Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0163DCCF9E4
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 23:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbjIEXVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 19:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242139AbjIEXV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 19:21:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329CAE6
        for <linux-scsi@vger.kernel.org>; Tue,  5 Sep 2023 16:21:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 385MtGbX023608;
        Tue, 5 Sep 2023 23:21:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=nY5TO5NIYSPCyzq4veICegNAxneG5U/4sPYYo7dpkVM=;
 b=Z1pa/DK0ViteJNoTS9kGV0UUcjD+9cdUnpAQm9d598yf6qjpQWG1YPSooZJZZ5Oad9kL
 WUhdJLHq1cFXbvtm8zdEFcPPTgoQVo+jbbXUli8Jg/ctYjQbztlJ9wteqhPJ25DtXoFB
 uL4vjjoxQaO/RsA8fGNUwnUthcyp7zggcy6nRwxezrLHDTaQMRcQWxIqJcWqBF7jD1Dz
 +T3JKpvAbGh6vRK1ciMYDgecZ0yCo0nslD40bE3Zr5V4FcCY5xi9zUiPlFvqUdePWlDl
 LjP7xjd03TQvLfmZi/8aU5uouHlCC1o7UGnhOn/4ttyvqfGArkgG3MpmCgqw+pN1jFmR Bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sxdhg81jy-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:21:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 385MDx87037114;
        Tue, 5 Sep 2023 23:16:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugbpcuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Sep 2023 23:16:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrbmLtLQKrT5bjEIFUxzOJSY6h98bXIHEvwEpHoG2a0J+I+YVYdt1JNbu7Sw8uMTY2+qlGIczyDn0CvkvbSPlQYnPs1kgdSydXZb6b2KA6Z/T11GbmyXdNkf5oSfDAJa5AcEhl+0t74BLUwBqfnNIPt+EOf2s5SqRmo+JpjPB9d48Xjv9Siw+bjnQymCDkiMuDg866hke0nplE3qvkmZqz98F88VPtS3OTpG7aon0lHhCRyJshk8ddBfwkNWOnE9Gheag7G3RerdFzdEyI0Dg8PWWsepUm0pixGnR8LvgmVgI1vcdyFVw6Flz1HcvOiolpt42OG4nrV9L9N5fZXKkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nY5TO5NIYSPCyzq4veICegNAxneG5U/4sPYYo7dpkVM=;
 b=ZeCNSFSe20pxxvPqJRop3oJPTZOV871q144nR1F+UoHar4fIRlJYFUoAuWjxVfNMztMmDNUbsgN+lhvjIrUYPtXygK3FFXrJ9YHTG5bOue7FMzVcIr7PxrQ8CtHZLmsBxvIfz6Bgx25QYtwRZY6RObN+tR4TFdh/bS+La0nmj6p9SkxO4CTYV7sm28QykwdOdXMdXDFOL/HSADpYm7rUHtl4CYBD2DycU6rMCXtNoQWqa/ccw3w0uKTp5lGjkTZk7NVp/pbZN3jgXMQX0act5Uy1GYYwvIFv9cF1F79L+NTaKesvvpexmuNkImfVwXoGHVKZrAgOUb/iZBKDOfne8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nY5TO5NIYSPCyzq4veICegNAxneG5U/4sPYYo7dpkVM=;
 b=YAa0OaMQtShX+Q2YrrRTd6fpa9Kxf3iiX0K3z3Mb3Q9crRl4kVySvsqakMJyNvF6AtCRlEtzWb6Fk7Nkl/MEkIewrrVeEekl5hK41/Ie4i792v+l5YV4qjHU+EhtrJi+gN9h7IwQXZr++j0VE7OPHXb/lBaooR1ACk2VF9ZULWs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM4PR10MB6109.namprd10.prod.outlook.com (2603:10b6:8:b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Tue, 5 Sep
 2023 23:16:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6745.030; Tue, 5 Sep 2023
 23:16:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v11 20/34] scsi: ch: Remove unit_attention
