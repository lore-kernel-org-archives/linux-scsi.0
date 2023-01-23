Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729A9C25B50
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjAWWOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjAWWNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:13:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC70039CF5
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:13:23 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLi0Ic011292;
        Mon, 23 Jan 2023 22:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=dyKvGgN7XaD8emmd8NmO5vbJehdd/Fg4MXNwU8HQE9E=;
 b=yykNUUpH+ve7y7OCt2DFkd1ijlwb6AsgmcMQ9pXO0ivXeOeI7SWKIUeSO6Boi+u9C8Lv
 X7Mas1eHR5kVmGI4hmISyBZXvoen5/Bf+cihpcryngSFNaczEU703Fkgv8pc+13SrPKF
 Q8mgbZhqtZfODvgh6WaPpVoebpXnGGs4kGwCB8k80clxvTENLt4slbSmJrA0zYz0CXyx
 Yh8FduTJMhPqqC8GLhYGOa1YWsAy6vPooBsy72/rSsiMLo80pGqFGlBSddpbnkLuT4Nt
 /ZdrCu3B36XD9OqOTEMyx8RvZSqvgB34aWxVmHIqwmtk+1zgKcYE7/nAALA3Fjd9wFI6 uA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktuyjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NL0D0u001298;
        Mon, 23 Jan 2023 22:11:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gadtmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rr9FnDK66xexNQALC2hXEo/sfytHFVZtc9GU1FJARWwiMsK04y/ug3trpAZNEWj9I79MavvA4SaZDu4UYJiS7nuwcsRtZSRgg8U8M6YNThH08nJmX3tCHoYlKjrnjOCSCy0m/aLt3KemPbci93L2JqPhVh1coOxdqlpiPVVM5c8KS8vxGJ3mOlS6L7oUHVLLIrj2g80/nBZbrT97kwUO8aeJSzsuyw2WLcqMQ6xPA3ANuh7xICJz3uJNGNFfQ3e6zQw9XStZ2HgTO/L+aVyZ6n55toWScIB17odeF9s83KUestbawrQIVt8lOug2tqavvQ8fP+trRJV3hYhkXY7ATQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dyKvGgN7XaD8emmd8NmO5vbJehdd/Fg4MXNwU8HQE9E=;
 b=iu7SH8bDEHNXADmdrsVxXODt22m+ocz6Oo+1wM82trBr+rsCuI1LGKueGmkwKFdnOUPMGAWZ7yM5P9PvUKvVy11KX7nX2DdavRtno39MsVUosA28tBsiepV7fvFFtTlir1VYvk331XlP3r8nT0Ec8atNzF5PNdxhs0y4YYNBYO9ojAsGzpGwzqPj5IoYZTCKlBbsq3qa0ApDjhRXkQQJfd37Jk7lx7zvxpVWA6F2Zn7vjTbnHn+pNhsAHaN1lwdLCtKUpxX/hsC7XVM6lFRWfOUwh9i/GctWTCk4kfT1e8sRoFMFrWwLDym87IiqmedYNDrxJ0rijsyl1NGixmngyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyKvGgN7XaD8emmd8NmO5vbJehdd/Fg4MXNwU8HQE9E=;
 b=PVwR5LqQz0pEP41h3oJuq97EZEDvPHFDqHbHjftUXvUqpDeC28+IF8ULeZfrwCx4aLHNT8caLHqsEOeZaGFOcv24VRSCqKlGYwIPKi9KSlbSyij90VeK8iygwSyVbRDtsIINdi3yN31pKmoDhFkljZjcRmSBjG33ftmvTf26WCk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:04 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 09/22] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Mon, 23 Jan 2023 16:10:33 -0600
