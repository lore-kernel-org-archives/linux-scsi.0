Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6DCC4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 07:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiLEHjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 02:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiLEHjk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 02:39:40 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB0D10072
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2022 23:39:35 -0800 (PST)
X-UUID: c130c5883c194b34b6a53369cf8c74b2-20221205
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=WCVmbUg+704llzVUuqBzLCvjjbLj/X5Co3i+GTE1q5Y=;
        b=cos0WLAGJXDSQ2VYXEzS5E5tDPIjOobOMIYT02khcodm5z8dOCVHwIAsPcyyKd6nLGj+KLEgnk1g58rID+Dv20P90IIuhFg1wiS6MQLoKn6Vbgb5Owty6T4bYcR3ULMMJjALVFMJhEmo1rJZ4cB6MKwNCqjyCFwBsRGuVBxUqk4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:71c6cf27-353a-4542-9349-5317c8cb1495,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTI
        ON:release,TS:18
X-CID-INFO: VERSION:1.1.14,REQID:71c6cf27-353a-4542-9349-5317c8cb1495,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:28,RULE:Release_Ham,ACTION
        :release,TS:18
X-CID-META: VersionHash:dcaaed0,CLOUDID:f3252b1f-5e1d-4ab5-ab8e-3e04efc02b30,B
        ulkID:22113018173883RKSHLS,BulkQuantity:60,Recheck:0,SF:17|19|102,TC:nil,C
        ontent:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:40|20,QS:nil,BEC:nil,COL:0
X-UUID: c130c5883c194b34b6a53369cf8c74b2-20221205
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1852832143; Mon, 05 Dec 2022 15:39:31 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 5 Dec 2022 15:39:30 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 5 Dec 2022 15:39:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=heZAl0epiDqtQXgME79D5EN7F5g3GUzUSxW43Ws9k0LmiB/YHqlVZv3RCoWlVPG8RRN9EB8e8Mr1OMAGlkv8ZTjchedQ/z8kiOzyAIMwCKO4BgmuOKlLXin0wCtoSjSq42tsfLC2QtyTP88eG2xCbH3voJotakePGL36HTF4I5SINPpwTqd1YhngG4YNlnOUFnESYAbSU982+GqOKPKwuzWFtwpb79ChkEKu0yNVjzH7pRPeMugXUzO0FCeueho1LibsF4N3TTB07T5wIWeRjU8eCryjyA4xMUf/T2lqTIHH9vd2whDtZznFPG/7LB1p3gpeYLHNwNZn6eSpeWjhcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCVmbUg+704llzVUuqBzLCvjjbLj/X5Co3i+GTE1q5Y=;
 b=Z5/TX8mzi3teROta41/iGK0YIi93UpcuMgJR/6gAY4bkoZZOZxBICrleeRg+lRyXGVRx4WNQY4FYylJVF3tAmOpjuGSRA0Q/brpHiARl7DUxRLWv29u/dHo66CLlF/l0DS6nc8hh0GlyMjPN4n2rdUy5xUmSd/pT27tUtJKG8rFJtwpTwnd2FHDUmRZKKabTE20kpVFCEiv+nyDkH97u4XURxBdVGTynfoTJj43Z24w5jnSDmskucVYWBKcXMZe4stGIxe/gTXVrH7OV8AUdlvtTZHHzTfxAJqxG2RGBDdFGVzsTTR2efTVujO4Sp8xtMz2VxweTPSrte2pteJ1sNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCVmbUg+704llzVUuqBzLCvjjbLj/X5Co3i+GTE1q5Y=;
 b=a11zIEreIU7w5+yqCtuYB8k5vQH2cAqLlYMv6RUTz7uT4NIzOuN+7vmzEVxts7UG7Ade6TDFyk6twGoJ8iRMIMnf4MzWu8g6kInEU9VotiJtTQNjDwu28BcyvbJFK8cwAFUpa5uDGKs9c0l8TASYj7oj4XpMBOm+mGP5BsB8nug=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6294.apcprd03.prod.outlook.com (2603:1096:4:175::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 07:39:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::19c4:ae14:8bec:3448%9]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 07:39:28 +0000
From:   =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>
To:     "dlunev@chromium.org" <dlunev@chromium.org>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
        =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?utf-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?= <Qilin.Tan@mediatek.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
