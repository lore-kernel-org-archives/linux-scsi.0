Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C43C2D0D1
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D246206EC
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o2ocV9ky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLSXRw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:17:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:36208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSXRw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 18:17:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJN9Vlg083950;
        Thu, 19 Dec 2019 23:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=2X+MJZzOp6dCuDeJ0KornCko/xUA3DPD/Ld+FI4IMB4=;
 b=o2ocV9kyQUB5ennM4SOPbMvLAQTJulmlksNIKiCsKqjDX7D9/8FtGhio+oWlnSnOEoKb
 z8oNsFrRE9TsRnf315+mH/Bwz0DUFN+fhe1bsdpyhII3mqiijNUmwbMNVQaqGGr9OOVS
 yEiL45AQ1lyvs6xMHbulUms9o/Y0qc1/fO7KLqjGWYbhuxnHNKB1l1a811OBG87fLUyu
 efrW5z5LGbPw57bqyz8jJeNiJTpL5J9GLMAvYbp//2y6sT6uMteQk4p5yCzbJOhVpUUz
 iEbTMIkLFRTh0aMX/xTt6NuzWOT+Q29IVm7WDuNDWDW4WrTn6m6GbPIbQ6sCy2snW4L4 Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2x01jadsm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:17:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBJNAaxi032210;
        Thu, 19 Dec 2019 23:17:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2x0bgmkg25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Dec 2019 23:17:38 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBJNHabU021720;
        Thu, 19 Dec 2019 23:17:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 19 Dec 2019 15:17:36 -0800
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <matthias.bgg@gmail.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <beanhuo@micron.com>,
        <kuohong.wang@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <andy.teng@mediatek.com>
Subject: Re: [PATCH v1 0/4] scsi: ufs-mediatek: provide power management
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
Date:   Thu, 19 Dec 2019 18:17:33 -0500
In-Reply-To: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com>
        (Stanley Chu's message of "Fri, 13 Dec 2019 16:11:31 +0800")
Message-ID: <yq1tv5vc3ci.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=958
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912190170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9476 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912190170
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Stanley,

> The patch set provides power management on MediaTek Chipsets by

Had to apply this by hand. Please make sure you prepare patch
submissions against my "queue" branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
