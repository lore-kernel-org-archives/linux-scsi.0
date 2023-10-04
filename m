Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2CAE936E9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244020AbjJDVDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbjJDVCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F660C4
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:52 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FJ2FS016059;
        Wed, 4 Oct 2023 21:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=EaXyyTczHDVfT+tOv5nXUvY1Jn30Q/vkiUima6NUXUI=;
 b=flsw+rjApRgXhnCMEsWlDiOpiVRghCafz1qFDo2yF8DK0btdp+Rwp+VTILhZv3lJJDTJ
 ds4iSEKxGGRMjnie325T0fan4jtBzV/vSBR2uso+iOd5QISARQaSeGdbDjapGWskDMSx
 AtSOdJwX4g7vnJeb7bTXBAkAzTF/bYPDLhT0EKhWtgTrYneBexlRXrjpMilLhU495l85
 R0YTbwx7qOcnJ6JIatK2+/jzhHA8S9sOzbXLdGVYO7+A+T7LBy3tBnYfDHP7auB2YR4M
 LqPzMS/Yp9D2ufQ+I8zq4G9nlHaBTDMpuxq6TzzGZJBEbd5gkTp3YSTTdgG4G8KI84/n 2Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcg4s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394KQ8Tj033614;
        Wed, 4 Oct 2023 21:00:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea48as2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx17aM6kdOAlCh4pJ/GcQ42FxaI51cBff+/Wj1wqHmxVcKRbPl3SaDcpcSrefJhkuYv+trEBwJD0sx552VUeW89Yv4tlb58DayBtNbcrSjbBt+3JQZ5+Pgw9FpyN2e+ZwjGVfCYn38qQ9iBFlsKvgf7GJhBd1FXO+p6vZ87fDv5G+y7vizt2A2t0pRK7buAOQ/LOxrqIU9m8ssaFlPsH25HPGf5/IMz3G9VBBugcCTy9yBYxLAAEtcRcXeV4DucJxbfKTsHopk+tMRERS1r/qsnIrG4P+c7KDPoHs4jY+iIv4kWZe3/llHU8KysYxrHKSD3QFeLt638urkp5ZB4z4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaXyyTczHDVfT+tOv5nXUvY1Jn30Q/vkiUima6NUXUI=;
 b=Qrxb9wyxzWf9h7L95d+GP6FRrTSim2I+pjJ9P/YsDjj5JCWa/x2Q8ZIqWSGJ0JMhiXJRPX5Jv8m5VtLVYP6j+55yvn+t6JNtGiXuGyuADGe7Jeu98QJ1CqDgERE80FktCRzjhC4BrVaW471bbS2e7Dy/xW8cmbgVKdX1HqDA5kRiO7ZF31kZ/fOvPL4OUjoOc3MpbRhXILtDtgMb11WqJD/eYZOm97y4jfxYzMfPNBF/A6xXrd/uCMSemoQeHR5gvBGRunlHa5/Dmr3ArP7676tPXqgNm3s+bGmAq9eKxSHkbXAGBYXKgHP1cOsaWI2DldydhYroOv1NmyZWMfZ8/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaXyyTczHDVfT+tOv5nXUvY1Jn30Q/vkiUima6NUXUI=;
 b=GRJMhwgCwSkGtd3o6WauA4QfSJTwo9AqbybVqMDGRRTuJ4axiUbTP3HL3JQQCrjLAgu2hre2C7K1X6Jj702F47JW9sz9rLP+Yu9UeiMYMBLYzrxe90Ib9MV6ExBlpWkBlOiQeuZv/YtL5y0WYiCtS3XC7A72fwY6o/jDSHkLoLk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Wed, 4 Oct
 2023 21:00:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 11/12] scsi: sd: Fix sshdr use in cache_type_store
