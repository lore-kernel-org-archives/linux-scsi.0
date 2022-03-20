Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0F3C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 00:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbiCTAqF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Mar 2022 20:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244497AbiCTAqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2022 20:46:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C73241A1A
        for <linux-scsi@vger.kernel.org>; Sat, 19 Mar 2022 17:44:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22JDXB4l027608;
        Sun, 20 Mar 2022 00:44:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xaNqMKHMxMEPSNPdOQmipmWUgkkqiGxiIHveNJx2zoE=;
 b=xUq5YsuymigdX35Ed24xfz8kPKdiznsM46d5OtmiPH3LKrWNnbaOTYEoBfFYj6gO89Lv
 AIhs85brgvBMKJNDb/VW9yoT5YEOQTdVHKv7eIf0PWDnka3qdgIUXtOtyYQ88I0yrAT9
 E7xpL/5sscWIIXVTxp6BueQXPZh8fQp3nGdES4EUetFpxUX+FuIyMvEMqdidjAYucRMe
 GD757+AzLn/5Jr7xfp+NND6dS+OIe0iDi5EDcYzG0t0rHVPgVvPlk3eF/vnyqH3oenQw
 mFlJzhVAOmCJ8ZYeVDXGWHWW6lasHjqQJhXkaRGAuI9uKtJwVpW/DcBh9Yt54i/ZM6wM rA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5y1rw2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22K0ffam137063;
        Sun, 20 Mar 2022 00:44:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3ew8mg6mq1-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 20 Mar 2022 00:44:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dp3M0HriiuGMhSIgZJjU4RV+Ihbr0gMOISmHHXTVp9cnvMBsFpvaGpEbj3/zq1L5KH8weWgITObGbXefpGKAmPzZs5IvjeRJbntPYfHda+HcEEF7Pnsr6B2t9z6AtbPCSe0iIAnV6kC5je9xQrexs+aA5/yFtUc5Bz3h2Ry2yEPNvpsdWeM3bFc7ZYERCTBFc/o8qwak0NUpdvHhmRQ56Seo2Gw8qUnF7KejOeH8ojpcbeqzZKNMn/MQrLAxj7fGbCW9qY3NiR8jsDRL0uNvtUM2/nCO/V/nJzP/iUFFMLTHOx718Xw5uM1j4zQSgfmRf7LPWfdtkORTodR6g+hlFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xaNqMKHMxMEPSNPdOQmipmWUgkkqiGxiIHveNJx2zoE=;
 b=BQNjxre7hNG9aa3/iQ8CrW+x7mxpNKg56bzXAdf44FEstRw+DzgGPtrPYnLvhX4ejICgU9uEuGfaB6WnDCqG87HnTliWqyRH2eXvLIn1VvYtS6QcpA3G1UEvuXWigZMpbSTpJ2sz4WMczSG7pURy1sNZs5clTxE72dmBvkOADlDIKhzS2kNZJIRFWHi82/h1dggwbveQZrYCW7X2R34V6vGWiNKHT8Ke0Kz0PVZGz4Tc4CsIFjesmReHhew4wl+oQ12/rXFOZIrxY0GzDXzanOV7QfaUUkuh/tJxn6fb8QObW89ePPc4t1VwFxF9pJ/Mb/ahJKM5zCP/Z3P+Q5QduQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xaNqMKHMxMEPSNPdOQmipmWUgkkqiGxiIHveNJx2zoE=;
 b=MECbXDN3Cq2q4S76kaHZ6pt4QRgwoYAlRjenxvSDU7qGNbrvveuMAFjqP8RjtGKs/dQ4DqBkDT0yS5XqHdwJ/T9CCqyBSXKDdPe8sBEFuVfsfly4DVSZGRcIlthDTarCGxmE3Pb3TOWr10+ac39up71OwcCdR4FKnRlXeJdM7Lo=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH2PR10MB3992.namprd10.prod.outlook.com (2603:10b6:610:9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Sun, 20 Mar
 2022 00:44:15 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::78b1:38c1:cfb8:537f%11]) with mapi id 15.20.5081.022; Sun, 20 Mar
 2022 00:44:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Wu Bo <wubo40@huawei.com>
