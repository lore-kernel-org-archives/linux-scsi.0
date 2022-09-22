Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E24C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiIVKIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiIVKIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:08:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E08D5777
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA41np009748;
        Thu, 22 Sep 2022 10:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=rWibl0AxIVBIAnAVmqUM7IeCdGXz5FJu/4mjS5VQhu8=;
 b=FdTaT7Gjpo6+WPHbeLjaDvy7VB0VG6kjDOuqBHPOQSHE2x4c4eJGl2pkIko+HbMrqpWr
 CCNLeE8yo3hl57MNSvSTCjC4qFy+4fJ/kovDuYz7Ty8rjiKH0X4Xj2IldidS66Yk+4tb
 ycCXVRIu8B9AQw4bK12kYmCpLfqsHtnAT3EbImUo2fSN+IdBug+fxLattQoHNCsatcET
 meEMtCmS0khAVY3QfUX+stifsf7n89WhezqrX0kBJvA9a1Gi5y76wj4S8EKcsyYvRdeE
 rXcD7ApffVi33ep0EuUrlAPrTRLzz13UrN6IE+UMSHrb/zq9ynoGMQoyfEYXd6vRvhKd rw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688mgpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8l3vx032017;
        Thu, 22 Sep 2022 10:07:38 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39fura7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6acta9RGBlL1IOJ8Fbivp2ljXfKYH3nCk7CtoG332ustASSRVnuYwNS6vyMNchbNw54zM6jPMbheDSPzT+jMU92CNz9eG2OXO20HbSvTEXl5uzhEGVLLR87voRHJSR1VHhKYM+1Evc3fNgPaj6L+XIR4+PxQ9jtA4JtwELhTh8GTExEoIZv11/Mnty+st0gbokHhFLx3C2GrTmPq3Kk2n5h2DAiybF9qCTN6IEzZdc+Je80aCkrszfZIXE0SB1EfWa39fdIzUpgRgsxWx4k0ID+Pl+2Mkh8CwM+HfwmU0AU8thHh2Ry/8FUaSQEGQaBOPELX6XZc2ZaBUH7zvB3oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWibl0AxIVBIAnAVmqUM7IeCdGXz5FJu/4mjS5VQhu8=;
 b=dc9TkZqEZ74ESSUlvoJfSHyhffmfQTvDd3Mtsxvl9BrEYSPpDPGJ8/EREpi7DSTpsG85SCl9jOEESiyVImfX/ObRLcMxbs79BJvYGoeX3HGLZjHb7Egi9tKVFyMnhMyCG6cVm+SnvdxqgPCqvBcMLY8cLX+F2IzdO5akb5b7ft8k0an8KO4MO3yThkqMOPgq27N9Uwkgz0BbRRy5uuB88et+5mvOhRGNPkLL/gXxqf6009LwDAhr9BRnX5rSiK7hY1egFAf+/ozr72kT9hJ87TXJL7MAduys55fyXRoCJm8KXTJYo8Fnd+eAmYHZ+YwpJgn1gzf4uU1hJjEWs8m64A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWibl0AxIVBIAnAVmqUM7IeCdGXz5FJu/4mjS5VQhu8=;
 b=wnU07+WrDuvpASPcYf8wx7V6SfDKvOjNrAzeSU8tyZF0/CJnGQVoJUvgo9XKpdCkLUS/Zt4Q3bhvJEK+gbt+ue/EDO4yB+BLw6X28OP10P+FlsXcZ5bzku5YCIvab+QD1luo0p2ReFG99uIlPBFVdWCfGTmc1S0hG+VUbMtCBtA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 10:07:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 18/22] scsi: sd: Have sd_pr_command retry UAs
