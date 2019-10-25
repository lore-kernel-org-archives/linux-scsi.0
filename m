Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD5CCA9EBC
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D69452084C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 01:16:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="deTeqY3W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbfJYBQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:16:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388515AbfJYBQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 21:16:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1E1n0120894;
        Fri, 25 Oct 2019 01:16:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=AbepHJYRFeSdhP/8TwPby8wa7p9KL6DyyeYknaFGBMA=;
 b=deTeqY3WlGZw6r8S401Fx/EGPyOCmrGR9Zn//QDZpxfEuDWNBbRmQDj4YeuuE1QDkb6l
 /AR8tDRsisfHVdKu7c+gbGdFGCXzW35SSchaibNY7pkbW4YiNhvfHGHhxdX6R92jIfMX
 yBA2dWl+fq98+rfJXAj6l2HumdojtREav9foyVictSHTNP0hR8r1BmmWSzKlJT7wEKjW
 LE7P1Ve3v8pQyUwqqaCYMlvhaAXJnBGlqiFVqWrDVa/oooaIR7OOlFGtzS4sNCCTpQL3
 +QtRRB58MgS6GmKB6TvcpOul8wVKpQ/pV7+yK6rxouhlhv/2GrIiodwFA+jX+ktW33vf qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteq75ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:16:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P1CrbN181742;
        Fri, 25 Oct 2019 01:16:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vunbk5ydd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 01:16:15 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P1G9r0024360;
        Fri, 25 Oct 2019 01:16:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 18:16:08 -0700
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <kxie@chelsio.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <bvanassche@acm.org>,
        <davem@davemloft.net>, <tglx@linutronix.de>, <info@metux.net>,
        <kstewart@linuxfoundation.org>, <varun@chelsio.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: cxgb4i: remove set but not used variable 'ppmax'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191021142042.30964-1-yuehaibing@huawei.com>
Date:   Thu, 24 Oct 2019 21:16:05 -0400
In-Reply-To: <20191021142042.30964-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Mon, 21 Oct 2019 22:20:42 +0800")
Message-ID: <yq1lft9bp62.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=951
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250011
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:2076:15:
>  warning: variable ppmax set but not used [-Wunused-but-set-variable]
> drivers/target/iscsi/cxgbit/cxgbit_ddp.c:300:15:
>  warning: variable ppmax set but not used [-Wunused-but-set-variable]

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
