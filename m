Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AD3EB64DC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jul 2023 07:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjGCHZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Jul 2023 03:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjGCHZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jul 2023 03:25:04 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4189E67;
        Mon,  3 Jul 2023 00:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1688369093; x=1719905093;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=QniRhKxgwpt6ordOrRkabT6MfbGMbWsAAZzrcsVSXUtDXV/aOaVzJT6Q
   qf8tagbwPzG1rXdmWjl/VT1YSdXE4aasDTWYEuYcC3jiSqorpFFLcj4iw
   ulffADw5r0YlzNUngNWUFShxqlu+pX87UUf6Cdmdi50zduO4za9XSIWTw
   29VOeqM69KTMy9zx8cYvWjC1nem0awrQhwgHbaWyEdNyV+zfkfsLXKqvd
   pHRyXSOLWjL/MN0hLTsuBeMJDNyzyNE31AZoGj8CyGvi0lFOnN6Vz1Ljb
   jId+fh1n9va1oLLIZwF4RysWAYRMZ8zALxTTZ2SZXm7TE8/vJ6F6fx+YV
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,177,1684771200"; 
   d="scan'208";a="241745375"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2023 15:24:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEvPTNEvxmKB5n5mYZP5DD13K7l3V8+v74OiO+hFgqSSiv/TTtyXI6UxQKdC6h11vyPy/1NoJBPiu47GqJAdKoqNAvnHNNNN5X9lz0JRkdkICSvfD/yoIIAMZ9Kzva8dd8OJwL8HBKhINtBSzhFBeXM0iIC0m2PuXGKH+/YYBlLJMedjZaFzZmVYpYE/XXmxIk3T2ykXdrpTaZVzc2OJ03Xkpq1GY8LttHxOSa5fzPUnpHLBqdxuc5HhRkM0v616ZbnbCPhTHQy52I1oLnlYy14JeBLMG+zBvhnrA/f1dJUc2rVEJOO6/pfn/72/c9SOy0JtUHwpZGkzMAqy0dOjvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=DGy7bGzeSngkdQLPq/6voiCsgb15yEEdwpGNi1RJRK0JA40ZAJb641OvLhcSwNkUvm6E4G+SNVSV1ZlGw5BIP5Ny5dB0Oq9YZQZDK77/MbjvjieOzg1CrfuElo4J6mK6iIi8mHtXMJkWFt1UaKDOit2cE3/Wg8vVw4wVqCQGUqPEInKEkx38Pk8I4lTwAH4/xuvSRLDKQVDEy6XzOPqDD0++08UGvuxLkNoNPXPowryNrC/5aQctzwgcp5zVmM++eJNzfedKFXrLHlAocgsx82R8qECNBWadTNX4tbsNmKiku2w966ZTBnOe2JGYupuVm1pqY+4cooH9wRQnjWCUZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=UPmBDqQzYGcHRsf7VHoNU2ft4ek1kT6XxE53SGFcOgDFhB5pfhlfcWN5yuA2LVtH/lLUA5S/xJcM2WPUPz9YjLgapM3TeS6Y+VA3xiXhySENavniT+m/x3r9r4Nn5S4tmPeGkVlVEfFf+eQjU9IZ3CaNeIOozFWR1iWRrkAAYCI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH0PR04MB8065.namprd04.prod.outlook.com (2603:10b6:610:f5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Mon, 3 Jul
 2023 07:24:50 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%6]) with mapi id 15.20.6544.024; Mon, 3 Jul 2023
 07:24:50 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 4/5] block: virtio_blk: Set zone limits before
 revalidating zones
Thread-Topic: [PATCH v3 4/5] block: virtio_blk: Set zone limits before
 revalidating zones
Thread-Index: AQHZrVjcnzOJLUxj50yqPhBPhh8dI6+npDSA
Date:   Mon, 3 Jul 2023 07:24:49 +0000
Message-ID: <5dee385d-f5a4-4b59-f661-6f41a5d15e2a@wdc.com>
References: <20230703024812.76778-1-dlemoal@kernel.org>
 <20230703024812.76778-5-dlemoal@kernel.org>
