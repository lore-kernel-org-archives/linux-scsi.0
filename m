From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-FOR-38] target: Fix t_transport_aborted handling in
	LUN_RESET + active I/O shutdown
Date: Mon, 28 Feb 2011 15:28:15 -0800
Message-ID: <1298935695.5401.235.camel@haakon2.linux-iscsi.org>
References: <1298595500-1558-1-git-send-email-nab@linux-iscsi.org>
	 <AANLkTimcRB3jC6WsKxAQz+TYMhG5aSLQwPkbEn9qYJ29@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60756 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1B1XfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 18:35:00 -0500
In-Reply-To: <AANLkTimcRB3jC6WsKxAQz+TYMhG5aSLQwPkbEn9qYJ29@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-iscsi-target-dev@googlegroups.com, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>

On Mon, 2011-02-28 at 20:37 +0100, Bart Van Assche wrote:
> On Fri, Feb 25, 2011 at 1:58 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This patch addresses two outstanding bugs related to T_TASK(cmd)->t_transport_aborted
> > handling during TMR LUN_RESET and active I/O shutdown.
> >
> > This first involves adding two explict t_transport_aborted=1 assignments in
> > core_tmr_lun_reset() in order to signal the task has been aborted, and
> > updating transport_generic_wait_for_tasks() to skip sleeping when
> > t_transport_aborted=1 has been set.  This fixes an issue where
> > transport_generic_wait_for_tasks() would end up sleeping indefinately when
> > called from fabric module context while TMR LUN_RESET was happening with
> > long outstanding backend struct se_task not yet being completed.
> >
> > The second adds a missing call to transport_remove_task_from_execute_queue()
> > when task->task_execute_queue=1 is set in order to fix an OOPs when
> > task->t_execute_list has not been dropped.  It also fixes the same case in
> > transport_processing_shutdown() to prevent the issue from happening during
> > active I/O struct se_device shutdown.
> 
> Hello Nicholas,
> 
> Are all I/O shutdown improvements present in the lio-4.1 branch
> included in this patch ?

Correct, the TCM specific pieces for this between v4.1.0-rc1 and
v4.0.0-rc7 are in sync in lio-core-2.6.git upstream at this point, and
this patch should do the same for mainline .38.

> I'm asking because with the lio-4.1 branch I
> can't reproduce https://bugzilla.kernel.org/show_bug.cgi?id=29442. If
> so, it seems like a good idea to me to refer to that bugzilla item in
> the patch description.

Yep, I will update this with the lio-core-2.6.git commit reference and
linux-scsi URL shortly.

>  See also
> https://github.com/bvanassche/srpt-lio/tree/srpt-lio-4.1 if you want
> to have a look at the code I have been testing.
> 

My apologies here as I have not been able to personally test your code
yet, but this is still on my list of TODO items for the week.  I am
happy to pull directly from srpt-lio-4.1 into lio-core-2.6.git to track
your progress, and thank you for rebasing and testing against the
lastest TCM/LIO v4.1 development code.

--nab

