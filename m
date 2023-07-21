Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF389EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 13:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjGUNdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 09:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjGUNda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 09:33:30 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1205819B6;
        Fri, 21 Jul 2023 06:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689946398; x=1721482398;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U3pMCr7y7Swlelqlkq6mY2L6a8YnGNaFOcKJJAoI4Sc=;
  b=IdKt8ZOipfMSBU40QOmQIq3H4Os4u4mfgU6wERZxc+yzHhOz0atOxBvR
   /uEAqd9T8zAVk6tD2FxSVl1L2fu1USNHkshSRwPI2icXcQ3iUVwWwh1B+
   +lq5Praktv5JyRpeHN5s1EyxlIIfRjuQIcGucavN+liQD6RWghKsZbDP1
   5UmX0nc4w3DucSL3/j1dbl+b7QhoZ/AmakLoSgnaOnnjYww/hBIzP5lH1
   F9BwW4oP7lowPnbs4zD5io6brzicZdS7Ox8pK16AzPfxA2hZ+sW9Kwmg7
   S5Jycq7C9Tjf84QXeQid9Ok287A0p2MEEEPv0oVOMvX/7TQ/PZVKgtDRl
   g==;
X-IronPort-AV: E=Sophos;i="6.01,220,1684771200"; 
   d="scan'208";a="238514964"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2023 21:33:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2I/hMh5Ll7GN/nCNpMJVZRn73KI5CZf8gH0y0/IOOr/2fA52xIgqXRVo11d+8/Rd43czeayN2kLlnjWVyb2jFu8WX0k4DoEJX4eqhvWFmiO6XeOrDK5BT4umcuvn4CmmN4IJC1aSzbt/772pKdbXlwv9dtMHi3bwIM/P+T3UwjuKyu/kKkloHqC/YZ2F/21FjfOo9hkJPfaKPj0zrKF8eLtHPT+hSrUAd6D7XcT81HWl6BCLEAKvW2vPLSR15FjMOcppMp9MPgrGdEj18Aw25jqp//06mvbCLYRsbLeN1HJQuMOocT5IPEHcgkqiZyRJInqr+VY1BtxMuz8pktTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0rD3uLfpEMZWCk4Obta6D9DF0ZO/eA4gIWCYnJqYJw=;
 b=CbKZFq2fIG2wAcRCGDbCAHbWgOr2yH/XuwdU1Haz41CMEUQng3362yL13ztICa0i/CeegikypRVR1AIWpBI0gxjs4AyYZy6XYixnQDsDXM45+DCuzHHeVjpnFbrCzplhCyC5abUJEFFuhKwi6yv86dAckedRV4HTT46OTPqN61G8Mxd9wkHZSxhBSKk3DzXLg+ram84o3HyClJUvJ2jB8grkX4pIv+YVLuLop/oKRAh7mCpBsgdFsb3t/zMNJEegbw/Lv3pWqp9q0GeeKegdMXrjZITdbls67T1z4HgpP0kfR+gYE3TCS51Jmk54uJRyjLGM2pQWD7pHyjY6QyYJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0rD3uLfpEMZWCk4Obta6D9DF0ZO/eA4gIWCYnJqYJw=;
 b=xzHtQw2AUHoSKl4eDV7u1iYLbSMH7sdU3uYHLtlXp7g398J+RATOF95uaB6scoPn5eEDlAQ8SoHEseCyVXy9gR5CfV+KI8Qv2ckigC8M728xkP3ng9P6BbVRBbOc4IEmR7fI0tcIuWkf/r1JA/ns0KQSS5iQY6XCV7IqbjSdW20=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by IA0PR04MB9036.namprd04.prod.outlook.com (2603:10b6:208:492::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 13:33:12 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 13:33:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     John Garry <john.g.garry@oracle.com>
CC:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/8] ata,scsi: remove ata_sas_port_destroy()
Thread-Topic: [PATCH v2 3/8] ata,scsi: remove ata_sas_port_destroy()
Thread-Index: AQHZuqOjeCyHek1q70ujIX36HCDJy6/CWyWAgAHfXIA=
Date:   Fri, 21 Jul 2023 13:33:12 +0000
Message-ID: <ZLqJF03vWDg9KQ+e@x1-carbon>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-4-nks@flawful.org>
 <8db40977-19db-2180-24f7-cddffc5cf3a5@oracle.com>
