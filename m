Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C92FEC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjKNBk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjKNBk1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:40:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573221B2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:40:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsssK031062;
        Tue, 14 Nov 2023 01:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=H6UVph4AiV2Ade8PEo3oT4SMD+C3x1fFAwvQCLnnC1M=;
 b=f3afGoqDo4u0HzC9IWmHRDbp2mtseFdb34UevOcyWlYyfQlxGqERO8mHK0NSvhT+z+iW
 esPtWM+WkngSCROTj48eYjOsEdwMe2KpQpZYmIJ118rhwksnH0K+zUsLweTjiNBewSs9
 fyW0Xupc2dNxV2UhWWxFd7W2C10eG3mdrPyw7jf/fS91GyqO/3VsMeVb9dObOt5+8woU
 K5cHqtJXD6KJm4isdu+Jx3X4UkZ3sKvXfDLUwdzCaDLp8Yc575S+fegHABMiGvYkDefC
 otHKe9B1kNlMK4cL9TYbdgdqF79u1cUi9STCRbCtuE/QB53SKJafeMZA1YYkYrttcQTJ jA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2stm4n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE0WPrr014858;
        Tue, 14 Nov 2023 01:38:14 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxpv9d96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:38:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3J9VkPMz6/RJ7bH92ISIn809Ak2pN6cy1w8r7qzYAO/Bh3t9KYCW7eDIN/GhZM1AsY6u5a0XUk0icjTOoRWY/ASVH8T7wY2HUr2Ed+uTOKJRnuXPoc8tRQ3s4VIrvG3bPsHOB3KT7H9DPu66MVAWv1TRYLXaLvRQZjnnGhTR0G/sY27ONoe7pJOIK1KeqA6ZIZikUfu1i9fQ470lOZ+UNszNqw/UlU5t1bs8RTOHCZJK3ON8ShEqs+8eszHDkH/i06teFj3Tzae0xkS9YGA/WgMdFbvpG3QhBZKwSZl77Ojik89NB9TpL2Rt43SHIZo0Xz4QeqBVlfJX+5jDa6FgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6UVph4AiV2Ade8PEo3oT4SMD+C3x1fFAwvQCLnnC1M=;
 b=kPRakTR53MB5UNwNA8EgSpnpkEzvCizD+0eFBIa59K/CxwrlhW79UomDyCccgGmSM9gZsLVol2lPYD20ZSPOttTwUQUtLkh2HlftwVBDwzRIiGPBPJXpM72dqxxu/SPUxcGYU0/fucdoGGesD6sFwUOUGhrYUby1PfF9jRpYyz9IrrFVtDSO7WlItKKc4fAi+dRH4mvsGabMXQnBv32FQ3nDo+2dG3XG1eje9/qlXGaPzKmuHdJv8qI3DW/QrzhDCyKGkD98oDemGjjr7M9sQEtki+gixbI1Y6PN8EL+JBCH9/FlnQncVaCJqVwuQpH/VP23wtyNQ/2quMZVoxg73g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6UVph4AiV2Ade8PEo3oT4SMD+C3x1fFAwvQCLnnC1M=;
 b=oUqRvLJb+YOrzRjyqEx9Z9qMbM0+niqQ5mSrjcW9xbDsFTrE/AvmR3OSYid/nAXI/9OUZmtDLMH7ZcIlAcZ4F/RMYZDpMDc9w9qYsoZXLQHS5PFOOs4eg1MC0NeaCQCbvO0YjbtNI7O4mm+y9VRVfbFpirj5yos1VFuCahaXI1o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4199.namprd10.prod.outlook.com (2603:10b6:610:7f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:38:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:38:12 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v12 15/20] scsi: sd: Have pr commands retry UAs
