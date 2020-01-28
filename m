Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AD6C35240
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 03:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 703C52467F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 03:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I7E+XagI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgA1Dri (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:47:38 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53410 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1Drh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 22:47:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3hbOQ171973;
        Tue, 28 Jan 2020 03:47:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Ax236AQfU2t8uiC5gmz7fwYFm6ebB0n/VDPETNEKVc8=;
 b=I7E+XagIM38iCzOjAVZjVZ3x8jpT6dIzlxGqN5i7e/KtUIu21uALBFvvllHI0JR/52gi
 gt/XvmsJzG/kqh+gaRRI6FZ/EW9eCXf3aBAsyMHgXTdXvjK2k7phSPey+3plAIfju3wK
 NjGLehl17OLHVioxuVHNLeXJMeE37fEqENmiWWhMQsvW0CGelIMKjP7F4Af3c0XuEh0k
 LM17d8VcbVsbq76i3cpZ+CSja5XabrQd4/dyRA2RcOrOJ2JvwcwvnOHrBFSZ8SlrrFHa
 az/7CB1GUro66dsE7jTQYxY81m1dw/XcdDQ9Ol6kpFOnuq5VzGGlp0YoaYFL5iFXUtog VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xrdmqbeap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:47:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3iEkX052190;
        Tue, 28 Jan 2020 03:47:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xryuart86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:47:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00S3lEhY000571;
        Tue, 28 Jan 2020 03:47:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 19:47:14 -0800
To:     Hannes Reinecke <hare@suse.de>
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] megaraid_sas: fixup MSIx interrupt setup during resume
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200113132609.69536-1-hare@suse.de>
Date:   Mon, 27 Jan 2020 22:47:11 -0500
In-Reply-To: <20200113132609.69536-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 13 Jan 2020 14:26:09 +0100")
Message-ID: <yq18slsb5ts.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=814
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=893 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280028
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> Streamline resume workflow by using the same functions for enabling
> MSIx interrupts as used during initialisation.  Without it the driver
> might crash during resume with:
>
> WARNING: CPU: 2 PID: 4306 at ../drivers/pci/msi.c:1303
> pci_irq_get_affinity+0x3b/0x90

Applied to 5.6/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
