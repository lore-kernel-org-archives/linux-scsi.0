Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD97C54E8D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB6D20757
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AXlgQxqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgELD3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:29:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41102 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbgELD3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:29:18 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3N1eQ130551;
        Tue, 12 May 2020 03:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Dh8mcI1FRbOqvThp8JBTTIWPo7UnuPp94mhHgvE9ml4=;
 b=AXlgQxqho9s76F2hV/dhN50fd8nbl07sqQQgYbjjC39V3hnlwU722G1ai8Kf2GYFtOtM
 iF1IDrNxnNmXt0WL6gZwjzB/PAODNkYis9X1sNhuKbuoNldcdM1G7K7BAhPgLIs8ooOM
 My2gmz/iYBsGBNvWFVynocQKmBLqCm1DHNees0h+QTlY/Qoov0KAIW6BL+jRdgC3Bn7w
 qrND9EbYawfWzu/XbCO2KBgV0QywevsAtkTCM5EfzuwoGm0WP+CPt5I8oADYOtDecCDQ
 756wfeVYeECAteR19ViJ+Y7UH7a1lNKWrGLjb3eEhtguZaU/vnOFNUB1d20VL5mWVfDK Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30x3gsggpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:29:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3MUdf015978;
        Tue, 12 May 2020 03:29:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30xbggtnjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:29:12 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C3TAdD007328;
        Tue, 12 May 2020 03:29:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Mon, 11 May 2020 20:28:40 -0700
MIME-Version: 1.0
Message-ID: <158925392373.17325.9006412341355835743.b4-ty@oracle.com>
Date:   Tue, 12 May 2020 03:28:27 +0000 (UTC)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     nab@linux-iscsi.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] target: loopback: fix READ with data and sensebytes
References: <20200428182617.32726-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200428182617.32726-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1011 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 20:26:17 +0200, Bodo Stroesser wrote:

> We use tcm_loop with tape emulations running on tcmu.
> In case application reads a short tape block with a longer READ,
> or a long tape block with a short READ, according to SCC spec
> data has to be tranferred _and_ sensebytes with ILI set and
> information field containing the residual count.
> Similar problem also exists when using fixed block size in READ.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: loopback: Fix READ with data and sensebytes
      https://git.kernel.org/mkp/scsi/c/c68a56736c12

-- 
Martin K. Petersen	Oracle Linux Engineering
