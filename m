From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: Wed, 06 Oct 2004 14:59:38 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41637BBA.804@torque.net>
References: <OF2154D688.D97183DA-ONC1256F24.005BD3E3-C1256F24.005EE95C@de.ibm.com> <1096996724.2064.56.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:32933 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S267232AbUJFFAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 01:00:04 -0400
In-Reply-To: <1096996724.2064.56.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Martin Peschke3 <MPESCHKE@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2004-10-05 at 12:10, Martin Peschke3 wrote:
> 
>>now that there is more and more stuff handed over to transport classes,
>>would it be feasible to put LUN there as well, as its form appears to be
>>transport specific as well? (e.g. 64 bit for FC while other transports
>>may be unable to convey 64 bit LUNs)
> 
> 
> Well, I'm not sure about that, primarily because the LUN specifications
> in the standards aren't transport specific.

That is right, 64 bit LUNs were mandated in SAM-2
(standardized in 2003) and SAM-3 (soon to become a standard).
So the Linux SCSI subsystem's 32 bit LUNs have been deficient
for some time. [Incidentally I am probably responsible for
bumping the lun representation from 8 bit to 32 bit some years
back. From memory the only reason we didn't go to 64 bits
was uncertainties about 64 bit arithmetic on various target
platforms. Those days are long since gone.]

When SCSI devices start using advanced LUN features like
"well known logical units" (SPC-3 rev 21 section 8)
we are really going to start hurting.

So I sympathize with Martin; in the past he has tried to get
the mid-level's representation expanded from 32 bits to 64 bits
and failed. Now that he tries to shadow luns in the FCP
transport (like is already being done for port identifiers
and names which _are_ transport defined (i.e. arguably should
not be in the mid-level)) he seems to get turned down on the
basis of architecture.

>>I see that this particular patch is not exactly what was needed to achieve
>>this, because at the time of the evaluation INQUIRY data the LUN has
>>already been adapted to the way LUNs are stored in scsi_device.

The SCSI INQUIRY command seems a pretty fluid beast. There is
potentially a large amount of very important information in
its vital product pages (especially the device identification
page descriptors) with other information formerly held by the
INQUIRY command being passed off to new SCSI commands
(e.g. REPORT SUPPORTED OPERATION CODES).

The ugliest aspect of an INQUIRY is the way SPI information
is conveyed in byte 56. That information should have been in
the protocol specific port control mode page (and is for more
recently defined protocols and transports).

>>I am also not sure yet how this approach would go with REPORT_LUNS,
>>which returns 64 bit LUNs for all transports. But for everybody interested
>>in 64 bit LUNs, it would certainly clean things up.
> 
> 
> Yes, that's another reason to make it transport specific.  Even SPI code
> has to understand 64 bit LUN returns.

So does James now support Martin's proposal or is there a "not"
missing in the first sentence of the above paragraph?

Doug Gilbert

