From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Mon, 13 Oct 2008 19:55:04 -0700
Message-ID: <20081014025504.GA10518@akamai.com>
References: <20081009005126.GA7954@akamai.com> <660360F4F2570145BD872F298951B17A5C94F055@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay03.akamai.com ([72.247.150.167]:47759 "EHLO
	prod-mail-xrelay03.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404AbYJNDFD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 23:05:03 -0400
Content-Disposition: inline
In-Reply-To: <660360F4F2570145BD872F298951B17A5C94F055@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

* Moore, Eric (Eric.Moore@lsi.com) wrote:
> Abhijit - You're patch would allow page 0x19 to STP devices, which I doubt is supported either.     I think you should be doing the following instead:
> 
> +       if (rphy->identify.device_type == SAS_END_DEVICE &&
> +          (rphy->identify.target_port_protocols & SAS_PROTOCOL_SSP))
> +               sas_read_port_mode_page(sdev);

Yes, thanks for pointing that out. I think it needs to be OR-ed with
SAS_PROTOCOL_SATA.

Here is the updated patch.

Signed-off-by: Abhijit Paithankar <apaitha@akamai.com>

Index: linux-2.6.27/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.27.orig/drivers/message/fusion/mptsas.c	2008-10-13 17:31:57.000000000 -0700
+++ linux-2.6.27/drivers/message/fusion/mptsas.c	2008-10-13 19:51:57.000000000 -0700
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
+	   !(rphy->identify.target_port_protocols & (SAS_PROTOCOL_SATA | SAS_PROTOCOL_SSP)))
+		sas_read_port_mode_page(sdev);
 
  out:
 	return mptscsih_slave_configure(sdev);
