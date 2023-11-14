Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693B8C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjKNBjR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbjKNBjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:39:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB901AB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:39:12 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsDm1000855;
        Tue, 14 Nov 2023 01:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Jxsb0thGeaakGaSIIjW0c1lUqI3rg/gUtemvguE1cQk=;
 b=OLbjeF5vjEpkJFWElELJsohu83q6dv4LUJDDY2ZQz9voedcCZsNcVUGcAEtNPtF9VHPt
 eEXr73bytY+MswFbmlijpI6mR8GXfVeqvnVBcNtag2ZkAixVCSuAXA1UxgmzK5Fr1xpO
 /w8TfA17gMZ/6XIWc2mgeT6lASm6VPTuIqHNZK3KPQXYbx7vhn0tzb4eEqnFPB+v1+oX
 AmSPIlVQ0yGos74Q38xbqc5N8N9X/y40zz27FStYCl247iyEYbV+i08os/KHw+crTGUo
 dKEBMXIZt6AHU4bqvrVL+gXeGroAXbmpPbCCBaOD+C06APfErFzDxaE1AoAu+w/KiJIL 2Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qd44eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0btSe020722;
        Tue, 14 Nov 2023 01:38:05 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxh0h6hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkQIWTM23zkcXnriXJOkDjd3ZbC0JuKII4Ma9AT3Uqwjcb5TVVL0q6hRRUp6XnOVu7zw2YGXNcd5ljkonb/Vf/SBJHvVRq3FixZT4BpMJsahpnwmiOVeO3eLGF+Vp1qdBsDt+0ph9Mdi5Fw9i1PWInYXBaBqi4Ae55eLGM2fcMJeCamR5j5g0/cNzyP+gJIQnd9Si514yZeIRhCsJtCPoHG3IRphZmjq/cV42GXWvmXfFyxoxU2SRDqzUOKiaAWe441+frtkPfBs2TYc/VdY50gUFV/o+9UDdBPJfURzSnfhZOCEqhKhnkf03q0C4CMOEKPAgPXQ5M323VGkXTBGpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxsb0thGeaakGaSIIjW0c1lUqI3rg/gUtemvguE1cQk=;
 b=Mxz7Cdw3y0gr7vkPusum/p8ve0maqWzPeSpSAQR1xbtWiSjOvDsYjKMlh1B+tmhJjoxmpjMm8rjmPDgQUOmipAjls9HcvTI17Q0uTfuNkP+AdWrt6F/RdRcMT6DsyWWzAPQtqdfiNLnlEzw+Vk4fcjof4u5ZI/jU6uy87ullMZzGLS/TU/u3YMQlYEOPRB/MV8QdyhvtUofuEQyEDiaN8T6oYpwu+ybeKqNQOedsL+cqrFX2+Z+zf3UBqBNbBJX9z0F+SWhBFOXVuO1q10q8vrYenDSr4BWmFICNSA5HIl/reOp8DcVYUvGEn/1qsvywlF/qAGNFKKNjb3rM2ihCng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxsb0thGeaakGaSIIjW0c1lUqI3rg/gUtemvguE1cQk=;
 b=wfa8kUDAl852YXcAoTaVL/vlue6ZWAHSfTCE9nz31RuSnXS1KR3x+UldzVlw0x91B3Zz19F8TAQNh5T5dMeM7L20toY0smsgcaB9J3Wwr456nFw3GYAS4XE49yLLjJf9ZeCKowDxXhKWcNEBQOGl4WQ+Z75L3J44V9MXlNpNfn4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:02 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 08/20] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Mon, 13 Nov 2023 19:37:38 -0600
