Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C83E776E9
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 02:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjJCCTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 22:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjJCCTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 22:19:04 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAD1BB
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 19:19:01 -0700 (PDT)
X-UUID: 32dea1a4619311ee8051498923ad61e6-20231003
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hbQe8kgsN/fBoD+VLE22OwnzYXsv96SR1Ftm8hxafHA=;
        b=mi5aybTo+IGT57ptg2yzZLM6kghs/rtiHmQ8lGwjAQxFFist82bMpE4UvnF1ojDjOFxSvlHz7HIbBNVcMvyk4lC5ES0wRKIWt/lW0NypCBFhFx5nRAZ28V+8FDiX2nK/lWo9Rg/26n398eKC2v6aZ9pLOOEoV5305TW04cwmVtI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.32,REQID:51bad116-35d5-49b4-a811-00a986f328d9,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:5f78ec9,CLOUDID:ac4983bf-14cc-44ca-b657-2d2783296e72,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
        DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 32dea1a4619311ee8051498923ad61e6-20231003
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1941073175; Tue, 03 Oct 2023 10:18:53 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 3 Oct 2023 10:18:51 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 3 Oct 2023 10:18:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZSQJAXEr/EhkrkNgzj/a+69VcDU/tJzw9iygKk47RE00piI8JrLuO59CxAWqX6CWzYG839G2WvMfLCdmpPLcPnrQp6Fz7fXDOT60B6HaAZVNctal1sD7xPw+jOB38Q9REmA6cD/VrshCsS0g43aWH47nJcRJL8ryjUU76ciWJIpwndLkAoAX2TloZFVBomxUu7Ss9VWDifyC7ztax+AxiOlHEd96FcaxFfdjLhFczGWMqyLIdTvkpmeeVSEBn6f+2+/IRxcowTs6VRbal7/Is88NYyHIJSzpjLeCZQr9ZL+uOP1XCuOLhCKOqE7PyAdhd2oH05v2zYHstB0nNZDfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbQe8kgsN/fBoD+VLE22OwnzYXsv96SR1Ftm8hxafHA=;
 b=Quc8Ec538MaqU5M8StNtNigzI4RDUDqz5QQ9nw/Alsc8NS0PKRERpLHrpo5do8LfAdOub7pgzdwhO5+Zmj42WCgaE+1TSaMqhFC4kv+xq3xEHhsRTxX5r25EmF249rk/n+xacdQ/qZZSSMa3Dd2sMAP66yWoW1cI6n2bmQUJMYjILW7Un+HXgkA1fvxADu+idYOwEZ9/tsUvkmxsTnM8LhHceOFeic9jsZFC0L2k6DRjw7AN8176hb9fIa1/EQ+LHGvk1X9AcQbjq/Ho/Ht9T42PhJ4JCFPni7tD8BN4HlOjAtWauhmI9eqsCTZhgTs9LhgKOqq/qikQbmbt20On5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbQe8kgsN/fBoD+VLE22OwnzYXsv96SR1Ftm8hxafHA=;
 b=Y0xLChVcE983oWDm66JKVlv+lNuwx7I8RYSSnqNa7rzVIlgD3Z+vOVXuH9VkX1S96B5AqeocPdki+1YZ5LmTGHacEHZ0Wvuf6xM0WL/rw0R3uNrGvLpV63I6AmzriTqml7I8CHqTQejtjLXDV64iWfXGi/vGXTT3Lh6LLqcW8b4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7681.apcprd03.prod.outlook.com (2603:1096:101:13d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.36; Tue, 3 Oct
 2023 02:18:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::6b1e:f21c:5401:d739%4]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 02:18:49 +0000
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
Subject: Re: [PATCH v1] ufs: core: correct clear tm error log
Thread-Topic: [PATCH v1] ufs: core: correct clear tm error log
Thread-Index: AQHZ9S/JJcXGJJjQQk2ZKVxQRmo43LA29QOAgABgfwA=
Date:   Tue, 3 Oct 2023 02:18:49 +0000
Message-ID: <7cd24948f22f63caeed6881b085e32b0aa65021f.camel@mediatek.com>
References: <20231002125551.15111-1-peter.wang@mediatek.com>
         <13bb26ca-fb67-4f20-a05b-362d6829a3e5@acm.org>
