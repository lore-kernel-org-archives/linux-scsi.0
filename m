Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2294DEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 13:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjGKNvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 09:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjGKNvG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 09:51:06 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2043.outbound.protection.outlook.com [40.92.98.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D7994
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 06:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Thz2A/we0KNf9GUpHKhPTzHL4Aj3WXt8oRCRON6FaNS1h/U6pQTe3359rJqCwOrh36YbDMKQ2xSw9nifVtjwxGK4WbLxhgYYgkM2a6zAbwJKEu64i7z86pY0y3BaZdzhfkZyMjy6eaNxD16s1nwUUoIXSsU0Vt3VhPfT5KJr6DNI6GbtJK/T9CxCdyhQGrUMYD12MmAkAxC6R+aYRmY1zS0zJ2xCkFVSH8zBANbrXTcGZcam+Ejn0/hebwo5oP5Jysklzp56ZiuQSO4PPA8o6T6i6vsm/kJThwC4mUlVknBjA6fCx6hzOzcG/eFrqARstUpzGNlQ2HhYBK+x63XTnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq8EsMOV8NOSBnnB02Y00fE0cohLu19nNam1Zf+8ppc=;
 b=Z02qiCJnoixW2I/r8JyzssvPRFS40Wfg2ChTKgO9NM1GLnDcRm3wrzMfBqvi7QlHzV8QMbWPWuQ8aaHIB8yue/FDZ3c/RBN+M5t2M64IfbPxQE7HWGaeUEpifbWlUmC34tMTpxOSFoJNGz5F3cnKH/3VFnBQerY25VCca5Za5BdLsRrtxv98HqLsbqKgkIQr3PCQhpt5j2HZwpczTpA2i2nBrBAYu+PYVfNgP6Ttm7lU2fqUqqabk7royB+uoQrfa09UxMkwLGYwXazLUQKtRCgXVMh+8ArjE8/djXDxpRcAp+ybd8SHJzzAQL4CjYXuiq+Dx5ls0n6jvqBikJeKfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq8EsMOV8NOSBnnB02Y00fE0cohLu19nNam1Zf+8ppc=;
 b=DLEb5fwaDflqIVFz6MyF1BCGZAFQGU8XHs557T5Yx5ttHxt/xpQpWMcc/ILxEWgSHyF4Xw3XknAhdv7WuiL69dqB7Bot6UzbuxcmABk2LrP3OreecHdkebFRV1tvPlVMCMZFFWJQqKuOvHS6jxsLUtYrUjUZ9iYz3BIVTwcMrpIZqWPUgQEszizM8yX8vbtFu3P389i1U1jfrNk8rlqc2oPFim8AYbrC00af01RYnYRhEbr8U+NPaEWYO60Ca3GKz/XenDx6F8r5lUObidg9f3cbcQi+5/eAKFE4Ds4cZqirLwiJ4otPSz0MbbPtx2QvAUzHOl68MKHmD1nv39WcsQ==
Received: from TYCP286MB3045.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:304::5)
 by TYCP286MB3220.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.32; Tue, 11 Jul
 2023 13:51:02 +0000
Received: from TYCP286MB3045.JPNP286.PROD.OUTLOOK.COM
 ([fe80::bc17:f597:b741:e5a7]) by TYCP286MB3045.JPNP286.PROD.OUTLOOK.COM
 ([fe80::bc17:f597:b741:e5a7%2]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 13:51:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   linda.zhao01@outlook.com
To:     linux-scsi@vger.kernel.org
Subject: RE:Mosquito Nets with 5% discount
Date:   Tue, 11 Jul 2023 13:51:01 +0000
X-TMN:  [BWAmD9vhoa+ukPlGzN2GsW2ulRhDgnFD]
X-ClientProxiedBy: TYXPR01CA0064.jpnprd01.prod.outlook.com
 (2603:1096:403:a::34) To TYCP286MB3045.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:304::5)
