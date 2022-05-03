Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FC4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 14:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbiECOrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 10:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237260AbiECOrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 10:47:00 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4B238D80
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 07:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651589007; x=1683125007;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=ZHTQ2RmqTolgFtC0hqz8E2+QWIzr3foI+jZSpvYfFHfA6VLNWbt5kE5G
   9ntWUg43NI7ACldMeWDuBd4dvcHOyMD2O+dL4Kui5DFmb/iTD8WsAyHe9
   ycW4RkV20OcUWNevEOevI39XYeL8xF+O8TVF7UzVG+13WLSL23OfybApH
   dOzisUYsHrxjBoJfKLPXh7hCJGGq2bETZgb94j6CrUElOzTX867ZRC9ER
   H/3FgbppIA9ITB9Ow5UPDBNHGduq1W9JKuwftGoY91FeTmW+f7rUkHVjr
   60YuSAZ+iVW3iSVArn7d8chXrhpEzn7eFrm7STpGTrLHytuboxNWa789f
   w==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="198261444"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 22:43:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6/Bb9oU/7G+XxI7F/O7KHB/yQUWf/AhmRpVeHht8wKAnPIHIsdeNbN+x+oWGs6+BU+n28XeISCEqq+3v2ATJ8CK2IOsew+UnRqWBeUtaAjeqCZUaBdwSw7wzh2pogO1bVZkkn7D6FixujMjC0C9XioaAIKuDiwaucR57wTdI+/7efQgAzyjJeZCniHds84O1sqAl1szwzdGlzljClXSkLMt0pc411K7vTLNbIQQHUGbvfZ61Z/OjdGrJizj8Wasvpv8ZYVneDiM6V4S/NUdG09rZyEPEw4tOPQQfKoLy2MnI0XlR41/f7m2fYpiU6IooRtsErLqaEN5ZSkRmn87sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=A7lUnNtKdy83UYrqXe/ZX5yW8hu4QxK57xqaKZXOHM9dZecadYxjZYghz7u7ulCRBVJpfkl7OjByPzOaGK5BKkFaj9ahjNSBkaceqh1PqmVY3/5JfsFk5fKFZf33YhcT6gxzxv/p2qIF3nFKcYVhFi5v4mMBw4fMqrU8rKrWBSYnspgfpxbdFIZHkhN8VwgCOYV3AdTD0CY5sOSA0py1vA3tgof8XguzI8Ix//3tAXyQjdhJgHso9NCE0u/RkXi6t9q3w2ROVjeETPZJ3JhorgKcySMwAW9DXSu2wHH7S1RqTeDjz5l52CVf/pwLthOhuUMc3UvKVuw2Ve6Fv2VIGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=vgtE3tO3rOfZpZqzh/VHEn9rvR2zcUKA0BDEwapUiUJAxYkCV0kE2GSFcAGzG0aTNWodMfP/Eng+HBmkAOITiPS2FUlAYwcXb099qnUMbINPZHMMpdFwpRGaEHagyg6CDjJd+LtPCUTEVWz6HCclT6OxM+/p5j2ymd5iLEfjwOk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6735.namprd04.prod.outlook.com (2603:10b6:208:1ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 14:43:24 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 14:43:24 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 01/24] csiostor: use fc_block_rport()
