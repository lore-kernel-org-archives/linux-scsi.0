Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50259C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiESAgb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiESAfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9431A14D16
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:37 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIl9r005304;
        Thu, 19 May 2022 00:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rijvphyjeMnhCbpdcL8uF0LN9Dq0GApnePASr9KfJao=;
 b=Oegq+R3x3ed/SpNXy9Chtnx3tQdTDLBXlyNf5VyKm7THFNsdEjrl+furEvbohe/PDYBl
 roRTh3o+EoBRdv5BAs5oOVoVyBLxXd5Opmtit08LLkN4eo3GvZ6ftPgwHEgft5EtYm1G
 cEGon9eLLxrt0eJ/soY/OI1hBKuclNgnsOx6miXGzR9IJig+Rdr2u4WTazzapEZ+BKSV
 oOZSeuSLe4ubRLH3cV4Uy8FJAzyVoPkN7hO+ZD801JmRdV6BRfVgDfGVkEdl7wna1sQf
 I31ZA/yxn4NkgW0osFOYDKEoh5CrjEo/PG6jOORRfEIEQ7kFyDb0b43/jhLcik+jisuO vQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g23723162-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4V7015306;
        Thu, 19 May 2022 00:35:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOqcZFbi8rK0I57cxQV3pQbaiF1qhze+3kMPRGopllBlRKxjaI/RRlsGAzB7vqdOL+sL9VDIq65nwGzD6IO8VsTfpqDUBLvUX0XfRXDT9H4TTzhMo90UnbNXSoo91RVR8ZbH8dnr7Jf7Eke4UnxIMIi1ooJQrVROGFfiSFb3DoF3SgWD2rmYmzZsrbCiF8RPKWzshn+LCCjai7c/gDRO+LVidICZIBnWzVsiqNZrYuSDxu9T8xSETOCRbaTw32eauL6s8wmGdX73ulWoOH6oC1wZJWuHD/OPmwDV501MfDpI5AD/K15N+X84dW1OlBIE4dNUtHtLeNR3oOnH7Rnwpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rijvphyjeMnhCbpdcL8uF0LN9Dq0GApnePASr9KfJao=;
 b=j4Wj6+NgaIXg9gEdAeqPSO7oFfdjThdUYDdqGUmOoikey/PZSqdJ7feE1Z4r09AF3zr1LQHQHiTmAP/rEe4+mIJEJvRuisBhS7Pl1iCmZGyAHpcxzor5HEEsNwdkNSVan+GkKiWiXtw+gEOFrYvIUk44XWxj44YaFhdbAgH7WShNeq4iES4gI78OCRIDac2j45Dpo4ohG0NyHXaPzS/hNRj/rGQUDwL4upnnc4u854S4JoKU9o3xNOO1WNTV6kcCabzo1z54Kko0AQ7Yf9Cl49TA+IaVQN93/GyM52N7xiOdThAkGxI4eIu9xVeaZoqsXj6eQNyhJ3qqX6k1f/ygHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rijvphyjeMnhCbpdcL8uF0LN9Dq0GApnePASr9KfJao=;
 b=jZb4bwP1asJg8RmCjt8e7W2te6x6S8dtkJgz0sQ3eMxUX9l/FKVGQKPBIQJ4x5CTbs3TucYLhQWsQTR6QhCwxVg0lu5PEWWUwYYJPpD59iDiwJQa5zRHlPw5TUS7vhjH4l4e+EJLn/xx35/vqwm/rLsP2kjWM1FuZhrwXbu2dQM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 03/13] scsi: qedi: Use QEDI_MODE_NORMAL for error handling
