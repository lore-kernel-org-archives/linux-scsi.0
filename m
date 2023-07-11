Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ACE8EB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjGKVrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjGKVrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:47:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F1A1716
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:47:06 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BICvOx032137;
        Tue, 11 Jul 2023 21:46:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=i74eLM0gYYLfBKQ58eUwPhldoNfeqtnqzPMiKTZMjK4=;
 b=Ppw1HYgNrXHuBDZeTdywTH1knluNZWxzwP827eUsksFWs4Alkujq3KOJIhD9VdAqEg6+
 KB3WDQBsjo56PjmDpfa5Ke+ob0EjG7RCjEGKFhv+7psdyFGxpGALmgqgCuOsVGk6Oa5e
 w59Q40S7UxKpRI/MQbzNQQSYAysIHgMYSg40kAPS1DD4BUmUjh12iowMKrC/FuGDxFQy
 rZq593VK17/icpUQma++W8DMlHRmMLoIbCT41IAjozhMge9+/jGRSI2vzJX6wZjpQyVi
 xSsYg54wqSReUVjmWbwFygv826hobxKmvVzNuplvAuvpJ/dURnUrWkAIAn+3OZ4SvWi5 9w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rpyud647t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJwMMl033310;
        Tue, 11 Jul 2023 21:46:51 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx860yxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:46:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CK0lpeEY+JYI3i/5jGl7OLwEsWygzBt6Q/OqZfaR9ockclm489xhar+o44kFbxuhCycNmNntDYBjjzQYJ5wSpU3eUEmHuwBDobdQXuKD0T34eEDYb82JgR1G4o+FlWlTVvdUlcGX9XjEDd5xDJU50rcJztGj5B7Ixz6QRyjrvTF4unpHCiw/rX1J/WSMhL1+mHLUEm43UV2o3PzjZ5zZWDvQRPhk73EzEda+pBRM9Mxfv2Hiy2u3YXD7fXsQmBdt89YpzT70Smo+4YSoWKnIH9wgrRn4i+4e8B5GWasCc/zRmsTzqZY+cb48H2nZ79yP5gG5mqDbn1JMGhXGvWYxCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i74eLM0gYYLfBKQ58eUwPhldoNfeqtnqzPMiKTZMjK4=;
 b=QuNANUk7Ey77jNBQKuOsd63UI5CImvFj5hv0SVlBop3srzTkyJ6uNF48PW4U8dPQ9qFgoK4a4ndO8mjPIfAKEPm6UOi6ydmcWK+0L9vNh4d8diCxVVT10x5UBpApLuTlFwz4v9AHgsCZm3EzT+lVLnckvP4UxRfOvSJQEcDS4jNuUo+jVWWKeFfXFB7/8Zg9DmlaTY50sWMkjUkiUPwng3BhGEoLdNjXEgswKyHEPKCooNCRiff8hftcyEYRLkXmyJyiJG1mqbqme6jU00C6y3OfZCmXMFCZF2hRMlzvcMUZbEM0VHnNMrwXsxwaGkhKPJlyiqfTA95tBDqIydmCrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i74eLM0gYYLfBKQ58eUwPhldoNfeqtnqzPMiKTZMjK4=;
 b=lEKipLjH4VFe5EARhIe0TjtEfjvtvBDfHtehkyOxDhIRvWTPAFEQducHkB8xkiAD8Jryb/w6d7b7dn9vXdtcAy+S7PkwZFloeQxi/0LNlFpI9f+D5TnT9f0O+zHFp2IaYKB3OJG4hlFmzgbNDnknaZQEUzneZZvnRTf/ndFAU/E=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CO1PR10MB4450.namprd10.prod.outlook.com (2603:10b6:303:93::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Tue, 11 Jul
 2023 21:46:48 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:46:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v9 11/33] scsi: hp_sw: Only access sshdr if res > 0
Date:   Tue, 11 Jul 2023 16:45:58 -0500
Message-Id: <20230711214620.87232-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
References: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0060.namprd02.prod.outlook.com
 (2603:10b6:5:177::37) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CO1PR10MB4450:EE_
