Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F39C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F1A61406
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhI2EWT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:22:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24758 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243941AbhI2EWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:22:15 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2QXLl007736;
        Wed, 29 Sep 2021 04:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VJdRxias6ru9DfiFUHyJuaR0TpNF5SspRRKWeWij3LQ=;
 b=SITqYdc7ljRGX/jg0anDd17YRRJn122bI+YOC0H0Lz8QBW/n68dayGIEF+NlvWn6L/WW
 9oxc9ZOGvTCNxKfydwXt6goq4yN4tlP3wRbtRaTytfqJ+YNlAXZmz0eE78ObSjmf1Qwl
 v/KpsvvJuY5Rm2VDC//QFokPKXhi8FKM6EZoMSgoxPJCO7k7p5HJh//rfLm60Fdq9ZOA
 fGGP/3puS8SSw/6cmLce4c6H5M2QEcRWwsMuBOgoTpqxw9G07TXRXNF01S/uv7p0lKzj
 bvmPghjojbHzBULQ1hdNc7epVb3/W8+4vp3DAGjgtiQZpp4M/Xw/+J0VEtL8L0k44RmK Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcvruex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AUVC030883;
        Wed, 29 Sep 2021 04:20:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3bc3bjb7h0-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iymHPRtkgW3JXVyvDxEzXr5BJQHZXaPkNl2h3d4toEepv+HrEkzmevUIyNitZUb+ZLlmJzC4KOEUNO1HVSQ9lSMKOIoQAAr1CIy9LUegf1hyJ1y8amvdzMEm33tGla7ifyVsR7GYy6QQ2anjO06MGx/JS4jaVna1gs9xNpVddxKe8p4uW0F+bpqC9jznoFmi9XrEePGoCa6e+OnZv3p8e6p5LlCrPa736PVpGvGWZLS+KwaoX9CcDobwNWWGmh+7sbqg9474XFp47GaAzv3KAOSc8Cxxw5zqD31v4GCFGOLP3X2TttFKSfwYwoXDbS14LGOQPXfVXlZb5VEDU2TBUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VJdRxias6ru9DfiFUHyJuaR0TpNF5SspRRKWeWij3LQ=;
 b=SC2UWymmjoJiN9m5EikbZoPd5gdmU41A4n4tzOe9e7EUxcBym+iQdK51kIqY2UmeB1Jz8r4qT9Py/Goz0rMASaPYv2S91YzUpVhYlUn7AqNfHnZDJdnlXqAy6unHNCgsih/qD1aCoeE8aawNrVFKWNx3YO2J8BwwROk+DxrDYWLktCvfPpY0f9C3C45NiSBCzlgTFyOtPPxPA2B2lcaFFkU4UqdSuelwiBl0HqTm2q8/gZtB9ddb18t80ieUJzt4Q0aa5GxSy1PwLRkRepfSdqpuzueyPZZGHUdN7Q0ty52SQIPcS2kOoLaPETOkGBX5K0Yk5wzX6qVXTAVOygkqWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJdRxias6ru9DfiFUHyJuaR0TpNF5SspRRKWeWij3LQ=;
 b=uPgaEvDCodfoFwIlEzn7x9MunSopHqTdn7xJtxnb3IzRDTD4A7y63KLgDGlH4Dmn36PmYWDlr0OrxFZwALkuutECAPryt/OCPP68+ZNMwrUwH+2BlVeYYry91uLRrNrOiKR9+8PVz90AN7i6zKMztfsc3vN6rgRh5GB7pFBMYrg=
Authentication-Results: twibble.org; dkim=none (message not signed)
 header.d=none;twibble.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:20:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:20:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     dc395x@twibble.org, Ali Akcaagac <aliakc@web.de>,
        Tong Zhang <ztong0001@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Oliver Neukum <oliver@neukum.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: dc395: fix error case unwinding
