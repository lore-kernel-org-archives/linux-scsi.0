Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D453C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 10:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiFGKFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 06:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240723AbiFGKFR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 06:05:17 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD645EBD6
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 03:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654596315; x=1686132315;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OQobwY9BKAv2ndogNhE3V2bMcs9kT5evmgodMq+fPtg=;
  b=Y/z6M0TlPPenfE1Pz+LyIPV7mH9PGydHe0QX06x+cZz6CQXc0z8uPgGa
   dVEMsfwKCPamCWwRJuHvXeTWkGU4DGcXQwQX+4+QmoYnHWUfChwWryuN0
   A5folnAQ3JORnc4kbfJu7XoJe/Wr+dxfj3F/rGjzakh/OvUWNw7lsKPyJ
   9BMEmK4HQ8ai11w9+E1tynY/GyKCbyKP8DpdvWPVREsGdTN+GwSCWCrOb
   9K8Fu19ZghfHl796AC4WuLRvky7WWIly3F7jNGaJuKXYEygEti9dDzCLT
   hsVonVSokjdihPKgioaeL+Xz9QGy6TBJUsX409/Z8S1KKIxatmNH06pL7
   g==;
X-IronPort-AV: E=Sophos;i="5.91,283,1647273600"; 
   d="scan'208";a="201206585"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2022 18:05:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIdWZoPy+398XZigzfJMHWBLe66myrCQFDL+o4ZZ+U522JPIcLpxbEzIq/6BP094woB22Y9ZIWQHcL7WT2AaYjsyiFUxCq5u8GUxHqFAg6Ch2R83J0R3CJDhfzvhFRswQd1Y5e6S+Q0tlDc2pR1EJz/x5aMNJHdJaZoIByVBgerIyg59a/UR8dCL+cOTBHOHVvnM5chRRMRWQWEB8D4xFvjg/vJlQYxtUiW64HtFhOSlenC0anL6ZAmAgP1cfRy5ytJo0tAS9RvZrjAi9AwOGgSzqKeSfZrYEirM26gZRsFmZQW08JVDL+LisucsbTqNELxnEe2efi/bPiUDQ3qMhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StPcx+ArZZuAJlOQuC5vmRcEeHXUxdrOjSde9TFrsFE=;
 b=dEijh9GS5/F5V2+LFLZ6BudVOkbT1tj8urR01JcqXzvF1wmYFDfA8mQlAQ9Hx53UAcgv7tGf6bt0EYKw8BpCK7P7lDfMmh70ZzDKpMz5bBOkwCT+S2xvoaFeV5Hdy/hmJlDTlaBnx67sSTG+wNrY9aFraArtd550AEE9MhRzuP5QMIpErPIp0V9bWaxTJzTM9JvejHuZcI4ZVwDtAnxcXLuZa///HedjpviUPARs3dE6FAeF25Cp8ZxvG9JEjhH88Xtk+IsRIdMoOydC7VT+IfT2E91wOYyAHMqD55FaAiyRvTUslO9ETBLIG3tENqOcVuz+z29hLmhlKTxRDj1Z/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StPcx+ArZZuAJlOQuC5vmRcEeHXUxdrOjSde9TFrsFE=;
 b=CtWerGJQnx6JW8MZOcGHqFoq+hK3PDv+nf37pUt7Dt4UCR5NNLwuUWGJ3PvIaJrKcu3il9PBEQXEixhHTFAV4JttrsVRlT6bSUDoIg88lyXaaohy8GxQn10D0pwiTesI/bweKHenSv9KN7rOPG/CwzJatB+WQOws8CNvJ9VhUck=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by MWHPR04MB0977.namprd04.prod.outlook.com (2603:10b6:301:47::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Tue, 7 Jun
 2022 10:05:13 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::19e0:250c:79ef:1617%3]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 10:05:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Thread-Topic: [PATCH] scsi: scsi_debug: fix zone transition to full condition
Thread-Index: AQHYek88ElC509gMvE6mTbpf/6AP0q1DrIKAgAADMICAAADcAIAABvmA
Date:   Tue, 7 Jun 2022 10:05:12 +0000
Message-ID: <Yp8i1zE0AK2sxFL5@x1-carbon>
References: <20220607014942.38384-1-damien.lemoal@opensource.wdc.com>
 <Yp8XXXX/vYKvuvSS@x1-carbon>
 <a2ca3cc1-f948-e9bd-c335-3b75190fac49@opensource.wdc.com>
 <Yp8cRb77m3f7zZTH@x1-carbon>
 <65a28eb4-31ea-486b-2f77-a7d11418169c@opensource.wdc.com>
