Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A265C49361
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD42E61263
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbhFIDly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50444 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236570AbhFIDlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592guuK180215;
        Wed, 9 Jun 2021 03:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=VICH3jqi8miJ598stLmYeJYUFUMz/3w5XWgr1BnarmY=;
 b=q5oDpFu2i47ncuLyQ6WcXemMhwPfFpw3lpPe9BZxQfKZBGwWAHG/gI4HgNW+lk8bW+iq
 A3XCjs5ycdvcRcPVxaM8UAI4lQ8qDE7IXg0hCMkPdm8ZnIjhRwXlF3VazsTzVB6g/85u
 HRDkOX8W5Ou86YACDWP2jw/QqRIp47s1LYGbL9zzbXiwZoB3CO8t0Y6w4yF6v4k5z8no
 NnKH/QJJaN6SpkjF/qWPX6E2XLMq4VkmbeZF5BrcQzQ0vp1NCaSJOY/auwvU30Ga4FVw
 TJnC9/eWqvKDXEiRBECw1uYIDUaqmUuE6lDDXVp431GckPYiKLq6HEPlNuCTiJ1TNDhV mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38yxscfte0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 03:39:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z2Pp082696;
        Wed, 9 Jun 2021 03:39:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 03:39:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ElgIKqJeY7IyksyIHBM60LuGZL4dizItDsC7rFsyLQqKE1CMffD+FdROoxOSvYg4zeWg4QQl9Qb4JxSo1Iiq7FououTPkiKHJL627CiJFw0Hsd0WO8u7IC2RHe0xPfLpO+f4zEKBnx1x8sI80oQ8+YTusL5opLFY95OO+AKeC5fxrGBblQTRvWBHtReIdtbF0Zq4Z0hGVKx40YzGmbJoT/9WMbzf9NyAqUDsMCat9jKDXex4HbUNBv6/avooZYDBCMeGPBCondMAFWmBsgBfDXcYaJliJvVBA0lfIU9B0rHULI0748iJclYy7/x71ak/8AX+a2iHs2p/SUvt5z603g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VICH3jqi8miJ598stLmYeJYUFUMz/3w5XWgr1BnarmY=;
 b=bxiowBwx7Yppo4VKNcOpsshifFKBD9uL+gvI4JZAt7p/0wGSDFiLjvUu2WN4+YrkaxXqmV6naOyUB1VeBVrEyQwa00DO3onkWVE/ae9Ff1sawa/YPkIFDiiMBOv2BU6ZhFJB84car/ATchqiCic8Z+0fnDbGf53p3xFoicoLJRU42EW9zU+VDNCoWp4MidBDjIBdbiZJcTN4qFtR2Q2e+azpOtc2RtJJy6lWZTGACieQIi9c8C+AC3r4lh4qZBUo7PEWzDuionPsnZjloubecWeBqJoKjJxnCvYFEuDwxNQoGFi1XsRQ4EJz6ecVjzNLSsjdIm7C7eosFVam7i6Rrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VICH3jqi8miJ598stLmYeJYUFUMz/3w5XWgr1BnarmY=;
 b=eLetUYDZIDMMC8GsN4GqgLwUIihgWjb5W4Vvzy4oc15bHhKVAgNG/+Ls6xPh6nytQWS1EE+0xiakaSFGFzre0Xadcfk+TccqPGAqHmEctSJA6mtRUzuOw4jiAKhphOCC3wadzqhQcmXYTUDo8It5Fea1cpUSyOhispf1bTjq2r0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10/15] scsi: core: Introduce scsi_get_sector()
