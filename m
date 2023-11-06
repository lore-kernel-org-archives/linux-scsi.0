Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED47C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 07:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjKFHhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 02:37:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjKFHhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 02:37:33 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764AD76
        for <linux-scsi@vger.kernel.org>; Sun,  5 Nov 2023 23:37:26 -0800 (PST)
X-UUID: 51ded4267c7711ee8051498923ad61e6-20231106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=QyyIqW1lizISfkX1JMAzIm2VtsioUuJStnwrw0pfCbU=;
        b=VygxTdqJXgvLT9t9r1lt2c2zS2z6J8XAFI06Ft6ChzAIJDn5WUnM/DGARfFp+F/2EWj9jqc0K/BW88EmnPXjFMLhdt3vzVoS7QqvfQtz7isVHHRMT1a2eUwuFg38mTWmwHovFzC8COBCGgfw4mWc+P2blB5YDPR/vqQZdUdIjc0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.33,REQID:21a80652-4d0f-465e-a695-f40010b8b078,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:364b77b,CLOUDID:2b250f95-10ce-4e4b-85c2-c9b5229ff92b,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
        NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 51ded4267c7711ee8051498923ad61e6-20231106
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 660273532; Mon, 06 Nov 2023 15:37:21 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 6 Nov 2023 15:37:20 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 6 Nov 2023 15:37:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO/V0LwE/3MBYITX33HRgvqDuVRhNosAelMc9uA7n7zLcJHCWYLO3emwFxVJkQ67Lst2LWyiUEhOqyYqqaPaVhvb9DENlW/ixGiwlNW/RiOsMmaxSUzkBG+yjgSuNcD6zTZDbB8N4c8YS+6ZcWiGf81Yk6JSbjLIkOc5tE1LymnIH3abD6wTyBx1P8uB6+fXZht3usfYxk8XLq3XS8V9xVuKQI85KEp35Z9XCLH5sDYUBTVzhqRZPNMZ9YOh4g/Y8AIjB6FoHOmu8EpKi6Az6o0R64H7uLE7swONmIWdGrIBdgGZ+jW0n8D/JlE2fUeANqRLJlROYa2FkpWuEenU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyyIqW1lizISfkX1JMAzIm2VtsioUuJStnwrw0pfCbU=;
 b=KR5gRseP1Q3apiUwVICE3BviC7iumuRYC90V0ZABo8ToKghh9bxzQjFyJws5cFJe7EClf6Ie/MUzIPI1lBxKdY18A09+fsKhvoLLgaXLFI6LlVJgCJ8fow/bf+SsdwhavlhVCp24hOgzi24dYEtw8Bqjj18VP8O+CL4mSwzuRJUl0Sa+T+pMTorXRKq8D8CTi8F2s9DTvc+OkBBXH8QLWF8bitDZGeFLE+b5ThcXSMp0h2HKLz0dgXdch8tHIvA+PS4yEn88wwba4q436/2NTBpLXDG9qMfNkhFOwC4wQbA6doJHZLL+l1SaD6asB64Rk1pk/k+sbgpC4IakOt1rsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyyIqW1lizISfkX1JMAzIm2VtsioUuJStnwrw0pfCbU=;
 b=sOrFG2YR0yTsRX1JCBH6mR7TSlAPuL4ogXAgVGY+zG06ABrcUgLKpY9FRoB7QTsKSyoeUonT7J+fttpdRd1qKQSyttb4zyz2ObKZCBHPiVeZ+1fJO/xo6GpUi5DG2baFmZ6GX7aCSRsKA9LOzo8lacrb4D3cN03vo8l8Y3p7wmM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7079.apcprd03.prod.outlook.com (2603:1096:820:d5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.27; Mon, 6 Nov
 2023 07:34:15 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::fe9d:2778:cc48:6b1d]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::fe9d:2778:cc48:6b1d%3]) with mapi id 15.20.6954.027; Mon, 6 Nov 2023
 07:34:15 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
