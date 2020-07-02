Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12AEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 12:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A981B20890
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 12:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AiuW+uwK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Fh5MTprj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgGBMiC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 08:38:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2323 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgGBMiB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 08:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593693482; x=1625229482;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JCI54Bdej8DlAhUNBSA1OAoClLY+QCJsRGXtDxXSAhg=;
  b=AiuW+uwKYC2mDHMrLauXbE1hdHI2xjoVgjjrR+/CEhE+K8kbyHmJa0GJ
   nNHU/EyJKR033oYroX6h1j/c7Fa3o2jzGlRW6t8EWJ583VrL5OHoA8WD1
   v4TNKlAkc2TpLvCaKfVTC9/X3NM8fbE1jfuMWcM9OOyfHsGU1gdTwJZhC
   HeGRXifXtD5XvOCylnQZLgoBY1Ba7s0NxyisHAI117iRfnPPCaxnsnaob
   ZqmI/Aje3OTHpTOw+uKfJ7zQgh3Gp9NFOmmdBql9mlz2CF6H1OUiw/nvL
   gU6rVct0yBMtc42gBfbOc9A1QoslPo6Xtv7jyBWWPFYlMiK3wMp9Elbi9
   Q==;
IronPort-SDR: sAs2j1i6hKoOjq5sp0EzGtUbv9VQyCXY+mFwrLvMx2qu0rQuh8QL+7iY+VTcJBsjiT2r1/iVoO
 +d8ZZtlzX7CYKl6r7SPTBQw4X94XcQaBnzhEjqJ1r0TxGr9w28o1hyiuTCn/OvQz+StjBgFJq3
 mOKHxdvHSNy6jRSAGqAAEgCwQ07T3B42gCu/RLU4KYjNUhw6/7lruQTFbuVNTw9LrQikIZQzTd
 JkOiNd8Bu3hkXRDWkt8vWUq4d3x55siJY5Tveey4B4htjrPTUM3+HirXbpAHqKK48gkM9V1LOi
 Wf8=
X-IronPort-AV: E=Sophos;i="5.75,304,1589212800"; 
   d="scan'208";a="142826912"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jul 2020 20:38:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO4iN7vC9lniEcsWrwbnkMA/cg6olsWsNrSEooPHXHJJPhmvc4x4HC4nwl89DSjpnGF/+wX3J28+EK0awhc8HLZqSaiIpKdMd62KNtZacEb0ioOpdxWdWZnPrvQI2G3EWnEuhOH6LejGMBOVSVpZO24IDkqUYTxjZDLuSAMyNguoa9B1YIAlU3lhQ0if6+ViC6yqx6Jc88KgzHcNCJ0mRdX4rx5nsEQlqToljg1hsOKnjsGHu5hYXd48Pi+EeJrdLwXy7IJ08eQ7S7fpkzgOTGqTbX+jgHqJ4M1Y96z4+EQldHO4cnFUED3bMGu3ktQr5BvjSj5qTDddRUfFcavEDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQpgfT6tBMrrPBVx103zmYnEnWq8urPCkbHAz1qBzx4=;
 b=HWP0b46Gqzcbn0t4dbPz5pHpns1cZyDkcYq5+WNIdmzKFJGUXQpIMB6oXsE1GmnvCqLmKJhCsSjZvMgCBKL/4Cqw/qtGr7XomzQ4bQgtKVTXWu6gqCH0MeVPXfyfQPGhLZocatBiBU3WuZlQkqqxDsNjVQPENELbxBJ399YnRNK7I+NKBogilUMwPjXBOC3JLJvRGTFgbyW0J2/1mjlyiDKNJGXekeT5QWzsXKpUyUeZQ8U/ACD/OlaEv2txEyr3Xe//wdvCF+mH1KElo4JBxcnBHRXHBLOz2HL92qm8DRU6SclIbK+3X9p7NSf0RIX1xSP+MdiIpvuzc9Ofyx686w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQpgfT6tBMrrPBVx103zmYnEnWq8urPCkbHAz1qBzx4=;
 b=Fh5MTprjZ1SoJMZMJoKx+xFsj4whO+BDVYkokuxZmvO1wJHu9lN6zMjzPDXW+EIGUhe928eWnUGEkSFlxMmebqhRTO9sI7JTuj9KxI6PnoosUZSXJEHMA7Yhmvv7wTdSQRm9mj4nvPGlB2zQNHShIq4MROTA13evd9a0emUxtMU=