Subject: Re: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Thread-Topic: [PATCH v1] ufs: core: wlun suspend SSU fail recovery
Thread-Index: AQHY7f2ebQ5oIqIDLEuxQKxEnr9j6a5Xbc0AgAB+UwCAAfJbgIAAd5qAgAQEnICAAMK3AA==
Date:   Mon, 5 Dec 2022 07:39:27 +0000
Message-ID: <f24e8e5a252715494049ac16d0c1da7d8f1ff467.camel@mediatek.com>
References: <20221101142410.31463-1-peter.wang@mediatek.com>
         <98bfafd3-c7b7-89b5-497a-aa694d0152dd@intel.com>
         <5e00ce60-3859-4964-11f7-e036f6dda56a@acm.org>
         <CAONX=-e1NA--3taTmfbUV+hR_LOSqvBqz_=1mPmYZWaKGGR=ig@mail.gmail.com>
         <c92655563231dd79ed6d4287d7d5bad4de142a18.camel@mediatek.com>
         <CAONX=-d1Hiif9WFuGVQaMr7iUFxOpOSE7bkJriTrqh-Pvtdq0A@mail.gmail.com>
In-Reply-To: <CAONX=-d1Hiif9WFuGVQaMr7iUFxOpOSE7bkJriTrqh-Pvtdq0A@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6294:EE_
x-ms-office365-filtering-correlation-id: 7a2f9c19-0fc9-42d4-bbe5-08dad693d6dd
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m4LM2InjBhR0pZsaKj8XGtEoEM8sP09yZ7OtR7I76LRVEjEmT2cHHvPm34brCxXquSTtMx5BFuZZhEckh91+fBpYtXk25uWBRILrc8/OvcCycj5bLH+Wc3eVxXSyk4dFsCz8wRkVjLVcZ8f0vxSDMXohhUBlQ4i4Ba3fK+AXH6FQcC3ShIbhrvtbyg50WjoaqB29qemtUXFYoUdiSCCp8AUrQF9q3w7TNyFo//q80K7ivPDtwg80Z4IijIGUkBHVEEpWueSSELpp+nHBapipsjnV85kANianc/PkFsCFSdBDCaeDWSj9UDTbccy3Yq93ZoHxI5ygJQOleN5s/uoo7Rk/0b5Ykb9K3gTkpIu6hUAtCwXxZO5M3GIt+luHIs5prPLDLoPsDsusRyMHJwuB2m/pr04lpYK9iRR34y+e30j9q/3mAiEfvl/byfUdcw/HRWJza8SYrID48362JruwgWI3S0OVueSLFQMbouAXv/qSS9sT7FuQi8PQobPyNQmSbwVVIaeD0hgZLFdSw+4EEERfeU1DQPQITtJlr9LJ3NzGPzx0YV0DYxywieW+to8Rg46MjgMTuP3iJJot6YtNfbVFfN11bhMFPrEmhwVoBgnCbNgXfsKA6iO4IPfl2FBcjKFekqXiiDar2DG7Z8c99GxMjhm+kFI1AdR9daUSsrGXzONu40cIc64/oCg5joQLqgK5KIU0wRyA/x6VCKNpH4D9EHZrwNpvLwThJXjgTJ+SxzWpBHXCzT45oCkW9Mr7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(2906002)(26005)(316002)(86362001)(66946007)(83380400001)(6512007)(6486002)(966005)(6506007)(186003)(54906003)(6916009)(71200400001)(478600001)(4744005)(41300700001)(2616005)(5660300002)(15650500001)(8936002)(38070700005)(38100700002)(4326008)(122000001)(76116006)(66446008)(8676002)(66476007)(66556008)(64756008)(91956017)(85182001)(36756003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2pBK05iU1JzRjJPMTA0dHB6RWFCbktFMzJaR0hXYkRYZXpjQkJ0T0ZZalBs?=
 =?utf-8?B?Wi9pVGtWa2dRbklkYnN6aW9HQWJsQjc0eW03ZWs5NmxKeE8yZlU4UUV0eTB0?=
 =?utf-8?B?blI1OVM5ZlJpeFZyMEd5ME1FN0NuTnZmLzBsMmtwSU9aZVdjSVBEVDhEemV5?=
 =?utf-8?B?TUdDek5mNXI3a3U1QkFqM0pwT2FRZk10YUExOWMrcVpoeUFCS0pWNUt6dVdM?=
 =?utf-8?B?WURDZlgrMU0rWUtjaFBsOGd4em52NEJBdjR3ckxacnM0aElpSHExVUcxTjZG?=
 =?utf-8?B?dWpqRmJnV3VKbXBrbmtmeWZVZzZaTFE3UWp6SGFEb0JPMkhBUnVIZE4wd3lx?=
 =?utf-8?B?Z3AvMmxRcDhMbVlZZUJQZUc4N0NNM3Z4Zm1SMk1DWVhHWFFhLzN2Yk0zN2Q3?=
 =?utf-8?B?UnczZUV1dzFYV0tvTXUzUCtYcWxMYlRUUWpSSHZVOVowWWJRejdCbGREOG9U?=
 =?utf-8?B?WFl4bitXeUFZWUVqMlVUZm44NHNiMWxERUkrTGVPYTVtb0kzV3JXSG9sVHlq?=
 =?utf-8?B?dktrWVYwNVR2c1BRMytwY3o3Vnd1RnA2Nys5N0pjRml6MGc2amFZUFhmb1VT?=
 =?utf-8?B?VUtRODhNZnlaQW5pZzQvS3Zkd1hEb3ZraWhjT2Jtd2hobzlIVzhwNzhac0pO?=
 =?utf-8?B?SUR5ZU15QndNNTlaLzc0U0NRdGtMby9jM29ESGp4bVVEUlQ1a0tnRUlKckYv?=
 =?utf-8?B?K29vTS9NRFFYbFhSYU41ZFRzQ0JBa25aNlhNdkorN0I0ZlQ1THV4Ty93aURV?=
 =?utf-8?B?QjNPOWZNcEpOZWIramk1c2FpUkxiVG53eTZXMmpUT2x6elI1RVpOTUl5VDFK?=
 =?utf-8?B?bktXb2czL2Z2OFdCbkl0TVFMRjBjQUo5RUlESnExTE8zSk5mMTgrSWFRWXdG?=
 =?utf-8?B?bklva2tuaGw4QzVVNU1OdVY4YXErNTFodDlyVEtiaWJsQXZSay9FZFFCbmlV?=
 =?utf-8?B?OTNadjd0a1dHMzBMRkJoenhRckZWYjJxcWk2WUZ3eGhhS2R2ZTlnVEZTa0d3?=
 =?utf-8?B?ZVBmeVFYcWJpcXoxTlFCVnpFVHFVdGhDaTR1Vk9NNTBHMDNSYkJTWTRRUStS?=
 =?utf-8?B?eFRDUXlpUTR0K1hyMndsRythTnlDcGVrYXlkRWlaRVF6SHdWeS96Z3dEMVRk?=
 =?utf-8?B?eHNwNWZocUpGanV3RXdINDN4UXU3Smdhd0pYNURiSmVNS1h1a2c2YVZPZ3Bt?=
 =?utf-8?B?YzZGYThGanp6TWZKMUtJVmdZOXFNUTIyL3ZQWkRxVmc3WmVEOEtXQzhkNTdj?=
 =?utf-8?B?bDNOYkVqZkM4bVRjK2ZKaFlMbUhQcGd0QXVpaXJTYWVDNHBYWE05UHo4MHlw?=
 =?utf-8?B?QnhYaG9KZUl2OVRJSVZML2krMWxiV0phR0t5UjlzSElQQTVSNXFtYTZRbjJI?=
 =?utf-8?B?MGtCbFFVNjU5MDFpV2ViZzBJNXgzS0s4dFFLU2xGUUxxYW13Z05kSEhPeTBC?=
 =?utf-8?B?dEFqOExodUdNc1FIUXNtTjkyOHVZUVhSU2VRLzBUREpHRXZLMGJEYzFQRk1K?=
 =?utf-8?B?MmFzeDhHOTJTM2VGWmlHTytrL3k2Z1VoTmVJT1VXR2pvR21oWklHRnkwQU81?=
 =?utf-8?B?ekwydVl6dFJHL0JqSlBFZ0QzZ0ZGOGpDYlVQbjNIUXlSSHAvMTNGaWhndGZR?=
 =?utf-8?B?dmVvOGZtdTR2NmhPVGpsYkxaOGwveEVRUGNIQ1dzZ3M4ZlAxeGRKdDF0UVFC?=
 =?utf-8?B?SWdQRUw4RmRyRVNhNms1U05tNDVaWWgxTDd6QSs4b04vdFB4RG9hQWZyYzNy?=
 =?utf-8?B?NUpqYmtqVnpQOTlPUkx4bE5GVTJzeFZJUW5DNjNUdXNkS0lmYzBsSWJjRE9S?=
 =?utf-8?B?MC94YVZKWWFiSEJRVUd5OWNUamgzeCsvM3l2TWNtei9iOUxJV2ZHa1ZXNlA2?=
 =?utf-8?B?ZXlzTHFEbVBYaXdhcXNVZ3BPa0pCSWtLVUYxSVp4MGtYVkhFVDJ3SDArT3pq?=
 =?utf-8?B?dVBzQVpLWnpSS1ZJdk9nNG1IdW0rc25OdnI3NTJ2Q1U4UlkxZFNXdTVDa2hq?=
 =?utf-8?B?MUxacXBnQTE2UkZ1UTZ0aDU2NkhVVTJSdGh6RnpBNmVXYWVMbDBJd09Ba0JD?=
 =?utf-8?B?S043N1JZbVBTODMvY3JPZEo3SExXUTU1QkdsajlQOWVZbGxrWXd0aWJlV0dM?=
 =?utf-8?B?WnlqdW5UR1AzNmJ3QnpxMzlxS0s1aXVGM3hCM1lXYUxDdXZFQVEwd2x6cG1U?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <391985618D504E429C975C2F89690BAF@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a2f9c19-0fc9-42d4-bbe5-08dad693d6dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 07:39:27.9582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TbqGjzOjknKThsK9lvZzQjQlWtPb6UVt66S5nxc7pU2sJ7VHzDwsj0HhMIZ+aX1QhVfooLzzYzHPmeU+bVIIEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6294
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgRGFuaWlsLA0KDQpUaGFua3MgeW91ciBmZWVkYmFjay4gDQpJIGFtIGdsYWQgdG8gaGVhciB5
b3VyIHByb2JsZW0gY2FuIGJlIHNvbHZlZCBieSB0aGlzIHBhdGNoLg0KUGxlYXNlIGFsc28gaGVs
cCBoYXZlIGEgcmV2aWV3IG9mIG15IHYzIHBhdGNoDQoNCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5l
bC5vcmcvcHJvamVjdC9saW51eC1zY3NpL3BhdGNoLzIwMjIxMjAyMDczNTMyLjc4ODQtMS1wZXRl
ci53YW5nQG1lZGlhdGVrLmNvbS8NCg0KVGhhbmtzLg0KQlINClBldGVyDQoNCg0KDQpPbiBNb24s
IDIwMjItMTItMDUgYXQgMDc6MDIgKzExMDAsIERhbmlpbCBMdW5ldiB3cm90ZToNCj4gPiBNYXkg
SSBoYXZlIGEgcXVlc3Rpb24sIHdoaWNoIGRpZXZjZSB5b3UgdXNlIGluIHRoaXMgZmFpbHVyZQ0K
PiA+IHNjZW5hcmlvPw0KPiA+IEkgdGhpbmsgaXQgaXMgc2FtZSBpc3N1ZSBkdWUgdG8gU1NVIGZh
aWwsIGFuZCB3bHVuIGRldmNpZSBwbSBlbnRlcg0KPiA+IGVycm9yIHN0YXRlLiBTbyB0aGUgY3Vu
c29tZXIoc2NzaSBsdSBkZXZpY2UpIGlzIGJsb2NrIGluIHN1c3BlbmQNCj4gPiBzdGF0ZQ0KPiA+
IGFuZCBjb25ub3QgcmVzdW1lIHRvIHJlZHVjZSBwbV9vbmx5IGxlYWQgdG8gSU8gaGFuZy4NCj4g
PiANCj4gPiBUaGFua3MuDQo+ID4gQlINCj4gPiBQZXRlcg0KPiANCj4gSSBkb24ndCB0aGluayBp
dCBpcyBkZXZpY2Ugc3BlY2lmaWMuIEkgYW0gcHJldHR5IHN1cmUgaXQgaXMgdGhlIHNhbWUNCj4g
cHJvYmxlbSwgZm9yIGl0IHRyYWNlcyB0byB0aGUgc2FtZSBvcmlnaW4gYW5kIHlvdXIgcGF0Y2gg
Zml4ZXMgdGhlDQo+IGlzc3VlICh0aG91Z2ggd2l0aCBhIGxvdCBvZiBsb2cgc3BhbSB3aGljaCBp
cyBhIGJpdCB1bmZvcnR1bmF0ZSwgYnV0DQo+IHdlIGNhbiBsaXZlIHdpdGggdGhhdCkNCj4gDQo+
IC0tRGFuaWlsDQo=
