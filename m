Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E5EE936E7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 21:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243994AbjJDVDA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjJDVCz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 17:02:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BA99E
        for <linux-scsi@vger.kernel.org>; Wed,  4 Oct 2023 14:02:52 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 394FIvYX014453;
        Wed, 4 Oct 2023 21:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=jRiB79JWME0fB9GF2PCATXgDxhvS4u19VZe6zw4kxpc=;
 b=LKVqgEdPopTSLAiL/pwmZtLJNmvGSul1o2vNSZTx9E3ihfxH5TKFm5qspStdQHI5xeWZ
 5aqRlqZBc4ZFcVRdKXOWJFE5N4UYw5rUSIXxf997bctPP6VPcPcPpx2GKbu7FLYDC4zJ
 jI/4si2xskkxXu2F3FRPmZZkDQMbIodQaUAVer3NKOOPgsFnKwukps7oXEJgGjSh6pyt
 fh0VEKyJvFEQNNABYwC1wEq02wyhkcfKgD8040LYNGfBZ+Yz0c21n3PyQvVEHypmruUt
 LMD76jg2Rj/eUD+IEMLKmYcBJyB//mgVWjJSd2wKPDaRWLU+pNjP4c0I3Uh76EnGgZhp Iw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tea9283mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 394KQ8Tk033614;
        Wed, 4 Oct 2023 21:00:44 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea48as2c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Oct 2023 21:00:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWNey/pjIYceu3933mzSOfjYjTJBqOkGrCtUSUexS3UpNQNk3rIlNPHGlnpbX6ydODzjmrlSNv+PWNOKoduGgSU5jhWXlMXYI32epnzCSyEDwDwosWjzIH3QGmh/rmxqk1hXD1oJUhV2OzzuTBQ/PVd5UOuK9KKt+zJDwoT3qNHu3t8ty0H9o9v9PVCnNSaj+1u/pFM8fLOEHMocJsZw1bYir0gMDEBaejeydz+AkefDqtouCVgnhKxaHyytVA55zejvlW1SWm17EcgVJvHMwzhZbBsw6PLoW4jdgQqVL7utpucU4d/kIStyKDpyzRaqB56g1bPvh7CdANyZpxr4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRiB79JWME0fB9GF2PCATXgDxhvS4u19VZe6zw4kxpc=;
 b=OZ8NlFeYzmdG/juHieKZYOpl2emo+CBAyMf+FAGDHuEp9/525hLWe3oBDTLrHXEYgEVTlL9Mi5dwpmKm4O99DKOOiLLwWdBFzz0xlQ4MGqscsrODbQmhOhC1QbIcCL9WCzv6+G1Ilu/hsUnwEyqZbqVv1pGN4p/+dEw6qviCzQcs9fiVA9LwbX5rg6XW/tfvNZoFrI4tOgWoAd2qk2UmTbvYfhpJlxevduHEayI8v+iCxYaRGvKcbWvcemY+48fI59a9q9D6cg8nmDWLDI7O3Ju4SlBqzkBnySkR87N6Ug9cMRRPZp9FFVavDk0wgTG3wG7eqI5DvdhrBvqZr53XKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRiB79JWME0fB9GF2PCATXgDxhvS4u19VZe6zw4kxpc=;
 b=c8+NCacL99PpGG0MxX1Ajv9tG1n8QZGktq3hj01LC2MRwdKoidD4I+rxh7wUhxTcpSsZKi98YzrZmzjPFdNxWJjrIB5LMHtq3Y9Gv2hqBwXl3ZuCSL9QSWUfA78KqdAiwvvd1BLKVhSl0jn1AGxCpYIZyPwRokgFxM+0JKPzHWo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5567.namprd10.prod.outlook.com (2603:10b6:a03:3dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Wed, 4 Oct
 2023 21:00:41 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Wed, 4 Oct 2023
 21:00:41 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 12/12] scsi: sr: Fix sshdr use in sr_get_events
