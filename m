Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0872C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJWDGd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJWDG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D916263842
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2tKAm015631;
        Sun, 23 Oct 2022 03:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=mMZ4w6RmXl56pZO9uQeLFLKCzbklk3LGx7X/WGAy4Ne+q+nfqbvL5QZ64ynchbOqhL3P
 XLj804t6vhWfCNsdMDhx2StGQwsf2gzY+meNAs+nxazUkNGjZIaMNs96wvd27xG3hKl7
 usZbA6iMkw0wPWuygk2I5FZ8a3F3yE1NgoyQjOGoTj33GG2HzmsCQa3OicfB9TpPTpL0
 e883r5vD7owvaKm1SjjTzYgNYdSfULktTACgIX++HreKWiG9jBvueexMVgrJHbNjhSbc
 ew0UDKUR0R4C8ygCIAEEUMlXJwqYqnmwVJcN5LYEOfP54MrO5UgD6RzZWpVK6z9C/4UQ 9A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKGd2a016377;
        Sun, 23 Oct 2022 03:04:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y90n9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0/EMrKy7yHNfryj3UkSAjkSbpIfIzkq6YqTbjpHCSoWhrfM/1ErZZGZHg/j5P+hHLp8eNXvBT8mfnbW1M5OSbbZnejX8TgJIA61ltp6P4r4EAQrF58+agRZiMfKwqvovZqaXZJGwOSazkiF6W+uDWvHjH/T1JWX9uNrsvl0cmOYeMpa8hlwXnDy6V/DRpd/q/feoCBcZGpQIauGJj3yCa+yduaPyxx7R2tmBp7EmWMiQGjrmPPUPSVyqvj8RNdRDs1I4PWJUDkR7qVIt093JtJb4MGPvKdp0oeV2CX0CVz6bMgV6nGhDOY10E6PB0cONI7yTDmKaITYEfJrAo7fwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=EBYrwkLoT+PqcYgwXkJ4CfJWFSvXin13exj3lUATBO71ZDwkodS8v2IzPtMj7RDmEwi+xR0Adbraj0Qv0pnZbpplCgCPcPjRMKKhH0myQmG1oQQlIDVxuJjyIDO1cBHPQ231H2WURfZgjxLAn6263TF+pSnrmNvlI4mJVhOZcNbTDEfJosEc/lMIdrYoiyWe71pYdK/JasS4ruPengcD3N7DzPxKapeBhBIemTP8ohL/HEcRd6A5YFdWFe7oREJSjGzX+d5timuZBlM7oclXvncMKc/aQI3mL8VyiWbu+rrwRYi4WnAMFrlqHuXmdJKDB+DiShCIdxLG73ngkRhe8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=MvMPlcYylFBEqGuZF6JLtlWweGu6ZcJo0+6ghQrFZZlQmZY8exYxBULupgf0xaaOcJRGoUmZoG3Xh9mFZtQzMVIE4FT6HUNYvBofwAkAX9Y3mjsTa9zL7ZePt1m5P0ajjMT+j9xxVWJT1UnGS1BlYWlwRvys027W1TWhz97qSVY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.21; Sun, 23 Oct 2022 03:04:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 07/35] scsi: ch: Convert to scsi_exec_req
