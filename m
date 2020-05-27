Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75465C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51A85207D3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="joKUyMLQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgE0CNV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgE0CNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2CpWr165328;
        Wed, 27 May 2020 02:13:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cgNhwBL0YxsJOuzda5stp0OuW/YIWB10RY3uXefOsj0=;
 b=joKUyMLQ54tlB5puXcZGVEJ/OJR/ObY0xhlTWIz11DE9Cd157j+WlfBfNH8MIbZ8Grbf
 iVm/KT0gElWDUszkQyWJf3eQwm7tU3QB/jqxySZMY6foV6JU5aFta4ObtXiew4z2y/NQ
 7lehI37yw8XlztPyNb11QzSkXxvsPqt4jrOTashkLPksjEhturRYr/VC01YPqEpSsl/M
 zm9VzQFqAFPenz0hNEaPobXtQmTvVA2SaUdF3pNCh+chrZbmb2UJ5/fFzVJUbXv1/B7C
 mnTFeZ64LdvdrRKUYG/PLBtKRFFHzP/8WzuChwenetU5B9rBp/jevsbWrYaMiIEjYi2I PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 318xe1cxvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27XJO133227;
        Wed, 27 May 2020 02:13:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 317j5q908t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:15 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2DFe9017249;
        Wed, 27 May 2020 02:13:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:15 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jasowang@redhat.com, shirley.ma@oracle.com, mst@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com
Subject: Re: [PATCH 1/1] vhost: scsi: notify TCM about the maximum sg entries supported per command.
Date:   Tue, 26 May 2020 22:13:00 -0400
Message-Id: <159054550934.12032.480617639517233845.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=978 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 22 May 2020 16:51:57 +0000, Sudhakar Panneerselvam wrote:

> vhost-scsi pre-allocates the maximum sg entries per command and if a
> command requires more than VHOST_SCSI_PREALLOC_SGLS entries, then that
> command is failed by it. This patch lets vhost communicate the max sg limit
> when it registers vhost_scsi_ops with TCM. With this change, TCM would
> report the max sg entries through "Block Limits" VPD page which will be
> typically queried by the SCSI initiator during device discovery. By knowing
> this limit, the initiator could ensure the maximum transfer length is less
> than or equal to what is reported by vhost-scsi.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: vhost: Notify TCM about the maximum sg entries supported per command
      https://git.kernel.org/mkp/scsi/c/5ae6a6a91503

-- 
Martin K. Petersen	Oracle Linux Engineering
