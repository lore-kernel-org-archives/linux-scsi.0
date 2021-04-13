Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A02C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B7161249
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348736AbhDMXH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47156 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhDMXH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjw4P168963;
        Tue, 13 Apr 2021 23:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=PSCx+g9ltPrEMNl8YgyR7hb0HUv1o6PFXcNG45qB8B4=;
 b=YNSay0oAaiXUi9k7PMj8wZYIDW+30wCfc0Ps/m0uHGJdqnOhNgSl+U3jP5uXW1M3fp1Y
 jemDNF/MQK/Pf2gP6ElRitC3HMdp2XpYI8b68+/navUO8Tsi6kZW713S6eBWFUOw16Jb
 r7MMqZOCDwIxDW4o12Hjixo3HZr6qLNUwvfRuu2MVku6Nrj70x9gTHq4o4kRX0QUAbpk
 oNQ+zgz93hfqqlj5lrMdqLs2jZKQXXyVP3MwHShs6KGrXzRsqvk03uRevJIQ5gM+X92X
 15VOgDGOBR1OC1Be3/MV7ZdoEJMZhuFJiJRanMYSo8C/HD6f7L9SBzZDxxIj0pVonDzz rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbgsw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:06:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjTrS105370;
        Tue, 13 Apr 2021 23:06:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3020.oracle.com with ESMTP id 37unst1tv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:06:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyE3HZ9z1eIKLWOf7hRX+T40FYGeDnYhUtTCfWcYf6SDnaOMnp7sXT1EEapQVrqmXSKdnoyNxTB7ICxUXUwPaHHPm3iHtTNWZBHtaBmxDfAIUT5/rTzITOXztc7SAeFKs6R0XHLJzSDFWzQE7C6cscPPsVFL5XJTn+gSmBdGvCNw4RHojh/YoQpIX4LUL9GET+Nyu5rM5FGOntfk+DRx1QqLVpfhNe+IRR9VPhod9YEvYoewQ8jGILCBSp8WofybobuFihfjmp065idjv9y9IIwkutDQMNcLzTPjGBtp1SM2vgAcqpvWif5k9+LQw++ybxzGgSqrfqr+52Dvg6bucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSCx+g9ltPrEMNl8YgyR7hb0HUv1o6PFXcNG45qB8B4=;
 b=LbhUYa4VWZHdBv1a2lXb9gq/axkX0mVQQI9dA8d0Ef4fx9Jglh2hqpqg1ru7+0X3HnhNhgVQYoH0UXmNMIgXi+K9aPXdUgEHMo6JH9fmdK8XPyX3QanKJHOpUvrK87GwGpoCQcH1bYIN5m2Ukhf8C2ewvlteB1w0b31SU+evPqXHZkqhvgsTEHmftdxQN4OhxAEEGu4E98oPxebx8CQ6HGQa6VGjSH1z+vPXmTdDe6yQxgz73WW/9lvcSnQudVQDXamPKVMitlMYPl+P5B/G7IXjwWSDHbg0gOuf2Z7S+XbqnFCvhOoyg41+wQ4zojFrHm6/4cQie1uQaHTezCsC4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSCx+g9ltPrEMNl8YgyR7hb0HUv1o6PFXcNG45qB8B4=;
 b=P3T01DEIE/TnTbA75r7LMC3pJqXLr4qXXVHJMz8QnGUS7uFSUM5YbbqdJYQU+X479On+9t5/O1c8O3kMR2oKUXwkQ25xDIHSkvdGTmjBRg5T8jYyR6R1akjgJVHgLXXvzrzQbgCXsVy0kQhpExu5Bow26BD80Pmr4/s0f7hTauk=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:06:57 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:06:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 00/13] scsi: libicsi and qedi tmf fixes
