Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22423EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243368AbjFNHTa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbjFNHSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:18:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A601BD3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:18:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jsO9025325;
        Wed, 14 Jun 2023 07:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=w/c3h+o+2hEC1e8B/KzTC8Xi9FEmVKbs9/jf+qpkx4Y=;
 b=jVMWCsJKKMacvjtZEm1hRE9dK3FD7OkXUSZY6DJUKAPT/2HmIU+JEJynMQtLrEAimAOq
 rTmpA40NYJYUS1Omc26QKbwQWu71IOOpbuanVqKp/iy+4T9cSoR0g0PVsbECEtZgLeg0
 ECTW5SyddeSbLuslsNaLfr7Q/3srLnL1I807Ocp/YiMNv+v9xJGP5XLL6VHnLgfQnvfq
 eIL4jx3OWCG1P5/cvPYeyaIWFB82NF3EJkRCztlIekhnlwXnvvdHXLIIb3TGQARtgHPX
 DC0hXBr/gRBXhcMYFwcQtaYB/ASmHUG3S6KCLExUeTKE0KHMbrRC0ahXR9GDxs3YAL10 KA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7d6vph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E5JmbC009030;
        Wed, 14 Jun 2023 07:17:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm5ese4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDF3q3aC4/ATTzvKxImdbIbqgLHQqKxYaR8lYNAzgCAPkb8oH0h0DtjbDkLsR06p/9EKT1e5f/tzmjk8bAFn5J5MDLtEtlddTjo/TiZ1tOiv0OqHNJOXyLjpmg+X+vJU7ikCmm7zXJBa1mdUQiuoUXsgjlcf8IdEngNRvkGjZ4cQOqkNqFZn8ZCaWRz6i/15uC9fTaFtNLZ7AiK0GXJCZ/YVxtbyJWzTdSxvLXyifGYq4L6QRERFEA/qzu1ThqEt8OCimY/AvB0SbCnmTHMD6H0M2nT+M3o2VAd1jDhbXSz+lXmVVOVnelFCN+OePu92djyrAe9hCrDW9598dz0LgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/c3h+o+2hEC1e8B/KzTC8Xi9FEmVKbs9/jf+qpkx4Y=;
 b=iICnBGdnegfY7ufWFGGA58kh0GHxHl0d0K2HPUO4Y6gphv8+/fNKAITI8wlBRJBTj/xo+Opjd2BwyzAIwn7cZdCaGH8wys0OS8w6POPaYJv/dvGm8hC0myO1Rv9eQsvkYJ+7v0dZMhAg6Tf23uapkD+u+CT9EkG0uKo8R8XFGRWBNTiZU194LSh5fHhypB96oGL6r5lhwhB9qRwWXAywbJAXNo0wF9uqAwLSumITa6opvcPu8ecLVrD2rXTc7XSsTH2znc9bc4EiZbjVVzi6jyr1/kbmELIXXaU7NEIFlpMHabUfaFhoIBf889PdPDkZDBsC+duw4e5gLUPHKWIerQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/c3h+o+2hEC1e8B/KzTC8Xi9FEmVKbs9/jf+qpkx4Y=;
 b=qpjgVdyFTDJrE/om1YgN+gdHf5sDswRkItoIQs8InNuEcuYWN4OUXBCo0Y8Wue9TW1uIVRz452rKD1/LJ53gBxgR+Lwi59jrOmN2nf0ujqbrr6gyEZFmkTC0c8EZmlOaIa6FLcX7aD5LmG+H8gROsUsl7gUZMMd8UbUgM3n8Xbw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:43 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:43 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 12/33] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Wed, 14 Jun 2023 02:16:58 -0500
