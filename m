Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42E0C83003
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 02:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF17720787
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 02:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w4SlvUS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgD3CSN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 22:18:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43264 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgD3CSN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2020 22:18:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U2HQRp089938;
        Thu, 30 Apr 2020 02:18:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=B6Qt+C4e6Lwe8ywTSAXKjW5qP239KNhknMulEi56OQ0=;
 b=w4SlvUS7Wfb1/QHIj6xWw8/MfYVN9zQJmeeURufPLvcZ5HghhKzn4aIyEj5InVQIlQM5
 JEVjX7qK4qRqZRDicj0P35PCpL871xOq5Si0UneUvjXP7Ne4N/XP2iDn1wF97waNt2Dg
 r1PCULcWJz//vhcJ35q/46qNS2naj54GITRp8Wq63E4RrXlcg9iDs5VhWAfvsdAHz09N
 rkUEgO7XBa6p/2Vp0c8zE2/XvmFWtLk1kCtwNSpSHdg/yOOVC0PDdc8bnJlGgjV1X1pD
 89EsgwcKJQthuGkd660IFBRHO6PcvP7Z8To6YLa1x7cckP1HYkChUUDXyqJVlEhe2Ncm BQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30p2p0ebjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:18:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U2I7jD114331;
        Thu, 30 Apr 2020 02:18:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 30mxrwcya6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 02:18:08 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U2I65c020262;
        Thu, 30 Apr 2020 02:18:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 19:18:06 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     QLogic-Storage-Upstream@cavium.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Rangankar <manish.rangankar@cavium.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: Check for buffer overflow in qedi_set_path()
Date:   Wed, 29 Apr 2020 22:18:02 -0400
Message-Id: <158821297687.28621.14243735902827937785.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428131939.GA696531@mwanda>
References: <20200428131939.GA696531@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=799 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=854 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300014
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 16:19:39 +0300, Dan Carpenter wrote:

> Smatch complains that the "path_data->handle" variable is user
> controlled.  It comes from iscsi_set_path() so that seems possible.
> It's harmless to add a limit check.
> 
> The qedi->ep_tbl[] array has qedi->max_active_conns elements (which is
> always ISCSI_MAX_SESS_PER_HBA (4096) elements).  The array is allocated
> in the qedi_cm_alloc_mem() function.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qedi: Check for buffer overflow in qedi_set_path()
      https://git.kernel.org/mkp/scsi/c/4a4c0cfb4be7

-- 
Martin K. Petersen	Oracle Linux Engineering
