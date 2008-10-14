From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 11:42:26 -0700
Message-ID: <20081014184226.GB20297@akamai.com>
References: <20081014025504.GA10518@akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:48993 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYJNSm1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 14:42:27 -0400
Content-Disposition: inline
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

* Prakash, Sathya (Sathya.Prakash@lsi.com) wrote:
> This patch will avoid sending the  port mode page request for SSP device also so NACK. Try to use the patch provided by Eric, which modifies the driver to send the port mode page request only for SSP device.

Yeah. That was exactly the wrong thing to do.

Here is the one with Eric's suggestion.

Signed-off-by: Abhijit Paithankar <apaithan@akamai.com>

Index: linux-2.6.27/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.27.orig/drivers/message/fusion/mptsas.c	2008-10-13 17:31:57.000000000 -0700
+++ linux-2.6.27/drivers/message/fusion/mptsas.c	2008-10-14 11:36:36.000000000 -0700
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
+	   (rphy->identify.target_port_protocols & SAS_PROTOCOL_SSP))
+		sas_read_port_mode_page(sdev);
 
  out:
 	return mptscsih_slave_configure(sdev);