Subject: [PATCH V2 07/12] scsi: iscsi_tcp: Drop target_alloc use
Date:   Sat, 19 Mar 2022 19:43:57 -0500
Message-Id: <20220320004402.6707-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220320004402.6707-1-michael.christie@oracle.com>
References: <20220320004402.6707-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0065.namprd18.prod.outlook.com
 (2603:10b6:3:22::27) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93639b0c-9e16-4047-f66d-08da0a0ac26c
X-MS-TrafficTypeDiagnostic: CH2PR10MB3992:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3992610291E47C034917EFDBF1159@CH2PR10MB3992.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfHGArkylfFHvVgJVIQxkIDJfF2sssLSrXpu24Y4Ilpt9FsW25lp94vAnTIdE4RoWbD+22wjKjP26XJwX3frJvFibbbgKCr1mDNCW5miKOyqfw8bcqHw33KLdljuiRndo4lNqPNzLrcubv0IYY/usFWD6AB1QlSgokq1Tl041mXf9cnRINNrxQZosZmvNbrsrsG549ciMKx6W7sffcHlj+qELCnNYX6qH4aMBOMyRR4IMehYaQ0K0JOdr1jjmvkkwsu/aXeFRTmZk4sFDhYP6IcGtqIk/hRVbII+GYmBNKyRvXlIvrwboa2lRgheqCABalftUE5nbWchhur4E6vN+eT3KgIk4N2E5bc2MuOFKmRGgVncMEeaTn9j3GqFWpzbOmHpuGxB5D5+HYFiRU4WTwlL4ctCBhJOKhXfbWO1siaZGS5W6Z/Bggi81Gkh1/YPfsY8mT6Ey4+hqdRuVbg6hpK7MnJ7MWi/MMevogeRWdxVjjLLRKrohkOEk4WV7wIxz9rSy2hufjw/hQetJmNq+Z0RT9KO7mW9UP2YB1l/Zzrx3YqQbJx86AJJTwbt0Quv3hgK4vKAaVWA1K2dQKc2pwzI/ZXHxi1Csl47Jinmi+AQ+Yy4H5JTlSm31IpZjlXg5h6StJmU06T9sY5OZ1EjTPmJs2q5ck31I4nFK+BQQVvA6YC3pVQlaLuSPaX9yGXoEYHBYSPMRl31c7E5ZJ2shg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(66946007)(66556008)(66476007)(4326008)(8676002)(86362001)(83380400001)(5660300002)(6486002)(6506007)(6512007)(6666004)(36756003)(4744005)(26005)(186003)(1076003)(2616005)(8936002)(54906003)(316002)(2906002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FIm28FvltXUJMeC584ANl0VcFsUzp4WhdtzRUn4QpGDeeXi7iD0VxuqqVVUw?=
 =?us-ascii?Q?J4xLN4jIFtO8IlgQ5/OlQSfov5ZDXXxhC4m144VUh4qCQ2itQD7yHUsz2lPq?=
 =?us-ascii?Q?0gtI2fylSLCX6OvhRoU//C9+3EP1Ay6NK12dYmR3aVhOz7e/q6L64cJOKSxo?=
 =?us-ascii?Q?iYb9fiHREhDLacozj7K3uRRg3hg8gZYCtYvEsSA2Z1E2mt4SBCupcAxKIPZ4?=
 =?us-ascii?Q?tMFsuWG+qlKBLSar0JKIs4hohTgdokUCtIiDrl2Y7pVFiITK05rVvZFYDaTt?=
 =?us-ascii?Q?vPRdABOKQ9oqItiHwo8sKZ99BAzQvb53wkFawqFLBT88e/KsyxWZ9JukJ6uj?=
 =?us-ascii?Q?x2UO3pPoxmYtHScbu5+Qa/WdHWUWhV302eXCAZ0ULjXlP/vzjzU+g3fIVgFs?=
 =?us-ascii?Q?eCy50QK35lQkqlpaYF1L6VZqQnnDDvX7FpR697tJj+NP7mGDtn3bXrCethOa?=
 =?us-ascii?Q?F5rNIkp1gdzxnofuzGydAgVylv0QN3knPp1+BqMTGmtNtsKyWO2AwlNcHyi6?=
 =?us-ascii?Q?9j//aQDlxHJQSe8UMKIpoqYwKE9F0VN1e0ZX0Kn6gHTd8k5/onuy5PkYuuF4?=
 =?us-ascii?Q?2ktWmysX0p1BgaQNuWyo0V4bWEIpUS84+gSUGsREBoYnnGHs6eD9WmJnnL71?=
 =?us-ascii?Q?ZR7xvbkMyFNaz9a0b++UFZzZYAzKesb0ElvD/vQnoqugiMZ2HCOWoJiiLXt3?=
 =?us-ascii?Q?Zdc2vnK9FT6bYfvfegvC//8cTyA9azUYpvzMLrc0i0ZNwh7wVDOv+vPCphOy?=
 =?us-ascii?Q?QT8Vvzt2T8jI6L5Xkh786jieDO1FJe9adTSc0bHJhA36gWJWMtgoSqokNpVl?=
 =?us-ascii?Q?+nKLKT+NrnSUCg/X3q+BTJ0cE6V9YzugdIrApsDCnU/BrhVHpgqk27UNJnSs?=
 =?us-ascii?Q?JAV1oe942QSoKuTwacutvaW0uVy8x9hiDP5YgczXzdhPHjVbeBEiDVJqKK2B?=
 =?us-ascii?Q?JigKQIaQkcGMhOzDHHKoEAh5nCpFzZ7t0VS8Ro+QQXnAqA6F9oEnFw3rBrAn?=
 =?us-ascii?Q?AWBEQx6Qnm2bq+z8Dz8t6mHoBMls6gH6IqXwQ+r5urbfF6nubAd2MdmBb3Cb?=
 =?us-ascii?Q?ee+rJtWziLyRE8H+O6JU7nwm1DVwzF7WoUW3wAsYOQOJOB6GPlR9XbgQuSgG?=
 =?us-ascii?Q?/dVnqYGyPuiOE+vEOHNeaCaTpOzJxlzNzqM+0UV41HjEJQNGq6sB4xSBt8AO?=
 =?us-ascii?Q?aCBXrtPCYw66SSRbDjsT7UvZ8gpTQgYL1nl0hDir5s9PJodZ+j80MytdLM1O?=
 =?us-ascii?Q?Ppu7YsuK5Nbk5OL5s7LuN7XiifAzphJAZDJ7Tw9yP9Nh4Ahg2gnJOgpyc/Yj?=
 =?us-ascii?Q?uIenWFMhN2JmABspH02sy5vA+alXl51lVyRpH+q+AuNl76CJgGDwoay/QSs3?=
 =?us-ascii?Q?LqvneXu37zf+aLJ0t+0IO/+wooFQo8wBd9q7zKPrD3htCLNE/X+UtgGqxLw2?=
 =?us-ascii?Q?pjXKWjEJXL/0MWWvNykfqToUImI8BPNz2WnodoHwK9gvimLB1wHH1w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93639b0c-9e16-4047-f66d-08da0a0ac26c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 00:44:15.6405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNXuPhUgeCkk7i9sVVBdGADToBZbPecO6fxKnPdud/STh+HrVrhSi0gHoHbUW9Z5SltLtJ4enU3VGgMD0AsYTN86lLnJ03kxEJ13LAF1YVY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3992
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10291 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203200003
X-Proofpoint-GUID: ZKKz8CadRdkfHJXy2YPbnCgil0bmZW0q
X-Proofpoint-ORIG-GUID: ZKKz8CadRdkfHJXy2YPbnCgil0bmZW0q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For software iscsi, we do a session per host so there is no need to set
the target's can_queue since its the same as the host one. It just results
in extra atomic checks in the main IO path.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Wu Bo <wubo40@huawei.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/iscsi_tcp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 067f71a418c3..e4d633380db0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1039,7 +1039,6 @@ static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.slave_configure        = iscsi_sw_tcp_slave_configure,
-	.target_alloc		= iscsi_target_alloc,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.25.1

