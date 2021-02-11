Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC40C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 666D064E8A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhBKMc5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:32:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhBKM2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCOGfA139808;
        Thu, 11 Feb 2021 12:27:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=uwPzet92S7R8c6C4fWnQUmHmjuehLZix74TyPdaTFPU=;
 b=0hlOqY6Dx6mwGqnFtaiEwvKAJ0oWRfdYekfM7eS9ngasOLKXrKOE3GJf6sgqD6uukjaN
 eCweEqKRo8WaBN4QjscjcVQqAlkDdHL1ChRH/z9AxCgMdbnIJkXNc89T0wkFGm5cbzL0
 DTC8uclg28EB/BzAG379Mt75nCXNmr810mbdb1aVXK3vPIvHol7eHn17D6Qagws8afYf
 8yQTh9QUX9+Ju0QoVMfgebHtgn/00wz8frXQr+EAoLSigCFGyGGcA/iQwrEbNCQPSS7A
 O8BVzwdPu+PcKRDQGEOZdJSlZirLB4+xxU6Ok1BvNKr42VGHaZSqufR2lWP8v2ygPPBM gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrn76f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCQ4nI193915;
        Thu, 11 Feb 2021 12:27:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 36j4prg58e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/8+CZzJXW4pMZDw0rNHHD8i6v8pwzAQ4qoyoXflZ3LgUR4TShgwu/Ih9DR4Cj8YtcZJA2oWHWZDulpTt6Kpw29VWqLmMUdcRLO2cK+VeDXBDuqLuDnetcy8pQH9Hqf/i99Z83nlziCQqUc1NyBGJCGvYgn73yqU395fSo3ODa3/99UISyivoUV33DUwpvEinzi46JxPLllKNv4Ne3lsnYbYYXxZ9BEdLatRf+c+Al67sGcd1mIUF/lLo0mVtDuyiXgWd6QfQEGSH+0Jf/fcvqpZi9rqRhKiCIdGVocxZyTdyEkmF4z14v21yZZiCePLUEBekazi+Bz0BlT/QPuclg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwPzet92S7R8c6C4fWnQUmHmjuehLZix74TyPdaTFPU=;
 b=MWSIFAFxU97TZDiNGpgeLvGDNdkOOJwv80q/AEPQ+wRP7Wuvy9ze7bjSRCJaH3x/M13qn/mpQmBS5j1eKZRL1JS7wm9MJyFhuMIjHKVSHf29+y/DOYVkip9zmmrPlQslByNYjf3Y0ty8pU9AkJ1pto95GoCcagj2/otkPkq2vSNQi7xOqDCRF3+ybS5IunOIdVIuTXOtN7dvFj+Pg2hOQhC9az3/Lp5A/bL/e+vkuuc4s+OZqhwG+MVQ+8uDbGt/eXVoWIGX/tr43DR6CUAQyjPfOl/CvygHXbKv2I5xcG7DYAXeqfN4MJif3NKLOppXcrTqDR9lLYyp5xv9rZQ9Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwPzet92S7R8c6C4fWnQUmHmjuehLZix74TyPdaTFPU=;
 b=STL3oKDEWNeET2zhOcVR5ot0ydBav93gf1k+OVATecCy8C6STKkvDABfS9GH2kSylpbQ+5qOb3neGNRteg4aTC5UXR48JDCL3B2WzzIGDX5lH4kmahNPt69nrOt76KreBRSeijBxqrCC9NJDT83rGqYxd3rqGCVyFErE98XcDXM=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:50 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 10/14] usb gadget: Convert to new submission API
