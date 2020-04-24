Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C3CC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 17:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCEF12071E
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 17:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ER0dxUHz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgDXRJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 13:09:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgDXRJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 13:09:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OH2YEa098278;
        Fri, 24 Apr 2020 17:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=YpQd0PaafIECwaO8K9kUsTtlDnIkdSver9in3iWEF+o=;
 b=ER0dxUHzHmmSl+B69L+TI/tSXQsl64XaD5ai1+0RzyWu6XjzGPj89aNP+2Fx+PwsI2Bt
 cozeKekZ5WKjynkS0JgkmlZFkJpn1lU68riVK3Yvv06oBTOk3VDWBQEq30zDhiF1dLVz
 5aCRYHcf3I77z4r8NP7LjbOtTqHolqbtzX+ODKHX/UgckupXavW/mXu3nECQZQRlS4nG
 v1TRUUWgPo7tuLagOtcNhUPhddy+vjE9Wfn83y3/D0XaLmJkuGXpwMuQN0ON5oPEprPl
 8F845BwtcxmFgjc4uJWBvdU7sH4FTNzpuJT25PTVvlG59d9lo6prF9ys5He7KVQZQqUx rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30jvq528jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:09:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OH8Wge185858;
        Fri, 24 Apr 2020 17:09:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30gb1q5a99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:09:07 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03OH96pO011786;
        Fri, 24 Apr 2020 17:09:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 10:09:05 -0700
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [v2 0/5] mpt3sas: Fix changing coherent mask after allocation
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Date:   Fri, 24 Apr 2020 13:09:04 -0400
In-Reply-To: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu's message of "Thu, 23 Apr 2020 03:23:11 -0400")
Message-ID: <yq1a730erpr.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=609 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=668 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240133
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> * Set the coherent dma mask to 64 bit and then allocate RDPQ pools,
> make sure that each of the RDPQ pools satisfies the 4gb boundary
> restriction. if any of the RDPQ pool doesn't satisfies this
> restriction then deallocate the pools and reallocate them after
> changing the coherent dma mask to 32 bit.
> * With this there is no need to change DMA coherent mask when there
> are outstanding allocations in mpt3sas.
> * Code-Refactoring

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
