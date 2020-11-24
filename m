Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2776BC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C09DD2080A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mH6qBd1s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgKXDOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:14:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52610 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgKXDOg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:14:36 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 22:14:35 EST
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO39ZHT032239;
        Tue, 24 Nov 2020 03:14:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=CjGg/3NAt1W9g4gnpGdsojlm97Dqszx0LMzob0U5qcg=;
 b=mH6qBd1s2P32HNByX4NPOyeRv1eFoNMEnHQuPq6wPkHMGA8kmrIUfnqt5LM79D2PoCcH
 PAgR8v/vQLu1OfCEgsEaRYqHCXYCAQdU2lyNVYDNF4i6CxYEMK8sT+4NVT08IKzGQBlq
 PdvLYzLVjHFFVqK6ngmfFV1/si5BepPZsWpL5C8/z4BdEszMXuVCSsZbkR2Gm+uTe3Pr
 rsCfNikne65An/nK5Aq1kltoveM5elEL75PxVLQsAsx7YrPrk16dWBOXcdIr28hUbbHZ
 Re5LQQYe0rW+wOEdGlRxoRyYe2wTgjGJZi3OpYqIgq41rjJgEENicbm5YHurgRnIz2r6 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 34xtaqkw2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:14:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO39s7u179059;
        Tue, 24 Nov 2020 03:14:29 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ycnrurea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:14:29 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AO3ESWf009992;
        Tue, 24 Nov 2020 03:14:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:14:28 -0800
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/atari_scsi: Fix race condition between
 .queuecommand and EH
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18saro393.fsf@ca-mkp.ca.oracle.com>
References: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
Date:   Mon, 23 Nov 2020 22:14:26 -0500
In-Reply-To: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
        (Finn Thain's message of "Fri, 20 Nov 2020 15:39:56 +1100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=1
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=1 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Finn,

> It is possible that bus_reset_cleanup() or .eh_abort_handler could be
> invoked during NCR5380_queuecommand(). If that takes place before the
> new command is enqueued and after the ST-DMA "lock" has been acquired,
> the ST-DMA "lock" will be released again. This will result in a lost
> DMA interrupt and a command timeout. Fix this by excluding EH and
> interrupt handlers while the new command is enqueued.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
