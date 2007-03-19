From: Adrian Bunk <bunk@stusta.de>
Subject: drivers/message/fusion/mptscsih.c: inconsequent NULL checking
Date: Mon, 19 Mar 2007 10:22:18 +0100
Message-ID: <20070319092218.GH752@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34817 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753002AbXCSJWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 05:22:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in 
drivers/message/fusion/mptscsih.c:

<--  snip  -->

...
int
mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
{
...
        if (vdev
            && (vdev->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
            && (SCpnt->device->tagged_supported)) { 
                scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
        } else {
                scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED; 
        }
 
        /* Use the above information to set up the message frame
         */
        pScsiReq->TargetID = (u8) vdev->vtarget->id;
...

<--  snip  -->

vdev is first checked but later dereferenced unconditionally.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