In-Reply-To: <20230703024812.76778-5-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH0PR04MB8065:EE_
x-ms-office365-filtering-correlation-id: e1e648d5-4476-4605-a587-08db7b96964f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8MzibHQDTSqKCMrB+3wD6Q0s7twRc3HtFDjv8JKhEu/CFOCqetNg9mneWmHGua2QCItlsncHWgssNypQ/ck/InHnYpjMVotyFDFZ1tIYNqi08A7/Y8xwkBAlyUb8OKdVAWl4p9tlTvfm++64UohFnApnRjj2wWMptJAaxnTSCdhTEmG0UoegkbnxhqBWvDUq/LTZXIuuajY+sVhdWkrdHNwPfaq7WIK9x7Gc5sQzhecfwZcCyZEjXLcP8WJU1xXVPMnZMfOV370tWCqacruf7CxnJGrDyhApfZeatE++gHwG0LxX5+qed4mGyvL7sosKw5p01+25DwLt8zK9Hu1N3zZ7N0TIjOMWRUeuDVJtCed/cViet+jP09Rdlgz3ndU501y3LxN4sUilgKV5OclEL4dBYkr6tr8spMzAO1z7tcpNtXKVNOQ2liyrtw+L7Fo1WZkTbTsq9xzTG9aO+BbgpBuz6UEWsfBxp//NSxugviptv6RPdIV1s2ugh1PlBahVtTsGE8I5CLBurZcMU364HGOO7R+CdFAosk15MBLNBqdudkSj1pFgPnEpI40RswCIYPSjStnfQ6v1hSwNTVZiakMII30X02dXOPmQ95Dg+qU4kzbtM96aDDSFtGFNVnGwB2DVV0ls1Ir4S4UZ8J69KPCvls7bsCnG7k7mzg1m5hEkXjcRY8YO7FomT7FXsQag
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(38070700005)(19618925003)(2906002)(41300700001)(5660300002)(8676002)(8936002)(558084003)(36756003)(31696002)(86362001)(4270600006)(186003)(2616005)(31686004)(82960400001)(478600001)(6512007)(6506007)(71200400001)(6486002)(76116006)(91956017)(122000001)(316002)(66476007)(64756008)(66446008)(66556008)(66946007)(38100700002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L09oT3RMaW9Idkt2UndReTJyZmlKSmNDQzdLR3l1dTc0SmtScWRJYmlBV3Ez?=
 =?utf-8?B?SEgrOURVK09DZUtCc0tEbnlJM0NEbDBjeUZqeVNvdU9ZMFVRTDgzbXJTM0c0?=
 =?utf-8?B?TDBzbXpzQnduVGJHWnVEUTNleDZTbGpYWUNPbWlXYmJLNUZRVDlUTU9iU2dl?=
 =?utf-8?B?U3M1S2dxK3h1bWxlVXkzZGNGWHlSVllIbnZZbG41QjZRUjFUT0hOWnQ0Tlo3?=
 =?utf-8?B?blQ3dlFUeGRmQVNKRk1tSTF2WHc5KzR5R2tpTHFla1U1ZytPMnF2OGU3c1BM?=
 =?utf-8?B?WHhzN0NmMWZHUG5kUldTSjMwRWFPaDdqZTVJRnppTFhKU3hqSS9vWGlVS1Vu?=
 =?utf-8?B?LzRLZXNHdWNSYWF4eDFScTgyaDRpc0tFVDRlTTJQdjFMOXRMSFRITGtlS2dX?=
 =?utf-8?B?THJQYWRyV3lPWWxuS1paMFloNmMvaUNYdnh0V3NtYVQyTmFCOTkrRlFrQXB2?=
 =?utf-8?B?dFJ4ODFtQWZHcFRWY3NGRDVHSU0rWnBzL2huRFVxanRsZDZlejQ5TWx4NTg0?=
 =?utf-8?B?ZWd4OVplaEZ6STFuclY1ZG5WZDRWZDU3TmtGK3Nra1NyaXNrMVUvSmE4UkNn?=
 =?utf-8?B?ei9QSVBiV1hRaHFSb1NnT0pNcWhpanNINkM5aUk2cmlRRUNLZll6RlpMSTJG?=
 =?utf-8?B?T3dIMlpHUjB4d2sra1BLVFZmd1lxWGpqQ3ZYR3dSM3ZxdUJreVllZFdXRmhx?=
 =?utf-8?B?dnBhZHJjTGRDSGxWZjFzWmJWQ1pmcndGQk1xWERDSUZxczM4Y2ZDbzNtTTlN?=
 =?utf-8?B?UXc1bTE5bW1HNFErU0t3TTc5Wlp3Ly9ZRkhONW1iOGpZaGNjcjhWQmVoRzBa?=
 =?utf-8?B?RGZTYUFSbDd5VCsxc1BlWGZ2c1owSEpUajR6bC9DckZDbTNMdXVkcSttOEM2?=
 =?utf-8?B?akMwZzkxNUw2WHZFcVpwRzdMZXhZdFBhdHZBOXR0c0hKaHhxNVFNRlo5UTlj?=
 =?utf-8?B?ZmhyVCtHVXcxRGpMSlVLVUNXSldyWFpiZ1VORkQvMm5Cdk1nOUtFUWVobjkx?=
 =?utf-8?B?NjF2RW5lUjBXUWVTUE1GbHg1SHBWMTZPTStCeE9ZRlhRa0xmQUZCUWpxeWlu?=
 =?utf-8?B?eTBudFFHNThYc2ExcEcvc3ZSZzRTQWwwYitJKzB0TVNXdmlzMWpFaW0wVjhO?=
 =?utf-8?B?d1JBR2ZUOExRTWIxdXM2WFFWR0lmU2tGWUN2djNZMVV3TkpJdm50M0Y5N05k?=
 =?utf-8?B?MmxUdzQwTXJPeWQ2bU5ISGlDMFhtV1NUaWJQbVhZWW9oWkpFYVZEa0hrbnM5?=
 =?utf-8?B?SVdDMkRXbjRiZ0lrbi9Fbjd0TUpzUFNYUUdYQ3ZRbGVQRmdIa0o0eW16UlVJ?=
 =?utf-8?B?TTRZaEcrREJtb096bmlJNklGRFhPWlhoczVNTGhUdlE2UVdFVUhwTmpPWXVx?=
 =?utf-8?B?SWVkRzJZNVB0SlNLaXMxb3pSOUVXRDlGR1NXNElCNFUrRzlMOTkrV2srVGc3?=
 =?utf-8?B?VXZPdDVNM2I2bWRvOCtuYmRwNThFaURITVBuVGtsZEp3akdIQy9lOWQydGpC?=
 =?utf-8?B?YUIwaEEyeXVDT3ZGaTlUL2VPK3VmUWxxbzI3d3pWSDZONFYzZXdTZGppaTM2?=
 =?utf-8?B?NHZSc2pEN2JsQ0NpUHJjSWRjVXlSVUlrWHhPWEJNY1Vtc3g3TG9WWGhMdXo5?=
 =?utf-8?B?VkJwRmk0QlNPMnlvZUtid05heWF1dktLclFldnlSNjhZRGNubDhFNUFzd2Q4?=
 =?utf-8?B?d1ozTVBPdFR6WHQxTHhkQ1NUSGJzQ1VXKzFON3NDcHcza2hkcVdramsxVDdk?=
 =?utf-8?B?OXRKU05yMDM0SkpsL09IUFc5USs4cjhEUWM0Z1U5UGdvUGI2YWtnWGh6ZHBr?=
 =?utf-8?B?dGM3QzJDS2dOcjZ2QjA1emxOODRkMlNvMEhSMVNiZUlKTFpvQ29oTDF0N3Y3?=
 =?utf-8?B?R0l4Q0NBVXZWQndDVDhkQnVuOS9zZGtZUjkvaGJQbXpWLy9weTNIS2RCbTFH?=
 =?utf-8?B?UEpvWTRMYUJ6cytEWVBoeXN5MlBJUEZWZnI2b2RLKzUyUEpodWxTSzBKTDdC?=
 =?utf-8?B?VU96VU1Yc0tES2ExZjV0WUk2U01TTVJQSytSLzd6Ulg4RDlCRFJzWFQ0WEVC?=
 =?utf-8?B?WkRveTV1SGowMlBWMnl4RitCTWlUVloxVWNsTlZJcVlHK0hURmZpUVR4K0lm?=
 =?utf-8?B?eUdhYkoyT0c4NUJoMTFNWTd6S2tFbFZ5ZlBNRk5YaXRWYkhFa0JGTW10dUdE?=
 =?utf-8?B?aXgzRTVSZmlvVkhkVVRnRnp2ZElBazYwRjBrMHlVVnZpT0MrMmMvRkhCOUJB?=
 =?utf-8?B?NC9XemlVTlEwNm5wZ2JZay8zMGt3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D9290BCFE5068469A9AC8E619CE9639@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Sml1MEV2aCtJbm5aeE9XL3BmS0ZwY3NtdE5sNm4yaXRHcFphVXZXV2tURDNX?=
 =?utf-8?B?YTUxK1hOSEUzQno3Wm12TFV1NXYwZ1QwS3JKMHduUlk4NTZGNm1BOExnQXo2?=
 =?utf-8?B?K0JpZVpNNmJFN1ZJUDU1SzFWKzhCenk5UUxUcnh1SFBSS3NYY0FheEZiQjV5?=
 =?utf-8?B?YkJTOENzbTdTUVk0UDR4eGlyYWdnZEQ0U2NrZTR0Q2tFZ0p2b0crNnJsdHFY?=
 =?utf-8?B?M2ZiazBvVGxOZTRvUXMrbU5IQ1Rrb1IyWWJDdU5MUXR6UXVPc2VBQ0pwK1RI?=
 =?utf-8?B?TlIraWJkWmErZEs2RGlSWnE2ZzJ5VGt2MXFERlM2YndBdGwyaCtra2FRdFJB?=
 =?utf-8?B?czBtYVE1WEcxalJvakRpczNrTnVrSEJpZDZXVHVYU3docVNZakhVajRXMUtz?=
 =?utf-8?B?NHJPYWtmbGE1VjhETXhMWmU3K2hnalVXVWZzakUraDBwMFFZM3dkcGhmZEtp?=
 =?utf-8?B?NUhxVitLWWc3RStYZUwzSHFGQitqSWxMMmpXbzZPeExDNG81S0ZXL1JsNjA1?=
 =?utf-8?B?V240ZzhMVFRyMnhnQ3V1ZlFNWWZmMXBYZU5NRjVpN3pQYkZLU3dkWXpUTEZY?=
 =?utf-8?B?YitVeEdCbllsZFdMckNpejBtMEptTVhpWk5YUm83RXpUWjhpVW1wVmdCSm91?=
 =?utf-8?B?TEtseWhPVFRxaFpzeE5kWlRHMUNqaUJUMUcrSzZ6ZTVKRytzdE16dkJKbDM3?=
 =?utf-8?B?amY2VkgrUi9YSUIybThQV1NtV25XekoxR1ByZXdKSkR1REMzcGRwNzlNSEdt?=
 =?utf-8?B?TCtWTk16QnZvU2pOK0JYemZCL2x4T1hBMkxCSHppcGFRY3k1cWFGdnMzVFRl?=
 =?utf-8?B?NHFnbzgrd2pXTXZ1SGROSXVnRzlxRVZKOXc5djh6MUFoR0g2OTg3K0tBcWlN?=
 =?utf-8?B?ZDU0NnV0bDVlai9NZ1RsUGZhRWMzMEJWeSs1N0c4eTEzQWZpM3JCM1pzSWtu?=
 =?utf-8?B?OWZrSEx1NWhSdGRBSC9kVklLV1VPSnNDeC9EWC90SytkS2ZMUjdKWlcxMUM2?=
 =?utf-8?B?d3hHRStpZXFTamxxT2pUVmNpN3hyL1hyVlFacExiSnh3TnBaR3VWR1VyZmlG?=
 =?utf-8?B?UXVvOG1iK0NkNldaSFExbjBCOGJWQ1JWNm9EbU43T0hrUHAxRVY5cGFPNU9n?=
 =?utf-8?B?cVdReDBobGlHSGJ1U0pyN2Y1MXY1cW9jMjh3RG90MnNCVUd5ZHhjU05lZTBi?=
 =?utf-8?B?R2N6QXNDLzdNWElHdmlLQjlGWHZ0emViOFp2VktZblh2QlBQR1ljdTFyOFdr?=
 =?utf-8?Q?kHoMSS8OnMhEx/f?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e648d5-4476-4605-a587-08db7b96964f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2023 07:24:49.9893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: grzHj4joV55vc5P+eKeQrd+Yi93p4mKPq83L+egjfYGmfs8aKVxfzTjuSeB2gvn6Dn6f44TSjvXvA9zB7Lf7nc8QRCsd5nYPUB/edB7cdtc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR04MB8065
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
