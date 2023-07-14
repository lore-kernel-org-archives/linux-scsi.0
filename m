Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465E7C0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjGNVib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjGNViT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F11735AD
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4DeX003063;
        Fri, 14 Jul 2023 21:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=+SXl29Ia7Ei3HnAT8/HQQBdOqjXpLbtPZGu9+GIfWb4=;
 b=LtndDuPY8tBV5ASrDnBuOy0wC/CUlArBQHHNp4c4jPp81W1sSB/BsTAWR1nHtSIEMlz6
 VRmuQtbXE8S6HB3EmJwk6McMwMyyGHToOceHj5/h1gYWhnaNFVIGIdroCj2dxaKHBxDZ
 Bi8YREmpkIZqZjANrEcyopRkhfk1cbnsNI8k0d0Ad7orf1A5Mee9UN+yUNfGoscrjqug
 2kMlDhCWJepoQdgzLYeVzX8eT34Ln2zHbGwABNh9BavmHGKUuM3PffbVjPyOEnJc9Jgl
 GK84Wbnaik6Po8anYaQ0RzEIhtL7RQdknvdgRzy6wmAtH56ynaUy0qFdyCytIaCbATDu zQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtqnct9v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK1gsU014020;
        Fri, 14 Jul 2023 21:35:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvs91yq-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5+WBlFnKIKCizA+EdWKCOCOIDBwLfAOcZYNJY40vgKR9Qkqnam056KMuiWWw5Vy86tWQZUZpaJ3GV5z4hkUtoE2Dyrg5d1A5gVEliVSd9K2FTv39pcfw2eDrSmcjGIh4nF/9wFIaz3gskYwUtWfiDOTBydjgV3OylxS083W02iFjjRxFwFLiThgfwfX4UMaOtoGWyIz2mbHq/pFKmmOJv70T/wkVNKle05nc3As/4eHrhHhKt1FZ7QUt7mfOMfDj4rV+Yfp/1MRJw01HrMG4vmrC/WMFNMYtZZZD3J7bXHq82WnGKkrAB/TwnnYIgpLSIakeau0AttqLydeOsjewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SXl29Ia7Ei3HnAT8/HQQBdOqjXpLbtPZGu9+GIfWb4=;
 b=XpdzuZHIU1uZYKa9tGxpDkdtZFK11UMXyZVYL8wYso3e3jCFpAscJaovjt3ejeRcRPqhHW0avBHg7AF7pyO6kPupurpiINCT16kzhvYHxqrCXVkWni+qO3V7ZhuDRXhoFF7p1cGpksaeudIwn9YJnjhsgXRo33H9Piiw3hYcZ3zvRxNLBEVjr07FVT5spkUFHZXuns1pTC7vsOE2IUShwwDByaFPiXiBwAxjrhOZkPv8dejrcbf+os9lhZt9MFhADM5rQHZwDyP9J3YgETXkmTprScRsCBzdvbGncUGUbHwzqMcShTfX/U0p9QHSCSshUprzl8nfnVPA6z3rG8rDUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+SXl29Ia7Ei3HnAT8/HQQBdOqjXpLbtPZGu9+GIfWb4=;
 b=VlsX5zQHc+2yXVJ9bVsPNPNoto72Y4b/IFPSU6Tt3BteFAq6oxYnk080fUMWbAMWIYSwwDoH5w7H7/7Vw1BBR0RmE/0SjGBJC0D2SQG41ncxGAFbDeIIo2GeGgra8xVujwYo+oFUkEBndnwlC+Gm40swV7/aI64zmIRfnU/2IiI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:01 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 23/33] scsi: Have scsi-ml retry scsi_report_lun_scan errors
