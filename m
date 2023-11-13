Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87D2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 02:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjKNCz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 21:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjKNCz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 21:55:57 -0500
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2012.outbound.protection.outlook.com [40.92.107.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A5C12D
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 18:55:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpu1AeijMSulQNldXgcOpDuZnBHyeHIBUHLPDsHxTa7cS0FNGAt/sDMs2bY6a9rOMqNxg0XoSrmRTAt6844bcS4nWOZIddefJnR9O/z74tZvwfuWVtsSPweDWsBkzpdcKqJ5m+PFaOilAGgHoZUxq7pjP7r7Bj5l5WbSyYHvRSkKo4GRXemWf/cgZbKNg36hdphhh1XrekjvpvvlY1CbvtZ3sphzKS87TsREVVfvoeiESnsAJ3+H1VWoi9Q9I+La76Jqp9/Bw8aOzDGjqUNLEN9/NWc8ywhLekZebIpA1ZbM0IZG9eVnQqqOdy1ZiSe00xbfEzwcujtWz/1jVjMGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RnnzC6YYAtPnbWwIeEUVDSMjCuV9IIsrGT31xU9wWo=;
 b=UkQVvVaLUyhfa/ofm7uXsb8u6kwOmwEJFDrxSlQMMjKPBbEwBJZ3aKfCchX2aa2MZDl48f/4lktnu7vrtvtoNhuDxvB5MX41b7vXoS4NJBdzkZaPhLJsCrnfJA/WsLqtp3c8819X8MlHzuBiFi/knbCV7zWBnSoi4cCUVavWsAzo24i5lhGMb+QfJtQdXjCKcVcIVtQZ6AZTtPFrKji5o/wyEcB4M0K2S8EIPMp5wCJTuvnDeFhXjqM7SOTsmZX8G5sbhDquQ7FTnoPszScAN82OqaUDYIowPxNCOtfQMdZBttDD/gdGLaYATGr1KyqQy3XJ+fsVeROqJdu92DGNuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RnnzC6YYAtPnbWwIeEUVDSMjCuV9IIsrGT31xU9wWo=;
 b=dj0rEa9liiwvybo11ZLrFt/UqNX4ogw394TjFqPPSOQbGM6eAhv5+yceuNViYeqL2P9ONMxxeVoaalKFDI1CuP88n8AtCE/2lgoHX+aU1frh4hmh63Z7XKUAXjjSecw1qGx6tZ7sjgXRGsIxzVEpolrg3JxsWI4Ingq0yAfPynbXfi8LBHfLCaMvYqhCifYsk0s38qf0Zovd+5OZj+sqDMHnfBV7+5OnWUU3jGFBKBjJBljHBke9QNNCjnG57HBaJ4pb9RVjbvEzpdQEDbunrRwaA426Z/qSdw0UyiCx2fYb9NfewHQmyIvYL4HQnmO0Yr98yEToDoK7qFjDx8GsHg==
Received: from SEYPR03MB6507.apcprd03.prod.outlook.com (2603:1096:101:54::8)
 by TYZPR03MB7027.apcprd03.prod.outlook.com (2603:1096:400:331::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 02:55:49 +0000
Received: from SEYPR03MB6507.apcprd03.prod.outlook.com
 ([fe80::41f9:52ea:4587:2b80]) by SEYPR03MB6507.apcprd03.prod.outlook.com
 ([fe80::41f9:52ea:4587:2b80%3]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 02:55:49 +0000
From:   zilong zhang <NeoPerceval@outlook.com>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, trivial@kernel.org,
        zilong zhang <NeoPerceval@outlook.com>
Subject: [PATCH] drivers: fix typo in drivers/scsi/st.c
Date:   Mon, 13 Nov 2023 22:33:59 +0800
Message-ID: <SEYPR03MB6507111C9AF0BBE744EA7841A2B2A@SEYPR03MB6507.apcprd03.prod.outlook.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [awhTHTnLClHkhsGQJFeXGQeVEyLzyAp7]
X-ClientProxiedBy: TYCP286CA0004.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::13) To SEYPR03MB6507.apcprd03.prod.outlook.com
 (2603:1096:101:54::8)
X-Microsoft-Original-Message-ID: <20231113143359.11653-1-NeoPerceval@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEYPR03MB6507:EE_|TYZPR03MB7027:EE_
X-MS-Office365-Filtering-Correlation-Id: 41d70d2d-4a61-4816-04a6-08dbe4bd34fe
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c1FKsIbD1auD5zIn/YIBKdhUigInhR3M62gH4Tz2g0GTFDrKq3e5EcLYo3r4uY21cJj9U+3rV1S5RXowV3m8Z3zryJSRiPXHLJkWXqDpDxoWIvJhdrNIiIMsXkSmtiFKIquZUxZnf/I9PqCGm6msq8fcMyswqKY5Wc57BZa824a5oY229LfwZmmBvxII+LM+WHJIRuaYfxxLI8CezDwfQPi3/hFPYoI1Wb0IKSu4BtjSWG7Skw636Dnpd7lyRQDE4wIjJjY668uIOWyelGkIYNQbER00bQrT0ILDatFyEg7B/54Deiklkih9f74fGr1cyNmNRGeX/N3gejvnFWS56jaHkvjJtg3taX8MQkOYOm5842bYlrKNCTKMfTqZqnYW9HDwf0y9k7igN5eABOMXi4C+ybNUJc7bFG5kgiZfm+uVFgXw3yh1+9v6PCD5+C0uSbbFrQnaTXexVGCsMJfn5t65Zi6+h6Fyn9lTws2kzkYnmS9Ffl3c+IDEw0qcqTG9KAsmpD9DkGAbA4GyvPUoMvit23Mw9FVOWiJKBI23TAVOnIMoly/FM0rls5J6k1UGVVAhBnB7Cp1GKfme5JvCKRjKgolydf2QY1kfIOcBP14rgwrG/+OsCi0erc9grGPO
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rWtsUHS+OGDYPhnIhkjZ8UWdIygVxZ7oV9B+LvQ2f2tZrWmX84I8ITDIlab8?=
 =?us-ascii?Q?qwZGNg2+8E73fX65Q+hFwT4Bg03Msb+rg1JdeQoNI8GWDtcIxU1/hbitouHl?=
 =?us-ascii?Q?QwLRz1gtJ5l/rnb4vrdPs3OuS9xP3pob/BxApIdZR96JNNioTXiFMUJirnIO?=
 =?us-ascii?Q?hAVZdQm3jqxgYbxd2gf9ZwC4DzghLjSGUy9Px/EwWprXdwajtsfgtoVf/aui?=
 =?us-ascii?Q?l2rPloiugchZzdF9Y15rVnhakWCrYu4blxXmps5KVHejWNVlCRxlHcBIrdQu?=
 =?us-ascii?Q?p1aT81+zOwng1tjoxxT14gXMpthcFLu4qJ3/CQQiEaqqOeyhnp4zo0qYu79e?=
 =?us-ascii?Q?VEjuPcXV7K8mqqsQyOgMo3T2a9RnC8AoWGYEYYOaY53HtnWIFVSBxPGzGScM?=
 =?us-ascii?Q?e2AS0VzQlWJQlXDH7QE5+VEuVcipvbfK1vD25VzDIB1PUpcrrSd7ttP08JK7?=
 =?us-ascii?Q?mTgj8SaQeshJd5btZdilqdRQFtP7prR2e4PqLlGkUb+ZshSaHYyUIFdCQRUH?=
 =?us-ascii?Q?PScLQoCf7/AFjMMHWYMfFVeJgKtwgZxtZwp6htxmGuuXTlfa+j5J7oAWsEFe?=
 =?us-ascii?Q?6a9bq7Eq6jgDTRHc8mus5rfX/HK874yQvfEM7SqsAF+gIIGhgt90DeZCsoDm?=
 =?us-ascii?Q?G3F69JT4bC3PbXILOPHN2jv4Cg9BuIbekn8fN667cTXghsLGG6StVrclWZFu?=
 =?us-ascii?Q?Lnghdwq5i89gByvriCq4Zhj/bKsrwfuvlXA/mdzhuyAGyPrmvqQz62Pq3CMW?=
 =?us-ascii?Q?vrnhcXWDFecd9/JkW8mLMCojhRzp2mzNtmojxEiqIeovtvonslxNu2McOQzZ?=
 =?us-ascii?Q?zrtkCCn3MAXQgtk3oDZ4Pj4D6Go0TWfMT7hzkOZ/vbvBhrbIip6YgV69wjQx?=
 =?us-ascii?Q?5Vvv3XEecPhvIzUSoGMbymrVoKMmjoVXt1zj9Cc0nZIXk0RrBtcXLqnATZE9?=
 =?us-ascii?Q?KXyj2jEn0tylTW5/MZtcRgGfQj9WJ7E2PFOX+9RHTzJQmTo6JMfl1AMT/Zd0?=
 =?us-ascii?Q?7qJC1uJCh2StSR0dy386O0FXEb2kHPve+ZxmKAtD/SdIjaeuxBbXT91Und2B?=
 =?us-ascii?Q?u29uV4RCYtuVgvrANzt8YRpjfx2FVxgU3p4wqkfE7L0z7L3wdkyHWkIlVQLw?=
 =?us-ascii?Q?/rHNYX6fTIkAjsgotG9iWY9ThVPes6I8iEroqT2LrUnovfMHw0+DGw9/U8A8?=
 =?us-ascii?Q?9J2VYKYLEbQ2Yp6exdfjIS/wPm0VowHMCCSQpZMfq4JWKVp4dXp0578T07w?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d70d2d-4a61-4816-04a6-08dbe4bd34fe
X-MS-Exchange-CrossTenant-AuthSource: SEYPR03MB6507.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 02:55:49.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace invisible character with a space.
The diff looks like this on my terminal:

-^L
+

Signed-off-by: zilong zhang <NeoPerceval@outlook.com>
---
 drivers/scsi/st.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 338aa8c42968..19d86257036d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -230,7 +230,7 @@ static DEFINE_SPINLOCK(st_use_lock);
 static DEFINE_IDR(st_index_idr);
 
 
-
+
 #ifndef SIGS_FROM_OSST
 #define SIGS_FROM_OSST \
 	{"OnStream", "SC-", "", "osst"}, \
@@ -308,7 +308,7 @@ static char * st_incompatible(struct scsi_device* SDp)
 		}
 	return NULL;
 }
