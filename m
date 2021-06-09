Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FF5C48BE0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DFA3611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhFIDlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35382 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbhFIDlh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592frM9041511
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=aSxqkFVUlBfmruBg3qE5hSrM7TsfEfakYCFOqR9F0d0=;
 b=IfFBBODPKX/FeEaqW0XhPMvhRS9BB5XnpWupE+molPN3FcmJKdh6kN3lpuf0GqaYiZa6
 53Ke/VxZRa9SG+OVIM8bTO/9Hu1Xji6Q0VZtDvM4AwB6RNi/DpeKCtgq8Z+DEozq4q90
 u9RDAs4owhtow4z8btgsDAdVI78lSFjNCuG9gxvQ2YAFI464JWmSOBx8qkEZMdAvJ78o
 LP3TGW9Nx2uq1ef6aUbYYjTGL1M+aD+kjEmhlAyUA03Y1O6DYzvvxOIe12Kcp526chX3
 7oBmxQYn7cVLyPxLUIT+fFTt7QQgLryxC1k1eUcUo8ymx56GKib/wD/R7MX7tEk6rwaC 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3900ps7rnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z3rj082718
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr1d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2rVpGqDvnGxZ/tRvlsKNdGVIsiwQYXYf/dG1HO1MbCm5LhgYnBFwEZcGzGy3H7AktkaWySUm4BXeMlRJHFMeDYZ7VYv6k3Z2WjlXZh6zKrGMYm6ey68bBf3k36wJTFxvJdpWzOciUv8N0CMj/EOfJz9QE4FTpOxid2WwgYJ+vjEav+NpDvojAKZi4tdQ4S9o2Rm0PmtxWxNxySAhnII3+LbLlGf/8DvOzKBnNO9vGkM25Tj03qIL0ILoCjazdUkVD+yupQLwGt//2GqBcMtBji8cxWkarfcqL1tC3dWW2P1wyRU9rOQ/B4Dh6hYYLQL+bZ+scKggwmnugnXll1y9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSxqkFVUlBfmruBg3qE5hSrM7TsfEfakYCFOqR9F0d0=;
 b=BQ6am9/Nlgwjy6r+XysUqxiKZzSYIwJa6DqO+TbUbrRW+gvCmnwKtGhK4AIqFMwQ/BmCLeFBWzFgadbPkou7iTBfaRuAMC7Y9a9ssT2P2Cj9ZaiLRqHDtOBaRkghntTx+rZ0x29D4VP2sIEYUQB/xR5Ym2hiYrubzrpB5URATW7J39jvNok5rdH5Z2RE63jyQaS4MJGbuRLCcfmDqGfg2aXhfR7Llg4BlYJysLgtFYdWbE8Rvb+D5oiJEM+HcJ09OBY20zaYBhNYojkgDsRO762Uaz4nx79UUSm+LJfUXEkL2XuIuuwAXjeZ6ch+1zuTkW0xm9FO1wGjCZnKEHuMng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aSxqkFVUlBfmruBg3qE5hSrM7TsfEfakYCFOqR9F0d0=;
 b=WoZ4tYoarpN6Lsh5kbZY/zyQYMvTCn3fLQ2A+6TJX5PRalVTbwvCtTNB3c7tREJ89lyYuwr8sCqh2Vas7e8l9Iss56McsqKIRQCXLZdSDX4E8xINb5DYfH0Di6BywFkmD/EawAz15K1Kggr7IM43jnPZVyGdmTc2oeyevWpIrYE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 09/15] scsi: scsi_debug: Improve RDPROTECT/WRPROTECT handling
