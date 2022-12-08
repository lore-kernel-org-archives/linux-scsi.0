Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069A3C63703
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 03:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLHDKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Dec 2022 22:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLHDKV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2022 22:10:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4047BC21;
        Wed,  7 Dec 2022 19:10:20 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B7NOoAK016123;
        Thu, 8 Dec 2022 03:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6+rerFJH39Kros+FS5nyA3QQ4eDzSw915PNvB5CPamA=;
 b=asXfx6a+5Li+D+i6xASETZ7YJlZizyAEzqbnliLpDUqBzBSBDD5CUnFo6yghfMPcOzIJ
 Amdpd7p/WXWbc5Bpxq2myX3JGiumftKUBfzMwRUR5KdbwGR8fdivm9ZUwkthNWEH4gAu
 kojum8MjC/ZdsGawDzvMW9YbEHc5rutIbznSm/YRlVp8MzeJSJF3bHQWo1gF69QPWGM1
 OGL6R7vAYf8IqrxNzD2jC8yyAcPXxzDTLO245PRWQ8mFFwrQ3D+lPCMOS9eBKu0+Ania
 +o6xHvb4Hn8hmRDKEk6dKQSZErQYUbtzD9mrIfjxqpYr2xuyJeigwfh6IIQIBaOnkc3I FA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maubahwsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B81NahP033819;
        Thu, 8 Dec 2022 03:10:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7xmkuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 03:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4WfPx7LbUn1J+aYOoFt5Fnvdzmo0wKTzaCnKI6ik0Klc0nUKOGPIA4JLOPk/NTUhqEPPNyeUzIjnrYZvR+OJcHL/amGeZZ6IDbXItiL+u/5QBraC65IX/nWzGs/u1Ff7XfiUVgO9jNl/S6L9EbJ4ZcEzcc9AAuNvz9IzWXKXDbAz8gAkZUOv3VeLBxLCLJ+rOsk76UiBP+N8lbSDqH8JivGanB2eXy7yK7bAwKwJ1ZCESMxThXT1uYLLfX2DPgzg64IbQScARtWRObsb/wC4+tAqYqb6GhqViBTgyWnzMkpOGTiULfu4ppm/xs4vKIvmk3c2XigccozoZOrEFSKDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+rerFJH39Kros+FS5nyA3QQ4eDzSw915PNvB5CPamA=;
 b=oU3Ivle8gPWcfLDSoi/1liV6bWSwxCW5MUiZq+Z7VoFBi7Q4L2GQ0NblmwNfRVZxMC9HcDGp6eh/60K7Nu3Sh1tbr+xoHlZK2m1NZpksQc7JZrM4/SRF7xPGZZ6J5ZyAeJ4EqIkbZZxtMlrF5bd0aOe+GrESHlZ5uDm4uPG2HtVPFwjJYqlSeHNTKaeSsMN2A9EWbEeA2YJHG+NhNibqDftSZWidaPXTqCC0PY/CYqwdSqlh+jo4o1PIJdbL6diHCm8pRTVbRRaut/HXxxHp9rnJm4TrKj/mcXUmc/ZrV1f9LaavvxnjQTA4TOqdwpyAVdYCGfhDmphDY01Lb8NgUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+rerFJH39Kros+FS5nyA3QQ4eDzSw915PNvB5CPamA=;
 b=ZuLHrGN6jsGfDvLX0wZkIKRRhTzVac/LcE16um1+lUYaADG0njDRJ7TME8Mi5spm+7EtPxLAbxXdUIYNzefA/iaxgVdzzTgXas935+a7o/RzNkgx4kIfBMrFnSsU79BABChV2Gt2uWPc6bCm3J7lFYIsiYGayNvl2cwbYDrUNo8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5132.namprd10.prod.outlook.com (2603:10b6:610:c2::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 03:10:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:10:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/7] scsi: target: drop tas arg from __transport_wait_for_tasks
