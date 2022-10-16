Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41592C43217
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiJPUAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJPUAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:00:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB023EB3
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ20ux011562;
        Sun, 16 Oct 2022 20:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=BQzPFz2WNk9uwVVH9q3Ta3775jGadtp0eGetWzyH2VPEzmamJqgtB/vG+yKztDJ3uyA+
 KkFMgMFkn7+h56DzZMyPxyW+W0wWZ1US5LdH3gPZJ1ssFPy/h740uBGHmMz3kbwbVeg6
 +o1YXGujjV+NldEKvZWdA2K2MpJA92NxEa7UWvghXA7yeT4dtvVhkBYHyFKewL04iiFR
 /pxBQxL4/PAKasx63ER00sbMNQXeeKKQesq+XEbjpjT44MIUDMklrQksBJdz3laZ2ui+
 VyPTXq926K/mVkIQY+oZvgb3sNNMOGuoGB//wpr1dG4BYFhkDFpAhJKhY59fNI3F23ak Cw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39ydb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCAneF001181;
        Sun, 16 Oct 2022 20:00:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8hqwmgmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eeT9TCNgbWhdXDpZ8nR0ojzMTwMHK/xfBy5fQ3sSU2yUibDK7pMxKeNx3AGpQftIqnDrhQnK2hWRwHwuaSqwdltKeVIwahFxu7KzdbbR/KX/q/Pj71fP4AHHIjiKTG59SSANLT2CBZrsWcF+srMxTDlKZLaXj8vozCGFuRvy5tOnQfGuUMkgdQxS8s9BQx+u2HtpIfhZ6zlMbML8t2J0NmrLofgmteYJkXyAmz8PpYscraikVPIUS9nXKrv+134aT+xGnTIjoP+zNmXiqqVe/5+zb7Gc8PGq9IO88RG+ZxtkuOPJEhyQNXhponePMr0stEmYfKscay6NSpUmy6VWhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=cnlATWfqfdrV5w8xcfJoFfQIdCvMgeq2eO42/+dPD0UPrO+3MdCysG1MWvnHsqunW8dEFWChYN97ThWNJ2AyQS3XkGD/xeaHq7Y7yYgvMrUFTosaunShG8xPentqUs3iJCdXv5wGci8PI1TqZvUwo4o1fYrxYCRoo7uhggD/nUsz0fC61ETTGnQ73JtmTn9361+e+H23/bMXiY2CCFKdI3kfYK9bmrd5aKFe3XZaNQ5JLf0U9FXp7hIJqjuc2KEAJbbOkz0ZmDkcMCPn0+64zPv2deTScgziaxlFReqT9YYNPYpbTr51SkTdx0RtHn5ArRkJOvn4B0OwXh+6OaO+ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLO3Spkew+E+i1LsX8SIRp5psan2Y90s9P0m1HdmK0U=;
 b=bGqMuq/9Uhr21ycShyBe/vO1+B473I/Ia9SunQtHhrhaY2FZiSU3ETUxRNamRFgIntenXwfOQs6uXifKaZH7RbBeq4appPrHZWTIAYgKfbYviDj62A/p401iROu+e3TlYHmh/veSNjP7qhbR5ADaHf2uWn91c7NpA5vMs+K53DE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 07/36] scsi: ch: Convert to scsi_exec_req
