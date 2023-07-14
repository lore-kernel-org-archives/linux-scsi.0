Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75874C001DE
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjGNViO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjGNViK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0843AAB
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:59 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4A4v004674;
        Fri, 14 Jul 2023 21:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fbUZGGzHLP/Gms+L5XHc/EadHFm53cAHpcjH7HxQ0f4=;
 b=evbEyLjXc7p58ej2zp/UH0es07ewpBEeVmAoECpMRs8Flee4vcEVRxmodVsvd0IO9KKn
 O84/ImR7l20Fd8aM8jcCVUweTS9z+vUVIoRbzKbNvtgBoTPutuqpQCxU6FHXPeq3wExW
 pjmcQTsh859D9r1psLCKqh0h1jUydENbJOYjv377TJOJecfDXJVrArtRglJMmkpucNxO
 XUayJCD+Wg8z2xMvlfdzGBPuKh+2jboiMnB94b+4NT4aPIUVtvWuPCAIUrzk3ME3Xu1f
 kHS4jVdq4nwD7Q5oL+gSbfhJ1R/pCFdV05GRCAJv6SyJmgCer01UOqLo23snrTNcgV1m Kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptn2d0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK3hSk007714;
        Fri, 14 Jul 2023 21:34:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrvv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TOpM3t4bAU1WkAu32ilVbz2vDRUtBiGoXdrI0/VCukWP7RQV79s9IsqDMv6Pz/pCCGE/LFJwfLeGG2hs6K8YzJWiD0NVLoICVt8Ur2Do+kBhKyYSY7ZT4tKWQlLHXqSlfNpE4W3oirXNL5/ge/0MxYFEYV98urLwHnnepeIhqAIT/lNTMYhOUbv3HGMvmJY8BfER0Rund96qa82dcRstd5XwWy6FTiKggoWCWRFbHT0Lboplc9Xg6H7E3B9ZeMpH8zb8qVGloSEZC3qOz1wtmuobcnjkl/qwTgTeUsQtJKeNRx+USN9KHRouvUlXqzLROqFQIipebg1wW/u4rQb+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbUZGGzHLP/Gms+L5XHc/EadHFm53cAHpcjH7HxQ0f4=;
 b=V2sp6sLSelOGTYXjauzkl73ZDehB8dGHTzUEeTP9MQzmKG/b/BHmaQx8zD6DRzX5A/EPUdVEJK575IAOeRnUJmHr4f0o5gYbMRM94X0bOMIA/Fegy0ZGNdJaSlX3wJ38ME0XQKjq052OqIySrZQl7/JN6P0Z+8LVBAu388v3vdoalNEUnUZCv20LZ6AkYDKbMg0au0hm+1XpjzJMCATcHL9I5QTBeK+O9YD224gnKrx1xdmuHRJMy2qAyrcjxMQluUs+ZVPzUDxoCWomknr1L2+Rr/vksNdh5sHbCO+xezRVf6XUIWAHJzmRd1yn1M4XlkpoIO3XXKoOuG7BEbraYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbUZGGzHLP/Gms+L5XHc/EadHFm53cAHpcjH7HxQ0f4=;
 b=FYbf9jyds32070LEo5UdFRr2kMolznWIcWf2xBauCL/0JTWGLJDWwPJUntxME9GMklPJF3+nBNZeXYQwDeEbNjuCXYNZU1yreKjqU8yNGKwoALmoPIbz8PWXtdftWpytkX4pM1yKdS4LMGXo1CAlQCzZIMMzuJTpuZNiNzorQig=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:48 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 15/33] scsi: spi: Fix sshdr use
