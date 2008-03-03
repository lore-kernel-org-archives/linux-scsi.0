From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: scsi: fix target reset handling
Date: Mon, 3 Mar 2008 10:06:11 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D70D55122@NAMAIL4.ad.lsil.com>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61956 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYCCRGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 12:06:55 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk

On Friday, February 29, 2008 5:25 PM,  Mike Christie wrote:
> This patchset fixes the problem where scsi-ml will call the 
> device reset
> handler for each logical unit, but some drivers are sending a target
> reset. Because we do not need to send a target reset multiple times,
> this patchset creates a new target reset callout which of course is
> called once per target instead of once per lu. It also cleans up
> the all the commands sent to the target when SUCCESS is returned.
> 
> qla4xxx, qla2xxx and lpfc were test with a hacked up sg_reset. I also
> sent lots of commands to the target and decreased the cmd timeout to
> 1 second so the scsi would run (turned off the eh abort callout too).
> 
> The arm scsi, mpt fusion, sym53c8xx_2, and a100u2w, and qla1280
> drivers were only compile tested, but looked like the only needed
> a rename of the scsi eh handler.
> 
> The zfcp driver is also only compile tested. It was doing a lun
> reset and possibly target reset, so I split that up to use
> the device and target reset handlers. scsi-ml will escalate from
> the device to the target reset for the driver.
> 
> 

The fusion firmware supports Logical Unit Reset, so why not fix
mptscsih_dev_reset so its passing
MPI_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, and lun number to
mptscsih_TMHandler, and create the new function mptscsih_target_reset as
you've done?

Eric
