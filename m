Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E071C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjAWWLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbjAWWLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:11:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F60A166DE
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:11:18 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiMNA020042;
        Mon, 23 Jan 2023 22:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=N+pmxlRd9rLb2qRFgocY7ga9Tgs/yAr7VbgDS5iVofU=;
 b=eYoDr9KXvBMUkzpf3xYMtxqVq15oNdy8XI2uHyAH+teCSzfpzoSO4a/f7KQi93QvgW5n
 wuEtvr2Zl+11eZDZVJtfnUsJBr85DL1GM4PKM478QMnJmFIrQARG5v3adTcpxqIYSsrE
 rtAU9RNIbLl/feC/urUtsObah9AqvapTGRcV5y6UDgKSNgQBxH6uvoqMpwIywdr9xINt
 gvZFjyN4TX4Z/6hCJSGDLk9M5VFU3V9XBrUqQtbgA+lBg3oVQdJDyADE0Qh/bTOqccJN
 VpKHiWBSlTECQoF6/ahx45WNKmMhhDkyEtAncbooIlSlePEt9myBOhBZOKyPL4ie2YOD eQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0v3nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NL8TxF023227;
        Mon, 23 Jan 2023 22:10:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4e42p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:10:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czaVSDu8FbmmQiEQ4IVdHKcNd0O1R77iBJU3+h2DcojWDtrL5jwKsOFfB2XT/e83pIqspIY8mQU9iLhpm+SYkSb+WokokiIJfztRQER7DeJNcxa3edmlmnYiUR1LY3rbm8iHem0uGj8bqKbcisWazuz0eGbznIhukJqxU2Pdw6efCP29Xi8Ibr0Df0lUp3KGdl97qdTckokCrdY+z2p0WbPKr9MKOmNMIfVdkcjt+/LG1aDl70/H+yfPpIFjbqFZIDWY//4sHxJUzcw62Uv9GFtvBlhU2HRbRgwHzx3gGM/b+mZBnPPHZo5ykkgKVUNsZA9M81DYLs0eFqPYjwoTqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+pmxlRd9rLb2qRFgocY7ga9Tgs/yAr7VbgDS5iVofU=;
 b=YtpDNmXuc1+dLmqR7hfBwUUxbd7MdA+0uJQ/vNYJ5AdgkQBFAPG2e2aUfhPSD8nwSoi+H+uVETCLg0tcKjvg0OvpUylFSWuMtLKYiYzJRirx+prH0dz2ne4ix8fi088mjVfe8vw7k+xhaNiHtwqYQWEYeWwS0UMjpDwMakcP4zZfgTNKjTHhfu0fnSC29YeURV0+Vd3fGcuns1ue6GBfIxg/mDPXN3BajmcpKy/132vWLrvXd12zUDFKewClQEX6HuFacxI7STz6sNOVa3jDWAarWqnj0Cs0w0CpbaRx9tpiNH3i8Hs8mDY7ODkUcgimOgJNpjygRWypZrWOGYcDxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+pmxlRd9rLb2qRFgocY7ga9Tgs/yAr7VbgDS5iVofU=;
 b=oEPd5SYM9srJ86D7pApQxASzjEUzmw02UTZJg9kUonwcFZU2ydeBTkFrXE2S/tjc/G/tf1xmIgXH8e+6s2NUbJ2JHcspceXkDjYXuOTtVGGwMrzUbxQ/ChQZzDd00CET0kZ4mUk+rBNwNovfksq82w9r20EWTlX7aeHsghcScrU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.9; Mon, 23 Jan 2023 22:10:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:10:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 02/22] scsi: Allow passthrough to override what errors to retry
