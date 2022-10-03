Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A90C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJCRxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJCRxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:53:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D63D37182
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GODei015444;
        Mon, 3 Oct 2022 17:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=DUBdMi8eeOUQYsnXxo+XCusZ9wKDAWj6SzP4m+poGjY=;
 b=wV8/f2XGXD/xWdoZAe0U4rYn+W0wR/KvnOnyeqr3I6zczRmXK6dounXK6YPlQA86IEqG
 CjpehhqUC7qr2akJTBSzuQ0DiY80R96EdRJHd44yRy5X140ZwOWXocXMnOohKarco/8E
 e/H651/lieqOfdOFa8IRWzOn3jK98FJCrXuvcAU1u9j3QimEVldDiaUvA95D83VNiKdH
 yvZrXaanhAHYqogJGZ8dbd9FCgjNNAKPouSP/tYQXjOmSdhIhFKqo6PgF2ODXAJA/fts
 x0Wr4+mWs23rX/V/jeiun5IFBoh73KXZrszTbWnJ53A/zASwPDRfUSUtC7gC+E16JxGJ gg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xe015519;
        Mon, 3 Oct 2022 17:53:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgWQKW06Lkg/ydoKU/rzFoJ3XxuLXLNuYBWFtx/AeD5T+11N6kdE1yqQ9BzEk2pB5/xvck52DwUfOmM41pDB4FzPeXnCS4GdcSmOA+V6UIR57peFHu4ToLI0Yk7BSoBooa7evSe8bQc7KWOZ7tCROsTEqGfFVyWfKvRDFIGlMeW3TfZEKhl9T5rpv4AdF7+BY3hNg7yOXUUG9YeDBGpX4uByvWcBejX+CqsFzjAciiyTKat1GaiUCvU+KG+YsY6wmHe3raJGzQlciZxrb77sziMJVZlzrFiXrc0VDJY3khtpDXA0+GnyJhaudGF/SRY2ZbE6oN8ElVDTs9aClecITg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUBdMi8eeOUQYsnXxo+XCusZ9wKDAWj6SzP4m+poGjY=;
 b=IhqNn85Kh7vmjUQKIvYpO0KsUyzy+7GWQYKE1fd0uqXHZBcWX3prhrCJTIuJI7E9j8FR9pT392VjWtRmo+pkwui4dpJEe11WMbHRhTBJYQ0xJA2B+7TtRcmmHmTgT1Cdk0I6FWobjC0y36PNdWuar8sLfvDtOBLCKsQrg42syXkblMnoPK0zs6rnVMTUBC5RC84U/5gUEv4aitOTpfarbzPLaGR0lg93IyiOkkATC95zrnPPmfWdhHm+1SKtN1RnqSumxy4I77F2DtBUvm4yJIXXMeygl7OeG2kLwjGf3LpDGbRJe/I2bZXZPlHIbQalRYLhrAOSuNEb4DThWt26ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUBdMi8eeOUQYsnXxo+XCusZ9wKDAWj6SzP4m+poGjY=;
 b=jNIrs0ckpkyc1EpbzQPAkDXaPcvnBypmNtMKPrFJu0jtRdo01QTTfW+DYFIA0gaxF13XgDxfcX+yI7RgAAj5zMfBeIQCis9zPDK+OocX8Hek6aaxru0l1rEKW107TBAoCrdatJxNOIDcyB7IGfIrOaF8tF5v/uG75WP2bg4miak=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:30 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 04/35] scsi: Add scsi_failure field to scsi_exec_args
