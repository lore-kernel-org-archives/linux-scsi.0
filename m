Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E235C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B63F52085B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:49:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xR700xLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgKXDsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:48:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41620 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbgKXDsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:48:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3mlSj149466;
        Tue, 24 Nov 2020 03:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=xO7c69bo04QbH0K5Ns9hWS1akBJNChVvOF00BzSKiZ0=;
 b=xR700xLMpGiAVR8ym+sM52rWIljmOSTHiQfMoOGldJ0tpgtYr+d4PRhGrh+TbSlQ9xN4
 Ffo1Z/3cNOGXfoBgbnf3PN9t1URUFqJTa7FPid1tPwZ8wiWphoJfh9+7KG1zQMx7TPjJ
 WO3zMnL9yvNmQRlPZzHEbKUx0mNrtx9HvLecS1Fcxcqb2TgLvZsU2VRYrQyUc8oUhWiR
 /2R53fbu9rarM/OEHruYspqo7EwN7TsKnTu8XjzkBnbKqAHFutYl54k1jl2N367XO+rX
 2Fh7GzxAq5NIaG1wzgcAN0gZrDuSyVnbrp/EUPFUpMhUgCPlXZrRYi7enQiiBquXiv5e 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34xtum0dhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:48:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3jvrU117375;
        Tue, 24 Nov 2020 03:48:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34ycfmr31b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:48:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3mk4D003051;
        Tue, 24 Nov 2020 03:48:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:48:46 -0800
To:     Karan Tilak Kumar <kartilak@cisco.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, arulponn@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: set scsi_set_resid only for underflow
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2irl8j0.fsf@ca-mkp.ca.oracle.com>
References: <20201121015134.18872-1-kartilak@cisco.com>
Date:   Mon, 23 Nov 2020 22:48:44 -0500
In-Reply-To: <20201121015134.18872-1-kartilak@cisco.com> (Karan Tilak Kumar's
        message of "Fri, 20 Nov 2020 17:51:34 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=1 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Karan,

> Fix to set scsi_set_resid() only if FCPIO_ICMND_CMPL_RESID_UNDER is
> set.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
