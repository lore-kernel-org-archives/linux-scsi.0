Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD7FCD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 22:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjIOWBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 18:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbjIOWBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 18:01:44 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05832118
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 15:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1694815299; x=1726351299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ovlL25YfJrzKrzfeTkpusAk7ouPLzcdWiNgEuYevjMI=;
  b=L6l9phc9wY3hD1WkstRlUd9NBU9usu/Z0XG5/J6OYUy1iDmwtypVvI0E
   b6vV3CrEGWJDzX1TvE4+7VZRwaCX0ooaXpfJgct+oOLPqtsT2wdb73gTO
   ewKPuMF69HPgTO/9I0cwyCXq/8xBdEyzf5UjbKombtq4whh/Kq9wjCzlt
   TV3LvpC7/E/JOXorUnG5l+N66pTnsreKfeGgRvqEv1ApM20XHPuacAT0x
   j09pIOgIAryouSiEr6TcSbt4t7+8RgF91NY4fjmueE5OwPmn6P3APHCSZ
   mS3zBh1i1B3rpy1W5FqJ1k8dB2z82BUvVGlvc2OFZNdFEY7ITfLG1XhAg
   w==;
X-CSE-ConnectionGUID: mbe+DpM7SrGk+4kb0Y3Stg==
X-CSE-MsgGUID: GviQhp31Tfi1KBV2aZHQtQ==
X-IronPort-AV: E=Sophos;i="6.02,150,1688400000"; 
   d="scan'208";a="349404127"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 16 Sep 2023 06:01:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4R3B8CIRjheZskCknzf9whQH/ZmNugvAVu685M0RZ3hSEL8/vxL/TlbtmW0i0dznYmsDDDqaos23eGwUGLUfcgfcY6NG4tlXRINusqPfpGpJP9G4+K8TdWHa+U+RwzlUo8G24BpiKbB28cIcaWBzOdNut7MFRcDDVCL+A2sU5woUZTluc0XImFaETtFOVSxVkB5pdsPHrtb0yzPzi0ks0uCXYrmblW0qyB9CRQ7tmQ8rI8/W/NLh4BtJOMubXu1d2GfKzs/pnAxcME9tJ43y2MdyteLNMdA8IcRwr2bgRVx/v5SWrYbNNtBFOjLe+yrjJ87QfjaFu+CIryC6JROgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovlL25YfJrzKrzfeTkpusAk7ouPLzcdWiNgEuYevjMI=;
 b=XpVCUavBdByrlCTzQQrJJYBMm+4KEmvNI7xmKVo/FMZi7kqIOkADhT6rvpxqP7OUDKhf4krvkiXKa4Ky9P0dW/5+kNo7ahqBLl8ub0p1TZhmEmnwD1xuLHPyJJttNOPex79mxvnIe6lKF4X1iSSuElkKyiU0AT4+xTWJqqrJbVqD8GPgfItSxVudguR7Cw3XD3aDfgiFDebwMA2NxPbt2pZwuyiSsGTLOTfo+LNQySZdwcsJh/krpZ0HDFHjIM7ww/fGUDgMCT5u0Ja7/fVvVINaRqXi5ljrgI8nTF0QK5kwAyswibAjZSxWBHSmpzcGSdLnU1Gdm56fELrBymqtgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovlL25YfJrzKrzfeTkpusAk7ouPLzcdWiNgEuYevjMI=;
 b=l4WkOooyWdXqn343U+Ge0R4seVI+r/XbEG/s6LzTYHfMt13/SyswQA6o6xgdraZQPGLFyiPBfo3R6a9Mbwv+KEv17DNAPGJOTwyJ57Up3D0GLLoYJCjgMhnaPU8M/gJE8JpDn9mlxcKdajwUjekD7bTzQCEvpcYUbna0dzwSypY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BN0PR04MB8158.namprd04.prod.outlook.com (2603:10b6:408:15d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.8; Fri, 15 Sep
 2023 22:01:37 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ac1f:2999:a2a6:35a5]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ac1f:2999:a2a6:35a5%2]) with mapi id 15.20.6813.007; Fri, 15 Sep 2023
 22:01:37 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [Bug 217914] New: scsi_eh_1 process high cpu after upgrading to
 6.5
Thread-Topic: [Bug 217914] New: scsi_eh_1 process high cpu after upgrading to
 6.5
Thread-Index: AQHZ6CAyYDDqcWtCWUm0MIeTTppQMA==
Date:   Fri, 15 Sep 2023 22:01:37 +0000
Message-ID: <ZQTUQGG0Q5k+CMSV@x1-carbon>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
 <41689a20-af9d-420f-af4f-72e299a765b7@acm.org>
