Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC59CC54EED
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:11:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjAWWLv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbjAWWLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18BC38E9C
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:21 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi0Fm011288;
        Mon, 23 Jan 2023 22:10:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=JaZxYv94/X51QMrAc3XPYEABLGjgKTB8h5z4CUHhVPQ=;
 b=MS+6vbN+/eyaB6oeXNDc82TpLKMZP3dP3E6TtkFrXmz+1hEBg5dfro3rwXQN/z28+Anu
 l7yA+OyFET/pRFvMiheLo/pwMvJQyckEUNHHDmJlkRFgzcs+93FbIbwkpBmaSo4gALzA
 T2Tndsh273M9gbqNHcwhlZYpBwLf1xfLE9rAZcPAUdW3qHn3Kz0Cp9C/iFwaXaRVR/bS
 kYt7/jaY0XyddGe+4ilAtvigDfftvcRtYtlmQcLM6jsPkSqg8W5nCSjv7DgJkKaWy4QQ
 R1ZTLVmCCD4nYRmVb10H3NrFxGtl27fOxlUcAKlTl4qM9IGcXwM+vtX60aGsYJ5rm9gT rg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktuyj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NL8dej039567;
        Mon, 23 Jan 2023 22:10:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gaxjnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuvEX5Tq/ZBKVz2VJ+d1a/4n/lIh/tnpCsp7NPdmsHeCZtme01F10TPmDnU+qnoO5zt6uMFvEnbEpCwNTHLzwMeCCtmDsLDGVVbwaJ4hf326iQhHLVSbY9v2iWq826V75lkJOFV5UiQ/J/fve9RdFOFBiJH9usG6mRWx2coHuNXOCIRX820WH83P7xlsY90/Qs2VYKUVnqg3X055iMkbCHH2ugXa7v022GHWrDbArVsEDLgeFDwVZYYHLwWKx5x+Nhgbn39YOYZ+km8w1sfE9ip2FunQ3CHATeCpjQgxSbMdaTA4k78rNGWbSveZjcQZA0DPhhRmOG76P0qYWU8tEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaZxYv94/X51QMrAc3XPYEABLGjgKTB8h5z4CUHhVPQ=;
 b=G2/rmG7PBvNztBAZ2AWY5IGwXnLwdbnxsEUuGbAneG1ltCj5jRC8K5RUhdhq2dew26yfmC0uBVZ1DVHjrLMTcuvXWskL5g6l8SgeR8j3AXsGAdFLr1+MGAVtt94F7wAWFzTh/AH37jVGSt0iYZ7JQGQnYZSesfDOqSEKbZnrB7trXuD77JFcSU5Xr+iIFyF4bTjjXyj46t70v5ADw7b6e0gZsQmnrB/GNosbwOJHtGMHC26JqKBQ3L6+nrz7L5R2z6waMkLTYvp+xlC1BIPgFdCcdnFdr+8NegEFVunLfroWwoNF9CFRvMgdD9WCUleagGhuOX+Y1XkHAYrQ4TaE9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaZxYv94/X51QMrAc3XPYEABLGjgKTB8h5z4CUHhVPQ=;
 b=AA91j51YaibbaULn/+1cHXkht/1LC3mTn8geTpWlPWk0l1SEhKIZv/sjXjk5daB06mp8qSAMwDGF9MQ/P3p6hzsYGhDp+k9a3oisLDTtSCElbU1nOQDUtoOJmNpXwK7KwS3yv+Cq0Se2QzO0hWzAJjREwbPD/5oDtbbK1Mzz4xk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:56 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 04/22] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Mon, 23 Jan 2023 16:10:28 -0600
