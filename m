Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C3EC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4E1320714
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 02:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TuF4/TAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgC0Cjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 22:39:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0Cjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 22:39:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2djkb104276;
        Fri, 27 Mar 2020 02:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=g2DM3voZIITkDCmYy1BIG4B5rGYL7atbyZwe+H76jDo=;
 b=TuF4/TAPTbkgo8rqeqrn1NjQBWUYcJuC3E9kY4Y4Om3MJYTs8icLmMsJWv1UG8LBy3kz
 MOI6v2AzNdCXUPNVHmU7vmIjICObvuY//pi1D/L/hBqF8VMjEUtSgGbMnhWmgfsLGwx8
 mqPDgDEwVXWRrlMkRC9PQvFVLqQiuURdZSPgzSeY43e1UL/6tF2aMlU269zMSqTAJXrC
 IS25iJa0QcCGkwF5es4sYGFfqWv/GJXZDs8KcFvuD4DolK/4/r8cW7Oub+vimo6QLqMM
 wgLA75KvdGJkg4v5oiYwdXk+g/1zb2upYt9L2OXEqBBKNdsIfoSVUYGJWyWw7zv9eK4S bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3014598q8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:39:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R2d7HA061101;
        Fri, 27 Mar 2020 02:39:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2yxw4uug1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 02:39:45 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02R2diC9022360;
        Fri, 27 Mar 2020 02:39:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 19:39:43 -0700
To:     Manish Rangankar <mrangankar@marvell.com>
Cc:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/2] Add MFW recovery and PCI Shutdown handler.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200319083811.19499-1-mrangankar@marvell.com>
Date:   Thu, 26 Mar 2020 22:39:41 -0400
In-Reply-To: <20200319083811.19499-1-mrangankar@marvell.com> (Manish
        Rangankar's message of "Thu, 19 Mar 2020 01:38:09 -0700")
Message-ID: <yq1369ued1u.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=983 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Manish,

> Please apply the following patches to the scsi tree at your earliest
> convenience.

Applied to 5.7/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
