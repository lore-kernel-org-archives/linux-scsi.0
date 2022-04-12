Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2008C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 02:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiDLCjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 22:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiDLCjY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 22:39:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D569319C31
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 19:37:03 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1TOBL012784;
        Tue, 12 Apr 2022 02:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=bIstjrNzf0VHOBKtkkhVcaeZcLIV1/eRD/uAPwXWhvM=;
 b=T0yNvOCDsB5sQ5Da++Jt/1X13vSuXAj9UI/CvqkkK4bMt2Iy1fna4oq0fL5eCp1riTsB
 z8BI7Xoi0nyBO8b45AXBVV472o8EfsXZcr85vulqouNJCsMhYKyJUAc09pd3dTKCK1ip
 Y9CWnuCVi9OWKLLw2PWGhRn70kXyDs7HEFvKm8O6b8bhgLTdQfWL5QkT7cWGMo9d2lAZ
 xcG1MorwHjoNlKyZOt7b+oEGKNYBCr1nKU/4bXvB+yr8pTPZKA3gUNRsDiSbGFbA2UXi
 U7DQApWDZOWKcOweoBFUBJEhch+n6rC+0FcCDRrRHxJxr4yGj4BazCTaSTqcANkAd9jc 9w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwfk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 02:36:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C2VhGb031344;
        Tue, 12 Apr 2022 02:36:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2eg28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 02:36:56 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 23C2ar94002744;
        Tue, 12 Apr 2022 02:36:55 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2efv6-2;
        Tue, 12 Apr 2022 02:36:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Bob Pearson <rpearsonhpe@gmail.com>
Subject: Re: [PATCH] Revert "scsi: scsi_debug: Address races following module load"
Date:   Mon, 11 Apr 2022 22:36:50 -0400
Message-Id: <164973085491.8307.6548937708800204079.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220409043704.28573-1-bvanassche@acm.org>
References: <20220409043704.28573-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Z2UMkfTzlTHfw6mPPSSSrx0drG2aNsjJ
X-Proofpoint-GUID: Z2UMkfTzlTHfw6mPPSSSrx0drG2aNsjJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Apr 2022 21:37:03 -0700, Bart Van Assche wrote:

> Revert the patch mentioned in the subject since it blocks I/O after
> module unload has started while this is a legitimate use case. For e.g.
> blktests test case srp/001 that patch causes a command timeout to be
> triggered for the following call stack:
> 
> __schedule+0x4c3/0xd20
> schedule+0x82/0x110
> schedule_timeout+0x122/0x200
> io_schedule_timeout+0x7b/0xc0
> __wait_for_common+0x2bc/0x380
> wait_for_completion_io_timeout+0x1d/0x20
> blk_execute_rq+0x1db/0x200
> __scsi_execute+0x1fb/0x310
> sd_sync_cache+0x155/0x2c0 [sd_mod]
> sd_shutdown+0xbb/0x190 [sd_mod]
> sd_remove+0x5b/0x80 [sd_mod]
> device_remove+0x9a/0xb0
> device_release_driver_internal+0x2c5/0x360
> device_release_driver+0x12/0x20
> bus_remove_device+0x1aa/0x270
> device_del+0x2d4/0x640
> __scsi_remove_device+0x168/0x1a0
> scsi_forget_host+0xa8/0xb0
> scsi_remove_host+0x9b/0x150
> sdebug_driver_remove+0x3d/0x140 [scsi_debug]
> device_remove+0x6f/0xb0
> device_release_driver_internal+0x2c5/0x360
> device_release_driver+0x12/0x20
> bus_remove_device+0x1aa/0x270
> device_del+0x2d4/0x640
> device_unregister+0x18/0x70
> sdebug_do_remove_host+0x138/0x180 [scsi_debug]
> scsi_debug_exit+0x45/0xd5 [scsi_debug]
> __do_sys_delete_module.constprop.0+0x210/0x320
> __x64_sys_delete_module+0x1f/0x30
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] Revert "scsi: scsi_debug: Address races following module load"
      https://git.kernel.org/mkp/scsi/c/f19fe8f354a6

-- 
Martin K. Petersen	Oracle Linux Engineering
