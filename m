Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0B2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99F1B20873
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KDR0Kg/K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgE0CNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49984 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgE0CNX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2BbDG092037;
        Wed, 27 May 2020 02:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HTXrVGcSEAZfLtvFJ32MgdXboXlq1++co83zpqQMo4M=;
 b=KDR0Kg/KxxT0ypP5vezqlKQs+IX2wZah8Cg5+KtkLukgOaovTRQda3Dz+gYfpn1xXUVU
 TjnwUQ50sIIaE1b9CUCECgTS9Hho5FQ25CqNLhASr1+SNL5Y6yd0wvQpZNdnW+inSLn/
 Gn8ynP4nrbmqKSlUgjhtCkXgxFQ1NJ9BXs1OiOJ6qXWx5/PzplNmTOG5DSuHN9otZVfp
 mFtOIt6NRNF6sMsxL0oOqqhjA0LQhGMoFAxpa2dxmeAZFb3El4LFkGHPO/p5ceb7zuGX
 kSBjO3YW46uSMWP5INKcocmm55F5VIbxML+MqF4JV9Vg3mmFhr3JUgKghgWTPGkz06mX wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8qvxha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27ZrJ190198;
        Wed, 27 May 2020 02:13:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 317dktheg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:13 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R2DCQp017242;
        Wed, 27 May 2020 02:13:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:12 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Khazhismel Kumykov <khazhy@google.com>, cleech@redhat.com,
        lduncan@suse.com, kernel@collabora.com
Subject: Re: [PATCH v2] iscsi: Fix deadlock on recovery path during GFP_IO reclaim
Date:   Tue, 26 May 2020 22:12:58 -0400
Message-Id: <159054550935.12032.12429490681572583579.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520022959.1912856-1-krisman@collabora.com>
References: <20200520022959.1912856-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=982
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 19 May 2020 22:29:59 -0400, Gabriel Krisman Bertazi wrote:

> iscsi suffers from a deadlock in case a management command submitted via
> the netlink socket sleeps on an allocation while holding the
> rx_queue_mutex, if that allocation causes a memory reclaim that
> writebacks to a failed iscsi device.  Then, the recovery procedure can
> never make progress to recover the failed disk or abort outstanding IO
> operations to complete the reclaim (since rx_queue_mutex is locked),
> thus locking the system.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim
      https://git.kernel.org/mkp/scsi/c/7e7cd796f277

-- 
Martin K. Petersen	Oracle Linux Engineering
