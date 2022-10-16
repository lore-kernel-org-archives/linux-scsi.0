Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A99CC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJPUIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJPUIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:08:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CBC32DBD
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:08:18 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJlr2E004935;
        Sun, 16 Oct 2022 20:08:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5YKQhcrOjULZ+YqVj101gi0gVn3r2YkP4ZGxV+G4wi8=;
 b=JND29eGf9IxAGDTvlf4hBDaRukBBX22Pf6V0wvwADc4UxL6geCIS1/F2FZG5LSlC2WQi
 Dwn0+zri3ru5+M4uY+NYzCMhorAxg7MAikOXPWSlsKzva1JyWmo6PPoaKl/cYCaFaZNp
 JuPV3d8icd2GEUDp79SkF1FAP0xPs5OVqP5rhBvGRqIjU1vQAtsRjlubJG8WRf7MGb4b
 I9Tr1ZjhwMgk41UJd9mbOg0cHs8yttndWQbG1wjjhMuab6m5IJXYGR/wG3Ma1Q/7UFcg
 P2K1avaukGjZYCLCe2xn9jr408hV2HoPuRiKVO7sWQYkaEFR2d+xeh6j6zJEPcyRP7xd PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:08:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCBuf6029646;
        Sun, 16 Oct 2022 20:00:20 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hr84jjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7z7I/iOiA1lDmdsiwngKP3XAOnF2P7JNfIiRDbebo3+t3qxUc3/eRDorguHtR1/GTOp6YxhjofrSeyID1Q/IXGi+6o20kyJh0CyH1lKGGTg8fklvHlstjATCbduPkUqVZAcS6NqrnxohMtA843OJ1QFsGLMsngg2tZM9NRQe+n7B5DGfiFczHnBjYay9euDSk7qgYgI52eWtJ2Tg+dI6tIEBLW8/MlpzlIjEBsbv0H43GQZlNqnw+DpTEaWW8hvMGjzVIVG/5FrtDTGav0w3xcJ7SPC5xVmENPJ3eovNbOkLQ0sqVTm4iyKvl9ZDKu3FKORFyheZVtryIS6fG2RAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YKQhcrOjULZ+YqVj101gi0gVn3r2YkP4ZGxV+G4wi8=;
 b=UxwsyA9Ss6HWe/qrasQ4pfdSnhEn6/AlCb3esTebAytJ9Fe9YX66iM7byWL5CNcGqe54fBUwQORP/EL043uaLJzdhk63bvhOR6cG1y5HxdDPbkaxkpjSVw++/lu5Hm7Mwgvovn5wemBuLNxZtaeerFRXG4nMcDaMj8RZCIC/syuwI/LEBP3gHbpNh3AzWZkq28+AGUoIohcCOvey/ev164O0j2qVuiieQgyWNgGcU8Qfs/5CdJpi+VYTnOUFSYy850ZD69881dbE56le86twraeXGA4tfKzOtikV3TLdkgGTwSAvfOG6GkANwx1ugICdh0/W6BK/Q+rnV0c9p73uTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YKQhcrOjULZ+YqVj101gi0gVn3r2YkP4ZGxV+G4wi8=;
 b=v6F5Y3bp/D0VeB7oABjX1JfWRElitBpZnVdV5KrTOZikQXacBsFkFEcVzfj2yqDeYHYFNwX3r93g3PE7QBGsCGTkoM+ZGHvL8yuzgv+mcE/YyrIQ/E0n0qpniAzn1cJfLmbP84YkbWLxwyH3X1PC1KvQyvC/W1mK6sZy/JC7vWA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:19 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:19 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 19/36] scsi: Remove scsi_execute functions
