Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82910C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5152023A3C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbhAOEJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:46 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43614 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbhAOEJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43OId144041;
        Fri, 15 Jan 2021 04:08:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=cAtO0mX29LDGdQJs3lP+F4XzqyTReBnIl3OPdOrDVn0=;
 b=To9sZCPJup3qSlQX6ghFU2Dey+PrdTTEjqbbbxsM1SK7hf1sDcnfJ+durmO0WCDtuJMu
 LSJ+6/QKNYldWrmdxP9+mvVIVhaiflxTW0s0pRCigFgEI0OYYpUu3vFJL7MD30ppCbUI
 n1uj3UxkDDNQzkDlsyHglCDu5gu2A9XuopzRXLL3VeRWKH1K5qEz3XNu1jzhfyPcVy5t
 a1SQmQXDq7R/egbontlwXkDvR8alGUYDZJsh5T1BuRNJBP7xUDma3OfEH8V9/doJP56M
 tf02i6GUJ199cxwOaHv2Mj28eW5ZobsVtHg0M+gnvjs5C7vex+/+vdo6VqLmPqXAuXDa ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvkb6n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45jPx018720;
        Fri, 15 Jan 2021 04:08:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 360keaqqqp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7SWIpMsAf9UJh8rTCwoCM2gcDNuQoopsgFpvOMLQxCqxLvVl7VRViOnIg9DOPIN0saGVZ+9zR3c1ozbaY6BVnqDrKSchhfC4J2HkH5TFhmPbi80/1l6DTnsd++ZlCN0xyRip1PPE4UlaZVoZJ7eoqND88Tdx2/smVL5MDUAcCMJj2bGVfIPw/NjYglGGdzLw1vAptRrzUGwAfXf08mHOrxgM0OhnHos89G6ccQPUnlkaDyb0R06MEktGBa17Wk9a7LlbvRojsbmjacgzB1nHZalhpXkbsvEkclt2J/4wMWmjAbw6WAKNkNXzhWXl0g6eaE+5kib/atLHD70Bc/cnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAtO0mX29LDGdQJs3lP+F4XzqyTReBnIl3OPdOrDVn0=;
 b=m5XY62tiUDrydmEKT1hLwSoNCm10cow6H01MhCH/YdHgRBVSwvBTV7AGMI52/lwVRNjWLvv1SFvrlijwoWwV3+EKRxMDosOWdQg0RBcB8Mdrh7ZzZeqwYKy8r+VwTI5lN5RgCYM1iuQ91q6saDrwr5FULejFj3dojuWYkob4ec7MT6o9YKjsBZvpGCt3ijZEmElc7SOogReJY5IfigspivsdM6iibu4Tj/xB209inFibNoYUoWRsoCnh5WClzAR9jNX96HkrNSNbSHhHFv8Iw3KZ7QMDt/O1t/Po8hqROtHF1mId8rhhBhT40r24sQtYjMGBfZyABC6KiB0As9h47A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAtO0mX29LDGdQJs3lP+F4XzqyTReBnIl3OPdOrDVn0=;
 b=zzSFs9EAzM0ipP7h1S3U3zEs8Oj+iLORbfXUbMd6pJ89j6Axt4UDElqgaGtMfh9J116VXEYBFguxX6KeKKCojjigcHYzFUD8D7fWF1t4UqWEloBNnaLSayGQ/9T2JmiaJj7wpZcgdIOR5EI7DtJe0eodrzyqHgos8IFE0C+DcRI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        akshatzen@google.com, radha@google.com,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com, bjashnani@google.com,
        vishakhavc@google.com, jinpu.wang@cloud.ionos.com,
        yuuzheng@google.com
