Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B0DC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJPUAs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiJPUAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8722A262
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ20v0011562;
        Sun, 16 Oct 2022 20:00:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=QytqGE0eYqWSpPxGaYiAsQ2Y0ZK5Wp2/spXXV09H4/WXNXwiaJvE82FtAlkCSnI8XjQQ
 raNU+LelcL7QIWYvteXZ2Nep6gU+Lo8nt2WbD8rcMfNXEwfq/y0WDNSrjXdOooaD/UzZ
 rAKFWANfg4RRwduRqdAeyQgwbjkb4B5mbvpDSTe426/FujvPByBbWs9eWhqoO9qvBtZ/
 06KJxIZdFzjR+giHmu/Og7+3/nkKv8/YcZyQTiyDgwhNyTXJJ4yLrUumm/ynF1nnrObL
 kkLjMYoJy1ihGBLzY31tFd8j8yVw85+eqldgtY8yU1VeTOrdT3MfH0wOyVRKGqCsrws0 jg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39yde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAueT001247;
        Sun, 16 Oct 2022 20:00:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2042.outbound.protection.outlook.com [104.47.56.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJivdTFmX0zWVkeA2MYfZKi5DEUBviMiEgDCWLJAXEWnfnxth7BFGiNIx3mJnIwwljKPba7VoIq8AERHJL+3JF/2KtJ06WjbBmLm3dPfa75Vd5deQwwBuysGnNvWZQKqhgnyRlLqSXbr3eIBuD9EvMuORwq379A4822olReGHVXq2dAXXazNkacOWPR594hZA2IEdlSuLH/EIDkp9kX5z2g9irPq72ExrrdPwPyoezhL3ack6re7uMAv6aMw/SUMSF1RQZrXKWXoaF0cGZGfwVaO5ijTo13th7XrLizG7+9rMgADfiMCjdL5UiRdw6wPRcFa2m8uT1nVyHfX4Uzwaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=hCEYtyVqNiIXnQMtXHUuU+TAoh4vVNd6gK7JlqKaa0wa7zKs0BciOIIIS8L0KAF+dP98orrr2029WCHyhvabDx76DaDVcAHU2vHXVBM9sSJFP0UC2ZehlXI6NXSd4NvMGnKmw4KQkZDOlEt/kUtQ5o6i52j2nuINZe9EVEvTtMQup119DMK8gqUf5WgU8hVsiRkcu8aIF5cTomNRp1KAs3BesrLDGgbLtb2ebPQlrEehIGtznvl6r1mHOLwrRapmzkNbL57aGkmvnEgy5JrD8ZoX2+wcpQgCmpdawDDuRt5dgLJK6ucHiznouM844W37xB0p3Zfet8NJrzhhPXt5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ShUH1Cm9IjgWLwMtUP3eOv3O3dA79ysgx5YeWTHX1Q=;
 b=N94ceMloZtqFk9lpiE2AUuW9OcsDlJzpoz8LHTX9pigF/Qm7Y2RD/xikqyRcIlsbQpEIeP3gF6Ei4c3vOlL+SvZOCAuyldy2j8Fi7SYiRzRlPpM+1lxUF+XdcSAmYIUl9tkGD1rzS3EOHo3lcfudlf+VAC3C8wZrYvxysg1OJ/Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:08 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 12/36] scsi: zbc: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:22 -0500
