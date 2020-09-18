Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEDCC43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D93B23718
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 03:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N2c8J+TX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIRD0v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 23:26:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIRD0v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 23:26:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I3P8DU042413;
        Fri, 18 Sep 2020 03:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=u5Wc1Rpfr9jGdrhv1sc2/WJ6KhTGK1VbK75D+xbwxjk=;
 b=N2c8J+TX50ard6WzXvKuXvMzu8Ny7YDzu7hCLo9GwNodb31EWmpUrFl5bsuCytfsChSD
 WXI27EeNkCju8P8h0Wwlkx+J0Y8Ggg7Sp2V8yxp75zwDJMcCz4+IRu4yDBlI2SFItyqa
 WQvuKcbHV1D5ac8UuwmJt6bmyOoF6FmiS5fZIy/K6j8tdqpWTj2iDkbWRBQ1yo/OjKiS
 MMX8myPzkL8V0RBS7ytepYH9ryhKcZJXTH9+CDKLWRbMAwo1ykBeU7iM6RhwyUzmu8nX
 0CqDLybVW3fRhxwllj96ymABnWTttDPznx11muMrX1vesyqzpjzZFP2zVf6YMWM9JFtF rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dxctw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 03:26:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I3PvQF180306;
        Fri, 18 Sep 2020 03:26:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm361gdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 03:26:48 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08I3QlSN009154;
        Fri, 18 Sep 2020 03:26:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 03:26:47 +0000
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] scsi: mpt: Refactor and port to dma_* interface
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z8bu5v6.fsf@ca-mkp.ca.oracle.com>
References: <20200903152832.484908-1-alex.dewar90@gmail.com>
        <yq1ft7ixyg8.fsf@ca-mkp.ca.oracle.com>
        <20200916164411.hkpmqigdhgdb66dl@lenovo-laptop>
Date:   Thu, 17 Sep 2020 23:26:45 -0400
In-Reply-To: <20200916164411.hkpmqigdhgdb66dl@lenovo-laptop> (Alex Dewar's
        message of "Wed, 16 Sep 2020 17:44:11 +0100")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009180028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alex,

>> Have you tested your changes?
>
> No, as I'm afraid I don't have the hardware.

QEMU supports it, I propose you try testing with that.

I hesitate merging big changes to abandoned drivers unless they've been
tested. It's too easy to miss things during review...

-- 
Martin K. Petersen	Oracle Linux Engineering
