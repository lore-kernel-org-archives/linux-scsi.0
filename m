From: James.Smart@Emulex.Com
Subject: RE: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Sat, 5 Feb 2005 21:00:27 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C1FD1CA@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:56830 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S266695AbVBFCAe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Feb 2005 21:00:34 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

> Targets "speak" the same transport protocol as the HBA.
> This cannot necessarily be said about logical units.
> Bridges are being proposed between SAS and SPI in which
> U160/U320 disks on a SPI bus appear as luns on a single
> SAS target (i.e. the bridge device). If the initiator
> wants to speak to the disks then it uses luns (most likely
> where SPI target ids appear as luns). The initiator may be
> a little surprised if it queries the protocol specific mode
> and log pages on those disks (as they will reveal their
> native SPI transport characteristics). 

(I've always hated T10's putting of transport things in the SCSI payloads!).

If this is true - you haven't done a complete bridge. Having done
bridge products before, if you don't have a complete bridge, your
setting yourself up for subtle incompatibility problems that always
pop up at the worst times...

People have to realize that that a bridge is more than just a
packet converter. It's actually an endpoint on either side of the
conversation. Yes, you can make it work 80% of the way with just
packet conversion, but that last 20% can be a real bugger.

> To query and configure
> the bridge (and  perhaps check its protocol specific mode
> and logs pages) well known logical unit numbers will be used.

All well and good - just make sure the luns report a vendor-specific
scsi device type (and use scsi generic to talk to them).

> SCSI targets seem like an important abstraction in their
> own right, not just containers for lus.

Doug, no disrespect, but I don't see how the above argument relates
to the issue...

-- james s
