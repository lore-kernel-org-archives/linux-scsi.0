Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F15C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 04:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhLNElC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 23:41:02 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36288 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229516AbhLNElA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Dec 2021 23:41:00 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE2mCOU004121;
        Tue, 14 Dec 2021 04:40:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=/5iGBxUoApceK1JvcpGajxyXz8hgibYkQoLzIbnkHhE=;
 b=wWldtmr8vS7XQi1RKRHZU4Zme7P2+B+pa5r5bLwDpd0DVjf4YCLyaqbsiujvGxnB8cL5
 5sLYFoyxOikItbufK9VTi+AGwD5A0fn3sRysKpdmLUnYZH8p31+WftLdVeNj7KPZ7kdz
 cKxKPNZAXTmT0sBjhupQTOWlLbHOSMEQy5dURS0s5aM6wCbmBEbIrByOTG7AKEt2MeMw
 8i3yo3ZMCtwouVgvazqmwnaFp3ztEQP/Hucx6NASlJw+wZ1rKoQ+qc6dgvYaq6ce5R2W
 sNIj7DRhSdV63eajVRx0XlsQLQjTQfw7Skp0c9a4nv3woQX5m6in06UnT/35i9Z4kLwH /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3py2mat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 04:40:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE4ZY3k032463;
        Tue, 14 Dec 2021 04:40:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3cvh3wp5ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 04:40:57 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1BE4aj9G034843;
        Tue, 14 Dec 2021 04:40:57 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3cvh3wp5ab-6;
        Tue, 14 Dec 2021 04:40:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] lpfc: Update lpfc to revision 14.0.0.4
Date:   Mon, 13 Dec 2021 23:40:52 -0500
Message-Id: <163945683293.11687.2655733084690610390.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: YGmz0qwq8PczGcKU6K0WwPcXqQPAXDKU
X-Proofpoint-GUID: YGmz0qwq8PczGcKU6K0WwPcXqQPAXDKU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 3 Dec 2021 16:26:35 -0800, James Smart wrote:

> Update lpfc to revision 14.0.0.4
> 
> This patch set contains several bug fixes.
> 
> The patches were cut against Martin's 5.16/scsi-fixes tree
> 
> James Smart (9):
>   lpfc: Fix leaked lpfc_dmabuf mbox allocations with npiv
>   lpfc: Change return code on ios received during link bounce
>   lpfc: Fix lpfc_force_rscn ndlp kref imbalance
>   lpfc: Fix NPIV port deletion crash
>   lpfc: Trigger SLI4 firmware dump before doing driver cleanup
>   lpfc: Adjust CMF total bytes and rxmonitor
>   lpfc: Cap CMF read bytes to MBPI
>   lpfc: Add additional debugfs support for CMF
>   lpfc: Update lpfc version to 14.0.0.4
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/9] lpfc: Fix leaked lpfc_dmabuf mbox allocations with npiv
      https://git.kernel.org/mkp/scsi/c/f0d391969749
[2/9] lpfc: Change return code on ios received during link bounce
      https://git.kernel.org/mkp/scsi/c/2e81b1a374da
[3/9] lpfc: Fix lpfc_force_rscn ndlp kref imbalance
      https://git.kernel.org/mkp/scsi/c/7576d48c64f3
[4/9] lpfc: Fix NPIV port deletion crash
      https://git.kernel.org/mkp/scsi/c/8ed190a91950
[5/9] lpfc: Trigger SLI4 firmware dump before doing driver cleanup
      https://git.kernel.org/mkp/scsi/c/7dd2e2a92317
[6/9] lpfc: Adjust CMF total bytes and rxmonitor
      https://git.kernel.org/mkp/scsi/c/a6269f837045
[7/9] lpfc: Cap CMF read bytes to MBPI
      https://git.kernel.org/mkp/scsi/c/05116ef9c4b4
[8/9] lpfc: Add additional debugfs support for CMF
      https://git.kernel.org/mkp/scsi/c/6014a2468f0e
[9/9] lpfc: Update lpfc version to 14.0.0.4
      https://git.kernel.org/mkp/scsi/c/4437503bfbec

-- 
Martin K. Petersen	Oracle Linux Engineering
