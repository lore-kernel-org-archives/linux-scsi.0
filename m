Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E80C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 11:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjFEK76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 06:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbjFEK7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 06:59:47 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2389C102;
        Mon,  5 Jun 2023 03:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685962782; x=1717498782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=NAtUDbrLwOyck3pF0e8eYjU3fx+627msN2F9JhkmPLm0SD/dGkDg3lLj
   Qe7+DOLK6VfGGbj4UAD/Gn4kR7hJlWrXNZZHa4YsscFbKG+SxgCvRz5iq
   o1quNYswfJA8rpgUd2OePo81Qa5lmVkqKuRkRHDUfYli0p3byhXso3F2q
   s93W3ruOIDo9gMqIB9mFaK4EssbagRcIB1wylOzGkKxQgp51eBRsLeREK
   I+BwvV0CBOI6ZrkzPe09RFKUJMzXQSNPB0Eaq3RnABTDVvfobvSy1WIRD
   Ut7Ow3PmEjvU7W5hUDssPd0T6ef/hIH0iyAhmXTylzT2y9S4DM0ALshiQ
   w==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681142400"; 
   d="scan'208";a="232528005"
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.47])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2023 18:59:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0O2mymH0VsCVkBkGFXlHxQOcp5F9XENUxMJnNq+x2PzMlvZjRADC94XYGdrwWnYaurs6sGZ5rUoEOEegDqcZtGeGLMaUTIjACVngOmxnIT7sGD/USVMuVb4YG02JzHJL/OTx7ejX/UilKCbFm+a9Y3og0g/53z+7oDsqNZlw9NrAlgoNuPPiwrOxANNIaslSqPqrABtNoP08HjPqyUK1gdejeZe5otJozl9+hYkPZSyuSafovXPynNGwYepPgWUvxd87AhdxeaDOHXGO87vqPqD/NctNBQNd5FH1jnWzNc5qO6yxwve+2vQVr/TPwjIZpndnBymTUbHTLLqYWMLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=LcIJoGdvcQ3UXSRk/kYr8252rCJBRCr+wrS43TRIf+4GRYpu/EaUVRDXCt9WzRGf//yrUCoLhq+RS4sHd6FjmpFMut7GWsGqv8ZYlez4BFe+hLUQMvzjsDXZi+bI8C5UOrSJ2evXfStH4zywS8gd4BOiiUJgtbssO7QJv0qzfgHEvZDsxwrqyznTRYq2pjjeebhKJ71J41/hTntWyf4WbUKBx2yhZcyEAmGbrbhzT7wRe0UBRQxcN3zmCILcPxgv/Pqydj/apWszKVHtqMdpSwCW4yW5dgTPkYU/XbcL/TOp6sxAjQfBadvEl/alBQXv1WdNdTEjBr9hetalZAMZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=M4lgUKJmdhJG9VZvYnP5NI8HFZ8aa9J7HDCXE3OXqowjTYQt4fcgv5oCEeccv6U9g1ALdjexvdI0B9msB5DxZXcLDRaOzX7YtBHOl8IVeAvGWPb4kENcw/xO0lZmJTQy+Ba+YMHwmE4elIRto/udIxdQRKtDkm5/3/VNMS73A6U=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN7PR04MB8604.namprd04.prod.outlook.com (2603:10b6:806:2e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 10:59:37 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:59:37 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2 1/3] ata: libata-sata: Improve ata_change_queue_depth()
Thread-Topic: [PATCH v2 1/3] ata: libata-sata: Improve
 ata_change_queue_depth()
Thread-Index: AQHZl5vsZ9IXNiePHUCXjDL8DNkQSa98CmoA
Date:   Mon, 5 Jun 2023 10:59:37 +0000
Message-ID: <860960de-e861-9b7a-52d6-0be196d8aa8d@wdc.com>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
 <20230605105244.1045490-2-dlemoal@kernel.org>
