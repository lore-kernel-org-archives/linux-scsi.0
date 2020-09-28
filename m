Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BF3C4741F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 08:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396F8207E8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 08:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="K7Pqua3s";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="L7RsulsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgI1I0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 04:26:25 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:15045 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgI1I0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Sep 2020 04:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601281739; x=1632817739;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=K7Pqua3sGo3vG3nNGQE7X1x5Ql/vXIEStvIS/KZaG66eA+dmaJzI/irU
   ilco0YY+daUHqf/zuPPURbmC/Exx/haQY4RCcTWPoV8WfZPLs/xn7YFaF
   0K7Adib01my1YX9VU3+RR6murhcd5PnDPvRur61a6LLUJdhr7YdkuQlWs
   ohSRvO93L5i9i3UsUiMuYg6SzeUJahaxjYIqN2CgL155a2qymmmnMN/sh
   ZmhQbGp/ycehN+TccjpRVmQR7Az3BhoM+31yOd04uQ0ZU/fvslfmQhJez
   0ZUvwWc/0z7RTkB1nzTwZj3ywvoeiRMsn2HRODJm+z4E66z/qfjSRMfvS
   g==;
IronPort-SDR: CjZ2fRviJ5GkYAMd86MiMmZCWxxskKh58jKt3TYBvIUSFXy8eHYNq41+IYWTQ+6mwh4ieinO8X
 gUxezpRjeoc5SoWXms/h+Sadl4A9x1211VPHD8Exb6ZNlBTN6rItLFOeJyeGZy+LlLt6lycIw/
 b8qctkNWmNgMSyN9fODlXLcvLkp9Y/3buobpO7ydOnPi1xlW5guMO8ELQp1pXt0Pu7iGDdOo4K
 DTdM08P0dBEilDj56xjiMDk4BMgpzql8LMBl2K+i0wl068W/7Fny5G6YnzxdCAjYHCD5h4Ywi3
 Mmo=
X-IronPort-AV: E=Sophos;i="5.77,313,1596470400"; 
   d="scan'208";a="251819125"
Received: from mail-bn8nam08lp2045.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
  by ob1.hgst.iphmx.com with ESMTP; 28 Sep 2020 16:28:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODx2oXhuo8ESwOGm5urNVQQTIKcpZ+SuROBK18OC62YnoQubTUEjyWeyTrjpCSYnO8TP/6JU4Msg98PbGI2f95Azexaqfj3IXuC6TKhOJiH7BJXUgfahLOiViKGTE/vhbYnZg+HztFFoVm7OMbahSA95hjhhTgGSAtcZhuCc0FUifc8xn/aXiGowjE7rH3Zh5xgoc4cDyBHROytp3jWuD/fDxucVGsUeqtVkq6WqsK8gtslkKwD76WuXllauQNllZo0L7LNmw6EUByM2DY335UPc+ZtWOy4/okGBE1NVe5s57zVn9awX2QIrXlaKvLZiTbM1QdVvh1arMzbO2BCeWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=WfraheYDEwm54+RFIK12UPN94Q7eAmREcd1ET6DbjaHiHQ/qqcOi7/b9KPO2ol/TmbVWO8bDsAvRHBL7wa3cygDWFZ4ym/RaUKCFtt8eznc0ZYTEP1/jshtQU1zcsebRsTzSTzk1OJA5TyN3XEVR4HE1REi1dWybwRUdWPt62BJJvqXCAP/R2Q0y+hP6sovQjXOaTm7Wok+CRtbWD7YKx7jyZL2ByKETPZheEfvuyW8Dx//7uC5rVzjfwL5E/7zHdVIClFNdTmTy6aK5/2gr/totf6c3YusxLRaTCNx89qOwJkacHdLAoQCFoTOTgiwCNXPK6W9ozdPJ2IFMDLtdEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=L7RsulsXwmIAO3Gbowc5ZI6qyB6+nIsl/nQ7Vf6QtZD2L8g/5hZbk9XySEUvWC/ap516hc0YewvuyDlQK0KLfeVEMHyhkVM5X3/Ge2BxP4krefOZ4tdInhzjmQPlxvf+tyQ6lQHDwcRPc3ZcQCGVQdqSAwFP/unAuQQGUB8vC5g=
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com (2603:10b6:4:7e::15)
 by DM6PR04MB6412.namprd04.prod.outlook.com (2603:10b6:5:1ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Mon, 28 Sep
 2020 08:26:20 +0000
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::7036:fd5b:a165:9089]) by DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::7036:fd5b:a165:9089%7]) with mapi id 15.20.3412.026; Mon, 28 Sep 2020
 08:26:20 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Keith Busch <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>, Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 3/3] scsi: handle zone resources errors
