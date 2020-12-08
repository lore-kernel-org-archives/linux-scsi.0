Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C09DBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 08:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB6F23A60
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 08:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgLHIlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 03:41:51 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54101 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgLHIlv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 03:41:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607416911; x=1638952911;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=vI+z36yDCv11VcUgqj0e33apteJLZMKEwiGqhlwp3d4=;
  b=p1JI4KS/0BrYGWAfwVpsA7oKyZMe2LQmUjEFWyiDSP3eQwQ6MjVRi5ax
   XEfSrptDX6DEUs+3bXO2HK5Jw5nntsMWZk9GmtiYx565CcMdxROhGe7wj
   5t8CVjdONt4DcnwmbchiqdeqD3Iw052xynW3GlmXU31GXLPuJKdYxMINB
   wEgvP4zEMv3Fg6JtCw/LfenML4BIMuPBdVenMWYkF832JjKPsaAljcWys
   Y0dSG+p66H8jXnABlmHAhya8uBvuiIj2BZbqsFxUgrgEvPY5wCxj+9Sha
   cHpKdASVWWnm48z1voPCcjOyJ9hYX7MDyl5o4N6ZxGcUq0EgOcWHEmP/1
   g==;
IronPort-SDR: tojNOJt2/GDmvfTULsY7Ex+RMhlRTsTML9USz2vIZiyw6YP0ug5Nj0LiYqSToLVdZnfbnlJ01C
 Zqq4GN+UDmAnj55Z252fju5xUXm31QJ2qlPJTCCAXNmtfLbbbpVz3umjXYMsDDMCX21IZu2sx+
 xV12+JBmTtddJYCPBndQDKz5+3hLqCMfq6flxBC3gPh+XZjSBPR/Cjko3rXN/bQUTlhWKylA1E
 UA6ocLNWddRQ9DHKyDFFjlWK6/af/txty7pFPRtx+G0RAoLUxJYcyR+KcSWLcOaB6LgfqytMEh
 Sio=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; 
   d="scan'208";a="155882990"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 16:40:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oIpmGPbZkfv0LFBUZ+L5agt8KdZcqTglzH2XE0N+f7XhkiSOBQCoQFUX8Eof7dRITT6kBMTBjNhwWbHss5RwP58waKOv5Igg7xLSECI9rlN8bieRWnkWs0sYqBlKf/QKb5Wh5j9l7RXsmFe3TDl1rrDhArGs6s6ooDfsg7TzUkkiVFGXcjH4EtTX4Gv6Ll2sRv6xjB0f7zp1WDO+0G4hWxVI/n8kLJbWCZWBNdzg4gesAGrZ3uxO9lU2ifavyfjvAjTY6i300Be07uznbazjYqINm8sw2YA8hd/0C079oQrhVazFIyiMcXzONdzMB3zOHFNJatBwQtLpTQqGwr2NbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI+z36yDCv11VcUgqj0e33apteJLZMKEwiGqhlwp3d4=;
 b=Ri2NHO0lJxNZ5VAPTfAtfnnxZtdCvaqd+LYxdS8YKhs6/sopDKYUkDaPVxFba5+Z23RcziUN8RNK1HiuvJoeBv+tjnlgENtvW6Cx56M/f8cqqU/yelrOEjltBop8A6V7BBcA4sjsOaerNNU7PpAAxe/yBeM298R4rJpxo8e9uPmdnhFICRaHlOotaJMjNKglGjd9pJsdNCcUm+OtyI1g13sNI1gYKYgU58GSS9D3A5x3xIGlcp/TebXd/YIdVgd82MDYUrxiQ9OI0QSnD5j3WI2bOP1nkW3kU/Bw8NnjLnwJ9Bn30Z3kmz6OV0ipQjutIF7xYbT8mrDYTZm87YoU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vI+z36yDCv11VcUgqj0e33apteJLZMKEwiGqhlwp3d4=;
 b=vwI+Xs0XJNrdlcENIQgeTfcp9OVIL2BvQ+ocbW9adzycUNXwGL1tGv2h/fcX0q1S1Skn0mVvR0Mc4BUirwowUAEYYAoIfJqICqMgC18K2dPABEFmGCits2qMxbxOtP42Ly5bqgPVtA10CVmv2tiphnpi16tw9+CHq5ZJ0AK6LLU=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4685.namprd04.prod.outlook.com
 (2603:10b6:805:b1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 8 Dec
 2020 08:40:42 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038; Tue, 8 Dec 2020
 08:40:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        Hannes Reinecke <hare@suse.de>
CC:     Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyi08xMuKL73ZZUaIarInYKlQvg==
Date:   Tue, 8 Dec 2020 08:40:41 +0000
Message-ID: <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <20201207192453.vc6clbdhz73hzs7l@mpHalley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: javigon.com; dkim=none (message not signed)
 header.d=none;javigon.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6232f46-9985-4873-c699-08d89b54f26b
x-ms-traffictypediagnostic: SN6PR04MB4685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB468539606AEF3F2222671E649BCD0@SN6PR04MB4685.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3LGgpj+gCMajQIOvXv6NE2Yvr+S+Q1P66exy7VZIj3v+SYh7buoJLneeyRfyXroNOn0ztxHnYA8vEr1ClPe0qtqyKg6zwndfc7fjEDhnH5PcwJ2Vqkre7QfkGd3FGHs43tmOlH+vxomkrEBmAlw4l8bLR1bdhC1K1BFV57Zz9cd4VVmBrVrZ7qIhTzjCioerRdgJhT4e3hYc4Xty/+N4Rm5BwoE1ni6660ItRIEY+LUNwJ9Nf3ePK+ogGWv/2zjIQQMnWUUET4vtDfakzNClhKVEAsPsbzKF5t6xUPv4W9RNkeJ9x+Za/NUlL/tMius2IdEHBpVPdaxQcDgOFsVi7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(8936002)(83380400001)(66446008)(66556008)(316002)(53546011)(2906002)(33656002)(76116006)(26005)(5660300002)(6506007)(91956017)(64756008)(4744005)(55016002)(86362001)(66946007)(52536014)(54906003)(186003)(7696005)(66476007)(110136005)(71200400001)(8676002)(478600001)(7416002)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?zdk5Tt2WBtEqw48/dhHoSqKtOC7Mkap7mP7x02BhRb89x9Kz0r/A/dL+Hl?=
 =?iso-8859-1?Q?rMQJtq2xoyEAEAC3TH50VDGdKV68nYZgHE61YJmm2UwpotHzHfN2Wq3MLD?=
 =?iso-8859-1?Q?yMlanT8t0mNBPxLXulRU/JWfxISYV0/55ep+vEMLLskBC283HvHmw/QXxF?=
 =?iso-8859-1?Q?Ix6Q8BLzRZT4FH2KsXYdl547KhMIK/3PXYdayMBj/f6ZxY9EHdCIW38C3L?=
 =?iso-8859-1?Q?g1aH96mu9Y/l0ovlRxm9w4zSsGWSxdba8aNwwki7+njchhG0IbpyzbMPaf?=
 =?iso-8859-1?Q?Ayvegty6B08b3sCJwkGf2x5XgCsXpyegpyC476RKA2Z20V6Ck0W6aZNn4P?=
 =?iso-8859-1?Q?4rNGres69GcVpStqKpKeFziHwIJVSKL7ZLBPeyvezic/FKJsP0yXWUZM3Y?=
 =?iso-8859-1?Q?3M+E5vBO4FMgyRElazMRlcfYLHw/Os5FDDI6Thq6dAaguKL4aslRxGeiZd?=
 =?iso-8859-1?Q?c/5zNMd1Jg9Z6quL1+z6MbakacoBsBIosX9JJSANI2Gbe/pdyIU5VzkdEG?=
 =?iso-8859-1?Q?GyIth7tDCkEUMG62a7FKVD+ivUfYZ2NmdEo9B9ra2gFL7jeF1b5KanEw/Y?=
 =?iso-8859-1?Q?hXYMzUfdHIdFZjzeJhGZLwY730JhAP+mKFFiVHIFAmeiLlL1x9EIPCs0Qd?=
 =?iso-8859-1?Q?q+Uy38r8I8CyxPMi2AbWzGMjpE24lWeFScvSjE1pri5wMc8QmT+yCJyJb/?=
 =?iso-8859-1?Q?+EDO5md1Ra5bFA21pLUa9An45rfBkgzUWFeHftnS7VGTpx/Ye4VEHW/0vz?=
 =?iso-8859-1?Q?L0aS0WUfsS7kPq9ivP6hWjKRrAYD5Y/ez2lJx0pWMXe3ZFkoftJDAteUaG?=
 =?iso-8859-1?Q?/y/w02L7j9LfWvvEG3mBSeCdK3Co8sTCRpdo79HoK9BqS7UXsOqsIQ5I6B?=
 =?iso-8859-1?Q?diE8N0Uniq6A+RUKqWDTTEsl+rcOyeGEORBesZuv9fVXvRLfd/OhsgV806?=
 =?iso-8859-1?Q?xUdRZRc/aWJlPIWZdUpaRicDd30S6VPk9ydrqyTI7OSTn1JjPhCpa2E9W+?=
 =?iso-8859-1?Q?CAvpfN2l7wdsgkfWfyMxtFyoJfG6UsT3TTY60m?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6232f46-9985-4873-c699-08d89b54f26b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 08:40:41.8083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5f3SENs6K3SN1aPr2ineoVlrRSyV7/y9Og3cAswZBquhygTMpX45newZQyzpPDZnTOqJ4hXAboptAb7uqc4chBEDr7rMPngq6rkla6rsm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4685
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/12/2020 20:27, Javier Gonz=E1lez wrote:=0A=
> Good point. We can share some performance data on how Simple Copy scales=
=0A=
> in terms of bw / latency and the CPU usage. Do you have anything else in=
=0A=
> mind?=0A=
> =0A=
=0A=
With an emulation in the kernel, we could make the usd "backend" =0A=
implementation configurable. So if the emulation is faster, users can selec=
t=0A=
the emulation, if the device is faster then the device.=0A=
=0A=
Kind of what the crypto and raid code do as well.=0A=
=0A=
I'm really interested in this work, as BTRFS relocation/balance will have =
=0A=
potential benefits, but we need to get it right.=0A=
