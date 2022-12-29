Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F72C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiL2TCp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbiL2TCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:02:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAB213EB7
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:02:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxPuF014152;
        Thu, 29 Dec 2022 19:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yRqW49R3AX2G10zBW7QJuOU8XCppKlme0z2np6hl9Yw=;
 b=o/hZP7/J9ZG1bkt+4UVswLs5CESvdd6/hNkNVTfvPLs4nGbsMLJvdmc+h0caVNAewX+L
 HEnFU+wzbSmXX3bxYYpjreQfncyAuMPcDIUq8cJQ1vgAVOgD+133pqQa6as68jd2XgC8
 toCJXvsX4LzTrS3fUZerTx/KOw9r7K8YYJ9B6laa/brpVdoBM/iCxVIp+wOnQDk4VnFL
 jkOtdZBSPFHzeC40iiN1k0ag6ZYBYWFVRuxgJTJ3Xs7accS0nJD1krHWTQSPcFv2ePel
 sgbXAowWIsGpdQti77KXZZDEPq+vVRGlWkaXdf9uGUM6vjor+vs5QXsiaKyVnJpZLTGI Yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsaa76se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTFunmf001312;
        Thu, 29 Dec 2022 19:02:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv7985t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN4RX0THvcAyB4LG7eKUoLQZ6P/UkRqErN0AG8xFSgDJsasTkMu8atz6MdgK+LNhqZn0l/K2RV+r2QMgJ1fHvNeVgibvzelGp9P0S5cbICH/ZK9bwzIWSlWvKk19hryosMP371jqsICjo5TOYcZsD/e/D+zJ6VErx++tdfDKzACMDfeEjb5pDImw33f+wy33hE4cST36YpInTFN3i61LDMdgxlaMk83uJZYQUsiFv6nw+mNa+SLrl9PjRbD4ploeYshMCpPvmBb5iLveqiGWVj3sn265jeZ6Wgt5eTlHj4tOhi0PXLlyMCpRaGPuexS3zv6r+asMwrKJjcrqFoIcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRqW49R3AX2G10zBW7QJuOU8XCppKlme0z2np6hl9Yw=;
 b=WvR5A7EZf8LVqFuYajkLYnNVgKZ/HDfRMa53xYSR5KXnHjldYIJaOW66jwpBDLCObyMUusoykY0V0nACh67zE4yA8OPbfH59jnUPf3WC9YDFG+LCsueFfa4JscPR/jXCH1LkPgWVTUyGYwe3s50Rh1vWoinLx0ZGGVxr9lVIh9477m8rNL5qiGRkRZNb4Mrs7rYxVGNY970WgGHWJwbxTAmZ1z4uIGVlF7KWvjyELviSMkPYugZ02RenvLq21alv0TUyeBlcxcRVp/TmPqbTgvWvwQQMNu7ZzwO/2pwqimGnQjRV68etGzqV1lgHBEjTrHXRBmEAFEefMZ0YbBUaWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRqW49R3AX2G10zBW7QJuOU8XCppKlme0z2np6hl9Yw=;
 b=WTodVsP7BgwtDGbLLLJrnRMsHnzxtqDiJzak8TjLo3J6+D9KrgxGx77+pZiu4b8X8jkWSCnL/rs157ORWXGXhw9ZQnpccP2K8gHT73GetExN1xcS+D95aVKWmo8MUqglmYpRQ6FttSzQ/8pFEH0knWiqrA43qegVLraRF+ldiu8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 04/15] scsi: ch: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:43 -0600
