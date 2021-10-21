Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA968C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 06:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D3561183
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 06:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhJUGZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 02:25:11 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:6604 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230515AbhJUGZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 02:25:10 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L5wMpX032749;
        Wed, 20 Oct 2021 23:22:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=u3VVvvGOTC+Ng0omkU5yspvArYR/iTas7DCYbPKcvT0=;
 b=CpK328LCbvwkbBe0PEfJhelJKjJKV4SOSDPqsuv5RPRKUEr1HxwmPwUcwreXUtK/TL+2
 yjMknfLmANJ7dcIATFSBU8wQ1dgNoTA1RUVRQnm3pwBXWnXIGg0OZbBVhWddfrwKJjB+
 QkuuJ0fyeJ/2G2gtvSMqUYjYVl8P7rPmeAD54aPp0+vNbZNweFKMw9lgBdsqIYd/w226
 H9qjBIql1x4OLICEroLsILsEwY842IbSEByazJ1MbP3sCrokLRM1o/Rot1/Mk4vsp+PQ
 JVJnxxPdPd1+Z8RlSXQsinoknekq7iOMxR4k1Q4h/6SEUqsj4EX7NtHOMYNUYMsRLXTE PA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bu07t03b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 23:22:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhPO/InZOhx+QT3ld1P5v+b6b95vE3q0q9GlSFzg+PHCPWBM0gpIHaprGncF1kDxWewi/aI0qRVRW6DP77VJCKou2Zb+DiZ0YFzoLM9NizC9ulYe6NyE7D9UypA/f3KycRRUGeYwLlttLOQI/YCQMy4beNj8KsTZ9yOmbyWlwtcwZcunyIqrFK5gHQQOJRiTaXXQK1TUdCN621kgpi9I5z+HX53ofD//xrmRnQNcFzZuj4OoEbiceVL0FqeWFryevMydxEeE7l7wDPMR9rOE7Gmd8ooeoJuFr+zlRjdHVv1hpWDeDk1baTdX0svuA/urMoPXPsWvf4UBvfEQFgcHVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3VVvvGOTC+Ng0omkU5yspvArYR/iTas7DCYbPKcvT0=;
 b=XK11VaUVnc5TvyRqLOkAK5lY8Tk0uoMfN5nQTbMEDNs48rQP9xaF01t7M7JDnxIximIkH6tVOaljOo7Ob3uBzOwSKXiHLS3mWxTCCulqgT+VMMjm5lLovFRr11NvyTenI3dGIZglq8rNn1KuBb+FoRzVoR0rajCLHunJdo9FX9EzJg76xDI6ESCftm/mrvsYNimOxxzpgjXIjEfteWse4BSOVkvEZ4WafBT9/eRrDYg1CZ/Ma4H/0wLDz/PplnDtj0ASnxuNQgQec2E8lHtZDLOHlvIs7MWsgL/qYVxaFWd+BQWLzhhyXX3o6eL2rK1zBK7V/GdyCPd6DAAQINxEDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none
 header.from=windriver.com;
