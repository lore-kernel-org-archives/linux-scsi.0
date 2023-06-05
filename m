Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C306DC77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 11:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjFELAW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 07:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjFELAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 07:00:17 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8006210D;
        Mon,  5 Jun 2023 04:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685962816; x=1717498816;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=UOl2b+OhrdCLyzX+x3dz1xk0j4TtUD7ui8fEWtSmZZpr7yszAn795LfI
   fIErsBjUZQqts71Ac8UxNNI1ooYOqpjchKdgB8gx8At669CouxTocLL9C
   sPoIkRrpKq8Tj5k6BfhrAgJE2BiGxJ1gwG3PMRCDRe5t4EPazPT+4lqmF
   snUNVrmjJJTeQdLddAkXZfOjHYBu1PxtpUmXts283GQotK3VymmaJc0rQ
   VHvmL5W2QaYyS1H/Ninmdl16Qoo3fCOT8ro7lOiKYl5Z/Q97SkMrMWddd
   EUdwjQxkjME5jczcRTTGEQcatAY53RAfRPuO891NKLqvjXws9VkQiQi4g
   w==;
X-IronPort-AV: E=Sophos;i="6.00,217,1681142400"; 
   d="scan'208";a="232457327"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2023 19:00:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTEXAw/t08qEuH6CjytIl/UF76IDg7SSmKqwWRoZTlNolPHGewdq30nwlu5AiCzrziiAOjXqPI7mCQ8yky5L/oC4yNbh+NC4Jq5D910mzXa41o5wEcZbC6W0pi5bjQdQVOY2RHN0TYUZr0A7zSBbFo+8hiECFzOuycCImX2Sq2jKiIM10pyCW4N5FhDtK32A656HZAci7sDHxM2Ev7zji4GaITUzkP34cHASUDyi5IECf3tTipnVsIddl+7fynyFOwgj6hWbCizQk8t/Mx91buytWvF9b8S2AgvaVhE1xsOQlHy9ubQzvWle93go5k8Ie+inJF1cSeIHw7wiy1iSLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=YfpfEIIa2kYyC9/yacy9z+Fx50kUABD98gJ5xex740LYPYRxgwm07ghwUXUfFGfO7C/Jus7nhjjPoZD37SWCHiPRRRxyps16AFuo6tHfAxxXscrmWZZFEj2mCbEegIlQfU0jgInbxYhAyniXhyPcXYSP7CAvol0r68QH1PFeEMeYYKYDffnv+esTK5xvYl1NNxOT/r6ZbX/yHUX32zsogtoOg0gGU5VCNd5wAnQ1zVavehEIqC+rImFXtroHOPAKs7fTNVPf8ukfYSopTKS78C4ZsPY9ZoHieUutF28ofbUxFwepQGlSldPOzlRBpsaCdZeLsU9UIzVyS9jYO9Py9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=jJANukPt4dgQ3+PlFnYjzpYarlXjvS+fNyeBX8pBhNre1lQgdlJQ15yxgOKBKpyCFCgs0CFROdx+OCJM1SzgQl8tsE1B+SwdbNJOjG6DZmEjS4atC5fNWkM7onxuaps1lSaq/NqnLuWau0AVEt9hwmHt0xyIuDpSnILF3FjWZPo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN7PR04MB8604.namprd04.prod.outlook.com (2603:10b6:806:2e5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 11:00:14 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::23cf:dbe4:375c:9936%5]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 11:00:14 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v2 2/3] ata: libata-eh: Use ata_ncq_enabled() in
 ata_eh_speed_down()
Thread-Topic: [PATCH v2 2/3] ata: libata-eh: Use ata_ncq_enabled() in
 ata_eh_speed_down()
Thread-Index: AQHZl5vrVZnVMai6H0qAfJKrgF3izK98CpaA
Date:   Mon, 5 Jun 2023 11:00:14 +0000
Message-ID: <f01715e7-9f32-ecbf-fb02-7b5023004dcf@wdc.com>
References: <20230605105244.1045490-1-dlemoal@kernel.org>
 <20230605105244.1045490-3-dlemoal@kernel.org>
