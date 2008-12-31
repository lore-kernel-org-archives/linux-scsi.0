From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Try READ CAPACITY 16 first for all SCSI-3 devices
Date: Wed, 31 Dec 2008 05:18:59 -0500
Message-ID: <yq1sko4y7e4.fsf@sermon.lab.mkp.net>
References: <20081223164703.GB19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:60864 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYLaKUP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 05:20:15 -0500
Received: from rgminet11.oracle.com (rcsinet11.oracle.com [148.87.113.123])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id mBVAMBTM012544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2008 10:22:12 GMT
In-Reply-To: <20081223164703.GB19967@parisc-linux.org> (Matthew Wilcox's message of "Tue\, 23 Dec 2008 09\:47\:03 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> Of course, it's entirely legitimate for devices to not
Matthew> implement READ CAPACITY 16, so this patch also includes a
Matthew> fallback to READ CAPACITY 10 for SCSI-3 devices.

I've been running with this on my DIF drives for a few days and
everything looked fine.

Tonight I tried an all-spindles-in-the-lab test.  I have several drives
that report SCSI_3 but don't implement READ CAPACITY(16).  All of them
correctly send sense error back.  That's the good news.

The bad news is that I have one particular drive model that after a
failed READ CAPACITY(16) command responds correctly to READ
CAPACITY(10).  And *then* the drive firmware commits suicide.

FWIW, this is 2Gbps/10Krpm FC kit.  So not USB/FireWire and not exactly
90s gear either.

*sigh*

At least for DIF I have an innocuous INQUIRY field to key off of.  Long
term I think we should check the Block Limits thin provisioning bits.

For now may I suggest a much more conservative approach:

-       if (sdp->scsi_level > SCSI_2) {
+       if (scsi_device_protection(sdp) || sdp->scsi_level > SCSI_SPC_2) {

-- 
Martin K. Petersen	Oracle Linux Engineering

