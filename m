Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F8BC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AAC964E6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Feb 2021 20:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhBQUcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Feb 2021 15:32:03 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41136 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbhBQU3l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2021 15:29:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKOK1A146994;
        Wed, 17 Feb 2021 20:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=HXHwPn4n49NmRvdLRZ2lIEM+fuQIc1gTrIMasqA08JQ=;
 b=Z8CClcVorSfOwg7ycKJ5yAe5BnKjMjOhHFi2spfJ+bwUoyXW3FjylOhtaNWo5QGLAbhz
 4PIgvc/dJQW21IoAxu5/o5GElYKxAnPnOKmJhCdXSaFU9+8WND5iTK1dUNTazH2kfqwU
 f35VtSdpcWo55vNSwMqb2DaM7qRm9UTMa2grccOYI1tkf5YD779wKw/emzZHG9rG40sB
 0+ddWxym3N5H0iq1eyXHOa5HVt240W1K+ke2fmUT8j/HsfWGL6JExRXbtK4TJSwpDHq8
 p4Aw1RWE8z4DRrkWtaoxFVjdqYhZ7QV+pgYHNs8ywGfMlt2U9gm4Pl/8glKr2fO0inLD hA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36p7dnkpj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HKQB6B191515;
        Wed, 17 Feb 2021 20:28:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3020.oracle.com with ESMTP id 36prp0p678-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 20:28:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyiMd5R6cL0sxGjh9nPNqt7S95vu/TlFkB3/Zpc4XD6mpEudKzfxvU5QJ5/X3LvcP0xAKi1x9s07frzGJua7Cl0nz34hH2CXqBC91280+b0ODIiEj5+UC5hwbjQS6mO7RUsfddpfKQJd3OhTSj5HEU3Idr/377C2p0ZQUzvf8PkDCJf7v8Hg7gVkYGLuCfm/qoxxxqcEu1UiWUPG/gVFHp/SYayuOJBfVVFW/uhpaVCDYLg7ssFrw9seelvA3bYnXra2ZSYim98dIWXQEQO1XhjKiNJhbxT/pEAwFpjmKpZjp0pBQdq5ZagLIbhWBWI8/lOxWV1HNliQFtoYRExu6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXHwPn4n49NmRvdLRZ2lIEM+fuQIc1gTrIMasqA08JQ=;
 b=iC4OWCkej8pDmF4o/ixFl1t/N4GeKqHXwoMiL7EURjkfHPG88aHErckqqcjsUYMb06vzg3miZxCooMKiWypoAlvwnCfpeOsjO9X43TWYH1wRxUSpLXIrRe8IIoKiD8b2sAeipwcQxZ6MgO6ge7PfZt7on1vIXixup/NyDHu+a3NJpIqZ8ITKtObNifKjxWo7LWvRRchMvSJq/ZoQAOEz3I5UDv3312qKM15nzeb5HlqfSoS4G/AY4Cpc8BlhXVta2lNhLNJf+bPu9dM5Y+cuNmz1dkCMnnKWNpPl2G0bHZo0Ntde+mVaC7jAy7R2Jq2pZUcw0J8Po/YKg9BmGU8enA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HXHwPn4n49NmRvdLRZ2lIEM+fuQIc1gTrIMasqA08JQ=;
 b=H2d61sfjVy1jGgO44od82eiNNvLfABPBfmWNSw9Zawqt/UzLJ5xNVuGePePR+sqw+atNhgmsoPgLELk85q2UUSBE3o4sIQUpPtSh06GJrANqCkrFTdiLfUZdAXjIymPLNVSowo+8QIl+BEzmCojpWpYzwsMSk5LxSr/wBx1irI0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB4101.namprd10.prod.outlook.com (2603:10b6:a03:120::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Wed, 17 Feb
 2021 20:28:30 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 20:28:30 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bostroesser@gmail.com, mst@redhat.com, stefanha@redhat.com,
        Chaitanya.Kulkarni@wdc.com, hch@lst.de, loberman@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Chris Boot <bootc@bootc.net>, Felipe Balbi <balbi@kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 04/25] target: break up target_submit_cmd_map_sgls