Message-Id: <20231114013750.76609-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:5:bc::47) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: cbcc9192-48cf-4893-e267-08dbe4b25773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nkaa1MnBHORNCd3iYClTFpjNR+hwsGCIQR7PpRIQEVrVDyTcgP0uHUqvAmycFidvlAfbUGxXbaLvFtJRv9sGYN9ttjiPNQZrcOafQnzvQ//qjezu3RbZlXj6/PVDtk3MILAr4BscpJE2inCL83DleGlZF0KP3uUR8Yae+KrobvcjJikeaUh4TjxY5aChvAr5sWM9iacHS9eF/Ih4FspefHuWNWdeDtReLtgYtp9OavnyOUjl5cuOWgwxOQF7qBSNfGEi9AKJYI6xlriuNajwccX12fe32t48sdxo5GXVe/bTwtlv2ernrSB0GdqNySR5q996jHhS6kO02yknAFdJFiFeFrJiEPURoSd317Lm5VZkEbHZOnu0tcHIy4wLVbxX22mAOT0U+ighey3QP0Cs20cg6ogem9VJqfD/ea+0KeeUC4/1Ww1QTUAKQna50zha9C5G/GcPJ7LDkecyhjeqGe4dTtTI7ESsM2QliugfPwNGF5qrGcH4rrLq+zdR4Kx0XcIDU4EvITnvKjcyLQwAroih5mPT9dUtnP5AkleLCsHk7tzcn5KoxBeMzQpjT/jj2/sCSXcBFXnwmA/veFx9QE1ei3+15pvWysYqKgLvqsKkq57c/Qjl3W0mKeqsxzYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230273577357003)(230922051799003)(230173577357003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZNLoSS9M4xwd+8I3NuoLu6ETaB0N37CekJLTzYv3uF6xakfSpaVqCy1VVda/?=
 =?us-ascii?Q?5v4qZiau2XLW8m08/qxo66oXX7vZjQLUKOCRtZFi8gq+s7UPlNuhpkbclMtb?=
 =?us-ascii?Q?qnQEIvlxlKm1wQqSiLvSqMhOIDAoxghAiUbgaBgO20vSpZaQcP/823TkTSA9?=
 =?us-ascii?Q?rIaSYxjH1+5JXz6lrKDzvs50KXedMrjlq/U5RhN5Teh9St7hgjrZ8rEUWM1r?=
 =?us-ascii?Q?Flp3Sqbzn1DSm6N8Uq8odlOdzSbU8132Ipj4DH+OUQLgfFcoaLbWGTL2C9AJ?=
 =?us-ascii?Q?Cq/DnNMarRUox5BmhUDaxlOXqwfJoPb6vvPuehtY9+WEA0BRkWBwlklXU/rv?=
 =?us-ascii?Q?kHKNufFk84RisHjiP5cxqAtcOyyXSbb7YJFut8maaVXnNEa0pet6qgtZKPIW?=
 =?us-ascii?Q?mRPPRHOIh8atjuajCT1PazZzcYF6giy/0Q2i3J/77yEm1K+r0Bhk3phhKD5e?=
 =?us-ascii?Q?jnb4UOiEewZ2/5qOLciKaa1ppegkN6ju5W5qS/AnWT7NOGLNz8mY8p+veCGb?=
 =?us-ascii?Q?zv4u+l4xzjRRt8GhKVh94UR5Qxlk4gUXRPJXCPmlQybTdzW/L3YXT7LBDucv?=
 =?us-ascii?Q?kUp++MpwrBHYMyjt1Qg7XZYW4mmG+vGIMzKnyVmP50M3gu1WSGlpMBFQmnqY?=
 =?us-ascii?Q?W4znZ19t4FnozAAmc4xD/1aJlmRPib7llT4ekVL4rvkrTMw6Wiakto6EdtHV?=
 =?us-ascii?Q?TLFmM1nUHZMACFl9FlmHKxTt/hz1MuNavk1WvhusKNdoOEgbcY+mozMHvpFu?=
 =?us-ascii?Q?x+iArHxJSLhqkwWGrTJ1of8xxciOYAVsDMpH3KtKQOlwa6mEnHBeC7K3Y9p3?=
 =?us-ascii?Q?h7jCudNredtV8G45tx7IOM94OGvizgfPjvp2IwmCZu5U0T0bUGqZ8fsgsKqT?=
 =?us-ascii?Q?QOuxNrWFqFKgZ4wwgp1B4Mqie9Qr7cSEXXB+fc3iOk+ji7hlkupnYp2roXS6?=
 =?us-ascii?Q?DIfidpJ71d8m5AVkdTNFrMByxcVlWxUrKv24Ls0VgCilxdcFaZwPaz8g3Zpm?=
 =?us-ascii?Q?NWaPFKu3U/l8pPN5Qd7E4X7x6OGdp9fLuM3LaxvF6k84Av/TZZT696DVBS0B?=
 =?us-ascii?Q?a+PgfELLKRKTjLNDlSchqI78rLE9OECXLbfNi1N7Ao2hGKwe2ikPK+QH8RzQ?=
 =?us-ascii?Q?ne791K73lF+aX7sv77pOSLFcJz9hmqxxGGvz20BdCB8CoVOmp1RqjZOJVGtn?=
 =?us-ascii?Q?SGR9fYLur8oLIxiyHMEUxBg6B+jt0YkLb+vozcBgGIA2YR65nAO5gzT0gOOx?=
 =?us-ascii?Q?6gC0tTC3vXTLwDVmoA09jEZqlN6Y42WDMibAwoWHj+9vfzy1GVKQudUfsIl6?=
 =?us-ascii?Q?wkygf/BQahxJQBsgUbThYLwzcXZfjpXJf5Qoyxvx2y8EMHDcWXvB/Umfcgug?=
 =?us-ascii?Q?CWL4O0JVpdptLqYn7I8gFgQLkaTGs3piDfSWQEUiqNEeJ+B8OsoH9FxEhfA8?=
 =?us-ascii?Q?ZRexygfzZ5Cgvizw/xRluwaz5sK0q5x3LE3u4uyP0YeBf9BSjhsRgWxy7eLq?=
 =?us-ascii?Q?GZDwDSucVXfUE85Wy7z8wZyWMFkOjNFg+41ygOvW08KP1uhartw/eTR6chsq?=
 =?us-ascii?Q?5ya7IZi7bkpSY5OavGC+t7A3gNONkb7Qf6FYETS+smJUOJeail4BTANYqvmH?=
 =?us-ascii?Q?tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: P3mMditPvfAn2eDRrfoimgIXH/zSe6c7/u7ZRSNyee2LXJoPVAhuwCO8tgFuHujBxVaTsH9nsMbO613Gd3t9u+uCi9hisJNJzl5+gfDGhjX4ldMRsKGhpLCK+sHB4v9YJzq/rDNjKt0pf9R02btslK7RA5CIET9UCnK5hfq9FKDQ0DhgqV3GrgkgTFwN/v77tC1as8A3QdKpzIkRKODSm+m0PzkfM9wCi9fOM/mYZO8qhJljzRv8mTtxke/fe8DHgXzT7GSYTDytXoqA7vM319kZaPdorHg7iJrGEyO2d5QZ4Vp1HQS0wB2LOgkM7P576zznrPoXx5PXTrC6k+oYuj1T1/60MnMyXLd0KH6tYc3VGZrTXDBcH1dEPUSPT04Z1irqQZ+jJcgy4L+c/SRuIgaV5SKMbvxlQvikEGpFX0Ks/4lHB89xPAZ2cX1ct+q0NOMFFmJRW/nvFw0rB8Wjs7LrZ1dxdzEbD0KLe9LrxTFR3kfd/c9YoSSusvcQNm90Nv434ZNTwJrVqSMp3ssv1SofB1SVo9kxE1yLYsLXevAXAkYmDv908j2Pvkd2gCbw4ZDjPBq6Yi3FEH57S1oITBS4pDbOMGCEUlJMxs/EI3w+fg3B/0TWPoyaZvmENXwr1b8fo66xhNSQpMqJEcUpByWww45pFpnv0oy5D48dnBLdZ+FYnwkDkqUahCmUGSGOQkdN8IB09yunJfKzugsD6NkiD9PgbYkLN7R0Xw9HxtTaj3DSSKK0o8JwcQhOMZuRYJYcKZFtWdunsxg1B1DdeapUNglat5R33Jf+aO6pImjBq+LCg+ukXil9uXwmdixS4oOJQnMrBt5g4Irn1SzI39r9lfT2w/K79ymRshD541cdIHTsVTyM5h+xIbXMSanX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbcc9192-48cf-4893-e267-08dbe4b25773
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:02.6774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJM4oLd5SSlnZ62kRPQQzYkYgnq8sFzBazpy2nv4m5SYMQFy25kzVntKPSE32AZ5t1yx31qu81kaOPgy/Atk9i4tnjYyOEGbCJXEHAyTYMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-ORIG-GUID: wvsCVUDU_PYtNus9gTDwwF4Z87owLykn
X-Proofpoint-GUID: wvsCVUDU_PYtNus9gTDwwF4Z87owLykn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 84 ++++++++++++----------
 1 file changed, 46 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1ac2ae17e8be..f8a09e3eba58 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int rc, err, retry_cnt = RDAC_RETRY_COUNT;
+	int rc, err;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,8 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t opf = REQ_OP_DRV_OUT | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* LUN Not Ready and is in the Process of Becoming Ready */
+		{
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Command Lock contention */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.total_allowed = RDAC_RETRY_COUNT,
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 
 	spin_lock(&ctlr->ms_lock);
@@ -548,15 +563,12 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
-	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, queueing MODE_SELECT command",
+		(char *)h->ctlr->array_name, h->ctlr->index);
 
 	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
 			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
@@ -570,10 +582,6 @@ static void send_mode_select(struct work_struct *work)
 		err = SCSI_DH_IO;
 	} else {
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
 	}
 
 	list_for_each_entry_safe(qdata, tmp, &list, entry) {
-- 
2.34.1