Date:   Mon, 23 Jan 2023 16:10:26 -0600
Message-Id: <20230123221046.125483-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:610:54::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aaf31f6-8502-4666-2519-08dafd8eb134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ghofE3lGKZqG6l4HwkR4KpgAtGWuyZKfd1RwNrNAdAGKCLZZQGAFylvB4q4mp/ExP5ZoNSerULv36qMl8DEiikv7Q5kAqZr1JW2YrDcRvb59iKlbC/rioRU/rCJg8J1cylOfxR+dRCuJylKbWqNtJN1pLAWpnqAANbzFO2QnG+mPb/R5Qy7dBoOg8iGmADJ5ijr8FTtFwrOWwqrF1hjVZZxcpxODP01Tg8nOzL7PVsD78oYCZy+7Kprz15ndHrQ4zep76O+WXKcnXt3DnOsbZ+nuAi/MUDu9hWyBqcCQ+9uDKO5pboD6xPm8NqZJtG/AaZ80WZBI8UG+LUEZ0rxLRV0uIKgYOhCzo0d2KlkP+OCyr9WprSjVh4gUsp2l6ICWzbtvVOT9S19wCJHCtFijCE2ntv3Sv085nyxDngfQr2wb8C0OS+m2c8ls25g+iMhNWcM6cgUe3m77y0sajWNTAe4KRkmk+YEvkR6ip+JRtwxoSA9q1ukt3ED0BLuhyaPpkZljjUxYcbctaDW0pnpPSx3C1nBmuhl7+3psz3qWvYt+YcoJAKIPDw3s7ypnElqGLurTLqrpBdLcLLw939de9xflEEuCyNsk9JD5ovIHr6omBW+bOnfK31tk0JSz+aLf+SldIvWb5Lj8CMIevZF+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(86362001)(2906002)(8676002)(66946007)(26005)(6512007)(66476007)(186003)(41300700001)(4326008)(2616005)(478600001)(66556008)(1076003)(6486002)(6506007)(107886003)(316002)(6666004)(38100700002)(5660300002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lux151NM6nos+vlQlp49TIgIMO7PrMBzWVNiD93RqLSVcTZ9XFME8ve4M1yK?=
 =?us-ascii?Q?m+8xWv+huFdmRclO9X9Mwm/4cCzhi+3XcvslbSmkGMWCaU0yIagVP5OlThFq?=
 =?us-ascii?Q?c2iQlZRoQDeILwKloAJjBHJG1AiFjwWT2iKa/0Y3aPB28ZCrQ6RGqxvieUpg?=
 =?us-ascii?Q?gWzwQ44TzN4nHe03rLgrkl5jjU1qwIJIArhFSzenvj8NEhVCiRxijQ/3jyHr?=
 =?us-ascii?Q?NWHRoa8+Ca+Mg9EgdggRQE4Zo4aXARSrdLtbm8MT7TT2kpt9zseFjYHbC3gc?=
 =?us-ascii?Q?VAOrO5krt2mHXx/vw97FUcqTxM5Frp0dLm8s6FW5hqe4RQ3NjJn4WMkfua3s?=
 =?us-ascii?Q?sLJwgWTTxbdAeIzwKwtzGbmXa3Lf6eSyzJRDtvQLze+LOwsh+HPkBLz6Eq7P?=
 =?us-ascii?Q?CBB5WuveXuvfxQDDgjqpUc4IWFu2rqxxhGX3dV87zqLvxAi6Ow4BeYjdR/rj?=
 =?us-ascii?Q?HsIxp3B/vaZAiojo2USk8En0ORu+4pnH1NPvHtXHmFgrOUR5IOAjZZImvCe/?=
 =?us-ascii?Q?cFSALplgsCh6kbCN9HDBSNdqLT5TAbgkxEORtzJLfcsSyODI8A2n88JMbi/W?=
 =?us-ascii?Q?kIDV2po4gQQ7ZmPwPtJ+u79cl+4MuEGHxf32zPrZVwwz4JIevPKa3EDkTP7S?=
 =?us-ascii?Q?3y5mi1jRL421CeDj7A/3MWtgka1uPtnsRkqTRPT3fcZscWzlZSkgtUXo103P?=
 =?us-ascii?Q?Xd3FQuCUl0j0INYwfjkYJqugSqRWvjEZ691w60XFkOr8rVaUrp+dxxpKlW+C?=
 =?us-ascii?Q?Dx3d/xnSOq7hpLZB/a5MuN8B6MWCqxkre/dxO+JRgc/w553AaCdNtK/3C0tb?=
 =?us-ascii?Q?egMZxqOhgqYN4Km3LSAFquu+3Um/wXd3ULkehj+y9ofCeMlxyWX0IRIgiUXJ?=
 =?us-ascii?Q?NnAkqCA3x3nnlZiMTQCAaiWWAYCcjulNd4KVXkrSYavLWjV4/0bLx2pHXqrR?=
 =?us-ascii?Q?T6UNR5cbU8hG7l8MG6usf7rNVIap9fOg+kqpr7JmFVYQK3phww3xfDoy32J7?=
 =?us-ascii?Q?WYbyPW+Z5NRLShyMxt1W63DEV/UtYf7gT5uC+JfOQjlNpln+66WuBSKllwY9?=
 =?us-ascii?Q?ij5dHFL1jTkSgbUscygliXGZ0pZ/FMX4j5uFtP8McSFoZpgS0rVaX1ru/KBH?=
 =?us-ascii?Q?o+B2lwC08eB9A1xR6TV5SHBZGCkGV3kIrXCDT89a16Xeoq5Kmae6yu1953Po?=
 =?us-ascii?Q?gJXjlKgyHu/9M1PiBjKwbisees3xTOmSvtmQrlM2HQeG61IMjG/81JEujD3T?=
 =?us-ascii?Q?GcvsFioElQxHjOtb/JB/Qg//6IiipAo8lJTBCpn9VnGz/YqKo/fDVeIJlozL?=
 =?us-ascii?Q?Ssvdnj1uHX2x/ey1+u4oF5HzMSMjzZmueQqdSkH/77B80HkCfPoQ+qSX3w9v?=
 =?us-ascii?Q?u4w5WPh3uG4re8G4Zj1Zq8x+9z6lwCb5EA5h5cxOh9k9UL0x9qeL7fSzKjG9?=
 =?us-ascii?Q?tUigGe8uAa5Oe60R6QBs6IrExNK2yacKdfZa6eqT6zwYn05S9kHgGx/DqgNo?=
 =?us-ascii?Q?NUhGlNNQ9gL1FisWJ0HWshjtYq9z+V+EJ0FU04r83n328B491Dikp4QsiRQ6?=
 =?us-ascii?Q?xi3i0nW4A+INQC2+eeTAdvzjiSQqzTjw1p1uMbrGhPpBTdnw60FK2H79+ZKD?=
 =?us-ascii?Q?zQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1KV7S4nD0GIc8N/yQiGcV5dzqVwX91r3tVgM5nRuMRrblAM+NtA4Erp9edw0/zprQB4Bk2+yb68CgZd+nu94PpzhmD+GbK9vtB53r1kSwltrvdMr8iyutQT+sHtKZQoe3qDgVJ2tw6aFpfb589iTsUFCAi9kv/xO+S7SnZ1futS8ZBA0osGfzoThxfGiFc4S4iojUt1mD89dhDsDZderPf9eptO08jDMWZV2MmtiaOEsLI+knM/3nlvSUbrXqJHjbBOe7pCfGTt5jr6zyhOpEGf6xMcKrARM7m8qMbV/JAwYvZYmUpekcI8l/s+luvbz323K5v2ISCA915ma/uogsAlupOnCJIhp9LCiHA2CvAbj1nDCIA1g7ofW/nS2+RBnLtISAHl8PatyEkfrolmjZFyBuCJW5htyn82K6lDQnGiZWRnMfSDctt9KoIYgeB6kxH2UMaBIUBR1EGhX2HiH2saXeUq5ubpAlA3+hL1xnfCaupqUR7V1rD8txT2mYExi+Nga5OC5vRNP+k8VXFPUtT9E9e4xqG9ynJm6m306Nla3fIClO27CTPQFaumcNkGUNulnTryh4AVg7m6Yb2Iwyyx4xyKQxgYmrGAg7bjqFXIDY3dB1yIfwYgecr2WdK4ED5TK2q0Cm0uUfJJO2FT1+j9cERa+02D2qNJ7tFDB6oUTfKQdmsWMaHBclBd0JWhv3pdVlYXPJNG0nWyClEkWlvGjtwlGSCBrZKhnpLxZH1QQQ6xzGqKUHwmqqGnzspot2EbKC6mnhtbUHnQmWWehyi11S9wudKoyw/z1TF4D6BGonWOrcsr5p8+cXHlLSE/v//d+JA1AWLeWoJdVuaOkBYvdTaU8eZx9/799RWgTJSkLv45t1xfmQrMFjFgxCEh0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aaf31f6-8502-4666-2519-08dafd8eb134
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:10:52.7608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjkJNPV0BpzVHn6CRBsUynCx37hAr1rwfGNNgTdsAinf9Y+Vk4LNHEg737x8zRt++tDQE5WsjEdv2C2eowgKDsUTFtGerDgp+xZyOrMR3l0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301230210
X-Proofpoint-GUID: WLw6I1B3XFGV9BJ2E2T5NpLT-wlA16LN
X-Proofpoint-ORIG-GUID: WLw6I1B3XFGV9BJ2E2T5NpLT-wlA16LN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For passthrough, we don't retry any error we get a check condition for.
This results in a lot of callers driving their own retries for those types
of errors and retrying all errors, and there has been a request to retry
specific host byte errors.

This adds the core code to allow passthrough users to specify what errors
they want scsi-ml to retry for them. We can then convert users to drop
their sense parsing and retry handling.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_error.c | 80 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c   | 10 +++++
 include/scsi/scsi_cmnd.h  | 20 ++++++++++
 3 files changed, 110 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c68db2c39016..544bd97bbf3f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1830,6 +1830,80 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	return false;
 }
 
