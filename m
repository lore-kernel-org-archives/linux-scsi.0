Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302DDC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJPUAS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiJPUAM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6376223BD8
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GE3cfF014633;
        Sun, 16 Oct 2022 20:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=mRNLj4vSMuOR1rCIBkdKcazmODqM+n8UKCUs8G1YbBuNSbuuhgGJ7zvoZ0MN11guU9xo
 DZvHzb5AB/+vcGFKyGoWP9VFbmtxvA6FyTNndQd9m4hiH9OaDvniYfD862QLjaWMd3cd
 5e7k0zk+VHiPzKbJN99uh9hHeQA87mf4atiStnIJs1ivLP/TRFSwu86q69Z3qzPsI2x5
 je17XMVxduZvyObFCWdm2BfvOgc05brNLTyLqwXuxNe7ILvFisW/BWag4ouYP5Wn7Obs
 jvOSmNB7nG64ptRBl8vO8v+oll6o/cDXz/BjtO/XeQ2Fmr6D5DvrcPQyHxl86zuACHmL vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k85mfs5qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCTMgS040066;
        Sun, 16 Oct 2022 19:59:59 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0nc0ux-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 19:59:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyUcBX92MR68M3/K7p890mqemUCCenh6cAM8L5Bi47tBz31KPns4RhUABm2RH0MuRK2IdomFKIMAaGpefSK88wqSUMl1YK5DIPm20aSZuuetS1sqD9cM/KAx9OzpbGgr4mQ7MoGRyqSlO9tIyG9hXSTzcZwJoq0Mi9vZdS5N7W0BBS2NH9md2SgqC+uavSCfYA4y3j4ibccO1UK7valZDVxTasdtvqrCU6c4nK1piooGMYPmygHfGwKVhCMniNLh8Ll+y7qLTXldQdLa+TDymjz49JEZXHpRV3pEkyKYWrQUDmnzitNTu+o2XTXRpHJq4NEKeBUIeHuazamox5tiwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=Yz12UWw+tsEtxVNXrm/f4E1dWIGAxbpUuovkMlXf6R+YdNyP5YtBlnnQBM44koPJyGzW/zKrKTaKzXu1h8Ni19QkkvEUGzxCOj4HG7CuqHdA8PfPK+NWbYpfT/Fhy3yrIznOfkRAAzdmgOEtSNRe51u/CxAMicjEV8OTOVNZgj7LnxXoQ1MYuR+tIs1tf/xqkp5YdgOd+LoKJkqlz4+L2La03DhWzyIwBtRRe/+hMHSzJ8mxEInuGtvwgeUJzxqV/jJGHHscxQMBF/AA+YI3TDpZnpGfwyQ9vBxFZslRssP80nSBk2x92Zfa9OL3j2naqd4OAWk21iGZhvHcOstffQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLJqvLDnoM2LAwyzuFcx9nVzpbqbINSt3ruS/6SUL1s=;
 b=O9FwnYpPDT/PSN41FOYuMfRnLuUmx5njP9dXvhpUmAPg6RLGuF1t6nje4HP2fMUVMcTVuqQ4lx2LcbnLygbfy3+/I9ZBjCCctyGV+s4fACtacOB7bMYQxSgrItjMGn1QQxpeAUkbPtyN+iY4M5fNS/Dsrevdp30BImEvLIC7H5s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 19:59:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 19:59:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 05/36] scsi: libata: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:15 -0500
