Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E04CC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 06:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E3E52168B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 06:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wKghXgUA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgLAGJO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 01:09:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgLAGJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 01:09:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B165ETg071019;
        Tue, 1 Dec 2020 06:08:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=O6m9rQvnSVvHQGgO/uu/QShygvQ+hAFA4Hjll/8l+bk=;
 b=wKghXgUAXy9f61OVz2cGARe8fhzUeVG9uhFcRRbjrMFMpV/ebu/6N6T8SAh59VvLFKjR
 y3IvWdi+41MTQxdNIXZHPyteb5ZwpaJjfyTzfEErATc2zvbweshF5K15BojAkvCF2P0L
 UW37vLpRj3ZiFbMfxGCeLHl1Uc6GN4swaOsYatjJYEGbugepYOvQ6yoBVcd22LwIsghe
 WBjkZVaO/OupFq+PewNhajaAnXV8ESXQCSTB03e2BzOmiC8ZBFPqAvnZcS0T9dZd7t/h
 qCQ+t3D9w3eyKPgL9GJ77ShzHGHjPyKMrbcvPR5MAhxOT7TiPo2PQfNrCse/pMWryg08 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqgsrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 06:08:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1664k2108621;
        Tue, 1 Dec 2020 06:06:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540exh3a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 06:06:30 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B166TtK011796;
        Tue, 1 Dec 2020 06:06:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 22:06:29 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: Increase IOCInit request timeout to 30s
Date:   Tue,  1 Dec 2020 01:06:25 -0500
Message-Id: <160680263440.25762.10503808138811663400.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130082733.26120-1-sreekanth.reddy@broadcom.com>
References: <20201130082733.26120-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=835
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010041
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=863
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010041
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 30 Nov 2020 13:57:33 +0530, Sreekanth Reddy wrote:

> Currently IOCInit request message timeout is set to 10s,
> which may not be sufficient in some scenarios such as HBA
> FW downgrade operation. So, increasing IOCInit request
> timeout to 30s.

Applied to 5.10/scsi-fixes, thanks!

[1/1] mpt3sas: Increase IOCInit request timeout to 30s
      https://git.kernel.org/mkp/scsi/c/85dad327d9b5

-- 
Martin K. Petersen	Oracle Linux Engineering