Received: from BYAPR04MB5112.namprd04.prod.outlook.com (2603:10b6:a03:45::10)
 by BYAPR04MB4677.namprd04.prod.outlook.com (2603:10b6:a03:14::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 2 Jul
 2020 12:37:57 +0000
Received: from BYAPR04MB5112.namprd04.prod.outlook.com
 ([fe80::a442:4836:baba:c84b]) by BYAPR04MB5112.namprd04.prod.outlook.com
 ([fe80::a442:4836:baba:c84b%6]) with mapi id 15.20.3131.036; Thu, 2 Jul 2020
 12:37:57 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Thread-Topic: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Thread-Index: AQHWQ8iO/B03U39S+Uih8dmO//K+66j0U6aA
Date:   Thu, 2 Jul 2020 12:37:57 +0000
Message-ID: <20200702123755.GA609677@localhost.localdomain>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-2-niklas.cassel@wdc.com>
 <CY4PR04MB3751C2C03ACCA263541DA348E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB3751C2C03ACCA263541DA348E76F0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [85.224.200.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 89a1fe45-8594-4606-b1a3-08d81e84bf92
x-ms-traffictypediagnostic: BYAPR04MB4677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4677C9DC1F9369FD2F3F6858F26D0@BYAPR04MB4677.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1AnAPR4mS1PPUvEMSGnA+XMWmyQ0J1d3+O+HSc14Vp94aOy1pO65T/Vl/8d/+e33RYv0A7U0fqtF/gwJ28kWnax6rkq1cVm94GmU5gZJfY7k1ZIFakWw3sfgmpgTYMDPVM7SGzuEdjjUpBpBxDyzAoUcR29ex4qV1QSXJM82kNmVIu3UnloVfWxQ7T8KY+BmWNOSzKqLbuulWajVsRNh1DNJB3g6cSi53wRgi8NrqkwNUNU1fkK8Tp0esu3hv32gqo7iKtAxjNmHX1KoPchD+vk+ZpgdBG0S3PrfG5IjAK+W1tM0qnrrxQI1aDNtUDR7yugVkiHMN/YJPH4xGfsAQMeGwIb2vDZt8DoL2utiQ6/Ij4snKnyJ6pZkTic3gQktOte+iYmp1DOc0iUzOjyraw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB5112.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(91956017)(76116006)(64756008)(66446008)(5660300002)(71200400001)(1076003)(6506007)(53546011)(186003)(33656002)(26005)(83380400001)(6486002)(86362001)(498600001)(966005)(7416002)(6636002)(6862004)(8676002)(4326008)(6512007)(9686003)(8936002)(54906003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NKZTHbqYLri73P18MfGgfqnJDLw00/h8DDYJIhX78HrgrLyxZaS8+R79pWdi1KR2AktgETE+h/mrqZvF2lpgQfFK5noAbocmfo6W9WoQErQhhxNl/u1cIdjqcYXnagQDbBWSzgCZgyTwuDswv2LGxEwNbsnPnZUZ3fUAHQHcqDGbRdzT8RODbIEeQQOUecruMA5dbRdVrJf0oIKxdMlMoKsTvderb4BcjktgQ/36ePO5zKfHAgT1/0z5zjyNpc8JfaI+7SjZRcO6MdCmzcrPKNgsjkEfKVXvfD3xUzKCj9/0DqUcb8csYee2byGu+ZE0ZVr+Jbh+Xsbv7hzDkjJn0xpO6EX4nAM5pVK92vD6M8oBQjo3O4mb6VqRQaNdGn86aul1IIB4CxakuhyMyyviYokzzav3pFdcxiSOR0HxHOybZsy5+FDqOZXXsKkXufgZH0LPrHrS73ra+uMcUNQIerWBZ4FANq7jhv9aREyy/v84qe6abqaXsafiLW5xG7Pn
Content-Type: text/plain; charset="us-ascii"
Content-ID: <22FC15E947CE2648B994A6E81934AA5F@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB5112.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a1fe45-8594-4606-b1a3-08d81e84bf92
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 12:37:57.0514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vYVYXf+Pe468K8HyOI66baYyl2rX65IsUdoREgUzMF1oNvxbMTtEM0N33EeQO7w9Lw1bmb7T/ngpvaY2aRvloQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4677
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 30, 2020 at 01:49:41AM +0000, Damien Le Moal wrote:
> On 2020/06/16 19:28, Niklas Cassel wrote:
> > diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
> > index c08f6281b614..af156529f3b6 100644
> > --- a/drivers/nvme/host/zns.c
> > +++ b/drivers/nvme/host/zns.c
> > @@ -82,6 +82,7 @@ int nvme_update_zone_info(struct gendisk *disk, struc=
t nvme_ns *ns,
> > =20
> >  	q->limits.zoned =3D BLK_ZONED_HM;
> >  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> > +	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
> >  free_data:
> >  	kfree(id);
> >  	return status;
> > diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> > index 183a20720da9..aa3564139b40 100644
> > --- a/drivers/scsi/sd_zbc.c
> > +++ b/drivers/scsi/sd_zbc.c
> > @@ -717,6 +717,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsi=
gned char *buf)
> >  	/* The drive satisfies the kernel restrictions: set it up */
> >  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> >  	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
> > +	if (sdkp->zones_max_open =3D=3D U32_MAX)
> > +		blk_queue_max_open_zones(q, 0);
> > +	else
> > +		blk_queue_max_open_zones(q, sdkp->zones_max_open);
>=20
> This is correct only for host-managed drives. Host-aware models define th=
e
> "OPTIMAL NUMBER OF OPEN SEQUENTIAL WRITE PREFERRED ZONES" instead of a ma=
ximum
> number of open sequential write required zones.
>=20
> Since the standard does not actually explicitly define what the value of =
the
> maximum number of open sequential write required zones should be for a
> host-aware drive, I would suggest to always have the max_open_zones value=
 set to
> 0 for host-aware disks.

Isn't this already the case?

At least according to the comments:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/sd_zbc.c?h=3Dv5.8-rc3#n555

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/sd_zbc.c?h=3Dv5.8-rc3#n561

We seem to set

sdkp->zones_max_open =3D 0;

for host-aware, and

sdkp->zones_max_open =3D get_unaligned_be32(&buf[16]);

for host-managed.

So the blk_queue_max_open_zones(q, sdkp->zones_max_open) call in
sd_zbc_read_zones() should already export this new sysfs property
as 0 for host-aware disks.


Kind regards,
Niklas

>=20
> >  	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_bloc=
ks);
> > =20
> >  	/* READ16/WRITE16 is mandatory for ZBC disks */
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 8fd900998b4e..2f332f00501d 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -520,6 +520,7 @@ struct request_queue {
> >  	unsigned int		nr_zones;
> >  	unsigned long		*conv_zones_bitmap;
> >  	unsigned long		*seq_zones_wlock;
> > +	unsigned int		max_open_zones;
> >  #endif /* CONFIG_BLK_DEV_ZONED */
> > =20
> >  	/*
> > @@ -729,6 +730,17 @@ static inline bool blk_queue_zone_is_seq(struct re=
quest_queue *q,
> >  		return true;
> >  	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
> >  }
> > +
> > +static inline void blk_queue_max_open_zones(struct request_queue *q,
> > +		unsigned int max_open_zones)
> > +{
> > +	q->max_open_zones =3D max_open_zones;
> > +}
> > +
> > +static inline unsigned int queue_max_open_zones(const struct request_q=
ueue *q)
> > +{
> > +	return q->max_open_zones;
> > +}
> >  #else /* CONFIG_BLK_DEV_ZONED */
> >  static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> >  {
> > @@ -744,6 +756,14 @@ static inline unsigned int blk_queue_zone_no(struc=
t request_queue *q,
> >  {
> >  	return 0;
> >  }
> > +static inline void blk_queue_max_open_zones(struct request_queue *q,
> > +		unsigned int max_open_zones)
> > +{
> > +}
>=20
> Why is this one necessary ? For the !CONFIG_BLK_DEV_ZONED case, no driver=
 should
> ever call this function.

Will remove in v2.=
