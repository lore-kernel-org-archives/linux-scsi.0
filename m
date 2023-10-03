Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBD8E8FDB3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241112AbjJCUxd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241096AbjJCUx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3390C4
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4n0u014375;
        Tue, 3 Oct 2023 20:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=paSmyk7o6XsX+aCqXGcuZtGqjxiA9Y/rhapD+j0iXlU=;
 b=MLbSxfTeo/UJCAdJluRmtXV+lV/doygSGRIoQxMGdQgqU2SyF1U0gD30JEf/SKvTR1er
 SpjvgJarUAq5srAdkXnT4ShdwfRLUCb11i3+FlRj6eJNxVwt9vJ+JJtST6IsYAjXKo3y
 FAh8xbYc33v/M6X+Bgbwy6wlDy/BExcJRFMhdsr3Qd9pPNQvey/cyRjsRqhSbDwNr7cV
 doyHnR2quOgxWsRR7xGITljEohTBolSVGox/cIpBupp/OPwXxEjF53ziKt/AIAa4ZC/H
 Mo0B4qoPr2JnEspiuNxRoCsuWyU7oSUdCA9QBFnO0zY6xyzsXhpAgrvFvq5Z9WQuxZa+ FQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea925s05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393K3kO3033640;
        Tue, 3 Oct 2023 20:51:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46tekh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEfxDF8Z9HKuh0YNJ+qmfLoCkMaFzARNtpImIJTPQOSj+M4aHnqb33YS3u9lH39o7h08+/eLsMBDt93rSh4r0ipBtm/KJQ6Zlnnq82D1jZspOZ3v5f1fVHB533fwxQRxNWVR2tNhskMTmG+Q9qEs5xQ2ctLBJnvVJwVvs38BJlmkFJ5jzfucJNrbI3idpnTme1kvsSxou49dDuZwPzzZuWgucwtxi8haFdBFgO2r7+q2Eqz5s1bgqLImbo4J1eqluMry55CrggdOOMnmrVDy/3SgUh3EKn+tNzvPp8oa0Bt7bFnB6mbFgy11pyiHwfWC/s+VZcrId/CW7+vU6JGRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paSmyk7o6XsX+aCqXGcuZtGqjxiA9Y/rhapD+j0iXlU=;
 b=YGfp2iIBTC+KXc4QdfOLvzHYwlHLHwykxpox3u0g/baj6FsqWnMwCtBD4L0UPpBpEgbSocX9Vb37bpAxYY9lO9ndCjRVHQ0/bLfZMZLzdZVImxfj5/RdEs4eZ35ko7VsLzLcjBElCYc2BBD8aQmV7G5T3uOVupEDUJ90DoSBXCvxw+QrDOa2HrXu3nz2/+Q9FsbZkT4YOnlr127p8yxGAjfKWnJe7s/hhuw6kpoHtyxChgnaESxyG7ngI+KtYzrya9gJFzzP5xz8IDqnLKeukcmZFcfkh/Ph+PBmwqZT+HW5pZHhS4zQ++Cu7gkzpZBXhFhWhki1FWI5LMmDpORuyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paSmyk7o6XsX+aCqXGcuZtGqjxiA9Y/rhapD+j0iXlU=;
 b=YWTM9zsMdDubp8NJ9WppSsGa2HrXYm1RfGguJ/zPKKx3HrtEKMs2ai3ohveNWk7+XOiMKpiCF8ywOjM3zurA8KaOd8JO22QU1/9SyvIfTPuK3UFjPTAWSGlLe3URP4xJGs+M5nwrMTkyoKqy1ehYW6iZbbjEsOx6boFDEiMrmXI=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:13 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Date:   Tue,  3 Oct 2023 15:50:50 -0500
