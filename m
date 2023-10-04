Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E38E936E7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbjJDVCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244020AbjJDVCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253E2EB
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:44 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIvav014490;
        Wed, 4 Oct 2023 21:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=c91sGn502pTKXih/VtZSIZ4KpqIsp3SytOpaw0SzOWM=;
 b=IIy75ezOnh/pIl2J6D4f0MZN/NcaUKUSMQjX/7Fd4g9J8Egi3IpjUDK2pqFMVMskVhI7
 KdJUwrjGZy5HYVRBoX9ysOAR/+l80e/NjFIbHZP/poca8FyEOzfQ754W8k0+sakpXaE7
 ZDCPwswMpy0TpzeJ+5PB78CGl3wi+xAcx/tudrj35p1/TQc3bIGBwZ3WbtSUJfAmpOtU
 rNiJXWaEevNrUkREl7cP9Pyh8WqhVQAb50WeEySNY6ggsxCxMAR4oYziAcjcnnluD5PO
 uSceZQ3h3Q8L3lUvgjeNBcGw+btiXbe2IJguJ3Pg4WJAqtKhpjDIzA4nmvMM8ZDjgbHJ 2Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea9283mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:35 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394KUdwq008859;
        Wed, 4 Oct 2023 21:00:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea48p3x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzQlDBum6qNkh8AF5Bky5lIbsk1TN6leYdODHP78GUjulZhTGY8uOxecCgW4zb/cPYf5mVMSokkHO7BkVknq9b/9cDRTXyOXfMJ103G3YcRgHtFI4rdMWYIjr8lQYh+4bT/09NGGcxFlW4+A/8OUTeEQXZtrtcX8GVkFQqyL0MJcb06AMJ+25stTEVRTQ+Havk29ctRLjE8s1ZKqT/6vpkyj6aj0zd+dPbDnPlzjFtvtyoHx0a5kZKJMHDP5B1+V1/ugdlYeHZukN2cUVTO1WWxJMid7j/LLIzBxct6BvjUbDzP3V+kfwCK1PmxH2zwW4G+gMjNyLjtp3HGLD9iw0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c91sGn502pTKXih/VtZSIZ4KpqIsp3SytOpaw0SzOWM=;
 b=TxtELtPoqRC+aEbNSwU8OUaH95BlTbP1DGgSEttsadbnNQYgg8+jrkg5WxfEPxuWj2qshGK6SIGn3YKvRfSgb5gWazs6BXBACvIu4q4/gaaUAJeBKlrbyEC+y1a6g+RohknuwBOUiuj5E/gGLZGbNrENsNv0Vk2ZISSyjBuRpcKKZ7S3m3yXTEDHFXNYkyXifxQBI4JK/jOQHcUrZHj/eAzQxZWXiqPEJxq3sfJgkQWVSIKbjXdFXrvHX7omyYS6/5KrEKVY1xIBcXyoJylwIfI0d+Qsep9UVfFGkPWhpOYUgh4mPvF18ixy2+pHvjSGiknxp7wdJpqur5/dpaslnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c91sGn502pTKXih/VtZSIZ4KpqIsp3SytOpaw0SzOWM=;
 b=iXR3m9LurLr2qM76ldEcH+0W+YB1HxcAqx3QayV/nVRAtymSnEPMVSS1z/W72sfJzXe1n9UuBjzFHKo8nj2KrHb37GmqgDF7eZjnk3RvzI8ibm7xk01+DufM3Zx1Vc01bqzwZVrh8w+xTKd8m7caw1dhXPQ5G2KwcOFwPS7vYe0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Wed, 4 Oct
 2023 21:00:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Date:   Wed,  4 Oct 2023 16:00:09 -0500
