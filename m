Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A43C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 15:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbiAFPW6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 10:22:58 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:21382 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240393AbiAFPW5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 10:22:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1641482575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rAinODIHIPpreFs867NHsBwTUzLPKBx7WCc5efDGM3o=;
        b=BjQkEUCNspKapjcliMGSgGF4r7nYzBXry1AK0Ccbz8c0VNY3AsG2g3kcAwMTQb6mIWxySV
        yigAPv9iDRayVyQNp5bhZp2+cBPF9bhDvN7TrMuU8UmfagKhBKQBOStHhImmQRLrFE8NB6
        RXB8RqZ3ytJ5E032HhYvzrp7neLOGFo=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-16-oNox9LwZNWuSx0s3dR8U7A-1; Thu, 06 Jan 2022 16:22:54 +0100
X-MC-Unique: oNox9LwZNWuSx0s3dR8U7A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asacUOI4XIGD6vnGVJtwET+uqbK1U/JVURa/MWiJ5ss4Gz9+2wEx447AzTAq1yZ4GHN0/owPXWiAnl/htPsxg3WkPOWxDBYuzf5JcWZri/sZ5QTwnhhn53gfFvGZsa9trXRRdjn4PIlppxxKp4yd/2LzzVx1pQdWrzORHxJ1ThcJl9tV5tBZYQdZ2KZ/56ox02rA5/e1Vce2ZvSVsfDK+ILY5yRWL5ZQqIIqaVddon0d5B38RLpgh3KbXqvf4jQgmjYbfsOhMNXL/TXAR+ZSB+MtcXKzZiCHSimuu0KJJ2IShFq//MRwJY42kufNyTxgnjfAKjqUeNBDV7dDEx06gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAinODIHIPpreFs867NHsBwTUzLPKBx7WCc5efDGM3o=;
 b=m4xgcJkyRlzVxBp/UGPXoeW7nF346blpgXpr1OO//9filiDw0Fh9l/paEmUvgRNK1FgXYG54JJj1SM2evvHLJwGJVYvxqq3xMlq64sRAF0hh/IY86TJEzqOC/1AwJuRI/KGRv5TpE7SFUXsBRcRcu66yrvwQLoz2Z3tfCoGEM0w/9x5APfXV3OmRpKDwH0dASdIjxe+cakX5cbhb9IfSDUvbVuKlsUXK02sWT/a2n7yLVvQyTq7C7L7LSz4ADoeWC1EsJXkf6qCkCGkxIX4vI8Kf7hOs9Z0tCM9/PO3XVz4VbGGHKFCarpFNvm88vfLdGrrFJ3j47/RgKEK6HTdPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Thu, 6 Jan
 2022 15:22:54 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 15:22:53 +0000
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
Thread-Index: AQHYAl4nMXu34/rIHUa9cQ2p6vlOuaxVTzgAgADIjEOAAAYLgA==
Date:   Thu, 6 Jan 2022 15:22:53 +0000
Message-ID: <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
         <YdZcABq/pxMMh3X0@T590>
         <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
         <YdcEJngPYrZk691Q@T590>
