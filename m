Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114ECC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CADE82082D
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Px22ismm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgC0Cfv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:35:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0Cfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 22:35:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2XGRc014848;
        Fri, 27 Mar 2020 02:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=TcflEB1nn4JpAkOJpFTM6eXidFcVUIfenxu8Wace94A=;
 b=Px22ismm/MyUZ4zFD3Mi/CoiPGjH5X5aGlQxQW47EYFvf/qfDJ1zhaBoRHYOcXnpCxfl
 LR7uZX2o28f/yEOlTdamNDszXX7cROmw++q841PhzJQRXlUroXnxoDW+xjE8XaxXkXmL
 JP9ERhCMGSrqVv8pang86CZSRsOIRbJgSyLZVKZ9WRqdg65sEBqbfXe9OR6FFDuXAfww
 welEq7t5YWZJKRUGw2BmYAaCbbcWeqtEn/7EhHrXmBWAz9TkCH/9H8UPUGCYispHtvYW
 dTJzPL2jwqnuL5/bGUkPVhMS8M9SeQa7d4ZfWekcDaR8SFiNXouyFo+xPGfClSzveOJf QA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3014598q28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:35:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2XDm9092331;
        Fri, 27 Mar 2020 02:33:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30073f7g5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:33:40 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R2XcDH027607;
        Fri, 27 Mar 2020 02:33:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:33:38 -0700
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     target-devel@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, ddiss@suse.de, mcoleman@datto.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] Fix a race condition in the target driver
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200313170656.9716-1-mlombard@redhat.com>
Date:   Thu, 26 Mar 2020 22:33:36 -0400
In-Reply-To: <20200313170656.9716-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Fri, 13 Mar 2020 18:06:53 +0100")
Message-ID: <yq1bloiedbz.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=782 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=859
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Maurizio,

> Multiple threads may try to destroy the same iscsi session structure
> by calling iscsit_close_session() and then end up hanging.
>
> This patchset modifies the driver so the session structure is
> destroyed by iscsit_close_connection() when the last connection gets
> closed, thus preventing the race condition.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
