From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/commctrl.c
Date: Tue, 26 Apr 2016 07:46:22 -0700
Message-ID: <1461681982.2348.4.camel@HansenPartnership.com>
References: <CACxtibTF72YUeOnm2Rsx6odjRXybjbbGbx32-CqAu5u6ahndKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41646 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbcDZOq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 10:46:26 -0400
In-Reply-To: <CACxtibTF72YUeOnm2Rsx6odjRXybjbbGbx32-CqAu5u6ahndKg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
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