In-Reply-To: <YdcEJngPYrZk691Q@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 972ca0d6-efe8-40eb-6a35-08d9d12868e9
x-ms-traffictypediagnostic: DB8PR04MB7114:EE_
x-microsoft-antispam-prvs: <DB8PR04MB71141752B6CB5BD4766A16D0FC4C9@DB8PR04MB7114.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pPzk/LgRK2d5u10nUzasAJZjOtuU6Pb7UiOTv8QTZSUTCrI3El0E4vSMZmQsfJaqRsSKTFwkrde+0PviFeACVx72kT9GI+f5eRxM8DPJOz+ZLdIrq7SsnAYTtFYhjZaAyZhgFKU8nBNUA27haX0V66zBC2CwaH1UuyJizNgMxpC80iFQAFYlrOh34GAGk9vRPA3BteykVDOmaigFEsbYMvuZNmy3ZT1IQdIUoLFQPuymvY8FWvp4F4gXvZsgY+BOWSoXXMzr9iU3vUNcCAm/JT2pRdnzZ9dgbcn/NKW0n3Xyrw6z0QR3FDU4ZUvqjEzaovx7gYS9FDPqGDR8/8VL7GKN03NzoybzDTNYZ8fpb7eAws80lEV3uTuaAXlUmEDRJSyJ3xkIF28OEQy8Dd3Ig6rNfiFZWZeEkJ9X3u3AclxTPDqbobzHUD7Q/4OVEgHZkbKUtVsiocRcfe/kZkDdhkyah0dm0+KqhghI+9I/AgcxFmPlP1bGZ7AZ0OiastGZFByXbi0Ms3HWphyBGi5dv5R2hVL05Ku/FkPd3oWa5xIJwdbzcADenjIspG5dSdrBX1qNXUo4duM71XnM/rrBH4TAwXIOC0CfqhAezt1upyxYhf+GZzlmIVrXpNAJuITukrPPCXOxHpj4aVKkQLXB77/39cJVT0nXWy3BhIpCgFwOR0iGV/0IVKNLbrmGvmE525cLKkE8kTjI1n7E3nd6dnuXraTguYRYRCI4Olggn1Oo1ZiEkogZsvBa+ExD9wpMD2XWvN5iSw1y6DWZZ5xyww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(6512007)(6486002)(8936002)(186003)(83380400001)(5660300002)(122000001)(38070700005)(36756003)(8676002)(2906002)(316002)(508600001)(86362001)(54906003)(66556008)(66476007)(71200400001)(64756008)(66446008)(91956017)(66946007)(4326008)(76116006)(38100700002)(6506007)(2616005)(26005)(44832011)(42413004)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?A/xHqf9yZi36uhNiUpgZfQfaeTQmE10mxhzUcsjJDac9O7KyMkIdRTivd?=
 =?iso-8859-15?Q?lpS2PlCi+Pf89L7raxhSyfsNHC8M19mU/JHeg51GaR6MtDK/hnW2Cb4Dm?=
 =?iso-8859-15?Q?3yr8h/wYysE22aHusEpDAhFaL7Pfr83j/iWtZssLgDvDj736fYhyMJFmj?=
 =?iso-8859-15?Q?SAcGZiGoQnig/F2/kMJ7MXSlBqDc3KLriWBMuDkNbtdRzAOPnn3Q34rXj?=
 =?iso-8859-15?Q?C5qYQdjp1JUeHs5Z2kZCuawp+N93SL1VoX/QomUqIEu0wA/70LIylGFyq?=
 =?iso-8859-15?Q?D5TnhOwsjYSkc1M2A5npO20182Ok4zaxEeCtso0mj9v2CpVvEemFA8OKP?=
 =?iso-8859-15?Q?KTC9JOi2Xg8qOVWK9zZ8vFbkG4DwjzCj+kMEOy8xzyQoSWrwi50BQRdri?=
 =?iso-8859-15?Q?+Q0NYNN7JiCIoVosI34iQs2cgN8+ERxU9D+aQxztpuCXiOSgrXb+cIWk9?=
 =?iso-8859-15?Q?8c9j9D8q6U8Cvn961/tR7hkRE4R4tVHgTVwSd73Vy5AeQ6SxMIPsCRx7P?=
 =?iso-8859-15?Q?2bxkBnYOX2dR3v+wmc/I/zwVompsrP67nLfn3vLKbgzJLXpyHbJ3wX7bv?=
 =?iso-8859-15?Q?RKl0N0QY3hlb6dGg6w4d0hwW0OE5KcAhE87ryaAvqRKJpU5u5f/utXEoT?=
 =?iso-8859-15?Q?hIchDWxd2zrg+yJb0R7ADdkMu+XUYrAx55jVIscr6rURNBwt/QFhVsrMf?=
 =?iso-8859-15?Q?tX95JvYKODfcA95YlhWozMEIjWq5C3/Yvzyamzs/YRWalgV5S77AAPgsM?=
 =?iso-8859-15?Q?2iv0QIXdqqCXS/yw49C23pFG1zh3S74Dw7RffUfpBVa1WnOe4vaFNmeVA?=
 =?iso-8859-15?Q?DVjp4qvacHBm3wetBfrzp8Z2cQuvsun2dDmD+HBNz68GjfLTeuqPm06gi?=
 =?iso-8859-15?Q?3B8Igps6ouKRDJRF+Dub5eYsObY9ndkTRiI0mo6EmbPEAEmuNtKhpZbN4?=
 =?iso-8859-15?Q?s6tI5G8bM6DZJSC+At2/sw1Ps/TQvnsbU8TsLvCfTOXzfDgDIGnc9h9xq?=
 =?iso-8859-15?Q?YTmESG3XlBz/VruoxDaNudcYW3M5KxcEQZaw9mrgND5VyiuJwi1/pFTJt?=
 =?iso-8859-15?Q?RuajKHbJnnPaJ32PX45DFcbB+rL+WrxDAjluNSxMQ8GcQ5MomkaVzdeU1?=
 =?iso-8859-15?Q?YU4sA4O5WMEYlVZtAFWcSwleby6dkXkRqV0TcyJrORApyy/LeYmEZvchw?=
 =?iso-8859-15?Q?s2CsQuZytAysHW+wS2u6l/SjviGqk0AGvItp4Vu1ZuYnbInc4P/owSTwy?=
 =?iso-8859-15?Q?1DtfAbBczdcJ/RaN1ZszKTaSRITNMNSeHTK62fNncGQ49YWKuodO1+W7E?=
 =?iso-8859-15?Q?ziDf9KPZos7fH8DjgBnwCKe16oaA7PBXyPOCPcHSj0LhO84OkIz0w8Fvz?=
 =?iso-8859-15?Q?4FEtN++DwkoAD3mvsPTt3GRFJnCBszUkieOqzzny+cUtKkR25ge0EVGeQ?=
 =?iso-8859-15?Q?Ep9kI2NbtMFiWAy5PfwvcKbEOx4/rNw4HrSRAsllOgJcR1dNfEznehFcS?=
 =?iso-8859-15?Q?1OOtpeMDOfwwIXFFoGumRtXsbnXF8Xwjcd6qf3RCP95VY/Az8dfWirg5N?=
 =?iso-8859-15?Q?WD7YnWk7NnvYPLDtOs0uiiPJ2xTF2wL7Sbg0bjKYp9CDP36OYifA23vjB?=
 =?iso-8859-15?Q?FMZpiWJ1wW5wzpT6GHxppUmM7Ya6MQ8IzBZdsT4IvwIbmoRgPiOxeuOXl?=
 =?iso-8859-15?Q?+KteQinN+a3k9BfYeeN3/uzzYJzVS4XMODuZKn1qavzQAuo=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <1D1C9838E7C9E943ADACCE5063D96FDE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 972ca0d6-efe8-40eb-6a35-08d9d12868e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 15:22:53.7201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /X7kc/b8sTpU+RLAd2C9pP3buzLyXmTdUVs0uaurGeuowFBaihbU6sdl2wicDKZHv3Ewuka9oynrhj4e8LR9/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-01-06 at 23:00 +0800, Ming Lei wrote:
> On Thu, Jan 06, 2022 at 10:26:01AM +0000, Martin Wilck wrote:
>=20
> >=20
> > Alternatively, we could inhibit increasing the device queue depth
> > above
> > a certain multiple of cmd_per_lun, and size the sbitmap by that
> > limit.
> > My gut feeling says that if cmd_per_lun =3D=3D 7, it makes sense to use
> > a
> > limit of 32. That way the bitmap would fit into 2 pages; we'd still
> > waste a lot, but it wouldn't matter much in absolute numbers.=A0
> > Thus we could forbid increasing the queue depth to more than the
> > power
> > of 2 above 4*cmd_per_lun. Does this make sense?
>=20
> I'd suggest to fix mpt3sas for avoiding this memory waste.

Let's wait for Sreekanth's comment on that.

mpt3sas is not the only driver using a low value. Qlogic drivers set
cmd_per_lun=3D3, for example (with 3, our logic would use shift=3D6, so the
issue I observed wouldn't occur - but it would be prone to cache line
bouncing).

> > (*) this calculation ignores the use of sb->map[i].depth. Taking it
> > into account wouldn't change much.
>=20
> Yeah, I have actually one patch to remove sb->map[].depth, which can
> reduce each map's size by 1/3.

That sounds like a great idea to me. I've also been wondering whether
it wouldn't be possible to use more than a single word in a cache line
(given a high-enough number of cache lines).

Martin

