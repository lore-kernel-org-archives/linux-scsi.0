Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053A0E810DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjI1CJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjI1CJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224C5B3;
        Wed, 27 Sep 2023 19:09:23 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL67IA000518;
        Thu, 28 Sep 2023 02:09:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+tO2VjHVKNgGEMU7q3Tzi+M6706HlTxC8sy1II9UE1Q=;
 b=nAf/P4NDn30IcYIWbvS9iUeyTqmiWioCHPgGkdJPhjihIDAJmzUFV1l1UswZXK+ROa0z
 3M52wHGlb/n2uSsXRdcT62VdTTY74I3tywMosqOZ9NFoYaWf0KFrT2+fHkhkUEeZ5iPA
 gCJ9I8+Uk20/nFuZqKFqsJkvx30wxGf88kzKigBA2Fj3tPeDK+Qys8XaA21ZBMttEWQZ
 AnpJFJAaMuFifEuoObsvmztn4kZ4EjR+cobHQgnC+YebD5N2/5MLRj1/8ZlItjPSW7Dn
 vim/EfrybIrRzlTd5zQbW8nt102+mFws0j1r74FUbOJm5DCdaX6qr1inFaB+HIvA56m6 FA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxc34ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38S13tsb023671;
        Thu, 28 Sep 2023 02:09:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pff0f11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfgCWwb3B3kgoasng6qfEsu2aTzlOfKUGXvh8QLfCsd0hfLfsgHd/X/dtRE43LvjmsNppQtrUF0tmQ+23p0+dTEXB58hgQ0nxCeZ7zHT/cf7VRps1Umh86qX6t/TSjQBZMIbBhc0hgLdxMvvAGEmy9WPwb6EkYcKBhWOZ4t7+JhhALYsNXj5Xgfh1toPzTP9bNE8sw/cX9H6BsKZHkx0JpW1FdD1S3SeLadApGk18dB57eTvPSCyuct/VfF0PXO2dSZNgb9zomr5TDqEHh8xkv2ifxg2lTGCuSsWm52hfHKkTSYw+lRlUX0PwRu6ga7qFv9eLesUtMRpzIUljsexDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+tO2VjHVKNgGEMU7q3Tzi+M6706HlTxC8sy1II9UE1Q=;
 b=IB8/h6B9tV0Kxr1zU6KyD2Pc+A7K/atHMlNu+ReeNDrAIb3HPBJhrrnLNzW8BqFq4y+5kEluiX6XbHnT8FAJhEHiv5PqBqJErCcRFhraFD2uGJwrWrPrQmDVJ4zbfRA1F1mfyRdce/cyZr3zivtnZK9VYaSdKscVn684feXWGyTUlnychdSGG6/v2D+JE30rOxL2BDtB7CAr31Bazcaiv3J9Mx9DvVr9nD0bhd5Z0iPpgQL+LgXd2iLUqo1upFhv8wkqYDVKOisHSS1tkkmsbo2jiRD/qGX1BN81J7rE6SIzt5adTNtjtgfIctk3ScpPPjzokcY1uBV0bEyBkDwFuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tO2VjHVKNgGEMU7q3Tzi+M6706HlTxC8sy1II9UE1Q=;
 b=FlpQmFlQ4sIzIxczFt2UNmlZO99bAj58TSKFtRzSNTtorx2QvDZnY6h4Je0SHhcccTybcAQtV2FueeuZwvtLnh8V9HqbSmLesmd1zO2zMRotjFnvYIfp5zHNRp2RaGStuuVPXRdAMkJxiXmEBExSX/wJPwkbsolHhsxy8kQLwPs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:19 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 7/8] scsi: target: Unexport target_queue_submission
