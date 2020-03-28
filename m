Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0B0C2D0E8
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D62420BED
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 08:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DrAxXdbK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="h0S0q03s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgC1I1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 04:27:12 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:9151 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgC1I1L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 04:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585384031; x=1616920031;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=cNEol3kBvxPmNUZryim5bDRMzWXUZwHhY7+F2Yv+VBg=;
  b=DrAxXdbK8CP+2j7PIeRtCPYUamSkz6vXi4IAq0PVegbHYE6UoHpFGmcz
   G98fDD/P1YlxycMLEkdg9Izf3t2hUe2/1xYen1ahfX3DfHnfLvSV/IESA
   Q0VnXbuWe0Yta2E8RFNTNUkItzFBbVpY6oYtd3uyPZFu5+zOOgxasW0em
   4rv6YKcoegMcqpZn7xUX6GYk0EgdfXHjyNvQ5NgfU37eTMi35v7ZnLlo5
   Bhiv+9+LyZ3TBJdyCbOIID8g2S7Y3mDNy9EoFjosVpdnAoV4yXT/OO2hj
   g/vyZEWjjrWK3MdrzJSrq8q4U4XLWE2E1xFBBPbdQDnwZfYx50R2PaOn+
   w==;
IronPort-SDR: 9R7yqZeIZnCavQxWVz/LdSMQW2ou6kR03CeZ3CsGchbsF/11I9GBwGwDpYauGkT5h9YOVA9wQA
 EAnmHotpJflNSkkHuof+D0/mJnjXhJ6ZZguW9CTm9cChcIsue7AXiWjiEfxSFoorAd8IOJ9+4A
 73cPviGf4x4rZxygoiS1Gzy5MehkQ2jge3og4xHDt/uRbjEEt0spzBoolhsX7BHSB3dabnrAuO
 /soE4nVay+LFvS9qPlECZ23lY61eHcW9eo3SC8oi+tRnNCqyV9yQKG3Exb7PQZ+XX1+Eyb3XGH
 cv8=
X-IronPort-AV: E=Sophos;i="5.72,315,1580745600"; 
   d="scan'208";a="133744808"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2020 16:27:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHvRiuQOizbtwU5AOO6TGl0IWPSDsMgL2RgVji4Jbqyd4c2wZ3V2t+6MmzHhnTcYEg+qsza8GIurrtIqbIHOJz+wVcPrrmhe2H+4tc0EBksxtN6uAdM52Q1IPWEYvVpzhGB81QXv4GyA1W+i68p2eVioVv/i9nGL+EVh6P9/iSexODo7ZRoMqdASl1oUToNieD7/sVWyzdTgGmUnBbDBG1ojNENdo3MSU4OMYoiWcQPrrAAAlHhX6iZNTtCekiYwr9wM52TNrp7oOdzOyjRVbzvOhtPEykX0ySP2MOddPgLN9x7XJJN1xfPaiJbMgLfuIfc5TFcMwgfOd1sQ7FqZWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEa4y2PKv1T15AecSBDEFZlp06qGb+NTirJwPS2FFeM=;
 b=UwIn/sV62e5stKr1xoAavOCohuEEJJxm/r/PIG7xLZlhxOPD9t8y9Bu3BtqVZo+3IHudj8L4+y8I1Nro0PbMfGGn5dRjaPi8ZuklwaitbtGBIEIypRp3OJihh5n20QsAdc13e4h0TPfckJuYvgGVl6XbMvXECfv/44LACwsNGD/uGpgYFCd5XRhKli4bzDaaM1LkOADc3OAROzaCS58wcP8hnQAY//QzJGPJ7KY1ocRBQ7LRsjpyxryElP8I27uAI0ofDlnXsgOAG7pMbIjjRZTxkvIZz3Woi3bGIObsKHfQk/NriVhIxTN9bnm5lfHucCHFpQuwmJIE2g2k8p4zBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEa4y2PKv1T15AecSBDEFZlp06qGb+NTirJwPS2FFeM=;
 b=h0S0q03sg3rPxg1PQzjkf9TJ3U/fGg24+zuEHUyOr8blnx23jRnk5+qQZiJ8h9ekrELmOjPok7T/i7LLMUprex3f7fpwsabsoAOiIUcObQEsbbI9IiKd9rdDpx4c1uUWyf9H1u+B+SncDfYJ+4M8LZ+z49yE3oqf1OxJyZ1VrUQ=
