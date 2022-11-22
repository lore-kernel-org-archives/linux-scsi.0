Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C83AC43219
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 03:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbiKVDnW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 22:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKVDnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 22:43:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC892A71E
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 19:43:03 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM38jXC014952;
        Tue, 22 Nov 2022 03:40:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=05/a/ayaxdAesBD7mFQpxiGajrcmO9ecH5etfcHtJ7U=;
 b=snrmXwXCz7qb58bdnF8pr14q28sGG55QB72m8HMxPs5R8L1UUKU9TTocC92kq614iKSR
 fCRcvEvQM8C+0aHVBT4subIwrxFBfGeYz28TU/o+dKjRjOvwS37EwNwgHs14FupElLnV
 v0w+7DFPHY0iyGeghUiiWBW2DvscOSkwaC6+7zhOMyc41HS6QiGkM/D7J7O5H1IUO0K4
 YlQTMEPKbU7rP3UdaJBaimjLZW2SN1BCTkXQ9DXy1Vx61xvNf2dPa+iz8eDMc1ifphSO
 qgB8kXCB9GCrv1vChL1zhZUAXBlx7MM9bOgLusUk4ri5M/IxIAvc0yPzq1wWJ2bUr0yH Aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr2c58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AM30hLm002244;
        Tue, 22 Nov 2022 03:40:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkbgdu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 03:40:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIq8TEA8s406AFxYZfDsMkD/F5CPJcIafGiyjZ6DhxH8p2ra4pBVUrQMASM8YrTEDKxH14P4iNnauY4nSdIwhEadnQKAg401YvVdepink16QJYLQZd8codFL1/wyspiWxvZKGG31AsBAecv4TUYQMBWIvxRw3mHWPvCyVO4XqDO7Jw7YfR045SyLr6XF8vEbVdz3g23MvIQjDCtxJkAC73b9olWUnL0AXvwzWmyRPnzcBKmpud80L5kS1sIEfmyAaaOktli6Kn8X9UvZ43Q5gtwKkVBU/Oa4u2fbxbxXl61CNdcX3bWCOVlS+F5BKxOhrWVwS0+Yq8m4fUh/yE+dbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05/a/ayaxdAesBD7mFQpxiGajrcmO9ecH5etfcHtJ7U=;
 b=k/PC3CLXpzheGC6fiRVfpR6nyiJQ1SyCA1R8nFenln4hUrFHQ6rYCpODIRimC/psPyIReDlXfc0o0a3hC3sS/zGZcJ2rtcrz/qS2UaQ0dG551Z61nZOOTD+xINhrmH7E9Wzne+HlsXJHNyV74EaQ0QLzjH32tE9MAO5GfNKyMpLnTAdAfihvr+qYKJB6kX0yZV6kvsM9gGSDvaLoELDRNi8gHMlE2lCuEqIzxLsHdzZP0I/YP3AdzWev0zE9+2/TaEai5v8GNLSSeS55SzGf60716TNOiMukG257EINix7HZFkNA3hQesdCF0KtEZ92O5qZObNnjA+ODxBhzaerwfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05/a/ayaxdAesBD7mFQpxiGajrcmO9ecH5etfcHtJ7U=;
 b=t1USQsU/F+gcoBuPTOChQMj6y41GnSeHGEU2eS6RUGVdZdxGZofUoJU/S573KUgR1wHq9Hk75nQwyQQnUE8l4t6POziAtt9v3T+4I2Fy2H6gHhiAKXFIlsSXKP68q0+1X4Y66rfd3BESvJQc/CI2gJ+o8Sy2dMf/P5plPl9DxRU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB7055.namprd10.prod.outlook.com (2603:10b6:510:278::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 03:40:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 03:40:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 15/15] scsi: Remove scsi_execute functions
