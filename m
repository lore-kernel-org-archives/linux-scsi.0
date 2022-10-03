Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74C1C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJCR4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJCRy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:54:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225303F1FC
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:54:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOErC015527;
        Mon, 3 Oct 2022 17:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XcP6EsDX9P9l2B0FS0Qa+71/lCOO72Qq1go3QHLrICk=;
 b=dlO03BbbX914dGvawMjsuJaJ2uYVO6aq7G/HRmU9V/+AHwGJ/lio9t+lKRLUPg/NO/tq
 UkyurfRgV/bodiwH5zAc7fLQm/t4VRaR7KCmwEc1tLMNpPOhUfMPIJwGq95luuSXSQbz
 bgj4mK9r72yOw08MOl8imow0JN2ja++3hgd5OHlmySTknlU3f6ZYNS+D2kDBLktYcras
 OJxUeRpEtqE+rl+nnB1MogzRhJZRXA1/dwn9Thka8VHats4nMzVioEM5kG9iOrVcCwUA
 QHNU0AQVpm0i3bvoLkBMjSoPftCYtqueY0IA2rc7ke1vOMtQXZ5QvwI+2NEovfd6USN3 kQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2mbnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293FFjNL014072;
        Mon, 3 Oct 2022 17:54:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc037ymt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaFEK2611KRpOM2m+b/dHp3hem1+ckNAuIdIPdEo+sydk1YgPvXLLKidY/LZEtHZjTImUGMn1AMw3DIcsU6ASmTsgZkKUgAjwsM2l24wTWYHWLMSjURBGOMvroKqnTiIUcWBCCJdNeGLuPza8KHRT1WcIBxRJHw17fL1Xmdqg7H86Wc0F1rvMQ5AnTFrd6xaaI3/cFm3OlIytYaLmmJo1U8t5MrXP9C4z0u+ZXb2jt1Hjdm/5MchUOqqOL8Md073WVm7icpeK88N6U0oAgM0rfOmR70UUiUN6XKaY7aLsW9vWgsufwDDbP459ubkmVfpkH6h8g0sqemZj7yx/deZRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XcP6EsDX9P9l2B0FS0Qa+71/lCOO72Qq1go3QHLrICk=;
 b=iWPvdcSwepDPSnCiuOrPZlGNi1FEKZ+xNbv4WrDYTCso6oPb6Fnd2fz8908vNATcwUmn/TDhhWnIR3bQKB3NWpdFbDzMjhVYg7kBpK9mHWOXZMuTgpIH074nSqOEv/Ku8Qn7Hwzjq2FBKXcDBzOB65iUnQpnrWs6erW/rzEzy5b0kWVKAZwvop3QuxuVo9VqRdiXlSHB07kDV8z8TVVVDXtyLcbOLdBufhO88lpg0fOiu7T4Uxomjhr3gTugxY7+mpCbUF6nnQy9kqcbajpGCZS2YsqMNPOa46LztNEenxT6cNd1ja52HK5OZk979jv+NdvSzv7v6A7fw564Evsi/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XcP6EsDX9P9l2B0FS0Qa+71/lCOO72Qq1go3QHLrICk=;
 b=UysfXSQ9/OVqTrAEqPLYDH3uXSSkvxuWa6tvut8OG8CSS/SN/wWaBtgjvXss2/eiB6CeC2GHXkjcz1fYlnVHeRXGdlifspBLmqsrthT7MuGkfwymYaQ3z5gI2yo9pOQBh+MqLZ89WdqLqzMKgWwpQPnU2GyE31rh3lROGR30yEg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 31/35] scsi: sd: Have sd_pr_command retry UAs