Message-Id: <20221016195946.7613-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0006.namprd15.prod.outlook.com
 (2603:10b6:610:51::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d62e7a2-ae18-4f31-313c-08daafb0fffa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2IOQEnjs9DR8TqxBYCrd3TFtaRO3ALGYNR0TAz9M9hzINDMB5SmIlLhHi22z5R7waQQYW2XJezyYEeFa1bg9Z+TUt4K6J3d3M34OfAHIyg/LmpX16i/8OHN6qyDXy7/rVgTUG/8HBfzEk97oC5dpVnzVSiTXD3lrM6fegM9HXMQGSDx38naufLMSf/cZioGDNuIM9gUaISIvUepc+Y6TYWHnkCHgJ5vNY4WSySTlfn9jPOhBgIyCJr/8AKX9jr4cZtUmKwfOY09dFyBxz8qq6VqvaMNe9yrVBbrb/PE6oE+x4m/EtoYzkpyogChVU+AhlJeM0ktYiGiS0Zvz4fb4jDjobm7mWgsST/fHaezXo5zkaOCzukeH5GXnPyExYWEQ1RzCZsjh8+aG/Vol3hhiu5TzMVuKdGxCuE/HSqV85IZmlT9SmI1lXXFZFDdG1wI0Ky9u63mXjftvVzl47hdaxB97jdjBeaHs9+U4mpq1NFn12GEUZcuw0BVzDIGlqXaYssSxdkpPc15WoCYQeUkslCKXo+0sjc5WsUi00bptcSbv1+PW7ydOXJDq3QXI6fooaglqocmrb1lmWUb9avJAcUMgmfq2PGRNBsVHdwE762ydWteVEyrsx7LqCXDGwEWBd7kUHACXUAQxuZ/fczyt1su/IKGqv19jtHQQ6rh0oe8ob2xP/45UZdgAtJv1ECYp0I83pEsDBchhxClE8xcbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BVlCUXrPvPd16PAJDK9e2wA4YiFuyzAlftriDWCGXQUXcTixMh+As5hx1288?=
 =?us-ascii?Q?1TMCtH/vBCgYmnZpFo0/lMtXEmHPxQKhFAC7Rjr/m7Q/LhpAdOwshfl51rc5?=
 =?us-ascii?Q?hcjKC7tH53WBGw4SeggASvsvkoPLLCYbxXkZkrBdFSDJDJxWbw3caeJJy4SK?=
 =?us-ascii?Q?QOOesrxyMt8rimYA+BA7NYijdFiqqHUhlGxvB2FxkkAikrQ8VccPxwY9WUNe?=
 =?us-ascii?Q?8crofR78AFPDujG5Yk+/heI08I7LBr+2V6a7Y2UPwN2ziNUpga6IbHTDJJit?=
 =?us-ascii?Q?mB9NgOb8Dpj/gTRvevrpLL7dgXmsvrebOTrvYWK0bQ/zJTIcEaLxSeqm/HTA?=
 =?us-ascii?Q?FrhiGYXd/A4+E5WsFJJuDoi7EKGI71Kw1vn4DGCpf3nyKVdvAFuXF6CK7pzu?=
 =?us-ascii?Q?5JobZk1H9J2cQK67g6jAHdeTfnV8fqGf+jfqkSh5/7tnlPpMDKH6X0bilaGC?=
 =?us-ascii?Q?0WkWGd8yPhf+WaYV90i4haPHjlX1LUKhh9lNp5okxh25mkLzCGfdSxkWKdVb?=
 =?us-ascii?Q?f6vIUIGwwTbPcEFxCfQZ94asOpQ8Dwv5qCzbaKn4iEu29kpDBZ7JGymfovVG?=
 =?us-ascii?Q?XDIQOfQxPJgGBHktxdp3q9gni6imfKrM9W7443oZV3rTo/nDyZj+GyZU6DeM?=
 =?us-ascii?Q?b21Fdh/7DlzWiwnDzKMYdsdPKtZOThRUW02JzWpUnNYzB7ZdHLC7UXSP3pqm?=
 =?us-ascii?Q?KJ5K944JC1wvWvzahaH8DQQiooNk4LW2ZvghQ82DgYTw/07ifjlFuHw4nQg8?=
 =?us-ascii?Q?3cU1ZIXBa0ECA0BzT96LLcw+2bAV5FQkIClmZgR8cIE1x61HSsIpa6I+vtgg?=
 =?us-ascii?Q?JAJFzEjeAaGuFMqMO9yyt9jWaN2ghm+/WV/Rf2xfwO4um6Bbayglg84uHSJ4?=
 =?us-ascii?Q?PJP1nGu0pJFrtkvELyO+aMpx2nP2OCfaQuTxJZMnNNwNpTmpkYG94N5AkIRV?=
 =?us-ascii?Q?a+9s/RKMAx02yL1YEnF52BMKQKsTZmOWEfqf0c5hv1SRJD4Kg6WOm4KE2FEB?=
 =?us-ascii?Q?sLWHONxFrBLrg5L0ulNIDNln+NL1GHSbAY8O5y5nmvDPbzSSt7Jb+9hlAAwK?=
 =?us-ascii?Q?GXBSoP6Y/6HxxR02wIKCBzNstaKLcelxnDxxcM4F+41cPKXm5at5P036W5g9?=
 =?us-ascii?Q?kHIYUWZPK/mzSOWo07FD/QRChUWYKjiSVzLSaQPbKNTbWNGdmoSEQ7hG6eLf?=
 =?us-ascii?Q?so1s4TKzu1zmc1dD++bQ3ctAHKOjD8gCxpR7kukf7XvZcJYzqp0r66Wq07mH?=
 =?us-ascii?Q?Io9kKz4CUCSpxlvWJnEAJgFVRAuH+c1cLxfGMa5ELKy24s6SeZazg+wPupAy?=
 =?us-ascii?Q?hiXm08N1Jm75NgsyZG56d4ac59aovkKU43R9WhUiRQ3h2v+5Th3iBcddj123?=
 =?us-ascii?Q?1qWWHhcZOmQMqgr8vv3RDNj1AXY4y0iPO66F1A49Fdf/Aj3X4F9A59OMos2n?=
 =?us-ascii?Q?FdSwqnORue9XjN5pS1wzIjied0LK4ZcdUJhZqwBq2METU28DiNQFGiQlmacp?=
 =?us-ascii?Q?ipXGGdRsEvU3HmOZ5+y5IPrbO0ck1LYkN2fhO2ApsP5JZ2V5ae71SO0ZO9+S?=
 =?us-ascii?Q?KHrQ16MBSWudWKkH1abSen0k3X3WgegCQ+12miDBweqVtfzBPfjWJE6VFb/P?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d62e7a2-ae18-4f31-313c-08daafb0fffa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 19:59:57.1287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2t9NcTk0u5LIMm216j7K+D9RnS5oJ3K6GHN1QTkH3ug0T5fOxqVED/DPqBPEXQKP0RvyIg3n+tRfKjKs1kdfGfABRK9UPGyQBUhvm91s8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: hne6fEq_VnlEF9X0leZqxHgygvO6I3qB
X-Proofpoint-GUID: hne6fEq_VnlEF9X0leZqxHgygvO6I3qB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert libata to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e2ebb0b065e2..3057f703982d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -413,9 +413,17 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = argbuf,
+					.buf_len = argsize,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -497,9 +505,15 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_NONE,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

