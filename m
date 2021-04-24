Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C42C43461
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6999261009
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhDXWHQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:07:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhDXWHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:07:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6RGQ124454;
        Sat, 24 Apr 2021 22:06:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=E0xAxkZw2zDna6WyY4IvHyFUhdsRoY3UrA5Ng53z17g=;
 b=jIb8LHv1Q2vGiHelNfv2CvJLAaAThxBdqMbL+0veyg+GEJ936mIbXIcusW+2CvdvU382
 K0N5nWu9H3YayboUzv/DXXaQ/kLi4nnY46xcNZpP6P/ZI5lvRN0pvAqWK650usDdpYEh
 xLyrJwoyrLwXseE0g65sFjTpxZkDjKe7ZGv+/q6a3bz1UKnHq4Q/tCmRVN2wLMebd018
 InDL0rqNgnbQ7vpM2awp4KQE5FZgkHEwe20mMeEGAOECCHj2JbzxtDbeF37mncRLn6fs
 9idruzc3TbnNQYxOgJaq4QFmEmpp6IxfrLTvvP7DquqG8hG6vP/z8pkpYK2pB1dKw0x+ Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 384b9n0shp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OM6Qla143191;
        Sat, 24 Apr 2021 22:06:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3030.oracle.com with ESMTP id 3848et2a85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:06:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkV5/2p4fLiiEwsbBhqxSlrmiyekMeVaj53A+g3Vo4XkjqBcJQKRWgr1BjhvosHL2VdaR4Ek5jukyhlzRcF4fQLjkZDoU4SJ6p1LWBC/tnEAD05NB69bfxxk2qfcMI4B4vkTjvdwkssC7SYaMWt7PIkSm5XXU3iyOdXxQh9D8KgC/KHdN3KDJHTvZVcXgIcky8tdpXqqzEfp0GZdSagW0VjzZQjfU6G9obwPLV1e/81BJJeR0IL2+6q7Ysn/SNvWE8MSPhyjZBJqKOMfXXHd0Ig2uaTv97yAEVmc4HDEocP1aNt5UcXcOgdsnxmB5a7oh74EKBGVDPsLRSLSoUf8+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0xAxkZw2zDna6WyY4IvHyFUhdsRoY3UrA5Ng53z17g=;
 b=GRa9UuW45ARFquNZLIla4w9kg+xr3G86m0nD6tOhbZEZbcnG8hVZY0NwuJgGhugs9D8FCMW5YJ5iSLhEQ9kXruGVqUP9aUxy6FvcDGlvHWxSOFw0+JiieVKYUn2XOEw2XDl2ngcDuHklCwRaSlgk7clXKo5fjcCRDdXrU4PUxFXobevX3BfoBRHVbBJjljLvvrlqRymLezs4PTqNgwy1+KLo+iOkEoI8MZ/tQeMIEI5/roXJoDNqWFrmewGYE/rNHLSrVpVp/BzQ5WJEhbYFHN3eedni0r3PD76WLc4mKbPkCWKXvFdtRc0PIyfFbps4ZJleaaZbT5M4SoPok7d9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0xAxkZw2zDna6WyY4IvHyFUhdsRoY3UrA5Ng53z17g=;
 b=KdBdZHEHhXdEHCs/VVXXUaOz/j6Ap3lt3Cen45XrfOpdbKotOViePVC0Fpd9u5LXN2uUxuflJTPeo+vbCaJmhbgZxBNLvvy+8VlN5/0WMo4t+E65sbXuuw4vq5BBGrcoJiJqbHi1MXzt17ZazOnuvIaU4Alo3A5AfJ6kENykU9g=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3317.namprd10.prod.outlook.com (2603:10b6:a03:158::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:06:26 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:06:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 12/17] scsi: qedi: use GFP_NOIO for tmf allocation
