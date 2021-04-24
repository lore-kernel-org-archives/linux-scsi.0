Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C612C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B65F61152
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhDXWHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbhDXWHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6TwE151684;
        Sat, 24 Apr 2021 22:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=WuAPXIQ26+yk6vAnba24Tfly2PS6q4RRVpSQpFjI9oc=;
 b=WeDSz2mp2uTAuXtL7wR7jd0FddI73jAVZ/iVFteoh315PhbQj8fmlJmMUCd0YstCU0Rk
 Iy5wkLVAbCbRvBAVYCE5yo63xxjnB+MDN/rivCROpDwYclzFxdAPJ/VshRcO07UhsZa3
 bHNRyEEonh2h2O8UaNIhZtROGTZrhSNtqIKPzaSJaPCmGqyVUEZFT/CRtJ8GWCrni9cF
 gnMOdEqDDduMJ2Z7YOM5H3PyXlB1CEpMu7Taz3RvaBlIKgnZD335iY/y5yqIVmjL3JTl
 nGuQ4R9a8BYu98CbvPZT+8dI1GIRHb5/sNb6KUFzDn6sD8xiim38bh76+7acJ596PF9B tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 384ars0t14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Qlb143191;
        Sat, 24 Apr 2021 22:06:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3848et2a85-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJrk59VF249H16GInd2TBqbODkEAzTzfEe2HrVZ/cHsJ1qTjhEGtrVFs2czZ4Ju4OmffHPrZgDKCaqDx48luVcawx4T7aO6Saa0KDTIx+DjZM4G4dQKxnUEgOyGRpTLTG83PAuq3GUCuWZY6kFNM7KuSput7N5+r/a9QTHMECR/owT8qz4LXaG8632+dLrghny/8GWc3fqYSD13sjMts1sC4sLYPmbDTU1SSTN87PcoRVk8VTXVmsGJvXPEzt7xoIOhdOHRZQuxt8wIYt9S+BzQnHpRLsRr0AnmBYeiHSyJsR14sLLFnd397VUtLzLuu0OFKQyLr+wKjUxr7vkjOGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuAPXIQ26+yk6vAnba24Tfly2PS6q4RRVpSQpFjI9oc=;
 b=dFerZTVi7rP3nUty1HQ72egXShQECy/hlTPyrAoO8lBetO3PvLh25/UEuKEWQiDum49Om8oU9o8VaN4OFp1mFS7ZC4F2wB36kafeDaa8+P2WqGlXyyAI4rOpBX+SRMwYVzbG973rzDjSTugq/PYiQUm0Km7twHy0BfU+EVqo+Efq+eMHUGy2J8/OwIbp4d8kpf6SXkFbPtIL2VgkUCG+bLeOd9nJ2tYEYFJo2OULzI20fAbn4hgcF/KYWktull7J5NCxPjfKtJUD4EgSd6XdDmi0WYdzzQtfri0vmdOpJlss//HPbZt6Q/wYIC1oljhmRCNvBcrCPAK2QDj2dhkb9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WuAPXIQ26+yk6vAnba24Tfly2PS6q4RRVpSQpFjI9oc=;
 b=qke0GtQ4O62PIXRRCUs70ybkxMfNwi+pBd0oL4KKiM7UCE6a2EhEN0U6mmvPnROUPvc+sV5toG1phtE8k3FlHvHz7lNUNzWFpCZr+lMCRMONf6UREAndA0NW27CkTye6ToGrJUvT0sxJvHpchTAnLhBiXxKXztBd/itvrgGejPk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:27 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 13/17] scsi: qedi: fix TMF session block/unblock use
