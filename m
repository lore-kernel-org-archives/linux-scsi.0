Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06419C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 17:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 960FF2076B
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 17:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="g0/9e5P3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbgHKRDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 13:03:21 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:38432
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729004AbgHKRDU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Aug 2020 13:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVzmzKn5EhPtPifoHK4DWhqrpPhqEH4ECSYyG8T7m9KXD/UIeAEMkN7OocJY7WIVexw9llG+OTcGInMLViJOp6M/tLUW3O2AClqPwOFFqGnXa4EipKqFVPUf9etbb5jrPBIAmhnejWzoKoz6F9sV/JnWkUV9/lg1ityN1uPUhtaTCk2rQ5FuQwtagdbT+7W2z1+ITfnjfcdiHpY162I3eRn4C6UmsyPFYtuDrFSGoc63jIRX3ZCINgG0OWCCmLW7UFj2AHjwDQD2k4qkcrfSzvStobAJye3FNFWdbNqJALuW2MWmERuFVWMW/HT0tt+srlEMc6npdewgZPqBPJ9lLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIX8KW1i2pdJAgqyeJuJ1sVl90ZFGJ3jjnVtq0ZvlH8=;
 b=iz6L5DmTeOhD8yfZX0bxupk8PTnogZlF/6Rujjm6bVZHlSat6WnIxv+1lmBqdysWJu5mTHAI9DigUaRyrmWh0obZs7px9Z4R6wUAsM1L+1y9svF3tLUNuMqlSqkFVxUcpinZD0o+D2ZnwdhLaR7HtMWGaUtbERBoHisaQwRl91311dxU7XVfhM+dvFgs/6Jh8845PYriOGjLEiTwmcnlGWuQTWTtIKIXIQGv0sqBQP7Jt5oOiUEQHm0FVtbD+GjGM3UNiQ/vLmVjKkjLZ0O1gOaYa5i9jCg4bwuWFUAo6YA4WXIApSdTH3yBwXpmGAU9e/MIgoaDJkDUtYf1J++lEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIX8KW1i2pdJAgqyeJuJ1sVl90ZFGJ3jjnVtq0ZvlH8=;
 b=g0/9e5P3yRNiLG7B/yCPY3Tok4JM1xkm6pKRDssBXcHF4YxpP5nh5RGJ9IECoFUqC+rNC+yZB8eXEq9fv7mP6RDxLpxZ4mi8ECioNXk8W3ymbrHxOpSiIr4wYAn3Bdquu2m9BdpHM1P6CbwMl36OxGxhnlw8RdiXr325QtJmWWU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=ddn.com;
