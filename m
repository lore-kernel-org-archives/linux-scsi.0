From: Leon Woestenberg <leonw@mailcan.com>
Subject: Re: how to use scsi_remove_device
Date: Sat, 18 Mar 2006 00:25:26 +0100
Message-ID: <441B4566.8000803@mailcan.com>
References: <1142598225.25906.256865850@webmail.messagingengine.com> <441B1388.20704@s5r6.in-berlin.de> <441B1C7F.2090605@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:62881 "EHLO
	out4.smtp.messagingengine.com") by vger.kernel.org with ESMTP
	id S1751343AbWCQXZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Mar 2006 18:25:36 -0500
In-Reply-To: <441B1C7F.2090605@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>, Eric Moore <Eric.Moore@lsil.com>

Hello all,

Stefan Richter wrote:
> Hi all,
>
> the following drivers use [__]scsi_add_device/ scsi_remove_device:
>
> drivers/ieee1394/sbp2.c
> drivers/message/i2o/i2o_scsi.c
> drivers/message/fusion/mptsas.c
> drivers/scsi/aacraid/commsup.c
> drivers/scsi/ipr.c
>
> Sbp2 calls scsi_add_device + scsi_remove_device.
> I2o_scsi calls __scsi_add_device + scsi_remove_device + scsi_device_put.
> Ipr calls scsi_add_device + scsi_device_get + scsi_remove_device + 
> scsi_device_put.
>
> But aacraid and mptsas call scsi_add_device + scsi_remove_device + 
> scsi_device_put. AFAICS this is either one scsi_device_put too many or 
> one scsi_device_get too few.
>
> (I am looking at Linus' tree.)
I was just searching the linux-scsi mailing list and noticed this 
in-progress hotplug patch for the libata SATA framework, which in turn 
uses the SCSI layers.

In particular notice the lookup of the scsi_device before it 
scsi_remove_device(), then scsi_device_put().

In my particular case (Marvell's GPL'd SATA driver, not the libata one) 
*it seems* the device lookup is missing, although I have to do more work 
to verify this statement.

Regards,

Leon.

+void ata_scsi_hot_plug(struct ata_port *ap, unsigned int device)
+{
+	/* libata uses the 'id' or 'target' value */
+	scsi_add_device(ap->host, 0, device, 0);
+}
+

+void ata_scsi_hot_unplug(struct ata_port *ap, unsigned int device)
+{
+	/* libata uses the 'id' or 'target' value */
+	struct scsi_device *scd = scsi_device_lookup(ap->host, 0, device, 0);
+
+	/* Make sure that we set this here, in case we aren't called as a
+	 * result of sata_hot_unplug */
+	ap->device[device].class = ATA_DEV_NONE;
+
+	if (scd)  /* Set to cancel state to block further I/O */
+		scsi_device_set_state(scd, SDEV_CANCEL);
+
+	/* We might have a pending qc on I/O to a removed device. */
+	ata_check_kill_qc(ap, device);
+	
+	if (scd) {
+		scsi_remove_device(scd);
+		scsi_device_put(scd);
+	}
+}