-
+
 
 #define st_printk(prefix, t, fmt, a...) \
 	sdev_prefix_printk(prefix, (t)->device, (t)->name, fmt, ##a)
@@ -880,7 +880,7 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	return result;
 
 }
-
+
 /* Set the mode parameters */
 static int set_mode_densblk(struct scsi_tape * STp, struct st_modedef * STm)
 {
@@ -955,7 +955,7 @@ static void reset_state(struct scsi_tape *STp)
 		STp->new_partition = STp->partition;
 	}
 }
-
+
 /* Test if the drive is ready. Returns either one of the codes below or a negative system
    error code. */
 #define CHKRES_READY       0
@@ -1244,7 +1244,7 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 }
 
 
-/* Open the device. Needs to take the BKL only because of incrementing the SCSI host
+/* Open the device. Needs to take the BKL only because of incrementing the SCSI host
    module count. */
 static int st_open(struct inode *inode, struct file *filp)
 {
@@ -1337,7 +1337,7 @@ static int st_open(struct inode *inode, struct file *filp)
 	return retval;
 
 }
-
+
 
 /* Flush the tape buffer before close */
 static int st_flush(struct file *filp, fl_owner_t id)
@@ -1891,7 +1891,7 @@ st_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 
 	return retval;
 }
-
+
 /* Read data from the tape. Returns zero in the normal case, one if the
    eof status has changed, and the negative error code in case of a
    fatal error. Otherwise updates the buffer and the eof state.
@@ -2090,7 +2090,7 @@ static long read_tape(struct scsi_tape *STp, long count,
 	}
 	return retval;
 }
-
+
 
 /* Read command */
 static ssize_t
