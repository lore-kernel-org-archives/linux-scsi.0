Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9828C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE13120739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 07:46:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S8dbvAeT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="c7IKd9st"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgGHHqU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 03:46:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:28250 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbgGHHqU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 03:46:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594194379; x=1625730379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CW7jtL+m2tH5zC7+DQavXwiS+gYBPySjAj7htXB6tU4=;
  b=S8dbvAeTGwfpGkhuscrdQvLoTHaMStzW/0dvfeyY4sXM4Ryiop2qmNpB
   GVZ+EIzaBV2Uv2vZmGeMEhuIZ6d044qjWOech2K7Em/vTRISKLfRWouE2
   LCz73qrFes+kuIjWuWmYqsuAO/XtLigDTXkNQ5XvNiuCOGni/BcP66CeT
   lNmmJgLogUxoS/pmoAsa1LpyRRXtE2K0vREANUUb72phdPh4uUaKlROqY
   W0zOhF4e1oNoWsoxZx9m3S3KBwfRQY4UzH+SCgPi5XZzlghR3AI34G8Fv
   YNEWNM72GIf0SFy7xCX0yVKAUvz9t+UXmK+K0rIxEN+1uOCZitUwFX6j3
   A==;
IronPort-SDR: IXGQKEgbMyCWxc0gHr0ytY5NylgYY6030HnLFTdsWS0O1K8sSX3PZJSmqG55h8fvkCIFuulTxq
 cNwd/BWw8ixOngs2prm3Hqqc3XEZrB6oUdprBUziuC3zZ8ohUwBtOukYoo6eFGiHAzM/oWxo3Z
 CEs/Jm3MmJ5GfejjSnzQRqpYdq7N0ZTZ9Ea9WuFOBnDjM2vxH6SB0r9h6tgkuNJMGBDarW9qFs
 GJLqutM7pZCqX2uxUc20ZSkk+z37tdDwwcQFbNYsOleHbR7Qt+/urWqOP0+ytkuiU7vmJCDobm
 z9s=