Date:   Mon, 21 Nov 2022 21:39:34 -0600
Message-Id: <20221122033934.33797-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221122033934.33797-1-michael.christie@oracle.com>
References: <20221122033934.33797-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:610:cc::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB7055:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e47c6a4-5df5-43aa-01fa-08dacc3b57ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uynVaQlHb3LuuDBkpNGt5QWcrdnbiSPnutT69+ipYmtn06y308P1XcqP6K8Ks4ola6cKJJ37vBEa47lTKIzQ4yzioYU/nazSdw51+hzV1fYf8fcZoLBWaiT0bhSL9GcCzWgRp6C+jTiLWDSdn4K/xPUHYJ6sR7aCsk8jW6ZGN1/ONmFFFPMEcbRBjLrX8Yp69oOtfX2+r2OMmx2jQn8MlEhYXiiJMbEE2tT/yDMpy7pxtGLPtpjtQv4yUkFeHJabHjx2B0ooOTLM4MPy3PH+7nTquDaXuexJ0HG1sS4RIevPutO9eDhrhBisPQ8t/xj9Ws5VgoNOIUd577GVHU2XRBaAca5MJWkX6q6UtHGC2WDjl5BCCsJ2ltUG3FOXEEXmNJnNEMEE/94IsN4z8AZBeAufhlf/Id3ghDIrA1bH9UmvzAbPPRu+C155vu7cwt+YUBrQQLpyZCaBQT5kvxO8Ne1h8acmeNQFw8CqlZSy/GSKlIdYHvEFdvi1Bj296CsqqnIiwj9rZW3bGr3HgNUic+3cHrBhpaiCUgCwX2FU76nf+aSS2dhReTD8yf4Np7wb/JynJsLeVbd6tvRnttApQ7hTumKUyDJ9S4jHfQKsOFMNEt23SD6/WiOiT0PaUc4F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(86362001)(5660300002)(478600001)(8936002)(2616005)(2906002)(1076003)(186003)(316002)(6666004)(4326008)(107886003)(6506007)(66946007)(66476007)(8676002)(66556008)(26005)(6512007)(38100700002)(41300700001)(36756003)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hHCPR8KrQ7ZAiRHtTlqH35RTrZ7OjIF+cI+m1CvEouZm/6avpPXQ7IB1+zzL?=
 =?us-ascii?Q?PGZJkmr732N64tmJTGGp7D+yR/YKrke/z6oTW7bqV7nDcjZJeNPtVE+vf3Qx?=
 =?us-ascii?Q?xqMLwBWXmq3f9Y17Ef6bHHwox5L6eb0sgJZeVG8wslhNSxrOHAuXQ8shA3+r?=
 =?us-ascii?Q?AINK+ZANzMBw5aYynldukquCwvaaIYGjY70r9gr5iCRR+aeBkMUPlchUSVj5?=
 =?us-ascii?Q?xy31bfhsvpYEBbxe80LBMVKepS61qpc6SX394F9Xq+koR/fHEPUGkb8OImqW?=
 =?us-ascii?Q?hZ+52JTLAY/nsSQXvaDhEAoHQbAGrGWGg3H2QSMHS+JLDr4BnK9QfFLx6Mla?=
 =?us-ascii?Q?1VK2gxa3uiQ8s9g69ywBIHsHBp6ghTDj2bvC/a0vhZ9Q0nIHLhNfeJDE80FI?=
 =?us-ascii?Q?dIQbzz5pYRvutKJ5GbvOInO/FRpzrSLWd/bbNdezBvsLGzdvjYJeOUAJwdTc?=
 =?us-ascii?Q?jP9p7EzMxicLehkAdo0GFNCj4c9RnxgSb7Re6K64b/wpq/1RSsBDMrKn11Uj?=
 =?us-ascii?Q?bD9Aq11yIHMNqm06HWY5L4nJzvWzeLa3xuTZU+0Iy2r7sEmBBaqjxTEwjI1c?=
 =?us-ascii?Q?Um0qD++uT71XygWmeFEAqRc6hX98csJYmHgpQsYgKf0z552HTR2L34IZbVlO?=
 =?us-ascii?Q?H7clElUYLN0ARM2zMrwf0vkSiUWzRrgEGscc3lNf82B9sTOIlXV1Izih9AFT?=
 =?us-ascii?Q?0fhsRUt/egUDSRRCPAYIGfOpJXsYDIiIFTnshEQAfQrawm+P/JLYAGLr/TWL?=
 =?us-ascii?Q?Me0uPC0If/0eZY3JR0PBrb50+IXTegJXEYpNfE2BQ2MIUCqfaBGZoUcZC7td?=
 =?us-ascii?Q?3Nm1/iyUEoyGdg+cOI/DcJJ0uZbkZHxWkcKEkKxNay6NTHTPr5dbNGJ0ylgz?=
 =?us-ascii?Q?XPBZAaVSysIPxhVTQhbd8UaUU7JHmzx3o19r5gzztNqG6Dq1HKKOGy9Xiy/A?=
 =?us-ascii?Q?yUAaPJKYgPknTIwF5RTFCrNEBjIyRUIV2x+kr43ms/IA8/fQUchHMnWtdvvZ?=
 =?us-ascii?Q?x9wMU0L813dF2QwN0ib/8+4hK32z+NZFkPAEg3sx4hwyzYn0dCORXmETSe+B?=
 =?us-ascii?Q?5F5Or76xDzj+JN8gTljGSYsiqh+rendufuXpH6VkOf82SPN8e3Y6TS/bhvM6?=
 =?us-ascii?Q?mz8CpkYECU4qunygU6gqOv/IOffUGLcI0a/tai0AHXEgxtun1vPmcdrUmoUZ?=
 =?us-ascii?Q?/WjYHvW6YoVa2gyt1GqDg8E7sFpuhsK60OViFJzsdJ3JB8ng7hZkeEhNbUqn?=
 =?us-ascii?Q?26MPg2r8Rqw4Pd9CMnslpndX7HgSTc0CuZs2+mLLNI6ySHU/vRPvUmfTYMX8?=
 =?us-ascii?Q?M20Dkgi3gmhhOXG2ObcESFRfe+OO2UO6fOkblN5gI5K76D5ilOLkXT7gl1IR?=
 =?us-ascii?Q?45rBwLRN8bttjv3D6rOkNxTbMANHZvzJ7RzAbT20K37844IgF1SS3b6o/CtP?=
 =?us-ascii?Q?vBd6TEEJpodEzbaMrCX1wZzycKgB+AEckB2KPNRVfzXMQaOMCJfEaVEHJX1q?=
 =?us-ascii?Q?242goIB2RE5blK0neDL5IHIhChr3DzlbENhUJsSYMi2MJeOTu+qADdkCx5SE?=
 =?us-ascii?Q?WNlMiNtbSA+Oa0COlzX5LNxOCU1rFY3JLXwpfL+UWZc7/86feAHFyTKI95cy?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0Mp9ekXwrQInf+U2zqp3QRzpqqsq6IPw4L0dt3TAvfbjpGDY5qsYlyCUI61tCQKaw4hHnKFwPjI24UexFw8DKGkETx7zfdOLwFB24DCionSTW1oZXEtsBH0ZWvORsIAGhL8TSEtAPi3ZCvDXaOCkscPFTNwSXnxK5yJqMwSFjwSdjL9CKepMC8OwitzBB++u3p3NBGMsMQ+EWToDzzvK6BoqyUimtdhjYXzJ8rJ7AKYWFaacIq1fRtiC0XyvtRom7XwjSUYCzyppZqNCohMa5s2OVSF+sZMPW61o0ns2C+1BhLPH415pxepgp3wPs7jOVq0STMgvV6XdUUvyabTdsj3U558VhMQZk1gg0k1zyp0gk5jreZLA4nKD4LKGV/va9a30Ec9ZY8YMcxTgFAU6dsnvgwy8jEqXXr3lsyBiR32nCViyCdwyGzJH+Jy7REHBdWDXB7U5kkHqNaBvHZfseeQshnuJZirOVax1n16m2hVEKOePY/fj71/EElfeMt/Q8vlPCoNiOInlL03srzsuSO+iBBExySxJ9yKRsultr1+O2HgtqhFOeAJOz8YG4NzempTxRMOnAqHmaje84o1y63mnsFZteFu//biKKY7C01MgCTL+5PBmE6hNQduJAzROnPl8MGN5GDVIRXE3GZNS/AnfehRcpHfn/HLoFpL9EU54wXI8AayOpkueu/eWwlLh9HSmH/u2lleDBpl76dGkAkOBu+ijrVEf3QzYZResYdRs9G/QvA4BKLEpUjkedUXeXZs9cITdJUY/0zVZYVX9kMdIoCfPfelNch9yVJjGkei9N2tyRapxKQsfWKbms+1+/3Wfs9dcpP0VhIRz1ssAgARCASC7gKm5HVhSGDinrd2poJ8GboAuThLOzVwvRB1P
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e47c6a4-5df5-43aa-01fa-08dacc3b57ca
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 03:40:47.5433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cQQBT3RF7AoTk3bTiEJcYFInWm8vq+mXHlhmXSc5lu5MXT0UQntiO7K94eCrzsEuMP2XEImFkzussjBiylR4WxHgZn9QCaefk1iE9YqcvBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220024
X-Proofpoint-GUID: mWWPiDc4ER0N0CRpD8SNBGvKEFOUckpZ
X-Proofpoint-ORIG-GUID: mWWPiDc4ER0N0CRpD8SNBGvKEFOUckpZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_execute* functions are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 include/scsi/scsi_device.h | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 578f344e330d..3de7cbe95bdc 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -479,37 +479,6 @@ int __scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 			   retries, &args);				\
 })
 
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	BUILD_BUG_ON((_sense) != NULL &&				\
-		     sizeof(_sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
-			   REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
-			   _buffer, _bufflen, _timeout, _retries,	\
-			   &((struct scsi_exec_args) {			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.req_flags = _rq_flags & RQF_PM  ?	\
-						BLK_MQ_REQ_PM : 0,	\
-				.resid = _resid, }));			\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return __scsi_execute_cmd(sdev, cmd,
-				  data_direction == DMA_TO_DEVICE ?
-				  REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
-				  bufflen, timeout, retries,
-				  &(struct scsi_exec_args) {
-					.sshdr = sshdr,
-					.resid = resid });
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