Date:   Sun, 16 Oct 2022 14:59:17 -0500
Message-Id: <20221016195946.7613-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0003.namprd15.prod.outlook.com
 (2603:10b6:610:51::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: 25d5bb1e-ca42-4d44-c223-08daafb101db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xTYEyEf2cKo3G8KQuT6p+z3uUhBm0mzKiTaTgWxcC8KBsqlJCSNi9LeRe3KqpTJteoT5MxwiBH6sEPkf1oA1NWpTvoaDWvxHSnQiYCQndbW1s4hrNXyFuvdrX6KJe7WtuZVPtr1YrtKQMgOSEZIHFXlg+W/s0l+dXL4/FVBw2S3Zybk2eB+Rg0BcawwKzAbB1xnPK/qwRvE4xDEgz3tzmMRIB7ur4hJ/Htodxrmdv3DRXCh9lGG2bdhxKAt7ofQ7Yit/hVrALvNDtQEJ74L8NoquBFKpBth3siLFvujFFjrQpYLOM2PGq9dSPlKst97VhaZ4WO5OD0wl0YLSyXoGI4uFd0P0I29AxdY/0gJeY3RKj2ydHaDnwfLRXGfmcAiHfhxcyIPx/EU3uHcmJtftajhzDNT5XumNwgKczKPaK3+bzLedKopoDZvTQrZlCnaf+vDmleA7pY5M87aY5UhFf2z6GvkcnBT27YnZ98cQsX2LZVidGIg2PtdOWV5aw/Yb3ClUv4cQIzB4jbcSst8TrpMapNHhSWdv+A3IIaB6Hh88/3AIdzLO7mczQLL8Qywsopv/8hevSqCnQsFPYNpiJphTl1bx6O0JOkLWZWEDeo9X2CicXUhofzkXEN6Vx8RjtozIXZcVOM/29fzyEzXZDlw7WDZsue9IADFvUzKfYgl7uxBBVcGvWjiW/PtiSo9z7yOno+/E+pLsXk4KHWk2Dg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(6666004)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xowOSyT0dwE5ayMzv6zwBg/TcmB2La28BE6AJZJcWMRPWeAC362niWnjU68I?=
 =?us-ascii?Q?Ye2SgdlFPFRuHHLwY/vmARsQ1UyJ1Hw1eAYDFoPmX2o2Q6DYcZQq/ZRM1I/z?=
 =?us-ascii?Q?IrlO30a2oO+MhEZm0BH1W2POP5Sh+UrTyDmEmSKiIJQdD6/WkGhYBQtRzd9h?=
 =?us-ascii?Q?f0/hKgXSy8soAwLxbSgZNDSjsot2h3T5pEmMjzoA4CZIAWeXdYdhDKxWml15?=
 =?us-ascii?Q?rWszkdSiI3yH6RaD3vRfvfqIAM63nNMP49/AXUM8WhapkOnHRYbqIEw1F1Cu?=
 =?us-ascii?Q?V6U0/G/w87tfomvsMRCQ9LNYVWfgfqDLAsUxgxk1imI7VmP8Xw6xAY0Wttnb?=
 =?us-ascii?Q?1eirxMseulQEMvxboZkH8ssORHVqG/vi7YG28AvxugVMtYNKiwPkDMpZ4OEO?=
 =?us-ascii?Q?CYJUXp5m5rvV+ucnN/6aOtNsg1aDvJ7meoUgueP3Tff7RkjoY78vemvcXeUs?=
 =?us-ascii?Q?PfITKXAWXEz2bJXZOaleOwFUWrPWY1LNeUWQVYSAhRBr5zLyHCM4vpBh4CEI?=
 =?us-ascii?Q?/CzY0kcjCAoX42b9UuTHC+/xaIjrs7UPTXsRM2Tak8H7IWI/SYW+n9gvrvOg?=
 =?us-ascii?Q?sGZyW1wJYe5B1QNWVx4WXTHgG2KJT6Jf0Vl2RCcIIqqQ98Dd7J/bu7FrZhvo?=
 =?us-ascii?Q?qvbLQ7BGAT4bFFEHa0HmFC0GVwk0xWS43BC0R0QPJKuHFKIMORzrYT36DwFm?=
 =?us-ascii?Q?c0cvlxl8sVG0eamhjQ9QsAMuJvU2zYImf7z6Cka1pZ5b5gsGEQU3tdDqAJ5u?=
 =?us-ascii?Q?Jl58MRX/b7e6atErmHJelfMWwlk6RqpBj3KN/Qta9Bdw7B4lIzDzYhpHM8xA?=
 =?us-ascii?Q?snPUEJuJNLK2DY9gQkrAPFMUCtK3dhMn+yvVwGzSttl4tCT1kZYG6j221hAB?=
 =?us-ascii?Q?vzntEhTl8egCZdTN1IEgHXK0wVK2GHF/55LQpxcd+qdj8hJH0Lz7Hrhq+W06?=
 =?us-ascii?Q?3xAbESgAbFTWRolWCTdBSqJPWPh44SckUevAhbdc3MZcqDZTsAQgiiIZSm/m?=
 =?us-ascii?Q?38qd1pVlKo7OMaC2HlcP+MnGHLp5svYz+Icrd0Cl5Ljnx/bd3zLsbEOuuWG8?=
 =?us-ascii?Q?dKI7pyAZAu0sBpItkT5iW6kGxMlItXGV9Sn3/DHIHguJ49L+2uGmgLcVK+pz?=
 =?us-ascii?Q?HUIC7oS/lc6UuUBmpCN2sA3m5tXMoEy0cpokC+qO+vgWBP1gtTLtAQnewLgJ?=
 =?us-ascii?Q?UX0YCipK7ZElz5+BXdPWyeTCyi+vhyrXdxxEgfk0aS3ayHpHVOwpRUOh6J7K?=
 =?us-ascii?Q?x58cw0NJbhl1Pavnv/J3qtimLBi6tSCpqaroKHPMkzzHkcRbZBz2LKZsbakO?=
 =?us-ascii?Q?lOOQfwWxnU+fnz2rMRzweOojSkfTFiHdECV9zAciQBOb0twNzp+9d7bDJvJK?=
 =?us-ascii?Q?pnEWBv1f2kw1cCaj361LmU7D4wsqacOUJ/2d7kKdMmnBUpFjdwuLbZ4Xg1kQ?=
 =?us-ascii?Q?hVpbeTV9krCz4v/O/ebm1aipXTQC7tt8hJosVYO86e86t7aZWZM7VftttiMn?=
 =?us-ascii?Q?y475fjHX+ZJKM1iB6Gdcy4LemveCyNXKERpavQqu0toMhX+jQCeMt6Yegaa4?=
 =?us-ascii?Q?iKNu+7aAzwIMCAmU4MJMVIrNdmsHKjlMcOziDPRKZwkXnfZ+NQxnM9aG4301?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d5bb1e-ca42-4d44-c223-08daafb101db
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:00.2691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAZf9T0UdMQMQlS12XTZaiRMrBmtaV5jeOQZmvUYzp3Iv14BOFSxZiDX5j0a9CPHe0NQQyuISRWW+YJ26+Xqj5ly7HTxFyJmymyK6aSXIGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: mqjdPPzFaZm_wmgcr31CjQVeWyowQXJe
X-Proofpoint-GUID: mqjdPPzFaZm_wmgcr31CjQVeWyowQXJe
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