Date:   Wed,  4 Oct 2023 16:00:12 -0500
Message-Id: <20231004210013.5601-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0109.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::11) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e6150b6-92c1-40a4-bc2b-08dbc51cf5b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nf8CIzoiawUWnXHyq0//zG8XE5oU3oxTJOVu5fZSgDBIYUj6NIIAQOwQO4bB0xnHWJ8fna64ppBefqGA/yQeNHlzqeJPe7NCTm3SURmz/imOJTed0bWU/kOaxbjUv+OHDykv+Mx6QNVOKfgCITjv9Huljy/lDSRHc+oEvV5f7wlC8lhSpk7KEqJNpT3U1G6WixRzddZ44/FhIvs+2zH3BpHhPzABoD15rIGoq3RGVv8SUyX7IV/dla2x+nH+wbK2Mz3WI5fIMEa6V+qnrj+F5Bg/UHALST//bkd46nPVTfE68AA4LQMOaobQSQoDsuk2yBXI6rSDBx8N6L/kWLkVGh+8WhpgPEHJ6EdGYSNkTdukk7hkVqhts0WpaEa5p3LJZbqQVlCpjKYlvh7m2nLoQcNm6pdftCyR6F56J0YaogO46MplzyV8Ak4ykdqxy+AG8W54HoOYEX2GO6z4RRVPPxfRagIX44WOy64l7omY64T8aok0Cegv6VfHrrJy4fyWOc464Mc8pKSUiHuz1UVGSAX5dZiYdA8gsZ/j6FNnII6vnqoD7OD/LuS2PutQIwhN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(38100700002)(6506007)(6512007)(2616005)(86362001)(36756003)(1076003)(26005)(2906002)(83380400001)(5660300002)(478600001)(6486002)(41300700001)(66556008)(4326008)(316002)(8936002)(107886003)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KH6CqC41xe/UDTryuCkfGCbJOokAXL/6nxxPNadvYxqzUxB9Pp8gqHDR8M3t?=
 =?us-ascii?Q?GHE9vJ5vFROeyBgOlO9cVG1sX9OQFs6f5ZQ3qiIlqzBenxjRl28pXNl0p6p+?=
 =?us-ascii?Q?F2oWHeoHR2XrfxTM0AHWSz0wbSbJ9AmcTx003GkutlpNZ44RnPdMC8clF02h?=
 =?us-ascii?Q?PvivoJ2KS3elPbxt5c6vYInoc8A7kV45ry2oSIQ2J5DC8uHr4tzm0eBCenFn?=
 =?us-ascii?Q?YLFkOxTYDsE+50nZDwppNZhkVOOsj9MAhXU/77wv2LHHHy7XtryzSG+ja8iO?=
 =?us-ascii?Q?fiErg6Pkkt04B9j7R5EURvDeIYpPSg4niRBiR8ZqhE/KazJSZ+2MVKbR0zUf?=
 =?us-ascii?Q?UOzSmKBG2hF0sq1dKCurHK9i/AnR4xFgTAHznFf08H0llH/ktj2OdvJlpEad?=
 =?us-ascii?Q?C08kUTW0/OVxb6TbStwnIm+GgiuGt86E6DK5r5kOtwMBEWTJA599+SWzvoHp?=
 =?us-ascii?Q?kXxFxzW6CgoEc1fegg22Dvc9Ygf0UsI/7YPa8nf/z9Jm8vmTDdxVuWUzLoS/?=
 =?us-ascii?Q?kYfoJQtGsea2G2QbT2DfyhOilKdsauz3KGqmcSrpi/r6eKZ1r/UMCzuscpWc?=
 =?us-ascii?Q?/cFaF16zcfC+ah24z9NvsCwsxhzF+1L05zIIEEv/ipPWjKV5TAcTy+fxmafg?=
 =?us-ascii?Q?sIp6JA6ZfxM7nL6h1SUphWdY+4Qonh9OuMUGnubnDC4Y5REsL7Khw4dCO+Nn?=
 =?us-ascii?Q?QoQQHUZPlRZzLTLb1upokI68GgJHfWsrERfPRCNr9niPL5x3cy2+cz00K6pu?=
 =?us-ascii?Q?V2Oc5DG+uP//QLd4qqAiYP7Be/QnqsEmoBdFqqPrj9qgyxiLbFBPbP+fSRu0?=
 =?us-ascii?Q?I3XeQKWa1x1TJNiaJbP8XmqYB6qUv3Hl8oiLit/6uZ6sb0WThLr2rof50xD8?=
 =?us-ascii?Q?i3U4/D1KcvZtRbjOUvGL7GmU0js6eqch3lTkcdbmROdpHGEDMit9rNAhWXPL?=
 =?us-ascii?Q?yZi6QAs9R3GyCFjQGcif8hnTm4IdeG42JBGsMhNMzwtrWvMDX8Hlx22Y4xzR?=
 =?us-ascii?Q?Rp2HuDLvdGI1yzbgJnMEUjl6MqFfaoUHKulT18HgNpwTeY12C0/BXdj6Lwr7?=
 =?us-ascii?Q?KZUIPo4lgXM7FS62ZkQbkcsoh4NXFU+1wovOPtW5eJTDnLtt+u/dJYoQaV3S?=
 =?us-ascii?Q?S+diM8+HkwmRZ/G0AyXWzb8S0LJNy9AjndJPaYzkzQ08q+mxjn8nno0/70IA?=
 =?us-ascii?Q?pB6Dg/Hl4VVfA2nln3GoG5D8X61aY+Bv7iYYKpbXHj6eJkKDddTHpItRUYmy?=
 =?us-ascii?Q?obxfkHX1ZMzF4KOYq//YQfBXZvbAwVSOtWVZu/RfcKHz8D+06f0QM2vfYwPv?=
 =?us-ascii?Q?v3pCU3U6tmOrheTGXbHoj/gjRex/3t+y6hrPgaSt0zDu2wujdNx7m28YSMQT?=
 =?us-ascii?Q?bKejgVTDP+g2WyGEcHY8pMIvZLYXGRJ0StfP0PPXZ81/7zUPhbGww7I5D83v?=
 =?us-ascii?Q?ygOKk/UYlqbTZSepDhbdUZVblW9iok8YY/FRoRRO/SXnME8AofQkwTg3EqoP?=
 =?us-ascii?Q?1DWFW6bNgyUhv2xnsFWuTcKvLuWd0zG6VfY4OrVvd81ZEWSzDUc5Janpv+SS?=
 =?us-ascii?Q?IQ9z+SlOBLzvx8YuV6p+q4DMCsG130DnvUvyUuad2z7grWxxlXRtWQeWzz3b?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mNWV+N0xXzsR6SuovLD1yLB5ECGOWpMkprTB0edCjaRXPb4RmHY9tmSg1DeH/Bor6NQEIsPSXV6FQj6GokYKiSaoj2Ii7XG+Bh85NzUT3HKnTZgH1Za7Y7mfaOREBqB5Wn6RnQNof3p0Q3fJraqwXARc0oHT8tGu5ctMZHMaXEVtw/JM648j7M8+47y/0wE52Auo+Prm8KjpySLPv8DFj9DXbkUWoeo060BtT/KNQB93pXlN1z07WijEhMkP0kQPn64FmNF8Fe+myLdqffUTGkhtfw7Plic4OLqPNo7R8e3xUEh0+LIAgpWoWIL86hE2RteFG36iy/1XFhWb25U2rQKSmwttLYchSgFfaHiDDZlUQKmSqoZ0q8O4QP/zWNjdZEUG+43JI3xrUYqemruK7RQb8VhFnDEUNym7FEerKtoO25ahAR+eIuEFm7ODfKPHSdy7u/zhX1xgXi0ZEeHWznyjFI6cfzPQmLkEyPj69bvJVlqHTV3w2GR/iZNlzIdL8rsOTMcp0bqlSNOo1yc6idTqB/pVaqS3QWILuqwYUVQoUkoQ2Dsy/pGzfwCQg78r3YHWrA8/H7gMlOMo2TgA/2HLTUtGg+4i32DoWqHx0JIPMgJhSzMqCb9+wNDxZa/x7W8UYhSVDSQcthLilb7f3tsnqufrHPj9UVD0RQtEq2NEaJTgvUGJHc60KAxY4/XByKWZHkwOqdEHqd9fOVGfnHCojKhB6VPEvW9lcxluPgLJpKSDxSvCmaWDSUGmSZnRemdsV3ZCoFmY77CnmTRAwLM8DWr9JxyUDTLAyzg21fmmYfZZ3bLotcGQwlmH0sp/VuUo2FtOkhTonD5DgMwagaVbEYrzEMC/dTKE5utIMXtL0nhDk7+QUuMEKsTz0sjK
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6150b6-92c1-40a4-bc2b-08dbc51cf5b5
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:37.6273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQcJ4wH8S8lEmgoHQNdP99kdBI5PlUurmtB4IMLIUwNV6JJwBrHx1n30E8rS7s7SvpK8LKzvWoMVZy5hfSoYG2gNeSSSJhKxQKg2mmx/A3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310040155
X-Proofpoint-GUID: GvriUGm8SdKo5hTKziB_8DzZR5hUw0CA
X-Proofpoint-ORIG-GUID: GvriUGm8SdKo5hTKziB_8DzZR5hUw0CA
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
index 538ebdf42c69..8c10b99c5ec1 100644
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