Date:   Mon,  3 Oct 2022 12:53:17 -0500
Message-Id: <20221003175321.8040-32-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:610:38::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 16080e17-c1e2-458c-226a-08daa5684664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IgWQOG5ZRV74xAfcZtspijfF6vbTxCgme5kzNpOwj11cXt0oqOefIm1iNtaxCXpyWsVAZKdyvXJgQHQxmeB3WbyoriE62px71Mz1NIhD+j94NoyttrKX5nAP25C7hnLr0qS4q08Iklnqs37v+VyT83Bxoru9GHkaSGYQ35bJKm9H7qWSqgOtOErma/NT/r6vMhJA8fShUf6fcs3oCgTQRVtEp6GVceXpfAalx2rLyIE3460TnpyUrw9iVW2EE1DTE02XsHToe0hlusPUSZrxYQyVKtieSfzQmM4HrYRq25mJkgAEgjCTOy3uWtDZ50BWlvP9f9sLS4KrYhGsywypkuLly8YozYvw8SejNU77KpFz28eqvR40K4qbf3ZxBI3OtlBto4I60VRxc/kpYKXi7K+uEjPOTfDVjI5Ytse0q31Y6Ru4gv/EqSTStfGok6NZKFdhZVXfYdrNM3EHCPAV7ARqCj5OMuNFiUs+WOCk5XGe1yw+v6EjbhXU3J+a1fts1uIeHDXBRNZ0ji5X8s+spBFTKL7jiSzoQu2hv5Jj8ku2H+D0db1/FzIUQKgEtgF77mtPTLnNv3IsJouIWofa2i7fp6nRAr5dHVVdmgeNU6WCHfsI3lfHeeL3mkafPwMdcwC6KUjy/KxiZ89+ZyyEdmbIF714nT/0a2IYTolcbNvxm+Y+0LTzevNw+jylSnlKs+Z3WPEAcRKeQBlqIPJ4vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i5Uca/gVugzN0AdI8I/wU2V0EO6uZWUp27z0UH8HSdV0rRE8tPscfUoEuzYq?=
 =?us-ascii?Q?r7HvvGZmqJYaPTpthlGHcbnxJPl56OcNEfK/lUpwgOCovBqRgETSAVwMocVa?=
 =?us-ascii?Q?ErXCITbCWMf1l8ikOtQdbnCRENU+60OQR/jlLKhJIAZ1r05/44evb9oxIV2g?=
 =?us-ascii?Q?UTu2+D4fzDYqR0QBaMiYb8G8PxAarzrrJNkTf4c3EBGT1hdxOtsOcVt6sRFT?=
 =?us-ascii?Q?Hx5fqQrvyxW+CHJR8qxVDlJcSBDW1bzFA1VYHzgOE/EsdTlgbs7ZSCPLij09?=
 =?us-ascii?Q?Yb8P7nN6q4wMdvTqSqZPxzaVPkWsa9gjRvHDXDaCMOXIoTrVezQwaCLa5m6I?=
 =?us-ascii?Q?4MSWxxm1GMpzew85NmTLSsTBmCVm29gDUh3aHLj5O7C1tculBWKR5G2cJm4W?=
 =?us-ascii?Q?8TB6osI+UA6jEF4+7Yd8/NQX0ThWFYidczrYDYokuOWTOYU0eYtpChSBIChF?=
 =?us-ascii?Q?PrFIFFT7YAPhqskY1snCfHfBvuT9UOZKnbf1Xt3QCY5FOCY+3aacn9UxLXjc?=
 =?us-ascii?Q?uyId+dbDBKoTlbcyi6b6ahjGZ28h1Na2saBK8I+aXkYw+lLvBZz3oI/qHCGY?=
 =?us-ascii?Q?UNsXxsXFD+X56UDpoXgGAkAz6EzAm2y1fiYTbtmMz0uiHv0nrE5nmtnFuS5S?=
 =?us-ascii?Q?XS5eoiYVv09JzzuC7kfpJchiHxuAngpAhlN3RuSeBydV3daVwB2uLfxs3iqX?=
 =?us-ascii?Q?DXkVbK9yvC3E2V7ysaK2yQ4XJpnb4x5nSwn7mNTsw0lDahuHbk5ukHx23mx0?=
 =?us-ascii?Q?tSQPaWk9EIpV/AXa7ZYdrcJXhyhluCDFA1WjLNSKOkgwtm/4Yl1woWAsnbcA?=
 =?us-ascii?Q?LwCy8EV04789eM3UTgvCuUkBYxFA0VasbQtzu1qBVLB0sNANQzlVrKvGSsUr?=
 =?us-ascii?Q?TbaDVy5CSxpz2z/M4t1XZN5F0bx4oNFmZiqt7eCzlI9r/9JCnODEvN/E5c2u?=
 =?us-ascii?Q?q8y+jcZ9Rc9XzwqIZFUEsAEWvN+kVOgMp2A2rTHvhg8S68EGku/Wcx+pbtOJ?=
 =?us-ascii?Q?epNgJ7C3HHo1nAeubdtnYFDwY1DHs4qr6l8WZMnoSelCN7/tiG3qBTVRfMXi?=
 =?us-ascii?Q?CzrqZ/GEmOVAJ2Z2y70RUR1/WYDOk6N2JFZrr23Ert1W7Mhjp6zJMQo3Ne6U?=
 =?us-ascii?Q?bTYzYZl1GGCmnTindKkjx9lM3cU7181AoVmgcrI/TV90wiZNO2dQx+WznrVB?=
 =?us-ascii?Q?b4cyzZnlO9JaMgvdJnBFXUzmraK4GEO7DlQG5IwBtQxx3Dv5egiW5FIdajPt?=
 =?us-ascii?Q?gigJq0E3TZAkhG5/Z9oXuoN8+6V+U82wEz4FTUPVYHJREGQ5iEf3TiWwSuTr?=
 =?us-ascii?Q?HqKACNveVmAvORnSEkvYtlZZnUitpRRAxSd4msvvBnuyvIs9CS/t8Ebq0F7T?=
 =?us-ascii?Q?hXcKuGbiXp/oy3egmW4nvOabzNO1B2XziuuSsR1GIVvxHS8XZaZZRurKgfgc?=
 =?us-ascii?Q?w41OF5ldvR5HZjIaXTLnGyfdM0167UG5Gn/nzyibnatwleMzWzfyYgpWU7O9?=
 =?us-ascii?Q?gBt4gZsTps0YY2BapPV6S2jpB5w9WA2ZVq7k9vkSLkT1cF1+s3wwiIvSMLkD?=
 =?us-ascii?Q?FhkdLkrmlYEfNKBAKf9SLZ0mpgA9EYwUc8RSTZT1rk+FUHUkeqhS3Zu/8bnx?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16080e17-c1e2-458c-226a-08daa5684664
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:10.3433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWcEAvwaZ2V9bVU9fgzXIpa9vGd2cPO65pKYjyGKqfjgPdtmQNxHDeu2YIPHFeni504maosfF3h3qJyRWUcA9x7GJHoWq5HlT5upJ1hAPVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: rmiaHIkd29gOAjg37TPAkkFafsOn9GMH
X-Proofpoint-ORIG-GUID: rmiaHIkd29gOAjg37TPAkkFafsOn9GMH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a6b6c769dee9..cb07a887b40c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1723,6 +1723,16 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	int result;
 	u8 cmd[16] = { 0, };
 	u8 data[24] = { 0, };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	cmd[0] = PERSISTENT_RESERVE_OUT;
 	cmd[1] = sa;
@@ -1741,7 +1751,8 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 					.buf_len = sizeof(data),
 					.sshdr = &sshdr,
 					.timeout = SD_TIMEOUT,
-					.retries = sdkp->max_retries }));
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
-- 
2.25.1