Received: from CO2PR04MB2343.namprd04.prod.outlook.com (2603:10b6:102:12::9)
 by CO2PR04MB2295.namprd04.prod.outlook.com (2603:10b6:102:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18; Sat, 28 Mar
 2020 08:27:09 +0000
Received: from CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b]) by CO2PR04MB2343.namprd04.prod.outlook.com
 ([fe80::c1a:6c0f:8207:580b%7]) with mapi id 15.20.2835.023; Sat, 28 Mar 2020
 08:27:09 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: all zones zone management operations
Thread-Topic: [PATCH] block: all zones zone management operations
Thread-Index: AQHWAydCbik6RfBk9kK4q1a4/Owqqw==
Date:   Sat, 28 Mar 2020 08:27:09 +0000
Message-ID: <CO2PR04MB234357A7ED343AD22375CD00E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200326043012.600187-1-damien.lemoal@wdc.com>
 <20200326072800.GA21082@infradead.org>
 <CO2PR04MB23433C37660B9A8B53D95790E7CF0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200326093049.GB6478@infradead.org>
 <CO2PR04MB234368B6701C041B292DC872E7CD0@CO2PR04MB2343.namprd04.prod.outlook.com>
 <20200328082211.GA32518@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ec925aa-459d-48ed-7027-08d7d2f1cea3
x-ms-traffictypediagnostic: CO2PR04MB2295:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <CO2PR04MB229544DDC69A9E65538DBEC3E7CD0@CO2PR04MB2295.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03569407CC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO2PR04MB2343.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(71200400001)(26005)(66446008)(86362001)(54906003)(66946007)(186003)(52536014)(66556008)(66476007)(91956017)(5660300002)(4326008)(64756008)(316002)(76116006)(55016002)(6506007)(8936002)(33656002)(478600001)(9686003)(7696005)(81166006)(81156014)(6916009)(4744005)(8676002)(2906002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N1I1VQ8VCg+xVJLjdO00ogEofcTQUyFldo9+dfuFPL+ZWShX7JgNzLSQC+XQ/Oft7RibiHVyAIPfNjjA57Uz+3Iv3CIh5PN8FqEwL5971CM0B5XX0eyxLJB3BbQ3wuctUE5oR6uthLZVy3sZvIE+d3tv3y5BaMDh20zoYDwNJ+crQudDiYd2ZX8ABFZi3Gj3K9wEaoN9DHZ88r/viKEDNS/tXLHqmVIRYwiLAhC2P8yEg3km4r4fsZxk4hpv0jBWZ/W30prL7rLtwH6ABa8Q8VDAwny3h7gdSIat+ZX2HXu00vVAU5ewsWAZV3PoGa9avgNGkWCDGYUPgegWy0ZhlK5fZfMdliISrHrqRDCb4FfQfD9Ys8bBNz1hCyI2n23uzIgKtmVIObwXgZUk/x7rD5R3kvrMD8zzGthcBplezRKhev6Ax6ZOxSs5bXV9ddSb
x-ms-exchange-antispam-messagedata: xYcnpNkrsP1kdfM7AfTsIZx3jPV5DvYrkbux7kVwW4wJS+QZou/TdCcY+dffeY9YOiF8jYSe6UqSAH/VlEJKbL3la2stKlrRj/mQgdcquXk31B3giHVDeMIqOd5CjtM/J5fc6Bo+RsKiU571x24DZg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec925aa-459d-48ed-7027-08d7d2f1cea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2020 08:27:09.0723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jVYa5ybr4Oxs/YJznUHuU4Lg9Mhuc8kpGxYLmnwzcZWieeL3F25Z0IIHanHJyzbSDgSetA7/eDX4CG6nDYaaTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2295
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/03/28 17:22, hch@infradead.org wrote:=0A=
> On Sat, Mar 28, 2020 at 08:13:26AM +0000, Damien Le Moal wrote:=0A=
>> In any case, I think that the patch has value as a nice cleanup of the r=
eset vs=0A=
>> reset all request operations (the latter going away). The side effect of=
 it=0A=
>> being that open/close/finish all come for free with it. I would like to =
get it=0A=
>> in just for this nice cleanup.=0A=
> =0A=
> Well, this keeps about the same amount of core code (and I'm not sure=0A=
> it really is cleaner) while adding significantly more code in sd and=0A=
> null_blk.  Not my classic definition of a cleanup.=0A=
=0A=
sd is simplified (one less argument for setup of zone mgmt commands). But y=
es,=0A=
agreed that null_blk does need more code.=0A=
=0A=
OK. Let's drop this for now then.=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
