Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB15AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiKVDm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiKVDmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:42:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DA227DD4
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:42:52 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM0maVS008057;
        Tue, 22 Nov 2022 03:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=QvX/COtHBCqsajW22UDLZbUZ179+3+Hgg+aYthHTgPY=;
 b=egN9CZZkpYhb4RZpfp/GccqdI9IK27r97NDWOGdlxr5dvp0NhdKpu8Zjy7N0bnPqAZ+x
 ktOcLXMJrxMwuBqjReCteYX5Rz+I2OjI3jrLr7eHPX7BSR0ij6ui3O2nTKzvODoYAa+y
 NSnnL3ILrypDgsBB6RH2RYn9MnOjNuFsMRriIJMA0GgOj+MNd3XkZP50TuM0Ck3q3NFP
 OJIrqVoY+KuQ6eEjJA6hH2kvfyY8LNxTrknXRMav+FYlYnNsbaG7fu4TEgImPTv/LkvL
 3jbCXXa/0lqaQAIwF2bSqmBEME6eILdBs64tpUGDjLfgLwGCZQsqSeCC9XTQ/elfY+Yz lw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfaxt8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM33drS028960;
        Tue, 22 Nov 2022 03:40:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkagjxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SS11EmYjrNUJGDuuG2cRghmTTYaCfo6txtdIr1kWZjiLKXt+H07Em9I7sZMZVZGxt7dYkg731M+i0OFnWpmZFdO2i9hOR4yS1jNvPoJIdOxzMbhS5X0ktg/EccvvRgUvd//+plmiQJDuSc7KBtZoadlBMQUig42X80xT0mEME+9RupQe1IWI1UsHRCak9NA/oXcOduKVfH78MqdV1gbj8Kr6vjeccPr4OXIe9djlHqS5dJI3xAeN/cMF5HyMHwAPeLktCWf+jIBvtxfvvYupXD8jWvoOGe1rcLQftrkoDMOslhZbc3QcQRUBoZl3x2coa3xTtvqp0p6IUfGgdyKIpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvX/COtHBCqsajW22UDLZbUZ179+3+Hgg+aYthHTgPY=;
 b=NPGjBBXmaVddZnP8YEM8VOANf5ry5y+h4j7Ix1zF6uzp0FsXHHiCKnd5nnSIDzRJQb/M2HlCI+Ux4gBZCUeFw/UEEOPirkbku7yyQgIaX1GOIC67DAcdRp/mhHS4vYofDq9s5UqZ1R3zc5KMUEhTHfjYx1HHtgriDffGZ3bauj4edC1hGxyvOcppbqUkEOtMduv4eGXvoo5NurPgP3XnP85lwBHyjhBmS3lgspbMpQP8sICgg+SKvU/EHVvLhBcEzYRwjk72svBcIbMEUbLhqpBT6U8b8lF+HKocZUVQWIyR2Tao8Svln2nY7hZhtDlPmHoG/nRhetRywIyz2GMwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvX/COtHBCqsajW22UDLZbUZ179+3+Hgg+aYthHTgPY=;
 b=UPgKGYeX7QDLDgbQVtZJE4n4ktySpq5MX7gPddQ3fCS27DASHIHZZzMzwfinjy9EkgCrbiAjjzUqkxxdM0gyZC+VEoQfW6xxXBgL8lotYbiGoy9KRG5c8ZKgqSuaExBMQn6CIJ+VH0VGEtRIWzjhxPmfCoNpkuMO3nLl3VEzEM0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:41 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/15] scsi: sr: Convert to scsi_execute_cmd
