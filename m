Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244FDC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033AD61221
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245425AbhDMFsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:48:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344641AbhDMFsT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5k3W8010128;
        Tue, 13 Apr 2021 05:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=JQ35FG6n6qBmmqFlY7T3pKOBN8f6THpsDrZS69sAcJo=;
 b=DlJt0ckLEOCmGpOaz0ViThu4ftpQrG9aKt5Tyz5tg00aX/sKnRwGO6O/u/ieCN6gPgfX
 4ReVfEC1Uw4F3Y0cg047gFInYs/Tl+MZjmjKNm4TisY9wZP9wbQj6pGsefREm2m4Oi/H
 Tz1hwc5HWfLdyxrc+R9AO8QikmL1xYGHyBz1K0/POAIudkHCnqLSmzPewKYGtNpHEKoY
 7Q6ZeMK7JcE5pERcy1R5D80SPKQT8TMyG2wcPtLCim7RSFm2UoruhyrXGyiOY7E/sNdk
 hO8gb7F9uCiKUf3b+Doij0U0yZQztMEhmY5Okgu3IXfaKuUoPskU4b1+1VNS423qEi9U 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hbdxfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:47:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jcXa125402;
        Tue, 13 Apr 2021 05:47:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 37unwybx1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:47:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIaEnIFSvnYKoTBO1HXIW6OnS+OE8LGgif4NuJ+STmpXCazw3ijq6Au17AZ3h48wdfOkAjVfFjFk/yBNdP4267IPMra8JKNqRloWRBgiK0DkjnhMA0MFOwBpg1B3Sz8Eq9fJ2V22XGyw4zdfe95N42DxLms4T7VE2/xwv+Z3+Qaa7mHYFYyRbgRJ/5OlWcPAYulaLCQTlEby1hIGjyDt7HJ6KjLVg2ttnZX4o9ajzezVGkqQe4alu5r0GHT9fLmOXxpbaV1/b1kyD402czNJVa5D3hKLEdTG2XBncPjUWWgO4BlRKKHgE6JOOoQn3nuGm/bjo91I5f+SVk6tH+FBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQ35FG6n6qBmmqFlY7T3pKOBN8f6THpsDrZS69sAcJo=;
 b=h/EJajdkbEwxZa2QC8SYjTGV5vdrfvWFkLOU2eL2zBkpMM/VLzaC9zqjOgB23k8IscVIq5coxL8CeECGEu0gHf9OJyorouepomTsj8MGX/ZEIO9WuJGMPPts1UioQz/XGZVtYZljmqUQbEG2Va3o0tnGa+ZZC2vEdv0ppwnv22USvkCZnJWbTja45835vr6ObsEnigOxRy2Rm0a0vB5U3q7EMba6P3/YNYfW9jhnTQ7re+LMM7m2JdZwgvczqxIKkOKDPJxKWT+gtFQNnT/XZvoK0uUzehVePfb2KpXLlURlsTskKGxpqntdq/+P3y8yjM3R1IFyT4eEJwBt9gjy2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQ35FG6n6qBmmqFlY7T3pKOBN8f6THpsDrZS69sAcJo=;
 b=nyaJma5X/S0FdL7baikPjFIgl3vl4Pd7unlbjx6k2B1zSB8btCL7GNH7+5zyO8pI1usw8K5qW15jN6xQJcUvvWvAr5yeCc1ZQSF+WVaAx6NnQ7bVovW7WBx+huy7Gz45syaQsF+WFKucEWBG2qvcavNe7Ea0vyIbq5cyR7gm2tA=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:47:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:47:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, yanaijie@huawei.com, luojiaxing@huawei.com,
        a.darwish@linutronix.de, b.zolnierkie@samsung.com,
        Jolly Shah <jollys@google.com>, dan.carpenter@oracle.com,
        john.garry@huawei.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