Date:   Sun, 16 Oct 2022 14:59:29 -0500
Message-Id: <20221016195946.7613-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0050.namprd07.prod.outlook.com
 (2603:10b6:610:5b::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0c0402-8b74-44a5-edbc-08daafb10d0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SBfmrGQnEpgBAwqQ3i84y7d8Vb+KM54ts/sKtOgaNnPG9KD+0wRFQojyOb1oBqRtjAvxb9faucfaD3o29/m2BN75Kwd+38CwLj60QX0e95Brk5nVnfcYGJKTlQ1ZgyqlWiVF2FTIsPPkAEa7o82IJEv9i3lxGqnTp4vSDWWsNxsuwdm2MvFFPP+Lsnc/mozHZCVq50+KT4kTNqsSQS4I1XJo4Rc7YQbkAW2uXeiYZ/dJdgP6ARCODjqID98dIJmUBLEsbaYSO0tPZi+qm8r6nsbhHbkpHNVH/q+2VbJ+3mUrZa8spB/n0DP1hpyjZVWWMX8gQCbQCP3HWZZOq2d4eDtmw1SYXxuR8KLv0sjppu3Z9aWsQb7M+1GU5Kh2Rqa/lw9k6f+ShBkdy55Gnalq3VE/9ARXueAa/OH7BSVtK8Ud0GLTMGuYNt/QFUlKWqtiSGuJYUYbcjEvcEaQPdsYFZ1kkI94t1K6hdp9Zv5PhI2awdS499AVpBWsOAZxV0J6PUsq111lkfG79OVnCoguinagr2IA9JU15/Q/ZQW+AKhbKcmysowOzwCXqWRbGE9IdC8iBZLaRCcJe/iwEPAEC8vMF2YNu8LmkgmzqgTYD0jwKnFoAfoO9u16/ygcTZfe0pzD/+QHzxJz8Qw4WRycNfrhlf/Qwkbcdn6QJlKtu5abJO0qthYCktRsCfureqgdp9S/j8+V2sOEUYe5tThbbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Eg7wnwoS7UaFLVLNUP7tdPTutHzW0pFRlXbpMcc3fIvyv2z9BD8DunSfmaWu?=
 =?us-ascii?Q?TxLU4dYmJzReT65LfZHdsw05gt6RMMnfzj7Cqi5bCNkiuIhRhMdaC7gNPxeJ?=
 =?us-ascii?Q?2cdsnXcLAU78NmLqFHIhRUzdKJsFs52UaKmt/Hi1a8lj5ss+cxOEsaqC2EsK?=
 =?us-ascii?Q?OXzPy3DK6UafdGYHfJWCbL6iulcWQ2YqaHFphBdkaDIo4JJ4ENryTJRrG5R/?=
 =?us-ascii?Q?vU0fhygmZDxLfDGuNpTwwcjtNQxMmwXenf+R20VRQa7zlf1nY+jaQn0l45cc?=
 =?us-ascii?Q?FyjZXtAgz5U8360NxstfgTq/YpOCDrIg/tAZUS/eXe9i9pWtlUS6VpjKVUBx?=
 =?us-ascii?Q?umvZw8Fz/dJS2EFOfyCncPdH6UBSjX4fIUXH6yQCFBzq83uU8UYQy2aAckik?=
 =?us-ascii?Q?Cy3nbay137CsKhKkLHASwSTQPpQah98hDlWNW//TZrpyBOU+DDMsnzpg/HAv?=
 =?us-ascii?Q?UVYyOFiiL18gPW39RIDUUbppWB8/VpAsfzPeFnqjbC7yv0QZXTARaRsjbBdh?=
 =?us-ascii?Q?9VASpw3y8fxINv41kbiXb+9tPXjvq7P5M8xikOjAYf+tr3SOq+jJuy0DdQYs?=
 =?us-ascii?Q?6+jf9QbQb+bKQNtFBzxGSu9FCK1Xx0CxdXwLzZ32idM491XqfaYg23Y6Cnl9?=
 =?us-ascii?Q?njoe6/kxwLHz7zLxKkfny5Vc7SmybtDzmBcMEvRJ9X/RIgLjdgEm8nCj5fnb?=
 =?us-ascii?Q?0sFlMh3hhUOlHQehJBTdL5HsiZIBw5sMVholQnz1JKjcMUnQG97upQ7Z03qy?=
 =?us-ascii?Q?4Ae8haXNoKzneAH6FRYgTe+BihmWTjVNFXZ+0MMiPxRWoVar0T11vgpVGk+5?=
 =?us-ascii?Q?rqzeZdU3SLXIZRBNUXEnMpZzQUCRfMphQ4Bh4o8Q6M8of7PawwLs0GhejuRU?=
 =?us-ascii?Q?8oE0UlvpIUV/FflCVbGj336k/jI0+EuFO3MOBDVZn3N1G4j89mZMkY4MCtNG?=
 =?us-ascii?Q?QIydO0L/RLCpxiUjwiU3VkQv5NTpivcm2gZkoimsbl/rUp57Va3grUiZkuI0?=
 =?us-ascii?Q?QuAX3+YqQlw+caTlDqpkseOibnluLsPBM97/pAG4yo2S6reFAvPACZLSvSXy?=
 =?us-ascii?Q?HETEAtTi4Weam0DxUiSK1fj2HWPn1IoZEZWufyvB1CGnXYNx0gID5BOegCac?=
 =?us-ascii?Q?hp9m1IIAhoUnoRx4agE/bZgXvN9tklp34I2bovexrjtoETASolidREaOnVKq?=
 =?us-ascii?Q?lsWfRcnKfIA0hPR1nS3osipak0gq9GC0epjZxdJ3XA3I+9EjYQMaSNn24+ef?=
 =?us-ascii?Q?99Q4IKqKukqkju4nbUwxFntIXyaMiHRL7aWCDKP0XWgQzdnSGe5x72HUJZ2w?=
 =?us-ascii?Q?tMe3RZTjtCaT1hDWW8AdV66s9lvkiDuzmRdDRTRbaNukpsLYz+DUI2QwVLHc?=
 =?us-ascii?Q?fL90Zp9GvVHB3WHkouseDTCfQRWdbSKLbNK4rOj0DGj6yy7bPybSfCCu+Usj?=
 =?us-ascii?Q?icIoQkMCb7Y4+HiNrHQ4K+KTffbmDEwjMB8uKDlFhK7gWME+QV82t5bEC9FI?=
 =?us-ascii?Q?D8dYm/LY0rad2NPgxBgcNK+ocrVtLwPfD7oBcTyx9FBpq64Nxlu9Sugsq9p6?=
 =?us-ascii?Q?OoXofkLi3TSLQKHTAARS2AZ6JVhdgzOpQxvIbVXUTtWRaNEpk37sbh4WBjIm?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0c0402-8b74-44a5-edbc-08daafb10d0a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:19.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUNq26sGskI440bv/DXhDSKWJ9MmhX7e/7U6eTR6+Hx6bNXi2ZbkBT+69GDZa0VNrNsyZw4mIHs4LozO7ctvpGJO/LqiVhrL/xXcquRI6Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: 2luf8YEq-9IyaWTDTU7eVBy0sivwNcq9
X-Proofpoint-GUID: 2luf8YEq-9IyaWTDTU7eVBy0sivwNcq9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_execute* functions are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_device.h | 39 --------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 72d1690f4ff1..c2dbb8824ef8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -482,45 +482,6 @@ extern int __scsi_exec_req(const struct scsi_exec_args *args);
 		     args.sense_len != SCSI_SENSE_BUFFERSIZE);		\
 	__scsi_exec_req(&args);					\
 })
-
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_exec_req(&((struct scsi_exec_args) {			\
-				.sdev = _sdev,				\
-				.cmd = _cmd,				\
-				.data_dir = _data_dir,			\
-				.buf = _buffer,				\
-				.buf_len = _bufflen,			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.timeout = _timeout,			\
-				.retries = _retries,			\
-				.op_flags = _flags,			\
-				.req_flags = _rq_flags,			\
-				.resid = _resid, }));			\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_exec_req(&(struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cmd,
-					.data_dir = data_direction,
-					.buf = buffer,
-					.buf_len = bufflen,
-					.sshdr = sshdr,
-					.timeout = timeout,
-					.retries = retries,
-					.resid = resid });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

