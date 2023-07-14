Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574EAEB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjGNVgv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjGNVgr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:36:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32CD358D
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:36:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4XJG019325;
        Fri, 14 Jul 2023 21:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=qbj/BrLOPWzCCtwFGk+xP7kMGwmlsSYqbLJY4eV+3oU=;
 b=xPTarPPtQdy7+dPuPSI1zyV4mplaTigLWHU8KBe0+00rD7dqO8DcCyQ+bE+P21ziQLiR
 peqLSjr4lTIuysUzyxrY3Nk4ZCA3IAlQ6t3SpjuIaEXARiIgkYNKVnDpKxzbhvsyCA+5
 YalZjM35sYgImf2gdMo/6TTDTNBTmJcFW4teKjtXVEqZ22RiwytQac/YC2/CDBHkKGj8
 6e0j9lbQQYvGpzJwLng+fhZcCE/C+u0+OCYd9mBSPGA4b6AUnMVATym2WzdHI/PsfO8X
 S0v2nbn2kJEhOl05dhuk2hgAaJmQz+PXJ0kquj8hZFAqL9WdvFkqrsIb1gYufZyI16Sm gA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtpttjfge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJxrJO023357;
        Fri, 14 Jul 2023 21:34:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvxsd20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:34:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OF7vOzz12Xfyoeg3OffAMZkXz3yUZhGCWAVePVL244iMiyAoAAljbuY8rT5/gXsNIUBxbzbw8V0z80nTDbSDQDIZFryeXPcFUAT4xVodaYs0lQNVjmg/n/arEmsMlaffHAWS6qmQQ8oz3hqi894MLSw0ogQXAlrPKhsqCSx5ifyWvbQ04sXvu5g89owMnhlbcA19d6SwKN2vJUGoEZ6KRHz6uwTOswQibPWPlHf/Bti5nKqbgrpTjTS3AhgTA4WTwKA0cfL5AI8VLoCnQ7uk5NqWBAYCcIOhdCMLuVPdV/cZQTTa0uYTHLfQKf3YjV7aYx3KVyytWxa+aoG/+hFCgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbj/BrLOPWzCCtwFGk+xP7kMGwmlsSYqbLJY4eV+3oU=;
 b=jYI81c0EVut14ieuQg/WXDy6LXyGssTW29HoIG7uY27ZVi07CUqDZmT3QQ6/tyTnOtnTtbBuVyzyrEz1b21pZpjfGMxj1A/2yEc6SaQntO6oOWVhjI86c4PvCLuu0MjUUPyZjZZ9FUsHgbelLNas37y1JrqO4pDYk6OfnSMrtjLvtCsfFKL8Khx5pVhRKk2Qm5GcrqMI5H9CBxyjWrwCnVqL3+Vl5SA+WjfKXzJGRKSAEzGL2eyyOhUVdTCS1ry/0JpyPCKytDV6/fiWtrfmFyw7lBIkVI/x8WjbezerCjvUk4nAeieoLJ7OIJS5m45E9/vbeJ+bkDnLMF8Y5dVw5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbj/BrLOPWzCCtwFGk+xP7kMGwmlsSYqbLJY4eV+3oU=;
 b=ibU0wmJvBif4X5hQlQf9WFgLrmJTadPAB7tQgLbA2E7FhSRzjSN+XlQ+oMWO4z1eiWQbETFZC4EEgQgObhKbeeqPMxPmFoX05az8oP2xKIB3tvuJDRbFNxVp1ctQnWIabqpHPzcCAk/hE88eWgfWuBeUuU6sr4qw+SK7bC+Rmq8=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY5PR10MB5962.namprd10.prod.outlook.com (2603:10b6:930:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:34:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:34:33 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 07/33] scsi: sd: Have scsi-ml retry read_capacity_16 errors
