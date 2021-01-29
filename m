Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD1BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49E664DE3
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 19:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhA2TDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:03:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43038 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbhA2TCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 14:02:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIxxhm135323;
        Fri, 29 Jan 2021 19:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nPNzv0iuVZNHkF1Y5jUVK5/YdA+jw9Gnehh2bv30+jg=;
 b=lHdbQTp8BodD/bwZKbxk2dGgrMeYiIhgC2ojOvxdirVx94KTDBpCBAtkgWct1IBjxJSW
 lnGWUVDyIUX7wzddYC8jiNoMOEjbphjGqQUCZb1cCqCcrEYMRzVRcqwE73ll8gNWgNvB
 0C7MN/EdtiOBgl2SEZQO20ZgWO6nJU2z1Dnedw/zpheLuMF1m1PSH4G8Iv+93jWskn8G
 QYsiJgTO5S7CrcKEFCHO7fzWuReNyj4+dbVHq0KaeLG+Ix32OH9znSLtXIeiTmMMFJVT
 G0SiPlfgOyf5jHloWROVL6BtnPvEQ6YH77nHdOR6g2kMJJQq1v3mK1LBQgdnZzIbsPqc WQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689ab306v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:02:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TIxu3Q061840;
        Fri, 29 Jan 2021 19:01:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3020.oracle.com with ESMTP id 36ceuh2yfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6FI48kqlqkTXqXXw7NnwxMH2qnjAfLTtpW35RYVifojVQ5KcVoWkb+iDJBF2Htcr4HuoV/ILTt9xG0rNAf+YMxKOAotbp6K+kUfeFFaD30MB3mI5vTP2YFD3QLBNTt7LZm32G7sa2weEaJzUcttAGcLmbqYOR6VXy0+kY5td2Go+fzs4Bs4kQrJRzJqM0KdUNVdg996Hx0t+MD1YyFJWXrEbXPtIUuk2p7EFGZvoddNLWOMuwSpp2ZNtnxRroRLAFnENto/airvYkwglUX+g0n1yjkeGm5gc75shh77DJaoybN/DETnPPW12zq9ehcXDjvvh654iKPcOo4xXWSXXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPNzv0iuVZNHkF1Y5jUVK5/YdA+jw9Gnehh2bv30+jg=;
 b=CMbRswOVgsa4Dimp5TKSO7PhqWZyyO/DMiyABMgYWkUbubb4SPd0+vgaNu4fKMAScw/7eE9j/JDnNdQhxFJRxCgmf2mIt340NX2F1ej/vaXNn1IyKI255siyrbU9H/khPg6CsV23z+gY1pLYyYrcaABUueRw8eURQTwZEs1lH99+C4Lt9lTOhOY7eVbLdcVaxCjnVdVlxvHKBs40MwwtTpyR7+GEPsXIaum23PecO3Vp/Fw1F3Sw1PHuyp8DHMH5+W0knxeAY6ITmw7euoF15ZW/CG63xWzj40jg5u1F4xmVKuHRdorMKSFc+ipq5Hv1BSlKua1URx4kuu5ald6/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPNzv0iuVZNHkF1Y5jUVK5/YdA+jw9Gnehh2bv30+jg=;
 b=TNBrHvbSaTAuMpfuxHG4na/2TLfVMF4sNexN/e8tr8t3SM9F0rIXKH/5WGlf8yR1ff0o7zeQML9Rt3v+Yjhay2uu1+Tfp9T+XJDeksgXS5TakreIZNnoclv2iae2P3ncB1z1Z24iLW392modfevdiBfCISGMWtocQCYGRyGV7WM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 19:01:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 19:01:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux@yadro.com,
        linux-scsi@vger.kernel.org
