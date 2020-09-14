Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9A6C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 23:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1DF82193E
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 23:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VWIYFrV0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ENd6lgXr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgINX06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 19:26:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:16399 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbgINX0z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 19:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600126016; x=1631662016;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ThS0bbPrJUkkRl8xIG9xN2JkPOVtqz+686v78VwK8e8=;
  b=VWIYFrV0Sk0/gRbbltNHBViKUH7Kt/h9jRmjd7iqqFCPTt3UHW8txFUS
   0xk+KmQMjwz86cNiEGCH9VdrUq2jAGJjfspoIfjMFj1EFekxhsW/0P40H
   Dqe5bY9x6bc6Ty0OYb5wbwSJHTcU2dc783/GH3Obxzi7AqSQFeQpTItOn
   cjFTt36anuRuO20w5ewgOwBDZHMnJVJiyts1UWelnHH/SbiNK7a2jkzc5
   tLL1uVv45a4uE9S863wio74mE+d4eSoQul8V6c18SnNruDdj+98Sfrvjt
   Dn3pcg35Wxt4Jrlf4gHPpcRF1zOhKxKGUqzMXshEOp1nQDnuzF4hzZwNy
   Q==;
IronPort-SDR: fSqBlPOmPvQEo6NG1bfICC50C50tv2kgZZvNYqIAGN+X85HRYuvg94YztUJToTa7r1kvNvRaUA
 r4syCVgohoCEmbeGM4b1eIEl8xGE9ifr3PqEQmboHG/NtrLOHo94g7mFWAO5RwgGb2EWrg9nvB
 yzwRdREASPl2hDi703h4BAoGmgDo5juuNfT/joHYXWDwTfHNjmU1NOWJPc2A/agFvj6LMF/WOl
 iIZP9g7ZYp/zcGsWiATuzzbz4LSHZceSQ9DBloOvRPS7cSmOeTHDdJJl08CW6VqjItMpB6mMJ4
 7YU=
