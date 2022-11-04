Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DA3C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 23:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKDXXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 19:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiKDXXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 19:23:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4626060E7
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 16:23:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4Kj7C5013354;
        Fri, 4 Nov 2022 23:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=3aNbeZWnUIkQy43m2r9O5AZylr5VgufUoEUKDZ/Bzc3Yp6MSpTlWVTH0oxSuYGiYNGP8
 nU2pCMkyV+Nc9KawDThJVNnL7Qq4tz7To9CGKa4pjxQR+iunSbhly75GcVd2rUoPOwsH
 swId7aiBTZu71VZDrT22bQmA6CjmINkaMYKRejzrT4B7Ng96SE7s1bLzNTVkSFkd1BJC
 dIFHCPQZBqczsKCmUPHOM/eDrD9gL+9sk1r8DZsCq403c4zzLcRDRdfHBC1pPq1F3HDZ
 X/xRZXfjNhMAdrblFKzf7oKKbs2vMUK0p9dCQjTX4gyCX+zXEWrw8g2kIEIjBFFJSIAX 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgv2as1k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A4NI0Wi029703;
        Fri, 4 Nov 2022 23:21:37 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kmpr9a8xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Nov 2022 23:21:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2sfMs3tHzSWr9Mx6tVVJzv7LKSzLU7rEIbASw543YtHr+gEUjiypIXkgPl9oGv9EYzNtsllc/OHmt+kpTkwogFWvCmg6JnA14+LIjU+QluWQG8rPpDvzqdV3q8u8xLEz6l0cdNIXBxX9DSwojzX9Zyt3M5oXg/Sdkh3ydPdSUK5auUt82LupG3AOqd7Xlf00WcEulOeq2wR6XZ/kaZ3st1V8PCsmgOqGM2cC8En3IuIcy7BCItFxWjy7nv+CdhGVEIp5ovB3yK1VP5YsFnvEflQW+z6++cHvzQEUjA/5ccbHMm+cQ20M48Ed14wyz1qQM24jt9v98cvRJozO3kACw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=cudG45wz5wAyHcS8hnAFa7u0dLXPSlqXBhHMhRmPc5wkK5nMie++HihX3ObrRXwVa5jNpuJ7Ukz4CAKMmYNoLcO4IFgPX4Chpyy/gk23Md/p03RhI7PWoWlHxATya7m1/x6v76M/THpe034/n+hmsesXZZ5YvNlC4jzSTUJqJV44zeqEwzLjmTEtNfSXxD4Pl7Z6QTryhliLcIv216goSGQN+t5r1J/VMEURejBAS/fpG/kPIbnSJpDdnuZlrpOG70eLcl00bL+bz03Ln6KP6pV75sbXDW+76QFLdmWBDLxxTrc5ZUt3h/XHFs+Pgnm621w2Z12qwLCdwzcZjxEoxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=QvfmArU0hfEjeBknzk9KjJBsRpAMnji2h+Wcu/iFngnUmHglnB2G2fCMjQsmfb7g83AmVd4Mz8lHuBRyJp8LV1aUkFMWAxEQGqqyL1sJxMtwkeChijN3jxtUq2jIcovoU5uW9+JAWUChK4y5LdllqlfTieAMAzzfJeO8O54xh/4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4756.namprd10.prod.outlook.com (2603:10b6:303:9b::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20; Fri, 4 Nov 2022 23:21:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 23:21:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 07/35] scsi: ch: Convert to scsi_exec_req
