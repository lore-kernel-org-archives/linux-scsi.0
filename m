Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E464DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 02:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiBACDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 21:03:47 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12322 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232638AbiBACDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 21:03:43 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VLZf41010052;
        Tue, 1 Feb 2022 02:03:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=gFwJRQdW6nm7Z9ZaQxkW4RvJJfk5/CprNSDO1zbjJkY=;
 b=OTdEXKNDEZCW24l4RvFqrjzJ1tMmXjA0JWUqckKIzcCTdx2ch1RgJKCNfmHzPnBe80aq
 UoMzdRHWCIDIkAVFu83mH/g0RKnZP5pFy1k6dccEHDj9DDKG1r2dqki7YZf0/djKMWFN
 yOgYXvJb079bpCMfzZJLClQNeePpbDYeigxJ0p+xfpANKFUCO2l9w1jeo7tg/FDUyHEC
 N9vPT6Ssq6z4FYQZJHg47kvZMIepCGg9DxI1keDLEw1tb1ONperiLOjue3b1PN9IyHC0
 KTzzIr9UmHR3wAsQ+fzAH4oHPktey21Li102mu9ydCHwipNHmguteQ6l3oFh8FbGY7w3 +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjac1fg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:03:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2111tR4K079128;
        Tue, 1 Feb 2022 02:03:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dvtpy6w9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 02:03:30 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 21123EPj096319;
        Tue, 1 Feb 2022 02:03:30 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dvtpy6w3w-5;
        Tue, 01 Feb 2022 02:03:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH V2] scsi: core: reallocate scsi device's budget map if default queue depth is changed
Date:   Mon, 31 Jan 2022 21:03:23 -0500
Message-Id: <164368097301.23346.9140841739337251694.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220127153733.409132-1-ming.lei@redhat.com>
References: <20220127153733.409132-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: t2V7EAVEtHB0kubWJ12eKsilXCwLaa6j
X-Proofpoint-ORIG-GUID: t2V7EAVEtHB0kubWJ12eKsilXCwLaa6j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Jan 2022 23:37:33 +0800, Ming Lei wrote:

> Martin reported that sdev->queue_depth can often be changed in
> ->slave_configure(), and now we uses ->cmd_per_lun as initial queue
> depth for setting up sdev->budget_map. And some extreme ->cmd_per_lun
> or ->can_queue won't be used at default actually, if they are used to
> allocate sdev->budget_map, huge memory may be consumed just because
> of bad ->cmd_per_lun.
> 
> [...]

Applied to 5.17/scsi-fixes, thanks!

[1/1] scsi: core: reallocate scsi device's budget map if default queue depth is changed
      https://git.kernel.org/mkp/scsi/c/edb854a3680b

-- 
Martin K. Petersen	Oracle Linux Engineering
