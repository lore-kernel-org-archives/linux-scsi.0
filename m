Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8916C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 14:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95387608FE
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 14:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbhJ3OHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Oct 2021 10:07:43 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46518 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhJ3OHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Oct 2021 10:07:43 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19UDbRKc030170;
        Sat, 30 Oct 2021 14:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=PPrb4kI6G1Zs2yIdHBjokDaIJrpYbhw8Q7CU3tBcsOs=;
 b=Hgp+hr13vSC+VxdFU3aigf7uxvhCaJ+zYmhmq5P020Ity6B5rhXPJXNzxvb2rRmjDY30
 7V14D2Uv7QPZsChoyeucNSfBKbgr6F86VvbDVR74dWBNiBr4EuGnRId3KPBkTRU6xHZR
 OGL/14tEU8OOevEaDwBoKLQXllh3wrnmSYM4CPxAPMI9NEzGjcvyYemTJywOdauOOKXA
 Beg3fYco6npN58FiY+J2PXDYD6KZJmWuOPFeYn+TRZiRn/VsliU5nDwHBBEP0HfwcCcd
 44HeJb97X1IzXHcYXrV3RSOsu6s2TEITuepGJrkYOn2V2lfCWDREZf7LLQhSsyONXM2U pA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c0wxa8tgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Oct 2021 14:05:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19UDtc5M028506;
        Sat, 30 Oct 2021 14:05:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3c0v3a6tkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Oct 2021 14:05:00 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19UE1uHn037969;
        Sat, 30 Oct 2021 14:05:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3c0v3a6tk1-1;
        Sat, 30 Oct 2021 14:05:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Daejun Park <daejun7.park@samsung.com>,
        linux-kernel@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
Date:   Sat, 30 Oct 2021 10:04:59 -0400
Message-Id: <163560266528.20892.581992678159697629.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211030062301.248-1-avri.altman@wdc.com>
References: <20211030062301.248-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 9m7-4VgHlUcRKdGTT-MKQCqpebqmOxFr
X-Proofpoint-ORIG-GUID: 9m7-4VgHlUcRKdGTT-MKQCqpebqmOxFr
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 30 Oct 2021 09:23:01 +0300, Avri Altman wrote:

> v1 -> v2:
>  - forgot to remove ufshpb_set_write_buf_cmd
> 
> v2 -> v3:
>  - restore bMAX_ DATA_SIZE_FOR_HPB_SINGLE_CMD
>  - remove read_id - it is now always 0
>  - Ignore ufshpb_prep returned error - does not return -EAGAIN no more
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufshpb: Opt out pre-reqs from HPB2.0 flows
      https://git.kernel.org/mkp/scsi/c/09d9e4d04187

-- 
Martin K. Petersen	Oracle Linux Engineering
