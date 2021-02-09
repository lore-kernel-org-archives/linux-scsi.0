Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7350FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADB964EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 12:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBIMjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 07:39:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43160 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBIMjn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 07:39:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CY9UQ054636;
        Tue, 9 Feb 2021 12:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=mwRx5RJwoINrrW6DHSPguPEI22CgZPzUP20hTWdabpQ=;
 b=PgriokHMJs7Z2Gn02e2ei6tyygT32HKG6DqR3v4dlvgC5otzBAdMgygxuZlbw/r5Fr1B
 Cza9AJHCRxZseObKNSDcpovMYLWbQnWzgfRVaGSszWYQ1X5KRmWDjlV4cOuhdPMn4R5h
 Y1AJ20DptsMiLA8ow98HQXoC3da4uWAXnONkAtKhFLQMQIwF64z2N/D+eq6B2NgxFyfN
 mlwas6BlS87MJgopkOqv4FdyYSercppRTaqwp40Exl84bqADMJBQN3Ad5iAgVaL6olMk
 NNetnIsQn2yfdgdYBYusGH6rTpFcI4GydL+xHJTjNoxHPeDbJp6qDKq94CyT1kIaIA1D Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmafe4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 119CaDIE178533;
        Tue, 9 Feb 2021 12:38:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3030.oracle.com with ESMTP id 36j4pnn07j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 12:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIhJm6TcQr/Up+iG7LVPOdHA7+sdBpZC2VNsFipbUSCjpdvFlrG25WFqCH+Afm3qKDQ1K05JFa2INPkfQpPDQKIAO2JcrEPvJeCLmu5LaHDRJscIKTdGe423+ptX5iZ1AOZuHZjAM0kDegasMM+L4Y32WgIB1L9sUO3OfhYO3SWo61E3IfOb29xsGvcmgyr9CwUhu6ASVOp+1ygmyb7xe2r8hn7enzJmJmr30oimEZSNUZzfhETg9axWY9Y1WoCY+sFqOAI7lwiCvK6djl/k5hVkL7RitARZJcV9VmWUWyMjUCVo3+BtCroJB4DJgZJ9meZm+XaNqgkJbnWoszW+Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwRx5RJwoINrrW6DHSPguPEI22CgZPzUP20hTWdabpQ=;
 b=efLZUa32lTm6py/VkpIQMZx9mTrADamGqH8GIisTluZX2cehpHNAlSthp3xcn1USPXkcGro6V/gIGIxqHFQwBlauum+HzvxWjj028pKYIXWdZ4BgECnO26kux4b3ptkE7RyThMfw28bYCjhIsOgkoI41e+lcsBiEslMOOccJHFz1Fy+SSNWuPAQNWBh12iGNpBPeHGUnBbftvMJXnCUNGw3cKPrXByY6TMGPaDowjtZKf2k3tlWAIXzaFqvIK0EodpkBt7Gx/TXXEvLI70lXcXC3X3Nbr/JTMFnjTySLp8WbrtuifNwKIPHfh3wyDoDj4MHhgQRB31dxIjxT4KY4Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwRx5RJwoINrrW6DHSPguPEI22CgZPzUP20hTWdabpQ=;
 b=hFEGuGPdHAg1VZHRYx36nfuQCSECLQP4NEwssW40HHK6hGusXmA7qLtG2gp2UvslrlKoxVDt2Bhuqhn+7WJRaVEUyWigZ8hd8ixNT40DXEPFxBzfeY3flCO8EUdFIM8DV0R/z7gw4GraUcWc1IN3HQXmsBMSx6w+l13mCCPwGoQ=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2600.namprd10.prod.outlook.com (2603:10b6:a02:aa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.25; Tue, 9 Feb
 2021 12:38:55 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 12:38:55 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     Chaitanya.Kulkarni@wdc.com, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 01/13] target: move t_task_cdb initialization
