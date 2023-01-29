Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D1FC05027
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Jan 2023 23:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbjA2XpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Jan 2023 18:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjA2XpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jan 2023 18:45:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D01969A;
        Sun, 29 Jan 2023 15:45:07 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TMkTqA025111;
        Sun, 29 Jan 2023 23:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=65os2/q0SY3M0+oYUPVnUGW6BnDGO50L//Ndy9xiPBE=;
 b=PMeLP2LlrVjgfSl/GPSTFysHxvEccO5ZCV3NzXEW6oSRfZRsViIteF+y4lJ4dTQDYYnb
 qtg9ZDn+vf0vI11nQbkzB6uflmXYzba6eTWVWZcdutWiEzWPkpxEi566okvh69qrWhbD
 QVqg8lUdVSkQDz2zuD36/nqO1FSO+dyEPgXvJ0zjKT4FZmPylgyYgeOvYMLOu3CxOZvc
 vOmsFIEw4vK50Hz3QI6dhwziXllN88Aj6y0UUpGuRg3bM6qhgdhuzLNgg/S/RxkmLo1b
 DFj+/SaqrV67Oz3fyERlL70a/qo47KURrUehbZPv6MNWS8W0mMFpl3ufRh0jrxZfy90a Cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvr8hry1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TJ5qYH000798;
        Sun, 29 Jan 2023 23:44:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct53dr1t-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 23:44:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+JgLE/wPxY3TG8dN25yIZx9y+EL4S5ggty/TFhg9tSamweKBW2OC2vIQHdYkZLaLrsczB4YTWS9WcoppMQKDpXrQpa8EVi/SQVsfJR2BimMwTPb34Y86x7ZYTncSWLSRYk9Dh93H+7cHPUug/R08X0Cj5JygLLgVEUX+FAygirSgykLwvfSx62hDOkM3/SAVAvRtANvOag/8PEO8ABEoZ7qzGc1FF0ZNDTd4UtlkVIbpYLqjqjaB5Nhdz5X8BVRdcKd+WkKTPetdRgbpBjeB3qfu5SoqC7Gs3ZCdLFDPUfEce/6Q+yTSxBe2HH507Uz72GI3TvyivnztsIFRO0Mfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65os2/q0SY3M0+oYUPVnUGW6BnDGO50L//Ndy9xiPBE=;
 b=LF1pi0ccWHf45nkqEFx2OhDgAiGMcwMyMc2Nout5m57x+MufLBZL0aUtYG0dyQIXyxINVpA731SkW6LA8cX4DF2Xay51najdF25eGToifTpwRBAHZjCSdG/qdiwlqXnoZ98nkT11Oabaxrt8tMg4ZtqxZxXMPTJrihnNAsxF7Dk/ftp6GSUWaLjbdmLx4KjQ79o2dp/YILayxS0MPyuSrYmXAxETBwNXxeDqVq8mm7ZnivOJWdjbw4Wl61Ag4iOtq3U70ZmS2xi3A34heasoftg69uTeGBumk2VrBdIHioJhTpSb4DHp5VXsqry3WXysMFzBFVh+4khb0Ul0Xdq4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65os2/q0SY3M0+oYUPVnUGW6BnDGO50L//Ndy9xiPBE=;
 b=hFsHXtLOH2W5W4V+bbffvuwNJ3tM4HuES6N4sJYfxT/sSV7UStdMIC0p3OOSFfVl1MP6ZXY+DEhwEsNvKwl5Tq7ByiieRchBT07NOJZMUitsxHdRR7RpSH0IFXhprqwL4qIwaBTngZ1OcrwlGor/WPfNZl9VtBypgrXWPaS6u3c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sun, 29 Jan
 2023 23:44:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.017; Sun, 29 Jan 2023
 23:44:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 07/14] scsi: target: Fix multiple LUN_RESET handling