Date:   Mon, 13 Nov 2023 19:37:45 -0600
Message-Id: <20231114013750.76609-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114013750.76609-1-michael.christie@oracle.com>
References: <20231114013750.76609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: ff64f14a-6211-4ace-198d-08dbe4b25d14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXEtX1og2VLkW/t4PZtxlbpL0PRpLFx6ZtulqTdhOULsQ/JRTsJsAc+L7a6l4SdEmt7CL5EceB9Sj+UHGv9tqrFBW8wHfixRAlyXHHZpfkZXdWPAMnUotgRePGTNwUQpjebkxwIg2qWpyNclcfRwHhckDIYnSatgZAU8Z6/rHRmkev35WXgSJtwer+ktHS71OYlt1b533AICIW7NGT6zAFCULzJdlKVnsbsxXXldrYj5eagEajbini3o/vv8nodiOYlymVIA+fXZtcUIieOpr5/rm2X7rYHAJjRlVbk9X+b6n43jMMWBhPlE6mIYT6e7FF2GlSuXdOl3QKPATkrjayzu5QvBj0IG17hKsscg6HzzY2TA2pXSPaTcR949l3Z7AEQccCAU6h7q/nCI/Pf6CuubxyPXtZZOK5wh9G/XOCZY4H39Xw/oKVfDaWGGWD80v4uEQ3g0FBpv8LUkBglKb3bqhiWNqoZhyW3hHsgSQNQ02g/8VgIFUupuJZwi5aHMU/QROX3DwKOFntV/Pw3P/YnXjLRhyVRn4YInzJz/5xO/4EC5B6ReR1rfj9ahRvjt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(83380400001)(107886003)(1076003)(2616005)(26005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6666004)(8676002)(8936002)(4326008)(6486002)(478600001)(6506007)(66476007)(66946007)(66556008)(316002)(5660300002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aRZrJSH84Bmh9idbayHF9lfdSszux06iZHYVcxAofHH4n0CuC9FB3MPBqcj9?=
 =?us-ascii?Q?UFEwWOVpObLy0nlGGKrkUdNGm47iT9pKWF8rwbxHDbWGJUkVBB0Kl+Iec3Te?=
 =?us-ascii?Q?+wpcwjAqSxnX3o86wEclqtiuGmISzDrm7TpfsJsAnogrE0rRLVj3NBLkpclk?=
 =?us-ascii?Q?kf1DuD726lUXYXr5IVAcSyezJz/CEl5Ta0s5elpafnPpY+QI53Pg4Mqw2aEZ?=
 =?us-ascii?Q?6X+0f3edczCRraxFGkOZM9D80HyyHutqbJhiIB2shbsRwJv3aybY9jheadjR?=
 =?us-ascii?Q?lMFYI3ndl6+GGHyE/iQnWxvnttdOcsbtolHFU4pFGIeAZTcIFpEOGem+RM1l?=
 =?us-ascii?Q?AaRBdA73swxF5yJFV1sW9D3oJpgZUkUkuSjUdZhsVoG02NzQyaOS5UHHnwMl?=
 =?us-ascii?Q?/kEwA0trKTvYqO0m5yCB+kyQ/E9vzjpZPuXGsAZymbBDwJLzqsuOghlSw0wD?=
 =?us-ascii?Q?vb5xiuBDHBzQcGVGf35qOCWgU8dkiWD9cwy1Pc6a7NNhq8EK3MbM55TOzj5T?=
 =?us-ascii?Q?LaGsikZ3nd2O7fu+cLS/3xeni1JsDzuScUuufCm11vKKUx3qEUJ/B7gA2XhW?=
 =?us-ascii?Q?k25knynxDRxSZ8nw/ECViKnnc2dXT0U1VdMCwGmkwzT+q/YevAYGZurz+Gyk?=
 =?us-ascii?Q?X0JhjYsoGdhFtSfP8+k3t0aknsAUxbQJ+c/VMLso4v3Qxl2yE7fA5r368QaI?=
 =?us-ascii?Q?j36Xn/XcRvNwY+UXFlYA0b9fuC/Fno/8s3FSulNqZU8eyxy0Td2qMsmtlRdq?=
 =?us-ascii?Q?t3wyFB6rXRozmI6awkQfVmdEPw7xH/wZ0XFlCV6zVwiHPx5PWFufffrBbtZu?=
 =?us-ascii?Q?M4TU+SCOlPOjnlBFewTRjps7y9WURdCw4cm9wfKytYtXz4CDSqZ44NfUU33I?=
 =?us-ascii?Q?Av0UnlqhT62cGpJS0MkjQSzigr+HFQd52PvnaynoIB1ANWjJwUg0Eg68wp11?=
 =?us-ascii?Q?uEV+xnDWJcYsZ5tTbaTTRDHEvXLrlWN3AFVVo2MDhFERYqKFU0CpHB7hOyD1?=
 =?us-ascii?Q?kUnZ2vFrk1CBmpEZBcOWETJxJE8juqHpsGfZuaahqlE131BmbegfnMSe4KrI?=
 =?us-ascii?Q?a43VHZtw3PZH6I35BsrexRcHDk0jdP/iLN7xT8sRGbuEXzXyfWEvJ6G8z/Ri?=
 =?us-ascii?Q?3hdZYXPjxFqtaLvCCJlQ5rwnNXtPyyJWWpxAP1qVSm0loOwQmyuHKuho2xSM?=
 =?us-ascii?Q?Ct++QzvD9bUzHqjYAOAV9vdI7nHYAvbjEVtmlIz1v3HBjhh1Jlx/HJgHuzQ6?=
 =?us-ascii?Q?JygcWBkIBfYYASCeqE+VaDI593Dasr3Btz4jsA0zRmkE3YoAplZwOOtYlz5o?=
 =?us-ascii?Q?6Z7BdkJnB9yCe/lgX0RaXUm2DUcCrt0rfM1jeWdyLgRN0BUQwtwuMhqEwgIn?=
 =?us-ascii?Q?rmyvdro/bQrVV+QvzMV0CTH5Y3blOwe5efNgWhem0wtDEQ4271oGoTevv2Et?=
 =?us-ascii?Q?3BKGmL5KabCs7GVLTTVTpVOZ5qoTx7aklODZO6N2509y64C0Uln4ivW4Us1d?=
 =?us-ascii?Q?O25DYoTBLUKws6pb2rwVolyz20DxJGYG8SL93WHImgJJ+40h4NAd4P7LPmOS?=
 =?us-ascii?Q?210z5Hqvg+rNBrfa8vMup/sWYhvdgBdqGyNxasO5DJ5zs7mO0C9ZuQVVQiX0?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WrgXJ3ifAzIozIHsIFcEZ96JWvLlRXNCw2i31UmHZUir36uEQnUzFZz4/QisldDBxa+mJY8UjQWvfdE7VPY8srGNb7Sa1FfYG6gIRHGopzl1MIRJiDqyN1TqehaHFq9EW2q0lxVgRtCnXemKAmZGVIpZfJgImFEAzEDIJ6Z5vEUG7y+DbtYw4TLFirHuQtNIT/8keVEpSvmFjruS1XTenM5xXBV4xvUQ0U97baPakcHiqkF0uS/jm43RjSJi8DQiTedxNxcf/WR4QljHg5urB8x+2BquBtu3A0rquFOEEMtjHoIiz6i959T/rkbdpbOBqKnv6pG7oruERAePi/1keRikhDbZKBS3rHdp0VdXZk0xdFV1QvNSBiK6VMiyhv+4eRP489Lj3oTjpDS4a42+dTq+u0MORLFagiInnmfAAv2y6+l2LnpveWGOn90Jd+ucOXA9bzKIA+TaYxVJvKXDXu8fsgKcRztwbNx1g1yYuNH8eF0nxQOSRexad/zW0AbFMvHK1wxdPa5iDfmFXWoSMeU99EQI+sedAS1RncwICbt49Ib/1bjT3SVc8rbmB1TMFKtUy/tUhxoeSoVWbd3OHxZUQZQ/aLW8MUO3Pmk/t6nzicxmif41b2NTdolbtgzSqSkFhktHPnCtAmJNqMw26PsX0ZwAUOjnKUAI7ICGDH/BV/FDpAB+WmeyoiyFZLEoMKWwU6lIa6lR9jU/A8LQWVzrCK87aF9JENq2n0BegwBw64KJJo6e51FEFICqjC6beuKkbKuL+MbH55L8RWaR6jw3PM1Y0ILVdbr5G5N6BK0Kxab7TctFWvkrYAAUEMbWubSo4ZP1y9vV5Rwtoi/UMtjMHc8cO+Cc3YUw12G6tHJw2s2u43sEGiZ9IuKtLuFm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff64f14a-6211-4ace-198d-08dbe4b25d14
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:38:12.0853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0UeVSrzCx2IG8UL49caMY6o2SvnH4pcZ1Z0N7gGM3kakuCnr9nz3b4g21gmYHArNSugM1WFGUkjO1D4pO009G1QxxDt8iqYRVXJoQxgexc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311140010
X-Proofpoint-GUID: 7eXYNC7yhyeKCC4TeFyCKLqGNSuIFCXd
X-Proofpoint-ORIG-GUID: 7eXYNC7yhyeKCC4TeFyCKLqGNSuIFCXd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0d73145430a4..87a8feabc2b4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1800,8 +1800,22 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int result;
 
@@ -1888,8 +1902,22 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = &failures,
 	};
 	int result;
 	u8 cmd[16] = { 0, };
-- 
2.34.1

