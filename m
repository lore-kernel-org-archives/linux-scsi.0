Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4B5C388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 415052168B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QrcJutuv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgKKC6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55910 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgKKC6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2rw6G089077;
        Wed, 11 Nov 2020 02:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ds6Vt4A3ZAyYIlpmoJwYs7jfklEElKa6YjF4jeEh1Z8=;
 b=QrcJutuvr+5/Qs9LIhHtUPnOO1DzKGG/NnwMm+np6IuWfBW1fnLherinYQRIDJpHkwXK
 zRErrYC+lZg3uaz2C4ybssOlh3WHKBAo9fb4gmMgktezm2v4b/BlEF6qLxm8nWbfkOju
 +Wr5xe4EJcRYhnQH9GWbuMrIhJPN3lZBqjChQVAxt7+JQQyrHDVrp3Ppie/JstXPD2eh
 s8p08nSOO4GGR8O4THkX3qzNvpQdeA8nZbhzN+O0v1P7SxstVRjbBx7vyUwlKoL777lM
 jEjBhT09G0fFnXs35TawDR6HiGvYIJUpblHxKvL28LSRX1D+kO/etEYdWrFhuPTYqgJ6 1g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3ay5a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tEJd057960;
        Wed, 11 Nov 2020 02:58:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55pdnjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AB2wVb1017720;
        Wed, 11 Nov 2020 02:58:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:31 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/4] scsi: target: COMPARE AND WRITE miscompare sense
Date:   Tue, 10 Nov 2020 21:58:22 -0500
Message-Id: <160506295513.14063.16995021450167842819.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201031233211.5207-1-ddiss@suse.de>
References: <20201031233211.5207-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 1 Nov 2020 00:32:07 +0100, David Disseldorp wrote:

> This patchset adds missing functionality to return the offset of
> non-matching read/compare data in the sense INFORMATION field on
> COMPARE AND WRITE miscompare.
> 
> The functionality can be tested using the libiscsi
> CompareAndWrite.MiscompareSense test proposed via:
>   https://github.com/sahlberg/libiscsi/pull/344
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/4] scsi: target: Rename struct sense_info to sense_detail
      https://git.kernel.org/mkp/scsi/c/b455233dcc40
[2/4] scsi: target: Rename cmd.bad_sector to cmd.sense_info
      https://git.kernel.org/mkp/scsi/c/8dd992fb67f3
[3/4] scsi: target: Split out COMPARE AND WRITE memcmp into helper
      https://git.kernel.org/mkp/scsi/c/ab628b9fc8c2
[4/4] scsi: target: Return COMPARE AND WRITE miscompare offsets
      https://git.kernel.org/mkp/scsi/c/749c226cf56e

-- 
Martin K. Petersen	Oracle Linux Engineering
