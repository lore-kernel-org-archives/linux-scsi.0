From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 01/04] scsi: make scsi_send_eh_cmnd use
	its own timer instead of scmd->eh_timeout
Date: Sun, 24 Apr 2005 18:22:22 -0400
Message-ID: <1114381342.4786.17.camel@mulgrave>
References: <20050419143100.E231523D@htj.dyndns.org>
	 <20050419143100.0F9A8C3B@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:55019 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262479AbVDXX03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 19:26:29 -0400
In-Reply-To: <20050419143100.0F9A8C3B@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-04-19 at 23:31 +0900, Tejun Heo wrote:
> 	scmd->eh_timeout is used to resolve the race between command
> 	completion and timeout.  However, during error handling,
> 	scsi_send_eh_cmnd uses scmd->eh_timeout.  This creates a race
> 	condition between eh and normal completion for a request which
> 	has timed out and in the process of error handling.  If the
> 	request completes while scmd->eh_timeout is being used by eh,
> 	eh timeout is lost and the command will be handled by both eh
> 	and completion path.  This patch fixes the race by making
> 	scsi_send_eh_cmnd() use its own timer.
> 
> 	This patch adds shost->eh_timeout field.  The name of the
> 	field equals scmd->eh_timeout which is used for normal command
> 	timeout.  As this can be confusing, renaming scmd->eh_timeout
> 	to something like scmd->cmd_timeout would be good.
> 
> 	Reworked such that timeout race window is kept at minimal
> 	level as pointed out by James Bottomley.

This looks fine in principle.  However, three comments

1. If you're doing this, there's no further use for eh_timeout, so
remove it (and preferably fix gdth_proc.c; however, it's better to break
the compile of that driver than have it rely on a now defunct field).
2. Use of eh_action is private to scsi_error.c, so you don't need to add
a new field to the host, just make eh_action a pointer to a private
eh_action structure which contains the timer and the semaphore.
3. To close a really tiny window where the running timer could race with
the del_timer, it should probably be del_timer_sync().  The practical
effect of this is nil, but it would be correct programming.

James


