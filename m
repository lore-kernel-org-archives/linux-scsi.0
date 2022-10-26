Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A38C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiJZXZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiJZXY4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45306269;
        Wed, 26 Oct 2022 16:22:44 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLFsOd022260;
        Wed, 26 Oct 2022 23:20:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bth/+534zOuK9kB9E65xM/EXVTInltICBYeRN6qz/3Y=;
 b=kIkJkPgxVDU13ASrNNzjnYC0Lr9vwAvXA5cLzPjyZ3bVSNoKmXvhYBJesIkTsxNMF/eV
 IHFU6iaVJsbtOfAHMQYx9ojDOxYipM9cW9JLW/iJCnZpMmvUmJNJ0LmRFGXxP8jWnIWQ
 SGN085qgHk+a3l/UEG0tdqpPC9RqZO4/qgyXYBHGZFCOwCB/Ok7crBWJYiz9BXmSIHH8
 lF2gpPuiIeTVaH2vLxFJME481kNpLMDX3bufhkBl8O9NAEn4uH7cE0iuk8fO+48oRgt2
 YpULAJ8Bc7MEXDzM2MohXm8cZq389LNM6V99VNc4CeiF7fW8PGTe+GPZWGMmmHTfC53g dQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLkbbK006786;
        Wed, 26 Oct 2022 23:20:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggdrr0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCqSOswfXugL2KHcwaFmynj8jfwCrsrbCTyC+qXf8igQjy51cStDiqFYSpVWSUrg/PsT6inHWiH2A9KPXyWUzYtBUdhIqAGyDyYo2sh+wxfXrMQeLNTznmc81NOSxHEmzduMvj0cgeurdxkesiyKRynkSZmpAY00DbEzdkeB6EYK+0DJHT52mpHx4o+3KxWEYzB+F8igfGV8+sgr95MT/Nx4saUfh3rUvIQny9Yb9Qv8HThznZh5Q3FewLnAi+lYtcVMvbfxQLZcn4RaLw7yAcj1K89IBh2DZHEM4hEsHJdhRcPLFzq8MeFg4xz6IsYAwo3mMkIhKfuVwmeTI4sxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bth/+534zOuK9kB9E65xM/EXVTInltICBYeRN6qz/3Y=;
 b=UO5RWzVi9JWtkGFTGwu1PRcvepMLRxb3HAwv4aixPm3ORQ71knWdxCeOtEQgoMOw1z2ZayQ8T+9uiJIRW5JPLCQ/+vvWNWEfqekI801E81il6FixDCrEdYFdL/e0qHPxlgzdKTiiJSeUIDybinlUI/eJsoXsihWZJI/jisfEFWkev3HoJYo+XCvMIXrvfCUu8pdgxORemg6WxYbZ07OE5r+KyQNlSePT74pNAaPfnnRQjXln3cS1gldJghWsrLy4ZMiLfiWuMG1K4RmYwfaCiqxAEvlMumuejF9oJCoUjGeIntcdJAaFK5OhiNLilh76PjNBO0IRaywVNo8LLVDrAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bth/+534zOuK9kB9E65xM/EXVTInltICBYeRN6qz/3Y=;
 b=HIOSFUquC0EgSuXWNz7I/zGxBK5/h4SFWvTcqy08uKn20BJ/wU7CzQ16XPf6ETwrLtc1D2MzPG/+Zx6TYf6TSmabB+omRhmjwoxBFaL5sQ2HHS4j0uhGtvA3bPo7fRldetpqnyOyp0S55okXF8R/w6G3+gtklsvskh8jz+VN8DY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 14/19] scsi: Export scsi_result_to_blk_status
