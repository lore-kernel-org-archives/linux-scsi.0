Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A199C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F61E21872
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 01:51:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ucm0qWTX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389580AbfHHBvZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 21:51:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54120 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfHHBvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 21:51:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781mxSG138309;
        Thu, 8 Aug 2019 01:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=fqar6kzjg03/VcvUI5mP5RbL8vn7I1Tl9jgrXQ+77Ik=;
 b=Ucm0qWTXP3Hk+ghOPnUvolTPNLw7JB1Tr+MCp0iOUlNK3BWq+r/Rb+PcpnJ+ha12yqo9
 sDofcaYtd8guu+duCsNrVMUkAtxb6MZBEjUEaD1ry/8jl1M8x1Dd7Zo6A7kLpAwoNJWn
 N/mCKHWwXEXouYBEOGG2o/bCMGTtsxPyYiIvAet2H/mwu9LcrVXP4OuFYLl3vLuc69si
 GIvl75ZjSr0T0KWIj220JT1CtV5J143WlFDgMGKmkUeDUMf0TeLphJNP4+aU/j33YkbK
 DqbDRpytYm7Gxq9vn1DxNHHF0Lv0Cs28Ct+dJaoGEixxxvdFr+BoF1mXdjRNLTuc+0ol iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pygxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:51:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x781lwuX143092;
        Thu, 8 Aug 2019 01:51:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u7668a0vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 01:51:13 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x781pAv9011890;
        Thu, 8 Aug 2019 01:51:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 18:51:09 -0700
To:     Anil Varughese <aniljoy@cadence.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>, <rafalc@cadence.com>,
        <mparab@cadence.com>, <jank@cadence.com>, <pawell@cadence.com>,
        <vigneshr@ti.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Configure clock in .hce_enable_notify() in Cadence UFS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190802112112.18714-1-aniljoy@cadence.com>
Date:   Wed, 07 Aug 2019 21:51:06 -0400
In-Reply-To: <20190802112112.18714-1-aniljoy@cadence.com> (Anil Varughese's
        message of "Fri, 2 Aug 2019 12:21:12 +0100")
Message-ID: <yq1wofoctmd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080016
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190808015106.14PKdxc47QRTWyt0pXJoRn62FlulmhS2J1x4PTi8lqk@z>


Anil,

> Configure CDNS_UFS_REG_HCLKDIV in .hce_enable_notify() instead of
> .setup_clock() because if UFSHCD resets the controller ip because
> of phy or device related errors then CDNS_UFS_REG_HCLKDIV is
> reset to default value and .setup_clock() is not called later
> in the sequence whereas .hce_enable_notify will be called everytime
> controller is reenabled.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
