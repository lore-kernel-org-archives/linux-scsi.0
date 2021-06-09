Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B176C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52DD4611BF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Jun 2021 03:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhFIDlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:41:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236552AbhFIDlj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 23:41:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1592gxEi084157
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=+kQyJ6w0S37LEA/5nrmj/v6ACmMO3nxPu2b2CgWMunQ=;
 b=c3l/1NqX6H5Y45Sc0o7sT7ui9EksBO0klc7ULkOMikYCPx3B7KO2icXz6acvKWkmgVSf
 p8XEpBIB1KB6MVawhpY4LBT3FlcOAdmtgqiI/SqInGREqY3mVJNin7exNnXnI0/s6/OQ
 LRPo77n4TUAumRNw2/FFVStP2/W7UFU3LajcKTxtW26ogOqa8bPNYJm9QDMqWHMicn4Q
 pYC2WVSrQpYWdUrn1wDfHZn/CioI8kZlKqz9uRXGUnxDVYyjXGtPKzZJcwOVhDNTFyDF
 UyDdHSy+G/dIfWikqCTt2kfSitTa6OkH3mLGVerkl8NHh3k27pFYHNa91PfD4T7drYGM Vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 39017nfrdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1590Z2Pr082696
        for <linux-scsi@vger.kernel.org>; Wed, 9 Jun 2021 03:39:44 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 390k1rhr2k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jun 2021 03:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EX6LSg/zUZUHTItQtG/CYtj8PZmJS3gO14n2bXipCB5SVLuoHLWJF4C+INceWkT7Qtlm/QVlN/gl9IIFWaNIFeSbsrvM551Eij/mMNKCooV/Xlumohwe0U0uNrmYGdBs/nMBOcCedq7JO6IxkNiq+6Pcj2jQ+iasmoO1G2kiOLXXJfP65EI300K0LCDHzkxyKeD/UODiDFNeoKds2OFTfgQ7DoriapGhX44rNWz8CaiArW1N56aQRwtJLE3AaeWCT6TXpIqjT1MA4xnwpX3PIsDH6cJhTFDbodPEiwUxCuivYisd/SiNZHZImv1+V/jyIRgZld5qSOyBSM5Ixto8Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kQyJ6w0S37LEA/5nrmj/v6ACmMO3nxPu2b2CgWMunQ=;
 b=j0D7Z1lRhNUHUGmLk9kc4rNix1vv2Q40W0Qz6LvxyzqSW3qz8aBCktIhRnnK8ax9YD27KRdit6wNqbhl2H31LtC2woBL0OzLQb4HskuBbysJzAK1uB4eB2KKy499HJMaOVFCpH53fMjAIgxnQEEGHmvS98Ad65Ewm1QOs8g7uLT0FCzVE569F2hEPK5pMLLk0NsMRGbl0Hw3TSNlwCkrwld5zp6NMTaJnNK+w9Jy6qPsBJVCxXOZubF4qOqHujAq2tq/Jkpeau2gwquF7HWvP4D/yKQmJahgO9svlhPZfQvNWDjvlO5JG0OtqXMb9+5H5r2ShSAWaaza8+U3dExvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+kQyJ6w0S37LEA/5nrmj/v6ACmMO3nxPu2b2CgWMunQ=;
 b=G7HD2xtbLB5+jfr0beeMS5vuve971kor8Or9v9I56hqNtrgcp/wEgKebzY1Leee6L0bqs+LLual+2RoJPObbLjPy6dv7EjZm34HEz2LBG2GiGPemgR3UI0IIDRg4u1gVaA2rgX7wITgFuaYBjAprwSemzQKYnuNi4Bwpi9r6Vkc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 03:39:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 03:39:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 12/15] scsi: core: Make scsi_get_lba() return the LBA
