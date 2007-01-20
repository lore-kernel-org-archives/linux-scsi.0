From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Sat, 20 Jan 2007 12:18:42 +0900
Message-ID: <45B18A12.5060605@gmail.com>
References: <20070119170122.GS10987@htj.dyndns.org> <45B15575.5090806@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:49591 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889AbXATDSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jan 2007 22:18:51 -0500
Received: by nz-out-0506.google.com with SMTP id s1so541385nze
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2007 19:18:50 -0800 (PST)
In-Reply-To: <45B15575.5090806@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello, Douglas.

Douglas Gilbert wrote:
>> This patch implements sd attribute stop_on_shutdown.  If set to 1, sd
>> stops the drive on non-restarting shutdown.  stop_on_shutdown is
>> initialized from sd parameter stop_on_shutdown_default which defaults
>> to 0.  So, this patch does not change the default behavior.
> 
> Tejun,
> The IMMED bit in the START STOP UNIT cdb is not being set
> when your patch stops a drive:
> 
> Advantage:
>   - the power won't be dropped immediately after sending
>     the command to the drive (assuming the drive gets
>     its power from the same power supply that shutdown
>     turns off)
> 
> Disadvantage:
>   - it will delay shutdown proportional to the number of
>     drives with the stop_on_shutdown attribute set. Say
>     5 seconds per disk.

We pretty much need the IMMED bit to be cleared.  The goal of this patch
is to allow drives unload their heads before power is cut off and with
IMMED set, we really don't know when is safe to power off the machine.

> Disadvantage (with or without IMMED bit set):
>   - if another initiator (e.g. on another machine) was
>     using a different partition on that disk, then it might
>     get upset (especially if it was running Linux).
>     [I'm not sure why you say this patch is necessary
>      in this case.]

Yeap, I agree with you.  I don't think the behavior introduced by this
patch is necessary in that case (did I say otherwise?) and that's
precisely why the default behavior hasn't been changed.  This is just
for small little machines running SATA and possibly USB disks (dunno
their SAT implement START_STOP tho) which are currently having problems
shutting down its disks on sleep to disk and sometimes poweroff.

> BTW SCSI disks typically have a lower start-stop lifetime
> rating than ATA disks. This reflects that SCSI disks are
> designed to be on 168 hours per week.

Yeap, not as useful as for PC stuff but I think having and enabling this
still would help in single initiator cases.  As you just said, they are
rated for less load-unload lifetime to begin with.

Thanks.

-- 
tejun
