Return-Path: <SRS0=D4W/=WL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EACC433FF
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 01:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830D5205C9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 01:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jn8SihK1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbfHOBvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 21:51:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfHOBvh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 21:51:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7F1huMJ070502;
        Thu, 15 Aug 2019 01:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=+wgQy2jjT5eVEZE1FeEQ5FCqvnSvPCQEDuyow2ZE6BE=;
 b=jn8SihK1NcI7y5uKl/11vxs5/Tmb8SpDbv41/ebK7auqASzyWGB7bcTuN17C2+sH571T
 YANwzT+lV72dyuVKLSWSPhfhrkDITl/tsvWEjbWaXoNgnsBzv0uJH9Nv7dJL1Crxkx+M
 T+6g7A038XCw0GnKwB4zjuab/xzQZmzNy3rv63CE9jvPcM8q5ov3z2d2u8ARF0ugILaA
 qWa202hU8UFCwATfOyTaTUgcGOz+VCCK7ETe8H6MxTRh5F2xMPM46WivUDED8mW7qwur
 0t1WICs9PGxR8zEIetZgT3gFgV2FIzh89o9dJCLtMZ+zAU6vX5m4C0C9kd3IffeX0c+i 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbtr7f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 01:51:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7F1mMHF058669;
        Thu, 15 Aug 2019 01:51:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ucgf0fnac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 01:51:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7F1pT9W029580;
        Thu, 15 Aug 2019 01:51:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 18:51:27 -0700
To:     Bill Kuzeja <William.Kuzeja@stratus.com>
Cc:     <linux-scsi@vger.kernel.org>, <qla2xxx-upstream@qlogic.com>
Subject: Re: [PATCH RESEND] qla2xxx: Fix gnl.l memory leak on adapter init failure
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1565792681-9641-1-git-send-email-William.Kuzeja@stratus.com>
Date:   Wed, 14 Aug 2019 21:51:26 -0400
In-Reply-To: <1565792681-9641-1-git-send-email-William.Kuzeja@stratus.com>
        (Bill Kuzeja's message of "Wed, 14 Aug 2019 10:24:41 -0400")
Message-ID: <yq1lfvv2o2p.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=479
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=546 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bill,

> If HBA initialization fails unexpectedly (exiting via probe_failed:),
> we may fail to free vha->gnl.l. So that we don't attempt to double
> free, set this pointer to NULL after a free and check for NULL at
> probe_failed: so we know whether or not to call dma_free_coherent.

Applied to 5.3/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
