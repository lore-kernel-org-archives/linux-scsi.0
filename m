Return-Path: <SRS0=78fV=5C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 213EDC10F29
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 15:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E623620752
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Mar 2020 15:11:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O05Km9Qs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCQPLS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Mar 2020 11:11:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCQPLS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2020 11:11:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HF91nF017075;
        Tue, 17 Mar 2020 15:10:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=GMWfNKfqJdub57cAyDczA7XvBIsVdsR7ZkUkX+zan4s=;
 b=O05Km9QsAS9OgGCsWcFu3bBYEaKyipwoidcAr3bmGXrNlXvGyKhtb2mEXqABXYhq8Kmp
 nWNYw467Sfgbk7abS4q9hsdE+AoxjVEJrIiPYGEv1feyZfjmRwsGynQZBlmB+1lsEp1t
 HEGNX4793v5B/3hD1PVKaUMTDdyXE3T15xXdk8FyIBmyw8UUNPY0P9CDuct5cdsfoqT5
 QRZLqU8cYD1m7zY1Q/1sq7C68jl70k8PkxRbx0CYgINowTR1/B1+te3n1Bb10X90XPCa
 pZ10xZSZdTanxDSTLCvev+PRVPAFXo6iYCewUAzu/4oeEE/4keU++ruFYuK5XtoB8r+M 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yrppr5gff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 15:10:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02HF1W51097594;
        Tue, 17 Mar 2020 15:10:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92d8qd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 15:10:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02HFAsjO022992;
        Tue, 17 Mar 2020 15:10:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Mar 2020 08:10:54 -0700
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/5] Consolidate {get,put}_unaligned_[bl]e24() definitions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200313203102.16613-1-bvanassche@acm.org>
Date:   Tue, 17 Mar 2020 11:10:51 -0400
In-Reply-To: <20200313203102.16613-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 13 Mar 2020 13:30:57 -0700")
Message-ID: <yq1h7ynow3o.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=708
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170063
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 spamscore=0 mlxlogscore=770 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170063
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series moves the existing {get,put}_unaligned_[bl]e24()
> definitions into include/linux/unaligned/generic.h and also replaces
> some open-coded implementations of these functions with calls to these
> functions. Please consider this patch series for kernel version v5.7.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