Message-Id: <20230123221046.125483-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0128.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d617ca5-a987-4b57-fe4e-08dafd8eb809
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aaLRqdOi2cPNLB29c/WjSD60p7MubhEqPNnke9DNijXIX2BfzrZh4FOOjno+9ji7+xTelcsMQUYymr4UA+yWJRmW87EHHTYSTcsnKxhqQKx5pg3Zf8f93Grw5XdaWDT4g84A9lamtxjiYLvQ9IGl9hjq+MNZxqdqjIwmyLmG45i/QhAVA3CqrCiMKS9y83SYo7Vh6Id4GZt+ANq0LaoJye44ngk2qxkHv/poxQjmUxagM+A6hPvpYDMXGS8cAEKLnFA9Z6FEMlWQL4ik0lZFfJIlnSVBnj85HYRaOrDGJHZbhX4b1PFvURFYiXWzCOgdFTk7R2yYWjfhzhoL/RKqBY9b6Rq/2o+63YazLmwPYlNq8w/tfnMD1Blt39+ACsAWWqO0sgoCFQl9GMIxxBPt+pIVnSzcmDk5iiybFnFVSJHT02LbOgF1oPZVVfQFhE7HxKZQKV+VAtDy8N4qBNtKInHaS1H4He+ACQiOCovwCi6KPUGU7Vbv0d0al328zyzNWQwiC6rsqmv8JMtqOu4DyJS/NzxwPuJ63lym8WA3gr+mVsCHkOwlUYBJHgxiqbMRfFS0pVBQCQOkE/Gkn5SAX5r9z/Joc55JN5L4qB6gsS2+6rwrgaXAntKAM2Dy8R9r81prOPUCoJtyBF1z8+/UA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pUn3c8QGnw48V+oAEh5kN7szhCAopHUT+RcAsXbK2SphJ/Sljk6HwS7Bi0zr?=
 =?us-ascii?Q?T4e9krDx2F5w4hCQut8H0viTjSOrTs4JoVm/+O2VKJZJORjngk1RqmGM6r7v?=
 =?us-ascii?Q?5T2OtsIURR8RgMXGw97B7omXOlHKB+11UQ08KEhKvCTdE1UH8vPVJ+5BV66a?=
 =?us-ascii?Q?DK7mBaq7BX4f1+lSul//b4aSVzVFOa30k6bMeLR49lIGxH0OP+2JAoB/xJZ9?=
 =?us-ascii?Q?KsjxMqJHrM7ZEAbVV0WnTUIkwCe+00QRT0fRgkav0VikPcKCANAMUNpFDzZu?=
 =?us-ascii?Q?+OCx8iGasup0JkRWX1awg0OnisYYwnWwWlMb4KYqmnIZ0mG+E/3AGBdWHnNE?=
 =?us-ascii?Q?z14HZR9YY+ZY8Szuy92Aqj4P5TkbvEqJRMTubCnZGkxF2uTy38M57x1iR+Zu?=
 =?us-ascii?Q?7/dzKhwmPuBRFtCzVC62311a3ankX+Q/zqPQFFo41/PHKDqb5a5O5O3uNdUL?=
 =?us-ascii?Q?DQeYLyY0U420hay/Bto8lyYLPIXggY1Gg7/AvgbSW6pc+uud6HwWc/IDjTjW?=
 =?us-ascii?Q?zcQ7QhUAQni2X63GbGZZEFdVI85YPWbzDvuRRPfdTYnyDmElDMKfCI4S8j5Y?=
 =?us-ascii?Q?KiPJBB8FueYyVFE2nVUBgmz+Ew+0NGDud7V7ocvG/3bqwD3JtFAUzokfG281?=
 =?us-ascii?Q?K2QA0oNEFDOjn45ArFoD9Tocmqsr2avfoJ6Tn7ZtMdQtiqzALlX0XLzN5e68?=
 =?us-ascii?Q?glqUuxgwq8faVuUNsHjkDibKYd12kbHaC3Lmz3fDRP6bR0bNa916CCrdG9pK?=
 =?us-ascii?Q?Bv4DlPuIkrTrFXoLAAPc1ax+K2BUTyGz1BPVRtqwvOMRH8bUEHqkzmbKGy5+?=
 =?us-ascii?Q?lsexkB69yHSspr03g8VMzRZkaagKbL6/g8eVygeH1+NAJaBt2QE/lJV7ltSn?=
 =?us-ascii?Q?q4XMaOLx8a48CZnNukkfeGXT7DHqjadRab0CGUP0g2R5kBISQVaQPp8vJc3U?=
 =?us-ascii?Q?pSbQz14kTE8xIvot8IxU889+ED/dzH2JdhETqv57o2tJn5juJl1OtGty/FA2?=
 =?us-ascii?Q?eyRuQ3xFb4dLhHyL52tV6j6AxIR288gUAveomGUwg0ILIyBYMu0Xh6g1LvY1?=
 =?us-ascii?Q?yzKl2M26uzkUHJc6vnQ51dpMZLaR5XlaeZFJ7imWkXOue5tHuM2D/tCZdPQh?=
 =?us-ascii?Q?mpquxd1i3K3LA43UWhxr+whumdvOBIyBSvDFemYrm4KD60GpuBezZgXLALP7?=
 =?us-ascii?Q?4h5ibP7p7wshSsWyzJ85rUuoLn7GjN3ra7KH62ogyRHMno4VeY+YguWCareD?=
 =?us-ascii?Q?da1Q4IXEQv2/6Q5WfpYUp9+YAWeFT76wLdB35j/mbrl4mkciUVhyyavwOIg/?=
 =?us-ascii?Q?2z7JpV4vCuc4EnDqxYin+yCQ71YVHSzFZP7p5T7a53QcnT+ZLRM97TaEtMxC?=
 =?us-ascii?Q?GnIWCMZ56DgRs/7JayA+qTXwJZbtzF6/4vzxHqEUssocMOo3k3cErJSY44Tz?=
 =?us-ascii?Q?rZSc7KRc/KWDQcEx4OpKp8tfVl3opTr2oEHWeSYkAnpz8Ys6A4Vi5E6EOh+a?=
 =?us-ascii?Q?ZefB00h+gA81fd8qZrQfzARpu1L1P/p7MV9tOqROCBpl8fc6NrVCDxaR/SPd?=
 =?us-ascii?Q?zWMKoBp6X0YVazHnPwGQHLbm/fQgtNNieNizYYOlxOwVL1eTNW1z34Xohr2l?=
 =?us-ascii?Q?AQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yMKAfhvAHZq0XfUsXp2pV1NTEX6C4B+pnlRrQQ2v4VCV1L9Owl0JKXcChRU6lG4IYwnNwcPkKz+V/7YeRR5SGY8bas6gMdjBsOD6/56OSX7Otyh2+kYYUgjhSaLSq8TNiGl49ZR6PnXmdD4NgfcT1kwJe5tnjjF7nqjOOZZosuWJdhZ9ERHdV77FRS22Qgo4bjsy6n1VZ3PEB1sDo76V81ck/pNQSDqlD6Lvy5gGNC2S3iN3BwaHsQEJCtZp7pN024R6CFrDpFrOG3gaF7u5PKEkDyXUlpBmp/0cpuZel5gtHPEZUdXu64OV1Tc0huFWIbJevxCPzDlONvghY5vyePDVPez2e3Acg4q6gnJXifFe6HVJsV1ynPBpRdFjaCQy4fPuxnohXa2BQv1HaRij+caExKiJ6yWwby7HIEOn84DQhnu9lv9/eMrVP8ueIBbuZHglnamCsPRsOXne5/Fj6D+srK53pZY7Lvo+vHkFTVdPwGN7zMTlVa6PVG7/CuexTMvHOFYZuJpRTJL1ruysFh8AxQa9feNWGwp13PcdHz22+OiGh1epzWxo36bH/Wbqj47UUaSjxsxu+dhZc2/CgecN0umCYICisQ+ZU/dkp3kZkKVVFqePwv24x13A7a6UwigEz/JGSVH5KFfYn+fSZsatE8WMVcG5oaAUTEuAMaHGHj5JIQBogQWHhCoGDdpEJmWyU50WBhUPADKQlXLAwhVsJjuTBSeCtrpAxLrI4J9FPuh1NzaU4cTVfbX3xoI+ZkGqL8lWrPRAH8L0J6C+uNyipNf3Ieu405fErZcbD5N9pMFivVqapo7GEUFoHulohGy+RDa1q+DTKNfLWAJqbbgP9g30BYarw9O/dITu5rXzVPZ560v3SZGhBcD0g0Ga
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d617ca5-a987-4b57-fe4e-08dafd8eb809
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:04.2598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ET70fybRfsLNVbMUusWZJDoi2qFBUDJYWm4w/U6XKC6A8yTAcYUAUSQ80ZmE6GjX9V/1CmH+hX2qJnFyIs5QCsIW+hFLxHrsRiUKLu0vnvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: FNgDEbaWLyKEr3jc5c0pGHTtB4WrE0PQ
X-Proofpoint-ORIG-GUID: FNgDEbaWLyKEr3jc5c0pGHTtB4WrE0PQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 42 +++++++++++++--------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 5f2f943d926c..6789ccfbf4f7 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,11 +82,21 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
@@ -105,8 +112,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -123,14 +128,28 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t opf = REQ_OP_DRV_IN | REQ_FAILFAST_DEV |
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-retry:
 	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
 			       HP_SW_RETRIES, &exec_args);
 	if (res) {
@@ -143,13 +162,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.25.1

