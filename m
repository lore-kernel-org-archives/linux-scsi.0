Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61540C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjAWWMh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbjAWWMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:12:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350AF39BAD
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:47 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLhto6012751;
        Mon, 23 Jan 2023 22:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=URXHOzeksmNXgv5HYAoDfaGsM7Vyn4YmOq/KPp4BlPU=;
 b=Byl69ALZWgDQlxrNbu7e8bCQGijw9vV6loDJRsTEQLMDjEMd7JQyS6+Q5/PwKDcPBJGr
 Bng7ApcfRw7pe3KeVXjp07aY0CQoI3YQh0tqO/cq5oEM3HB7uIP/Hu2EUGSNhq3rYY+C
 jiFAbLRMseelLntcQb3HRwSsItmOXkkQnIbxMeHCnHBtxuc5C2HtpDa2nPAynj3XhmNB
 pZpzRYSHr4ATfUF3NZlWRFoEXOvV+vvO1A6lOCa7J7cQpnK0ufjKSG0yMMCxMwrQXdOL
 PQB4aRjHvMMxlMQP5Bl2kKQt3OIt/y3GCpc0c85IqhgS8K75yydvEnCPWU7U8BdI9sJD 2A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt41cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLMEwJ023119;
        Mon, 23 Jan 2023 22:11:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g45en0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ly/cx4Y6F/PAX+VST3Qa4sCmTYyaH5YO2tEpDQr6qbrvWddAf61bXqukwv/w70+sxz6/YwetBzEDapFgv8I1B201wPewmi7jmNscezlyWVSoJvzw+N4RN46BlRPsxY3QoESE6c27bcODyyd+XU9tFr/D582mMENFlZ3qz7yfQT7k4FOG7y/T3cIdWFaW1n3ZIDqyZTSrAFnSldu80p4hl5lQgtJKh0ZmvWolJKbKBvRWEdpNKcllQPe6hYZ9V3yaTP8tXe6IJm7ajydlSoHN087MwIO88xUCL2kUEcsqhbQLIB7ZBHCLMXGeHjy4yicqgIRJKEpnmOxENhF1XyLG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URXHOzeksmNXgv5HYAoDfaGsM7Vyn4YmOq/KPp4BlPU=;
 b=CNo2LkLad2Nsdb4COcJguSrl51VMejOlSUWOwsYul9NtsjIrS4vqyD7P8PB1fhFsi4PvchMg8gkY/hQ1682YDXJdmbQTg5HvukO41psDHWvo0y6TWrEEKE6+U4hu1EmnhR4SFhc5Ih1tIsjkwT5TsgMjzIAWRWj1x71gtJPy03bLg/7zV2hywjJjz9XtIi3D9S3fl2dUngDMucs2ijRQ1yxVh+ssA25gFYbbyjv1iESCkzoe/bzt3toasV7PM22izTA3XKkj3QAT+t+WfBFbRKHdyaxKV0sfRTaWsHOuRXUNTcnWZ0oCTe3f4m4ZFyC8/jhEntOH+BYcdP6ZKSkBUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URXHOzeksmNXgv5HYAoDfaGsM7Vyn4YmOq/KPp4BlPU=;
 b=GlwfB+1vkbufEvM5SbgA3+DarJaVm6IpAYCH44bxZ2zIfpwbgU0lIW/fdaB6gPwSTc1dIsFkocD2KW7TAtyYqVUYrOZHJGnBdCsYgmA5Hfkl0AcP0uB09nSYm1Z/rpDzR44BR82Rvd2BVhz0DW8d+36d7V47t/RBWDuDaMZ1J/o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 16/22] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Mon, 23 Jan 2023 16:10:40 -0600