In-Reply-To: <20230605105244.1045490-2-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SN7PR04MB8604:EE_
x-ms-office365-filtering-correlation-id: 8038667d-c0b8-4bcf-5389-08db65b3f42e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: omfg0l6eF+twR3lxBQK/GD3olOO8b0OpW/P+siWsps28dXT1e8sIDLCRwOuywX94H8T5PnaSGjbapCQP/RfMOvWbnRwkbtmmHDh58UF1DxilOm1237JLhV7IMc39JQ1v5RLGwgGhgJ8sOPO3nmLPbgPVo0eE8+uBd7H29ECz9eRHvsjy307uICngTcyrjnY7xKh1UvYI92WSlQc6q7ETLDTBmTP6GYOUH5sXHJnt4F51WB2oK446bupCw51xOxQs+8eQGFf7eWNQq395uwOxlOSirZBEi71vb/Zymp9bZlTaYrmc11MWz30hAgbdVaT1vHZVWOyw+YPl1D0pzLI4+CoiwE+d8XfR6Y8UBFfs+rUoLNxh9vp561U5I5TAyWfFwCwK6uHBqtJ5tmFW5KT0+UUMjnoE+tcM8VfWw5hlcm2VIEsC3jMNXfzlLfJPyI1GFrIApwOJgbexy+EBoe1J4jqsXzlDV7dz03tNgW5n5oPKAaXsjFc493FxTOcaqVrx60YSFD/sMil8cXWoID/CTgXrgy2/tW6SqGKdvude0ODeeCImGjXWr7rCa2nG9rYwsdxt4d7lzylKh6dQXz3wh0og1CwV1a54ZMyB1jXULDNTqwmVSlzp94w21/89x8bbwikFBid8VuN8enW7UPYlqcIWr7RnXobX3WfBqq72IHxXO0Okg3Px2ZZ2jUNZl7pu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(71200400001)(6486002)(82960400001)(2906002)(66946007)(66556008)(66476007)(66446008)(64756008)(122000001)(76116006)(91956017)(110136005)(54906003)(36756003)(38100700002)(38070700005)(8936002)(5660300002)(86362001)(8676002)(31696002)(41300700001)(4326008)(316002)(558084003)(478600001)(19618925003)(2616005)(6506007)(6512007)(4270600006)(31686004)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c08xU2tZNDdHSkNXMXprVVFmVi9LZCtMSjVJZWtPdDlWZkpoY2JEczk1K0tI?=
 =?utf-8?B?dVJ5Sk1BdUdKM0xyUTg3UGk0blRyN2x4NG9aQ1FpV0phZWFrL0doelpNTFpF?=
 =?utf-8?B?QVhtSm9oSG4xKy92b0ZPcXV1cVA4QTA3REFQVkFSTW5IWkZ2REVQMTFZMXBH?=
 =?utf-8?B?R1lXbk1zZHp1akUrRmVkV1ljOEVWUjBLVE1FeGRTKzhsMFRPZ0p5dWFmeE1O?=
 =?utf-8?B?YjNEQkkxVXlQdEtoN0d0aSs3SmcyWGRHdzBza0dYUVptWVM1L3FDT0dqVSt4?=
 =?utf-8?B?STdRNUlaclAxTTQ0S21rWGRWc0tMb2I0MllJNHltOWZXLzhVUDI4V0JiYVhy?=
 =?utf-8?B?WXZqWXp0STFHeEFwMERZV1lVOHlzM09WVVhaQS96MVM3dHZEdWxZdWJ6V0Nz?=
 =?utf-8?B?WXVWKzdZbS93WjUwWlIvUFRCU1A2NGE0bTR2RW5VZlN0Ylo1dVJwb085M3k0?=
 =?utf-8?B?a09WVTZZN1k2eEZnN1JPTXpUQ04zY2t5aHZIa2lqbGRyc3Bnd0dHWmZGK0Fu?=
 =?utf-8?B?WmVHMEptMFZ6NnJ1RkZZMWNMM2Y1OWtqMWRqS0QwNmVLRXdyU3BtUDhMQ2JV?=
 =?utf-8?B?OC96SzZ2cWdBcTdiMGVYa3hCZWJBcGVsUUYxSUVlaDJIOUJ5R01Qdkt1d1lN?=
 =?utf-8?B?SkJkY1lSMGV5bWozMkp4RlZwMHZ4djdITEp1Szl0cTV1NWdINHVUcUJnZFQ1?=
 =?utf-8?B?UmJHN3phUG1FS1VsckIwekxMS2ozOU5UZjh5dVRTa1VEUzNIYlRMVEVicVRU?=
 =?utf-8?B?aW1tTDRLKzQ2K3UxMHphRmlweGZic05BQUJoRWsvYVN6QmdXbU1veGE4Q3gz?=
 =?utf-8?B?TjJvZ0l6SlhCZ25ONVQzaWV1RkNaUzJSOS9HOGFhT1ZZam4zY3ZKS0FaOHU2?=
 =?utf-8?B?dm00RUV0VVQ1aGd5SVlCcXgwMG5XdDdpbkNiQjIvdEtPYmJsY2c1Z0ZKa3Qz?=
 =?utf-8?B?bWxsYi91SzNwRTR4azJFdHA0MC9RUnY1WXpRSndzbCtRdTlReXkwT0lMMVpL?=
 =?utf-8?B?QlJ6ZVNwSGpxcDc4QVdUU2VKYzNhMnhpcTV1TkFWdjRtQmJidWdnTVhYeUhM?=
 =?utf-8?B?VkJuNFphelNxL3ZtaHRHazJlak4wamR3d0FzOTdhZ2RQUVVhQUZuRG50Y3Q5?=
 =?utf-8?B?Q2Vlclc2M3Z0RTFJdVNtSzFuVCt5RlQ2aDhBdVh3L3dpMGN0eUlsUU9IanZt?=
 =?utf-8?B?TlByd2hMUjd3YjZOTG11TnZNOGZyNjZIVGdoUGlheFU3VDloVjFWYk1IUlU5?=
 =?utf-8?B?T0I2SlNVV3c4QVhLU0tWRVRmTnJLVFdndnZ1aE8vWVl0T0MvbzdFamxvbUxF?=
 =?utf-8?B?eGJ0TURLbmxlRFlXUHpOeVY1SndRVXRoM1pTeHRWa1phWnlZdjRxaVZjayt1?=
 =?utf-8?B?cWFkeTB4SEJjOC9iUlE3ZU5md1Ivd1UySVNrSDJwLzhqZTBUcXV6WlVTQTJK?=
 =?utf-8?B?RW9ySCs1Zk9iZzU2UFF4czNOUnRZRnQ1MHRlK3QvZkxFWjNQL3NaMmhkajhI?=
 =?utf-8?B?ZUowRWluTlVMV3FqOTYvYmlTV0tLMU45YVErVjk5Sjd4VnhVWUg0QXZTcGU5?=
 =?utf-8?B?TVpaeEFYZjRhNktIYXAxV1B1Mmt6a0tGc2VyeEVGRGN4ZUpIMFhIbVgrUXpv?=
 =?utf-8?B?NVRvemdyanFTMHNRbHRUMjVqSzEyUnFZRTNzaFNtY1kvZ25MdGhKOWV2L3Jo?=
 =?utf-8?B?YWdVRnhWWURZeVFySWJ1WmdnUW9laWZiclNVZXVvbUhLTUhLaFp0S3ozMjJJ?=
 =?utf-8?B?WkVZZ2h4Q0NjZG5ORFJKTkw0alNYSkxiNlJacktldStMeWI2UllGK2o2aDhy?=
 =?utf-8?B?VTU5Q0dsVlNHVm9tU21sSWV4TU5IMkc3SmhVSFAvK2phTmZ6L01VSHpQMis4?=
 =?utf-8?B?RmY4c3FRejFTQVVQL3dwZTQ0QUkwQjBDSHFKVmRVZ0tnTVhtN3FvazA4cmts?=
 =?utf-8?B?UEJsaVlnU2tPczFvN3psN1AraTVpVmxVdkF5aStVS0dHTFpsdlcxcDVpZnRl?=
 =?utf-8?B?RUFWRmFmSldrVmhTdGZDTjNxbVFvTXRtTEQxWFV3aVlWMjdrU1c1VlM5S1FK?=
 =?utf-8?B?N3F1dG50VnJZZlJiUFp5WjZhSWNPZHFMYld2c29seXc2UWJ4UkJyeUFPZ0lM?=
 =?utf-8?B?TzRmWGwxWTM2NkZKS21oNVQ1eEdKcG1nS0hWRFpYd1VVOVc0aEdIdlJYRWZ4?=
 =?utf-8?B?Q2paeU11NUdLbFA3SlYxbEhzNmo1S1pZd2M3UmtRSDdDN2pxUWgvQm4zek5H?=
 =?utf-8?Q?50vshgoTXgmAk5RTNGjT3UAOueo4REKg3+tI54U0wE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <224B96CD6DEDF245B7A55382D3D9C92D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qsYVfyDyi/r5qqarQ4Ut+6P5aM9qW9TGdPEtDWMPf0PD9nXYhNMlWNGXNr4zwEcbjaBixr2uctqgZ5Ollrc84zm0f+W6jhSl4nCu072yVtafFQW6Qs7tPUyQVQkMne4SX29KxTEdTDvQmG0XwTaLMDKIeM9xZEwnZ21MWw7wBrjelaQ7L2Sb3qO6bys9HJslffcIfTRt0M5b7qsAAWgvgBgSoVrCMdsQau99brnFPYOGZjqQx7KI1lioxy2uMqi5vml0FLi69mleE9dhQ+KRV+F4PoOhHDlQNL7KUSSdyXnx9OhDOme1yodT9av0BtVBsy/jrvymLBEzdj+vc0mJZSgO42RkpneM0ZxdsNIH+tRIvA2lOku7DxTPsE0xPfQafuWusPahHZIUy2yriJkRoflcidKMuOxbaxoChfqljE5NWuPizt5ggFbrbgQjIkyv7b2fBLCTG3aDMmbUOzs5Loug0X1v9oB0Zf7QV3wAnAvZl2v8mB3WvGOif0D6JGyb8uhgjPGDJZKZ+IEwqyS8qeAB5yJ2+vSu2jS5zEemjqU6xOnjK64KTcauUVSg95DuSsmngJ212t4wAspum4tjOYz2FWy6TffjHB4pg3zsL3vEL0bHMhzgAFfmhOMj5Vzw3GoGcpqE0pf0CimgObZB2pd7MlQE7TmGsQ1HG3fGBdt9Mgu5D4NFB/tsnZNV9qV1X97OtK1nMnciqofKS9hYl48K+u9HSpGU4KbwTZo5oLXrYt5UIU44IkicLpbCQYOgK+Axc4Ap3YmnuMVk8zFJQgTTJBrkU7Vxt5z8TiI8Dwje+k/ufo9AiDbortdTKqtHwnjzcJDQDtQoVz50q9r9ZuaUm/D/NywRCkPMWeDrrBhPusmlUvHra4KUBoXeY8Nm
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8038667d-c0b8-4bcf-5389-08db65b3f42e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 10:59:37.3248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IyxVD697X/bLa/W3rANaUG9uDa6sZXg7DxEpivEbXQtRqCQ0SBQHLphfvH7Ty6TJc2mWh9RBO8Hg4TdqoHVRS/4Yz6EGst1v7nNYFIccPbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8604
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
