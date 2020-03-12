Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D55C0044D
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB1E520735
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 03:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UfT85iLQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgCLDIm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 23:08:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43308 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387657AbgCLDIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 23:08:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C2xM45175710;
        Thu, 12 Mar 2020 03:05:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=YpmzN3cJx+gWH6uTD4QVgcwdVZLJvMbCnFkIOCirj8M=;
 b=UfT85iLQOV69sBWI021DzAJf8z/b6PcAYOenUqDbZYVIUXZQyJMHoaCJEX0MB62mOii7
 ANDUftThTCcCpT/1fMLe4WdmXsMWTfvPejhFH5KR8hggnu9RXmqRUJgwJkc6cSJNLxG9
 WOqyV1ua0sqvhSUGUWtMkUl943jD52cZkxWPTg0ANYHoC/ue1nnw74n+tiHqhWirCJ/U
 wV8sp7D12DOtm0S2Vc5iKu/oeEiUJAUZJwN88L2d50vZWXndIly+iwtvfQTbSBI9Eylg
 T7M99t5qiZq8+Tapi7/m72uD8IEZ8bzvjZc8C6JOsMe35+3jD9Pyz3Rb3wzsWj3XRQnk xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yp7hmbf3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:05:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C2xUn9018696;
        Thu, 12 Mar 2020 03:05:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2yp8q1tqt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:05:57 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02C35UdG003438;
        Thu, 12 Mar 2020 03:05:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:05:30 -0700
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Matthew Wilcox <willy@infradead.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        megaraidlinux.pdl@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        esc.storagedev@microsemi.com, Doug Gilbert <dgilbert@interlog.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Hannes Reinecke <hare@suse.com>, dc395x@twibble.org,
        Oliver Neukum <oliver@neukum.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Ali Akcaagac <aliakc@web.de>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Avri Altman <avri.altman@wdc.com>,
        GOTO Masanori <gotom@debian.or.jp>
Subject: Re: [PATCH 00/42] Manually convert SCSI documentation to ReST format
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
        <yq14kuvu6cc.fsf@oracle.com> <20200311125024.6acd2567@onda.lan>
Date:   Wed, 11 Mar 2020 23:05:24 -0400
In-Reply-To: <20200311125024.6acd2567@onda.lan> (Mauro Carvalho Chehab's
        message of "Wed, 11 Mar 2020 12:50:24 +0100")
Message-ID: <yq15zfab7d7.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mauro,

> Btw, maybe due to the conflict you had, I double-checked that two
> files ended by being deleted instead of converted (looking at today's
> linux-next).

Yeah, I messed that up, sorry! The files were in my repo but I evidently
forgot to add them after manually applying so they ended up missing in
the commit.

> Feel free to either apply it as a separate patch at the end or to fold
> with the previously applied patches. Whatever works best for you.

Since your series was near the top of my tree I decided to grab a fresh
mbox from lore. I manually added the missing pieces from my mail folder
so the series would apply cleanly.

-- 
Martin K. Petersen	Oracle Linux Engineering