Date:   Wed, 27 Sep 2023 21:09:06 -0500
Message-Id: <20230928020907.5730-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:8:2f::34) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: ca964062-c866-4186-ec4b-08dbbfc7ec8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlsWm8QONn8qSBZ1JPDN8k7DONlzaq8tgq54OOGWXSlVRTn0adhquuqWQHyPlMsv+eqpULAVAUKzAsYzMJC4DmigSwyc6rK5yWu4A34HHH0YFUqWUntdFn3QLS1pF82bYMijyW3Ybr4heD/LRc4F8Zv8LlBtvtu+jN0VmuVpT2U+TXQSqvLHtggsgcbog2UwRpWbx2i8K5YtWlspbHSV/sWHtgNHkLbPYdbGmsD/tzVZBD0FQVlA/SUh1RnFROwTYiSCh98si5aq/yAQyWwFiHdhhmBvnJWKUxyszjmQj/sf9p3DBRGVDqvNj/EnyHY8CTO7h+XTlMdxf/zL03EhClYmnOv1n/FMeR0vUx+TIPtyFeRHtZGvtsxkHqVgzyQ0TCTjfwFULrTzFwgthyDVCEXRJPY2qMF4R0PS9+1gZgYums6J01eKPcf4AqOJfiTOEb+MvZN0egvTcdXofOhSMnznoqrCN1uAP/m8ITbf3znT7hnMclMr79pkDLvYVuHfYs7eI6AcWoBkoV7m739E2EOe/QXLdFysbcPkwkbFQR9GpNk99at50WXD+vJN4Jmy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?993brq5A225ExIDz6krsBrS33ZbEKtSlwy0iAdEYcsPfsl3iEoeHxzAADGF9?=
 =?us-ascii?Q?z9SM4cKprtV79cf57i3uDt7PZKY7xqdJ6DtsgA2RZRIGogsdXwVCaFmEl+QN?=
 =?us-ascii?Q?ClulQuNLpZ5fgFbIk8DlbEI8KDzg1QK/dlx6rlBk7bIXvDCZeQkwj7G3F8XF?=
 =?us-ascii?Q?bm6dipbxNsYv1lYHwtZrcW9QvSwu7O9AoqYuwL/LC15TgVC9Vo4oqPMTOxhp?=
 =?us-ascii?Q?jTqTmZUPMqCYchkhfvUo5CpbQBX1IYEVWpUvgfFZHUSwiMuV5BEj/X01WmnN?=
 =?us-ascii?Q?wrS8uoigzPFzW4cvsLjOju8GuMzbGSRhnZI3qvNx5T9BmAHvUQ+BzJAB9Gjw?=
 =?us-ascii?Q?2SbPvOlTNmaJltvdflyMA2vh/sEWsZWZ3ApIaM9EVgxdeWjSu0cDpByJuraC?=
 =?us-ascii?Q?dZmvBt/vs580a1KhIZQDo5QWT6ThhtROnQCxCGWcqTn6bu7xoKGWRXD8gzTl?=
 =?us-ascii?Q?K9jkQ/iJGv63Sy5eh5vbPuRYXpEfCnmSBp80VKVHEe7w6kT8hVJQI9xyCMmE?=
 =?us-ascii?Q?MJleZarykGpDwpo0D6+6IImbglhJlZrvi5GKJb7NcVb3MmekRHY04UM00Ouu?=
 =?us-ascii?Q?Ol1nypHwLLnUU4iJ7vc6OsrPI8AxfVXC/kQ24JNtIL+JAVkpKimEYqyu6JHn?=
 =?us-ascii?Q?8eTR6EvKrfWtGatMIQHfnhd59mW4wZ1pReNN12UwOvOAy18BraB0OX3hd3WD?=
 =?us-ascii?Q?c5ZTvKLDL9Eb8Jg2CghRr/nYdsS1uvXPXSKZD0942dvGNC5qUl4opwOw/IG2?=
 =?us-ascii?Q?TELq+EKygMGQkoMwGpLTENBycuJe6m4/WyyMbWEkvTIIm2pqQcOSOJu7Aj0K?=
 =?us-ascii?Q?zTMrgO/SPF8ze3p7WVzuRwrhIAnusUr/QdLJXyQsviS0A/JJUls9+U4WKbrU?=
 =?us-ascii?Q?WZ9lrrDcsOE8dueQh9sbtmePedlsqj0aZ7ObhzMa9VsxdyDf8cw+2S3gNR1y?=
 =?us-ascii?Q?g8S1bqsgG1X3YLP6r74jczty7iY966zTcMNPnn/S3BAY79KzHHW4TkTXBwgR?=
 =?us-ascii?Q?hxys3d5/QWpm8E+Bjimpn7CA5mDWuNVG6EoT5HxuY6G0U3/zgtV6oL3tp3+a?=
 =?us-ascii?Q?K6EPM/5AiOFsYkjccz16w8CqWVoo0ctZ5sz3XFn2g/keKlO2kLmYCtRqJ9yM?=
 =?us-ascii?Q?gb+HI1qapeTu0ncLWdUQRd8t1Yaa7M3T+JMtMWlBXR+Ly1JfU8nAz18LwttP?=
 =?us-ascii?Q?pYitMpcQYS7nDhp6mvX4scc7n26KUYbj5E6k8ZrumA7kqdaQNwFEDCepGoqO?=
 =?us-ascii?Q?L5hAmgVnUqCVLT+vnxHRhxLJUVOo87FURxcoAaHbgjmkpb3u96xIrS+el0pR?=
 =?us-ascii?Q?/3z2/+SLWsZ5/CId0jhXNwhIDHR5ySdjHUMf6LcPT4MDgi67WjboAfkUGnSY?=
 =?us-ascii?Q?PtHB7i3opjMOdoQdZoVgq4ClpD78XvIK3XO5WOjpAim6DiBlcfUIrh3lafpW?=
 =?us-ascii?Q?/V5o2nNfgFHxcxK4ByV+oXKZSflc5QgyQybDmlWCNRwuUDnqiKAwF0O99mYy?=
 =?us-ascii?Q?L5r+uM2+3L8QYeaqLWRVLo0amPJfJHvGwYANlAL7i8cinj4RJGuHaTaBdnK7?=
 =?us-ascii?Q?wvo3Urd7yzeDrzONszGdPa2UvbqtIKCCvnzWnrWtPsNpRpgc9b+0weO5Ed69?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VvYOhW8DsuTAOo/RZ3HICr6GEH3QD+RVzJw5EZCc3JEpoYf/yY3Xv5WPhEKmbTl6a6AqiuqHEn07QM/n+sGeaEKvoxj604uWYgj5C47K6zu1yFTXilhWsh0ot6liPkDxNFeH8dUvQz3b+3b0hH7mU9v8U1OZMZRZ/Oow2TrwtVY5iGKu6SmYArajP7pLEX+o1DmYRDq+ynT/oJpeaxqYbGjBLHSnkL4R0oU470inkkyMGAQyP9TAxx/vfiYY2uKfS20r5Zn4sHPyxFfLHZdgAuBKlTBZQHXfNZeurww+M/MDbS2yTLodGYRw13bU3BPz/9HiQbPbMJhyyE3x6FCdy72hDdCeLKjXkXyoO42ZAcXg7gdVh7R/xEDBfZkkTnki/htZcpT/4kWEmIxOHDxYzOqPPDj8SFX0E7uVOxJTgFgjVvLutVvyC/FZlN4kSypijJkfUwQK4Ne6UhuGwIz/u6/9NGl+/bAPqfnMZSwR8iP1SK/S1MsNv6sBjLWJosi18hhiqNzkK/H/wulxP3/H390MIF4WPZGAHsfQ+EXu95iBf7icOyy5CGUW5Dhx92ZXyPUaC/TpuhZ650ffQ15+X3A3bXgE7puU0aX3Gsx5jK/hG9Ge41dslXL8U6iy6NmCu/rlcKK3dW2usEWIrOlhQtlkpggx+PnVhERPTKncRIhjn0IYsnKFgwFHq2KfW+Pf30pkwgSvW4Y1JwWdTEWTQU1eWIV6ScI2Uq14cu1KU5i+pCRi+QLvwg39s/1Jnx1xCsFtYRyJZwM/9DwfgvoKxw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca964062-c866-4186-ec4b-08dbbfc7ec8e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:19.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ilxLo6aWcX4wJBQxbBBcfSh8hIEBJAFLxoiko/JcRLpPzhlRu5Rcmf/oYGkQv6ju8JMORN1acGEmDOecauKvhjTT8jnIx9KmCIapJ4oG+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309280018
