Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5B0E80A8A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjI1CJX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjI1CJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68DDAC;
        Wed, 27 Sep 2023 19:09:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL6YxX010753;
        Thu, 28 Sep 2023 02:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=c/KT1LUXffi8CQ3sbr4TDpDp+kJ0EPHQLIH3Pd53xjw=;
 b=t6JYhHPrZrbC5n5Sa2/35voR6J6gn2Kd4R139Rr9T/DogHumw2SxTmDA48/FeQREXeF+
 mqUvIYR/5DmXQS4xb+HyHd2VsKA4jzemvnfYMsmwiiWEH+2nyo3Itf+1FgklioaVwDBE
 nZ692PKtHjUUOZBupiixm2UK5i4Y9PZUgkl4TNHg1BlLVNfYzy2/m4ZB17Pt07b8lD3z
 lnMo/BfWDc940upD5PFrk8hfEVl+o4qj/F0MvdepFL44VlxSntefCa3T4cxEfWo/coEH
 W/Y0O//NUJivoOZKlvIQo3r9e3bCy3C5691I9JBfUherYItvzZ6/5yej4lxIt3lp2ZA5 6Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9r2dk6u7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38S1UJwY035048;
        Thu, 28 Sep 2023 02:09:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf97827-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mao6GXKWIZc8GXiqrz9YNC8uJQiBqjEAJXywZR3/MAh4OGK+H4o4eYqLzDtyfNUFZFFDVX6k6FSz9jDA+S4U8t6uTd7Ftezv9ECNoe09Qn5rGuAmP1lD1ewwPk0xbGr942/cnxrbKU3u2qmSPgKfS3osROJJ+WnvwYkZ5vGhwOCxyhQBg2F2TdG78sHEcqLIXC0Fq9JZQGUcEb5SYbpnq+Vv4BoitOAP1v3Kjk0SSHkA9hU/bzBJWNfTGQXBdSzs3ug/YIq3yuwhFfSTMVXn/s5WaVQOsHFWiHiqq6mJVtYSFVqgYRqqPlKVmmzeEWGrl/+cCL5lJ6bT7F+6LJBRNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c/KT1LUXffi8CQ3sbr4TDpDp+kJ0EPHQLIH3Pd53xjw=;
 b=NWhuuvmCUeKdUDfafqeaKViulW8BxesVYemJncaTcWNA0VuVMgeTn0z/XyZpUkQnfIQcZeeDsKbl1n2vRXKd9UpXz8D9F4I1xXMEP8FubHamwwtt85EFcAeJ2gk23pXOqmdgFkfAmakezBKY7Ndh3YL3R/81hLzOk+GBRkgFPiqpQhwTeZRgVlL1kuWrj3hwHBYuXEP/1+plzbCOfsv1hTYZ+rF3l9xALbQAa3ul1GkC6dX2UhgDxQs2EeU4vd3bV+fil8lhWXsQPkJrT/hLxUiwiXESg8Krl/2bZC3DoryU9MHEsa/CkU4xk/O0DJIKUIW6s7ulB09JJFEa2m8hZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c/KT1LUXffi8CQ3sbr4TDpDp+kJ0EPHQLIH3Pd53xjw=;
 b=ZiazSCFygrD7MTHItgmFVkQqt6x/TCWh/ARmWeaOEtqCbG1rZ6sUIh+GvmHMqcbd34VygDsTvLK3ufjWm6NwP0odRBYuENgF1MChd7WCxf/8v1y+FkcDsaORXq9+Loty4oEMfq4RG5pIbftNF9EAYy4pChKnlumI9RgOwJ0f750=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 4/8] target: Move buffer clearing hack
