Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53AFEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243172AbjFNHWf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbjFNHVd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569532684
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6k8sa021635;
        Wed, 14 Jun 2023 07:17:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=l+LAZLw2B146/70d4zJpiJ6GsKQLGaWNOGvccXc64js=;
 b=UVWx2xl2Tfd5XUrYzF+ruGwkZsqRgreZOsss/JFTiTBibLsCAHiW+rvfYwrxp+yU8Kmv
 TBvjO3H5OCH6aeQam/hpKIRMiQx6UeL8A/GBTZdHRsU8uE1txFDecFZO+FXpmogTE1aV
 /r8FextW2ogvkLw6upT/z54Xj8v2ImNk4rt2QHCOClypW1HqRPMqM8PSGMwWifaJN6v9
 JUqwekTunYmgOWOkGwJpjN0rsahL5rN0JWL5sLsIpccWVrCyuYaoW2ev2y0IxH1nrW8Z
 rh8yuZC0a8d/247Rk4INnALBOCVTqMeGKBP/P3Q52sHmdl7Grptx/X7UhuaGIoMQi5Lm eQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3evqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5sv8b016309;
        Wed, 14 Jun 2023 07:17:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56pph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWI59ULi2yNfoqJ1Q6l6uFsenkE7rrwDdAJ4dT59Lvm48nODeBxsYrGlHFEx2JbgEtLBWnjVZW3zpx+e+GZn3fXGp6IjKGTtB6hgWWH+3UtBCZ9qN9o13nDzUXRq0fOD7U5a9DfpyuHOK03atak2D5RBvCayKm5J0PkHR1NBjY238t4BkxD+QVcV3iwMiDrxJhozT3Fiy+2kf4t3zDcE+cTJp3AtJZzjXkSjAxBcX/KdL3aw1EHzJo4L/gaQvcGQqFDmABN1oPdIPwGUQ+WiGS084iE93u+FBe58xuKBouAlwLn6oyZky7T6BZyBuuDsz/8P5MiBfR5BzPu4WY5Gpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+LAZLw2B146/70d4zJpiJ6GsKQLGaWNOGvccXc64js=;
 b=JOfwTznSHCRhMKfn7MByaJir5+hdIhd+VyGHNEh1bIESl5Pbz0mgofWDslIcSqQr92EcXlqS/HxDM7tgoylczlPLs1sMYZJT8wL7wZXKXC71Hkt98PO5QCJviyFT1t6FjuVSUgkNcC6K6GAa6KCdEZxkfVmP0W7GFs+oqKVdJ/UiwkvzgGnndGHYnASMLHJrQ52CdtxOw/W7vWMtxyT7EjAwuDFV5lueSwAAYs2gKJPjFf914mVSLB7/BWkvNHtGpXdQhD3Hno0QJ7O4yiR0bXgM3QbHhycYY3vE8zWCnvfSZ7yPP4W++FPuXEoud8848golIcXsVjEg1bSK73EvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+LAZLw2B146/70d4zJpiJ6GsKQLGaWNOGvccXc64js=;
 b=hdCjPcRP/hhLQae9nehfvdeBbzH4hW6baQBzT6WLgUZCA1g4QmKoig/AjXuvTYqvkuBU8Zi746cGcoMvYFYIDalRSdZogyO0xETNrU4gUouFGgAfSjKltdDB0Df/Wc8ZAuqoedhkkJjOEbnptBFZYIsC5XZzCQ+ldDEaeCVzkAM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4188.namprd10.prod.outlook.com (2603:10b6:5:21b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:55 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 19/33] scsi: ch: Remove unit_attention