Date:   Tue,  9 Feb 2021 06:38:33 -0600
Message-Id: <20210209123845.4856-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209123845.4856-1-michael.christie@oracle.com>
References: <20210209123845.4856-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:610:59::17) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:59::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 12:38:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b85d68d4-4da8-4a37-b692-08d8ccf7a9f9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2600:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2600CB45CDDB9EE3E5CA5DD5F18E9@BYAPR10MB2600.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJAA6QqmfGm7ijREpTNGxwbyfY9ixfRTkVQJP+jASuqljPZftKuziLL74j87d+BXBQKQRi7KjpDINuNLn/UVagpqkYvN3we/rV3tlT+A1kn+fTbbWzbQ9aaKI3dHjUWcH+cnB+sYY7i1vBXSJhzq5jKrqwU1HD/TKcT9VvOa6IVA3u/koDUGar2ol3F1AXLIPdau4Y5VZNSJn59ZinySsjziNBGuTZXVQhTxk/ePkQ3N11Ha0gd9DCsbirBmOxBYC8Q42LwMadfsdTCcvU0US4vL/W+PmjkIRChsJkqEvr8ZYFhiE/yHuoPV4HZkScot2qkHVrRwt0fgRdN2d9spArogwc9U4xF19AAJy+q58N0414xaB6op5sKFyqxxqSmGtyT9z5C+6EVJis0uKqtsnDnBdPRRPUEAkiuDaL/qR+Fy+qAOld/UuJqft/qO37/521OREuznl8EX4IYXpHP0sI/oBY1lybPeAcV9zGlkmu87n0W5VzHoWL0Dk06jWYNfMPiN77dN2gjFkdqq/ddViLXYdAW42TV2/sfFtsizpPfeTiBqoYDhK1efyi7KwkOjrLF4NElFfN9CuCtBJ/wQYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(6486002)(16526019)(8676002)(86362001)(8936002)(5660300002)(4326008)(6666004)(107886003)(1076003)(478600001)(6512007)(6506007)(52116002)(26005)(69590400011)(186003)(66946007)(66476007)(36756003)(66556008)(316002)(83380400001)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MX9hvd+rQ7dNSlzjmxi+MCRkTRDfIu13JluDs3hNtBEnZY4A+0hsCzWclYRj?=
 =?us-ascii?Q?fmS2NApaxTSoeiQlXc4xuKmwqpTs5rA6bAu3Ek2ReC1gGCKwQGQ4UYjlfptr?=
 =?us-ascii?Q?OD6zYeu+si31UCpvnhMvAYg4qJm8OLccr+NvcSg1f8xXZU6Qeu2m6B32j2W2?=
 =?us-ascii?Q?lXKcxSaufq7M2LZxXtH4ytNSCeN3wqgcToTfRRKSzGCb5ZUSdcOI8rFZJu8u?=
 =?us-ascii?Q?9umuODIp/aDrOgMA90n69lX1qMMt36tnlKR5mot68tZk2ksiD5ajUuOomQNx?=
 =?us-ascii?Q?HdncVdjrIW0cZO5ZC1LV8IffObNzr+m4WhHxMaPDnoii+usWET5kNIKjGZB5?=
 =?us-ascii?Q?uvhCNfjVhv5MXYYXEm48NyI0SYopGxjelI2g95oHqdi4auFAC9v5H4Vt+VVW?=
 =?us-ascii?Q?//0DDML1K9xL7WHVsKLjVKND7wVFySaKz5dUSrO1CI2yamY/nszoIiNGT6k7?=
 =?us-ascii?Q?+7OEZBnXyGTccljhMRfbp3PXUkCwxQ34fqP37vl2Hz57Le+o70b7ql2rfKkO?=
 =?us-ascii?Q?FxMPWIEjlkgKDwnCUFG/ui3asyJGNGEipGdumos7Cd9p7A2JEirLV22LfwSd?=
 =?us-ascii?Q?Wi2sEy3cN1MvV9ntz8vdXKp7fnZgTPWsYyLrq56jPGgv8nWciDhiAt/ywWEh?=
 =?us-ascii?Q?Y9Ih1ilzlKzzPHjzPG9q7wnF8Watu+81kUUn1EmMPwj/pnok6ERoFrz414k9?=
 =?us-ascii?Q?tfvuusZ1i0m+iqpH+OPMtbVukygO56zwvN4kNhCfSgLrVdwqcQ3ZbNvHfqwc?=
 =?us-ascii?Q?Jfmgq9Sa6BIXcQECAGM69/SxrvZPgFLLEHHRfFeBQEQyhNXqDFnG7vtbqW92?=
 =?us-ascii?Q?WvKV+Pk9CFqByQMbNSI8F8fa2tEIo8oPpTTWr2mV7253CI1pXhfw3aeh0v5Q?=
 =?us-ascii?Q?AGQ3XCiSwzb6okztB5OwIlbFn1ozydcZvLoWKN9EFRugrvgjKx6kt5U8NZCb?=
 =?us-ascii?Q?rgFkO2uPKOrIROQd7lI99R4xzE71GsIKRI7yuMMQCLoEmjXo3PRxTl7JiAhx?=
 =?us-ascii?Q?L/6LnsZwAvUWwfVV3g0G9lKyNCnIY8g9LH3NhDr/Z/WMVspAF4cLoxW4Xrbo?=
 =?us-ascii?Q?ffOjdl4mp/SCHnYxaAdBrSxgD+KYsWuH3uuIcg3JzQHxc655RExZlOuVLZ5n?=
 =?us-ascii?Q?Nxq+/ifiCKaln6oxWCQDoQgXDafQPUPpKmouV198kVuK/wc7ikCsTXoNI59C?=
 =?us-ascii?Q?VJ8TMeQ1hZTRFfPo8wiSC3iJBMYwbZw2+o4CduBxDa/bu9HdRdbqer8WgUv8?=
 =?us-ascii?Q?GAME2zz9iLFI+EPGX1pD1ZUKhZjMd4+uuFDFYfDjCqVfkbxtHDP+f9lgyhea?=
 =?us-ascii?Q?7OQ/ybI1ltFvnsCJ7Vow+/kc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85d68d4-4da8-4a37-b692-08d8ccf7a9f9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 12:38:55.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufdE7tOsuX8Nh0rM0YJ1YwnCr5shjDSJmbaMPJwmMDQKc19fjdQn1JvX/nSoJw2A+tnrDpXzqRvdO9VC/cBWyLKzIJBmlesgMiNXL6dzDus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2600
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090066
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090066
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The next patch splits target_submit_cmd_map_sgls so the initialization
and submission part can be called at different times. If the init part
fails we can reference the t_task_cdb early in some of the logging
and tracing code. This moves it to transport_init_se_cmd so we don't
hit NULL pointer crashes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d47bfd8b0f87..5c4adde96d5e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1389,6 +1389,7 @@ void transport_init_se_cmd(
 	INIT_WORK(&cmd->work, NULL);
 	kref_init(&cmd->cmd_kref);
 
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
 	cmd->data_length = data_length;
@@ -1430,7 +1431,6 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	sense_reason_t ret;
 
-	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
-- 
2.25.1

