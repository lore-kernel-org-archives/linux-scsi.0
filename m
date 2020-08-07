Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B10C433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 04:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F3C21744
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 04:32:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gAYVyRcD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgHGEco (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 00:32:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgHGEcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 00:32:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0774WNsI141338;
        Fri, 7 Aug 2020 04:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=8Wfo9c+uZ6H9abHfs8H2dH/06jlrmsvNMvWZnZ+m/xQ=;
 b=gAYVyRcDHCZA1oU2kbOgRx4hqvmV4BJvzhMXYaeXs9feh9vbcmA/P1TUX4HB+zt5uwb/
 /gqO6h6vmZST0Ojs2lYI4qe7Vp1Cs+VLLSoFpvRz9jljEGaAR64sVajPwEhdXeVSa+bP
 Fr1CQgFirE23smTbLCZQ759WgnTasH065pa8SA096yqmvdbypkk4TuTywvrOhJCPw7ho
 3uGxrmsaIXtO8A5PwfKVUTmx4TIAODzKICSbDK3e7hGZaoNbzYT8YizJesaVQ2EEJs66
 kA3ezxDWhl28g4/S7jGg5a0ON3VTZZVV9cTI20Aepc41PNDKuj3JfEeCin6nGwP2ekRu 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32r6ep6ejq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 07 Aug 2020 04:32:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0774T1Ch032156;
        Fri, 7 Aug 2020 04:32:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32pdnye4u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Aug 2020 04:32:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0774WJdV016137;
        Fri, 7 Aug 2020 04:32:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 21:32:19 -0700
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mu37w0ig.fsf@ca-mkp.ca.oracle.com>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
        <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
        <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
        <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
Date:   Fri, 07 Aug 2020 00:32:15 -0400
In-Reply-To: <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        (Avri Altman's message of "Thu, 6 Aug 2020 13:56:34 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008070031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 clxscore=1011 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> Martin - Are you considering to merge the HPB feature eventually to
> mainline kernel?

I promise to take a look at the new series. But I can't say I'm a big
fan of how this feature was defined in the spec.

And - as discussed a couple of weeks ago - I would still like to see
some supporting evidence from a realistic workload and not a synthetic
benchmark.

-- 
Martin K. Petersen	Oracle Linux Engineering
