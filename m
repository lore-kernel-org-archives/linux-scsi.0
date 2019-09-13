Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00509C49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 22:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C85DC206A5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 22:37:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fDY2Xcfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404148AbfIMWhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 18:37:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404123AbfIMWhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 18:37:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DMY1Kg006118;
        Fri, 13 Sep 2019 22:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=8dtnjnQEDgNUKkKebYbVHTKvUPytHmLC98wdqkBDUbk=;
 b=fDY2XcfdM+O7px/fqlySWkq4Ehik/L/T3p60SQ+nrG9a2lhI7nOisE4yAVNhbvaMRq2t
 +L5vifKeF2oLgz718tP4GCyf52PbsZS7UAkhnfwspYs9cva2dXFNdaSnSu9QkM094Ajo
 v1NAsTKfRy+bJlPbBTOsIfM9WcjrIQopezySTDXL/4Ck7w5l71bcS/+jFbWEUqtfH21e
 u8s6KBwk4JlBpOhXB251xwdnAtsokzffA5C+eUhxKHDi0ElMirjt+LWojXObdhR4NM6Z
 QsA2PmKfFET+S+4P0/7QwJYwV3KHM60eaC+CRplSZm4IG0NEpoGxRya7/UaHczwVuayA og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uytd379w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 22:37:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DMShbD057899;
        Fri, 13 Sep 2019 22:37:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uytdjv4xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 22:37:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8DMb96A019223;
        Fri, 13 Sep 2019 22:37:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Sep 2019 15:37:08 -0700
To:     Martin Wilck <mwilck@suse.de>
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/6] qla2xxx: Fix flash read for Qlogic ISPs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190830222402.23688-1-hmadhani@marvell.com>
        <20190830222402.23688-3-hmadhani@marvell.com>
        <bcab32ef2d17d7d14c3a5d41ee711e21ab749ab3.camel@suse.de>
Date:   Fri, 13 Sep 2019 18:37:06 -0400
In-Reply-To: <bcab32ef2d17d7d14c3a5d41ee711e21ab749ab3.camel@suse.de> (Martin
        Wilck's message of "Fri, 13 Sep 2019 22:36:43 +0200")
Message-ID: <yq14l1fddrh.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9379 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=757
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909130220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9379 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=827 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909130221
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Martin,

> I believe this patch should be tagged with
>
> Fixes: 5fa8774c7f38 (scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism)
>
> I just bisected the FW initialization problems on my 8200 series CNA
> to that commit, and I can confirm that this patch fixes it.

I am not going to rebase this late in the cycle. Himanshu or Quinn will
need to send a request to stable@ after Linus pulls 5.4/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