Date:   Wed,  7 Dec 2022 21:10:01 -0600
Message-Id: <20221208031002.106700-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221208031002.106700-1-michael.christie@oracle.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:610:5a::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5132:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf2d77f-2a26-4400-a72b-08dad8c9ba49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGGEiItcS0ZbaRBtT655TbneDXvJNKOlZcPxyJBygr3SaRzXyPVwE8X8rrZbojrkjxmSFy6kn6Scm2M0cTu45iILo/gobu5cEWiEY+GtT/Ig3w3lGRX4XNb/R6cJE2I/ZHB8Wsr8CbcqebmiwZK8uZPeon3MEJXHMVvcjCtVcwtYt09Np60gR6RLOSbtp/tU+7cldbvl1LlPyIjialXZqd8R8eO3jr4aFW4HLaTnr8JbWi7qM8B44V6Qd1i9v5brZq8jyg1X72g0w1ILEicMJEirxlAl2KZVzjkiwSEUhxFZnw+5Q9ZjX19pu24gfJY8o8O0vTB9bp93KrJhcg1gnYBzBycxhlO8TJ3nnMilqMjcrZVpgmoKnsytMsXfNZRFH7b5a8VYVmf1r6kBjmog+l/ILg8gw4uCpgirzs3Bxk7himl7cVNc1wEMJNfNq6IUId1MVHF4lb/1f/gQBzlOvIP4NcvVUy535tNoE+dTt2EkoQYJL09k29W7ZndUIhVmhm4CeAjJWX914BrAbrUm30gBNyxoqE9p88kA89iPNBjeLM34FLhlG642MfWyr4Ddkshx0U1ViJ1JXmShmwEtl8UdeXrUGZRKys7QMesgi52XeasQBd+U3Vetn2t2VBYFWayc5JLrYOi2xF7bFLwmvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199015)(38100700002)(8676002)(86362001)(83380400001)(66946007)(4326008)(41300700001)(2906002)(8936002)(66556008)(66476007)(6506007)(478600001)(6512007)(26005)(107886003)(6666004)(186003)(2616005)(316002)(1076003)(6486002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jEeYhgHWOT2FQvGd2gbcyn8Pn36Fjpmd8r4PuSdK87OBLIw2DI/E/Og+TgIt?=
 =?us-ascii?Q?YH5AVJ9xjhPFnBZ99G0WW5XN8+Tzzt0aEAzio0Hl3tEV3v1J6hashRVr+DyT?=
 =?us-ascii?Q?5vfs4uk9TDOOVhtZtjPdz1mvs24pz/QTtxvAQdFqV6Y7pXUTjHSB9QMZ6hFR?=
 =?us-ascii?Q?DKsXKfCjnoGgc10roEXBcLW94hd+A1UnsKwxTSgMya1rOTcxe6y0byR9mCoL?=
 =?us-ascii?Q?AD+2yrQ0D6wID8r8OxQQtOyeO6moZ5ZmypuaX7+fiykyOlCbhZ8MehrR4xUe?=
 =?us-ascii?Q?OSI4LZSmywbH1WPtk6x8u2aw3E8HpEeAWPETYVQWERnDGARJqu+P+KO5DG8z?=
 =?us-ascii?Q?hXDxny4iSWQgS4ETLm6NAmqG640HV/mwJ2W7ZLtMD/+WIZFLACbL2AIJrT2S?=
 =?us-ascii?Q?zUTFuMrzZQiPl2ovDwThvzhs2X/oozJYHzzdB0xolP9Ci72icpdyB4PbTFMW?=
 =?us-ascii?Q?dd4XpwBKqV6yZBaofSnkKrpwjOXMN672WtD/uxg3daGeqKNH1zUmOzkasQ+T?=
 =?us-ascii?Q?ULNPM61rit3oKGXuDC2RI3QEAE4+HX7tl96TD92Unt/lIwWJY8FzE2v450HV?=
 =?us-ascii?Q?ToQL1qW37+Qwus+9wFP9q2tu1tUrT3VGavrTO77ox35xhy5FACnXUzAaHywR?=
 =?us-ascii?Q?tSytIqbeghpI8EtgWLf83sVR41tnn7/AKXSPtoRU0Cp6NE1uLOWvo378ALH9?=
 =?us-ascii?Q?NuY0wHV6WjeAO1DpQK9Zp3UmPpWNCteV/HAU5/1W5IQhbEOBsJEL/VMneIGm?=
 =?us-ascii?Q?8gKdhC19Lja2YR3PSa2HV8+rK7gfRTu2K5uQrERUVdSIJRbJkoLld7DpKtvg?=
 =?us-ascii?Q?Of4BLMWWUNQj6ok0Uef3LvEng36l3SypM4BJ8AlodLs95n19JCygTzvGuMKS?=
 =?us-ascii?Q?9CZ10a7XoitO8g0fZkas0kQz7dTrlZBn3PeJMNRGMdX044NrPytsoiEYJB7G?=
 =?us-ascii?Q?6GUHRCaFEkUrGON/BpXGtDVHo5teBSTsTfSvvvHKzGi1eu9/nQoZ52hkmDgF?=
 =?us-ascii?Q?SMA9JLNJrQi/41dOBTlDk9VFowMr64g1P/zWwzuJxQDlC7FJ9CbpIrq7wR4G?=
 =?us-ascii?Q?48sWBO742rzahJWL9c2pfeZXANIE11tygjkX1ND7K999IZvuiWLn6KcIKqNL?=
 =?us-ascii?Q?TweIs+ORpOdGhbs5BHT/Ocr9uE9bYkmb7FRvuUxlCq2cByYd1dXHmH7714ed?=
 =?us-ascii?Q?khmXwXbjCvuPimCn8uK2vGMQQBtR/IASXumFH4v3ktpJl5MbtJ0hpRKAmYYc?=
 =?us-ascii?Q?EKRehdijExTr8n2ThC6Y023pMeh/Kqq+eGbjJWcHNhSrLpa78gBKopWbJKTw?=
 =?us-ascii?Q?BuJUD1/8mavrda0qNQdZwiiDofQ3F6gilOuEK9c+t4wIwujqXYNiBjmo3oJb?=
 =?us-ascii?Q?IrSjuIktVAMg18S2KV8K24MsIKJifYKQXMR8/hdxzAKx3IXhf0+X1d52eBXR?=
 =?us-ascii?Q?MTSMvDY3p3BObjCnv9Raa5KPYhStzAGIgRr+Z9/JfHi4hvaioA9WIgt2hh3j?=
 =?us-ascii?Q?VU0hINz8dVVZv7x+Ts/9XxXdS0cZffZhc9n6n9bT5uvpI1zFu0iRqeYGBZjP?=
 =?us-ascii?Q?FJfSbGfvJqbZCV/FAbbpQgw9oVnIjAz2rXOt0XQE0y6NdFHbM+hu59DhBwTS?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf2d77f-2a26-4400-a72b-08dad8c9ba49
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 03:10:15.3636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bp2mIkj85rB0I+po4RcoXw+/ylgL6b1pb3Zum6egUagvq6CUz7ySl7UpBmMft9XjOfvmmSLUgnXKFPkYrytlm7jZc1D2Layl+afpqRLwpaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212080024
X-Proofpoint-GUID: MRucY6EswkqOMZ-ztYtOEi7bjv67s4_t
X-Proofpoint-ORIG-GUID: MRucY6EswkqOMZ-ztYtOEi7bjv67s4_t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The tas arg is no longer used by callers of __transport_wait_for_tasks
so drop it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8bbf0c834b74..d42ba260f197 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2902,15 +2902,14 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 }
 
 static bool
