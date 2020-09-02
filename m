Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCABBC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 01:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEFDB20707
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 01:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eQ9q1Uyy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIBBWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Sep 2020 21:22:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBBWx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2020 21:22:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0821J9a3061241;
        Wed, 2 Sep 2020 01:22:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=d2A/fakPT8AvXHlc10w6SP/dKYZddFmLCUQoXWCKYhI=;
 b=eQ9q1UyyTxQIdRzS77ffkMWeqgouJabgfmTIGV5vaP/zCJRUU1GoPK+CjzKs7sTByp5o
 r7Ck+duKpX1obYuAO5ErMDhDwVzx04DQvEDm2EAujm0vXMtWus5zE5wxPv/xXS8tY6RO
 QKpSjz7hqQ1zdCtvjI9DQAq9jhJWWtLndrqxylsr6SQwt37X2/Ldp3/Z/+CnJX3OOusB
 +HkMo+USjJ641ha7ehYIZL2iVKsSGh04UbuLV5TO46tO1a3FM5skGsoKccnCYRd8oxQF
 k0wNSThLH8cT5yvUU7XbEc3JAjwMNkNHqJdpWyh01frAR21+smtK0MgnJ5gAb6igB2OV TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 337eeqyndu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 01:22:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0821Kb2Z095669;
        Wed, 2 Sep 2020 01:22:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3380x51ts1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 01:22:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0821Mkc3025912;
        Wed, 2 Sep 2020 01:22:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 18:22:46 -0700
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, njavali@marvell.com
Subject: Re: [PATCH v2] scsi: Don't call memset after dma_alloc_coherent()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1eenlezwf.fsf@ca-mkp.ca.oracle.com>
References: <20200820185149.932178-1-alex.dewar90@gmail.com>
        <20200820234952.317313-1-alex.dewar90@gmail.com>
Date:   Tue, 01 Sep 2020 21:22:44 -0400
In-Reply-To: <20200820234952.317313-1-alex.dewar90@gmail.com> (Alex Dewar's
        message of "Fri, 21 Aug 2020 00:49:52 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=810 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=830 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

> dma_alloc_coherent() already zeroes memory, so the extra call to
> memset() is unnecessary.

One patch per driver, please.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