Message-Id: <20230123221046.125483-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:610:5a::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 0588e01c-726a-4afb-8ded-08dafd8ebe93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grPuR1Dz08RxZWmOV0TdOu3/VTnXvJjqdxYqlEkDr1h0+g+amUisE9ch2Ab0C9ufzgSxpWZPIk11xVsEGMhX+XlQsSVQMtPSnDvBCMmh4vtpnWbP5Y4EVmi0QpTwufArLSm23ZjNPmzg4h3n974d+2pUd3sP6gwt4zCLDIhqAePUokATngkzmi1t+q+Ihg0JE0iIVrmoMbmyaPGDilQwdiYxJ8omOJbqdGZfq3XNSTGnlxJzofTlw3U3iu5caRUq1KhNRecUJq51lonoPa7SX5svNk8YZjC54Ti0Ha7Xc9SoMRodiZ3VuuZ82JmseTpNnqFvjHejlgWw20xaUHzf1jgj8eSxyYj2a34XFsGMQe08rjeZQnZjuo7I6tBAsKfkYMrBwAIdwf95YaccJ66KF0WqZvQh32ozY2DxoYHiFK81wywd7B5Uhxvcl0zQUtchck8A6W5GRvZkQm7J97TCeWIiPhaxOxiHz0oVs9IcmCkMhUsgpMKtSVRxUlBXp7huO9ct0VyQZfKiav9qKzjWQfuKBmX/YJcfBY7K1flxQmAvkmKMtWD7COs1EWBamgWjmeKUspLMXD5tk2tWAVCmHF2YliPy58sBTduYx1EAnB27nlckNo24qrQlrjWQ3cK65TiF0LzMW0V5I3FeMLnVMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s7138n/cR79zi+aYhFvl5pbJJ6yrA70fv97y69ZF91txZIIUfameG4Oaq4sG?=
 =?us-ascii?Q?fpJJSnXgjABIIWzzCJYthVUaVAnt1BoQoUU/IZbztwMbo6BSa1d9abor3VzA?=
 =?us-ascii?Q?ijbtlBYsU+Tcs5MjILOJRId/KLNwdhE6Xe+1VK9d8dkDnCDTOIMni9rBp+PG?=
 =?us-ascii?Q?vOMIXu65DZifZBEKGFpxdnR5+46fV3viLhGv6hLMahQx4PAxBEPnkzmbl3zY?=
 =?us-ascii?Q?XvTYFUqAs3f51hfQREvDtdbbNbu9h+xeEB0hX0WeMOV7OiBtW/WGqXZWHluT?=
 =?us-ascii?Q?xHmpGSe7j9+gGF7nOzHKs2GuhuOErKF2nKIvbwrfhEEXLc5t0I5zt+L7fn40?=
 =?us-ascii?Q?tj8IiIDXpG6IPiEYPKJsm99130fcKd54PiGbq4BDfsb2/8wVGXoCsx0UvgHw?=
 =?us-ascii?Q?fbMKUpt0R1ydQcAM9KRwTU5XvXq0YW5iOn33tFuKRF4xWUAllJmAOWgdHSoG?=
 =?us-ascii?Q?kxUr3a15ZMEjhNndistwsjE7LKbmetFkHN6a1sp9r2MNUps2+1EkZmBlf9V3?=
 =?us-ascii?Q?pQOVhR8TwC6JWWVk6WlO2gNDsWEu3zWXhitai7e5l6sWv+X+2tWNnAiby6O1?=
 =?us-ascii?Q?sEJ+iOTW9tdXMbjN98aV86k+ESA1NgcUP6lODdcVMCqXbLfefZ/Rm8u/sZET?=
 =?us-ascii?Q?p6XzLSKndhRJqhm2y1ZdZNSQiMqtkrg/aaFr0FWK45YKoUPdFqc75xhgFmcK?=
 =?us-ascii?Q?/Q6cp/cc9qE5Gr+i1qoAWLWbP9VXkfkM0JeS+9SQWYMwcdguvWW4CNNldtus?=
 =?us-ascii?Q?gxjxy6j3DQyuFvpJYmYWrvAhyPQ0SE8sUbvYKwe3ZkF+BhdSv/cf6+JTckOH?=
 =?us-ascii?Q?bDXk0Tnjuf1ZZXLLxEgJbVQEnspl8Z5rPTUuyxhipMjm9r1En5XJurTmc96o?=
 =?us-ascii?Q?FRwFUhBeRuZPsczT5NRnmduWhY1jM5sZGpFvUM1TWSzGT1r0ROn3NaH+ETum?=
 =?us-ascii?Q?IrcXq6fWRyI2oayuuQhpjwkP0qByPcRSOm0ZYR0tyiofYIwLBxsGZ0UbFRgw?=
 =?us-ascii?Q?cLTBHYtZAat/dSAKFoBV4eBFjvoKgLoI09DvhMUJhQJ8SdD3sCUZrfUp2o0h?=
 =?us-ascii?Q?CZxquTufN/ZbiV/zJ8FiRsUhQC1WxokfjP0xF/+KTGMTa8vykQKQG9DJbfi+?=
 =?us-ascii?Q?Pawq4tkFIL7w7d+K0g8oV31NPYmbFrnP+fcmNDqGczC1fkk2HU6bSCca+1eh?=
 =?us-ascii?Q?PHZzgRCyBH17G59N7TbmNKj4V2/5oTv+xig8dbGMZXMIK7dLVlxnV6g6UXSy?=
 =?us-ascii?Q?QXTL4hBEWKbRrz7uC/Ma8q75o4cMcbPHZ1f6puTSEzmUvsJoMWqxqnjDfEuX?=
 =?us-ascii?Q?cB1iwq3nXEC3UU8HVHY8mLNQSVuQgPnGuvGMAFA8As+j13WFum6GUF7w7Yo9?=
 =?us-ascii?Q?SSBLy0WOz47w5Ugy0XFcqAuE50+gbg9F3u+gWNa+NAA9+2ctv6UMlCS++zLP?=
 =?us-ascii?Q?ll/yVnGYHPV6k+LuRmQnLNe4l6mN4O+5FQAvzmG4DobeLH1osc7KmIcLXfVs?=
 =?us-ascii?Q?44HksVh0lbXKqgUWySS/kLJ8valp5+Jx2bam2JsgBlQJrm4f5y5jVu9Hy6XM?=
 =?us-ascii?Q?4od6sAqqzar5RWwH5bMta0z4iI4QPcZMk8WRE7XykQ/Y+nTOk5Cjkme490Ya?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HkXwTiVw82aSGgi5b7Yx2tz6Dg/xo4XmnFglADUGd1tPwummiz1jg2XX0P/eNsqf40z19Ogk68Eteq3wo8X4nssMB/MMQ6Ou9hWjv0zqqmcvd4DifUjjBfCi6q1bTbL6NdKLu/E+Ds0XwXZWZ3MwleLXxaILsIQKtJUK/MLS9XxnBVHU4wdXvGzaSvBcL8rho782O6PprgI/D6CerNBr9Xw/bydDSeH0+86M83kfMtGVAFVErthn66Q/XW/fT7EcOXIeBkdcchzWvcxIgIPX8JD4rK5cOHrh43WnuwWhobJeQcECmqo1730RhsX7xeNYfidVfODhAhlsMKLnfWHa/73hwOwIofNUVHNcFbn6B/f35FidyBYv2ob077P4VFBxpuE2sHspQqKGxJIiqBazVHB61rHnyU1nMdFLYJznDmB4oGuV05vV4Ssdrl8xFJInwsXJckP8g66XviosoGrg69GVI5ZcqrWmWwfRwq31lD0NpsKyphx+qju3elPbZiVHv4tEZtfCcB/XtJzC0dgdb4N8xdlw1/1Z/cq1HjvwfF9FVcPpJp2Dn4LYbRQycdo0HLlOOihbK4F7BMen8YjGFibgS6oVfigg9yUL7orkywtkoGZmtSaVTkWjb19CIitsYIKPWJXW3O3nsHYXhZp/8Q2+xhKYGEYYHdHT4JWZhUz6nOXz0j+rIVJCF7scyzJBwEdlrB85Zel+dMW5OQJ82DaPiodqv6M8n7YX1EROjhBOjq8XlqYZQaDUzvsnOFCqqb/LFDrCUICOZrC3ALPjYtkv6RzaYDlcGwEI0VXSbqQri4xAO9YeZV5k/u+WlYS8gEziA6vXlqFUrdvapK6JRf6Eu4ZDaoOcYT7yOGcId+o2R2aEpyG24/bYixLNqfDG
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0588e01c-726a-4afb-8ded-08dafd8ebe93
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:15.2120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSyGN6vawL2reolU7luUiUXzbD7ukWAHukAYyYXjSL4NauLo6Or4LxKMxZLwBQLpZ/4wg64rDoDPUTMMAuuEu1JOLh0eAjoD7gXMbPziGCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-ORIG-GUID: 7NbsNh_I6JG491E2ZyjV_k3IfOwDCHRQ
X-Proofpoint-GUID: 7NbsNh_I6JG491E2ZyjV_k3IfOwDCHRQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_report_lun_scan have scsi-ml retry errors instead of driving
them itself.

