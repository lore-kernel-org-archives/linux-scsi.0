Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F96C3A5A0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E703720644
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:15:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I4YyXjCV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfHTCPb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 22:15:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbfHTCPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 22:15:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K2DYHV137953;
        Tue, 20 Aug 2019 02:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=BAsZplUs2QVDnNPiQV39c8xdsSfJTbxmvLjYR/dP1zE=;
 b=I4YyXjCVJnotf5d0N5SjU1KWpKOnl6QFfAwy/2zhG7Bt1hbln67xdXzmqerOGQ69W7Me
 iJSXzCaj9ww+ivCk3pep5AqrBkHxkipPNM1JBgVsGc8d/CeuIfwcJLGDrnp1sa4W1zwd
 caVxN4YmzygH42CmF6/dtiOUDNzJzaTF91O2QhGmy5K1/DaG7t3eIy1ZeGP4850lWAE3
 SDJOmPV5h2XuJFKCdMkytjEWHkECZihK1vS5kqvgy7ZoNj+AO6uuxuemwENPybbrEYEW
 xURo4W/1vHz/7vcRBeYBS/GbtkvRyrKTwyiO3LTvSeYBJno23ZvhxEPEqeMKh79jB766 vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ue90tb3eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 02:15:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7K2DOpo061231;
        Tue, 20 Aug 2019 02:15:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2uejxetd0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 02:15:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7K2FPeJ007312;
        Tue, 20 Aug 2019 02:15:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 19:15:25 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH v3] lpfc: Mitigate high memory pre-allocation by SCSI-MQ
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190816023649.16682-1-jsmart2021@gmail.com>
Date:   Mon, 19 Aug 2019 22:15:23 -0400
In-Reply-To: <20190816023649.16682-1-jsmart2021@gmail.com> (James Smart's
        message of "Thu, 15 Aug 2019 19:36:49 -0700")
Message-ID: <yq14l2czio4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=517
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=584 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> When SCSI-MQ is enabled, the SCSI-MQ layers will do pre-allocation of
> MQ resources based on shost values set by the driver. In newer cases
> of the driver, which attempts to set nr_hw_queues to the cpu count,
> the multipliers become excessive, with a single shost having SCSI-MQ
> pre-allocation reaching into the multiple GBytes range.  NPIV, which
> creates additional shosts, only multiply this overhead. On lower-memory
> systems, this can exhaust system memory very quickly, resulting in a
> system crash or failures in the driver or elsewhere due to low memory
> conditions.

Applied to 5.3/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
