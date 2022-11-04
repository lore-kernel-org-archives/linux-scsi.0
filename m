Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21815C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKDXWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKDXWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:22:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613F31C93B
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:22:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4KhrPt027184;
        Fri, 4 Nov 2022 23:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=ScYnJDwXr3zspY6r2CIA0K7Pr9DBdXy35EZd07laKenMG+pQrH2qXz4+ft9NGuBJpYmQ
 /AmKuO/qO1FX8xjHCzpNjPSIRBrCx2UpjzHTme/kG0n7AbscPWpRK3z8OUGhtXPRe1/R
 3jl06p/4GJcO9XCzzHxpRH2EbCQQn05zdz1BxLOt2Et6AagWa0w8hWyCShAAFmGgkO1F
 tZ2Sq5tpcxdgLSd805gftaJ6kJv/nrF/xycC/DO/vrwrF+aEKZ+LzZeyvJCu9OoiHRuB
 tO93XwPcIU7A0J1I6SZFU7ho1N6A09vF2Ukz64CNLlIPUwrV0MHCRHJ6q44+pkyDDe2n aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgust16e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:07 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Mtc7c029811;
        Fri, 4 Nov 2022 23:22:07 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a95q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:22:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBkb4CL1NpxrRUxmYvCE3ypu0dS0w1QZxZt4tO0kEXOnHB7aOmXhzqsk7Wf/hiIWuLi6XYJiHSxL+0Dj0BwYT5WM1544DjzoKuIoGTPNrAyrcT9z0IFKPafU1Rh9UruqSVCqtGgxlKkawksXdkr24ZachzIrwJNpfx+NEMty1/KFtT9KaJPl2ytG9hVDlXbytw9ce6SQyKBce3CVhwRkNbGKXJo9PJCWpNvjFIMlddoNWhJhQGdJ++KJ7/1zoV/m5OvkG7KkM2+GIidzXAA+MsmP4fapit7zSgx4taQ9qpq3tILr1a6ZkVsKOmqJLPxv65WCaEtvlQEIzw38cL0C2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=eHPr8WNqlcDYlQDVAMoMxzQLEOVe8R45wVOojZDNAAvo4g0VWmjO7G4c7aMLDzKMn7FQUjtk/dM0tTA/BHvOsQ4vFSg1orHezoC9UTnbux9uMfVqhRttM481o6mFkpEQVJPMHYtXPeCHGo2X8K7ItG2xq2Y8nHzGjbODWi6sVU89+BcNoLEJZlL5hq2fnAmQ1vRSE/EBhTNlNjoYloZ1loHCccH+tBaTkKBwi7tLCG84fo8oDp5hiQyEdBBvwfTQhF7F0qiQki7OHdZMEGEKmadaWVDo9+sMOukFyIPk66fJsyTY/IYsvJSoZn91Y41jzsnN6Get2cHiX2V4FDShQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCQ80TsAuy0hmG6ldOJJBi+B0gPmmjwea4QMlokaAIg=;
 b=wqQl37ELpdsroDd1QYOn9ONT4xj6vWTD6ydBSDPA4QdOcOgegbe9WBB3xDcdeJ926BmWubHFPxdXkQRJED1MsFLG+jokDXRhOVR0QTXYZfr4k/uLg5AvvK0pL+uRgEe82oQZUFOMdDIfBTtKBAyvRz/Tvu9btPUUMQkOCb83x7I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:22:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:22:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 20/35] scsi: retry INQUIRY after timeout