Date:   Sat, 24 Apr 2021 17:05:59 -0500
Message-Id: <20210424220603.123703-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210424220603.123703-1-michael.christie@oracle.com>
References: <20210424220603.123703-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:4:15::30) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48444cef-00f5-47c3-d9b8-08d9076d34c3
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317BF17664C7093C597F97BF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BrwONkbLuiEIOy5jg6ZSL5oJ40Sima6xoY+rYUj1kN4/exFwFiTRWjM391QKmB/k5FNYWZJndw61Gw5v7mD3ItFKS9nt+p7PbSo5sT99rwrZKXRjPV+q/nLvX/3/I/vxxanMbLoH6u0DutHobJQlIS5ptOZA0lCvM9pdMHno3NBu+OLpVygXnfqrsMZ+jzfPDUor1dkJD38tuJfYPzCy+O1Ipz70BUktD4iJ/ze1AyI3U/w+5BOuXQU6nYNSlEcNWlVUqJ2ZQFrRM7gMbeQ4gK9o6+Jel+w5qQDHfni1cg/HVxN6T6BgLZnufuu+JSjuIcVDa5k0ebmSItnHzuSieBc51Y/hfAvgSRM6eb9vddRJ7gfEt0JxAwUwvPo/nHMz02t9K3qR6Yp10hbgRHARMpphktT0hNHc86zN7Q9GxastA/VGMg8IUV+nwsQMmViwVvtvvhXrI3+ICj2lmDyTLWme2sIZvK+qGIVwYZx34gnlvZtJcFy5JiDXioqkuNIxcuHGeYL4srFzCc6pjFob4GeN+/zZeaE8Wot2yjBUdB5o8DmXufLTvP6c7OkrKNRZ979CNjwwgawvYBiYNJbCgkAhiDzmqT2bmIIVFx8SlIcasGFgj3x6bt9AmJ+AxVPG0bCfDyas4ebxPif/sf+Eb16Y6n1Xvfow2KQze3vP6mmdKN5clnSK0M+obdm1KJaq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8D7vNTKTazAR46EgPnv+dlj/+gMJkN7mQoOz3kcnEukZ9QotIUTliJSg30jk?=
 =?us-ascii?Q?0Ye0JrR1TSKAYd74ZNd0f48epARffffTQEpXFetIG77oihWrmblsuSvlaNjk?=
 =?us-ascii?Q?6F9d7gwUYmXZUijk45FbCZp132toWT9vcl79Eydrun4T6sZ4nCfwZAjIoiwk?=
 =?us-ascii?Q?J8kIK+1/+IxJv7Gv5xyh6RYg0UAKRismBphHC/g4V8Ot6MG3Rye/4Iy0nhxV?=
 =?us-ascii?Q?1Ev+iJ7jLtFe4cPMgGID5R91I0XmynNFYdhJEMZyCX7jOTjepERgTrjCWWvs?=
 =?us-ascii?Q?LbeMYjKNC09pNGnpxFQOJYm8An2V3EZQEDVExhLpPCNBjyG55g7kx4vPgFWQ?=
 =?us-ascii?Q?NFLSPfwXX5UHn71xhhMEEYzkY6hMJogKDgLg/xN1WkXaJ4ZjwlgiwjixJXer?=
 =?us-ascii?Q?HlTdXrM2lXdBSl68palV8vT8Ch35ta4H/lwB8LXpFKaveKYf810+1ZTvBzgf?=
 =?us-ascii?Q?9+tDi48phA704/WthGfx6tYh6OUX2TZIlCfhsNgMdXl7fu4xQSCsHtbCL6J5?=
 =?us-ascii?Q?ht9mXV+CX3XkeMRPJoVUm4usStwPncVJMPYqfsrLEuCCwp6xtqZ41PsRNyWx?=
 =?us-ascii?Q?Xnu87X+sLuCF2lM720YwY7XPLFQ1DFcjWYXVKvrHBLUXYQHWbdoBkh8IVwxh?=
 =?us-ascii?Q?E5OXvOdqWYtx3BVK83MnT4gaGzbhT4AEmbrWq+Nu+MuyU0z78all9VpQKeym?=
 =?us-ascii?Q?ulfQW4Zo5VG0NtkJH3pWDfInReE+FFwf3RINpEsfB6dtaB6Jm2cT8ag0WK4t?=
 =?us-ascii?Q?nISFpEJmJEqETOo9s6yDRY6ixuRWbdlk8ja0RXuGHxFSjiXsgfSxub+rZa/9?=
 =?us-ascii?Q?seMgLuPjJUjFiFVzhbESQN4IEzvXyaXNVZpw8XgsN8AEUklpGIR5UH2rDDON?=
 =?us-ascii?Q?VA9f1UbhOkNgPx1YeTa79vF1L3hrihgOcEmuFlESm6J5J6mu/ud0QMI3XNg2?=
 =?us-ascii?Q?xm8mjIS6T6ILmKxsE2QSJVmlTs581gdFxRpTvjkKF2Vs2XqNstuC6eV66/9T?=
 =?us-ascii?Q?EfAGCrglbiDnpRBX1Uf69p4x4zBNQd8inN6BPduGgsiMat/NhMXOSDdM9Grn?=
 =?us-ascii?Q?ZxUil8kfc48rDUKnrQUGYLtdWtbrqG3gRNBSi/U3avXU0HY42OaMvaZPA69x?=
 =?us-ascii?Q?nB3JaBg86q5lj4qz407ygYpF54YEqmDDd3mtTgrTh6JmBBRNBNvmNkBBLZ6M?=
 =?us-ascii?Q?sKNquCNgwaPIfC7vDsNKWI/APFUJbiHcqGwg3i8Vgb73oDamskV0eVRnEWdj?=
 =?us-ascii?Q?q+h1rW3NkFGl0ySYZa87g1Ytp26gu/8mxKnysxN2nj8T67kWUgBFcHiXFFJy?=
 =?us-ascii?Q?BMjK2wfFwipPpt/+N2DG32x9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48444cef-00f5-47c3-d9b8-08d9076d34c3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:26.9874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NDZA/BJB1itx2WjtDCRcMIzfdDCC0sNRxQJxei3hPWzRaL9x3EfrgIStavjcu76Oys4ml4oCGd5qx/tc4Ert1cj0nDPdprfGqasdfklFvAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: kdnCnT3TnRQgAhyTH6M0d7hpa0_FBEyn
X-Proofpoint-GUID: kdnCnT3TnRQgAhyTH6M0d7hpa0_FBEyn
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers shouldn't be calling block/unblock session for tmf handling
because the functions can change the session state from under libiscsi. We
now block the session for the drivers during tmf processing, so we can
remove these calls.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 1fbb74c109b9..f9c0fa94859d 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -159,14 +159,9 @@ static void qedi_tmf_resp_work(struct work_struct *work)
 	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
 	resp_hdr_ptr =  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
 
-	iscsi_block_session(session->cls_session);
 	rval = qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true);
-	if (rval) {
-		iscsi_unblock_session(session->cls_session);
+	if (rval)
 		goto exit_tmf_resp;
-	}
-
-	iscsi_unblock_session(session->cls_session);
 
 	spin_lock(&session->back_lock);
 	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
-- 
2.25.1