X-IronPort-AV: E=Sophos;i="5.75,327,1589212800"; 
   d="scan'208";a="251145312"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2020 15:46:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ac7DZq5ZSpY4evQ4FAdpNgqh2AbdcPBhV1m9MyQhDP/LX9DM5S7ZnrFLUPaewWbEXHbEaFVPE7JKxZRO61hbbcZiQI3W2IwyxWm3M1yfNEUFtNygNjRIrMRMwHsl51M3vxjars0SnbEkTaRXBfPUfWSiUn49mTagnNx0M9Psz/Hzu37qdHjJNXekaPgV7VpGl/VkHu+e2rn3hctuyyylg9vFE0XiZLx55HzlU7faVpZ6U/vMbUcqbSF1Fq3v8+Ig5FfKkvcaaieF10ObcaABs9pKXkvzg44+yw9DMsqtf5AjP+LEd8CqjnzL6mZ/AVBqsPe86pNln7C8R/roOUqrFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T7OjNIL0K7K4IiwWHnwHTXl9k8BdA83AOQKVi39f7A=;
 b=RaF4qmpYp4buhKsDJk+Gb+ALDeUlpFDnFt5X/AFQ1itU5K/doWnKI1aKdcnbU1hNy5jJmaHdzLA3kt/QDeVm+MujmUUUv3ElGoufub3QtT6b2Xh/2banO5H4fk7SLA0e53dHO3Y8xhRzbot0zy30ycfBcuUcUx9Tnu8GfS/iJbsW/qfH6lWOvDPcOksTOwUiJCNBaeKVlqvZ3gZd12qF0gpjo+jmPauoRJYTsB8pjn1d3BF0b9D11HQG1Ely74QhjiKTTem8fxFcZKPw0+3GuQi75v1WcpNssg9td4FsjyGcdgiJdQZdl0xwg/dQ6yJ+VQvXlcTk2X6HjZrEjKDRvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T7OjNIL0K7K4IiwWHnwHTXl9k8BdA83AOQKVi39f7A=;
 b=c7IKd9st4oLnyemLskpBciE5xjMnCjmzslcq4xk2o0Rm3zc9/gJC3E7tL1koeglZYi1fXCSY4AxoY4biu5VJ52I6is6xsSMt1CJVJLE53e5ZFNI1ak9vECD+zZ8Mp8gOVCnzcQ+erhdQxpkL8fMBoZTWGocFMDTsJFVWOT82Wt8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4576.namprd04.prod.outlook.com (2603:10b6:805:ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 07:46:16 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 07:46:16 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Satya Tangirala <satyat@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: RE: [PATCH v4 0/3] Inline Encryption Support for UFS
Thread-Topic: [PATCH v4 0/3] Inline Encryption Support for UFS
Thread-Index: AQHWU9CrN++9Kq05i065EZNIQ06i0aj7P2IAgAIQROA=
Date:   Wed, 8 Jul 2020 07:46:16 +0000
Message-ID: <SN6PR04MB46401281ED3654AFE34B779DFC670@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706200414.2027450-1-satyat@google.com>
 <20200707001358.GC833@sol.localdomain>
In-Reply-To: <20200707001358.GC833@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd8109ac-f48a-4d27-d93b-08d82312ff1c
x-ms-traffictypediagnostic: SN6PR04MB4576:
x-microsoft-antispam-prvs: <SN6PR04MB45769AD690BE753EEB3BA55CFC670@SN6PR04MB4576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /iTBKNeZgbpdiNFQMmw3GLrumAc3FgqH/scoyEt+7yAVfBbWRDMJ/WE+PgP8/TzU6j0P8eHBpX6kviHRaz6+GknpXwgLwg6S2ixU+4lMHibqPTtMa2q8y6K01q5JcDQNtYeGA0+XgfQN8MkTp12wR/9dqQc1pKbg2lN+BGk2Jf1zxy9DnJ3r+LeUUZqGpTBee5iER0Qha4DbXC2BCz7mHkmIlGY3HI5p/2XcXdV+rinVZtNMCGBSsVqxM6FvJ2R958jKhOe0yPMobyoZAdYYpMsI82VC5nzpkdmzBYLoFQj28d0rNCbbWbjl+h9Ns6yw4ZnuX4AWvfW5zNcAN4V3Bucmv/WHJKIOtIzFcU15gu4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(966005)(86362001)(66476007)(66556008)(8676002)(76116006)(64756008)(66446008)(71200400001)(66946007)(9686003)(55016002)(83380400001)(33656002)(8936002)(6506007)(26005)(186003)(7696005)(478600001)(110136005)(316002)(2906002)(54906003)(4326008)(5660300002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XW/GajNH4mUffW0Gx1JwLIvLssvGlgAwtoVUHyacbmOwuzGeQVBQLqlrPW4H9WbMnJYqE1urI5lVu0jtv0jMg0Q6qUZlA9FWCFz3b/PexkmOlCWLnWShCZpRA5RegPqsMjJ17LfUJHnbnJyznKQp6PPT8mT4zu/xXe+qIVsjB/NuzMRka1NeAMIWUHPGeZr3d79DQc7OO/n5i1wFHbb+abrCU19UA3KGdyWg239rbzJsPU6bCiwmO/Osj5TodBMJltVH8wDGRF5IPS0gg+N5r6g/FxvmqQ5tBHnlFvbEaJJbBr5BK5hSjllkF+wR4IhsZyoeP756eqnRoSCINEg8mFOlpAseYBC8VtrIHk6nFveUyefErQ40/AWGsgkrnePCNNy2OFiDJTrUgcxXBYknD0w5BBCmaI/BIfQtEHXNv/h7iOaizGXYZzgYwgMy7BkrnZPnxQpfJde/R7CxclsktEV3Kos3C7t+y5lW0JckL94=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8109ac-f48a-4d27-d93b-08d82312ff1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 07:46:16.8230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i0fqtztjpel2733jEiUUIPc/r//RJ02wn5jDyX+r/YRNu1mta9duu/2Zt5QErBs3MlODl+cDWbEc28rDtaBHaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4576
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Mon, Jul 06, 2020 at 08:04:11PM +0000, Satya Tangirala wrote:
> > This patch series adds support for inline encryption to UFS using
> > the inline encryption support in the block layer. It follows the JEDEC
> > UFSHCI v2.1 specification, which defines inline encryption for UFS.
> >
> > This patch series previously went through a number of iterations as
> > part of the "Inline Encryption Support" patchset (last version was v13:
> > https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
> > This patch series is rebased on v5.8-rc4.
> >
> > Patch 1 introduces the crypto registers and struct definitions defined
> > in the UFSHCI v2.1 spec.
> >
> > Patch 2 introduces functions to manipulate the UFS inline encryption
> > hardware (again in line with the UFSHCI v2.1 spec) via the block
> > layer keyslot manager. Device specific drivers must set the
> > UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
> > to opt-in to inline encryption support.
>=20
> Note that it's now ufshcd_hba_init_crypto_capabilities(), not
> ufshcd_hba_init_crypto().
>=20
> >
> > Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2=
.
> >
> > This patch series has been tested on some Qualcomm chipsets (on the
> > db845c, sm8150-mtp and sm8250-mtp) using some additional patches at
> > https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-
> ebiggers@kernel.org/
> > and on some Mediatek chipsets using the additional patch in
> > https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-
> stanley.chu@mediatek.com/.
> > These additional patches are required because these chipsets need certa=
in
> > additional behaviour not specified within the UFSHCI v2.1 spec.
> >
> > Thanks a lot to all the folks who tested this out!
> >
> > Changes v3 =3D> v4:
> >  - fix incorrect patch folding
> >  - some cleanups from Eric
> >
> > Changes v2 =3D> v3:
> >  - introduce ufshcd_prepare_req_desc_hdr_crypto to clean up code slight=
ly
> >  - split up ufshcd_hba_init_crypto into ufshcd_hba_init_crypto_capabili=
ties
> >    and ufshcd_init_crypto. The first function is called from
> >    ufshcd_hba_capabilities, and only reads crypto capabilities from dev=
ice
> >    registers and sets up appropriate crypto structures. The second func=
tion
> >    is called from ufshcd_init, and actually initializes the inline cryp=
to
> >    hardware.
> >
> > Changes v1 =3D> v2
> >  - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_stat=
us
> >
> > Satya Tangirala (3):
> >   scsi: ufs: UFS driver v2.1 spec crypto additions
> >   scsi: ufs: UFS crypto API
> >   scsi: ufs: Add inline encryption support to UFS
>=20
> These patches look good to me.  Avri and Alim, what do you think?
> We'd like these to be applied for 5.9.
Yes.  It looks good to me too.
I've added 2 nits to your 2nd patch - please feel free to ignore them.

Thanks,
Avri

>=20
> - Eric
