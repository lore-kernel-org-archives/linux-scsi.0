Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F018E8FDB3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 20:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbjJCUxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 16:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbjJCUx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 16:53:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40589B7
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 13:53:24 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 393I4erQ008524;
        Tue, 3 Oct 2023 20:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=hpp3dor4hFf3OVHRK914BNwKq2IFLAkhr3N+zRMQRoM=;
 b=tj7yJFXOo5Pf4KmEcDIBtUhLuWl+gIBwrplt+lTLGvXolfKgzFI+gU9vsvrE3oDpuNHF
 WtTpRfmgBjVTWvqz08JUvCxuEC9qzMnsA1hPYdSiZq7ENpScowTDxPTuT9KoM4UtZ4Gt
 6s0yEeUpopI9quq+9ef0AWn1QJbVA3q80Ny52SERXrmg7ID1BlWKy3YgvlVQSs4WY+/n
 ui76+XUvow/PrmncBr/M4FlFtMZtgWWaDQjzYp2sdO5m2TnGxJAe0aXBKxZetdeKJpJG
 gjuOBXRLW0WkCvqXAQypc4hybf9O/OCMhFg5WWDwt5iNe4wJAKksuSw7HQi40dtYz8Tg cQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3teakcdsdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 393JXwR6002947;
        Tue, 3 Oct 2023 20:51:12 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea46kvc7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 20:51:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVEtu4HefEHVI/89zaU9s6umD7hpIIsVjGhM/Y5+1FmkwrnM7tAM/jOOGDE3J3WxhtWF3qj0R2WPyl4QpTZwZfs4K3lG/dvwpRoUnCOL5RH7ObQh986YMD/uqNDQtbCHn5dvoqMa3pkXgqmJqupk7ReI3FX8NIoDCmTAuDWtD3ZwYrCjfAQSH0H/U6VQI1QbNppVZeQZkS46rzQ2wC6kQA9WpAmgLKxh10RdcGtA3ZyR9YQRQ17v0HXVuMXUAZPP0KSHh/1PYKfi/dGMuQAaVn3OvNqiWbgXKMNWzGWYQhBo6Wye7PQ7f0DDIsqc263usShvyMwomMU3mCeU8Fj4tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpp3dor4hFf3OVHRK914BNwKq2IFLAkhr3N+zRMQRoM=;
 b=JPnwzpPnklQTR17lATp844+AKZnRgChBAIQ1jT3rpI8PLsNo7xMEILGIX1wj4nqGqzqsveE/j/H5DklyG79dhSw7TBowI3HyUipMYHfi1U7016Ew8ZgPcDwtNNq+xLgguabTyAEmJzUGuRQggdGMrCXkt19OM8HNqdWNgSNPH6vlhGho3Ee7HpI0DHW2CUZ/5lHdh1z49q7mnPMYCQe2MCwvVsrLWzj0IfuzEC85TwUpNGeFRJpc0h/i32hlxQKo5Qcvjo9pt791O7nvoAm77e2i9gtlNXNVV3QbwMKI4Ab4GdhW9GRL93JNXVu/f3SOo51cQK4r7dajzPUKh6wADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hpp3dor4hFf3OVHRK914BNwKq2IFLAkhr3N+zRMQRoM=;
 b=FEtizYLY3ZJeKDyOEAPgE4i2iNs3g2qKglHn2wbZlGm2NFCkwkZHU362aBZg7EJyvaIrFvH4ZIJYvWU9/KFIwDTVPb7d+Oy2UEGwOL3A6dedSx0tYTsSq9Ub9Q4a4z9DyvWnAOZLSdKS8J4ACm/ib9n1sRxLaSrCFU4FlmyCFK0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6794.namprd10.prod.outlook.com (2603:10b6:208:43a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Tue, 3 Oct
 2023 20:51:10 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 20:51:10 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 06/12] scsi: spi: Fix sshdr use
