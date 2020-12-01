Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D932DC64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E7B7206ED
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 05:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F6G9jQeP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgLAFGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 00:06:21 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56192 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgLAFGU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 00:06:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14n7xo008467;
        Tue, 1 Dec 2020 05:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5d9AP2y5OmYGIQTuKZTw29SkqgOUaVOW69s2a3zB8/Y=;
 b=F6G9jQePnf4QEV6aCQ3lhjMy/XqV0StxVNNZETlr8Uy6dCNv4cjCctne7X48t/vlUbVL
 ianIODFcJicSwsc/wPVShfhVeeU8miQQ8JkqF3sjrcvS1XJyLzTInnv+9kMgMaSR7xiy
 X18b/wMHRknJR3s3aPoS6lu6nyC3GrPeiZqWYTNfekkP/dzNYC7Pljvr5qF1fRwOmHVr
 R/qkXGVnXBDfE66nsPOEaioGoJ9ehWCNQz+Zvt+lEYPS5CUMY020XbPQB/QG0fuNgZMV
 pLidAMATWaR2erUCX6MxNggYB/wWWDvqV7afwh2r7rgk0tMhzSPpYQ9ufqkXiEw7t0C3 7w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2arqfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 05:05:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B14oMOf134941;
        Tue, 1 Dec 2020 05:05:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404mdx2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 05:05:36 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B155Z5A017105;
        Tue, 1 Dec 2020 05:05:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Mon, 30 Nov 2020 21:04:26 -0800
MIME-Version: 1.0
Message-ID: <160636449893.25598.14958452418456601378.b4-ty@oracle.com>
Date:   Mon, 30 Nov 2020 21:04:16 -0800 (PST)
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@telegraphics.com.au>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/atari_scsi: Fix race condition between .queuecommand
 and EH
References: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
In-Reply-To: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
X-Mailer: git-send-email 2.29.2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Nov 2020 15:39:56 +1100, Finn Thain wrote:

> It is possible that bus_reset_cleanup() or .eh_abort_handler could
> be invoked during NCR5380_queuecommand(). If that takes place before
> the new command is enqueued and after the ST-DMA "lock" has been
> acquired, the ST-DMA "lock" will be released again. This will result
> in a lost DMA interrupt and a command timeout. Fix this by excluding
> EH and interrupt handlers while the new command is enqueued.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: atari_scsi: Fix race condition between .queuecommand and EH
      https://git.kernel.org/mkp/scsi/c/03fe6a640a05

-- 
Martin K. Petersen	Oracle Linux Engineering
