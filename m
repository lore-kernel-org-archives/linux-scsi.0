From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: QLA2300, Infortrand and LBD?
Date: 28 Jul 2004 10:17:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091024272.2225.32.camel@mulgrave>
References: <47F3C2BE74738E4683574107469DFA204CC855@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:37312 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267164AbUG1OR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 10:17:58 -0400
In-Reply-To: <47F3C2BE74738E4683574107469DFA204CC855@XYUSEX01.xyus.xyratex.com>
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: "tester7 A." <benew666@hotmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, tech@storageone.co.kr

On Wed, 2004-07-28 at 09:46, Frank Borich wrote:
> Looking at an FC trace on an Infortrend controller I have, shows that
> for a LUN 3586680 MB in size, the LBA is B5D3BFFF in the "RETURNED
> LOGICAL BLOCK ADDRESS FIELD" 
> and with in the "BLOCK LENGTH IN BYTES FIELD" field is 200h , ( B5D3BFFF
> * 200h =  approx. 1.6 TB). Seems that infortrend does NOT respond
> properly to READ_CAPACITY_10, at least in my case. 

Well 3586680 MB == 0x1b5d3bfff * 0x200

so I think you can see where the returned figure is coming from...

Infortrends should be made aware of the problem so they can do a bios
upgrade.  I suspect that even if the array returned the correct capacity
it would be unable to process the READ/WRITE(16) commands necessary to
reach it anyway, so their "fix" may be to tell you that no individual
luns can be configured beyond 2TB.

> James, this may be a dumb question, please excuse my ignorance of the
> internals of the scsi subsystem, 
> but is there a plan to implement LBD support in the 2.4 tree ?

The problem is not just in SCSI, it permeates the block layer.  I don't
think there's much point backporting LBD to 2.4, although many vendor
trees have it.

James


