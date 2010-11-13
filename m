From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Sat, 13 Nov 2010 18:45:17 +0800
Message-ID: <AANLkTik6WjKpd35noEYpGDq-8RWPz+9reiqmBiRXVEeB@mail.gmail.com>
References: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
	<4CD98FC6.9000108@cisco.com>
	<AANLkTimN+nhY+SDApbcpJ41z9jPTu6jj0RmYjNYNyo5+@mail.gmail.com>
	<4CDC3A39.6020801@cisco.com>
	<AANLkTim5wr_ZdV0=XR=1a=P7t=ErE=S8nxi4CSc8r53V@mail.gmail.com>
	<4CDD794D.7080901@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63931 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0KMKpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Nov 2010 05:45:20 -0500
Received: by wwb28 with SMTP id 28so64wwb.1
        for <linux-scsi@vger.kernel.org>; Sat, 13 Nov 2010 02:45:18 -0800 (PST)
In-Reply-To: <4CDD794D.7080901@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Nov 13, 2010 at 1:28 AM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
>
>
> On 11/12/10 5:42 AM, Hillf Danton wrote:
>> On Fri, Nov 12, 2010 at 2:47 AM, Joe Eykholt <jeykholt@cisco.com> wr=
ote:
>>>
>>>
>>> On 11/11/10 5:45 AM, Hillf Danton wrote:
>>>> On Wed, Nov 10, 2010 at 2:15 AM, Joe Eykholt <jeykholt@cisco.com> =
wrote:
>>>>> On 11/9/10 6:01 AM, Hillf Danton wrote:
>>>>>> Ring buffers are setup for exchanging data between K and U space=
s, but
>>>>>> they could not survive multiple open operations.
>>>>>>
>>>>>> The registered misc interface is monitored and prevented from mu=
ltiple
>>>>>> opens for fixing the vulnerability.
>>>>>>
>>>>>> A typo, -BUSY, is also cleaned up.
>>>>>>
>>>>>> btw, the ring buffers could be setup in a per file manner?
>>>>>>
>>>>>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>>>>> ---
>>>>>>
>>>>>> --- a/drivers/scsi/scsi_tgt_if.c =C2=A0 =C2=A0 =C2=A02010-09-13 =
07:07:38.000000000 +0800
>>>>>> +++ b/drivers/scsi/scsi_tgt_if.c =C2=A0 =C2=A0 =C2=A02010-11-09 =
21:42:48.000000000 +0800
>>>>>> @@ -85,7 +85,7 @@ static int tgt_uspace_send_event(u32 typ
>>>>>> =C2=A0 =C2=A0 =C2=A0 if (!ev->hdr.status)
>>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tgt_ring_idx_in=
c(ring);
>>>>>> =C2=A0 =C2=A0 =C2=A0 else
>>>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -BUSY;
>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EBUSY;
>>>>>>
>>>>>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ring->tr_lock, flag=
s);
>>>>>>
>>>>>> @@ -319,20 +319,33 @@ static int tgt_mmap(struct file *filp, s
>>>>>> =C2=A0 =C2=A0 =C2=A0 return err;
>>>>>> =C2=A0}
>>>>>>
>>>>>> +static unsigned long tgt_open_cnt =3D 0;
>>>>>> +
>>>>>> =C2=A0static int tgt_open(struct inode *inode, struct file *file=
)
>>>>>> =C2=A0{
>>>>>> + =C2=A0 =C2=A0 if (tgt_open_cnt)
>>>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EBUSY;
>>>>>> + =C2=A0 =C2=A0 tgt_open_cnt++;
>>>>>
>>>>> Since there's no locking, there's still a tiny hole where
>>>>> simultaneous opens could succeed. =C2=A0Consider using an atomic.
>>>>> Good find and good fix otherwise.
>>>>>
>>>> Would you please, Joe, show the atomic version?
>>>> thanks//Hillf
>>>
>>> I take it back. =C2=A0There's no good atomic version.
>>> The best I came up with was:
>>> In open:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_inc_return(&tgt_open_cnt) !=3D=
 1)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EBUS=
