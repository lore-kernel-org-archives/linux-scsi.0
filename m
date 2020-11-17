Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C94FC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 04:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66A324671
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 04:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wFDiUo6i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgKQEd5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 23:33:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54102 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgKQEd4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 23:33:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH4OSrx161203;
        Tue, 17 Nov 2020 04:33:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=EshNhEFwh1JJV/VNuwzW9QTaC7Bvbm9d7b6KWQCmOho=;
 b=wFDiUo6iRgfzZTEIdhfF89uMbyIKr75LZMJFXT0FbVQweW6K5NJl4C+S0b9mNp2GJON+
 jvCujcRJ/Wevc4KByozmj5KoeWO/7JLQVUXYYzzXNPw6dHnxbaOux+3yQoY0sDv8x2SG
 kwxgeopaf5e2iXNx1GPIGNNAwup+QDYXLHgmmE++VzPRNePmF6RhqI18nJYlkhg/wCre
 2XXqw78xjpDTWAl5MPI9jYTojkL+aUrS/YFeZykpAyAEc8Zv88wNIkouWx4qL7eaTTfu
 7Ikv9RmX1HuS4t5Z41T1j75ckqG+J9FLVl/QNPXyBNgA5FvN0HVQwjMoCdIJT7s170za 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rarm0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 04:33:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH4VYsF039937;
        Tue, 17 Nov 2020 04:33:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34uspsv0v5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 04:33:22 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH4XCIa017287;
        Tue, 17 Nov 2020 04:33:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 20:33:10 -0800
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <matthias.bgg@gmail.com>, <bvanassche@acm.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>, <chaotian.jing@mediatek.com>,
        <cc.chou@mediatek.com>, <jiajie.hao@mediatek.com>,
        <alice.chao@mediatek.com>
Subject: Re: [PATCH] scsi: ufs: Add retry flow for failed hba enabling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg984n7p.fsf@ca-mkp.ca.oracle.com>
References: <20201112054537.22494-1-stanley.chu@mediatek.com>
Date:   Mon, 16 Nov 2020 23:33:06 -0500
In-Reply-To: <20201112054537.22494-1-stanley.chu@mediatek.com> (Stanley Chu's
        message of "Thu, 12 Nov 2020 13:45:37 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> Once hba enabling is failed, add retry mechanism and in the meanwhile
> allow vendors to apply specific handlings before the next retry. For
> example, vendors can do vendor-specific host reset flow in variant
> function "ufshcd_vops_hce_enable_notify()".

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