Date:   Wed,  4 Oct 2023 16:00:13 -0500
Message-Id: <20231004210013.5601-13-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231004210013.5601-1-michael.christie@oracle.com>
References: <20231004210013.5601-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:5:54::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: 9535acd8-3d10-4fdb-69a2-08dbc51cf69f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XLUbgPH2+RniWbj02t6oR7ImnODZxb1Iq50zWmD0bR5qebwWTXhQefYOWsBzEBrz7fJMTDLGHIZg4jNxa6aNlwlFvwVQrSZS51QT4EhiMPfShmN+DYWPVai4QCr7oci+7sx1R71zcNgKq57zz1P9ZcqdG403FuOPKFQkwVddpeoK8LUw4nCbF7ovxAkC3HoJwj9woRZY3JUVOraiKO3C6jyF71K3klaR7v0EA4zShdgyY54H7GKw+sTM+h8v3QExCZBG6tPgetBr9ky3+WLa8RpIV7myP6x8a6lByCpDfOYPN+yYxLNs+kETPHZ3xsS/IsPjVsEeJs1RuAmf32slR5eR6ZnRBfgwLar90E2CWTrewtPxFNXN9ONLWAO8ZCTodFBnWQhjjwzYzNyPCyl92XafMLFBrivWoKJBJnLSvA8pIJ6rcTI9YLegfdSiemzy5aMyy5P9VyGp0fEkUs32+YGgOA//jP/lOJdYctOxtJ4IzlfhNr24Su6Am01lbudfTsVk6U/eTQP5s07kx3Oc9+LMprR11adj+2mKmZeW2oV6r/9WWOtWQxUi2aV/cuhr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(38100700002)(6506007)(6512007)(2616005)(86362001)(36756003)(1076003)(26005)(2906002)(83380400001)(5660300002)(478600001)(6486002)(41300700001)(66556008)(4326008)(316002)(8936002)(107886003)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hAu4q0HJa14T41cSnx6eeXGb8JIacsmLxcDzLJ2Y5etKMgNysWZEji+EAiiK?=
 =?us-ascii?Q?Ka88z01wE7DSnwkdSSxDiDYN0XGuTJve+O/zVZ6JRoBj8yWVK39FOYhUQSO1?=
 =?us-ascii?Q?yrdknzfdNjvKVPv1bK/x3dvS58TtVu79LADb2Om2+36VLsvtkvekcAkIVyxV?=
 =?us-ascii?Q?cB9QU11v+IMwHf0qo0vLgtIkN09f3liFeoNAOvBk769+OImeDTn1XMqDQF64?=
 =?us-ascii?Q?++AOT0gGe5t/XlcuX402vfqUb9gbII1DutwwqHg1qR5k4KaoUjz8O6zdNktk?=
 =?us-ascii?Q?s2G/tzMno+Xr9bLdlViNPrSK35ZP/LjQSZsy9SVz+cs7yxN4xS9Vm31AvXo8?=
 =?us-ascii?Q?9puks16O0taOrIgYv0jLIvaKvt92Njmfb7WvYR1pOdlMCmUiLtYvT6p8478g?=
 =?us-ascii?Q?d0ypw3xDBG/RDb0Ix2amrf3A/yEv1oacZDtaQM0h2YcWB5qGz6V67W5EuZ58?=
 =?us-ascii?Q?d8Aw44RmtDRKnirJp0lys9UJexGB+Ps3kTwx2KObkNa9fPePf04xoloHkDQS?=
 =?us-ascii?Q?hq/WOFBGccmImU8wVh3tRNk0OBlTSgvSsBzSx5MUl0BQPBU0T9B5gUajT3DB?=
 =?us-ascii?Q?CdkC5mtTpcrL8ASJKT//6mlxaRSxXktXO/q60CXVIua8QeCNFrik9toQHv1J?=
 =?us-ascii?Q?xzv8GmncHw8xFmsn5G3T12FnxaIdIwuc7+qVgV6x03HG7qUnAwRxVXvV8OpH?=
 =?us-ascii?Q?WHFmz85GBpcHwAUwQjXf1N2vkUzLybkgRNPXnyohm0KusSY30ThTH5ZM2g+i?=
 =?us-ascii?Q?eoe8aSeQeK5fkqtByW7Xn4aOqU+BxjCwrYDrPOGHvSfFuGsCSX3z3seVICNk?=
 =?us-ascii?Q?XqxjrQ6MjsjtwoLF7dow883sytxt521K6G3Luhm5xJY0RL6DZhLZK38mawLW?=
 =?us-ascii?Q?nIHfwhqa3EbpLagXEaNrC2AsWcCz12mwuLp6MfWZESPs48dfjZ/zOgF0I+tg?=
 =?us-ascii?Q?Q1aDHvO/Z9j41ufXlL2AOhSq+KadCgsaAjGE0bMsZTMWzv2FFrxrzliZAXG6?=
 =?us-ascii?Q?Icas9gTB6V9kag3aOz/if5B4SRCNpkNtISdAulKtYN846ZFJM/9BCdGauQWh?=
 =?us-ascii?Q?EC+kH8JM1+mxG3jMfat3tvf7gEchy0vXyY+9oQM4ZcX0SzlpRijhjGy4jDA4?=
 =?us-ascii?Q?y+7XsiM/3duDZE+z9mribOEU5l0frHVD7znDGfNblgG32yBazrdmIptMxlAS?=
 =?us-ascii?Q?fdjoMuDeOMoRZ+oGL09ZPQQtbSzU5uQooqWmTPURejLR8wzIPYazzV0yeYpz?=
 =?us-ascii?Q?7tUgUTnxBpt4fRyXPATkxlPq2kecFMyPUZtCtjxJXOwZtUOjzRettsPRp0Ox?=
 =?us-ascii?Q?Vk323EJmp87qnt/URpXnR3Q5KhHA0fvhS/0gzpaQOehTN2e2peaNk8HaXZe2?=
 =?us-ascii?Q?uCtngsfjgXb1tOjL/1Iv4gg0Fbwr38WTQQH3GC2XlzpWhZINCy2mFpfVeIv2?=
 =?us-ascii?Q?Q34Y7D8180TQ7qTl2c3kl5Qi8A3l5RCnQK1IsbCWglibJd+jR4DYBPANDdJL?=
 =?us-ascii?Q?PiQ0xh1tfC39S5+zb3QXapdLcQO0Kx7zaUCcix2CrhHdJZs6VQ9izADCp3P6?=
 =?us-ascii?Q?uBly9fOyRJuuf9jtuHRkDY5O5sWTG8nnLMF6IHwQDHViMqKqtFvA7gj/83OQ?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: y3z6T1JTJujw1c1V5SM8axz/Y9wMqbEsO6wcMis5If8TSu5b57sYH0btbP5z7a8q4fkKZCjY9zYAzzFJ7HHOv9z0S6vYI9fLtk5xNOHFWk6zwFUPiOABtNr8VJjl2+DSElfkXt5oTrdQKJW4arY8xsdowGN5+bRVdDakutVDstqvE+UwxVNbO9YPFa5rCuR4ShgP4MKZ0A7qtFJp41oVzDFmNFwMrS3KKNPXLvrbze8ZifMIQxf/3m1d4uwXwcWRiFY13fVzX7oplNtDiYI/XIcNQLt+ELbp3/1G2BgqyMtUkbV0wWmU90Pl5CrvJF7F5VJq+jUa6cWpZVDWL/3oHXv8rsUZzMuDqssFn0HDC7eT5vcRmca7Qm+GdBmAxS05FncTgqYaADF1XHh+sHSdqaVQv8iHT1tBGT06+VbNmze5U2tJgqTYiWpV8k6v0u86GGAy9neqlrEyaY4zuN987RsjvtV88MGnP9kckf1fBL1rKf0P2d4nE9fiF2KnEU4OCntJMfa3vSzWyhnYPyjCQ+m8niFPiiasKQVh9v6XHV7TEs85Hx5mnY40GndW6ySziFW8iD2jexF3X/6Sjvh2QnoAaRSDUAgiqqRqOX69NmafzvLn9Gc9pztYd4i1grgAia5YpD89izJIAWAO8/dx5TweejcjxMKOGLy647ChOSIo12cEhqpikuHmNLEMOav7shS1JJQrvnIHDTrG/Vmw9XOmxHIGGjhPrBaW9f1pInRTR9Bmt9hHwewvR4Wu6xEQz6c4mM2N58gaj0TlZI2koMjmiHzKYwawnONPk0vvsSCKy0QfSfH8hF8wc8aY3Ddq+me2EHs0w6U4aiKIUXoRqKwFd4n0k7wo6hYKwtVC/Y7EOlPT3S+/N9p2YMh0FOeM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9535acd8-3d10-4fdb-69a2-08dbc51cf69f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2023 21:00:39.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wsyWFIkE21cRGMd1LQkIawJCXLlmSoSzTAlW2Rep33f57/EVchDTKFMqIxRu/qv63kMkmryK5OIM07gmHks9ZqsGiiClQM8eIbg14+sfztQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-04_11,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310040155
X-Proofpoint-GUID: cgQrGsNovEhUkUvwLzqj2GdG0ebkuZO-
X-Proofpoint-ORIG-GUID: cgQrGsNovEhUkUvwLzqj2GdG0ebkuZO-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 07ef3db3d1a1..d093dd187b2f 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -177,7 +177,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 
 	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
 				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
+	if (result > 0 && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
 	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
-- 
2.34.1

