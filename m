From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 67091] scsi/be2iscsi/be_main.c:328: possible bad if expression
 ?
Date: Thu, 19 Dec 2013 01:16:21 -0600
Message-ID: <52B29D45.1030101@cs.wisc.edu>
References: <bug-67091-11613@https.bugzilla.kernel.org/> <bug-67091-11613-8nIo1tBSXu@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58308 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab3LSHQa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Dec 2013 02:16:30 -0500
In-Reply-To: <bug-67091-11613-8nIo1tBSXu@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@emulex.com>

On 12/18/2013 08:24 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=67091
> 
> Alan <alan@lxorguk.ukuu.org.uk> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |alan@lxorguk.ukuu.org.uk
>           Component|Other                       |Other
>            Assignee|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
>                    |sdl.org                     |ugs.osdl.org
>             Product|Drivers                     |SCSI Drivers
> 

Jay,

I thought we fixed that bug. I am not seeing a patch though. I think we
wanted to be checking against the sc passed in. Patch is compile tested
only.


diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..5642a9b 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -325,7 +325,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!abrt_task->sc || abrt_task->state == ISCSI_TASK_FREE)
 			continue;
 
-		if (abrt_task->sc->device->lun != abrt_task->sc->device->lun)
+		if (sc->device->lun != abrt_task->sc->device->lun)
 			continue;
 
 		/* Invalidate WRB Posted for this Task */


