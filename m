From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: RE: How to resurrect offlined SCSI devices?
Date: Wed, 26 May 2004 09:17:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E704E37B0A@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63486 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265647AbUEZQRO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 12:17:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>



Wouldn't it be acceptable for the lldd to call  scsi_scan_host() at this
point to force a scsi mid layer rescan of the devices attached to the hba?
In a fibre channel environment a device can disappear for a long period of
time, then come back. The driver knows exactly when it comes back and should
be able to tell the scsi layer.

Jon Infante
Emulex


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
Sent: Wednesday, May 26, 2004 7:46 AM
To: Martin Peschke3
Cc: SCSI Mailing List
Subject: Re: How to resurrect offlined SCSI devices?


On Wed, 2004-05-26 at 08:14, Martin Peschke3 wrote:
> Is there a SCSI mid layer interface that allows an lldd to get a
> SCSI devices back online?

actually

echo "running" > /sys/...<device path>.../state

will work from user land.

Really, it isn't safe for a LLD to try to bring a device back online on
its own without user intervention.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
