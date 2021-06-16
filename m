Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8BBC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9274561246
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFPDwJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:52:09 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4806 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhFPDvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:43 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kIQ4018251;
        Wed, 16 Jun 2021 03:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bHivoPMEMOA65BZBKYGvGm8umff3Xtz0Es/YwEC8sdg=;
 b=xVIX9O6lIeYoFe+j4b+11jGXO/MeTBX7XOz/n5Qi/dsVZLh9fsvtFZkbECtZwiWrDqxo
 GnSvIFPPVBw1JBByZiiazbj3fsqO6EDX54g+rryYpCyuXq/ocVJStABYb8b86E4fYP86
 khBxiAx55yuTIKTqropyB77+zs8gmZQgZqFkQZ+3bga+okh5LyO6AQmw3G5qvGdvF/av
 E0qRVRFXwdPG/TxwQXk9K6j9je7iHKZN6MvdRIlMYvFAVjVDobxaAMtLKqFLsNKI6GPh
 N6ouwIv2JHNEH8yh/Yo6/Z7j+2C+lhgITmf70uBg742uiYw1nLnk81O0VRel8ZqJT5Zb GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x06ht0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3ioix064553;
        Wed, 16 Jun 2021 03:49:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 396wanat0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dip1buiZGFq6X5cunmdQlXfeSqlqJ1sSnlwsz+G9XOw+lAK+K3XXNHStSIAhCNjnjKPm4QqCfDXqc/fTYyXwbft+BJU2Bn+7zDPbvMVQ7uR4AxUjwBM0/dG5yRLxbs3FLUKkSn4wxxAhlWbIwn953qUnM0SdoVEoODYwzkgSL5ZGb4nh+Zon9BnDMbc1FmBlk4iB1OCKolc3fORG3jhSokAwxorMiQJRWn0UNgXquWo9+dK36XcAx6EBe/SMEJuOoUQ61myv5SBUn3DAg22fFYvngek3X0+aGBkrfwFr11+/cJuE8YTy5arB4F88/FGifkqVDut6oJ2TbXPsZy5+OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHivoPMEMOA65BZBKYGvGm8umff3Xtz0Es/YwEC8sdg=;
 b=DLyJmV2rnBeMHhf2dXYFgs+7LujxgxO5J3PkEWCtDT7e66U6VOR9lh8z65LtMPnr8MZChSak/MM13uyK2kkXAkb27wg2s3hJ62x0Z4aQ5g+ZR2wxVX79VrKyoaqzCHu5TX72Ibiv1iqTLds6SyW+dTmi4Qk868ghxX0iR2zA3txj0fhj2ibJxcXVZcEDIqkRnCB0yDPJCxvicExxWlgfYWoTRCLhaaazXZgMQV5yfO9AqpW+7L0KZenP5XdAJm3tbDkYfMtTXB+WSPx5NahV4giwwFntAmp2BrnTsK6k0s8y1nUUPAOcrgQrFCWFIa5yf3IrPJzcPsrQRBjlC3vrjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bHivoPMEMOA65BZBKYGvGm8umff3Xtz0Es/YwEC8sdg=;
 b=m53tH/j4gcTL+t7jg99mc1+4OTK7rizpPy9D7DdMlPzHZ9wItpGhbE3K5tCr/7v5iMFwcZmXwJm/w5E3LmtiXpZwsstopxO8fxmZ1BOFA4Wqcl/LnTyMOrb4s8hdGj1Hv5QX5uWuZFo5g4fVYdRAPRR9NCIZtuSvsHU+G6C1kgo=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 03:49:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH v2] scsi: fcoe: Statically initialize flogi_maddr
