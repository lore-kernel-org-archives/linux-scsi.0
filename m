Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19377C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3922076D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 03:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kjeYL54A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgHRDOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 23:14:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35082 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgHRDOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 23:14:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I37XBM113875;
        Tue, 18 Aug 2020 03:14:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7QHkV/ES8zH95c7fmkSF5lFXc1zNQSjl4IUT86m6GQU=;
 b=kjeYL54AOhbyFJ20YnaQ1/NBGPn9fBJ1YSqK1yqptWnywqKZQFOWyXapmnST3fPxEQBm
 Vszyl7W1G2WfQzZ1fsU6NQQS/AlQT8yNK2Rj0B336XHNHSfVUJ5T4wA4SI1NEq0grhbw
 E0Vp1Qq2q1UMRIvkdk46GiN1cNOfCCyz+sbIEVGLYVXxwHoxqkLYFUp0TqL668U7OwD1
 3cLu1MzKesYse4uj/h4Z1olq5bF5Kz0KzL39EKugJqUcgIKe3EHFZbYJuQEEhq7lAFnk
 f6GQ83h7wS+jyrNf59V3oJQS5GXpEZtjIdG8hpb7r8VbDVxLNiclNA2UnjuyrV6njIVg IA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32x8bn22vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 03:14:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07I3863W131255;
        Tue, 18 Aug 2020 03:12:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32xs9mf4ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 03:12:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07I3CY4o029796;
        Tue, 18 Aug 2020 03:12:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 20:12:33 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL
Date:   Mon, 17 Aug 2020 23:12:22 -0400
Message-Id: <159772029326.19587.8414026585786255595.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810141024.28859-1-adrian.hunter@intel.com>
References: <20200810141024.28859-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxscore=0 mlxlogscore=998 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Aug 2020 17:10:24 +0300, Adrian Hunter wrote:

> Intel EHL UFS host controller advertises auto-hibernate capability but it
> does not work correctly. Add a quirk for that.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL
      https://git.kernel.org/mkp/scsi/c/8da76f71fef7

-- 
Martin K. Petersen	Oracle Linux Engineering