Received: from DM6PR11MB2747.namprd11.prod.outlook.com (2603:10b6:5:c6::22) by
 DM5PR11MB1564.namprd11.prod.outlook.com (2603:10b6:4:d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.18; Thu, 21 Oct 2021 06:22:46 +0000
Received: from DM6PR11MB2747.namprd11.prod.outlook.com
 ([fe80::b431:e0f0:891a:f6ec]) by DM6PR11MB2747.namprd11.prod.outlook.com
 ([fe80::b431:e0f0:891a:f6ec%7]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 06:22:46 +0000
From:   Jiping Ma <jiping.ma2@windriver.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        scott.benesh@microchip.com, don.brace@microchip.com,
        scott.teel@microchip.com, kevin.barnett@microchip.com,
        Murthy.Bhat@microchip.com, jiping.ma2@windriver.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yue.tao@windriver.com
Subject: [PATCH][V2] scsi: smartpqi: Enable sas_address sysfs for SATA device type.
Date:   Wed, 20 Oct 2021 23:22:39 -0700
Message-Id: <20211021062239.185327-1-jiping.ma2@windriver.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:a03:80::21) To DM6PR11MB2747.namprd11.prod.outlook.com
 (2603:10b6:5:c6::22)
MIME-Version: 1.0
Received: from ala-lpggp3.wrs.com (147.11.105.124) by BYAPR11CA0044.namprd11.prod.outlook.com (2603:10b6:a03:80::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 06:22:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46434145-eaa3-4a28-ce1f-08d9945b32e7
X-MS-TrafficTypeDiagnostic: DM5PR11MB1564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR11MB15648BC6FC6764B4B01B3778D8BF9@DM5PR11MB1564.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4t4v7IUk5EjhyHmN7+3TL3YhpjNvV395LEORUVfJBzTl+XH0PTLZUAQ/fbBHmh7sNSmJ/hjuPFJiLeQw3AkoG/HQGp5Syuh0iOCme8pgXcgjzBIQ/NZNwE60tNCzgEF2R/y+0FIkLW/9X8+h34aEbDsDKnS3rGM9uqzKr9te/3XOC0YG3NsQcN2fs03uMkM39qJuAAxHLDjqR4dd5+SZMSx5vnJYJITeeVYhdgI94kWVIO9xvB5LjNVQWZAQmlunO9ilzceQjQHTGCT0BPw5SxBcFVK6IxP08A+Ko4nnvjkNYaTT9iqVn7fYbfaulkUCN8eDS0aQ2QZ57wJaHVpJU70Yefs9KRL99pYrYkTMhROyOixpyPZ4bwhLtYk/79hFy6uvgcMnCqwrDb4meZ3GZmsLQUwmLFlu0d7g90uxSBrAfPzowtBDoE6dXmLQtm4TBkkff7JwkgLU8L5Kk9VC7pE48yBX/ziijdtqyw3KadFYIS3cL71khX2DY4P40356dHj8Xkk3axEn6TIoSni3oNd3VWsBZCN6EH/4YZHBgpuA2DgBSDDE3MxjJSIJePpQjWvc2NaYqZPKFhmrrjHnMZTaNzPQ5ZNX2eAFDA4ZYcBDNDfuwMjl8XmdvkgH7xEJaqL2Si9IgYieqmHiX8lH++MvtAIly2zQbseTiBGzxI54Ij6y82xs/0ZEARF/anZPuTrmctxmxEZqhyrDlTl9NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2747.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2616005)(186003)(6512007)(956004)(2906002)(6486002)(107886003)(36756003)(66556008)(52116002)(66946007)(66476007)(38100700002)(8676002)(8936002)(6506007)(26005)(4326008)(83380400001)(508600001)(5660300002)(316002)(6666004)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yXi6HEzOfkJPuJZ7zPPugrOrv6Nv/sexQmBTJoqbewnh+OTXJf4lwDsN+AT9?=
 =?us-ascii?Q?1TQz62453cyVNLIG0pyJ2BbsYzIrfBQIxmLk27LwUQQY1f5AQFYv7TJcyXOW?=
 =?us-ascii?Q?j8nvU7SlPawhRbJ6apIoOcSaLZRHYg5egO9CqlhAYh+7E7pEDjpZylzXnLxB?=
 =?us-ascii?Q?l3ljGApDiTsGgk/c4smrLNX/TZVVfA0aMlAzU+Omx63w7xr02zS7BmbcSDpz?=
 =?us-ascii?Q?fWavgdVfngf5/StBOXb3dUsEqEH1tTD/fDW8DLa1hKJJJfXkUiosK34MxUgx?=
 =?us-ascii?Q?G5iNOmBmW446FSuzBg++mmWTei0kn7HV28jmOQdENFYsNKTMJDDi/ua1gCKk?=
 =?us-ascii?Q?h7dXZHoEaiurvfAiIceBjS9cA9lpm0b0+my0rYjQiUf52yHyultiU93HWzJt?=
 =?us-ascii?Q?8cYYdr2WiPg4rriZGFg8ITZaZKo1edDIo9EjEFCw9ch9EaMZES77lLJJGAtJ?=
 =?us-ascii?Q?D8W+Raei/lOaDXQC1sXgnrzkI6G2kBlY8nHkdyMsVTAcZROYIS1ZdvHYZehr?=
 =?us-ascii?Q?TfAUD/7RSKsDs9PfJu5pf/I0NPMmowR2K3AZZ4NRT8CCj2yJt/TMuCLsGFZq?=
 =?us-ascii?Q?NhEnGcyBNKA5XzjH0ZxInv70OSsCVPGGtMIXoNTnn3Cqc2FGWRnjvRUxobvn?=
 =?us-ascii?Q?axF8hsQc/7wqqsczYZxygVEIKBy+NNyOAUi4WIelVccGwhHJW4ihp+4I7NGs?=
 =?us-ascii?Q?+y5ZgLZ8J0qlhG+s5LWevUcAC8nsCIJdde3iV80yfMdVCV1d3/xorBd4nXFn?=
 =?us-ascii?Q?piQHnEmOwFVJb7SZMtMBSnjPQAb7x+yXgM8VL5xr2JS/75bMKHSFrmTcqhX/?=
 =?us-ascii?Q?elF4sfJfZ45Y5o/TicT6WgFQv5W20nQWaY6KgMn8MrMpiEur1YKaKEySaKBH?=
 =?us-ascii?Q?1gmY3/d9hR72b8FwZ3xVgRsWu+w2gKZcbKvMkmvEi0yVPYae89Oz3zp5M3Cu?=
 =?us-ascii?Q?hiI7ggb6aV6UjxjwEfyVWg6bivRSTN6lLl00hQOtX2jEyrRlicbcio0/Lf7g?=
 =?us-ascii?Q?iU2W4TgKR4frPakSj3nd9yAUikGq6me2ogF68RC07dm5/ZV+OxFUut0TLuxw?=
 =?us-ascii?Q?YP48g81q43A4NkPtGASywAac3KfHBonxwIF1L3fIh72dKLuPjnbvXoxPxyeg?=
 =?us-ascii?Q?wYkeOTtiXQT1+oPT9xgwqGw/F0jgNkyjytN4EYO47PekMA31e6PrDFrFGBXx?=
 =?us-ascii?Q?ZVNTpu26RHtbxxXJIQ5Ti3Rl7+odnrcsGp0cEqQDQnUwHNus4IadrGGmjGTh?=
 =?us-ascii?Q?/xgjXvGtpqbMAlR6pZix75RR5K4QkaVDm3bD72SJSYjccR/q4P/p6gOMQQ8K?=
 =?us-ascii?Q?1tOqcFUeygZ0S/GPCMlddaGq?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46434145-eaa3-4a28-ce1f-08d9945b32e7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2747.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 06:22:46.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jiping.ma2@windriver.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1564
X-Proofpoint-GUID: ZXGclHwBup2Box5AMma3toGOFzVyo6ZA
X-Proofpoint-ORIG-GUID: ZXGclHwBup2Box5AMma3toGOFzVyo6ZA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_01,2021-10-20_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We met the issue DM complains that it can't find the disk specified
in the deployment config file after we updated the Linux kernel to 5.10.
The error is "failed to find disk for path /dev/disk/by-path/
pci-0000:3b:00.0-sas-0x31402ec001d92983-lun-0"

This happens because device type SATA is excluded from being
processed with the function pqi_is_device_with_sas_address.
which causes all SATA type disk drives to appear the same, having
zeroes in the lun name. /dev/disk/by-path/
pci-0000:3b:00.0-sas-0x0000000000000000-lun-0

We can add type SA_DEVICE_TYPE_SATA to class device_with_sas_address,
since it will also get the sas_address from wwid. and works transparently
with the old kernel without gaps.

Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca..df16e0a27a41 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2101,6 +2101,7 @@ static inline void pqi_mask_device(u8 *scsi3addr)
 static inline bool pqi_is_device_with_sas_address(struct pqi_scsi_dev *device)
 {
 	switch (device->device_type) {
+	case SA_DEVICE_TYPE_SATA:
 	case SA_DEVICE_TYPE_SAS:
 	case SA_DEVICE_TYPE_EXPANDER_SMP:
 	case SA_DEVICE_TYPE_SES:
-- 
2.31.1

