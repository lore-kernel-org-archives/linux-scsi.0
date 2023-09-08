Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D141EEB570
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Sep 2023 20:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbjIHUsM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Sep 2023 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjIHUsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2023 16:48:12 -0400
Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F309C
        for <linux-scsi@vger.kernel.org>; Fri,  8 Sep 2023 13:48:07 -0700 (PDT)
Received: from [192.168.1.103] (178.176.76.159) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.14; Fri, 8 Sep 2023
 23:48:04 +0300
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: scsi: hosts: check result of scsi_host_set_state() in
 scsi_add_host_with_dma()
Organization: Open Mobile Platform
Message-ID: <812c97ce-9b41-400a-9eb9-ddeef0156bbe@omp.ru>
Date:   Fri, 8 Sep 2023 23:48:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [178.176.76.159]
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.59, Database issued on: 09/08/2023 20:34:53
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 179760 [Sep 08 2023]
X-KSE-AntiSpam-Info: Version: 5.9.59.0
X-KSE-AntiSpam-Info: Envelope from: s.shtylyov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;omp.ru:7.1.1
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: {rdns complete}
X-KSE-AntiSpam-Info: {fromrtbl complete}
X-KSE-AntiSpam-Info: ApMailHostAddress: 178.176.76.159
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=none header.from=omp.ru;spf=none
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 09/08/2023 20:39:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 9/8/2023 5:21:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SCSI core uses scsi_host_set_state() to control the host's state machine;
this function returns 0 on success and -EINVAL on failure to change host's
state. The only place where the result of scsi_host_set_state() is ignored
is in scsi_add_host_with_dma() -- that blithely continues initializing the
SCSI host even if the host's state couldn't be set to SHOST_RUNNING...
I guess the logic behind this is that scsi_add_host_with_dma() call is
always preceded by scsi_host_alloc() call which leaves the host's state
machine in the SHOST_CREATED state which is a valid previous state for
SHOST_RUNNING. I think we'd better check result of scsi_host_set_state()
always -- better safe than sorry!

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>

---
The patch is against the 'for-next' branch of Martin Petersen's 'scsi.git' repo.

 drivers/scsi/hosts.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: scsi/drivers/scsi/hosts.c
===================================================================
--- scsi.orig/drivers/scsi/hosts.c
+++ scsi/drivers/scsi/hosts.c
@@ -272,7 +272,10 @@ int scsi_add_host_with_dma(struct Scsi_H
 	if (error)
 		goto out_disable_runtime_pm;
 
-	scsi_host_set_state(shost, SHOST_RUNNING);
+	error = scsi_host_set_state(shost, SHOST_RUNNING);
+	if (error)
+		goto out_disable_runtime_pm;
+
 	get_device(shost->shost_gendev.parent);
 
 	device_enable_async_suspend(&shost->shost_dev);