Date:   Tue,  3 Oct 2023 15:50:48 -0500
Message-Id: <20231003205054.84507-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231003205054.84507-1-michael.christie@oracle.com>
References: <20231003205054.84507-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:4:ad::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 701cd65b-e0d3-4d2c-7519-08dbc4527914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RXupx+GaetbI25V8ontJ6CMqEN7+e0weQpwMr3eOGw00ctEJk0ROmW8Q75kiUt6PE5Eury7zNkdnYWuij1RCZFcNfaqwJhHLaaJX7lJOXstHdX7wUkx73rJjcN3NjxLSgdcRoI0uXmi2HNwly4VwPKGn/bpP7DeiKQFjn+WRnraFnv/GKtDLTqhEAZoYXSLAaUCMhCFaweiBSpVSeY3cpsc7qd7AcsrmVcvQIQH9ccytVL/dbuvBy8vXXjqY+PhPM/kPHoXP+ZpIo4nkMjAEZTJnogaBqZ/ie9JN9IlxBbZo9U8pAdJQKWj5jI7/JXptLX6SQNzIzFXGEqOOq7Roqn6/O71kT6CYZwZ/v9BF796j90/h+WCWLhrztqMgct0bbed9lJC9Ii8gQuiU0MXUHLU1fn7VD7l771tPhuIab1a53VGZUntwsNTXR8dDmZrz/c2B5Ab5l5ZU3q5LaYXkzFUi8WGt8N4H4C7ZKY7yR/PyekJpk6lHHGH4SUW9SxL1ffd8YCXVOHOfcvq0KlK+ZmkUqhJqfzrR0+yi1k7jBmDUPR2Hxko8BFl3lHDb9K1L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(396003)(136003)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(1076003)(107886003)(41300700001)(6486002)(2616005)(6506007)(316002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(8936002)(5660300002)(26005)(478600001)(6666004)(83380400001)(38100700002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+AvpmeFnKR0Ox+/1Xi7vG8qXo9NrBoG89gp8wFaQd+sTh8i1uESdyb6Bi63A?=
 =?us-ascii?Q?TdNhZHNbYbmzFtoJOkuA5C2PfHbrazVvYhaxvq3db+Inmp17aX+4g7VRfEDy?=
 =?us-ascii?Q?a86VB8foWc3aXmKoaY97R+aySqv/yk8VLOQAU/Af3D0L94zh3MIEnQaPVr4X?=
 =?us-ascii?Q?meWTVsdriQrUttRvRmoPTX6rkSpJuFQflSKrX9MG64eaBaHnDsvkMyCH9Wk+?=
 =?us-ascii?Q?D/lHlck4mWLTKhzUUa5ZAlDWehRWC9wEac39exWOSQXbJtunxDGwUs/0M6O+?=
 =?us-ascii?Q?bOl8TDaEcxif8Gg+/KlWWHLlU/Kbk+05VQARXWzoGdOJT37M9Z6YYkPmJRfE?=
 =?us-ascii?Q?usZHaAVRVf2Iei5ssBOO8+cimV9CmMwyhpQHFk2lQ+71vLNrd3Hf91AsJv/N?=
 =?us-ascii?Q?1gH98+2pZdRrh/Z3uEgjuQOwenTIT0vCKQPbZnSPVgzTNmaSdu/h0dtu2aaf?=
 =?us-ascii?Q?a3Jkg8eaSP8cSdLcEPPleS/jIydqsMgeLu49t/Dks/a5pypTvIE3Y9b9s/ln?=
 =?us-ascii?Q?L4WyQxvsWSmiN5hN+qG69xBv2k0M2HliT9nNs7BO9+rPb+rJNost2o2SnRkX?=
 =?us-ascii?Q?5era1jl/k38gFyPldWR5WYTAlpt2AMvooV767sT9hulUgEH3lbBqAcLbezRl?=
 =?us-ascii?Q?LJWAcG9ijvgu2YX+iZWHxrDBquNU5/Hp4rsyG38XaCfARtvH1+QXGKxQSO9/?=
 =?us-ascii?Q?RwniaPXCCf+d3TG0dDJlFPEFpGFrMCxi+L/lFoPjXXPKQ1dkn/bWm0Mu4LJP?=
 =?us-ascii?Q?gyzSPuRVY9Hd+nrnjJhXltgQ+R/xI6tQh+51FiYTqtg9piEdfnp0UTIQvrlO?=
 =?us-ascii?Q?ZoR6O2fXl/WJT9K1kyhq7NbwQ0RyV+l7/VH/7kdFbGwpFZsgx0o8fPkL/pyx?=
 =?us-ascii?Q?cQTiqvcvj4YQ9/Nub08kaObaV12DVcbsPIibCrka+w6bBd6mN8PHNZy+jtnb?=
 =?us-ascii?Q?x3DWSpALfW1uqgsebEeN5wkH7LvoxFLRyPzNlPKwS+Y72p2qQpikdG+PbaUj?=
 =?us-ascii?Q?ccp927TUfrW31OsK74sv970K694A5YjeCKzYRhkCKuAL5U5mMdOuZKBb4hLE?=
 =?us-ascii?Q?g5QVCRXUm6PyM7GeD8GzucbG/s53LPVLAtQbZI9I4FdwTscXWZZMJqEsLmud?=
 =?us-ascii?Q?zu5yosB/XVrmnpnVN+dgsuVnQQ1uRzotg8GDgG+1b5QsR2QNgvMoYjpTw6h+?=
 =?us-ascii?Q?i43tgIBpNznn9zmEBPuSCxztOL6IqOzBtSykGCUcjDjhxgAfN/6GLbZrlk1W?=
 =?us-ascii?Q?Voxz8+3GcDwDeyCuUwicv7ciQZMZ5bUoAgwP74rUN8tyTAC0TTzkvG+5EfvR?=
 =?us-ascii?Q?M2jW7U0T3Xh9GX4/WwLcEeob743WwGO/JqJG89c7pbVlv6ixHwTdUnRaHasb?=
 =?us-ascii?Q?1hkYMCn7657tYaB3lHMQJ2JnyTn4ziQ3wPYo3GFue6JYItcq7a3a3UChu5FX?=
 =?us-ascii?Q?D8W6K8qhYDt26pfGT25xrhxsdaLuWuZap8Fz+bHQ1m4P8am8UjIPHNg3iiZb?=
 =?us-ascii?Q?KdO20JDEw8w6OMY3jW9EiprYz5vCrLr3zg3sGB5uVDjcpQWRUEl3nKnH8aJA?=
 =?us-ascii?Q?t0ycsNyo6x4xhaZtf+rwAeMM5aufTY4d5xWM2BCs1S1zvEwBL9DYyOT48fOr?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pwMk+egb2fp7SOH5ifvqPF4rZdkkl/4SmoCOPnrV6p2Vz+YyUXXUYRQk0zW7GdztERq2zbgcIzlgoLnmWr6cph0V+j0U55DXPKCcH+uBsgM7X0xd6z0y13EPn78NdIKzK1frKHNuAGl3GzYqE6UXugIKEkuQdxTWZ8pITJb85twpEDJ8TxMDFu98iMQE7zPdQqIlZkgoLQeyaZ687jeT26llm4m/lGwk4P2+bw9Q6tneuuytVoDsT5La9o4RqmqylBwwns+PcTIUIxkZmrNigNas4LkV6VFrE8KDGPMIvJK++aL2T/LaoQIalZW7pJC1ntJsxYSRb+lo5vQrobzdgC2I3us3I5cfIKmPmxKBplSgPOinAbJJG+yom3DLZApxM8XgqO53nFnBuZ5A9/Z3uN0KA7tgn6I5j+IilR0RS1nDUjgLPJjzGwfFwgLJMgjmJz/FTkvUV+VprpV9qfFJ/kPMgCBA1zf4/GaFyipuSFmN3rnZ8jcn/DN6/i7dCKXHvxw3ogH3SOc3MnShTvTE0fGSvtPtp/Ob9bg7+zLjO1+HWhRCg+YGAbKvGogQrre65JCrlRsp0Gdcq0/YPHkLD+dggmejRwlaeKK0IxJt4UNHzUQkLkUe3ejw4PKyjLtRpn/Z6xwvPiNVWk/2JxqPh597sq0hGjzKDmZbmqvTuErJ+U3HEN/gNUP0JldpqwPP+KTtNfHmbU1TTaIC5IYl59GRGKLtTVeoFAR0nZAygVmfXDYTVJwUiWa+nQzLHMocG4b8bC9FvyT9Hh3M58e4pnqbltG+h82UWYBo4wx4UQoMHw/QHvdJmWox4QcOx8FDyb7WdIGj3K4NIWr3s+Mb8roeX0ohjEH/OkfSu1Pfi0dnMpKoxD3QXxeBzQUTnpjv
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701cd65b-e0d3-4d2c-7519-08dbc4527914
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 20:51:10.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JfEoAiIpsNxNCLaW30exq+yzhG21vkEwHL/okrDRLzxNyw++sAZ9BTi+b7d+72O2tzNK2EUjQ0Ek9Y9I3NE/bHene7ohTZe6up8nhHw05J4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6794
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-03_18,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030158
X-Proofpoint-GUID: KDorgqw4d5-S-6PnVCh-PASG1RdlhFwq
X-Proofpoint-ORIG-GUID: KDorgqw4d5-S-6PnVCh-PASG1RdlhFwq
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
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 2442d4d2e3f3..f668c1c0a98f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -676,10 +676,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, REQ_OP_DRV_OUT,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.34.1

