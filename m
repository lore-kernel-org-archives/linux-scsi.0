Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43DCC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B268206BA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 02:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fIg0/UHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfKMC1b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 21:27:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36402 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbfKMC1a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 21:27:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD2PAsN040558;
        Wed, 13 Nov 2019 02:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=IgQK/jgcaBafwKBfKW4igsisY1VK1bwzHjPq8iG4ra4=;
 b=fIg0/UHbhZ5D5dw1UucEUyqtCwpnG7xOWcN/8Mi6dNU1liyTWxQkg07nghGoaNkjXIQ6
 KaCmFX6CV43uVA+DYhZgXtpz/bbhzEersxdmbk7P7VwbadSWqQPBa1d5d+cQYzTXw1Eo
 kYt+ZPfG5yN49bYjEslgsNE/75D2LfpCrJ0hR3ElLPauA5aBTZituBiSuYNjNDrgm4mO
 fjeQEOaQ/scacvW+fPCfj7mJNJQJ5aLJ8DzmqxbLZPaS4YMdiBwRuYEiUK8A7rhJlcqb
 +11WpXrff52+7saIxaxnowOLXt8HSjtbDEqML4+K2NcOKlC3gjFBihynjK/PJI91yDKG gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w5p3qrvq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 02:27:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD2MlAn190431;
        Wed, 13 Nov 2019 02:27:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w7khmf6be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 02:27:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAD2RFBE025245;
        Wed, 13 Nov 2019 02:27:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 18:27:15 -0800
To:     Kars de Jong <jongk@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        schmitzmic@gmail.com, fthain@telegraphics.com.au
Subject: Re: [PATCH v2] zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastlane)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1573414513.3230.4.camel@linux.ibm.com>
        <20191112175523.23145-1-jongk@linux-m68k.org>
Date:   Tue, 12 Nov 2019 21:27:12 -0500
In-Reply-To: <20191112175523.23145-1-jongk@linux-m68k.org> (Kars de Jong's
        message of "Tue, 12 Nov 2019 18:55:23 +0100")
Message-ID: <yq17e44qznj.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=856
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=928 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kars,

> When using this driver on a Blizzard 1260, there were failures
> whenever DMA transfers from the SCSI bus to memory of 65535 bytes were
> followed by a DMA transfer of 1 byte. This caused the byte at offset
> 65535 to be overwritten with 0xff. The Blizzard hardware can't handle
> single byte DMA transfers.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
