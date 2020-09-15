Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2EDC433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 02:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1DB2065E
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 02:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S3S+GkJt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgIPCpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 22:45:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIPCpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 22:45:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKANhu178547;
        Tue, 15 Sep 2020 20:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qAI13vl8S4HJ0bvYvTuJZ4SrZXNUUbufGVxMmQawQvQ=;
 b=S3S+GkJtpgtD+WnjR7b1367YtZ1/mVfujKXdzFOeHi3zc+E7pnq92mkfWsbpzG9tMMa4
 hzG9E0hg6gJn7g7/AeqM3YxbpozKTpw5V4XUQXQZt8H918+Q+NQ5mcSsolMxhLswh3pF
 /1aby3Yv37iesJYW1MXUrbwF8XsehOcH8uUXidiL3i0oOiWGa+3pJMKzRAvUJUrutSvT
 deS6Tdb/7FLujl1RLQnmtsCWbOAHCOTpWKwCvt6X0gSGimLqj17rsQt1FhqWgVruPfxT
 lUoC3fy9JKM9F9IG9cnB7ecXPz7Lb/kUmlU+AELcp08n3Mp5UpBV/OFb+dkKzNgcbwj3 FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dh0yr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:16:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKEhaU181308;
        Tue, 15 Sep 2020 20:16:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33h88yy84d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:16:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FKGfvW007855;
        Tue, 15 Sep 2020 20:16:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:16:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, Manish Rangankar <mrangankar@marvell.com>,
        cleech@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/8] qedi: Misc bug fixes and enhancements
Date:   Tue, 15 Sep 2020 16:16:26 -0400
Message-Id: <160020074002.8134.7440013888270718633.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908095657.26821-1-mrangankar@marvell.com>
References: <20200908095657.26821-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150157
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Sep 2020 02:56:49 -0700, Manish Rangankar wrote:

> Please apply the qedi miscellaneous bug fixes and enhancement patches
> to the scsi tree at your convenience.
> 
> v1->v2:
> Fix warning reported by kernel test robot
> 
> Thanks,
> Manish
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/8] scsi: qedi: Use qed count from set_fp_int in msix allocation
      https://git.kernel.org/mkp/scsi/c/3f8ad0072bf7
[2/8] scsi: qedi: Skip firmware connection termination for PCI shutdown handler
      https://git.kernel.org/mkp/scsi/c/5c35e4646566
[3/8] scsi: qedi: Fix list_del corruption while removing active I/O
      https://git.kernel.org/mkp/scsi/c/28b35d17f9f8
[4/8] scsi: qedi: Protect active command list to avoid list corruption
      https://git.kernel.org/mkp/scsi/c/c0650e28448d
[5/8] scsi: qedi: Use snprintf instead of sprintf
      https://git.kernel.org/mkp/scsi/c/5a2e69af16ce
[6/8] scsi: qedi: Mark all connections for recovery on link down event
      https://git.kernel.org/mkp/scsi/c/4118879be375
[7/8] scsi: qedi: Add firmware error recovery invocation support
      https://git.kernel.org/mkp/scsi/c/f4ba4e55db6d
[8/8] scsi: qedi: Add support for handling PCIe errors
      https://git.kernel.org/mkp/scsi/c/96a766a789eb

-- 
Martin K. Petersen	Oracle Linux Engineering
