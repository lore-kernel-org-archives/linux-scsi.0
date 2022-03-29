Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75011C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 18:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbiC2SHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 14:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240411AbiC2SHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 14:07:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68923B18B4
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22THsKZR022190;
        Tue, 29 Mar 2022 18:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=mT+cNDzutjEVSuQGt/GyujEmq72DoPYTpCd3Pa+uLfc=;
 b=bS/vKB2Jo0zgIx5C1mZd5tjxDINId6k0aIdWWXpBWeqpT/vtU9xRO/BSvK+FPmM/WdtL
 zVhfyBIw592EPnvA+lGaoM448azy7SXVfRwH/z+N+mjnqq2opPL9NU2c+/M9uN1EALMZ
 kNqXwnYlWprd+MBDpDBLy6aF7F6fLY8LByt8ebbsxTupP4Afjk70NUWzXXI3Ua5vu4ow
 s0oCneG3/jLTeNmDjMcB1tVvcX9oaL0IEq3jX+i4KOjFdIOz4gAW4sgb/ikC/z2xc2Wm
 AU+j45og5ezP/bwHPKC0UpjxkgyUNUqQeGoz/YFWkAmskrUkzo4CggEIFQZoCRqkdoxn TQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1tqb78tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22THvFJK048570;
        Tue, 29 Mar 2022 18:03:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3f1v9fhge0-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 18:03:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/eOnwnV9AT+AsgbbY/ExpsUuV2JN6X/ZhcOnjWSIn/gFSvCHxTOKkdM8CXXBZZMHN6qALKjwGY/29+hZY2TLwAdZFr5RMoOIOiklG3rqdRMVGN36ey0tpPLbaLjdA7mg6j6rDaAIgFod7y8l/AMi4ORai4wXUOr1NCZCDvRcCAePmW8f2uYTpdVp881fZeUQNnt7R5U9B24wMowhSeBGkPq7QrpzQStTBvWtk3IxPV+IuC0t/ZSH942DfYSXYCTfHb2beUeSJD/iSd3EY98BleSxKobL0QIZSW5BgvRnOJdQtJ/WPe2XwyKgtfdk0fKIdyNmDYrVrG8YJ+IHNMuTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mT+cNDzutjEVSuQGt/GyujEmq72DoPYTpCd3Pa+uLfc=;
 b=IGR2/wA4BFdhYlHiIexPvgktYa+t3+t3h0eVDMR4QLbqyQfWcDKifQuJfc/0vReuGFhLGSQvoDtSWTNo3WuXSTPPZ21kACB8K9FlPatgg6sqPYqkgqR0DzezM8TQJoqA3KrKKcW7X1/Hh6nDtzfqp3An1ri42JBnGlnfu3hLfGzWqjWYxS7LCXG29EITN//6XTTd2f5x13YknyyyW68QVQ/bCl8oTSNSCNSns+Xn9KVLd75TIxsvjrZ9bpy/xLSF2Cn7JYZStmUagdBmHfLCuNS0wNYEI+b5PpfT8mc193owcZ0uQkWlalkkcUKj4sOfdIUaBvp/Mm/Qxb0JYp7qoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mT+cNDzutjEVSuQGt/GyujEmq72DoPYTpCd3Pa+uLfc=;
 b=jtok/OImbEOGVA3S6z0uun5HBEatt1YkW9k/jxGAM7jdFRA/5NctpJHVFB9p8NnxH63U/8jAF7bCrUJsZ5nDSqWCR2Zcm0VlXjUO9m4FvBG27gDlIkDf2j5AJBthKAytAA0H+Emj5hzy+kxTwbURIS9y0970W5DH7nAcircsrlI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN2PR10MB3584.namprd10.prod.outlook.com (2603:10b6:208:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Tue, 29 Mar
 2022 18:03:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::29a7:bae9:9b3c:c9f2%10]) with mapi id 15.20.5102.023; Tue, 29 Mar
 2022 18:03:39 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V3 07/15] scsi: iscsi: Allow a recv and xmit work to run