Date:   Wed, 26 Oct 2022 18:19:40 -0500
Message-Id: <20221026231945.6609-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:610:4d::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b9d4192-c268-4511-c7cf-08dab7a89fd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLqVfkew1QOoaNHRty1gQBmwYNDc8SKiGir0AKnYEsNbTysUoi7QasiPgh/HvukpSJhaH5yNiuESQUjN7z+ad01QM7EgQhZnWVEDKIIJDhU6ssZKF5ZX6klw97bAZMLJ5QD595fHEMOYhPDmlsDgbeKxb5/LJe3tNLTBkAZtmrZeDzUHXE+7hjzMd86+4+4YkZv6jTnaGuAy1pcPd6u6VbhcEtBlHvwttLxe+8U145z9ltJJdN+IeRofAzh3O1DPmf1HqqxoWGEdsJTQdcUVhOnKgvsGXeuDy16bz1c8va4UzyurSgmgKym6Yt0dlN7BCQwsJu3jWaZIVfIGvZZlMCZ7/my2Szy+NOZs17pttE+w6lC8dz+WusCU8YaJFDaltIBxp16oH3cdQw9Il+Hfm2qO7pbdL5Kdm96nH9RTifleT+8gpDZJvNnjliL8z2NEPew2moWE4NI3z8O+pdmpQdbtXUyFVyqVGr8TznSl/FwMgni86anbkDIy73njvh9KgPOH5xGMQCHTf6i7bW75xdV/DhuB9YxSXrHltHja/5LY/11/I7WOn/TmnT8SRVa0+NrinxZdK82fLBKSygPOWWdt9vIQNldqW8HoxHJMhq4c1lBLWDNf3MEBBsPq9MMPQ+Y3PPHy6VbAanlshSyAepzuc+QV44AnMn2YIL+YyooIUogkQpVv4EpdPSaiO/bR6rVsZbHEphrEjRgpDnFYEJse7fPFgzWqcCAMYzWJGD2Iz5xi3RrAGeFXo7c3ZRxa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VW1Rq9mqpshbU+yt+FAvgYDl+CJZqkLAmz+C0yGMbPFeFVRwSRAifKHYrK7o?=
 =?us-ascii?Q?wLje5OzXq8BRCwqyAOXUPqxYG+slcrIOPx8WHQ3PDVBAsmcyMemiYTYI/QWK?=
 =?us-ascii?Q?w5r2pbdBlcbVOiQs04SIDRVef67nCJI3PIgJkM7NC6X2X+bziGrSfcowhHzh?=
 =?us-ascii?Q?yf/UALVy48qO3NmfVL+VNc49hYmDPKctWQeEu49AMlR79hhPpP6l3Y9dG/GW?=
 =?us-ascii?Q?lcPaXrOLd2p50NIx6NXtehbF5QDKRXAFWE0eSEof/q9/NSNIXaalZgOifn5m?=
 =?us-ascii?Q?8EnrDtLtKePlHxlMM5l+AX8vp0G+zWuqq64YOCi1gdxix9uIcb07dXeVRGOF?=
 =?us-ascii?Q?zbENtlTQ5Qy+j6jEvx+Z4MixlkUB4vpgrXHz4mChPFDWfwuEq13DYso4F8u6?=
 =?us-ascii?Q?d+uYLbn1pFUpnsIMMPNefgnMtxxKLtoF4VDU3jEmUR8T8xLtVRcfx6NjVKrP?=
 =?us-ascii?Q?zaCzRxggGQBfDBnv3IV5u970gugNeTu3DpBJqN3Ibu0Go69tZQAmqJUu/irC?=
 =?us-ascii?Q?AAGTOK+I4KJWeVKGfJlTlrKfsePX38Qc9fIxzPT0qAq7dxM3QB7WovHYWQAA?=
 =?us-ascii?Q?jS5zfeEW+UMC0mNm4HW6S3HFyhLHwmiq/0AKBkjlrUaS3At5bDEcpQiDtfAF?=
 =?us-ascii?Q?nkEr7tKGL2IKo0Rm2j9tv2LqBi4Z6R3oUWHRgEK4xbpC0vUHpPe5B+JY/3BL?=
 =?us-ascii?Q?Fs02oKd9vXhNvSwyFdtoTXOXcrXQLYRhN3INDYxmTC2soMM3o4dyB8gIZQC+?=
 =?us-ascii?Q?MSX8lge9ykkVmoV77itXUMWkQJ/po2DSH1g9mf184x4QpE9iGf9T4LBv6PkO?=
 =?us-ascii?Q?HRAnqdu6qlz/DJsyjTJNod+kFRbQAW7sxKrar23qtgTGI1E6zZL6crUq99xR?=
 =?us-ascii?Q?y6cuuaWDPvF2Btq9eiofqqZ3/VqLbJ4lRlRcqbtbneWM74trGhzpTJPduBO2?=
 =?us-ascii?Q?UrjG1DHHxyLLmZUxwfVpe+Ws+41zMqQvkn2ZEP2C79zfGIsSLdcLK0yzp9Ds?=
 =?us-ascii?Q?CohvHdo3YytZBhCZaehS4+1YR+ic6D89p9PiMkFN+ydQGpZPYqBNNZdPBkbs?=
 =?us-ascii?Q?2qFQaFHr+0TA6wHGKY4BcYhAdkKeXvgctM86ZylE4azqQIbf2pikXcx9vhs/?=
 =?us-ascii?Q?6f7xRIQszpxC8RZrDRUR/XMCzZgT18TC3JxFkxvERSdyeKTQSNny/tTDSVA+?=
 =?us-ascii?Q?/wfd2HLxWgZqM4RkWknVRb5PsCeKbvpnTfTCDSfLZ/XhrrlmtDmyGLtFGm8o?=
 =?us-ascii?Q?oucOFmlTwQul6j7lK5oVC7Gndk4moZyQjzLKHqKP/CTFSjlScHyolrE/1UIE?=
 =?us-ascii?Q?CkFqPlLFsz1q4NBH3HKjc+7JvKYphN68zDMNg4XPyBhmSc9EFsPFf/gCOAOQ?=
 =?us-ascii?Q?C6WpmdYXIUJJPNvvkuIdWHAU5iRNVfv8r6JQZmx4DR/9Pgb6wvIoDeuwLc7q?=
 =?us-ascii?Q?kP6JeNnis79VdLXlu2YFbECmSSSuWtpHJNBMogXDCnPhW7hi/MgDHfXhZYE+?=
 =?us-ascii?Q?LCK1EWLZ/p2khAkwibounWfNYkDtOh5kAIATSLMMpx2yl1v7YC50OVa0l+Xk?=
 =?us-ascii?Q?Yh1R1T3BjmvSvUjsdHBOuYBqglRSqHg+nEyNcJBArTX9MPbL/OswpAzceTR6?=
 =?us-ascii?Q?Dg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b9d4192-c268-4511-c7cf-08dab7a89fd1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:09.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: chy5SvTy8hoPRc7FfzMHirwEOVeLbLI55gJc/GdGV8wzjqTgMRreetGHqYGHwzS9WD+SlBqPGhrCqJdD1rUTK395Xmk2Hl+Yfl6IldqMYXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: 3qbF5JIHPmI5ciqop8b_fzaRZ-NoffAy