Date:   Wed, 17 Feb 2021 14:27:50 -0600
Message-Id: <20210217202811.5575-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217202811.5575-1-michael.christie@oracle.com>
References: <20210217202811.5575-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:610:51::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by CH2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:610:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 20:28:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 977206a9-f79b-4f48-8a9c-08d8d382969a
X-MS-TrafficTypeDiagnostic: BYAPR10MB4101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB410130CE431D2F1CA0E785D3F1869@BYAPR10MB4101.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07o7E+p0/Z/3f7YYQ1nYDj4jA9PUlxu3OUYXulW4vn/za4soFMFx3IOZxnY306vRvPzRAc1evmWgfnH5lABuICzPi8outvOI1xt4uVgdLCg5vbqlW63gWmnBqIJJvXT5U6wtM6ZgFxeMYw58eqB8c8qUBmpGEALd7skOeWugh2vvJMf7RHGi/PN89wGNVd0sQeUwObTUrtn/2q46qr4JWfizsDNdQ4SEmM8z5Z9oNbT81Fkin8ca96vfsOAUvb+lPailoELD2Lu+QmNGg8xCPF8cWfuktG0NrcYta8c+lzdIhL9OcvA04gpPal1sECZA0+/ZKA4/i1kFsFpo1aNIIRvXqRSSVEOBDjgVKklUuKKqUm4P51hyyvxoXXkNspelDRiQUk64rpdzQwB+dYiWeWdPWhActDT/xZkfZxG8CGSpoZQ6kIh0eM07sJ1MBhSHFFFPBO0b2ThYuqTdas3qLyMA340SrHz02QbQP8NpXnl6Slk9ex0xYJR7Qcbk+OBt0nnrJkjmJCbz6qZW5chOSLSV+2eeeV5SyhA35ylXeR+9FmoQdfGJwmo4PUjg5OCbMbnWUNfdhaTT0NdWV+2sMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(396003)(136003)(346002)(1076003)(107886003)(6486002)(26005)(316002)(54906003)(7416002)(478600001)(2906002)(186003)(86362001)(6666004)(2616005)(6506007)(52116002)(956004)(36756003)(66946007)(8936002)(30864003)(6512007)(8676002)(4326008)(66556008)(66476007)(69590400012)(5660300002)(16526019)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Cn1Y00KGZQPMUuByFWLh6ClOCuqRiessTIF9XbQOWQGkpB7gjEfrC+7EV/Cy?=
 =?us-ascii?Q?D9oKoXNRNV6o5znMqd1FO3oYgyPASMH57rkymH0Q6sOL5EVxMzBQ2B9X/HD+?=
 =?us-ascii?Q?bUAc5k/Zd/UiUsmFcVqWQu9gW548Sw0fDPgM2G+LCUpaWiXWu7s8f2H45Irq?=
 =?us-ascii?Q?u06sAAGJ0atmVuZn0HyO3kjRsTEd5BQZm7Tid5TaODIVMlZrCwFCpfDamfVe?=
 =?us-ascii?Q?YFzgws5WPKSgwDkFg2Kq8ZMoTujVH18kTFwwpwLeDMVhuv0elaImGUNOSlla?=
 =?us-ascii?Q?sXSTpC2JGdq8Dr6Ozh6D/rFRd9rS7oJOF+Hw8F7HoIWgfFiktlul8bqO/YP/?=
 =?us-ascii?Q?4md6/L0hApjjVYWbBBYgPS2NvrJ0LrwEdH67xf8Z8Nulb3RS3lKjpvLxrBQ/?=
 =?us-ascii?Q?Gxc8N0ciqGsj6KqOxDT5wi53cfzB+Y3PfBNGIib3fdObUDmA4dMatwKM6CeB?=
 =?us-ascii?Q?0lwVgSw0tQdaei2goQJd88aSk3jQVFujBCkoW/yg9ot80Y5rXHv1ZLVb7hk/?=
 =?us-ascii?Q?T8ahmzrSPsPC8B6cEPE2BOpCIXiDUATW124pR+FGdD295IIJX3842V0tiuSA?=
 =?us-ascii?Q?NvpVa42kH4xhlvVGgolaZ/LCxC/wws7P+N/AEmY2EnaOVLbCPxVAjdUfOpkE?=
 =?us-ascii?Q?H4pLWtNw5onjnrMHhMSa3eB0Vm7QS6s09N3JnZOOjdo/WyeNBSAYD1BevpKW?=
 =?us-ascii?Q?ZqMDNNfEIvkh5UuLPzAoSgcJlaoTBw2YXv2DqPn+BTpzeGwphXJ2B7CgwaSj?=
 =?us-ascii?Q?UcoRwdnJuufZUT/S6b0d+N8Wv7Le6wYwnQzbdQvGvC7LJ0SRWbJr0VyaYT5v?=
 =?us-ascii?Q?80+urZoHUCLRI2prITdwHD548jhFXQa9wktj1xj0WUnRE8ZzO4uN8vBFT3Zp?=
 =?us-ascii?Q?dPRDKOcZehAUBIc9yW96J9r6oGhIahr59W92viNKUK6WOPhC3Q6gGJFjly6p?=
 =?us-ascii?Q?cvEBhJoq6z8MiDgJqYZGVjv22yDDDf5vm9PzUVnbicK1gSSNj4gGJgbmpPJq?=
 =?us-ascii?Q?GqH+DafJ5vbLRzyukYHVWQI24Intz46Uxe2NtaoYAP+rH3jizV2Bc54Xx+P7?=
 =?us-ascii?Q?2a4mcYAi2+i+z80Y3+mhlN/hUgC8m9fTcWkzryyPQ1BD1/50U+I4H7TOKR2S?=
 =?us-ascii?Q?sHLIJtG3UADGE0k5EUcwoqfTaJURd+lF2MQKzIGh+7wj5jpuQGVSOvymC6i8?=
 =?us-ascii?Q?maF96nH7sV8vwNHp0MciZXGCEldJywTMeQLrzIexRW75b5cbgEKxx3yK3nAy?=
 =?us-ascii?Q?jePhHoO/i2ftZxzW4Z1RBA/ZSbeCbIh4bkhaPkG9rTGPQsuD68j5uosgEZ6n?=
 =?us-ascii?Q?43KL5sDy7lNORF28uMiUGNAn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977206a9-f79b-4f48-8a9c-08d8d382969a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 20:28:30.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfUvNX7zHKK2AVyNpQkgfFi7X7m0eRSEfMcgTux+LKvBFbUo310AaD3CLkJJw4Pj11++CbknK07oZPfs9KyBZXWE4Gl3tQrSspCEBgbv3AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB4101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170152
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170152
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This breaks up target_submit_cmd_map_sgls into 3 helpers:

