Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53270C47076
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 16:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33114206B9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 16:24:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jo+uui50"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgELQYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 12:24:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35912 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgELQYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 12:24:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CGMvxO038586;
        Tue, 12 May 2020 16:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=2n7Lm4qRjNg0ZKkCdKnON7CKWLO6Orpjfox7E2um0pE=;
 b=jo+uui50t0SQwBuY8yxqU92QvNm/lEQFekDbTrpcM+BYk2KIdqcEQnx6PtPkJ+pwmTkO
 tTbzl8wYgtcYAKxazsAXPxP/eSdrYQoGga1yjoM3V7/QyS77SiKldxw5aih4gchKoULz
 9YwHIE7ShnJo4IyXElmDj4FASTH1upNzQJtqVnqS34I42WzlkXW5dLC+yGWTd3I2I1wt
 Su9uGwxdZAK7XMiYGVW2gzeBBEzMo51glrQfFWCxFkgCluClzdfkFjroAOoFP9ygIXnx
 pIe6+BwmZLp1o8PjTElhqr75OYmRnxo85E8tYb0T7iNmLI6Regu8X5L0FTY2AEq0WsyZ PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30x3gmm39q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 16:24:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CGHleX195407;
        Tue, 12 May 2020 16:24:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30x63q4ta9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 16:24:13 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CGOB5L011008;
        Tue, 12 May 2020 16:24:11 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 09:24:11 -0700
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v11 00/10] Introduce Zone Append for writing to zoned
 block devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200512085554.26366-1-johannes.thumshirn@wdc.com>
        <20200512131748.GA15699@infradead.org> <yq14ksl2ldd.fsf@oracle.com>
        <20200512160410.GA22624@infradead.org> <yq1zhad169p.fsf@oracle.com>
        <SN4PR0401MB3598F2AE584D163B222FE4D59BBE0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Date:   Tue, 12 May 2020 12:24:07 -0400
In-Reply-To: <SN4PR0401MB3598F2AE584D163B222FE4D59BBE0@SN4PR0401MB3598.namprd04.prod.outlook.com>
        (Johannes Thumshirn's message of "Tue, 12 May 2020 16:18:19 +0000")
Message-ID: <yq1r1vp15qw.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=642 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=677
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120124
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Johannes,

> Just did a quick skim in the gitweb and I can't see anything that will
> clash. So I think we're good.

The most intrusive pieces are impending. But no worries! Staging the
merge is my problem. Your series is good to go as far as I'm concerned.

-- 
Martin K. Petersen	Oracle Linux Engineering
