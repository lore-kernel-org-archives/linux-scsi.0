Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F130C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 22:11:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384CD61056
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 22:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhKEWNy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 18:13:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28034 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhKEWNx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 18:13:53 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5LjKgc014246;
        Fri, 5 Nov 2021 22:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=RY/uAk7UuUGRzRXkudoF0oBb1qcfAbwUv1D7diGPBVk=;
 b=OtGS3g8nof6YR0uiY94592Y2T7jGPtiqUXKSZKjZXCYdH3IWB9bJ0SJN7VjAvXAvT0Gd
 Jbpw3ozXoHQMcq2C4x05nCPz0AqZQT13ogi0XhY6ioFTtsOHpdFzYd41uy1byFEn7YU6
 7S9ruqqQmaZbvj7hZMkmi5yqEXoZ0iZCGtVz1KIHsYb+3+7cQO5NzxLdpl5LoSZf/Wq7
 qBXjcsuzGGKE+qGMoISXPdV8oZsWWOxg5q7O+eDmqh1qbFlvwVh8KjR2NS83CWrS9Rr8
 STRw8K0xNOIcj3CcusI8/8ORtibRDjeiO/F4J86xIcSU3UuNBukUQ7mXGuJUeKwboXQy Ag== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7bw1s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 22:11:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5M1Btr064362;
        Fri, 5 Nov 2021 22:11:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 3c4t5dkemt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Nov 2021 22:11:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nzs0QUJDpjgQrMWRiLLGGyCwDz0uZK8MsLa5PpDsi8yMvSXTVqvLQst84lJylpD0Q8lPOUJDSSS3EduJvWD59rRlPOsORbe3/55wXWX02H2JmAA2j7VgG6h9VX05HJ6cxhdiXQyFtpJ7HulMqD6mtWZRBO8TQi8uf0Fi9ypUycQ6rS2nhTCQ8a/lOJndSxYheWVNMRVdzzu+NLGSz6xz40SUq8IiFGQySykGegpyN3hCPsZt1qC8ooSxEi7NwKtNlT2lb8svw30bgtacxj8UKgZ90ARpw+BvDwGAXnuHYO4hZySQc0HIDKMJmJ2G/vy5yGdzJJ1wVx9/OtLwxbfw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RY/uAk7UuUGRzRXkudoF0oBb1qcfAbwUv1D7diGPBVk=;
 b=DhQcsqQEI10RjwyA9yESrl9VeD3DXATGmvhNDVZwnwbSbaOllLjE30aqhE9XhFyK/91EFyx9Pt6JCCF8H5g16LfLnHtJZhcqP8qeySqqjC49TM39+zKiBjcQyRwRyv85o+j3z8TM8azIJoRr3eTXfWlz8IfPB9QxG6IbJg+DGa/nFxdNxGNTUDSDdlsBEa7BDqJ//amGc5sIgA50d09AcfFU9pJJ7Xfg6H2HHLDZYZFDwDhviBNvdYfpiKihynpRrxXnvd+8EkBA97+iKRzi8CQNjxmOh9hShJQ6AudDeytitcttXeBKBjCmB7L2UXQtjosSvrT3kkDQGpP0qmPXdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RY/uAk7UuUGRzRXkudoF0oBb1qcfAbwUv1D7diGPBVk=;
 b=pRfC2kUko/sRakFCkYBC6zUsWiZihRTOhzD95Ljd3uTPgx5bR1kWgMC0kqIORpfbegaDg8rbBUWSxct1/cqbGCqUMhkmyTMp3E+bh6Dkf8/udn2pyMscAJq3+o6MpryQjmPczfat0lzdWQLzO/zC/ssQ25iE3S+h0SW5a02+8lc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2588.namprd10.prod.outlook.com (2603:10b6:5:ba::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.13; Fri, 5 Nov 2021 22:10:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 22:10:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>, Wu Bo <wubo40@huawei.com>
Subject: [PATCH 2/2] scsi: Fix hang when device state is set via sysfs
Date:   Fri,  5 Nov 2021 17:10:48 -0500
Message-Id: <20211105221048.6541-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211105221048.6541-1-michael.christie@oracle.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM3PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:0:54::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from localhost.localdomain (73.88.28.6) by DM3PR11CA0011.namprd11.prod.outlook.com (2603:10b6:0:54::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Fri, 5 Nov 2021 22:10:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5b41a49-5a32-48f3-e651-08d9a0a924cc
X-MS-TrafficTypeDiagnostic: DM6PR10MB2588:
X-Microsoft-Antispam-PRVS: <DM6PR10MB2588D0538CDA60B805669C6BF18E9@DM6PR10MB2588.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Au2QIjcQEA0lZmAF5/6tHAqJA7qxqFt/br+JPYNU5SDjQlV4LR3SeKXjwXoV4mWEXv8SwySjUHIgsr+seFnWGFWL2ESpymTVmwQCni2LKlMLxz6qi8BjmD2rlCJfJFiFbPEMr5XJbsnHznefdHELFTDclYyp0Mjl203gjfsriKS/olgGUK2WALcIVZLJ6dMAJkmyUBna7uijWLpPpFRXRJbsg8lDgx7rYe92F0ZsBccNhQrZtZzwios73RSu4qEyifXu0dLt8DQEwXERpySKhNEcKQQvxdDdISxxEsvrC0s8MctxVVuNwI6nf39KHfAM6JQISn18+8sYSG7BAFTSNjxkmA/DZ128t8XfwdvOwbZ8A+302FXrvp646zjXJFAz0uyvvG3sX/KFJv/zOKF63hG6svL4CbJNAIJ3HmuiHU5qT10/xy6lxeZthFjJxrjzKjbOuxgnf6EdzvLRoEwFzdT3I8x4hGGKD4xh3anv96dSZkubSdeEq6h/VU93XrhN/c6uSMtqaMIQiElZosxqJe4Y53y6yFpdQOi1ELex2WBFX0REjd02S8VQr/FZc6ILBtiS40HTyfORdzx0wikkeociEDZ+LBjR5S7pgFGh4I4fLUvlitGL5VyH2WBSugbwcmtU31901zDC4Hho3ISEmZ/jx10pUhPopQSzUOVMrWNrHSE8F057hGkT7spAplSDVX3YM3Xtv7S53OrQIDI5Gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(54906003)(1076003)(6666004)(186003)(26005)(316002)(4326008)(86362001)(8936002)(6486002)(6512007)(8676002)(508600001)(52116002)(956004)(66476007)(66556008)(66946007)(2616005)(5660300002)(2906002)(6506007)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5XB9CgvJG3wBxSNg3tF0Wt2+75WcBHxwhUlBSVcBCzAq1DVK7xk3iJRMM9oz?=
 =?us-ascii?Q?TVDUbkaARK+6GshjoV8iTw7x6oN7lc5+rINfPKw4hH/wWPF4JF4ND4pEzU4u?=
 =?us-ascii?Q?5c3kpw2bKiBjWE0no2F3oaEzgpzZg1e38Jjpi5pPbFkzOMccbK1JpT9w1Nm+?=
 =?us-ascii?Q?YmWv0sPMKCuz+xfvFk7QlOyPbXDzz37WbDaeK2BOE/UkBA5bUWcT7pslUPO2?=
 =?us-ascii?Q?EmF8fnaGErwv8wpM9MP9zgS4ERwVTzu9ivn1rm3mxsag9b5DfK4Mh3adhZJR?=
 =?us-ascii?Q?+FkVVBPHwwtF1bnZkPKq8f6wZZ/j7khbxJJFbBkGy9KXhaDHWvtE93PGsflj?=
 =?us-ascii?Q?R3rq9/C5NmRMzwNw1+5iSSKXIx0Y23t7S1o+dg5HPkVWUWWe6bgJ1riCdYRK?=
 =?us-ascii?Q?onc39/SUjPeuOFK3VdzJlDl3U+whpkBqukLcHPHCZTpFPkCwYImNLJGhK3ot?=
 =?us-ascii?Q?J/+xo9MnQRVdABy6C/BYJJ0zsXqde7mcwLqf6hjLSKDoB/zLlpzqn0WofEHH?=
 =?us-ascii?Q?U8ewuXLju5rtXTaQ8j6iDhLHdXInvUlxRoQ0wXZ9eELVoKSoR8llm3LCdv1y?=
 =?us-ascii?Q?AXBuTE5tnDFDPLuQSpU7jd4b3G4msatTvQkrCAhjZpQfRr8YMAZbajOKQnKO?=
 =?us-ascii?Q?RTtdTQnzHu0lG067WbKABk7/Xt/OmOJJA+8KWFGN4o1VlQUuo4baFSCaZtCg?=
 =?us-ascii?Q?6elCpMP9hIKrSEzMYOQdNPAQc2HnYzMGDJ7W+DZEWGdTxHqqOPE1oUKv/HBX?=
 =?us-ascii?Q?qZorCtR/LYbenUPgo+sHHSKGIPsXoylULpBR4xHRreNFem3+VTwW9D0Cu8x8?=
 =?us-ascii?Q?+vD0fHe5OUQ/KA+wYt8PihKGfki6ORqCXoUB5W3BOCp8hUYuq5RnRqPyItZi?=
 =?us-ascii?Q?ZHejbe1PcRQ8mAjnCJh4pPewVWDGJoP3zUyLeXVC7X9YPjvDxKug89XC2nTy?=
 =?us-ascii?Q?z3fxMChIw+FLjPihvRhSU8zJT9t94IJF121exW6qUq2rQjA0nd28hSHQK+Yh?=
 =?us-ascii?Q?dEHMnkDV1TKmao3giHIvkUFyWj9UsmIzrDiYbg20F71snjXwrkz9mNRBKAD4?=
 =?us-ascii?Q?Pd+OPbt6ASecXyXLfDPAI3QAFud5u4ipTrJZVfCagzWAHBdRpMSARaC5leki?=
 =?us-ascii?Q?Qd9K08CKFNwpFP+OUWWvq3XmiUamIGcWqtkarnJEWXmMZF6kxklWwF/BXtiL?=
 =?us-ascii?Q?EUq0NHAPr9+iz/JUkjQws60yqZs+3lk+NZsSDBiQT1BoKanuY/Eqp3lgngEg?=
 =?us-ascii?Q?FlumWFZT5KpBtB9OZ+1DHC4nwJgoIBQM4eqkaDShhNID5/+srlrTrSfk3XBO?=
 =?us-ascii?Q?riKvgiXwlfp321MaKy0YhxdH9BCUBfyusWJhtaSMRqShByuNRLrv2GRs+oBo?=
 =?us-ascii?Q?Yv7es1UtcKXFK2Ns2MxxdDOFK0Yh5Szv36AOUL3OrUb32KGQFEMz/NpbgoJj?=
 =?us-ascii?Q?EF6R6G6Z0d1l2IsKbnYrm4yB24mW5UZKN4gcvrUx8jkQ4rNEqoCJTRKQo8UW?=
 =?us-ascii?Q?uCUHnCw2Q10a50FkbmZdSWhQjAg3vGAk5VFW3hUh5jTWz0mc8pnav8St59Mr?=
 =?us-ascii?Q?o6PoUEvrMTuJXpAH6kWcOieLipYi7j1jzy3FwfW92O81XPdaWPJzxsTmu+15?=
 =?us-ascii?Q?9DFRQdh922D1zDgfJwsVHsLr24LIosggqvTNUME8N2dbZrhDCFQHNeblAt82?=
 =?us-ascii?Q?rzbKBA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b41a49-5a32-48f3-e651-08d9a0a924cc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 22:10:57.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qtYZRs4unv6zLs5nOzdtnjEUd4bAbrDdheXbDSYSiwFm9+rqM2ARJ2ASC/Sj++BptdW0tCorZUeube/qyvaLAGY6brjUWgf0RdXqcOZ+8A0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2588
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050119
X-Proofpoint-GUID: WOzvoog8s5H0-u3vs8fwwCbmEbOCpbBo
X-Proofpoint-ORIG-GUID: WOzvoog8s5H0-u3vs8fwwCbmEbOCpbBo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a regression added with:

commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
offlinining device")

The problem is that after iSCSI recovery, iscsid will call into the kernel
to set the dev's state to running, and with that patch we now call
scsi_rescan_device with the state_mutex held. If the scsi error handler
thread is just starting to test the device in scsi_send_eh_cmnd then it's
going to try to grab the state_mutex.

We are then stuck, because when scsi_rescan_device tries to send its IO
scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
which will return true (the host state is still in recovery) and IO will
just be requeued. scsi_send_eh_cmnd will then never be able to grab the
state_mutex to finish error handling.

To prevent the deadlock this moves the rescan related code to after we
drop the state_mutex.

This also adds a check for if we are already in the running state. This
prevents extra scans and helps the iscsid case where if the transport
class has already onlined the device during it's recovery process then we
don't need userspace to do it again plus possibly block that daemon.

Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
offlinining device")
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: lijinlin <lijinlin3@huawei.com>
Cc: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a35841b34bfd..53e23a7bc0d3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -797,6 +797,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
+	bool rescan_dev = false;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -815,20 +816,27 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	}
 
 	mutex_lock(&sdev->state_mutex);
-	ret = scsi_device_set_state(sdev, state);
-	/*
-	 * If the device state changes to SDEV_RUNNING, we need to
-	 * run the queue to avoid I/O hang, and rescan the device
-	 * to revalidate it. Running the queue first is necessary
-	 * because another thread may be waiting inside
-	 * blk_mq_freeze_queue_wait() and because that call may be
-	 * waiting for pending I/O to finish.
-	 */
-	if (ret == 0 && state == SDEV_RUNNING) {
+	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
+		ret = count;
+	} else {
+		ret = scsi_device_set_state(sdev, state);
+		if (ret == 0 && state == SDEV_RUNNING)
+			rescan_dev = true;
+	}
+	mutex_unlock(&sdev->state_mutex);
+
+	if (rescan_dev) {
+		/*
+		 * If the device state changes to SDEV_RUNNING, we need to
+		 * run the queue to avoid I/O hang, and rescan the device
+		 * to revalidate it. Running the queue first is necessary
+		 * because another thread may be waiting inside
+		 * blk_mq_freeze_queue_wait() and because that call may be
+		 * waiting for pending I/O to finish.
+		 */
 		blk_mq_run_hw_queues(sdev->request_queue, true);
 		scsi_rescan_device(dev);
 	}
-	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
 }
-- 
2.25.1