Y;
>>>
>>> Then in release (since its the last close):
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&tgt_open_cnt, 0);
>>>
>>> There's still a hole that this might overflow, and I don't see
>>> the best way to fix that without test-and-set or compare-and-swap.
>>> We can't just decrement it since the last close will clear it.
>>
>> Great operation, thanks.
>> A good lesson already offered by Wilcox, you see Joe, clearing only
>> necessary when the final closing.
>
> Yes, I think I took that into account.
>
>>> So the best thing would be to use your
>>> version but protect it with the tx_ring.tr_lock.
>>> I would rename tgt_open_cnt to just tgt_busy,
>>> and make it a u8 since it will be 1 or 0.
>>
>> But u8 is not native word, and the spin_lock_irq is enough, I think.=
 //Hillf
>
> I don't understand what you mean by native word. =C2=A0u8 is an unsig=
ned char which
I mean unsigned long is more friendly to the 32/64-bit registers of
hardware of this century. And thank you for sharing so much.
If you do not mind, I will prepare new patch based upon busy flag and
spin_lock_irq, and you review it again.

good weekend
Hillf

> is just as natural a data type as an int,
>
> Setting, clearing, and testing a char is just as efficient as an int
> on almost all architectures I can think of, although an loading an
> unsigned char requires masking on one architecture at least,
> so unsigned char can be worse than signed char, but not for compariso=
n
> to zero and storing, which is what we're talking about here.
> That said, it's not a big deal either way. =C2=A0It's only 3 bytes, a=
nd
> this isn't a commonly-used module. =C2=A0Silly of me, really.
>
> But, you still need the busy flag even with the lock.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Cheers,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Joe
>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0int error =3D 0;
>>>
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq(&tx_ring.tr_lock);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tgt_busy)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D -E=
BUSY;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tgt_busy =3D=
 1;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tx_ring.tr_i=
dx =3D 0;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rx_ring.tr_i=
dx =3D 0;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irq(&tx_ring.tr_lock);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;
>>>
>>> Then in release:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq(&tx_ring.tr_lock);
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0tgt_busy =3D 0;
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irq(&tx_ring.tr_lock);
>>>
>>>>>> +
>>>>>> =C2=A0 =C2=A0 =C2=A0 tx_ring.tr_idx =3D rx_ring.tr_idx =3D 0;
>>>>>>
>>>>>> =C2=A0 =C2=A0 =C2=A0 cycle_kernel_lock();
>>>>>> =C2=A0 =C2=A0 =C2=A0 return 0;
>>>>>> =C2=A0}
>>>>>>
>>>>>> +static int tgt_release(struct inode *inode, struct file *file)
>>>>>> +{
>>>>>> + =C2=A0 =C2=A0 tgt_open_cnt--;
>>>>>> + =C2=A0 =C2=A0 return 0;
>>>>>> +}
>>>>>> +
>>>>>> =C2=A0static const struct file_operations tgt_fops =3D {
>>>>>> =C2=A0 =C2=A0 =C2=A0 .owner =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 THIS_MODULE,
>>>>>> =C2=A0 =C2=A0 =C2=A0 .open =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 tgt_open,
>>>>>> =C2=A0 =C2=A0 =C2=A0 .poll =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 tgt_poll,
>>>>>> =C2=A0 =C2=A0 =C2=A0 .write =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=
 tgt_write,
>>>>>> =C2=A0 =C2=A0 =C2=A0 .mmap =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 tgt_mmap,
>>>>>> + =C2=A0 =C2=A0 .release =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D tgt_rele=
ase,
>>>>>> =C2=A0};
>>>>>>
>>>>>> =C2=A0static struct miscdevice tgt_miscdev =3D {
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
scsi" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-in=
fo.html
>>>>>
>>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
