Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E58C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67BB8207D3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xjc+KQvQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgE0CNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgE0CNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2CAGj057411;
        Wed, 27 May 2020 02:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=htDXYTJoz9m6N/9b0zVKzXQMGg7hWLaW1feSs1VNM5I=;
 b=xjc+KQvQyzSrH9aQV7SFWrMvePF57DDccAi0nauv/mcQUWQEGlu/7qrD3Zy77G445u5r
 ik8IHtr63gmhqMlq60pN98MVrxVZsBIRxrEdbOJDP9P2pu5ebjr6NUJ3TC6FFWjvRwjE
 nmX0uPk6CH7sxJZ6fQ71iKJMo5dKGt+xhIJcTCfMwjGpgTc/k09S60tEnsR4hGbtqN/l
 8JZ+fnNo4q66G/ZcfjcluE8NGblDwTEY4XvNschjHfPYuZHX7B69xAZeGlPQqzOv5Qjd
 poKUJ+vPdQU+9RuL5WTpZGdWPcZ1fN2ipjvRLY9OYwUwpef+1zaCaEqpSeC3D65OLMhY MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 318xbjvym3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27ZdN190108;
        Wed, 27 May 2020 02:13:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 317dkthef7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:10 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04R2D8Zt024038;
        Wed, 27 May 2020 02:13:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:08 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Karen Xie <kxie@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: cxgb3i: fix some leaks in init_act_open()
Date:   Tue, 26 May 2020 22:12:54 -0400
Message-Id: <159054550935.12032.3078033061151944751.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521121221.GA247492@mwanda>
References: <20200521121221.GA247492@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 May 2020 15:12:21 +0300, Dan Carpenter wrote:

> There wasn't any clean up done if cxgb3_alloc_atid() failed and also the
> original code didn't release "csk->l2t".

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: cxgb3i: Fix some leaks in init_act_open()
      https://git.kernel.org/mkp/scsi/c/b6170a49c59c

-- 
Martin K. Petersen	Oracle Linux Engineering