Date:   Sat, 24 Apr 2021 17:05:58 -0500
Message-Id: <20210424220603.123703-13-michael.christie@oracle.com>
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
Received: from localhost.localdomain (73.88.28.6) by DM5PR16CA0044.namprd16.prod.outlook.com (2603:10b6:4:15::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sat, 24 Apr 2021 22:06:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49b0a7ef-f357-4eba-d0ca-08d9076d3407
X-MS-TrafficTypeDiagnostic: BYAPR10MB3317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3317D5E10635330F1FCA184CF1449@BYAPR10MB3317.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZsCCmRlvcQa1wbwbtgKKeAP5aHT/4JuDqYAIokQ4ualRk8CWceGb8AcZ85g4SWvO3YsAmJO60V46TIKcEJIDSvPsQb7kSUADW6Vby/XsARsMUDow7xJmzWevER0pK+eLlcOQQdqRf6PPPCjoAyw9Z1Mw7s9nWwDjluiRcwJQkZopHKf39Y1KOKWyNeNYmfU8b3TMSOrS4BD0mov5FSw/fJ54ciDAc/IQqXSVBBiHs3VFi6nF8OBPebXjEFE1AzTgIelr78yo+6Jv/D+v8DiYP2aWiVydrSGJs7cyMV/cosOknmQTmZgolTCB11w6DnS47tb3ft7M+CZlQaIY/Ww4HCHS/jW07q2s5pXpsF4rODzA8mHNmIQl9WX0zliXGkCuConb35OtyR7Sk+1uZOAfZnCB/YidFF6tdFcZ5gjMJnAucEjBOBE9kEoKVMZHWLh6q3w1VbA+iFQEQ48rl2HAQ+m9z9oSsVK2mO/IRmIW+K7RP5reDazupVzeVo3Vw29PFgK4sgs3l0Ae4FPMlLraMUmGfedqQQk9bT2kIRDhY/hgXwcp4FTmEN72crxHScoJQpTXr+LdZCHUYDubr0MlipPTdB2LdpA588Elc5wreEDx0sFJVwyexf8Bl/lkjUdsW3xUPbqhV6HsgZ+ANYfqap/SwKb7Klj0O0Ma+4StZHHBTp1w/tohEZpybdWpKp3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(396003)(376002)(39860400002)(4326008)(6666004)(1076003)(36756003)(86362001)(52116002)(478600001)(83380400001)(38350700002)(38100700002)(8936002)(5660300002)(26005)(16526019)(316002)(6512007)(8676002)(956004)(4744005)(186003)(2616005)(66476007)(2906002)(66946007)(66556008)(6486002)(107886003)(6506007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YDqfNwDS8ey9HAxXkjeDdM3gwbbQJ5SSbItB9oAj8QO7lrKREwlJCPQxKygU?=
 =?us-ascii?Q?gPQIP+JoBozEJAjgIZS7SLD26c/VWtXKqV2o0yIb/nnKfbM7ONxlozmmA4Du?=
 =?us-ascii?Q?n+XeB5jNHEL7UtTNDBy1oeZPXIFaSmffLPy1gUGXVhmVOoIqyCWlRwexndzR?=
 =?us-ascii?Q?JmsCWVFS4jlBnRdC6Q5f0wZy26WOQpjksLs6ki4ipZ2RZWHA0gn+rOzkE70Z?=
 =?us-ascii?Q?xxEng1yXZsax0A5zPdGuGxzv3d/VurUuQ2SQg4urr7RBmufM2m0+v4kZ9Ffw?=
 =?us-ascii?Q?Wfwyu/fqaS8L7aK+9ot6XHDH6uGmTZTcZOsVxxZDSxiFVS2Uh8vLzy+fBQgr?=
 =?us-ascii?Q?43Gc50asn4Q+pwqM2bttE6K0cAnalGorH+v9MJwaLZXQtXe/c1t5AMdFHNmh?=
 =?us-ascii?Q?LyDSYF9+gIN46ndVymnP4czUSGK/iW1hBMEVXCW48VZVubwC0BJNZRdK8q10?=
 =?us-ascii?Q?hD4PlPA5Wh5Xxy2A8A1H5GJvbXuKViZXy8WFCbpmLISAnz7Vx1wPHHiFb5wI?=
 =?us-ascii?Q?ZUrpxOCQJ1MeNcVlYE+Xm2jU7m0wCUq2gFWIlimSDWBbJLmNFcs4T5KSNh8e?=
 =?us-ascii?Q?6KBzogFS0Gwre2qZFR8PiT4Dp4AMKaNy7n/GeWZ1FxvvruMtJhmmjxa03TI7?=
 =?us-ascii?Q?XU4LmP7MMh1j44Bpx4Tu+ctwujR/E2bKw3Cbeuk195JPorf5NvA5L9ye94oc?=
 =?us-ascii?Q?+PofL0EG/OVEIRVxSC7aHdTvWVrZriMG5mCnYOLPtIJ3X08L4U0+5Lk+B7XV?=
 =?us-ascii?Q?oaGDwFW56LMuUMawBMxv7RqKLP3/FnmGEsl4M1U4N27sbOCrWkiOKfSA74gK?=
 =?us-ascii?Q?ps9xHku4xalmxyd/4p0kYdLJjJyE9HgJYci8IvUfkHuE8zA0B+Tqq4TQM6ky?=
 =?us-ascii?Q?PFjgN+3/ypnDGwKPHddL8zi/7BsLFNU6Rai70PD+op2Psep74LCMhzmYQk/W?=
 =?us-ascii?Q?DWM8tiyPJ00yBuo+NafFc94HByUJNwcfxFi2vHk1+vCcflUlWKYYX1oYuMaf?=
 =?us-ascii?Q?nWu43crApm6EIaqRQ7wyDmLdTZwvwpqvMjBs5JXB8UTISZ7M2xTCj1aTG4V3?=
 =?us-ascii?Q?RPUtQjxLBukvGd6sMZa48TvCwc4xxxshOq6I1RTeAs2KD679l0kqQokAOQiP?=
 =?us-ascii?Q?TIIkqZZwaccvL2xlGlGpu1hdXrkcIovs8L6KfjGJWOqVhFwwxSemMqq94ypZ?=
 =?us-ascii?Q?zIVNMgNCkSdMY+ldZLC7zLYlEVQbmJ3u874t81KaVZHEaG+YGXZjQpNZUw9l?=
 =?us-ascii?Q?D0J3Z2LfsZjXx2qXyWWHx1i8sO0pQgw7MItnO4fuQKcYrLqebhMIdwZrbB2o?=
 =?us-ascii?Q?DtSeOfsWvTzHbqAZr44VeakF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b0a7ef-f357-4eba-d0ca-08d9076d3407
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:06:25.9840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mo8AszT09eftweoDpFlGaRsoQPFA+a/k44rwyu0njc3M2sLb7rt+HY6h6r12inFGPHvAFyCG3BPq2o/yZZJO5aBOxzSuttNUmeDp+5ULu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3317
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
X-Proofpoint-ORIG-GUID: oHi0OH9F5ZbdiPtOSloS-RF7JGeVjaV1
X-Proofpoint-GUID: oHi0OH9F5ZbdiPtOSloS-RF7JGeVjaV1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240168
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We run from a workqueue with no locks held so use GFP_NOIO.

Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index b4cbc385d0e3..1fbb74c109b9 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -1394,7 +1394,7 @@ static void qedi_abort_work(struct work_struct *work)
 		goto put_task;
 	}
 
-	list_work = kzalloc(sizeof(*list_work), GFP_ATOMIC);
+	list_work = kzalloc(sizeof(*list_work), GFP_NOIO);
 	if (!list_work) {
 		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
 		goto put_task;
-- 
2.25.1

