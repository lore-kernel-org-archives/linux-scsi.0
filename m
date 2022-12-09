Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2478BC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLIGQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiLIGQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:16:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2629A944DA
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:16:14 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MJ6nk003050;
        Fri, 9 Dec 2022 06:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=PAhvQBMUfGw98GaLDuLKCxRM6MaM2bmhGACl/P8/DfQ=;
 b=FxQeP6DWT3+WWs6GCL42acYZZIfwmreH6WNrY3RLMyRzytjePCjIcq8HP+LLyHJeRFVH
 +VagQ7Nh4zVD6g8OW0QObE7E91G2a35RO3VlmJBrEduGLkQpehvZn7Bth765qqJOsQ0B
 bRh6fj+05/YqgLebm+D5SLRBNF40BFKdL5jg58J7czoQMzWMVbbOvvBz5UWvutIGyU6R
 689V8xufN8DHLX3IkTTHD5hb1NkXWUvUOFG+hxSYABmwZaz2V85JvwfYEELCTXAQ7/yD
 7QoFCBo4HmunQSHerCXvlLREV7JrRoYU2ugI9i20piCmzZDVx+sNJHFfRP5+5pCSWwno OA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkcjeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:14:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B95ZnmR033876;
        Fri, 9 Dec 2022 06:14:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6c660h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWxkbeBkNmQJavYmtd1yQnwBULi6UnMP+oa0sCOS5kgKsGBM/RhOQMhg3d0+Z5Fy6AGQ6vTMMs4iPHCTF+baDnzJS9T3fv1X+AgdR9ABB8XB3OYVDWSWu2qTE9pRVXvZWUmWOvHb6nnkPzOA8Leq1bnNjmlZFb46bglfQ3MepXNIsL1rKC32ctHHGkChXgHnkWEzBPBQJY2W3wHKmg5Moyce9cIz6TRydwv2F2+HOae3TAb+kO1EvLrYQao1EwR7a+8s+RZugUbQQFeDp/CjVIOXS9u22vYJOs6m5+AGhjfWo5aRXrOsryLi8oCUVFRuxAjukB2J2ZrlFIgzwNGCew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAhvQBMUfGw98GaLDuLKCxRM6MaM2bmhGACl/P8/DfQ=;
 b=GQs6Ta/Q6sTkXWTil4vP24G6idmjvnoWoZ8rZ6c2LnPl1Dk4Bt8B7LEG8TeFYJFdxnRM0oOYkX8AVOfwxRhux5g4fjtao6u78Q6CNbeVN3koKYp+QF60Pc8LXOvoA/8tt2CwMrPCeEEETFH3+8Zh55HP3LGB9ZEATP2uFWpEDNzTqXVygFxRizeaxTbup1eDJeB7hSS1HKmn6wQTUM1MuCtIPv1/ZvSHsQcm5vvb+3L3L9LiWZcqaj37tFC3N0R8eMLSIChwwCU6s1liRQDeapAO+Xf5w6v9+LcYHqiOnchoHe3lpNMZ/UcgSngutyBZoHsUzdX9Vwwu5/dH7r9jOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAhvQBMUfGw98GaLDuLKCxRM6MaM2bmhGACl/P8/DfQ=;
 b=iylgsxF73zTHdFbXiM6ZmGFUBbZ/mLE0JVMjYBoWkrDBt5KS+4Js9uFHtfeD4MSyvpHFYhJp/Jz0sP+HNEJUHew632wlTWTaU837fm+AvQ/aXfc2QLuJuLKRlYLj6FTzx7t8GV/87ToUDQKjwJgdWkAdfU/ZPtjd7EgeKt5PwTI=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:14:02 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:14:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 15/15] scsi: Remove scsi_execute_req/scsi_execute functions