Message-Id: <20230614071719.6372-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0003.namprd17.prod.outlook.com
 (2603:10b6:8:191::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: cc91bee1-a652-4cb5-8084-08db6ca7720f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAE7gvPpqJffLSyjZ3XQfpbPjVycbXy6H0/Bxolt2yACOQ/BSpsz//d05Cy5m9vaSrJDA/UV3LbY4YcZaul/XEvCmWImIAPU7PHVDj2+6TOiC/6itMamrtEP+MBy1hkAD+/gqWi6dt9PCK4KzLnSw/GYhHguvTtKdqdVqFbf3dkB4VJ/xDNmoKrfv7zT+DRINTUNyF8YnV5PMBi/8/XTd/hleK80eneuoEnYSTwuOnoUc0uGwEhdk9mK3pPiFEHOha3nm5ylGsVVAn4/KzwuGZ7N9K2HCAs5yeTsgaMYfUtbzta+1Lso0bXOlnkXYIN5sQsz3AYMwi5kgtyH6P1uQrCs3jwTqixLJ/uO1iAPNt1acoDt+8UtEub6xcoxNXmU6OxCBiKr9M723GXNA6yrvhAnjSXeTpytzlY19wmE1wiimYea3HMyoD8VP5vmrgVCM1gbcYsRij2vJSiPEi6VIfmmqO0XWzPyAyB2cN89xrf1j3k0m1sCBO4LeXjumcmn84vVE1v6h1sB6Nos2zRU2LKtEENX+jJOozmmQAcW6rb7BLVVVjdwD65xCgike10D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LuDRH3KKDWE5i7h4BbjAEVUXyEGyEH0e7u5N3M9OY+cSFqR/StkN1W0f8GR+?=
 =?us-ascii?Q?KRueGSwCYQSvdmbzhEUbfTgr/Wm8D65+dRWNAE1bPpy59v3WsNA5qx8w26mg?=
 =?us-ascii?Q?V5t5Rx/971KzQ2oFO6OVZpCKlm/NCc8Z/2cETgAIfNgWBB2kZp/i8BZ2dPWx?=
 =?us-ascii?Q?8pp5gqPIwDj7v9Ph0a28xIJjDHOGDOHKbpoLRSXY2CAHr404CU5RRPuCH5yb?=
 =?us-ascii?Q?HQ1zkLsW2k61B5xqE29tTuDENCV7EWE6F7b6PdNdacsl8Bl/MYcV4tPUt3yt?=
 =?us-ascii?Q?9FyO05iepZ8OrLKxm/yYF1YzfwroGLTKEMme/fHR4CU29mxs+XG7eDrs53LV?=
 =?us-ascii?Q?9buCfaR7IF96qebJ6RAyM5riiWOzGN605KsUAA8ZIo5zSQjOc6UxQsyaj1lU?=
 =?us-ascii?Q?Ngtgu6vd9g3DqtevIxY7xl1ftfhvej7N/kspytDyDgH6VKJ16q4p9KfSh222?=
 =?us-ascii?Q?QfeWPbmlx3luVgzI7+CmSWNsTXvu++aojoFr6ZqVbzGkV3ERrsT5Ym2TruQw?=
 =?us-ascii?Q?kG8amPY4gcwF04Rdp2jZU85L3EeNv41P/3SPxPfWHk0LrCCzSvewOZtJdOX4?=
 =?us-ascii?Q?Fu6vhS9oGoztOyPTbFtnxV2W60m6mqq7g5jxk64Fi6QyoVMFZYvBFj7kvKkx?=
 =?us-ascii?Q?nezvZiz8447cQE9JZO27caud6l9CdNNJlGxH81sd4wx4Bv4xILWJv32D4pck?=
 =?us-ascii?Q?+t2KNIpkx6VUUvE3gy/GDMOsPIEhhYJhR5l8cVW8s/y0i+UZSsGG/FRCfvdd?=
 =?us-ascii?Q?28VSm9wJPssXavxV6CXC2TPU+CfrGX2bHk1qMxuv/5VvMl1j8z8s/BwnFsKq?=
 =?us-ascii?Q?mJndHokbGMWH0vlxG943EGatG0OudFj0r8Gj2BU/11stAh1omKLtpC16HzWG?=
 =?us-ascii?Q?mu+JsCPCEA86dDzeSe3VCVWOvamr6vMNBAWJHC4XmgxsIW9as4LKKZELlWKn?=
 =?us-ascii?Q?Z4wNnHNfaj9JhUBsEDtIaE/wDEmkJGzIVcGmfhR1s83b221FfKQU0wc8Yk1W?=
 =?us-ascii?Q?kxb1/EpPBbNpgyzrbfzdcv2W48pSy7biW4903E1hnEZ5ONH9l/hZCJze+TVX?=
 =?us-ascii?Q?1HLQGSNr6kESqRhrloJ2CzDPGUPES6FEwFkRpB0eud0oWXMd1CiHNdwIgbVj?=
 =?us-ascii?Q?2Cs6OPcVHuydEyI+nG5nzgCWUyHLG28TNaAZxfpXCo8a3CnrPngy8Im8lqGy?=
 =?us-ascii?Q?FFUeTi+ux3DzH6UUZvC5a3YUskr/xOI6+EqTluQt6H8NtGhpKHsY1c4Oce1J?=
 =?us-ascii?Q?WkpzFOXuTj6nRGdd4yNxP75k12ymmGV2WpmWtyqfKChUPO8Y93K82oI/Mxxr?=
 =?us-ascii?Q?U82HhEo2Cr3zYbgRjQv11HQzvWFen2KZatlF1uJKvJ0jN34taZ15yssCB1ax?=
 =?us-ascii?Q?SXDxmWu3MXLfL8Q3cBKSuqjZkZr+8w/CcCO6Z6hx3bKEW4KVEzZqo3iTdn1t?=
 =?us-ascii?Q?9qMphMtDS1aV+C/w3NFnKgmTjys3pmlcXl4peGJkegLir2Y3NfirCV+z/Et1?=
 =?us-ascii?Q?5ADnNPS1V+mKOhoRBaiJ9I1bu9lWA6QiEMSTssM/yMvovYtz8ulIl3UWrpjz?=
 =?us-ascii?Q?lW3WY5B4eW0T+og0V07eroJUcGzlnB/LkLzErhfbM59H/SMVGsQGzzJth1gk?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: F04PuBjbtRS5pmjHAdWl+q6mF/MeokmIBHatA09t4wxxydxpmFLBtndI2nJpiUgUrmfbWwiufqkgxJe8tKvjWCibyOV5Ft0v4UxdCwZdPCrW5hGNBekc98whoInvAY65m+PmX9uGAK/x5V5qR3j86CTvUZWPeeY7JfeVWagz3vMjd0h49wK/AVUTuHZH82Y5hIvgzr0LmZKexgRgZ9iBkMx57Q36w1azgWxpSlKBEugMPqABobiSc/ueUiq7A6m9oxfQ81t4m+KrR9OeNbwof/4/ucmzrgp20r/7kChcfPaQX8Xt2IE4sCi+vcB5CE55DAKWTPNItnjlLWMRvc7tIM+50G60lNC+kSjjee/NBnO0cp21hwBIVWt/1210NIzRdFyS93jyJ6SmWwCo21f2aJWZ3kr+gdcXKQPEbNOR6cAaXzxjSKUvXvzQB3qq8Bern5KgI33X0nxGYKoKqhRM1WSLf/p2Z3ouc/2nc6p47Tgcn1nmdLYWob07PpfFc5rTH6GPe2dzx0pz49ZPJP776++gnA96VpkMxy7akmN6FCe2cZOJqt27Rdkq1lwR64UFWq4qwzB10RGYEcu5Y2YMZHx4lsQgnT780s6sUj+52FeuaHopTXT1jYFTOSM7eQO0ohJhx3VNWjJ8eCzyM0f8azisinayZk0s3cOQqmmRADjlVJVISlCnKokg3CHg3KruTBRJ99XxcMG9mIPCrPZnoWLe+Qk/vAkM5COr0F8T4VTbH7+v4CZoSZMJ8Epe8Ff8yJwAHxlbaXYwKE1F8P3gixdegFlxwQHLoRiZWXEUBFdlH4b761hyyNCdXV90mcEe2uYrsSLuJQ7s616jdjCfY0uoxpinStAJG+z7yDgnvCj3IWs1q7NqsOGZ4OSeFUYA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc91bee1-a652-4cb5-8084-08db6ca7720f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:43.3249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouv9OxUbfXY9/8f/jdvnG8XtE49bgpF+Oaf5UNt3o/DtRzepWk86kAm5g4Kmc3Ek721V5g6rX3ZeVjzmBTM3mKE6W2R4pw8Zdxyn0CWiY8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-ORIG-GUID: PLcdpIu3RZ1RLV-auNq8QCSO4rshfbf1
X-Proofpoint-GUID: PLcdpIu3RZ1RLV-auNq8QCSO4rshfbf1
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
index 785ab2c5391f..63d146f933d7 100644
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

