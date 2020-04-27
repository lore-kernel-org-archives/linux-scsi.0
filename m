Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55635C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7422073C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yeqMK6z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgD0UVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:21:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35762 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgD0UVn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:21:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKJOMt141290;
        Mon, 27 Apr 2020 20:21:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=KvoLYPKdd283izgHcgAFyVVKUQcRl8gnYCXvI/MjoeQ=;
 b=yeqMK6z8xlcuHiUKdz0/v2Lw+CcTa0mser5C29+zrLCIzhrjgjg0RkMzMSPhLAHFrcHj
 sv49PpUAbdsKvWA73K3DHNq53vUA6Kdm/5nNzNm/X6nCGfBK949WRDS2v7c1SFPniUNB
 zmlKNSFlQoojdRP6bLf6uMF3FEFYuD0ax9jvGXY9Jy7QRlIASUvm1GuPjP6GNqyYLoDP
 zUUanso04iIjW4V12mgpyAiYf+ABu2hNT60aFAyAGogz5dkN+g9v9BkriFjOWJfN9jjs
 ggfY7ZQ7HPjPpQHXZtpjeEVuwTUX11Dlz5YtUPF7y+335NeRis4irIgPVDeby+kwcXZx jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 30p2p01a2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKBpff060248;
        Mon, 27 Apr 2020 20:21:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30mxwwwfxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLYNX004218;
        Mon, 27 Apr 2020 20:21:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:34 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: bfa: Remove set but not used variable 'fchs'
Date:   Mon, 27 Apr 2020 16:21:23 -0400
Message-Id: <158777063305.4076.8196764911288464111.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200418071057.96699-1-yuehaibing@huawei.com>
References: <20200418071057.96699-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Apr 2020 07:10:57 +0000, YueHaibing wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/scsi/bfa/bfa_svc.c: In function 'uf_recv':
> drivers/scsi/bfa/bfa_svc.c:5520:17: warning:
>  variable 'fchs' set but not used [-Wunused-but-set-variable]
>   struct fchs_s *fchs;
>                  ^
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: bfa: Remove set but not used variable 'fchs'
      https://git.kernel.org/mkp/scsi/c/0745c834f793

-- 
Martin K. Petersen	Oracle Linux Engineering
