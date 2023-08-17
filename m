Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41B7C678DF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 23:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbjHQXuz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 19:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356339AbjHQXuc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 19:50:32 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6953A80
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 16:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1692316227; x=1723852227;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Twc/vsy/YBp/b5EqrZbu/kUXBlWUlq3rB9cZZopHr64=;
  b=X8hyJZqZ4tf6aNV53UNZxo+x3SJM2cyCzCu8kXuobpd2mUwmjho05x49
   ymuCO0IQCgb/ii4zKAm7GCpPXqKWEvKYhJJC92QtvpB/n6s48nkLUCSRw
   sCBfN4Ow+vdiV4St/3gshIe267Aa73Z8T5JBeWvHPcQZdM2p4qV/8y49k
   9yk4Kc+/Fpnx0jHrACgG8wV7eSne4rgLpf/h8Yac4Zx3+MywuOoYgNp7j
   zZzCuKi5b73joFTq/Nm0ZyGcahFLSNEl/2rRU3xbSapn9KL3LZC9Vxqib
   s4wwHubSNta7d5nQKopFXI076yiBEqnrhQjmQy4iLExAWVS9/N2NbnMb0
   w==;
X-IronPort-AV: E=Sophos;i="6.01,181,1684771200"; 
   d="scan'208";a="241311926"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2023 07:50:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRoPJlHuiSfOY5Sy87/un8t1D3v2u6mmnCm/qBuOxQWW1OGafi9A4W+91Ct8DvYIxV48oRrnfpgg4oUDvxttZAkZ5WbTulpxuIL/QzXDE5D8ilmsDImsh/RIlvJ2QGJjwt0LAfZJDrG8oMMod8NrEAfKgRaALDKjZyU7ifO9K2f+ISVcIxLdHb6bpP7VP9N1Cn2u+gBLnTJ7/TRmIw3iOim49vRyTZrL7nfhcgukS5OyG+mi8NURTjWXlEpioAutgXrVTmRY7jWs73JUS2KSdeU3JLm4FPtp/7hIMISPTFpysfO7/J0b01G0c7VjL4RHnkvps4IgSSwG9o0I8PbA2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0E82SFKdrg8boXEiMdlc5cfQEc0t5SEjJ3ykEiB2Nw=;
 b=DU77TgJJzs+PDWKoN87tPHOUua25acs3Ryqym06Rm1bLSIQbY1J478SwysmhT2A4LsBnQUl9PMrBejgeGygqNbHN6XMubJiPPF7imiG5coV31LXvBLwaYDxAineYJiujIxrZlomwTb3HbF5YoopSIC6OGrNo2RKKwlazYeE66K0STMOsEyvkAnCCz0YvICh4ubLIJJOMENgANbWBDSJ4MZPoYHxZxtQf+gNfpPf3W48NWKqTdNKjj0nH/9KUL2z/e2Pm6D1ZMfZR4V1SCHd0yXmPuwTYyU+m5iQrk3u9YPNRkTIWBohuTuZIrEqd4xckQwSfPCpwyh//yoWM2tftcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0E82SFKdrg8boXEiMdlc5cfQEc0t5SEjJ3ykEiB2Nw=;
 b=JzH/HXAorSPzcqmkkYYxCqs5QpBZUfiRlMDSCpGGkEmc8cqmbn9ArkkMyavX3lMPRXXzUidevW0lGmRJBxp8iHjIBBwM1+xq8pN8GzT1gzBSL1l/3yQsMFOmgqjuSO8oenKP03/u/05kAKvsYgbo76Tuz+Q8zPUCUZruzKFhc2U=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by MW4PR04MB7444.namprd04.prod.outlook.com (2603:10b6:303:7c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 23:50:23 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6678.031; Thu, 17 Aug 2023
 23:50:23 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     Igor Pylypiv <ipylypiv@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Topic: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Index: AQHZ0VO0fxFCEX0RQUu2CJj+KjRNT6/vHc4AgAAKsoA=
Date:   Thu, 17 Aug 2023 23:50:23 +0000
Message-ID: <ZN6yO8Zcd6BXqKrX@x1-carbon>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com>
 <1a3f8cbb-9d2c-08c1-d1ea-4d9898eb0e23@kernel.org>
In-Reply-To: <1a3f8cbb-9d2c-08c1-d1ea-4d9898eb0e23@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|MW4PR04MB7444:EE_
x-ms-office365-filtering-correlation-id: a6189433-c7e2-42fe-f973-08db9f7cb919
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ttDlWQ6fppHAck6adr5zWNqtAt03zNqtjkHN1UH2P8awt590p2xIUFvXnrVsRprV4d7Yd7UejQagCaqG8PHhd71zsaW1abLtZLt0CB7TUHS7zF8Mp7opSaJSx7K7q2BV+kAqn4oKSW5rYufUTmNfltvDCek4Bpw8g0Pb+kEEx0PXoIwTF7OIaPiEwFJFDMLRbf3jQ30kUPfuZXcVFx/GDVUvbmw+pBb864T23zr65w+5R2Nns0lg0T5y3VZtAi3tbFeNS7otwUwO6f19V8BtCKvaNqPyCL66aD3OuTSqkHDYz/oB9+HnACGFrN8LzAm67qLxThBXCkYd0kw33+1JLEcq4IK7yBnbuy8RqAYk4CuE1eeO9t8ob/Mtg3zUT5BpR160YU1UuPMkc4zYf1ugDmXxcpQTIJOgNlLGMUU8Yb+olhX/AR9dxtrI8QrW5S5WksMHhXbd/qftObD+YeYF8e/eVfzSwNDOfQATK69YXiCJSYrk+o7OlDa1shjCUD5hjk4q2g+xPOfKqZpKjnKftgBy6IXCudF7YfKsYtYLYadFc2w5EbnT5rnFQYWK9npCd1TaunFh9aouwu4S6kuQnryIhOllUoMpX9smZf/ivIEvamUfAaGfxdUJvJnBv0HP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(376002)(396003)(136003)(39860400002)(346002)(186009)(451199024)(1800799009)(33716001)(86362001)(83380400001)(4326008)(8676002)(53546011)(2906002)(5660300002)(8936002)(41300700001)(6506007)(26005)(6486002)(71200400001)(9686003)(6512007)(76116006)(478600001)(91956017)(316002)(122000001)(66946007)(54906003)(82960400001)(6916009)(66476007)(64756008)(66446008)(66556008)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PlWNLbaHOu2WpSoXzjPBJ6OStlLznkFfovaCe+6IemrLvfd+6msyNb4/nEbL?=
 =?us-ascii?Q?ZA03wDPgbasV1iS/dXrUJXdZr3CSS08rez9B7eu0fD+kaFMOCDaSLl64RFfK?=
 =?us-ascii?Q?SxccyR4dxJ5+paYuo2gPOp5ez3DNkIBPDrRECt6WDgCrCTsI/+jDivBurVHK?=
 =?us-ascii?Q?n2LPhKgyfnpzBcVJ44/JPeTtm2csMuZFBG/neFLvQ/Su3/Pa/TDObWC4DQN+?=
 =?us-ascii?Q?+/GZZUSsHUB3dpxX0gaD0drzay4maTlI+MNp6Pg7N7+FRPde05/iFtS8cltg?=
 =?us-ascii?Q?zWPlXXF19l7EL/Y9xMRV49cAwgjOFMZsZv3EFLj4Sin0T18F7fJtv2+LRyvh?=
 =?us-ascii?Q?cvCM0FOVf+oDeBdAn8LjxKewqT0rinfW1L/cJ43qmkFJmAWvPdwZlDi7qYtJ?=
 =?us-ascii?Q?YNEXpL9sN86gw1NJeJ6VqKKX8YKC5P8hpQLSI1vxObaExk59A8T3LpUuopPC?=
 =?us-ascii?Q?4Yr6HkU3Yldz/XQ/ruJk+YJ71E1vWNdIfZ1v4rw/UN46nrSnK6cOaTu6EKHS?=
 =?us-ascii?Q?C19CAbCeRotM17i8kx8o3y7SvzmgKOmnfa6XrVZc4MXAV3j7uxtJvv+jldzq?=
 =?us-ascii?Q?4ikO5j1+NQd+xWOwZ5Y/ggm1V/l5jjKvfUxJBnx3t9H7gbo4jdw9n6y2tCcl?=
 =?us-ascii?Q?vYNTqfxQUeFSE8jJeYoJvFDEDlMy7yjlbvaSZveQ9yGZAplcaWAL8nfd8ZaJ?=
 =?us-ascii?Q?GrV0xOiKrK4vDua/Fr+EhbsPp8GBUXYkw/1c6UpNfX3jv0EcZYQ9mj+dxcBe?=
 =?us-ascii?Q?zkKvp0416QiuSws2/jbFlQM/6vX4Qfh7tRPbzNG1giUGNUw/ynDrbJUdzPLZ?=
 =?us-ascii?Q?7veBC9NFDBcJkr2Vy/SfU9zuOEGIvC23N68WACqIJivuhDj81yEAeeT8cqsc?=
 =?us-ascii?Q?LAZRxzN7AauC8MSwYe+OcBAdvs21/gTLSL0IlJffDh4ToNV2D8dkAR3unZbJ?=
 =?us-ascii?Q?4hltR1To+hRR9Pm50vSwmC+J72XaVlsjiuGtkOE8wWk++vBMJg9RlCvEMjbe?=
 =?us-ascii?Q?4+tF3jM0r/dkQSvhl18C4pp5rK0RaZN3SJNlr+8f/j+CcutcmTepvuG9k060?=
 =?us-ascii?Q?YrVJbPe/MKCTjvejnUrlSQ3M7fZ7B7Xjstb53KrjJV8A6G5cD3vybMmspoS+?=
 =?us-ascii?Q?5Vs+Shcw2DIADBl1zcBBiTOBobDeYpPCJfwCRB7qEFh6j5ckwkM6YfWVdj7K?=
 =?us-ascii?Q?9CmLKeEIfHzVOl1b8gaN38gksfMNAGNJENHi9pdLD9u9CaX4ncfwDGpW3BMx?=
 =?us-ascii?Q?xvsrz6/Qo/sL8aUE6mP538/SycIFl6SCWTQyc9Farz+BGWYfVAoZU9wWrwV8?=
 =?us-ascii?Q?XB/xTrvhky3BXY721WnbrtrNXp6HIFlpMzYwRbEbLqMHXF3zLJqcBYNlcYXe?=
 =?us-ascii?Q?P5cXp/9lg7a7+NqeVbJqNPgeVEX+0agpCJmDqeJbth2uIAhfsCn7096c52Ou?=
 =?us-ascii?Q?4mgge2p7JonTgcCKEE5cgb6cpkHw0uXL1OuTPphtL/kPZnYyNFWrDOtx9veq?=
 =?us-ascii?Q?OPSlgArfVzTu5WQOa43LwkqglDifY/M7+crRcC6nESCwa/rjro/rYCHoEcxS?=
 =?us-ascii?Q?hIJmKy0X001WZWEIwSarlMu47P8fNBpo5MLjWhXv0N0XDj+N7T/piPQJFHJn?=
 =?us-ascii?Q?kw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5DD4D68E78757149BE5C38963272BD19@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?yplN6s2LuXFmi9v24p6Xrakxa7Sp3DWQbL5uxPUOulIzrWaSMWtQbz9y+AkI?=
 =?us-ascii?Q?gklDpIR9ikzcmCT+Eu433mKxZcXDFkb6Bv5PGGbFUAh87vlw2+uumrz0pSkU?=
 =?us-ascii?Q?nQe8dzbbJQ3bk+5F62YQfOpddtyWeSjwsEDLRr/iW0ordGsgzfSgRLETBAa4?=
 =?us-ascii?Q?WmjldDrjoN+drECTpVPHph5+4Pj9TKznhaMHXgCr4Qy1PwfI9fE+lOCu9W4u?=
 =?us-ascii?Q?lSqo4cWVmLpritc1PZEImwoBhcrSeAs1OPBshDtggVWij3k86usiaOfAG7GV?=
 =?us-ascii?Q?iPUsCf+NxsRlmGJ/gLJzlBNJuXb+th8Prqs4zhzeeF4y6YFPppnd5dVUU1Ez?=
 =?us-ascii?Q?c0SF5qPCbPYydun96FQNkbi8HJsHW8DiBKc9dVU5cL9rVwdpYXcWhudBvxAG?=
 =?us-ascii?Q?r2YCbjCxpbmzMfo9VX41XWPYecC8XzFUs7w+6NY2sXIdqZoDl/ukn8SWrISE?=
 =?us-ascii?Q?6YX4FrCiHsOTw1+M5lafSW0phq83PROZejHDsB91YTQM8NykZAf3hh+psabn?=
 =?us-ascii?Q?qEHT1EwuPHSMmq+tFtlstyxBgWguNzFdsSZZWATZ0arHh48qIbY0z52dc9P8?=
 =?us-ascii?Q?qlo/HvQosIw+b7tsVXLbXCMKgQ6ffR1OacAePvPIt4bOjF3WJ1v/jmZ3y3Ym?=
 =?us-ascii?Q?/InC9nVBxu7xcrxxVzF7yZ52uvpiOSax6HO1v0Nx2/T7I5vZdXDyKVCdxgIM?=
 =?us-ascii?Q?W3y/Q/+GbL5zUwOAtKC0Ayasd4MnFh0Ony7fFzUNCCiL9Xi0JWGbd6k3wyIB?=
 =?us-ascii?Q?usP7II0MP3EOBgrj+nFjsVVUS8LyAhgQtBAdXUk8mqRqc/UJxIV1bkreDly2?=
 =?us-ascii?Q?s6y9gaXf7ImPkD+YkwMrK++4ATlCwLYOuzh8RMAw2OspmkymoxAzaO6xAILk?=
 =?us-ascii?Q?nLBPxZf3Ivas/J9GpowyFyZ3d6Z0/uTsw2E0Q4+dwyc18+1l5HGzSmTynvlY?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6189433-c7e2-42fe-f973-08db9f7cb919
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 23:50:23.2681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaDvvCAlZHU9GvuuOg15Qnnw5b0IPZdQYOTs+4VCOROTlWZcQLnvnIDNbgcQkNtovIOrTi9PbYgsnmr+M1psOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7444
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2023 at 08:12:02AM +0900, Damien Le Moal wrote:
> On 2023/08/18 6:41, Igor Pylypiv wrote:
> > For Command Duration Limits policy 0xD (command completes without
> > an error) libata needs FIS in order to detect the ATA_SENSE bit and
> > read the Sense Data for Successful NCQ Commands log (0Fh).
> >=20
> > Set return_fis_on_success for commands that have a CDL descriptor
> > since any CDL descriptor can be configured with policy 0xD.
> >=20
> > Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> > ---
> >  drivers/scsi/libsas/sas_ata.c | 3 +++
> >  include/scsi/libsas.h         | 1 +
> >  2 files changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_at=
a.c
> > index 77714a495cbb..da67c4f671b2 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_que=
ued_cmd *qc)
> >  	task->ata_task.use_ncq =3D ata_is_ncq(qc->tf.protocol);
> >  	task->ata_task.dma_xfer =3D ata_is_dma(qc->tf.protocol);
> > =20
> > +	/* CDL policy 0xD requires FIS for successful (no error) completions =
*/
> > +	task->ata_task.return_fis_on_success =3D ata_qc_has_cdl(qc);
>=20
> From the comments on patch 1, this should be:
>=20
> 	if (qc->flags & ATA_QCFLAG_HAS_CDL)
> 		task->ata_task.return_sdb_fis_on_success =3D 1;
>=20
> Note the renaming to "return_sdb_fis_on_success" to be clear about the FI=
S type.

I'm not sure if I agree with this comment.

According to the pm80xx programmers manual,
setting the RETFIS bit enables the HBA to return a FIS for a successful
command:

PIO Read: Nothing is returned
PIO Write: Device To Host FIS received from the device.
DMA Read: Device To Host FIS received from the device.
DMA Write: Device To Host FIS received from the device.
FPDMA Read: Set Device Bit FIS received from the device.
FPDMA Write: Set Device Bit FIS received from the device.
Non-Data: Device To Host FIS received from the device.

So the FIS you get back can also be e.g. a D2H FIS, if you send
e.g. a DMA read command.

If the RETFIS bit is not set, and the command was successful,
no FIS will be returned.

So if you really want to rename this bit, then we would also need to
change the logic in pm80xx to be something like:
if (ata_is_ncq() && task->ata_task.return_sdb_fis_on_success)
	set_RETFIS_bit;

Doesn't it make more sense for this generic libsas flag to keep its
current name, i.e. it means that we enable FIS reception for successful
commands, regardless of FIS type?


Kind regards,
Niklas=
