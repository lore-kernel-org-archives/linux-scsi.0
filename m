Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE58C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D1224671
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 04:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LFXdufTf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbgAPEJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jan 2020 23:09:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgAPEJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2020 23:09:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G48PFC115378;
        Thu, 16 Jan 2020 04:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=U2BJiam1MiRMZ/JXp/7NvE4tKiHG+O1DbM3WpMWeI4c=;
 b=LFXdufTfH6kWDbrzQcU757xJsB0/F1EWA55I6HHPFx4LEWfoPvb3IFUD3Geug72Vqfq0
 WaJG0NinEq9Pt+LvfS1tgE0OwSsCgdLhqUQ3cer/Z4PKxlDQua6iPKAfDumXSK1+Gyq4
 5P7kdr9iRuOLRw/71iIG2SZxRS+cchSXoknpqw6SP3adW2uJ1ZiBWRNMaddqzFfgQb1v
 dK58efOqGGadcEUtaN/XTMt9G+IhxDPR7YournLurkX9BWJLNVBJ4tm8G/8O+3LUWUPg
 lhWzk9lsoKp+txm2zGXFxi8TuLnOBFC/eA6xBDUO+pl5XGjakeeiOI0k7E2+sZ5lg1fB Tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xf73tyyyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:09:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00G49ANj186069;
        Thu, 16 Jan 2020 04:09:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xhy22jf15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 04:09:38 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00G49a2p026557;
        Thu, 16 Jan 2020 04:09:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 20:09:36 -0800
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla1280: Fix dma firmware download, if dma address is 64bit
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200114160936.1517-1-tbogendoerfer@suse.de>
Date:   Wed, 15 Jan 2020 23:09:34 -0500
In-Reply-To: <20200114160936.1517-1-tbogendoerfer@suse.de> (Thomas
        Bogendoerfer's message of "Tue, 14 Jan 2020 17:09:36 +0100")
Message-ID: <yq18sm8nitd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001160032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001160032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Thomas,

> Do firmware download with 64bit LOAD_RAM command, if driver is using
> 64bit addressing.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
