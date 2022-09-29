Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6C3C04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiI2Czk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiI2CzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:55:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450124D156
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:55:07 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNif6Y020801;
        Thu, 29 Sep 2022 02:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IW0dMrPTpp6b6jKffX1ZsG6XTvsN4xd7DFp4ZVSxR7w=;
 b=ftBFJyTzSX3tHQ32ZOhhYAn9tYM+lQgu8SNdLrke+o9hHeKhb31RwtMqX0lVnSP6fhiV
 VCdDg6pxVv77+yx78sUZQrF7dYg9kqGvVQBpO0912fqptDigUwlXbyucd/fjI3Fwd0CY
 bILAWthj/gOCjvr/i11EsqCBzPiw4SJyvNzEFo1UdiTnAQ6dPgoaY4t76WX48sFtraQb
 0ASmj0YGqTPYGwF32wYgq1yUA7KEP33UKSjrWAePsBkzH+2SSeJE9L3OTRCoAAPulK9b
 MfT7BloTO0s/M33qIO18PdDVT0WIJJ1o8mHtPEKH7I7/Rwo/Yn7ZGXQCbttdYlIrfFgX WQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13kgas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM1cee039455;
        Thu, 29 Sep 2022 02:54:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcqb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+1Xq/SGyotlOr9m0Dv43fPtsvl4f/i6g1v35QYNMih5t4z7vTOIJcRINnIp/WmWMGASiSRoXfINb+eJQO7gfBSeuyPlCJbLcFPvYQg+lMh5QBLXqSL/EW2I/QoasT7gqYUAQS6vBMuJ5CJLhHWOZP7Y1Ht0068Wdoa1GuYueGgtHp1mkngHAZNqv38wN71sgjAVwiN33DLFQevg4gVrLtocHCSjnie3inPauF1LQQJLfd3o0/QOVjJzT1CseN2btixuKPIQR+pjMf6oUXx04JV9l0n2Sh9tHuOfQp/w9K5SzEvBSljO0jdB/sWktCnPpMlkZ193kQo5injxmsM9/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW0dMrPTpp6b6jKffX1ZsG6XTvsN4xd7DFp4ZVSxR7w=;
 b=K+XD6QGnVTqOUyveGjIA7BkIyIpPFF9IL863MF3jLEb9GGAgkCozn2FreswvoN2HuR5i8N+Z9ga+Hgke940g/j8f2BUE9eTvhYswkhLTodjs+DCIvIjhivC8PspWI+AumvJ+0I45bZPQSLptn9rGi5bAWYhnVeBbP3/FOwiOMtYIAmxL+CgpGt9tnv9cJ0PkpVpxWWBkRMmn3UwyHe8iB0BrLloJ6SCcVybQFKZGtqu1LaUnMLY6QJsWtH+2gmfJ+LmEroxy9b9t1F/OgP21wubXO1j3hjk0BnAHP/w0yEggTihz4ncsRUpUihLWunOhHw19RRYinC/TiqsdtvRAbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW0dMrPTpp6b6jKffX1ZsG6XTvsN4xd7DFp4ZVSxR7w=;
 b=AYGNHBNETpbyBcJKZ3mrdC/bz8Qp2WF8mraGOQenDn6ecadJPVTdpmJff9eMch4zzFElke+Yqp9V/L+GqzYKXvSy7zHkN5RriPRWKvqftgpjxoC8/+6BWtRyqJ74+0hfRFx9/E5KzTNyYvGChTtVzR1QtsjDpdgbHe4QHjf1WlA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 08/35] scsi: scsi_dh: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:40 -0500
