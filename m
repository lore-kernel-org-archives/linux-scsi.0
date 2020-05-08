Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6837C35280
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E54920731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:57:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KYhoTGbc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEHC5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:57:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgEHC5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:57:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482sArN097588;
        Fri, 8 May 2020 02:56:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ge3yTxVTWD6Ulqohma0oOPgLaKnN61HkcXTwKutreBM=;
 b=KYhoTGbcS634BgckHevrinbFO5KrEshbGt2KFZDQrDZO+8U4be/P7EU0wcF7pc/jbUvx
 LloQKxl6nvNYKsOsQ1lcsZavn2nULSJkPQl7j2JFj9PlVzy/yagQfSbK6cPUY+ZEaWnL
 ybhoj1M40DdyPSIceF2v6d3XS5pI/AwX9KSzKQOBLWI8OPlLY2stJG6hI4n6zRhQT7P+
 OAAHIXIvxr5SBoyDGn16At6JP5eZ6vYTaeAqgIzJWSFHng6VMcIcNCYS5yjd3jRkwc+0
 CdZH/R1EUIqvXuYNZgcn8wHDce4wd7/pMjqlGyh1sBtmqa34CtZ0ra4AFIGRVs95RdB9 nQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30vtexrrs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:56:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482ppaZ138389;
        Fri, 8 May 2020 02:54:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30vtebgpan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:40 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482sbXs027756;
        Fri, 8 May 2020 02:54:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:37 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        mchristi@redhat.com, ddiss@suse.de, hch@lst.de
Subject: Re: [PATCH 1/4] target: add missing emulate_pr attribute to passthrough backends
Date:   Thu,  7 May 2020 22:54:23 -0400
Message-Id: <158890633246.6466.3989954217345857639.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200427150823.15350-2-bstroesser@ts.fujitsu.com>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com> <20200427150823.15350-2-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=892 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=941 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Apr 2020 17:08:20 +0200, Bodo Stroesser wrote:

> In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute
> emulate_pr was added.
> passthrough_parse_cdb() uses the attribute's value to distinguish,
> whether reservation commands should be rejected or not.
> But the new attribute was not added to passthrough_attrib_attrs, so in
> pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
> is not available to change parser's behavior.

Applied to 5.8/scsi-queue, thanks!

[1/4] scsi: target: Add missing emulate_pr attribute to passthrough backends
      https://git.kernel.org/mkp/scsi/c/9299941716a3
[2/4] scsi: target: tcmu: Add attributes enforce_pr_isids and force_pr_aptpl
      https://git.kernel.org/mkp/scsi/c/4703b6252b33
[3/4] scsi: target: Make transport_flags per device
      https://git.kernel.org/mkp/scsi/c/69088a049488
[4/4] scsi: target: tcmu: Make pgr_support and alua_support attributes writable
      https://git.kernel.org/mkp/scsi/c/356ba2a8bc8d

-- 
Martin K. Petersen	Oracle Linux Engineering