Date:   Fri,  4 Nov 2022 18:19:12 -0500
Message-Id: <20221104231927.9613-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0111.namprd04.prod.outlook.com
 (2603:10b6:610:75::26) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: a9640697-8214-4d66-a68c-08dabebb5ba3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6TN2TsngjL1bt2YD2RfCOg6Wmb8RdmQNBh/mb5F+ewafAfeNJje6MBP0qHRi5IEDKZwxc7aVWCMvnWnlLBmRUIrNgeDaVonWYQGqOCgI1kHWka7Cdk13Dh4ivDEAiTJcwkLTxvyf1/A+nozyN6PVoIfIHozUvXfH4aIAhfPNvK9FgSFAKfxdbMtnURn4S++2PtfqnEwCsTeefBPFZ/qSz0Nwpe3Rw12F+KqWO7Fy9pQdbT8uLsxIflbwAHZYAO6ZmYah7qbs+eA7K5rr4wDoUjElf9FI8vHo7MFUT/Lj6zlcwGsycmuqe1Y8U3/pW0ynQpOuZe6yMqsZJ8rjeBhT1yxm+2OYw0aZ6HNzF2CoPxMYB5qJ1wCFwXoouFr/N2mxDUL19z/wPl9dmD+w/2remVavKwZm8Z/uPZHvsIEqcXppi4cEegd+GcdY7qDfNfXIYf5ZNK5HH0Ztj+LrsKrT7NRuAJxtqk8MkJ73EXm00uTO0fnSIgdUNAvUayYzbA7w/AjgeRIVtbH9qn91V/hw97QOElL3jIRvVD7Amfrq8s3JTCuaRHPUHX+cISIA8Qa4ALL0lJTonM6XZLFw6QyIp3ItTqrw9ruBtNU6hRhy01+amTlAlGsvlzafs9CLv4i8flzChRGrnaOh74Q5Th6JjFsJna5Naou3+iz4vD4S1S8bsmbOC09qkQw/THmG5S4W0Ga7RcBW8rM3Avx2QoeoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(4744005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vdcZtwFCmN1j7ST8EX7shGQGSa0nCyzxXzIEij5T23utl/Z3ipR6BsYU2MfS?=
 =?us-ascii?Q?qVLwDE88eM6iieYbchdnK2VMeDYwSnMyu9aMfQw5pspAjGyfsFYDwa7xWiyB?=
 =?us-ascii?Q?pPXqJuG4YbGU5afofJkC9MpLt39jOJGjTet9XCuvv141Iw1DNLLxU6JZzok0?=
 =?us-ascii?Q?qRs4qRs15fx/1MYMBhCoer99lRsqDL6Tu7GLxhadRlqIbpvfszpm2aeqwiaS?=
 =?us-ascii?Q?82oe0tpru+uoOQjqMIjO6kUNm1rG3JYZlyKpkPHaWOyqffVZ2FFVjTWqfuyk?=
 =?us-ascii?Q?AR//MhffBuw1OZOA1HXnch+n3tQpsJjVATKD07fXh9+F9y/Ti6euO9zg62IJ?=
 =?us-ascii?Q?ttnWmLZyRfg2XRAC53+E9Rz/P/lvmXnp7tL+dTCeKPKBUPN6E4WQZOZhyYWt?=
 =?us-ascii?Q?gjpdK33bMzlimyTj7/udHfufS0ZfFj5Qr8ynm+aotDXlOfRo+KgOiJd8oR2S?=
 =?us-ascii?Q?8m8C2f2Z+PLlawrf7wjCIa165f001iCQ+fuOhaLfR14dC2rHz/WVLtKD8BMP?=
 =?us-ascii?Q?qjkFGBbm7NJQqmxvRt8+BnvU9sKnvG9MztB5aUfMFfUy3qqby36O/G3rSElv?=
 =?us-ascii?Q?cBnbFtGSIDGdj0FcQYq91Ff41LIWgVuKZeuCi5WrWl/bV9umHvbJy9+yL26y?=
 =?us-ascii?Q?Gb27hJa3h1Sa74xGVzliBTJ1T+Zsy8xFEHF8OvOUZfS+MPI6zTpWhIRccTbx?=
 =?us-ascii?Q?zU6HWsOgJ/ieeK/HqMdmrLiHiuS12+GNPFQBaS6ZouQviQrL52Sm6rbqvjdN?=
 =?us-ascii?Q?N7pXJ/TfpgGzf1vhRCTmk9cvEu80QkXXoV9sfbo7f2uRHSkybA2yqZHrUSnz?=
 =?us-ascii?Q?i6A+oqlMGLfVvdeFPTnlcdO6XbpZXU2doV0VPq10xs7AE/VMtHO1jLoU/Uz3?=
 =?us-ascii?Q?jZLYmrz9892Vn/NlViNY1fF+MRPzkRDeguGnldkATn6I78nEXjwMROLZknqW?=
 =?us-ascii?Q?p4kNENyEVuutrkBporKLblUVtHIxAp08JZ7u6bCBmNZX2hylC2KAxPlNuE70?=
 =?us-ascii?Q?evsxErD4qPxArOf7CHzhGvlTTNYXSfmmyp1pNb6JG1v73MA4M4RSwwzNROsA?=
 =?us-ascii?Q?51RHUiC7N8WcSESjFT9LLf1oGU+AzbXSSkJnUDRD4mpSMjRvOdq+YaigEJob?=
 =?us-ascii?Q?/US6/MDMbFq5K7gVo7DQtPG+4cTdBdJTPeG+qKbb+TMSEDIReVSPuupSw5mX?=
 =?us-ascii?Q?Eo8qYs59B6Y3E1OwgYCZNX1O+ygGjfqnnnKzqm8JAh2eq3AKj1B/mPdgAIQ9?=
 =?us-ascii?Q?MBfuBK0InmGxJ6yzakFGknMggyHma6FiO8oiblPansCB9YK8R0MjEl459TZM?=
 =?us-ascii?Q?BBQpZZ+lVMeSFmecC0e0ukzZWQvqccYcIJZV+4IAy9hXK8K8z/RNv74KbPNl?=
 =?us-ascii?Q?p9ZM0AXZ/fsHkkl82gKftGaIOH3+LXo1i2yJiMxmNLl5fBWqLx6IlLkLI+DC?=
 =?us-ascii?Q?WELyqeQnjvm6t+SdESHQu3IAJCCwMAtmhd2B7+nGuxpKUUhzIzBhK32DtX2W?=
 =?us-ascii?Q?ehK3vGPi9fX3exYwJzlu83FREzxCP+3E6Wjv+vP66CEgEQNeaCWNBm9hok0J?=
 =?us-ascii?Q?U6/zGARVrIdAphPpOoUYQSIQ5a6TyG7xp47VMjUb/K+6QAYeHHGzRfWLvFQP?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9640697-8214-4d66-a68c-08dabebb5ba3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:53.2897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qs/hSGd+ifM/GQCG5xEK9jG5+5Vu7jAJRiDJxIWZdKhqKwZ8Ijn6uv9u2jpd9cZqxDBnBGu3mm5psrikKWx1MIs2+8jwAjYbIVInlW7oLi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: 6j2j_leW37RtqZvE6AtzdBgvZ_Edp_rM
X-Proofpoint-GUID: 6j2j_leW37RtqZvE6AtzdBgvZ_Edp_rM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY up to 3 times (in
practice, we never observed more than a single retry),

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ffdb043bda5f..28d53efc192b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -674,6 +674,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{},
 	};
 
-- 
2.25.1

