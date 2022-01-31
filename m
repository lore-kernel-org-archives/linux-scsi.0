Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D159EC4167E
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359118AbiAaLfu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:35:50 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42264 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377558AbiAaLdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:33:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628799; x=1675164799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=nvP2kZWieKObIiuqNG+vDoypLPCIv7RSnqfSEbBS5pprXumn+59APJQB
   mdqH5Bgcqk+x74heahkFcvr1XeHOaLSTbDWamk1iwSBB9tXodBojnLZwP
   uFDW0/dD97P4nGa0koMgCI+lLKauUA3lCtDlOhIba2YBr/PGNSVnrHBUn
   8dfz0jCw6eZjSJ8DWEnUASMiR4bco1MjftS3ytVpwlGDQnej2JQ9TBpbO
   KqENh5AVZbMdLfF1ksTt7ixgnatbnrfhvy94idWayPxhwH7ba/J2j5KY9
   cb1UXucC8ZoWxy5NP27/8x+tVrEH4X2lBLL2blpDgRWK7K2xNardGBv5x
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="196594431"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:33:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTyPa9bFrNLpAm9G9AjqIL11DvIFENUT85t7i5gnXMol6IkjHUXJnHB/NTuLEN196GcwZujS1pkivh2Hfx+VYnQOfbEC2DYIGAKBp9a/sSb1LI8keMcO/mVT9oo9IfEShtGWUkcWqrqvYrnupqcy/XMY79xhoR06W2/zAs4+Hlhi1wBmuF8OvwwVcv3gHn/8wA3BHKNMEvgffVTT2/5g2XW/bmGyFh6uxzWPwE6h1s0QzsAJgPgoC6L8/p/SZDdQDbYL6QIiKbmyLBJK0StghfqnMBwwExQaDrYkyKy6RuctADHBRL9zH0xkh/XwzJDNJfuszIOKqDWEr6jThTA9kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=lg+KhPodxs77VtrAbSXwRlRknUKOtXjJ0O9GvYFlIiIBYQsnYAom6FGpAiiAlZY0seT3MCpXs6alWOFOUdn4f/a7JZP2ITxCMnNPQt57Ft5QWQoEdrsHBQLkQw7AqgsP5qITW2l1meOT7lidGBk6OPG7QDtKcJeKNKweJY97j8fO/1iOtKliLvMYsQiYR6S26fyTtdT+vPOl3/Ry6htqrMa7IU9sHlRgOnuaskJWP7NvJtCKCg27FndRNXt4zXftShdybRIbXJ1xiF8X26eu6+T1w6bkYKDYGWjtQuAZj6tzIJmnN3XbKAoVlmUhtj+684FRvfj+U8VF/+f03Sqd1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=DbHSg4RCHemJkp3qzHxlblFafHWGV1Ybh0Hrq2WnDHMLs42hhhCnIBZ/PrYy9OA0uumTKouedUFXzwU1pr749z1RBzP9HLLBNc24mEsZTysx/hB4dKj/LlQ37oMH7MH4ew43rZF6nQmEATIGGkCA8YYw2q7Vzssy/5X6k8o8NWo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CY4PR04MB0214.namprd04.prod.outlook.com (2603:10b6:903:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Mon, 31 Jan
 2022 11:33:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:33:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "yuyufen@huawei.com" <yuyufen@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "john.garry@huawei.com" <john.garry@huawei.com>
Subject: Re: [PATCH 30/44] mvsas: Fix a set-but-not-used warning
Thread-Topic: [PATCH 30/44] mvsas: Fix a set-but-not-used warning
Thread-Index: AQHYFJWOVl7+pVLXU0atjvac7dfxh6x9A4EA
Date:   Mon, 31 Jan 2022 11:33:17 +0000
Message-ID: <5a92cdc3db4f079b6c5ef3408d2ce460d56d0cb8.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-31-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-31-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a6ecde8-a65f-4d3d-477c-08d9e4ad79b1
x-ms-traffictypediagnostic: CY4PR04MB0214:EE_
x-microsoft-antispam-prvs: <CY4PR04MB02149B8F83C2D15AFBE8138A9B259@CY4PR04MB0214.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDS/ZT3jHKRo5UqRo0tHUX2HeX86F00sx3L1/0K3paBooVc6N7Uv73xr3DSoy88BZhG8kBSFDJcO+b0eAzdKkhlf5Rk9Zrp7lDSWPIZ3D1Wr/zJqy0IeXDuD/xyC+sIqwbf+04SDoZ0sV3jWHER0ZAPBoWcEx1KvbieMiL1v6zLiI9FC8JcsOCLxFtcLut7vx3k0iG/+5fghNthHbAgt8oE5jDuSmeX/PMkQ4SzMCZkGvFmzgff5jNvF7yfSG8qgFrFSMB85s+6nJAP0PGoKz7jFn6NPjPfLu899BDc66l7Q53XxYCv2KlRIHOFRQk/xbHtSbNmaM+fyHjpn+GOic7pSiGW64/Xe5EPPyP8qCEhRb8iqMXkaPxUzlnxArKSBt8vCSTbSyamuvQ+pZuv2ksWa8y+VZ8G3TeYns30A+xBJtd8K1U+0jbsLg2pnGbDOUjJNjcDLfTuiv/ho0QMeIYBhC7IInx22y0F613tCQdCFwSo/We0ceTH+ZxbDBMYr4PNZSGeJyge+7OdbH1oQWAVTWHxebK9EehjsafEl4Ifta4diVNT6ZZ8/RP6sXHcdETNnsGO28GZl6RU20cf90acqtQOIf2ZKmDFnF1HWaSgYEJnpZwXeuFQVErJca/NK56nF8dCf9XrYYpvL50e5lTfJWXkZJKoVHHB1UouVNVnZZx+Vwn8MNWq08lSpQDI1WoGgsptQI+ys0fAfehlpfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6486002)(5660300002)(4326008)(8936002)(8676002)(71200400001)(508600001)(2616005)(26005)(558084003)(186003)(2906002)(36756003)(122000001)(6506007)(6512007)(82960400001)(38100700002)(64756008)(66446008)(38070700005)(19618925003)(4270600006)(110136005)(54906003)(66946007)(91956017)(76116006)(66556008)(66476007)(316002)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGZrQVFkSDZuZUkxL2daR1VGdUlqS0V6aHc4Uzg5UFVOZGZCbzlOK05rU1pZ?=
 =?utf-8?B?bEt3Y3hHdC9RRE5NYnpWTDFVQlJGd1RCM01iaG5OWWp1c0pNZXJZMGFxcTgy?=
 =?utf-8?B?ZXpJamxNZ2JLelNRQlRXUFVLODI4b256Z2xGOUxpUTB1Z2Uyd3RtU2pMQkk2?=
 =?utf-8?B?L2ZjUk83Yk1Oa2ZPdVVRMFNtbUZQN2pkYUFJSFI5ZGpCWmVPeitIc1BXZ1kx?=
 =?utf-8?B?V0R6VktuRzBqdUtscU5Kb3VjTXdGK0lmNzFHN2FOS0tSZEVXTTFYaWFmRysw?=
 =?utf-8?B?WW1vZjFSRDBhWVltcHhWTkZJSEhpN2FGaUErVDg4dkQ0UWJCejFhQnArdVhS?=
 =?utf-8?B?VzVLNVJzNUxkdXpoS3NTZWs4aU5NRENySnorTEdrOFRORU8rNlhsV0YxbEh6?=
 =?utf-8?B?Tk5MTFIxVnVYNGVUb0RMMGxwRFJpL3VSbDBpdGxYcW9tMzRPV1lTL0dzOGlP?=
 =?utf-8?B?WjNZcGRZdVBpRWMwckh0eVZUYU10cUFrc0xrYVNpWGh0V29iOXlNcmxqcmNS?=
 =?utf-8?B?R0F0UldXd3ZZK1ZmRmJNNWgrQ3V6SDFCM3oveXZWQ1BMM2NSTi9hOWl0dHE4?=
 =?utf-8?B?dXNYRGhWaTRkRHBoc3crNFE1Q3JBRTFQR2JGTmFUYkdvWk82V09pY2dCenl2?=
 =?utf-8?B?MTMvSFdXVXQzNmd6MGFOV2Nxb3Z0c2tlY01WOG9jYjJLV1FCUFpvU2dkOG0y?=
 =?utf-8?B?MWV0T1NIRktRbnNuVkM5cXFhU2k3dXg1anRuSnJxTllVUDB6K1ljNkQyYnNY?=
 =?utf-8?B?MlA1UnhHcjRpNXFBQ3g0b2wwRFpWY3B3N0ZONytsQVU2U1QzYS9aL1ZrT2ph?=
 =?utf-8?B?N3FwNndDMlc1WUh4OXhOTFpBMEhIelVWa2ZpNS9rcGlvWExkYUJ5MlBpV1Az?=
 =?utf-8?B?RGQySlc5NFVsbmFGMmJPQmZDd0plU21RYjZPNHlnWTRlNkNHeXBMSTRYbFFW?=
 =?utf-8?B?WGRyU0F6NS9oRTlIU1laWE5zM1o0UEdZNDd0bmRuWEk3eFpxSTl3dzJrcmV6?=
 =?utf-8?B?RUd6Wmh2ajFIK25qaFJEc0NMVlJrNHhkV2lwdkRVZDh3QmxVZkNIM0FPVGkz?=
 =?utf-8?B?dDNrTGRYUUhLRHNZSTVTdlhNZkdsMjhMS2VnZ2NTdnd6c0VxYU9uaXdQTWtr?=
 =?utf-8?B?aThYSFFzSlVJTHIzcGZ3YXMwRFVmWi9Pai8ya2E5djc5cGwyTFgzRVlBV2Ny?=
 =?utf-8?B?Ym00ODR1TVYrRkJYbUJKR3VSZTBFdE5uUE5iaWFqdE9RTzBWRS9jdy9oSWZi?=
 =?utf-8?B?TWdSc3VJZ3FjVHVqYWZzWCtVOTJBVVEzNDVxdjNNcC9JK3VxQlkzVGRlMXA3?=
 =?utf-8?B?bU51alF0UTZHOUVQWWV3RDFld3dhV243RDJvT1FwZ3JMamUyS1h5UmJUNzFq?=
 =?utf-8?B?amErKzdrRXppblJERFQvSFJGQjI1UzF6SVdjcCtNWlV2dEN5OW9SYlZHTmpy?=
 =?utf-8?B?Q1FxaGRoUWE5V1g2diswcURUL1Qxd0o1MFkrV0NTOEFBSEJoZGtVeElYOUhv?=
 =?utf-8?B?cG5WTWw2UnJBYWZsRlNiMHhWckxHZHI3UXBLaU54aUtzQitjUFpCUFd1MUt0?=
 =?utf-8?B?TTVrYWl3ZjFSSnRZWUExOXAxazF6ZUptYkduNkQ2SWd4T3p6RWdEL0dWUjdv?=
 =?utf-8?B?b3ZmOXQzWk5ta3pDYjlPdlk1NWp2ZkFzMG9wWlNMMWprMUtGRjNvelZyOHp6?=
 =?utf-8?B?UkZXK0ZkSzljT3dQOVJNZkNWRmJCS3lLa0FRd3BXR2FkOERFM1F1Ri85bk1L?=
 =?utf-8?B?elROL010UTZPdlJxYU9za1RXZjVINWNVeW9VZkVVMVBCbGpyMUdkUXhOSkta?=
 =?utf-8?B?d1hmWHZjeWtsR2p5TTkrc0NEc01WeEF6cUMxYTEwYmozMERhQUk3VWpDR0RR?=
 =?utf-8?B?aFRQZk9TLzIxbDRCZU5XNFlwdzhWUGxIaFViRUV5d3VGUjBML0NldFZJRkxt?=
 =?utf-8?B?TzNVanlOSUZNNVFGOUdMTzQ2QzVQeUlUSFFYYW1JK0FWdkVwb0R4RWF5Z1k2?=
 =?utf-8?B?Y21NU1dTekNMTEYzOXJFdE95SkY2WXpWditCMnc4SWNmK1hId0ZDcFJRenZ3?=
 =?utf-8?B?R0dUaHhxNEF6U285c0s0ZG5ZUlgzTmVENlh5Y3ljeHlHUVA5L1g2ekcwaGF6?=
 =?utf-8?B?T3F6REVyQ2hocVEydlFnZWNkY0I0c0hpV0drZTRUdDhrUUkxcDJCR0FJbVhP?=
 =?utf-8?B?MGtMVEM3Zy9wR3M2NEpFb0VKTDRwOWNWbkVuc1RSSE1Oc2NTYy9PTUdhbXRX?=
 =?utf-8?Q?EJV/5/+wox0dj0Qtb4WA9MnQBA00SahE542TeQ1E/4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE016E16268BAF4595B29D4E9CE40622@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6ecde8-a65f-4d3d-477c-08d9e4ad79b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:33:17.0230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6DjWqD6C5Vto1c0EMmTbs3Ljv4fubr/005U6YtPpsSdMAfypo+3zEyjlZH4R/iEQEzZezT96/s5W+0HIqcqseb1NgWulYNSr52jHTnKCwpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0214
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