Message-Id: <20231004210013.5601-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0011.namprd21.prod.outlook.com
 (2603:10b6:5:174::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: 73463e78-c0cb-41fe-f06e-08dbc51cf296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EK4ouzTFBwhAw0XfU55Iz7ranKl0GCoC3g/cC8AuWGuK9LqetSLX7qQ2HZgD1FOGhLBC+9IZhMqnqW31Hh1DgyNSqQxWFtiEAJ/SLQ6IhKxGw2xhGaYWFv/eWO5z7tkIOHkjFWkK8KuWu9OMWPJNXYn560XaVCA5c9sx+f5is3XhhXCuXiOKHfWEnnA3iTS66TJkhh92FgMXITXOj5LQXW+wIwNlFbnD+F2IDxPDDbzCDAmlobVXgzFP0l0h9KDf87iS/qGxo6vAymwDyuIN+0cenMXM5U/a0MQec7lgEp0RP0PeOV3Hy2XftnHtqwbV77Qc+bQdomHxyETl7VcnHnB0HyKYrGnpFLVJkw5RQTUy/dflKKgc6c956EOgSGaou3Ierm0anxZSF1S6M6rEXr/CRZ8EhavUQYvQ4TNT7wUVgXCf3CnwdKlL1yHbNkuNUGoXeLE8FgszlIqCn1ImZqij6GxnGp68GRaYtc7IZd6FhRccB9IZ6OsGEM0CtJftTId53aPp8OZBGmPorzUQh3BOmamzw2sUSA+QFHZ5ZQMhrQGYbKILYcpxOQZ/wK3g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(38100700002)(6506007)(6512007)(2616005)(86362001)(36756003)(1076003)(26005)(2906002)(83380400001)(5660300002)(478600001)(6486002)(41300700001)(66556008)(4326008)(316002)(8936002)(107886003)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LrQdRRMfSyMyJrevW2L4AYvnVLOGbCw6GP1V45A+FRx9j+4zNpScfBzlBxXy?=
 =?us-ascii?Q?HcAnL8/R3XtQCFdAVdibIi9seYmEujA98v/XYqTKgdiI52ZtGcJ93lUvbGH3?=
 =?us-ascii?Q?RgENNVzIW+8x4sc1zEegmuo5Q05bBs1lWLNVe3B4ZuzoEdX1CjsGE89R33oU?=
 =?us-ascii?Q?BnwyEI2PNTdI4xahiggUwWE6hb2rIJr6swtHZCBC6XpZBajds0TA9nk/GpbB?=
 =?us-ascii?Q?pRv4/x2gt/yuKP5BB+dZrynWJ0x0oBoI50ebLGtvoSxsRDF3ZPX2wVgEmrjx?=
 =?us-ascii?Q?P6S+Uv0hwGgzVYwDbguV4mBliZmLXk5HrNeZIBs55q3FME4/NYvUcTthIxTk?=
 =?us-ascii?Q?1kj5ydn27hXjDW5eM35aUdk0D8KAxbaFsYsF/OUImtFB3JCm3grV1WkJLGJ/?=
 =?us-ascii?Q?HbtkE5Vna4BYPGle6/U2AmMhngcHuMRfRaMHC9VfSumUlPEv0N3ZoJ8iPVTG?=
 =?us-ascii?Q?augE6Q9qJEQ+Age//7K+P9usb2DH/O9MYimk76bMQtX1ERmYmNBqIJ7e12DY?=
 =?us-ascii?Q?mk3GLuDM98aF7uEeTXpnA3UIySSvJD/h1ouM1THPUcXWjgquCES0Vixmml8H?=
 =?us-ascii?Q?XroWqeS15cpJf7ViVy0SR8F7DzUPOorEb81O+3L2Mg/xmTAIvyTHCIOzxLmz?=
 =?us-ascii?Q?qAcXV4NK4DBtICHCw2h02miF4Z0yrNi2ftIyVYsfIPJbeRiVjbOJwCRoR9rr?=
 =?us-ascii?Q?jzsrBPuGX6OZZ39hnEKZydOZ0yqM1NTj2W0GoG+T7luK5flSErLS0ov5/Kh8?=
 =?us-ascii?Q?B2sR9VQwskK4QG2ADj/1r/WfyQa0XX78mQ0B6XehHQyH7hp7Sb/BxgDpR3kJ?=
 =?us-ascii?Q?B3hK+QYyJJctyJQKN1o5EvJA10oVXzpoFdT1w1rqHw5K496w1xPNr7+HJtGm?=
 =?us-ascii?Q?RDfpT/3pPIAV1PDZd+0wJM/Ie1MokZNrp/qkqVz1+R8aQf1y6LlTrurqbreh?=
 =?us-ascii?Q?SwNHSEOnbhS5pLwvVDXYl9r+Bu6DDtxUTOXR/3JUhN47p/xTknr++BPoMk5u?=
 =?us-ascii?Q?WJGdQkUZiOK1/eXJjrwcYAzSHd7Hno/yjbPNd6jdpH9Xja8t3ljUJvlAmLa/?=
 =?us-ascii?Q?zUMaXxWwPRuMav3IBaVFLe/ZU8vQPw2oYFTWmENg7WvpcM0E4yxT3HhdpFoT?=
 =?us-ascii?Q?WSZ90RuxkzYaYx/nXubYE8mzbdyVLGyRxcVgMzX1AZqwTwwFU/YJq7DdhaUT?=
 =?us-ascii?Q?VI2g3t/ZkLmiK8ekvkbRBa3TUG0SFwkOo2bR5/tNfd3M6bBG1KPnirl0cxw3?=
 =?us-ascii?Q?DEzuwW7UZzsL5uezcPvaFiGabQ1Xi0hQwuhtxPUFSeJ0F6A0EsJ/xge66JHt?=
 =?us-ascii?Q?WcJ3/7vVQ2aoqxy06T5C15vydUlis5trSe2D1jMSXDiTQqeZZyJtpXa8gEhW?=
 =?us-ascii?Q?rRcCeW7Ni6+kh+WqQDYeNHM8XfpnIeLTHdKUBQtZSxR3G8JvH2w4PmOmIGht?=
 =?us-ascii?Q?Hl/f/1QBjLBWgxSLTGZfB1hWlUmGUAt3CYto5hLNgx9JhlVuOCt6HJBERhgG?=
 =?us-ascii?Q?QEtXz+J4B22/a5QYKEDmTXo02yjy/aKTbrUdNWoeMCpQ8ybCtw8ToUzFNjcp?=
 =?us-ascii?Q?dRe8i2EPTI3reiRLRLCdRO0abHrhQgHnbnrK3ap0/FnyUwUkZtaHTdQq8v26?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +oHYl3QPJfum2GQP3HbeEtdP0LYaFtDnmD2aIzVJz9OToUEqU2swRrTmQO4tHfq/RsD1+xpOuOvxKWIkLDWhO3GLk5Mu042EB+iR/6Dph5oBdWZAm0N+pFwymnKvEPsqjH7GimMqpQ6pvaA8gvq0RhBZoGRf/C0r8EJZtIwq2i0/FlxHX16eJgwW5cxYXQ4VGd7AV0bZFcoVtTGZ0NjXiJcW2y3XEQAeU2F/v6A9zOPcFNPd/zHL+AMm1FMwbktlen4PFSS2duH6ycHFrylJSSqlHBiddqteja90duIRhXecLCsnxlC9lf2DXy1qQZjy9CRwK4wSY8lXjkRuHrcQF7tX4sPrj2hak/aoaFEIbfBk+8huzxjRjD5rKjCuC1gvQYuWJQMxvN9f6rUp0C/orZPbgY8nPfxidNTG5IqEAyTib/3MJcXoePQy/LFq1YKKFl8c9FspBY47bNrO4USz1ZJT+aXHhXX8BYA5u6XBJOlc2KDaAb2fcI3qEorGtGLICSOHZrCUNJNSPpFqfl2B/TtZby3VFM7HHRvXbFDf/evBbYEyV/LZzFUrVbDoyuT7LpANZBfiTu/c1rN+moYjj4wBzuXAoXv/W/InZGCN+/LA5EVZYSWVFTm0VtlE3oba9MjTtiOc1Do03PbRZylrcYQ+63u2uPVZRMhK+Lg2HNZRc0IGNnT232Ze+wsSoiStrLsoIBWraabyG+EIeya8119mJ/zaMfmjJq+b+eDQNwJWX1mi+WSMOsT4WuCONk/rmdr79lge23PvYM5I8a0hi0agEd1v+aif4MQSwwblVlyFNsrzsbEBbSftjhBDs6LYOZgVi3p95cQ9S+mD9RbcgmXJTfiuSgkwzFjwAH5zAe9XsyPNO+PVAIDiQXFQi2ZY
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73463e78-c0cb-41fe-f06e-08dbc51cf296
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:32.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z0jak8zo23MHKnTePEyRL9oVdelaereUsHw5m51kvRGlMhYGSE5bmJRRK3UxW6S6lJ2Fqf8zvF58AvI/yr5zHc6tystwTb9pbRlnLeKyYJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310040155
X-Proofpoint-GUID: K1syDOl8HKvQu2omBFXCUAxUvBAkRMo8
X-Proofpoint-ORIG-GUID: K1syDOl8HKvQu2omBFXCUAxUvBAkRMo8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sshdr passed into scsi_execute_cmd is only initialized if
scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
good statuses like check conditions to -EIO. This has scsi_mode_sense
callers that were possibly accessing an uninitialized sshdrs to only
access it if we got -EIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6d4787ff6e96..538ebdf42c69 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2942,7 +2942,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
+	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
@@ -2990,7 +2990,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
-		if (scsi_sense_valid(&sshdr))
+		if (res == -EIO && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 		return;
-- 
2.34.1

