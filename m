Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E529C64E7D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8C32465B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 03:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WC2lQNpO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgKQDrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 22:47:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39398 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgKQDq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 22:46:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3fpKP138174;
        Tue, 17 Nov 2020 03:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=IsUpn/dl214A80H/3v06PDx6DW/p/wuxnCWRIFCi2Cw=;
 b=WC2lQNpO9x4HlzfjEPacsf/jjOYVVxF+9DIg2yW7qCn7L4CXYFyl53yTXf3WVlE4OdVs
 lRPZgGJVsL9H6ApeZj28rzdMICbgSL3mP3sOuwoUXx/oKFBsTWM7fXYc+a3XPGoPjp3v
 2XlOL7u40uew55bq4o2GSOodidDJmf+YXhIbiBDuoRiFSVBEC4f11JY8KvpmbWIximBq
 fjwa16zDlhTPDegEIyGRfcD5rtev0+3+ZjQ+R1HgI/GW2FuYKElaVC8EF/JN1/69+rgy
 PVZKYwMBYf0xPJ2bFoupQX9jr/OH4juK6RBHgTg86NR4E4s+EL427PJclfeErERJ7WL7 rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34t76krd88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 03:46:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3fIsL005305;
        Tue, 17 Nov 2020 03:44:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34umcxmebw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 03:44:53 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH3ip0V004749;
        Tue, 17 Nov 2020 03:44:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 19:44:51 -0800
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        linux-hyperv@vger.kernel.org, Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v9 2/3] scsi: storvsc: Use vmbus_requestor to generate
 transaction IDs for VMBus hardening
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lff06429.fsf@ca-mkp.ca.oracle.com>
References: <20201109100402.8946-1-parri.andrea@gmail.com>
        <20201109100402.8946-3-parri.andrea@gmail.com>
        <20201113113327.dmium67e32iadqbz@liuwe-devbox-debian-v2>
        <20201113185424.ujdfx6ot7siqr5qh@liuwe-devbox-debian-v2>
        <20201113213933.GA4937@andrea>
        <20201116110352.obbqxzxw6etdq4cl@liuwe-devbox-debian-v2>
Date:   Mon, 16 Nov 2020 22:44:48 -0500
In-Reply-To: <20201116110352.obbqxzxw6etdq4cl@liuwe-devbox-debian-v2> (Wei
        Liu's message of "Mon, 16 Nov 2020 11:03:52 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 phishscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Wei,

> Martin and James, are you happy with this change? I would assume you
> are because that means this patch to storvsc is leaner.

Yes, that's fine.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
