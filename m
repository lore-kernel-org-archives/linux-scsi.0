Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A23C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 07:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiK3H1O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 02:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbiK3H1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 02:27:12 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954905B85E
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2022 23:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669793231; x=1701329231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SUvO6ZzqK/D55Ar0N9FSYQt6rOfffMXAxKwEFz/GR3I=;
  b=jWBorJUiimbwJcXGy5zB6k5ZucijmN4cZ4Vt3uHSJo8k2etQuYf1DIJS
   1+bB1BOsjgDGJAdrkyvak+q4/KJeKarerid5uLyyOagqrAN9lkV7qTFLW
   MCPobXOM7DuhyuLb9MO+R8Y0zkb6xyqqgbohDJP30pnQezL0i+EDSGDnp
   UAJBdd4D+F4DqeElBRew1iMl9/ShUHb88lypA0yiJ/tFdbSM3g68BBgja
   nQZzUWCJNf2+LVto0Z6rsHnPLfQZVUmphgplc73V7+7XeJRxGjII/tY4x
   znZHQSp/dkWNBOXr4xJHOo8kuTzx/rTQ/AP7Xk9CIlQUwQyY9ommaVLuv
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,205,1665417600"; 
   d="scan'208";a="217527232"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 15:27:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcCq6s2Z/zwfbVEaR2BvJcvg7j4nTgBmUfqwEhoMS6CTodd9ob3GHoSMk58MSE6Ch3evSxVlF/pxhAQiq7sYkWeWa8TFbPIbGZh3EKncDTqa6SAdW1cgvRKROeBphOv3og4OoLUIr13ARCG44E2fpVsSfzHlnYCzTDiwVzAi0elZWzDabpifEylOqkJmV9rWZFb7vbJSmekJhrXW4+biVMdt9Mtg8USS3LfBi35ts9LK8nDZRXrHpcgngaFXi81B7IsXxTxbBA6Culwi6Ibz/vukEnQ5Agmoo7h9oS0X5TOtS2WohnlhdrqvGMf1jzSvMRX/JhnZWbXhu37Nb1gQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SUvO6ZzqK/D55Ar0N9FSYQt6rOfffMXAxKwEFz/GR3I=;
 b=hKTfB0ZD1/nBQmPnYBBevHRQ7jPJ2gk1RRTHk/lD79zd2yO6pdjIcEsM3GFGXxvaWQKA71IPKwxn2KPFBYN3dK8rADPLFrOT/cV9/d81TaoX/c5CW0UJ5sjydhpvXA25Dr0cNFwhwj/Cq2z4JswWkdAZe54Lfc1RsM/S9eI+t6Ry0a0TJqPjmW1+Xy1FdQmyI9JGXyIfa/S7bOZaqA8kerNOotXvpNgYaMWfTkzSh4l70F3TeBQJUi1UugIbJYdMO8DnbMY1OaFVVjJ9efyT5ZE30MF21s628SBkQ84ZzfUoQyvYA7JeKg6p7KW26a6vQBFyJNCIFRvfS7zutX8OBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUvO6ZzqK/D55Ar0N9FSYQt6rOfffMXAxKwEFz/GR3I=;
 b=J/YcgCMQyXQT1qy+gaOtUYdcahVE6ojmz1jLUVcD1wQeUIbbFojX2JZuX8Sjq17JEO1iFn7rw+qmvBCUAUVYcHl6sgnguSuez+8yAX/TwYE1Z5GKwVmD3krGggXa2/IhHJVKZITM9sEmB03k4KNVrWa3ONsePV1y+sPqwAqQVL4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB4463.namprd04.prod.outlook.com (2603:10b6:805:a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 07:27:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6%4]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 07:27:04 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v3] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHZBIkjCLBlAkyMnkK0mk8ji2dWUa5XDUkAgAAD7gA=
Date:   Wed, 30 Nov 2022 07:27:04 +0000
Message-ID: <3711976d-05a5-9848-56e3-8b97a729877b@wdc.com>
References: <53f2e206d85b99e8e2f2519beefc3e67262af67a.1669791411.git.johannes.thumshirn@wdc.com>
 <Y4cCfN5eW/1Qqvse@infradead.org>