Thread-Topic: [PATCH v1] ufs: core: fix racing issue between ufshcd_mcq_abort
 and ISR
Thread-Index: AQHaCLGs15USPRn4k0iVCY5EmXuIgrBourMAgAQ7MQA=
Date:   Mon, 6 Nov 2023 07:34:14 +0000
Message-ID: <6a46d72866b5fb7fc299ac7af6b5055bf454fd78.camel@mediatek.com>
References: <20231027084329.4067-1-peter.wang@mediatek.com>
         <a017262a-b367-4500-90a9-bc099fe08a5d@acm.org>
In-Reply-To: <a017262a-b367-4500-90a9-bc099fe08a5d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7079:EE_
x-ms-office365-filtering-correlation-id: 57f3e9ac-1c58-441f-7b81-08dbde9ac729
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +87u0AY8RiOSj2WivRWEIV+iiHrk+SMMH65ipj4NvXrbRBzuv0L02u6VOAPPOGKjmszsMb2JOOgMk8D7PB2ogObJNdVBf/kZy2U0JAwohMel9LmpGMLEcUAA4LbaWmsJGR57c/I3q4+9aZOnNyhoDCxvbCdKgd+Y3UVBTGhjgINaB2B0Oj87rL930+UMfnQLjGzgAOv3feZq2abEZU6ZDNF46WWcNZBaLhGEvwsEzqdJHppSCvnQJ87VmHwutCzNG6543rKXysVuPljNrcuPpgQSENH+Tnrpe0AoLI6OmTb7WSBRVS8/qJ9UMUvphEtZdpgDnlRb4i2gsD2O3NOORNVZz1HKA0wAjZbETxYR6bLUz96vIUvAmF/QLM3kHW/pPyrRBGG9YnSOmoWPy2Ez/TpcVdTWruXm4+DGh6cPmk6lE1NOkgLETn+nf2fEvrJ83STJ5Cj6mm7MOLVNotouJi4KJZOPCjtamQqEr2+xfR73AqhKMiVzpNtLof6KRo4HSHiUaIkx4EPkpC1AzutKcM8H0TgxUgfU+YV+s5/PRuY3LOO0tpkOPjPaGnztNYh03Ob9AURwWyTmASgG5CHCYyiGYx0BEIkEdB6qsJNPXTANM9E++RW8Mf8Yd+O3OjL4O/wQyPGvMf2yTmtuUCjlZbBQGRNmcGqkRqxVFI+6W+WjQPQntumNyxRtByQskqN3p83JCYoh2OMgA1bBp1gI8J2OCQS1uxx8L8onEfFmwX8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(39860400002)(346002)(366004)(230273577357003)(230173577357003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(38070700009)(122000001)(6486002)(64756008)(53546011)(6512007)(66556008)(478600001)(6506007)(76116006)(110136005)(66446008)(66946007)(66476007)(91956017)(85182001)(36756003)(86362001)(107886003)(71200400001)(26005)(2616005)(38100700002)(4744005)(83380400001)(8676002)(2906002)(41300700001)(54906003)(5660300002)(4326008)(316002)(8936002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1N1NmREelBrTm0wQmxnalpYMWNCYzRjZlJFRDltTVhIcTROZmhFaHhlc0dl?=
 =?utf-8?B?RE1rVWdKNlRTYy8xQW95SUI3Wnp5T1d6RWZHdjF1ZmtwclJjSWhWQU5oMGVi?=
 =?utf-8?B?OGFXSTQvSi84YjdORU9zUFFCTXpBYVdWcFl1N1hFck8wVTdXeHRKeVdqYkE0?=
 =?utf-8?B?L3huKy9EaHh4Um1YeDlUYms1VDNZdGJJSGlKQTJEd0h4OVYvamFCTkxZRXd0?=
 =?utf-8?B?ZWIyV2E2TUtERUpSK2o0U2V4b3JsSHRpSXUrY0FKdzNqakdKT0d4eDNRNUJ4?=
 =?utf-8?B?c0M4WEF5ekIyZGsvN0ZhRlV0U2lUZm96bWlhYVYwMWR4MStIajdoOVZ2WTZM?=
 =?utf-8?B?cHJ2bU1FVmtsb1Z6bTZhK2IrNytidi9DTG5iSzNNdHd0MDFhZTlvbHNlbGMx?=
 =?utf-8?B?dDVBaWZIU2c4NG5RZWFZMUpENlNNcTdlcVd5RTRUcUNGVGVMTFJUWGpXakRk?=
 =?utf-8?B?NzRQVDh3cnVxN0wwSWxxNFYyb1JCRDFyWFRldWtWRlN2c1pmR3A2Mkp1MWlY?=
 =?utf-8?B?ZmpJeTN3SU81ZkpsV2gvWTVyVHNSdllTSDZFQzFhUXR0THFCK2s1WmtCd1Rm?=
 =?utf-8?B?SytUc2JSZUVrVmxOSVFXaHJVais3UnRBR2pabUNlS0xhbEVjb2J2MnVNdnNU?=
 =?utf-8?B?dXRFSGNGa1VMRGJsZEFXYS9ST1RtTFhvNS9Qd0V3WWhsOGppbU9zelJYTnJY?=
 =?utf-8?B?TzEyVUx5dDllREZrSDlVNzRiMnpqKy9VYy9Tci9NYWdOcHNqdkUreGk0MGx1?=
 =?utf-8?B?anJiRXhiWlRQVGUvUlhSK0lpMFJ4WjNHY3hTc29DSG5pZWNHVzZHb3IrQVpY?=
 =?utf-8?B?K2xLOVRtWFlUY3VLTGZxb3lzZHh2alpraXY1N0JYME93RWRrVm5WS3l4cHlP?=
 =?utf-8?B?UVJVODl2OGNDQWx0amJqNkNKMVhuRGJCME9zVzlCaWpuTU9CZm5oeHpraEIv?=
 =?utf-8?B?UFZDZ1d2c3EybDFEOHd2SVVOOE00cTkwWnZKa3pFaHNxeTQrc3ZRK0dCeDVX?=
 =?utf-8?B?SnJyaUxtU2NyT3hFc0hIVVB1Mjg5S0ZDVGNUSGNoMjlQZWdENkwzTTN4M0FU?=
 =?utf-8?B?cEUzS29tMnZybTNwbjlZZzlhdnJJUzVZZ2xPVW1RZ1JGdDhQWlVIalV2Rllt?=
 =?utf-8?B?dXpubTg1QzZVcFdKR0loZ1VxZ2VkdXFob002Um9pMnFwQ2ZDcis3NXNyWGhx?=
 =?utf-8?B?Yk43VEQwcGZhQ1hqa0NrcnA5eURpY1VFN3d4MGg0MmhvdFo0eGlmakI2TDJi?=
 =?utf-8?B?K3lRNWdOU3NNRmFhNzRHNDQ0b1hFRFVhR2ZjVm1BS2E2Z2VnUXppekMyY3E0?=
 =?utf-8?B?c3ltY1ZWR2x4eWtjQTZXT2JZOFRDenNWd0dxNDdHbU10S1RtajlBeVgzOVBo?=
 =?utf-8?B?bmp6bWxLcXVLQ2NZQUVudGVoclRPSVpYazVmcmhuOHpycmYwL3NZWnlMeFkz?=
 =?utf-8?B?NkRzdEF0YlVveEg3QXZvMUhuVmRuV1BtVGRBVGRYQlJIVXNCRnJqVnY3Uk8x?=
 =?utf-8?B?dHgvRFhnZktleDJFOVJFdTNBZmtEaVF1MmZ2aHh1bjRXWGZrT3o0NlRpbVZE?=
 =?utf-8?B?ZTBWZ2NaYmxQUFVobjFubUhpNjRwWjdOVjZMU2dpbkJ3cFM0TU5RV3BERW1q?=
 =?utf-8?B?azB1MWFHbTRJYnlUV1FIWlpPSFBUWFljNHRhN3AyeUlXYkdUVHd2UUNTYXBr?=
 =?utf-8?B?UlNFSUZiMWVxcks0OHBSU0dqT1BxVkdSdUFFd3RFaWxMT25ZWEdsZStIWERR?=
 =?utf-8?B?eWFGMTdjMzFneFFFNGkzYWNmU0grZ000MWloNzZUZEQxVnRLbitjMFRRTlZo?=
 =?utf-8?B?OEx0YXhYM1M0UndEeVptS1ZCcm9NYk03WVpRYTdxWnBSSU9Mc0hVczhEWEFC?=
 =?utf-8?B?TEwrb1R4dXliZG9LZnJuc3NnRVk2bnFBVExHWVRkNGg5WEkvYWxzNUlEekR3?=
 =?utf-8?B?VmZCTnZkcU94YkhWTVM0V080YVB6VTh1K3JoaGFiL3MzRU9PZTBLSEEwbXhw?=
 =?utf-8?B?TG83azNXRFNjeFRxQlFMNm9RWExYQkFIOFRkOExrb3E1amZSbldvbExyZXJt?=
 =?utf-8?B?aFlxQTlkdjZ3eGxJbUM0T2w3dFZuUTR0cTR1cFp5a3hMNTdzTUd5UmtrWHI4?=
 =?utf-8?B?YnF4RExIb0hwcVZCMG5oeWMyb0p4UjZoanhQUUcwNld2MWpoM3pYRUdNSTZ3?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6ABF682A2E4FC40B53BC02E2A40A1BE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57f3e9ac-1c58-441f-7b81-08dbde9ac729
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2023 07:34:15.0706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wfYhuo3YgIFOVuzGQt+2+/Ba/Q4tMPgXlqZBLfSMCz7gtI0b2nEC2PBdD0ldwWLZnvtCUfhzDxL+vQBFJCCcNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7079
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--21.188200-8.000000
X-TMASE-MatchedRID: ge9e+QLSeazUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
        WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosTF5m
        VOro0mqbZOwGrsd3Jn9jTtjpvVy0grRlLslggfyrmAId+2bAQwsDyPNek9e/amyiLZetSf8n5kv
        mj69FXvAOkBnb8H8GWd2QOzJPxag5q8/xv2Um1avoLR4+zsDTtAqYBE3k9Mpw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--21.188200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 0266FBBE0FE2C6A207516F51AC9EB326BDCD7C7E84840B5ADB49262D068792D32000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDIzLTExLTAzIGF0IDA3OjU3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMTAvMjcvMjMgMDE6NDMsIHBldGVyLndhbmdAbWVkaWF0ZWsu
Y29tIHdyb3RlOg0KPiA+IElmIGNvbW1hbmQgdGltZW91dCBoYXBwZW4gYW5kIGNxIGNvbXBsZXRl
IGlycSByYWlzZSBhdCB0aGUgc2FtZQ0KPiB0aW1lLA0KPiA+IHVmc2hjZF9tY3FfYWJvcnQgbnVs
bCB0aGUgbHByYi0+Y21kIGFuZCBOVUxMIHBvaW5lciBLRSBpbiBJU1IuDQo+IA0KPiBQbGVhc2Ug
YWRkIGEgRml4ZXM6IHRhZy4gT3RoZXJ3aXNlIHRoaXMgcGF0Y2ggbG9va3MgZ29vZCB0byBtZS4N
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNClRoYW5rIHlvdSBmb3Ig
cmV2aWV3LCB3aWxsIGFkZCBmaXhlcyB0YWcgbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MuDQpQZXRl
cg0KDQo=