+/**
+ * scsi_check_passthrough - Determine if passthrough scsi_cmnd needs a retry.
+ * @scmd: scsi_cmnd to check.
+ *
+ * Return value:
+ *	SCSI_RETURN_NOT_HANDLED - if the caller should examine the command
+ *	status because the passthrough user wanted the default error processing.
+ *	SUCCESS, FAILED or NEEDS_RETRY - if this function has determined the
+ *	command should be completed, go through the error handler due to
+ *	missing sense or should be retried.
+ */
+static enum scsi_disposition scsi_check_passthrough(struct scsi_cmnd *scmd)
+{
+	struct scsi_failure *failure;
+	struct scsi_sense_hdr sshdr;
+	enum scsi_disposition ret;
+	enum sam_status status;
+
+	if (!scmd->failures)
+		return SCSI_RETURN_NOT_HANDLED;
+
+	for (failure = scmd->failures; failure->result; failure++) {
+		if (failure->result == SCMD_FAILURE_RESULT_ANY)
+			goto maybe_retry;
+
+		if (host_byte(scmd->result) &&
+		    host_byte(scmd->result) == host_byte(failure->result))
+			goto maybe_retry;
+
+		status = status_byte(scmd->result);
+		if (!status)
+			continue;
+
+		if (failure->result == SCMD_FAILURE_STAT_ANY &&
+		    !scsi_status_is_good(scmd->result))
+			goto maybe_retry;
+
+		if (status != status_byte(failure->result))
+			continue;
+
+		if (status_byte(failure->result) != SAM_STAT_CHECK_CONDITION ||
+		    failure->sense == SCMD_FAILURE_SENSE_ANY)
+			goto maybe_retry;
+
+		ret = scsi_start_sense_processing(scmd, &sshdr);
+		if (ret == NEEDS_RETRY)
+			goto maybe_retry;
+		else if (ret != SUCCESS)
+			return ret;
+
+		if (failure->sense != sshdr.sense_key)
+			continue;
+
+		if (failure->asc == SCMD_FAILURE_ASC_ANY)
+			goto maybe_retry;
+
+		if (failure->asc != sshdr.asc)
+			continue;
+
+		if (failure->ascq == SCMD_FAILURE_ASCQ_ANY ||
+		    failure->ascq == sshdr.ascq)
+			goto maybe_retry;
+	}
+
+	return SCSI_RETURN_NOT_HANDLED;
+
+maybe_retry:
+	if (failure->allowed == SCMD_FAILURE_NO_LIMIT ||
+	    ++failure->retries <= failure->allowed)
+		return NEEDS_RETRY;
+
+	return SUCCESS;
+}
+
 /**
  * scsi_decide_disposition - Disposition a cmd on return from LLD.
  * @scmd:	SCSI cmd to examine.
@@ -1858,6 +1932,12 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return SUCCESS;
 	}
 
+	if (scmd->result && blk_rq_is_passthrough(scsi_cmd_to_rq(scmd))) {
+		rtn = scsi_check_passthrough(scmd);
+		if (rtn != SCSI_RETURN_NOT_HANDLED)
+			return rtn;
+	}
+
 	/*
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index abe93ec8b7d0..0233623ec245 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,6 +185,15 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+void scsi_reset_failures(struct scsi_failure *failures)
+{
+	struct scsi_failure *failure;
+
+	for (failure = failures; failure->result; failure++)
+		failure->retries = 0;
+}
+EXPORT_SYMBOL_GPL(scsi_reset_failures);
+
 /**
  * scsi_execute_cmd - insert request and wait for the result
  * @sdev:	scsi_device
@@ -1126,6 +1135,7 @@ static void scsi_initialize_rq(struct request *rq)
 	init_rcu_head(&cmd->rcu);
 	cmd->jiffies_at_alloc = jiffies;
 	cmd->retries = 0;
+	cmd->failures = NULL;
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c2cb5f69635c..e410f485a409 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -66,6 +66,23 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
 } __packed;
 
+#define SCMD_FAILURE_RESULT_ANY	0x7fffffff
+#define SCMD_FAILURE_STAT_ANY	0xff
+#define SCMD_FAILURE_SENSE_ANY	0xff
+#define SCMD_FAILURE_ASC_ANY	0xff
+#define SCMD_FAILURE_ASCQ_ANY	0xff
+#define SCMD_FAILURE_NO_LIMIT	-1
+
+struct scsi_failure {
+	int result;
+	u8 sense;
+	u8 asc;
+	u8 ascq;
+
+	s8 allowed;
+	s8 retries;
+};
+
 struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head eh_entry; /* entry for the host eh_abort_list/eh_cmd_q */
@@ -86,6 +103,8 @@ struct scsi_cmnd {
 
 	int retries;
 	int allowed;
+	/* optional array of failures that passthrough users want retried */
+	struct scsi_failure *failures;
 
 	unsigned char prot_op;
 	unsigned char prot_type;
@@ -389,5 +408,6 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags);
+void scsi_reset_failures(struct scsi_failure *failures);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.25.1