In-Reply-To: <65a28eb4-31ea-486b-2f77-a7d11418169c@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b68fc771-faea-4f69-3703-08da486d364a
x-ms-traffictypediagnostic: MWHPR04MB0977:EE_
x-microsoft-antispam-prvs: <MWHPR04MB0977EF02A746C738C73DD954F2A59@MWHPR04MB0977.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcSY+NJ5SxubAF1vV4qQPVKkP4MkAy93Wolv42Z6OCUtaVNbgtpNsTsNv604V5J9JbQFrvBg005MCFg67x+H6YRsoyZV+sZp/zZw3JMd6iLp+JK9+GcO2XEz7cUhQXLuiyUAQt2nBid6oJzwPTSSzx3RJg2EwFHtBeCqJig/z5Z37Ov5FfZTSqXWozzg49aZ7NIi4/bJ6ytlrgbJWFwSYmqc6HX4J1RXiHl/uf8gNvN7QUllJ5Fb8dnrnhpAg9QMwXLURjVRVMD80KeygrL8N1Dj20cGxNkt39KAZVL+1x7bSSvfuzMz5jzNSFJXwfcf7rLg6Pztj7ILV2aDG6PSMUJ5ZFZ5C+lHvZxWgJHgvC3juylg7f0TD4AcdTp94c6ERBWLLCJewRwlRmM+5j8/wKVUXQk/633OuXvldZ/TABgESBLlZ8uT/EIHpWxzsfBn8Y6eImt35Pw3xEG4cVzvYSgRxWXxlmkd0hPPjxm2xhgGcbZZ1Z1nA5lYSAWciko1r1I2P1UbBbjYMqAQSm5NFwlz1NeyVbRS1VkW5XEBSF+m1wYlTjE5JTbShHdSlZ/6UxCC1xSOBFPnZtfOLEuetm+hhSIW9FOAeUlW2KTgpAyqUd/B5pHKy+i0tX8Mss4gQS+1W0eUXhanbb68toH1vtkV9N7aoHinpHxWdnCpDx8CuYFbvpMftwIi8KlFiv1ziq3FXAjVvftaH6P+0SGjfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(76116006)(38100700002)(83380400001)(186003)(71200400001)(6862004)(8936002)(38070700005)(5660300002)(508600001)(2906002)(6486002)(316002)(54906003)(6512007)(26005)(9686003)(122000001)(86362001)(82960400001)(33716001)(6506007)(53546011)(91956017)(66476007)(66446008)(64756008)(8676002)(4326008)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QdU4pcWkwff2jErGc3XmIl2jkmJ1/7Tg3bifql8XQnkwD5kWcs0VNRmEgI1x?=
 =?us-ascii?Q?VvJ5ERfgGiJuWDZlgQoZiQbUW9uOJXuD+rjq0rnzrkDzqT/vQTOyYAEJuKGk?=
 =?us-ascii?Q?9gNwJjFsMMxkkF0BxQTNgvQk5mmwynJAfGPvqaKS5QZiXiLlZ9ZxdcYjHhiA?=
 =?us-ascii?Q?Q5JcIu7vUwjRfr/AahA4cHC/+YbZPwzhm0EiPXDUv7ORmWctRCZX9qACPuAE?=
 =?us-ascii?Q?kzEn/HYOdjZ5kxkTHKqn4SeQFstGWhLQsBPrCZ8nKviY0AqCGOeRzWia68JD?=
 =?us-ascii?Q?dqT9o/QKS+ugk0tcqPYErasaPkqOxoqcTJLHr7rkqqhOdhnrsOMONQO8Zxim?=
 =?us-ascii?Q?Sf0Wt9AUxw3SlbgRP8UFQ/3x226Wcc4JIfsomhk9Ynqv/ZveKHWIlAp6Af0x?=
 =?us-ascii?Q?g5KLOjFrgK7ighorjLp9SBczCHrNfo0OPa3XPqP33KVQcjwn5grNKucsuQzd?=
 =?us-ascii?Q?MpWkw+/ZQoCHFolQv5NcEGvkZf45nPVJVLLmNNxjfrCA/HE7fBSWF0gQr9UU?=
 =?us-ascii?Q?iKPONa+7UH3ByjCGuws/Hgbny/erSg1jUCn4ii8uyyxpKTeLZzrZxZ6zEK8Y?=
 =?us-ascii?Q?ls/2Zqkn9/uXoaYlbhEjZA/yVMeIbN6Ic3RTztC7G8rVK16wzDC63vljFF3y?=
 =?us-ascii?Q?C+f3hefh8mPyWdWXnhwHSYhqKyacR1mtdAEMHE9xctTMCEK25ckQ3nJahWMP?=
 =?us-ascii?Q?SaJeU59EvC7uRjvWPEXX96OvFs0OVt3bT+ofGRwVzlW9DFMjZ22U+wlNeL+W?=
 =?us-ascii?Q?jQEtRpNgwv7E2R/5ac54BgcTpXGh6eCPPMJEhJRDWhs//uFHTconT+nlPiBd?=
 =?us-ascii?Q?WawAZYzcGrNWVAbYzJ2IvX1YdC62vU49mJKPW2na2MKicwASVJCLYb65e51a?=
 =?us-ascii?Q?fMKtYkDMLrEFHSikPI0AZXRlWw9GtYRv/TB0yCl48vD70EKNjMn5tJ29GpwU?=
 =?us-ascii?Q?aGvbvNtpNEY8zBmV6vgVsWYupFjzui4/gJZP69nrSjr/bBponPNDfDV5oZwm?=
 =?us-ascii?Q?bUdTZ7A4yVk9W8iI6TscHSY9Y75ORMWMsxsaYt6hZnMsgylvhQHkSHvITdlC?=
 =?us-ascii?Q?8ImTwwD4iN/BqEhG09i3Eeku1wH1LacyhA8r5BC7VHYoj3kIio3tg6Qb8Uhr?=
 =?us-ascii?Q?pnFJEiS8ELng48Yb0vufy5veEPd48j6AbbfxQLdEGHk4RYWMZgUoybCfi3lw?=
 =?us-ascii?Q?zoxMwR3nxSxL1gPT4lh9TD2un3P4QINm5GEi7As/01hxSJw6ewQtolOYRBFF?=
 =?us-ascii?Q?b8ipP/dPB5ErsTtYCVBxKT5pZA9r8LTkClF1ua/ODkulaX8S7/PjydXlTI5l?=
 =?us-ascii?Q?rGT6feNvoT50okm2k0tsF8/jDhbN7H7BJHNzDzev/gx1JLi16e9Tm1bV2Yi0?=
 =?us-ascii?Q?1lKO4qwxL3W9Whv7l7vnDr9pJQNBsVE38+LHYRonbDyMoRrP+PO8IgrNX4tS?=
 =?us-ascii?Q?ET4qvt3JxY6XejCM/5shAhN9rAeZ1stVIRXyI2VtS3lHJeh7qHRQi0MCgGLk?=
 =?us-ascii?Q?25f50qr0F2BsJ7FZuncHOFxTUAMfxBhhYRW5rLL9+yRXi2n64EaXM663tPCm?=
 =?us-ascii?Q?iJO4Qjgw7YOKtpou+gDzM46VWWcdj6lratt+O5fRRsLKrFfyqWQHq1B5INUJ?=
 =?us-ascii?Q?EgpOMd5pgmJwqLxrQQ4FPhaCqdV1/+/9ZC19L8ZW6V/2y62MULr/4rZm7o6W?=
 =?us-ascii?Q?NYC3jA0i3U/LDM54cK0N9wzEkSbXOn83v0pjShpJKSOe9gcd7fmXD6YMpJtK?=
 =?us-ascii?Q?zYVKL3TJM9kYxBl6Z3ZK9y3zla5WagU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20E053BFDCA9F24A9CD593DED17513E0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68fc771-faea-4f69-3703-08da486d364a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 10:05:12.5659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9rjQdStKUYqVN8tpTJOsFDjJDil/BQn11C2sIu5JEZTaZox19CQxqynLmdOA9jlpoDHcWICt0GNqRwKvhmDfPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR04MB0977
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 07, 2022 at 06:40:14PM +0900, Damien Le Moal wrote:
> On 6/7/22 18:37, Niklas Cassel wrote:
> > On Tue, Jun 07, 2022 at 06:25:45PM +0900, Damien Le Moal wrote:
> > > On 6/7/22 18:16, Niklas Cassel wrote:
> > > > On Tue, Jun 07, 2022 at 10:49:42AM +0900, Damien Le Moal wrote:
> > > > > When a write command to a sequential write required or sequential=
 write
