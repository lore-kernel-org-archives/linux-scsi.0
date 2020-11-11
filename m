Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A3FC5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B1B32168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HFrqk9Mw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgKKC6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49958 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgKKC6o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2s588158282;
        Wed, 11 Nov 2020 02:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Jw7xtPKUYJKz5gznRW4LKnrRM5tQoIChPU0skHrcydc=;
 b=HFrqk9MwrLYORw73QGyTMuTKRRzgM1QqINWnoHnxaT2K13HnDsg1YMrQpy8prxV9ou7F
 8bd9gBihUDMQpEUsa9Rwiil8pit0k8nkIvuNS1aw1GBvQVdWyS7HOEirJDU9D46kFsTk
 1BzX6nJTLNdx8NKomO83/8ieqfuSRagLQ0nbVP3ns0uwZXLZTkRIl1UJToX0IiMMeJRU
 T5aA7pYS7J/L8rt8A8HjFDuOfQEBJDz4kpf44q/Q3SP58U+BvnGYvap3+Z74QPaTstvF
 ZB4/kJbpuKPhkt7sDVelD5gg6lElsPjPqYzoNQjOhiQcCrSiilOVndWgNSDcXzorZLy/ EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34nkhkxwpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2sr1t153464;
        Wed, 11 Nov 2020 02:58:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34p5g15jdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:32 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2wSCM024321;
        Wed, 11 Nov 2020 02:58:28 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:28 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>, linux-kernel@vger.kernel.org,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V4 0/2] scsi: ufs: Add DeepSleep feature
Date:   Tue, 10 Nov 2020 21:58:20 -0500
Message-Id: <160506295514.14063.1577564592645254971.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103141403.2142-1-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 3 Nov 2020 16:14:01 +0200, Adrian Hunter wrote:

> Here is V4 of the DeepSleep feature patches.
> 
> 
> Changes in V4:
> 	Rebased
> 	Added new patch "scsi: ufs: Allow an error return value from ->device_reset()"
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/2] scsi: ufs: Add DeepSleep feature
      https://git.kernel.org/mkp/scsi/c/fe1d4c2ebcae
[2/2] scsi: ufs: Allow an error return value from ->device_reset()
      https://git.kernel.org/mkp/scsi/c/151f1b664ffb

-- 
Martin K. Petersen	Oracle Linux Engineering
