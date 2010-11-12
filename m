From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Fri, 12 Nov 2010 21:42:27 +0800
Message-ID: <AANLkTim5wr_ZdV0=XR=1a=P7t=ErE=S8nxi4CSc8r53V@mail.gmail.com>
References: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
	<4CD98FC6.9000108@cisco.com>
	<AANLkTimN+nhY+SDApbcpJ41z9jPTu6jj0RmYjNYNyo5+@mail.gmail.com>
	<4CDC3A39.6020801@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38572 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0KLNm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2010 08:42:29 -0500
Received: by eye27 with SMTP id 27so1811456eye.19
        for <linux-scsi@vger.kernel.org>; Fri, 12 Nov 2010 05:42:28 -0800 (PST)
In-Reply-To: <4CDC3A39.6020801@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 12, 2010 at 2:47 AM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
>
>
> On 11/11/10 5:45 AM, Hillf Danton wrote:
>> On Wed, Nov 10, 2010 at 2:15 AM, Joe Eykholt <jeykholt@cisco.com> wr=
ote:
>>> On 11/9/10 6:01 AM, Hillf Danton wrote:
>>>> Ring buffers are setup for exchanging data between K and U spaces,=
 but
>>>> they could not survive multiple open operations.
>>>>
>>>> The registered misc interface is monitored and prevented from mult=
iple
>>>> opens for fixing the vulnerability.
>>>>
>>>> A typo, -BUSY, is also cleaned up.
>>>>
>>>> btw, the ring buffers could be setup in a per file manner?
>>>>
>>>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>>>> ---
>>>>
>>>> --- a/drivers/scsi/scsi_tgt_if.c =C2=A0 =C2=A0 =C2=A02010-09-13 07=
:07:38.000000000 +0800
>>>> +++ b/drivers/scsi/scsi_tgt_if.c =C2=A0 =C2=A0 =C2=A02010-11-09 21=
:42:48.000000000 +0800
>>>> @@ -85,7 +85,7 @@ static int tgt_uspace_send_event(u32 typ
>>>> =C2=A0 =C2=A0 =C2=A0 if (!ev->hdr.status)
>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tgt_ring_idx_inc(=
ring);
>>>> =C2=A0 =C2=A0 =C2=A0 else
>>>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -BUSY;
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EBUSY;
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ring->tr_lock, flags)=
;
>>>>
>>>> @@ -319,20 +319,33 @@ static int tgt_mmap(struct file *filp, s
>>>> =C2=A0 =C2=A0 =C2=A0 return err;
>>>> =C2=A0}
>>>>
>>>> +static unsigned long tgt_open_cnt =3D 0;
>>>> +
>>>> =C2=A0static int tgt_open(struct inode *inode, struct file *file)
>>>> =C2=A0{
>>>> + =C2=A0 =C2=A0 if (tgt_open_cnt)
>>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EBUSY;
>>>> + =C2=A0 =C2=A0 tgt_open_cnt++;
>>>
>>> Since there's no locking, there's still a tiny hole where
>>> simultaneous opens could succeed. =C2=A0Consider using an atomic.
>>> Good find and good fix otherwise.
>>>
>> Would you please, Joe, show the atomic version?
>> thanks//Hillf
>
> I take it back. =C2=A0There's no good atomic version.
> The best I came up with was:
> In open:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (atomic_inc_return(&tgt_open_cnt) !=3D =
1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EBUSY;
>
> Then in release (since its the last close):
> =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_set(&tgt_open_cnt, 0);
>
> There's still a hole that this might overflow, and I don't see
> the best way to fix that without test-and-set or compare-and-swap.
> We can't just decrement it since the last close will clear it.

Great operation, thanks.
A good lesson already offered by Wilcox, you see Joe, clearing only
necessary when the final closing.

>
> So the best thing would be to use your
> version but protect it with the tx_ring.tr_lock.
> I would rename tgt_open_cnt to just tgt_busy,
> and make it a u8 since it will be 1 or 0.

But u8 is not native word, and the spin_lock_irq is enough, I think. //=
Hillf

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int error =3D 0;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq(&tx_ring.tr_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tgt_busy)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0error =3D -EBU=
SY;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tgt_busy =3D 1=
;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tx_ring.tr_idx=
 =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rx_ring.tr_idx=
 =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irq(&tx_ring.tr_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;
>
> Then in release:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irq(&tx_ring.tr_lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0tgt_busy =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irq(&tx_ring.tr_lock);
>
>>>> +
>>>> =C2=A0 =C2=A0 =C2=A0 tx_ring.tr_idx =3D rx_ring.tr_idx =3D 0;
>>>>
>>>> =C2=A0 =C2=A0 =C2=A0 cycle_kernel_lock();
>>>> =C2=A0 =C2=A0 =C2=A0 return 0;
>>>> =C2=A0}
>>>>
>>>> +static int tgt_release(struct inode *inode, struct file *file)
>>>> +{
>>>> + =C2=A0 =C2=A0 tgt_open_cnt--;
>>>> + =C2=A0 =C2=A0 return 0;
>>>> +}
>>>> +
>>>> =C2=A0static const struct file_operations tgt_fops =3D {
>>>> =C2=A0 =C2=A0 =C2=A0 .owner =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =
THIS_MODULE,
>>>> =C2=A0 =C2=A0 =C2=A0 .open =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =
tgt_open,
>>>> =C2=A0 =C2=A0 =C2=A0 .poll =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =
tgt_poll,
>>>> =C2=A0 =C2=A0 =C2=A0 .write =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =
tgt_write,
>>>> =C2=A0 =C2=A0 =C2=A0 .mmap =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =
tgt_mmap,
>>>> + =C2=A0 =C2=A0 .release =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D tgt_releas=
e,
>>>> =C2=A0};
>>>>
>>>> =C2=A0static struct miscdevice tgt_miscdev =3D {
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-sc=
si" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
