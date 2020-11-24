Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1977C6379D
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524E120866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C/nWj68L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgKXD6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48258 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbgKXD6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3totb154424;
        Tue, 24 Nov 2020 03:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MXQjdSo1SJsDsRmOmCcEtcKSQ4xokhhd2IdRPOwrEmc=;
 b=C/nWj68LCatrAG+w8+t4Fq4joZ7UW5Fhij9vJ0vAgq03f+2PDW13EMi2lQ+BC9EG9UP/
 QHAdipgZgZ/+AvUYlnbg+4t7UpWt3dqxDHff5nelMwgyO+/rBIE5I8JBKa3IwSCffQ6l
 3jzBV3ZGN3b6XgGdjRQbaN2gr6eVmQzrnL7NYpOU+24A2Iy2aUG27ZaZ4TuLARP1kxk+
 jLAn6eevO/p6wkz182pa94l9rp37bYJbbg7/ADv8z9BcFS+eZ+s81aZ4hrKCTDnyspxm
 N7Gtyz2UpvtlGw5t8MmELmz6wE+qKY67SL3jms5rTVldyFq/J6dzM1sEA7Lc6Yozut0x kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34xtum0e4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3ssSt115642;
        Tue, 24 Nov 2020 03:58:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34yctvu0te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:17 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wHh4009638;
        Tue, 24 Nov 2020 03:58:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:16 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix set but not used warnings from Rework remote port lock handling
Date:   Mon, 23 Nov 2020 22:58:05 -0500
Message-Id: <160618683553.24173.4860843133688828099.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119203340.121819-1-james.smart@broadcom.com>
References: <20201119203340.121819-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Nov 2020 12:33:40 -0800, James Smart wrote:

> Remove local variables that are set but not used.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix set but not used warnings from Rework remote port lock handling
      https://git.kernel.org/mkp/scsi/c/4a119d8a4c60

-- 
Martin K. Petersen	Oracle Linux Engineering