Date:   Tue, 13 Apr 2021 18:06:35 -0500
Message-Id: <20210413230648.5593-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:06:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d86c128-4852-4984-125a-08d8fed0d60a
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB246918284704690B084BBC1FF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sCGIB6CXyQ5JJJbx0WGARB+8Y9ZvH1XEjCzQKsrKH+vLE/d3bxr0Z3d7CDtsNVDwBQCrZcj/Hphd7y+GHCkP9w1iMLqudgVn5Bq3tXjZfCWGf9Ayl2MuK/dhrtbK+Ml8CPLUp5kr9yG/gDmeHQpwj1zxx3nV1cVXOwKtWhxUidvJ6ldZ4Sk/wpEg5unsu59lwrTd5mlaIgNWnHD/Mw8B0/L6/LVivBvmezVmlnhJjOP18XoircC9EgRyvZJJsXNREWyBaDikOqpcUcyTpI/37TJk6cFs0eBZE7VPhTGxZKjS4uNsum4c/oCgBzdmwpJ1DPLeHRI6x4DMwLZBxnWxHOu3c9eq3+mD4yg8OBXf4Z0sVkRBGxfOhzM8f1BNg8rTxXKCGQ5rtjxVQDxS0px9d7wDeXCA/VrOCwMsEOEOYtoAiAbiPPiJGd5qCC+a9i3Jn3z+4F6B0mhvEecWKgfztOijHNCFytmquIRV0TqBVbMSKw9q+GWdE/jjrTkkebA8czw/xeMMc0XM0eEbvkWffoBFQb7nowrPRVmB3EhVrnJxZrqvrvapnXji7J4NBobKfzjhh+u+7fbEXRzfwdOiws/mM3jjy/tjaa9tn2lK4eBK8Khsf4/9OI0H9+WdR77wvwBx6F3+ql6empP4VjBYwGbbi50qiKXLavs0gwm46cvaAJxoedWrL3K2hmWOd0v+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(4744005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4LIvKwR9xRtr16jnojsBJqie4FMrGtn8BuMF3tNDuswdwe7KNRpFYwcG6Z5e?=
 =?us-ascii?Q?+hJIMO68FN+yIzb0eVNThcQVRJ/RHwnVFo38/TcN4Ug5U5yIkJnYKzVeONvW?=
 =?us-ascii?Q?nNl3oThBDOrDfSXZjKfk3OTj+/ndMoZR8fqrKEZJAF52FtyCLlh1dvWl3COw?=
 =?us-ascii?Q?6cl1sJOGnNClzNC1a7084q91RztiQSKOd87BhAMKjKinJWrJvKD9aVhvFaa1?=
 =?us-ascii?Q?YRUjDBxxKJ2yxsVUmnldsPj+KRpPdPS4zTqg9QQmiFEJ32PhNGRCNU5+ggeM?=
 =?us-ascii?Q?wO2J7DTtsckUCiN4XeK7w2i/5+DeIxh7D11gQcL6/aCqZhuwIfM7pk0hnxjt?=
 =?us-ascii?Q?g9XfSCCGWUDljRMHYkH5jTsytc1nZql/hVqPx+54ZPFhZJLWJbXb9UA+qjlQ?=
 =?us-ascii?Q?b7T7rwi+rvGqjDYYLIHaXz4Tt68XaPMSoVM61dmA5VKx9lrNq/6jeMzSWypk?=
 =?us-ascii?Q?QAZD/LM87UvRXdf+1JvtHPaPkUhzCK1sRNhy5fHlU3srm2XD9wm7wNQBNzxR?=
 =?us-ascii?Q?1HMt5F00+k3v7SqaQHuDYj9hpyHuPRr2fRt1dk65CHYsIEGyvQFEHz3LwjgT?=
 =?us-ascii?Q?VuTlEvOq9goVSKMkyxKSLjUh4Gm95yPX06p2tyN0jzrnnoyGPRUoMTokBzMY?=
 =?us-ascii?Q?taaUox+9D+jZ7rewtcPRqyO0vOktCfUJVV5iCKTOEexXHXdnd64JaARXAXkG?=
 =?us-ascii?Q?CfXbXy7pBsVDfYVvKbSsE/05Pmb1zQgAQgxEJMFpINstGXpH5Mo1qPWK9e7G?=
 =?us-ascii?Q?gaKsb2XzmZhxnIhw8uORVRowxlXyQcWEvxNc/9eqAIgJy/MCWmk3p+I+n0Tl?=
 =?us-ascii?Q?8IdkNMPHeYegJ4+ZvYvjI2xaTZI7Dtqyc4scHeX6bTHSXTgNYJ/DDzMKLLIU?=
 =?us-ascii?Q?OvAFajv0bKreYyA8ZpxYgLy4msqsfxfCX2HmFaxl1eoaZuynvTr2jtO9vY7d?=
 =?us-ascii?Q?bgMlJbwD6YbZsT3NdAU4vObUuLDxXQH5beh62M685l8QNJU28duOmD371o2j?=
 =?us-ascii?Q?SuZ7gp75kwS1koyVTeBGWEFw80mGh50UEDBpuMZj35nvB6lWWnbDJndokMxl?=
 =?us-ascii?Q?o8V/HiBw3pVz95Y2xny1A7r1sS0NowxNSBwVQKGvXKDO9kCPB0qReEC8SbbY?=
 =?us-ascii?Q?b22b6pw5rLICu/Cu2AORpaiFVRSVM5JE+jfDcbvGZaHk7e7BiI/NvhDYPFw/?=
 =?us-ascii?Q?7fO3Of+qv3PhYaaJRC8m7ffq9Nwg83+Oxb1+h0liupTccK8MSlgV3f4M+kEv?=
 =?us-ascii?Q?aCm9HWqJ+Z0MDWLnlz5SE9hAVfRLJ5IamamnCBjd8uMlfZwwTMLkkqHZ1rEY?=
 =?us-ascii?Q?x59qy4OkSrgNChe/HB9wRfLs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d86c128-4852-4984-125a-08d8fed0d60a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:06:57.3480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bzLrNPxSJRoTL9VK3dTeChGckC/Fp0C+eHChWSnAxxrQrFs5r9nzUfqH6+0utGvkAgkXQOzXWEBnIGkz4bwrxypc0wCNmQ94/VLbFGXDRhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-GUID: tsa__Zv6hbsYjqj8Z0mzWRaiLi8IL-00
X-Proofpoint-ORIG-GUID: tsa__Zv6hbsYjqj8Z0mzWRaiLi8IL-00
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches can apply to Linus's tree or Martin's 5.13 staging
branch.

The patches fix tmf bugs in the qedi driver and libiscsi issues that are
common to all offload drivers like qedi.

I've dropped the RFC tag becuase Manish has reviewed the qedi bits and
I've tested with drivers like ib_iser that work slightly different from
qedi.

V2:
- Dropped patch that reverted the in-kernel conn failure handling. I
posted a full patchset to fix that separately.
- Modfied the tmf vs cmd queueing patch. The RFC patch only supported
qedi and offload drivers. iscsi_tcp/cxgbgi do not need it.
- Added patch for another issue found where cmds can still be queued to the
driver while it does ep_disconnect.



