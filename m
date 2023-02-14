Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D510C636D4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBNAUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBNAUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:20:07 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E03119685
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676334006; x=1707870006;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NNqZFtUg6N4RCubpfa1gJC28FYZUmxqq6SoAZ/odxAQ=;
  b=YVPhciEgEdMbYt9Clgt2or0w1rJjuAtBi/kU9EO2vn8bdL+/kW65t+kT
   XxI08Y/uDtta6Rx8C7afjUS7XYzyC1Aylm3Dtub1v5zwWoWmRk24O3Kop
   qYRR2tNF9enPnVGa7kd6DSQunScpysIeCgL7vmL400n2rE1lPVa3PIQaO
   w/LBXFnOJerzj4z+cjz4kPLJgS4QKGJbVqROJKQWpG93meJeTL8QR06DF
   vU2bkXJAmPWbddDUQ5EBdmSRTDQmRBsZ5UAkBcOCcGTit9638dbvnmIvr
   MM4HXeWJ1LUG//Hw0zSJeswTSttYt2IMzoiITYAOSOP69moInX6hqjdCc
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="221521644"
Received: from mail-co1nam11lp2177.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.177])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:20:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bjVmyQnbbQHvbaIhRAU6x74RUCmFlfOgLgUU2KXAlwYZQpXwf/YmM01o5SUcJRJC569AdWN67EMBYJFn3SZepPq/G/Q7onvG+Kv72YVTIhlGO2W41N+zzCdN4nYFIfedW8iYOtqbpOeTYCvXe94MPSh7ByWl0WNP7gZ/S16MYXKMWpdHYQopMHa5ctTyFStBQfIp9k9Lu7PBlDqvnyZtR4BQXvqvUZ42RfhGa6gNyvGh7AKfxOYnOYuqYJnb9mCrucsI0dp6m8I4LsA1vCQfl/cswdUSExsO8cmqfn90K/Vz8a6gqX3j7CVFKkUj4ilJjtQcUOVdTKbBcU0PMvfFkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2P6EQIzdF2JRnBm1QVFVgB+wGA855lgA1NwbLMCI7w8=;
 b=QmPJjMgRfLQO7GqRQ5fkruNJXGVvQGuskGLRSWNPE5F5SlHwLNPFB6tTiT5asu+Yjv5rtRgAnieUOTgiWVScZA7B2XrZVb9y3rR5uLiE+/YZVHQX4uRY9GENgNrRymf4gjiB9ypSK9+9ElTG/eyJhqRXdr7eYRDUKFBfWnsTYe8tbTugped9fT8VV2hAZKQMB2Fw+cQdZ5hQvkXJSzLBZ69c1KU0hBJ3PU/5cyG7sREx9OOrDz2PbVj96ZKmxDwOH9z2BttJrWTZSboOh7Ot/J3St047b9U7lnHkEehphvTtIJoVOkJoh2ZWgguyEHTbgkTly/CYXoO6RNkUDsvJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2P6EQIzdF2JRnBm1QVFVgB+wGA855lgA1NwbLMCI7w8=;
 b=M3hpWevwIcr6aR6tX1K7v07bpT7xx8shtjUy+EiXcUp+F5FttDNna97ivihvfrQiS96iBzJcE7ZTOVxGaHGoPPwtVSB6RtZFACZUNf/WawBNvrct8R/Kqmk2x3OPtydnf+eWYxhDL8inTPeB5BXwLob5AFnlNkawfcz1J6qD3Yc=
Received: from BN0PR04MB8048.namprd04.prod.outlook.com (2603:10b6:408:15f::17)
 by PH0PR04MB7208.namprd04.prod.outlook.com (2603:10b6:510:b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 00:20:00 +0000
Received: from BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::3564:3ac5:8178:34b7]) by BN0PR04MB8048.namprd04.prod.outlook.com
 ([fe80::3564:3ac5:8178:34b7%8]) with mapi id 15.20.6086.019; Tue, 14 Feb 2023
 00:20:00 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v4 4/5] scsi: mpi3mr: use number of bits to manage bitmap
 sizes
Thread-Topic: [PATCH v4 4/5] scsi: mpi3mr: use number of bits to manage bitmap
 sizes
