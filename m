Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99646EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjGNVgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjGNVgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:36:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B963594
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:36:42 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4ZFY029810;
        Fri, 14 Jul 2023 21:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=6h2LDGUDELlSe2nVsNyEBjYguZN4LpICUM+QUJrPeKM=;
 b=id+7F5/vIlgfhO2ZASpscfRglPSnUnPLZ1wkpPOdU90J3uRR8KQELCrrlt9ngjU5PE2r
 q5kBBiluyr1VAcmvRDk43yce4GW1GX08xD7caBRR+YzM4EjAK26esvxNf8l/Zm7SuJlv
 YCw8f0Xll8QhfbgDOzBcsPAmQV6DTcYX1u/70FchK0apze1Do/WX1ro59wNOkcMZSoQz
 UkuIxq3o0bKsd/12uSGyEzAFvJgdL4N5dM4FUoGdr8ZRjM73hQQPflQS5VLmLgwy/2xX
 jxveV6iGI4NCjsXtotpkrGSZp/Hyqp0D7VVOfoccfOvP7YooWhP4uRK03n4hsoPhj5PV PA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtq8atd3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:34 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJuqFX023540;
        Fri, 14 Jul 2023 21:34:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvxsd0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AixT6eeH3PLppNk4bMAebaxfurSsDBCMsHf2svOg/xhc/VJX1MBhlHV6Ge85YcL94ERK/oZMMzFZpRsY6bMsuqAdu4ESRujX7cV/FvvfUHMle0XYM+YWcFWmzfS2pCgpZowYh1bsB+c67ZP2YKIDdIhFam7mIQxXhBL0Bmjme0ie25m9faWOHfRc0ht/qqbItUcUkrLeVDyzwgFj13lSGcqBEgldbD/6mfCyOfHYoDrBpt6w4l47KgfZ5+C4bxMl9N8kgcrN3dkvzg6YJz5Iy+9G0V7Gu0/0tadjRj8TfUR3JbeI1cYDYNNEqHjP40ey6X/pEzU1K9rm2vUMK4Y3yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6h2LDGUDELlSe2nVsNyEBjYguZN4LpICUM+QUJrPeKM=;
 b=IapxYbaKlekndkM6WOJwApyXBxHsiCjoBC/IJ3P7/cNSHwRvDB6dheoTpziuIlD8dT4k3RVyRZ5rJqu4Ktge9MjCGVyw5lGcut4ECeITyp2Q3e7FVtHL8U5yPA/yKbHoZPyTnYkoqBWzCKM8rykNMT4dFNbpbvDqA0nsTzwok5idLUZg/eTzUk2c8sIPr4YSWQr5Nb7eo4of9+vSv2xPbvdmNk0eDKz9mskIGRlrR8j2fgmliP9lCw8gmmnGswqvy58Y2edSVWnZPsGhJQ7dOS1JFfSrhY514lQLGoN46BWVaVBsGSRP+EZ8W7RnbSVqcFtl7ywRrDDL4unnMc1PGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6h2LDGUDELlSe2nVsNyEBjYguZN4LpICUM+QUJrPeKM=;
 b=utT6VF7hrkWkKjcZc8s2DYeYGmkFxkxeHywFXPoRoesl4cnsdPzS23UznzTV44LvqYMz6nhO1stvRDoSqk3/LcMAEtHyGobEBgHlP9l05f6KsCdt6SDAChWVUv3Uw9okHTwhRMYoNDElmLnyOsLvDTfozyx1UVCQr8xSi3Xgfek=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:30 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 05/33] scsi: retry INQUIRY after timeout
