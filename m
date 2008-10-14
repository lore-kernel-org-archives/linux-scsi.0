From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Mon, 13 Oct 2008 17:40:23 -0700
Message-ID: <20081014004023.GB25794@akamai.com>
References: <20081009005126.GA7954@akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531F8DA6506F@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:56844 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYJNAk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 20:40:26 -0400
Content-Disposition: inline
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA6506F@hkgmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

Hi Sathya,

* Prakash, Sathya (Sathya.Prakash@lsi.com) wrote:
> I found the reason for the non zero err_cnt for SATA drives attached to mptsas.
> It is due to the failure in sending mode sense request for page 0x19 from mptsas driver for SATA drives (which is not supported by MPTSAS controller).
> 
> In the slave_configure function of mptsas driver, the transport layer function sas_read_port_mode_page is called for all the devices attached with the MPTSAS controller. Since it is that particular mode page is not supported for SATA drives, Check condition with Skey=Invalid request and ASC=Invalid field in CDB is returned. Hence the error count is incremented by the scsi_done.
> 
> If it needs to be fixed, then we need to provide a patch in mptsas driver so that it will not call sas_read_port_mode_page for SATA devices.

Thanks for your efforts!

I patched the kernel with the following code and it is still showing a
non-zero ioerr_cnt.

Either my patch is wrong or this was just one of the issues.

Thanks!
Abhijit

Signed-off-by: Abhijit Paithankar <apaithan@akamai.com>

Index: linux-2.6.27/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.27.orig/drivers/message/fusion/mptsas.c	2008-10-13 17:31:57.000000000 -0700
+++ linux-2.6.27/drivers/message/fusion/mptsas.c	2008-10-13 17:33:25.000000000 -0700
@@ -839,11 +839,15 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io
 static int
 mptsas_slave_configure(struct scsi_device *sdev)
 {
+	struct sas_rphy *rphy;
 
 	if (sdev->channel == MPTSAS_RAID_CHANNEL)
 		goto out;
 
-	sas_read_port_mode_page(sdev);
+	rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
+	if (rphy->identify.device_type == SAS_END_DEVICE &&
+	   !(rphy->identify.target_port_protocols & SAS_PROTOCOL_SATA))
+		sas_read_port_mode_page(sdev);
 
  out:
 	return mptscsih_slave_configure(sdev);
