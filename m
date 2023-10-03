Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C4DE8FDB6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbjJCUvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241090AbjJCUve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:51:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B83AC
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:51:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4MKe027071;
        Tue, 3 Oct 2023 20:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=J4S2m+rt17+Z1FtntH0/aTzUZMtsLRWxZpcvrDq38no=;
 b=si9SUGiznx+3feXSiFp6Ml9s0GLcz9DthViJQKuUP5oQAtdPrHDNGLOY3wIi7v6YD3bD
 Q6vDtA5mWK+/57MRyXBMzTXRTvTCh6C3yRA3pJkYMy7ew5EBqoZHuC4+qsfiqiNDF5j1
 xCBxcBY8EyZhwabYQfBK7QA02HMRC+jpdGxqD1cLUP+rUMExVwl3hFXqoqmLUWdvAKtC
 SVsHjjyUAoBT3cXo0thROcXT7vsBVH1f+9lu4qZJ0KSyOA3MZ5g3SjSN2Xb1CNOsNw9F
 HzcaAb4mxhZTsghDTf79BO8OAEnSWs/RlANKhloovu6RWWz5uG9sewcBcKhncoj3MCi2 7A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teaf45r6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K1iq1003023;
        Tue, 3 Oct 2023 20:51:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46kvhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOvG5TnBrawaljkbgLbWmn9KRsACkmD5n1kfRzlnIo2gxvPEJ/ODMsEeZLVAb7ELkriOgkU/mAgAxx8/8WTbYgUpkwkHcYbTNnkG68z2dUFMUl0vfEtpTRvIwVbwuCPL6RqD5T4ul7+F9UNMFS514SuV70OQHeZluO+byZnPf2X2XKERQhO+9DIpePfA0u/wxh14wIZPzO5DXBHJ5vN63bYpOZ1ic0nh9MDCNnMT/gHeUH1vfkzlkfZOckGQw/YoE7gk9QrJrMrIXt+km4MyL2hJ805NaHyDv7M/aVOFsSZxtd9EDqo6d5HzSBGUrHOtKxIioykzQPDimlWaI5BD6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4S2m+rt17+Z1FtntH0/aTzUZMtsLRWxZpcvrDq38no=;
 b=ENGcvNRInA2X2BVBniRcL2GVxz4Ub2Px0fCnENzXGmSu4tvaJemRNAHaJCo6rdQHCsOooeUfHsPxmI90w3jlZUNfmulJsZgXCdI5OAoUPafYNW228ZZi01mOGONV0nkwCDfO029czUDLeJgfjc3DYZa8t+XhWauIS8nTIyYAH5fwC6r3oBV20gXP/TEvSxgfnjtol5VExg9GH+yzaw5qttt8DRSz+a+PmL0hYi1cfGLfz7ldwE8RB9CoWd/NoMqpgGhgSC1XQBtGtmAyTA5LywpE7TmNWB9XNnueKHHzp56JYOoawAjq6NFm3hcW8FF0TmZ9lgtMAKyquR8bcMxxEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4S2m+rt17+Z1FtntH0/aTzUZMtsLRWxZpcvrDq38no=;
 b=AulvUH0vqNARKQeJfZyIn5pQkxHwx1DlNIQOqcQ/vBllmT503sJw58WWQtKmnUaMgS/agjm+XyUf2LlQwMKpfrhLC1PytApN3N2GDRKLBk9GsnKiv6R/C3e2GIHVRn24jEdIA7tmpc3lRcHYEdUPjh5NgjU7XR4GG4Bwq4sc4XY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:20 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 11/12] scsi: sd: Fix sshdr use in cache_type_store
