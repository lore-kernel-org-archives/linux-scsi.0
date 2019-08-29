Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1B3C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66D5F21726
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 21:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iV/u2ZDo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfH2VoH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:44:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfH2VoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 17:44:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLZ9rr177646;
        Thu, 29 Aug 2019 21:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=439GR6laOPkxyExd1eaxTBPth3thhYxo3Z4AiKzOilk=;
 b=iV/u2ZDoCX0l49hihfnfGIAO4O7O4V7JLjrpIxp5crVr69hBop8DeAbd7kMpiOYnQ7q7
 my7O/VAou2Q8S4LTy+ouA9tXeLgMzcw8jrn4c8RhSyW+7tNF4FQc8T+aaiH8TAgr90Pr
 uYs7t0nMPiQ/rvJn4EvUgXlitguUErUg3mNRGyGaaPM7dbb4GddlZBqp6swFz2BoUrds
 9vbJ/Uq6m8hvlOLj/LxnCdiCOOSAWQyx7GdlVE7x4BxevW5USfq9hM8IC64mLvahncTF
 7DSIlotUgkrGE8sbapUyQJEPskD7qJvKOtAQ7Fa/rYnaOs1CfGfW4OzwjyYWhWVzyB7H 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uppr9r11s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:43:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLYHOT037162;
        Thu, 29 Aug 2019 21:43:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2upkrfg81v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:43:53 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TLhp3a000411;
        Thu, 29 Aug 2019 21:43:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 21:43:50 +0000
To:     Anil Varughese <aniljoy@cadence.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>, <rafalc@cadence.com>,
        <mparab@cadence.com>, <jank@cadence.com>, <vigneshr@ti.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] scsi: ufs: Disable local LCC in .link_startup_notify() in Cadence UFS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190813074250.28177-1-aniljoy@cadence.com>
Date:   Thu, 29 Aug 2019 17:43:47 -0400
In-Reply-To: <20190813074250.28177-1-aniljoy@cadence.com> (Anil Varughese's
        message of "Tue, 13 Aug 2019 08:42:50 +0100")
Message-ID: <yq1ftljsl4c.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=937
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290216
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290216
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Anil,

> Some UFS devices have issues if LCC is enabled. So we are setting
> PA_LOCAL_TX_LCC_Enable to 0 before link startup which will make sure
> that both host and device TX LCC are disabled once link startup is
> completed.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
