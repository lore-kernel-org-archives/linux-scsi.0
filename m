From: Todd Fujinaka <todd.fujinaka@intel.com>
Subject: Re: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD reads
Date: Fri,  5 Feb 2016 06:54:23 -0800
Message-ID: <1454684063-19116-1-git-send-email-todd.fujinaka@intel.com>
References: <20160202101830.GA3786@node.shutemov.name>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18345 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbcBEOyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Feb 2016 09:54:40 -0500
In-Reply-To: <20160202101830.GA3786@node.shutemov.name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kirill.shutemov@linux.intel.com
Cc: linux-scsi@vger.kernel.org

I've tried to read the code but I'm not sure where the strings are getting
parsed. I'm afraid I'm only familiar with the Ethernet drivers. In any case,
the patch didn't help and I had to add this second Marvell line. I'm not sure
if you can just wildcard the second and third fields or not.

I'm also trying to reply to a mailing-list that I'm not subscribed to using git
send-email. Please forgive the errors.

Todd Fujinaka <todd.fujinaka@intel.com>

-----

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 47b9d13..bbfbfd9 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -205,6 +205,8 @@ static struct {
 	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
+	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
+	{"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