Date:   Tue,  3 Oct 2023 15:50:53 -0500
Message-Id: <20231003205054.84507-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 68a0ce00-0b85-47d5-d2d0-08dbc4527ef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MXVvIKSMsLD51XuJpDsojZWIy8V1obCcsOgELSFMFqjdQfQ0tahs85ApZ1bvvdlm8rTWIt8vqw5FBd8WuEPcdTgz1D6sa26hrksEet1imoQT3q2tNdAMLRi8Qzhge9vHJMDMQKncGs/TmsDVw7HagdUSlW5I/7RRUGFxkeJ083wp6cWfPrwHPnX78xaBKDGaLY94miU28c6GrGhGALapKVI7T/ianU9yadEZxCmrOQrz/YwZxZKbjKAHPHSDv3I5n9jHZ+hMYz2rPq2Yq9BfOVIFiC85ezU6gUkK/GOgUwmpzFVInJsp5ARuMU2YJeCaXAJulNgm6RHaMtPtAOMjddkALhUJQ3LoMqMni5XWKNWfi5rDWA5RFx3ZJyDSFqnw7qgd6DuO79LWq0IaAC11c1vYKfWOrmeigqJpZDggtr6/mjdh/quSMORPcvBgUmBr6TY+QF/ssnr3XTYihxhwtU0wwoNPYvY6QZvOat07ilouYfVP7kFM1PcJbDiGog2HphmxgyLV2xQePNEe6WwO3Rw8AVd6GZG4/K7sGSYCn5T62+WsvEGxi4TH+1MNe6x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?57dojrOq23kToNwLgS0L6py1OXEnfX9xAeCGZK6YMUN0uR58lged3tUbzdgC?=
 =?us-ascii?Q?LVuByBYiuk3PtMxgRoUz2tIajil+DLMiQiTfVVvbU/uwjzJ8m33tHnWxz393?=
 =?us-ascii?Q?n7K885KIefpWhTRSojLyaPOD8e29qRgwSAoQTzar0qwH9jjE5YqlNL4AzsFc?=
 =?us-ascii?Q?IeCxTyGnBJhGViEmFlBPf4lh23ISNFsjroQheSXTukKYm8bkiD5ULgQfh1H+?=
 =?us-ascii?Q?KPa2jsk4RsftONFhpPIyFPOq2Ah9RCQwIpkuYXlZhDocTvh5o9SymqrI5qM/?=
 =?us-ascii?Q?LR/5Yrahnsbduv1YHT8U2FDwnpHdHypvY6RQlBEJvcIZ9CSu7oB5xXUG2W5T?=
 =?us-ascii?Q?PIbl9l2dHe8SJRHTWW2PouRJmC1D0N9Dl5VkpPoWpo7IpzS20x5FNyGon4HN?=
 =?us-ascii?Q?Ylh4x8oRVXsZS+v2YaNZHTCb0q+ce8SowqjKpJwRde4wGNE1Jo6Sd+UIDOmt?=
 =?us-ascii?Q?lEffHvTTdf6OM3eDUBmKq0F4KFbFYdNUmLvHnHhY4ezeT0OKoer4sdUNAi2+?=
 =?us-ascii?Q?K0Jls+5tembZ9CIAbqoZuYi2HJ5/B6uh4xrNLuBg90oP4DGEA/XSzufnxrTa?=
 =?us-ascii?Q?kJtEPKMpBU5RpSKXu0fVWDQaz9XCCkwX+NcVEsSuwuAwrySPs+CE75N0olfr?=
 =?us-ascii?Q?hxsa7IvAdpmozJ7fdjZmZ+W9iUMltk4TwpY3BmgOTJUzfse9ICsW5IGLW2VD?=
 =?us-ascii?Q?UnBLRTl7XhMloMi2lwubBxNIiYdM0ecAe8H/tWI2Z/qRopYfkl5nUBwCfjPG?=
 =?us-ascii?Q?CyzQxZ0FzNdPyMb75ype7fbX9KAgNaMrOKQUaaHbF/1AyuwGtBvzr62Jj8ID?=
 =?us-ascii?Q?+INKKkUonHL8vc2S/OJpMJyLNALYubGzLqZWABtqc8S+CphFXWvg0lX75rMc?=
 =?us-ascii?Q?4o4rVis7YSCByeezp0suwwDxliJaYppAJNtY8Z+LV0X4faFtZw0Gbfdfgdbo?=
 =?us-ascii?Q?BqaOYKjhhFKicSbTzM7dC/tE8opBmWsRxhq1CM3+ZhxKuKBrh5FJ7kOFIz9O?=
 =?us-ascii?Q?InHOtd2MmAZhrYe5Gz45nQGQcRTDv2tINyklOWtIRMiRTSIC0fYsIumlBDrJ?=
 =?us-ascii?Q?xKaDeRZav3KdYd5B40Rr3KknNszp1R0K0zZN6pOYAChemTGBZo8DlDFryAM4?=
 =?us-ascii?Q?8Nk94h8UrWn/6ebRLdmRg3MRaxSS6BhkvE1E+3emW7rCOxdXEAG4mvrTyP6/?=
 =?us-ascii?Q?GaLrqO0P8zix4lroW/rhWZdjThapzBvKvkQEqxIRo10UdH+GAgrsZwzFYWaA?=
 =?us-ascii?Q?gXmdAPpZJYEGtLyV2E+cDozySOTgbMXQqDiFcaIMfwszK6GN4FWX/iUtbpH6?=
 =?us-ascii?Q?DxWh/hLr88gD3lRd1NhfClgIVbN3zxtum4i0kU7i2RdScdxE1wkPLI84yYg0?=
 =?us-ascii?Q?chilpuGVdz2Lzn+BtlZ7xnfKXIXukdfnbWIzAEPAoAz4JvYMKX8ynpJ+kGzb?=
 =?us-ascii?Q?em1NybhKhzuokUlQT2+LdgdPuV7Nw/ogMh1WJmTTZVw3+pyPAuNyH+4jH2Bv?=
 =?us-ascii?Q?aEdQfSoho5gXtmhH7sXOCn9P5puqGENj/BZL4MFh6WExmPwldKgH1QxuHNwx?=
 =?us-ascii?Q?FrMWgw5TEtJeKIETjhYeMCd/qoZwb37fA2umKC+nFk9dFkYVJ8wJSsjMVh3z?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YzD70dHvy4Xv4UXxVogpNJSB6byT79atSyrNOtELQnFQqyb9eqsQ70EFqE4Ne7SKcdvizDWgdNfjVFavyOs2diXh4o2FTkGpCCMyem3QsOwdmKB55kcSXpxwu2J2xevis/GMQHZowN53nOKpr6Jh5bT7T2BotihXCwt5E/V4pdsHFnRuQtbSJYULIYLE0Q7Kvthzh+b9wTd9fFd/ivGhz9Rw3wPYSkW6kgtC/E4SHFgwmndqI9H/ly7h5eCH0qTTq1UjJuXFhjr3GJhAC0hMzLYRSEBkak/BPYcT/WJeA8Ykx0Pw6quZPaFJprZNuwNLBDqfy/u0o03agTu04byDjNv8KOAJYQ+LgA76qdZsezgOZo0/YbdPuzqP//AlvjaWstTrSys0WjobopjhRgC53qAQYvnrcQNV9ZQceP/302m2Qe+WmLvDFa7nS6sjZkFMh60wjaWXYSS46YwErmorr8KVGps72xMSkJWkulhgiDf9CdUsb6H02eeoj4yVO3joYEoPVuXRZsEAeX/2f6CLYQYDOM6WPDrXCCbPuKnYdLXOmrhagiLVZuH1ImFIC30UwIrccMKycEb6AxXjFsRZUj1HcDpUbRRo/DX891VzxqGlCQJWk4JHimr84gedJcm92848dtEdQcSBdBSOPouiExFbIv05scdJX8qGSwQnoyFDXGluKdQwTrP410O206UjwUAz3GTs3R0EXhTpwhCGMWbjkRCoR3pBtpG8n5RzEwjXlreZb0XZbi4NIBtpPlxiG7y4dlBfFM76KX/dyw60sV6fQu80pZmcEpTSvRTSEU1l3zhysB9sBtIcicBcq0iQXZSBJzPjrz0cXyzABvx/po9eSQZL0ioRjMfKTwJhNqnZcmteOe827jAv9LzrH3kX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a0ce00-0b85-47d5-d2d0-08dbc4527ef9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:20.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOVKh8ypJw2dST57b0W8xVhmEj8wMqX4iU/yhEd5U3hqVeaminDk21s20Y5/gzyO1Dyr2xWEjab3jK78mFzRo1Lr86SVylcC+KHOrJvp5n4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-GUID: oVBJVV9FjMHagVv5iIPwUSa7ti49R1Am
X-Proofpoint-ORIG-GUID: oVBJVV9FjMHagVv5iIPwUSa7ti49R1Am
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0dde64d55619..5c4a22d5c6ac 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -143,7 +143,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	static const char temp[] = "temporary ";
-	int len;
+	int len, ret;
 
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
@@ -190,9 +190,10 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	 */
 	data.device_specific = 0;
 
-	if (scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
-			     sdkp->max_retries, &data, &sshdr)) {
-		if (scsi_sense_valid(&sshdr))
+	ret = scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
+			       sdkp->max_retries, &data, &sshdr);
+	if (ret) {
+		if (ret > 0 && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
 	}
-- 
2.34.1