X-Proofpoint-ORIG-GUID: 3qbF5JIHPmI5ciqop8b_fzaRZ-NoffAy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Export scsi_result_to_blk_status so the sd pr_ops can get a BLK_STS error
that can be returned to other kernel pr ops users.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c  | 3 ++-
 include/scsi/scsi_cmnd.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f19bc3a7ef59..9367c900f093 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -578,7 +578,7 @@ static inline u8 get_scsi_ml_byte(int result)
  *
  * Translate a SCSI result code into a blk_status_t value.
  */
-static blk_status_t scsi_result_to_blk_status(int result)
+blk_status_t scsi_result_to_blk_status(int result)
 {
 	/*
 	 * Check the scsi-ml byte first in case we converted a host or status
@@ -609,6 +609,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 		return BLK_STS_IOERR;
 	}
 }
+EXPORT_SYMBOL_GPL(scsi_result_to_blk_status);
 
 /**
  * scsi_rq_err_bytes - determine number of bytes till the next failure boundary
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ba629ac4525f..2ef3b92e901f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -174,6 +174,7 @@ static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
 void scsi_done(struct scsi_cmnd *cmd);
 void scsi_done_direct(struct scsi_cmnd *cmd);
 
+blk_status_t scsi_result_to_blk_status(int result);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
-- 
2.25.1

