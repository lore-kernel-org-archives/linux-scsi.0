Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBA2C6FA82
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbiIVKIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiIVKIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED963D58A3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA3s6h006449;
        Thu, 22 Sep 2022 10:07:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=LgRZ2lxi7F1bHCyRHqexpFAvGwvvm14ZICzktggnYQQ=;
 b=Q++wXeY9i6CSfNseL80+BG/pCYth7RHWdazLvXiQ2ST0WRKAiDI8QIj2aTMK1tbXId0R
 S/YTsePvrCvnDaY/wcwKEK842opH6JtZYYmy6zvtb8SYwsH9/rIOy5R5EU1so2rsg+GN
 vj2XSroRUrpcLq5i7QlC4IpkgE1gunoG0rwqDbjMNdkQuIX+V5qqbfMjuJznO0f2u2kP
 mOcvPEMpjnu6/EzcCMQYSmltPWh6eoUta61g14wYGiT8aLI+OeDa1YWFjpMY7M9TAgO0
 /QPeeQEL9be/iC8cHt2zLXuDGUjWlP8dcQKbRhZ1ZpbrFGEXlTKnF5ZwBnamVPzYbLdl OQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68md28v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l2uY031991;
        Thu, 22 Sep 2022 10:07:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39furbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWcX/nNq88Nq52GHEvkYUxOzcybZNyed1PQAB4nstjr9pchhO83xKB0W7Mu26UYfM7/z1U0NIpmBBy38KIHeUGIUZ6Yzm+W9l3/C4yF8IoBJ3FR7Obd5gtkUSyRhXCjdJvmbT2jD3psbFXPP8ldhuTgKL21EGWAP3hDgwTRMCRZ/m6jbp3U+SM9CeH1i1ClnJahVVuyvoYuk2ooSJrY6aZGsq1Zu29LelyA/C4nhf69qRs3ygLuWkkAqLIe5G+smbD9jNMvOJO46mlank+mpBN/yk+oKzWxqz7pnqQFTTcBZkezZYkat7TR6uPRkXu++djvhS1LC22RqNY+KbhaaOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LgRZ2lxi7F1bHCyRHqexpFAvGwvvm14ZICzktggnYQQ=;
 b=Ds5LUo8MdFdb2RjIk3rJwjyEBNxVBTAqCul10USBbvhJDNGhFsszmYGoPThhG6ed8rIW3MkToe9ec5SOQ+087WGZCZdCHjGvKaE1XrYT7Dmt9fUwRmDVAL3PuDsep3JpVVYbNbIwlDSeCkX0RD9ZZ2MzVqRI4fDDH06OcJV4+SR3VwBo3Zt5iysm1x8sSASBL6/ZQVn+drC8SVZ8C2EIWVe/Zw0fI9KHcv4w3TMkADRc+RT3cH7YfYIUk3+Mb//VJlsm/3zwJ4olqbiPkVFLZ7T6mlev1OV8O5v3sNbw6sSZ9f0Zn20dJ4d4ymY/pZVPg7UuHYNrkHTyUnKUZvqemQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LgRZ2lxi7F1bHCyRHqexpFAvGwvvm14ZICzktggnYQQ=;
 b=t/jT1SG8LERXVIJ/7A+HptncqPmIbXR0IrrLWB3MK8auDX4YnphgncatXQY+j4XgJbL58618sfYtAvR5XK57HYsam/ejGvIDxjQ0DeX4IPg5hLbVgiNTyV0KIhfqNoAE1Cax/03qzvyynrjofrL5bXJzWYm3RbEjXHOE9D0Zceo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB4317.namprd10.prod.outlook.com (2603:10b6:208:199::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 10:07:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 20/22] scsi: ses: Have scsi-ml retry ses_recv_diag errors