Message-Id: <20221016195946.7613-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:610:e4::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: d5a226d2-5479-4c02-49e5-08daafb1068d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8HH4XXUz26FTiTvLBq6eTZyHBMbx0jHeVanGix5GcOzvm/271ETMLKtI+1PgISZcQ9rbOCuUfVUY5YfVDd5XwtF/oTtWSG2fFxqlb9bvtVHPiIZ8IGcHancfm4gurXQ56o74AovJWYOeb3NG1pufaIsxpcy9/gfSoXig6UXvMzcbOiZ5ABXXt3zE7yx9uCOfuQaIMaMm1hbusXho6ZamBrwfKCR8r9KuahPdgXDX5sbGMWV8IUA4hm64nG0zRjezFTNMSRnrchcSqD0wH5Tqh2+JKdSMqTESF9qA4I2FY+PIhJYFBMpgCs3nX48G/xTF68oYZblYoe1pPTqiyl3zFfs/kqW9d3r3HcStpTRV3Vy3jNG5yTmJT02mM7HPklLWfxX2fqDxHuA/hljxQvhVHOVT5nIbpOintL2McuHfry6kkKVkg7zyYws0Q+EMXnH1FK4CLYfoMZfazVtOnGWfqOv41aUgKF7JhaMIUhsg/LQbYuzjGv8hFxoz82m87KASXgbRwAk4meitqrmt8jHO+VWkOu34sSfdDKQBwtYS6/fbuMLAtEI5KatfXCw9ORC9mF2aB1eda84qzdUk0ZKhV7TAcukqWdtPnedAlxJpvpOUTR6cHm6mGULKb1AjgTG2TRqxxE/UKbD5iTNt6rfGBolkCBLUEYZuStJm172zWRm0XLavH2/t0T0JpSUxt9CH1tkHVMuZNC6PksWOf2ekg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LO4QLAVvnVOu+xvfEfKkum/uE9bJztVBKcoe6xsHhDRrqVNUs5f0wEDRTNsD?=
 =?us-ascii?Q?ME4/QXjz3SWVgo2lELYVqGfl+kIolYyczrurn/oy/QvOFECkVa/KQGCLWP8s?=
 =?us-ascii?Q?5Gx5vGENvXgNjMHdRqlhwKVA3/SV8snd78bscXdP4cNuT8T3EZzNInFBK3bi?=
 =?us-ascii?Q?Bf23PbuqJjfqMseM17BKUfsJcMMyi3t1hNJ+NRnQC99Vos9iCtH/c1lCiTJn?=
 =?us-ascii?Q?TEGb1puXLucdHExoFvCunG8LGhLykqqMInDR7/WOxlh4+8JYicy5wDYxFWf6?=
 =?us-ascii?Q?kQM20kDX/lDCPymfp2wgV9/MHSwVrQHwQLGqy4bRjh0nXr4hsgxw6BZLzMFj?=
 =?us-ascii?Q?KaNshWW1hDLv19jPMn2e1r0NVdsYtxKYfFXyFyYBfmkpJ+lc1EnROy2tSXfw?=
 =?us-ascii?Q?WpDLu/TI/XahM1fuh8L25+eFyev8Ll1+UbL7SpGntcQKAFnxddRguZ5UOsa8?=
 =?us-ascii?Q?ATxzqGAMYB+43bPz7urdbC5UbBBfghJQfo28BB60KuRSLrmlDjWH8dG2aVyV?=
 =?us-ascii?Q?pUk1lY7BJecdlHD58j20sbOYRPNU3GlFMpI2J4kQJ9OJxmM/mgaKwv5fl+20?=
 =?us-ascii?Q?jv0RuCjZyc1aHBADh/1pHAQWwwNRMZWqLTQtycv3K0V/AVq1MxziidlS4Xtt?=
 =?us-ascii?Q?yD13TShL9wtQXx3pS6PfhguRRXQ9iHX1AA71+O28xBCYUG6EkJKSpUcgZwpA?=
 =?us-ascii?Q?CPPG6t1Bn3FwN+Mq8SY7cOqaTpba/TTiMWZKzC5mVapYFyd8DWnbgcgoTQic?=
 =?us-ascii?Q?vaS7b5lfwtzt0/bHQbpr8bsK8mFBEbyn01u3EGUdp+PMW8oLU8HK4f1JTYe6?=
 =?us-ascii?Q?0QLLjNv4ApxeHpen2mVjcpLYpKn6kyORsIgbx5R/rau7gbOlup5AEdvSQ3QP?=
 =?us-ascii?Q?/g77VYip4zZdzMnBtE4DgwCCV7KcldfYBfS0ujxNS+wb9sfkvdUoyn+g74IX?=
 =?us-ascii?Q?k+AXpG+UFmfhMEvcTdBX7Q9xoDHs2PH8GP5NrdjajIRKZMt01rvSLQOFv1kr?=
 =?us-ascii?Q?sUoOiwDRstXDBf/Z7MrvHbH2U0GY9Vryn3l99Pnkc87aGPObwrrO1eiktIlQ?=
 =?us-ascii?Q?6b5D/RhFeWQ2z4+6agi36/QKBg/DP7Bsctr0fm3pxMGokFf1kMWuHrG9kjRa?=
 =?us-ascii?Q?jyWH27vcK7sb2PcX+yft8Jb1bVEWjsl7hePB08ritq8R5hY4nhtliCeV8up0?=
 =?us-ascii?Q?z/vdZ3UIoknybwm9s1jvhKxRbxStKIQUqIoxkPaiOtbtLKUqM30wFLR1sgoW?=
 =?us-ascii?Q?h+HgiNJsRgEB0U0Q4wJh2hBDrwKFXLOwLiI+6gV8PrU9bGVKXul5Ik+9T+s5?=
 =?us-ascii?Q?VxNP8phpcd8WKDzQ1vBZtsUT5c9kO4EhLhUPkVR7cbyPTEsSMqz76+vrhCcg?=
 =?us-ascii?Q?Ng6T2KfBvIutD+1RdiWt5/iAIjoZPW0LTLaNlef4+334VDOvSHdMg5/VzA+G?=
 =?us-ascii?Q?xnl0e+9QEAY/taIgGuprfSxUG7bUaY88+N38Ntr+vk4tgDC7d9iacSI8s5uM?=
 =?us-ascii?Q?LErXWvi9MY8MNPlOQzzp1a0X883FiqlHFeFJ3e2uIzVDmLNCTOG8YKxFImTD?=
 =?us-ascii?Q?EBy81C0bdbZmP1QJsbkdmOWVrlTXmwZUeFCMtwlf1buicnggYtZCQUOx0mqu?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a226d2-5479-4c02-49e5-08daafb1068d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:08.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O8WzaO9oyu7JQoLGgemVAQQfe1AFWmVrBwTZvDPQBJxvj0GUg2OPnIoPEfEJWrjp8blFV3971+gAOrVm3VcRV1m7y6NhyvUjyerWEm9YYBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: tuariEDTd2RvtcjMtAuYPPXr4wHK4ZKy
X-Proofpoint-GUID: tuariEDTd2RvtcjMtAuYPPXr4wHK4ZKy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..d87884a19a51 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -157,9 +157,15 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buf,
+					.buf_len = buflen,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = SD_MAX_RETRIES }));
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