@@ -2238,7 +2238,7 @@ st_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	return retval;
 }
-
+
 
 
 DEB(
@@ -2452,7 +2452,7 @@ static int st_set_options(struct scsi_tape *STp, long options)
 
 	return 0;
 }
-
+
 #define MODE_HEADER_LENGTH  4
 
 /* Mode header and page byte offsets */
@@ -2670,7 +2670,7 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 
 	return retval;
 }
-
+
 #if DEBUG
 #define ST_DEB_FORWARD  0
 #define ST_DEB_BACKWARD 1
@@ -3096,7 +3096,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 
 	return ioctl_result;
 }
-
+
 
 /* Get the tape position. If bt == 2, arg points into a kernel space mt_loc
    structure. */
@@ -3288,7 +3288,7 @@ static int switch_partition(struct scsi_tape *STp)
 		STps->last_block_visited = 0;
 	return set_location(STp, STps->last_block_visited, STp->new_partition, 1);
 }
-
+
 /* Functions for reading and writing the medium partition mode page. */
 
 #define PART_PAGE   0x11
@@ -3496,7 +3496,7 @@ static int partition_tape(struct scsi_tape *STp, int size)
 out:
 	return result;
 }
-
+
 
 
 /* The ioctl command */
@@ -3864,7 +3864,7 @@ static long st_compat_ioctl(struct file *file, unsigned int cmd_in, unsigned lon
 }
 #endif
 
-
+
 
 /* Try to allocate a new tape buffer. Calling function must not hold
    dev_arr_lock. */
-- 
2.34.1

