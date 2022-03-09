Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0FBC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 04:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiCIEP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiCIEPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 23:15:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4331C3B2A8
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 20:14:19 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22949h3V021319;
        Wed, 9 Mar 2022 04:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=C4sgUEjA7yuLa4FscLWCjMWMJDk3HJCaDif4HGMao0s=;
 b=LyuFOV7PgfI3VwDWVRVAw8kgXUQCXQcgX2NcZTWNgwV7ODCNyvNZ0jaIi6LHfgcY8m3l
 0vWyxfUI+abA8tyS0okuOAXu4QQVJyCg5au3DmOXw2cCsEUicOL4FtD5KHa7EWxRihoT
 GSYq3vQaDfSA75rvuJAh9WRg3VFv12hlSsHAehwmacbJN9WgYVcAgwP+ebv9pT0NYW/d
 qY83Ajl3tlUMVMTunZ5dLqFUKLbw78o6+zstZhXS8xpYOwAWWSDN5FL+VqKBwM2aOyOx
 RkgA80O/AZObUXScOuKV0SD1uIApAko0PnW7mPfZNqI2WXaKvdJkIEN9a8tDNF/EvnRQ 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsguq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22947J1C166791;
        Wed, 9 Mar 2022 04:14:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qden-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 04:14:13 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2294EAeL174884;
        Wed, 9 Mar 2022 04:14:12 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3ekyp2qddd-4;
        Wed, 09 Mar 2022 04:14:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, njavali@marvell.com,
        liuzhengyuang521@gmail.com, mrangankar@marvell.com,
        Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        lduncan@suse.com, GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] iscsi: Speed up failover with lots of devices.
Date:   Tue,  8 Mar 2022 23:14:08 -0500
Message-Id: <164679903743.29335.12851352477345747123.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220226230435.38733-1-michael.christie@oracle.com>
References: <20220226230435.38733-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: uPCxyjHCxgN4nhImOn4tWFt_uYbdUGpF
X-Proofpoint-ORIG-GUID: uPCxyjHCxgN4nhImOn4tWFt_uYbdUGpF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 26 Feb 2022 17:04:29 -0600, Mike Christie wrote:

> In:
> 
> https://lore.kernel.org/all/CAK3e-EZbJMDHkozGiz8LnMNAZ+SoCA+QeK0kpkqM4vQ4pz86SQ@mail.gmail.com/t/
> 
> Zhengyuan Liu found an issue where failovers are taking a long time
> with lots of devices (/dev/sdXYZ nodes). The problem is that iscsid
> expects most nl operations to be fast (ignoring mem issues) and when
> the session block code was written blocking a queue/scsi_device was
> just setting some flag bits and state values more or less. Now a block
> call will actually handle IO that has been sent to the driver, so it
> can be expensive. When you add in more and more devices, then a
> session block call will take longer and longer.
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/6] scsi: iscsi: Fix recovery and ublocking race.
      https://git.kernel.org/mkp/scsi/c/8dd3dff3bf3e
[2/6] scsi: iscsi: Speed up session unblocking and removal.
      https://git.kernel.org/mkp/scsi/c/b07c348f8ffb
[3/6] scsi: iscsi: Remove iscsi_scan_finished.
      https://git.kernel.org/mkp/scsi/c/d8ec5d67b8bb
[4/6] scsi: iscsi, ql4: Use per session workqueue for unbinding.
      https://git.kernel.org/mkp/scsi/c/5842ea366831
[5/6] scsi: iscsi: Use the session workqueue for recovery.
      https://git.kernel.org/mkp/scsi/c/7cb6683ce761
[6/6] scsi: iscsi: Drop temp workq_name.
      https://git.kernel.org/mkp/scsi/c/69af1c9577aa

-- 
Martin K. Petersen	Oracle Linux Engineering