Date:   Mon,  3 Oct 2022 12:52:50 -0500
Message-Id: <20221003175321.8040-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0006.namprd11.prod.outlook.com
 (2603:10b6:610:54::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: f9790356-1176-4094-a8e5-08daa5682e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQh5bzT3KTESbUHUI5oLnaKivzcu0zSlDh+7+MKf6EZwZnJCXojm6Bt23LO4C1fyHsgHkcFzKNXkXj1+nl3AIIT7mMfnWZrS2ZvF8OBsi7ffbazY7Q7Pcw3Fq56Hc4RsJbKGQ0OlZglkLlTtLydlHrrmV00vNIPd8xXJir24oVM94/pCbxrmngDonlJJFGYJqfc6VsBJcYoBNf0+3el+xPwgWC2DUuhdT4CucfwMybeVsMEWjMfoHIPcOvpXzOH4yr031ZOvG/Vw9HpcTLFqLIMx3Gava8QZstwDBWHCCntEZ4BwdUwRG4s3a8QmrMlqXk49qHj030vyYuILuMa0Cnp+ewuoE8LD0+ppxJS6n4hSAXBQLqiBafOXqeqF5xAa+9/d4RErWThdP19RWQdnCPFh+7Iusxn16/GFPtw5FDMNYbQly9cn9VPCjqCNg9q+4WDxYhgHVhuSLujW5owL2ytSfzbhHNMr2oFG2cqnwsfnFGsoDwuMoTWRXXWZeSu08Z85GpGdPFJl/y65ZYuAMzGD69uIpmDq10kjgDQutCTWjGfZkf3OcIsk8ROrcqK3ii6rVuNxLMv19bZj/O5U+eToJIeodmlYu2PRAOnvTbQf5YXpnuywOQRqfeINcz4iLtKgN1RABhNuI5M+hpG3nLUop8W3gpt294B14Eihtgc0Scs4aJtR7t+O38qQJi5gGNXuV3a0dX88NJemasRjcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i9BlhoZFnS6+CSJ4F5wiUFVT7GKvR/n22/XCIubrLJQLhIaQ1uCyG9XwVWz/?=
 =?us-ascii?Q?Z0UR5KDaBUuhhnEGlwVS0EY3WyoC6aaVdgQCK2o4VRz7SZ8sJnmiHeCYIoC3?=
 =?us-ascii?Q?rkQK8X+WtDW3pDyXGx4VEUVY/TWQsJbFgyA7Uok5SWGdRapVqesuiHpTy8NU?=
 =?us-ascii?Q?uiD39p8srXFwSk+WjTqSwZaw9dvlZqekK+bUQIMDQeLv4rHb3c3BbmejClcr?=
 =?us-ascii?Q?7I8v2m7rDjCMWSWFwCyMCD2PQo+IzsX9K5Ev6n1ly1KShV3jopp1xYrjgAaf?=
 =?us-ascii?Q?LiNuplB8m5AzEEWLVDD4Klta26U2/2LDLL8oXuVrcC+CdjW0bG5JhH5jyLSN?=
 =?us-ascii?Q?BBnCm3+4daxrcAZ89BigzBy/9hOIbD59OaTN+6N5Jtzl5KHAxoLSJusOGPPR?=
 =?us-ascii?Q?11pbB1GmFDLb8+DWFJeCVsaao2m2PMbHf6Go26nDvl/OL7JWsg9RnCMNO+1/?=
 =?us-ascii?Q?NrPTuFWzZ4AJSkcSCAVBF2vCzpA4tVRe6GG7f/QFDLzua+265H9Gdkhomn4D?=
 =?us-ascii?Q?Z6qyg8gA8koI3b3fMQG+y73uMjGaESeB/Wa6z47OYQgAy6EjDG14XjcKPiQX?=
 =?us-ascii?Q?2f+mEoF49AgO3xVlJLPgk0dgg7SEXaThHYfBo1vp2ZYYrkJAItWBLInI1LeY?=
 =?us-ascii?Q?7AWJ2n9zIv2m6JJhUywZ0LJVcKvhMB8sQPFMXPyISSGiQNPopVYO88ofKqL2?=
 =?us-ascii?Q?89N2dl3eFaLCZt6Q8UG/ECbyEiPtdVCgYU+/YmSwISRUFpCdHSvYrH+B0kme?=
 =?us-ascii?Q?eWDLukbVFG71r3tBVZoKzZ46Isa/9xjDOrm9wcADGXeGzAiQiDTlGVQek25A?=
 =?us-ascii?Q?dfywNHUEdi2TczoThzcTUQbDGK9TFMlHJe33lOeyBdO+PXwNIA0TMJYzpZgh?=
 =?us-ascii?Q?he8fKL/VaFLABZAxtCdf16JzXzvvPAZjvnDUdV9lSzQAsKlGjohVLx6Q7rLA?=
 =?us-ascii?Q?g+1xDRSruICF7AhVEigwX4AW20B37VdBijYzmzkh3CAbeHGw6mc5qSYnZTgB?=
 =?us-ascii?Q?HKSju8FL464ao7ExL3Szt8PCd8oD+6oy0q9dvIMcUKcH2+QHmQV7wxd23XMC?=
 =?us-ascii?Q?3nwBch0Qscdz4XiDzV8y1dFFlwfqmBhxxpwauRh4zGCSf6ThQ6uu7Or25SjV?=
 =?us-ascii?Q?J8vrSUK9Usa0k6KlwyRxAhhMctnL58PJw2DySvEHuEGIM549qwbgHSrDAO1F?=
 =?us-ascii?Q?/3m7DddbsomUxcCkqzRKqD6V4KGn/u1NpKNOwNyCwffmrlVxnjQMVegi6AI+?=
 =?us-ascii?Q?pK8NLh5qGFf6YYNqn2sieVEP95wGC8leSdsviQ4mqaWCPnESRaZsqUaMOc8u?=
 =?us-ascii?Q?VLq8B2S/RxyR7Ddw8yY9xHV+87pNgwjBFkr6aLswmAbW/GR27tumtCNzKUe7?=
 =?us-ascii?Q?yEsubcZrqOLta4P33de2CVeRsmZhjLN59tEh5QNMdtUfQiRjhOpDz5BUCuyX?=
 =?us-ascii?Q?zx/4cKPWFcrRuXmyYw4dg2pY9jzgZNXs4ry1IA6an2Rnxvqv3plnhzvj5fIn?=
 =?us-ascii?Q?nbfAVlNG15ZGoByisrUleLD1VdZI/nTcNzgjMeU4gBZ9K4cdZ9CF9il7ZnOj?=
 =?us-ascii?Q?wL0vr00Yu4/qrms+HF1eX7+tg71roPVuQcPHfgIZIsW/J94akw8DyuCSKYEN?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9790356-1176-4094-a8e5-08daa5682e77
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:30.2059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZMVvPtS3N/76kYxExzjLrMzj+Tm5afRFM3hXVf0wkhJV7lwN5qJNi0WDG9wLrEe684iMYhE2kDLhrpt2TG0brBYoxCXjfF8U8xLRCayLMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 3Arj8DWDba_zEPnWBrLOqpL0DK_8Hnbc
X-Proofpoint-ORIG-GUID: 3Arj8DWDba_zEPnWBrLOqpL0DK_8Hnbc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow SCSI execution callers to pass in a list of failures they want
retried.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c    | 1 +
 include/scsi/scsi_device.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c0b4ef0a2074..685f2245d222 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -215,6 +215,7 @@ int __scsi_exec_req(const struct scsi_exec_args *args)
 	scmd->cmd_len = COMMAND_SIZE(args->cmd[0]);
 	memcpy(scmd->cmnd, args->cmd, scmd->cmd_len);
 	scmd->allowed = args->retries;
+	scmd->failures = args->failures;
 	req->timeout = args->timeout;
 	req->cmd_flags |= args->op_flags;
 	req->rq_flags |= args->req_flags | RQF_QUIET;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9975d04acd86..6d91c14527aa 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,7 @@ struct bsg_device;
 struct device;
 struct request_queue;
 struct scsi_cmnd;
+struct scsi_failure;
 struct scsi_lun;
 struct scsi_sense_hdr;
 
@@ -469,6 +470,7 @@ struct scsi_exec_args {
 	blk_opf_t op_flags;		/* flags for ->cmd_flags */
 	req_flags_t req_flags;		/* flags for ->rq_flags */
 	int *resid;			/* optional residual length */
+	struct scsi_failure *failures;	/* optional failures to retry */
 };
 
 extern int __scsi_exec_req(const struct scsi_exec_args *args);
-- 
2.25.1