Date:   Wed, 14 Jun 2023 02:17:05 -0500
Message-Id: <20230614071719.6372-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::23)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4188:EE_
X-MS-Office365-Filtering-Correlation-Id: 0245ed95-fd2f-4c26-a862-08db6ca77910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2GmHFjnmDkovca2YtY28dzv4fZKrq8e39MKJ4BRPGOVm3MP97apo4+l70fmAJFhxMu1+3q7iYJh0V+KrOe9JiIB4hrXpR8ixLBJpMvYFQKlONAHgpfeyq0/gHHkUCIlkPGgyEGOLeDtwCNzfvYaq145JZ32lU7893iTt3DhswDUaBGKQUGuy0aR4o8Qae1mvfbsd1JmkS89QSSasML2sccChhZVY6k+5xiIpK4ZYfSdtvF0EcThGwBa2zBtuexcyrz/KhFdDgYSvR8FZ6kzh9Cry6wxVvI99Zb+uSagHZ3AAPbI/AZwH+O2RzNT8QJ0aRSkGWrwHhx830rq9Buxq6L0MPYHe6c3Y0ameuNrpZPm4PsM5N0TIz8CI8P3x39tQJu9Z1YoyXTcloLANdLuVpSAwNaC7gaCMmUj/gln7e8eb+p2YALiuBtKRinnFbNAHehah/8QGCX8vl/8tolOZ9z04VYxifiiVkpHXBWcX2wl1DvuF43lWjevptFbH+I0oMNH+bKmXg6bZCR9z8kWfd5hQO+P3ZderAY/7COzccreq4QalD5vWdjFeYOGupLJ3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(39860400002)(136003)(376002)(396003)(451199021)(2616005)(83380400001)(86362001)(36756003)(38100700002)(478600001)(6486002)(6666004)(8936002)(8676002)(2906002)(4744005)(4326008)(5660300002)(66946007)(66476007)(66556008)(316002)(186003)(41300700001)(107886003)(6512007)(26005)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IuvJF8MdpRiQ8sfrIX7+vmQw28cu5wFmfQXAYzekrliCY99CGxZEtxN/15/0?=
 =?us-ascii?Q?Qi8w/ns5rich6X5tf9vkJPMZghXS8firRMDdxae03AlZX+Mk0x+iHTxOadSR?=
 =?us-ascii?Q?P2KYaUbYMIyxjo86vMvfUd+t4S+adE6Tj0dyY32tpt702XsKg35ag3UwEvPg?=
 =?us-ascii?Q?qhbLnq+fdBaMFEvok1xN1cnbwolCnB9eliO9lj2YkP3p0fXPLZx02mBFKh7N?=
 =?us-ascii?Q?NKOXYrpJGK4HtwVJOa0LSLV/cp4kR2bcfmxDCnKCEH2dOp8Bxk4f6JInbOoG?=
 =?us-ascii?Q?DNCBMMOwiseihMMdC131Qb4O77daDVFGxca9PHpb4EGEppQCyoe+XAIl/Dy7?=
 =?us-ascii?Q?/teG/+1YTfSdWTaZvtAg706pWBNMD9g+cq+GzAuJa/k3npzw2JPBKd2w6AKs?=
 =?us-ascii?Q?GwbqRLT+FeHLuBbqSFN8WOrBhO4AbzluP+0PwJV0DdQ/xwcBEptzYPKkHn+w?=
 =?us-ascii?Q?/VLAKD/o/UkuqfVNfxmYQ+frkJYXRoXi9qPpSNuf2ErxMqOwXKHslT8vg8Ko?=
 =?us-ascii?Q?gytMCh44NGx6lXCNFs6tCKQSro8b2+lwPyVjraMJTnBi+D3Im9JdvxlGq2ZQ?=
 =?us-ascii?Q?iVdpnI3uZJFcJW5I18XZSUOljd0k4pACv0IDemkFQKqbSuWg5Jae9ysWMJIw?=
 =?us-ascii?Q?9IDDyL1jbhtqTtb54g2AkQUxibZ2NZ3dqaDbMmVyjVTkBCDezjhEcTu0RtUY?=
 =?us-ascii?Q?u8QD1t47sr+shNP2BuYijqGhMV5XSjIHZYuB2nZq3noeCYyVdfnTJ8//CZ7z?=
 =?us-ascii?Q?DnIrg4wmfb3aKsJSvKmboNEoP/F1urUcj3+XCs62ZhXPmLh0uJmkleOlyNYq?=
 =?us-ascii?Q?7A5jK8VjGDZ0IghUZnJzH53QFA3RALr6l9UdEZ1QJuSRE+oOpBH4SHZZ5P1x?=
 =?us-ascii?Q?z3IKbKu0BYrDkA2AfJJwOGHodz2nK0MymCJhKY01TRoJwDIe0/UXZrnqll5Y?=
 =?us-ascii?Q?NRLHUCkW/IqLwSA/eQwYx+sZ2YdGWR9auYK4bloAF7EGgh/1KmHB0V7NmRfm?=
 =?us-ascii?Q?Ep1LRJjYiXGEbnnZyCB/0U5KjK+M5fEbvxpqsSCpKiDKY90MMfYGGFIMek2U?=
 =?us-ascii?Q?EHlljcy8ryA0fG/nybMH8XMoF13v+W7+l34qrlu1XXKRic5gQWhN4iObPsGV?=
 =?us-ascii?Q?T4jluRS7DXbB5MFSAasxqoSTyHix6S7wuq85o5xZuTXWuhi/rxfDL8ky78G8?=
 =?us-ascii?Q?MXqDLPnH2+MNZfO87dCcg1YPdge4AgNZtKGppcjoAx9Hh+Y2HoQN0yKNSAnQ?=
 =?us-ascii?Q?3A7C+GSgPh9U0dJD+CLTjLP6zG5fmE6gDkFTBGDQJJzQ7xAZhlnIL312P27p?=
 =?us-ascii?Q?MxO1GPH0HzUeRVC+YZgZx8MJab0ISncHNU5V6cbiK1S/2YcOHUMzdSs3t/Zk?=
 =?us-ascii?Q?HkgUqxU79MAz1MijnmmUHJZZBtk2UFJkixV15KkszVlORzFQ7STSop1HhnSW?=
 =?us-ascii?Q?O2Nd7z68OmapYPtumR3Z7gcFuVJI5k9nwg7Y5359YR0oz8eaxkezdt3K3s6k?=
 =?us-ascii?Q?d7Qx/NYijLOqM77Sc+J6l2hXQvlXAh/M/b2bu/lu36BdaQCWaRzTQ7wGJrnA?=
 =?us-ascii?Q?qQ67h8aBtzl+F4MXUE7w2h+BHT+B1koY4xZ/ie+pE9GNwyaHL2IcaG6yd3Lw?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: giXD7k1VIhEm5YIhLdXWyI02xXHDNDBV02scRXurY/JXd0R+ecH7adiYL/Sth2Z6jiM+STRds0oRSQrWVm6n++8rODjmCEaEx0c/IrhOdZgSWfkWyzCjtB3HkS21jGx8FjXmFDTNFULYSPknXxmtpktOoUou2d8JfFczgvjlHr+Q40Xg45qNV18AmhX2ynHx9V3euU/LAMIamU4eMwPRM/RnokGndq2ODNMNmKnfnUzPxrfrMrNeq/oaesiRyrKs6qP17SLZRz9QkElOZZ226qmRpso1A077z31O5pa6p1nbbO+vbKkrOMtcXmrbsuMPIsqoC7ZiMZo5ZNvipFkkLkBOo3GrY7DIf3Yy1bGZ6msiQQdeZEaytn44B+KBlU4KemGmO/VQ3qEfJt7KYoNbLqzlvTBsDLjlGZ9FGBLDnsLHN2gc8dLko8ejs8ZkvavmhnM9qikiuBnuDEqV95O8PSvE6i3AwYhy4GGhPofyTgV2xpCM1PesfZsji7tuDcjc3wsL8ExCWsBMAXs8UwNe+EAtuHrmrDVtWQg7vyMCmobaKdKxjZJv+Y6FwcmMDWR24VU8jHMXQRFeF00R6aUtu9y9ThY0+fAB0O6hrSIzk4eiF2ydfGkTb25moyBwxQSMson/dYXCUISbD+cvDYYFZJz1vXA353Rw29YrXV197WCltx4Fvd737GGtOhwUHeD4zOJhYLYvgkpyBvi25yRgo0DrbDdwcnH6QGh5FrqPnvZK377EN13C8Oroft4IrU8nMoCfCXqqQ+4XuFkxzDYNYLw0UsdHae4edTUMdDJbkfW6QUtCOv/sjE5N8e0bMuwhsNyTKYs6je5gv7dA4jx48j4RQ6YUI4kZufpRD88/Zh5t8b6ZMXS6efK0hxAM6yHW
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0245ed95-fd2f-4c26-a862-08db6ca77910
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:55.0584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLX98Hz92vE7yKs2QQVFIXAd86hTOGLYE8yPi6cQaTH8FHTiwcBpSPaqQcWWoDZmDFCTMYkuoK0RJJFNBEO1vDK3Isq9gqhDyCXdc3aBnTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4188
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-GUID: PZgMn3xvKhxRmSP-S-zodCyIkWkRaFwW
X-Proofpoint-ORIG-GUID: PZgMn3xvKhxRmSP-S-zodCyIkWkRaFwW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index ac648bb8f7e7..ff4a81a1b056 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -208,7 +207,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
 		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
 			if (retries++ < 3)
 				goto retry;
 			break;
-- 
2.25.1