Date:   Mon, 21 Nov 2022 21:39:30 -0600
Message-Id: <20221122033934.33797-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:610:cc::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4472:EE_
X-MS-Office365-Filtering-Correlation-Id: acb15c22-1c56-441b-a59c-08dacc3b542a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62gbbUnJeWaw4O8RFbdX/krANictR4LwRSHEJyhG1zf7Egwl7zUY1YaHP7djdyzD0yIrC8yowkgy50asbDWgHOKKmU8FS78P2v97Tz0Ax6HuhKEdUEldz9K7TwlS3sb5TXdOgC5VeRXpssDIjnjSA5g4z3co3JxvR4uEN3KaJGioTmAE01Mw2MXRWVgrOWLAl1+V928NlCYZJFuRTwsihuAYZDHoiSQxBiryUPPyvIXsF387WzBB92nlNHQ2WO4LpWmVkabpG4zwkhOn7tgZKKIgiBv9VHfWQz3oSf9DpXEk/EELIAolz036/WzmhBwEF0dV+54FCJoQg58gtqqiv5e/5GqCTFRDs62P80Yue1uqMdvEpjOBiG9AlWIfa5kE5Q7YhHpM2EfzFRVw2+Sj0kl/IjEmf0mrg9W2ehrl2QloolM8S5kILOQLmkGV1touAZwkeMDck/IhROCgnK9S3yN4IACcobHP0fHLnNLqRFiPYmNICRQS8IQ/jyay/ZGX0cT+QeIbCyxq5D3YDlZXM5R7OPLUgqrioyk3+HAKoDt5KC60ciSSnzfvqMl53K4Eq4qBQ289MLHSLHgcEhGuZ8nv5rRyTYOnpFI4ApTl7VdT+aXbWMEwZQA4MLmXf+9T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(38100700002)(41300700001)(2906002)(83380400001)(86362001)(66476007)(6486002)(66556008)(8676002)(316002)(66946007)(4326008)(6512007)(186003)(26005)(1076003)(8936002)(478600001)(5660300002)(2616005)(6506007)(107886003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NsIbSX3oUCgBY8D2jIzAlKnxv2Pi2ViBE56ltZz6LngXn/z97g9sPZM+A8vx?=
 =?us-ascii?Q?ncF7fZLvbTWkoa7Uf/yCVVuvlzDs1CFaZSIAv6egrNCdI/BCEbbtZwoaQSST?=
 =?us-ascii?Q?VTyl5Cr9kEZOmgtilFAZUnuhf+zQmEvPrYwojdFeqZlt6Y/6FiLXGPKFKJ5p?=
 =?us-ascii?Q?usM/pz6hjyCTeUXZMADarun7vTjL53mQaoZ+MCpM/uPBaaq9Qjic8cQPnZgj?=
 =?us-ascii?Q?CnglsOjq2IJKGqgjE+xdnrdgpu1rVu+b0kWsOaa93dJNYGkhdKAvCcVlzIrX?=
 =?us-ascii?Q?JU3CuqC0crq3E1jpZ1BB/bhmclmQJI/RHr4EM+cqs4wXMH7avpyRx5E5Cfz5?=
 =?us-ascii?Q?eBvVW3hEkrJ1NIsWzoZ1C0USjVLM1TtNTBSs+mPQOI1oo5O9f73uKK87P3sD?=
 =?us-ascii?Q?X9v7i41htxH71PGtStC70oNlgegWlAwPNziGMMsXcCTry8HjXNifI+e6vfNA?=
 =?us-ascii?Q?Dhkih/cDe15sR0s2lOXfcwVy6jIecg6EMhruFwipdI3yO0yv0X4GaU3jLizI?=
 =?us-ascii?Q?m7/akI02q/3pdIpLLALmwmg9POct0aBtUwPtGR4oWCBwCnRlnqcW51o1h+cg?=
 =?us-ascii?Q?F7dOBZniXN4LhzAokexJlh6+di59WngfmInQPeKzhxDfKB4t8fbIO0zaziI8?=
 =?us-ascii?Q?v/9w/Jdqj0VZhEaVmOGmJHvhzTy8XMJDL0zGIgH0IaD7iqZLGxe4TN357odl?=
 =?us-ascii?Q?CsLamOdpeqcbOcgx0DJgn3pI+M/nKf+Fs5RD2ZKrOXxfGA0NiriDXof/u/La?=
 =?us-ascii?Q?URFWQn0VYD7YJoWQF3Q23KuJFfPrB9y4VDW4N4IHR6wOUSm9zUEC8y5eIcJu?=
 =?us-ascii?Q?rrRTOQeofL7XwEgfTVg/Yq1nX7a1XiBUROpYxGGNoTWa+9l09rVhsMCl6C47?=
 =?us-ascii?Q?zdk6sFb2Q2W6y+FcTYShWJ66qzYat0Nt9Hw6wmDxj4ocQAGWNfloxryhyLZF?=
 =?us-ascii?Q?iT197rRMoWSeui5Z3VLxL4+AaWHL48iSmn/vmQqSsiWwosabJoUvWr1tlFp7?=
 =?us-ascii?Q?O5tkugBrREgSbFPWy+j00u0XTEuN6f27nvZUFP9V9PvYiLrJsAAMutZkNmQ3?=
 =?us-ascii?Q?VnOEUKqUSmcKZRdyPnHrWCcWx77zUzMJQiANewL582MnV+3g/5vsvwe6JURz?=
 =?us-ascii?Q?cvcBlm24+jmIn9QIuENz3Mc4JLTwWtnNgkUmaxsctrUfRyFe02Swbds3uzpr?=
 =?us-ascii?Q?J3Auh/U0Z3o8AmMhPZXTxYjSUQq9+rhSqdTwwBC07XvHJ5LSCeJ0oow5nQ/2?=
 =?us-ascii?Q?bl2EEKUlx5TUHDsx4uwDmOeedQGjqC5OONUAmR0rzAoSXLgVUbmxyV7yKPsL?=
 =?us-ascii?Q?SFTPxkv7fp2rtXADzmCv15vE2DlHbZV7L0CjbFBcOZUbguP8QsNamq2vJjOd?=
 =?us-ascii?Q?8iC7vw86XvDtVoqRp75KxvFbmm8nr7zfkJlaqOx9TwxCIOMDd/zm0NA1Eiff?=
 =?us-ascii?Q?VRvzkq3w7XIoByh+l9+uqFOofe227Bvqm6degt05tGPmvpsH1fVS12bS8lo7?=
 =?us-ascii?Q?TSdSBmNrgb53tB76Bgm3NfZ/LcZf2NAqUeQ7A6N6oW/Wp428d5Z4NcJPbNML?=
 =?us-ascii?Q?Co945mi3gKX462kThW6cA56uqiEa8L+hElCKbvXvMTm/vt8bBPU7zLPADwxc?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ctzALXEd6a3IgxbY56p1Er8ruyCLY5zYx0u+0iAC/uuAzmoiadkl3vubVvpHbU2TpI+THFICCcC+lku8aIXmkazh3YNj7If0vZwJU0U5TCEpfZJyzTKUPXkqcT5/Om9FA4tBP2C0RNF+hXq4aASBmEMwjYhcpLmKnpFAqF6u8FjtuMkl6ahjUtF3unpwDqf1KdJ7v0WP09w6l7SFkDxtcudkHnL/jrZTimseh9XP73I16ZqyYC4EeGCg/p/dWP/LelmcH5frg1QmKmiKjpffXCq6qVinRMLGTNY6mE0v71lcydjEpHN839/FOZFBLg/uXsBk/UAXBT77FpjGmShVF2v2uL/CQfj3HyJ0Fy9DCM6W1yWzX/6KPe0eTVzsZaurUovRSc1as0KfLU92Mo5Wj4JNlO4v8v1auns4sLHiRf8i83/q+HkQasOE9tFaG1B+wc3/LbgQUHFeUE2u8+VK/JOthMKH0fZJOAoel22z3N6ew7Syb/+9E3/8HAYjuwIIgyw/NM8su13BhSyg6/thY2r2Po6/PfSt+rHvJ9zI9SwfrNqVOkwR8tB8i/sDjqBiiyULgKDTAhBBgylFfNxyRw92efXz6gkKYU9IRRNid9Y15SXddcI/tgdCmQjrOSxX7Wz+VptbNOdt2JPQFWuvmtdlknwFfTBMiUOOVjgbQdF8cJPlrpG+Qe40HPKk1g+N+TbTZVx9SJo9Z7ONEsmaZKsshXtFTga/rurXsN1GD4tG3b96/nGi8MkEjLjDEDe9fi7/34tBYyj2b9L+b8exYWmnS89S2VqiRbBGyi6h7xkU+dzhpJqSebl5xue2VQizN7jrZEtcxmbZ6t/e3V/DQaSbijzx+rmy9+Q3yyJMvDfSgjb6CJwkpY5s6ZotZkTD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb15c22-1c56-441b-a59c-08dacc3b542a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:41.6376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yq08kn9Ec8tk84eSUvxRlL4dpj5gl+d2lGxyfJqgaGps1oA5pl3mLL0WxDC2SYnWTOWkTOyyr4KrEas+TSbyWvGXS7hRllCJgQoMCd0sOzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4472
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-GUID: OtnRrG5PpsK97RYcn8ifEeNjMQToDDEf
X-Proofpoint-ORIG-GUID: OtnRrG5PpsK97RYcn8ifEeNjMQToDDEf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sr to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c       | 11 ++++++-----
 drivers/scsi/sr_ioctl.c |  9 +++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..093ff071bb3f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -172,8 +172,9 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct scsi_sense_hdr sshdr;
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
+				  SR_TIMEOUT, MAX_RETRIES,
+				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,9 +731,9 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+		the_result = __scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
+						buffer, sizeof(buffer),
+						SR_TIMEOUT, MAX_RETRIES, NULL);
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..4a2342888a4f 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -202,10 +202,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_execute_cmd(SDev, cgc->cmd,
+				  cgc->data_direction == DMA_TO_DEVICE ?
+				  REQ_OP_DRV_OUT : REQ_OP_DRV_IN, cgc->buffer,
+				  cgc->buflen, cgc->timeout, IOCTL_RETRIES,
+				  ((struct scsi_exec_args) { .sshdr = sshdr }));
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

