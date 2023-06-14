Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 312C1EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243374AbjFNHVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243366AbjFNHVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C641E294A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:25 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k2cT026413;
        Wed, 14 Jun 2023 07:17:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+8h5Q/GBKYXwK5pBMb+sNzt0D6jZHtVd86NT5V7jdAI=;
 b=zM31qmCj3ccQ0Nb1qlyp8yxwrCpr2NDNWDG55UcqCbuImnH3jfZvu2MednZnR95KhY5L
 ++8J3aztRjSCHqEbeL7AeoNcP1mzXP3kfyEmtkwHAB+5hhMZ3C9laJ+J5puJKfyWy/ZW
 XFHhhWmuXzZcR+hNUHl4ClP3W0+J9TboXDgjuWJHG7eXcxfkGV0Kx0Qddopv61rTTO6G
 QRDvAVFZF7D/x/wUGBrzfQRUBObj2DXh9Pd2PoBERgPWbHgYfapt/aXNq+3tD/JARTav
 odTYB2n0eqMJKd05gPuWTiFI6tCX78/PATWROLe+rnQhgnj0241caS/YUuFlg/R5/0lO cw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bpyta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5aFRd008455;
        Wed, 14 Jun 2023 07:17:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmbex98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erevcWtfUkgaACeWbpFdtT//GdWqKdI/7ZqL3JThNr2hg4BwiHV3jH/lizdRU6yDF8Fa+Ed1XgdUwdOUKYjVqWkV2bbJW/DTySnNVfXVxSeV1k3tb/0xJgJxJC8p3F8nhsZYIaHPDWbkAuRmjF6qFiUpxsEnVZcuQQPzXaEKrOcoUw+N+ckcsrsq/bJvBDpOcxBlmvQw78qjAkaNSU0Di7P4Kb7saGqmcbUCt77m80IWH08rDNmcdMqVRk37N2KVdiyFvU4FDGmiy1Xe7lvYpohXOdsoQqUD11PLMu9t5c5MiPIeBtA0yZWhU56hFxTCLMkjNGkhesh5prO5EUOaTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8h5Q/GBKYXwK5pBMb+sNzt0D6jZHtVd86NT5V7jdAI=;
 b=kVEbM6O0oNWqJDDL2+lOoxcrtw5bv8YVL42BaN4gIibByu4KMV2thvmWT06bYOdVjwvgwop6mCix7BLhdb3yUfA6iP4JXhCuOjFI8cItJp9TdQNBWgGSS8drg2lqC+Wx/GIqPFwd5175pAcWop7bni/ECodCpIef9VIxR7y9s+99sAMTqF7uh4d+ryp2i9pttbULMk7wn4GinGdRvpZkN3pduRQ1e99PFfAFbmuPlgicqnfnWDiBH44AZE3iKP/CdXVQPfMkX9i6AoouKZjSgFz3mD0hrsIKIEiMthWLLW6FghT5YBwZupMsTeGXtdDKfm8P4eo+vxBr4K2wJnpagw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8h5Q/GBKYXwK5pBMb+sNzt0D6jZHtVd86NT5V7jdAI=;
 b=bKws4fNhu9CA60P0jPALJhMoqn8N9TO/M+yH3U8Gsp1NVLNmMQL/iZNt6VKG37lOM2EXJnoOQl4CIOsAf6c1NUFRvgRB6M7AHdTqn5+2zZvIXxEvqxFifKhwYNFlxwxmTW9NlDX3oWx3ujMcvHPLUppv53qBFmf9xu94VIRq2zo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:31 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 05/33] scsi: retry INQUIRY after timeout