Received: from DM6PR19MB3849.namprd19.prod.outlook.com (2603:10b6:5:24a::8) by
 DM6PR19MB3994.namprd19.prod.outlook.com (2603:10b6:5:24d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.15; Tue, 11 Aug 2020 17:03:18 +0000
Received: from DM6PR19MB3849.namprd19.prod.outlook.com
 ([fe80::74aa:15ed:66c1:777e]) by DM6PR19MB3849.namprd19.prod.outlook.com
 ([fe80::74aa:15ed:66c1:777e%6]) with mapi id 15.20.3261.025; Tue, 11 Aug 2020
 17:03:18 +0000
From:   Greg Edwards <gedwards@ddn.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Greg Edwards <gedwards@ddn.com>
Subject: [PATCH] scsi: fix race reading async_scan value
Date:   Tue, 11 Aug 2020 11:02:38 -0600
Message-Id: <20200811170238.72879-1-gedwards@ddn.com>
X-Mailer: git-send-email 2.28.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY4PR21CA0016.namprd21.prod.outlook.com
 (2603:10b6:903:dd::26) To DM6PR19MB3849.namprd19.prod.outlook.com
 (2603:10b6:5:24a::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pneuma.datadirectnet.com (2601:281:8200:f242::e9c) by CY4PR21CA0016.namprd21.prod.outlook.com (2603:10b6:903:dd::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.2 via Frontend Transport; Tue, 11 Aug 2020 17:03:17 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [2601:281:8200:f242::e9c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfed5a74-374f-4d63-a90e-08d83e187185
X-MS-TrafficTypeDiagnostic: DM6PR19MB3994:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR19MB399493EFDDD46FD7151AB960CE450@DM6PR19MB3994.namprd19.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vxPKbz7JEfLYtANfb3nevA5t5MU62HyJxzsvfbL1HshjogiyHLEpCGX0hNQm13HBLaWKAhUSEU6uAx9TsCI9Z+3IiIJrhKltBr8ldxwuDaqyBdmtCl+aKihMJ03Opqk0ECQMrKiGfE2qmbfEhTF+ni1Sbi8J7RtKy6OL0FFTWhhCXXQYv4av7CluSMYj4EXk6PYic9q11oJl+6vDrHpCGL3uDVO4+7OOEA6eCUTHI4dzkg3RWODYasirjZkhKKofon7rOnVzaAxo09pK4x48604X7V++winXFNQTWPzy6GMZKplFvcxucJgFYskp2MMDaFIbrArd78b+6tOTyFaE0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB3849.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(498600001)(6486002)(1076003)(52116002)(16526019)(6916009)(4326008)(5660300002)(83380400001)(66946007)(6666004)(8936002)(8676002)(2906002)(186003)(2616005)(36756003)(66556008)(6512007)(86362001)(66476007)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jI+5xefgtEAQN6nB3IibFNaIE/HvGcsM6eSejMJ/X/H12eF+fIGclvz497OUIQ2vUgQMLn0qr8RxkOM9tQGjpjsrrtzg7+PJIjJvV/DInkq3qVJiFMgXNgIild1FCdvcXCfYB77OF6G4MlWPaqaJd6u/KZaWG6sQ6azRPyzQoxYRBCkT/eAUqdMGtC/mLDlfKhWGZzCWbGBNd2oA7XBMgYVCM6E8BoG+GVGHQqcrghjQ5HW4hdFR3gOgo5AND8vB9J/xli79y1rZksP7wgrhEOeB9jmI8w6/c06rj/R3gwCZOqJyDWSYY+KUQn2sCo35MazdkfqU+c+XhRfYB8DUqhVNps3kjiZL7Fjb6QjqnovZtus2/99/iodaF8ehAkL1gSxs/69vKAPh/x4M51zEObc3muI+XAipzjFfNHxz32PwqzUvf6nvFjSfu17mteDlshcDir2XrFMTbLdfLPRrXxtrLCszjAltGSDwGQU7uDxUrkV7Ify+835QGUU7eEH93xkFHpRxnk48Du0MQSW+OuL76dtsM8cYXnRCC6BdfAEjNWpzk0lsMW5WOtX2FYrk3clSXqk+g26ZR7QAPeXBZAB7g5K6lceCvVvXm0qGLjvySbq1nYblNskA15Brj8Gt2VvK23eiRkbzaQZjMy3+hssQhUZFC6pFPrtLP9HWPg8=
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfed5a74-374f-4d63-a90e-08d83e187185
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB3849.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2020 17:03:17.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fbIQpLm6BHrr6EdE5MBWKZKlA75GVnWwzWyftFAP+c5k73KgPr0KcsE0xLKf1gwr+87kQGfQDlIiG2abpMPBOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB3994
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Readers of async_scan are protected by scan_mutex, except one at the
beginning of scsi_prep_async_scan().  Threads can race reading the
async_scan value, which may result in two threads for the same Scsi_Host
going down the do_async_scan() path at the same time.  One of those
threads may then hit the following check in scsi_scan_host_selected()
after async_scan has been set back to zero:

        if (!shost->async_scan)
                scsi_complete_async_scans();

and a hung task is encountered:

[  370.197123] INFO: task kworker/u40:18:967 blocked for more than 122 seconds.
[  370.198550]       Not tainted 5.8.0 #1
[  370.199538] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  370.201492] kworker/u40:18  D13768   967      2 0x00004000
[  370.202699] Workqueue: events_unbound async_run_entry_fn
[  370.203905] Call Trace:
[  370.204668]  __schedule+0x229/0x690
[  370.205620]  ? vprintk_store+0x114/0x1d0
[  370.206627]  schedule+0x45/0xb0
[  370.207527]  schedule_timeout+0x10f/0x160
[  370.208558]  wait_for_completion+0x81/0xe0
[  370.209599]  scsi_complete_async_scans+0xe4/0x140
[  370.210722]  scsi_scan_host_selected+0x8f/0x100
[  370.211774]  do_scan_async+0x13/0x140
[  370.212746]  async_run_entry_fn+0x32/0xe0
[  370.213776]  process_one_work+0x1d2/0x390
[  370.214799]  worker_thread+0x48/0x3c0
[  370.215777]  ? rescuer_thread+0x3e0/0x3e0
[  370.216807]  kthread+0x116/0x130
[  370.217720]  ? kthread_create_worker_on_cpu+0x60/0x60
[  370.218906]  ret_from_fork+0x1f/0x30

The issue may be observed when hot plugging many LUNs to a virtio_scsi
HBA at once.  The virtio_scsi event queue is small, and can easily
overflow, with the target reporting VIRTIO_SCSI_T_EVENTS_MISSED.
Multiple threads may be processing different VIRTIO_SCSI_T_EVENTS_MISSED
events simultaneously, and waiting on the scan_mutex in
scsi_prep_async_scan() behind other successfully processed events adding
devices.

Signed-off-by: Greg Edwards <gedwards@ddn.com>
---
 drivers/scsi/scsi_scan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f2437a7570ce..7dd113556234 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1720,20 +1720,20 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
 
+	mutex_lock(&shost->scan_mutex);
 	if (shost->async_scan) {
 		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
-		return NULL;
+		goto err_unlock;
 	}
 
 	data = kmalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
-		goto err;
+		goto err_unlock;
 	data->shost = scsi_host_get(shost);
 	if (!data->shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->async_scan = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -1749,6 +1749,8 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 
  err:
 	kfree(data);
+ err_unlock:
+	mutex_unlock(&shost->scan_mutex);
 	return NULL;
 }
 
-- 
2.28.0

