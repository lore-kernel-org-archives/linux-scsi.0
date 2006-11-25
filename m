From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] libsas: Don't give scsi_cmnds to the EH if they
	never made it to the SAS LLDD or have already returned
Date: Sat, 25 Nov 2006 13:02:20 -0600
Message-ID: <1164481340.2804.17.camel@mulgrave.il.steeleye.com>
References: <20061117210737.17052.67041.stgit@localhost.localdomain>
	 <20061117210749.17052.56317.stgit@localhost.localdomain>
	 <4567E9A8.70209@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:25028 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S967113AbWKYTDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 14:03:24 -0500
In-Reply-To: <4567E9A8.70209@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>

On Fri, 2006-11-24 at 22:58 -0800, Darrick J. Wong wrote:
> On a system with many SAS targets, it appears possible that a scsi_cmnd
> can time out without ever making it to the SAS LLDD or at the same time
> that a completion is occurring.  In both of these cases, telling the
> LLDD to abort the sas_task makes no sense because the LLDD won't know
> about the sas_task; what we really want to do is to increase the timer.
> Note that this involves creating another sas_task bit to indicate
> whether or not the task has been sent to the LLDD; I could have
> implemented this by slightly redefining SAS_TASK_STATE_PENDING, but
> this way seems cleaner.
> 
> This second version amends the aic94xx portion to set the
> TASK_AT_INITIATOR flag for all sas_tasks that were passed to
> lldd_execute_task.

Actually, this patch causes my ATAPI device not to appear initially.  It
looks like the libata IDENTIFY is failing.  It seems to be a problem
with the initial reset the device needs to get the D2H FIS.  This is
what I see:

sas: sas_ata_phy_reset: Found ATAPI device.
ata1.00: ATAPI, max UDMA/66
aic94xx: escb_tasklet_complete: phy5: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 00
aic94xx: 08: 01 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x20 for phy5
ata1.00: qc timeout (cmd 0xa1)
sas: sas_ata_post_internal: Failure; reset phy!
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
sas: STUB sas_ata_scr_read
ata1.00: limiting speed to UDMA/44
sas: sas_ata_phy_reset: Found ATAPI device.
ata1.00: qc timeout (cmd 0xa1)
sas: sas_ata_post_internal: Failure; reset phy!
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
sas: STUB sas_ata_scr_read
sas: sas_ata_phy_reset: Found ATAPI device.


James


