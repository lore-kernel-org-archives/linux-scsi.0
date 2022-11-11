Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D782C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 01:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiKKBP3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 20:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiKKBO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 20:14:58 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CF363CF6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 17:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668129268; x=1699665268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5ljnTORPkX2GVMa3I/2UEgM2aFIyl0RRYJX2UTyP5Qk=;
  b=rltP7NKNyy/kwJtfyjwhHGRD9QQXGfsqdQjQlG5at7nd4nwqshLSodWH
   hxP5y2WDxx96wznC2xYoeaSO13y5xIRmcFmrPov9ERRbbPuQrxrjin3gC
   +dayAuqBAnZjN2gd4IZDzp4KZeZdsE2InLpqU1GR/4ny5TH13zgDUaERR
   7fwbZ6ONb5BhMJfSy+eEYP3/2sqauEcctG9NilyjSfm76VlBMXFl6zYh4
   9DKRivK9kPpBojw8t/8XhzFU9ee1/i0n8AGnrKLKinRCOnkX/LfQfWZ7d
   gEri9AZjYhMv2I4heU6w499I/TvmVqokq0fydt1TEIIxxSR+pXF3tFdV+
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,155,1665417600"; 
   d="scan'208";a="214282898"
Received: from mail-dm6nam04lp2046.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.46])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2022 09:14:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWsg0PYiR+bJ73szaVZppE4L0eFokW3Radh+ueHeS8AlL8gRGW0lDjqpfRbfdJVhEU2Mgq2r0FmysIBTGWrseXCayJ+tYjQNw8bQOOx+Uw8w/hPb5aVbqKNjzXTGruKNBWpc1sxYQPH3qXCu00D6NUNvF8iFOZxCzzenjZmc/iH/jGdty4Ott6BB2BKy0bx45DFNeK9wL/4DCuLTs5OpwV0Y4JHreFG5HTlsn7Kl+hIRuZhKUA8/fgZ7lrsVYdaMp3Vw03B88lWLaCmHyuEFdTOR2QpbNCZUcAs3QRicoF4ZxFIifpVcHggDUs5u/WZI7d7d81zdECWfFlM9TzKKYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IY8K6WJEkld+M9sSU7mQkZY6gw1ovNjQ5X+d59P6kRM=;
 b=mShHhXVb87W/X5I6xwtNSJ+faL03CYEhQ5SK7acMEyT6Vfy2zaisFJPomUneuSfk01uw6nbwxbMM26uWUs8OknBUrtoymzGiawUFC9ibVvv03MpAAr/qErscrsyHbrdbxcdKjdB2EVigNSRRNQ2zyGyhsqxn45lS6zfmzWNNjGehUssdqqFSb1z+Knvh/IBBN4lz9kTWsn6xC/jIg3Nrb2RYzjup6iawrSNVqJVAQZ0ku5JSKrT31Bey3olJy9r2VHx0A9sceDhqOVAdRRFtkVNpMQTAz8+fcxh2BOUIh7+pqAYNv0qUQE4UNazTZuTVhlOjFMdOSpcsTBDMUoGwkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IY8K6WJEkld+M9sSU7mQkZY6gw1ovNjQ5X+d59P6kRM=;
 b=VhwiALMws3dol1xP5WZn6C/EbbAkT0PCoD/lyGUghttiMLvDPGvDFAd4EHq+FL55qNdAxNzkizKTUknxxsFgI1mZFMc30Ks1wZ28POZ2oYQuSi0eyUMU97xPhdNO5BKl/lVamfgzdAXGjwAVUMzD1m0KTzzqr2qWKuaLOYHm/1Y=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM6PR04MB4073.namprd04.prod.outlook.com (2603:10b6:5:ac::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.27; Fri, 11 Nov 2022 01:14:23 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::d4b9:86e9:4fc8:d6e0%7]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 01:14:23 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpi3mr: suppress command reply debug prints
Thread-Topic: [PATCH] scsi: mpi3mr: suppress command reply debug prints
Thread-Index: AQHY8+kTvO2r9kYWrkOPN5KkLZo3tq42DqeAgAKN94CAAFFsAA==
Date:   Fri, 11 Nov 2022 01:14:23 +0000
Message-ID: <20221111011422.7opqxydoqhopa7aw@shindev>
References: <20221109031207.1605138-1-shinichiro.kawasaki@wdc.com>
 <e4824691-aa3c-d054-eab9-679f83fa9c67@opensource.wdc.com>
 <CAFdVvOxxJZiXe74jB3T-=HjJ8Bb=O3baHbjueo9r3adsATQeGg@mail.gmail.com>
