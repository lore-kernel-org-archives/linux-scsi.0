Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8683C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1528206E2
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 06:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Emkqrh5v";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="gG07h0Cv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgGHGgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 02:36:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21441 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbgGHGgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 02:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594190168; x=1625726168;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3CH9GdHU3s1QUBcxBk3cYEQamiPDgJXuZ3YV/4Ia0Xs=;
  b=Emkqrh5vZCdA09jRcE4rPw5J8qfVe+OjrcNt3bDQnKTmjCvc49ndp5Cc
   EDRHp8DaACvChSjAywQ2PvH+c05EFh34hNzSqvh4L3nVXzzR35xE8vHqY
   0Ibdcvbkwx9QtU9ykMU3g+jf0pmaARR7PCqnFiCqpB/zw6WSffvtBbTaP
   wgR7SJpll7WBDHfgTk+JflCg5bMzDAWABHvFouVTTqXEBFOA6R+4z8cZQ
   wt/rTBgN2+8agcxc/OcqCbbVSv3xdJEVqx8Y6jrsjUDCiiPdEa/1DYLJD
   ge23pwo1RlMIyGpMND9OO/2oZ94gXKe46/q6TCqzLAglbgSD8WYHqL2Fr
   Q==;
IronPort-SDR: Km1a8iNnYWsvp9wwL0bdgQFjuZdB1F8YVOiM9v/PnuzQcLm1xUhwLPwQGDRMAumZgEa2X12N1c
 hq5C3oaLDh3JCCCqHhcaLu9LokbhGnKDOBKSqWCvuJ5NRTGGnAbY//4J9f8eQjdZuaapEWeTWp
 AcG5bGIoub6O4E2VpXiZZGU5NIe9t71g0GJVIzMFdAYgboCUWu3XexkpbW1p75OEE8OTy8Cuf7
 Tb2i6bCDxo4ZuV9jj0Gwk1Q5B6nR2vVnQguRzvnyzb8r+wdGId8AVIgmQrXE8FhCGztoWIHRPD
 lsM=
X-IronPort-AV: E=Sophos;i="5.75,326,1589212800"; 
   d="scan'208";a="142071008"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 14:36:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OngMrCYrz8Xo2NbBYNW7ON/jJKgRZ7cpcB4VVc8YeJ4i9Q4xNIoOqs8J0fPByYmrcb7QOaL9ZX6l99dNbx4RpsrkiVWI4HNMd5WKR9/ZF+J5J2I3Sa2ffmlkkexQUip9xUdg0r6ngOmuC5KIDpSLw7LqI6d4u172K9ePjQGateXw5pJfCQ1NH4zGhuc1fUXwMtCDvyGrbW/+OubTzRsY/kKkMRIMCPewYuD3s+Pe3iVhyFMcIyCELHaXBBjYvr2GNzoBOZvI7adfKbGDvOoSwjD10cn9Caz5FuomzeCFvjJQZWgpquYMK17Z7rbwPMQ0mntvG9CL5WcHBiKkBxaplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CH9GdHU3s1QUBcxBk3cYEQamiPDgJXuZ3YV/4Ia0Xs=;
 b=dlKJPqznsp9w2Enfvr26QrKg7bem78F1/KVdFM3GuWrF3MvpWr/WpvptxN6Ct6GmDYilwdWjcEEXUillDUPPQL4ZvSSECRhMtaRqZa1QmADI0pY9ifcojnoS8OCSy57EKCLCz1yyHDfAgY0v+5iTBqlvlyI6r39RIzOGOkPCLhu7hFHYY/eKafRio4kbxHc2DkxpfIgar2co57tpa3TRNeATLk8WUDGrWgJPy+Ia1MwEGjhzHiGvw/SFVhpp3e2EpEixp8dmbfRk9C7OHAesnv3wQgpmz6vLNeHG8nNCs/tFN/Kxp9rGmA0eu92n4yyXfgfosWWFHdExlJvYs6iBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CH9GdHU3s1QUBcxBk3cYEQamiPDgJXuZ3YV/4Ia0Xs=;
 b=gG07h0Cv/UWh4j7E8RWaR8NvZh4P4Imu6+Yic8clAsiIv3z1Mp6CEEWzW1AJhslHCpmKGamz1Z/dFcoNL7T5GNnCjguSU0eZZsvhHFgtsfKcYuXFkpW0GoVg6pTpokOr1KHNC2FFbbR3+7hBXh0LQGITZcQfCelk7OY02P3tL7E=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3585.namprd04.prod.outlook.com (2603:10b6:910:8a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Wed, 8 Jul
 2020 06:36:07 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Wed, 8 Jul 2020
 06:36:07 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH] Fix compilation warnings
