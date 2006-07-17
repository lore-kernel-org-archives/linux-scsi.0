From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Mon, 17 Jul 2006 12:38:33 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7022583D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50388 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751142AbWGQSir convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jul 2006 14:38:47 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Patterson <andrew.patterson@hp.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, elliott@hp.com, "Johnson, Steve" <Steve.Johnson@lsil.com>, "Rivera, Peter" <Peter.Rivera@lsil.com>, "Besmer, Brad" <Brad.Besmer@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Friday, July 14, 2006 5:25 PM, James Bottomley wrote: 
> I have no idea about the fusion ... the frame control is 
> embedded deeply
> in the firmware, so I think it would probably require a firmware
> upgrade.  Eric can comment on this better than I.
> 

Yes, frame creation is in the firmware, not driver.  
Currently the linux driver knows TLR is implmented in firmware by
looking
at IOCFacts->IOCCapabilities (bit 11).

>From sas2r04a.pdf, section 9.2.1 ssp_frame_format, there is
RETRY_DATA_FRAME (byte 10, bit 2) - write data frames retried (xfer_rdy)
RETRANSMIT (byte 10, bit 1) - control frame retried (task, response,
xfer_rdy)

Rob Elliot wrote: "the initiator could set a similar bit in 
COMMAND and TASK frames to let the target know that it is 
safe to retry frames for the whole command."

Which bit is in consideration for being set? In the ssp frame header or
IU?

