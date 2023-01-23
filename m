Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2032FC25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjAWWMJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjAWWLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3071F17CF1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:33 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhqW5010181;
        Mon, 23 Jan 2023 22:11:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mBmjy9c/rx0fsXHDgd69dvVQgVOXKgQ9iudln9nEvyU=;
 b=R/vGWnFr9kTAeRXosdNv0oplchg91+TVoZ+X5JwxZe3oFy/MR2iRasfUU4L5ZwKQw5b7
 Cz3C0N7dMsku3ACCSzNa6XtDeSdkazr3bhz0zPe4PtBoRKzZRdVjPTJKrrMf2CpsEJ0h
 hLlEWX7I3eJQ6K69ANNmmBvJ7T3MEFmsdaArMXXcQn0wxTqbg/pw+Fpn6V7MQXrblkLA
 h6fR2fUsz+Oc+5ESlttuAc/tTV8IRB/7+dYR39ihGDghA5YD5kAdHwCe1CHrzwMqrGlB
 z2YsyOW/DM0L083bi1N4hj0oSc4kNEMSUkwbA+5+klsxB9xjKsPUmsEB3FxSSCZ9ufGC 2w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u2v27n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLN9bl040098;
        Mon, 23 Jan 2023 22:11:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g450xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSetS9HWn9lTTnG/TBtzc2F7u8OkWx9+4Pf4Uz2r5Ri1bZ0WMseYn/WqxVP0c4xAS6o7b4AJ8zxGFe45EEruwo7BHFRJB2SilPGjr2tBTaFX63FGmFXi3aDj2McXceoLCxVd5GT03OB+/ZwaWJOTMnW8KvT3XhK4sH6L0XV0lnfImU23+xWKHF8jK8/GlSRi7Q9WJYCjCmXcTrRn2tprAhXhRowWNkzZSRWq9horGt8MY0Gu83hQsuUO34cbvERCUp4dZLbSr7bHPZfSfmo+uQInAd0esfYL2TMvrYEtYH/7FGoPU/45/niSiVZy1MqEh2vDJmd6mq5QWjeG0H9ODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mBmjy9c/rx0fsXHDgd69dvVQgVOXKgQ9iudln9nEvyU=;
 b=Wvy3xukqgBE3i95TBGWQZK7C7Wf04LhelWZdOQ3+kgfBjdif0OkmGP5U58Z1lMoOF8+MkZVNHpc8VnwHKf2X1u79rMIsESZXrG3GRKH22eJxiACrlgSDsweciUfANawBTh27wbx7KoAss8uxVamMqFYAqP47PJy4RtZy7O1QnBqnlcaSGdP93CoCyujzrwP/pVi60tJs0rRfm2wgfcj0cgDe9oIKS8U7wCiGQ8QU7kLcT88RQDb/sw/k9jrj56+G6YmRuKdztYGhnEpwabLwMKCkVBIehg8BExC27ZhKzmoyzw2Kl2yv29JdVyZQYDY6jKGHg8g4EXJe7FnSFh+Spg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mBmjy9c/rx0fsXHDgd69dvVQgVOXKgQ9iudln9nEvyU=;
 b=KwBW5voM3mYIQeoxzpp05W5t9o20SZ79nl59AR4vGMC9LSgELG0++TtEuAmsbsS8PTPF2DxT8ze6w3KYRXgUzBdCTcxK4L8nv53O9vpaLDGylagtiOCWLAtFbytaBF7XziuVmc1+uD52j2ZD/jX8rag/9IFuPENNtOXr4+6EO9s=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 06/22] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Mon, 23 Jan 2023 16:10:30 -0600
