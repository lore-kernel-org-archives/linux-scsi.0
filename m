Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0887C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 12:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBAC20702
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 12:46:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fW1HUJeQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="oFmQF/xN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbgGAMqz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 08:46:55 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55392 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730388AbgGAMqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 08:46:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593607613; x=1625143613;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=PiEGYQeefs7yjvLbYJsyeSri3u0mj0PNgwaBs5s+H+M=;
  b=fW1HUJeQ9VGD/H3MqAt3nQYKXslwDEej0lyvbQAtrGTd3RPooxIGsWSj
   2v2wUWNPrISWMvmBp9+oZ1aVk2vfvvEk+vhe+ygPiNw05X7t8rUX3Nkoy
   qLD6mMAiau7ob72IPdp7afgvR7rL2eZFhtd0WIh+FanDHsLHBRnV2YzEh
   bsEQ9p9Gsp8m88UFGgGTcQRBQ2Z5eEFGE5ewo/dC4XOnSP7eodr8Tj3xG
   3f5evC0LAFVp3AnaufIAKKEB8MpDXZtGs58NXt8d+OekzkZISbV44OeGp
   jz8cq0FX6hqZDLDiQAJfXmmM5FUTOeQ0DdEmycQR4pY6VkIBcNLcEMUei
   w==;
IronPort-SDR: j7mMuxHusVV2ZKzZjNbsc0lrOUiJt/+cwLENVD3dD2f9EhqfId3iPZ0rKHddro8IZy1d0OfjIn
 PVcp2VRG0XO6Y/U9uim3Mjd3kOsRVGr/yVSDSrnzeXYQVEvJULbVGuN12Cbt/c6itnjlMYC4+X
 TrkloGNjKQm2potvmi28CKdZq0glTK/DuAKvZxtQgszhvEEc47Wx9yr0h32y+FgdSH3NIsDH5q
 JbkPwvafrTsY/hysmjqP6Fyfvf/H2JJP6eaOaLwHpol6R+W2JdgQlG9ZXoj/ta3K90NBw9whtH
 rrY=
X-IronPort-AV: E=Sophos;i="5.75,300,1589212800"; 
   d="scan'208";a="141375868"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2020 20:46:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEyNhCAVsqO1hTjFgph9fADrQbcalUmLkwHiVxAJ4k525X2EGJjCDRlxSuWNSXg6ocYHmBv9r+vbVj9xjWJXmSnBiu2Oj3LcsLWYJS7DuByw9Jhx834Xn+wONzIZf2oktIAAaeDh0GVrEhCCDFqyKBLGmjbIe2PMlyA4+T9+2cHBfpwODg4DooJ/uiD0v9v0jCY6oRxdHX+4YHDrA54IaQnN6xpDju7n9avSpIMhhWMaZTG+mEb848eSl1lH4R6rjnHJq2w2x+0LqgYegtU9q6TCGqdbiMkHmtV/j7lDQHNyNo0eBFZtbVeAy2xhym8jESM86xc7/Jol9EyIbiq9QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiEGYQeefs7yjvLbYJsyeSri3u0mj0PNgwaBs5s+H+M=;
 b=BLkB7ssUmHAG3ulTmV9NSOgaxu8oEzL5ZeDRB8qscoLfwP+dCcMzPTVV1Kqm9D56EiLOiS01wutwCQ9ufpPw5kJQpRr4cUkJyhRR+bB3pCv+DBTIkgzHEmF6f0NyTLBp1lsgAstghiaYy2UMRI8vjcgD7H5IGaJFWraf/4+Wk3wqkZ0XBV6HCfDk+vlnZBBJuVHTFkpHtmUO/mG5CenpFRyF3pGf1t0sxw/gfkySkpK8u3/2eQ7NCxiPuoyIIhSFFaGa1zLM1nR9YUK+R8NkSz4+ro4WjuJ3wB7dgPOk1S0tQv/DtBp/9jvbFA3nbjzx8BLBCDY6eh3lUbJHeW7ftg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PiEGYQeefs7yjvLbYJsyeSri3u0mj0PNgwaBs5s+H+M=;
 b=oFmQF/xNwsoE5d3G42PuU2N8q5GJUF5sIQI7L8FPdkpHfZ7FRc9KvMOY7sgPVlU4RGbxS2V2rjVqJ61B7ji/Y9g46TcL4zp4AvM1mgs06INq66zGYsMw8cepHE6hOQr8Y+tjg43s1F1SIgsJy87nU4HuLpCIvwW/PPcsx46UeP0=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4398.namprd04.prod.outlook.com
 (2603:10b6:805:32::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 12:46:50 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.028; Wed, 1 Jul 2020
 12:46:50 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Thread-Topic: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Thread-Index: AQHWT4UHyypkjO12MkqbAgkXoaoEPA==
Date:   Wed, 1 Jul 2020 12:46:50 +0000
Message-ID: <SN4PR0401MB359836FE0D11130E6735EADF9B6C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200701085254.51740-1-damien.lemoal@wdc.com>
 <SN4PR0401MB35981C2AD1B925263A35B3C59B6C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <CY4PR04MB3751466FAE8069289AA237A7E76C0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:115:56a6:c821:2683]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 26a9c39b-f5ed-4e42-1a23-08d81dbcd345
