Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CF0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 16:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353023AbiAYQcv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:32:51 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:24735 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378758AbiAYQ3q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 11:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1643128182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJVtwhexLTTyvK7+cbCA2+U78O2HrWITXdT18uslLRo=;
        b=bQL8O3YsZ54SYJf/4f4eeLTPHnM3fmyKNISdQCjhg6Epkx9/Bkdz7tZY/8Qv9zxGQum1a2
        ucs+TG1SEXcc5mZghB6e5Tn6YRDf9f1ya27lBwi5qegiXV4lWZozZctDxCol8DfygLUC+P
        cl5mDS/R80Vy03ezFSJQ5/2EMP1kyJA=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-34-maSOX-XdPlCWnCaD9Dt0XA-1; Tue, 25 Jan 2022 17:29:41 +0100
X-MC-Unique: maSOX-XdPlCWnCaD9Dt0XA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oo9719kTtJiNCdAUJ4nt4BSrHKOKenjWCMun5NKD9zlWFkDl690ZJ4oVZ4eYcKUf1kGFjw7D49vSVdk+DGvPRSaJVuy9hb4tTpId6C591xxiEkue+ATNM6uTF1HFzl6FKNxWr414bXl9mp5GpNNQ0/8edr+nloPxlNGdh4bXkrBj4kf9nL7UWV0CMpqmog4b8GysuoceyfcDujNIx3wFg2enam2tik/oX+1dRPrSgBYdks085lVZ9D1JDwSF4sdiD3QbTKix4+Xs7nVTa7AfEULtj1nT2yg4dgyGbZkSLP+LNW0RdrgbCp4pgFHALFfJY6NH+/+aQwZjSBB9GT7LIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJVtwhexLTTyvK7+cbCA2+U78O2HrWITXdT18uslLRo=;
 b=cXQOoF56QH66Uq8ObEy/XK9JVfUATWx23ABtV2P31u5r+tC3h9d96mfSsPzm6ge3oRtF+kx+HcYnkGvPr3kEEV/KW9hfOfb4dAs2tSb3CsdZpPAWu44T0ryKcTkNCIJ9U5E4rvaxcOuog0ePMcMySBR9hQf2SLBi+Q9YqEyCxw/JCuw5a/IGpx7/8Ig/tF+/yCKJmKefE8CC0vv/jjsbf3J5kJLuxPWx/kJRVbOVIAJlM1cmYGuONQ18A7Rd0IOus7b88PmxBzPbKhe4M0wC5jfRS7BiWbRjnDXR5M2V7A/Dbr5VcUEbI8OqukxMe2GYPR4Put1d6Cp7tt3WBEAqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB7PR04MB4364.eurprd04.prod.outlook.com (2603:10a6:5:1d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 16:29:38 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 16:29:38 +0000
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
Thread-Index: AQHYAl4nMXu34/rIHUa9cQ2p6vlOuQ==
Date:   Tue, 25 Jan 2022 16:29:37 +0000
Message-ID: <53cb63b07b187ed608d9c93bbde11d1c8953113c.camel@suse.com>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
         <YdZcABq/pxMMh3X0@T590>
         <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
         <YdcEJngPYrZk691Q@T590>
         <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
         <YdcNrSJJGllQzWOB@T590>
         <5fffbc9191d1f1b3db1d51ce991591c9c6d91785.camel@suse.com>
         <YdcZwVUFGUPgkbLn@T590> <Ydug9nWg4loEVkJw@T590>
         <419311a6df021b0ba7b7e710caeb7e649ce8eeb1.camel@suse.com>
In-Reply-To: <419311a6df021b0ba7b7e710caeb7e649ce8eeb1.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45415d35-b4b5-494a-8363-08d9e01fe17f
x-ms-traffictypediagnostic: DB7PR04MB4364:EE_
x-microsoft-antispam-prvs: <DB7PR04MB4364DEC47F8FC273233DE0E4FC5F9@DB7PR04MB4364.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pRA/CCZ2v7I1Y2RpCLET7yutfEDIxGlTKjPjb1mVh9KTHPv8z1IOqooip538FoXK3zSgibLA70TPxzD9Y1LVhgvoOQll2yFQXKB+PNQ/znUclSekV2VGj/3LrotF0ke9e0P8iTADKsANfFHiLwiThhVo4E86L9lHHuGGyK1qPTunniBKWUYWLtibNsB5HGt0itfMjxdGg63jzG48jspesbzGua0t+bIzDdGqMTnMc8YI5jhDwHmqPoCJpdCv3/4P1Wf0R9G2TOMYssAvvkevH1WbOQRbF8I6ksC8rPcu8+EmzKlJWJ1NiUg6jgishZZFoMOiBvO3X3GdB9LLzFrSAcr2uGN17Oi5oanIAbBXAF5OLfOCC2wHRZ18/OOUTskBNsWMxfowNqoMVx3pyQOkQV1JXLWkmV1h7KXGEh1cLJy7g/DnCBO/B2VHwwLR9OLsFAnwBB+TzQPiAtL+6wxODQ3f2F/f+IECw1Y8A1ko1V/7O4gC/2pKUJy4dkjY/Fupqqx/5Hn3XiU5tNtFoQ3vH/gMhwiRa8XaWigNELDIObq6juuxydoMC0iXRGScX3eH+Q1aFmKB/QwWCCYiRps1Fw/tZwTHRYCgs0CWtLxi9Qnhxvm34Hv0BpcOyp1tM7bhlv+5gFpUUbF3mD14zaSqYHn4HbK+7gTnNQ2zYyM5K5D0rv+Dkhm0DdV65FYTYEoTD+ZTToTo42xIEsvESOig2ubWDfLb7zPb7yLdWqFgFdz/p0LjgDMpqKrYTH/3ng+GI0SWlbAwQk7ht6hzd70TEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6486002)(36756003)(38070700005)(66476007)(2616005)(64756008)(186003)(38100700002)(76116006)(66446008)(86362001)(4326008)(508600001)(44832011)(316002)(66556008)(71200400001)(5660300002)(26005)(6512007)(6916009)(8936002)(6506007)(53546011)(122000001)(91956017)(54906003)(2906002)(8676002)(42413004)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?W+lnUmAV1Bh973q3scnCv5fFJkBcBc4POZoUb2PCyNxo8sg8ccbKSPrau?=
 =?iso-8859-15?Q?kYtNXDU/Ne5ggFXYaWqvQAyp79mjacnNJJPfCH56pl9gu0qjnF8dFs6bV?=
 =?iso-8859-15?Q?5u5OM6hMCC7f0vQiAWYZyrtXjax+w9WcIdoKz7tWMajmnOG9vk13QZrMo?=
 =?iso-8859-15?Q?1ByXCkpMTWAV2m/zRcx4Fk1MCyMj1lPf5myVWvSjwFbjJ8xPaY2WHkMgz?=
 =?iso-8859-15?Q?qRqcSp1WAOsC6dv9SNu+BfefdfqTriuphlRrZBri4B54ZUadlGx2BY1Qu?=
 =?iso-8859-15?Q?DB7WloCe2bRmITLN4x+p/e76bE6zWQOZ9J8X82joO6hGIqKpywl3FzH5E?=
 =?iso-8859-15?Q?4BKLYZSQLx0hfOYVUcfSpjn90nkRBpqS38nIIptc3W9CCHnkdNuLHindD?=
 =?iso-8859-15?Q?MrC3IcuvJqs2ScFZrVAOfKCv3cZsWWO3nG8FZnTuo9kt27/fhttADaPIg?=
 =?iso-8859-15?Q?6fUb6QByFy5050B7M/ggjK31GV8TitbCNr5gnqfFJAzFMR1bqMKlBYHOv?=
 =?iso-8859-15?Q?96MSh7SlRDqUoPR2mz9HK8B0xPD1K+FIPrbYSy+q9yz65H1O/nSsbI4fH?=
 =?iso-8859-15?Q?SpHvGiF2bCYqPSYzUPz3mCrPSeRehyoMO8ZmOErT70TCLME1esVGrzTjY?=
 =?iso-8859-15?Q?qD0XGH4YyEh6eyhHSjG1fgtwwkXc88PkMS/gxMtDow08WfwFzkMrt88lJ?=
 =?iso-8859-15?Q?nmykxv3yB8gKT7mLfbsmiKez1j96bTkPLSOP1yUz/374GPngdExHB0On+?=
 =?iso-8859-15?Q?dU0iGich74Wtce2+N9JLZv1cPTZ2eGY2ThCOzcregvH2Ss+1MwA9g6Zvg?=
 =?iso-8859-15?Q?OMOL8FY31IY515karvatWQhxs6uar+Ft7zpRsLYHUHiBftYFV6sQcXbN/?=
 =?iso-8859-15?Q?xYluajRtxbHshHn5fhp4Q8OBpBoyCqpXL2lsAhqyx7+Tl9DRxK6b2CWRi?=
 =?iso-8859-15?Q?SfAVKPQSTlWxsS1SOdg6XBa1JZcm1t1NJSCHDMPpjizkqbbYMUeKBb6Hr?=
 =?iso-8859-15?Q?KG4NN/UsLdBTLRXsl+CX7FcbskgxKNxLFOIo0A9nv86mbH6zzQsdNi02E?=
 =?iso-8859-15?Q?4lyxrDLaXIcggzwBJTLMoqUKTFpVPbzuIpH4SZVI3wJhO8RpIfno+ezHE?=
 =?iso-8859-15?Q?POm5v/SzDYkvKD8AK4iMF9OyIkGfLTq3rOGH2oec6AQfvzNj//GKTajB0?=
 =?iso-8859-15?Q?c6UGFhRNcY4Wzg462dc5XOf12o6SZwABmHT51KVbtWR/IG78Awrd2oBYi?=
 =?iso-8859-15?Q?h27bB7VXU0nM/+Rd0WEpTLoFR/HRDTR5MxD2VaYT4CwtZu4/TSBVH8xOf?=
 =?iso-8859-15?Q?spxwY7daz1m6Z5PodmnIqnm9PXKyxQl6kqGeDQywldagTAGLBUofsvrad?=
 =?iso-8859-15?Q?oEXbWVLoqy9/CrupEGR9ECStaNEap8/oz5d/mUzgHmlz+XR+E2K91FkId?=
 =?iso-8859-15?Q?eAHX8npe5Ns7HPPynCNAENXhghq29AugHKVVHGz2ptrB+u1/IUuHqywjH?=
 =?iso-8859-15?Q?TtPgUhCls1u2W2Uqdzuhuw/x+fbxZYM+yq/kcC983B2idQJJynuXgiFpX?=
 =?iso-8859-15?Q?R6buBUJk2qjfjmeV2lu9IVa9juerube2pDQlUuvsG1i8M1IB1HWtIhB7g?=
 =?iso-8859-15?Q?8yWaMdxXLOjoDQ8+aWBBwR+UIh95KANhS1cgIfh12mCLLR32SpNBaIsWG?=
 =?iso-8859-15?Q?fi0ceRcNtAsqYMjQMZ4m4ii5LJ1YkqZbzFnWFoG+WNC5OJA=3D?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <B073D341F4C8BA4F8A67239FFAC1714B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45415d35-b4b5-494a-8363-08d9e01fe17f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 16:29:37.9935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CzXLnastrP4bgl0UWQN3ysGjsFOJ2KHppQlFMhzMD5ZbnGpnT5iwCwVva7olB/eR/eCYwgScZyFiHU52V0nDFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4364
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-01-12 at 17:59 +0100, Martin Wilck wrote:
> On Mon, 2022-01-10 at 10:59 +0800, Ming Lei wrote:
> >=20
> > Hello Martin Wilck,
> >=20
> > Can you test the following change and report back the result?
> >=20
> > From 480a61a85e9669d3487ebee8db3d387df79279fc Mon Sep 17 00:00:00
> > 2001
> > From: Ming Lei <ming.lei@redhat.com>
> > Date: Mon, 10 Jan 2022 10:26:59 +0800
> > Subject: [PATCH] scsi: core: reallocate scsi device's budget map if
> > default
> > =A0queue depth is changed
> >=20
> > Martin reported that sdev->queue_depth can often be changed in
> > ->slave_configure(), and now we uses ->cmd_per_lun as initial queue
> > depth for setting up sdev->budget_map. And some extreme -
> > >cmd_per_lun
> > or ->can_queue won't be used at default actually, if we they are
> > used
> > to allocate sdev->budget_map, huge memory may be consumed just
> > because
> > of bad ->cmd_per_lun.
> >=20
> > Fix the issue by reallocating sdev->budget_map after -
> > > slave_configure()
> > returns, at that time, queue_depth should be much more reasonable.
> >=20
> > Reported-by: Martin Wilck <martin.wilck@suse.com>
> > Suggested-by: Martin Wilck <martin.wilck@suse.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
>=20
> This looks good. I added a few pr_infos, and for the strange mpt3sas
> devices I reported, I get this:
>=20
> # first allocation with depth=3D7 (cmds_per_lun)
> Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: 7 0-
> >0=20
> =A0=A0 (these numbers are: depth old_shift->new_shift)
> Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map:
> map_nr =3D 1024
>=20
> # after slave_alloc() with depth 254
> Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map: 254
> 0->5
> Jan 12 17:05:52 localhost kernel: scsi_realloc_sdev_budget_map:
> map_nr =3D 32
>=20
> So the depth changed from 7 to 254, the shift from 0 to 5, and the
> memory size of the
> sbitmap was reduced by a factor of 32. Nice!
>=20
> Tested-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>

So, how do we proceed with this patch?

Regards
Martin

