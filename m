Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C2CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 02:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiBACEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 21:04:39 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49094 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232093AbiBACEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 21:04:35 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VMEbQL006220;
        Tue, 1 Feb 2022 02:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=LnxSuO7szA+umVWySgha5LXVAK4HX4HfEllPf1Lj9Zg=;
 b=FlwiQPW2qBArzwbXIXNSmW9koSi9zibrRYZgGmUzKZODuH8Ln8EjVH+mxQEu+GWzK4LI
 nrJslj6/JE9d31kyuCqPfjUZThSBK6piCoz6OoKPC5xAl0tjTeLbWtiG6tYQq4Xxs1tP
 tIm83NPF2v+eniGjEkMv+HNgJCx5Pc6c0cleMlLdl+BhhYXcyncAlrVfxjVpz917CnVr
 toZkT4Mtc7z+//lyCTt1I9vv2kGE28tjuAHZiwqLcIdu+meiQ5KnnBOKFMAuULhDbmBX
 WTOIa3cPQ4LnrC6mCPGpqVO5aFNe4J8Ur+tgwoi6XJm4FWqTD2oG6VTUkaWABw7u7eWC GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9w9eqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:04:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2111t7dt098002;
        Tue, 1 Feb 2022 02:04:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3dvwd5a8cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:04:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21124Pp1124522;
        Tue, 1 Feb 2022 02:04:25 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3dvwd5a8ck-1;
        Tue, 01 Feb 2022 02:04:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.vnet.ibm.com, bvanassche@acm.org, hare@suse.de
Subject: Re: [PATCH v2 0/9] scsi_debug: collection of additions
Date:   Mon, 31 Jan 2022 21:04:22 -0500
Message-Id: <164368101885.23527.13122069878492597470.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220109012853.301953-1-dgilbert@interlog.com>
References: <20220109012853.301953-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 8EiNHZSxFfvWlDw-18EFnztuRYD1kf1c
X-Proofpoint-GUID: 8EiNHZSxFfvWlDw-18EFnztuRYD1kf1c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 8 Jan 2022 20:28:44 -0500, Douglas Gilbert wrote:

> The first patch is to address possible modprobe rmmod races.
> 
> The second patch adds READ_ONCE and WRITE_ONCE on several
> high frequency variables.
> 
> See the headers of patches 3 and 4.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/9] scsi_debug: address races following module load
      https://git.kernel.org/mkp/scsi/c/2aad3cd85370
[2/9] scsi_debug: strengthen defer_t accesses
      https://git.kernel.org/mkp/scsi/c/d9d23a5a34bd
[3/9] scsi_debug: use task set full more
      https://git.kernel.org/mkp/scsi/c/7d5a129b86b3
[4/9] scsi_debug: refine sdebug_blk_mq_poll
      https://git.kernel.org/mkp/scsi/c/b05d4e481eff
[5/9] scsi_debug: divide power on reset unit attention
      https://git.kernel.org/mkp/scsi/c/500d0d248081
[6/9] scsi_debug: add no_rwlock parameter
      https://git.kernel.org/mkp/scsi/c/7109f3701a4a
[9/9] scsi_debug: add environmental reporting log subpage
      https://git.kernel.org/mkp/scsi/c/0790797aca03

-- 
Martin K. Petersen	Oracle Linux Engineering