In-Reply-To: <Y4cCfN5eW/1Qqvse@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SN6PR04MB4463:EE_
x-ms-office365-filtering-correlation-id: 0222ac83-17d1-42f5-a967-08dad2a447b2
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Mc12a0jhzlAuCKOcNCQ6ty9g/5Eje3/5kkbJA4AmWK0fce18+3ccKgkypO6VCUKYyCVaqAnQa452QSsM+NWHkx4KpD760maZYsjqGtkdif8IMnLDAQ4ZTGRLN+1+n3vtd12WfVSU8OK6MsiFifJBGmRDIPrz02w0jPO0X7/fg5oMXRBnPs/DrGoZZ1L126u4IG5EAv5fIIkfxQGtU6Y+OVof22761sfWNFjDuQyTWISBeAyTHbyEAES06ghA0iMZiQHG9EK0rcszyDLu2HfYgRbYRKRgsxYv1lz/RoKCt/fZ9bTH2QufKT9Zz99IGh72ifHdrwNwwElnwMLs6NU7ulU0MMnkteyWumRyaEkoDvGO4u4EJEcxVINnUokgao6iF3xSO4AcM3VNZx8G3PZ3v4Zo7CDXVzKfgw/zUNAMgUZJG5nQiE3SUqc8fQC2J+7Uxxaz+T8AwlQXXaH26QieNEJ8OnA5mQWikhY3BmFwolP/0kcBiJdXl6tz9yb6AhnlnfXBSeynwabbqHMrL42elHTHmIHjHv4vZNI7xIMfWfbx8Z0421dCUggteT9sQVlmrtXeQVRvBzT70kq2Qfzb22okw/irAw99nWZknomhJtlzXW8kgdtomnGqKVFcx4jvkrM7PbFInElEqwbWvi1ScXgHPVDhj2af5RYk2Il12L5E0nsnbB/+4ezVV+6OdhR7zhUY5VS1noC/6WxFCKQzwtnZY6Kvpjhyjf314x6tD9Dm4JGGBUEnnOxSjmlTEpD2acfqzEoVfrubzDwVsmHKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(38070700005)(122000001)(71200400001)(4744005)(5660300002)(6916009)(82960400001)(54906003)(76116006)(91956017)(316002)(8676002)(6512007)(26005)(186003)(64756008)(31696002)(2616005)(36756003)(8936002)(66946007)(66556008)(66476007)(41300700001)(86362001)(66446008)(38100700002)(4326008)(478600001)(6506007)(53546011)(31686004)(2906002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlZaSUh3SHRmVFNTQWhGYTZ1Qm9DWHo0b2xBWjZuNXNKR3VHMkZHTmN4SHBB?=
 =?utf-8?B?aWxhczN5bm45UVl2QlNnYVpmWlIyYmN5QTVkU0htUHFYS0M3VDE4RTRKN0dO?=
 =?utf-8?B?d2o4dDJ0RnN1eDNvR0RFMlpNTTJWNHNOeU96cXFmOXkvcE1HTDFZNXdDaTdv?=
 =?utf-8?B?NzAzZlJJYzJ3bzArZG9mSzFZRlQzMEJIVXlTYkdEZzlsK29pbDkwRlFGRXk0?=
 =?utf-8?B?Y2ZpeHRuU1pZb3JGV3BoRldXWlFtS3ViTDYrRkVCUmNpUWtIZlN4ZUlNNE16?=
 =?utf-8?B?a0N0cCtIekNCRnJkQ0FaUnRRTXFMaWRRYlJmTjNOUCtya2pSTlRnT0RyU3gy?=
 =?utf-8?B?d0F4M1FuYmlOeEswcVlOSS9CaVBZd2QyYWlwSkVwblJpcWlWaDkzbWw4ZUVq?=
 =?utf-8?B?NWJIaU4rQW81MTc1Yll3VHViZUtlVXVablV1TU01QjJXSmF1TnVJcW1MVG5K?=
 =?utf-8?B?dER3Vy9laGRYaVd4VWNXVlFyZ3psTk0vWXBiTW9MYUgrV0R3WjZWMFJualhm?=
 =?utf-8?B?VXlnSUdBbFhxbFFBYnNnU2haQUVvelNMOGNGNXo0NHlhdGp1ZWFVTThJdGl4?=
 =?utf-8?B?blhuOUxFeWE4QWpmWmpiSk02OVkxK0lrQWpWUGJUMVJNUFhEb1Yxb3hzMjVo?=
 =?utf-8?B?UktTQkl5Y2NNODlOYmxidjZMcEpDSEVxSHc1akh1cUFJVnBhNlZ6d0xTbkR4?=
 =?utf-8?B?eDNZT3pvTHZ4ODVlL1hGYVhnOEJvTTVoOXpmRFNWeVQ1cGMzdWhXZGNxWUI0?=
 =?utf-8?B?MHdKQVhFSXZaaXpybmt5S2hSTXZ5YWlvdzBHZDdFZkp4T3dxdHZVeFMyN2dC?=
 =?utf-8?B?d2gva2xTSjJpR3RSVDlhdTN4MUp4a1RqazJBWnYvZDFJcEhKbkswOGt0TC80?=
 =?utf-8?B?UVdySXZXOU1hUmZGRGlEZ2s0N2swUFZMWlorOVdScjBOT05tSGdsLzA4T1pk?=
 =?utf-8?B?MXhrQ2Fia1V3VFdBZnZuTXBOZEZwQVNKRUpxNk1ZQTQ3NVdrTlBkUGF3UHhO?=
 =?utf-8?B?eEM3S3N0dkhNTjlIclpBeTh0M1FCV1VEQjdtMWh3NktOSmF1aUJQaWM1VXMw?=
 =?utf-8?B?cWVWdXpaYWtIdjBUK0cycTU2UzlDV2JybVBOV0tza0V1ZGV2STdhRmxaOHkr?=
 =?utf-8?B?eVl4clNCcFpXNnJ1K2gyS3pjTU0vUC9TbXI4QUxSa3hHWUN5VUZYRmdjUGhm?=
 =?utf-8?B?SVZoQkloSGJvZ04vTXJKN1ZRNzZTS2xWWmNYUmJGQ1dyam4rUDFTdEYvL3hE?=
 =?utf-8?B?bmVMejA3ZkIzaEJ2ZmVpUktyODBrZUV2emQ2Ym9pRndMVTkvVkZwRDRhWFcx?=
 =?utf-8?B?TzU2SXRFRys2UDhMSlphQmdKUDd3VEJZb21ERk85V25HcGlweFEvMUtrNmNN?=
 =?utf-8?B?cURxTW5jazBFRWhTQkcyQ2RGSmtiM2tralFicS9sUTdiTS80dWZoN2lBRUxM?=
 =?utf-8?B?RktxYU5KNFhmTHFkdytTUXduSS9YRGJwblhCRjB0eUQ5VzM2LzQ5R0NEUnVh?=
 =?utf-8?B?bWVSMVE3OXZDY1VINDdWWHhxbDN0WFcyOExZWHA3Q0Q3dzM1cllPcVhzT0lF?=
 =?utf-8?B?blJqcXl0U1NkOHhKQlJpU0JubTJVYklFb0lZdTJPeTJ6MTdkMjlCMTR6WCtF?=
 =?utf-8?B?U1FKRHJDOGx4MTIvSHZSeWhnRllXQnYzcVdoMXluSXhFUWkzY3hnelZIMmhs?=
 =?utf-8?B?VUxRSFBCWEdtV3Y1Mno0M2dhRHA0Y2hKSSs4NU4xemxFZ2JQSnFFYk5TTTBz?=
 =?utf-8?B?aWFmZHdpUzBsOHdJSEZSdThnK1FkZ21IK25lMG94QXNPUFJVNnBJOEd1UzJz?=
 =?utf-8?B?ZWpDdXpBUnRPc3pRcnVhak1Da3VPVHlWN0drYlRON21HMjBqMXRNQ0gxTzFB?=
 =?utf-8?B?ZGh0L2Z6aUt1SzBEODU0anNUVlgzc1pMZ0xQY0grL1NOdWU4N29uMUtFWFc3?=
 =?utf-8?B?eXl4ajBIRkdERnhIeGZKUjRCZTREU2VhWDVkRm1jWGdmcHRFb2dZaGNqeVZl?=
 =?utf-8?B?OFFQWENGcXRtZVhocFQ3cnFWYjVuZlRRV3k2anlCN2VHaUpGWkZJRU1sM2h4?=
 =?utf-8?B?VVhSNUw2djBhcDQ5WEdmRjNyNG5lQ2tObXFBeUs5K0pyeHBOMWNYYXNMYjBD?=
 =?utf-8?B?aTlySm52SUdkOXVZaldwYzd6eS85dCtRY3VXNDVQeGVlVERlMkljTm0zemw3?=
 =?utf-8?Q?AIQDw41JjTa4iMQq5x160Rk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F5295841AA5734FA6F6CCBE0CDE1F68@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3M293LSMg72H/Rc69lhlgKzMpy1OshlO7FUnGMZicsPvecu9BSj7qDfAzZcQ4mvQpVzSl/BFQpJc1SpplGAHBTfE+x2SzTZhtGjqLuAjd70xlvAg6buZgSey8liJl9bIeyGbgCPCVBWFtXtEt6uwPgTNKCxPnPutDiTdNsIdC7hxd2ihp6Mb9d1k+hNtf28TQQxVXcmYVtNEECgYQb5YYm6VMoZNaxBjUFXMBbCw3azFMscCGyoo8qkvbllOjmhbS2gIbyyOJLPloZluM6uD72Vhdg6Q/QWfvVFmfrsC0/HerUBYiyCqF+4326xDiIVt0sBavCEDgnTiLD3alaqManiEWzqwfyNNyhLqiYCVT7ODsXU3B4qQM9GhGYbdkhPPTgoOsXIwnDEHOKetKgJchy/+O4umE5iG81To8c9V0yflhzDDs6EV/sZWNg8ZPQYxwa9Duc6tWmAo8Ltxocz3RitnY0mBLgksss+fd7sWJqWqZmy18ko+pHI5W/GgsfTrf6m9qEve8i7EteR/2vM/92yTnQaINbOuDzyVVX5QvTpOibbgTKhwHStwqzrW54e5mTFlTAsNnNwAWNsN9KxTGnX24KSAhnun6EvhbMKYDDJtfMvDCTuHuqcBvUw33zNOkm+NB35WzUvz2r6MtdzCwvggk5jnBl97x9o2Z5S3/DDctNrFQX++daDWyRQkgP3WbdaX59YUvhYih7FSm3t6ZvASsXdyfv31Li0J+zhL2J1bK36Cs65SeR0kDhjEd2a7/NI59lbW1g8o6oNN0UbRm/44svwWnt54I27Px1GrB5d5af4HDQhyiKPHGti8TglOFC1PqsHA8WHU3pbppSJPOcp7mhsuikR9j71+qq+d8fMdpLZUQfsVDigDqsXYOIGs
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0222ac83-17d1-42f5-a967-08dad2a447b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 07:27:04.5550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cff+5L5bQZoml5L+Bcfr5Ck47TE1KrF+Vh6jI5ONGAVrnADrHIP44nGD9PfBANO5GZviot0GQYCWxRUM3ahCIdifzPSKadU9DUuowKD1xsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4463
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMzAuMTEuMjIgMDg6MTMsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBPbiBUdWUsIE5v
diAyOSwgMjAyMiBhdCAxMDo1ODowOVBNIC0wODAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6
DQo+PiArKysgYi9kcml2ZXJzL3Njc2kvc2RfemJjLmMNCj4+IEBAIC0xOCw2ICsxOCwxMSBAQA0K
Pj4gICNpbmNsdWRlIDxzY3NpL3Njc2kuaD4NCj4+ICAjaW5jbHVkZSA8c2NzaS9zY3NpX2NtbmQu
aD4NCj4+ICANCj4+ICsjaWYgSVNfTU9EVUxFKENPTkZJR19CTEtfREVWX1NEKQ0KPj4gKyNkZWZp
bmUgQ1JFQVRFX1RSQUNFX1BPSU5UUw0KPj4gKyNlbmRpZg0KPj4gKyNpbmNsdWRlIDx0cmFjZS9l
dmVudHMvc2NzaS5oPg0KPiANCj4gVXJnLCB0aGlzIHdpbGwgY3JlYXRlIGR1cGxpY2F0ZXMgb2Yg
YWxsIHRoZSB0cmFjZXBvaW50cyBpZiBzZCBpcw0KPiBidWlsdCBtb2R1bGFyLiAgQ2FuJ3Qgd2Ug
anVzdCBoYXZlIGEgc2VwYXJhdGUgYi9kcml2ZXJzL3Njc2kvc2RfdHJhY2UuaA0KPiBmb3Igc2Qt
c3BlY2lmaWMgdHJhY2Vwb2ludHM/ICBJZiBub3QsIHdlJ2xsIGp1c3QgbmVlZA0KPiB0byBFWFBP
UlRfVFJBQ0VQT0lOVF9TWU1CT0xfR1BMIHRoZSB0cmFjZXBvaW50cyB1c2VkIGluIHNkLg0KPiAN
Cg0KWWVhaCwgbG9va3MgbGlrZSBhIHNlcGFyYXRlIHRyYWNlL2V2ZW50cy9zZC5oIGlzIHRoZSBs
ZWFzdCB1Z2x5IHRoaW5nLg0KV2lsbCBzZW5kIGEgbmV3IHZlcnNpb24gc2hvcnRseQ0K
