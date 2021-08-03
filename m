Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25689C432BE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 08:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACC360EBD
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Aug 2021 08:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhHCIDi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Aug 2021 04:03:38 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25349 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbhHCIDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Aug 2021 04:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627977801; x=1659513801;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=/ibBwyvoDsJoQXJG4uhZWrVbUcqkgUWBM2zueXSCsy8=;
  b=lpVeCh4TuMVwOUIU66JjGuWholy1z9wvKva9dQr+TOvfDLnMT1ena8BR
   cqx2MmbD9gVPPI/zg/SnM2omqiYK4Q3DCC/4XmbXuZouSI5UYsKlTu97t
   9g/M/Vzz5ZYgGfiZSk03eAF0APxHXyOuis8M6rx1GxOuC+RiBeHVs7zCD
   zNl6LU9Vx+Jc5+Cs0v6bbdjMPsZAvOLCZvFpTolwY35TDUnSP1qREPKNB
   XrO/dTplNJfpsBdFzUi+d7tUXCfCu1zBygfeHWzUPjjAanYg40SdNUvB9
   PkqWhoJTRsnAkUdI8QqTWnfGlfWKZI6joK89WgqS9nO0flUOem4H2eWfF
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,291,1620662400"; 
   d="scan'208";a="287741667"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 03 Aug 2021 16:03:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQq9R1gRxCv8sjP1URdlHlfxaFNuT1QsJvQd2+xpu9MMtvr1fz8A7J2FkFoaccQZjvr584fEI+CXk5ORknz+rRVHdGr8Pb/ovdKyAHFwQPstf8tFtiTQ7Xf3P+Kuu6aw9JRv3JBwY8vXrm8DyhvVkGROE68ncpm4sC7oUBvENcvkqUU3QEJ/E9N+uavdYsreemjTS+/AWKLNBySbbxDDYC79RCFaCR19Qioof3sfuAx9QOtCulilblj8ye33vENaPmpMGVm7vzW3mHjpJG582rq7mJqTPtkOl+8MLQANmdIrEovNhAtQMXfTbpwsY2ErYSTyrdCFBBZfAKPOG3tCvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ibBwyvoDsJoQXJG4uhZWrVbUcqkgUWBM2zueXSCsy8=;
 b=AwfRBmLuNc2z+vyTrcKiahDj1NGktZHoold6aYA84CxkYHGnSEOo32giLfLg7mWqxRcsaQmVhJjBxV7uzBvemiVXrPmIidtiPCflM/UeTMWjLc7ihXbCe6PHybBY/NfwiYIi4NTpOTK80kE3TrarqQWADDWmUPWLt5IU/rTSp0gXn2ZORkUHiY/bX1rLTfvvyNtrhSJ29V6/uf/nEBbJgzKEY1CGys9RQcpoT1IDLFPI1OfwQGeFmzqWjM9MCVSoFc82d6Y2f8+SGKCKuGd4MLh9meHo2lou97dJi6ExtzpsHUoDWzIPS5o55UON89GtrZqZU02z/YyMb2N0XVy7+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ibBwyvoDsJoQXJG4uhZWrVbUcqkgUWBM2zueXSCsy8=;
 b=VLUR5Idng7W70XfJ0CKgLV90OWs2V5V4+FEfb00bVMKlhtz7cLR5FlzhRoVQTq8+8rm0vRN5IguL4br+VlTTrpJOTTBaiwIBbsux5ZP7uHn3X6bxUyE6BpzNpmOkW/cqzEf2a+epO/pGLPjoCXZb7dIhzzjgJvrOoLVLh2s2QQs=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6496.namprd04.prod.outlook.com (2603:10b6:5:20a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Tue, 3 Aug
 2021 08:03:17 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::44e6:14cc:4aab:3028%9]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 08:03:17 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs
 sttribute
Thread-Topic: [PATCH 7/7] scsi: mpt3sas: Introduce sas_ncq_prio_supported
 sysfs sttribute