Message-Id: <20230123221046.125483-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0007.namprd11.prod.outlook.com
 (2603:10b6:610:54::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 801edb5a-61a4-4a72-b5fe-08dafd8eb315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/2je6jNGic+MHASaIstXS2lEci2AEGbqm2PzTOTH2w5iE7IfrqjjYDa2zoOa370GLTy87vOiB2QB7Uepu6P/h25K3ZxY6/TKR0o7sR8xVg/ZXSQPihz1wBdYS9THw9SAWzMcsUThEwfgR+fvVNdak8gi/D6LKWIjtJO2uc64hHx7RlDIgH9R4agHpmRbUsNlxosNni8gqig+8iPNOjbvmAUy4WmYoLYvxQsQacNaU9KuLSGHwBwg86EhUK9q09/XblhBcHxhLkUOMJ+EZREqAnSFDJBuYbuuiEq7zSnFyxo8lzp6aFIBj/XSXlEQWc65rJIH4qHtJzKNwPVRcKNpEhi/h1ni7IhRR1ROOwEUsqbt+NYEk1dpDbsVyUH1DospQsVjQUsVMD6+VlJjMr35XFHj3FB9kZjeJKIBb7FE5tj4Q1tXhTga398V5NE/pSyp2pGXYJM2/nTqP1uaXCyPc9i9qNfNtGPsyW7YsD2ND4a10LSwi6ot4BUHEyZeOUGmA5FLQcqijOCASZTldIyt58GC+Lf/H/+VTuMCYlFQDqEAJOYT+CGqFLEucnhZRfFf72OERSity4BIGkm8JNV8J8MAhU58AVSzhWeRxiVL7H0d1eNsJBiGdfcWEGspWNAMLoYAkWgfB21ArQPvsAeFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UlxF4XUU7B/Y2W/qDgjYgsq3NOjJrIXDkL8yYvRMLPgDXt/4ImsFcRj6RF7f?=
 =?us-ascii?Q?A7Jfv9etOUJNoLWDMjYQDmGb0yVvQvhrY0EJ2rgCwBd/y0d1ol6/Pmys6VyP?=
 =?us-ascii?Q?1ELGmDbRlaioxRox8C4Fp3vf8O4Ta5T2MBR9zEeUYFvuu0OeakgRK2ToMFWe?=
 =?us-ascii?Q?7+GgfmIO6bNsabvBM0TJU+j1wAowmrZzYsnclj1/QRUiULGqtDXhamPJAFKJ?=
 =?us-ascii?Q?nCric3EIORsufjah0l7Ff6/nUqJKoBtjtp2lT9jTUPxbkDonoLG+AKKaWrPu?=
 =?us-ascii?Q?etf4iD+IfqLyk+YmG3+uDzpVzKZSl6w5yeA4f1s81fyMUwg1YAl+wnR7zxkE?=
 =?us-ascii?Q?Kx/ZwwEJACo1YTnU5MDApoEHho52M3h2AhM2mijgfLz5voapXi6T5FQln95A?=
 =?us-ascii?Q?oEoJiPGNRxfl5Qqxk7F4i869YziJNcxUGUdb2D8uxFVpi72RjzXKq4S1NPal?=
 =?us-ascii?Q?1IWpVayOvA0sPQwbDyjnMuc//X/LnUEepgWJ0p7pRqOWq1ZCZg2bh/LcRVhy?=
 =?us-ascii?Q?0t/UGICUXr9UyAymwrXTgfFe2mtyEcBt0GQBT0sjtcJHuc2+OuY0ssqft8Cl?=
 =?us-ascii?Q?Ol/C5hVuTs134GD31QUkF0BRvKRhAW64lqJ9gyDJ/lo5MJQiJMdn2h084oP1?=
 =?us-ascii?Q?E/dpXnrao+9SBwauPIEmSvku9CkDVFOiKUAy9R1xIEE6Y8TgP2kzTr9DNWGB?=
 =?us-ascii?Q?O7hYufO9Lbq4FPtvklXzPV3ou6l4X9JbIFqovIKfnLC3T8vAWZ7dzJDlWkGC?=
 =?us-ascii?Q?om+W6ltc1ndoj7VXjm5FbxTg6y5ADiCf0sYvr5j2f93XJ061z9cGV/fZx3xp?=
 =?us-ascii?Q?mzeJj0OwkA2XeQm52vL7L5in/pxZfq5NJFfffoPQ7Lx51AhmcE4bJ4h9yikb?=
 =?us-ascii?Q?i6uZ5kCRqXhNV1+U4Mr2DH/WHog2LbQ/Va9QwchGQBFVqnl1sfPg2qoMgsae?=
 =?us-ascii?Q?iyO+Ie8cgjqev8emaOba01tU5hgk1Z6cz+J/BV1koZMw/j+n4crl3FNqbmbt?=
 =?us-ascii?Q?r/lIFJ3a0w6s/kH0XmihgVOtuatIMrdC0kxfBh/GKxKTLRFPybn1hc1Coc51?=
 =?us-ascii?Q?eZ0tfhh59o4L/N+z2ovNlWfU+Hu+YXMXpKPsAZlfOqT3pKv3kSQKV4iSoQE/?=
 =?us-ascii?Q?WC+6jK/Fyd3LbzrsAFNDhidIX2vgwz5zpI64g8EJVGrol2SDCULCb46md9zI?=
 =?us-ascii?Q?ElMzsciSRRsViVJ/mcymUoWnbNLOXT7PO8kYR32FLsiv+B/3JYtvy3upoEIi?=
 =?us-ascii?Q?Oyvxz1OQJAM2yoMl+1AmrkFGaYWn0yusIweqE7fPgTZh7+oLxBJnok9UTeY3?=
 =?us-ascii?Q?QCmBSRyDGcwuc5SKholFnL4eOtJDnDuMlvJBKcZBl2xzMQbLsY5t6+nLcRBy?=
 =?us-ascii?Q?qijmAL+Pqyynd71+5sVNleYF+56u2vRaL4oVCdDrcWoXYpt03KU0pCIIVUsH?=
 =?us-ascii?Q?sBHVmtc+0KnZ3wbEp5nWu4L9qTXR3cpMU8/mX3epLs7rkQPabg5Jv0nZqRg2?=
 =?us-ascii?Q?vMds9hGxzGyvQkj+d5b3U5/o+fOMG0jSBXWuVUmLqdI/GeTr1g0m4g7tUWbN?=
 =?us-ascii?Q?NvirmpJlAyzj7qRs3VRj10BrkSZsqGecMxKT6eEBtvbw2IQPd1kF7OiHsPAV?=
 =?us-ascii?Q?aQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jzk5JqhuxMU16WYxooLMl6J+yMDQMOfEDh0PumU+W7HB7qny5/TjjBueKaks2KqItGvvD3ooH3V6r2uQekHib/bHb/pclje/jK0gth6NwiPUNMr5MVzujaAB9IqT/0kwHXw1dImo2VDK9f1fUTFRy4KogOlD1j9iJT0Bjq45l6Ro6ZxDcWGWwYxphFM+9hszDdi4HHqX7KT6NZAT5ztkBicSjeWhCJj4zQP5Bq40bcEHQdW6bQZJj1rj7MFEqRDCOJUCYhU/VAcrKyza8pypepmdzZ2Yr5BvFj8ZnlGTeje9sroOQH/hXuphM5I3406wQzljnH/3xejjxst4GIKpqlS6q5iPhKZCibKTIpLlFBhyw/fTUS4xpzlDowcygqQTsV+qL8XczLkL4LPRBxKp/vgwNcISilru2Y75NhCgU9JJF95rcVrmKWytUk0jUyXTI3stbQuY58R1IhdwECkpX24Gr/Q5BcLObq5MDqalvH1f7TniqAy8iliR16A5tRyCE3dNfwiav/8WA1RBARg3heC7Bc/fymEpAuZQWqNFZm1RCb7VV3TZI7p87NWqxOzfFUsEetcfRSlUq9MxIpR1awGQf10dBQCJ08V58NZ24NMW+gRkiWo+To1n87b/sfWDb1zU3VXKefXfhR1tIGxjEnj/I+WNAzJd6V28dmKKnhx3T5MKhWkeGhKFtSrDzcqvbQf181Jc6qcZZqRs2fILfH2grPY3zIxQ8FbZ0qOo+3gA5ptFoDDzNnNdRsE6BjcQNSdnk2w/hBLnnCaKvaMFiCJy6KQwg4HvcXVDnkXlavyjTHbTTY5uaKexTNTsFPuZGokJxF35B1eiWQoYJAZnb1AniSVxwRWhLTXfUV4q/3PEpdtKStHJ29NgCoSDukv1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 801edb5a-61a4-4a72-b5fe-08dafd8eb315
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:55.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qZTF6T5FreVpqnMzH+kLB/Q1Pk0cFNJp7eXPPyOKzU3jwYAp/OepnU9nsia/Ye+tOQIYzGxaOC6lD1U5a+tdR9Q6+5aIBWwLh4i/RUocJSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230210
X-Proofpoint-GUID: zPrDagc1TeUadioFPbBnLm1V7n7yczuP
X-Proofpoint-ORIG-GUID: zPrDagc1TeUadioFPbBnLm1V7n7yczuP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

There is one behavior change with this patch. We used to get a total of
3 retries for both UAs we were checking for. We now get 3 retries for
each.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_scan.c | 42 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a62925355c2c..1831a0c2b54c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -647,10 +647,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
-	struct scsi_sense_hdr sshdr;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
 		.resid = &resid,
+		.failures = failures,
 	};
 
 	*bflags = 0;
@@ -668,6 +687,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	scsi_reset_failures(failures);
+
 	for (count = 0; count < 3; ++count) {
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
@@ -684,22 +705,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.25.1