Message-Id: <20221229190154.7467-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0446.namprd03.prod.outlook.com
 (2603:10b6:610:10e::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb27a68-d584-471c-c732-08dae9cf2c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SOWYswJwH8F2hsv7eoPhlrYpZsBwrwO9HXbNN761mBqc0cfU63ZQWltWCgYSIdmfdy1tSFnjvQfzAXGpzKhVEYTCQTZu6I1A/nIsXkkoaOf49JLXFrbaiAJzPQB+4KTVWXIoELshQdZ3GikV/w3Am/CeHLYcVtylG85S6R/fN1OSi8Irzac9l0MEdXqZ17+feGeAbaLnNzoexs127rRekNspqN53pzra/2HR7/L/4EkHiwtGtQm4K7b+dTKj7RsNTAIcrD1Awe4uVP6+RRB+GSGK1IBBk/JQpS25eP1Xr7R23Lfmjl09ui877ACo4Y2GqF+cwE3kluz5E/8pYlDBFr+Qh1V3WSya19Wuu9Il8JtzbIB/sTE2tZGsz0s+43NtmXilrqM68RrFVU+LZSzQEVFNeKN59QJs7Ke1va17mzsegTjARjXEReATXQcelyWAU3pLkfYcQGA3IvJNFrQjuFE8d2KR+CWB2TDskk+kKv/XSI72eSX8FzNIhIeJ5P9HZtaoXNR6StgrJ4k4Zw1omj/lJlNldrL5g9UhiQVg9dZMAybVyzF29J6heYqT0QB2Q7twBhi5aMfiEcRxGCgNi4mXuypkVB71KO3QPldtiq31w7D/ui9YR2Qc1WjbAnln2sxtcnP0JJiRNApbO4c17g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OzKaPRiVbPHU9uV1VrsazHHM/3SkwuLiZjXKW9W6qPXstaRliCByL4UkpEYv?=
 =?us-ascii?Q?Xhv/KwDQQjcv+5ggUYfP52OOBBTHzbD8lVdjnScKPxKnhOSPKtYAPk44mZvg?=
 =?us-ascii?Q?41Lmc7pLUxVgZ90tu7R0Mq4+QmAU3qDTEqoMMQjbUjt+zmAOmsPKgAKXbeV8?=
 =?us-ascii?Q?QrcW1dF0ptN+/G+by/sVbGLSBMsDEdnYLtHyfTQ5PKj43bNRp/LTGlLBaX4w?=
 =?us-ascii?Q?rKi7LlmW7onUwhxP63ynT85bqNx1mlKKE3HlkppiTsxRYJEAX9W+VbjI5Zqn?=
 =?us-ascii?Q?H7XTUi+xoRyjxGrC4TQYFaF/zFVTdSnVPM8DvENL1+aSbRKq0Q/5ZGqK95cb?=
 =?us-ascii?Q?ESC9XXfjfDCT7uQnlpDjjIlLoIsGnzghR3Kt1SgaN7IuprMSWWaK90QfjDBe?=
 =?us-ascii?Q?LzoAgvHq+afywOCczlXT+fisXZ/0QMjomWn8IMcSP6KMsh06zD1gBZ0T5psB?=
 =?us-ascii?Q?kFig4us1PECeT6NepmqYRTEp5W4PoTZjTYr6CBvbQotY9lCcC+vQI2Xnxmwq?=
 =?us-ascii?Q?8JGrxqXwfqNRoftZlSmG3HrhKHHRj0kwPUZQ7O69tPZVAVJ19mTvVrD6kFl4?=
 =?us-ascii?Q?ry7qeHBw6mbJoEVxFhgocVrmE42+xxdc/W3LIgP/Tan1OUxMu2L/w/PiSMsI?=
 =?us-ascii?Q?Km2n/y0V1wLiKXFIhOWNGiDIk9cpJxo4ApOW1etycmFRChbuF0I5+eK2rGBY?=
 =?us-ascii?Q?4TQX64Bk6qP8by4XAhxXIs0TGm7y6oKll0i89Cqi/c8l3qRMd5RTCG3elVux?=
 =?us-ascii?Q?sheAecz/2YoowKZElajSaXi0UfoHbTiNvk4XybKo1Q07KVnvJVxvR1BpxqSn?=
 =?us-ascii?Q?x7IQk43f/DokdWCr3nX3M4atIgkx00lO+DhjjEBaUncNAEDO1BOtM1c3j6z0?=
 =?us-ascii?Q?/C2nkK3imqa3SeQ5qrW1u/cW9MbjrgCUC6NFKXdXy6bMn9dcjpWWk1mZwfCY?=
 =?us-ascii?Q?Ki1IzzYObcxgP5F3vJZ1JQWHBCgYkS9oIbxWxxHaxpRZx9kV0Hx2DoHUBvok?=
 =?us-ascii?Q?cy7iwFcKFr46RaiVQeaKGKSOn2cveK14cQJL/izFLxZqMCwoD5yvtk27Jq5l?=
 =?us-ascii?Q?jLsOks7SQAoVQFebRcwE/uTxoWy2FOLD5mwAcnkrkMcEwVELeEi/9Kte1q5G?=
 =?us-ascii?Q?K9X3Jllhj8AkZtCdtpdAY4SXjd4pL0eiCwhZWhNYNv2jAfsDmxj8+j1S2+XX?=
 =?us-ascii?Q?7fBBo4J0VoFIcnQSxGKDZjQPAmVUz1ffGSuJc3lrBdrVk1MXMCId7CO0szae?=
 =?us-ascii?Q?6gkSyctDTEyZNJxq6MgqZ7ybfBf1GwcbXioLM3X2NEYq5uIHp6tbJiZ2JsvM?=
 =?us-ascii?Q?ex+nqNvrys/x2+8EzfJhueb/lXhy1W5MNoKu1lmDT1gCbCCs/3Y7bIQr/wdg?=
 =?us-ascii?Q?V4VrKjrKXaa1WCI+3CtIW2BYMxFfp/9g2di9Cw4vFyQvXPResUsRibdbMMQe?=
 =?us-ascii?Q?sIArtRsMlFDuTgukijlVzP5jh0aFgQ3Jni4cIP1E+OQwVddsaftX9yj+hRNm?=
 =?us-ascii?Q?HojHMCpQqvXPP9Kw+iv/WCcrNb8TS1m/0G8rGEC+1z+Ykc08X1EmQ27+y/ot?=
 =?us-ascii?Q?EGHqrH7NLjXizSJlZpo/w8TIhkEhxavT+iZBhVfaejBVKG5AAXK8RGgVYXP2?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb27a68-d584-471c-c732-08dae9cf2c72
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:04.0974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: McqOoedW9Q+Nk7jE8EXeIlpuyvl55reGn1dTP7b0KVRUZsI9mahKSnCxqRBTEy2hW1uIa/1Jf2B/9H0J3+nverkTWosEmWx87+Rt6xRGwy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: zjbZc5ZdWh2-bt4S6lOyD3MIulpHbC2P
X-Proofpoint-ORIG-GUID: zjbZc5ZdWh2-bt4S6lOyD3MIulpHbC2P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert ch to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ch.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..72fe6df78bc5 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -184,20 +184,21 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 
 static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
-	   void *buffer, unsigned buflength,
-	   enum dma_data_direction direction)
+	   void *buffer, unsigned int buflength, enum req_op op)
 {
 	int errno, retries = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
+				  timeout * HZ, MAX_RETRIES, &exec_args);
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
@@ -254,7 +255,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	cmd[5] = 1;
 	cmd[9] = 255;
 	if (0 == (result = ch_do_scsi(ch, cmd, 12,
-				      buffer, 256, DMA_FROM_DEVICE))) {
+				      buffer, 256, REQ_OP_DRV_IN))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
 			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