Date:   Wed, 29 Sep 2021 00:20:16 -0400
Message-Id: <163288294652.9370.4294891378413263010.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210907040702.1846409-1-ztong0001@gmail.com>
References: <20210907040702.1846409-1-ztong0001@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 04:20:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30ca2527-7af9-4233-056f-08d98300743e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45513F6EABC979AF72ADD5308EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmZ/hNrGIbjcIaU8Hu9QQeptN00+ymOA8CSX78kx9wcuCgQQDxUF/e5GRGXaOLLavYBSC31hfLaWePeh2wCZhJ1QegHM3bymhBMQxKXlPRDuMWA84qowvPcp1TXvyNXZpdlqzr3yh008fTg1+NBLO9gp6Pkc94eczwbnD60hpnKvpz5Qqt+5Yx4cWibi0EO9+TyiRdr1ajwg31kgY/FBtMZe1WQOpGw+ISGVW77UZpxv7r5bceTuPbqwQ4OgMelFB35rDSSr3we7mafHHsJhh4nrCCAaSkVxx7a0HQZPItQ47sCzLse4sms97ElGr8/QVjU0VtdFTBty8vaO0iuekNNLgdFiqs/kfojpAJF49XTKyE71fLtizK5bzL3c0yMZoAXAS37Qxoa+Faz+7fNyYAxZMi0z66sWlQzftHxcur+Ihevb6fNjaMXB3bwV8yeVvDhHMcWI9sISFAhsun/ENUX2GVK5eGOYzchD1Cnl7zwmj9G666O6GMVJ7kRst9qtAmhw0oZ6bZOVkNOvi8IAGtC1VB9GSKSkDXAT7M25drO//eyVCHLdWzvf6NcQiFeaYw7NXGZoWsU0UcddQ6vKZ1Y3w00lQaHCfL/6IKNctAwKwpo0kYToxv2ZvWibFPhaNSljrHwbc/Wkl7tjKMEYUSZ6L2wubGGgVmF7CrfJchDJ20zRFv63QtWNcNZlvkTytUjURGV8dPfvaapZKdUzXn6baOECl1MQkw7J+Rr7EV8pNEOmCNBqOmb7IrnzqHk5VUIiFl/TxbdlNis0nWVuoPOi9LS1aFVkVBunSp/bDJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(110136005)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(2906002)(26005)(508600001)(66556008)(66476007)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEJweDVoTGxJcmRJN014RUNiTUdGbUdRS0JLcmFtMnlSSEJhekVZK1FxSi9i?=
 =?utf-8?B?eGQ5VVdpUFdWNzgzdjc3bnlZUFdkMjhyNDgvd081bDNIMEFReGZmNFIyWkZs?=
 =?utf-8?B?bDJEN3pJcGc5MDlwbzc4Vis5OFpQTzQ5STB1eW5pSU5zUm5Wdzl5ck91L2dm?=
 =?utf-8?B?cUdsY053eUNyUzl4YlZPSlZxdUZ4UVRHV3liYjltWnNBcHNZLzY5aDNBVXZK?=
 =?utf-8?B?Y3F6VndPa1QvSnRiTTQyZmpRY0JCZEpTOERzcTlCTmhvREhMYS9xclJFOUdz?=
 =?utf-8?B?ekU0MGo4bnVjOUJabHkzcHRLd2ZaNklmWlV5eiszVlFtTWw1MzBXSjEzL3JV?=
 =?utf-8?B?OHdzZlhjL09QYUxvbVpPVUxHSnZ5S0FJTzNjR09CNjRoOVROWm1ISjFPcUV2?=
 =?utf-8?B?d3hBVis5NGpZQ3EyOFJsaHVmcEFrKzQvUy9sZlNuWXg1L2ZSejdQK1NVWUFP?=
 =?utf-8?B?U0ZDVGpsUEM2aFJNdlFpdVBGU1o4SXEzczVkRGM1UjJCM1JxSEhTYklONXZ2?=
 =?utf-8?B?ck8vTVhZYjR4WlhVMzhmTWN5NWIvY2ZvN3NHVkFyM0dNbENWU01aMERuUXpy?=
 =?utf-8?B?VTJRMmMycnd1TGcyd3FOeFdPSktGcHJZVWowZW1ybGxId3BwZVNYeGdxQlFz?=
 =?utf-8?B?UXpPZHFLc0xWaUw1Y3h6Q1BidyszcW9pZVE4dE9UUk9LalBYb3JnVUNQN0F6?=
 =?utf-8?B?aGFoRGpBWTVucnV6emlaNkdOeHBLZjJlYnMvWERBcm1URDQrNUJtUFJoWDNv?=
 =?utf-8?B?empCMFlhL0JZb3RWZC90eU4vMFcwU1FoblRpaTAwSUJaVWxDMEhuUVUwZ2NF?=
 =?utf-8?B?Vk5OV01FS1QyTWpSQjA2WUFOL3ZnQ2lnWGdlZncvQWNGL1MrYUI0NzJCTjVE?=
 =?utf-8?B?ZlZ5ODBVOFo0RnBrL2QxMEVRZGNiQjFCeVFuQVBkTkpLa2ZqbVU0WWFKbTIy?=
 =?utf-8?B?Z21RMEppV1N5RitGM3JXZTMraG95TWJsUDhmSnlZOUt3S2c3clJlRUNuRVdr?=
 =?utf-8?B?YStVZmVKRG5ndHUyd24zUHIvYkhHcHFIcVhwbG54ZnRRZ3g3djdoRERDQ0lM?=
 =?utf-8?B?VUx5VmlDQVlQcFlKc3h1eU1XU05BdE1VQWZ6VzA2ZVVRMFU0SXZreGpkK0tI?=
 =?utf-8?B?a2d2dUVaT1VwZ3FtU1Npd1UrbVlXNGRUeHFkYUxPNzdVcnFyWHBaeFQza1Ay?=
 =?utf-8?B?ZXJjcnlzTTBpV3IzN0ZnRGVnTGVuakc3UE1sVXVXZVJXZHRQdTF6MGt3NzBU?=
 =?utf-8?B?YjhRSVNMS0ZpZzVqZGllT1NwdjM1aHpPbDhLRm85d2FzRFErYUxzNHF5Vllq?=
 =?utf-8?B?VEtUTTVaM1hNK0drTXNqYWV1MU93dlFhbFdtbUE2czJ0MGIrUlBNRVl0WWlx?=
 =?utf-8?B?enZDTWQ2MHdIVy9MT1F6STlKRXRTcDdoVGlFQWpUOTZUYmlXN21XR3hwR2Fi?=
 =?utf-8?B?TzYvSUljYUFnV0x0MjIyVjlEMVdtV0V5aE1rZXB2d3FZQmVIeDh2eHJIME9Q?=
 =?utf-8?B?ZHBqL1dWemVUS2toTlp4TzY3c1BVdTJwejVCRjJiMmNFaFhxc1JkNEFtTCtU?=
 =?utf-8?B?Q2U1cDBYVEtCeTNNWlU1K2RLM3labllLU2toRGxkSG1FTnNGWi8vQWFnLzdV?=
 =?utf-8?B?ZXBiQXIya0lKRzJWdU9DTkxnblRhYXQzODR0Q1ZEUStzV3ZNektyQWduUjBh?=
 =?utf-8?B?RUlyQ1VtNDJaTEtwbmZ0WkFSSkNZVXBlUUowdmNxR2pqQ0pHUmZRaUVVaG5X?=
 =?utf-8?Q?2I2C2cdU2tcl6de28dS0Le3Ti+3KR7CrnvqFJqA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ca2527-7af9-4233-056f-08d98300743e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:20:22.4748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YOy3H+1Y3N6DETDNbNnF7ZxAVvLHvERhr607wnwoTYZBtRFqPY74nWTdW0wyRnqiDq8nNJZeGV2zYl3K3GZXBc2Bh0snQ9hZUE6RlQVwGhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: PuVtTKJqTTF9NSRo4aWoa4nE-xt9N6O0
X-Proofpoint-ORIG-GUID: PuVtTKJqTTF9NSRo4aWoa4nE-xt9N6O0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 6 Sep 2021 21:07:02 -0700, Tong Zhang wrote:

> dc395x_init_one()->adapter_init() might fail. In this case, the acb
> is already clean up by adapter_init(), no need to do that in
> adapter_uninit(acb) again.
> 
> [    1.252251] dc395x: adapter init failed
> [    1.254900] RIP: 0010:adapter_uninit+0x94/0x170 [dc395x]
> [    1.260307] Call Trace:
> [    1.260442]  dc395x_init_one.cold+0x72a/0x9bb [dc395x]
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: dc395: fix error case unwinding
      https://git.kernel.org/mkp/scsi/c/cbd9a3347c75

-- 
Martin K. Petersen	Oracle Linux Engineering
