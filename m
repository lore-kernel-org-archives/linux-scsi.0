Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759BBC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55358611CC
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhDNWjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:39:53 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38956 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236609AbhDNWjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 18:39:46 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id DFEFE92009C; Thu, 15 Apr 2021 00:39:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id DC4F792009B;
        Thu, 15 Apr 2021 00:39:23 +0200 (CEST)
Date:   Thu, 15 Apr 2021 00:39:23 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] scsi: Avoid using reserved length byte with VPD
 inquiries
In-Reply-To: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104141847360.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As discussed in a previous workaround for a BusLogic BT-958 problem with 
VPD inquiries with an allocation length of 512 bytes as requested before 
commit af73623f5f10 ("[SCSI] sd: Reduce buffer size for vpd request") 
are rejected outright as invalid at least by some SCSI target devices as 
are any requests with a non-zero value in byte #3:

scsi host0: BusLogic BT-958
scsi 0:0:0:0: Direct-Access     IBM      DDYS-T18350M     SA5A PQ: 0 ANSI: 3
scsi 0:0:1:0: Direct-Access     SEAGATE  ST336607LW       0006 PQ: 0 ANSI: 3
scsi 0:0:5:0: Direct-Access     IOMEGA   ZIP 100          E.08 PQ: 0 ANSI: 2
[...]
scsi0: CCB #36 Target 0: Result 2 Host Adapter Status 00 Target Status 02
scsi0: CDB    12 01 00 01 06 00
scsi0: Sense  70 00 05 00 00 00 00 18 00 00 00 00 24 00 00 C0 00 03 00 [...]
sd 0:0:0:0: scsi_vpd_inquiry(0): buf[262] => -5
scsi0: CCB #37 Target 1: Result 2 Host Adapter Status 00 Target Status 02
scsi0: CDB    12 01 00 01 06 00
scsi0: Sense  70 00 05 00 00 00 00 0A 00 00 00 00 24 00 01 C8 00 03 00 [...]
sd 0:0:1:0: scsi_vpd_inquiry(0): buf[262] => -5

(here with the buffer size tweaked to 262 so as to verify if a bit in 
byte #3 of the INQUIRY command is ignored and the length of 6 assumed or 
tripped over, the `BusLogic=TraceErrors' parameter and trailing sense 
data zeros trimmed for brevity).  Note the sense key of 0x5 denoting an 
illegal request.

For the record with the buffer size of 6 requests for page 0 complete 
successfully and due to page truncation `scsi_get_vpd_page' proceeds 
with an attempt to get inexistent page 0x89:

sd 0:0:0:0: scsi_vpd_inquiry(0): buf[6] => 7
sd 0:0:1:0: scsi_vpd_inquiry(0): buf[6] => 13
sd 0:0:0:0: scsi_vpd_inquiry(137): buf[6] => -5
sd 0:0:1:0: scsi_vpd_inquiry(137): buf[6] => -5

Upon a further investigation it has turned out at least SCSI-2 considers 
byte #3 of the INQUIRY command[1] as well as byte #2 of vital product 
data pages[2] reserved and expects a value of zero there.  The response 
from SCSI-3 devices shown above indicates the same expectation.

Therefore it is unsafe to issue INQUIRY requests unconditionally with 
the allocation length beyond 255, as they may fail with an otherwise 
supported request or cause undefined behaviour with some hardware.

Now we actually never do that as all our callers of `scsi_get_vpd_page' 
either hardcode the buffer size to a value between 8 and 255 or 
calculate it from a structure size, of which the largest is:

struct c2_inquiry {
	u8                         peripheral_info;      /*     0     1 */
	u8                         page_code;            /*     1     1 */
	u8                         reserved1;            /*     2     1 */
	u8                         page_len;             /*     3     1 */
	u8                         page_id[4];           /*     4     4 */
	u8                         sw_version[3];        /*     8     3 */
	u8                         sw_date[3];           /*    11     3 */
	u8                         features_enabled;     /*    14     1 */
	u8                         max_lun_supported;    /*    15     1 */
	u8                         partitions[239];      /*    16   239 */

	/* size: 255, cachelines: 2, members: 10 */
	/* last cacheline: 127 bytes */
};

As from commit b3ae8780b429 ("[SCSI] Add EVPD page 0x83 and 0x80 to sysfs")
we now also have the SCSI_VPD_PG_LEN macro that reflects the limitation.

However for the sake of a possible future requirement to support VPD 
pages that do have a length exceeding 255 bytes and now that the danger 
of using the formerly reserved byte #3 of the INQUIRY command has been 
identified execute calls to `scsi_get_vpd_page' with a request size 
exceeding 255 bytes in two stages, by determining the actual length of 
data to be returned first and only then issuing the intended request for 
full data.

References:

[1] "Information technology - Small Computer System Interface - 2", 
    WORKING DRAFT, X3T9.2, Project 375D, Revision 10L, 7-SEP-93, Section 
    8.2.5 "INQUIRY command", pp.104-108

[2] same, Section 8.3.4 "Vital product data parameters", pp.154-159

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: 881a256d84e6 ("[SCSI] Add VPD helper")
---
Hi,

 NB the SCSI-2 working draft is the only normative reference I have access 
to, downloaded many years ago and not online anymore.  I have more recent 
vendor documents that do indicate that bytes #3 & #2 respectively are a 
part of the length field, but based on empirical evidence presented here 
it is unsafe to unconditionally assume that the bytes can be set to a 
non-zero value.  So I think it will be safest long-term if we handle it 
correctly right away now that the knowledge is fresh, as past experience 
with commit af73623f5f10 ("[SCSI] sd: Reduce buffer size for vpd request") 
indicates the circumstances are not always correctly understood.

  Maciej
---
 drivers/scsi/scsi.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

linux-scsi-vpd-inquiry-buffer.diff
Index: linux-macro-ide/drivers/scsi/scsi.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/scsi.c
+++ linux-macro-ide/drivers/scsi/scsi.c
@@ -348,10 +348,15 @@ int scsi_get_vpd_page(struct scsi_device
 
 	/*
 	 * Ask for all the pages supported by this device.  Determine the
-	 * actual data length first if so required by the host, e.g.
-	 * BusLogic BT-958.
+	 * actual data length first if the length requested is beyond 255
+	 * bytes as the high order length byte used to be reserved with
+	 * older SCSI standard revisions and a non-zero value there may
+	 * cause either such an INQUIRY command to be rejected by a target
+	 * or undefined behaviour to occur.  Also do so if so required by
+	 * the host, e.g. BusLogic BT-958.
 	 */
-	if (sdev->host->no_trailing_allocation_length) {
+	if (buf_len > SCSI_VPD_PG_LEN ||
+	    sdev->host->no_trailing_allocation_length) {
 		result = scsi_vpd_inquiry(sdev, buf, 0, min(4, buf_len));
 		if (result < 4)
 			goto fail;
@@ -377,7 +382,8 @@ int scsi_get_vpd_page(struct scsi_device
 	goto fail;
 
  found:
-	if (sdev->host->no_trailing_allocation_length) {
+	if (buf_len > SCSI_VPD_PG_LEN ||
+	    sdev->host->no_trailing_allocation_length) {
 		result = scsi_vpd_inquiry(sdev, buf, page, min(4, buf_len));
 		if (result < 4)
 			goto fail;