In-Reply-To: <CAFdVvOxxJZiXe74jB3T-=HjJ8Bb=O3baHbjueo9r3adsATQeGg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM6PR04MB4073:EE_
x-ms-office365-filtering-correlation-id: 1146bf6d-6472-407c-598d-08dac3821195
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gx2ZU7tt4nZqJBIw+zVJeaKVdz0DBpAYt2Hyajed5QbA9BSpx74MJz1mFm7V/Ive6AuDF9m+zRJr+Cfj62r68hqUCcQ+tED/mjoHxGkGaJ425Rw3XHTTYmZs4h9PjctPoopLTAFtH1ANHEUM1mDO26dhqjYaWbIICju7SfS3yJ0LnNIrgxU8tQ9Es0CPv90dhh6QQhPxNeHw50Ds8cxyvpy22Bt27uK1uDCelbFvbfFkwSZ+l0PbJ/ctwdZAlTLqp6gDLj5+oIEfj/pzX8h3yxbOCKE3plSWWFtE8BROJ9DvXCExrEB/F/IqtuYvm4SYBypZ14M8KL05FnRB+EEkBIWNqlBan0amFBtu/5RkRr3U0Y5tU/wON3Mh+yZHgZlQUWD1pf1Y6Q58UuNW6VXQx91PFe3lxYtC+chXr1cboHroUOstfHndpBbc3pDN1TKq9p85QhysxsJAOnBiiRpS9GoP5NnOVykOKDTj5gIrzoARxKQWM0VD/ydmgFQg2RzLK5WlL83xxzmGN4xtqR+URfe75m0tus4iLDY8CPod/xMJGxiOX5lkPiRDkOfmImS1lOnqtqlnCbWEQOE+JEjJyBAPasFVwQNYfUBYCf1AyRRyBIlkS9jOdQjgs/tUzrCjwZUpSCgH7uCWHXET1kOzuNe6qQKbc2tqmxCxcW92ELMfTVfeCLCjVrYUtKQHFEmP5eirePMVhEQluLJBBVcdN5pKYLufmsCoqMPCuZOKeeZRm2dkepXEMnOCVM2v30/A8qqa47qeYmufZMSn+AY024f3xcm/6poSJqGcXr1Z0yQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(6916009)(76116006)(54906003)(91956017)(4326008)(66476007)(66556008)(8676002)(66446008)(316002)(44832011)(66946007)(64756008)(4744005)(8936002)(5660300002)(41300700001)(71200400001)(38070700005)(478600001)(6486002)(1076003)(2906002)(6512007)(6506007)(186003)(53546011)(26005)(9686003)(33716001)(122000001)(86362001)(82960400001)(38100700002)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KeStV6XOENuVynJ2k+f1qsxTR9FzhSv+PRd+ASwVeV9JGn49wcQ3WwuGfinu?=
 =?us-ascii?Q?D0F6oDbg8NpdHP+3BqVLbwdv9sytZ+EGPMaaW9GNVrSUqRWYGMzOcE/EIcpI?=
 =?us-ascii?Q?9hEU2vnGz6LGfPEjvl3vf2X3SjOU2C+USUB9th73utUVIUC/yT0yAVH1QZhZ?=
 =?us-ascii?Q?GWTET/xxDokOdXAI1JZbKrLQZjxHEaTlFzqibaNeHozaZAbtIfQ6ASq5xCY1?=
 =?us-ascii?Q?LvkwoKSW6Ot8MPFirY+SMUspYNKgeiKOVPMkQZX5QJEGHxSDa8ulSsiDffHO?=
 =?us-ascii?Q?MDtuOiZx95xLFirfxtzr/iC2C/bLvPoD1y5qsJyWsDBx/rXiGNMf38pnVl0P?=
 =?us-ascii?Q?74221jNIJN/lxsyc8mcgvLvOxvfRMP0fekbzppoSWifgMKCTybT0pcfd4/4q?=
 =?us-ascii?Q?sZpobeMzfoVpGuekBSfGpj6Hm+xsnM9zQkM4mdMGHRNYwJqaJDlcLGJFptnE?=
 =?us-ascii?Q?jtl1yBOXDhDP9JN6OvgTkNbLPpy6gLY+a9OxMXJGRDw9XocoDkHr1rBnUgjs?=
 =?us-ascii?Q?MjStXB9LPIJqcd9sZggHBzjsmaw0PZ+Ayjqw8ifWfPNf9VVs3KRnqNL/l+uq?=
 =?us-ascii?Q?uGhyy01slpLO/iAUiTJ2nbIUQ3I2DslFm7gj+KRp7rP4x6W7xK0ctvg32jzI?=
 =?us-ascii?Q?041wT9UoNnvScvn6irKt0Tq+WfnRR7Fh6N6Y815owuezBXkMhF1fa6hf1kEm?=
 =?us-ascii?Q?rUCEYxkxd0D9OUfvuwyEl5wREkql6aCY/am4m7Pda5rw17X1m3IL4850JSuw?=
 =?us-ascii?Q?z/KwDxwb+0lakpFNYvwrFSBRzEYePsDRLb3LW2dDKYc1/Ln0yJuyRcIUsE3i?=
 =?us-ascii?Q?jnx30uagWajRNFwtwMyI/CdecWePY8Py4WYu3gvTt6rnrXTOUkQBqjLKmJ6W?=
 =?us-ascii?Q?/HQXKagi1VH43GwYD6wdZN3PgMxlrngGXrPV/MAjC/Sagz15pvtU+c+UZlii?=
 =?us-ascii?Q?kDz7nVm8iUYMxNDWCmBnbX8SVyqpjNBmu/lqXI7a34frPOA9NrJvl87txv9g?=
 =?us-ascii?Q?jsoY+1szFL/s3Rv59dio/bPaaps8vOW2BHRMRL0sJ6AaQG0j4OXgpjEU7h5d?=
 =?us-ascii?Q?LGbGP0HoQgq24UpWyOqK/xNqoLiqRoFfr/XZn0C0nMVwxSyCxY5MtRz63sD0?=
 =?us-ascii?Q?Db+6+tUxh9zkuTpvHIuE8jerzTMR/wo2GF92p+mycVmHLD5C4cc6cnY4rX26?=
 =?us-ascii?Q?UwqrBhDu5DutKt5mSx7iCgWtzbhDalbEEPHMcznaVZg7Cr2ArYvYKXJxBBct?=
 =?us-ascii?Q?XRmA0UrZkQ+2gMo7TNd60itva6EFSP/nhCta7FweAvwQXg5M7NzOjqbOYUiA?=
 =?us-ascii?Q?HBrXqsKcvj63JWgIOlcEW6kdL01alknBE6bv6igMFU4Fi5leT+B96yEQg6CD?=
 =?us-ascii?Q?59uXZuLv1p3k3EeD5IIyuYxJdMGbb6CpjyldRqt5jbbjggcOGuGnwINnj8SN?=
 =?us-ascii?Q?128G+foH40+1G1mx/phvptbG/FVWy3c++qJTgcWcaYUepntHg3bt56T8pRDz?=
 =?us-ascii?Q?ONczhRuXqQanN7zRIpx2kYQvQrQNXmynjZo+dpYtFZrBfONa+RBV7oGo2W8R?=
 =?us-ascii?Q?+goMf1vXeL3jhP+vlGV5bBTX4QEosL6HFgRleQcXnuyg8KNHoHrA7l956sBT?=
 =?us-ascii?Q?YaMC+MTTWTuli1NRChGcKrg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E7D7ACE77FEAA04CA797E37FA7BCE499@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1146bf6d-6472-407c-598d-08dac3821195
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 01:14:23.4355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pwHPr+F3nGAIXp/qw9vaCY6a/TUuRDhEKT0L6fUpQew44bcrcECagjTtQ5rNFXvlgyVp8BXgnQYgWPpuVpgOEA4YTxyMmZ/O3/jlfvCxIis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4073
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Nov 10, 2022 / 13:22, Sathya Prakash Veerichetty wrote:
> On Tue, Nov 8, 2022 at 10:22 PM Damien Le Moal
> <damien.lemoal@opensource.wdc.com> wrote:
> >
> > On 11/9/22 12:12, Shin'ichiro Kawasaki wrote:

...

> > > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mp=
i3mr_os.c
> > > index f77ee4051b00..2b95d1d375f2 100644
> > > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > > @@ -3265,7 +3265,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr=
_ioc *mrioc,
> > >       }
> > >
> > >       if (scmd->result !=3D (DID_OK << 16) && (scmd->cmnd[0] !=3D ATA=
_12) &&
> > > -         (scmd->cmnd[0] !=3D ATA_16)) {
> > > +         (scmd->cmnd[0] !=3D ATA_16) &&
> > > +         mrioc->logging_level & MPI3_DEBUG_REPLY) {
>=20
> >>> Thanks for fixing this, Can you please use MPI3_DEBUG_SCSI_ERROR inst=
ead of MPI3_DEBUG_REPLY as that makes more sense.

Thanks for the comment. Will do so.

--=20
Shin'ichiro Kawasaki=