In-Reply-To: <8db40977-19db-2180-24f7-cddffc5cf3a5@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|IA0PR04MB9036:EE_
x-ms-office365-filtering-correlation-id: 3103a58c-060a-4f6e-dbf2-08db89ef07a2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iS0R0lazS6BRQ9dVwluWS6jMHRSsWb8M4f6LRRX2VAEb8pVmZF1qEuEejiPGJOutEkXqwSxsGEk/+gBmHC8YYAPGyUKQ1CYjzqh4QLAXEw6gQNvdSrs8pE+3oczt0dwnZNKHDh9AwehSD/c+sbf/N5vCELG1N408E2/tV6xkFbp5F5h7e4EUtFxdur0m3GWYfrldNwHAvX+Si19BrHuOyypKLhwl3zlSbnSGTQtgUy1mSOybvcRcoI0dxhKPrigoyWbyh7iWf4y4QkQsKuqVj71oOjCUlbooHtci1YXxgDVBwMUkXgKma9PQZ4TAzP9DdX4tJUzBvq1OEeTQ9hpd9JbhviU8vUlXV4HJ5RsNhsgG+FgxlKQE2zNaSzN1E8rSOEH6lobzLRxlDHCJERN8Efam8CGFTLmUcOSSG2pxa4qQiIVpzpOURmtQxDguaJMFWdhcfouHrc9lA4o/14YYfqVSFfbzGtET4QfpPiG8FQYmb+iNrmqUNCwIybb1HX0Gp8GWDcZ+evZ9/4O5/Kq117FdZYzC2hjmKMvtjm8FFee7GU8E/Q2zyER2CM+CgrQKThk986/wNVqvlsuXHoPyOkxAZS/uZN4uvfIlhWq5cjLlPX/TCXkx3gC02SI99bmPBVOSeETeInCK+JVTG2SaUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199021)(38070700005)(66446008)(33716001)(82960400001)(38100700002)(86362001)(122000001)(2906002)(66476007)(8936002)(478600001)(8676002)(7416002)(83380400001)(71200400001)(5660300002)(9686003)(6486002)(6512007)(53546011)(6506007)(186003)(26005)(54906003)(316002)(4326008)(6916009)(66946007)(76116006)(66556008)(41300700001)(64756008)(91956017)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3b5zDH3esSeUhuxEHeN8r09Xew/etDUwmtTVSXWrwHjajkZqI6jq/RwpxicN?=
 =?us-ascii?Q?zX4sYmgEZ5d0yUnSM64esZYxk+2P5A/e3lxIwcuqDpuAjEobCnghOGfabDt0?=
 =?us-ascii?Q?bGe6s1/wzqTP4anOK4geYYq/ddz2s1f1h9z+bXySVl0qnMsB3SRmQS2dpr4d?=
 =?us-ascii?Q?x385FgYWv1d/uESHJRxiSKndmUsDZ7o1U0utI1FrwgYxiP4z0DXO2VCMYvqN?=
 =?us-ascii?Q?3d4l1Jf9WRkTYlRKBL76mE0Qoev4mZwup44S+gHajYN4wv+Jv2RRZG+/Fx1f?=
 =?us-ascii?Q?tbvKT4lbwJBOgBo0FQYbS3WZlDlJS0zaVll6vpEDnkYZn2eFNpbZ54rJzkvS?=
 =?us-ascii?Q?PyXjG0ECGWeLzD4lPiBLqDO/qaqY9LKYcQU6FfvTh73sUWS6JR2JZvN/AUv8?=
 =?us-ascii?Q?GbuZ3Y/RDFLI3MEBel2p4TFvY1lgWiDfB8BClUxF8/2u0e2U8Pso4BtAfEl+?=
 =?us-ascii?Q?oDLJPVYknPKLRUCICcrk7HM0ZyqfkIXVohBm5D3wl0SV30iTHSn/JYCigvgI?=
 =?us-ascii?Q?s7HLiJbtRztWSAm+RIL+BJLSczFHS3iYGYPG7VazAKOo5ZhRU5bOYTM+igwf?=
 =?us-ascii?Q?O+X3jCXSW5PGurAkUZPQN+YsJ8xBrIVEYZvo2dc2HOe56zpfudCdwN/4oVLo?=
 =?us-ascii?Q?AVkGP8bqkOvgV0Mo01uxhneWCSnnR//EBmIymbpbxNdG2AS0u16/mcYVthrv?=
 =?us-ascii?Q?n01aEquNfYQiLI9nDoe0PAVlM6sc8BzsRQI7IknIjI3duLPjITYwo5Mpwqo9?=
 =?us-ascii?Q?6ITiF1BD5dsfREE251Y1PripY62EUu5xWmSz3yv9Ac2+uZ4egMWBHeUhQOnz?=
 =?us-ascii?Q?1dyYJSJ5qpZaXcpy6f3bQRFgWDny0NUR75Lm8XmLigr6DYmUp95d0PkxfTvv?=
 =?us-ascii?Q?ERTOI/nfMtGBZ1HUDbpkRC7yD5p8c2lqvIfsB4UjR26HGiSSn23UHHxxp64H?=
 =?us-ascii?Q?cupISlsUA0bjaPOErCkaxR0ye8eE93pzGDb3Mh2i/9DvZJvcH81BqKmNXXBh?=
 =?us-ascii?Q?eKtTQ3o14oMjpCB08Bm5iekRdseRl3w9zkcCIvkn0nKHA1xTrbArwE9zs0O8?=
 =?us-ascii?Q?jiPJI+fWqkw3hTO8zc3bX68rciUqPOr1uR+ZqF4ryO1LXcnNZOH/F7obN/88?=
 =?us-ascii?Q?oHezv7fRBFqqbu3tXHlfIJ7G0BbwGU47+aBASDe4JLVRO5wQhnSJS2oTRcT4?=
 =?us-ascii?Q?inc2Hx25KQFCI2PPXeA343R11/Thd+VnrIW8HYRCyTANN/uZkwejFyX64l0K?=
 =?us-ascii?Q?PSfkpaBfntFI/iC4n7P+n+5nytcvsllsyRCZV2v1/LtOiFffZabORGA8ny3o?=
 =?us-ascii?Q?x6f1hIbNC08I1HD+7ampiM0Vv5lX6p4yIciSmUW64gZ2ROULT2r5/U8tnPaR?=
 =?us-ascii?Q?NgSMmFKAs76xjC7xBmXxwYK7fJ1bj7LXNSJn2/eKtE4v3iW+iSlGoFPXIcPj?=
 =?us-ascii?Q?maYF2VBw3KRH7ZhdvpLpGP8xIznS4eT7N90z4APqDctiJYjUD+DZ3SsuL6hO?=
 =?us-ascii?Q?5mqKab8az1XyHweNtvJbTBRqAcyOiwLw0EIgjWk0RtQ8T+9euZKXAqvt0sl7?=
 =?us-ascii?Q?BgLrWXVzB/BWrvp8MRUdE1xWH5QvtNN/4VY5ZmqiqrJFutbkYamYeVYlwhNT?=
 =?us-ascii?Q?QA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <875D5E0875CA7444BE855B08F1C1FA1D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?mE8QrQ87ehRIqaxIqBR2yKwGEdLDlEzaZPgISRdQxd7RmCxdf+Bs84JkAxXI?=
 =?us-ascii?Q?1v9Fn9px4Kc/JV0E9L4d3z+AzA2009PxfuOKhoa/SCGd3MdEu5CXQBnm2uPi?=
 =?us-ascii?Q?TVj2f9tD9r0B1VaaEEC1KnDyRbilaNpXyq05X1lASBLqLvbn6u2NJevMnJ3m?=
 =?us-ascii?Q?2a74t2Rbx062Mdzc/+VkReiQtSaXspBBB9YBIla5uNfzHSUBdLbU8EYrs5uv?=
 =?us-ascii?Q?j/iZdxQgTrfhNTLjT+pUquEaQfZ8yaunsJmAJ1zK/ipbev86kcvjCoCrmK5a?=
 =?us-ascii?Q?b3mP60//yu85+e0v6hOYo6IBl/a1b68OBOzBHMtljNKBpKFiWIrW13B+6LhY?=
 =?us-ascii?Q?qUuzS9HE1BbefxK3izfsoFYzfn4LKG8dqJ3nabC48JuaM8XQhEnwWbsdcM12?=
 =?us-ascii?Q?WI2+1N6VpLIZrwg8ZHCng4YhQrNuj8pGkoDwpIL5ntt95K71fblA8Xdf8b0k?=
 =?us-ascii?Q?sF7HKr4ajganuCIb2DmbGcn/dLBu6+XxZa87xwSIafl8ll2mBdQv6cY6FNcG?=
 =?us-ascii?Q?IYhum7FGDZOS7ckER1fWgpzqgy1+m/V7lj3MLYKi9yhf8Xv3MZLnTtdyU5+n?=
 =?us-ascii?Q?iT/rl4jtLKeTR35Lfx4feLXi8C6e+OnYktrFoHsT2PED6K/G5e+jnrcqCQTz?=
 =?us-ascii?Q?srUk7xSTi+7Mx32R807F6I06kp3XVqTjWkHhURqik2UCKYKcs/zjkN1VqHRT?=
 =?us-ascii?Q?hQfqAdtrBTaOUMRTDIsqCMKYi0OsSX2fV4ln2PZXmuqUrm8yUBrMLeNJD4Gv?=
 =?us-ascii?Q?nh4U7im6IBtwsAor4rJVZg7ljqq/qQ+WLCWsBTjaliEOh4K4ockNAf1aO92b?=
 =?us-ascii?Q?qG69DqZa+6KOHKdxXAsDd+LlNaR0pqDpzBejwZFuufdbSnzFbQYGBUjLDHKp?=
 =?us-ascii?Q?jpw6rypBKxl1pNDF2PbS7Af4WGR5gT/31XxsUUdFeWzUWbRkJhfqzvbfBfNg?=
 =?us-ascii?Q?wNxyZJqONd7x3z/U7HsstGIxVg8Zc1UA2T4m+FRCnjk=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3103a58c-060a-4f6e-dbf2-08db89ef07a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 13:33:12.0742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2hV8z6JQnYHcbTLhSoKsL019q0kKalz30o5C9BVsiDcp06ptYLa2TcyGp/mSJBGf7YRien665EbK7ETBnUOvmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR04MB9036
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 20, 2023 at 09:57:29AM +0100, John Garry wrote:
> On 20/07/2023 01:42, Niklas Cassel wrote:
> > From: Hannes Reinecke <hare@suse.de>
> >=20
> > Is now a wrapper around kfree(), so call it directly.
> >=20
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >   drivers/ata/libata-sata.c          | 18 ------------------
> >   drivers/scsi/libsas/sas_ata.c      |  2 +-
> >   drivers/scsi/libsas/sas_discover.c |  2 +-
> >   include/linux/libata.h             |  1 -
> >   4 files changed, 2 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> > index d3b595294eee..b5de0f40ea25 100644
> > --- a/drivers/ata/libata-sata.c
> > +++ b/drivers/ata/libata-sata.c
> > @@ -1177,10 +1177,6 @@ EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
> >   int ata_sas_port_init(struct ata_port *ap)
>=20
> This is a bit of a daft function now, considering it only does
> atomic_inc_return(&ata_print_id). Do we really need to export a symbol fo=
r
> that?