In-Reply-To: <41689a20-af9d-420f-af4f-72e299a765b7@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BN0PR04MB8158:EE_
x-ms-office365-filtering-correlation-id: 6946c037-0515-4642-22ee-08dbb637554b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o3Mljm3WUuFjTNNuivPpgrpP4/KRn4uOEwBcHawso2Z4NRiAuVkvAoCn2BF8AcYLTYCgoOEEwNqAEZRgkVtD43q4otcAFiRrHcp9qZn2Ykp/8lWpapaqY7kyT4fofCdpp7FYjiBRfi+pLJz3P5FeyL79izdBpbIL1t5MGfBGh7/DXCmOnbCw6Ac2nGUwSVhOFXGMMDQRW7r+q64U6z9pCNMuLhqkqnYCPdzhGrbDo0Tjt/NPkmb/g0OO+2bPt522dsr57UrIr4NlES44b7rymoVdR+CG4bMFi/Nd/tx4qcm7tSMXapySA8qcvHpCc950x0MFE9Ve2TfSigf3N1+mCBoqsoqAinlnQFvOdIc/mRwpKzbq8oQtt5jYnEHoNimAaEq4tMUk9aEFZe338KxPy+d86mKaKbBFkqtI1HRDvxeqHy2lSSawTbNTU6PqQEEgOjNZ81TAevY7wz1tJr2koIVQrSKGB3DbXzS1gvAqVhbQe/j41ck8cWFIneVoJz+v9rdqR9bWOwDn69O11bidKF0ZAi8qGNzQcyt651ZiM/uBcwhtvkeQTyNZxL6v+mSvpYO8iKkN4OJtPEyQzjtTDxnIpDbwed9RSZ1ml25be8hqw1yjpfbxAkrFPqBSjPDa57rh9bYktv49QlagKuhUy97h57qUCGSS4dYocrDwa2Kh87P6uAYWEEAitmQEDMXOgmVoct0EdkgfYPBVXumK3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(366004)(396003)(39860400002)(136003)(376002)(451199024)(186009)(1800799009)(6486002)(6506007)(53546011)(71200400001)(966005)(6512007)(9686003)(478600001)(2906002)(4744005)(54906003)(33716001)(76116006)(66946007)(66556008)(6916009)(316002)(66476007)(64756008)(66446008)(91956017)(5660300002)(4326008)(41300700001)(8676002)(8936002)(82960400001)(38070700005)(26005)(38100700002)(86362001)(122000001)(10126625003)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QlZCjD7wbaNSAvacETzzJFK/B32ZaDwDJ+cLBczU1e7CvPPLSwlKscY0uMRM?=
 =?us-ascii?Q?2tJQZyXZGAMItaCOEDi9Nww6F5FThD7IQPdYcqTwG4AfmS8g8gpkYJhQgDXM?=
 =?us-ascii?Q?CD/+gOwfAZx1xWNX3tuQlDMwiy8h2cy5qIm73BqsS+dajxEdTMmoLlV/8qmZ?=
 =?us-ascii?Q?0lzh3c1E0c6SHtMFVA/ZGn7rSKd4Y3Jbdy2C35XKK8QVPX8JspsvND24FJIN?=
 =?us-ascii?Q?ECG2CDeMA+hpHhrqEFGUfKvM4orWCkWUCJH/vbE+pyn+K4ZV+7ji9Dsv626y?=
 =?us-ascii?Q?NC9q/O7RuWhcVzUq9ISA8ep/OtUQNbjqpGS8QWcwDs88yJahZR4+wbBIbThN?=
 =?us-ascii?Q?8jqMUZffIPcRSYkmjfbxC/jEDN7XRD7nwuGREVcVn9cGsX5bNfjYmFqvlTZh?=
 =?us-ascii?Q?xq17N0K4K3DM3Eu5sl5i4zv5yX3nEED3/o9wuKktPQ/ZLT11HiKN7mEFS5NK?=
 =?us-ascii?Q?4mieKd/74lBOfclHEEOLlqfmCBu+VRSYAV4xiF4tCgkZR5Ipyj5pSoUlgN5Q?=
 =?us-ascii?Q?TQVIbey330OsTSCDFrzbDh2aMHagkGZBihvQB9j/991QOLDSMMwTLYgmydqC?=
 =?us-ascii?Q?VPRNsnl1PDnyshKiEU6vczXym13xbiR5zrNkC2AVW0jywgEFJdUBrmZ7Fj4Y?=
 =?us-ascii?Q?B5UqHKdaOkLkyPf+IJLpsCwu6LNdxbx4iooMBVQuSHZkXIgmL14T7OQaLxbS?=
 =?us-ascii?Q?CrtB6P+yIN36ZNZDVgLBGttHZPYPph2Vt3r2QLZZ2NB/fN9IQa0YCemJjMb3?=
 =?us-ascii?Q?1Q9CuOTdhYoOGaG05Uni9IKIXUBIwOjJ1xR12+QZTIP3RRrwGd354QDYYHAD?=
 =?us-ascii?Q?EPaUcUAuN4r8So5u2B21frg9LYMYZMP4Szb3dFWMYOJhuz8XK6Q0oHv7fzkL?=
 =?us-ascii?Q?ijxEpIZQzrhsUsUlKEsEuyyP+I/nRzqCXDPNmXKG74dorqudOdLtfGTmZQos?=
 =?us-ascii?Q?2nPgaKhblsj3HjUqschLb+Y9+u4Sj/NMMK9WfDMbbjdpqtNfxjALiuhflW48?=
 =?us-ascii?Q?TM8vMQ0xmtmdic0utJyGHo8zKtkAUG/FrQySMF8Hs0NXK7cKUS2zrgp+eKcF?=
 =?us-ascii?Q?rBLZeH7lcHNaOWl5rkQkT1SMi3SvKA1yKsL/78hbX7HToDl/HBmVgbn3/Il2?=
 =?us-ascii?Q?cfM8YAkPCJ0MUpnu/5+bDV3z87fLYowlRieMQvZIkuL8yC4IbJ5HiBJswCc2?=
 =?us-ascii?Q?kD8lEPz5H4dIf11NSCyfypIov0CxTYiQbQ+AHjfKosaPiSEmeGGZF0A7Q7Wa?=
 =?us-ascii?Q?UQvNEajJDYHoiM91LqVnM0TPxZwnEHzZsjvydlQWl6QTdHPZr7mut4cel32D?=
 =?us-ascii?Q?i7BcBrylovHoKX5ZJY3fbeX4XTOMOAb+7amJc8AlgdKNOWD3k0Viv6HGpkrT?=
 =?us-ascii?Q?N4UBgAGnJkS4k/YBDHM7I2drLM2uf0/umVXNh1H4BAjx8R/IjU9m9jY3UMmd?=
 =?us-ascii?Q?jDrx3mZPav+zTFAuCX91nz+HJfdBcAgr4fDesprF18KqU4qUbYq+ah+djTjD?=
 =?us-ascii?Q?sQN8viMDejVcAgEnMrHiDXfge/PPjRwiUAD3n/N9Y7ZkYFkECPvrR1OEryDc?=
 =?us-ascii?Q?472XDor1LLAakLbp4nbBd/WN5f7Gr2oLrsE4g2KX9DW4lhVMPVXStN0A90Qu?=
 =?us-ascii?Q?Pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CF0548CFF45EE843AF391EBFF99F3C86@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R/s8ANau8L8DiX7acnms8oa6iiWjgm55lt//G3IreoV0Ha7dOW02eF9kG4/RfOvEfgjLQsZ46TP/8sLvYEUQ+SGLAo+Oksh/7TZ/7nVvHsSPTOmwoCEmBrNALMkgJd24ynRXsecq93P13XRFm1hERmAqRPKcQ2IK3RAMND/1YA0OLRJBzRsSd//b7OHaoNWXCanVCkwot+MS6/SYw80ncTHeNGw9pxyyw4703p0ZQXZ6s3n8OLsEkXvslubl6Tc79/b68u8yAS/UtWby2LBH2El0xcizKgqOThbJ2ixO4rcpuNbODAf3PvbhbUxXKQyKDhQdVG29pGQUcDffEJb5aVuW+kv1OLhpgqjT6cMKCGF/3Rvd3GNhQaNkXnBNJLaCl4BEAnYYNNp7wH/CQ/I7e0yKmPNZQRcilLJDZp6s/kplSySB/CLa7YBKi3H41JrNy3u1Seg+F/vpuHwlRVE4L6QPFsXKK6naam8KMqDMDSj4UpDwJ856y73eq89uHQSzPGI5qMZ6QSW7sjqRM66ly52TGRcnC9pdkcqGhvGLiGHAdhBmTm7uymzs+rgbGrDZCjzmvBBbrfON2wz0kC1NINLlxWflz+Ofla/4VwcIDcAG2e8lb0rD+GlALYgOfCpmCtrwFLwcvNK8TKwZYZTYyLGwJn/XStkbLQN/ITawl78eCB15TL+R2nmKM8cBWMo1KAx4SkOEUHHIL+pUENFASW04bqxD6bsnEkvH//0aML3ANl45a6bvfa5dncKb76XNMyexIeFRXTPeWAFOKerMpATM75FV40vG9falxnd43fhEym7luXZ0uObm2RKX16T3YejV6Pl/IUzTpcfBI3pPSw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6946c037-0515-4642-22ee-08dbb637554b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2023 22:01:37.3507
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LI8Z5Y7vLeVOuv0dJBOQVw3CefxvHHe9CUcvnwdnl2PJsM9ZT6b+EQjdE5YOYpLiEDIFU5fs3+/j28hUb3Jkpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 01:42:18PM -0700, Bart Van Assche wrote:
> On 9/15/23 12:33, bugzilla-daemon@kernel.org wrote:
> > The users loqs and leonshaw helped to narrow it down to this commit:
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D624885209f31eb9985bf51abe204ecbffe2fdeea
>=20
> Damien, can you please take a look?
>=20

Hello Bart,

It seems like:
https://lore.kernel.org/linux-scsi/20230915022034.678121-1-dlemoal@kernel.o=
rg/

Solves the problem.

From a quick look at the logs with extra log leves enabled:
https://pastebin.com/f2LQ8kQD
it appears that the MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
command with a non-zero service action issued by scsi_cdl_check() fails,
and will be added to SCSI EH over and over.


Kind regards,
Niklas=