Date:   Tue,  8 Jun 2021 23:39:23 -0400
Message-Id: <20210609033929.3815-10-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 683e08b5-27e4-4741-ae0b-08d92af835c9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421707C5A706AB07F4657788E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NeiDxUh2rKeB60jWAOIGwoobkshjYJpR2aiOPX2knNhNxr5FK3n4QtDkr5SSrkgmIZJnK5e4TL3vwLMDfsNo9wEv6+CrNeOxLBs/f4XnqKAxoWiQeQQTwBXOL78ZKcZpG3DdAs5pVNhHCFk0q/k9jcCZ/xS3HsvgvIO1lJLJx9VRGZPrNsaJjcXRMpO6C2fWPRH1WvhbBJIkUjWdvr/Ne/ZFeg7NfGjWF4ICCbjroo2VyxkTRNuFDwaO2lSbrWRWB+f7d/vb3cq7OPsCgBlARYjePyyby3AgGtiBfm7Me8FZeSbhb7hD6NOTw5pO5YUxJ81r3aPMCuvQ+aeQti46S60RtR88LLY8hYl+K8PWgnN347sGV4zrrwNfDyWjkokEHcgon2uWAIpx07XFrZsOLTbZOW53YF62tPLJDnGWMKJ/sD/0lYtWnmFVtNJFGavXUUu93iO7XXIZfWwEJJAvIfypWOXBnK7Bcf9bLRiYMrjwapOoPS7NHALmGOdWjLkxaIL8BlcWfS5laLxmF51NL7KkAtGOXIFul8IVq+HSDmd7KLxcurplBcWqPsWJJE8bfnBXSn6tCM654VP9YTpSWzlpFWXj5AUNa84QTt3ioIsIw29bZiaH7YCS6Rn6j97Cnk1UEbb1UP/xcxiujqu98Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8M3N9snkU7fEle4TSBXBA9Rz8j4967hAB/5lCKuW+xj3307nHK0pWNraY1NF?=
 =?us-ascii?Q?dM01zt+1I0oO4VXvUa8zTyRObMEvJnttzooWN6vfoRqgMz80gUDYcvxiDBuI?=
 =?us-ascii?Q?Mzjf/hHEMVjjX+4xK2RmchsZi2BX1lLMpmM9SDdcW/QCy3WzO24fb3oTovAf?=
 =?us-ascii?Q?jRqXPTDg2jc/f6hfF3k0lxMX8FHZPt3yaH7q8zrNPN2yncCXXS+xyIPIo0mB?=
 =?us-ascii?Q?WAXsasR8njUa/rr5YqwnXny8et3NVVwONMWszQmHeP3zeoBT5QYm8c+ftY8q?=
 =?us-ascii?Q?R6HaTVaCXX8ituUktJWt6tCJ/UbG47PpVQy/33askl+lmxppkY7+20N5wK4I?=
 =?us-ascii?Q?rUJBtHudU5fJAdjqtoPKb19Alye72PxwXpsKiopGrsB4sZfIfH/q6mhNmJM4?=
 =?us-ascii?Q?ULY/VOSvLuZR6dw8MtPQIv3nyGkYkkrc9JUUaSaGANquLKJCPIIU8h2RvSm+?=
 =?us-ascii?Q?oEOZ1/ygMm30YzbZsIgONC7NYA3R9tvFTaCWe0vGnBux9PMgs1bNAlMO6WpB?=
 =?us-ascii?Q?mUoiGOltUdIQi/TvaKijR2EJKuAHmEsYGvFsyfjK/vT2AH3vM62TgSb10AAt?=
 =?us-ascii?Q?NnnY/0CM9kHIHxaEUra+EzaZ8brQiJ9ERvZdZWM+EvImI2CkAG89T/rJeshK?=
 =?us-ascii?Q?VZzrNQcgSmTwreyOvpsSu99x7T569oBZNfzyQ++qEusjbzH+FGEyegrMdF/X?=
 =?us-ascii?Q?g9LobHDQ+Ma/H2qU1m5SScFNhcnbYSfURpBuQ1GClRl3xgU4lrt3cZTDBl0l?=
 =?us-ascii?Q?CQY2FGjc02d2EZDHJv6JHj8bPC7rXLGFfHti1O2OH6uewBjA0oWzgk5L49nX?=
 =?us-ascii?Q?iySoMueahwhwezqtku9hZrkfLm96szr01GgiuPYVOdv6kfcY9FgoY9c53VCb?=
 =?us-ascii?Q?dnRP9ops6yGVgJkSePUytzBGb1TWPR78AoH3gG9zMi798eHkS3h/N694X2af?=
 =?us-ascii?Q?AfJInVBVD1boL995r9kjgL3IBFa0wcUI+piMmu6ga5QAEv+Ly5B+CjMmxzdF?=
 =?us-ascii?Q?QdiQL+w+9SrALlAzo8iMCnYnOZu9p0Q8HKKpF8TzgKPJL7wwFKuUbHQ6xUD9?=
 =?us-ascii?Q?WdgBUTG3YeGswtd7xQhL7s2JXvHFrDZgyW7o/5T99/noHwl+rkkhH9YFpk4u?=
 =?us-ascii?Q?T3fgSWL/83nIlQW/WxOX6eJLFdSVgc7Mr/fnibtLERq4SujJtjYF6yULEZRP?=
 =?us-ascii?Q?I1Y6baM6YmpOs/zAa9B4sh7/XXELMlHlZ3yy/Z4K0DlM1KJFVeqIHdR3QaUn?=
 =?us-ascii?Q?HKNgK6rxUc8pY4WuORSXyLRPjK0wONyVFaXXKb7vBJYkXM9+4Cre77vHTB8K?=
 =?us-ascii?Q?FVwXLYBhYneaxAPU/vgHhxgW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683e08b5-27e4-4741-ae0b-08d92af835c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:39.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WCNqzV+5t7Ur7xIu6P/Mk5/c0h41omSA3nNyjO1xw5xRE04AoNCy+StKuZWBG1GxDZE5yHv5MgV+iZJGLg7CMkrRDZe5EXSpxXQ5ELyXT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: rphZFAbkdgxSUqfvLabCHsTSwrtZSYKI