Thread-Index: AQHXh3078BumpW0MK0yN1KQA+S7ebw==
Date:   Tue, 3 Aug 2021 08:03:17 +0000
Message-ID: <DM6PR04MB7081C5C53E32DFD4D6811DABE7F09@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
 <20210802090232.1166195-8-damien.lemoal@wdc.com>
 <PH0PR04MB7416257D854F7B4D43339A969BF09@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d52e3a89-5f03-4780-1dcb-08d9565526c2
x-ms-traffictypediagnostic: DM6PR04MB6496:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6496B7378C4742A0EFE9E9F0E7F09@DM6PR04MB6496.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S7pysUDJqbmC6deeRzt/KvIZcf1xr8F3XFcOB+t3Wy+QCNNA+8nyCQEWhXWCAQaLRkCn5rmDny0csCHv/NRqo9yJZgee0qV0eirrtumn85rOnVhag7cg7O4HCZuv6dn7YfrTo/0KCbrK7pZ+JJHgqGfYf0tHE5DgdyCc9dWXuUIfPFYK0A2h1X07HccyuvZrfCfZepRAYl7H28Vx99xidOI6D7HisBITdbWThH54InTg9lFYmY/mwHG1vvwVARdJJ1tfcYvVrS8yk+mMGSUsg0c75GsikHCx3RFitqIRYUuT2FKR/S8wb8EfhhavufYyC/7GGZRO6HFvqqkfyMXikQlWXkPtkzOhQ0dw9/v9sfPWlqQkV+vQZLDlVfZVwv1LaWCdda8+LMca4PXJ4v2AHaoKyVLlrALkNyYD10sKzcM23T/3ND0SInl+v6o6gGdwgYo4Q9jcSXvywLi39YguhgMv33yk2T/2eXUYcqTSVnN0QpdlaUdDslc5Hu9EmG7BFdp2w/mLQ6Fzin51HTydB0o/Pl4fkB0kP4AONl/plHI4v2DFD4kqAKQAaYhw98rZ1Ei2bvhBvPFIZNqbKDBwycJW2TIwx551gPgIHy0M4D9AZEEDnLRifTjhDw+HQzoJNTJTzZndcgrRD1kRIuPOpKPs7sD+jMLOILhRQKzU7o+cmNqXOgSTAfp/QjMv87azJZ2ql9VbDSLvVdMmkieOuKCNkVH4wOKzdj+xeAJt+Vc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66476007)(66446008)(2906002)(66556008)(508600001)(4744005)(122000001)(86362001)(52536014)(38100700002)(110136005)(64756008)(53546011)(26005)(8676002)(54906003)(6506007)(186003)(38070700005)(8936002)(91956017)(76116006)(66946007)(71200400001)(5660300002)(33656002)(9686003)(7696005)(55016002)(316002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k63jK2RgBdCtvMmotkcuaFJtO2NZSW0SSKDBFB91O0ifY9EPoaL7nk87Xbeh?=
 =?us-ascii?Q?HVagFXyRoV+APSTt0LhKVFdCMhZBZGJBIgcjFu8ezDcdh0hD4yFrGt7o2Mu6?=
 =?us-ascii?Q?wey1zcvOdOJb2jOfFjTgElR+WRovG8+IC7rC0bMNuOs6v//PJbE20aMtcE6G?=
 =?us-ascii?Q?Kp5zk2PjYNx8m65/CZoCyLqEPsbxBc8TatdF4/7jwwcpYN455KN347z0Uajl?=
 =?us-ascii?Q?5upyFIWm8b0w2OBEZOY11FPPj5am1geyU4QTBRnWnkqe/EknBZSPladYrjQX?=
 =?us-ascii?Q?fzMTKM6Yc8a5ikBAdKrLv9masUKhMA6vupFYW/dG0mI5gqyUclpAxYy33F3+?=
 =?us-ascii?Q?KFsbP4G50sZoMhj2VyvXPGpQf4a+dFwd+D6Q444j9xC+zKILzTMxg9Hg9Mkn?=
 =?us-ascii?Q?VSoJzMj23HbyOmLu9cQQmsQpHAmpr/ZOgRSvUeuRFF4fdNgp0ekFMKSxKV3i?=
 =?us-ascii?Q?zLV639JMp/w8M+7H10SxIvQufd8rDGCcLy5e6XYdON7ItF+DqCiIONTB5ez2?=
 =?us-ascii?Q?5haaK2vjoY42dL8LO26FC5A/7wccVh98jT4b4ZxStw1EH99RTi/1DZz9IkzJ?=
 =?us-ascii?Q?MN4hZEqvCA+LYCUybvxMZ6AUy3NbYG5ZDdFhgmC5nnNt5r7TaM7WJJmlwhkS?=
 =?us-ascii?Q?v0mPzSsT9Q3cti/HCOAB881YWZDWwyckgLC2QR5PlAJ1+YDR5xbVR2JQHfo3?=
 =?us-ascii?Q?bxRNLGJ1M4i5MQPNmYN8y8Gz7fcb8gRUBfPMh3iYv7tgLNZGL5NOrkPWMXW7?=
 =?us-ascii?Q?xNsmRwNX+5FsMLis6Tr6sOmcHbzzTHuWtkZwlWeFknUzMbqNjDpLp5ohX7oO?=
 =?us-ascii?Q?4b2oYAYju7mcSW9Eo1BVMUXkY+MyDREWHik9GxogT2EXStMXv+VUmlIAKasI?=
 =?us-ascii?Q?ahQM2OEy5hM7/DlbSRb4f9veELoqVwdiU4mTvaDOEVpUISATrgRnp4GqUTfy?=
 =?us-ascii?Q?R+qfvvhg8ipfI/UpPfBEKEaQOaBuoHzrVC0Q56KRkLveldp5XBFHaIRr5MEq?=
 =?us-ascii?Q?UbMM7n5h6k9ARQEohxRKlfn97vtfnRexT0WZojyvuW1+j7koBgEL4zuE+Lzi?=
 =?us-ascii?Q?6XzS2y+IRBxc7YzKh2B3xYztByARutJLncHpzeh41sd7M8zxMiDwD5gbUKiI?=
 =?us-ascii?Q?95sVIAkB8vJaeeHfeyi+q/vMOlLbhvpxHHseYCD7mx7yX+ehtxmwr/SWR/QC?=
 =?us-ascii?Q?5pH3kq4epHz6k0oSQppF/GIBjLTzLm4F/xgSY9Ws5NL+bLxG6H5FwfkL5ksY?=
 =?us-ascii?Q?Ln/jbf+Np2pUlD1B21Lkbof9032alaBzJgtJ5uxwmO2BjwxISs/UNkjgd1Kw?=
 =?us-ascii?Q?5KxpnOem9aWNkLa9HTVvx8VU836K860ojSOyFUkf4X1s+g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52e3a89-5f03-4780-1dcb-08d9565526c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 08:03:17.0238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wfZalda3WuWa6Pq2W7kXl3FxdjqN3Ut+K/P0TLt5bnYMtyM8s8sYOjO0LmPsni2deXmAy/k0J7VApwe+VjHNNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6496
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/03 16:55, Johannes Thumshirn wrote:=0A=
> On 02/08/2021 11:03, Damien Le Moal wrote:=0A=
>> +/**=0A=
>> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priori=
ty=0A=
>> + * @dev: pointer to embedded device=0A=
>> + * @attr: sas_ncq_prio_supported attribute desciptor=0A=
>> + * @buf: the buffer returned=0A=
>> + *=0A=
>> + * A sysfs 'read/write' sdev attribute, only works with SATA=0A=
>> + */=0A=
> =0A=
> [...]=0A=
> =0A=
>> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);=0A=
>> +=0A=
> =0A=
> Shouldn't that comment read: =0A=
> "A sysfs 'read only' sdev attribute, only works with SATA"=0A=
=0A=
Oops. Indeed it should :)=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