Date:   Fri, 14 Jul 2023 16:33:51 -0500
Message-Id: <20230714213419.95492-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::21) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a975477-b947-49ab-7d85-08db84b21b85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gRv+I12fHbp22WKyxVzjiCjOAewXfcU0vncSz2ZpEgRfaixOHgLsh0R5ue+bbQ9ZvTBQuBfnAWA61+juY/kJAM3KqZHS9wnIYOQ3aY+dN6Vz7CeD1ExCldSBd/AJ1492legozU2h3lDFYsw0uT4qzgK3SPjmZxFJRUePUwUojb7T7d8yYLni6jFcLG4yC/NstVslP82Cx6LcJVO8hOze9cXjjh6xxjpmhdZuBMm/py8UrOfpclg7mWbGi8AKeq9H5GocaShchwnjLSa9DGtt3Hu5f2y1TlPfAWVT9YLAXWNgx8c88HBCy3qgx8XSx7asTCbZXFDkVq1GLe1ArHpRTqUIjZhFhcvRRn2IfePd/V2GKdUqElbB0GZcqUHk4BlGrU0vAv+ZoOATzJr9Cdo/EBugYJikD7GnXIeVQNvxfpcBE2N3QtdET29TVxvQzaDIr9ZIMivtPVIAOcx4cn1EbcOhPBaD2YKJHrk+uqoMP6RofWDhiT+268EUzUbP46Bw0fRAEd91G4uxPPdxhrnVXSjb/UvZd3KgeDxL+BeOAUBe6qWA62wazJ3x58/M3Yro
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6512007)(36756003)(316002)(8676002)(8936002)(4744005)(5660300002)(38100700002)(2616005)(41300700001)(66556008)(66946007)(478600001)(107886003)(4326008)(186003)(66476007)(2906002)(6666004)(86362001)(6486002)(26005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fjoR5zS/wtRThpga5as2I+HU1hdU4IyOVIbcI+rBuYG2Km32E89iaTaYP27v?=
 =?us-ascii?Q?IV3AISbJ4AcoyB0csWjTbfpH6fr8nCUoWOdROkIpIj7kEiL9SFL9eCO6k7vq?=
 =?us-ascii?Q?01qbtmhwT5POwHANUraxOEhw4oj3p4SY1mdGXdxvPqflq/umsT9owsYtpy/d?=
 =?us-ascii?Q?qOzPEGbqPahe3nhHST5+g3ANYv5L2GNqgzDP9kxMW/VVVJBtDXeU5LE+kYz6?=
 =?us-ascii?Q?plUCJTyzsBBwvBWWfK1LSSf1bU4UMBMxJ05E50k9a0qNkTe4IOLCLZduHoHy?=
 =?us-ascii?Q?jhkw5X3f7RTnMtsUdNi7Cg8EpKsLNbEDhesgPdZsrbeQMhZTZ8aPSMnm8kpr?=
 =?us-ascii?Q?AjjR/5JoCcZwLP2lVN8fc85ujVhZAeuqSKNVwqd+JMkyTNeDZb40SGPNHdJZ?=
 =?us-ascii?Q?W/TkYnXWfgrldLVR7VKrQjM915tcbKEUr0aSRzLsDvI89GWTj6alwGfXPYhT?=
 =?us-ascii?Q?arhK71NOo7fpDciOaDsPKrxr0NDhmyiDlidsu7Xqi4/sDu3J8EFznh0jBQre?=
 =?us-ascii?Q?YhoKHfV5LhNeSGBK1tKSH8Y2eKKI+pB7GEYz5QV9eFdhAFNk4y/K9EI9Yslj?=
 =?us-ascii?Q?ZtixlqTi99g6lHkFOKDN0jxwL8csuD/BES6kEBeuc0DaxBnTaDDpCjJgY14K?=
 =?us-ascii?Q?z1rtlOb1gDlC7mBQrav97LqYdVO+M+sz7Rapr8g3ELobLEvnVbHeADPAmU47?=
 =?us-ascii?Q?AF0JP0mhVpRoi5avICkrojNTgkdLQtISWJe77TiP9PsS95SOtal5d961w+yg?=
 =?us-ascii?Q?8nfIhLzZrnkoPsgH8ET6QoVQw9CpxLtLhhTT8VCecvHrujfnxwKZeEKhzMbq?=
 =?us-ascii?Q?jsx3HofyLp6AMLiWtazi8538SFx6JYYleNzij678+mbd72w4mS8NBhgwJFqd?=
 =?us-ascii?Q?ZipqyI+fE1sK28/U+KMW37IFSsWxmDz+Bb4p3RwXNgmSw6a+dQewEys/8pZO?=
 =?us-ascii?Q?oxo7X9tGsn4plFGiMED81xR0EfqhWJex/4Lcp9tym0h095n981aAA49GcsIn?=
 =?us-ascii?Q?/CrvMnK48Dwian69Kx8mM53MO9efExqGmMnT3cxnE09YCB3YbdGGQ5CHP5Bo?=
 =?us-ascii?Q?PpUGaIpKb6STwIHzd965FclTDrLWZ6v/6WomGNEqyw+8DcJ12Hl+ewWsUeLn?=
 =?us-ascii?Q?1gfiFJC7TKQy8DqY9kIGBNDCfmX4yAApd+qIKcgQIPTDhUaWQgU+X6aG3UEw?=
 =?us-ascii?Q?qmCd13N+igMFulBes3/jEAokjW+3ZVldLC28ab+NkdGzhC94oF2SXnAp5+Yl?=
 =?us-ascii?Q?9Vy14TcxJXwqu7wLPe8WSYi5V8egqVK1ikf0DOsR1lxbIMuDQ+Mfe/hhEwB6?=
 =?us-ascii?Q?sYiwZLkfPDZJnrHjV/IKnegk42LTftBhNin5bJ4kJOaudLiB94HmGV9CJ81a?=
 =?us-ascii?Q?QOBd0qr67BFT+GHK9qGfsUNHSDBc12JtrCsLY76KzJcQ/Bu7RcsvxvyxL+Kk?=
 =?us-ascii?Q?C0uV1IfFWbIr3SPFYtgaJ0vcvENo6QQe1oKvclpGZfElduoFkAo1uWK0oSU5?=
 =?us-ascii?Q?6z9f3H9Qrt9Fh2AWYeuXP07bvV6iYYXMBCgNCrIYWphrzTZRkZ6SCzYGomEd?=
 =?us-ascii?Q?mA0EhCOILSO47pjrtLYesD+GwmGL27/WyNqsa/blZhayxFAXwLJM1nm9Dhcy?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OO6fIMW4kDrBt0GrWvL8ztlqRDgB5OrmF3x9Dp4LK3LW30m0j4V3L+F6ge3gJVyVcO8c2MGiUB/AfmA0/EtVLxXzztHA6qoKHTgHbCqGRmAYDwfd3VO2uCPn+yUjMx7+IdPjwwSF+bNgTTSh9YQ67I9ejuteIM9TtZrC88J5GSR5sD7b/yCpZDJMpOQF93FsD4Hk5fHrokvHGsd44GlXeUXxekmxcKkEF76k7Q5a4084sf2Pg4PI06iHdJhLNZ3RyX0Ob25Go6+gID98pot+bDf7ltGYaeKc4Ln90fMJ9fXAEmGtoE2tZ+Ebvcho0FgPOnGSlVc3lbidt85zdQD2jbtt4kEhdmvxW6LLvRsfWwaGsxgu2FwSoeiKrWxsVtIwUuIMZEDYNxTkxOU4zjYhFz7hI/y5H7xyrwX+v0Lp42CDd7HCdR5r0tglhEUZ6gRG1/TSeUHlK69AZRXqiyuNqkLqaHp6EPgWP51To4TmW2JShlGKHW/NftkVJIBowovJ0B0p98ejyHInorEc8YVS3gFJEUMgc7vu2izV9ElnVtMZwco1SasUeH9pCmq0y92vpiJJjwIjnZk4+MDGWPFcLbshYxzmAkHzcXGxKJSZZ8+jR7V8vE6V0u7U8TcK6AtIIz6DllH8/q8JOQVmoi0463UPSdqNwiJDiV37wphFKKfBpluHzho3rxzow+5dppVplSm+A8rixhPdc6tSKgjUrZrIy02LBh+CO0L828HfGkOgTj58pdAKmo3Rj7IHgyE5eAW93sj4VU7Nn2x4OzzqcPfcQ/6x85b8lRFE4AGKIwGu4KfnB7n61tOO/8+I0QJlfsolRzhSzK1pz82gm53lJAjtpqX7rb+L6yWuHzrtNHt3cZhKspf4Xj1bSzqa3Gqw
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a975477-b947-49ab-7d85-08db84b21b85
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:30.4911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iDjgOFp3Otqg8U8FowPTp4DfxF18q9oE8RxJtbLrKFfUfJuoubdz3aRmi8LqeKzgxzah7WzvqEY7wQSsDGl2B4qkxWVHYJnXW/+fKpxU8KM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-GUID: J5QkAiO8thnThTg8rCJer5wm5xVeXRl9
X-Proofpoint-ORIG-GUID: J5QkAiO8thnThTg8rCJer5wm5xVeXRl9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Description from: Martin Wilck <mwilck@suse.com>:

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 39070d9e2d11..e3c8edb92164 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -665,6 +665,10 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			.allowed = 3,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
 		{}
 	};
 	const struct scsi_exec_args exec_args = {
-- 
2.34.1