Thread-Topic: [PATCHv4 3/3] scsi: handle zone resources errors
Thread-Index: AQHWkrTLQ1SQ/EoaikqEhaa+rIyZYQ==
Date:   Mon, 28 Sep 2020 08:26:20 +0000
Message-ID: <DM5PR0401MB35912C3AF49550330AF4E6559B350@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200924205330.4043232-1-kbusch@kernel.org>
 <20200924205330.4043232-4-kbusch@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1460:3d01:dd62:96c5:79f:bf52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2e6fab53-5d78-46f5-1849-08d863882d6c
x-ms-traffictypediagnostic: DM6PR04MB6412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB64121C5F6782F66BD32F640C9B350@DM6PR04MB6412.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Evz8KiukbdEzHhJxs5DAbw3TERIOARJDyuM6492QSBe+cwhHPcuaWvWEnP+f/9T8YVhKpO2xs4YdRmBJRM2f8R7mgffjga/W1mYkTG+4a1XLZ504IisRfZlXfmoDQisibwcdqvN2Eq+sW3obZkssa+wWEKxf8AD0qEzZ+5gWakRSjenvlJEUKWFyeo9GYuPLiZerjgUZgaKbOmUX5JK+zU8IPv/t2XGRzdEkqHBU+cjocA1voio8Ll8S+vyhqrX9brPAX5oH4FAQb02wgNfRqpqUynjO9syLqGfB4omDwh8rWWqenbsM1cLhuBw9S5ZnYLOnjespkWv7isPrPUHmT1VosAnoAx+fWysrf5FqSBJSBmNXZvpsvBby+BQE6pUf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0401MB3591.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(5660300002)(71200400001)(52536014)(7696005)(91956017)(8676002)(64756008)(66446008)(76116006)(66946007)(558084003)(55016002)(478600001)(66476007)(66556008)(86362001)(9686003)(19618925003)(110136005)(316002)(54906003)(2906002)(186003)(8936002)(6506007)(4326008)(33656002)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wPshS4Xj9nLvTT2ENq2lr1f7bDeb7W9AknQRbmK0owXbBeMEizzgnBGvnRuG37OXJhqSI9OGD9GpDXP74PGVxsHgGchRj6q5H4ULO9knNInSMcZLKqNGi5hlD62zMjw3n+ZRFjhPbZxMa8LMaG3pTEHf+upSs3rbPoucJ7/gIOxIFrAdziHtInWELiIfZM14Ozv7Vv//AOBhm7uyNj6Gm6TdmOQV+bDd8c2RKnZHV8LxcWokQ2t6jil6SzT68jfLCxBcHfi/KqofqkvhczAnh26AoV4eCmLPluoEWdyvf5L0i3QO9FhHjeo6p07VXb8MxaytGw57ljIP14y8Mco4IhpUTO9axBKqKGwkgf1hgYsjZkh28h7WYcTaIiXSMZMTTaFAF+zGczpAxujgiiNmyv5rDHOI9M2Hp1NRrmWEflW5PMYsMNGHDWeHeyvcLc8LMu3z2RcCBknHuHzCFA5XqyUgYsmPi9GASR4oJSTnb4CazG5fReNNfch77XWrFSrn3z4/J6ojmfM9sNMuuepHWZiL93MUcUuuKCNZGw9M8iT89mYWK3yMJ9vm32g11KtS0sfvvyDcD1FlmH3Yco4fLZuZJ7hPRua6Js9BFzG7rthDflZ5SPfn08N6YWk6pJ0nzvyyGv6uP3nD1KJI6T8hM9k8LL90NdPCO9woYLPDvpNWeI3rLxPwDPr98x+QP0KroxQ/vDk18/0G0apo+so+CQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0401MB3591.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6fab53-5d78-46f5-1849-08d863882d6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 08:26:20.0766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r4T5Sn+sThn5yT4g2T7bZyy2tzW8aH7Ik0dKyiXEva8LYwCBCV/0z/GuJ8AnY4uWSZ/xI3ia5+1J7A1f0InpUuCPOdnaxDTXpNnt7u4Uaow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6412
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