X-Proofpoint-ORIG-GUID: rphZFAbkdgxSUqfvLabCHsTSwrtZSYKI
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is useful for testing purposes to be able to inject errors by
writing bad protection information to media with checking disabled and
then attempting to read it back. Extend scsi_debug's PI verification
logic to give the driver feature parity with commercially available
drives. Almost all devices with PI capability support RDPROTECT and
WRPROTECT values of 0, 1, and 3.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_debug.c | 90 +++++++++++++++++++++++++++++----------
 1 file changed, 67 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9033ab4911ba..25112b15ab14 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3076,6 +3076,7 @@ static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
 static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 			    unsigned int sectors, u32 ei_lba)
 {
+	int ret = 0;
 	unsigned int i;
 	sector_t sector;
 	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
@@ -3083,26 +3084,33 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 	struct t10_pi_tuple *sdt;
 
 	for (i = 0; i < sectors; i++, ei_lba++) {
-		int ret;
-
 		sector = start_sec + i;
 		sdt = dif_store(sip, sector);
 
 		if (sdt->app_tag == cpu_to_be16(0xffff))
 			continue;
 
-		ret = dif_verify(sdt, lba2fake_store(sip, sector), sector,
-				 ei_lba);
-		if (ret) {
-			dif_errors++;
-			return ret;
+		/*
+		 * Because scsi_debug acts as both initiator and
+		 * target we proceed to verify the PI even if
+		 * RDPROTECT=3. This is done so the "initiator" knows
+		 * which type of error to return. Otherwise we would
+		 * have to iterate over the PI twice.
+		 */
+		if (scp->cmnd[1] >> 5) { /* RDPROTECT */
+			ret = dif_verify(sdt, lba2fake_store(sip, sector),
+					 sector, ei_lba);
+			if (ret) {
+				dif_errors++;
+				break;
+			}
 		}
 	}
 
 	dif_copy_prot(scp, start_sec, sectors, true);
 	dix_reads++;
 
-	return 0;
+	return ret;
 }
 
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
@@ -3196,12 +3204,29 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
-		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
-
-		if (prot_ret) {
-			read_unlock(macc_lckp);
-			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
-			return illegal_condition_result;
+		switch (prot_verify_read(scp, lba, num, ei_lba)) {
+		case 1: /* Guard tag error */
+			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
+				read_unlock(macc_lckp);
+				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+				return check_condition_result;
+			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+				read_unlock(macc_lckp);
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+				return illegal_condition_result;
+			}
+			break;
+		case 3: /* Reference tag error */
+			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
+				read_unlock(macc_lckp);
+				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
+				return check_condition_result;
+			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+				read_unlock(macc_lckp);
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
+				return illegal_condition_result;
+			}
+			break;
 		}
 	}
 
@@ -3277,9 +3302,11 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			sdt = piter.addr + ppage_offset;
 			daddr = diter.addr + dpage_offset;
 
-			ret = dif_verify(sdt, daddr, sector, ei_lba);
-			if (ret)
-				goto out;
+			if (SCpnt->cmnd[1] >> 5 != 3) { /* WRPROTECT */
+				ret = dif_verify(sdt, daddr, sector, ei_lba);
+				if (ret)
+					goto out;
+			}
 
 			sector++;
 			ei_lba++;
@@ -3456,12 +3483,29 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
-		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
-
-		if (prot_ret) {
-			write_unlock(macc_lckp);
-			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
-			return illegal_condition_result;
+		switch (prot_verify_write(scp, lba, num, ei_lba)) {
+		case 1: /* Guard tag error */
+			if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
+				write_unlock(macc_lckp);
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+				return illegal_condition_result;
+			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
+				write_unlock(macc_lckp);
+				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+				return check_condition_result;
+			}
+			break;
+		case 3: /* Reference tag error */
+			if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
+				write_unlock(macc_lckp);
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
+				return illegal_condition_result;
+			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
+				write_unlock(macc_lckp);
+				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
+				return check_condition_result;
+			}
+			break;
 		}
 	}
 
-- 
2.31.1