$ git grep ata_print_id
drivers/ata/libata-core.c:atomic_t ata_print_id =3D ATOMIC_INIT(0);
drivers/ata/libata-core.c:              host->ports[i]->print_id =3D atomic=
_inc_return(&ata_print_id);
drivers/ata/libata-sata.c:      ap->print_id =3D atomic_inc_return(&ata_pri=
nt_id);
drivers/ata/libata.h:extern atomic_t ata_print_id;

It seems to be defined and used only in libata, while I agree that the func=
tion
is a bit silly, with my limited knowledge of how the linker works, moving i=
t to
libsas seems a bit dangerous...

You can build libata as a module and libsas as built-in, and vice versa...

Also, since there are no direct users in libsas, I'd rather keep it in liba=
ta.


>=20
> >   {
> > -	int rc =3D ap->ops->port_start(ap);
>=20
> I am not sure how this change is really relevant to " Is
> (ata_sas_port_destroy()) now a wrapper around kfree(), so call it directl=
y."

Agreed, I will move it to the previous patch, so we also avoid the null
pointer dereference in the previous patch.


>=20
> > -
> > -	if (rc)
> > -		return rc;
> >   	ap->print_id =3D atomic_inc_return(&ata_print_id);
> >   	return 0;
>=20
> always returns 0, so pretty pointless to return a value at all

Yes, that would be a small optimization, but I would consider such
a change outside the scope of this series.


Kind regards,
Niklas

>=20
> >   }
> > @@ -1198,20 +1194,6 @@ void ata_sas_tport_delete(struct ata_port *ap)
> >   }
> >   EXPORT_SYMBOL_GPL(ata_sas_tport_delete);
> > -/**
> > - *	ata_sas_port_destroy - Destroy a SATA port allocated by ata_sas_por=
t_alloc
> > - *	@ap: SATA port to destroy
> > - *
> > - */
> > -
> > -void ata_sas_port_destroy(struct ata_port *ap)
> > -{
> > -	if (ap->ops->port_stop)
> > -		ap->ops->port_stop(ap);
> > -	kfree(ap);
> > -}
> > -EXPORT_SYMBOL_GPL(ata_sas_port_destroy);
> > -
> >   /**
> >    *	ata_sas_slave_configure - Default slave_config routine for libata =
devices
> >    *	@sdev: SCSI device to configure
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_at=
a.c
> > index 7ead1f1be97f..a2eb9a2191c0 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -619,7 +619,7 @@ int sas_ata_init(struct domain_device *found_dev)
> >   	return 0;
> >   destroy_port:
> > -	ata_sas_port_destroy(ap);
> > +	kfree(ap);
> >   free_host:
> >   	ata_host_put(ata_host);
> >   	return rc;
> > diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/s=
as_discover.c
> > index 8c6afe724944..07e18cdb85c7 100644
> > --- a/drivers/scsi/libsas/sas_discover.c
> > +++ b/drivers/scsi/libsas/sas_discover.c
> > @@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
> >   	if (dev_is_sata(dev) && dev->sata_dev.ap) {
> >   		ata_sas_tport_delete(dev->sata_dev.ap);
> > -		ata_sas_port_destroy(dev->sata_dev.ap);
> > +		kfree(dev->sata_dev.ap);
> >   		ata_host_put(dev->sata_dev.ata_host);
> >   		dev->sata_dev.ata_host =3D NULL;
> >   		dev->sata_dev.ap =3D NULL;
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 9424c490ef0b..53cfb1a4b97a 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1238,7 +1238,6 @@ extern int sata_link_debounce(struct ata_link *li=
nk,
> >   extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_poli=
cy policy,
> >   			     bool spm_wakeup);
> >   extern int ata_slave_link_init(struct ata_port *ap);
> > -extern void ata_sas_port_destroy(struct ata_port *);
> >   extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> >   					   struct ata_port_info *, struct Scsi_Host *);
> >   extern void ata_sas_async_probe(struct ata_port *ap);
> =
