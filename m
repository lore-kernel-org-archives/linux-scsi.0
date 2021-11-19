Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DA4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91E0B61AA7
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbhKSEUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:20:06 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20700 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233924AbhKSEUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:20:03 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2a3Nu019268;
        Fri, 19 Nov 2021 04:16:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=1aqyD1Gh3NbWGEyAeBmmN8xr7mte2hmQHo8E1xFzquo=;
 b=a110wei7w43w/m0gKpfyq6whc69hARoiySjbqdHalgBWhJmKEIbce2WbtOoQNoGPSNfd
 /qHBM1aC7KNLAqDbuUF+Xu2uDrnlKrleYD7EEb8r4SvM/ESQmB/Sgubgm93UnNznUgFi
 eF/20VbjKOTzVLTtC9ktuJk+swhncIYRCFXjpRLsrRJ4SxW4YU5RjGqPIkqj8f+bP+Kq
 yQN6qiTTp1A6osG7xuORZYgPj8Uah9lr3/wA3vps8Q79hbfvzi4eDPG9pnaibDYO/YDf
 aSmAiKZC8nwUOwidJBbCKUe4Tj2P738JjOuT+2U3jCT51EIug+kgYlothLBRG82LlP8g Cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd2w93kaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FC5e020463;
        Fri, 19 Nov 2021 04:16:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7bye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:46 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4GiwI024731;
        Fri, 19 Nov 2021 04:16:45 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-2;
        Fri, 19 Nov 2021 04:16:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Vishak G <vishak.g@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Girish K S <girish.shivananjappa@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Improve SCSI abort handling
Date:   Thu, 18 Nov 2021 23:16:31 -0500
Message-Id: <163729506335.21244.1193812894951616835.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211104181059.4129537-1-bvanassche@acm.org>
References: <20211104181059.4129537-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Riv_vCRNj11Z3NLv-lisTIYo7R37oegU
X-Proofpoint-ORIG-GUID: Riv_vCRNj11Z3NLv-lisTIYo7R37oegU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 4 Nov 2021 11:10:53 -0700, Bart Van Assche wrote:

> The following has been observed on a test setup:
> 
> WARNING: CPU: 4 PID: 250 at drivers/scsi/ufs/ufshcd.c:2737 ufshcd_queuecommand+0x468/0x65c
> Call trace:
>  ufshcd_queuecommand+0x468/0x65c
>  scsi_send_eh_cmnd+0x224/0x6a0
>  scsi_eh_test_devices+0x248/0x418
>  scsi_eh_ready_devs+0xc34/0xe58
>  scsi_error_handler+0x204/0x80c
>  kthread+0x150/0x1b4
>  ret_from_fork+0x10/0x30
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: ufs: Improve SCSI abort handling
      https://git.kernel.org/mkp/scsi/c/3ff1f6b6ba6f

-- 
Martin K. Petersen	Oracle Linux Engineering