Message-ID: <TYCP286MB304542904F1D9EFD06F8F7D98131A@TYCP286MB3045.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYCP286MB3045:EE_|TYCP286MB3220:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d42be55-54dd-4721-de69-08db8215dd5b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5F34JU2KaojU3GQuoya9Io9Plvgf6psN7S2D+b5x3DzA8Yvl1iZGFH1vOGdQIMZ9fB4ctfrQK/Zy05Ax/1xiOTooz1VkZ1fvUV6cqMCmCslfuuOvvhuDTrbKeaJ3eNf/jfdPS2wqUozhA0PSbhi9YcemxucZD/NBoSr6fReeBAg1f01urmhKX8J0afJ2Pe70/3VTV18BvpDLohBPJKaxCL6hGKTZJVL4ofUPXCKN36YtGYBZqaWxaYH6Xx6f4Dvk1t5I1WBbEBn6KNr+D3RTAlOXHk1XqGzog9t5IdeX6uzBHMCZA8r0CxPGc4yyTta0gGUgLx2WLxcOfw8EI3OD26nubEZVfnhIUAI28ff0r4vfDJRKEFS3BWLPIvfmZaV02NpnnpHz4zaV8boMEpyfxXhdjADfvNSLGaukeED2WG0h0GPyf3xc7QKoJPYvAJSVKaqOMmYQCQWZ5qC17+JcvuQdYDsMXPSutTxq6vDO8qOA0ZNqU65VCnMT9pOOXBnFxYpgqa47M+CtsjdBPl/c+1d1ze/aJPL+dxm1SQeije4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXp6eWFsSDZ2Q3A1aEZ2dmw1NnQ5TThQRnVoVzF1ZTN6dUEyYmFPSHdTT3lo?=
 =?utf-8?B?RjZQTjdVejM0MEJvai84YXhVTzlIN1J3MEhaS2RKOEpNcy85c0FVZW1adldv?=
 =?utf-8?B?WHlPV2luUmlML3JYRTBuMmRKWFAvMDNWTnJnVHZMaHNrMDJMeXVqMmQ1YTdL?=
 =?utf-8?B?a2F2V2pvWmNXUk9ZN1NDb1B2N0VuRy8vRmNXdDZwdGdaVzFrcjVKZU4rRmN3?=
 =?utf-8?B?bUQ4ZHorSVZ2c3laQmhoMkJSNXZoNGtnVHQyY2dSUnFnRWpzWjNlS09nanpu?=
 =?utf-8?B?N2t6UERtRmgyNmdQRFlpT2JOM3doN01mdUgvQ2Qrb21jYkZKYXIzTUJBejBZ?=
 =?utf-8?B?TzVkcFd5K0VKZVJsY2o3d1cxVFY5VnBqZjA2cUtNc3N6bW9pczZtdm5DL3JE?=
 =?utf-8?B?S3F0bU81MzlEeHoxbjNqQ0d5bDdlYVdHWCtaTjc0ZzVTM2xaSHFnTVJGTUlH?=
 =?utf-8?B?MCtoQmZRTW9sZFhZUkFDaDg0aUU1Zy9mQmx5OGZEbE0vY1hqNEpPbUszbDVX?=
 =?utf-8?B?WjZZNVdINmZ2RGVGYjFqdUtqQ280aEU3eXJiS3JTc0xHWnNKVHFrdHZDNjVj?=
 =?utf-8?B?QXM3Z0hpYWhmUG5TTmQvak85ZlJTUFhxdmN4VmN0V3RWRTl2VG1SK2pzVHBo?=
 =?utf-8?B?N1FwSExmTWxiSzQzN1dKTUcyMGlXdnRBbU5RMTJ1NWYwa3U1ampNTmNIeCtU?=
 =?utf-8?B?bnhjWDhRS21LTG9wNGp2NnBOVlczdXF2Yjg3K2tlYnJnY3oxbkk1SnoxSjNU?=
 =?utf-8?B?VUNmaCtES2J6TSs4TU91RSsrNFhCU0FiTlZFSkcrdHdQZFl4Y2V5VTd0NTNM?=
 =?utf-8?B?a29POUovT05ld084T1VYbTYwbzVGZmdWbUtyZk1EcG9GNkcyQnVEOVIwNVN0?=
 =?utf-8?B?SWNXY1YvVHpRMDVsRjgyQzFtb3dUNG1nWXBuM1FuTWc3a0FLOXRlcE9vR0ZY?=
 =?utf-8?B?TFphbjFSV2tyTkRtYjR1Y243NHhEdmUwNjRZSGpQSWF3ajhwWmJUMVpJaG1J?=
 =?utf-8?B?ZjRrSGkzYnVja3BaVDFtc1YrZUUyWnBldkNmdmlsU2JiWEpSTkxoc3ZQZWp0?=
 =?utf-8?B?dmVWL1JPcnFGQ3hkcVUxUThFdC9RQk1zSzJmK08wRko1YjNWK3VMT05ZSUQ4?=
 =?utf-8?B?dVd6aVZNdTFlOUE3Uk0vYTgzVWZGTTlHWHNKQ0xycXN0ek5ybzduVW1MaWJ6?=
 =?utf-8?B?UDE2MDRYbWt2UlRDc1Yzckh1cWxkK09hQzAvSFdQei9GM1EzWGdhbjB1a242?=
 =?utf-8?B?cVNsbnI0cTdSdDlnanhmam5QcFlNL2hWUit3QUZMd3lTbWQ0bDc2Vi9PVzVX?=
 =?utf-8?B?a1FQUDJjVTVWRThwalNZbHFzV1NJYlVQY2lob2Y1NDZwNWh3S3puc2pzdjEz?=
 =?utf-8?B?V0NyV0s2NnVZNXFQYkJIdjJNd1BMUEwxWjVMY1lITkFvdDl3ZjBsVmsrbE43?=
 =?utf-8?B?OFo1WnJ5Z1ZEeWU5Z1JwUGFaUGtRcm9VVVVkaExJVkRSL2xZckVEQ2NMN0tR?=
 =?utf-8?B?aGQ0SlJCQmRtZG9JMUtGSUNRd05WZWkrY2NmQndWK2VxU1MzMzFma0NEc1cz?=
 =?utf-8?B?SEUzYkYydkFTY1RFWEJiczkzclY1OWVjSDhWL1NjdW0wOVRBM3lMQXZhWE9T?=
 =?utf-8?Q?d2a+iP7IWZcKNBWwCsfJac540DG6vpeR+FfIuj/4ufF8=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d42be55-54dd-4721-de69-08db8215dd5b
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB3045.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 13:51:02.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB3220
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgbWFuYWdlciwKCkdyZWV0aW5ncyBmcm9tIExpbmRhLHdlIGFyZSBhIGRpcmVjdCBtYW51ZmFj
dHVyZXIgb2YgTW9zcXVpdG8gbmV0cywgUGxlYXRlZCBtZXNoLCBQZXQgc2NyZWVuIG1lc2gsIGFu
ZCBQb2xsZW4gbWVzaCwgd2hpY2ggY2FuIG9mZmVyIG1vcmUgdGhhbiA1JSBkaXNjb3VudCB0aGFu
IG90aGVyIHN1cHBsaWVycy4KCkhlcmUgYXJlIG91ciByZWd1bGFyIHNwZWNpZmljYXRpb25zOgoK
MSkgTW9zcXVpdG8gbmV0czogRGVuc2l0eToxOCoxNiwgMTcqMTUsIDE3KjE0LCAxNCoxNCwgZXRj
OyBXaWR0aDoxLjAtMy4wbTsgTGVuZ3RoOjMwbS0zMDBtL3JvbGw7CjIpIFBsZWF0ZWQgbWVzaDog
RGVuc2l0eToyMCoyMCwgMTYqMTQsIGV0YzsgRm9sZGluZyBoZWlnaHQ6MTAtMjBtbTsgV2lkdGg6
MS4wLTMuMG07IExlbmd0aDozMG0vcGM7IAozKSBQb2xsZW4gbWVzaDogRGVuc2l0eToxOCo1NDsg
UHJvdGVjdGl2ZSBlZmZlY3QgdG90YWwgNjklCjQpIFBldCBzY3JlZW4gbWVzaDogRGVuc2l0eTog
MTQqMTEsIDE1KjEwOyBXZWlnaHQ6IDM2MGdzbSwgMzIwZ3NtOwoKV2UgYXJlIHN1cHBsaWVyIG9m
IG1hbnkgYmlnIGN1c3RvbWVycyBmb3IgeWVhcnMsIHdpdGggc3RhYmxlIHF1YWxpdHkgYW5kIGNv
bXBldGl0aXZlIHByaWNlcy5UaGUgc2FtcGxlIGlzIG5vIHByb2JsZW0gZm9yIHlvdXIgdGVzdGlu
Zy4KCkFueSBpbnF1aXJ5IHdlIGNhbiBxdW90ZSBmb3IgeW91PwoKLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KTGluZGEgWmhhbwpQcm9qZWN0IE1hbmFnZXIKRXhwb3J0aW5nIERlcGFy
dG1lbnQKCkFkZHJlc3M6IEJ1aWxkaW5nIDE4LCBOby4gNywgS2FpVHVvIFJvYWQsIEh1YW5nZGFv
IERpc3RyaWN0LCBRaW5nZGFvLCBTaGFuZG9uZywgQ2hpbmEKTW9iaWxlL1doYXRzYXBwOiArODYg
MTU3NjIyODEwOTUKV2Vic2l0ZTogd3d3Lmhpa2luZ3NjcmVlbi5jb20KCgoK