Date:   Tue, 13 Apr 2021 01:47:26 -0400
Message-Id: <161828335261.26699.11136369175308184553.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318225632.2481291-1-jollys@google.com>
References: <20210318225632.2481291-1-jollys@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY3PR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY3PR05CA0042.namprd05.prod.outlook.com (2603:10b6:a03:39b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.8 via Frontend Transport; Tue, 13 Apr 2021 05:47:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a78537d-af3f-4758-8422-08d8fe3fa138
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46141644CB59DB161F231D478E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jyEYyzNUZRfEy1lbXrxc/p4fk3HND13cpJVY0iCQ6yX7Dv5Hd5NiG82500kL8GdsU2XJPU6HwVLGPlP/Tp1Qy7UqFLENFzD9hjFXJ+rkho6jo32Qxy9LeysjbMhmHsJwiUjJc8JG4rsxSTWKOOurslOe7v3ZuhOMFQmUShAOKXCr02D08x5arG0G77uZ5HKG2gcbnUodU0s3lFiAzz523JK5wd2zi4ig1q/TgqLL1WBIPVQ8Nvwg15nA9Es6guAHd6LsC6eOko8aFlR+m+AUTKoE74a5usZDO1h5KUcW2YLwdzMeSj6p0ujzBgKPv5Ve6axARrZEnhCqDJlfO3ifjd/p+bxmpqKGA/PIdSyAiBVU5h6wtJH+BMoPVxS7z2UDCHplp4zPzUidbNIh60fnUmfmEDv2AItVEWCft9WBRCCcSKTQqyNn67KRXQkT0cUFnhm27ebQie4G5KOEFt0wORrWURnnDP3R3SWKDp1UGZdEsbO3kjPiYteaDV9+TPdNr5UBDh7pV0cCFfSIE0jdnkDfo6s1rIRizi6/HzujuHgBENss1rpmoAhNCU7FFSINMLljEkbLt061CAlT14JMyRd7iYumzqmShyKB2Oflr8k3hs5lUsmeflhtF8CZc5ppUDgqlZUZ9lX3VAgFSMVykQyK5BVM8o8qefaIfkt1vQASRgSpAHX4ZfN1elZcqBqZd67a2Nh7isCuxTm6fYayTE6PWGRGkLkdTFVyBf73S7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NWF2UU0yMlBKNUoreUkwSUw3SGdUOTJidk42QTZGTlR1L1p0YW4xMEFZMldi?=
 =?utf-8?B?aS9NWjRFNUpmVVBESHZWbi92Z0Z1WFZLZ2hOV1NyZXFnUVNrUUFHdDVoY2hM?=
 =?utf-8?B?ZkpOKzY2ZUR2LzAxZDRZenY3MVkyeGxBdjdIWFJqMUJCbEwvalgwaTllMXRV?=
 =?utf-8?B?aUozcFVnZ000WFRwb0diS3YwN0ttcWN0T3lDalptS0RDcllUMndhWkJ0c1Zi?=
 =?utf-8?B?MVcxMmhVLzN5Qk8xRjF5OGlJTGJWbkpQMGYvZGlFeTRSU21RbFhWR1NKNVlt?=
 =?utf-8?B?M1FTKzIxSjJtTkhxMVFmbUM3eSsrTEFPbUswRzdTRUF3ZHBya0Vzc2Y5SlU2?=
 =?utf-8?B?SjM4V0oweHV2ZHQ0dnVqZDNDM21JdGlIV3dJOS9uSlpwdFZjK25qNWdlU3l3?=
 =?utf-8?B?TDRDSm0wMCsrV2pSQmk5ajV6UkFybkRFT3RwV2dOOE1Td3BCZmJBc016TTB6?=
 =?utf-8?B?Z2o0THBKbkh2NXJhbnF4dU53MGl5WUxMU0JNVFJnSElmMUlwQmp2RFN3N244?=
 =?utf-8?B?UElpNkEreWd2aENCYWFOZzA0VStraWRQK055VUFsSEpqLzZsWFo2Skc3Sk9i?=
 =?utf-8?B?MHA3T2RnWW1EV1FJV1U3U1NvQTdZOU14NXRRQ2JmNFdjNVp6KzZpVzNNK2FR?=
 =?utf-8?B?b2F6YUZuSDZXZ2MyNE15MVliREtocnpYSHlOdU9mWEd6MXJ3cTdIWjNBZU9J?=
 =?utf-8?B?b0hwU1Z2WlBKeGEvb1VvS1FrTzB0QVVHVVA4VjBQWTdZRDFFY0YxTmltUE9Z?=
 =?utf-8?B?M3Rna2ovNzJDMkF5WTBTc01BVWlnTmtka1dqVTJWUmhRVDZUa3JqTnZnbkZ6?=
 =?utf-8?B?WGFiMTZrNTFmaS83cXp0bVEzM1NiNkdFdWZHeDE2dzRMczF6dlVKWmJhRlJz?=
 =?utf-8?B?SjhXNEg0eGk1L2xETFN6RjdQMlVNR1d5TFkvcVduL0JodHVBc1NGV3RVeXN3?=
 =?utf-8?B?dlRZRE1kMWZVenpOYXBpZGNFUGpjeCtZZk96TlNKby92dHFsUFRXSXRYM2s1?=
 =?utf-8?B?TnhCZmoyYjd0MXlnMXFMY0k1RXNQWlZUNStqSWgvRUY4SFVmZ2RtSHV5Zlh4?=
 =?utf-8?B?ZW5xN3J0cXcrU2tSeTZZbkJmWHNpV1N5WEhFczdxbitIT1JqcGZWOVdDQmdZ?=
 =?utf-8?B?TWZZeWdQTlZhQmVKR09ON2lsWlo0d0lKMk1QeGpqRmVOTlZNV3NvckU4VGJn?=
 =?utf-8?B?S0lCdzRESSt0dG9SOUpqaVBPR2JiK2l0eTk4ZXNnOFI1b0U3RG1JQzFzK2lH?=
 =?utf-8?B?eVpFS1Q3QnNzby9UTmRCU1hHWFpFb21laUhxb3l1OTR4dWlsZ1JBeXRkL2M0?=
 =?utf-8?B?cE5LVUJ4SE5vTWM4VkdwZDZSNm9CNCtVL28yZ3NKUUExR2t2aEtlRThpdlBN?=
 =?utf-8?B?dnZvMWVuVjMwdjN3TTJrRjFwNkhvZ0h2ZGNkMTBSVDRKaHRvVWxOTlF1RW1p?=
 =?utf-8?B?SnN5bTN1OVRQbkJsYTNGMXp6dUhmbG80R2IyMEdHdmxCM0h2NEN6dGhmeEVv?=
 =?utf-8?B?MVJVdHArUWNoVi8raWoxeU1SNXIrbUMzWExBRm5GUHVoQy9kcGg1bTNaTi9B?=
 =?utf-8?B?UjR1MUsxa0lNb1BieFpIVnlYa29CZXVveERiY0pkTjNJaUZUWlUyUVpPWWxm?=
 =?utf-8?B?cW8vM2UvMkN3MHZURit6SnJvYjI5YmZscjFNenUvT3MxOWdhUDQvb001dmo5?=
 =?utf-8?B?cjcrRXVJVHVlb01OQVRscU04V3RzTnRyaVNBTEZaWGhEUWxZd2RjY0t3S2d1?=
 =?utf-8?Q?T1bItyNZy9XgdYhy5GJi3NycAGyI4Vw7lJ8RGQx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a78537d-af3f-4758-8422-08d8fe3fa138
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:47:31.5887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqFiHA9TZL0r4rWuOok5hzdAwlsrG2MvDgF1ho9/72jF/cVUTUp9xJXNF4wewt66shA7dYP0xEn7gemM9XQwZQKXfI18FonwRpbN2Sq3CD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: sSseysTNBwaZhtj3Fj9jEu87TMHpfSeO
X-Proofpoint-ORIG-GUID: sSseysTNBwaZhtj3Fj9jEu87TMHpfSeO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Mar 2021 15:56:32 -0700, Jolly Shah wrote:

> When the cache_type for the scsi device is changed, the scsi layer
> issues a MODE_SELECT command. The caching mode details are communicated
> via a request buffer associated with the scsi command with data
> direction set as DMA_TO_DEVICE (scsi_mode_select). When this command
> reaches the libata layer, as a part of generic initial setup, libata
> layer sets up the scatterlist for the command using the scsi command
> (ata_scsi_qc_new). This command is then translated by the libata layer
> into ATA_CMD_SET_FEATURES (ata_scsi_mode_select_xlat). The libata layer
> treats this as a non data command (ata_mselect_caching), since it only
> needs an ata taskfile to pass the caching on/off information to the
> device. It does not need the scatterlist that has been setup, so it does
> not perform dma_map_sg on the scatterlist (ata_qc_issue). Unfortunately,
> when this command reaches the libsas layer(sas_ata_qc_issue), libsas
> layer sees it as a non data command with a scatterlist. It cannot
> extract the correct dma length, since the scatterlist has not been
> mapped with dma_map_sg for a DMA operation. When this partially
> constructed SAS task reaches pm80xx LLDD, it results in below warning.
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: libsas: Reset num_scatter if libata mark qc as NODATA
      https://git.kernel.org/mkp/scsi/c/176ddd89171d

-- 
Martin K. Petersen	Oracle Linux Engineering