There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs the block layer waits/retries for us. For possible memory
allocation failures from blk_rq_map_kern we use GFP_NOIO, so retrying
will probably not help.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 56 +++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b8a526c4f6bf..05be4e11102f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1408,14 +1408,33 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	unsigned int length;
 	u64 lun;
 	unsigned int num_luns;
-	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
-	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any oher errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int ret = 0;
 
@@ -1486,29 +1505,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	 * should come through as a check condition, and will not generate
 	 * a retry.
 	 */
-	for (retries = 0; retries < 3; retries++) {
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: Sending REPORT LUNS to (try %d)\n",
-				retries));
-
-		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN,
-					  lun_data, length,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3,
-					  &exec_args);
+	scsi_reset_failures(failures);
 
-		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
-				"scsi scan: REPORT LUNS"
-				" %s (try %d) result 0x%x\n",
-				result ?  "failed" : "successful",
-				retries, result));
-		if (result == 0)
-			break;
-		else if (scsi_sense_valid(&sshdr)) {
-			if (sshdr.sense_key != UNIT_ATTENTION)
-				break;
-		}
-	}
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: Sending REPORT LUNS\n"));
+
+	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, lun_data,
+				  length, SCSI_REPORT_LUNS_TIMEOUT, 3,
+				  &exec_args);
 
+	SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
+			  "scsi scan: REPORT LUNS  %s result 0x%x\n",
+			  result ?  "failed" : "successful", result));
 	if (result) {
 		/*
 		 * The device probably does not support a REPORT LUN command
-- 
2.25.1

