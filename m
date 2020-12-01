Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACE4C64E8A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1BB32084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:15:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="brjStd47"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgLAFP3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:15:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42274 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgLAFP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:15:29 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B158smW125832;
        Tue, 1 Dec 2020 05:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=kVj0/5uEgvvTQ/5df08BM/GKVqwwSEHd5y8fzC6Kqco=;
 b=brjStd473vCF9UmTKBhYB6mwHdRM4zDkuXWuUDylgONGx/PPoyaDcMmdupzOYVpmW/si
 9rBMgWQ8SBGyEsiHjggdKGhk673ahWwnB7VLER+g7ScdH8FBQnidBF9r7l/iJtEICgxg
 oOAmFcaoYx9pRFU/QGdOGyZxC07QfQ9yl/wdA4shYQVnIFWs66Weks4ozvSwZ40/U2mx
 1txwCzEoinXo9tE9quqoHEYR70KEgLUvDaRt5+VSI0QHbmokc1KlYXU+vNPBtArxSF4x
 sQySl8hcck36vy4m0yB/RdJ82XMsR9RW4NSzlyTJvksrVQi/SgWawGkFVL5pvJJn74vH 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkgk4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:14:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B15BIdW102349;
        Tue, 1 Dec 2020 05:14:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3540fwb2ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:14:43 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B15EgbC025985;
        Tue, 1 Dec 2020 05:14:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 21:14:42 -0800
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v3 0/2] Subject: [PATCH v3 0/2] Refactor
 ufshcd_setup_clocks() to remove param skip_ref_clk
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14kl6hzuu.fsf@ca-mkp.ca.oracle.com>
References: <1606356063-38380-1-git-send-email-cang@codeaurora.org>
Date:   Tue, 01 Dec 2020 00:14:39 -0500
In-Reply-To: <1606356063-38380-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 25 Nov 2020 18:00:59 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=754 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=784 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010034
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> Allow vendor drivers to decide which clock should be kept on when
> clk gating or suspend disables clocks while link is active.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