Date:   Wed, 27 Sep 2023 21:09:03 -0500
Message-Id: <20230928020907.5730-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0294.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e614508-d18a-46e3-82f9-08dbbfc7e972
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: itFizXDb06KJis8OBLY3vKvlqfeyRSjNr9FLRNORPqW1EzL4diqkU/TQjCDxilIVdUtxmZhZ5VaXRwBEqj1bwMGsuNduYx3nAbsoGZCOOgCS8Hx9shD2/qs5J8h2u5UUPwE1Ne22FuvXNbzvrz0Oo9LidGTt5iAWOeeLuyy/IGP22pn8qFx6CP2vSyeLWjIeJDhRxk3iNjDrS3Y6qdTQlUnPmZ1ZHY8wDhXgDUW2tVwsOOXIUdlVNdzxOlHa43C5Vrb93atAw1e1xxhda45lCAHHb/aXsPsF/HJuKgdCaV0lXtaDItBivHllTltT5Qv6gPmS3ewNXc3n1XlBMxPF+4sC7zgznlxB2096vBxcbNJyC39B5VkSTmmpUHZLeCWpNFlcGMKQF2ELV1bE/gkUkLBuuxS9PQ/B+SJIgESgIiaKDf9U/dsGFfnmysvGe2un4iEKZuZNzGyUlgHlr5kfZ+uHgnLt5eSv6v6VptVUur9b5UAtECeDn+P6gP63vl8ZMsx16EoElpqHkzTpl5H5Gc4vmJ6yGIhU6tAi3BgjRPX1FDKu1KZ5rMo/vf6U3cUF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y31eDXz8HDDyvmf//tmEsdALkhqIeL6qeylRuqAv7KZ1ZQD8T6HZQEu0Fa8a?=
 =?us-ascii?Q?GKNTY2ZoOVqXnKkiUPpcGyEVWXU6kMU1RKh99DJ0TEXvk841sLnXjC759GmT?=
 =?us-ascii?Q?a5lxVdgqoZwU9/o8t3hE9BQXumyQOqnosQzBD1xA2aUqtz/eLPdsoybQgnIE?=
 =?us-ascii?Q?VMn4yYDK6m3wi9a1S2i3o9KVNVcjvCvUz/cKB1s580XM1yaR2+xrN0CLieya?=
 =?us-ascii?Q?l/fIR1ysD2MZ+lcd6RdY8IgQ3DDJ+TRzPnMeurYXj8gpPWhgg4gQ7Z0dazgE?=
 =?us-ascii?Q?z4xqPE8N2YeyxKECBaVMz5Y/AZSkUfE1QhTQLhXa6lULbTxN9bb57QuVHHmH?=
 =?us-ascii?Q?qQnXlO+TZtPbhI8TLGctlkXFaWABLoeS9Oaf5Glfxf7O2YucfxIv8kxaHAKn?=
 =?us-ascii?Q?QcgMOHeDNJy7qKUgEiV4dPsR5dsg3CDIGkHv1b3My2MQLZ/WgZvG/l+zYaEU?=
 =?us-ascii?Q?UT7pli6iMVNTPayPkrLO/YxPc/gg98Z/WpsZ+Zu1k7L4ozbtQEQoOlSft3Oo?=
 =?us-ascii?Q?OwwsWjNM6DE+VOdVIB/tvzwMHot3taJlGF7FxjSAupbe0HkkjFBw0Eb8Hoyw?=
 =?us-ascii?Q?Cu5IKfYMHZVJEr/Krg4/0bt6UefvRL8gS3XM/ZmQm6UBNYTNTYZ+6ECY/+t6?=
 =?us-ascii?Q?L6UmGVMl2bM4EcKpTgqobPaTaNQwTRkPmZ7wClv4QIvmtSId4nFvPEcj8DOl?=
 =?us-ascii?Q?NZyaLTwobJPxukXbhYJf4M7r/VCCy3zK9DwZ8q0W/aXNzhT4wsJrJvx/T655?=
 =?us-ascii?Q?kG7RUQPXld9AzsBAyQA3FYeXOG1XeEIpG93OU/hABbIPVweyyiWn+66raTL3?=
 =?us-ascii?Q?af7ANhXVNG4roDkYr4pS87z7CX70PFm6DpITHmG9/yzUNx7r/qfrosmzKdWp?=
 =?us-ascii?Q?ZndlSyKq8rSdCI/rKv+4p67cTf9JcLeEve8dkFJHKOiOgjhNrjTTKT7YWpMv?=
 =?us-ascii?Q?lh//QbFz8dm0L3sZodV7xwKcueLIQUz7jbty5r8Nif/zlNHiBUG23GLkNjCa?=
 =?us-ascii?Q?ftLwG9174830WsIYxCXawwMAa+3dRmaDwx5Jzz+yqdCvQQ2ejkwZEayfrmo+?=
 =?us-ascii?Q?Ds85ebIgmvavmXu/maUZIh3PwLc0McsMTkxvi19DWQozPE5hYWHSaKXw6CeB?=
 =?us-ascii?Q?x7neOR9/KqENSOi0tk3AUi/anO2GPM+JX4aGk89DrVjbdF7CGspXY1BHwvDG?=
 =?us-ascii?Q?gTxqUJFPhJBXaiE4hQSUjZFqX/oobkyIL7NlYirVAV/63pH9yO7sYwy3T1AC?=
 =?us-ascii?Q?xN4rMTSbzu/QeiTTCG+2puVCCD5VPDKczqIce7eVdp2v4IGsuVHK3xuy3C9h?=
 =?us-ascii?Q?U+OnHqGBrmwI8JBwbDiwQ5md2BNfHyQIxkcaceqvzVBeySNChW/R3Jo40g3Q?=
 =?us-ascii?Q?fTE3ns75xC5d6fzlFhpiQkqmlK8+OgVPnCNeAJcnm11EZMmJKK+MGxwYL75V?=
 =?us-ascii?Q?hDQTM6NoC8ukfJTc8tVxG9+ftu7Zqr3amP2a0m8O9tPLLGFF4S394xHQFzHP?=
 =?us-ascii?Q?/X8Lqnq3XH0yZq6MfWwHQphvcYkLh788HMehAfYegV/pYUuixNiAv1lD+wmW?=
 =?us-ascii?Q?sHBT7jW3LrG4MDsM779fTqyoVNhQea75BEX0BJ5IIIXsrHhCOguW7lGRNQ0J?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OL2x/lmLw1M+TJ23WKlay9s0snY1V5Ab43Wlkr7eMap2AZ4DiphhYwIw/ERsMztpHQlHY7xPISHPKVypbrPx+hAY4l1HqzHNr/aC7PGCnFiXeFO1y8zr0uNmj/tAH+GcH9J/raqI8stHduZJrpRhm3yGIHC3Gp5oKb0rjtyPqJfpA9DCRda0wU+74GYwxcRVmyEipgpKiTQhm5w0N2oQLCFGyWiNTthBATURAKPGhBgHcIXSYHKhFvql6HY23NpSyE8HZBUC9G74y3zxKM/DXQO6Pv7FcvsedhPuvwvRW3fM199bFZA3t5li/dMN4u5jv8WkUdSnU8dpOtMXzuBk9pZt3twmY/unoL41LUZ2kZfiVxS5QtSBF0MQpOkBBik130WwYlfdEsA4SpwDljm0nqq+JmHO9dZQOw9ag+wi8rxeWlnaWve7RqmQ3q24hpJjnR/N55cD/cZSH+/yNeWj1W346IznvSXxcszVwrAiIQWBquhGuQR/3DQlHyD6qEY5MF+HZ3Lrw95eBVchB2m91OApaLGdhxxoncafvkrUHxwIczaK0a8cabUb6apKbqEAmayNHgYqrA/RR7ozCAwNm8WJu8CRBq4rM+BvlQikATmgvML3RgPAFwyFcP1kD9JSDvHTHUmL+841fBpUG+Eio6SchUSheFm/2/YSOTEm8ZsOFS143NGzsZCtbIhq/vvaaTnS6E3SpKh7XLuFPh+9hc8ZLldiFQCKjEmACG3IFK57c25ylG45vL1UO5msSgTUPUNQsqDuIvllKuiyIMGK/Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e614508-d18a-46e3-82f9-08dbbfc7e972
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:14.0387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JN1Jx1iYZudKDwE8ap44riPRIagGbWpZh63f0BNfFdWzOYabET+cNku9gh0133artVL7LtYR+5TSz+uS2f7zS/WCgqpZKstVMnnhKA5G+zM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280018
X-Proofpoint-GUID: jcrTtkehQwKClfz7BAfPliDRSbI-54dF
X-Proofpoint-ORIG-GUID: jcrTtkehQwKClfz7BAfPliDRSbI-54dF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This moves the hack to clear some buffers to transport_handle_cdb_direct
so we can eventually merge transport_handle_cdb_direct and target_submit.

