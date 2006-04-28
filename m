From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 16:54:02 -0500
Message-ID: <1146261242.5251.99.camel@mulgrave.il.steeleye.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>
	 <44522672.5010607@us.ibm.com>
	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
	 <44525CBE.1030409@us.ibm.com>
	 <1146249006.5251.64.camel@mulgrave.il.steeleye.com>
	 <44526702.1010400@us.ibm.com>
	 <1146257803.5251.82.camel@mulgrave.il.steeleye.com>
	 <44528508.3060003@us.ibm.com>  <445289F5.6070608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50118 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751400AbWD1VyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 17:54:07 -0400
In-Reply-To: <445289F5.6070608@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: brking@us.ibm.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Fri, 2006-04-28 at 17:32 -0400, Jeff Garzik wrote:
> If both host controller and device support 16-byte CDB, it should not be 
> limited to 12 bytes.

Well, the limit should really only reflect what the controller supports.
The SCSI heuristics, or slave configure flags should take care of the
devices.

> libata is not "playing games", just exporting what the hardware supports 
> as best the API allows.  It needs to support 16-byte CDBs for the same 
> reason any SCSI LLDD supports 16-byte CDBs.

I think he means this piece of code in libata-core.c:ata_dev_configure()

	ap->host->max_cmd_len = 0;
	for (i = 0; i < ATA_MAX_DEVICES; i++)
		ap->host->max_cmd_len = max_t(unsigned int,
					      ap->host->max_cmd_len,
					      ap->device[i].cdb_len);

You're setting the max_cmd_len based on the largest one supported by the
device.  What happens if that's larger than the HBA can support?

> Remember ATAPI<->SCSI bridges exist, thus any SCSI disk can appear 
> attached to ATAPI.

Well, that's like attaching a 4TB SPI array to a qla1280 (which has a
firmware 12 byte command limit).  You don't do it unless you want a
horrible mess.

James