- target_init_cmd: Do the basic general setup and get a refcount to
the session to make sure the caller can execute the cmd.

- target_submit_prep: Do the mapping, cdb processing and get a ref
to the lun.

- target_submit: Pass the cmd to LIO core for execution.

The above functions must be used by drivers that either:
1. rely on lio for session shutdown synchronization by calling
target_stop_session.
2. need to map sgls

When the next patches are applied then simple drivers that
do not need the extra functionality above can use
target_submit_cmd and not worry about failures being returned
and how to handle them, since many drivers were getting this
wrong and would have hit refcount bugs.

Also, by breaking target_submit_cmd_map_sgls up into these 3
helper functions, we can allow the later patches to do the init/prep
from interrupt context and then do the submission from a workqueue.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Michael Cyr <mikecyr@linux.ibm.com>
Cc: Chris Boot <bootc@bootc.net>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/target/target_core_transport.c | 201 +++++++++++++++++--------
 include/target/target_core_fabric.h    |   8 +
 2 files changed, 148 insertions(+), 61 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 013f4a5e8972..8b2b805316dc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1571,46 +1571,31 @@ transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 }
 
 /**
- * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
- * 			 se_cmd + use pre-allocated SGL memory.
- *
- * @se_cmd: command descriptor to submit
+ * target_init_cmd - initialize se_cmd
+ * @se_cmd: command descriptor to init
  * @se_sess: associated se_sess for endpoint
- * @cdb: pointer to SCSI CDB
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
  * @task_attr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
- * @sgl: struct scatterlist memory for unidirectional mapping
- * @sgl_count: scatterlist count for unidirectional mapping
- * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
- * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
- * @sgl_prot: struct scatterlist memory protection information
- * @sgl_prot_count: scatterlist count for protection information
  *
  * Task tags are supported if the caller has set @se_cmd->tag.
  *
- * Returns non zero to signal active I/O shutdown failure.  All other
- * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
- * but still return zero here.
+ * Returns:
+ *	- less than zero to signal active I/O shutdown failure.
+ *	- zero on success.
  *
- * This may only be called from process context, and also currently
- * assumes internal allocation of fabric payload buffer by target-core.
+ * If the fabric driver calls target_stop_session, then it must check the
+ * return code and handle failures. This will never fail for other drivers,
+ * and the return code can be ignored.
  */