Date:   Fri,  4 Nov 2022 18:18:59 -0500
Message-Id: <20221104231927.9613-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104231927.9613-1-michael.christie@oracle.com>
References: <20221104231927.9613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:610:cc::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO1PR10MB4756:EE_
X-MS-Office365-Filtering-Correlation-Id: 256977dd-ff42-4d51-73cf-08dabebb50d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ihOuJXWea86ShdMfIQSv45+KU5NcufW1tP3zkWpF0QmpARAnqiRpXBOvzrbT4IGj6n8xXLOgzS4ikqF57EAdnYukaE5Nw56WEgNiE0D0A0qsGOprY5DzchmvKr4n1+g2wfMOXIGMxcqe0S5AtsHO2r5p5Qx+FnOFgusFrTd5Q5VtX8zUn3qXDDPdj6T74rT3FSnoXuuNE1m+xALwpV5o712cvt2kdbpXUNXsqyTrkYZO32bG5bYCEDiUNqhARBVQj1iHm/FAQ3YQyP+99NMEIGx6R5YSetHp9EPjkjzeQwaFCpLKmf4aFo1GFMJAEbVj0zITbg2rry99H8cHNSDaIo9dem+Dl2SeJ6tb6W45O78KwizKLp7VwdkBHZr17k8WiCXI5PxR3IMVrAU6N/M7sI86WxCgwkVbvVT2l58uFLCH+d58mLdcwADvdVSDP8zW/sC8DvroEIn46DhrAs40vaz8/xpTQRy5IEH0Qy5vVPm16ZKlTVs8NIMSShUgUovf+cvlrHQDxvlDbk6OcZH0gzfe89zswuYMOCVlNCs3uCkxBOCuHNvPchnjaXewBMyubGtVNN+TqY//MsrJVZFt8s1WPG3q6jfBmcLpmba6NLwdiluqfJulYdPw+t8xITKauAgxfekLjsPuQewYWLkv13mNc0ArOdGEozURJkI6iQlrOosXsmF9l5iPx3ZbYy/bra9a3fWOSH301b2olracvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(41300700001)(2906002)(186003)(1076003)(2616005)(6486002)(478600001)(107886003)(6506007)(316002)(4326008)(83380400001)(66946007)(38100700002)(8676002)(66556008)(26005)(36756003)(86362001)(5660300002)(8936002)(6512007)(66476007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h705xQzjJNttfzQ5U3TBXkiq0PvmUIP0qS/h0eRW2PGCLkMiKVJzYgItM/pz?=
 =?us-ascii?Q?2PkOw2THv+Lo48571hm+ItpVzslYykf7hPvRVdJtJXiDJXERxJf3ugMn8gtM?=
 =?us-ascii?Q?4WqDZLsutQlkf40ry4CTOXDBQo/doQ3o3Qpg165DuLKVUjnjrQ1fJFh2+crT?=
 =?us-ascii?Q?WD6xj3MhPZKoA07MpDcGq4wUqbgGbBAdNBXdTfau364i/LLcURqD3r7x4kDu?=
 =?us-ascii?Q?X+TIeNKe6Sm2CW1mu/0pqRvCvXhRk7X4tmEYge5jXtHHGhdSQtysMKsY+tii?=
 =?us-ascii?Q?IvqYUcimOmsqcFCx9fC+BLliQV7ox5PcgNk8J3cSpurOyEWFgim6nf3h2DnA?=
 =?us-ascii?Q?kZ8+OKirCcvCKbe6FX5hC2PmIsI+zZCsxMKbA8327SXk9Gx1e09MfM0jfudh?=
 =?us-ascii?Q?1ixANtiko6smO5PS9Emd0PcByHTmhAYtANJzJSffLE9e6goHvqZrOKz2YrQo?=
 =?us-ascii?Q?t1gEtSK2koW54QhtjQ1+yu0MyL7wUTdcFUoQnStRFvFXqScOJANeQQo9MAzs?=
 =?us-ascii?Q?Dln+jUz+ebvDw7j+OE/Qk0Z235Eb42gCL3TrdJYFndrSqqndHB+4uOfgEM0K?=
 =?us-ascii?Q?c+oAAVaUdRTnLrByY3P01mLkk7pijUqZiVeoesdeVjZaGhOL3PqPcNoeLM58?=
 =?us-ascii?Q?8FNwjSkp+WFnNz9AeZeogr7HecoeuM2dLzZsCcWL3x+jeYWdBA+9MxAkVl45?=
 =?us-ascii?Q?D698DcHyk/CeUY6NS4l17H4Pi/X3+bA+j+eXA6FynkIWqIklsmqJwl3tA2kB?=
 =?us-ascii?Q?6k/E/3HB+U9lFXgrwVfnDhpSJ+p87knzPfhh9ccXyMVj0JzLC9TXV36C3JN3?=
 =?us-ascii?Q?OjRzCsefBwxGsBXZXrhEX8CnsWUvFC3MGSzebJroje74HPGw/G2yE9blAf0t?=
 =?us-ascii?Q?mRgNbM4EbVrEU7jKm7h7PlNAf6i61kdpa5Zv1y//6BdJC1U7ogiySRHliScr?=
 =?us-ascii?Q?cUYslABUGvlED/pYB8Hv05cgkH5XwYmyO+a+Ir4Ma5Q2JdsfhNshNQjej1QE?=
 =?us-ascii?Q?7XPsJ/joJNPBstfN0/kxXOQkjzb+SJbUhnIJIJ/of7CbzH3Cgx574PXaQxfC?=
 =?us-ascii?Q?O5afW+7dgu8udviUdcmJWdahkXyBBTtT61ULntQrR48blKxIvFqlie9VtMZD?=
 =?us-ascii?Q?h2HLlAM6FxXTRwjPRxSO2Wm7wfGJmBlQ5gYXiEeVO4lNNo52DcKy2FRwRrYY?=
 =?us-ascii?Q?F4n5jItzP9weBdaFu2Utq2/A7UHWXCEmzjCjSOybZoWwAEUxWAV+RNbgmDTp?=
 =?us-ascii?Q?MX6UAdqkS+hp9TIUDhIStVjti5wCe1v3+a03Hy2aEtEIekjeKvWL3VPJ1CMV?=
 =?us-ascii?Q?JfgFN435fbveIm3y70fGa+0O3HBzFwIG/Ii1wMo+r689ARzyUnmiq96Q1K5X?=
 =?us-ascii?Q?W65R1p6nciDpD2M1/bi+dHAlnoWGuxhH1MPSwRpH+WVXi9xPVspvqsdEuj8e?=
 =?us-ascii?Q?yMdsLpylXl3y2590zXBakOAgSOCQVdlqMAMDlgz3YcrPgPA5xZfzywh2/xM1?=
 =?us-ascii?Q?7ijd0NMZVGU5TS8NjnZIMpDaznFncQiPFujLq+skh0oOiAGTJVlR49TPamWq?=
 =?us-ascii?Q?JZJtrPMfjwPTEghRpXSq4JhYb+T+JTYDTznPHGHymPYASS8dsPsaj7NiTsqi?=
 =?us-ascii?Q?IQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 256977dd-ff42-4d51-73cf-08dabebb50d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 23:21:35.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2RGXYrlufv9SnPx4Ziz/a91YKxOZ3Z8UWOExqJxoMYx+/gb7Q0oPyH8Qnb+PSJw65V5c/iR4vzSzUp/iM2lV0KEKPIMg/quUGkjeQR8HO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4756
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-04_12,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211040143
X-Proofpoint-ORIG-GUID: _yYFquZeJmZiDszhgmI3oOucVXh3qPSX
X-Proofpoint-GUID: _yYFquZeJmZiDszhgmI3oOucVXh3qPSX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ch.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..511df7a64a74 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -195,9 +195,15 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = ch->device,
+					.cmd = cmd,
+					.data_dir = direction,
+					.buf = buffer,
+					.buf_len = buflength,
+					.sshdr = &sshdr,
+					.timeout = timeout * HZ,
+					.retries = MAX_RETRIES }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
-- 
2.25.1

