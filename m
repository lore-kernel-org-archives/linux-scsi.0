From: Alexandre Rossi <alexandre.rossi@gmail.com>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Tue, 23 Feb 2016 00:15:53 +0100
Message-ID: <CAM79t8ErGXsDb+8Vsn77gKOe7JPJJLNpjOEzkZktHEJvOXoZWQ@mail.gmail.com>
References: <CAM79t8HzYT+s0BrqzZ0-Cv7khzn6CvpE5bfnJ6H9xYCx4RkS8g@mail.gmail.com>
	<Pine.LNX.4.44L0.1602181121010.1280-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34885 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248AbcBVXPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 18:15:54 -0500
Received: by mail-io0-f181.google.com with SMTP id g203so194873205iof.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 15:15:54 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.1602181121010.1280-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Menzel <paul.menzel@giantmonkey.de>, Erich Schubert <erich@debian.org>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org

Hello,

>> > As this is Linux 4.3 and not 4.4, I guess this is a different prob=
lem
>> > though. Alexandre, where you able to capture the stack trace? I=E2=
=80=99d submit
>> > a new bug report with this.
>>
>> Here is a photo. Please ping me if you need to test some debugging p=
atches.
>
> It looks like the problem occurs in blk_post_runtime_resume().  Since
> there have been recent changes to this routine, it's hard to tell
> whether you're using the most up-to-date code.
>
> In particular, the first few lines of blk_post_runtime_resume() in
> block/blk-core.c should look like this:
>
> void blk_post_runtime_resume(struct request_queue *q, int err)
> {
>         if (!q->dev)
>                 return;
>
> The test was introduced by commit 4fd41a8552af ("SCSI: Fix NULL point=
er
> dereference in runtime PM"), which was added to the mainline kernel
> between 4.3 and 4.4.  I don't know what the commit ID would be for a
> .stable kernel.

Okay now I've tried with 4.4. The oops does not occur. So this is
fixed for me in 4.4.

If there is interest in backporting to 4.3, 13b438914341 ("SCSI: fix
crashes in sd and sr runtime PM") is not enough to backport. Something
in 4.4, most probably 4fd41a8552af ("SCSI: Fix NULL pointer
dereference in runtime PM") is also needed.

Thanks a lot,

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