Thread-Topic: [PATCH 01/24] csiostor: use fc_block_rport()
Thread-Index: AQHYXm0B1lS5CjGKA0uN7dUwbNJiqg==
Date:   Tue, 3 May 2022 14:43:24 +0000
Message-ID: <PH0PR04MB741648FA2B984CA70D1EBC229BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-2-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c887c654-8f8c-42b1-8110-08da2d1346b6
x-ms-traffictypediagnostic: MN2PR04MB6735:EE_
x-microsoft-antispam-prvs: <MN2PR04MB67354776E2BBD987FAC7A4879BC09@MN2PR04MB6735.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FBAAptJw13kUqJC+kYk2vkLOJXxU3iYsCFIFYjnL8ISIDLxU32hiSruX2W5bgGAEd7YWDh5P3UsJCaCBSKx1cRTBV3Q/ATdErLXT+YuTBxdLFleJOsagLF27PBaqzhhEYHBS8nVnpaxLZbmzuVaIDpTm1KQaEu1lhfOwDuDFvw8Ypa734EqnU8VykBw4kim8delenkDBoZXLihqlI4vRR+r73c2lOelyEmQrsjZ6+zWWOca1iFeky8WwzapEgnabiNPOSBfinuRvEXvyh6myVJRAOfOM8Kp67gpdDkeXNivxs6RgtA9KQOVGS2EYyDsihcLdGKVi5OF9sDZ7rv3wtO4TNAG2sucOk1yDjx6fysb1v6n9q6AV1Vqa2pZcdkADO+CkmR4h6/lB5TBqeEXC06p46+cK02SV/+CRZhYBHclt7xJoSIUO8kSqm9d+cqtnp2A0iNOaX1euY14ZGuRKNYk4Ho+soZVWQXo397xXsd2aKwoWCq+C39eze5ukHGbHaD0mdCLhu3lT10QEm/aiBmR4o9ImdJOIEg3l2ZYWkoKgiY7EjEjPZsB/+JCt3Bd9GdmR13Cl87g+m+12PUHjNZiA/BvYhxyCR1WP+p/LlovNkjRAYqQ3DWjI4TaUTTOsTe9pnqkobc9z9XNhLIgx+zAQprrY9XGGWN6v4kmDbV1qNK2kSRpveuvsln2HkfRbJkSA1KHDoirRHVrsT8pVdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(6506007)(38070700005)(7696005)(38100700002)(9686003)(86362001)(26005)(82960400001)(186003)(4270600006)(5660300002)(66476007)(66446008)(316002)(52536014)(64756008)(33656002)(66556008)(4326008)(66946007)(8676002)(76116006)(55016003)(19618925003)(2906002)(71200400001)(8936002)(54906003)(110136005)(508600001)(558084003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hwxaa45WnEUz11Zv1hlupBgujwvATYPD3t0mlF+iG0HRcFEGYoC3HsedszST?=
 =?us-ascii?Q?ICJtcEopPvjL/Y1we4KKEs1pqL1b8ssD3M6gfhRmDkQDXoMPmXZ5QZ17+e/f?=
 =?us-ascii?Q?EnSWOPwRZU9hEZ4ZtEHooI2uZd6DG+sOSg73Oguj3mmfvKeXMeTPF5sDpzRj?=
 =?us-ascii?Q?lID8z9f4R4jeHJ8nVSxGzBJxXdOQAeR3AUuXk6tLIqOkuIRnq73DAQLNv17+?=
 =?us-ascii?Q?wRekAPQYmcgWvN9PxczMPVqLnJt8IKuclTWZBVv0TUyftMYMPeqyBPtxUuAd?=
 =?us-ascii?Q?dIPx4y6pwt6JAT1R4C8fKqodviGbuSxcHIdr4ll8B6v4xEae1VjmgVgVHzXu?=
 =?us-ascii?Q?oW7k2y6nrdmOqi1SsxgxUfYdSC4fmlUdg7Ndc97tQ3i55pxiUs55Fq5Jn8FO?=
 =?us-ascii?Q?wMB/3DN2xWrVU0+s12Qo/7JFAgflyApqpzUfn+vfiLLUz0a2XQ9KRx990FrW?=
 =?us-ascii?Q?zC4qBIw/rJKLBb2t/iX+QJgwJxxREGju20p7rUUJlM7xUyWkm35z9CaM9Y+Q?=
 =?us-ascii?Q?S8oFCmbLuXX8jR2nMxxTc+hg3uSwEx3ooSgBADU5tTVay5/MCuGcyEDtQIEb?=
 =?us-ascii?Q?aE+wi8T0hdXhRhMr2xgK7X/CY/v0SLz0iv9eiSq6nuDTGnJh6pqlc+FAFT8l?=
 =?us-ascii?Q?s7FJtgRHbDEe4RkMkpCkycv3itrYZfiYekiC5BHwoWyjvVWNHa8w/VBUrsOJ?=
 =?us-ascii?Q?Jvvwdo5aKxdHkWL9r6MlnomtpPU4vvqHsos/xlbG+HPYRPa6qankNBnMQkyV?=
 =?us-ascii?Q?oDL1clg+qnEPvjPTeDTBDul4pQcOPTI3FyFLgethepJCXWY+qXWk5izjy5lh?=
 =?us-ascii?Q?SSSqNlEFogaaISiKTuqGXzx9XprExIoK5S5XSwldzOjpkcAMkqi2mKD5zAHc?=
 =?us-ascii?Q?NUBceUozs1kP4VSSAyB1TpHhZbif19DKvJI8b8nBZ4nqhN+vmhs/xf/hmEDM?=
 =?us-ascii?Q?DLfDZwAi/Z7u+4eQ6C3u9P3oCgtrSwZDXz0GOw0df5p2baiurjNeUyHbRaUw?=
 =?us-ascii?Q?NNNTV8WplgoO3Dbv8TLfuWp3WHBbftg6QH9fQajNf8v098CSN6xc5oNdHp/s?=
 =?us-ascii?Q?cTse8Twdeo+N1GaHKxtKUN6s+N13UI7Xb7EvAmVsx1qyB65br7z9EEV9mIxH?=
 =?us-ascii?Q?0qmu+wrmsb/Z9Ym9mlBD/RRmLTTkdwc52pCqxbk/dmAHLCb/EZ9DFoIIIoqC?=
 =?us-ascii?Q?UvlizASZYlLjT8EqtUXjM6/Q+HU0zkfkpGa5CF9aAEcnnZureO4zxMiSG2aB?=
 =?us-ascii?Q?UGu9LvQUWB3D5oMq+ySYocYplxU+BKykob9ICrAoBiejaQvVnrDrfypQJhkw?=
 =?us-ascii?Q?o2iGBIEHCICgfXp/wqmSFtxxcFXKtCLolmG42DEXqyHX30u17l+D/aITuIJS?=
 =?us-ascii?Q?bx2fbo17GUIHV0inaxOfnw81luzZnffMYteP8yBEtn1sI5ZlUE4cNRtcm2HG?=
 =?us-ascii?Q?r1ZedQTQ5F+g4y9nkJ4C87rrCDACzh3jIf4fX8TC53l428UEtux0cXsf2S1M?=
 =?us-ascii?Q?tupobRXvWXe54a5Bss+bNDDXbznKb5wQl+ilQ0/XukS5K2WWnzwW42jOnBbY?=
 =?us-ascii?Q?2R0nc0xaUtho+gvOP+QWH5aXxP8loLhNl+GO5Q/WHF3Cxp9CiipoTrU4yw6D?=
 =?us-ascii?Q?NNjVtY/ApGJqVn1bVewm7TGr/v9lXO4k2S8DdcCuhoJi+XclCmKsaPnYTqIX?=
 =?us-ascii?Q?WVq5wZm8MEAqbIHwcXpimrNJ1+ZdtYG6rtFIn3uQ34SR8jm8rp0Np7qbfi7K?=
 =?us-ascii?Q?G7WdyaoetHzHEfwKnYA7X0ir+bJWn5s=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c887c654-8f8c-42b1-8110-08da2d1346b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 14:43:24.0184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c47+pzLOqe8liFZ1Y6Df/40qFHJ/UnrBXNpiJ3OIHcdvD2UQkgecW7Wz9991ocZ/j4pN9ZETBORd/1gbNxMsaO7S6w3BEXoXIlratE0pK9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6735
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