Subject: Re: [RESEND PATCH 0/3] scsi: target: Set correct residual data
Date:   Fri, 29 Jan 2021 14:01:47 -0500
Message-Id: <161194526372.12948.15060363131006291392.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203082035.54566-1-a.kovaleva@yadro.com>
References: <20201203082035.54566-1-a.kovaleva@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CH2PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:610:4c::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:01:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d236a74-654f-4b31-d13c-08d8c48859c0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677A21DF02D13052DDE767A8EB99@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QKBvRN4IFrnvEFmgBhSs38OKwy2zBHYgqOTrd9SpRRxSTF6t+g0NBJSLOcsFAtVvThVXLQWPnJKX2n9uE8B1Cfg91TS4BkyuYV8uf0YW5PiUb7Vx+FxdfFpeBWd4+5c0qXdL80klyk2AyGSwyauIkekrBU+WQrjlM+rI64DG8SL7leiEFaXFYvbIOknNemgFvk0nA3Zv51mkHJRbgpQDVpyRgoi8SIegxbesi1edVIMAt5cDHvFVtl0CbEb5VgqVHpIBWsS8ajKptKGm1AwxyKhBP8wGueP8naJ1wGxILWrNxtdgQ+AWg/d6U54SxJofEhuQv5SdvFxngwx6mrSZSeSCrD0MR9NldQah782q0AFmqHs6mDGDZ2Aisjpy1a164RPCf10gerapVOvf1d7CoUhoOpyCr/ckcnOH6JI95NfA2UTYvy+/t8+V9m3ike0/PpdkQQMHYWKUY24NoIqvD2eYYzHHsCGl6gD1xChRL8nJoM+0tA1icvqQPV1FzlvaD5r1bfPLK07YQ0O8aVlAlGxkgC4efUVpogeiVTAzehMZ9xY4MYW+66y9bdtpJXWLdTqOSQ/qIBr0BoCoCJZ8ugnJmt7h1Wv7aeXxlJ7zwOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(956004)(66476007)(2616005)(26005)(52116002)(66946007)(316002)(103116003)(66556008)(5660300002)(16526019)(186003)(36756003)(7696005)(6916009)(478600001)(86362001)(6486002)(2906002)(6666004)(966005)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dGovYmhQR1k1MVZzMDdoNkIybzFKQmM3T1pHSTJzYi9VRHZkY3YwaXlaRm96?=
 =?utf-8?B?YXFta0dwZENiQldCZDNtMnFMSHppUmVHVklzYmF0a21mMFVjVVYrY1dXYUJP?=
 =?utf-8?B?T1FZUVVWQ0hvZVdJOXlpRldqMUxrczJ0TDg2VWtUTDA2M0ZpRGljUEp0RDRl?=
 =?utf-8?B?aExSQ0poU3VNeUZJR3F1U0lLTmVoS0V2WTZnQWN2ZmlVNGRsaWVCYlNlOWZ4?=
 =?utf-8?B?T05qaTJmODNrN3pvMDVpOWlkZXF2TzdpcDdpT0tDcVVhRExyRUlQdUlGRjR3?=
 =?utf-8?B?SjFUMmdkU0M5MDRMMXl4WXYzTGVQQmxMNmtCMXRwVG9vSklJdDFYK0JZcmkz?=
 =?utf-8?B?WEVBaHlTZnRvYlZvSkRZY25vUXNqdWFvUXQ1bE8wYmJmR1pkY2I3L2loNXFq?=
 =?utf-8?B?WkNWK0lHTU5zS2MreFljUGNoempRRUMyOE41L09pbWZldEZvZXVacVY5MmpP?=
 =?utf-8?B?cmpydHE1T1RlUXJrcEdKc0hieGRXNGhqY1ZVWjVaRC8vUnRuMkdJd09tdDJi?=
 =?utf-8?B?T3BzR2NwRUNGRWZtK2JiejlIcENUMTlVOCs1VGU0S1paS2N0eDZuKzVkVWJk?=
 =?utf-8?B?dXFrUTd2K1QvRTZLYXZhWEx2bDdhRUtZUTVhM1NEZWF5bzdWdEk2cXpma0tQ?=
 =?utf-8?B?SjA0cklyVnRuZW84cDFoUmxyaVJmM2lCM3NwMm5GUmVBcmNzZU1aR2k4dDJk?=
 =?utf-8?B?cEZJYVdQVFFJYlFnNW5VaFg3czhZeW5YMjgzNmtDeXlCWVpMWGtqOXIwYXlR?=
 =?utf-8?B?R2JOdFhhYjVYcENhOHduYndsMmYvUHZQYk5MbExxcHg5NXJpZVRCYUlBRm52?=
 =?utf-8?B?T0ZvWW9xT1BUSEZRWHowVXlzaStwbzJCVjV1UllOK01ndDVuUnF5NUc5ZE1R?=
 =?utf-8?B?QXl4WlJiL2l0Y25SQks4YS9zVHFtcnpISUNPci8ydzhIemRhWW0vVk9ucFdB?=
 =?utf-8?B?dnI3L1grRUJrRmVkc29EV0FQKy9iTXI4djJjZ3huekF5R2RiWm1DTVhQNW9u?=
 =?utf-8?B?WUcvQWJQbUM3bVllemJNdktFaXNDdGtwRXExdWZ3V2d2MXcxOE1ucEltK3VD?=
 =?utf-8?B?WFNMTm5DTDJHYUFWeUxhUFBqclRuY0pkaXdIR1VBcEVUbmJKRmVlbHBuSUY4?=
 =?utf-8?B?NlZIdkJMYlA3M0JGS1BlNWhLd2lPYXV5VVlnbUxvTHBUa1FJNFBFVDVSdEE0?=
 =?utf-8?B?ajRqWGxlMlkxa2NOSXRuek00UzlXY3VQU01yWUV2c25RbU1wbFFXQVZxYTR2?=
 =?utf-8?B?RkNYUmtSWkNRcVZWcGlZTnlLYkVXL1ZnYnFLTEVzV1dzUktyMmtlWjZrTnNr?=
 =?utf-8?B?TkgrY21PcHZqeDducGd5WFlUSTlZZmsxeHJmaTVrS1FneHlud2xCZEQ5VEZh?=
 =?utf-8?B?eWIzRm80ZFJsZVBXQm9yck9iL3hmSzN1RnV2QlkrRkM4ekxrS05IQUhZRVln?=
 =?utf-8?Q?aZlpeq6P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d236a74-654f-4b31-d13c-08d8c48859c0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:01:57.6506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PO4fd0poPX3WJhaLzOturyqCWq1ELw2+izA1mRoIt1AzdfpRoqryV/eS/i+AZj7OTAoHIh+srzZ36XUWs41xRWztbLKSEZoaEN5u203d/tQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=876 malwarescore=0
 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290092
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290092
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Dec 2020 11:20:32 +0300, Anastasia Kovaleva wrote:

> Please apply the changes to 5.11/scsi-queue at your earliest
> convenience.
> 
> The series changes the behavior of the target in regard to processing
> commands with overflow/underflow in accordance with the standarts.
> 
> The target driver used to process the DMA_TO_DEVICE commands with
> residuals (in particular, WRITE command) incorrectly. The target
> response contained neither a residual count, nor an OVERFLOW/UNDERFLOW
> bit. Such behavior did not comply with the RFC 7143. Also the
> returned ASC and ASCQ were incorrect according to FCP-4,
> and residuals were not set for the 4Kn devices.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/3] scsi: target: core: Set residuals for 4Kn devices
      https://git.kernel.org/mkp/scsi/c/eb90e45542b5
[2/3] scsi: target: core: Signal WRITE residuals
      https://git.kernel.org/mkp/scsi/c/cc0b6ad72e18
[3/3] scsi: target: core: Change ASCQ for residual write
      https://git.kernel.org/mkp/scsi/c/ead0ffc95a89

-- 
Martin K. Petersen	Oracle Linux Engineering