Date:   Wed, 18 May 2022 19:35:08 -0500
Message-Id: <20220519003518.34187-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21e99e98-d771-45a0-d954-08da392f77f1
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30202F30A93E9DAD4FC8C2B3F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kNYwFrE71LW3QYU8mDXIgmzRRpttnUJNU4S5GGWKg4vWKJbtthbRdVz1VtViOSPo1oFA+A8mAAUp1ORt6Kv9dirDULyVDaq2Z6A36vZMfCIBxcS5lROQF2Cknz4rGvNPuXZNaJbEdvrD9cEm0a9zuh7YFM79l7BmOCWHY7ps5ea+y9dhu/8wVqm8FESA20kAqQzyEl2JZ3MdX4r0PAeW3ENIHWuqMB0bboZ4ZwSn1P78L3jfWKdsoqhOqrw+Tw/ffZakZycwGhaShVuaHjsybEbl9Nj6jpHRqbchekixBUQTkfZIRxsJUcLXOU0FhoGwiMRWYExidisVvf4ZrNjmZNKSlQvgHzRh1d7TRPEkv9Vs3solA0Q5DYQPqo9lL2qNAfipnb9YQC1SmBhxIQEGydhRfp5rTwEiGgikzsS75664FR5wTU/cByOkGvwjJ+93qx9cdTiSZgy9gT0CVJPN4za7K2LxfpMs07sGWWnEkJMkFTXm41wIS8r+qm7krXBoE1KhXtLYMal/o2C4qrbTTOrknNO/QWY1Z6mOrkF6hBkNFF4v0QprhDcdAVt2V9xBFNfAwsk1RgruxeRRet/e6kyj8fseUckWBUoRLby1+P+9si8AWf5XauCv/Ea8kYHofbMtec4G900yUYxYhhv3W6VLj972fQji1bWyqPqq4GsK32GQfcNTfaUyWt09fvqPSCPQlg1WpfXO/bjenO68SQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(4744005)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AXA7foLROuVEsU1ZcAv7Ve5PsBxISBDfiB7b46crC489lc2IGZtD5NLxipNG?=
 =?us-ascii?Q?dsM3TK3zH9j8n+8kanmeG2xUF+dKcQ6psZuHoVeAj1Dcz2r8CXr9uP+ww91U?=
 =?us-ascii?Q?qgXFxxtzNAWVFH2lBvzeZ+ssVW2rB4K+nuADSu/iphe+9Dw23UkR0WbNKQl2?=
 =?us-ascii?Q?qFqQ91bT8oZ3QqaSARBzlOkaUwZSFvzPb8P+xJgpHmJx6UvzqAVTKXT7YA0F?=
 =?us-ascii?Q?xOtbcHLW1MCTpTBKwRoONrO8RkVPbotVOIZzUOVwm9kGR5BIZZMUXlhmBi5f?=
 =?us-ascii?Q?jGxGS9hFdUE6PghqhmQEe7HqcARhXKaLQxDvCrqR/7GHTbo7jdsaQpCstp+G?=
 =?us-ascii?Q?GU35L0RrDvY6sW3hn7eSI6lVPcYMIOigZsassNkoP0M/aDkfcMn1OmtmfhJd?=
 =?us-ascii?Q?D/FBjaVdBrpt5EzB/fG6keuLwNMYbpZElodqqj7g80tko5lS2pZiBjA0f3y0?=
 =?us-ascii?Q?iZ2uLuHJvnhWg2u1G6gKdMLKlQeTzav5Nzs5bwGXr10cadt5+ZJC6Bb8ui+j?=
 =?us-ascii?Q?h4bHYNWFQx8bDxM9+MhS9AaUYoy9aihPv09OcfkK+uizItOzbZPSoBgbWLza?=
 =?us-ascii?Q?XxWMLTt4UljbRyW8AxUk/hJNIdCw8FWsKAtT2fZdiOkC3iBiLILeES7FQj3+?=
 =?us-ascii?Q?12dSabYlmqT+WuTYT4Uy8OqfQZZlIX4SgfCqjV2ucx0kKibewjUbSaQi4hRL?=
 =?us-ascii?Q?9rUHxHTgZpBf2IlheyRqHmf9MtRZZ8ToTz49TgtZEqgaHSMDhyl4xEjVR46t?=
 =?us-ascii?Q?61gcAmxxk9m8IeTHNOVrRQioNYKOK5SPWYmScBM1/kX14vLnHPi0rvVQBxnI?=
 =?us-ascii?Q?Q+FSyQMRme8AyeNwUSzbdo4KRSf4Advk62EJf0HUAxNqj2IOHWGetkWQMGIu?=
 =?us-ascii?Q?DLiiq+zNKV3xfgmiq4Ym4xWykRzW//P9pyyT4WU0Wqg8k3EOXp6JHBuCgLxI?=
 =?us-ascii?Q?cpUHEibWFpJQO1QTOPoy5YoVUv4KwJ5HDW70AS+5vjH8rtqVM8387hG7/3pc?=
 =?us-ascii?Q?uCgJeYD3Nra3IdXPCt8vjxzI2wUet4mumx47HWX5bZcqXrD0OIXIPgykob8K?=
 =?us-ascii?Q?keiJKfgww95FHRhmYHwdW++l48u7BA1mtrp+cNpbs9xttEbnHr1DdCpc1Tzb?=
 =?us-ascii?Q?Z1EuzZfVL9uaYP5VcGJjD9CRq6+KtNLIu3YwrinrceUt38FMuXxJPRHaJ8G9?=
 =?us-ascii?Q?GhIGMhEt39+PVfRT7D2/UyzXziu1HizfJPC4ksdM7sqdLPvYNcZeCmjKkmom?=
 =?us-ascii?Q?2t/KcIV16Pl6kTkAGRRcQ4d0B8nEynGJhTuqZf5owmFZeYQjK2jtvnmR1oAc?=
 =?us-ascii?Q?flN16mhh4EzKwQ4IoNo6ijjVs/65UdQBX4dBa9Q9ULtNCYhHQlpOSq9OD6rf?=
 =?us-ascii?Q?3iKCtLcD8rldkB5HktUWBRuqm1UDCojxA1PNkPGdnAveH3TA/WK6Pl4wwmbo?=
 =?us-ascii?Q?TwFb+uITdFzpi6H5GUO+hKiFWebUYIWvJ9OKNxpMIRXl72jADdVrkOnlBhaK?=
 =?us-ascii?Q?3FWoaqqBLtFPlgbd0knqf3WaeHxSf29k+HU4qUZjMQHNgCcuTMR4bzo5ycQt?=
 =?us-ascii?Q?9GW67KhUpL42KLvLik3qMe242UjkwB6t2XKwWp44xb0q5C/NydA3YQg9ndaX?=
 =?us-ascii?Q?6rwYj+6vF+AQuKPySPzkWc41w+qcAv43qq7+jpqkx05GfcDkg27928wkJ4ld?=
 =?us-ascii?Q?iOdtK8jiZo65fWAi9mzQPBd04XhgD3/ESZOiwvSXWa+08UMp49VW/0nTjLG9?=
 =?us-ascii?Q?yd4tyeTeKrRnYNfURDFO5T53+OTAQsM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21e99e98-d771-45a0-d954-08da392f77f1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:26.6181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5+Olhho3kLCkBIIyn1cTUmVPTH3vwhl4/h7/oUn6YLSWm+wb2a3FPqh4rsLw6eXS3dIzmFByjEbKS9Kh36WhYo3Lw+oOqN7KxAlLPTEuNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: MMMRgnoHrvFwTCW9qo_SAQvLfupHTJKj
X-Proofpoint-ORIG-GUID: MMMRgnoHrvFwTCW9qo_SAQvLfupHTJKj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When handling errors that lead to host removal use QEDI_MODE_NORMAL. There
is currently no difference in behavior between NORMAL and SHUTDOWN, but in
the next patch we will want to know when we are called from the pci_driver
shutdown callout vs remove/err_handler so we know when userspace is up.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 83ffba7f51da..deebe62e2b41 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2491,7 +2491,7 @@ static void qedi_board_disable_work(struct work_struct *work)
 	if (test_and_set_bit(QEDI_IN_SHUTDOWN, &qedi->flags))
 		return;
 
-	__qedi_remove(qedi->pdev, QEDI_MODE_SHUTDOWN);
+	__qedi_remove(qedi->pdev, QEDI_MODE_NORMAL);
 }
 
 static void qedi_shutdown(struct pci_dev *pdev)
-- 
2.25.1

