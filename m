Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEBFC433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F1B64E92
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 04:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBGEsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 23:48:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41664 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBGEra (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 23:47:30 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174kZTT108603;
        Sun, 7 Feb 2021 04:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=23wu1yMWld9niuqGxoI6BMKHkdgBSWL5rhPPfv/xM+c=;
 b=GkKJyJ7HWGOoTFuCgH78TQAZrBQZnraA2oZPskjdVPVAyVo9+SIGPrv/7Jm0LM4w8XK4
 0FW/J7vR9opII1FJxmUYC8NqGl3yMv2bfQ9Chgu5xQ+MHIAXhGH/rgpPQm/4DwjZbE5h
 jl/jSeBUDcrbzaBmWE+N3V9dRQNero6q/ByqbbooWWxWLw9fdHNqwC/LQUvWJ/yJiVcB
 000k924Ioet3WXREKcXnhydjqr6RT6qC3QqUZNPrrWG+2jx/QD8JqIyuWS4pdE82NV9w
 UZoEfebntBGBBQa8o2nOepAsVbU3c7GIyqJxr/Lv2E4KI1nAsYhpjLpJGr3o6OdES4dp Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36hjhqhbta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1174kRSR154156;
        Sun, 7 Feb 2021 04:46:34 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2055.outbound.protection.outlook.com [104.47.38.55])
        by userp3020.oracle.com with ESMTP id 36j4vnmr7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 04:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUvv24QnV5xvO88ywpQHfJCBCmyQMMlLpbdVjuIeQ4FjjeZnNovX27zcgp3Uvhy6kHlGAEPVcuYzc5pS7S0cCyd4fPgazYKVdSfQokek2rNDX3utXXoKCHKy2VzTfWpJaDULZOWTSQ0M7ov2FYaJ0UERtonxot67HNtIau1OsTlC28sAiAXXhr3orbBoVE7YsEaxi1Zj883GzyGPbLs3VuW4e97xIvvWRjqBZjkHxTqn2JaAFl4A5BFmYeDqfiYb9WWyM0gqvoveOn9Xj+B/ra3rdCPnqXedEPj1f5hzei/FXX7V2BlznB7+AuefTz0rxGfg0Ati/DYmGMVPeauM9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23wu1yMWld9niuqGxoI6BMKHkdgBSWL5rhPPfv/xM+c=;
 b=dNCEASk0/vUYBeXZDIjRGX0vnlBIWZ4N5g0rwpRqm2aD+mjde80FxAXxYj0O9o8SLmTUbZ2feKJYZ1EbcL1ZZB1iVp88dDelup40IKSbCKyYv08izwQfS0X+bEWD70Y/pQGxDOvzxqaNTrb/3Ynq2Af7+HXnfxdM/5T//I/vCdUS06aZnJRjvlSlXtLuDp393MU6Pm/HHcVQYV/mfN1njV0BZ1YBplWoctLH+G+Bt7k98mkSfDwwf9l/KRBdm2S6XDqz+hHkcCA4ziwI8ElbojvEkZGxDv1mihJp5dgKy7Vr51l1CFzoIyN2QG84alomACM4nCT8dPeW8uVpcRS+YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=23wu1yMWld9niuqGxoI6BMKHkdgBSWL5rhPPfv/xM+c=;
 b=aodINSCdBl7askJqE8nL31+62FtXpRkBktMxg5S4HQFHibQ5TEbz6WH0r4Zi5ZE72n09OKGxTnZYkGuyEMT52EhrRB4kf6Y9VqgbE8sGL0P01FwmdqpzMlxoISvqaW2ZdlAZJwUp+Qj4jWI5MMKEzL9haJVxs+rBb4QbDynnTpM=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sun, 7 Feb
 2021 04:46:32 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 04:46:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 8/9] qla4xxx: use iscsi_is_session_online
