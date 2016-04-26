From: Pengfei Wang <wpengfeinudt@gmail.com>
Subject: Fwd: Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/commctrl.c
Date: Tue, 26 Apr 2016 17:10:19 +0100
Message-ID: <CACxtibThUYjzoVoKn4kKCT1dG4H_+RoxiNFgO2bx=O=qdjc8-w@mail.gmail.com>
References: <CACxtibTF72YUeOnm2Rsx6odjRXybjbbGbx32-CqAu5u6ahndKg@mail.gmail.com>
	<1461681982.2348.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34788 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbcDZQKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2016 12:10:20 -0400
Received: by mail-ob0-f174.google.com with SMTP id bg3so9249583obb.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2016 09:10:19 -0700 (PDT)
In-Reply-To: <1461681982.2348.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,


A Double-Fetch happens when the kernel reads the same user data
multiple times, whilst the data is likely to be modified by a
concurrently running user thread under race condition between the
kernel reads, which results in data inconsistency for the kernel use.
Since neither the kernel nor the user is aware of the change of the
data under race condition, this data inconsistency might cause serious
consequences.


I call this Double-Fetch situation as a bug is because I think it
lacks a sanity checking after the second fetch of the same data, which
should be a guarantee for the data consistency for kernel use, and I
have seen this checking mechanism in some other driver files.
Moreover, I don=E2=80=99t think it is the user=E2=80=99s fault if the d=
ata is altered,
for the reason that the data might be altered by an intended malicious
process launched by an attacker or rewritten by some unintended user
behaviors that are not supposed to happen. As long as the data resides
in user space, there is a chance that it is modified under race
condition, even though the chance might be very small. Besides, it
should be the kernel=E2=80=99s duty to handle potential data inconsiste=
ncy in
Double-Fetch.


I=E2=80=99m not quite sure what consequence will actually be caused if =
this
Double-Fetch really happens, maybe not as serious as a kernel crash,
but I think it would actually result in something wrong in the driver
functionality, which should be eliminated now.



Thank you!

Kind regards
Pengfei



---------- Forwarded message ----------
=46rom: James Bottomley <James.Bottomley@hansenpartnership.com>
Date: 2016-04-26 15:46 GMT+01:00
Subject: Re: Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/commctr=
l.c
To: Pengfei Wang <wpengfeinudt@gmail.com>, linux-scsi@vger.kernel.org


On Tue, 2016-04-26 at 13:35 +0100, Pengfei Wang wrote:
> Hello,
>
> I found this Double-Fetch bug in
> Linux-4.5/drivers/scsi/aacraid/commctrl.c when I was examining the
> source code.
>
> In function ioctl_send_fib(), the driver fetches user space data by
> pointer arg via copy_from_user(), and this happens twice at line 81
> and line 116 respectively. The first fetched value (stored in kfib)
> is used to get the header and calculate the size at line 90 so as to
> copy the whole message later at line 116, which means the copy size
> of the whole message is based on the old value that came from the
> first fetch. Besides, the whole message copied in the  second fetch
> also contains the header.
>
> However, when the function processes the message after the second
> fetch at line 130, it uses kfib->header.Size that came from the
> second fetch, which might be different from the one came from the
> first fetch as well as calculated the size to copy the message from
> user space to driver.

I don't actually see where there's a bug in this.  If the user chooses
to alter data in-flight (quite hard to do because one thread of
execution is already tied up in the ioctl) then the consequences are
their own fault.

> If the kfib->header.Size is modified by a user thread under race
> condition between the fetch operations, for example changing to a
> very large value, this will lead to over-boundary access or other
> serious consequences in function aac_fib_send().

Our only real concern would be could an unprivileged user crash the
kernel this way and the user must have CAP_SYS_RAWIO anyway (which is
quite a high privilege capability) plus the only problem with
shortening the data would be EFAULT.

James
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