-__transport_wait_for_tasks(struct se_cmd *, bool, bool *, bool *,
-			   unsigned long *flags);
+__transport_wait_for_tasks(struct se_cmd *, bool, bool *, unsigned long *flags);
 
-static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
+static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	__transport_wait_for_tasks(cmd, true, aborted, tas, &flags);
+	__transport_wait_for_tasks(cmd, true, aborted, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
@@ -2955,10 +2954,10 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	DECLARE_COMPLETION_ONSTACK(compl);
 	int ret = 0;
-	bool aborted = false, tas = false;
+	bool aborted = false;
 
 	if (wait_for_tasks)
-		target_wait_free_cmd(cmd, &aborted, &tas);
+		target_wait_free_cmd(cmd, &aborted);
 
 	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD) {
 		/*
@@ -3237,7 +3236,7 @@ void transport_clear_lun_ref(struct se_lun *lun)
 
 static bool
 __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
-			   bool *aborted, bool *tas, unsigned long *flags)
+			   bool *aborted, unsigned long *flags)
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
@@ -3249,9 +3248,6 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	if (cmd->transport_state & CMD_T_ABORTED)
 		*aborted = true;
 
-	if (cmd->transport_state & CMD_T_TAS)
-		*tas = true;
-
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
 	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 		return false;
@@ -3292,10 +3288,10 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 bool transport_wait_for_tasks(struct se_cmd *cmd)
 {
 	unsigned long flags;
-	bool ret, aborted = false, tas = false;
+	bool ret, aborted = false;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	ret = __transport_wait_for_tasks(cmd, false, &aborted, &tas, &flags);
+	ret = __transport_wait_for_tasks(cmd, false, &aborted, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return ret;
-- 
2.25.1

