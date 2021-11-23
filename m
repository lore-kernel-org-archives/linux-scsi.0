Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0C0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 03:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhKWDwT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:52:19 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23540 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229764AbhKWDwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Nov 2021 22:52:18 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN1q8Qc013543;
        Tue, 23 Nov 2021 03:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=IxS8+PvZZs7CPcyfO9hy5NTmCVhTsdU/HEHB3x0E78A=;
 b=eR3uDiEPJzegYJNYIJNCK0Uej1LbD1E/qWp1tftj5tvHmZkArOhA5kwtTvs7sVqvUppO
 Ja7FQAezA+Gj/EWufbXHwP9zkqJGOqajgxRjzEzrTJF9xheLYaqZ+LyusFVTluCrFmq0
 XBk6Id5PuDJgI2SaBPLJ7hj39d0vlb6ttTaCvFqjiVHaoVF3s5TQN1SN106zJ8LR2/LJ
 Bs1SxWDdWO8rgltKaP/BXBpnM0lzFDiaRZw8iN1D31/PMddevPBwwjNmaHz4HwI2G+Gf
 /zY6q4nfFLljfA9yUaf/EK0i/biAQ/TDnZdKhTiz4ft0oJa0V45ylgyzWxSPAAkJZ2Fp zA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg69medtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN3l10c162309;
        Tue, 23 Nov 2021 03:49:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 03:49:07 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AN3l19k162141;
        Tue, 23 Nov 2021 03:49:06 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ceru4g6hc-2;
        Tue, 23 Nov 2021 03:49:06 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] scsi: core: Remove Scsi_Host.shost_dev_attr_groups
Date:   Mon, 22 Nov 2021 22:49:00 -0500
Message-Id: <163763931254.19362.9911070167727757790.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211116223115.2103031-1-bvanassche@acm.org>
References: <20211116223115.2103031-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1gF0d1yP5AH9ZCvCLGol3KZgPSF4tcL8
X-Proofpoint-ORIG-GUID: 1gF0d1yP5AH9ZCvCLGol3KZgPSF4tcL8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Nov 2021 14:31:15 -0800, Bart Van Assche wrote:

> Simplify the scsi_host_alloc() implementation by setting the shost_class
> .dev_groups member instead of copying all host attribute group pointers
> into the shost_dev_attr_groups[] array.
> 
> 

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: core: Remove Scsi_Host.shost_dev_attr_groups
      https://git.kernel.org/mkp/scsi/c/0a84486d6c1d

-- 
Martin K. Petersen	Oracle Linux Engineering