Date:   Fri,  9 Dec 2022 00:13:25 -0600
Message-Id: <20221209061325.705999-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0021.namprd18.prod.outlook.com
 (2603:10b6:610:4f::31) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 105af836-a5e6-4156-9ee2-08dad9ac8f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRu4DKa/1IkKIh4CG7vP0bWmuJst+EKUaFb/5he7kqZhrdMzq6OR2Q27E4HQGMa0YDkWMH1Bk8cmlzpUiZiBHZQe4sc8OJ9lXijavIPjAPEv2CWnJzHxwFE0G52USt5DXKMqal9O20VMYFaXdfHB4cnRCuFb1um99nc45CIYf6E8ycPfnxsJMSaoioegavnNNyK3rvXGWXe/trfw7fi8tuX+r1cAMR7PUVF9822KipiN/N/paLvkdYb8zSx5TIec4x1pIjuTZYHohGYXG0M78ke1PWPvIa98aRxlK3EHnoUNtYEJj5jLhi0IdOpaArLuV5QguZXIFlsh4LzBdKN/VTifcYOJQXalhoOjl3hHWIr7q5o97AKEMJYte4KyFuXhjghc9uoV/WEaQZ4IxVm7romcgbkvb8kEfc3p9JpfJjEhuMXE8fiD4WxEGZOvFGYTz8rmq+ZPmqFrl0xRhGuQufk2jHTnjI08VcNJzZTQ9WMHdGcZxI2/KXP/sbG50bSQ0j6SCFx7dMqDt1spY4Ig14OtcMHKycq0DVKewm0acwuw11tjVODzarWC+Xt0aIGUvIpa0Bvk5e+72uPvDD1DNdGsUcUQ83a/hoEs/nZaT/3SgPqLtKchCMytUPXOgnq60gt4Lo57kp9qm2vVyB57cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KJ2uC4Meu3spneJHmVd/u7jiZiGpLpZmKRzA2i+f8E6/FfPG1FudTp9X2+hY?=
 =?us-ascii?Q?r9in0UADATbaRpEYmXBLcu0aQQQObBcyEjM71Ep5xbCfh59JbNtMT167taqj?=
 =?us-ascii?Q?DPgJtjDAGccrTZgitRqLlLuB/jWfqqnv+pUXCljdfvOkwv7dc9MBWXvNg8Xi?=
 =?us-ascii?Q?MKEACplITvWk1DNAxxxdi2+Qe5rtLGPuo8fZmNLdsfnHouAUXxIazVwi8hEx?=
 =?us-ascii?Q?GFUwsJPa0eEgl0NEWrAsrSgC8wPsUf0j9tzI6DvOpcNFEQf7uKV+2JbyDNhW?=
 =?us-ascii?Q?fOdnnhbOfBztDnFOsm1rEvAdVSEYw+jbO3wM4H2XhS/SF0WIHEtoXCAAt9eR?=
 =?us-ascii?Q?UsGLjd/LWRyLHJKfpR7U1h5xaB3ggW7BbIka80S2EqF9KD0K89EY05S+WTZ0?=
 =?us-ascii?Q?D8ZFrJ9IaaEAHbK4ZqFxuExUJAvb83PTOnJlBc53gq0OSP2mbLWerlZoPvkX?=
 =?us-ascii?Q?fmP9ENoE/PYYGlyRCXQNC5y/8haiB1dMlqJK+f2cKwNn57CLPT93Y+sD7dx5?=
 =?us-ascii?Q?W75/RodGE6BDBWM5qiYU5Er9COaVE5v9ORhBiTN/OMp8m4y1EseQDBw7n5l0?=
 =?us-ascii?Q?rff5rB/U0cWo8DX53WemC6h+O3PgJzCJEPHcziJmGupiVqieKsz2TRo6dsUO?=
 =?us-ascii?Q?NIIbd33SZ1hKYXb96hfwhOlX2v6YeJH/wC/NCf30V+n3tJAvRvLOZUFoVIPM?=
 =?us-ascii?Q?8Gf1P5oQzYFvYSf0iQ4UMWAvi/O1rxmODLhqnqILt1FiHZ7AEe9AzxLnfJl6?=
 =?us-ascii?Q?bA1mjfXdg3VUHYQh2TNpFLESEeo4HetlNez9jDDCfCaCjui8+bUZZBvN3UF3?=
 =?us-ascii?Q?ogtUI4dUplOptenoyM7L0DVEJM3v7mfZQQt5T7UrFz3smdnDpVG5eB5GJfuA?=
 =?us-ascii?Q?wPpFnL8YpgrgD189K2e1qYDapRevGLXI/tFaS4xh6lKksvyWePjpWCRn42gM?=
 =?us-ascii?Q?9CYyw7lV48qCcIgqTKJUbCZlXAuKJTWMS5h6CReRuqou0fDJjiTRN/KkP2Ad?=
 =?us-ascii?Q?C8oP4XaGG3dZ2Dvqoe/vRw4ds1nlXMwoWlrEp1muBBn3FZ2IzraUuwwGj3oy?=
 =?us-ascii?Q?HmIrZYuE0Dmh5bAKq2sdb9nc2vfAi2J3IALeETn1UJTNL9ozlwVwlPfJ4zi4?=
 =?us-ascii?Q?BBIgao3psstQNPjAdF8mL4WaDTZazExsW0dXNyiMfbZ+bwYcn50wCtk76lAk?=
 =?us-ascii?Q?IZPhOIWv+qqW87j0V98ym+kKxCYQFyO1uxhIb1F506wJlrRMShfHNdX2nLJz?=
 =?us-ascii?Q?gQ61PgiIqbGn5us095SbQfbetnsqI2rg1HEhhxibgdu47MdUC8A3GaLee+ld?=
 =?us-ascii?Q?Cp6ZtLfkPDXuc2A7BvuTr676QDgk5N8R1YkNLOfy8DVvBSNDX7rETEcN9v9G?=
 =?us-ascii?Q?pzC25NRXXPxkw0JKmi8CNTETYqD0ADPOfgZbML1fyzZpX3HhyFLd+bctrvm0?=
 =?us-ascii?Q?mnmGeSy/+l0MtT8WoO92wUBLZOkZj89wM4WZa7n0xuH5WgaiwQv9q/ZoOAzG?=
 =?us-ascii?Q?QJrea0i5T2bgPkj80E6iNFyszbG9LGvU0hcQn0tnI0+UYljzqP1+yXjB25FN?=
 =?us-ascii?Q?p63mQEmGYI7xh/IdN6SjRAx7vjGavX/SM1K6ZNzrbfTx0oQTouyAHSjqymqw?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105af836-a5e6-4156-9ee2-08dad9ac8f67
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:59.2068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6HuqrAnqt8qrBtjulaBhYT8legHoFz4qfI6m3/W+xMB04HhWY0sYcE8HCYLYg2AwQdSxc7JYXLMcA6HOl2paiCS82ETSxJHLYkbzh+de40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: rgapHJkZaF-MZyEMZRxQDV-jFxifoxVd
X-Proofpoint-ORIG-GUID: rgapHJkZaF-MZyEMZRxQDV-jFxifoxVd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute and scsi_execute_req are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/scsi_device.h | 33 ---------------------------------
 1 file changed, 33 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index eb960aa73b3b..9ed264ad3fa8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -487,39 +487,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		       retries, exec_args);				\
 })
 
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
-		       REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
-		       _buffer, _bufflen, _timeout, _retries,	\
-		       (struct scsi_exec_args) {			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.req_flags = _rq_flags & RQF_PM  ?	\
-						BLK_MQ_REQ_PM : 0,	\
-				.resid = _resid,			\
-		       });						\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_execute(sdev, cmd,
-			      data_direction == DMA_TO_DEVICE ?
-			      REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
-			      bufflen, timeout, retries,
-			      (struct scsi_exec_args) {
-					.sshdr = sshdr,
-					.resid = resid,
-			      });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

