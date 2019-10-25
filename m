Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFCACA9EAF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D0C521929
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:04:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H9/WkHwZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbfJYBEF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:04:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388427AbfJYBEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 21:04:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P0woH8104265;
        Fri, 25 Oct 2019 01:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=vpBgmSaXlndyFSVRotSDv7rKCKgNUjLsCEd9ZH/kU+o=;
 b=H9/WkHwZvimHyzk/1Qzucl8OC5XXeRcvuZ0iP9acn6y0iHyTgRf0UGSsoy95ZeHkCbUu
 jhFVFRSeSktJDIW4H4r67i+2sCkYrlh+m5f9+uKu2yzYibEASb2AKWTr0bmVtyzp0EKO
 tG6jYj79YGezZP2J7NhHlH7BuDAsOzwzni1phKnYw0SSs9fSqucZI+boAai6PD9IwJXI
 yz5vswymibTmmLn4jhlrUpiuWS97ApWTsGkIVBbq4o6XBGcW2I0O4YN2xW+qXnoEuzD6
 mrJNHqrV8KY0PzgFCK/chEwVH1knyawE2yVAA+GOvuJCcktVxNUFxdRjU/IotmOjF+eh +w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4r6xp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:04:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P13IJJ156168;
        Fri, 25 Oct 2019 01:04:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vunbk5ert-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:04:00 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P13xxd016570;
        Fri, 25 Oct 2019 01:03:59 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 18:03:58 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 02/16] lpfc: Fix reporting of read-only fw error errors
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191018211832.7917-1-jsmart2021@gmail.com>
        <20191018211832.7917-3-jsmart2021@gmail.com>
Date:   Thu, 24 Oct 2019 21:03:56 -0400
In-Reply-To: <20191018211832.7917-3-jsmart2021@gmail.com> (James Smart's
        message of "Fri, 18 Oct 2019 14:18:18 -0700")
Message-ID: <yq136fhd4ar.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=867
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=966 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

>  	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
>  	     magic_number != MAGIC_NUMER_G6) ||
>  	    (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G7_FC &&
> -	     magic_number != MAGIC_NUMER_G7))
> +	     magic_number != MAGIC_NUMER_G7)) {

These magic numers[sic] caught my eye.

-- 
Martin K. Petersen	Oracle Linux Engineering
