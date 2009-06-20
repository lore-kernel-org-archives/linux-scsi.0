From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: How To Get WWN and Device Mapping
Date: Fri, 19 Jun 2009 19:21:24 -0500
Message-ID: <1245457284.12515.13.camel@mulgrave.site>
References: <D9D8963FC28A1C49BBF5EE152BE9763601278B8276@CBA0EXBE01.CBA0.centerbeam.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34266 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbZFTAVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2009 20:21:24 -0400
In-Reply-To: <D9D8963FC28A1C49BBF5EE152BE9763601278B8276@CBA0EXBE01.CBA0.centerbeam.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Paul Lung (paul.lung@loglogic.com)" <Paul.Lung@loglogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2009-06-19 at 16:54 -0700, Paul Lung (paul.lung@loglogic.com)
wrote:
> Hi,
> 
> I'm using 2.6.25.14 kernel with the qla2xxx driver turned on for a
> SAN, and I tried to use SCLI from QLogic to get the linux device->wwn
> mapping. However, SCLI does not seem to be able to detect any LUNs
> with the driver in 2.6.25 kernel.

You'll need to ask qlogic about their tools.

>  I then found that doing a scsi_id on a device(say, ./block/sde)  will
> give me the wwn, with an extra number in the front.

man scsi_id will tell you what this is and why it's there.

>  However, further research seems to indicate that scsi_id does not
> always give back the wwn. It's is totally dependent on the physical
> device being queried. 

For WWN this is true ... the device must export it properly via the
correct VPD inquiry for it to be displayed ... although most fibre
devices do nowadays.

> So, is there any way to reliably get the WWN of a linux device? The
> qla2xxx driver must have gotten the wwn of all the drives on the SAN.
> Is this information "published" anywhere?

I think you're confusing WWN and WWPN ... it's the latter the fibre has
to know. If it's the WWPN you're after, it's the fc_transport port_name
attribute (either of the rport or the target).

James


> 
> Thank you very much for your time.
> 
> Paul Lung--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

