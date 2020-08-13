Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162BBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67C9206B2
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AwMilS59"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHMCjM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:39:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38878 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgHMCjM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 22:39:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07D2cOcp047274;
        Thu, 13 Aug 2020 02:39:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=7qECJqXVQLN9FvLwlPZJIZBWreafg/v/HFuvrBToK6I=;
 b=AwMilS59sv4XM2/jeIjnsS1Ojg/LzD4sCnwDn+fpth2A6c8tmf/YfuqeGDYrqGrikcDF
 9fFSjyQ3Xr4NyDfQhpyPDNgHUz3NPREEIe3xA/qIyb6lsZEKpbF++NwJXupOtFzZWkSa
 LgzeM8Qs5ToB4OTTaIRgTsLfPLj+/9rMyyjvfzIXfkZ2JQMtTT/aLrZSsmOZLLKQCgGO
 LGp/xQDd7cmBPvK1Xb9UwvLZIo2z2qWWktOHIZu/jKnXYyehM83m6KLIy0/osRTTBgWH
 84uHqelDcDtJNTsdwn72pleI7LFrs7cc0LjiTNSmncWI7et8jQtoRVzHHVSDQ478xAL6 /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32smpnp0sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 02:39:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07D2bQus105255;
        Thu, 13 Aug 2020 02:39:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32t5y8g81n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 02:39:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07D2d8fe029253;
        Thu, 13 Aug 2020 02:39:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 02:39:07 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        suganath-prabu.subramani@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: Add support for Non-secure Aero and Sea PCI IDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sgcri869.fsf@ca-mkp.ca.oracle.com>
References: <20200730082822.22343-1-sreekanth.reddy@broadcom.com>
Date:   Wed, 12 Aug 2020 22:39:05 -0400
In-Reply-To: <20200730082822.22343-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 30 Jul 2020 08:28:22 +0000")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Driver will throw an error message when a non-secure type controller
> is detected. Purpose of this interface is to avoid interacting with
> any firmware which is not secured/signed by Broadcom.

Why not just print the warning?

-- 
Martin K. Petersen	Oracle Linux Engineering