Date:   Fri, 14 Jul 2023 16:34:09 -0500
Message-Id: <20230714213419.95492-24-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0080.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: b61c3e78-39ae-4d84-804c-08db84b22dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e9RkBxoJpi2g0NrSRKwIXdqosd7WAGxo4lP4g9xseTk6DDb8/SCPq8ztki4A1UiVYYSJlJRb6ta4XB6OJRt15V0fRbwLXZoHpjWfUG0KqQhkS9ZSOGuFkFM8Sl7/gyLTsESXHxuUYDaNWVqxM2YhtAmwbtxZjk2mAmEOMLF5NyzPHmaJFBB8TNDXvtqX0of6QQI5OevZUEJSrZNC0/Jl+9+FTpmO+rkJe4j8JCYJKHum1Y/J6d7ekwhaIGqTYDlwynTY7MBstJlPmVtBYhMKGjyj3pcfnrehblex+/4JmOY7jIg0CMhxz9ZCVARybyPzsjy0CDNBEydoR2ewEJtyVhSegwKlh89OxI0K3/qxMsPYQ8QwiY6UmrEsC1KjKAZZV9A7ZaGdp/Y+XmTPz31WNqwEZZxpz2AMkAV+0ZAWFJMXBQrlickzGfosnKnPOzNJa0gysSsH20rQJHv7pM1PbgyKL/IfDPfpi/cG1g4ylfb4QGN+RKSVHQzEOs4sVUAXioI+ukDg4ufCt3rYPOzJJeKyUUE3qUPeoBFI6CyLE7smSmZB9HHQNkWg/h2/Gar3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qro3cHRGJnpYS66fwMx861ciAylrkMy5euoG4NkCHVg9PzMUJ0qHi7NcXIMA?=
 =?us-ascii?Q?rh79aqruEwCIlutv7yaBqcTEeWbbfHHr+kWMCE2fx7avyQNSUCeKQnyOjwYV?=
 =?us-ascii?Q?smc1owH+xgxyqb+pldxt5fU/NrL+rOpJ614qXADsFCJyaxh53PJwEn16MhLu?=
 =?us-ascii?Q?ykVHl5U9l6ACKfcRrD44j/DqnumPBWqH9lzwp62gtUujHiI4VclavFLU3I0k?=
 =?us-ascii?Q?63ibTee4opNuF2PThbvqYDM692Y2lTIK92SIcqtvj6hjRbPVtkgvain/E8vr?=
 =?us-ascii?Q?1w73ELUQo/l7jhAnkIVqdbK/0hhDXhaBL5QeiCfI/syadtoA2C179nUnSmwM?=
 =?us-ascii?Q?UQMkb1niNhuj/q7lFFnMd1HSf2A/WG6hRkNjIBj2ACXFVdHuKXrobT7KZFAj?=
 =?us-ascii?Q?lS08V27DlHe3sGb/2C28lilMlhTUp2Bks0tZ5KomvnhIgLvBHlBPVcTZaMFl?=
 =?us-ascii?Q?DDvkEFHtoIUt2rS0SsWYe8MyV3h+ZMttGAsuO5Nbk5Bx8rGGUNqXi+g9NbRM?=
 =?us-ascii?Q?4Yhqx5pDwEr01KJbnBSCOWi18HXeVzrozX6lvLDox7Fx9YBGqsQ6mbBuDRy4?=
 =?us-ascii?Q?zvP8M8c8M0Zq3dC/djxVpvtLeQDGOmRfwov/x8IBe7OdfH+7kPqUJ/M2380D?=
 =?us-ascii?Q?IfZMnCGg6CtGxoawn8yckMdYAPd+vzXE7svpAki4Z2kfU6TdlBimFnOzpSYf?=
 =?us-ascii?Q?w04k20uGBdNtJojBDfAnT8jkmbfYlNZC6PlKc3ZV4tjMwlsTX5alV5MTDUZ+?=
 =?us-ascii?Q?fUw6mEEgoSz4w2gti0Y+bNa4rKC5JBPpVsdZpdjKdJwgpJej7LuBR+uQwYLU?=
 =?us-ascii?Q?D/hdl7det+Cf7LzTUrenDyWBxFWL8SIeWh1pP3kkGb7jDXlTd4N+U74jywaL?=
 =?us-ascii?Q?Svxt/rzfPU3ilTYMbjfzSeTwLnuV8wkome2V6hmX9JzeIooMz0epA8SeUJqv?=
 =?us-ascii?Q?2k8ucGoceWY+SM+L9d65FVPzGCR7uaN0RC58DfQLVnPXit7nVIhGFZjtYu9T?=
 =?us-ascii?Q?ZszxL6g0iTBFIBqL079PHJNfqULFLKowyT4oG/ox53Mxoz4wkPYfaKavj3IA?=
 =?us-ascii?Q?wYdxsfK5hPT+sWSqRtbgZiumZTNHKZJq/nffoD+JcI50yLk63rZBwWdzBvdM?=
 =?us-ascii?Q?DWXrIx5bygK98e/ophWE+6FeoWII4v61vznBrX4PCHYcFlOK8NeW0Cs8WFB1?=
 =?us-ascii?Q?NBARRSX7qnqna1i+nQSRILYkgosWx6lpsyA4q6x0BdL7AcaJtVryyY0fFnp4?=
 =?us-ascii?Q?pQu0zpZW69fQkBJtRtwuO3fOR88pVERp89c1iqW1Q2lMlLNuO7ai1Y76U375?=
 =?us-ascii?Q?64UtwDuxbDE2vYFXoU9qs93hSFrk/rW6htAQVBcxOjM/S/IGyVAo5YV9tl2v?=
 =?us-ascii?Q?+zSm6bgiNRXf126OGcRJQaQ41r52hqMfgSvzeNDnSgez+43CXoPLqFH0fNN7?=
 =?us-ascii?Q?93i8ugOOyzZ9MQ6zg+D96XeLewMONnWlwRcm0+cJKrRVYNdesQL0NbSgMWuy?=
 =?us-ascii?Q?Zl0dxTUC3xpDULeejsz+nxAELDAYMV4du+xdm85ohkkWDhv8zNJEkJNN9K74?=
 =?us-ascii?Q?VfJ9fdpTHioKQnb+/wDq972e9nzdcgkAo38s8TRXKLjxQe3IXV9pwJOPtxTS?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rrwp2qxoqO9QyxHGyNrl4vQR9bt/M/mnVT2GS/kEtPMsz72QWdhnFhX6m/tNkIMh1vtRIG4LlgeSknicl7cqQcF2uxvQ6GvwUUHU9RkXGe8I4tPG3zuh+++/zij4uJdZdV5nyx73EpHMKfZLvs5HaXj2XVVr3UEaMNm5dTzfVxPEWoK76Ueo3UmnzcnOVu7qPVZQkYkQkk/3UD8Mz+OYGygNhlrS0ilrDqEll8tXkRM8iMD+J16S/PttYtSc+OnSeM7w3SvNkT0R0ve2kYEZAF5UnAHh1oFQmAGI6hAXdP926ZH79NH0mXHzBHNFyZJwTfexD1BY3TIQ71VzBwK/ZymJ1MwtbuL23O/Nnpplru3tIsBaMyr48sb9T9vQYu+acCnLvofnDsnTV6j94yVvjEXsR/z50P4OJ5fGx19APRArCdHoYNcXTLykQaRoOIywR18lWQbyff0n/4xdjGF0lg0rS/nbaX4NyWD/C99GNXBgjWFd0uXpnaL675Vc/oFcURebwDzseaxiJZT3CY/6ViSuJx+grlfOdiDxFs1TMSQjE+yz7eMWtLTux2S9FX5cATFbehosNfPe+/XKhW7GcIeYs3rPX4HEkNpZWK2YRQKeVCSh6+CQDJGhfW9qBUUCPlxKd+bQCP5BK7EGhPZ3l7p5D28Xak3xAclkLEKhBmU62lClP46tqze9wENClraZmTi/3rE7OpgsLLZWkXR6brt+5kU3SpSsD2zvuhzEYZtSAiTtfepa0skb4dQcjN5St71jdn8INpsQi8T1sxxJt9ln2TChaPLxWx21dje9py4cMGXVsF5PjwsXZkuVmhS3D0xflZ0jHYcFv44rAg7Bwg/3mpofhUkxaZWPQHSSu+5z849QEJLgh4+PxC8/RBIw
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61c3e78-39ae-4d84-804c-08db84b22dfb
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:01.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goMZBBwqDhXX8Y4UWkXUQpYAWhKwsnNetroJJbWX+I+TbdqoDC21Ikobcj/+bFcHCBZ+iXQN86h+7RhbFcCGVtTfWs32fTn94DH/j4IVUOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: OcJpfQdQJfniTpjmNKVhF0cGwV-KxZcP
X-Proofpoint-ORIG-GUID: OcJpfQdQJfniTpjmNKVhF0cGwV-KxZcP
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 56 +++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e3c8edb92164..87c64b51465f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1412,14 +1412,33 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
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
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int ret = 0;
 
@@ -1490,29 +1509,18 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
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
2.34.1

