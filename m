Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82836C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5172A64E05
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 12:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhBKMbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:31:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:42940 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbhBKM2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 07:28:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCNmFB139069;
        Thu, 11 Feb 2021 12:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8HpFkWpDIkaH4gkyUW64IOjx3q8imxclQrD+2UmDdxk=;
 b=upcHj7kmqzlbtzKBIZqUbpdbKyLrgPQsCBXKqKuS+T9RU/lbwo5d+CKkbDEQzOhvJ4OY
 bpvFoDsYS7oKu6CRzXMcZOFqCsbeqQ1+Ih7HgRGdej1AjpUnAS6bERwx3JMobURx4YyV
 mBbagxyN4Im4V1me/3DPyNh0o6nEv5C5UomZSXUApixjLujK7VIPsXfiIC1+K8vDvq2Y
 z87g7sU5ALBSWrts6FfFicJvKdT/1bKSwAphH2vgQChXgzqk/MMBrjnfgZqORrQq9ln5
 KrKZjO/loM/O84Zag6Aqt0n9/+I1BIdzTBzltvJ+kZmh7inJqiUZgzqW3gTfbj6f0B7j Gg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36hkrn76ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11BCP6De052161;
        Thu, 11 Feb 2021 12:27:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 36j51yxtuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 12:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPBF1A2u4QkIvK9wDfbyWiSzRHsmBc93457WHXcDVPvJ83SS0ImArTUpIIEZEWSMHu7CRHKiFJEQRxzRCr4zHdxLudIcQLFBowqj8G7uOW5eYGDHrBfsTk+ym49BNhuP78P5PaL/z21UCOmnhZ1KlaMUqMaqq6GXyJu5G1yPlkFp/WpCpJdoxNqYYRznbNMt8NJrAW0XHvK2jApJTIuAnMxNEL9JR1YXT/UM88qHO0oIlbS8xemMf7uRHhVImRWGqmPlC9PQZbXQwKISu0EKjMkUsshfAxxlPH3rxzM3RpytKjZon8qU1+RfXMUsxo745UWbcpUHwyGvAy3sDI+XXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HpFkWpDIkaH4gkyUW64IOjx3q8imxclQrD+2UmDdxk=;
 b=L18XAhF+Ar4NXbrI1drfUOFcTicRnPRL7z8HwVQrs5kT8HzB92t8sroALR4DrWgOKNR4iBF0zPDb2p49r1syOCX5TQn0DkMkK9Nto6z6pXUjj9CfXApDkAQuwC80HupmKrXDBOc7grmh1EnNdYDvXnlKnQNyoYxg/zgsMHlrx/2PD15yH3v+hbsdiWo1GeP43dVIoVp0Glb/XdB5b2KcEtV7Do76m6gLXNg2fzlV2LYoF8a3tOfe1edp/8bUKj+NAbHHHvkyW0VZOC4Njr/Mus7exJaCMhIHwr+ClaxfQXYQsoEqRAG1/sOzz7tmwdEEejaSVETu4uS+5I2ZKrNwHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HpFkWpDIkaH4gkyUW64IOjx3q8imxclQrD+2UmDdxk=;
 b=N7BcxumKWNMaCuZr4sic/IiUaCvy1B8wcubkfzwkbKmav4HO/6B5LZepVVmFkt6if0Ih4OW9Kh03Hp+UnrHmA3NS9HIHK+MlqwU+1xM5UFJKQ/IPJOY8BDgGgf93jODTWAEz0mWYEG5ghJNlSRiUJoBbJZvHhsdIKBtCtbznp/Q=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4339.namprd10.prod.outlook.com (2603:10b6:a03:20a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Thu, 11 Feb
 2021 12:27:38 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Thu, 11 Feb 2021
 12:27:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Subject: [PATCH 01/14] target: remove target_submit_cmd_map_sgls
Date:   Thu, 11 Feb 2021 06:27:14 -0600
Message-Id: <20210211122728.31721-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:610:77::35) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH0PR04CA0060.namprd04.prod.outlook.com (2603:10b6:610:77::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 12:27:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7ae9f01-ca1c-4405-cd74-08d8ce886ae1
X-MS-TrafficTypeDiagnostic: BY5PR10MB4339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4339F4D34965B0247B44C7FEF18C9@BY5PR10MB4339.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUswI6fudsQuTqGtis4ofeNq/FwEZu8nUpS91Zy4bd5wPmN1bhZT0UJh4HAArdpgO5LmOTn0lAmyowmeFVpM0T0ioX9n8XiszHNP4wK4g5NAsKhqrSPSI9Zuu6MKz3r64pjwVfiLSseLS64Ns7nXcfhZ28Zp0pJYXb3ZdDR+M/DSBe3dJiG8j7ByrSPD2aSoyYRiAQIqRp80eiUA75YnTCExzADWC+CEgH7J1Omy0nI4f4sz4aTgbPD2CTngIcnRIHOsGTXDCYHDwSBo7eteO/nv86xgQpW+d7ctkpY4CJetH/mY7kufTEIlvBdJbtGtAZ6FiR+uoiwUEVQmF1VJzzMLebk+BJJUqi++dWk8Ffjk+gFtrby74Coepeb1MLgdktIezKjZexmiXqEjIdsHtSzpvaNB3StDSweceslMpkn6Xl5mG4kqey4eE1/5R5XG/7nU/41Motg5ae6+ynBlDw5YqY6Oe8936UjbitgYOwBMP2zVqOtzcrEWyQv1KWwvBuWPbJQR8yfzIyN4z6lyfx2HT3UZUH03iXl5uFU5Dy6MX2RFX/Z8qi7QrAASkQb5BB9nAQBiIJCcAIV6DVvBwIc1OD7kuK5OhSRa+/opKW5u82vUYZEHfOfxx/Xvra4v/JY3iAPLdyQcKAopZBsN44j6UkiQm/cj2k9m8eZZY2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(1076003)(6512007)(16526019)(2906002)(6506007)(478600001)(316002)(186003)(6486002)(8936002)(26005)(52116002)(66946007)(86362001)(6666004)(8676002)(2616005)(36756003)(5660300002)(66556008)(69590400011)(966005)(956004)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vv8Hfea/rI6lTRSrXwfNH5cb5TKe36RJ8v21nvBL6Yi2gSFUFNCCRMNrzGtL?=
 =?us-ascii?Q?IuUvnyCda0L39GODSHEfQMB7BsToGNxWhi8J3kMrpgDNUoRC7aHYxZ+8RoEd?=
 =?us-ascii?Q?tsg4GAda7xVtfdTEaAruFvANOVnQZAr6BpNwzCGgmuHQxJ6Slui472hBK/jX?=
 =?us-ascii?Q?8JJtd3NLDxPcA06ZWIyEw22N7kCj8tRyz77zAUVWLJFxjou+qsN3uoWLCbfr?=
 =?us-ascii?Q?GGzBknluXT40Mf8lfvMqLFwhhdeUEYHjirdKo606rIJ0Kjj/snK0Kg/Xusl4?=
 =?us-ascii?Q?YJt3H+1dR8CTGx6qT7XKJWdtBPGygxWiYIjVhmSn+4JZD5a7Axv2HNNGGvY/?=
 =?us-ascii?Q?6WiuAGjZPfA2VpjSpWnTPKuIqKrjPh7LplMsTH5be3B+I8DHzTXu0nCBgRVO?=
 =?us-ascii?Q?sH4ui6lMdf96ww1RGfBGuApxnfkHl7MtMnF4Bpw9Q1o4Kc/8W+w2FTHJvk4E?=
 =?us-ascii?Q?xexmJPf2F5rJXdWHCru8PLoENrUg72l0UhfCQWNOTuI6nkcoffJsFpmJ8BaO?=
 =?us-ascii?Q?XTLzQDXFNQ5+CTrhig/EQk8FW1M3lllw6TuB+wRVYE90r8f4B0HdIJFJcueW?=
 =?us-ascii?Q?iXEWRwiUwzQ04U3BPd1anzr+NGgfYeJ7GHJEaSI1bMH82KgJ4kmhqRDtmmGN?=
 =?us-ascii?Q?TgFsSZG6l78XK33QMDHz5QzHcUT79r75nrhYpnjW5Psy+v0D6eQQdY2Mkr5n?=
 =?us-ascii?Q?rSRV6oO4iN+/cQAcxyiX6yHEh619TLUEyn+MWZpWZxYYxJ929ubTgJ/wvr3Y?=
 =?us-ascii?Q?GYHdcIawIYOLfIKd+NbnVJddliQ+ySp27gNlLgc6ye+BoxUeJtQZq53uIizL?=
 =?us-ascii?Q?0s6ult1oyKFojfaQWhP9XzGConROVi7FqWnBwQ8hAD9aePLSkGOu0dMVcwq7?=
 =?us-ascii?Q?CGb3h5ugFsM2AAb0DXWFny2BxGzOkOt7j6Jl1gKWbfMfV+TI7AzBJzCaJFsm?=
 =?us-ascii?Q?XosbJPKtAZp7Q+FTjQrK8RxATJOUsoK2XVT0e5WpH3VKxMfeK1y5mokBxekc?=
 =?us-ascii?Q?oFrO+3coBkiwhu65QnLCipirpaqpyAA7qCBaJlCp+IC1OVB1LseYu55Yrg2A?=
 =?us-ascii?Q?6uKPgBvZURIGn8eEzigV8YuwUz6TNcR65KerXvz7cWPVp4FEfiU/GXmb0SZC?=
 =?us-ascii?Q?VYZaeRkrE8XO0XAfJFj70Su0ldghN7Ob4qIEVa78ngg+gycaPrz3KGhUQUXE?=
 =?us-ascii?Q?5kewlHaKKHpxykzqOJmXrYMiZ+4P5DK0UCUDzEgP9eKGc8v/sCFgq6flfgwV?=
 =?us-ascii?Q?SbZSUJ3xaZevbxN0Vq3MDdEWIgvr9Hg68oKfnvpWnAAZ5mMqLgA61LYD1HFb?=
 =?us-ascii?Q?5l6Nm9GkhacYa0wYkeAiONbv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ae9f01-ca1c-4405-cd74-08d8ce886ae1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:27:37.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZWH4ye/fPIDmMAQfeOJmnkdRwLvj4MlWRGy5RoeRtCexRTfj0Q8Ofr/oXdLfmrdBo2spTsc+MqnTt+EoA90VEIxdqTMo2+WBF7xHqPlEOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4339
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=904 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102110111
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thsee patches have some conflicts with some in_interrupt changes
so the following patches were made over Martin's 5.12 branches.

The patches handle Christoph's review comment to remove
target_submit_cmd_map_sgls in this thread:

https://www.spinics.net/lists/linux-scsi/msg154443.html

which is for the "target: fix cmd plugging and completion"
patchset:
https://patchwork.kernel.org/project/linux-scsi/list/?series=431163


The patches actually do a little more than just kill the
function and the set was getting longer, so I'm sending
it separately now. These patches do:

1. Breaks up target_submit_cmd_map_sgls into 3 helpers:
-------------------------------------------------------

- target_init_cmd: Do the basic general setup and get a refcount to
the session to make sure the caller can execute the cmd.

- target_submit_prep: Do the mapping, cdb processing and get a ref
to the lun.

- target_submit: Pass the cmd to LIO core for execution.

The above functions must be used by drivers that either:
- rely on lio for session shutdown synchronization by calling
target_stop_session.
- need to map sgls

2. Make target_submit_cmd easier to use.
----------------------------------------

It seems a lot of drivers were not handling target_submit_cmd*
errors correctly, or were handling it but it would never return a
failure for them. The only way target_submit_cmd* would fail is if
the driver also used target_stop_session, but a lot of drivers
did their own session sync up, so I simplified the API.
target_submit_cmd never returns a failure so callers do not have
worry about it.