-int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
-		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
-		u32 data_length, int task_attr, int data_dir, int flags,
-		struct scatterlist *sgl, u32 sgl_count,
-		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
-		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+		    unsigned char *sense, u64 unpacked_lun,
+		    u32 data_length, int task_attr, int data_dir, int flags)
 {
 	struct se_portal_group *se_tpg;
-	sense_reason_t rc;
-	int ret;
-
-	might_sleep();
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
@@ -1618,53 +1603,69 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
+	/*
+	 * Signal bidirectional data payloads to target-core
+	 */
+	if (flags & TARGET_SCF_BIDI_OP)
+		se_cmd->se_cmd_flags |= SCF_BIDI;
+
+	if (flags & TARGET_SCF_UNKNOWN_SIZE)
+		se_cmd->unknown_data_length = 1;
 	/*
 	 * Initialize se_cmd for target operation.  From this point
 	 * exceptions are handled by sending exception status via
 	 * target_core_fabric_ops->queue_status() callback
 	 */
-	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  data_length, data_dir, task_attr, sense,
-			  unpacked_lun);
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
+			  data_dir, task_attr, sense, unpacked_lun);
 
-	if (flags & TARGET_SCF_UNKNOWN_SIZE)
-		se_cmd->unknown_data_length = 1;
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
 	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
 	 * kref_put() to happen during fabric packet acknowledgement.
 	 */
-	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
-	if (ret)
-		return ret;
-	/*
-	 * Signal bidirectional data payloads to target-core
-	 */
-	if (flags & TARGET_SCF_BIDI_OP)
-		se_cmd->se_cmd_flags |= SCF_BIDI;
+	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+}
+EXPORT_SYMBOL_GPL(target_init_cmd);
+
+/**
+ * target_submit_prep - prepare cmd for submission
+ * @se_cmd: command descriptor to prep
+ * @cdb: pointer to SCSI CDB
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Returns:
+ *	- less than zero to signal failure.
+ *	- zero on success.
+ * If failure is returned, lio will the callers queue_status to complete
+ * the cmd.
+ */
+int target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
+		       struct scatterlist *sgl, u32 sgl_count,
+		       struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		       struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	sense_reason_t rc;
 
 	rc = target_cmd_init_cdb(se_cmd, cdb);