X-Proofpoint-GUID: xUM9dWykO6g4Tl1aA1wK8yKUsUeyIHB7
X-Proofpoint-ORIG-GUID: xUM9dWykO6g4Tl1aA1wK8yKUsUeyIHB7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_queue_submission is not called by drivers anymore so unexport it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 3 +--
 include/target/target_core_fabric.h    | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1fde18e1ef3f..c81def3c96df 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1908,7 +1908,7 @@ void target_queued_submit_work(struct work_struct *work)
  * target_queue_submission - queue the cmd to run on the LIO workqueue
  * @se_cmd: command descriptor to submit
  */
-void target_queue_submission(struct se_cmd *se_cmd)
+static void target_queue_submission(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
 	int cpu = se_cmd->cpuid;
@@ -1918,7 +1918,6 @@ void target_queue_submission(struct se_cmd *se_cmd)
 	llist_add(&se_cmd->se_cmd_list, &sq->cmd_list);
 	queue_work_on(cpu, target_submission_wq, &sq->work);
 }
-EXPORT_SYMBOL_GPL(target_queue_submission);
 
 /**
  * target_submit - perform final initialization and submit cmd to LIO core
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index a808c3c32004..3378ff9ee271 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -182,7 +182,6 @@ sense_reason_t target_cmd_init_cdb(struct se_cmd *se_cmd, unsigned char *cdb,
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
 		unsigned char *, u64, u32, int, int, int);
-void	target_queue_submission(struct se_cmd *se_cmd);
 
 int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun,
-- 
2.34.1