@@ -284,7 +285,7 @@ ch_init_elem(scsi_changer *ch)
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = (ch->device->lun & 0x7) << 5;
-	err = ch_do_scsi(ch, cmd, 6, NULL, 0, DMA_NONE);
+	err = ch_do_scsi(ch, cmd, 6, NULL, 0, REQ_OP_DRV_IN);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
 }
@@ -306,10 +307,10 @@ ch_readconfig(scsi_changer *ch)
 	cmd[1] = (ch->device->lun & 0x7) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
-	result = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
+	result = ch_do_scsi(ch, cmd, 10, buffer, 255, REQ_OP_DRV_IN);
 	if (0 != result) {
 		cmd[1] |= (1<<3);
-		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
+		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, REQ_OP_DRV_IN);
 	}
 	if (0 == result) {
 		ch->firsts[CHET_MT] =
@@ -434,7 +435,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 	cmd[4]  = (elem  >> 8) & 0xff;
 	cmd[5]  =  elem        & 0xff;
 	cmd[8]  = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 10, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 10, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -455,7 +456,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 	cmd[6]  = (dest  >> 8) & 0xff;
 	cmd[7]  =  dest        & 0xff;
 	cmd[10] = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, 12, NULL,0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static int
@@ -481,7 +482,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 	cmd[9]  =  dest2       & 0xff;
 	cmd[10] = (rotate1 ? 1 : 0) | (rotate2 ? 2 : 0);
 
-	return ch_do_scsi(ch, cmd, 12, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, REQ_OP_DRV_IN);
 }
 
 static void
@@ -531,7 +532,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	memcpy(buffer,tag,32);
 	ch_check_voltag(buffer);
 
-	result = ch_do_scsi(ch, cmd, 12, buffer, 256, DMA_TO_DEVICE);
+	result = ch_do_scsi(ch, cmd, 12, buffer, 256, REQ_OP_DRV_OUT);
 	kfree(buffer);
 	return result;
 }
@@ -799,8 +800,7 @@ static long ch_ioctl(struct file *file,
 		ch_cmd[5] = 1;
 		ch_cmd[9] = 255;
 
-		result = ch_do_scsi(ch, ch_cmd, 12,
-				    buffer, 256, DMA_FROM_DEVICE);
+		result = ch_do_scsi(ch, ch_cmd, 12, buffer, 256, REQ_OP_DRV_IN);
 		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
-- 
2.25.1