Date:   Fri, 14 Jul 2023 16:34:01 -0500
Message-Id: <20230714213419.95492-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:8:56::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 603c8ad6-0da3-46c2-3d4d-08db84b22658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmPTsilICzS2JfpDB/uk+QMyGIlOlMIhUtprBJdmtEaZubFBenKUB1e5IOZM6QO8t/ilHSUOIgxHG2XjTcGJBkIyNYgyLr3jDWups2MFv5XbX3rS9bf2lv1H8U9eLI0GbUqobqPowNIulvmjk4i6LZOqqoeuLlKmsKVWQ7E5g4LojfGQcFJ4pwHO8/X1rP0KQZx3Ycdl9rYp5Rt27mqnSfOYPW9fqv1rWMdAbKCnqtmzmQTZGwEGXHFKokwlEndSYOPnqnDxqFMZ0WgEzDkeUIj5mnY7v+Rw44zmVrm2tT0b1E1q5dje14l9xYKIc2T9m3fJwOIom1IdGA+mvDx3+IOVh0YjFZC1FoKf+2Qe/Q/ZvbggiO6BGOdpM1tQiZROupfdfYPTYiBEZ+RiZdTWfrPvvPlMGyL0biVmkVBQyqkTp8gr5E9xmfDp91ocLmbkxnL3wKeQzei9cFXFoysxFPx/Iq19KXgJoJmN45AF16FUJbKy01CeI8tTIsCADHP9oTBEPPwuRX8aJD5sGlnrdpkoberwJxfouCrRL6KvcMVhU5XSJqVMJmiZ9aZTu5B8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vY0bwmsxMVOcp4dxVdbOMqtwlEyz2C20TZ/fDCvKb4txo82RMSMRuFD4+ULw?=
 =?us-ascii?Q?k+p/wwtIgRGpDhu6SurhFzJ4TpjQaMqPUHRIP4CByx3apCpXKZaQIOjsUYNf?=
 =?us-ascii?Q?n+GmxgY1iwNzT/QlIRfLG1IBeqdme6vdYoJYNZjZivZ4nzf1MQYhd2ycOHMy?=
 =?us-ascii?Q?BNP587U8H7NzqRecdFkjG8FOE7v/ZFl+1kG9sdLgLx49ashnU6klXVBfdGJu?=
 =?us-ascii?Q?T2N2mjhHgrfIWUdJBK82MYrjxdHGZ4J9g7MeMAvMY62pWBHmLYKugvJvJTsB?=
 =?us-ascii?Q?CRaSog7E06pDRIZhGO7FWrfomWFYLvcCyc7SCi2bkXQzhR3IhRJlSw6Znx36?=
 =?us-ascii?Q?lxtrygzgED8huEZLDWduWyLNs/vfrxB0AnX2ZBbxEp06KVpbUJxuLrvo0GYO?=
 =?us-ascii?Q?bjG3ZQbxGwB8DsiT7mcmi9ygFQr+OD0JV3BwFYsi1X5zlOiHtlBw78pJkWks?=
 =?us-ascii?Q?MB9cK8uip3bZTyYPOWNEUF/POdCkwFYWYDmZVMJIq270dSuUXCrKaP6vMlu5?=
 =?us-ascii?Q?5SMelrLfXC+lqmguEYLpGqAci2jdPBTJVucqf9L755rJWnvlORpa7DGRzrAz?=
 =?us-ascii?Q?qkQP7FSqrw+KA4hgauGPJ43c7lsNXtqX40dH7DnWYSlgsQBzVEynOMviip0B?=
 =?us-ascii?Q?mGEVS2Igk5m2gj+y8uhHJqZtEEMfophoLp83yqKg8l4jxevQr7YntZYcOEPf?=
 =?us-ascii?Q?n5w+yPwVKhWELK3d0VXY3fidgB+zzzG++kfuCwtiZivOCCm2X7MNpmxwNjTE?=
 =?us-ascii?Q?RdSYL94yoTFIwpFgI7spKNzEocGL6DJmVRUluPhVp+NWpNBi3LU6eIlTv65+?=
 =?us-ascii?Q?m+UWJCc9a0MRnt32YLztDXQXYZh4w6hNljoIgqgnsmmX77S0feZ7zt7pmsqF?=
 =?us-ascii?Q?jGYgCpvxft9A4xWaU8Z4F+MTBXfN0AgSwX7AwKocAunLW0wR4/T2+X8evzyi?=
 =?us-ascii?Q?gt2xDKMySFBdQSVeMMZB+YPfYP2g80jl9uFZC+oDhRFZtdsG0LWVrye8v1qC?=
 =?us-ascii?Q?rMBF+RhQAvKKOWbJqzQBhNyUi8/86tU2LCD/c5LHfbQ4s4y2SnM/sKWh0V9Z?=
 =?us-ascii?Q?5zDnRzTzgrFN21yShD+pJEeNtNLUJz4h9s9xQ2JtzYbOz4qy+N1ZiyvBfKI2?=
 =?us-ascii?Q?BAxInbH1A+yyF8PGSX32HoYi+wDCjG0Jy41HEEi1hw8D30dNkSiHXSGN1yn9?=
 =?us-ascii?Q?sve70vc7Ic6SDFoF9Tnh/2YBMHi4Tc1MbjKnRNsOioGV3L+QOUyKmtOdcSLC?=
 =?us-ascii?Q?AViwD2sfybEuR5cbLIKu/bL3kmV1dA0htgYG/3gcLxE8Hh/ofS1ooLNaLsh/?=
 =?us-ascii?Q?LwPv/Tvk41z8Uaw1Gi9HQPJAn9oSTIRD/sph7xuT/YpnqdKF9YbREtMFltpL?=
 =?us-ascii?Q?XM6F+MjMjdUFIATwGiv1ecXGDvZQPNyRGwY2eUTitnqaJg5gTIcJqpiS80pV?=
 =?us-ascii?Q?5Ahuu8PB9uaNxvim7mU8nc7cLT/lEa3FW9I/S3VCAXMzmMIsCL48UgcpIGBQ?=
 =?us-ascii?Q?pmjpCmRtkReIU9/MTUdQB3i1L8wHHgJkuaPYT5oLd8ZNGZ1E+hiET0ipBuew?=
 =?us-ascii?Q?hahNc5KwsiJASyy9e4qe0nOcdCLKAH3kc+GNKwMQBHbP2EK9h4kdABrKG1Ag?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fC1zPUuADO+KGRlmVCCWqjA2Yzm/vVoMktASpw+guwc1o13oZxq4La0ByDFtTig8WSxwC7Vy3+4PivUWWkYIiz2fRQWDhJXrxm2CxGwFiCokWg0sFXKeJzlHIHoqEDrxceS4afVm4xT/UPP6M/fQqGvUUHMQ+ME6QqqJfk+iA3/5sBw+iTkU0JUtwSkG4we6uuvNiVb3FRB+vS17NihE7DENmV9XnUeCleEl/0bDR0VLENnbqbyUV1kclgz92BnZd50qDMCLy75w20yak+U5sQnljD9SKBkYarugJsh+bhvk5AAZOTpWU8QMcnNtHaA03ZEE1Vptk9zmO7sjgGeqKYCP5h24j69h6f0rY4Y6u7MRxfwAkjvFm7g8ZAA3DlJCkylVHj1R9CwQRUbdUdl8zesQWKpinwVOFIREgZguJTpeTSiSidFLLuKTJyAdpuqSN9hxU20HaIx5YyOYhlunwKTMWhWeEwLU7of8HvO2vWLNHMIvXtR2bNsGvLWVB1CWQW5HSFslpDMZt4yhpd849sKLLF3ozG5UyQTZHF1WTGobYHCFeYcJKWe4B67KzXc88nBllV7UPMatNRAzsuP5jK5VqdoZdOggk4MGp77CD0TiCnjklyYMle1ayyfoiv+kl9t9mG8/CPSdk9IsgJIXOJz9mrKipIq/8gcEWwvkOBekKpcVI4kvWhQWO6atTQpWmTy1WvyxlZ+nB/Vo39QC1Da4+iAzjniIRDPGX3I2EoI1JO8TOvUVHZ1jGMKaSN/XiKouXEM/AHbUs4IIjO6DrTr+m4b9CHdQu0fkgYAQgGEH/PRBJnjXVZS+TbuM6veGX3SBOSrjucQogurjtOvxgQ1j0FLQC0Mm1LIQgMLry5JhzqRT1EpZaKBmi2oNi7u0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 603c8ad6-0da3-46c2-3d4d-08db84b22658
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:48.6595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XL5yLL89gprluZRQEFw/rqdsEaNPF5rB/CEUzVk7wLwCuTgjGK4nXX9WhsfPl+n5sBAHwfeIBL9Dm/FopvRDYM1Tf+XY8gRxuexjo32e93w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 5pg73nyV3bNplGc4bD15jzQ5Fd57SYUp
X-Proofpoint-GUID: 5pg73nyV3bNplGc4bD15jzQ5Fd57SYUp
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
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..f668c1c0a98f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -676,10 +676,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.34.1

