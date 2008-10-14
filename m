From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 14:39:32 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com>
References: <20081014025504.GA10518@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40397 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYJNGjt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 02:39:49 -0400
In-Reply-To: <20081014025504.GA10518@akamai.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijit Paithankar <apaithan@akamai.com>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch will avoid sending the  port mode page request for SSP device also so NACK. Try to use the patch provided by Eric, which modifies the driver to send the port mode page request only for SSP device.
Thanks
Sathya

-----Original Message-----
From: Abhijit Paithankar [mailto:apaithan@akamai.com]
Sent: Tuesday, October 14, 2008 8:25 AM
To: Moore, Eric
Cc: Prakash, Sathya; Douglas Gilbert; linux-scsi@vger.kernel.org
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up

* Moore, Eric (Eric.Moore@lsi.com) wrote:
> Abhijit - You're patch would allow page 0x19 to STP devices, which I doubt is supported either.     I think you should be doing the following instead:
>
> +       if (rphy->identify.device_type == SAS_END_DEVICE &&
> +          (rphy->identify.target_port_protocols & SAS_PROTOCOL_SSP))
> +               sas_read_port_mode_page(sdev);

Yes, thanks for pointing that out. I think it needs to be OR-ed with SAS_PROTOCOL_SATA.

Here is the updated patch.

Signed-off-by: Abhijit Paithankar <apaitha@akamai.com>

Index: linux-2.6.27/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.27.orig/drivers/message/fusion/mptsas.c   2008-10-13 17:31:57.000000000 -0700
+++ linux-2.6.27/drivers/message/fusion/mptsas.c        2008-10-13 19:51:57.000000000 -0700
@@ -839,11 +839,15 @@ mptsas_sas_enclosure_pg0(MPT_ADAPTER *io  static int  mptsas_slave_configure(struct scsi_device *sdev)  {
+       struct sas_rphy *rphy;

        if (sdev->channel == MPTSAS_RAID_CHANNEL)
                goto out;

-       sas_read_port_mode_page(sdev);
+       rphy = dev_to_rphy(sdev->sdev_target->dev.parent);
+       if (rphy->identify.device_type == SAS_END_DEVICE &&
+          !(rphy->identify.target_port_protocols & (SAS_PROTOCOL_SATA | SAS_PROTOCOL_SSP)))
+               sas_read_port_mode_page(sdev);

  out:
        return mptscsih_slave_configure(sdev);
