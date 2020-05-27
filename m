Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F631C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED722075F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O6FlQD7L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgE0CNm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50224 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgE0CNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2BwRM092146;
        Wed, 27 May 2020 02:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=rchfVBrv2XYFl9MmizvD9dJ1b2qOdeSgyrQhOTaDICQ=;
 b=O6FlQD7LCOtmjxuCWgoDu/2MFkC4IxdKNjo+d80OMt0t+wx5x8Yen25tfrQr4iKc1iJ8
 +ppYG5p25/D/YH/P9uFn9n3f4dgBktBt42rtJoAMucxKOThl2hi7Cc5sa4xfB/eCKWxZ
 SPyZ+iMC3vB1NMdQYlBUoFvxT9hIDqk5QEXDwHggxLXikVxo9VS58iacggPQTGf+yiZT
 v3S8yAxD2CF1l07laLI4Uupi6zTaIAQw6UDr7SuMQoXBsUS4YVxrYgn+SzbxxDKUGQYy
 HpVsEqhEGrge/zc4lN7KXUAJ/ZQ6VUe/MqJf2fcmeBYWkCKvsqDp3ktfqrLNhiX2MPJT Rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8qvxhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2DYA6035205;
        Wed, 27 May 2020 02:13:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 317dkthek7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:35 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2DHbY020391;
        Wed, 27 May 2020 02:13:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:17 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes
Date:   Tue, 26 May 2020 22:13:02 -0400
Message-Id: <159054550935.12032.792833550422424331.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526100340.15032-1-vigneshr@ti.com>
References: <20200526100340.15032-1-vigneshr@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=924
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1011 mlxlogscore=973 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 26 May 2020 15:33:40 +0530, Vignesh Raghavendra wrote:

> Fix unwinding of pm_runtime changes when bailing out of driver probe due
> to a failure and also on removal of driver.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes
      https://git.kernel.org/mkp/scsi/c/22617e216331

-- 
Martin K. Petersen	Oracle Linux Engineering
