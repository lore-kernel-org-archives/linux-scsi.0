Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76748EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jun 2023 07:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbjFNHWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 03:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbjFNHV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 03:21:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D312965
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 00:20:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35E6jrND021335;
        Wed, 14 Jun 2023 07:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=a5C0CYeBLfticU0+IYIu3CyY2cvtbRlGSH4pbzdNGtU=;
 b=tnsk/O0nDGDwe/4evU0MnJkL/8mWswtOzSDnbku8xjAEEslFIJG/+joT8ruOWheCYc1m
 ytAWcIYtQX0BaPsYhcg14dnvlxR4PR74mGN+2zum2URVke/HlYc6Mxt/dl6fALMo268M
 d8LAAd2+lr7G3U9x0ygJZJVL1jVcWECuqlV2I21ey3MHb9Il+w9NMNXDoq46MUnlMEEj
 Nu0X79YqLB1lPeJB1SIJoADDiTP0GLQ+P6jKIbd30wfkHGNkbD2fLYP5KJx+NZcUy5NC
 eCyxXDfg/pNebERFQkX881F6n9MM3wRdIpKgLD6qAJREMWJUZOSiS8NASRQxr6gS1vAR Tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3evqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35E617xO021715;
        Wed, 14 Jun 2023 07:17:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm56caf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jun 2023 07:17:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTbfMjEy5EephpUPLq+4u9diCD03LFfumuyksochIEy0IzsOIdJRyoL4PpIwrVvMgfpzfcfXx2Rp9Dp0tTiqZaPuWhnCU6dfP0i6jCFibwXB30j/4/V23bshIxs+z9rfWELT2Qt6v2++70/XbIKlIw1obGv5ftdv0goJKzElNDvAFjkochg/Csek6tUcLJxDv1dRnqwMm1Tn5WxZoD/kyYyHxkOzutfjbAKwTp7ZukvX324lsBw7gN9Vwde36wl500LGIKxZHo+DI8u8U7d5S9W04JDTomUR5WIdlc2lGy7Q7HJjKMikv174xTNFBL610kIOXGsjfv5RjCFrhYcD2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5C0CYeBLfticU0+IYIu3CyY2cvtbRlGSH4pbzdNGtU=;
 b=FSGdUVJFTVcO/YOBzIMdoNjWnoaGg+bdWKJMX5zoA32aF4hptWwuVfcXB1qTqZsFqtgrh7dXpzLiTX555P75McRPQfCbnZ7t39AUnUPrPLPY5XpeAUYpruTDxH6A0Cj4EkiCcTssDF9Nyb2sZubGba/o2mgavHgq9NSFDjPdFvT9LAP/QCDskBghx+Zw6z2J+EBtOxh4aABnZRTyVOtP9AufhMUsxNrcN8Emhbz9m4GHX4KBm9+aDyhCRhiH3t94eyakvKffunuzN/aE1x6C1kYnoJNw9FwfmovEA5yzWXGTGq9XSD/SWIat2r5qhtVqXagBW0VlnVpYxqQjlO8X4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5C0CYeBLfticU0+IYIu3CyY2cvtbRlGSH4pbzdNGtU=;
 b=W4tOkK0VgjQKPZKEs//SpP6fU9jE+Kq76ZUYjTlRgbRTL7G8hccKjVjNfdPy7AJouX9hvLVkL3RiI1tXi7qonZUdUk/e1iKfdT22Kjg1DNn9XIOPRLbV0yojofpcQrTWIX247c/6Hg61txWEISH0H2QxASlgEbRLa+9PjUqatkw=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SN7PR10MB7030.namprd10.prod.outlook.com (2603:10b6:806:349::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 07:17:45 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 07:17:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v8 13/33] scsi: rdac: Fix sshdr use
