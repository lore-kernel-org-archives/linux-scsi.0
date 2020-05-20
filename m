Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4834BC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25FD02081A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kxEOtDjC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgETCJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:09:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56706 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETCJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:09:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K23O3K095936;
        Wed, 20 May 2020 02:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=rfI8CcpoCfQHEKgjcQlPp8/KJ1SPl5TgR+6d/hf1tJY=;
 b=kxEOtDjCFGGm9cFPNuQHNXjQtfjwZfQ/6v7OGE8w5kV8xWvakwzHZTCrSnvsP72NjVM4
 Ce3vI+Y/fCSdxPnDfRkHxuKegYUZx6l3o5zRO2usgz3lXWGtaANd32n/29rYFq01CJVM
 uLdmKgc4ZcorLsnsvjbQ+MFNalYNkY//xXLxcInNdhrV/S8UdZxxMirg2mtWnFl06/cC
 7WuvrAWvJ1eDAVfXLHTFfnjv9z8A5KYrJy0JA2CyQIf2pFf1j0Qw144E6Y99OKeyS6y0
 mt64k8N8THDd7eqqusYdOZSDYTmk1FB8gI7/LbTfk2tX+PIxBegx3gWfeTa7Saoges2Q mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3128tnggmg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:08:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K28P0o136292;
        Wed, 20 May 2020 02:08:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gm64spa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:08:57 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K28tOV004328;
        Wed, 20 May 2020 02:08:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:08:55 -0700
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Daniel Axtens <dja@axtens.net>, kbuild test robot <lkp@intel.com>,
        kbuild-all@lists.01.org, Johannes Weiner <hannes@cmpxchg.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [hnaz-linux-mm:master 156/523] include/linux/string.h:307:9:
 note: in expansion of macro '__underlying_strncpy'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dx7wej4.fsf@ca-mkp.ca.oracle.com>
References: <202005191736.t1JQZSrV%lkp@intel.com>
        <87blmkhtpy.fsf@dja-thinkpad.axtens.net>
        <20200519184847.5affb9238b7358ac0d18c98e@linux-foundation.org>
Date:   Tue, 19 May 2020 22:08:53 -0400
In-Reply-To: <20200519184847.5affb9238b7358ac0d18c98e@linux-foundation.org>
        (Andrew Morton's message of "Tue, 19 May 2020 18:48:47 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Andrew,

> 		/* Vendor Identification */
>>>>		strncpy(&inqdata[16], "RAID controller ", 16);

> That strncpy() will indeed fail to copy the trailing null, but it looks
> like that null isn't appropriate in the inquiry data.

Correct. These protocol strings are fixed-length / space-padded.
I.e. not null-terminated.

-- 
Martin K. Petersen	Oracle Linux Engineering