Date:   Thu, 22 Sep 2022 05:07:02 -0500
Message-Id: <20220922100704.753666-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0016.namprd05.prod.outlook.com (2603:10b6:610::29)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN2PR10MB4317:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ab3fd9f-e334-4a7a-e6a8-08da9c8247a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WjyzvgqEcy2GjU9at42hC51PGr/XuuioYGvwdUFbH4gXbHQk7XegfAnqbWKOVSf94wNmi5svVZCwshyBYes7LfDCjMYAnvHuPp4eAs06Rqsad/UfHIiKpD41Dcg67WGaXShXR9W62nFofO7qahyDH44F3Jk9fZdT/oHaI2UnpePRtY2bABf0DUlYP9LY11uLQff+5AyX7X3xRDguqkXZfW+IRLmB/iTzolwkn3fEc9GxnRv9hCT/CHZNdWW/4MW/hU2wfJiGRM8rI4Y88hrI/zZpwNgm+0PBhF+gxWkk+mxg77+gTb3dSxRJ8PA2hHhuszuhpNVgoNEI/5DUgRk7OVin844CSxRjUIYZSPsY+ZRre9PfQ5lSbF692GwbP083rq0M0Rf6u7BAuSiU213vLaoZuXnT2SzyHAxrqjsSl+Km+7+ICvSc37o/y2rV4sDum0+zDGLkfZ9+w7JNhZ/pDxLizGEvTfytBuOuLW4bE2oH20JAGR07coOlt22v5ay9Lrw2ugQg3ouF65kqAEEssn+5gbR77YHP+NY2gnDaQxd09xeN1O+d7jN+BB/2boiPY0Sw44y7fKzRxlbDyVZwbOb92H5ZWd2Xn8zxaEh08eHaKorJR5V8OMEcYwDywrSREQBRty2XrePasnbK9ICEoQFf7WNi6TRWqrSKMUpUVZRdadHbxF/HyX/+6hW0LKRy356/SHOitPamreWbCvYoJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(376002)(396003)(136003)(451199015)(2906002)(86362001)(38100700002)(8676002)(6506007)(6666004)(107886003)(26005)(6512007)(4326008)(316002)(2616005)(6486002)(478600001)(41300700001)(8936002)(5660300002)(66476007)(186003)(1076003)(66556008)(83380400001)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NTHECIPD2EJhPR1QK0Xt9jaQ8SWPaq72tul/kFQuLuGTGBU1GLvPBiilfecQ?=
 =?us-ascii?Q?1BCU4UlXbTgho1Rc25aKXCStLWHBBvt4bLdKFciZ/DM18CpdJ7pItflrCvjR?=
 =?us-ascii?Q?OWSze1+F1e3gwzZ32gHNzikMC4FP/F3eCqQH9QqSWanju1tQ+J8Gk6AzX2As?=
 =?us-ascii?Q?/jdlHudrq4Y9K8V9D4yIKDQAKdeFXDZY8eNZn+RVSa5dVPpVvKIUCAepVdcQ?=
 =?us-ascii?Q?k749EJFBmogRy1WjZhGIzyP2CJ9B4ZC2l9sd2n/YDJggKI6NXQ4uSY03QG7F?=
 =?us-ascii?Q?nubhF8nxvYXczcXfpYBH+Rv4rOPa2VjBgVpu0y1DcQSb0Vr5egy2Fnahu1ZL?=
 =?us-ascii?Q?krNUaYJV1SUm0aj+PKZzcd4uVSHpsYFT4mAi2XLSHsCVYaUbRGashU5qS5lE?=
 =?us-ascii?Q?CTpiEjGydTrWlv9BZ60yqUGDGENsm/zDQM6BjunelzV3iwu/BcfiX5RHpH6T?=
 =?us-ascii?Q?AMs1PtUWzo+hki1Hi3qd1a5e21WU6vNFtTWiviQzuFw/n/6NHPVtfxO6ucyX?=
 =?us-ascii?Q?kAM6N7/9eXYZl46EuE+oNpCtxDZpUsUKcU/D5niqbJJiy1mWm4AbsnmHM8uz?=
 =?us-ascii?Q?sZeRzjD6S7JdH+ITd3K9urW1YOiDpnEVXXZJsVhndXi6/otOzgrm7xPkAP6U?=
 =?us-ascii?Q?lUS/CAf+4xw7wRtFRse8E+L1bol0MuumwIsVdPNB/pDyy9QhwUpbphO/XhU1?=
 =?us-ascii?Q?TudAMtgUL8NoXeCdLrWDLepHWIe2b000DrtheLAG4hmNWuXq+T5ut2xbClDq?=
 =?us-ascii?Q?e1CAM8I4/i8Hgefdc49sfEsyxaoDR2TJeUqoPd4ykAw4gAzYMFYLNIf40XQt?=
 =?us-ascii?Q?WTspRYqnweH+bA54n/pRzA2dJPFjvPJTJRY5evBqxR4OgXc3TspYA1on2/YY?=
 =?us-ascii?Q?MfdOrq3+EUpPgNhEbBuxXPw4Z6M/VT7JBXbr0vSl7wgveyTsewNcsNsjlXol?=
 =?us-ascii?Q?Abja45GeWzoJKFQzN15FB09+TK4a8IcOCfqNS9Fcjmm2ptdQ5NIMdL1vXLLT?=
 =?us-ascii?Q?0dg8pH5bAs9iTDMFZlRbOhpgvVlQAkDSYm5PxxM3KXiPwsu1MJ3WhGUiMl0W?=
 =?us-ascii?Q?oFJnZZ9B1aUM1ttKLcnZKjVcwGBD5x5TEbdC0jz1ZzVwSReLt0iqadpUdnhB?=
 =?us-ascii?Q?ZBJsw056Pm5y2SaT6I5O0q5S0FVpb7CNia7kdGrzFhHBtvNs62BzAMUo/O7l?=
 =?us-ascii?Q?edEw3DnGZvrk3Y+pLf2nwsffkD4lWF2Yo2WsJjto/AD4BlUIxTILtXg67kVz?=
 =?us-ascii?Q?xJh/xuFFMWkYuxwTAlWJsCT7ZkzsUzgh9cMSWwLy5jAmk/otzO3seXC+9JdO?=
 =?us-ascii?Q?4oiewRcnhLLotSPn0M96YVIS8lxdv5plDrKIAQkrmHdnPIAW30TNdgPFLJgc?=
 =?us-ascii?Q?tZo44R0fRAK49vatcrwLieJ9hSXs2M48PmaNNZ+Gk07PsCT4O5nTem2BNqqF?=
 =?us-ascii?Q?GtRWcTHGQPxWILZUf1oId2+ozcV3M8ihdrM2YFGo1UzHqc388rVjT9DN84jS?=
 =?us-ascii?Q?DsY1IHARmVZc2WLVEdFeRSe2yXLbZwrDmeEZWGMG98g/NoVXy8g+MYmtu7FE?=
 =?us-ascii?Q?mFR6FeZfhowHQj1r+xv875OOoE0GMVBTkUPQfr3+hf5m20LrNs1iwR4xnx4W?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ab3fd9f-e334-4a7a-e6a8-08da9c8247a4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:38.9267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hdail6tiUTygD76F9sNJOyBBKC0ZquS8Vo9otkrLtZULJ8la3fIL/XjKxrpyIZIft1yUabrDla7A2zfHnA4U3DCSP1EepNeWoSgQfyXxeUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4317
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-ORIG-GUID: Fd2RpdTsjMXRHzH-CRhO6jqPGQHjHDOx
X-Proofpoint-GUID: Fd2RpdTsjMXRHzH-CRhO6jqPGQHjHDOx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses_recv_diag have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ses.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 8f5a6370f334..d5de65dc034b 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,16 +87,27 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-	do {
-		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				       &sshdr, SES_TIMEOUT, 1, NULL, NULL);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+			       &sshdr, SES_TIMEOUT, 1, NULL, failures);
 	if (unlikely(ret))
 		return ret;
 
-- 
2.25.1

