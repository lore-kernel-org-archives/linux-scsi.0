From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] 2.5.31 scsi_error.c cleanup
Date: Mon, 12 Aug 2002 16:38:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020812233815.GA1334@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e2.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g7CNbQha009662
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2002 19:37:27 -0400
Received: from dyn9-47-17-195 (dyn9-47-17-195.beaverton.ibm.com [9.47.17.195])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.3) with ESMTP id g7CNbJON029838
	for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2002 19:37:20 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have created a scsi_error cleanup patch.

I would appreciate any feedback and testing.

The patch simplifies scsi_unjam_host and associated functions.

I did not change any of the current error policy. I would like to do
that in the future.

I have tested the patch on the following configurations with successful
recovery:

UML:
	Driver: scsi_debug Version: 1.59
	Error Hdlr Policy:
		- Request sense if no auto sense.
		- Abort on timed out command

2.5.31:
	Driver: aic7xxx 6.2.4
	Error Hdlr Policy:
		- Abort on timed out command
		- Attempt BDR
		- Send Bus Reset.

I also ran against qlogicisp, ips, and qla drivers but error injection
did not generate any meaningful results.

Complete patch against 2.5.31 is at:

http://www-124.ibm.com/storageio/gen-io/patch-scsi_error-2.5.31-1.gz

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

