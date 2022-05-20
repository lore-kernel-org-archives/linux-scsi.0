Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25E2C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbiETBJr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344267AbiETBJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:09:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47D913324E
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 18:09:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0Jhhd031924;
        Fri, 20 May 2022 01:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=b+7AyBNWSatxShNnqH4eS5qVH80qBC8GzkOcUNyw3BY=;
 b=lTPD+xLYO1HjRprJ+0BFFWzuThk4Q0lVY7DZQTPw7gpdztYWH/MOiV9OHNZMAg8sNLPw
 sv0kt4xSP1zOe82Ef0gAvSZJ9uD4rdtSvsk0H1c8hjEOlPExmexabHmS9GPVllFygakH
 +MQVYeci/PkQcr+JpEwfuDfVLK5LAntrctUW3oAJlYw8elcudCmdaFTD4edfKcRrnrjK
 /nLiS7eE1kB7VBu3Kte0/Nnruw3Ipu5nc0kNHiUYBYENNG3xMawI/G3IKyMkdPkuJrbQ
 pfSRDWPh5g5794w6b7GkxI9jQyr38OYWXx1NDsdoWu6zq/xBXS07sUETlTrlAZoZI3zC 9g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310wtr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K15nhL020166;
        Fri, 20 May 2022 01:09:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crytk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:19 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24K19GK9030710;
        Fri, 20 May 2022 01:09:19 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crythd-3;
        Fri, 20 May 2022 01:09:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 0/4] scsi: PREEMPT_RT related fixes.
Date:   Thu, 19 May 2022 21:09:02 -0400
Message-Id: <165300891228.11465.282438401170346067.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220506105758.283887-1-bigeasy@linutronix.de>
References: <20220506105758.283887-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: AullC124Yk-oCR9juXvnSM5Z8UHnYlzq
X-Proofpoint-GUID: AullC124Yk-oCR9juXvnSM5Z8UHnYlzq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 May 2022 12:57:54 +0200, Sebastian Andrzej Siewior wrote:

> this is what I have in PREEMPT_RT queue for the SCSI stack.
> Two of these patches have been posted earlier by Davidlohr in another
> series. I then added the statistics change and then I stumbled upon
> another get_cpu() usage in bnx2fc so there are four patches now.
> Due lack of hardware, the series has been compile tested only.
> 
> Sebastian
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/4] scsi: fcoe: Add a local_lock to fcoe_percpu
      https://git.kernel.org/mkp/scsi/c/848b89778ed5
[2/4] scsi: fcoe: Use per-CPU API to update per-CPU statistics.
      https://git.kernel.org/mkp/scsi/c/a912460efafe
[3/4] scsi: libfc: Remove get_cpu() semantics in fc_exch_em_alloc()
      https://git.kernel.org/mkp/scsi/c/a0548edf852a
[4/4] scsi: bnx2fc: Avoid using get_cpu() in bnx2fc_cmd_alloc().
      https://git.kernel.org/mkp/scsi/c/20f8932f979e

-- 
Martin K. Petersen	Oracle Linux Engineering
