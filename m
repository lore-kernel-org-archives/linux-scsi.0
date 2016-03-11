From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Fwd: [PATCH 1/1] sd: do not let LBPME bit stop the VPDs speak
Date: Thu, 10 Mar 2016 21:08:02 -0500
Message-ID: <yq1a8m5n4vx.fsf@sermon.lab.mkp.net>
References: <56df97e0.d08d420a.58e8f.3162@mx.google.com>
	<CAGnHSEnLA+WRMuPCLHc=U5m6M5XG-CGbP4gcmh4WJ9QeWwDm0A@mail.gmail.com>
	<CAGnHSE=Ct7vFas3K-DDwU68W+R=ADx7Tx36LBBk3gxeDFZG3Ow@mail.gmail.com>
	<yq1io0vqd0e.fsf@sermon.lab.mkp.net>
	<CAGnHSEng46jz66wkhiA73vvgfFzNx+3R4WeBLbyBrhD5UR6NBw@mail.gmail.com>
	<CAGnHSEmNreG1X78TU9RSO9UyuOPr=1urCbL-EWe7S9Q=tC8wcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23943 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbcCKCIH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 21:08:07 -0500
In-Reply-To: <CAGnHSEmNreG1X78TU9RSO9UyuOPr=1urCbL-EWe7S9Q=tC8wcQ@mail.gmail.com>
	(Tom Yan's message of "Thu, 10 Mar 2016 16:15:57 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> Hmm, is it originated from: (2^32-1) - (2^32-1)%512 = 4294966784
Tom> bytes = 8388607 (512-byte) blocks = 0x7fffff

Yes.

Tom> What about SD_MAX_XFER_BLOCKS then?

It is merely there to provide a theoretical upper max for the 16 and
32-byte READ/WRITE commands. The block layer would never submit a
request that big given all the constraints we have in place (controller
segment/scatterlist/max_sectors, etc.).

The TRIM/WRITE SAME/UNMAP commands are different in that their payload
size differs from the size of the block range they act upon. So we need
to artificially constrain their limits.

-- 
Martin K. Petersen	Oracle Linux Engineering