x-ms-traffictypediagnostic: SN6PR04MB4398:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB439805FA125B94D54BDB44649B6C0@SN6PR04MB4398.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g73OBCuwZgHMGYnisVTTsupUwHULIFJ8Jb0M+rssFLoW042Gqm0/inHn64TUlC6YhTuoFr0gzBuMOHx1lKwGJiEw6mJgx412rVBkT/puCoHW9mS55t8kSg4ck+ElCCa50xiNK3zC+zORqNGLCHkYTL1fa4X1dUM3rDuzmjdpCBb+HlpMUBCqgyeCqSV6rPETB2DNslGLQbkvGIYiNmVu4OQY9ipWSsIDfKP6NJ0WQgPxGsz9W7OmNQmLa5uWDWvRfqccSd+aEKnvsvJmYH29mL+J7Jl3r5zfqWQcT0YXtyZ2hkaBQqQDsYIWtpZpzk7bEFSdZdz77QFFxJIBZlXjSooXNeQ1T+1GYHCg40dAyKf6MpFJKQcP/wo6YMjRPvbz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(2906002)(55016002)(558084003)(66946007)(8936002)(52536014)(86362001)(9686003)(8676002)(64756008)(66556008)(186003)(66446008)(71200400001)(316002)(110136005)(6506007)(478600001)(33656002)(5660300002)(66476007)(76116006)(91956017)(53546011)(7696005)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OMTHIcPxz7EMaYLikdatepUcDT8xf4DRZxB4SAkivpyn5kW+4AJN0VZmP2cip2z6G89XCgOXVEM/f4RT3LVhjVS+sMK8BHvTOqxOG2Lls1QwU0fHWT7QUmUIwoACSSPCk/GSFShpPb0DIlnIZP4hpjUKbiLAoBnjWI4vgRWPjc7acgjEpHnkSl7KfpW27QKxjJo7Tw/zGF7wtV32rf8Ju2wzK68Cu8TePkdpjS/Q0fk21J92w6uOL/2TKeQ334uG/JtGa5NJkggdku6YrDa5xf29E8wcp4lQ/Gdz2bdefhBSpKwoBJ4jwrvLAReiUMw6jHFGhriG1P1++snHkgTuaw+8i9JsVy7drr1kUBQ3BhP88rTnbk+L4rhiJ/SUSPIHMZMKKU9OusOYK0qW1j7aVLild+Kt885+qeMMq1mXtZwRMkURpZGJBGFDX3lXCy7LIZm5e+izwRxWcDiz6vrySEzLbUhdtmnxkoLZLUT9zfgxiviLZudodXGaq/BhdM8TfoX0cNO3FyT5c0xVl15wasCez4vdhpnQ3RWKCKjZZkVGUgQZq0dbiJfhA1BNIoTN
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a9c39b-f5ed-4e42-1a23-08d81dbcd345
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 12:46:50.6834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L5ff7IxpyehsLYprAeHdwuyCXQgQ5SUmInSwjASP6gX7WHv9qjIhaNqb0JPlltKXyzV7k/mAAEbwd+CTc46roxYs7Bix4tZmdXl0OrG5klk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4398
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/07/2020 12:31, Damien Le Moal wrote:=0A=
[...]=0A=
> Indeed... I did not look at the other early return path :)=0A=
> Can you send something ?=0A=
> =0A=
=0A=
=0A=
Sure=0A=