Message-Id: <20230123221046.125483-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:610:54::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: cb439849-37bb-4348-8031-08dafd8eb511
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4m8+q51ej4ijjOHX7eJjPUSjjBUnQJLMuN+95ko4hM06tT/6YrUrwpnrVX/33xuV8IsPQNdps/hQ65kRyhsOWjt3DpRddJW0u8S6KNaq5QQTzBH1tSBItI3Hn6V0hbGSsP3F9Sq+4Rw1OgDyPwuCh00q6J47SY2smyOrbXU4R5OXw11RnLUKDufjtBKYVckPQDehD5uPBXqhvl9K/9PWFLvdL5IUL0Y6khye/5o2oedvECJRzF20ikPlFFVS2Mtqzh+vRKWZfgTqJDCq8Tw2dhOycmHn3yksEoMFTxOG7RmGHjVsjx2xDVlr6Io3tju2TGGBDxumvvx65bH14UY1qeFqBAG3BR/da0cSm4sAo6Hpgh2yTRz96p9uNxK8gylRjBdzI5LdBOXqeNcSdC22f2Zj4tEc3l1Y2MlKMlYn+1QPXVnTGRpVvOlxrOtNIfIT9qObXcFOSuiuSZuLZ0LXCoyAjanbn9/afDB8t3YBZbZvV8OUD9YMrg6oP1UmK70sGaw0uUV1do6oL2Cw0AtqIprFEVnYsBcwtEQb59i02IuKVv0+1lh7jhz9b7eT0LmKwt5+km5TyrNoFzyIZN3cc82taEUNaRN1CTMuQMrG08hnPeoJkMwBy680bimz97l0Q6j2gtY/Ag9Zlb9osW6gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T2bWEUybWYiPAn/KGBkFa51SZ/+gDZWrx0A5wBPUJKt50XnrcOrFcexB9ETr?=
 =?us-ascii?Q?k4VfDvtznq+w39OYe4MCQYF4229bAzSqlB1AzpyPU2eC90bGwNf25LVg6bgC?=
 =?us-ascii?Q?rGAQiiddi9ErPXjpwIEy4510VbJ3aFdADHQo874nd+1PuG+pd4fTR8XqDTJO?=
 =?us-ascii?Q?ljOQpK3OusG5k/x1O3l+jnY5IFSEZiq/sBthJ1RMtuZLDpfh1W0sROIlOAZn?=
 =?us-ascii?Q?rWvU6u3d/kLgjhOcB0piwnXQBJxKpzHvOJ3iGkMVHoQD1twzsKDN9SYahWyE?=
 =?us-ascii?Q?YXGxsSZ1O7m8DtoI7J0zujRF3lchqDY2t79rLkTgV1JRGldMmd1H+vyyL65G?=
 =?us-ascii?Q?6EvOs/jHUTm7AJRsTHYtSYt3lZQu3dgpjX8VCsUKYzra0spStJ/FxJneD7OK?=
 =?us-ascii?Q?3IKuAHT47veBu44yHnYMos9ojtBZI0u+voKFsyQC2nHjWj98tCexKpwQkTr/?=
 =?us-ascii?Q?7f+0pNGH9dECZCHbNCSzjTkTnBebpKCnY6jkkAuerXlGeZa/jzLaXeaxvqgv?=
 =?us-ascii?Q?ipAY7at7wdEKDCtyOMww9tz4nZ6RIWHUXW+YxwURifJ/MkxfhmbbZu038qha?=
 =?us-ascii?Q?es0vJOw1aXSkq9LHxH8ytv0zj0hpPqaUcRomSGe7b/xOqtuXd0xYBM1BLpf2?=
 =?us-ascii?Q?3KnSFEDCq1s2NYHcwxA4VfzPxh6d4XYbau0taIme/nO9+QrYVIPPcF9U9AQ2?=
 =?us-ascii?Q?WFk6xfdA8taGLCrIbzBY7eKdEwe7x/ozceHSng6grNR1yaWMxw9wEcRZj0FN?=
 =?us-ascii?Q?A8MvDB1KOROs8nBHwP/tkzRHGAQ//WLUTY4z/rfLLqPgwk9PHQgJ4ktCu3/W?=
 =?us-ascii?Q?ReSs3x565msobDW9mU98uCg0djbYxLOO4kKv4YRLVDz2VJ+vzFc2OTe8N6Xj?=
 =?us-ascii?Q?sNGiN416bGV7Qo2VHMnCyVMfC9zOTOxsKSygUE30V8j+NGUwYgYaqJXViUwh?=
 =?us-ascii?Q?tGq5TrtDNj6Zed3X6ckRwtIe0SoKm8XPthd5esMGpZpmBbluNCpyh5ns6jbm?=
 =?us-ascii?Q?rEz6c8SlFfQhljSc4XGejubWqg0ML8QZ9GMKKydVC2JBiLPWciu15gimOw8w?=
 =?us-ascii?Q?qbOL6pgf1ZaAT7j4lZzNb48C45J/5DZHnWPItTygN9o78yPnXbrhuSv+xhOH?=
 =?us-ascii?Q?Q3k86zvz5DS3ZMLrj9BSkd56xjGXmco2Uh6tbmQ8NV8LHcjCZh6raTqR/RQJ?=
 =?us-ascii?Q?532C/v37+XIPvQ9MJDd78ltm8ayVL0PVUkSlfKqtlSC7RuJUJCxaXlsAaB4E?=
 =?us-ascii?Q?oRY2vhggAzseuqW95LePrskwmzlesbvvdN89pnKeqRtCmZePDxa0WMh2qhMh?=
 =?us-ascii?Q?ZNeliKtRUOiu8PooATv95qCtfUKF1qNqlunixDYcIh3Ng0XvY3ecn6FlgS4I?=
 =?us-ascii?Q?xikVcHFraHseS9Ww7lkyodxTLMHhKzwnaDGGtfoRJxW2uXX0HY5V9ZOAkf4x?=
 =?us-ascii?Q?bC6ZUK5NbMEw8mZKdAl0h3FcTNBjc+I+8ttUxYuNm8O7XzOa5QxBWJI8ZXFP?=
 =?us-ascii?Q?P0nVCDiMJzUEJSzs4utqXOFLKlStDjvTmh6bHD4Wdk3M+87AJR56WvYo6Rnc?=
 =?us-ascii?Q?cTfD+kYNRFOU/D3OvO2y/Y1u8kGwgtErELX6u9JPnEZSCNGrhVgMtzjKaT36?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6qVP5eSS7rFFnThwt9TJ9myNTrPcxr85mrkIv8pg1s1N/uiaTJ8WiQ7K7IsiDnvQ3a0c8ofnrGAVLap4kHvpRef6qWQWgsWuBhdKk3q1STdSgol27DoGNsbehOpUldg1J8C5wb7laSSZ2P+ACnj0wQfJOTOqYTZ1cP8YS2PNMvyJ8a0m6FvA0/BpDSaGfj+xNYmMI96Em5fKYnqIPj+81V8eh2OKRxqzMBrSc1UdznK1dsNJuZ3TQ5w8F/N3ok/o0RG2nXrJQYOgOXRa25ThkDchUEO5aC7dcsxwyAaBiZ7r+0Ilt8MYYldVGmyMTaCqoWxrUv7xxXFFYq1X144AdA1PQOtJ30Tmun6Fp/oGSIejCM+F7J8YpvyGLqxyGqlbgQz8dacFm/oLvJvy5WN2dQrVgp/GdKZyizLEQ5KDnJ79D+vs2hCU8EZfFq1jOnPFzxU+1I943/UUF2/JmPbal9kUoLqt988d0sISxX0LylPXLB3cFkm5ZxwRpaiKLemJ+dJuQqyDtDBiiIvH2g7HDHglzWbpYnCUNwhPgFVHHyqH+6eQrFCRypX1AjC4Cd7TE0wdW4yCDo6RCmrYOnFU3PtOCHHjzx0Hyz7Xrnz6+GoKvb4TVU0LxTd4YEW70Wwuq1C/WfFoGFQCcrDDcAoElFkIxtM6P8++NshhuMt9Wj8ukszur61Y1oZB0OyGw/TTGwJad535FJLiNKY5G1Kvb5NAU1QjMuW1dCy44l/3cAebhvgVageAt5G+6kgzCvn5ymzM9/JfN9Vz+qe3Ser6UwYNV95P0yGoMTgkGY3Ufqiyh/pdl74+qCbYJzeL5k04BHKzo4RoD6sMpj0vsLIRe5dG0nrY2Rg5JVHNseHdqELDmA7kFZCLcvGUliDbE8+W
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb439849-37bb-4348-8031-08dafd8eb511
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:59.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWlBHMhd8aI+iJs88mdm2fuPOcJo2Ht1irw8W/H6HEI1gmcLXCOZFFYd/6bz3q5MMp1xDKHbmUuTZLMLbLoDSIqWVnueVOOGxAU5gJUjvh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: bYOoJnqSQBMVl6Q4YNhRAmocPtaW9_GK
X-Proofpoint-ORIG-GUID: bYOoJnqSQBMVl6Q4YNhRAmocPtaW9_GK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with ths patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the loop's retries. Each UA now gets READ_CAPACITY_RETRIES_ON_RESET
reties, and the other errors (not including medium not present) get up
to 3 retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 105 ++++++++++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2aa3b0393b96..99fb4d72e0f7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2308,56 +2308,87 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
-	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
+	memset(buffer, 0, RC16_LEN);
 
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