Date:   Wed, 14 Jun 2023 02:16:59 -0500
Message-Id: <20230614071719.6372-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230614071719.6372-1-michael.christie@oracle.com>
References: <20230614071719.6372-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS0PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:8:191::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SN7PR10MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 1821f5b0-c3a8-4ad7-916a-08db6ca7731a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n8t6mwSaTQNfRu8KewlUg/PXlCpJTEzVkbnRIRngIbrEAaUXm4DkptyYItU+gBi6glTs5nivk1kHTj8v2td9AyplrZTnuNvUzsaE5LC7tKAjdgOtHCINz1aaS7LofEro54RF5Je+m4dN3G7aEd84aM5n9XEZokx2ah+DSfygMMy72a1YIcFS/vn2J3wW0L8P6OebUxLr4+67EBeXVs5CIlcYB14gDr/Qw4YMbcaTKoQQvI/LfvIYi2RFY59hhMHdGAL6zkt+A2ZU4W8ULRPK78GR2CoDec399VfGuEIsvgIDcuyxnxtpolZl1XCaMhodvFSCiLZk1C0zR3FP8uaMrCRGOsT+1WFCmXjkfIwnhAZCaBFMDNZlFoGR+jqS94pAo+e5jBgmGrTK1VgtRw2y6MDh8Sy2lAJVIHTJfx5EKhC7435RbMHfPsIMh3WnD3+TNzKphjteDfb3oR8R7R8vJA6XwxXseThfKkM7XjFmFRGdir7GCHTy6LFFc14JZUph9Gre7Zs80n8X/mL41+ySj1H4l2AW1q10sxKolGM1MDls9nas62FRa2Cy0h6apRK3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199021)(66946007)(66476007)(66556008)(478600001)(5660300002)(8936002)(6666004)(4326008)(8676002)(36756003)(41300700001)(6486002)(316002)(38100700002)(107886003)(26005)(186003)(6512007)(1076003)(6506007)(2616005)(2906002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nHBF2ZyKjk5BZ/Al6GC+3Bipj+y4iqtsHbN7mVbUIf41DKmoSlT+KGPIQwYk?=
 =?us-ascii?Q?gmiaCvS5GMVoR558ZMkBPBEdYN9Posx/gtlOGzo0vH4SShm85yGgMXIOB1pj?=
 =?us-ascii?Q?nGVpQ2nYVkRNvt/uFbpK2kS6RCcjhFj70QVa4Q5hBODmDVlGbRcuOIAm1Se3?=
 =?us-ascii?Q?XwBsv9wQpbBLuHK0OhPsgJsGvHBAz6MnI3Ct5U98N4NPvYsZcw/h8guOUtsF?=
 =?us-ascii?Q?zHF7bgK/2v+YLfFVE4hBMddDOMtbmXmQ+kOQeKejy0VN0IC2C3sZqZjcVdRZ?=
 =?us-ascii?Q?JaiWxWka7STq7qb0yNl1oQDIvf4/pGVkhBbOdywHrWj8edG+JzbyiRmAy/78?=
 =?us-ascii?Q?PUH7xEakSqz5Qbgc65wQQPhoaqzH2LIibXkTL2bykVdNRaaZWI3zilIwE0an?=
 =?us-ascii?Q?2ylKCsfNXJjSRbYA5+wQ87H1z4yN0C1Vo8lYvFeGOarWj4T3RfwX6lrjDrWW?=
 =?us-ascii?Q?bkVOlPNuu4c5o7vVnu9D7j/HpSIpdvjmQiBXEMlE4jf1HROcTu38k52urBWJ?=
 =?us-ascii?Q?shTNQ7X1TT5j2iHyXvvO6ZTNK0OcyFeH3+FsNkQJPLGz2QnZOFihNSB5+1d5?=
 =?us-ascii?Q?sS75KuPtwUx5CcROWarL92HeaBHnUMVwjnn30xDk8H4WF3kYmz9K0YHX9PAB?=
 =?us-ascii?Q?nYiEWVP4YXA4ulgP5DeIy1fSo2r3/R2WZJryFbwpxVwcB5gg+sXutLDWex4q?=
 =?us-ascii?Q?d4znU1lO/V7lo6Vrz3+7LqXYrCE/kXGPwmeszAlN8n8FTQmPOWK6AB7nM4Q8?=
 =?us-ascii?Q?t8QvqzxxzWIT/GXgVz6F32VKu6aKoUcHagw/6lGisk1wDSV7hHr7HNfQHl46?=
 =?us-ascii?Q?E0LYRT0gb9rM6Ms128SNw805YDUSEgsy2KbQOFPPKSDnKEAw1yAepb1p/yV7?=
 =?us-ascii?Q?aWSxnCuDWdRFEWYRvG84lH1CjOF2Le5V4+ZA/TOi73yzuPcV4XMgmDmE7sFg?=
 =?us-ascii?Q?0ELoBNPrXgX0Y0hlr7zYf6OTKUXqqbWU8byA7W4ObNgq1FUzfyc2vTFm0OQQ?=
 =?us-ascii?Q?xs4GdswNEaCs/EEYxs6jFfm5mkgkdTp8wihM0to/SjwIrImnOn/qLsjqYg6A?=
 =?us-ascii?Q?hmNbJm3fpR75wqdlYuccBz/5Mk0hgl895XdCEq3A9wS4W1psXK1Obrf2z7fL?=
 =?us-ascii?Q?dtBfcO0mDjRujlHHiA/kkbLDwHuA06wK3BFAZDB1OUmdqmRpjclL9NZxhvMb?=
 =?us-ascii?Q?S2XdTYNr7Eh0SyKrcdEBT3Q61XDTiMY7dozhZpvAEO8/Px0WxZhXqekU5N+r?=
 =?us-ascii?Q?dxsqVsqa/LwsKCjJNFjyY/zklZssQ9Ai/k7Q+54amV9xApepqW2ofhy82jRd?=
 =?us-ascii?Q?NL5u6/QlmAeW9ClrY8x1+yC9ae4Q7EajZDAUCNpNRsqyg6ciXndhPSLj47lI?=
 =?us-ascii?Q?OJNCIkpfsQxN3Zo7tE0Lq8o782iLO8lGPfRWFD+0nsByjm55hVlMDKVU2U8s?=
 =?us-ascii?Q?5ZkDUkHmR7oGRoakfg596FFuvd7YL0vSbj8+VMC8mBLFLgpT2mgU9jKgWbel?=
 =?us-ascii?Q?wHvSL/XmdHV0ldU9mKRDpj3JnF46G+qIpLzUSpeBCXuUMfJO6b/bYmY5kqEo?=
 =?us-ascii?Q?6fyd+1cOAE/gGNu1nzztDbOrPKIibNeZBEGYxualMzMEjqVLtqiuWOXStfQd?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cPBG0C2yZW2KbhMPPGlSS+YuieYGhtH9yuUIEBHUKpTJFhXhXGd8gxINhgePVZRCc54yRSckKo7T0AI4Dz1golWeOWFzFzdUr6qsKqY3tK5VbdOGJ41sVyAdv6u1H034B/qSypZ45DkrK7FWsn+h46Z+nSQqW+abE5QXpnAuvSGklT/g74GPXp2wVNS7vJLW1gPekL0v1/9IEMwmACVXFVVGvzKDNVh6N4Ri6nRrooOT2JrFJQPfwLGWlkZdcCCxjOkRL7tkS8YRYQyJsdWtwdYg4ZpQnHeGEb+T+4DgKhtjXT8e96itscRNWlGtZnKG+HUCIWiIntwqncKfvW27NDRyqjXNjqnuLq78VM+Y4momIvUZ8H7tgk9gMzs1BaZcXBzEvtQAs1RSAbuQ4I5OJfCYiKHKSststouBVxyvTE+aHAhX+d368jOYcx0bqEugqQvYyWj63JcyIRwRVlounKeDLz2lqtSWHcd99+Qf7sMZZdZclQPdzcYPD2R1BKesXiv5VtygIyj9z3yaQmObKYLvyefQTovjWJQ8cJ4uHw4JP+GhX9XhWFndFD90qJD+IUR433V6hNSkiEXnbaolfEL5LbXwcogNe0kiYAFfEwQkKSYvA2N0l9uBQ0JFGCYnUy0pyVObb/zASEHWZ+YR9UBqeX1rWvT5pjpSwC/zFx4swmiybKoS13e+nQdpHmi22ElejBweMNxr7fuOFZ1q8dX4P2vvam3LqhLVA2akbUYcJlKSKNsEAXs3f2U9DL3fT5hDPDMDd3/+xUkSAUCFsBb7nULY0pmBxCHHFYp4lUi26p0p/wZ+DH/zQ4eAkAAw8FIkl1+xadcfKW2hzdnB+D/IZWkbR8Pon/HKfZ1oxGjdJv7H+Pql3m520eogigoo
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1821f5b0-c3a8-4ad7-916a-08db6ca7731a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 07:17:45.0582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yj+axT6QOhz2wsO95CCEjMYCJDmHxyJ8sEjoWPlQd6tyN9YLRHlDgQPWOTx19CogNQnEuIs5lleRtRkerBkds5cotjDt+/Ko2ww0Qy+247M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7030
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_04,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306140062
X-Proofpoint-GUID: 32YbnMk4rlUYreOZYIwwfVf1weobomhZ
X-Proofpoint-ORIG-GUID: 32YbnMk4rlUYreOZYIwwfVf1weobomhZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
can't access it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c5538645057a..cdefaa9f614e 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -541,6 +541,7 @@ static void send_mode_select(struct work_struct *work)
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
 	};
+	int rc;
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -558,14 +559,18 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
-			     RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args)) {
+	rc = scsi_execute_cmd(sdev, cdb, opf, &h->ctlr->mode_select, data_size,
+			      RDAC_TIMEOUT * HZ, RDAC_RETRIES, &exec_args);
+	if (rc < 0) {
+		err = SCSI_DH_IO;
+	} else if (rc > 0) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
 		if (err == SCSI_DH_IMM_RETRY)
 			goto retry;
 	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

