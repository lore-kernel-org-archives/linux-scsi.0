Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACB2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 16:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbiAFQTJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 11:19:09 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:43110 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241052AbiAFQTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 11:19:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641485946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7Fz7meoU6jlZ5wr4DVqNqhEZ+e0DhPazehBNMBGVck=;
        b=PJi9ieAMYSpG0qmJjvm67UPV3VnL+OGdWuTxLhAem9xtsf7PPPh4wC/v5+LtdEFB/hQ2Oq
        kxlLYBKx7OoHi32Za+JXsmGzlrDXoMY59EtbEacdZgfzuGVKfJsTOvyPPe5OZUVxXOqlfD
        B5qWp+Blcgq+SD+zzo35PGJNi4Pnl54=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2052.outbound.protection.outlook.com [104.47.8.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-27-5uAh7Ds_N5OThAnxhtSg1w-1; Thu, 06 Jan 2022 17:19:05 +0100
X-MC-Unique: 5uAh7Ds_N5OThAnxhtSg1w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cxc7fI5nV0jXmAFjnsn91wk1z1fmrGqHLpGb9AU24WgXp193pnnru85CjCysWbL4pBetdsWtqzg6wxKo/768WeHClImyPiboIliXL4z1FIny9bwC+1ZTqmUdCoZRhc4iap9IJrvHs4fngLr1QyV/m9NxaoOCzWeheIrhe8+ZaUkZPmzBNfl6ojx65aZwGiAqSxkAj3Oy080KUWy2yiYY2i5J7dfpIf8+D9B2GGpn+MLOkqhIIeOLNM9DhwjZnExBCVFmucOY4WLamSdI51y76ZapnLaI8Tnm97e3OslAI1NDN9W5L07+FyCrdqwFvyEnwdZtugktWLan2hLiwcBWSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7Fz7meoU6jlZ5wr4DVqNqhEZ+e0DhPazehBNMBGVck=;
 b=e6EnI0A4U3PRKX77B1LRb75cwDFMfPVVP0tZgiMw0gT7eZggp0Fj0fn4BPd5gjR5LNn4NjZdd5dIRCeRSodgh7jP4D4LVEkXB1H2MsY6bGU+PnvoUy1fXRGFcmccfm4bz+W6v2fPbcg1RegpLBU8HgsiRG+O8VvRf7KykghThGJ3cj/Lugid/TaoHBAzBQHlbzNXskpVWDnWL18L9OkLF0KAHmqN9fGKQfKCmDIVdUJPQDtx9sr9dhWyp0I7HczTywyZJuWPCPV4UojtE2pqvCxsvGcFrwjJoTOHnOQebVJ4r4Vb/P0CQaGxEQisXEmsTZWceYD99u29CqskjaKMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB6PR0402MB2918.eurprd04.prod.outlook.com (2603:10a6:4:9a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 16:19:04 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:19:04 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "ming.lei@redhat.com" <ming.lei@redhat.com>
CC:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Thread-Topic: mpt3sas fails to allocate budget_map and detects no devices
Thread-Index: AQHYAl4nMXu34/rIHUa9cQ2p6vlOuaxVTzgAgADIjEOAAAtYeYAACmSA
Date:   Thu, 6 Jan 2022 16:19:03 +0000
Message-ID: <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
         <YdZcABq/pxMMh3X0@T590>
         <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
         <YdcEJngPYrZk691Q@T590>
         <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
         <YdcNrSJJGllQzWOB@T590>
In-Reply-To: <YdcNrSJJGllQzWOB@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8549081-dc5f-45d2-8b7d-08d9d13041b7
x-ms-traffictypediagnostic: DB6PR0402MB2918:EE_
x-microsoft-antispam-prvs: <DB6PR0402MB29189A2FB56610CB8C5689A2FC4C9@DB6PR0402MB2918.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zfzH4K58nIwId2s2d8TSbPR6RB7byZ9vrfnElU6oUYYFgh2vcQ707uyRuXxmIIpAlx6gqVaKqLzogkXkA3gnu69ZVYLKRVn+LsgGGBXytYddoIgRfTFznUQb3IBn9XDu4w0wsqgTUUAzGIn7nNxPHycMjbQiI/pFlo/uf+9EIwIGXZJWU9qACv7ZOvdO9FIavJMB1zMjNGSBQDK/OvKQYW9cVaRP/waQ0XMeOURI2Nr/G3SZrOPgy9WpOx+Nyuj9+eydr2Y1//jNu70gXXc6S3Kbklmqh9jpCwbo8WF10RUhDgAC+mjnICGnpYneNCs2ZD/l03EuXv3uFQBrj8T8ZX7BslrPJSebXeW1DrBY5izmxEVItcPni7VE3WDu5bru2Dl5VW0SnTLLXrDktvMBO0iAQ2OQpTcZauRLNa5GKdwriFuXmOe/eO0+rTbPXeNc4tLvdVKBWQWI1/I1tGNv9IhpNrPc47rcIZmt7LrBVBW8bQdDYbgdffCmn6kW+FGmTrmOXoeTg/tBEyOUimouskJlkAG9/eS0sG3viiz0ojs0pOndpcwjk9J5c4SHRAaU0f2S3JKmsM4LtCQuMtYC7DpovGaEPfvCaR2j7CgbRYG2qjy/cQ5zpkd/FoJej1W8YXa5u8sZzWZ8J/IV/LIaGrrWcNC9h4sXChkU6euDCV6WNgRwy0Z5DS6ZQs2q9gKvvRmACCI/XZWGWl8iv5PFVpn5HLgtEVbCLAO0r//4seIYZeKAzIsWOph8r9VrIwbF2aMh35qs+NBnCwZZpI4csQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(91956017)(66556008)(122000001)(66476007)(76116006)(64756008)(66946007)(66446008)(5660300002)(26005)(186003)(38100700002)(8676002)(38070700005)(83380400001)(2616005)(8936002)(36756003)(44832011)(6512007)(2906002)(508600001)(6486002)(4326008)(86362001)(6916009)(6506007)(71200400001)(54906003)(316002)(42413004)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?rAjEgls4K1IjLUPbDZt0lAN4ayCnOBQlX4sARh7B+9/zj1P2E+/uyUE12?=
 =?iso-8859-15?Q?Z2Sqk45eX6p2Qw9kO/9gMhawfDsvS/JTKH60pIC9sBe/TiAAbxM7yFE23?=
 =?iso-8859-15?Q?hob5AIVCCZL5/ylLt1+1vUvhOjcwZ5qUGsa82T8IpbwvLPByaRUfa6v58?=
 =?iso-8859-15?Q?MroNIwWvu7NyRqLrA3fmqifr5VZq5OR2Q5HbkN+O8ev4EbiPbYF7NwNJb?=
 =?iso-8859-15?Q?szQ6XVShMNfjdMErJcr9Z6JG0hBgDiyzqRxTxg8BecMViMTWBOHgIhGxC?=
 =?iso-8859-15?Q?r1qmNvkLFRJVl3NHdcOFI8r8+1gBfWM4Lk+cJsg1t/A2kKjdqPilwml0p?=
 =?iso-8859-15?Q?hVPecSBy/ivOEgutRu+uCz0WAJmRXrgeY0b39CSO0PfRHrib9zj8+pq4X?=
 =?iso-8859-15?Q?iR9p94L7AT21IpXqKCvX3a+MFVN3fbco3u0n5V0IFWvdia6crPkNfwOn5?=
 =?iso-8859-15?Q?en6gV+YvZMhm6zqX6AtH5FPV+TVK6cTVWXyv+fm2iwlCYAupkTZBU91WH?=
 =?iso-8859-15?Q?rfLHf9VBH/OTiktv9k/aflDXXFUzUeMysTXtN9CffzsLWEFEvb2KqqbEl?=
 =?iso-8859-15?Q?ixIiZxn0uU/WsNXh0g9GOoq3fgb4fUIufB39kAEzgTkGV2FRYkRtdRw99?=
 =?iso-8859-15?Q?TRLg8rzznSa7A1TJPKY5HATrUJN+Hvou1OVAeoQXsxQW6+OJoaq3pd0nI?=
 =?iso-8859-15?Q?Ll488hgmMVf/05oVijSHo/DKGJHxbpCZcaNKirXWoifoaGIr1J2WlJYGH?=
 =?iso-8859-15?Q?XM0lwKe4OTBO6CLD/9CaNkpCzs4GvYu1peQyOf96QrLdQs77xQwW+PlTu?=
 =?iso-8859-15?Q?c+sX2IwHMAWj4TwA2ki8qcHi9Ophrmo1iF8saoZJ5DO9EQCex75jItVMz?=
 =?iso-8859-15?Q?TFhTToUrWcid7+lKQH7qjLuL1i9L3qSXOxsy9QS+czaGfGkmLkax4uulG?=
 =?iso-8859-15?Q?9+mTtZW1wXOhaEr+s9xJuZ28CsTiDLdWknVOLLCFI0P6G66n8unWWpwos?=
 =?iso-8859-15?Q?cos0jy/8kLQPxsLwNkK9ZQBa8P6gYmQKL/1YaFaBUxA5xgTFSXwCKzs7D?=
 =?iso-8859-15?Q?YsJ0g63g3wFomI0Y8m4/nLrMWvL8KkY+aqkwBDDEe0R+na4rYccRb7urr?=
 =?iso-8859-15?Q?6FIxtscUGpVYXWBZvSxL5Ztc5s2onQkP4unhPaShwsa/SIt24Vr0yfbgE?=
 =?iso-8859-15?Q?2pFIG73Sm69RL69fz4UCmJGqc0Lh635XzJ12KC1soMYy5vNCn+jBhn40z?=
 =?iso-8859-15?Q?+8uDcMmkiGIEty5f+E2QksMeTbrACJvcJypaDrE3Oki3EnGmibGz1mkqh?=
 =?iso-8859-15?Q?10DwAfP4cugScvpzlZbQIFYCWU5r2oroPzXVb+Vx5bsrlWhZY+uohF4ZI?=
 =?iso-8859-15?Q?keGjhJSAS0jbkgFwtTkWrXhDk0re/hVhYTEN8XW7kC9QnNHDQ3k5dMV1x?=
 =?iso-8859-15?Q?ROjoh4kpG6Vy7hlXNhoDq3vBhEPNp2/691BlNkr2+BdJGWR0JFibU6Cym?=
 =?iso-8859-15?Q?QWjNUeVDh9PvNxO7GQE7lSMQjRrGo+nzEzJRpt9+8BS5H6LxC7LdWQhNV?=
 =?iso-8859-15?Q?QDP0mPDBtv8oKTJwXaXHKKjzirykICacF3v4PN4jeTcYUKdPJXy+gh1Dl?=
 =?iso-8859-15?Q?4zPr5ei6szbGwkgaZPRO5lTdaDbM3qkHExbREYgLbU5bCSmCDjKS4TIig?=
 =?iso-8859-15?Q?vVb0+pskNnyhuJ791xkvyPr/SbVpjYwIZksZR+iywZChkmI=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <B0A62EFF459DA7459AA4538C9E8D1500@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8549081-dc5f-45d2-8b7d-08d9d13041b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 16:19:03.9779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c2GNW5Q1nHXwDl/li5mLY7UVlNQZv0Xuoy90lpLL/6pqTAUc4Y0u756+Dt1wRj7INlUBD9OsBCXwIa6oEVaM3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2918
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-01-06 at 23:41 +0800, Ming Lei wrote:
> On Thu, Jan 06, 2022 at 03:22:53PM +0000, Martin Wilck wrote:
> > >=20
> > > I'd suggest to fix mpt3sas for avoiding this memory waste.
> >=20
> > Let's wait for Sreekanth's comment on that.
> >=20
> > mpt3sas is not the only driver using a low value. Qlogic drivers
> > set
> > cmd_per_lun=3D3, for example (with 3, our logic would use shift=3D6, so
> > the
> > issue I observed wouldn't occur - but it would be prone to cache
> > line
> > bouncing).
>=20
> But qlogic has smaller .can_queue which looks at most 512, .can_queue
> is
> the depth for allocating sbitmap, since each sdev->queue_depth is <=3D
> .can_queue.

I'm seeing here (on an old kernel, admittedly) cmd_per_lun=3D3 and
can_queue=3D2038 for qla2xxx and cmd_per_lun=3D3 and can_queue=3D5884 for
lpfc.=A0Both drivers change the queue depth for devices to 64 in their
slave_configure() methods.

Many drivers do this, as it's recommended in scsi_host.h. That's quite
bad in view of the current bitmap allocation logic - we lay out the
bitmap assuming the depth used will be cmd_per_lun, but that doesn't
match the actual depth when the device comes online. For qla2xxx, it
means that we'd allocate the sbitmap with shift=3D6 (64 bits per word),
thus using just a single cache line for 64 requests. Shift=3D4 (16 bits
per word) would be the default shift for depth 64.

Am I misreading the code? Perhaps we should only allocate a preliminary
sbitmap in scsi_alloc_sdev, and reallocate it after slave_configure()
has been called, to get the shift right for the driver's default
settings?

Thanks,
Martin

