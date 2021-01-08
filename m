Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D449C43381
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645A02075A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbhAHEUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:20:38 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48984 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAHEUh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:20:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 108492hk041340;
        Fri, 8 Jan 2021 04:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fHAvPMXMCfyTi7IpkD9krCOAmF83C+ske4aYaDdCGe0=;
 b=znGqfx/FFGnccSpPSUvBx9MjOX9Zmpxc/EB7V/IdPOXklSa1zPQJnBe2cNdT0hyofOZx
 LCgc5Vl8M6kK+w61xH6ny4a1b3Lihk0HlCSAgj9AUyWEnOVIGwNoxX4mYFrZr7y1ka9a
 Bb6NSr5d+nkGgWN+DX7iqmA5oWoN/52NFsbCgV801kDp1jfiSNUR8WEkHPixQXt6z+Vt
 fkd/SYSuf4D8agn2Zkr9K1nbRJfRKRHFEweukDnP7ntELZ/7Tb9udlUkB8KXi0wbJpcG
 x5AC+HXUsWKBgEwS3jFKtp6/bisxTv3BdvBUA9u/S+nyfZRdFbo/t+Q/6zlAVySygjVj ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35wcuxysa4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:19:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849SNH170537;
        Fri, 8 Jan 2021 04:19:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g3r4kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:46 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1084JhNM012389;
        Fri, 8 Jan 2021 04:19:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 20:19:42 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bean Huo <huobean@gmail.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH V2] docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode
Date:   Thu,  7 Jan 2021 23:19:29 -0500
Message-Id: <161007949339.9892.7688310606850148159.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104155026.16417-1-adrian.hunter@intel.com>
References: <20210104155026.16417-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=873 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=884 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 4 Jan 2021 17:50:26 +0200, Adrian Hunter wrote:

> Update sysfs documentation for addition of DeepSleep power mode.

Applied to 5.11/scsi-fixes, thanks!

[1/1] docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode
      https://git.kernel.org/mkp/scsi/c/0b2894cd0fdf

-- 
Martin K. Petersen	Oracle Linux Engineering