Subject: Re: [PATCH v2 0/8] pm80xx updates.
Date:   Thu, 14 Jan 2021 23:08:29 -0500
Message-Id: <161068333183.18181.4466770203801164661.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b643cc55-3289-4a8c-f10d-08d8b90b450a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568C3AE7698020C2C0E8AC88EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fb+Poh2S8gLB6B2GPTrPHr5RMGrubUQ+ECdfx4T199tnp0c2bPpIzI3EXogdR5B1rXYFMrBMRhTii5k5tb3G7AUinIn6upxbxmZ74tgYMb93WXH64BBIGm9PsITe/FzjoywfCmOQA9+CVmq1WsLVMHh2Cibn0GyoJZQ0Yy/vrjOACNCYGUR73ZE3MN0r1KaOCyLBCI3evuD+nUUwb4LZjkAdse7azu8F12sLBWH87qUmLabP1xtLdo8yQtJV6b/01HyUe6Ly08hnKEds6pYzipHgQ5FjUaTRz2/zsIkTGKaX/SIGMatwdmVIZeuOTZRqYLJIIcAdwyTbhnfHTm1ThuloY2ErIULJA4/bnUgi/pUnr5rXqBRfnpLX8NIquAuINksMnFhJFWgij3F0nKkiWnx/oPmrhkS4FqyiG4uhLT0xs3m1d1sqe9Hwvd9o5TIgEK84hkmGoWkmr5Kp0Yg9NA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(7416002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(6916009)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WnNnYVNDV1pwYVBiRWRDdWd4eGdtcGxoK3ZOZ1B3MmVBbndWUTM1OEsrcDJq?=
 =?utf-8?B?RHZVb0dKUzhuKzhaWmpYc0w1N0w0YWo4Z2NhalhIb2hrQXErTXhoMTFSOE10?=
 =?utf-8?B?RUtqbnQrTkpCZkg5VzlIWHl0L0JyMnRRY0YrVzkrbis2Rk5QSGFUbE5KRFha?=
 =?utf-8?B?cWJodGNGSklHcU1CZmxCYlRPTGg3WjU3Y0NwcTlhR0RpR3NpSmNIb28wajVX?=
 =?utf-8?B?bkg4WThkb1dUeUJnVmREcGxlcFFaTzVIa2g5WksxNmFMbTJnMGRQUVdCYklV?=
 =?utf-8?B?MTVMdFpxd1QzdWdtREcyajhJUkowWHJnSElSWjhRUGUvNFlvS0JDN1FXOFRQ?=
 =?utf-8?B?YmxuRVFYSkdpbXlMeDFXaFpEQjFWM0VyaXlKbmxYUzEraGx3S0FJcCtLdFJL?=
 =?utf-8?B?OFZKNnNJMTBnOXdRUlZBS1pXRVg1OXBaR1cyWDZWVFExOFpRTGJUbmJDcThu?=
 =?utf-8?B?NjQ0a3ZLNHcwYnRYTEVMYWljMjFPTDJuWURBSlB2UDUvd1A0eTFDMTRLS2dI?=
 =?utf-8?B?MU1xVGlzeHRraGxtb1l4TUZMd3FBUllyUHAvTjN3ZERDSjVBYTVTaEJPTWNi?=
 =?utf-8?B?R3lOSHpTMVRBRjZJWXNLcm83QndIY1VsNkk5d3Z1VzBNM2lRY2J3SDBtMDJQ?=
 =?utf-8?B?VHFWL09aem45VGpQaTJXSHFidzk0Zm5jcW91Y1VIUHVvaXVNZ1llRUlHVEZY?=
 =?utf-8?B?dWxkb0tjK0JzUkVLMlp6RmNONTRSTE56WHA0WHhEaXM0VVppVGF6a3ZnbHpx?=
 =?utf-8?B?bDR3aXlOWFM0b3Bkb3QyWEpVL1JRUVJqOC9iSE1zUThCZzd4ZjRpZ3lnMDEx?=
 =?utf-8?B?dHc5UGFYYlJ2YU5ickU2OENWd3g5MGk5UnFjN1dtY2VmK3cyOXp0MGRqTStP?=
 =?utf-8?B?MTJ5ejlkVlA1bkRrRHhCYk96SFM4OXhybEtiMzI4akRGdkxNQy9ROHZtRDRS?=
 =?utf-8?B?WEtoYkk3cVFMNjRUNmdlRFNMQXcySjdiM3lmZXh6dGx5RGNDcmlhTG0xSlVI?=
 =?utf-8?B?bEs3SHNzeHBtSU9jc1BMMit2bTk3Wk1EQXN2TlBObVBMR25QS2s3S3RvMWVx?=
 =?utf-8?B?ZFN3Z1lrem42ZFMvL3V0VjRGQmQ4a1M5Wi95bWprZTliUTBoWmN3QlpKZmJx?=
 =?utf-8?B?MFE3NGlXQzJjZ0NBNTV2ajV3a0FwVDhKVXpvSko5anZoeUR5L2JBdlhOL3hq?=
 =?utf-8?B?OUVLQXRQdmRxa29zd1ZNd0g1QW1ocGZKTWEwODVuVGt6NkN3eDY5VnVIMEl5?=
 =?utf-8?B?QlFibFhETmNSeWJuNlk2Mnh0ajFKRVpRbWVYTzlrMEZKV3N1aUUyOGZFRkVt?=
 =?utf-8?Q?+ZrSOdfskUJ9w=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b643cc55-3289-4a8c-f10d-08d8b90b450a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:52.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtIEfKaJ0eD2Pin+0DEEcjujNfIerB6kW9z/x5GTj2jco3j88MFHTDdu82Y3re3uTIS8dIQXmv34lQwtQGlJukdchZQKiNwTb8J5ActnDns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=914 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 Jan 2021 18:08:41 +0530, Viswas G wrote:

> This patch set include some bug fixes and enhancements for pm80xx driver.
> 
> Changes from v1:
> 	Corrected email id.
> 
> Bhavesh Jashnani (1):
>   pm80xx: Simultaneous poll for all FW readiness.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/8] pm80xx: No busywait in MPI init check
      https://git.kernel.org/mkp/scsi/c/d71023af4bec
[2/8] pm80xx: check fatal error
      https://git.kernel.org/mkp/scsi/c/a961ea0afd63
[3/8] pm80xx: check main config table address
      https://git.kernel.org/mkp/scsi/c/95652f98b1da
[4/8] pm80xx: fix missing tag_free in NVMD DATA req
      https://git.kernel.org/mkp/scsi/c/5d28026891c7
[5/8] pm80xx: fix driver fatal dump failure.
      https://git.kernel.org/mkp/scsi/c/ec2e7e1afff5
[6/8] pm80xx: Simultaneous poll for all FW readiness.
      https://git.kernel.org/mkp/scsi/c/6b2f2d05b581
[7/8] pm80xx: Log SATA IOMB completion status on failure.
      https://git.kernel.org/mkp/scsi/c/4f608fbce54b

-- 
Martin K. Petersen	Oracle Linux Engineering