Date:   Tue, 29 Mar 2022 13:03:18 -0500
Message-Id: <20220329180326.5586-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220329180326.5586-1-michael.christie@oracle.com>
References: <20220329180326.5586-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:3:115::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5fe7479-dc1b-4ad1-6763-08da11ae732d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3584:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3584C6B04B85D8DD19F1C8A8F11E9@MN2PR10MB3584.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcOpntsXr9iVDbBWFg+eZhoTQjw/laysYSnNC0i4hK7QsPnRlbHnS7JiSPWzLB6BwaOKIhXxsZ/sapWPqMNK+rjxij/hQ++OmIstpj0XBtTCHSx6mXzIWJ9tcMwOwt5mfWTGXj1A+H7o0P8V+4HvB0jA5LU0zUuyBZ1M993R3qNp4HCCF2RN8K2fKzTOHrddRSAeVKJo8FUExvq7FN/8e6mcKMlAaNibtiXFOVakWbdg3+qlCDv9rpPR/MvCBpbtxdt1Jp50alkUEwRuH3eslEwU4NqHm/uraMlENJQICldz+HZSVf63R0UKITicafE36CEXxAMq1TzaIRZFn0PxGxSdXhhYWCdHt/eoT/GUYBZGALVhRs1OJuiwywFWe4YQuaMLcLy0a/n7itUnILv9ZUqCtDKUtUKdq+stWNz9Tt1F4Amnj9xMyhIMQmAuHAFRb7B1KwB6UqHYJXTeAsy3hNNrRM0N7bKPVE27ItNEwM6fmloIfzVnImkdZDscee8coU27SW5kn0KgboCwwxYomNSyHvUslbuQZWJgC8UXI8CO2t/iW3rbPmQeyZKybPElnwQRG0gVw35uSXaBcUMEd/2tmVnzL93bpK6dyte14vkqitPUj3DFDqV4riKB6mSA+3aw3Gp8zfNwBepV/pwxidi6xpEY1VOQVVMMhDqYTo3YxJCW76L7KSfYa7lO3DME8xFnsTUFJmJge9AanVGuqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(316002)(8936002)(8676002)(6512007)(66556008)(4744005)(38100700002)(2616005)(36756003)(508600001)(26005)(6486002)(2906002)(5660300002)(6506007)(107886003)(52116002)(6666004)(86362001)(83380400001)(4326008)(1076003)(186003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x7FgNRZqYPR5emlaBjLRjGy4zI4pVcU8mQt6BZNchoCxWoYgzNgT/eL30E8O?=
 =?us-ascii?Q?8FsmHQpDFgXO5AgcjuO3naaJP2TIFrlM32RCKKAMltYBlweWlmYYj9KOKVzr?=
 =?us-ascii?Q?eZv/Osv70gwy/PtjUGQROY98jCip4FxCtURcXnxrO6+UqKmQxWLTxpYXx6jt?=
 =?us-ascii?Q?WKwnNdMJi9fUpOfmKnzkT5zPCGPdjlquq9XYVNXsom/QLQVwNdafRaDBWvpI?=
 =?us-ascii?Q?h/H+mkF8SQCJWHaMGzVLuFRq/yYJ8CVfVQUMkoymnb9OmsVi5qHt/4JqLu83?=
 =?us-ascii?Q?MLTe/78dFb+YfAoB6hvkr09i0OEYLw3LcyEm8bOB7HVGWehXJAy1UipjmSr7?=
 =?us-ascii?Q?lXbVWP5i/pbV4F05FB3+iJnUlSVigW+fFij20jLSJLva3dQx3kD6vyi+a8xT?=
 =?us-ascii?Q?Th2DYU8fjLFC0yDrgIsgeIwRlSIzAW4efSHUTxR8kCArN6oaVMSw58QwrMKX?=
 =?us-ascii?Q?mX/adoAra+z9l+ab7LafSNrY2G0JTjcqUe81DCkAk1dwRcnVxbO4TCcXKA36?=
 =?us-ascii?Q?D0pKqx8ZqyG0Y7A0gZ2j/nlH90IWm8Y/56lW1gleWKaRb+mDe57onSmZeYFc?=
 =?us-ascii?Q?eruJC1w3tnzw5zL7tpx2se0nU3++4afCsskq1nCV3228Xmqb/V00tajj5hso?=
 =?us-ascii?Q?otVATzdpAE+wZiv29RoKWdat0rBe1EkTp4yxwo2k69S6UYyP21h3cAY4klTI?=
 =?us-ascii?Q?bh8KPIZJjJVCK/rQraik/pPr+yDFnNWdK1M4B0oeuzASJAe25XPsZ6lZ1/uP?=
 =?us-ascii?Q?/k+yE7sVwWZQUtS5CIo3t1fE2mw67bfC9geh5xA0rGHS4FxnfPqgHMrhR7ZA?=
 =?us-ascii?Q?VXvbb25hVCaohl6jOmwKj7SS5k8jZ6ZWMNZ8eZrhL5oJimQqdBrLpXfrsCwL?=
 =?us-ascii?Q?tCGEMI/mjfD7j/2nU4/YuM6sENw91+gvZ9DbdJNyJ5wMMYANed6ocYYnkIfW?=
 =?us-ascii?Q?Db/g51ZOhlwxGWsJBsTOwbUrV/ZFamUuZED8fy0CR/3iREK2vwl3geWy2NZP?=
 =?us-ascii?Q?pVqnXij6nIGvGHTznPO+H+tE2YVsasT3E9XbgYIG2W/nPSIQugdkAG/khk2r?=
 =?us-ascii?Q?JghkSlTxRLtZmkzYx1Osg/LKKtITqIJU2XIPBDmaDYrN0tW9wUUaOnGJrHCt?=
 =?us-ascii?Q?9+ihIdJpVDPGUs/nnZVoLNV2zQZ8JPy66WQMGX7cnr3t82N6F6UcvlEGbI7C?=
 =?us-ascii?Q?LBSyzS+zCK/h61aMfmC785Oh+3u9yoEOyk+CJRDGjkQkJNMjE8dnO9CrYu4m?=
 =?us-ascii?Q?6S7IfrhcOyZtZ9u6tIVOsS15GxLrkgwMa6f3kDfdYyp2zWeIO9l912TYKhbe?=
 =?us-ascii?Q?KdGplqeErv5ys9pRf0LGqVC9mKFLae2bGfGrFhut4BiHekkftR23CJouNepk?=
 =?us-ascii?Q?91XHG41aVD7Ex/OVxt+ajpSuUBAdFDMcontSJ6ijVvn9LVb5If6hhTK+upO1?=
 =?us-ascii?Q?Ioxe8PixjjLKPgi3M6UcHPZpIeWd7N9LIKPR3BaGmlRicmC0buVLrWreh1ji?=
 =?us-ascii?Q?ycA4xAWiqfoWGRYQx1/yPkvf3KUzvEaIpOtPLIVWTVSjbxUYouHtkoPd1jr2?=
 =?us-ascii?Q?l1zRx/TS8Ysse4xHjrZn1C4Rj4PWQ2hVHZ3uD7e8R9X1ruayi6Uz0BWPf87q?=
 =?us-ascii?Q?3vv0OkeQqVKkEkajeRpf72fKbuxUucAHYDZe0vaMQTAqrWqpG6z3M+0K4lOU?=
 =?us-ascii?Q?wTGQPSyivFV43HakMTcRSXrpYZYES8DegdIBzDafdvxvMKxX9gL74aTVoZJC?=
 =?us-ascii?Q?J/l4+JI4tt4j5l0Mh5UA2ckfPEoTq2Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fe7479-dc1b-4ad1-6763-08da11ae732d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 18:03:38.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zsH3GBIBlKNUeI5Lu8U7kecN2Y+/YKORVb0wAbnIVL0hsvEjeCO5bMLAwBdNWjg5ug+7/9vHFM/xmzt15y3AeGff8zLDQ2ungQJvaXbLFQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3584
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290101
X-Proofpoint-GUID: w7xKAZeYhJeHS264S38MdVyZoZWG3R69
X-Proofpoint-ORIG-GUID: w7xKAZeYhJeHS264S38MdVyZoZWG3R69
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow the recv and xmit works to run from different threads if the user
has set it up.

This also removes the __WQ_LEGACY since it was never needed.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3701f8d7f87e..4b4333bb53f5 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2827,8 +2827,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 
 	if (xmit_can_sleep) {
 		ihost->workq = alloc_workqueue("iscsi_q_%d",
-			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
-			1, shost->host_no);
+			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			2, shost->host_no);
 		if (!ihost->workq)
 			goto free_host;
 	}
-- 
2.25.1