-	if (rc) {
-		transport_send_check_condition_and_sense(se_cmd, rc, 0);
-		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
+	if (rc)
+		goto send_cc_direct;
 
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
 	rc = transport_lookup_cmd_lun(se_cmd);
-	if (rc) {
-		transport_send_check_condition_and_sense(se_cmd, rc, 0);
-		target_put_sess_cmd(se_cmd);
-		return 0;
-	}
+	if (rc)
+		goto send_cc_direct;
 
 	rc = target_cmd_parse_cdb(se_cmd);
-	if (rc != 0) {
-		transport_generic_request_failure(se_cmd, rc);
-		return 0;
-	}
+	if (rc != 0)
+		goto generic_fail;
 
 	/*
 	 * Save pointers for SGLs containing protection information,
@@ -1684,6 +1685,41 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	if (sgl_count != 0) {
 		BUG_ON(!sgl);
 
+		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
+				sgl_bidi, sgl_bidi_count);
+		if (rc != 0)
+			goto generic_fail;
+	}
+
+	return 0;
+
+send_cc_direct:
+	transport_send_check_condition_and_sense(se_cmd, rc, 0);
+	target_put_sess_cmd(se_cmd);
+	return -EIO;
+
+generic_fail:
+	transport_generic_request_failure(se_cmd, rc);
+	return -EIO;
+}
+EXPORT_SYMBOL_GPL(target_submit_prep);
+
+/**
+ * target_submit - perform final initialization and submit cmd to LIO core
+ * @se_cmd: command descriptor to submit
+ *
+ * target_submit_prep must have been called on the cmd, and this must be
+ * called from process context.
+ */
+void target_submit(struct se_cmd *se_cmd)
+{
+	struct scatterlist *sgl = se_cmd->t_data_sg;
+	unsigned char *buf = NULL;
+
+	might_sleep();
+
+	if (se_cmd->t_data_nents != 0) {
+		BUG_ON(!sgl);
 		/*
 		 * A work-around for tcm_loop as some userspace code via
 		 * scsi-generic do not memset their associated read buffers,
@@ -1694,8 +1730,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		 */
 		if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		     se_cmd->data_direction == DMA_FROM_DEVICE) {
-			unsigned char *buf = NULL;
-
 			if (sgl)
 				buf = kmap(sg_page(sgl)) + sgl->offset;
 
@@ -1705,12 +1739,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 			}
 		}
 
-		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
-				sgl_bidi, sgl_bidi_count);
-		if (rc != 0) {
-			transport_generic_request_failure(se_cmd, rc);
-			return 0;
-		}
 	}
 
 	/*
@@ -1720,6 +1748,57 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	core_alua_check_nonop_delay(se_cmd);
 
 	transport_handle_cdb_direct(se_cmd);
+}
+EXPORT_SYMBOL_GPL(target_submit);
+
+/**
+ * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
+ *					se_cmd + use pre-allocated SGL memory.
+ *
+ * @se_cmd: command descriptor to submit
+ * @se_sess: associated se_sess for endpoint
+ * @cdb: pointer to SCSI CDB
+ * @sense: pointer to SCSI sense buffer
+ * @unpacked_lun: unpacked LUN to reference for struct se_lun
+ * @data_length: fabric expected data transfer length
+ * @task_attr: SAM task attribute
+ * @data_dir: DMA data direction
+ * @flags: flags for command submission from target_sc_flags_tables
+ * @sgl: struct scatterlist memory for unidirectional mapping
+ * @sgl_count: scatterlist count for unidirectional mapping
+ * @sgl_bidi: struct scatterlist memory for bidirectional READ mapping
+ * @sgl_bidi_count: scatterlist count for bidirectional READ mapping
+ * @sgl_prot: struct scatterlist memory protection information
+ * @sgl_prot_count: scatterlist count for protection information
+ *
+ * Task tags are supported if the caller has set @se_cmd->tag.
+ *
+ * Returns non zero to signal active I/O shutdown failure.  All other
+ * setup exceptions will be returned as a SCSI CHECK_CONDITION response,
+ * but still return zero here.
+ *
+ * This may only be called from process context, and also currently
+ * assumes internal allocation of fabric payload buffer by target-core.
+ */
+int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
+		u32 data_length, int task_attr, int data_dir, int flags,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count)
+{
+	int rc;
+
+	rc = target_init_cmd(se_cmd, se_sess, sense, unpacked_lun,
+			     data_length, task_attr, data_dir, flags);
+	if (rc < 0)
+		return rc;
+
+	if (target_submit_prep(se_cmd, cdb, sgl, sgl_count, sgl_bidi,
+			       sgl_bidi_count, sgl_prot, sgl_prot_count))
+		return 0;
+
+	target_submit(se_cmd);
 	return 0;
 }
 EXPORT_SYMBOL(target_submit_cmd_map_sgls);
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 4975c4d2a933..4b5f6687393a 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,6 +151,14 @@ void	transport_deregister_session(struct se_session *);
 void	__target_init_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *, u64);
+int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
+		unsigned char *sense, u64 unpacked_lun, u32 data_length,
+		int task_attr, int data_dir, int flags);
+int	target_submit_prep(struct se_cmd *se_cmd, unsigned char *cdb,
+		struct scatterlist *sgl, u32 sgl_count,
+		struct scatterlist *sgl_bidi, u32 sgl_bidi_count,
+		struct scatterlist *sgl_prot, u32 sgl_prot_count);
+void	target_submit(struct se_cmd *se_cmd);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
 sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
-- 
2.25.1