> > > > > preferred zone result in the zone write pointer reaching the end =
of the
> > > > > zone, the zone condition must be set to full AND the number of
> > > > > implicitly or explicitly open zones updated to have a correct acc=
ounting
> > > > > for zone resources. However, the function zbc_inc_wp() only sets =
the
> > > > > zone condition to full without updating the open zone counters,
> > > > > resulting in a zone state machine breakage.
> > > > >=20
> > > > > Factor out the correct code from zbc_finish_zone() to transition =
a zone
> > > > > to the full condition and introduce the helper zbc_set_zone_full(=
). Use
> > > > > this helper in zbc_finish_zone() and zbc_inc_wp() to correctly
> > > > > transition zones to the full condition.
> > > > >=20
> > > > > Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
> > > > > Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > > > > ---
> > > > >    drivers/scsi/scsi_debug.c | 27 +++++++++++++++++----------
> > > > >    1 file changed, 17 insertions(+), 10 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.=
c
> > > > > index 1f423f723d06..6c2bb02a42d8 100644
> > > > > --- a/drivers/scsi/scsi_debug.c
> > > > > +++ b/drivers/scsi/scsi_debug.c
> > > > > @@ -2826,6 +2826,19 @@ static void zbc_open_zone(struct sdebug_de=
v_info *devip,
> > > > > 	}
> > > > >    }
> > > > >=20
> > > > > +static inline void zbc_set_zone_full(struct sdebug_dev_info *dev=
ip,
> > > > > +				     struct sdeb_zone_state *zsp)
> > > > > +{
> > > > > +	enum sdebug_z_cond zc =3D zsp->z_cond;
> > > > > +
> > > > > +	if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> > > > > +		zbc_close_zone(devip, zsp);
> > > > > +	if (zsp->z_cond =3D=3D ZC4_CLOSED)
> > > > > +		devip->nr_closed--;
> > > > > +	zsp->z_wp =3D zsp->z_start + zsp->z_size;
> > > > > +	zsp->z_cond =3D ZC5_FULL;
> > > > > +}
> > > > > +
> > > > >    static void zbc_inc_wp(struct sdebug_dev_info *devip,
> > > > > 		       unsigned long long lba, unsigned int num)
> > > > >    {
> > > > > @@ -2838,7 +2851,7 @@ static void zbc_inc_wp(struct sdebug_dev_in=
fo *devip,
> > > > > 	if (zsp->z_type =3D=3D ZBC_ZTYPE_SWR) {
> > > > > 		zsp->z_wp +=3D num;
> > > > > 		if (zsp->z_wp >=3D zend)
> > > > > -			zsp->z_cond =3D ZC5_FULL;
> > > > > +			zbc_set_zone_full(devip, zsp);
> > > > > 		return;
> > > > > 	}
> > > > >=20
> > > > > @@ -2857,7 +2870,7 @@ static void zbc_inc_wp(struct sdebug_dev_in=
fo *devip,
> > > > > 			n =3D num;
> > > > > 		}
> > > > > 		if (zsp->z_wp >=3D zend)
> > > > > -			zsp->z_cond =3D ZC5_FULL;
> > > > > +			zbc_set_zone_full(devip, zsp);
> > > >=20
> > > > Hello Damien,
> > > >=20
> > > > In the equivalent function (null_zone_write()) in null_blk,
> > > > we instead do this:
> > > >=20
> > > > 	if (zone->wp =3D=3D zone->start + zone->capacity) {
> > > > 		null_lock_zone_res(dev);
> > > > 		if (zone->cond =3D=3D BLK_ZONE_COND_EXP_OPEN)
> > > > 			dev->nr_zones_exp_open--;
> > > > 		else if (zone->cond =3D=3D BLK_ZONE_COND_IMP_OPEN)
> > > > 			dev->nr_zones_imp_open--;
> > > > 		zone->cond =3D BLK_ZONE_COND_FULL;
> > > > 		null_unlock_zone_res(dev);
> > > > 	}
> > > >=20
> > > > Isn't it more clear to do the same here?
> > > > i.e. set the state to FULL, like before, and simply decrease the
> > > > imp/exp open counters.
> > > >=20
> > > > zbc_set_zone_full() does some things that are not applicable in
> > > > the write path, specifically this:
> > > > > +     if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_O=
PEN)
> > > > > +             zbc_close_zone(devip, zsp);
> > > > > +     if (zsp->z_cond =3D=3D ZC4_CLOSED)
> > > > > +             devip->nr_closed--;
> > > >=20
> > > > e.g. with this new helper, if we are in e.g. IMP OPEN, we will now
> > > > set the zone state first to CLOSED, increase the nr_closed counter,
> > > > decrease the nr_closed counter, and then set the zone state to FULL=
.
> > >=20
> > > Yes. I am aware of this. It is indeed a bit inefficient, but this mak=
es for
> > > a simple bug fix by covering all call sites (finish and write). If yo=
u look
> > > at zbc_rwp_zone() for zone reset, something similar end up being done=
, the
> > > closed condition is used as an intermediate one. So that one should b=
e
> > > cleaned up too.
> > >=20
> > > We should improve this, but I think this should be done in a followup
> > > patch(es) and I prefer to keep this bug fix patch small.
> > > Unless you insist :)
> >=20
> > I just saw that zbc_rwp_zone() does the same after sending my email.
> >=20
> > I also saw that zbc_close_zone() does a:
> >=20
> > 	if (!zbc_zone_is_seq(zsp))
> > 		return;
> >=20
> > (Although I don't see a similar check in zbc_finish_zone())
> >=20
> > So one has to ensure that both SWR and SWP are still handled correctly
> > when doing this cleanup, so considering that this fix solves the proble=
m,
> > it is probably better to leave the cleanup to remove the extra (and at
> > least in my opinion, confusing) state transition in a follow up series.
> >=20
> > Therefore:
> > Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
>=20
> Thanks. Could do a fix like this which avoids the closed intermediate sta=
te:
>=20
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1f423f723d06..6ff4e03ad521 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -2826,6 +2826,27 @@ static void zbc_open_zone(struct sdebug_dev_info
> *devip,
>  	}
>  }
>=20
> +static void zbc_set_zone_full(struct sdebug_dev_info *devip,
> +			      struct sdeb_zone_state *zsp)
> +{
> +	switch (zsp->z_cond) {
> +	case ZC2_IMPLICIT_OPEN:
> +		devip->nr_imp_open--;
> +		break;
> +	case ZC3_EXPLICIT_OPEN:
> +		devip->nr_exp_open--;
> +		break;
> +	case ZC4_CLOSED:
> +		devip->nr_closed--;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	zsp->z_wp =3D zsp->z_start + zsp->z_size;
> +	zsp->z_cond =3D ZC5_FULL;
> +}
> +
>  static void zbc_inc_wp(struct sdebug_dev_info *devip,
>  		       unsigned long long lba, unsigned int num)
>  {
> @@ -2838,7 +2859,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
>  	if (zsp->z_type =3D=3D ZBC_ZTYPE_SWR) {
>  		zsp->z_wp +=3D num;
>  		if (zsp->z_wp >=3D zend)
> -			zsp->z_cond =3D ZC5_FULL;
> +			zbc_set_zone_full(devip, zsp);
>  		return;
>  	}
>=20
> @@ -2857,7 +2878,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devi=
p,
>  			n =3D num;
>  		}
>  		if (zsp->z_wp >=3D zend)
> -			zsp->z_cond =3D ZC5_FULL;
> +			zbc_set_zone_full(devip, zsp);
>=20
>  		num -=3D n;
>  		lba +=3D n;
> @@ -4731,14 +4752,8 @@ static void zbc_finish_zone(struct sdebug_dev_info
> *devip,
>  	enum sdebug_z_cond zc =3D zsp->z_cond;
>=20
>  	if (zc =3D=3D ZC4_CLOSED || zc =3D=3D ZC2_IMPLICIT_OPEN ||
> -	    zc =3D=3D ZC3_EXPLICIT_OPEN || (empty && zc =3D=3D ZC1_EMPTY)) {
> -		if (zc =3D=3D ZC2_IMPLICIT_OPEN || zc =3D=3D ZC3_EXPLICIT_OPEN)
> -			zbc_close_zone(devip, zsp);
> -		if (zsp->z_cond =3D=3D ZC4_CLOSED)
> -			devip->nr_closed--;
> -		zsp->z_wp =3D zsp->z_start + zsp->z_size;
> -		zsp->z_cond =3D ZC5_FULL;
> -	}
> +	    zc =3D=3D ZC3_EXPLICIT_OPEN || (empty && zc =3D=3D ZC1_EMPTY))
> +		zbc_set_zone_full(devip, zsp);
>  }
>=20
>  static void zbc_finish_all(struct sdebug_dev_info *devip)
>=20
> Can send a v2 with that. Tested. It works fine too.

Looks good to me.

But if you send it, I think that you should send a 2/2 that cleans up
zbc_rwp_zone() as well, so that we remove the intermediate closed state
everywhere.

The reason why I really disliked the intermediate closed state when
transitioning to FULL/EMPTY, is because it is not in the spec.

For closed and empty zones, we do have an intermediate implicit open state,
e.g. for a finish zone operation, both in the spec and in the code
(check_zbc_access_params()), so this intermediate state was represented in
the code for a reason.

Someone reading the code could thus think that the intermediate closed stat=
e
also exists for a reason (is described in the spec), but that isn't the cas=
e.


Kind regards,
Niklas=