Date:   Thu, 22 Sep 2022 05:07:00 -0500
Message-Id: <20220922100704.753666-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922100704.753666-1-michael.christie@oracle.com>
References: <20220922100704.753666-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0029.namprd15.prod.outlook.com
 (2603:10b6:610:51::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 83244970-b5a9-4fce-a182-08da9c8245f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uN5/7LQA0+ztTQNe5fkHYz16/DJNaurKrxlgzxhO0+//u8kev5Af873g7C4d6weTx/zuLsw6Evtrkl8bmq7tC2vXDX7zO7KaPSz8ya3kTOBZi+3RbSA96H+MTgfxFohglxXQep9axfJ11dXlgFhO7pt0ETR93LBb59VcAIeatgbBmQkrfd+FKi9altuM4Olbv5zngi1czx+utmeqvexDS/ayTBO07kW5WRwh/dRjLZ1454sqeT18V1Y8PQWgxzXsTWeMShJOl4kT9e/XYO/eZQ2VA83cHMPsyYB7eeMWKRZjGsaRK1H0JygwCt0t689Y5YCFsbYg3CYn0g8LmFIn0vEVUoqWd0RvT17jIRkEJdwJNbGz8VMEfewfozwklhf3uQ9qle/qQdsetf7hxHb2T0nJ7l7/m//4heQQX404N/M/ig4fX6m50Rdee6oJMLXrS+pA5VbvXoYS6eVm2VIB8xm1amk05IkE84zrKg8pjBx9bPUq8x+HvpJOnPayB2+cgbf23EcGQFsJ57FOBWLcbDUSYJ4Zj3RFPFAHwqz91Ae2KhHP5CBdhb7Qv5kIDz3uYHJ9+zhrLRVE6KRRL7ARwx4am3jU/HXCVVEld27GI8sYRtX6LCuUg3liw/JOSAgQ0Q1+p9STy4sAWRlfVS8iE0pLRs8Wg8+4++8HrPCzd1R2gknY8l730moOkJ0o7N3a1JHRmVyTHg9E/GgIxYPk8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(38100700002)(2906002)(6486002)(478600001)(8936002)(316002)(5660300002)(4326008)(66946007)(66476007)(66556008)(8676002)(36756003)(26005)(6512007)(6666004)(6506007)(41300700001)(83380400001)(107886003)(186003)(1076003)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1rraUC6BIkbfBv9KEoJi2Fv54u6uSXHomv1WMI+Qb3VOSYszTTQICTWwplx5?=
 =?us-ascii?Q?w/8Hva+wwBIrxbOp/1VXLYHqrJRW/3WjagNHDHP0wxChi50lrhvqdY3khzlr?=
 =?us-ascii?Q?Y/AIXmAk89SI2zkEvl1lWXIxc+adatpg6w8CIJ4O++2pSNR88xXZsRfDb9Yq?=
 =?us-ascii?Q?UUyiXvNi8MB1GEx914alNfOJK5XfH8CwgmA8jTsP/ApZ2B57CNOsJgDk5iAU?=
 =?us-ascii?Q?OUmWH+5D9rQLhBR621mzYRFR0EAFjN/QAWBcCt5FybHwLE2aOzZ1h4Ows9Ng?=
 =?us-ascii?Q?JrQQM8BlM/H8TRctGPlZ9g1Fc8FC8lHDdfpad0D8IZRyj8fELgtRgkL830R6?=
 =?us-ascii?Q?uoAwOa2BIUdHvItrf79WHyrMtsEkZRe/KSCgi6KKFQYMvHXY5aNHslHIm81t?=
 =?us-ascii?Q?KT3bouxziQVimbwFWqPz67u0rQX59yJ91DTein1AOrgJhtb0+YVLNs9v9p76?=
 =?us-ascii?Q?Ot4WTFyl10zfC66sIaEB3GtHoFwH9YBA+1YF/oBXZ9tmGyPpOGXHf3V2Us5l?=
 =?us-ascii?Q?TJf26zobC4OBv5NID0+IkaCubbupt1gheODVA+s5Dxb5OCiCWTXj+rJi0tCp?=
 =?us-ascii?Q?vfV6qLM6AFUB4l7gVaQwBu/pPcopUOW7f1wYLWf+Plfng94S9K7K9pDCXg+A?=
 =?us-ascii?Q?Kc0wpjS4CORZGwrZMsIDcNoc9uw95irIGoQzOr2IF1/dF50Aywh49ycukJbx?=
 =?us-ascii?Q?NsUvHXY+rHrwFXXkSr853rDaJClfUpCJo3GO6bsWkN3VLAH2vpQbhYp9FsKH?=
 =?us-ascii?Q?idhX5FmpAhLj+wgOp8ZpoYMTEDWRwlaindjgHJYsW36fiUHJJW/uMCIIwrrH?=
 =?us-ascii?Q?eDk0/sWj/Q/dbOxsc2/MVcjP8mKbq6thdeRdpFXrp/0L+RmczqyzOuwLJwAg?=
 =?us-ascii?Q?mc8Nf50BBFIkzguAwSR/9WHgI7MkvvuSGAU1OooeMnZvS5NSeTukm1+P81pv?=
 =?us-ascii?Q?e8GBmbZ6lV2dNud89YZEbTWbDORcWctxL6CH9Ws4cWC453fNk+bHdoLjtk59?=
 =?us-ascii?Q?Y0nkqsXe4hrjGNznyKsKHbM7R8Jixhi7ZhdDaL37bfs/dYmPaHj1PTd4P2qT?=
 =?us-ascii?Q?kNsppTr5LrH3baoNJW+s5JvBzac0xOwTu2CrGuty9COsMaoTgysuwRCIUCZh?=
 =?us-ascii?Q?CkMcRVYJXCotNfNZdtczeF0jpyIF1p0uGzorAIAMQB05XNzmWsAhga5+/z7d?=
 =?us-ascii?Q?MJ/BNIFNHWAzh6JazKENE/TjP7h4YQ0zg93YySqb1QoiGrWd+MqYre31faiy?=
 =?us-ascii?Q?mMipw6kLdAdiHhLhsduK4Qf3sTdnPxWxOci/YsKktFX5nELqb61n8JjeqD0t?=
 =?us-ascii?Q?yznkDkwylKyH40/t+NktVHA5daHND3uTP3Rn7Xe3Me5sVzYQoMEuEjlS/zD1?=
 =?us-ascii?Q?hIoUV0hOP3KxE9ZM7BCUvUWr5S+a4kVSw0IYWfW4rzRA8sm9kMl52WsTj07v?=
 =?us-ascii?Q?thXpApTI3K+ebLvzQ57oaTWTS/VSHY7zAyiLG9duylpuR2LKKq13Fj1N+TaF?=
 =?us-ascii?Q?Fd4XPx6cXILOuc1WnmSUe6Oe53lx1zuf0wF00ouL9+taSNzeFdYRcuzPT7PQ?=
 =?us-ascii?Q?JmVjZDtNQPDnhZ/zyNQ1ZCMHSCJiBFbs6xD0x3n4aq6/BlqCB22eAhgm3BYl?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83244970-b5a9-4fce-a182-08da9c8245f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:36.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +qOt3Liya1CHH0A/eRUKb2zYMc4GOQ6AsJBU2PQ9vHK1bhoig7znW4/Ippmm9zFEXcAXCVgB7zT/snZBNf5edzx216sSqh40o8/9ESGsadY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: RPgE_94f3buEIqkvanWIqvVRuFhKUPKk
X-Proofpoint-ORIG-GUID: RPgE_94f3buEIqkvanWIqvVRuFhKUPKk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 264c63b10e06..d655549dee94 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1710,6 +1710,16 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
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
@@ -1721,7 +1731,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	data[20] = flags;
 
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL, NULL);
+			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL, failures);
 
 	if (scsi_status_is_check_condition(result) &&
 	    scsi_sense_valid(&sshdr)) {
-- 
2.25.1