Date:   Tue,  8 Jun 2021 23:39:26 -0400
Message-Id: <20210609033929.3815-13-martin.petersen@oracle.com>
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
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0034.namprd04.prod.outlook.com (2603:10b6:806:120::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 03:39:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 097dd27d-3ab3-4727-9ad7-08d92af83809
X-MS-TrafficTypeDiagnostic: PH0PR10MB4421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB442151DA9190F54CA8910D328E369@PH0PR10MB4421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BUWcesAWjZFKXwYtLh48RMK+HZQEVZZ4S4upCYhr7lNPEUdAtNCLy2vDYloywQ+es5vFenPCkdz7qwU2Nb0OsZeJ7ZksBhkOyZb9AAkCXnpQZu3W6ojWuUohHzG6grRcTjfCNpIGWxrtdO7pYAEuAc8tnBYYUH9fEE5ekoQ4YGrcHqVroc8lBPpAqHpndFbMCk79qUflGRXJHta0PmOskxuZiUOL8q8mXO8X5hTMffSZ6V5N6wtUqHIrHGdlKH43hbEpe7LNeFKPvxLqz0A2cESeaB13Ric7a/ACZ1j72D+EiUwETxTBHHsjyQcyuvkPZyuzBQmQdzT3rsCGFO0ud7bdAunbA1pV3asTWogGROHphPxnWGanssZB3J+2u1i451DUEUyQrKn6zMEK28oJqfjEBvSmK+zs3XjsjuH7k6JXN6CjO1xneK0k5PB1OHOnUo7okjCU1Xzpe7GwCB0N/9+JQZwNZGzSeuR/lEMM6U2+2ldUNQSht2LSHws8bgwk69bD0MaNlz5oOwTayDCLHBzpWNy8oVZVW8MyUOrJSZyqhcL0C/7QK0+cA1xKHmH25LqTdCW3jnt9c/rbZFX6RGF64wLpZ9MBIQH9oteFypz9QfJKu4wR7lhhkL8AKWJE4s47iLwY2sG1Of/jbSSBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(366004)(136003)(8676002)(956004)(2616005)(8936002)(2906002)(6486002)(107886003)(86362001)(66946007)(52116002)(16526019)(66556008)(6666004)(66476007)(6916009)(83380400001)(478600001)(26005)(186003)(38100700002)(7696005)(38350700002)(1076003)(5660300002)(36756003)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YlFW0dA5oSxws29LfKwDdbwv+abuqZ4ctLgWzXHYzub4Uv7d2d13nyVbyaZ2?=
 =?us-ascii?Q?u788tyy9wh0dWLwBnfQ8Q96trI/P7sN72xUtySA0x9tkeA8fWrtng9thVbea?=
 =?us-ascii?Q?qlPOEU6L0Tiu1OWaqR3BJiSGEmqhjFdVWpVvbsoOgKg82pEETBUsf08ZcUdk?=
 =?us-ascii?Q?46O8/U7n1YB6RctUaTjMswrvvQYApMW/r/tHFpCZhAA81jNBT4pzVstWx982?=
 =?us-ascii?Q?CyNw9FPYDVBK6mfMhb3rCm5EM6u47B/Jeri/ngaaT/LTImKRPY1MgF97w3un?=
 =?us-ascii?Q?+buGR45dbiiKWgBadG2Gfm90W7gJcIq8eOfZD3eglBL5de1M/Yrj6kdPQZFy?=
 =?us-ascii?Q?AyGcCWuCuiqAiCiKnkbhnDRLJVjjmu/csqG9FY+Hpb9mdOnjHKJRKntqxmte?=
 =?us-ascii?Q?qm1nyYr8sQnB4jbTmBQuPLlARGGdAY/rIJorGhy/D5tac+enkZv2S1GXYFwQ?=
 =?us-ascii?Q?ASeeZb73Zq6TgcFW1dXZDNFmI6ys/rZlr23lj2+3PvzoKNNTtIYNbc3Y7AAB?=
 =?us-ascii?Q?D/jTONSK3s5UJImpxj1hdgfseiWUsz8325PEVETgNjgWaQ9G0iLdtd1bZYTr?=
 =?us-ascii?Q?xrRHteG9vJX/xjku5GSyXiQHUJwbnjtDsCOVGL/G6pQq2p/kayC70sK73y7r?=
 =?us-ascii?Q?9DgfadrCcVq3OzJTBVnf2JCY3HUuSkon9h9UTHqVfbqlQEvwOYR81QaBilBc?=
 =?us-ascii?Q?EA2mg7rU9eOq6YifRjgf3ZZ/7eTF84t2Vnn/G5oA0ir9p5AizgdUkBQDFtWY?=
 =?us-ascii?Q?OKofGuIwjRQbfKmDMVbLd25sL9GFj0S0mn+b3wuAMiFasbtnV7Eb4OXWM5My?=
 =?us-ascii?Q?suVvkB7vgsyA/v+N/OEBIGHJYXT32hXcz7jt41EQgkC9230FaYFy4L9+e7AL?=
 =?us-ascii?Q?235hMjWW5s6RgANYcyj0jqvp1nyJtANKsBK1Vec+R4lVu9ltvZCOIYaCi07v?=
 =?us-ascii?Q?rTjK1VkLW2jRn698K/Gw+LY9MyZGF3hBUg+Cc0y7JU0NEvu4naZh3lxTAbMK?=
 =?us-ascii?Q?KuEEV5yCYnhlVHVTG399u8PvZNrOWpq1Vs/j0X+HfHuCnJDHUSGVkCpHtnlS?=
 =?us-ascii?Q?e/5b7Vd9k2CiISkq206dY+Gbb/exKKkRAJBRUeSfsB39xW+OUNGiq8xq7Uny?=
 =?us-ascii?Q?hgfkJp2h2MOxiZ9p37M+1j9rww67jIHwRkFFfrISZmWRx+hx/F0u76OWBkDj?=
 =?us-ascii?Q?T8qKYhR2sTekmlOCtty82Q0c/cBLFPFhYGfpLb1oY5fi6g0Lp6/L/6bfhtrR?=
 =?us-ascii?Q?E7JQ32CKXDxH1CBxzgPxLrmoBlXofP/Bz4OD/BKvcisVc1WNTRBYkzeWRtk1?=
 =?us-ascii?Q?PZcKcKuQAsPjmePzWh7KgkuC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 097dd27d-3ab3-4727-9ad7-08d92af83809
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 03:39:43.1777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ks3rfnEOH/Do09gQ34Wm3Tqsoxz0iKw+5YvzrEPXoIzDUrVoQoqNdaTgDUkpm6wWlbHu+i/J7Pr8fyfNuuqegB0S8PpKK7JffWD4Y2KyJx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
X-Proofpoint-GUID: FYv8rn-ZP71BydYnhsIxhP0SmQ7ezAQQ
X-Proofpoint-ORIG-GUID: FYv8rn-ZP71BydYnhsIxhP0SmQ7ezAQQ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106090001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_get_lba() confusingly returned the block layer sector number
expressed in units of 512 bytes. Now that we have a more aptly named
scsi_get_sector() function, make scsi_get_lba() return the actual LBA.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/scsi/scsi_cmnd.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index cba63377d46a..90da9617d28a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -225,6 +225,13 @@ static inline sector_t scsi_get_sector(struct scsi_cmnd *scmd)
 	return blk_rq_pos(scmd->request);
 }
 
+static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
+{
+	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+
+	return blk_rq_pos(scmd->request) >> shift;
+}
+
 /*
  * The operations below are hints that tell the controller driver how
  * to handle I/Os with DIF or similar types of protection information.
@@ -287,11 +294,6 @@ static inline unsigned char scsi_get_prot_type(struct scsi_cmnd *scmd)
 	return scmd->prot_type;
 }
 
-static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
-{
-	return blk_rq_pos(scmd->request);
-}
-
 static inline u32 scsi_prot_ref_tag(struct scsi_cmnd *scmd)
 {
 	struct request *rq = blk_mq_rq_from_pdu(scmd);
-- 
2.31.1

