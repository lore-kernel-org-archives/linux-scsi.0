From: James.Smart@Emulex.Com
Subject: RE: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Sat, 5 Feb 2005 10:04:22 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EB22@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:48601 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261653AbVBEPEZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Feb 2005 10:04:25 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org


> the idea behind this is fine, I just don't like the interface.
> 
> Really a target device is nothing more than a container to SCSI.  We
> already do the transport add/remove calls for targets, I don't see we
> need other calls duplicating this.  So, I think the 
> implementation would
> look a whole lot better if the fc transport class just exported an
> interface to get the extra storage for the driver and tacked it on to
> its allocation.  Then you can use the existing mid-layer transport
> target triggers to do everything you want.

This can certainly be transport-specific. However, I assumed the better
solution was to make it more generic as there's nothing about this
problem that's transport-centric. If a driver only tracks things by 
target (not lun), it makes a whole lotta sense to allow for per-target
data.

Please note however, that I recommend the changes for calling sequence
be taken in regardless. The issue is that the sdev transport setup and
slave alloc calls are made prior to the existence of the starget (thus
any starget transport setup call). The starget really needs to be in
place beforehand.

Let me know - I can revise the patch accordingly.

-- James S
