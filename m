From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] fix vulnerability in file operations of scsi target interface
Date: Thu, 11 Nov 2010 21:45:50 +0800
Message-ID: <AANLkTimN+nhY+SDApbcpJ41z9jPTu6jj0RmYjNYNyo5+@mail.gmail.com>
References: <AANLkTin+Epf5WuD9sV=kNNgVXo5No4euF=6VoSOkFK12@mail.gmail.com>
	<4CD98FC6.9000108@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62219 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab0KKNpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 08:45:52 -0500
Received: by ewy7 with SMTP id 7so1069282ewy.19
        for <linux-scsi@vger.kernel.org>; Thu, 11 Nov 2010 05:45:51 -0800 (PST)
In-Reply-To: <4CD98FC6.9000108@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2010 at 2:15 AM, Joe Eykholt <jeykholt@cisco.com> wrote=
:
> On 11/9/10 6:01 AM, Hillf Danton wrote:
>> Ring buffers are setup for exchanging data between K and U spaces, b=
ut
>> they could not survive multiple open operations.
>>
>> The registered misc interface is monitored and prevented from multip=
le
>> opens for fixing the vulnerability.
>>
>> A typo, -BUSY, is also cleaned up.
>>
>> btw, the ring buffers could be setup in a per file manner?
>>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/drivers/scsi/scsi_tgt_if.c =C2=A0 =C2=A0 =C2=A02010-09-13 07:0=
7:38.000000000 +0800
>> +++ b/drivers/scsi/scsi_tgt_if.c =C2=A0 =C2=A0 =C2=A02010-11-09 21:4=
2:48.000000000 +0800
>> @@ -85,7 +85,7 @@ static int tgt_uspace_send_event(u32 typ
>> =C2=A0 =C2=A0 =C2=A0 if (!ev->hdr.status)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tgt_ring_idx_inc(ri=
ng);
>> =C2=A0 =C2=A0 =C2=A0 else
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -BUSY;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D -EBUSY;
>>
>> =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&ring->tr_lock, flags);
>>
>> @@ -319,20 +319,33 @@ static int tgt_mmap(struct file *filp, s
>> =C2=A0 =C2=A0 =C2=A0 return err;
>> =C2=A0}
>>
>> +static unsigned long tgt_open_cnt =3D 0;
>> +
>> =C2=A0static int tgt_open(struct inode *inode, struct file *file)
>> =C2=A0{
>> + =C2=A0 =C2=A0 if (tgt_open_cnt)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -EBUSY;
>> + =C2=A0 =C2=A0 tgt_open_cnt++;
>
> Since there's no locking, there's still a tiny hole where
> simultaneous opens could succeed. =C2=A0Consider using an atomic.
> Good find and good fix otherwise.
>
Would you please, Joe, show the atomic version?
thanks//Hillf

>> +
>> =C2=A0 =C2=A0 =C2=A0 tx_ring.tr_idx =3D rx_ring.tr_idx =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 cycle_kernel_lock();
>> =C2=A0 =C2=A0 =C2=A0 return 0;
>> =C2=A0}
>>
>> +static int tgt_release(struct inode *inode, struct file *file)
>> +{
>> + =C2=A0 =C2=A0 tgt_open_cnt--;
>> + =C2=A0 =C2=A0 return 0;
>> +}
>> +
>> =C2=A0static const struct file_operations tgt_fops =3D {
>> =C2=A0 =C2=A0 =C2=A0 .owner =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D TH=
IS_MODULE,
>> =C2=A0 =C2=A0 =C2=A0 .open =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D tg=
t_open,
>> =C2=A0 =C2=A0 =C2=A0 .poll =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D tg=
t_poll,
>> =C2=A0 =C2=A0 =C2=A0 .write =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D tg=
t_write,
>> =C2=A0 =C2=A0 =C2=A0 .mmap =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D tg=
t_mmap,
>> + =C2=A0 =C2=A0 .release =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D tgt_release,
>> =C2=A0};
>>
>> =C2=A0static struct miscdevice tgt_miscdev =3D {
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