Date:   Wed, 14 Jun 2023 02:16:51 -0500
Message-Id: <20230614071719.6372-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0062.namprd11.prod.outlook.com
 (2603:10b6:5:14c::39) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: abeaa2ae-219c-481a-e180-08db6ca76b17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3TZANoGXnB1ZRT2fYcW/rgVPf3LLxnF5k9ZGn57/giyIqQVWsXPUz8Rr93q3ew9Y0bbzS6Y4aY5zCiMuM8JkFXBp599PM4sn00x/Icnw4dQXbEvvwn9yul9bHznuRFlNP8s+4lH9qPTPR6eU6RAWhMckZ1L53oOG0z3I6bbmc3xshScKtvSZ13hRJC2tQEhWiyO/1W950uWhYp6PS4jUhh4HvRMt0rGxR8ocu8IU75WX6ZwuZ0A1IyWg4heRoUP8W+rpqlLhLNWaMkuj4wE90Htf/W20ySexDU0ZUGHdKV0IXoc9Tq9y+ZV8UoCABe+0zZ4RpuD+cJ8Lehev+Uh/3DkxJdv2av7lNZQ9lPhbYKpPqhk2z3Ks+kxp9lidpZz6LzlaRRs8PTEDhDrskYaVk+OS5Z8+cdpq570ox7mzYLl85NGNfAFDOCr+2xJvvel45FnP+OK6yJ12IvAK/gBqWv+Q71gW3VD5Cnb49mEwrT2OUSmhCUoqmue0+ZlODDlYI/AiHHTKbQCoUMdXGnZhsfAPIayd8QsJ482SXY3RDsa0/N7CvUP+hV8N+RiqTWU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HpkIGL6tw3oUv+8+9WjbKRKEC3jT8eZYQWNg/ZHb4FI/82RfCy9e6Yl9ctp3?=
 =?us-ascii?Q?qivqg7DZIvo+GFGBmjMplTLt6EMMYFV2wEvRT6qtR44Qy43v/Lq+OHTBMW0m?=
 =?us-ascii?Q?0yc8jin9+fQ6lkkZPhgQzdIwpaTKh3BfMSysXW7wFFyA68mGsU9mynJRGqzr?=
 =?us-ascii?Q?aCjVHZWiW8wVBZZHgedKqh2aUs7O8HkqQBpe8qmRGJwolzTNEvwBciE44oAA?=
 =?us-ascii?Q?ZWSCPJaHVB5kbDfTSghEAehd2vboy3/2i3wD+dGfKw7Fx7Cd2sP7Np8KsUxD?=
 =?us-ascii?Q?Xs1rWSs4YOgEj4STxJR6b3WK0A0Biso2gXzRku4FhGCz5f3NynR7Oy4eR/Ir?=
 =?us-ascii?Q?6aw/VvB0OzjMkWfaNiZvp5NvH4LV6jO2GOJ4fdaX5JiDT8eNnxeg/vfvjfPu?=
 =?us-ascii?Q?wQKKtisPTzLqD20jPHtr32DVY5b2SyAQKfuxmuy34914ANE/yMLXBcuxHAJF?=
 =?us-ascii?Q?Cu8ZYeSFiDZFYhN6rPOfhKcpHR8gUXZ4/VvITGmEUCP4qfCWH+sGn9v1rWlZ?=
 =?us-ascii?Q?tqYLp8aXs2b/ZWwU28JbvWtvwF6icc3DCyoM4ipC+YiJLPAgsh/xqkkQpG/o?=
 =?us-ascii?Q?FdtugGxFE5wo5yf8XXqjy4rjOaXJIzxnrLdt3TrnKWa4xe708RA0B5dEaNnA?=
 =?us-ascii?Q?1zxL7AgJfTtqpaRGueEn91UDXIVrhyR8j4X6TpQR2aOFiOVo6Brlp2wMxWml?=
 =?us-ascii?Q?qJ/hFt4j2gLyDbc/6GFmSvJKIhpZ8N0QDP7jmPNhnscaHsJurejh3ES0RVNS?=
 =?us-ascii?Q?rN2UbAMLhszRW6uyz0qnutvEXLNC4xoolR4Gi4bVDRb7x3DqHFkYhZXpnetO?=
 =?us-ascii?Q?ZO5Lwg3E0ZT4w+VYH+1ANd+sZ1VXerksdK7Wp58gm6uxItV/PVjZSPCOl8hM?=
 =?us-ascii?Q?yPtiGWvx7M1Kl39qsb5egMKErCk0BWfhNSgXmTKUBnSCixOWRwwqW3/prsYd?=
 =?us-ascii?Q?ysVKCucZMsD/vK/Vh39XkCYwladGQX8rQLdXJarbqYCOvveiyJrWYeXrorZa?=
 =?us-ascii?Q?KFLcZe22BQRPjmp0OTo1wyEdYRN1DVEIn1pzFySUaxL+BYm64ctY/1JAgQOR?=
 =?us-ascii?Q?tut8Gx91rrznEjxm95xX1HCA1bJNGQHKUDyKv4MTW31ap13hwn7C9AAZ8HaF?=
 =?us-ascii?Q?VJBKflJnMtSl7NS126xtqRDZEP/5JKjF/FPXBZ+qXZcqiFPtqCu+J9YgfN1z?=
 =?us-ascii?Q?JDP4DcS9zPOtvB5dalSAhpBWnNsogz9TMz8V8A1UKgvlMv8CgZZ0dVQ5Y28a?=
 =?us-ascii?Q?v2jvNvBgQFaMqo4ofpbQdsFNlSZIgIvv1kqzMFl5XpINaj07oJ78MuoGScCN?=
 =?us-ascii?Q?gTCncT0qTDdlJ8XkxujRbhz5KYPNDovevNgm+bblkXQ58JKttZgpjJSyp04a?=
 =?us-ascii?Q?rFJXKcMwLwc65LPgF0VyHxtA1AEfbWMs08k9MP5UxPqMQq4GzNAvrfPI1QDp?=
 =?us-ascii?Q?B8pOoaSfL+NY4+tPwHomi7bLe0K+VprbjHe7GmWQcy87A1QDFQJbLxHWj3M4?=
 =?us-ascii?Q?DP7vIN3oBI3SEdKaAEPMmhvTmR4NEdXI5kq82+s2wNmlmEZajwNctBuYBMEz?=
 =?us-ascii?Q?IkTsaQvYH0zLCMrvjNKDOPd61AW8AaHxwktAgXNBNvFnRR0MiWXkqNi9N78j?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PWs0qAh/salzVP1aQDk3hDoQuBxGSSAHAAT0nC+f/iUL3NZQz8oIr1DT7E9CRgq7JXcrbAzje7LrPU2VImntb4hi6gi7WmXkx+y515+fDES4umDr24bbqrnmF/Wes/+NW5FwlnHrfFwZkHLfgHHJKzLkWIZUyOgYhqHOogWlQvE8hdIPyXU2xouhdXKW75BkdbEEDPj+aYuvGvSmGBs3jq6L3Wo0VehpeNScQNddMxTMOicrsLrdJocgOk+FV8bNeoqAV74aZjLcCzGDgIcmQj/2WfWV3KY9AEgXC9Y6go3RyuMmsNETCP2SBv4KR5KHt882u/YhYa7E9WTKENSWlKGH+JShuh6gmBH+ZYfEwamf2qUx/Ym/j45y9JK7KxKsczNqu+3TxQkJp/JUuHRyl/2W7u40RcY0bL0VmrXfyU3irQs1hP4s2lr3Hzbp19fyI3yU1cBpWRK4t9qFG8tEhpKK7oS4wsWvsmz4Oia7VK7j05Qh9h2w8xnQ94GwYNhQ5nknZ4qxtPfFb/apN8aGbRq1JNxO+/qNTowQFVNO12NxD2OkixOxPxhi3bpOoD+S8EjpHbNMngJCgjUX6rjjGX3YsO4+BrqsFiR3h5xuw4OYALELOTETlXq6D7Fm8KoZb8DmLej2wM5tpxX33E/uNmx5kNG5ZoMgJIFyxdzYInuOnOEtzTRTEAfbG/xRmR98O5c2qfnZ3/Y1NkCUbSsp40pGi+BJmbaMzeT7UPk51BECBZjPoo3N+VVKZ/xlc1zKmgk3ZioOksKm3qJAvCPz6R2FRBKQIyn+CemSRBSel1zZdmtVDojq99eldgwyNTylZv24t9hkHt0LCxDQTjjphHHAu0lLXD/bso/BgWFJ0FLqAx9NMHXuqUB68/CaIo//
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abeaa2ae-219c-481a-e180-08db6ca76b17
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:31.6457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErKn7187AchAwUOjl5yQr9MBgGSRDsX//VG+fN3nXc67jEqgtyixCpRLZn0gS+Krka0VfsNdwel+oQrTOwcBmzKGjLUDBugTwghVoFZDYPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: LIWzSfrzjbt9VtkwZHhXMwPPzsfg1Ror
X-Proofpoint-GUID: LIWzSfrzjbt9VtkwZHhXMwPPzsfg1Ror
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 519755952254..eeaefba6c9a9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -665,6 +665,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 	const struct scsi_exec_args exec_args = {
-- 
2.25.1

