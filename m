From: Finn Thain <fthain@telegraphics.com.au>
Subject: RE: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Fri, 13 May 2016 17:43:35 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1605131459480.7564@nippy.intranet>
References: <1462668011.32105.7.camel@petros-ultrathin> <alpine.LNX.2.00.1605081235490.19865@nippy.intranet> <20160509080551.GH29510@mwanda> <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com> <1462829338.1873.4.camel@petroskoutoupis.com>
 <166e07c6f96724c0d1f972f2a65d0a65@mail.gmail.com> <1463017791.5827.4.camel@petros-ultrathin> <20160512062948.GG19274@mwanda> <410ee24683f9720077661b90b0472ce7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:60985 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbcEMGpN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2016 02:45:13 -0400
In-Reply-To: <410ee24683f9720077661b90b0472ce7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Petros Koutoupis <petros@petroskoutoupis.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org


On Thu, 12 May 2016, Sumit Saxena wrote:

> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> >
> > Also when I'm doing static analysis people always tell me that "that 
> > bug is impossible, trust me." and instead of trusting people I really 
> > wish they would just show me the relevant code that prevents it from 
> > happening.
> 
> Inside megasas_build_io_fusion() function, driver sets "cmd->scmd" 
> pointer(SCSI command pointer received from SCSI mid layer). Functions 
> called inside megasas_build_io_fusion()(which actually builds frame to 
> be sent to firmware) are setting Function type- 
> MPI2_FUNCTION_SCSI_IO_REQUEST (or) MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST. 
> So in case Function type set to any one these two, there must be valid 
> "cmd->scmd".

That doesn't show what prevents the bug. It merely shows that the bug does 
not always manifest.

For example, you might check whether anything prevents 
megasas_build_io_fusion() from returning before assigning cmd->scmd, like 
so:

2112 	if (sge_count > instance->max_num_sge) {
2113 		dev_err(&instance->pdev->dev, "Error. sge_count (0x%x) exceeds "
2114 		       "max (0x%x) allowed\n", sge_count,
2115 		       instance->max_num_sge);
2116 		return 1;
2117 	}

Another possibility: cmd->io_request->Function is valid yet cmd->scmd is 
NULL when seen from the interrupt handler if it intervenes between the two 
statements in megasas_return_cmd_fusion():

180 inline void megasas_return_cmd_fusion(struct megasas_instance *instance,
181 	struct megasas_cmd_fusion *cmd)
182 {
183 	cmd->scmd = NULL;
184 	memset(cmd->io_request, 0, sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
185 }

You might want to confirm that locking always prevents that.

OTOH, without an actual backtrace, I too might be reluctant to pursue this 
kind of speculation.

-- 
