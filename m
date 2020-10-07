Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7A0C46466
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05E5A208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rFNDCW9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgJGDso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:48:44 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48434 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbgJGDsi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:48:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973l5uv175631;
        Wed, 7 Oct 2020 03:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sp+W1ObdtURYjxe17LjlyECrzhC8OPLxupOvPFjMT0o=;
 b=rFNDCW9dXVSMQG7J5Jh0NtbQC4YrKsoCcBQ9XDTNE/cAioZDj6IEAWzHuXS8135W3+U5
 sipoKsYnxa8YFCuvBfkEGAzoS8vKkYqMOSIS/YfIElxb0pjSluwNzTTXEuozqIsarCS0
 54Riwt/0yxjEIZ1ffAKoxiW3N71hLhBxS1zZqK5EjuGlUU4E3rYyMS+Q2QmhkIcb1zSw
 rYaPOkci7elhAEH/DKDn+vkbIyzDyKuS+3k4XDcid+86FqGbONXGIXEFyx1WkHBisEry
 sFkSAjYZhi68DpexP8IpEeeknAFPI0pbexqPBGpjTx/oT5o7KKrt48/nuwczN0Prs9ND Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetayn7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:48:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973jI5Z054881;
        Wed, 7 Oct 2020 03:48:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33y2vnxxuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:29 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mSY0002213;
        Wed, 7 Oct 2020 03:48:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:28 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     njavali@marvell.com, Ye Bin <yebin10@huawei.com>,
        linux-scsi@vger.kernel.org, mrangankar@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: qla4xxx: Delete unneeded variable 'status' in qla4xxx_process_ddb_changed
Date:   Tue,  6 Oct 2020 23:48:06 -0400
Message-Id: <160204240580.16940.5879654501585414401.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916022749.348923-1-yebin10@huawei.com>
References: <20200916022749.348923-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Sep 2020 10:27:49 +0800, Ye Bin wrote:

> Fixes coccicheck warning:
> drivers/scsi/qla4xxx/ql4_init.c:1173:5-11: Unneeded variable: "status". Return "QLA_ERROR" on line 1195

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qla4xxx: Delete unneeded variable 'status' in qla4xxx_process_ddb_changed
      https://git.kernel.org/mkp/scsi/c/121432e87093

-- 
Martin K. Petersen	Oracle Linux Engineering