Date:   Sun, 29 Jan 2023 17:44:34 -0600
Message-Id: <20230129234441.116310-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230129234441.116310-1-michael.christie@oracle.com>
References: <20230129234441.116310-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0168.namprd02.prod.outlook.com
 (2603:10b6:5:332::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: bc478893-a1a6-4a63-044c-08db0252d291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dulkZJtoWY6BukGOaL7vu2BQT2hDuJONWwQFR/20VqlvIFrbGO0rlIsyXV4l34ncM2+BcGVq2NeIn59MIAsOB0PekhzPSBlvFOcO4rwiXwAAklPu3AhfDMEMuAZm+VObPLyFo280Z0a1wgtG86GXTj1W764QMgll4e78gnrqY3YyUnClgr+9tOlppFm/Hb/herKmfVSkyqtljubLfw0fhRA2EZKQqHmiGLhOjWGSvIC81t04BiEOSjSSzqq18thuiVFoFl0/8W+ihcMx6AhJTvJ9ya6x0GHgTTBop5gxOF/TC0FY9Zdb51sgiKnDFx3yNOb8PgThKd6qjLmZWWxmAOdaH0QXqw0pGZqhlfTwT6/BWpkqL4+OYrhqAkf9iXtt5yeOfi3zvjSkY4jb+17oyZNnljrFkz8ZfGQgF+NQd+Crbp+lOVt1jTDedMZM62JPCd/6EaiXtxG5ZUMJ4N4vygdzxeZu+OPMaGVUrxNxcRI/asxj253MI4iqg6vey4bD2mHjfETuQC6PEj6kMv7WkOgmJYuD8WYv7vnxIC07ULjbxVJvR0cARXg+yblOHAzUpnmGrIt1/DOKFP9CSW88Mzcglxz1NQTaMTJXA1NXz6P3NgUP1Zf90y8AIKEd67AZrjl60m7pjLgv/wMXY7Nq3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(396003)(366004)(346002)(376002)(451199018)(316002)(5660300002)(8936002)(41300700001)(66476007)(8676002)(66946007)(66556008)(4326008)(2906002)(6486002)(478600001)(26005)(186003)(1076003)(6666004)(6506007)(107886003)(6512007)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fwwFKJy1taj6Q/n2NoUMdrnlBLoRPryGaB95OAK2Gg0kN0DV1+CGQcAmDTjA?=
 =?us-ascii?Q?L0KroC9aOdbeOlIabzsr7tPaGZ1oAf+xNSI7rAslj0qf8HsJZkO21UDS+/7f?=
 =?us-ascii?Q?AePjv9lyTAGR/y+MLaC7OvpU7x3TwilqYRU01CizdJ4AOoK+4boNg0LsflBr?=
 =?us-ascii?Q?5dUwNqFbP7fanBnWtv55JRiIq4W33wsniUnD/1XDEHIGdlT7iPSn/Ihyuo71?=
 =?us-ascii?Q?5I4RowYXAuaks2tWr3HaAYM0Q4Zq4Cy+tzY7W6LdEiF9rjZI9C1ASxOpAb7d?=
 =?us-ascii?Q?Y2KGHbMxsHFuWUlkHEbNUpox5edELEvD688L9jVMvIx1nQerpcNwD1rdtEWI?=
 =?us-ascii?Q?7ntNCki2/Nl/nwdoREVe/SzXdQ7okWx/Iro+YEhCqJTMRYkX4RiOSrO/HXN6?=
 =?us-ascii?Q?cGWGUbfNZcUkIbRGtzuf/smud+cIKkywrsLSK2Uzvqa41auGlaVNxtdRREzj?=
 =?us-ascii?Q?HmKvGg5V3wVwuLQB+6ekxcR39PdLyqxzBXvR/Z0bsn03K7z2AllEzbG+8IfP?=
 =?us-ascii?Q?O0EzfMKNeK5BY4mBrknCLZgRP48YO2c1J2ncLR4P07EXz36wmRxpuXGAHJdW?=
 =?us-ascii?Q?r0iO+nbp8m1pvUFX6IFvq3r585YddUyjVB1gv/v2S8Vrrc7y5n/Y0poe5glA?=
 =?us-ascii?Q?b5Sn2DcNCfzyUp1VuSJhPgp2zSbZW3XP/pxl0WT4qRvl2eDCQG9yL5yArpTw?=
 =?us-ascii?Q?mzZ1J/5mocMLCv4GmfxyOET2Co0NieYTG+KHvKlqEtSDWMm+qV9o7824+exM?=
 =?us-ascii?Q?Ql8NO5/3q/TBOrD+LLDypo7FR1Z+3SPT/TClJDVJfeselF+c8zhu+X8oDnCn?=
 =?us-ascii?Q?mmtYiE4MsoY837tiDfnRBIN3tJPKe3oQBG6meGVZJiuqEpqfi2tohXhWqLmA?=
 =?us-ascii?Q?J7xXY6vouS2cwHgRapfFiVXA67wyQfxSYB24JLxSWwA2x9E56dV+8UcEPohp?=
 =?us-ascii?Q?i2a0PftyQhX/R815sB6Cd/GOWgbZkqX2I60QRye7/WFr0QRFmwTjp6SvrMOi?=
 =?us-ascii?Q?ic7Q9p82sVmoddUZLh+/rap/LnZfyyO4lq1qJlYdXsL3E+WycG7bcxqkK+po?=
 =?us-ascii?Q?lDIxrJprTAN4gWYCGXIUA1J9OzAOmmqmusfh+pTgbzw3dZRG8/CmE6WF8DdN?=
 =?us-ascii?Q?7PvD7prsEKECsqnWWYsv2w3+KIB10Mpl2UuiuBCP1ZLbr4iKQ2Dn3bMWEXCV?=
 =?us-ascii?Q?B6yyc4fkFlB+nlp/Bsf0KCi1/6L4dc+3E+iWpst6RL7AuXbFkVH1w3y+QQuu?=
 =?us-ascii?Q?wBiF3K4nrHV87MQfmouWM4Qax4X4Ly8dLqcXvUBhM0PFlgCmONPz+kQxpZb8?=
 =?us-ascii?Q?tpgFuqdyg9Mk0yb0T6qUcNFAZqhigiPH7QDiayW4cfl8iizlovzr3Ewt4Rfd?=
 =?us-ascii?Q?E6285ew7b3si303gTkB41YL+IBHTQYjiVw+kpvI6DFIdxBnVFEBrowz0npCL?=
 =?us-ascii?Q?3a3S/fBq6ho2M8E33DOKP8sU5p1RhjuptlgXcYiyJXQW7AlIEywzmdgMS9dC?=
 =?us-ascii?Q?NZSXCkqB+SR/c5sq1kxk9Li5RMwJhWakNhmaj+S16H8tJQLmnmteDyh9kSL6?=
 =?us-ascii?Q?XIgWw1JIxZzDgZu/o7bjjKSdHjy/Vw//eBsT4x0GNLl7r4Xn+iUGxPbkuSnn?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iBK4guJZ7go0jFxHlZxdIPWPW364k59+lRVIUf4+Xf2ylkf1QzJp10baVQVlIdfvFjVPMLssWkk9+I7xOa+mwvs197jprPD1xIIf9FydJ4HRKptiOnamcp7fxbF9zIrdN3E6LeozO7BZx4/0HSADo/bnFfP8LVmhdS8aMOyfOGupO9vM2h/4bAQW5pJAh3uf4rxWHbIoOKPx0X1j2Kd4HYNsiNVyDwKmnwU0bP00JwIVf6dlpJ2nBXaTQa0ivMY2YDLd4kh/XoMLEWP8hc8EHZFUG6DDrh/71gXey3bof2+S9pmWxCi/WSbQkxrQJvFHoeqfsHjgVShkqA8uZ955MiDap63iM8+lC7YIzSNCiL/yLVlT8LzeOH8CQHQ03n8yhnpqsCJiG1Bs4Ces3YzxZZRJXP6thydT/kZWe2TYXq9rqYOJalSQvjPSDXZ3vWy7HlPrB3nFoGA5hMkT32PowaUzvwJH+GSE1EdB/mwAu+QM2Y46AGczZG7hSCjixcc43Ew6gAAyBdpKuQ+o/zZHjmXcpXv3CKI8XL1xCMKAGNmQrps5UEbGPs1ETozck7veqTEM72Z320fJVlLRGdy+/HDWSgMwe3Y0qhggepp2nR6dWIeflNtN1l5uce84HeTelU/VFukAYTBqrl1smLv0FKP1IfbsUQKtH2QuDaHJFieyR0jG00VFb78TKV5HOSWcGJ5qfYbVaKNSxRSwDTo6v3P3+a8h4lX3iK66bV5IvLGfGwjkK9J6z4b3PZQdG0Z1fEB7wr/ImNMxeKaPcKAXem1vi5K30SeCNaEZpUNGeQcPczD34s67qolEUfYD2C4g7/UUtxmfaAgcILVEuER4CaW5dPjkCz8OcxG7AIRQOlwmrgLXVL/kttur3l/+tM4+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc478893-a1a6-4a63-044c-08db0252d291
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 23:44:54.7756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVIz8FZ4ZGjlVtJoRiI1n6Vu6adBcREFnQlqLarXDdjABWZAuTsQJd7C0JqJF5tEUj1gH4nNZNPKbgGG8lejpkcFjyMpHv+3t9gaGBm4+YI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290235
X-Proofpoint-GUID: sU6TsuyDWd4GrnbT8XDtO_MeuOdd5tE7
X-Proofpoint-ORIG-GUID: sU6TsuyDWd4GrnbT8XDtO_MeuOdd5tE7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes a bug where an initiator thinks a LUN_RESET has cleaned
up running commands when it hasn't. The bug was added in:

commit 51ec502a3266 ("target: Delete tmr from list before processing")

The problem occurs when:

1. We have N IO cmds running in the target layer spread over 2 sessions.
2. The initiator sends a LUN_RESET for each session.
3. session1's LUN_RESET loops over all the running commands from both
sessions and moves them to its local drain_task_list.
4. session2's LUN_RESET does not see the LUN_RESET from session1 because
the commit above has it remove itself. session2 also does not see any
commands since the other reset moved them off the state lists.
5. sessions2's LUN_RESET will then complete with a successful response.
6. sessions2's inititor believes the running commands on its session are
now cleaned up due to the successful response and cleans up the running
commands from its side. It then restarts them.
7. The commands do eventually complete on the backend and the target
starts to return aborted task statuses for them. The initiator will
either throw a invalid ITT error or might accidentally lookup a new task
if the ITT has been reallocated already.

This fixes the bug by reverting the patch.

Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_tmr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 2b95b4550a63..a60802b4c5a3 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -188,9 +188,10 @@ static void core_tmr_drain_tmr_list(
 	 * LUN_RESET tmr..
 	 */
 	spin_lock_irqsave(&dev->se_tmr_lock, flags);
-	if (tmr)
-		list_del_init(&tmr->tmr_list);
 	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
+		if (tmr_p == tmr)
+			continue;
+
 		cmd = tmr_p->task_cmd;
 		if (!cmd) {
 			pr_err("Unable to locate struct se_cmd for TMR\n");
-- 
2.25.1

