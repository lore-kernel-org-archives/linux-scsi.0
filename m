Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283C8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhKWDw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:52:26 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30650 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230394AbhKWDwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:52:24 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN1pi0C013538;
        Tue, 23 Nov 2021 03:49:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=quKsRRNdG/VelInrk9ByLZtYF2XTPwTqibt9UedN5C8=;
 b=RxVb+62r/jw3VFE51JA6yJQfW/GfSQc/LXTNriWfJjy77zffDjL6H7E9OTCJnJobODsq
 8DuWDEG6cFvLUrTGtoywddk2VIlj4dY4xboMZ3/0AO09hHAO2SCK5kbA+ydkBc6Nxi37
 6jlGOWUJzRj1TL94/aS22bgMVD0NfGNVe723oq8lIdNTFFZYjNBD++V5le3LbVx5mb90
 RA155rki/wwVR9z2kzjCc7/7sAGZqpuCWpC/b0Gbuvinz24WGUEh2bNMrY1AiVn+2k/G
 AoFGz1Rrcqv2fK2EBESrsYXyXkQKJ2GsV0g6wdPZs2RmpEToJA5pgVuke6itgqWrTZfY BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69medte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3l1Ff162212;
        Tue, 23 Nov 2021 03:49:06 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:06 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3l19i162141;
        Tue, 23 Nov 2021 03:49:05 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hc-1;
        Tue, 23 Nov 2021 03:49:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     brookxu <brookxu.cn@gmail.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH v2] scsi: core: use eh_timeout to timeout start_unit command
Date:   Mon, 22 Nov 2021 22:48:59 -0500
Message-Id: <163763931255.19362.9120379663212825862.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
References: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: ADKebL6QDNrzX5zNXgUCmVgh__MN05to
X-Proofpoint-ORIG-GUID: ADKebL6QDNrzX5zNXgUCmVgh__MN05to
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Nov 2021 09:23:32 +0800, brookxu wrote:

> From: Chunguang Xu <brookxu@tencent.com>
> 
> In some abnormal scenarios, STU may timeout. The recovery
> time of 30 seconds is relatively large. Now we need to modify
> rq_timeout to adjust STU timeout value, but it will affect the
> actual IO.
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: core: use eh_timeout to timeout start_unit command
      https://git.kernel.org/mkp/scsi/c/adcc796b4f55

-- 
Martin K. Petersen	Oracle Linux Engineering