Date:   Tue,  8 Jun 2021 23:39:24 -0400
Message-Id: <20210609033929.3815-11-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
References: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:806:120::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34d615b4-31b2-4b3b-2c48-08d92af83683
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4421EF5D9E773BD97CA486E08E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJnKz9tUCaRrX4SdbSqosEp6MNuQ0mMDlUPkvXa+T5IO1qlOT5QrrL5L48OJayo0CJFr800K+qUNjU5NPmXavTJZxzKRFwTyZT4sq4p9C1C0RlRdbHZEZnCf5N5gpVykAXHHWZy6PBfMCKNArTJ1uX1MWrEcp6O9+8+v1CSuEbXGarigRzoTSpNgSgK8XYpJfvUkY3UPazGmK2C2TUwqxSvrOEucqUGqsYv7EGjvq8w4R+guZROYRpY1oy+OkkMlG35mFwZbkhOtuFGCovq3uw8dCbozUoFri4/zjOhCiBYmsXSfjudpdKia88Nh2Pq/yr/z4P6mqqWRZkcmF+y+SqenvnlSUUpE4TI7LsNgznV1y3ZSs4B5q74EUywxUZWQ5/rA0o4jHNLbqRwV2ySCqlIy2ZVUPZXtS//BWEuLXggs/44hmHf+sj/C47B4kPpoMEB89d4NOu+maNvls5A6usRYl8jA4wql0S7B2mQwnPQwDmJ2Xmtv8dXO5+iWKtOZZ0YTTv2RaFMcVzJR9dhjRJxHRblS5WODQgoSk5mUiBZGie6mMUJON5scj3OmkbsD528fJywJ9DfvJxFh0s1u7sjY0RRI3fhSlsG6MScPnXrRZQra32/f8KIngTOHvz5XIowcwda5dRpIk+iq715ThoXMXka8fhxUVfhOSSV5wR2DeoylubgKkS3+QY0UFGKqN15ReMefJ/8Mhnjh/KTquG26VQYGL/RqpCfIYN9ge4WtAraQAFHcgNArmofs9b79wRcYNI/OO7p9KWvU4rwLNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(966005)(54906003)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DCN1tiK39kYhEWzeu9YVBvPjUS5Jo5oslNDMRONDD3Q6l0R0nuHlGXrjybaf?=
 =?us-ascii?Q?oGq2BDjn7BcTkTyMGbI0Sy9G4jSqziChYz1bhlpfzeT1EIdeVillAJOGmb7K?=
 =?us-ascii?Q?k/WarObFBDss0AyA3h+ockDbHU/MnkwNeIiPN9onD1ILhv59U2/T+BjUJvNm?=
 =?us-ascii?Q?d/dIgr0WCp96pw/Sx/KHWhBR/SpnL9CR3Z00zPKgqxvWqLg95GyKBVze2GEv?=
 =?us-ascii?Q?XpCOuo424s+mO3N471h573dnSly1I4OFmrL7w1J2qydlyqndWb3bpdQv0cbE?=
 =?us-ascii?Q?HTHzTgBcL/SyZAOHPlomX3FLzTty5R1164uMzIWEpciwXhBCe+mYZN+6CACj?=
 =?us-ascii?Q?NfIZ4Sc7ZUCgcuUDCha2coppT4uZio1ceJWD5NPMZj0bOtIR2KA2gjB6UDkX?=
 =?us-ascii?Q?Ot2yf5IPl4OG1JqxBiKescORcWzTfQvbSswY4j5aAWKXcf2JRT6yliNJkQS1?=
 =?us-ascii?Q?rzJUDIw9wztp6+mUxW6IxFPpSHhMfPkULElSw+rhRm3PTWvvkforiiLWMO7u?=
 =?us-ascii?Q?A4G2fXRF/7Zp86GmuqMiPz5yI+rBOi329YpO8GiYfJA2KDhY7pZqVHgRhfAG?=
 =?us-ascii?Q?crw5uK79Bkh9+0PM5ewc3/Q+lYWrzzyL3xJKe4cCCNiKhwNgbnxrZ2DVkUj8?=
 =?us-ascii?Q?zzGb6qFicScFwIVJqa8LVdpdR9b0FgxQIQPRL4N7bt7ncJegEspl8rZEE89Y?=
 =?us-ascii?Q?dXd5MNgtbH0zailauYU+oMUy6A8ulN9nlcqm/N6TYwCFx4QEiCf2RBbNN80Q?=
 =?us-ascii?Q?sFKWE29spRu1HI9Bkyy9sn1nmm91bEJNj8/lMhFIiUwj4ED9sxXBK6TqwJ10?=
 =?us-ascii?Q?b/99t9Ifl4NFRPGijf+KtMEBv9uJ5coCDaIJZubp7QvhAy0aYhiLneWrDNKt?=
 =?us-ascii?Q?/BeRuVGeMPuhAbU0ocjUNRVGcz7MsEdm59gfVfVO8xCuf89qHjmRPe/AUsXG?=
 =?us-ascii?Q?OVqowAMtvfwQRH7ySKcCFHdNsYjfsTc2o2zo1W6GFXM5uq5oSCxBd1+y3mXD?=
 =?us-ascii?Q?9vsVQJ0Cs3D+kYclzLw0GH0wDBpEsCUuyN2I+MMVq2z1wwormziIz4uTa22B?=
 =?us-ascii?Q?jwDP9G+oB+Xip94HlQrPmxXW+5kOPlkUsMVm9fKkhAOZnKFkZ9jCtA/RUG+R?=
 =?us-ascii?Q?M9tVfnjvDjlZCUHGpv/iR7WzXB3dQSZ+5iSNLY2e0aiZEvkWhey+uQQ8TREL?=
 =?us-ascii?Q?pZuO0E3EKMBqam+M8jUIaXUQYPn6LR44XqSSbRhW3KbcA9X948aG19ItwQNo?=
 =?us-ascii?Q?GnDR2A5DgVZYLoQf9laYInNQVjzGsummzXOzH0Jt47NjX2BPRE/xa/x7hL35?=
 =?us-ascii?Q?g72iICd2vq2EJO5EEnKD2nSn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d615b4-31b2-4b3b-2c48-08d92af83683
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:40.8131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65BpcHtHACaDnEdDtHukJRYrrASwJ0SfXi4T9cHD8QGGtqcp4LOPDjfRm3hFBflIhnbDrhhU/jhnY9lrYYqM4BGorCERcjCBN25GYriyOVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-ORIG-GUID: ZpCQfuz3r1vWcXVV6a0EcDFzYSIol2LM
X-Proofpoint-GUID: ZpCQfuz3r1vWcXVV6a0EcDFzYSIol2LM
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Since scsi_get_lba() returns a sector_t value instead of the LBA, the name
of that function is confusing. Introduce an identical function
scsi_get_sector().

Link: https://lore.kernel.org/r/20210513223757.3938-2-bvanassche@acm.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_cmnd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 301b9cd4ddd0..cba63377d46a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -220,6 +220,11 @@ static inline int scsi_sg_copy_to_buffer(struct scsi_cmnd *cmd,
 				 buf, buflen);
 }
 
+static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
+{
+	return blk_rq_pos(scmd->request);
+}
+
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
-- 
2.31.1

