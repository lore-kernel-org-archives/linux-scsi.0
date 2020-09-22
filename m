Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B555C4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BB723A32
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0gJbn5W4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgIVD5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60736 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgIVD5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3mvAY040814;
        Tue, 22 Sep 2020 03:57:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=qGpc/nOeTwQgziFXzHeIbnzOAyU/Cr2/SdYgF0XLfJc=;
 b=0gJbn5W4dsMq4S4s/MZ4LMh5jXqpJI1fpMw/YeIHv2zAo2TIVrFmmyTZFuTe0Alfivsj
 Ov8wywJPy/OBQVqbIReV5p0BcTz5GCeD5iaIQl3RFPLQ0gQtuKnQvzgSxEEJO3gwHlW/
 aqjf5SFmxsQc2zp6KckFxyTIb5RpAtJHsh5uOKbdW4X5VcwdQMSioYNJSTPunUx+CRY5
 XZ6kDMDi52WMnaQaNIPUnHHnIAbEJFgK9c2VHKJABjQhc9zbFC8laCcQAVXfvQbdNUsH
 8kM0FoE3n7lLLWoliPoeHGfASw/HWgfXAIPeV0E1BPtl92NKqza1q0Q6OaD9YJoyP7/N xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnuagnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3tsKq017547;
        Tue, 22 Sep 2020 03:57:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33nuw2pkdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:19 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08M3vGo4012110;
        Tue, 22 Sep 2020 03:57:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix NOP OUT timeout value
Date:   Mon, 21 Sep 2020 23:56:47 -0400
Message-Id: <160074695009.411.9916497400383722372.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <231786897.01599016081767.JavaMail.epsvc@epcpadp2>
References: <CGME20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1@epcms2p2> <231786897.01599016081767.JavaMail.epsvc@epcpadp2>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 02 Sep 2020 11:58:52 +0900, Daejun Park wrote:

> In some Samsung UFS devices, there is some booting fail issue with
> low-power UFS device. The reason of this issue is the UFS device has a
> little bit longer latency for NOP OUT response. It causes booting fail
> because NOP OUT command is issued during initialization to check whether
> the device transport protocol is ready or not. This issue is resolved by
> releasing NOP_OUT_TIMEOUT value.
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ufs: Fix NOP OUT timeout value
      https://git.kernel.org/mkp/scsi/c/782e2efb749f

-- 
Martin K. Petersen	Oracle Linux Engineering
