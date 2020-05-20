Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EFEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 01:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000B320708
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 01:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UlR6Styq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgETBMr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 21:12:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58902 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgETBMr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 21:12:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K13Opm014431;
        Wed, 20 May 2020 01:12:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=DDJLlwCiLhFC3/Wb8r1rQs4kSpy9ZrmNePn9KXOqaOE=;
 b=UlR6StyqY4yCSHzzFydH9cDekhXTbj/pBCoBJRiJX5/r7+UE020Mz7nDyacTJieMZGKL
 HTMue2bRWhJudWawpOwJ0kA/q+MegQpaOJBbnHWHjEceoZiX9ztpKmyaOtUhQHB7r/lS
 ADsXbd8N5SIq6TvbmyuurIkuuLXw8VYA1vdtLShs6VeLhx1a5NaOJZIX/i7u2Y/dBmQG
 fadScUJ5GqjOaIzGTDGAMUWWHkdDNX6Ai+N5gPWsiT7dkR/neMmGd2gH0qCMeycgCN1i
 JT24/4rPykJbKadXw3Pb9gbrEibVyfGPaiPJJezdVSCNvrSmV0STTwNxjfTsTpUhyvi3 fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tngcsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:12:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K193BA042026;
        Wed, 20 May 2020 01:12:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t35w6vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:12:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K1C3Au024694;
        Wed, 20 May 2020 01:12:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:12:03 -0700
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        kernel@collabora.com, Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH] iscsi: Fix deadlock on recovery path during GFP_IO reclaim
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1imgrwgu7.fsf@ca-mkp.ca.oracle.com>
References: <20200508055954.843165-1-krisman@collabora.com>
Date:   Tue, 19 May 2020 21:12:00 -0400
In-Reply-To: <20200508055954.843165-1-krisman@collabora.com> (Gabriel Krisman
        Bertazi's message of "Fri, 8 May 2020 01:59:54 -0400")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gabriel,

> iscsi suffers from a deadlock in case a management command submitted
> via the netlink socket sleeps on an allocation while holding the
> rx_queue_mutex,

This does not apply to 5.8/scsi-queue. Please resubmit.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