Thread-Topic: [PATCH] Fix compilation warnings
Thread-Index: AQHWVO6lyTJEF+xa70ydBmVTw6k6yQ==
Date:   Wed, 8 Jul 2020 06:36:07 +0000
Message-ID: <CY4PR04MB37518ABAB2C3A0B33C4A5EC6E7670@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200706123344.451738-1-damien.lemoal@wdc.com>
 <159418844430.5433.1895709179695846503.b4-ty@oracle.com>
 <CY4PR04MB37514AB91F1C8EFF3411AA2AE7670@CY4PR04MB3751.namprd04.prod.outlook.com>
 <yq15zay1pvi.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7abd28e-ce7f-42db-5942-08d82309320a
x-ms-traffictypediagnostic: CY4PR0401MB3585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR0401MB358519660E7C77CFCBCEE4A6E7670@CY4PR0401MB3585.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:862;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XBnCzbRaq2Q/DeppigFfF0CjYhQwz2OjL7zf9DUfh6+GCsKAZbp/lZzsdaOUh7AdfVmGbfBIxiwVyBeio2efgdTzkylE4fwcNiBEbsGLvnQcokQWNFw2Z/PhHrafGFzpNNhrgv31qcoQA1ON/K0xcs2QqL+Xhs2JRMeC81A8HJVg+PaQyeeutTNdnKuuNVyVxQjlotQfU98BTPNKuHbpBVrLZpgCItisvBafbl3cS7elubMkXZbkwk/LYt3ng62Qca9e+U+HE9SYU1hLsVeUVTa/0x7r+nvuCDL90CSJfc+xsdOW3i7c7oTNCmCTtZJS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(7696005)(71200400001)(4326008)(66556008)(66476007)(6506007)(91956017)(53546011)(64756008)(478600001)(66446008)(66946007)(76116006)(26005)(55016002)(6916009)(8936002)(54906003)(316002)(8676002)(5660300002)(186003)(86362001)(4744005)(9686003)(33656002)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 24D1NSqevyKcgM8mXHUvo7el8pOu94MaN4cJdefNxGmd21B0U2UbnimFsO44g1UrlVlbFxRI7Rv/Ajrl+AyyntIkOzSM7XBojyVt6/fGAaQ5bjSApCiKf5wujlT+kNGT1pTsHPO2szzhNloj1zGpUvTH1YDfXgWqIkNLHkWBYSjY/oiZqcQF4BhDISCKvsr2Gqpda5oE5byBkvIC5Bzpm1Pj9oMHeDaZesUaprGRI/G6hQA40qguyouNcq+Pc+VgOkiAK/OcQE/3AoRoLEmhw5Qc155L660reZyP1jEg8HCTPJ3lBbZEdV4jEUXbIxdnGqCCBWygUKP3lnbu1bRRhLQU5m83m4VwV4dxBBb4jCfEqM+kmmKwQM7VcOjKycjmrMwvNlR/PIVW4GKbxwlPShP3NBJUmYlj4B3Uev5foLL0bKM1WfgdgQFuQcS8zyYkBYXYOmqvFPM9GevapBeFfRNIzxLvTcMBOW20miCpNHDPknnxG5JqaGVoi6F2LHZK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7abd28e-ce7f-42db-5942-08d82309320a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 06:36:07.2562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zCb5yVOdbGW0oaFe2oR3oePKKLVu4HunzUqGKOvWGSBHLsszaxBvSxFUKa9gUolZeCPLY9DNUxwmaEparrwLMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3585
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/08 15:33, Martin K. Petersen wrote:=0A=
> =0A=
> Damien,=0A=
> =0A=
>> By the way, the patch mentioned above is not part of that series and=0A=
>> should go in 5.8/scsi-fixes, no ?=0A=
> =0A=
> Oh, sorry. I replied to the wrong ty email.=0A=
=0A=
I thought so :)=0A=
=0A=
> =0A=
> I amended the offending mpt3sas commit in 5.8/scsi-fixes.=0A=
=0A=
Thanks !=0A=
=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