Date:   Fri, 14 Jul 2023 16:33:53 -0500
Message-Id: <20230714213419.95492-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0150.namprd03.prod.outlook.com
 (2603:10b6:5:3b4::35) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY5PR10MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: d8a82952-ac4e-4299-d881-08db84b21d58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: io1EUPG2mubEWgCCGi7apYYijPHcv7LbbfHbAVxddy6AvGkNrYxZy8PUggZNuasjSC+QlOOgh0RzAT8ka4LyZUl/Xsup+0vE0BDUYXhrqkFFCIw2pQBi1+w1/UT4sPjv5Ae0OhFUDYFLCApicCUkSTHraHugnfxyAWlSkyxYvZbicShEt5DhiptZCDxnoVDtDmuTrYs2gpSwgtk4eb8QOT9k8VDcaS9P/nsp9Y16NI393LbiXDoIje7NGrFXL6tpbrJ0YfIqR96zl3NqL1jBgBDegzKxht9FYlFidEKCtotXzdOLpc0cP3ep2J6C35fAybiSL5JZBrGK5OMnRCXQRgx7fhmZ+hNusqdL9797Q4V2qqDFqDkOQJcKTPvizxn0uzRYF/aup75bSHjULyBzVkvaKht27HLLK4XB+ynuXFVFqfBgIvWdhKolOF0IaqQ+n6nKPY0+Q78RxR2RqGs1WfkBgW0+K4SRf+2i8pLErB2obw5bR5CCXCJrAJNMCXXx8UqW4EJ1mC7BuLTlvjpC1XURU9NKlgqvsz/W0424VprBZZ8TtyCruiJ7GbC5/fps
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199021)(6512007)(36756003)(316002)(8676002)(8936002)(83380400001)(5660300002)(38100700002)(2616005)(41300700001)(66556008)(66946007)(478600001)(107886003)(4326008)(186003)(66476007)(2906002)(6666004)(86362001)(6486002)(26005)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kFTNAjjZfkGRBz0rhrxTThFBm3M6k/RRUSM3xj6DNWgmg07lxZguSOcNuL4n?=
 =?us-ascii?Q?NeoREynCvCBKw0Q6lRGXYOIztbaeg5MyJKijQjI+yPKfNNasQY3qH954s9KO?=
 =?us-ascii?Q?TSF5CXWkmF53Rp/wXnbzGqByQM3Zt0HCkFOVVzTAg+C5ic1fI3zqz1vAOwLL?=
 =?us-ascii?Q?sdOj5AYrphamR+v0AMXOHRsrwTCEORLvthROXWsvx2bnznMbvg3l2Fb7Ju+a?=
 =?us-ascii?Q?tEjepfaZdCpAdw5sbH/gH+FKKInRf03nBcrd/Co4h1/jGymN0yB4WbFdgOPH?=
 =?us-ascii?Q?wP4cHx45Li9Yxk1GzLojDyA7/BnarLqh+qTHZ3FAosLbSCIYLtS/eGbboRmw?=
 =?us-ascii?Q?vIU5/oyUWqmXzgWvQEDZuF8di5FO5Kohtnnz3ahrlaGj8BwUd+1/YySjnOSD?=
 =?us-ascii?Q?JIPXKR5SJT6ir/hGAx5o94g/Yf4kT8msug4jO9IIGXgu0VHk6JzRzwOIrBAI?=
 =?us-ascii?Q?GTvjhk0fLbvfyDB3v2zY4crHoq02Gj6Y5sb4zKh3J64iSIEpOO24Q2K5t/My?=
 =?us-ascii?Q?MQrYqtlb58zTjERHItNVIzjUfL7pU1ho9b7sLbx0UNbSJgY8+T8Ufv18Emjv?=
 =?us-ascii?Q?PV+8R5GwfwEygbWSY39lt6KG1+60v3ssfXXka6Luwrd9WDkLm9JJDRnUwfuD?=
 =?us-ascii?Q?ferE9FqJInih/wNQZvVylS1vQs/aSJBV7itFcVpkGa5zFfwqrvxyLzp3Z3jf?=
 =?us-ascii?Q?aQRY1ARY+Oq0aajoaC/C/T6HxWBbABfVmLF0B2ZJYAMOrDxUYJX/Xb/v2vFp?=
 =?us-ascii?Q?J9hc796/Qa4K75Xqo++5wO70fLAoq/o/T+f8ItsUPy48idPliFIJ9SWgGCx5?=
 =?us-ascii?Q?trm7Yi68nQTm/aw4rgaLtvwHDw/xfKswdD6O/FgFpQdE9VVdzHwY0bd+LYK1?=
 =?us-ascii?Q?dBkKyUlfWmGBlfEe9CQjsIneJNWXcnco85xv3+VLcLTVm/30Pus08y2Dcu6O?=
 =?us-ascii?Q?IDWTmA1/98hmplLFHeEft2es/3Ey5trOGlb2A5Mo5NUbTFB9rujhNnpPvWCu?=
 =?us-ascii?Q?lWuu79nbIZua3y1EJj/sKEex+8noTbCMs01udX7pWhY/Sh0WVbnhb2w/b3u/?=
 =?us-ascii?Q?bY3PORxRF4JC1lFpBMXOpWxmXpKvo5Lfmqd9N5bH/vXvQG9idMw1m0HvIe07?=
 =?us-ascii?Q?D1EfTeSOpIWAclbyMsL+MsDfY7NwQXt1z4kReVYfhUzBNiqUVtJ9N3wuIWWq?=
 =?us-ascii?Q?PyV1VMiYKDHENzmzRUN4ZJdEVRiXHGJGoicifW5bWnNajDIKt4F9ugexqtEB?=
 =?us-ascii?Q?UEMNCS25OhHHUmS9qP5vJQItmDGU32qnC8ms+ggaEMp2UscyWw/qhRODhNMJ?=
 =?us-ascii?Q?TknW3oo0dlXf7mhKs5FQGrx0O6vRPbg77qYg7d1kZ3RebKDW0GB+IZ1YLna8?=
 =?us-ascii?Q?2oGC37HZnMcs9O8EYpFliWfNWLZ9BDTZYcF9yfu4tccy/d9Nk/oBZe9Rm3VM?=
 =?us-ascii?Q?4EVHbAlP344iU99fesx1oVciyiGYlx0z68G0hdwtEcAIuRWMhBNHyyUbOA9m?=
 =?us-ascii?Q?JJT46gmFPYoFpHIWQaglpew6voyGO+1m1jyqk7sIOoo7CPYFkSORiM0DTQU9?=
 =?us-ascii?Q?fvDH2h+3aVOqxE468MF9jNG+Tf6oxtUheI4Q59FA511TuZBjrwU/ahPsM+6k?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6znppTcVT3OBcL/To5enBJO5eyUf0xXia4xoM1f21nOZPZvUsOlXSGb+StEBY5Y8/rJWmcM9HSOMKJWh06iruBq+bGv63q6zwqXI0oLDWB5DzTcQTDbykWVXZ5wtv+1CRoK8KegdoQoWNSPOHgdyiiZ7QMW9j10tud0HsueT6zLC24hhzO9k8RAnv9lKeP/zJd7uKwDoi3ThgbWbwdT5YoehhLz+o2R5vrri7jCh72GLJfH+OpZ1swxILxVaFoHfl4vn447/MV8iR6uvmhuXdMiF6xWuCObWOIPiQhd5bjMekzhInKTw8dHtLsCgVzd8NT64mAC6avKvgZVVSCBk6HPnirA80cX68wBe5Wcp1W89AV/4BN7IFh2FvcpuY3Koy+jkHQFuf1sVPD30PBMLBwo3lgp7+ioQzxU9AFzeY5sgcnYxcFNvaRqHAGBlIBAICdu6wYp7UxPavvKbywdAtQd9rlmcw09DU3KfHTjyklvU+5uina3V6sz74fNIoXglUCjZiltHJcAN57VapofXBtXZB2JgdovLus7F1PSLiY4nWKvSEjSqG4FLatqbDiKkkNyoA3S9pFt4qthfG3V1afQF8283UI3rA/egZnsDy1Lz7PSEwrgETiV/dpW2ckPAt41yKSZL1m2fhHPlBCo6dMLsXRiggOKHu6stlsAMebdCwVGpN8O/y/+AdZbcGeul+mpCnuEisyLVr7oi3zXutlVZ+U0iqyaOOVqWn82EnXB8R+Qo8TZv/rR7jtfs/noLWVNAfFZoskbw9dzRZ5A/08yu9kHtvwHcRfNGBxQpYQnrQjzRJwny1UYe9kRrhLMB8Vq3S2ZJW8p7dzCJxAUnm/6pDRy3C8ZTVc4r8GbRxANjy7Qcug1/MKpapZDjjQY9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a82952-ac4e-4299-d881-08db84b21d58
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:34:33.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhxF6MbvWZpf3yrJyLodn86iHUF+ynvbKigU8B/Adjaj8cfmEGl4d/y21QprLahZ9/+G9ZB/HkjZKCt87TF+I9sSJwifEhBJpygpMa1Iu0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 57lSPtKU-Mu367TIeG4yw5MOhf0qhUlU
X-Proofpoint-GUID: 57lSPtKU-Mu367TIeG4yw5MOhf0qhUlU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