Date:   Tue, 15 Jun 2021 23:49:01 -0400
Message-Id: <162381524894.11966.7580762504476187416.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602180000.3326448-1-keescook@chromium.org>
References: <20210602180000.3326448-1-keescook@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17d9cb72-d360-4a14-c894-08d93079bd11
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4725DE158456F1DD8D1400688E0F9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dRa32VZNUknMIzjj96JfO8jKBr6hB/aOfPyJev5B69wMUeB9Z3D7KLBmX2cBVpOneHlGbivAYdOlsomSWgt99vPqptL76F7pp+O2hbCaob/c8jl+SbxTj6WjBaTpkWifWXVN54VV3AAFqw+X0AOL9bQDQBAFBIqq5V+jfeYNLBO7CnmzvBwIXoI0G4COvO27pehsx/N+9b6pLEgwgo+dfIJI1J1x8e4FoC21ARRbMPPaAW1NMmLlH8M7ZeHPlES74Rmf1MjsFP3pPEhAomokHtdC/vMNcDrUnmQeGvS/N0STVtT/JBKM4uflIf0pYZUzEGsgSEOv68MO588J49tCDqtRPTXUypQl2mxNJFVC15AGYUXy+qBlBgvh7ijmoxPtgL0FP7Ee9Fw8asZVVXcqCjp4Ja+5y8ItLGmcT7gRzNWjEZGtho1yxUZTfgt477qXmKW+jIWckK01iFW+0G6JobwJTvIvbdpYM/RjKOMPOARbDQ/zpC3A2Htt2mPNCqPgJA1tRuypOXJPIxHkTUzxT3QjQyTFSQAbva90T+7OhDXqaV1qOqurIk9iHd3qXBGW2ErZ8tlHW+VhkaxGJQJYvyzQJNypt3MWB/uCNzkMyyCNnEqRZc4zVcIPBtXBh5ulRUTdajEXhlU8rsv6kj1lYaNXKsIOUrMfMsZcbYhBS3f4XeWWY2z4njBK7zXzzgvYNw+NesGkH6d8WwEzN7DMVvB3U2mGz43UcPV4ehy54emWmYSKa2mEAsxgoMhdHxoCuRWuA29tK0Ev5Axag+NrqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39860400002)(2616005)(956004)(54906003)(36756003)(316002)(6666004)(7696005)(52116002)(6486002)(478600001)(26005)(186003)(16526019)(966005)(4744005)(6916009)(8936002)(2906002)(86362001)(66476007)(66556008)(66946007)(103116003)(4326008)(8676002)(38350700002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzFXa0ZjdGllc050Z1E1Q2ZmSmhPaytuUi9OR0NsQ3JGbmFZTEo1b2x5VUdh?=
 =?utf-8?B?Uk9zeDA3SDNCcm5iOXkwR1F2VVQzdUFmLzB3REhqZGdxMDRWcVpZYVoxWjEx?=
 =?utf-8?B?VUszenRIVklnYTA5SlhQYnZQT3JaSytLSEVybXpNanpndW5jTTd5NldjVkx3?=
 =?utf-8?B?d3ZNbnZqOFMwcXhHVGlnS1dBR3J0cWdwc1pNSEFJZGtTTlNnMmt0dUM2VUZV?=
 =?utf-8?B?ZWZaRmV4SHZXcHNDQk04K3NjSDZYeVhqQTZ6c3RJeGk3dHlJREZPS1Zid1M4?=
 =?utf-8?B?MHJaeUdqYlZzOUF4RDRJTmZZNjRRU0MvbUxJSUZIZ1g4NG9pWSt0anV6bjFI?=
 =?utf-8?B?Z2U1bkRteG9LU0piYzNDckZta1RZMTNmc0NGNVNqWC9FQis1bHhOTEE4TkMr?=
 =?utf-8?B?Zkg1UEVYTkFWQ2hTR2J1NzhNbTRFcXdVV2lpSkN5WGEzQXlYKzdkWlZhb1BH?=
 =?utf-8?B?RFlzWU1ad09lOEJsUXNvMzBTRjR3T0hhc1MzQUFRbkpqZm02K1hMNlhmVnB6?=
 =?utf-8?B?ZTRaRDd3WWtBbHBLWHArNDhvRnNLMVhwUHhkbjhQNk8rakVtS0IzUGNxQ1pG?=
 =?utf-8?B?Nk5FMWR2MGpsWXRQQWNRR1MxRU5OUGRMaEIvRG5uMXVyRUxFcUFRNHpOaEkx?=
 =?utf-8?B?KzJkK0owRFg3WkRYVGp5MDI4T0VWR2JRWXVUa1YxZW0xRDQ2VTg5Z2dIcVMv?=
 =?utf-8?B?THlHYWJtNkhBanZPOEhHeVo5V2V3T2JTQk5kMmN4Rzg4UlNTQ2lPOTFxeG84?=
 =?utf-8?B?Y3NaUmd5eHU0clVKVnp4UGorNzR3OFNCQk9XV28vVXUvRUZFNWVjQjUxckxN?=
 =?utf-8?B?S0hYZWM2MGswZFQwN013eGhsaE4rWHQxY3JNVW5sdXM3OXRRaUM4YUh0KzE1?=
 =?utf-8?B?YitFVWU1SlZQckdOd1MxR1Y5emhHSUtMODVWTS84MkhLOCtoekpkUDZudlJk?=
 =?utf-8?B?WkY4czh6SSt3VzFTWlBGd2xzYTVndDdZMHNBaUZHUHFPNldIaG1pK0oyUmo1?=
 =?utf-8?B?d0o3ZWdiT0F1bWtUT2VSaWxrZ3IvRGJKQzRpSk5TZjFpYzRra01SYS9jV1pN?=
 =?utf-8?B?WEhuQ0lSRTNZZ0NBa2hZWTlQdGhVWUdJa2VYNlBFeG1HNVo2UVNnb0M3YTJM?=
 =?utf-8?B?Q3hkeERqaVJOempmYWd5WG8rc1pBRXFwWTl0ZXFiTDFCcjg5YXpPc0M5L2tH?=
 =?utf-8?B?dm5WVkljKy9tYktMRHU5SC9CTGNvK3A3ZVh4Y2VaZ2R1MW5hK3JnR0t5RjZi?=
 =?utf-8?B?VnN2eWkyRWRvZCt0aE95REc0ajhxWjdkVUdoUytrSnNMS1BDdkVLMlRKcWJP?=
 =?utf-8?B?SW9DbGJoSlJ5THhwQmhyZnFxbiszUzkrM0V6TEF6cXRJdUNJWFNwSEtEUmQ2?=
 =?utf-8?B?Zjc0TzdSdFhSeVFsU0lGdFpOSUgwUkJtcG0zdGdhTXlCbTNMbklUd3lMV0pv?=
 =?utf-8?B?MWRYSS9LSjBkOHFsNmxQejZNQ2s3elBDNUtPTEw3YzBvL293aURLOXNVeGlT?=
 =?utf-8?B?ZjBaZU5ML1MxTkRhQmc0aXlwQmpZYWhKbGpxdjFzRFRTTVVzellFdUFUT0x3?=
 =?utf-8?B?L09xUHVIeEtHOUR5VVo2S1dXeHg1dTFaQUtjUTRHajBvMnIrcnl4TVpUd2pv?=
 =?utf-8?B?UmV4NjM5Q01GUTYyWDlYeVZrWitFcjNScEJRUU14WVhMdnJJbWlEYzJRZ044?=
 =?utf-8?B?U2EzanZzSTducVVwakV1c24vb2pkbGV3WFMxVHJ3S2g0UXRLT01pQ2RocUk3?=
 =?utf-8?Q?10M8KxvMGm8Rj1Z+g7VvTer8+Fh8SmNkxa8cTd8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d9cb72-d360-4a14-c894-08d93079bd11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:27.3499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rmctAmJs6j4F9c85bmqkA41UiSGQceBijCmrIj8raosEt5y1pxRGTwFOfr53nl41SUMGJNK3YjaCDTVRKSbJoVzNHpk7+PYCCNbl4Af2Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: 4avACSHjtybunqpia9N3XPRq51VePHjv
X-Proofpoint-GUID: 4avACSHjtybunqpia9N3XPRq51VePHjv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Jun 2021 11:00:00 -0700, Kees Cook wrote:

> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy() avoid using an inline const buffer
> argument and instead just statically initialize the destination array
> directly.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: fcoe: Statically initialize flogi_maddr
      https://git.kernel.org/mkp/scsi/c/ebab8e09a07f

-- 
Martin K. Petersen	Oracle Linux Engineering
