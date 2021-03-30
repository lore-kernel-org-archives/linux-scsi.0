Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DEDC433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDA861969
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhC3Dzu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60870 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhC3DzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3j299141708;
        Tue, 30 Mar 2021 03:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=UdP3Qkwy4uX3xCYCn3hwirrp0nTt2Llf4zWANLZW0y8=;
 b=LxnoenKK24wFzRxSSiWvsvLPxVVSCgphFCs7ra1uDskiDzPKstGk647D69ygR3B8TZag
 DWcCDJVjspD7qKLzQX7xkdFKtqAOnj990fwRTZA0uVBW85l9aXWrHNq4EbYCU1RzpZ2d
 4MTCx58JGPipgGbuMJhowgG0nV430fI7oSpeWgBn2YWQqnemgh51NVS5+18HEsIkc35y
 7DXINNnXxwYZcKFKhJBPDa3/0gPdV4ao1nYahWdaTduaPYTNWsrAxbtZYGFX+KUh7Yff
 KfZBJ5OymOKehsy8THCTNwBozfHXrxX/hv/z1UQqV6jiRml2ltz+Sey613xEUvNVecKC 8A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37hv4r5k3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXVI039572;
        Tue, 30 Mar 2021 03:55:09 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3020.oracle.com with ESMTP id 37jefrktad-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0YNPyVt+p/XaBHkto0as1fUpLnRh3R8g+d18xbLg6JgDl0mx+ui3wNn5AyTwlZAja2+0L7KWCm18CYm+wCE5dt3IATEgpM0K8HlCv6oelzXYSlX/SvOxIduQ4cv/x3mYptAVZbOXuEiYULaHM24XkORlRQb7Yc5UMsInnz7gO9m+6DrbHlDJ3yx2MG6Oy7HEo8PIf6OJvAweP8/mgGxtt5My57Vxr4iFhPl/EpQ+g4vQgFz+75JHRnxJD/p/yJ8LltF4DZORskaHSeuAZqS6v0KEHx5FHhrIjvj4eOxmBDFrI4ocbDMMYD0DJtXFzAEugLFGUllKGkPzLgxgb893w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdP3Qkwy4uX3xCYCn3hwirrp0nTt2Llf4zWANLZW0y8=;
 b=C47vOQVxi4FmUE32jGNK59WM1zfmEIyQgd/JD+CtjIYkiuiApogR3qU3+PUqdx0Hxq7xldGksbDDb7HWwOPAoYqhZlesWgu0JY0oF9t1fY2gMHsyxjjCr6j3aKvDB+Ub1SGgOvu0WRvFWVYPN88SV91aoOYMtj4k3Z6WHC6MSmMcWpKti9Jlv9odiUA0YbUodeJeD6outfMDWTGLmhtJZ5nepc1gQF/87MUOqj2y+iHV+nLTfw9QSEwvUt2/GoEjUe6DaoSOgVjfK6w5m9NZQa4yTVQqLqYMM8Nbs4IjORkD8l+1LfliwNY33pCJje9DcVEr4KxDHk9M/adqMvDSQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdP3Qkwy4uX3xCYCn3hwirrp0nTt2Llf4zWANLZW0y8=;
 b=wGP538D2QUDbzGg6mg1CdMR6GzZ5kZr6erqz/z9BB/X0b/oT7owe2i0sndLkIIXilTlHergjsRfbNzSzlVdcYEPzbU6W6cOKFZIpLVvQJlyU9e9Yzr7eNVz1w7wLYpbu/V1ko+AWkjDjFqVFSSPjarRJQTl8ous/U+GrBzlsC08=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        linux-scsi@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: csiostor: Fix a typo