Date:   Tue,  5 Sep 2023 18:15:33 -0500
Message-Id: <20230905231547.83945-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230905231547.83945-1-michael.christie@oracle.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:5:bc::42) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM4PR10MB6109:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d2a7d0-8ab2-451b-4543-08dbae662140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eb5YF0FqbBs6/ROv64xfGwpR3SzF7I42gG2ItyALsbgcjoIcRmrZENxQnXKEQ/0hSnuzVsVZ3nmmdQOiC8P6OCo1rEA5649h7JM9u/Jrr1PS1JwISGFiRTlKJsLcoNzlF/TnbOEzh1VttlWbnBe00l5YsWbp69sZzYhdN9OlYWGrqJ5X0zpA9CtNCIdAKKpwLSL4HdpoxSfAusm7tXFQNyP/XZC9AGeWxwHk7OlEKQ+lCwm64cN/IHXn7Th9CuPqiCUnVrGwYaAkWxBIk5tQgBaSlEE6vIVUz1rHBDbXF8cY2X11JPY25/6LQCN1hF7USgWVYZw7BS/K8nb5ei8VCKx8fw9ucE3Nw+JczM2MEgQJF6LIKe3IZF/uXO93hd2ceccpQSkxTr89fIwmGdGVFlUUDFCdn9p3R34Xx0ww0o6L0xWVrpfTMCGP1ZFj7sIcsPSf+3+nMlI1DmA0Nt4lbxYuyy6Bg9e3A1MT2atEMhlf58Q5bgfxOY/SvY+pbgH5zC51pj8KZqt5g4LWtCkemqpXGsWOFIVR37JTXqFMasF5DW5Q+c94H04Pa2/JuOoo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(136003)(346002)(186009)(451199024)(1800799009)(4744005)(2906002)(38100700002)(36756003)(86362001)(41300700001)(6512007)(6506007)(6486002)(316002)(66476007)(107886003)(66946007)(66556008)(8936002)(4326008)(8676002)(1076003)(2616005)(478600001)(6666004)(26005)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bMBkDvGJ9IkJMCR8/17c+hqi0CcYJ5MBoZFsn5/OX189jdeqU6Qipxkq1ubh?=
 =?us-ascii?Q?/ImtXwIK7zh9Zc2vQ3pnu5Z7ETm9PwHhVR8SrOCalv7t5q4tniXeQIHGM/XG?=
 =?us-ascii?Q?SkOT/M6XGnU41xdqQqPsOJef6xF00peuDZL9hNYD+2jPGt3sOhk2Pp3LEVEO?=
 =?us-ascii?Q?vcD6+2O4F0dAtn62GExrjdfe+PAdpkg/s+6FTF35Ag8RvjPCpSBrDHsSuqYT?=
 =?us-ascii?Q?KY+8IoY7YMyrn24Q0pFHU+CIttUH5AQERkhL38UECCQblOeGTqXDj47xdthw?=
 =?us-ascii?Q?QUGOihCJ4IA11hu22GkgUhO/die0Oo/M4gOOiVUVFNTURRfbe72A34JXxMwX?=
 =?us-ascii?Q?1eqN0AqzVimIAawk13ZLfFOzKIFIrZb2obrMGDNM0cdKYg+zJXi7c0mTmgI0?=
 =?us-ascii?Q?kW4c+Altoqt1icO7jZdiAyEYo+TeIspD8PMg/Q+3W1m6K2GwTpzeqmWZ9McG?=
 =?us-ascii?Q?SlXpevtvwY/dm21QaBBtuTadvaBhlcA1Q2U6yY2p1RbKTkQ5QhAWDNOUb0MN?=
 =?us-ascii?Q?YwnVJA53rCfirEt7QI6mvTecWY1cTEt3E8gxAj9i/Jp+UlScVsJ/sGH3yzXg?=
 =?us-ascii?Q?h8im/f/1x1n7ItnpryWOAA7SW2bsR+BHc/V71cL3cb9IghICFZWGMLuB/uul?=
 =?us-ascii?Q?oPjvYdiEs1s29t2hVBwXfZHM5e2YQ2q2Cz+3PbBzmuU1AQ3M2AlRTXy9+MaU?=
 =?us-ascii?Q?9rne4nofhvyItoCreu+WABZEGGgxDaJo2V0tJgeHDKLyvlfE+w5mvSSObnRY?=
 =?us-ascii?Q?p+PCpv79WadGlw5inf4FR/TbO0iwozIZBbUfcwbXD0sajmtLvDEkg8bcwdrj?=
 =?us-ascii?Q?69xMeA1dRPO/dBRt+QvdWZU6Sd46ab4+paTGontcGQILs7E4MjnSL2ePOgop?=
 =?us-ascii?Q?7NCa2qRvaboFzdrdP7xFFHbiD2Ukw0XSgXDh1x/9ExMHXv/X4WkiEpywD7LB?=
 =?us-ascii?Q?P/QCxSjNRLX1qZDbQBfptTIBaXuisbdu9mys0VEU2aM5Bz20pgV28JjFMsWN?=
 =?us-ascii?Q?IoesDOKk0pQ6kv8/OVpu92Q3z3kkiUXnmOrUvRjyfaO+z2cKXqsgfC/R/BML?=
 =?us-ascii?Q?j+r0smhvYSU3EjdwuhhF1paVk8m9mUZHj7fpKL2ls4NDzJObmN0ZyyHzCWEY?=
 =?us-ascii?Q?jfzxZNA0sgRbXZJ8nvisWNtOfmgu4LJfQnZ5Pq49WRjDNOey+/XvGC9H6wGW?=
 =?us-ascii?Q?Au7xyutb5pQKNf6O2FeaVP5A430N06zHTBTEatkWl6/hi80/JYrvejbJ1ABH?=
 =?us-ascii?Q?W/UFMTM7ZFKcwcdBtET6oG/2mYiVYq20vtwo4QBnpWOVWtS5L4l4DnhxJtz3?=
 =?us-ascii?Q?Y/WSMhOe4MuGJINTn+0iUvg8oPH2d26vl2dhlH3XYbRru+6EcEHk69N/wB+0?=
 =?us-ascii?Q?YPdPvrXJddZxZMix+YRsrX3ppmgiQRJ9oEgyG+87DFCjkGU26w/26Bs43hG0?=
 =?us-ascii?Q?7sIsuKODmOey/dNg58nw8QZ1/AvaFlQ82fITvdwB64PXXK68L6BohZrC5/wF?=
 =?us-ascii?Q?VC//WJv8AmqmufUiFSCGIZx4PnmPaDkiNVf7x6KlPIgyfRzKpClDAXPjl2Mq?=
 =?us-ascii?Q?iO1GL3UwvLQKimL0XarBsdg5CR0PO91h5Hi87Tw9uRsSxycAwqZNMYdtP/hM?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lXKIe85mTO67FG6cUNf73LR90LFi2JiH5aCTMOleI/9xRCtPkn1kCL+tmRHmcuo/iT+jzzqWXYnwTuBKKPR70HmLcEOUeFHK1Os1Hp3CoWJzs/YegFcwTWoAQFTS6RKCOOx4rb6H4/8Mc3M/wECCUMCqy5i0jh7CCTZWweUVOK298EG9p/9qw5Mm7IhUM/Im0pCqRN2IFApj0fg5zhp2biwo18YCczlpQTJC2NmE2gBqIfI7ApSV4zT7NSgGPCqovLxiWp4iLZNktN9cb4CEanGj4beSHwVzKNTY0khgUcY60gtBoH8fWrZwae8ArdiDmZ9dHW0ZZVMkqqIddkP/qER6GptU39SXqwskoeknb8IZkxbyi8N7bB9uTFnVz2kyMt2jiwsTtEjLE0jR9UfvCAk391NAba+/oWFSUUmCTGBf6wV+zJxY25u7Qs0jPQvE1Qu/xvP5ZqRq3IeMJOcf+lUx48kzuGeZSg0f319svYcylDBFuQnpgCzBdExNvtL3rGbCKQh38UI/SPGtgMCiwt6GTwL5M8LAr7tiFE02Ciu6C6be3JSJe16Gdy8/BYjhIqsQPtZoe4jOC+KcIyLmfUfTUJXiF7XzYVKkqgUyfa8agH1xnoacVUuP3ixnxt9b87EEUy47geOtCYkfCgW5Vt32+bH1CZeoj4sAhGVCMEykWBn/OApJ5K78hvASf8jhrozkivWo9k0uKxuyBuqpyhm1YDkna/lXLjvTH1sYgT1c5fkQPdi64p3biuoR64GJvOyAeNJQUgAw8FgeFCpWkip2Gjn5oXEVfI5/Rf7KiRv60vXSFEEsdHgZxkF2VbcEYfdF48XzxuOhlHdcxTPCJMURErNVM+JaqIYic66LRhiaGNhUbSpPjW8koE/S71Us
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d2a7d0-8ab2-451b-4543-08dbae662140
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2023 23:16:27.1910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDWMBeGfLT7UzTrP5hN9gKGZS+ACU4uPi6nIBoIQqbl9KIYbTu2/Dwvo5AqeG2+xTr16w6iUKw+Mkq4RxFDs9tzQPKFkfHaTUSLNOKYQgec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6109
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_13,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309050201
X-Proofpoint-GUID: T-E1Rga3cEe2ViYIU0BOqfHOA3jd1_eF
X-Proofpoint-ORIG-GUID: T-E1Rga3cEe2ViYIU0BOqfHOA3jd1_eF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

unit_attention is not used so remove it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/ch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index cb0a399be1cc..1a998e45978e 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -208,7 +207,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
 		switch(sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
 			if (retries++ < 3)
 				goto retry;
 			break;
-- 
2.34.1