Date:   Sat, 22 Oct 2022 22:03:35 -0500
Message-Id: <20221023030403.33845-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0028.namprd15.prod.outlook.com
 (2603:10b6:610:51::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 4954361f-f71c-4bbe-4821-08dab4a34613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MmdiHU2gpQfrjpK0P0DvSK+ebva4w5A83LJLRSw9PZMhGmiyRIPVKEVeqiJibaIhWR0p64FiZA9Y7EywJYU8XZ4FxCQsJXTOiejV7kY7kitJDDET6cbM7odipcp4nLVv95UmDDTjNYJfsZ0Zkz4QTqTMjr7t1Fx9jaVS6P4q6Wq9B1eLSQk3QiRNyxOtj0hdx7KJPzNPVkElDtsICT0PziiqrbthwaNLhvKzkk0E/ZyPtBEsQQInUXfaH9W5wiikh7+sQE3JfcpeEp6wcCYJunWl+9aUAWwMScgZsi/15FNK7kRtkWAT7e89OaSN3bET1W2u5I0+C58tiES8+qKrEVlRMUEGz8CIRveGdQbt0VHYG4glf4lA/GT20Yiak9+zXMvaHB9zjut/ukH5mjXpnp8/XrjpE8AUwLC/aLCM6WfbvVifhoHY2R19YPNl2UkdvgQSvSOaoF+I9KbHVaKyHVSxcxKzFocXiVie8Ap6F/TXknGe8uRaJSorVxoH/aWyZET4xq2gRmuB7Hwhemj0u2Apebb03b2b8o/Gk14YOv8LXYxSx602ZpuANIH/ozbZbfBvV6rkNh9ROrJijH9n7sdMlaqc8Vo5oH9W99uBCkKMIZbF8vi1dLQcRcDllmvK5bzmklhBEHU+7SBYfVv7/pElT1vI6Q3j5itd7cdG+XPqyzKGevQ3horOx+qmutzNgVH6NrZisqrIaEqzC9XDHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199015)(478600001)(8676002)(4326008)(36756003)(186003)(1076003)(66476007)(66556008)(86362001)(66946007)(38100700002)(41300700001)(6486002)(83380400001)(2906002)(6506007)(26005)(107886003)(2616005)(316002)(6512007)(6666004)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6f/2dBuQXipQry4FcoYuz7bdTLdlj9WutLnkXHuASPVppC4ThHrTYy0GZ5s?=
 =?us-ascii?Q?PhY5hV39PneLovznzeyT8lCmfPrxo6uZFW1JksbTKpB7DHvzJLqC6/Gag01p?=
 =?us-ascii?Q?XVF1hwwqjNiYu9l7orNKgtRFFG01awgrkQ9KOyrCsqpafqUCupfUucqEQDgG?=
 =?us-ascii?Q?j/NxLszhADbK19W7NnrqivNoNNYs1NU3B7Gxy771uAoI4VKRZuO5TiUiwMPh?=
 =?us-ascii?Q?RK63GMehES1HSLXnUF/qZbABvUZvoYkTHtfm6Jd/1F0YAk5mDpttnShuoeRz?=
 =?us-ascii?Q?J63JkxFCETsNgj+cXsee2+Mh2sZwg9+4kMWlnGmRjfGgMosWHLecGakA3IAq?=
 =?us-ascii?Q?8f9Ce5l6EK3dMKOwTwpDeL3aR+d7CvsB+evjhCZdECDVkVObJbW3NAs5iQCl?=
 =?us-ascii?Q?nP0jBjyTOxuscDn4YRJ3DGSMwZbR0SK5uwqrIf6xvlt2hUfhSi0aPZelOHnA?=
 =?us-ascii?Q?oodHT/W5V6v+2ZU54gGz7j8rxu6WvHJIuSkr6+kCRppGSF3IbXk42t2CoN7o?=
 =?us-ascii?Q?Q7J7y0/tF89vgUgx7EQ8TV1xAwjiEorgIadONSc8Tzks3x/NPMbPyNg5/3DS?=
 =?us-ascii?Q?Z8V0AH2ZHgF0VT0hqE+ubvrhom8ULKaI9o78GvoO4m8CU0YL6Pz/Y0PZJ+X2?=
 =?us-ascii?Q?nYm+mh+oN4690J9Z4e4ie11yvPHjEVdHdurmIkhgGMkWhbHKEF9fv2HYfpID?=
 =?us-ascii?Q?XGIWXCYbLEjpvEM7o83q7NQ13dJKrXB7TM4lZ14sRtlKB7LgQNMZ2BfOdZxD?=
 =?us-ascii?Q?QFyuT3aNqgrwyXPBjuNMoymlCg6wdpmLjMPIovAH2qa9vMNgAHZitSekYc4Q?=
 =?us-ascii?Q?LlktDNgmsdwH7d/o8OZ45das6jVb38kXGES3fsdval1XJaRxvFgZ4HzjghVA?=
 =?us-ascii?Q?E31l9nOn5lkphWyoSXm8UEn6JDRloLlEWuw0l6fXIm6CQh5m/YS6zD4ROMxH?=
 =?us-ascii?Q?5H+F5ks4d0+w7EU1UV1SIwYm2cdZVstGiBFqWnKSWYhci7Kdz29q6nqQrc7E?=
 =?us-ascii?Q?j1ZGKa7e6+7Sh2QfZbNgPtBPYwg/Op1npqOPvMdET6AO7/KT1OL6Wn6Ji1dJ?=
 =?us-ascii?Q?lwPDlROrNjtQCGwBlrg6CUGH5mqFw/O2JmbaalsVpfMbVqI87Za1mECgle1q?=
 =?us-ascii?Q?SFrWuQOzHZzP4sGHLubWzkNlrwVHzZOXcbaK+vVoCr/3ySPwIEUsGNumCeEg?=
 =?us-ascii?Q?T44D7YnTY+gZerfGjjl47DKnLZ4a7hcoG65PNBjQA67ebJx+5iSR7u03lvgk?=
 =?us-ascii?Q?BIar65UMV0JljTuezQGFBpfKk0M5rsim/oNE8vKaz8H8x03Stvgt7GGsogVa?=
 =?us-ascii?Q?97vP1QVixIypzncK9O3jSQbX9MQfdd2nQADeJsvyJAKpwlDNSttIJwnyok9M?=
 =?us-ascii?Q?uKY0h/yud7nzQ0on4bR/6GDHaD31GGgnVv1zJcpWMeOPcxzTwxkaZKsb5nop?=
 =?us-ascii?Q?B2lS4Au6EcrVMy2OyqzohFVij74MjlA7hEnp8jwxrOV2aVCa9HvtK+MgyCfH?=
 =?us-ascii?Q?kbLE8LYzWyjsAss8HAlrraiMXbJl40JQgKq7NGkzy7Es0nDZMqJJof5REP+F?=
 =?us-ascii?Q?BiEMkc/ODm8VzxULIrqBrhp9GvWKFx48A40xZyyNxLJvUdUwcz6eczpDK9cY?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4954361f-f71c-4bbe-4821-08dab4a34613
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:17.5934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shqKzkWGGL3agbQ28x4wYLpIHYJv6l67N5iP5YRjtJXC2Mbw6LFi1qlTIhBAJGv3AC+boAAIsFBlseCnKqVkS/RV5bmdkUrS8Rc/wcVbqIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210230018
X-Proofpoint-GUID: eNNpqWPDBKIsMSuwUW_YC-cqTbu1hEhK
X-Proofpoint-ORIG-GUID: eNNpqWPDBKIsMSuwUW_YC-cqTbu1hEhK
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