Date:   Mon, 29 Mar 2021 23:54:41 -0400
Message-Id: <161707636881.29267.9303258375381352229.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319092311.31776-1-unixbhaskar@gmail.com>
References: <20210319092311.31776-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 422414bd-db14-4988-c66b-08d8f32f9c3b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758D55279D066AA708D85388E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vTM6IPgabaZ0LaKsE7kz+kcke2G9Fq+njwtmBF+Y8rW7+8K5Jnx7q6uhprMhH03IV7xnmWdq3SM3x5/f8cw8SodjB4W1smYM3e7dkZpL0/fknfB9u9fXSEj7HYY0LoOMhvKBG9WabgXnHDuzBGw917rvReXA/U0eA8UGCR673TrJ9QVJDbQylLLhYASNXL4ZQqXfnZ7dOfeC1DI8MFifD6ikCd+c2EbSjRRR/YGe2RD0JdCV1PvWMxRF1jXKfBgnUQREiaPvb7xE2FGKZ4bTiLRjg/HCK1UYVMRErouPSuD0GcaOpuAD5CIZQwi2A0dceCsX2NBpdPlCjxVuP5FwJMN1A60QPX2Ok7HpHUmyZb7QfxP38Jl1W6xMv8kYP5w4/yfoIArgTV/1UR+Uq0Z1H/RItAWZVXaDBF/GHr5HAi3jkWiG8kmrjcIFS4LzqEq3Zf8ACKLGPxUubIVrw9rgzEd6HETH2wgxMi8gUpF5lorZxJJq0bhuoCeVrwAVPWdqqbMKkNkMPd+my4F9mqV6cipMsPhXvDQxh0hOs6FtsZpmpT6HWANW2EizmUIW3xmv4aCrBxlORjFsrzftMl6OHhelN4uIUxxqrhRKvozEPrxrJGTikz3yk+4yK+1wC3Dl7HneryhipZ8l9E/KeY4PeE5hRIq5gzlivrcYbR+JhYxhEZ2rKUSIveP3JhLUly3ioUexJrs3b0ma4AyE9/FMoU2wpko/oIldBYh65aCUtac=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MWc5ajVZK2FHZ3FSREszMzVQTzJzVXVMY1RwZU5wRmdHYkx6WkQyRFZpblc3?=
 =?utf-8?B?UE05aUhBOWcvdmY5UkVCTm00TFhQZklnNzlDTk0vRUtmYU1lQngwd0JKVFZ5?=
 =?utf-8?B?QjJmMFkvRDR5cDMwUm9ZOVpHSGdZRk91MDVjTlhxU2hDMGk2dTFwWkRURjdB?=
 =?utf-8?B?QXpqQXV1UmlkSFk5WU8zMFE5eWhiQlViQVdmMWRkZXNBbkllMnZxNmNnRW05?=
 =?utf-8?B?Z0QzMVZjRDdOVDJVZlZrOUJRQWJpUS81K3IrNm1NK3I3S0lFN0dmM0pidDdi?=
 =?utf-8?B?MFAwck10a1hhV0Z3YnZoS3phVjhJVHh4M2l2YlA5ZUovVUxVbjk1VWVGV2pC?=
 =?utf-8?B?cGU4cnRPQk40WVRzVGY3WkxRa1VTelVWREhObERRY2tZN0d2ZHp2YlUzMWZj?=
 =?utf-8?B?OEtwblZ3Sm9UbjZkMG9Vcm4zdmYvZnRkVTZFc1F1c0NVdVFTaUl6dzBDYTlT?=
 =?utf-8?B?bWxnVndCNTl4N3VZL1djSllJMUoyUGk0OHZmNWk4d25TS2I2NlROMVcwUDJy?=
 =?utf-8?B?dTVhei9LaHg3TXBzSzN0Rkc3RGgwY1JEV0hmMFJGMzJJdWJFQzNYcndseVhD?=
 =?utf-8?B?V3Nib1V4VFZzR0ZGQTJDNVRnY3YyNGwyUlhsQVpzdDhLeVhDMm44UGRxbktR?=
 =?utf-8?B?M3ltNnR3U0MyR21sUGk2NWR1bFV5MDZ2ZzBiRFRSOVAvOU5XTjgzQmhuMjAr?=
 =?utf-8?B?S1dCSmxZOEdZcjdTbkJNN2NIU3MvSEg4bGlVT0wwSlJIT1c2SUVUdTB2ZDhm?=
 =?utf-8?B?Rlp6eXlxb1JYRXBBRXVwNEFyVVFLUzFPVWt1UVJMc3o0dmluSlNmU1BhdThO?=
 =?utf-8?B?Rkl4UjArQkF3Lzh6RHU0ZXNvSGtMZXo3ampFUWVmZkx0WlZKMnIyVkdnS09U?=
 =?utf-8?B?MTdrbDRTMFRDSy9sS0ZmcHp1R3FFekc1KzY0dHpBWnBnd1lQNkVuandLVUpx?=
 =?utf-8?B?MkZjZGRPZTQ3VDJxMG9Xa2lUT2E0UnRVbmtFaXEzalE1ZnhRdmJrN0NVQkJw?=
 =?utf-8?B?SklZYUpBbEtsaWZMZERrdVhBc2tGODI2NU5zcGdXcUF0RVV2YW4vZG1GRExp?=
 =?utf-8?B?elFlbEkra2RFU0NVbTRQVlhkTDdQSFkybTBob3Z0MFBGRU1aRW5WdmNXK0wv?=
 =?utf-8?B?MW9xYXFVVWFEVmx0SUdycEFIelFTbitXRVBkdTh0b1NUYldhYzdLYWZQUlQ3?=
 =?utf-8?B?Q0lBM2loK2VJbGNCSm5uK2NvTDJtWnpkaDZmNWdNNUl0ZVo0RGxuVmpiWGxt?=
 =?utf-8?B?dTYwWW5aaWI3ZXAvM0MwOHJEMVNpNk1hQWNOSmk2WGswY2VNRWV1TzBzNllt?=
 =?utf-8?B?YngwL0U1WXF3MURpWExsS0VvbXJ1MzgyQ2U5TUw3SUV1ZjdWakhDZFpYaHRW?=
 =?utf-8?B?dVpRbDYvelFVSnpCYW12VzBETm01Qk5oT0RhSU1YUTl0cDRaNWtUNHRqbjhK?=
 =?utf-8?B?NWVDbE8rK3ZyR21iYjl0czBoSkdQSmhXbGhsQ04zOU5MYklnZUFkNzdXK052?=
 =?utf-8?B?NXJ6eXY1U2VLSFZxRVpyR3JCNVNVTGZueHlIWHB3QjNrdnViVVdaZWxCSzho?=
 =?utf-8?B?RjhYeUd4bGQ4RVhCd29ZYS9ZTE1hZHBLd2tOa09TYVZjUUt6emFHQkttS0Y2?=
 =?utf-8?B?dXJmWTVNb2NOV0JlTS9HcG8xKzJDTjdlajkxU3FGbm1XZzJxazd0M2FDUWhq?=
 =?utf-8?B?M3drL24xS0h0YStZRHl0WUlrV1NqcytMN0NZdENmQ1F5UkZNd0hPUmhzc01m?=
 =?utf-8?Q?fcgXIyp+kafqa3NitGzgoX9vGv0bYkqwEfhKGcC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422414bd-db14-4988-c66b-08d8f32f9c3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:08.5400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nm+b1XHn1XFsAYfPrFU9v1D2Mn3paJPAbk35zxP2xjD8P5KM2qOYZU1+SXARtg3/WcF3Vijg0Jvg4AEv8038CGIqkqO2PcAErZtH9g8zAro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: zkjzIqftAAwKXN7FgVQhdIyS6mxyVwh2
X-Proofpoint-GUID: zkjzIqftAAwKXN7FgVQhdIyS6mxyVwh2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 19 Mar 2021 14:53:11 +0530, Bhaskar Chowdhury wrote:

> s/boudaries/boundaries/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: csiostor: Fix a typo
      https://git.kernel.org/mkp/scsi/c/a89562e31f01

-- 
Martin K. Petersen	Oracle Linux Engineering