Thread-Index: AQHZMhmEYqkjraf9s02Vt+211r0ekq7HG2+AgAaUg4A=
Date:   Tue, 14 Feb 2023 00:20:00 +0000
Message-ID: <20230214001959.5sep62afvm55m2z6@shindev>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
 <20230127063500.1278068-5-shinichiro.kawasaki@wdc.com>
 <CAFdVvOw4NmCcqMkGdYtfdXzvuWw5Puw8_2ritWiHBPwzz-YLTQ@mail.gmail.com>
In-Reply-To: <CAFdVvOw4NmCcqMkGdYtfdXzvuWw5Puw8_2ritWiHBPwzz-YLTQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR04MB8048:EE_|PH0PR04MB7208:EE_
x-ms-office365-filtering-correlation-id: 1137c3dc-4a7e-4d7d-37b6-08db0e213604
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jM79S4pehCA09wdQ4FTm4isiLwZcTOa8aAsKgyeghZ0ctO5tG367IjIou3iv1tb+VT8B+FlZIqPqEMgCXytN5wtbl9A2ttHWJzel4YoXHjBYJSOPb81t4vNHdhYr3azrvwPMyLx4o56avJ77Ui1pv4yK7rbucYe2Su0u/4xZY+Rfpu8K59z69KKijK+x+fcldJtcGpQrIvgSw5i/Z6tVv//0svjVy+dBkpJ3E7IAQuxN0Ed0ghwLjTBMNWazI4ZxXt1QplKLX44TtxxSe4pv9lBmtsCndgyvWpi8QiNiIVLTKXONzXowarAdOLXfTIQujQUI6GixNuNjo21qrfBdjMmp7RRZZ1GdGKMljBxhmcvR25yvjZitp9jnaqubwzk92SNvzd2qILQMI/Ooqlrs7rzUSuCGv+RJChBbMq70wLqtCB5rnSPC5nKzBAkCRUkgZDq/SSJvqVWMoXYI3M0VoDTY+VmgbtwLoIw1Yc6SpUK3YKN1kqkgsQyChi/bh75bz3qbVEEaFU5to8R8QjoTZtJS9ElQ2z+xcTjdKKzZCGPJwtiHU8K7WnRj0G999OSjLLNe3DsVOBAZPIBrSfhlYSkn+jU1WjapuXLnpMeIAtAVEvli0uIjMUDQjkQ256wAVIH96eupDUCzj4Ubob3DYMtXtJwd1zD8ifhW9lg5WEzNiFxvUk4uqRHTcX57CVdK4MtwF+r9m1cTuE2zQE2eh0oYYH0Uu1WtAy8frnTlS0k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR04MB8048.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199018)(82960400001)(86362001)(38070700005)(38100700002)(33716001)(66556008)(64756008)(8676002)(66446008)(4326008)(66946007)(76116006)(122000001)(66476007)(54906003)(316002)(41300700001)(6916009)(91956017)(5660300002)(8936002)(2906002)(44832011)(83380400001)(6486002)(478600001)(1076003)(71200400001)(9686003)(26005)(6512007)(186003)(6506007)(53546011)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MDopDFrEeaO1ZVRnUMoM1NnsOddB9NSwxvzizi1svwMFjUwOK0kfDR0+2pHs?=
 =?us-ascii?Q?9wLTC9jLJzBQXu2NChKn1YbbzZdRePXFC/oJW8owo0buNBYyGAL24GQU7nmk?=
 =?us-ascii?Q?rxBkKfnOtGzoU8gQscr5HGc1I2UjFGgdwwptruNyM4G9Q4TnNtiXgqHbJVKh?=
 =?us-ascii?Q?zX914Ul3SwiTCcAO6PjYpQhpnzBlhza+nxWq8hqU1V+06ITj0qTttyxu0FWh?=
 =?us-ascii?Q?vzMrUcLw3UYR+MeM7/+vleL6OH1gY0XNvPnpppZrTBjfu1whax0YJdd4kJXo?=
 =?us-ascii?Q?XIq87C5y2Lp8q8TVo4PNjt7tF0pof7EmErOYbmem2/k7bqHFgXDcqYlZEmHy?=
 =?us-ascii?Q?tKrfCPkTmnDhM+8oxN96sq9+IULcrOYC4eOrUo7BtiQxiAscmD3O+lNQ6hXd?=
 =?us-ascii?Q?m+oVriHbqkL8/S6KPyH+cJ4DZ1I2jbuRdqOV2uKfxORU6yMfIWgUDH9ZhXKf?=
 =?us-ascii?Q?OuIENIQARg9rIre0ccq6T2EOqu1dWJ+Ld1YCYKF0+ggRcPJ4s6LwSY1KnXwG?=
 =?us-ascii?Q?O029AoumI2q0aEHor/2o1meT16EFzm+z5i4hritpIN/sjRt+Rqn2vJsV9rq2?=
 =?us-ascii?Q?VNdE+W4OoiK2+bQeIsqBi4DJtyXyX1WSkpZvQAAKr8oA+B2ZpS8XBkhbpJ29?=
 =?us-ascii?Q?shLYEt/GRDjbqd6Rd3KH71No8CfnkbCXmNgCGU8a/M7FZGBSCLoJ4O4dMjT4?=
 =?us-ascii?Q?8zaU2ZnLGyvY9fRl/eGOrnoiY5eHoD4BZoxC0DWrHUdt6hSn7a8wHjtga3p0?=
 =?us-ascii?Q?MJfuiciN/GpZO3e4Jq54tLsN/CzQa03n4ZXsNoUxdNHgxYLsH5q7VqZTxI48?=
 =?us-ascii?Q?eODT7UKYxj/V7ffPv6aAIUjAIglIdeIFCvwTaJiYTPrI0n4lw3QhxJ14+m9w?=
 =?us-ascii?Q?VqMEwx3VDxHttAxPPrCOGYxvAzo+ZJJZC3vv6jyrYq4SMAvxKKHfnMSkFqMk?=
 =?us-ascii?Q?K0Wn6vGxadoV/dNNzb70I3w0MOsQZ+/tZcpzZwmM7CZNV8h6CfQlHfeP4/Dx?=
 =?us-ascii?Q?bN6J8pI2T2sEq54U9u70jKMCdtHBdkV9+FGRW14aeA5OH8IV5EW6lEcqDXoI?=
 =?us-ascii?Q?SVQTxkgoXwpA7K0QB7fS5h3GhJKB7SeVrCMsk9JMl7+vdt0M9xLAMef97TK5?=
 =?us-ascii?Q?3kv1a1yllP9/KGiaXH2lVMQL1ADeKRlxdRjGn953QqTIQTtfPR+R5GO7oI8B?=
 =?us-ascii?Q?BJwXeE1UUAfKSwbPkIDVlGK9OpPBtgvsOfwCnMgflWmRdfx5yP8FBxj30Hs/?=
 =?us-ascii?Q?0qNW8tJiVULFRRbGV1bNbv6cApgBdV2Nu5wEAeMmUXbWrHLjFqQY6XIVsBjJ?=
 =?us-ascii?Q?WMsS+h7x5VcOY2PnefiQW8C4Viw1twK9M1pMe+x2PniG8prI/0WrTt8oOI7W?=
 =?us-ascii?Q?3zHnxQKLOsB1KsWPIeW9fI96h3zc/EVQvkFyUYOcaj6ZHqv0m/PJykUvk0eN?=
 =?us-ascii?Q?1V4+5RNgrR0R/L4PDKhAuFKBC0Sy5KjbxmQysKPU9RqUAqeMkkslzArhMy3M?=
 =?us-ascii?Q?e27SKUltuhUV+CbKs3h+Pv7aNf7Z6aX7/Thrqz6ZHnHJ1BBZMOAUu0hhPMbu?=
 =?us-ascii?Q?Zr4ReBuirEMHP9YnKPbmpUJlBo7tCnEHoUUzwO2h7BS1bO4drMFI3PovPMVD?=
 =?us-ascii?Q?XHE/ly97TRhRh/quczWiXqU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E65315CB20D27D4E93E50BC7BAA48D0F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R1AJwZ05Br4Du6ng99X/7nbpvCVRbzrw4imr4OnKckC3obgArBK4tajtHySJgNY0IfKw5rmt53SMoZ3R+GpVwtotnr+8m7kVMYPiB4jPw0iWPdPWEUVio2T8/Fo9BlYhwbMEJaoOUaK9vthcLlhH/CX1foPvuABZC/VOTSwnR90kY3+El62za3QEiTvdTA7Ckw41S81jbMKSky+ffeNpbYofb7+Wl3rHp3ac6b1/eCmlLi8Gdk0iHBK8Ws8Mo53l3lCZDJpNKlStVBXJEn9UOBBxUXXI9j58dfZLMk98P6+OT7ho95xFBazMF6w4q0guous70xQKsLJK6IvFOhdtDHKO2jCk0m0dyiX7bEaptY2jYqDEX9kUctcIHkimHuclPYN3d65tI0Kz99JeX1GnOZpkpgIT1xcsiKycm+P2iQ/1MmfPBLJnid8UaSVc5XsOnnXXT4l3etuXYEEGuwwdjls88vUhjqL6OggA/Dr0UcEIGoGU7nC2//opiuvwua/C7UEd6rD2WW8N97ijt38OKqdVVyOUGEUkfiYTjJtuvJsCWUEUfozFBJtOeXL4sh/npnx3sEuYTZ07jjP+gZ/er1uW2Ij1k+r9updaqSCDMri2lfqyHVubOVfL10murmG5hUnkCX1JIrim3F4VwQCc7ISFQvzjC32BerdlOMM8uocP4Jv0o+WZPe9BkgBbad7gcmO8eSUfMQJR7ZbPHZ7ujf8LgQ64vwaL8MaEQRUNmKfIu71j2CJfwaorV4P8AlTGxxI7jQfOZVr7CxQtTtLlMqcB9LnKwLmF+Xwh7TTL/OG7wL5LIlQyTbRakY6B76Sg5iOmOGtjGOe6w6w71p7D3dhcL8T4H5O0a56s6m38FH4=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR04MB8048.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1137c3dc-4a7e-4d7d-37b6-08db0e213604
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 00:20:00.5387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XALroUq345YeaFc9wyPgyEQsmipDKhsC7fOl2dxRSpiUTxjDjKaR92+UGGjl0o0h6P8/DtkS2UXQ+u2x0kfuSSsDLDZrBIGOdWFMV1Jh6NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7208
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Feb 09, 2023 / 12:50, Sathya Prakash Veerichetty wrote:
> On Thu, Jan 26, 2023 at 11:35 PM Shin'ichiro Kawasaki
> <shinichiro.kawasaki@wdc.com> wrote:
> >
> > To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps usin=
g
> > byte as unit. However, bitmap helper functions assume that bitmaps are
> > allocated using unsigned long as unit. This gap causes memory access
> > beyond the bitmap sizes and results in "BUG: KASAN: slab-out-of-bounds"=
.
> > The BUG was observed at firmware download to eHBA-9600. Call trace
> > indicated that the out-of-bounds access happened in find_first_zero_bit
> > called from mpi3mr_send_event_ack for miroc->evtack_cmds_bitmap.
> >
> > To fix the BUG, do not use bytes to manage bitmap sizes. Instead, use
> > number of bits, and call bitmap helper functions which take number of
> > bits as arguments. For memory allocation, call bitmap_zalloc instead of
> > kzalloc. For zero clear, call bitmap_clear instead of memset. For
> > resize, call bitmap_zalloc and bitmap_copy instead of krealloc.
> >
> > Remove three fields for bitmap byte sizes in struct scmd_priv, which ar=
e
> > no longer required. Replace the field dev_handle_bitmap_sz with
> > dev_handle_bitmap_bits to keep number of bits of removepend_bitmap
> > across resize.
> >
> >>Thanks for getting this changed, can you please change the kfree for th=
e bitmaps to bitmap_free for consistency of the API.
> > Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update =
operation")
> > Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks"=
)
> > Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> > Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
> > Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > ---
> >  drivers/scsi/mpi3mr/mpi3mr.h    | 10 +----
> >  drivers/scsi/mpi3mr/mpi3mr_fw.c | 68 ++++++++++++++-------------------
> >  2 files changed, 30 insertions(+), 48 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.=
h
> > index def4c5e15cd8..8a438f248a82 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr.h
> > +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> > @@ -955,19 +955,16 @@ struct scmd_priv {
> >   * @chain_buf_count: Chain buffer count
> >   * @chain_buf_pool: Chain buffer pool
> >   * @chain_sgl_list: Chain SGL list
> > - * @chain_bitmap_sz: Chain buffer allocator bitmap size
> >   * @chain_bitmap: Chain buffer allocator bitmap
> >   * @chain_buf_lock: Chain buffer list lock
> >   * @bsg_cmds: Command tracker for BSG command
> >   * @host_tm_cmds: Command tracker for task management commands
> >   * @dev_rmhs_cmds: Command tracker for device removal commands
> >   * @evtack_cmds: Command tracker for event ack commands
> > - * @devrem_bitmap_sz: Device removal bitmap size
> >   * @devrem_bitmap: Device removal bitmap
> > - * @dev_handle_bitmap_sz: Device handle bitmap size
> > + * @dev_handle_bitmap_bits: Number of bits in device handle bitmap
> >   * @removepend_bitmap: Remove pending bitmap
> >   * @delayed_rmhs_list: Delayed device removal list
> > - * @evtack_cmds_bitmap_sz: Event Ack bitmap size
> >   * @evtack_cmds_bitmap: Event Ack bitmap
> >   * @delayed_evtack_cmds_list: Delayed event acknowledgment list
> >   * @ts_update_counter: Timestamp update counter
> > @@ -1128,7 +1125,6 @@ struct mpi3mr_ioc {
> >         u32 chain_buf_count;
> >         struct dma_pool *chain_buf_pool;
> >         struct chain_element *chain_sgl_list;
> > -       u16  chain_bitmap_sz;
> >         void *chain_bitmap;
> >         spinlock_t chain_buf_lock;
> >
> > @@ -1136,12 +1132,10 @@ struct mpi3mr_ioc {
> >         struct mpi3mr_drv_cmd host_tm_cmds;
> >         struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
> >         struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
> > -       u16 devrem_bitmap_sz;
> >         void *devrem_bitmap;
> > -       u16 dev_handle_bitmap_sz;
> > +       u16 dev_handle_bitmap_bits;
> >         void *removepend_bitmap;
> >         struct list_head delayed_rmhs_list;
> > -       u16 evtack_cmds_bitmap_sz;
> >         void *evtack_cmds_bitmap;
> >         struct list_head delayed_evtack_cmds_list;
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3=
mr_fw.c
> > index 286a44506578..d25cd0382e20 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> > @@ -1128,7 +1128,6 @@ static int mpi3mr_issue_and_process_mur(struct mp=
i3mr_ioc *mrioc,
> >  static int
> >  mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
> >  {
> > -       u16 dev_handle_bitmap_sz;
> >         void *removepend_bitmap;
> >
> >         if (mrioc->facts.reply_sz > mrioc->reply_sz) {
> > @@ -1160,25 +1159,24 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *=
mrioc)
> >                     "\tcontroller while sas transport support is enable=
d at the\n"
> >                     "\tdriver, please reboot the system or reload the d=
river\n");
> >
> > -       dev_handle_bitmap_sz =3D mrioc->facts.max_devhandle / 8;
> > -       if (mrioc->facts.max_devhandle % 8)
> > -               dev_handle_bitmap_sz++;
> > -       if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
> > -               removepend_bitmap =3D krealloc(mrioc->removepend_bitmap=
,
> > -                   dev_handle_bitmap_sz, GFP_KERNEL);
> > +       if (mrioc->facts.max_devhandle > mrioc->dev_handle_bitmap_bits)=
 {
> >>Free the existing removepend_bitmap prior the alloc.

Thanks for catching this. The existing removepend_bitmap should be freed. I
think the free should be done after the alloc, since the alloc may fail. I'=
ll
add bitmap_free after the bitmap_zalloc() result check.

> > +               removepend_bitmap =3D bitmap_zalloc(mrioc->facts.max_de=
vhandle,
> > +                                                 GFP_KERNEL);
> >                 if (!removepend_bitmap) {
> >                         ioc_err(mrioc,
> > -                           "failed to increase removepend_bitmap sz fr=
om: %d to %d\n",
> > -                           mrioc->dev_handle_bitmap_sz, dev_handle_bit=
map_sz);
> > +                               "failed to increase removepend_bitmap b=
its from %d to %d\n",
> > +                               mrioc->dev_handle_bitmap_bits,
> > +                               mrioc->facts.max_devhandle);
> >                         return -EPERM;
> >                 }
> > -               memset(removepend_bitmap + mrioc->dev_handle_bitmap_sz,=
 0,
> > -                   dev_handle_bitmap_sz - mrioc->dev_handle_bitmap_sz)=
;
> > +               bitmap_copy(removepend_bitmap, mrioc->removepend_bitmap=
,
> > +                           mrioc->dev_handle_bitmap_bits);
> >>This copy is not needed as the data in the removepend_bitmap is not val=
id after reset and the zalloc already cleared the memory.

Okay, will remove it.

--=20
Shin'ichiro Kawasaki=
