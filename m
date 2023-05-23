Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C54C7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 09:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjEWJWO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 05:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbjEWJWM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 05:22:12 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872B594;
        Tue, 23 May 2023 02:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684833731; x=1716369731;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=abR5nNgnzxoFhzcKjGhiNOQgcINpAHbJGzjYGFtPYpxYkMAFI/vu3WGU
   FvNbcq15oG74SKPC2XfOHiCmAKYy4034AodddHgsOgUpq4b15wpzKfvXh
   BtTo0iV9DZ8V3HejbXDCWTcDe7a95QeQtTiIiU9qECBtLsnRWDVv4u15D
   8GswEVYlkda3efBr3HzvUcoBrvqVjZjIC7kuUbXsXqR5rphXbiFNT1Bo3
   isINPFsqR5r3YQewmK+CvCIiM97ZKE6zj5dQwwuyPizfSvLmA4Up13QZy
   UV3lnDkz3/GODDCWq3WqtSMSGAMjWo4y94zQv9qs7HLxWfZlzJ+jJ9rmW
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="231447724"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 17:22:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUE96hXrxWXm4jiuEwn49Vb02PJFClNcw33cjBKhLoIcgk8Es+qIS3R8wG6g6rvAVBkfe86q+06laFCgvWpAOtacnoiiuifp3jPyhKA5yPs2PAX9Eo9pN52KpNN7RhVFAyWTUhwjhHIaf/5C8I5+8yF55O+X7upZziRbqXqlkT09PeljaMAH/pT6gT8nJ84AsT/dhnS2aX3EzVXKZjvspnqQYgs9C/VFrvakJRB2xb/9onObL0Alq2GHcmqNmtGm3nNuHKXySDP3rfg7NSBqY+59eqp+v4MDOEr7sXeZhcqkuuLD5GmaykUbox1+ZKcrSeMLCy5NIm6Xwa0jjouIew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=LlS7hJSkJ/Gs8yHbcJo1ROkIY6+S2CWC/RONPwefFhMQQZeSNsJWCok1W2T0jjAvMaXyrBXl6o9VIp0xaM17IRB50qRduakcO73mZk+eVWnQ8qExrxCWj+ziuE1gIXkUTJ+QjkXOzw3cIDyVEgqQRYjUaf9shc1P29D6RZH95/JFrfO/L48KOhSURahM5SB/omkAva8X2MqhR3bB10J3WhwgNpVHu50IRv/mjtCFc2BXybJKl6jQWo/HfzZzef5eiPv3Vl0VsWrBoht2eKHqQwOz8vUe+w76Rakbr6CBBK56mYB6j75GY/NJ27DgXV5Jd/EN2soVUeZ72MbeDNccKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=bciL7QALY0lMRFaV9m+hbW+Ft4k28LyrUL5VlDof+GcIvfiYbxXtO3OB5MCwANq3fH++zpT3qykXKFV4XIu7IQCGpsyfQIHYHNvuBaUHe7uhonEJ/dNugQo4XU6/EzlaZwZ0bYDGJj+Hr+Is/1cU4Jzgd1OzXDWBpduuDHK3x+s=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7853.namprd04.prod.outlook.com (2603:10b6:a03:37e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 09:22:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:22:08 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests v2 6/6] block/{001,002,027}: allow to run with
 built-in scsi_debug and sd_mod
Thread-Topic: [PATCH blktests v2 6/6] block/{001,002,027}: allow to run with
 built-in scsi_debug and sd_mod
Thread-Index: AQHZeCbTo8WZCy+zEE6rV8YDpmoKKq9nv8oA
Date:   Tue, 23 May 2023 09:22:08 +0000
Message-ID: <ed4878a4-8316-014a-bca4-311162478bf6@wdc.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
 <20230426100611.2120-1-shinichiro@fastmail.com>
