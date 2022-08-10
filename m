Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FDDC25B07
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiHJDmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiHJDmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:42:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E9372EC8
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 20:42:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E0eE025960;
        Wed, 10 Aug 2022 03:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=U7iRm/CSUXDeyXCiUfmTkqapuKQ0tr9/U0yAlV+LZoY=;
 b=BCmxmiZMz9m0e1Q0zvmZ0cgq/7wd7UdObbdxr6PLPe6hkglfmBH5jXHEMTtCQ00zYb2M
 d5H1qncvyvHAaO4B93DLpZ28hL09P/ypD4fIcVbxn+yTrlDS+j+lZUyl56ILECY/1vv6
 /q/UHbT41ks06RS01892wFsClbSgyG/jgvzqPUfPI1US8vhDcAZRtu60CPLAMmqEz87O
 nj6tEdna1o/BkmA2GdtaoIz4Ce8Selfdgpka04Gs9dolbiulc2uajJ0kSnhGPYDkHp4R
 emt35PjgXnL1dMk02SyssLhuNk/T48gsb4pNecO2ScklJK1G9BEgJ7KNag+lYZ986tG7 kA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0YZDX036587;
        Wed, 10 Aug 2022 03:42:00 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfgyvu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK+d83b/oTd08Rk20nnOE8vngZmPhyVfmM4zr0ylcv8xaB3pQZzO92UdoaTwVajBy+Vh9xKg4V88Wr50rhnikFF7BH2mXvIwun4Q0QJm+zL8udXaC2y77BU+LQZJZMnYccNsNXhuX0/9YEu0DLeuzD72y804pnGTp6iB9i84C8GZkRDhhd9QS4QdNy2Py5LJboSrhNt1/eYJxvl9Dq72qFyeXr47eGSr6qeNPjaR7u+0ddfC5Lkf4nzUd+/vUgtgNtCS1jx9AX71AD9CZs5GERSGGy9UmNpo6qKlVMJHIfqa//b1Zn0n1eZUJYHz0L6lRJmuOwcrSR8/stl7SQnY/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7iRm/CSUXDeyXCiUfmTkqapuKQ0tr9/U0yAlV+LZoY=;
 b=i7ZuOuIRitBJtSpq5DdL+nRX5CbSC+0SeNXaLKNgfwDePcEi+69OcNaZQopjChaAX0uEtxVaz0cEKvtJoEO0oGqmK1V+ShwjIB158Gi0DHI8VPrzMOiZiO8Gw7Sm0203pR7U9ImaqcQxnx1h8EVtlIv+REft/xPRofDxYNP0LDo/d1bL24YOCip1mMmJvNUDHUqO0jDtvotllzgQA2xOnMPdxTlL5Mv+WXGG6gBQQ7wf75CPQB0U8yx4I/jKeJQElrgXxkEaFXJkd3oHxJj87ZmVWC5aN7HdY0/sv2B9fTJw0MCpu8QhxfH+iug0kt4eF/+f3shNAe19mT3Fke4bpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7iRm/CSUXDeyXCiUfmTkqapuKQ0tr9/U0yAlV+LZoY=;
 b=UYEzcxB9nrFo3DwG4KnlaDihSPW+XLYF4e++ZQvRZXHFIroiC5FIp2cOlC+/30QgHZ4hcvNgM/AR6H/RDtFI+iLOlp/30jtn35GMwA9/l7iLjKOqcM8XfhEC4Yuyw1DOxvRRK779lIX7OXonfYPfxZ0t1W81YPdBYwR0RDphKBA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 03:41:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:41:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/4] scsi: Fix passthrough retry counter handling