This also fixes up the comment so it's clear it was only for udev and
reflects that the referenced function does not exist and we now allow
more than 1 page for control CDBs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 49 +++++++++++---------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 709314415a01..c2ddd09051e8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1593,6 +1593,27 @@ int transport_handle_cdb_direct(
 	 */
 	core_alua_check_nonop_delay(cmd);
 
+	if (cmd->t_data_nents != 0) {
+		/*
+		 * This is primarily a hack for udev and tcm loop which sends
+		 * INQUIRYs with a single page and expects the data to be
+		 * cleared.
+		 */
+		if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
+		    cmd->data_direction == DMA_FROM_DEVICE) {
+			struct scatterlist *sgl = cmd->t_data_sg;
+			unsigned char *buf = NULL;
+
+			BUG_ON(!sgl);
+
+			buf = kmap_local_page(sg_page(sgl));
+			if (buf) {
+				memset(buf + sgl->offset, 0, sgl->length);
+				kunmap_local(buf);
+			}
+		}
+	}
+
 	if (!cmd->se_lun) {
 		dump_stack();
 		pr_err("cmd->se_lun is NULL\n");
@@ -1796,34 +1817,6 @@ EXPORT_SYMBOL_GPL(target_submit_prep);
  */
 void target_submit(struct se_cmd *se_cmd)
 {
-	struct scatterlist *sgl = se_cmd->t_data_sg;
-	unsigned char *buf = NULL;
-
-	might_sleep();
-
-	if (se_cmd->t_data_nents != 0) {
-		BUG_ON(!sgl);
-		/*
-		 * A work-around for tcm_loop as some userspace code via
-		 * scsi-generic do not memset their associated read buffers,
-		 * so go ahead and do that here for type non-data CDBs.  Also
-		 * note that this is currently guaranteed to be a single SGL
-		 * for this case by target core in target_setup_cmd_from_cdb()
-		 * -> transport_generic_cmd_sequencer().
-		 */
-		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
-		     se_cmd->data_direction == DMA_FROM_DEVICE) {
-			if (sgl)
-				buf = kmap(sg_page(sgl)) + sgl->offset;
-
-			if (buf) {
-				memset(buf, 0, sgl->length);
-				kunmap(sg_page(sgl));
-			}
-		}
-
-	}
-
 	transport_handle_cdb_direct(se_cmd);
 }
 EXPORT_SYMBOL_GPL(target_submit);
-- 
2.34.1