X-MS-Office365-Filtering-Correlation-Id: 86851303-a1c1-4c06-1eed-08db825853f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLBSvyDtxvcI/pTcpaCxPisS9jlytYedO5kVgMhSUxdlOMVVlsSpdpE6UQQmfxAxNqQzRYk/5pAvUjBu+0KmOJ/+adRWnXJcxviCFZjcAo2VI8+RTltJ87whnGc3DEw3imJnDaSI3WM6f7aUFE9mytqL3/v2UeBl0Rs3qepOoRSAfweSb+2TBdvULwSbjb7KvzN3GJarxDvNyk5BaMYtlLv1LyeE3Az3q5m9KYAmngWYMH6YmsLT8OrKv3kXJxvkI2tK5cJbpuh5dzC6GOexOvihvf5KrdlvXgBe9IURH+EDK7wiBEjN9pV+sXnpBpPQ2+piFiQuMCKtkRMiGvpvPcbxVzEybbGTWn8OEL6SlcPYHTZAwfsYgZAeXaGAZPoCUXn3jyEObkGew2tJITnQ+qSO/3VPBMyPFaFYs3t8cSA43GG+6cbe6PvY8U12N+TO0Dg2xjYEubgB3j9QwYM4cJE9jbZj0O8hBoYW378X0G45+d1wRFGngXtNj49boPtbrVnVvjdMlNHv4ugHWX47kb5fRT/MR4y+giOueOpVIjoJtpfYn1X0+gxUDIgbiPlH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(83380400001)(2616005)(38100700002)(36756003)(86362001)(478600001)(186003)(26005)(1076003)(6512007)(6486002)(6666004)(5660300002)(8936002)(66946007)(66556008)(66476007)(8676002)(2906002)(41300700001)(4326008)(316002)(107886003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XREaHYDz2MDpJSrdP3SmhWx59xmxr8APxNh4RT8PzyAuB5QWVdjOlTY7xtNC?=
 =?us-ascii?Q?dzxG2t8rdg3wK07qaE++cSZc2o8xjFIk57bCsz9hrrQoOBOaweQfRdgU9/4G?=
 =?us-ascii?Q?6/0f5Joy/mxTg/aTDQFA+XzH1DfJcwoUgt3+yInp+APUsKNz9kVfBzCSexsm?=
 =?us-ascii?Q?s4HzSVIjfc3/DJY9mOT+UFXtE1pg4mgdWnIfZFIJPd5u7RlAGcVKhzkFvVu6?=
 =?us-ascii?Q?i9idShwd5MuoPEYmVseduUDDYZkbHHYuVIzltxLWHV2O401u93NI5AAHzBaV?=
 =?us-ascii?Q?zqQyZqDpVN0dYrFMbOeWyPqrqj2L+Xc5TWMEh6X2ESWT8VJwYqAGaYRHjsNr?=
 =?us-ascii?Q?JIOV6ISOeCpDTt8cqsEdyZSMUs1btOICjEYguyEGnRt8Ck+DMCMcnqUt0v7u?=
 =?us-ascii?Q?b5Ys4HD8k0vQsyLNynCYbx/ve45QDkbxnD1ZCAVvQa0y3EP9DNAJNmLgXsCq?=
 =?us-ascii?Q?GGD+Cs2r95gFVKMKoU89DJgmY/kZ/TIWnbZvhjrGnXmwK/M5aA6uYCLlQhmB?=
 =?us-ascii?Q?iXkKM4pMODiOZORArKirTRc5ecECmNU//MA55tZthVfIqw7qAqDGb81A6kLT?=
 =?us-ascii?Q?hvluFWJcEbzRBnuV7N4Ck8TwZAecU6Qjf/t2oQVWY3flKSIzu8k71nvzzsLC?=
 =?us-ascii?Q?TLfYl1tPhgCoXaTq/nevkXtmcOCoYEA6ObMcSw+2pRscQB/tGGQaCjZsEOwj?=
 =?us-ascii?Q?32wQnv/chDE12lS1xakbN8lce8b9+bFSlp4hCW4i9JKC+5kmttEcDTWRd2up?=
 =?us-ascii?Q?+RgYbZDvEkp9oIizHng26xeO0vx6TRkXRKpmWhQDxfNXUqTka0Pn3gN+ELvD?=
 =?us-ascii?Q?ZX6NYzUN5j+gwPLx22ccRFdXfbr0xmQKe7Am9M3B25lMrKdwNon8l+C5c3aY?=
 =?us-ascii?Q?WOG/xYrSDtazBZxHdMDLnLJEjYi+AQQM4f/QVvg+0B/tdE4hnLqvr+xLjucX?=
 =?us-ascii?Q?Wtz0LkDmMfiHzQgtuixCVFRk1Z7KhDtw2Mb7E2IKbXJxMxUGmkD27X6/yCPk?=
 =?us-ascii?Q?gUQH7GusT75gynl4NL8MiblGg8qLrE63a1xuzpVP7Xlzf0YQJcB5BJyukxmK?=
 =?us-ascii?Q?HJkTRcM10PjyvlFuAZPXM+GqqnGUiyUWJuyuSup9DS1Un9+wJkaoGN4tH81+?=
 =?us-ascii?Q?0C6H2+OXn1zoJ9n29VsJzilSYPf8cRTbFtKjJGLoPQeBSyqf1FPmpQdNveMp?=
 =?us-ascii?Q?TE44FA6+e6rzH/UoIe6y3SGJIYUMX+FV9vuqc8Zox8dOOb7EHPFWOcF6+ZbI?=
 =?us-ascii?Q?X5bnHHrFShbC47A7WsIEjjtArtUZfmc9st6Q9yJea3/kvmYuOg8tvfxtI1Md?=
 =?us-ascii?Q?nXU5gwaFZEhNmPU2ArxNWdUtJXO+hTjIkVXDAQhN7pVFblq35UFpmWZBdrpb?=
 =?us-ascii?Q?St6dz22lYtbMeH3CR1iyZTiW6hTddZsFwmzONEs91RN60Yvj5ssuBngmAaos?=
 =?us-ascii?Q?6ID7tKOx4rHLO+xAY1thJ06PJilQzIBWKihnUaWjsLVS3ygrEw2LozumBUKw?=
 =?us-ascii?Q?eBHXrPbad7kmPIOT5UHxArIyHiw+/ZIF0MQluCyNxp+heAJiSBGF0j5oLOyI?=
 =?us-ascii?Q?cvmvHySZRUIeU7bmGV736SZ0LdHb37aLFqSG9OK1afOjEAq3hUNt1X7YusFD?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NIf96fYmGcuQBCoe4ToJPHRKZAJMoy8SosM4Yrz6fMgOPK8gS69gzPcf8BdTo1lqQbZP2WEK4QG53DK+4JELhke7XV3gstRNfOu5N4+3Ebruu4jRrSO4UADrHITTiQZNZyf1hBE51EYByRNxYQCR04YBXj9x4Mw4+AfSkv42uh2UN0aod7IqB68i3s+1U3IjZ2VqH4Gpj0/TlxZWujmW0B5TDcvHOdN96B12HZVuBgRDz9fk5cvgnVgWjzJlEQdO+4NbOG2LpzmAVR5xuwXwp301m5MSXgmLzX7o404TR4YcxtmJ3zZbTq7Rxe5Y1z+DhgpvgmB0kgKRBBAzzG+mQOJC36VsiTD6bfZ+X7IYuBTdiKW8Ycjv5Vlb3AzdeV+hVrKXZccDAtlIo7XyYRAyE2Bqt34pxW04coawxLL89HTbyU9eZa1g5vLd75J44lfvpVrL+ocLt6la8E5nCZPvTBXaE66a31S2SKULrNNL/WYInpYpQ1bigMvqnXBcym8s5dFgvjjrggpcGLRbaYHudJu/AE7aKoP17SC1doCAp9+D/PZ7/VhF38wbxM90tBCBCVkBxlmhfUIllRZvXCHFMQ93oT+iSErafeLfg+jsnSI9yBajG0NeAGyyc2bgzd0Nz9xxJPp0cV2XkEl/w+QLh3Uz/3g92x7bygmJ2Siy+gUExsz6bWRRXMh0ccxXOCuQxd0jTxii0VHTDKHC6EsxIm2wJaA7UAKlTxSHtJnFz/3iwggPuV2GrtT18nLBmcGJzm6q5e33E3h2hvxN67ZFq/QX3IgmhrW70ldYjLzmBqGgv2UBoVc3y5krjHcetbOFdywHBdgSwVe10CJgJFi73NCID5JQ675V7vjtihrInDhZ8DRSgvtzu6l/b1OFoDic
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86851303-a1c1-4c06-1eed-08db825853f0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:46:48.1729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KsFgSmaEi82sVdxYwdJT/sz8/3lqlI1UItTBoXNlhsUWmBAhgsrJyLELM+yIKSELWXPlX7YMn3w78SnOPVMwCMwvpPuvkhTt+wXLWt6QtS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4450
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110198
X-Proofpoint-ORIG-GUID: GvZgskLgeya3SDaxeDMGX-IkCEXMnpGG
X-Proofpoint-GUID: GvZgskLgeya3SDaxeDMGX-IkCEXMnpGG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..785ab2c5391f 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -93,7 +93,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
-		if (scsi_sense_valid(&sshdr))
+		if (res > 0 && scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
 		else {
 			sdev_printk(KERN_WARNING, sdev,
@@ -134,7 +134,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
-		if (!scsi_sense_valid(&sshdr)) {
+		if (res < 0 || !scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending start_stop_unit failed, "
 				    "no sense available\n", HP_SW_NAME);
-- 
2.34.1