Date:   Tue,  9 Aug 2022 22:41:52 -0500
Message-Id: <20220810034155.20744-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810034155.20744-1-michael.christie@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0001.namprd17.prod.outlook.com
 (2603:10b6:610:53::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fafb2102-799b-4888-1c68-08da7a824749
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgGgr0TGW17ij2MnfVSgubJZoCq5j4HDvGlyqqqSXOOTUySScvFTVMlWs5GJdihHqlHxC0sg4t+fALrnmdqh+UeUeS7SJkOZqfZHy3f4iHOHdifn+2C4kOKAsklDjJlSVsiunHgmvEb8+uo5n1SAVtO36qlQkHbAjw3cqrvDvwfuBijx3hEHunqdB2qgFI2TDVJnwBKW8y3478MZ17S7lZpS+YXXsmmmF6m/fpWQb1WRke7jZ/btvPC9BW2gPfAFEapPAbSfO8GT2SIKKY3W2LvRoeANIcZFtKhL39+3y68uP3mvb4pomuVcORFPwR+s5Zh8Zuom4zS6kG9jUoHqz4x5iXaC/3zswno94TsK6QsP4iXRbPJVi4D5Ym5jvA9LncNvz5Zk0BRJRizZ9nQ/NPRQFMEfQ2lJCmEGudiToKHijY6LQWiL/8nNf2/tVCWHrukYDZ/71lPafomLPpac2S8kzmSjLJGg+O8qwBQmhyTJX0B1SUtUUclmZ1tNEifSlg4mZ6UbraRv3hWHJVNIGJR/kMuuATFGDXLso4iyN/nG1nB1fgxieqrAaNrnyfALfLNA8dHaoMOz9VsrHm3zEzcehDgaF+amcVQS9PniPIdwShl7hOx7pcp936WSLK9pOv0BYCEv2xSlcD6HJkzXgduibs5ZoU3F7tE90oc6ADiAr5WPX2ps0MsOZyid2fVQnet17ADcxIZ2u1SMrqcsD2LCrRgguMUet3XqPm9yj7E/RMhUaj7RLSUomTkn2SWA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(6506007)(107886003)(316002)(41300700001)(38100700002)(6666004)(86362001)(2616005)(66556008)(6512007)(186003)(1076003)(5660300002)(66476007)(8936002)(83380400001)(66946007)(36756003)(6486002)(4326008)(478600001)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VM3Ao2vmXNV/sMhTeukovoaQGJMIdnHWYO/SbgrGu03I0InhHNYS0CA+d3IB?=
 =?us-ascii?Q?IsxOWD02f+aM/jgBJHARHgK8ttAKmaM4qqACqfSm5A+WXcUlSBxsZKYWudVA?=
 =?us-ascii?Q?wdJRe0zL10wZZTT30gHD+wiNKwCswpksXOBSImwb3a+ZzKscD7vh+ii64dwD?=
 =?us-ascii?Q?1XmlNoPRaoPfC1S9oKS5255ptAFPAYc2Bh7RcSobYBsLdFXvJT6SiMC7ve+J?=
 =?us-ascii?Q?b0xtHoSM7VIu66iqAONo8AjNn7cA2bN9PkHWovtD7Si9fkiv3M7zPLKi8xOP?=
 =?us-ascii?Q?Cf5xejzdAxCQouZ+YWYJn5aSP36TWLKsLIih6FyjAXMZVAlV/uINh7WnBY1k?=
 =?us-ascii?Q?heY63MUzVxvLbHbFOHKKYrZQHdG0QdzNfDTcYEq5EK8KYzqIzl8DAiaTkOL0?=
 =?us-ascii?Q?fnZfH6lBYBLAAuDgpunzpwLQf/1RAYyzPkJPqGwjoOPVgb7+nn+NhMsRrjzu?=
 =?us-ascii?Q?hryCRMtTlF/Ayq6J65YS97AChZmq12vR744E892rWNPrH8qDROQESsEajxd3?=
 =?us-ascii?Q?6b5CgDDGBIDdTpTpr53jM27Ukd6EtFD4Y+Rn3YYCutTGiv7HxAw0UtEcNhYf?=
 =?us-ascii?Q?76l6aGULtp9AVWLP4OCpPyW22jrAyxMBAgNrwYSoxmt+F4e2v4Fi7mWHz/eT?=
 =?us-ascii?Q?K1+k9bjonmorhDegrVfE7MFbMXUtFjApYctPrrALn+Y7RFedwysIkTQ4xcDe?=
 =?us-ascii?Q?/uFYC2O/pO0/71SlbDNGtC34UjVkZbIXm3hQuv5C3PNiXr13+/97EUj5wHV4?=
 =?us-ascii?Q?zMlBsG+ME90rhLiQJDofHkNaov9ZZyxDZQ+SMk4SZ1dWFqnipLctz9YMpDn2?=
 =?us-ascii?Q?Gu+2G2VvX8NJguk/Aoyyx2jzVyuDmac8/wUIcSki+d2qe6cd+xV574qym7ce?=
 =?us-ascii?Q?eA3wPkFtJv6hxZ6yqWbS9lQX4vFOFBSaFF4KXCev3kwZS4nQ8sB8SaYBz9gH?=
 =?us-ascii?Q?5PwALdzQwvVZrbg8Y3gD7G0sWEpMk7myZpMxyJnK/edHFXOvEEpuh5Cx4Ozx?=
 =?us-ascii?Q?K28cNn2Pm5D9BPQp87ZFgViKOYtrOiZhMQJwIKpaTQv4rt7gIXLK9ppmOFul?=
 =?us-ascii?Q?mti8rmva4V3HuhKpaAv2sIepPD6wJPI8Y6CeZOeryhqf+kV3Jam6tz1y94Mx?=
 =?us-ascii?Q?YCjIYi+5o2+PKSDtIIoZgoeHwGKFKmPdQrGv7nJcBWJ+lm6hMKD/IWgxQ9JC?=
 =?us-ascii?Q?L01usPpn0r7ves5+G2Pcw31TVa/rCFxeNwzvd6e3/SFUO5oJkNclimQfEd28?=
 =?us-ascii?Q?ua14VoihgQ44hzPA+lVJyYyzfB82NVgvs49qSnr61YEGg5vdLVCQmgwFpDeu?=
 =?us-ascii?Q?TDRGaq1FinVS472wyf4NmDHV+RmxFvIxQcgRB7Ew74tSDvJk+z+5sbisKZde?=
 =?us-ascii?Q?ZJG4XhnUhSidgkbnUA8rUMemtkLmGVQjlU7Uhy+sSvlYWSvFznqfZ1uP4TCh?=
 =?us-ascii?Q?3ng9MklC7mDVWFFL5TIh6WB7em9spYOIzoYDAPVleEpkF1/cFQxK8fuJeUYN?=
 =?us-ascii?Q?JBiqIW9HXGuBHUDw218rVx1VqDM42AECYOpqegHqXOH5Q0wz3kG53Y7l0zAu?=
 =?us-ascii?Q?ZgVa5Q8H0dx2k6hUA3r3+MRWPgbO4uHDmladMcF40oUyzv84TFEwt3mnZ/bx?=
 =?us-ascii?Q?zw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fafb2102-799b-4888-1c68-08da7a824749
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:41:58.7751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ZEawcSS19hlP90i6j1H3QvMbVd4TlE7PDQAYggPL6X2GYY7OZuZQExrTohfjXV2h0k+tzMpTUJIpRAAyn98BjURImB2sWN5jjB7A06FMNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100009
X-Proofpoint-GUID: dgoRCC7va4KlO4bvV2acQTDC4Ej0IAqD
X-Proofpoint-ORIG-GUID: dgoRCC7va4KlO4bvV2acQTDC4Ej0IAqD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Passthrough users will set the scsi_cmnd->allowed value and were
expecting up to $allowed retries. The problem is that before:

commit 6aded12b10e0 ("scsi: core: Remove struct scsi_request")

we used to set the retries on the scsi_request then copy them over to
scsi_cmnd->allowed in scsi_setup_scsi_cmnd. With that patch we now set
scsi_cmnd->allowed to 0 in scsi_prepare_cmd then for passthrough
commands never set it again.

This patch adds a check for passthrough commands where if set then we
leave the allowed field alone since the submitter already set it.

Fixes: 6aded12b10e0 ("scsi: core: Remove struct scsi_request")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_lib.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4dbd29ab1dcc..3ef85c8b689d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1541,8 +1541,10 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
+	if (!blk_rq_is_passthrough(req))
+		cmd->allowed = 0;
+
 	cmd->eh_eflags = 0;
-	cmd->allowed = 0;
 	cmd->prot_type = 0;
 	cmd->prot_flags = 0;
 	cmd->submitter = 0;
-- 
2.18.2

