Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36580C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EEAB2074B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ac++HWFR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgFJCmF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:42:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgFJCmD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:42:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A2aQ53156139;
        Wed, 10 Jun 2020 02:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=jsoQcyzfrxL4t8e+aWIRBwCpl33orrtek8y501RHyXY=;
 b=ac++HWFR3PniNo+ib7ObhN2pXkU5X3ONXn9a+sCR9kaE/S/jfXkgciDuaEbHn7A2Rem3
 n6jFTQ7JrrC8TPsJjf97NH+t+bEUCKuW9b6qmQ467e6Henc0gjZTUg8ei2wE9XpwTi59
 gG4nqAi9nAKc7FUlgSFDuJqcZsQtg8D1YuexnXRlWa0inqB9hN7nRoPvYmznfFeR58/X
 8EvObtt3v4XzM9ScrKqgnxXPd2OM8VEmc7A6YsitMMocvkEVLHUzTHZxPCVAJe/G2EfF
 RlejOJXRwDWmBCBazBIgYuXuPYb/qRbA57AxZuArqW+tNUtw0zu0bpBrwgk7Wl787/f1 UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31g3smytkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 02:41:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A2cQsU168143;
        Wed, 10 Jun 2020 02:41:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31gmwsd3dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 02:41:26 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05A2fMSp000824;
        Wed, 10 Jun 2020 02:41:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 19:41:22 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux@armlinux.org.uk,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: acornscsi: Fix an error handling path in 'acornscsi_probe()'
Date:   Tue,  9 Jun 2020 22:41:19 -0400
Message-Id: <159175686975.7062.3916571088976504463.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530081622.577888-1-christophe.jaillet@wanadoo.fr>
References: <20200530081622.577888-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=971 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 cotscore=-2147483648 suspectscore=0
 spamscore=0 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 30 May 2020 10:16:22 +0200, Christophe JAILLET wrote:

> 'ret' is known to be 0 at this point.
> So, explicitly return -ENOMEM if one of the 'ecardm_iomap()' calls fail.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: acornscsi: Fix an error handling path in acornscsi_probe()
      https://git.kernel.org/mkp/scsi/c/7960c0b29626

-- 
Martin K. Petersen	Oracle Linux Engineering
