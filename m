Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1427DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiECPrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbiECPrI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:47:08 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94842E082
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 08:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651592611; x=1683128611;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=epHSiszGX9o7yNqFFOg6IP9Igp22JX7pEpf5Vr4e4p/fS6WwrucbfX3E
   g0O5VmgozA4fvma4VySSybdUb130BFQhrSWCOcwzKQYNf/GTJsV29Ec+7
   f4iJcVRG0h6MhdzpAseenF7e6KpSlipC/aSPope7gYjaaLeHoy2/rnKLM
   rIJfMhF6T6v4q1iroZ9q7hmwiCTX6waMKsAH846UKlBqHquWYtETFWpF0
   FUyFiMLTHCNQ490hYSS1+3+h5KalsQbWnPtZSkqil5IuX3qDn1HhFxsOt
   UvfkkzuPMCD/3awDjxYL3lTiyVyMFJ/pKzIKSskHgrhXtJPcuZpkKhvN/
   A==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="204299717"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 23:43:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+GjN+sCUBnEmYBuvJ3g6UebmnHSEgpr2u4GCy3BTuvu7teQpJMbraxIDfqZ7oW/BuUvEcHd0qpcr90CFJyXjwc+ksmXLlU9u5cJMqh4LgSLq33rR3wwqrBw/Vkv4uCk22ilyL5GAPsiZnJWx86YAv+/qRr6ltPrNYvWOdZ85txQaPlj94Z0lzveIQtEq0alOYn8hkIEoQjLCJ7SsornrvPUG4ODC4tSklrc7v6Uy6mdqKPLGNgC27lO65QLlT8Qm2x7Wc8c/Q9fjH2sNzf5ty9R27TpAoKeZkpzI05ZYTFlSX9rsI4u612MA8Dvoa7+wv1GaWtX6gGmwxlKuhLhiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=newqlOV6KpR2nOJLy8BXFO0PbGv0hJE+y2GS+CHYiUUj+LtotnnCq1pM4PcGGokxO3K45IMhVUI5RFuSXmhcaMOeA4yDu3Oj1Sx/5gcsSpDZs5ZkDKxPpQMbw8nYC2y0VgCRdt4yyT+k6Y35SdvaqAVLc7MeUJVO/ui03hdQF6YpX7T6M6TAoVr++TK5+6HNutL/bq1s+e4hwHGw/aBx7QCt5Y3Vmi2/MfNRUYZrrdP9DqARJbPk4qC4Yg0aHxkVgUMTMIY2ktAncu8S80vPbDXkU9wbkkqw6OfOWIjxaYCjmEdP6arNpcXf5nH2Lp01xrmWME3N6QU/SMQmceJvhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=RpZhrRcWTNML9w8xuT8BB2hmTxSroKBzXv2JGGvKG+clq17iFj0g0eqMWPwOtYABM3nXEhzAAbfftP3X3LT3g5msSa3IyP3Zkm1aXyKZ5lFdV0CMK7ty7tFCBnpsNNUMNGTvEbk3ff3FDf6lorY++615xyh1hdsVGsr3osULf8o=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN6PR04MB0373.namprd04.prod.outlook.com (2603:10b6:404:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 15:43:23 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 15:43:23 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: Re: [PATCH 21/24] ips: Do not try to abort command from host reset
Thread-Topic: [PATCH 21/24] ips: Do not try to abort command from host reset
Thread-Index: AQHYXm0w4yqL6B1ALU+oKnV5muw15g==
Date:   Tue, 3 May 2022 15:43:23 +0000
Message-ID: <PH0PR04MB7416CAADC0BF037F853CB4A29BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-22-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8cc3ae1-341e-41c2-f1fa-08da2d1ba818
x-ms-traffictypediagnostic: BN6PR04MB0373:EE_
x-microsoft-antispam-prvs: <BN6PR04MB03739C36EC7A507326E7CF389BC09@BN6PR04MB0373.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3yWby0u6+0bUexTTOupRfdkjmXl3/7T9aFtiVy9AFZ8bbriLECEWLfX3+17eeD4iSD7k82NI2liq0ttRjoRsN/U4rdC2Rafc7GlUa02/B8pPM8/uclsf8CEw84G2sm+dYfw+wJNsUQMdVqznWGp/0CQpnIpOtGQkD97x/usif//YT/YrnMx+zyYfIObPFhlDK5zg6J3HCzKR7E5CDPbr7L2ts1sAb2Gy4SCnwtiv9Q/8TpRjC7eclmyJ+BAktFkbzZAWa3GF6LX3HjHrhoZSL0pLFrOkqHBYs0SwIBPirpYEfM3oLNTYD5gytmQgY8VbC9PwAm5ljtgrEpgNJJ+UEX/6UhyTU6uQeLCLuV5QNYnjfUW9LO3naw4M/hYRGMqFfp7M8gd4xZCPEgTYA+X9cS+9ioRTot47wXBkfmdToDxA1fxciKaXbrXlWokML/WeBAbr+FAJadRCJu07lpRTJ4n7SUz8ajqS4AbYKiEwqIEnxcF/VlNhsMasYmTMauqN5uk8y0RZnbqd8V14SZRDlZs20JGRRFUMPgzP1auT48KMVt13Rw4F2bGP/58JpRwU50V0ztOv34z9JTB8+YGZ5MbvPPRbBcf7o+zVs3xv5KoRuh/FhCbc2JrpMeeS6dW94AWdiQBe7sVZZvCcB1pXVVVkULYsqu+r8Llptk37/1iS5qAoq6mW0fTPc3QdCLtWfRE2sHgrWMg6yL+enU4Sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(6506007)(38100700002)(38070700005)(7696005)(9686003)(86362001)(26005)(82960400001)(186003)(4270600006)(558084003)(5660300002)(66476007)(66446008)(52536014)(316002)(64756008)(33656002)(8676002)(66556008)(4326008)(66946007)(76116006)(55016003)(19618925003)(2906002)(54906003)(8936002)(71200400001)(110136005)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IEqlEAqHOXHyVf3BstetDiDc60dFlmuKYbB1xgo7zh93QfmTGaKmMC0pO2e9?=
 =?us-ascii?Q?uFTY8ppgwytuMn141AP/k19/SlJ+DI0XNtpF5i0YuRCshQAsllHDWEYp+sMM?=
 =?us-ascii?Q?C3RQxY0OAnHssJOb8HOIAxhdNqIUNcPKgjNQ3Mrdxq74g9MNA5Spjw+sfyGJ?=
 =?us-ascii?Q?E4Ophd0oFITdEswy/ca4dCrV4GtS4Cp0seTWbrbsHXggLYzGL2eMRNb0Onby?=
 =?us-ascii?Q?BlEKIdq23bklBnb8SkLGdvF3J1ZhIpiR3JF1D4eBUvIopMn5JmPhxyyQLoBF?=
 =?us-ascii?Q?maMkf4I1ZXsZMZgEXvbnNylNjFhRAAaw7g3gNG9Y8UfFtYLWovPvavS+pqyj?=
 =?us-ascii?Q?Vg1r6XRcWocTCOHrlc9VZvQHPbTPbGdXDvBXgedQ8ONeVZgXeSlq5j1SMR3P?=
 =?us-ascii?Q?QMxQX/ls2I7t2GLRijRYhycGT3NJUEwLYOdbaqQL6Jb1jrMxgaHyYU2aL1K6?=
 =?us-ascii?Q?VTJby1JVNfxnnW943DVAskwUgWdTNFRLZT+9xZL2Lph7hcCAGZxw0bQI3KUj?=
 =?us-ascii?Q?3fkQPXsAMrzkKEKYmv6bEiXTXXzIxpv5DpzC7//zzu0915RqzJNV4YT8fQhT?=
 =?us-ascii?Q?57VpzajYAzQrR7+AucqI5Yr4wlvZXvTUjuzKs9tlo9H7ySogLRQSQYbGrpMk?=
 =?us-ascii?Q?VahzNv3jugXLVorkSl6g9oQdzCbdTwYUZhXm/O1XCpmBmRw3m2vsrc2IM6Cf?=
 =?us-ascii?Q?NUvtUcsGpBR0mrc5WU0GGmeEYo49BhGpNu8Ux3QmdaLYhAdNFD1Up+gOJSza?=
 =?us-ascii?Q?QyMnW8BvJCzvDsHwm3AopWDveDHEaZ7G0An6l1HNSCQ0koi9BpPff6Et5QWU?=
 =?us-ascii?Q?Lsy1aE5t2SJUyDgWGO4I25wyH8umiV9a2lEO9Pvu5uSZ7To13LXakovibBoT?=
 =?us-ascii?Q?TGhU/o8fvPjeynwkyX8dnHRkcN8jNwqKwhnNlDn/9r3cLjIFbaGvRKx6RVPN?=
 =?us-ascii?Q?GC1P66miFKdX33rQyE3vwu6CAIxn1fv9MWetbOwBEheJ8wv/40LieBJcnYhz?=
 =?us-ascii?Q?ZHl6bBEui5h1Q4dreUyxBUypr3wDDhqUxxj3DiIO8vpHzr5mrMjgMY6FMIhR?=
 =?us-ascii?Q?IHfcxm7BwVSAgzV10T3Wq0ApegjwMjdRyM9mUFW8zBkAemkZdd4SStuFx7JV?=
 =?us-ascii?Q?XlQNbWpxLocVeop134XQ/YuceHziK0052lWRlhlePPjDEWY8HJcf1ww95FPX?=
 =?us-ascii?Q?f547x4pxQ7lMIVcieYHDEw5FunH4SqgPE5AlgeKR1TPL9yZlD0FOPaPRUcsO?=
 =?us-ascii?Q?QeiZCH6ukxiKXviSIfFbZdbgPT306CoHy3fqjo777rzSdE6A9EwBpMDaUTwE?=
 =?us-ascii?Q?F59XcxiJwV62pFGmFldMIC1GeDwKz0eFgcHwI/wYa+QDeZA69DbiDk7lTD07?=
 =?us-ascii?Q?EE1TW+QzbluVxdTimIfKLm7Xg3A4g6CNUOhZZxKA2q0bz72QIRbad3qlXqfP?=
 =?us-ascii?Q?SW3oOZ2M9it66nJMBHtnyeXn8FnmoUVeqMDYQL1mh+GtoQgaRghj03kHpdXU?=
 =?us-ascii?Q?StwxRqK97tcTUGx7xcYtE+zQLbfdy1SMqEZII8zQIrn6OnJXd6Nj47f62Rec?=
 =?us-ascii?Q?oA/mXGdvOYti/ijjA4m/aICTYKJ3GqzxqSnJol+5qBYPiCD/h9/sb9e6+niB?=
 =?us-ascii?Q?ieSRlwjdWfAcPJcgI32E+FOCadJLA691pQeBQcpv5cHzswzzsbO0WSoQrmGd?=
 =?us-ascii?Q?pCP4FAyl/PkFEJn6Ro7hqwWDG3orzIH0wbeEmMzqoKRJ1jvTA671oDADR1rY?=
 =?us-ascii?Q?QPV8RS9v8zMNJaYFoxqhshgKhET2zqZK/rpo8+T0ta8Ta61JmXxf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8cc3ae1-341e-41c2-f1fa-08da2d1ba818
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 15:43:23.3295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 239D9ucncmayYhOGi+kjZTABO5TDmbM39YtlFy0X9pO+8f9tUv/ZvPfsF88Cf6cQ0rirn02x9uqzIfXSDtDoI9SbtFzAHjv058FZMSiMXL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0373
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