Message-Id: <20220929025407.119804-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0017.namprd11.prod.outlook.com
 (2603:10b6:610:54::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 827032b9-bf13-450e-5dab-08daa1c5eac6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+pfofrDAaaTrB+0rgRL/pRpRv0R3UMDb78JMErh31wKMKEXn15oPm09+K47j9Z80aF9bbtZuu4krYbXGNECIjhIU+OXVpdggoEhGU3Yi7JVbmMvJ4B8u3MRisB70SfvgEOhWEEwJqTfQumhv0StDXC4ZzWhgy/452hZ1sZXbVgwNbhR0rfxLZ0JKQZme7EQ0C+sGafaNNmcNzFgFldd1jP05e6QPXlCD01k2FCXin4m4nrdFIUzN2U967df/9NQtpmdj7fSyVX0bx5tsA/Gn94g/9q3mjDEelLcIexPOfTET6iHBUmyfbkAmjB3uYhUtQdltIgvLfOyPig5KsXqqHC+0uM2G5lG+qK1d4nbl0/n2nooG636ZSrsneUuGcq0fY3kp1NbCY5JoLNExKKHCCoSp3eRO4x/kPhMaMLAS0RRQu4AKe3Dgj2zQNGDuQFl3J9y4k3ItvZ9Fa7C814HBwL/qpWECT0Tu/lV3W+xS99BeShT5Dg8jhCYptL7eZVXjFnELdg942DFEZJ7f0ZHL5zwBVLLjS/UoPN2Ux3/QQVklkPX/+41KXS/ExUcE4WJzs7oEojvU2g5jXcqGacXX7RU63QwoRpOfNeJxICrS172RXoGDFWIb+qwD3DXc61aoHbSHqRTgCfYwo7A9SrkwzLCHC9wX/vsOLHemT7/7BJSYZdLmUPkzxIRFf+IrlE/WtFl0tIlOjTRL6dR4PXVKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oq3Iy1YVbaTkIhf9vwYK/b0WCR6/XECTUfAobwy+YvU58mUB0z+G9SQBXadw?=
 =?us-ascii?Q?PejhZ9mzBGqFNNo6lJKZc9VhTl2lCxMsLBl+OExAdWwCXbXh+Cas260DvNmn?=
 =?us-ascii?Q?kCQrhpT3E/HAMZFUVl8FPoduOm60q+eIImDA4/iMVY0/qBXxh3H9ndosC+TF?=
 =?us-ascii?Q?R6pNiBfIhqzWQ3Vl8VUjGngWZ9tOrC1iSDlCHmgGdjhPlB77gkZtIEf+OE6v?=
 =?us-ascii?Q?wqqb/PCm1oMX+It7QAyD1AZPgaotHXPuab76jZpD+w126NVpdF2Hw3lnWvxg?=
 =?us-ascii?Q?9FUiIt+xM/rvNoioX2laZ3Kw3yp7z+fi8tST5kh4UOys7hrJYMCbEBVCa8Rx?=
 =?us-ascii?Q?VCDe710TVzBIs0qqwINuxieikF2SzbO5zgbhaU6AtKsSD2ud80uo0VZOgwR9?=
 =?us-ascii?Q?wjUYCxvazkU8GJmxntJM65jecuFMioVlFpnewPmWqSVcQ5TAkW0X3LVPdnXx?=
 =?us-ascii?Q?Z4MLP5tBHGTwbSPGp8M6igRUVudT6pcu1JUUBjoCWt0Xi7kZQuiG3IdEBe3O?=
 =?us-ascii?Q?S/IDad1TDqbxlGhJn1V+rDnovxnVgkRsc/bRPFLtg5yxnPOaExkAzY1vltDK?=
 =?us-ascii?Q?EU53+vCAOGybfIjFz7WkTt4OBo+n3xMldxIf88cRPEXWWUKNYK3LFLIkL7Pr?=
 =?us-ascii?Q?ErsDe5bmBoGi71LrDKAU0wRs+R2uUZ4O6jupsvWhyECmnVrx53pZQDfTdYW9?=
 =?us-ascii?Q?2Jp0kKm4ENqRgzJgr0BGSm70D8MLahFjwMjy4c2YVQ2v7xNAgw6xcsSnNSi0?=
 =?us-ascii?Q?FacFfVEM3Exy3dJZux1mDGxKj3Yd76lXqEwLN66yUyKW4RYLMEAwer0DJsfG?=
 =?us-ascii?Q?6fWgaJ4BzSVuhUU7n6OZUDRED2VDJ7ULzPjsWhxUj6bonu3fTf+wwnHpsnCg?=
 =?us-ascii?Q?bjPtQB/tMC1U50dnFVKINl/Q4w5pN1Oe/57Gwzzoh1KWLxbksrD0AU4YsgEP?=
 =?us-ascii?Q?ShSt6LSU4kIHTrDQz4ieJcpHPd/6fMC6UsDwzzI6mWHvEOAh7SMM8FvdUnMa?=
 =?us-ascii?Q?757C8IEPzOFjSVBO94JbZrSYlNlpAXjpjf2MtM/qElgijmnl50QmB6ftQlyT?=
 =?us-ascii?Q?aomAmTbnj/q99CV+r9DZUQMmVTMdcQtVvwoJt/qSICol4rqTJHqNnri/g2zD?=
 =?us-ascii?Q?BfLqJ04uQ8eoLmb1zeye52OgyYBcaWDWItrYgW5AO74Iy1laDM6yIfXXRzWA?=
 =?us-ascii?Q?BYAFSJtfZ0WQui0Jy7ajeZ8JlmFv3YodJIPLSgx8VA+J4sXpilcgOEOjXDwS?=
 =?us-ascii?Q?JjaQQxv/aQdGdgXaI5ntc5mi7pFz/3b5EPtBs9DuXIoRtVGQhFkTSUUPQ0Mp?=
 =?us-ascii?Q?YzPAPK3GAHXIeSerVnUAfh761xR3utsrQ99KyD8UIfcuYcz6MDd3QmgOUR4u?=
 =?us-ascii?Q?UVPplB1ztafPDoKRh0xugRmPg1IuT20R6T9Nj1m0nj2VL/MUr5bJsw0R+XXO?=
 =?us-ascii?Q?BBhNrL8WpiwYJinftlQTlvF2RCMWf+mtvtD2u9E3gGQn6ScbjDgHCPMjo8jJ?=
 =?us-ascii?Q?MyaP4IXR8WqqGoSGqOTahUQiKw89fxMs1VtUnzqPQbo14RO0Raxh477ei4T/?=
 =?us-ascii?Q?yDbbNAvzB8qQOQ3nYuAj1kMuEJ1RYH8WpOo4lmgrOJBXoutbT12prYYWk/Qx?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827032b9-bf13-450e-5dab-08daa1c5eac6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:24.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFVHE8hgHrLGvVMigw3SIcWdOkO3GTXtdgl3bay50+DRQ5Sll5utYquvaGMEmb1BgBd12N8RCGAKwXAU+Xgf+W3rNtORIeBULagqU7nCqGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: 10WqbC6QKhqDbFQo3xEVIG5g2XPGFdgq
X-Proofpoint-GUID: 10WqbC6QKhqDbFQo3xEVIG5g2XPGFdgq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 26 ++++++++++++++++-----
 drivers/scsi/device_handler/scsi_dh_emc.c   | 13 ++++++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 20 ++++++++++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  | 15 +++++++++---
 4 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 610a51538f03..e4825da21d05 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -139,9 +139,16 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = buff,
+				.buf_len = bufflen,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 /*
@@ -171,9 +178,16 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
-			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
+	return scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = stpg_data,
+				.buf_len = stpg_len,
+				.sshdr = sshdr,
+				.timeout = ALUA_FAILOVER_TIMEOUT * HZ,
+				.retries = ALUA_FAILOVER_RETRIES,
+				.op_flags = req_flags }));
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2e21ab447873..0ad6163dc426 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -263,9 +263,16 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
-			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-			req_flags, 0, NULL);
+	err = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = csdev->buffer,
+				.buf_len = len,
+				.sshdr = &sshdr,
+				.timeout = CLARIION_TIMEOUT * HZ,
+				.retries = CLARIION_RETRIES,
+				.op_flags = req_flags }));
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 0d2cfa60aa06..adcbe3b883b7 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -87,8 +87,14 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -125,8 +131,14 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
+	res = scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = cmd,
+				.data_dir = DMA_NONE,
+				.sshdr = &sshdr,
+				.timeout = HP_SW_TIMEOUT,
+				.retries = HP_SW_RETRIES,
+				.op_flags = req_flags }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index bf8754741f85..c4d1830512ca 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -538,6 +538,7 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	int result;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -555,9 +556,17 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
-			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cdb,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = &h->ctlr->mode_select,
+					.buf_len = data_size,
+					.sshdr = &sshdr,
+					.timeout = RDAC_TIMEOUT * HZ,
+					.retries = RDAC_RETRIES,
+					.op_flags = req_flags }));
+	if (result) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
-- 
2.25.1