Date:   Thu, 11 Feb 2021 06:27:24 -0600
Message-Id: <20210211122728.31721-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211122728.31721-1-michael.christie@oracle.com>
References: <20210211122728.31721-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2fbfea1-fec0-4382-9d1a-08d8ce887265
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB43392238525F1539DC12CB55F18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYucBx8aybDGZ7om8TznshbFYDecFdpD70yBkICp/XJWfOqLXeEcXMigPHoPhfABX4n+l/qh5gt7vMyblWC7V8a1JEVDMOzUY89ZijiX1XC8Oh2uvdIJPtt5tPeJgJ1lKcTIb1ZdUk+w+8Sw6dx26SNr/lxdXzM8pYqazYBo9wEg2E2nfwlJQFA3N5E0ByjrRrkZ2ak8osHQa+MeQ1ik/GFjV8Q6YLZY52LtyZegcJsqBnRr1WEiwA0IhUFWnjwF0P62URM2U0vwx2we7qbAqUiCu6h6Ce1oZTECE0DFc5PnMVT4xfTeQfovrmzvTk9tJXmJybZexFELuAx+FyNcUAKYdBJsG/YQ/YxjM0zlFys9KMLP4VgocEyOhOoU4rFG7jplCfY+88U7F5FA4rAWjsd7dD0mnYtEHh84SrURdkaimMvE1bNVWhW91DAPBVjlrCmvxCLf19h28ouKncSr8rvJqk2QrgesfDdYLEg2CXJmCBJfuL7ES9e9mViXtFITuXWADvm1q/dP5cLGh3wYy8EBmWl6NX/UGd9lsmNHm9rFzPztpcnFYYA8vHzB/AX/PbB7WG+PwYnQyUYNMtX8rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(4326008)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(54906003)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NlAMMggqetPq+GXeaLG9X4ivl88xdZ/+GfHsfEDiCPXn1h84igJDwfUSvAT4?=
 =?us-ascii?Q?Shd1YwmWR8Z0O8CCesED2SjQpao6KlJUXjcLdpwLnPPM3yLXAnAYN90w86wS?=
 =?us-ascii?Q?LJUomJoHdaV6mqQPaqLrG0ddI3DMPgsy8z5s+pCK1apxOSHFLsiPbnjJFgh9?=
 =?us-ascii?Q?bAFWJdj2zHJbN7MI5492BckE6o2tBLXaNMw5kHAozu8tBdUA5lyQYq9rUn2d?=
 =?us-ascii?Q?cGkdWlorxobeDwhEhxVhP9QUE2E3KYycz6w5hr7vMSdZSwOQ0xhz5j23tL+Q?=
 =?us-ascii?Q?RPssTNS2xZ0bOZ+l7aS7y+cMl30wDBX3c7EYgkHQlOCgHaPRLqV1aa5+h+TX?=
 =?us-ascii?Q?hZh0YYxNjWoJdRdmM2wM0uzCQK4Ljs/Sof3S7RSUVgaFC2KEEklgO8SMm+fM?=
 =?us-ascii?Q?Y75GknmcvuuUom1EDRtrxY2REPZqQea8s3naVbEwVkTkMQXuujEaB6bDBcUj?=
 =?us-ascii?Q?TVTdXtYqduUpUwTKBSLL+2M7L3SHE5jwDcBtyDA1vPIEDMF7/cvbfYqbFW5t?=
 =?us-ascii?Q?LrapJH8IIlS5qN3ZfOrLBlKRmnkeJxeTOy+9tzMOGdN08OftmCBrggsz6eKN?=
 =?us-ascii?Q?+U9PCKEdRWE75bCkZOnLhPs8WvEUPKuUXz4ajz6g1zpsnhgRCQxN17O0+lne?=
 =?us-ascii?Q?0vimAjkKF49MWWUe/XPrmdidWsahXROdNAwQpqG0uPd2VQLVAVH97CZbpxAC?=
 =?us-ascii?Q?+HPdWPrP63PtsgY3VOAo04kGb9cqWdekPIAVfFJQ9Q7RNUxWrWlfIe2mJYh7?=
 =?us-ascii?Q?i8Un5UrqQISlVICb+p/lUrhbZIxS0wVpXbThHdWHwFoMiz2d2CphvJq4MKAO?=
 =?us-ascii?Q?zJrfqbE1GirznizO/jZUy9KVRR4D5qLOC4G+ps7Kg/ANPVy63Fn5nUvPEmDJ?=
 =?us-ascii?Q?eid6RRPVM81g4y6XlGXzvkdbWXsRp2hK59BruBhsHTG9ME5GAPhomavXbbrD?=
 =?us-ascii?Q?vebt5r6QyMSvd7z6hw+4ZbxDwgLyTPLT+GAsaouGuEBcYIsMCGwaKnKSTQYI?=
 =?us-ascii?Q?xDNEC4AVeCfIUssVJ8Q5iKGc5u/t3nKsP7jhjr9iLUPn9nAL4+PIcVRw3EZb?=
 =?us-ascii?Q?2lma+j/Ow5OB0k3nTlIgA8oCXIFllreK0rW1Z5mnzFJ5aZhlsEBO90Bf5Hhq?=
 =?us-ascii?Q?SVnjNM+uCB869y5lHFFGcSxBSeshM/7gUAYBKHNMOoXcTwbH1UbFT70Ed3DA?=
 =?us-ascii?Q?flpI/SjH542FVeLhPNZ0h5WCZL63qhpbMSYjItRWrmAgGh2sVkKOGWFvEwcv?=
 =?us-ascii?Q?0VHF6kCB62itVDy1TPpVTcwr3rnZ0LA6PJvlcbzvvlZvZCRxoy5lziegMlnn?=
 =?us-ascii?Q?n98nJDrikxqtdKCEGr/Xe10r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2fbfea1-fec0-4382-9d1a-08d8ce887265
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:50.6469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3Df94DS+WXKxitx623+cNfr5MfLlre0lpzW/5uQ/x0dwjE90gXovpg4fYiS3B9nzhwxvde3pizzoj69NwemMQVXYbDTGh171pLnjr1PQyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

target_submit_cmd is now only for simple drivers that do their
own sync during shutdown and do not use target_stop_session. It
will never return a failure, so we can remove that code from
the driver.

Note:
Before these patches target_submit_cmd would never return an
error for usb since it does not use target_stop_session. If
it did then we would have hit a refcount error here:

    transport_send_check_condition_and_sense(se_cmd,
                             TCM_UNSUPPORTED_SCSI_OPCODE, 1);
    transport_generic_free_cmd(&cmd->se_cmd, 0);

transport_send_check_condition_and_sense calls queue_status
and the driver can sometimes do transport_generic_free_cmd from
there via uasp_status_data_cmpl. In that case, the above
transport_generic_free_cmd would then hit a refcount error.

So that other use of the above error path in the driver is also
probably wrong, but someone with the hardware needs to fix that.

Cc: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/usb/gadget/function/f_tcm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index dcce6e2605f5..7acb507946e6 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1058,11 +1058,9 @@ static void usbg_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
-			      cmd->sense_iu.sense, cmd->unpacked_lun, 0,
-			      cmd->prio_attr, dir, flags) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess, cmd->cmd_buf,
+			  cmd->sense_iu.sense, cmd->unpacked_lun, 0,
+			  cmd->prio_attr, dir, flags);
 	return;
 
 out:
@@ -1189,11 +1187,9 @@ static void bot_cmd_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-			cmd->data_len, cmd->prio_attr, dir, 0) < 0)
-		goto out;
-
+	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+			  cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
+			  cmd->data_len, cmd->prio_attr, dir, 0);
 	return;
 
 out:
-- 
2.25.1

