Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56838C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 03:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33F2620672
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 03:24:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="akTl6nwA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgF3DYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 23:24:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbgF3DYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 23:24:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05U3JD6e094775;
        Tue, 30 Jun 2020 03:24:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=tHcsctLShGc0MewAnGOiNtrNdlmfdFfD+isACDi2aFE=;
 b=akTl6nwAVZHMIQmjnt5nDqZzHINncO59YDCJDJ1aFtfsL2z8bVz2oxi/s/yXWPhDjRQ/
 /XhGZqXo56BR7dhxit0HSzfUG/X+f12UT/8Q0nD12vdow93NBpmL7cCYqES9InQEKXv6
 Y7YHch0GQKmUIgj2l1qYqjd6lBRRsJjQbeJAhVfqMz7NC93Hs/pc04v39/KhIUApr0EN
 j+0MKY2iqg5PfRm5IAV76t+SBGeyxjSBxiVh2GsKm0xJsa2DRh9kJW8fxdWAbmspH2Ka
 LlC5Ww4ABgcausxk0ddU3MNxBalo8nBRzriWcyiVqgAb38rTKwsEInyfuREe7j8/Kovy Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn1pdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 03:24:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05U3JiMx056952;
        Tue, 30 Jun 2020 03:22:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31xg1w0vrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 03:22:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05U3MaE5001771;
        Tue, 30 Jun 2020 03:22:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 03:22:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, "trix@redhat.com" <trix@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_spi: fix function pointer check.
Date:   Mon, 29 Jun 2020 23:22:34 -0400
Message-Id: <159348733080.22223.9799555482060499948.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627133242.21618-1-trix@redhat.com>
References: <20200627133242.21618-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Jun 2020 06:32:42 -0700, trix@redhat.com wrote:

> clang static analysis flags several null function pointer problems.
> 
> drivers/scsi/scsi_transport_spi.c:374:1: warning: Called function pointer is null (null dereference) [core.CallAndMessage]
> spi_transport_max_attr(offset, "%d\n");
> ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Reviewing the store_spi_store_max macro
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: scsi_transport_spi: Fix function pointer check
      https://git.kernel.org/mkp/scsi/c/5aee52c44d91

-- 
Martin K. Petersen	Oracle Linux Engineering