There are 2 behavior changes with this patch:
1. There is one behavior change where we no longer retry when
scsi_execute_cmd returns < 0, but we should be ok. We don't need to retry
for failures like the queue being removed, and for the case where there
are no tags/reqs since the block layer waits/retries for us. For possible
memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
retrying will probably not help.
2. For the specific UAs we checked for and retried, we would get
READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were left
from the loop's retries. Each UA now gets READ_CAPACITY_RETRIES_ON_RESET
reties, and the other errors (not including medium not present) get up
to 3 retries.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 106 ++++++++++++++++++++++++++++++----------------
 1 file changed, 69 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 755b09beff2a..245419fe9358 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2402,55 +2402,87 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
-	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
-	};
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		/*
+		 * Fail immediately for Invalid Command Operation Code or
+		 * Invalid Field in CDB.
+		 */
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x20,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x24,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail immediately for Medium Not Present */
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3A,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x3A,
+			.ascq = 0x0,
+			.allowed = 0,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Any other error not listed above retry */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = 3,
+		},
+		{}
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = failures,
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
-					      buffer, RC16_LEN, SD_TIMEOUT,
-					      sdkp->max_retries, &exec_args);
-		if (the_result > 0) {
-			if (media_not_present(sdkp, &sshdr))
-				return -ENODEV;
+	memset(buffer, 0, RC16_LEN);
 
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN, buffer,
+				      RC16_LEN, SD_TIMEOUT, sdkp->max_retries,
+				      &exec_args);
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		if (media_not_present(sdkp, &sshdr))
+			return -ENODEV;
+
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.34.1