In-Reply-To: <20230605105244.1045490-3-dlemoal@kernel.org>
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
x-ms-office365-filtering-correlation-id: 27e03e18-2a60-4e88-8458-08db65b40a1e
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p77otmVKkF+7eVJYw2xAx8oNTYwxyxEe7KcGJeYzKdTU5GTTvLaKQ9h7gy0TtjZudMZOssL9xgGlpqgqQ43uZ5aU0B/L3YNF2+7PYSGqvgdj1du2/vBt0uzBj6kAsj5kzJfRKYtiKnvdgYJ/mpDyvZMxnWud/1BaNnN6y61wNOF0cB/4r/R1RZt47BRa5TRd3zdjqVCnT6dq5M9AetX5nAmbQpfUeE7XFCo3fu20KdkkX+ahu8F6+qUdTkAsa9ItsoHuJ5HCjCzaNmHmsQShz/nlYU/x8v/zk2MxlJLrrF5Ng/vIjQrk9rFNCnNsfZqunZXw5yU26AKR06Msj967T2Rm07w0Lezi9p1pZ9E7aNivSAWTh5opDLrZnh8YySGf9LL/YyvhsNK31Sjw370v764wVyGhad682asrVLW2hIYElxI071kELJy3ghgXYMOwm6zLp7V7BQ5kmEv+JCDvP1MiC1cziR9daw/qEKp4zOzd1DPoKjWabmA3vhSxI3ccHBa679COsnRqYyECNts1O0j1CYQMdOoW6h+FTKQuGWc2SRPGMluZRt1QVngYrDq/tPNcMMSWh9QYSpYA/nKnLUdArCBMEq7wWNL6lLIptL7OcR+FBSovrD1XlSUTZTlvClVdPD7iRSjMe9w0kcshM+4ENqsT5sb90EkEcDNJNbmdLd8Oh3LurlIhEl9xwdpj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(71200400001)(6486002)(82960400001)(2906002)(66946007)(66556008)(66476007)(66446008)(64756008)(122000001)(76116006)(91956017)(110136005)(54906003)(36756003)(38100700002)(38070700005)(8936002)(5660300002)(86362001)(8676002)(31696002)(41300700001)(4326008)(316002)(558084003)(478600001)(19618925003)(2616005)(6506007)(6512007)(4270600006)(31686004)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVB5UXVtQTFadlo2Z05pR0NNZ2pZUzUyRVM5eVBmUkFpb08ycHVWRzdvZHBN?=
 =?utf-8?B?d0hJejJLMEJVbW1BaWFRUy9UaHdYUHJ5Z1U3Qi85QWdGUWZuRmNabWN4akVT?=
 =?utf-8?B?RXl6TGpVTUVIWDE1blgrTmpvNGdaRGp0clgyaFNnUGQ1c1BmeUorSldzOFFR?=
 =?utf-8?B?NTJUdVkraFZuaENKZlMrRVhScnJEK3BCTVhubFJBcW55Z2tHTGJnWlVSN2ZK?=
 =?utf-8?B?N0ZJcnJyVSsyTFlDeFVYMk9yUi9wYkVPRllJVjQ3aU1Fa0ZRblNnTDY2aS83?=
 =?utf-8?B?UFhlcTRQcUxBVXR1WGVVYnlybXluQ2x3VGlPdFA2TU9Hb3RIWDlRMlJPREsr?=
 =?utf-8?B?YkJQM00wSmdaRHhidUdDejY5L1ZUV2NlK01QRzcyVHpEM0VuZmQ0b1luQjVP?=
 =?utf-8?B?dERlVWluc0g2NHJHV3NuRzJMdmpGRUtOY2ljZVhEWEluY2NuOHc4OGJEekNm?=
 =?utf-8?B?dE5kMmdFSWpBS3lZWnd6ck9kdkhEWXd4aDRWMXpBbEQzV1BmM1RSR2cydXVI?=
 =?utf-8?B?N1VoYXJuNEJ2aWhqaFl0S3M1eVppRTQ1NSszZGJrdytlWmVhZVV3YUYrakxV?=
 =?utf-8?B?a3MrazBaMjdlTlYxZmJIL2QzT3FzQTlmbEdMdVB0OEFPVGlEdmJJOHpqamJK?=
 =?utf-8?B?a2MyazEwTkZMdlBGZWRaUFgyZ296d2pYZHdzVFVyeU4wdTNCellSbXRQcFh5?=
 =?utf-8?B?bzlwQzVrYTlGZSthYUxoaFNvS3NNWTdveW8veEs0bXIydlNtdUxWTTh0Q25S?=
 =?utf-8?B?RVRhajZkRldzUlp4MUZIY1c5NnRkSDZUY0phUWYxSVFTSEFHUzdGRWVPVVJs?=
 =?utf-8?B?czFncERxd1RXVHBSNGkwVTF4T3dkb01Dc2lrcGpWNDJpTzJoZEJ0ZWgyVFlp?=
 =?utf-8?B?WXJXY200MkJkS0xBeDA1MEFUQllndzNJQmREN0RJcUhDdzcvUjZTampRSGpi?=
 =?utf-8?B?OHc4RllodnlUNzQ0d3A2L1N0S1lWMGh6RExVTFVtNzJsOXdwWnpUcTd1VEFF?=
 =?utf-8?B?eEhRVkhZblM5WS9tYzkrYlVvL0RtZXpIbi82L3hQeGlZRUl0OFA3eXVRVjU5?=
 =?utf-8?B?ZU5sTGNRSUpMQVQ1N3ZNdzZWcGxWRDNqVXRSWHdhUTNoOFVTbWNnTGk3TmRS?=
 =?utf-8?B?b2NsSGtBR0tuNVE3eXM4OWZVUTNpMUxUcjl4MWFjMmtNb3pwRXhNK2ppRk4z?=
 =?utf-8?B?NnErd2ZySjZ0T2JjWmV1Q1lic0k0TUtCMVlPc1VDZ083Vkt2M1ZjRHU4YWVZ?=
 =?utf-8?B?ZjRtYVVlR3dxbUVqQWN6eGdsaVVNQUNReGV4dCttZ0REdmdpVHFxdFBMN2g5?=
 =?utf-8?B?MU5ZU0dwV3prWjdLQkNEUEcyVzNET0toSk1sdWZGVnFLdi9TNnh0RTNhMkYz?=
 =?utf-8?B?Yyt6eUVwYmwrRmxKWHU2ZVJMRGdBUFBsZGN4dlkwMkF2QlVMV2lTTW93aHJr?=
 =?utf-8?B?aVdrZ01Kb1Yvd2pveERVQklMdExxeEpuakJtM3FobndmTmpiLzB4aCtlV0ww?=
 =?utf-8?B?SEJCbTU0VFp3bVFHQk5JQjFTdU1sNDdTTFgzbHNQUjRJeW5VNzBoVlgrNzNK?=
 =?utf-8?B?SVhabThxbGRmOFNSZDg1a2tnSjZrVnVHL2dsZkZ0bCt5NzJFbE1iWVUvL3dB?=
 =?utf-8?B?aGphamhRbHlTYkwwNW1YN0htc0xKbWl5N05TaU45M0FpV1VxTUZ6NHhwdUdx?=
 =?utf-8?B?YmF0cStrR3FxMW42UDdSTnM2SGMvVXByYmduVnBYQzZ2VEdEYXZhRWdXSzJ2?=
 =?utf-8?B?QXJPVWdraGdqdDF5QUNkUVl5cVA4bWl6YmxNdVhQblEvVFQyWFoyQ0ZzeVZ5?=
 =?utf-8?B?ZUcrckhWQ010ME51WGFodzZod1NMS1AydHhncVM3OU1uaExkY2ZsekdMeHE3?=
 =?utf-8?B?WEd1czV1RHgrcCtZbjZPWDJmVkIzU2ZPeVBkeVZCQ3BscS9YZGZKb0h2UlRw?=
 =?utf-8?B?NXV0UEl6d3JnMGpJa3dxRGNoZjhqSklVamdQTU9yWnN3TjUvbmttSHBOK2Vx?=
 =?utf-8?B?YW9XeTE2V1AyYlJxY1BiaVNZYjRvSGpsT2ZGRnZXT1kzMThsbWZqb2pXQUlX?=
 =?utf-8?B?THJ5VWc5QjZZRXAvaE5hOHdiVHA3RUNvTGpSSGNlekxwZzRXNUJ4QmxIdEJ4?=
 =?utf-8?B?ODZ6VTc0S2JFOWZnTDYxbEY4TW56cEZsK2d5NmtQQ3ArY1ByMStDQkgrWjQ3?=
 =?utf-8?B?ZklvMlNYUXRHd3JTaHIyaFBUMEh2TG5QOEV0SjgyNmQySndUWHNWUzROS01q?=
 =?utf-8?Q?4j/vLzt+WoIUcQfcGslZ89F+EH/OukiuPKStq3DHcY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0056A1CDF12DF4488195817DB357DED@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dLo86l93HLkC8Fuf1bydy2I36J3vJljyU5Qxz6/tA6nGvJXd9gfuUYAykGcU/CM12FvFW6tO41eTeHgT7PSt15uAHowk49H9srBWdEt6rqDVGgsqmLQIzHrIVCKawqOnYqTOtSgKzzE+0R5DpXG1FIILIo8KMoTX9yFKpZgVbHUrY1XM/s38f38wMBdIbACRLvROQP7E5zBm5WByxEOHBShK8dO2W8kJJT/jfPGNTu7FBIXUNyBIKMayfrurb6td0bz/f8IyazM9J0jpdV4CtbUZmkbUQ37gQWuNX9exMonvNTH2icmW+6dupHGSXf6VbXystsObIs2jVIK/73SwdQpA6ELDr8FkmbkPAgXr+pO4k0oNc+DLQ1UHg7tWS379q08SPdC/Tn/CjScurZu95OBZhAnGC6OiDxuIyoiyw33x8O8kBLrOetJ2TDwEgXnQLen2XMkKGjmT8xPVpnmumpYa8UpArmQcsO+o6vsaJn21G8UxQMxYaOH13b+97v5KSNj6LUpWe4Q69YS3Z6ZW9j6WksZ1LyjpBN5+FDZH/1ktf4LCRZw2Ke6KGKTAiyciXhm1CMH3edA9AhhUC3FuA8px2Wuci0UrAxrt41rnWpxzXUISqDlJ91IjN5taJNQGgLrwyfYQo3Vu8OKUSKaWupPY5tqqfag4u9GkiisQnap2yWTaSxWP1dSuF+HW5j6oeZs0pef5VMLCIsHdooHcAkVssi4BPuOjx8vPIT+oD9jX7nKGByjz3+kmmJIMGisX+ydv5r2R8zvvD/bRofIEApjk544+ABi5l5bVRKdwrpjl26dRxena/ABnYjog/+xmeEi68Vg4kHVGy9rxKkHWTUDbP5N8KnMv25v2xUH+M+Dwt8IpDokuZVEpxHvdCp6S
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e03e18-2a60-4e88-8458-08db65b40a1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 11:00:14.0798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JjKxf0/Of7cWzyXnv5D2ihzghnGbZJqyLVfiNA9AvQI5VtCitCCO7Sjeq0DbGQ9jHGjVtWPXUbx4oKdn9lXTXXJKE47haULnxGIgSI9fdU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8604
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