In-Reply-To: <13bb26ca-fb67-4f20-a05b-362d6829a3e5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7681:EE_
x-ms-office365-filtering-correlation-id: 8cd9342f-5db6-4e3a-3177-08dbc3b7148f
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oL5RxNdnhO79APgSgulUe9XLlXiUZXI2k5DPrlTcb5zKZGPiJC8gidyHLaxiy3plrKWQYoxDtTuAVCMRIbCXXnHmLvAC8T6fCJ4ATQDT26FjYd260Uofzd6I1vdaMJJ+o9I3sztrwo49KcdH3ABHMqw2akQdcQtIg2aYHJ6YUR/fJ0+wyphcgpKSHj2e99CqdTTlWXdxNz5hLQKPubUyo+UniM3j5rDPiYfSDUGTpnidgGLqvzOTNjAZBIR6ZG/pjNSR+HdWRQmFF5U/DlTdGtK5j3CXp4NcHN1nIvzsH4uhq1RpIobP7nQMWrzwvKkLe8wUWDOWze6SQb7cVMJuEIKoTjbRlE8LhiwCHhuFvpApKurSxw3q3PRXSloetU3E5Tho8z0VG5BP33pP36+VXKXHpdGucmqvEGUSqUVFdb8OgQaY40x/URT/5oUo3XLowtmHEzRBynqEcfjIzwB7ehYxi4N5bScYXTgwT9qvmWKCUdhbOmwcRXfSD+OsoUcqKirUQguHwuVCSygt2U/3VLNWjGuKg+Ajf98T/nts4PGBbTMvXKYjMBBq693q78E1imsgqnkMxYBSa1ca2litq+n+0gLF3/Biq6ihi+2hinwgYMFDr1UTrxuAK9G98DRxhO7woHwfYlR+/z1oNU47q+nLeG9BOkoReo6ZIdQsktTzoCxkAQHxdEtBQySqJrGa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(396003)(376002)(366004)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(6486002)(107886003)(6506007)(71200400001)(6512007)(2616005)(66946007)(91956017)(66476007)(64756008)(86362001)(26005)(66446008)(478600001)(38070700005)(122000001)(38100700002)(76116006)(110136005)(66556008)(54906003)(83380400001)(2906002)(4744005)(8676002)(4326008)(8936002)(85182001)(316002)(5660300002)(41300700001)(36756003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUZTTDNNb1ArY1cxNFdtSENNZVlZUHNBZDVCUlhXVUpsODVOd3ZpSGViSmpY?=
 =?utf-8?B?Wlc0SlVGMloyc3BzSzUvb2E3WjNnTGVPZk1UUFdQM1pFRnBCYm1XbHdERmpX?=
 =?utf-8?B?anJpZkEyOWpxT0ZRdExMMVdoT0NLVGpzTVlsanBNeVNkNFBaRERYM05zZCtT?=
 =?utf-8?B?K2VMNVNKaHk2NmR1MFJlOWl0SGxxNGlWemNuZDd2OTh0dmt1OE5tMzlPSEFQ?=
 =?utf-8?B?TklEMWdDUElPeUtOYUtmOXY3aHB4QW82bmU2MTN2SVZHTEhDZS9pdzZPL3U0?=
 =?utf-8?B?RkIxV0pwYWorNE83YUJLNWlYekt4MmpTaHYvNE9iNWlvQ3Fmbk5xR3ZHeUox?=
 =?utf-8?B?VVIzNjlmUDZIaGdaRXEzUEhQZFVOWGoxajI5RUY3TE0xQjBTblhDZE1sNEd0?=
 =?utf-8?B?UkNKZWVWSk9CaEdjMzVLVzZrQkN5anI0eVJMM1BXOU1BUDVIeXJVdzBTYzB3?=
 =?utf-8?B?NkVWRjQ4c2J6VU56aEdIcmh0NG1nazRsRVZQcGo2SmtRYjA1ZlU0WjhneUta?=
 =?utf-8?B?MUc2RXVIeVBLTnFEdXFTamlZaDVla0owTEZyRTJmMEF3TDduVHZKVnlMKzdq?=
 =?utf-8?B?V3p4NGxES0VYOHZUaVpDanFtQ1lybXh3ZUNmYUxmL245R1pWRTA5by9KMlpm?=
 =?utf-8?B?bFhKQmx5MTAxNUNKbWpsV2ttR2xwcHIwSFN2dmxsNUlZSE10bDVCb3NmUWxx?=
 =?utf-8?B?Rys0Slk2RWJkSDk0NVRLcmFST01sZlo2ZEozU0NkV2tGZEE3YXBON0IzUW0v?=
 =?utf-8?B?RjNHYlMvVngwYm93VXZFM1Fzd2dnc1RMazdURWRrSHM5Ulk1eVMxY2RObzI1?=
 =?utf-8?B?RTVhSW95TC95NVBJZkJteG1SUnBHTW9KWjUwTGc2QTVaNDlHZzBIYkRQNFpM?=
 =?utf-8?B?bi9zRXd0ZGdlTHc5bFJ6R092NmdtZEpid0ljem14a2pTWGlkS0hFTFdqNWo5?=
 =?utf-8?B?Lzl5ZmkyL3RRa0ZDODNNd2s2OXhaK3YxREhWelNEVFVvWXJiRVVRazRGZkpP?=
 =?utf-8?B?Ri9BUHpBRXlNN2VrM2NjTjkzM0dReDhUa2lzVmVXTHVMZ2JHT2xUYlg0TVVL?=
 =?utf-8?B?aUxZQmhOQnpnaW81Q0xPaVpwZkI0V05TRm9hUHVvUGk1QmM2SThDTkdEOFNG?=
 =?utf-8?B?eHNmS05FZ0h0eVFuSUtWQXNuY1UvOFdKNCtETnRNNnBtaENnMXpRZUdpcWVQ?=
 =?utf-8?B?VTlpT3BmOUZSckJhMjNFNDZDQUFnYjdJQkRyUFFuUmxhWld3UE5RUURvSXE5?=
 =?utf-8?B?SXVNak1ibmRDZlNIL0VwR0MwTWdjMm12MGJmQ2JQU3cwN0hqQVlCalMzMTB2?=
 =?utf-8?B?UWVGOGNqS1JEeVZ1MFJGUmpuU3o4QXBxRTVzbTBEZ2o3TlVMODAvRFppWTNn?=
 =?utf-8?B?SUlxNzRBS1c2Rk9reW9hc0EvYWhHUFk1WWgzeStnOTV6UTlPNFNadU90MjNG?=
 =?utf-8?B?TkNhR0dEVWdGTEc2MmwvZENvM3p5eDgraUVHajJXL2EraC9VOFlmcmhaMEE5?=
 =?utf-8?B?MDZiYytZSjNTeStFVm4zd1hwZVVGcENOenJldmRrZUV1RHhEWEMxalF0S0lY?=
 =?utf-8?B?dzZFaEZNdVJiWTBpR09sWlRYOE4weUxXU2ZnVll1ajFPdURPM0RZQTlIeFNL?=
 =?utf-8?B?ZzdMT29WS0V6c0cyb0lLZVRTcXZPV2lXSzdXeXpXRXU0WVZHcGh0eC84VVp1?=
 =?utf-8?B?VXVuK1hxTHJLaW9mOXdZdHdrcHFGYzJlN3k0dnhDREpKTFZlYzMwdnA0ZjZa?=
 =?utf-8?B?L2JsR3Vha0pSNjBSOEQ2YThIL3ZSU1VoTE0remdnZmVUOWV0elc2ZVZWdWFD?=
 =?utf-8?B?Z1JMdkVWVThpcURieHhyQXNsNERSQ0pib2xsOW5UdlRXM3hvd00ybXUxaFFo?=
 =?utf-8?B?Tlg4L1orOEZpLy9xRkJZSzNtelM3NEtNMDVjRE1oNGQ2Qzl4dmJZK2JCaW5n?=
 =?utf-8?B?MEpuMjkwa21YVW4wTG5qRm53VXcrYWlkYjkxUVVQQ21kTWg4QXdiZE9XQUVt?=
 =?utf-8?B?anBoSzFwdllIekFnN1VpWllqblpZSnpYWTcxaW1nNzBWdDVSMW5TdVE2d3Nx?=
 =?utf-8?B?b25ET3QwcUgxdVpPTnR1ZGJQeHp6Ymp3bTgyQ2d1YUdrRTU2eHd6RlkzcGpC?=
 =?utf-8?B?Um95WWJSZlFyQ3gvV3NVdzFqTnVMZlprNUVVMTl0Rys2K0V5d3J6eGdxUGc3?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B268B390265534CA09D7F9DC18656A6@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cd9342f-5db6-4e3a-3177-08dbc3b7148f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2023 02:18:49.4086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZlGsuDJ9ZoS/72fCfWR6FHalRQXj83ikxuMYZsPiPckoQbg8RDYeR+S7RxWpTJ48yWJ24eAGfB14xzQCCg7lbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7681
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.279600-8.000000
X-TMASE-MatchedRID: w2TFuZOvAtfUL3YCMmnG4t7SWiiWSV/1bkEYJ8otHacNcckEPxfz2O7H
        s99bUUHU7Wce07pz6LDSqM2u0XbPLmJsmEdw6YDuoxWB033D5MI7pfSjRsD2Oqj5v7I4/SgYDFU
        +SD6gXjGDJlHDf5fBO5GTpe1iiCJq0u+wqOGzSV18GfB9SHbqW2Z85c5StTiXUEhWy9W70AHCtt
        cwYNipX/UrOTjR0Rj1gnf2PBsCGqMKviqBSczjb1ikqADfxo96G0NLUmuoAW4=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.279600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 3A5EDD4FAA44D262AB29E7C34E6B8E3ECEB304AEE198DD43907A96275B71D4202000:8
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDIzLTEwLTAyIGF0IDEzOjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFBsZWFzZSBjb25zaWRlciBjaGFuZ2luZyAiZXJyID8iIGludG8gImVyciA8IDAgPyIgdG8g
bWFrZSBpdCBtb3JlDQo+IGNsZWFyDQo+IHRoYXQgbmVnYXRpdmUgcmV0dXJuIHZhbHVlcyByZXBy
ZXNlbnQgYW4gZXJyb3IuIEFkZGl0aW9uYWxseSwgcGxlYXNlDQo+IGNvbnNpZGVyIGFkZGluZyB0
aGUgZm9sbG93aW5nOg0KPiANCj4gRml4ZXM6IDQ2OTNmYWQ3ZDZkNCAoInNjc2k6IHVmczogY29y
ZTogTG9nIGVycm9yIGhhbmRsZXIgYWN0aXZpdHkiKQ0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFy
dC4NCg0KSGkgQmFydCwNCg0KVGhhbmtzIGZvciByZXZpZXcgYW5kIGdvb2Qgc3VnZ2VzdGlvbi4g
d2lsbCB1cGRhdGUgbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg==