Date:   Sat,  6 Feb 2021 22:46:07 -0600
Message-Id: <20210207044608.27585-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207044608.27585-1-michael.christie@oracle.com>
References: <20210207044608.27585-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:610:58::19) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR20CA0009.namprd20.prod.outlook.com (2603:10b6:610:58::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sun, 7 Feb 2021 04:46:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c21bba6-2de1-4cf4-b5f0-08d8cb235720
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3429504B360F74F1D6E8BA8AF1B09@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7inRXa5Z6W6GIDvPPuQmsQEQ4FO0XyxNCElkppNt6NamiRLqlwAM4wxJwSA0TpvOu22BPFNYC2iVTHddNzh8bzES3u+AEMt22oMZba7kdgdfFGKFpDEAwnAXyXq0sFXjW+CktqpSkcqcV1sq4VptvXnpdEJU388InqRLCaZJAALkNenNJ+bf88NhIIygduI4SW1L6hWC2WIeZMhCW+fOkFA0CNS3cQq4GU0jPCe4f8I2rrvBvN9BtZh/6f1eroJYuCFKZWokKEiiFtkLIsx+AFlNR13Lpduj/LAgn9l+2Uvs2dseJscEDGWsPZQWHeoVbb55zTzh1xi3/TOZDzhKUqqy8WHKxUvxgnDkY8QIAE1VCICQaLPHuU3D7RchROwRsi64v9wqB/MCBKCVBD/9ew1sxTQ3uDEPmD//6VZNp+wALpVwJtp8tCbHGG0L9Xz/wE7npfpIajHIu014RQjByTPtNZdDsGyXpkDwEVYKn8joKZgKepfy2YQ8UyOcUdrsbMIgJqYBcMXRD+UDzLjNwb7mQKod9VIlvqeXQ44YgEFUxyy6lLCRa2uLrGQ2nvUO4fH7P/dYjkHLqYecwCu83SRs+jjXnTYtFDAPRHHN/8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(1076003)(6666004)(316002)(956004)(2616005)(5660300002)(66946007)(66476007)(66556008)(4744005)(6486002)(69590400011)(83380400001)(86362001)(36756003)(52116002)(107886003)(6512007)(26005)(478600001)(8676002)(2906002)(8936002)(16526019)(186003)(4326008)(6506007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?F5PIHRO9/sFldMjKcR6CaMFDrMbthsAVGgetuPVaBmWicxgpBCaF34pOuYbA?=
 =?us-ascii?Q?KkTkMbup2eRYWo+ifgLuzWoVfnxWmfGeAYF1pCU9c9O7AMzytfnRTzSHMz7h?=
 =?us-ascii?Q?dhQE90uyhg+PeBd91b4OjaIsIKPDlh+ZZUikzrEdy/czNkVYJssMAO0wtOkU?=
 =?us-ascii?Q?VB2dHmO5ycI3R066Dsq2NzsyNDFrX1WPlAKRv8+Usogclnj60yY+t12DHpMK?=
 =?us-ascii?Q?XVBkmH+WpovCdHF+2t3YuPMJR4TsaoQSssZkON2Cj3wGSzc600vsJrnlEbZA?=
 =?us-ascii?Q?Tlog6iySTohj+m1xWhkw1gzgNhguzKXwWo2DQVHVDOLT1px1ywp4mlCuD3aP?=
 =?us-ascii?Q?EZGzptUuhDWgKbca/97CohH11+5GtLx7HXCnY0VFu6Bx+y/BlxmUlBxmM5GL?=
 =?us-ascii?Q?AbkblnTHEA0dpdZjIiCkwlwuSm07f+/hgaseSWFFaGAvAgA6cQJRy5GAXB+R?=
 =?us-ascii?Q?ibzGWKTUrgP+MpI+kAhFNHfU2hldos74w5DGQQo3Ux/yy7knPF934cEk8c7h?=
 =?us-ascii?Q?uP1RCNU77ffYsDlhZOeJaKyvuqVJ99G5v0zae5CYRzR9fOkQzRQvz4J1TDqf?=
 =?us-ascii?Q?MEp3LFWfVGhn7GeWjz01+WTDq5/XFrWF1U7CWohdrJtvrfudKk6qamf7SSZP?=
 =?us-ascii?Q?qvG3C/NZPNvj3bXJ5XtSX898cLDygIssnTHQXswB3od/QlufPRpHTCO6EIOb?=
 =?us-ascii?Q?X6owQf56ASyl8LkkNsb/o2cYgs1sUlNe25zsUANMwS6h9qvX0a/pujcvipjc?=
 =?us-ascii?Q?8uiTyg3sV5Hb6Y8ct3Z8Fs9LCDCz2HzrD43ZP+SbXlDuz4dCzl6mZ3jYyaGq?=
 =?us-ascii?Q?IDD29B03/gSsjZ1kP8peHA7W1TYlEz9+n3lD5VRo8g2mfsUF4C9Ebu+dY7DS?=
 =?us-ascii?Q?952BkE0yG9htxc6lRDgXhKMeUQ1/z2TcAyNNQOEF7vP8siwxde7UEAFXJ9/i?=
 =?us-ascii?Q?kEPJDzrYtsKhuSPn36QrDBoM+ldujMVzLJ8mT6eDJaJ3tEgWQKF+mPkU0+aV?=
 =?us-ascii?Q?14WPZ1nMRxCmGznQmKx9QzAg1xwoIi2uABbHV6j+lZPCBdRoaMpdr/wPQUCp?=
 =?us-ascii?Q?x/b2lNsdkhCviPYl8jF+LoZ9k1EDg+YgAYbHd1XcWDt4iTUcVPfJ+5VUc9Dr?=
 =?us-ascii?Q?fQJRGbesulsO6fQUqZP6VZACSn/9xS1upQTPhf7O3fUPDxHWa04kHJxVMrss?=
 =?us-ascii?Q?zHLMgcTjVSIQzyaD1Z6buWPu3ArqQx9/M1MpHfwXKLFzjpif9gLFRXNrsgGN?=
 =?us-ascii?Q?YfgwAj6nYiMaP+K3qEO3TVZ3zyRhhuaZsPnmWNckpN0qfYgT6rDau9IH5Kga?=
 =?us-ascii?Q?YCarIKBTdhGZVBnIgN4TOuzj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c21bba6-2de1-4cf4-b5f0-08d8cb235720
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 04:46:32.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bO06KdDbPYJdqjLfMBGouFHnlh1rwZtUpCAEkOJLfY6r3fAKHndfaWMf4TD7OE5jlCjeV7x1OpByojilMdl8wHCU9S9af+vuaIQ7yTFScw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102070033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9887 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102070033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__qla4xxx_is_chap_active just wants to know if a session is online and
does not care about why it's not, so this has it use
iscsi_is_session_online.

This is not a bug now, but the next patch changes the behavior of
iscsi_session_chkready so this patch just prepares the driver for that
change.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a4b014e1cd8c..7bd9a4a04ad5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -841,7 +841,7 @@ static int __qla4xxx_is_chap_active(struct device *dev, void *data)
 	sess = cls_session->dd_data;
 	ddb_entry = sess->dd_data;
 
-	if (iscsi_session_chkready(cls_session))
+	if (iscsi_is_session_online(cls_session))
 		goto exit_is_chap_active;
 
 	if (ddb_entry->chap_tbl_idx == *chap_tbl_idx)
-- 
2.25.1

