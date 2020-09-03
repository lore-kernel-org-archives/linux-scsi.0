Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA334C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964992071B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:25:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uwogh1sU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgICDZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:25:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgICDZ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:25:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0833Ovs0073275
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 03:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : subject : from :
 message-id : date : mime-version : content-type; s=corp-2020-01-29;
 bh=faZwFhJbJZmaWYlQ73kx2Q3kyUjiYX4AXkTIb40rXWQ=;
 b=Uwogh1sUYziPCQAMdlx1DgoTZQJ2cP1V5Ju4C+d8NW6L1xsJSFM5LZROCWDgbCTUilDh
 tnxWNocL3511ce/S9ZSZUlswsyPpRIzJusLDuamAH7EmwlUIKWkw0lQbrA1wUHQrXsMz
 2r7GxbEGr7EEeq5GnW+/35OUdimUDWVxssdN0lm6TDMHQXfdeOdxV618u/24OqFZ2unc
 p9ih0tgMZYJ7L2YvhXfje/4HRGCO0TqqpxDrvWthEuX7xmsgkiJoP4X/UR4cHweviU37
 VPPHvoGd17CxYV4eCacbSbPGey5wJaTRkSC5rBUXFKc8mJGuDqJcORGFtQc/oDFfB0bM Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer69hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 03:25:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0833PFT0050769
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 03:25:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kr24n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 03:25:55 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0833PsHd028718
        for <linux-scsi@vger.kernel.org>; Thu, 3 Sep 2020 03:25:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:25:54 -0700
To:     linux-scsi@vger.kernel.org
Subject: SCSI staging branch
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8mnd0k5.fsf@ca-mkp.ca.oracle.com>
Date:   Wed, 02 Sep 2020 23:25:53 -0400
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=3 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


I have had a few pokes about why patches are slow to show up in
5.10/scsi-queue. The reason is that there have been an awful lot of
rebases and fixups in the last couple of releases. When I have to go
back and fix things that breaks the commit hash previously sent in the
thank you notes from b4. Which again breaks the lore archive mail thread
links to the git commits, etc.

As a result I am experimenting with having a staging branch that is
separate from and slightly ahead of scsi-queue. I merge patches and let
them soak in there for a few days to let zeroday and the various code
analyzers do their thing. And once I am reasonably comfortable that I
don't have to go back and fix anything, I'll shuffle the commits over to
5.10/scsi-queue.

This also means that there is now a delay between me merging something
and the thank you notes being sent out. I was contemplating hacking b4
so I could send notes for both staging and queue but it would generate a
lot of potentially duplicate email.

Another option is that I send a personal note to the submitter once
stuff is staged. And then the public b4 thank you notes once the commits
end up in scsi-queue proper. I'm open to suggestions.

Patchwork should still accurately reflect the status of posted
patches. Plus my for-next branch shows what is currently staged, of
course.

-- 
Martin K. Petersen	Oracle Linux Engineering