X-IronPort-AV: E=Sophos;i="5.76,427,1592841600"; 
   d="scan'208";a="148588180"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 07:26:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YU/BusqN6xhIATQTYjl83PKief0CZ/xXZPoyEcgJXgY1MOEM9cWhTFWBk8EffX3X1kYfN5cUK6X+xzae6G+ZmRwsumvI4Ggt9Pb27Cvw4HGbjDeEiddXqihrDljHkFK3rceiCKOw+oQGFz+prYttNl8e0tyO3FMzY8l3gMRaeUps/rVXDE2xmCsgJQyRdb2TE11pMu4PTmgJOUTioxwF4K3ZPVllqHwLPADSpn+u8nerd5eLD8ifI11Wt0C3c0LWpRIwjMAmKV26Mxcczk8yxdCcPN2fgPtcQdqdRWFH/Pt0knc7ZX/45itL3rhMq87hoOaWgLTEp1dMAvaX5BYmgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzKbayRPs18oR+jb803Y6m5Df4jbl1yA7T0/hvelJm4=;
 b=HjIuSypZGMcm31/ubNR2Mjt90kWulOu/TzEjNIM+KPIYXx79mmpMeRkDRDCpQ8zS5bPLwd6DpqeDFEhiFIufgPkttweLWmt9OrZM707N8bPlI6AJYZMKegzl5eeBEFZyHSZSCL7Bcz5XiB3LkyIXOtg/qw8EuzqTyM6EYwwHQTudtB5sFZ2DTJedd2GeupsYCDFw6D6ivRxYP9LguPwLzLcwb+5Lz4evIkZQLI1aQ7m/hTcod5YK4T2/WPLTP/D7ZLXmM+n7zLUxGbNVUcOYj3wonhL1QLD64K+J5/SRiKf3NbPhZr09V3bbDyYLg4lrUseWbHPg+qXljK8PUHd0zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzKbayRPs18oR+jb803Y6m5Df4jbl1yA7T0/hvelJm4=;
 b=ENd6lgXroF/3UkQcXgjNgIW/DnO+rYKS4OLGbj2MY4mS+cZux0WgJEjPLvlRsgUkXUfgrQVO1eMm8IT9X5XQ/VPIYYL/T2Y7Hc9hp5I3aOJnAFZwvpH0P6bmnd8R/BlTgfXDYFSY9zHewDZ9ekWXXttvrijdZQvb5odb/Y3/wZE=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3588.namprd04.prod.outlook.com (2603:10b6:910:90::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.19; Mon, 14 Sep
 2020 23:26:52 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 23:26:52 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Topic: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Index: AQHWii7iTImXf29o1UGELyu7sFgFmg==
Date:   Mon, 14 Sep 2020 23:26:52 +0000
Message-ID: <CY4PR04MB37511EBECA19B80C57FC459EE7230@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200914003448.471624-1-damien.lemoal@wdc.com>
 <20200914003448.471624-2-damien.lemoal@wdc.com>
 <20200914072034.GA25808@infradead.org>
 <CY4PR04MB3751877C568C7F8B3E458960E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200914142011.GA30097@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:f58c:fb44:b59e:e65e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: caee3350-8d10-4aab-c738-08d85905a989
x-ms-traffictypediagnostic: CY4PR0401MB3588:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR0401MB35889B8DD7345ABDDD8637CBE7230@CY4PR0401MB3588.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ebjbNVd7iwwLPr2sDmWEVxP65VggnbC6RsSSAi6kl7FOyz0pUTK9m3xKED64FoyVQ7gPoMlE4TEbGu0mNxxVKG/2QiZqAIlosjLeVeWYkTStyJNoKk+aW6DH9y2ZQT/sg5qcGRLUplOne28B7O0ZWiyywwaOKj/0rqocbbnfDw2QxaR5MINZyxTP+WAnQFQyDQUYRIcAtrq/5NIXTF1p1uuE5Ois8XHRiaRPazI/8o+PIOJ6TXFxblNGoGvfEr0DHjlK8Ss0cVOXEYRlase7Bm/YcudKPwUhWN8Wntp03OuZuvzEerJM683FtBNXk8HBzAprz1RYqZNnCIvriEWsVIrY7UZBdmZveZOTDlQn451Z2hBml3N5AWAWKOtxsjp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(66446008)(478600001)(7696005)(71200400001)(6506007)(53546011)(54906003)(316002)(4326008)(186003)(4744005)(86362001)(9686003)(55016002)(6916009)(8676002)(2906002)(33656002)(64756008)(66556008)(66476007)(91956017)(66946007)(76116006)(52536014)(5660300002)(8936002)(3714002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1tQ0R2b2IJy/z3e1aFuA1eRoJwYD4/7DuckcFD8yK6Ms6DSFVgKUlzMiDayJA2Ih8ZvxajEMYQaWS//mdg5iio5sl3qv0EQCNLV0tEKhXo3hoPUxICacli/aD5WNBLS9s8CR6uPCoLBQfQYg/695UoVvmayFGTQXr2JWz67tm2B4INdOHEy+zifgR892akvhkWfk4AHbEGkGp9/oobFJnPj8UPo2Yct2MTrm95aXu6D2gAZBkFB1QrlK0AZ1Evd+Ean72OgAIojQlQZ35Jox3tdaEJM5nxgm/FIyZb1BZ1+OE6U1APjyVAENPrkC5hO4uKov37kUGcDLnsGs1XRlcQFEu/h0GtfjQ5+7N81CfuaqA0bfcXX9idee8FWRIhEChXqviF/2K+OAPBkLUIoBwr7IV3GEqFojvv6pU1U9eOAihsMKOMR7o0/F4O53tU4rJXPcZwT/zm+NClJJdK04QO5z7Xc4pfZs1tSw2ThtCJXK//qxdS9cej0+x6+BtPa0pTw8rsEKtvWlA0S0nWNq6T7XGEd1vrT4FKYWMBlrx2Lro50u3RorzBEEimqVnWT/JeLdIU51yjEw2mb5sSgUru6uI8KWDXofvOowzOOJ5FMykrz3NZ7JCOVjhoYCF7c7DTl09Fl10r+I25nUeCxt6V6qIFudXXSfHuPmdfKlK0sF2KvaTmMRa/9Y7rTDOquA7BZ0aHnP5DSF6set3H1U5g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caee3350-8d10-4aab-c738-08d85905a989
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 23:26:52.5833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4VyxjMk2pDbf4IH7DE70ihn7TK0ijEreEkzYlvVFEWVAj9i2g+HLfovof05Tj52pNF0YzIOJpNq9PVuZ1aispw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3588
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/14 23:20, hch@infradead.org wrote:=0A=
> On Mon, Sep 14, 2020 at 09:03:49AM +0000, Damien Le Moal wrote:=0A=
>> Yes, that's nice. Will send something along these lines. But since this =
is a bug=0A=
>> fix for the current cycle & stable, we probably should keep the patch as=
 is and=0A=
>> add the improvement on top for 5.10, no ?=0A=
> =0A=
> I'd much rather also add the trivial helper for 5.9 - otherwise we'll=0A=
> need to pull current mainline into the for-5.10 tree and create=0A=
> all kinds of mess.  And just adding the helper and using it for sd=0A=
> only will have no side effects elsewhere.=0A=
> =0A=
=0A=
OK. Sending a v3 with this added.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
