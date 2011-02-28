From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH-FOR-38] target: Fix t_transport_aborted handling in
 LUN_RESET + active I/O shutdown
Date: Mon, 28 Feb 2011 20:37:39 +0100
Message-ID: <AANLkTimcRB3jC6WsKxAQz+TYMhG5aSLQwPkbEn9qYJ29@mail.gmail.com>
References: <1298595500-1558-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39960 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab1B1Tsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 14:48:51 -0500
Received: by vxi39 with SMTP id 39so3466938vxi.19
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2011 11:48:50 -0800 (PST)
In-Reply-To: <1298595500-1558-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>

On Fri, Feb 25, 2011 at 1:58 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This patch addresses two outstanding bugs related to T_TASK(cmd)->t_t=
ransport_aborted
> handling during TMR LUN_RESET and active I/O shutdown.
>
> This first involves adding two explict t_transport_aborted=3D1 assign=
ments in
> core_tmr_lun_reset() in order to signal the task has been aborted, an=
d
> updating transport_generic_wait_for_tasks() to skip sleeping when
> t_transport_aborted=3D1 has been set. =A0This fixes an issue where
> transport_generic_wait_for_tasks() would end up sleeping indefinately=
 when
> called from fabric module context while TMR LUN_RESET was happening w=
ith
> long outstanding backend struct se_task not yet being completed.
>
> The second adds a missing call to transport_remove_task_from_execute_=
queue()
> when task->task_execute_queue=3D1 is set in order to fix an OOPs when
> task->t_execute_list has not been dropped. =A0It also fixes the same =
case in
> transport_processing_shutdown() to prevent the issue from happening d=
uring
> active I/O struct se_device shutdown.

Hello Nicholas,

Are all I/O shutdown improvements present in the lio-4.1 branch
included in this patch ? I'm asking because with the lio-4.1 branch I
can't reproduce https://bugzilla.kernel.org/show_bug.cgi?id=3D29442. If
so, it seems like a good idea to me to refer to that bugzilla item in
the patch description. See also
https://github.com/bvanassche/srpt-lio/tree/srpt-lio-4.1 if you want
to have a look at the code I have been testing.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
