Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C5CC433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61FB2067D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 20:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xgv/D8j3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGOU0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 16:26:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44752 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOU0l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 16:26:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKMCqn138840;
        Wed, 15 Jul 2020 20:26:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=mimElBGzRy++HHr8M1BmEAFebpsIASVMSvpGFuvyC9o=;
 b=xgv/D8j35MegC9dWwKwQATBSnLryPKBXKAwk1HfXq182J38cdJ6K8crPsqnDB3LGgfBq
 4g4eqr25nVdNCtX3CyYw4KONNY1NuZW2dwsJfufzcJkz41uwhgqRzvnYnn5RYc2nQLrz
 FW+nFFSrhXzvWZaT4FTjboCoOrRoUlA0XaMlKfXAGez2TAz1NH4Dt5SWjMbhr9toaGRO
 v1rqgtQuAQWExJtOo91GmyJatymfAcKdew1SncwCrL1k3aTOVhnDO/zClQTpkLEDPPNj
 naUH0GAgJvcbqK9XH+mvZg7sLjrU2mHJ5uJQ1RebPaV+YMjVQ+LcDmgAcbVONbvp8cDw zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 327s65kwkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 20:26:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKHeK6190290;
        Wed, 15 Jul 2020 20:26:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 327qb8qxxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 20:26:37 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FKQaP1010372;
        Wed, 15 Jul 2020 20:26:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 13:26:36 -0700
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        support@areca.com.tw
Subject: Re: [PATCH 16/30] scsi: arcmsr: arcmsr_hba: Make room for the
 trailing NULL, even if it is over-written
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7u8o7ck.fsf@ca-mkp.ca.oracle.com>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
        <20200708120221.3386672-17-lee.jones@linaro.org>
Date:   Wed, 15 Jul 2020 16:26:33 -0400
In-Reply-To: <20200708120221.3386672-17-lee.jones@linaro.org> (Lee Jones's
        message of "Wed, 8 Jul 2020 13:02:07 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150156
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> Ensure we do not copy the final one (which is not overwitten).
>
> -		strncpy(&inqdata[8], "Areca   ", 8);
> +		strncpy(&inqdata[8], "Areca   ", 9);
>  		/* Vendor Identification */
> -		strncpy(&inqdata[16], "RAID controller ", 16);
> +		strncpy(&inqdata[16], "RAID controller ", 17);
>  		/* Product Identification */
> -		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
> +		strncpy(&inqdata[32], "R001", 5); /* Product Revision */

SCSI INQUIRY strings are fixed length and not NULL-terminated. Please
address this warning using either memcpy() or strlcpy().

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