In-Reply-To: <20230426100611.2120-1-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7853:EE_
x-ms-office365-filtering-correlation-id: a00f27b3-c394-4664-76ef-08db5b6f2eda
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pzTLytWSsREki1ir4M8seWJNPItZJoOjTz9Tz4GM7kGi9qlmuVDW2AYeeLAPF6F0fq2YdWz3hiVsOf9cO2jukbH6CpLSOVPymSHjS2nae7aQtNi7kuJIPcZc3OSVHnXVvK9kbvCwhTdzuTEiAERMlajI+qjxdfmOGL6aHXp24UbWGhFZdP1YZr2PgQxTbbuljfMiuWaCrl9hyha99vg/mkjKrFq4f84Xw/zbsUHljLLL2qoQvxvd81CojRABCGWkV2ISdkTbM2cDkyvKmMCXV1zYIzPKkr773TrVCw1yHcatkFu7pTiFLpbXKV9yn+Dsx1Vt2q79N0fn16o/LqP/WaMYrJfGITgzNSujnS3tmRl+N56XNOaTvBsi7gAjplAB9wiWnhZGqlkAcotS/6wVJN4L3CnwYr+TkWAFOrUq5fWeS+KbkYmqSFsu8VEQLKSbmXRntKqANm0tHYiHO7PBDNJyas2FIV4mliHeQV+cAihsc53wqAbJzTHIs97GW2QXUWMoxh5/9q+S9d71LK+pllfMzGCbAYKuIuVtYMxfS1itvAXIlZgMvTKpbIj0jRdXLZFcIIrrWORCKwCwznFsPH6tJWdNKba1e7dsCa3en0qNpM1sQtAUI1Nmek4q7fbbFKJ4+rVMMLmOp0FopxbI8f5duJdR1N0HTtLoJUNqqZZknhZIxRfrzYfO9mGzkHXq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199021)(8936002)(110136005)(54906003)(38100700002)(38070700005)(31686004)(122000001)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(478600001)(86362001)(31696002)(91956017)(4326008)(316002)(558084003)(71200400001)(82960400001)(6486002)(41300700001)(2616005)(19618925003)(36756003)(186003)(2906002)(4270600006)(6512007)(6506007)(5660300002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzZocTV5bW1FVGVSSEFSVm9KdDlIeU1HeFZsWVBTa1g5UFM3dEJEdFpqMU50?=
 =?utf-8?B?Mm82aHJnNm9oYlNZTHlRSWM1T3VSRXVGWTBrQ0NUeElJSFdUaEo2eCtnVkp5?=
 =?utf-8?B?Vzk3ejR1Rm1nWVhnNHBRbjM4Q3NmTm9FMndVL3FydXgrSHhVNGNYSFJPUlVE?=
 =?utf-8?B?WVQ4N0NrOXJzT2V6NzhqdXlGRU9PelNTNlJlZDdIdDFQQVhYL0JWNTlLdUdI?=
 =?utf-8?B?bEJEcHpvUHZuT2p2Z01VNzNhWm5LK3ZRTzJvYVUyVGhZRHJJbW4rT2JUTjVG?=
 =?utf-8?B?QVJVbXJnTGlJVTUxUm5NMDBkcEFOVjhJa0tGWkdIb1pIUEFySE43ZzVobG1J?=
 =?utf-8?B?M1h2N3ZWTUZrU0xrZ1ZsbHV1Q0hNU2pZbUovVzhIS2RuMmdhUlh6bXNTLzhI?=
 =?utf-8?B?RDl0R0YveWkzYlI0K2FVUDVBa1VLblV1OVMwNnlMZ0dybjBmN2NKazNCT1hQ?=
 =?utf-8?B?Mkt0MGltcGhlbFZIeHVuY255WDhSUUY0UU9RakNMZEd2SWJrNEZZL29vSDIw?=
 =?utf-8?B?THVQRDE3OHlWbkFGci9yeFpONUNMSG1UOHJ0QzYvYWVvNHdYbWwramlWVSs4?=
 =?utf-8?B?S0ZtTDBmd3FMMXFDdVpIV3VIRjJ2TGtpYmlPQ0xUUXZuK2p3ZisyR3dpQzBQ?=
 =?utf-8?B?SE9CN3B0QzQrWDI3c09QaytWS0ltZHcxZzJYd0ZQTldGNy9IOHRGZnV3cS9F?=
 =?utf-8?B?MlhhQUU3aHhkZDZCOUFSMllVZmg0bkFXYjFaTlV5dHNNOGRUQUNjc2p3REZN?=
 =?utf-8?B?YXVCSDN2RXZtMWJBemNGMmdQN09oTkdIbmU5b3VXL1hlR2hIUnpjY3Z5aytx?=
 =?utf-8?B?ZWxqZkFlYjVUMDRid29jbHVXTVhXa0cyVnVaS1VvQlJxN0FBVlQ3cit5S2ww?=
 =?utf-8?B?a3ZnaDhoK2didlE5WVJOT3ZmUHRCMGd0b0NHaFBiRlNTeG1PbkVmUFhvQ0w3?=
 =?utf-8?B?dmNEL3ZiOVdub2ErbS9VaFZpMkE5YTNEdE1DK2V1ejVaQUlDVlVrOWpnYktH?=
 =?utf-8?B?RE1oL09GVWZxS292WlIrVWtzNTFLUXhQWit0anJRVlVMUWQyRzBPRTJxdksx?=
 =?utf-8?B?SjVLWGozYUlyd0Y4eDd6bHhhZktndFBHbmx4dlFld3pIckp6cWFzTFpuSDN1?=
 =?utf-8?B?OUdFRFk0bDBhS25zR0d5ditqcEQzam9nYTV4NlhwcjZyRkYrRE01TVZvZWNr?=
 =?utf-8?B?dlc2eDI4dXB3dmxFQUt6ckxkVnVNOVVZN3BoWCt5RmF6WEdtRHlHUzJwWUlY?=
 =?utf-8?B?VXJwT2d2M1pSQ2xkVGt4WGUyNUUyVXJPaFZzWnNJTVpMNVFncFhNdlc1akNw?=
 =?utf-8?B?aUsvclpyRTFaVTZxc04xckg5QUphOWlEeTVHcU5IZkVXV3JtZ2JjMVN4dkgr?=
 =?utf-8?B?cGxQRkZqSzNXaDVsT1pLWThMWGpZRERpUzVkZkgzWFQ2TjhXUmlLRnQ4MHov?=
 =?utf-8?B?SSsyZlBEaWU0ZmhxRmRQZjN2Mlp1SDU4NTNmazBhWmRYWElSNEdWUkNPM2NX?=
 =?utf-8?B?WWZRUHB4MFhCRjJjcmZlZDB3WEVrYzlFbkEvQXh5WmQrZGJFVXhqRDZOS0xP?=
 =?utf-8?B?TERGTUFHaFVWQ09RcjNHV1A0S1pBcmdqckJxZ01MZnovRzJQRnRDUzBqeEJh?=
 =?utf-8?B?R2NSbEZoNTdmTjhWTWtMRjcwTHBRcUlrWTNpMzdIamprWVpDQVNZYUN5d1Zl?=
 =?utf-8?B?Rk9TMHhidkgrQXRZREZSakp4Y2l3QzhjMEYwdUtuVEhSUldYSGJ4Y0hqSVpy?=
 =?utf-8?B?UjgvOFFmeHI3QnpzZC9VcUgwL01PdnhRZCtnMTFWNGhiK2g3czJ4SVcvOUNt?=
 =?utf-8?B?MXVyazI0Ny9PcHc5QU12TkdGUVk1aVh5ZytybVJaTEdlenZLSk1KdDZkTW5N?=
 =?utf-8?B?eDdpYUQvYjNqNlIxSVptZkNwR1B6eG10VHRsVE83RzQvampKTk90N21DYmVv?=
 =?utf-8?B?TDJ6LzBZVExPeFJ6NVlUZm5SMVJHMlEwa0k5eG5JNVJTL1J2L2g4dXpaZEti?=
 =?utf-8?B?ZkRJVjNPOVRxM3pZRmpnSWwwdWZNNCsveWlmekNQeVZtYzFTZW1qTVdkYlZ1?=
 =?utf-8?B?ZUlOUjZYOUFYNXBYYWhPWEhmVGZtV2JNcHVLRmVta1ZRMmsvZjhYZzBPYm9J?=
 =?utf-8?B?N1BUenptZ0hDTXRjYTVEcHBzb3ZMNFAzODhSYWdPcUZFZmdKajZWV3BHMmxS?=
 =?utf-8?B?bytHZmptTVNPUDcrWGlLTWNzamhEZ3NDdmtjZ2xyZ1RkQjJQRWxQZnFlM2ZV?=
 =?utf-8?B?TkhweXM1ZzBhN0dWRlRzUHEzZUVnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C65ABA83F82B0E4382F9F8974BCDBC88@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mTJBZseSsmv53R2zBRZ+l+7/fYZ1Ixu53oiQ+8tHoYzf3SQ5hJ8Tqkr67sPdA/DRb56z4iS43JUBg2hOIS3v4NvwLYRKmLCEV+XNvpkOGJVb25CllpGeQBcKGFcLswRQqvmPNmnX6oEfvZs/jTRoyiiKsaDuiZTE8NlKnywG2piHYvNNHNfG6eX3TfybxfhuKpuf/oI1HirXmL50taC+iLwEG4IVHymFulnYp5pNcFeh4iD3Wt6hua93lczRXxsqdb1dDlwq7Bv847PY72IkctJxVI8t7tVC/imJNfra2uL4mdOmEKAWH8aQwn4GoUjOs1+LIeYRBy4sldqPIpErIYlsU4UBXx7bVxn1q4L1ku30VxQH+T3lfbaLuc8bP4mtlCXp6vmwo8GRpWKn8lz7ipjZK0Rnk42Xgs/bJyDw+dm56mqn6KTc0Sk+R8gRfq7PAnvytbBnE+D1SM6F2nGPsOBTqsozJaRuleBnT/y4RdLbaDXzUtuKjpDq8gHPrM5kWBdZ9U/i81TTW9ZI8HSkprELmMO8BTZ8XGmdQLbsDAyEUMgXsyFI3oxcbdSjxdpPNrjclEaLq/Vve8meok288LmsCCeVxa9SNJlV/DiA3GXsE/1uOh+HQwc5daLR1LhA7RIZaKqQ6a0s7W/8pjlyr7voRT5gC6C/L/Jpiyu7LUurvw0Aqz2qQMpLOMoqlTpiDDKauoZKcYJ3RHfPK1HvmdAFjD4Q1a749YF+iGpPRSDiS+k5RVLAaWHuF9FoLe78A+up9aOPH+eHzezz9X+7C6HtnaIqQgf2ZRoRPsDeU1lwq0XgBhRWi/EpZ81wX06UN3+OE28h7AR2cons1pONww==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a00f27b3-c394-4664-76ef-08db5b6f2eda
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:22:08.8494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ZDvuMl7ZhFktfVBB39HacYHvHfOu0CUGVLE7zB919ISsbEWFS4lF54aMQoNEfY1fd6Gw+aFnk0uQxclIxBsCrx++iCPjtABrhivJWJGst0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
