Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DB7C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 03:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiF1DZd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 23:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiF1DZN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 23:25:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D776625291
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2022 20:25:07 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S2HwTl031758;
        Tue, 28 Jun 2022 03:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=bRmfH7zx4BXbO+KqEHcdieV8R/+4aPRnfCnKacFSmK8=;
 b=Qy+jjP7xnwuIcBjCEr/kV2/VMOL/qyNR29DAq10EgI5pWuTrqNssWMGyr7kdHPOLtoqb
 sLx6lk1oaXyqHoUoLjfKXN6A2PTZCtB4JfhSJNNtZAQbdT+nCasAhlADhwUhCrQDQzup
 +OX8IX6mZULlWaEglop4pxKuPg7DLuP7irHaej6gStFbmR+6aH5WG31vI9h6JKOnAjc/
 TNP3wBRwgODgO+oXhUEMu8jtbqUwIr7MG4hxUGUnk4ltbF3Z53O2A4V6DEZ7KQqM4dZB
 1sJhbFi/NY8tTihyC7WqgMrr3mbWJ51EIitJUYs+n5r+8egzCyvXI18g+tklD4aruU7K iw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwrscctnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S3F1LG002385;
        Tue, 28 Jun 2022 03:25:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 03:25:01 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25S3NvqI016584;
        Tue, 28 Jun 2022 03:25:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt7jjkg-11;
        Tue, 28 Jun 2022 03:25:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] iscsi features for 5.20
Date:   Mon, 27 Jun 2022 23:24:49 -0400
Message-Id: <165638665783.7726.3252947810161544654.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 2RXJz00HNwrNeXjyxTqJtKMKtrwuKHdN
X-Proofpoint-GUID: 2RXJz00HNwrNeXjyxTqJtKMKtrwuKHdN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Jun 2022 17:45:48 -0500, Mike Christie wrote:

> The following patches are for 5.20. They were built against Linus's tree
> but they have no conflicts with the existing patches on the list and
> can be applied before or after those patches. The patches also apply over
> Martin's staging and queueing branches.
> 
> The bulk of the patches allow us to run from a workqueue instead of always
> running from the net softirq. When using lots of sessions we see a nice
> perf bump when doing throughput and IOPs tests. There's then some cleanups
> and locking improvements.
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/9] scsi: iscsi: Rename iscsi_conn_queue_work()
      https://git.kernel.org/mkp/scsi/c/4b9f8ce4d5e8
[2/9] scsi: iscsi: Add recv workqueue helpers
      https://git.kernel.org/mkp/scsi/c/8af809966c0b
[3/9] scsi: iscsi: Run recv path from workqueue
      https://git.kernel.org/mkp/scsi/c/f1d269765ee2
[4/9] scsi: iscsi_tcp: Tell net when there's more data
      https://git.kernel.org/mkp/scsi/c/f93a722fa7b3
[5/9] scsi: iscsi_tcp: Drop target_alloc use
      https://git.kernel.org/mkp/scsi/c/9b89153680f6
[6/9] scsi: iscsi: Remove unneeded task state check
      https://git.kernel.org/mkp/scsi/c/533ac412fdb4
[7/9] scsi: iscsi: Remove iscsi_get_task back_lock requirement
      https://git.kernel.org/mkp/scsi/c/e1c6a7ec1429
[8/9] scsi: iscsi: Try to avoid taking back_lock in xmit path
      https://git.kernel.org/mkp/scsi/c/6d626150d6d1
[9/9] scsi: libiscsi: Improve conn_send_pdu API
      https://git.kernel.org/mkp/scsi/c/6e637b723d82

-- 
Martin K. Petersen	Oracle Linux Engineering
