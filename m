Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600A9C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C7682064C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HMTEnfH/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGOWQu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:16:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgGOWQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 18:16:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMCxEA130179;
        Wed, 15 Jul 2020 22:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ZTEoeqQxmm4dhcQdAZtmh+8bzjPkKJAUNzF1UbYAQpM=;
 b=HMTEnfH/UglWXVl27gq8bgStTZoi49FD6OSWZUWIVdvZzSvidDuv1cKhchLgG2SAZVHn
 veJJHy8DNeX0OYDGkKwTfjYfKu6kurndDDvCQy0s0z4T9za48hkWgQH3/6wJU4wTyWRN
 Bmb7P2NkS18pGfxKu9WDWUoyx0e/uFIjDFmWiT3dxG/DyFE05FIv+7WgDGP208yyURWQ
 0OwJb/3iMi/xrFv/19nILMubapXXeJHAAapcc5zGwXKO0qz/V8to+cs0nV+nWtgp3QCZ
 DprlW6QcRzW9hTxiQQlp39Epd+3+dxMJ3ieroKT44qB4ssG1dDDQy2SCxRk51JxNx1QV bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cme1fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:16:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDflL152348;
        Wed, 15 Jul 2020 22:14:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 327q0s3mm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:14:46 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FMEi8R004658;
        Wed, 15 Jul 2020 22:14:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:14:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, dt@chelsio.com,
        dan.carpenter@oracle.com, linux-scsi@vger.kernel.org,
        ganji.aravind@chelsio.com
Subject: Re: [next] scsi: cxgb4i: remove an unnecessary NULL check for 'cconn' pointer
Date:   Wed, 15 Jul 2020 18:14:36 -0400
Message-Id: <159484884354.21107.11845539351380758591.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1594741751-3323-1-git-send-email-varun@chelsio.com>
References: <1594741751-3323-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=986 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020 21:19:11 +0530, Varun Prakash wrote:

> 'cconn' will never be NULL in cxgbi_conn_alloc_pdu() so
> remove NULL check.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: cxgb4i: Remove an unnecessary NULL check for 'cconn' pointer
      https://git.kernel.org/mkp/scsi/c/ba8ca097089b

-- 
Martin K. Petersen	Oracle Linux Engineering