Message-Id: <20231003205054.84507-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0010.prod.exchangelabs.com (2603:10b6:5:296::15)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 5176d951-1f5a-457d-a7aa-08dbc4527b1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gX7Rq77QNQr8SIDQWeAbMJyjM+J1LWuABge/ecIEPGsplLNJzP6R7m/CA1WQ2RVmV83I7lEj2S/ulYyV8SyptsUbug/Y7ktVBqsCnS0lZAZ1GQWeUPuFMEMZfRjvqhVi7iCkN2AlnhnWiTZhAPK92HCrWjNoM9jEk5IcvsdFqVzRhV139ABEjjx3M3U6pQ/tch9Pp5qitTZsPxBeNvR0L41/4QEdb7/IKQ3vP63RzhHuMFBO11o2JBB4BKPbPJJK7/FpBxv7pvBSYDQIh4L2oVO+hxb+BPq3cLJen/IA5vuQXLEcqI70BuylbrAhWX2BXXeCG5SkKk78McT45RByj/F2X5GpRCpn2GFriFvSoFLC32hAVK5qHhweiZwNWLduISKKCGMRlrjO4QKFm9PyYazGNstdSgkTSYhetTyoLfT0l+b3y7T3rYLmw/gCw6djBnRSNSWH8pINP1+2BLyCvGY+uTVh3cCkMBnsTlFm0Kxzm2J284eY6vIbmoQV2PfsXnTK7NtooP6bEr8P02hNrUuzZbBq31Fv0TWDM/lrws9UIGq2ZYnw3EnK4+J+EvqQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wswB9jSbeEpHM6l6Bevt4YqpseDMH4opljZekSfq0V7OAcpTQ9ZJchtNkTrN?=
 =?us-ascii?Q?0ZtaJDqLtyYWdHGPWz5F8tu5ji2t2uALaFiDMDq5V6OY+2eg7t9P9Z1CpN2P?=
 =?us-ascii?Q?HPIJLCbt2M8ynPCAPRm8ny3j/zz03hZsvIy6C64b8sv59WwGicV12dYTNy45?=
 =?us-ascii?Q?xt0PBBq7urZbN1JDQg23asugKr3Kl90iDivGBjMEa+ErEERioGqIPpcq5FPx?=
 =?us-ascii?Q?BzZINVcZmjpP7l4A79sYUPFd6xfO2B2ZON0SPw/vv5/kzvkNkSg+QDXfrMPr?=
 =?us-ascii?Q?A0LN0rmpGh7WqN9d4RQ1Cj1RPI9mkn2SpI2RSZBHZKvkg0hz+tHs9el1iv0J?=
 =?us-ascii?Q?IRlAt+/lYFyEqYR6qf26Ezjj6M6tnVykQI/0UIl8qgYYZwV/16aRdYuQZ3wg?=
 =?us-ascii?Q?ENFrHni80bnT+4ogh7sTsXUG7OTprOwBH6ogNCvxPHbSP7lEmcLVCafry5L3?=
 =?us-ascii?Q?VMwbwBDtQUYsA3cFmTMTZW4xlG91JxFVpOpMJjMYQdiIcEz7vybuWg12XPC8?=
 =?us-ascii?Q?MQ2mQxN0iM7mz32Oy7AR9C2gFnXnp54+3lsFr07UXpV4/oLFmRDzsETQDyhY?=
 =?us-ascii?Q?G6CmArTL3oEg0p+lbXvoi2HPBoTakRg8rhyo4+r+fBjLitonXKW4YAdbYN1f?=
 =?us-ascii?Q?vVxV9PwQPR7NV0O+sCiJJ9bT7qlLCtyEMJL6OEIMFSPiFC8nOvKxh6evHHz/?=
 =?us-ascii?Q?ntaeDospNLfB6WHCDOIsIq09umUX135q2l/e/ryG2cqdShTIwhrSgo1TIZxs?=
 =?us-ascii?Q?KreJXpMYEULksO4JhI4QsB+N6XAZ7Jmmq/eeCNKjgEgi+mke1UCOi3nZyOXB?=
 =?us-ascii?Q?/jc2zaiVUIYo3dxNr2RWwRx9/R6ZLFF25nWJidHwzZIW2OxBdYOH9cnFY7dL?=
 =?us-ascii?Q?WW9Y+vSVjdFCnp2Qv3u4JRKqfFIe9lIDibee8BgUPBUfp5vz5fSraSla/P82?=
 =?us-ascii?Q?Qjy0AFFyPh3IorwpQMO27QY/dCNAW+acycxOomkqQA1nDN0TycssUYpXtLdK?=
 =?us-ascii?Q?DFJyegOOrBxt6O5dfKBm6gxHI7aO9ylHvOpEgRWlRyw25afaQKZ/exRlweNj?=
 =?us-ascii?Q?YYOeHus2aI8Go2+WrAORpaFmBH+g6pKBM/5PGEJj6bm6RIWIKCmbb6tWujz3?=
 =?us-ascii?Q?ukJDtGQgz3ozHMjsq/zKFVmRrhGCMy6ZaEowQRf7DhgzTR0wT3Z6hEODeH5b?=
 =?us-ascii?Q?e19n5/bd8hFd9XZkPRpN+bGFn4i0DtsPYzhkMNMl+8G0L6j/jUsmsUDvdCpR?=
 =?us-ascii?Q?G9eiHydSu7aRAv8hu7lNx0+pxR3Q9rSIMjco7MkY0LDiIadn2ZPoS4iJUnP5?=
 =?us-ascii?Q?cq+TRu/fvtZ9PR213+JsMS68B+8M0scq/yi33Ulsx5FLT3JErZoyVzaMTGBP?=
 =?us-ascii?Q?FPwT5Xt7tKDsy48UgK45rH3lE2WeL8hsGcbXgRoRe86VHSjsH4KtmLitYq4u?=
 =?us-ascii?Q?/JLZhQT8bfK4JuNrh5rn5rlZml7pGcr/GyAtWQ7lhmjsIgxomQpQObXzvXgR?=
 =?us-ascii?Q?BzMdsGntAdQrueyD1hd6Jmu2UNVpAmP3RpObsaFLkCwxw5+bmLbsA1l0B2Xl?=
 =?us-ascii?Q?TmPP5ekTd0/rIaCMel9OQ1NFLp9zaPDbdj+Zu14lFA3/IxKkcyEE5Bb2vGbu?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ck+RwUWf1Tc42DgLDaIbxYh6iu6oOxMVYOUVYAmd6kV7owcW2V/VRyzZkUorH09Id/Hu+xKGIYTeCV2yKoX4M17flHDpWtzAKfTVaz9asT2kmV1QMF5U21wDGi93IZOLeqbmiuM7oZXVk65qZ6whq6hi25lfsJY0XerxmRMsOH5gRoW4m729GnSoo7fFQnzA5kjxn3wSI0Eh8WChMklcE6S9NZtDPNtmdESQXahTIpHxQhc4mpRHY7SzVzaXbSgE+YRBG7aIP/euOEpWIftTce/Ul4f9yzINmeds8DieAlv9G+jgLbhn6of438A7XBQfBNZwPFDKLQvMG3KLPCjb8gpx37/4ELuAiXqUwzQo8UUuXdrPPpw2bkRzxtopTw43DSicwTWrblpuaggaj26T1ZHT58GdcNDHpB/yFJ3J/8p3iA5w3WzMpPZEBPix0S9ovkEdQ9Jg0IcF0bilWqPU+T7tBcXp9PZhl60L8q/rgGUGy9usWFtUFyGNmhc9w8hxu8KXjadvXhPEGY5dzkX93OXoFFdDdyZtBjpIzhquqm7drL/sz+jVkOou/vRMuwT2pKaO+gkW9rosUeDzSlyzYDGxcAiZvp84HOCU+R4zh8sASroT2Gq79ERAAGI+sBz7TbaCLayxnt6Qxp5rB+cgsEajrz24FqPPvx6umAROru/O7nWNfMJU0ZnqPawg61gFDEuy6T34rAEENeWNC3iwn/uiR2ySh3ZrDmxeucxa17CAd45Cv9rHk+J+fnH3RPGTn74tALHOcetdiSH3NM2iBIYdPRNwRWdvGpNtMTxkTCk40hEwCT9IMYdepBIznfuqrJ+IJt1JBqy7PRLfseT3dspdRyMXcz4SkO9lXlqnU1RPPSEWSVw5tVLKvA8X34U3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5176d951-1f5a-457d-a7aa-08dbc4527b1e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:13.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F/9NfbBnU57qwNwl4RiVZZrw5GM5rrcCvaH7LZ5YO8H8ZB9uWNt5Q5i6feL9DuAFSKp4VUdKgTDiMD4iBAICrgP9Ual2eidXaVWqT1zEg9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310030158
X-Proofpoint-GUID: oKcpMxrTeoUL1UQjIj2PrZohN4oMF5TY
X-Proofpoint-ORIG-GUID: oKcpMxrTeoUL1UQjIj2PrZohN4oMF5TY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sshdr passed into scsi_execute_cmd is only initialized if
scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
good statuses like check conditions to -EIO. This has scsi_mode_sense
callers that were possibly accessing an uninitialized sshdrs to only
access it if we got -EIO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 75be368f3b5d..0dde64d55619 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2895,7 +2895,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 bad_sense:
-	if (scsi_sense_valid(&sshdr) &&
+	if (res == -EIO && scsi_sense_valid(&sshdr) &&
 	    sshdr.sense_key == ILLEGAL_REQUEST &&
 	    sshdr.asc == 0x24 && sshdr.ascq == 0x0)
 		/* Invalid field in CDB */
@@ -2943,7 +2943,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		sd_first_printk(KERN_WARNING, sdkp,
 			  "getting Control mode page failed, assume no ATO\n");
 
-		if (scsi_sense_valid(&sshdr))
+		if (res == -EIO && scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 
 		return;
-- 
2.34.1

