Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09132C7EE29
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 09:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjEWJ4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 05:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjEWJ4m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 05:56:42 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7773FE6;
        Tue, 23 May 2023 02:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684835801; x=1716371801;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X+xTEGhvEeyilaC0MXUy3IZfCMR8LMsxVHkgEs64OAo=;
  b=jAebaq9qN/QTqsZj5/6cTvl2mJJWXkQ4QNo7ATkj3NwW1pgPy1O7AgVg
   iABkAeyrTZ6+Bjh2yw57luDdGjPe2OWsPkmL73l19jI3kD6ta0UcUAZuc
   ZNYUCnFBiQK76KXYZnQED+8hoe/yNPMgJFZgoBwv86pSj49ArVqlOBTlx
   umQXEPACej2Q8i1GZLOynFhq7ZIobMfZnY1bgv5wRApCnzc+xQHxwA+0i
   5ANI7KVVG9RloZPcX1xpGl4dLJY84UcnNXnJa/N2aH0CdCQA8eCoG6dBo
   6FOJwdG1AC3DWvoreaYhCfP518YwKCPlhJ1eJ+4LVT2OMmD2WylOlnQR9
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="229600851"
Received: from mail-dm6nam04lp2045.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.45])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 17:56:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WowqT68agAwRXe88kmuSyB+IPTSUagJi4ttWQguEgSLffpOANBOCnxiu8P4ZVde8hYvBqa3og4nUgiBG61jvikuML36i7aBb817q72/dslsRl1PqbgMhphbDKiHOwYXMEO+aV9q4wmjbHyK3E1teqVOBZT30Km01aGWIGQpxhHKhZHeg2r0fYFjvjZFlKIf65u2bUxAHaCwXAqRLFBI5UYrZM6xZAfgizUdWcYn7mQOT+3WCW3Y8hvU9DTHMwnSdluqOc6/cYU7u7bF/0A53qdGD//68iycZvrlvkrVfIgOCzNkXuafcyqsuQVUnEUsnBSmkMpZshsjDuy0Vw3eQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+xTEGhvEeyilaC0MXUy3IZfCMR8LMsxVHkgEs64OAo=;
 b=Y5pD2PrmFMHxb+TQEXFuw4aM9ByK1Rh3GFdv1a4gbY4n7x/AOMUYGUPOLi7+XwiZaGPQWiryX4i3Z9zEYuhYPEWHr9XEDZxONXR354POddzhIj7Z1nBmx0TuavAU7OZ0qfJnaaOFJYmNABzNmcUsPUHc1H0vlRmRjy1XG0smgXokhH8VNxvBuTLV3FbH1F/C0YiTujRT07OOm4OKMvKaMakdHaogdbJzwC7EpwSKSRa98sf0R6trA5kpFImnk1UcvNR8nubLjQ4jaKreHD3LtUnP9FGngpVB6W+uBMjPts8t5XA/uQEqwMPdW79i8wTy1cuGq07Um8GdCINoGyZ4XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+xTEGhvEeyilaC0MXUy3IZfCMR8LMsxVHkgEs64OAo=;
 b=EDxKeNxBUV6N3PIKwnXQfETROvx3diLswtUGpiDMtFm2CmoU+8qRGMxxdqmfzBFCq3LxsKUc0vwStS3gO+LN/D/P86RzaKn1xyETRS032/OJ+QrBsQGDI7sd9OPTtUqmjUJ9LSpODvjZcOWfG5Com0g1vyBX1G2qd0CD8M/+s7c=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB8471.namprd04.prod.outlook.com (2603:10b6:a03:4e1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Tue, 23 May
 2023 09:56:37 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:56:37 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
        Paolo Valente <paolo.valente@linaro.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH v7 00/19] Add Command Duration Limits support
Thread-Topic: [PATCH v7 00/19] Add Command Duration Limits support
Thread-Index: AQHZg6YjwmqGT0LeSEm4gLZ3+3m4lq9m5R3RgADNTwA=
Date:   Tue, 23 May 2023 09:56:37 +0000
Message-ID: <ZGyN1KkCXsTo8ZwG@x1-carbon>
References: <20230511011356.227789-1-nks@flawful.org>
 <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1h6s4nix8.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB8471:EE_
x-ms-office365-filtering-correlation-id: 2015b5d9-979f-4eed-c4f6-08db5b73ffb6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TGlr0wqgmARo0vS248X7clsk/EM3f7LwhlgZTSAwRjE7Y5HS8XRlNzzAKosTNyBl65JXrHe6t0B9kmbFpbjsqR8/oM7be1WrWyIwh9AugMYpZdEuenkcSjaO46lYInfhYCK17ueOYrOUioBUThdlNngytq4qvXh/7s3UfJ5jZs5qwWY/ocKaHS6eBtWuvrBueB34SrslIyw6RG612fPOh9p7dcK9zGuhsoOiqzDIIW3ImgtONZOUwX/lHNfNMyF1io6g505/QabL6JN1O+dB3m9B9OjmHrgdUMOmbaW9bVUCmcWwCGpleLp06URneHieOh3N7P/FdF9ttw4h2793afYbNdlVhBHzo/fUKhBeYVkLVPPhNb9RWGfdFsfqUtbdgOQwtxV4z6M1DA+1vSvvwmdsgNq1ZaIr4jvMcj6XESfDz/0z9FxF7245OmuGXsAAUyQkHC/8G0WoJH7fHzINGHIelE0giBaNPXMNeI90TgUMhtNAATErFmmVNKOM/q7SPK0ITnOISPc6Y7W6I1P5XBCMQU3gPZfWncjOcXkrHTW3rNGOdsSFClijf9yVPBkhYSR+PBs0drt6PdbbyTQPBxuMfO/ryqvEWRqzv5fz+as=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(2906002)(33716001)(71200400001)(6486002)(86362001)(38100700002)(6506007)(83380400001)(8936002)(9686003)(6512007)(26005)(122000001)(186003)(41300700001)(82960400001)(66446008)(54906003)(66476007)(38070700005)(76116006)(64756008)(4326008)(8676002)(66556008)(6916009)(316002)(66946007)(5660300002)(478600001)(91956017)(966005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PuCvuI6wIZxAhu6JTQUdN/ILbvoUA7lWA8vHWwAe4xgrx1IAUyCRz4/9kR3s?=
 =?us-ascii?Q?eTcS1retU0P4HQ3JiHZHy5L8ktDjMsUPwyV2qYfi2mXL8In99nBqHrW7vat5?=
 =?us-ascii?Q?NCI/YiwaVCU7tqSxVvUYd7LtOwSu1QWdPvxtqFKloi2YNO2Va2aOmeQ1O1tN?=
 =?us-ascii?Q?S6nK9x5QcimbJ42doRAE/sC8TtzLbt+g7mN5nJKcAeRxH7wDjmNR6rbjTDrP?=
 =?us-ascii?Q?DFK7BAucBBiUSxGR9p333WsT8NbyHFTsUzB1M94px8DumXs6QULq7SFBK0Aa?=
 =?us-ascii?Q?so70GuURt8Pe+9TwiC/f6GwEhhd24DPp1NcDKKWw9WiFFF6xMayNMVezaMAl?=
 =?us-ascii?Q?850RtIt8Cghj13eW7a0TdUXa2Ks/msNOv4ggCZ+UgreBR4rCPkmHp3qSMrNh?=
 =?us-ascii?Q?DRQjn1kNH39N9g6bWvmItN58AJyGmyVoBHK+U93o3C2nHLbROFLZcn/1E4nt?=
 =?us-ascii?Q?VDRSyLbH3NKEHWxb7JT/raOF91pWRdgL+c6hNOhJ1SP5J2v7RcEAq80BvsVj?=
 =?us-ascii?Q?h8FLq4zatDwF55UdHy2Pdb0tYrUql6yhBZ3i3+wV7GDjPVJ5kU9PX94o1odW?=
 =?us-ascii?Q?4fUwi6sVG4e83CX4T0ECOs9NLmHW7dlfBdTBe3hX83TuU5kwg8LbdAP7oUyw?=
 =?us-ascii?Q?1X0Ay4pdslFPZ4NWSYj27DMQOqi9dAGNFBARVxVevURHftbHLwu6CV41WMc1?=
 =?us-ascii?Q?1K1GNHWhYoJc2hgLB7ZqE+48NQxGaRdTLYDTrK2SobeeeJlAYWF8AD29n6pQ?=
 =?us-ascii?Q?l1VbBsZZZBR2fj9B2Ki2Brzshnw0h+pxs37c0ZFzvJVDxvBaR1MmCremKVvk?=
 =?us-ascii?Q?lYXkW0OnXGwys3rjuZ0jDDdWKNwjMSTUh748Eq7T9UBmh3rAZQpyg9bhW5nH?=
 =?us-ascii?Q?XOtnCA1Soz6at/5DNxobU9slavU+B23XIVLLQLkD/WM8pY+ewNYaZyouSpHh?=
 =?us-ascii?Q?L/0jkJhJoLlVbMBDxkBW2pGklF6MOgwDOLg4jwwiW2r7cX4DWwmo4iYGJqGS?=
 =?us-ascii?Q?G0G/th3OGDdr1WUdK3tHW/yeEs8a5oC0QZS2B2PNquspD3i1+yOtOZZRzHjT?=
 =?us-ascii?Q?Ypve5KLNCMCh1fW/uEJfbAZwBXyIo6pijPZU7bJvVi9fVdqIyGLTf+bxI6/n?=
 =?us-ascii?Q?8iAfzsWQ3ruzjMPAIX86P3KPU+5O562sE+VEWH7hdUxGaPLwRwgqJ6Zeqhmm?=
 =?us-ascii?Q?jwN7a0kQgxxbJAEvhYVAtynqq/+pjxrVu+dijtiwiNUCg3Li2hp58LGNTO9H?=
 =?us-ascii?Q?+HhzXoEu+DFY1bah772+p0wE+gXtylxzx4NNpavNN1JncrHG/C7p9W/Pc9Fu?=
 =?us-ascii?Q?q3s9qzqNZzEK36jTr6twmlRfHGudm+W0ATMg3m6+42iqW/jnSeJc7PxL0vG8?=
 =?us-ascii?Q?xKEjp8baSlWfx3X9YDfIwRVG196bcmsZUcggQESqogjy6t0aEcSF5jj2Z1PL?=
 =?us-ascii?Q?NAc1Y0qtbiShMDtcYAU9S47LMpano5mSwSI2MXgMcbbmPzkNyPwvH84+42jR?=
 =?us-ascii?Q?ygwcy5e7ulafWqKe1i4uuARUXL9YX6Gp59GJgXq8DrQdw3bX5OUlAgao8h1r?=
 =?us-ascii?Q?wCVwmbRjIEXF9Ih1Q/Qxh0USVv899JT0JBL61cyB4ZWCE89ir642ECWHstsl?=
 =?us-ascii?Q?tA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <63BD71B88D9D3B40A471695CAE2C72CF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?jKCQqsIMWnkwNCGffYGeIAHAuRFVdIsHa4Cs/ZHpUGwm8gFvdwegrsceTYN3?=
 =?us-ascii?Q?2yYLx9T2P3fesBU7xJnB57fBpsq7DQGgU5tGcZZIv2BRwCfWih8agtIk91AK?=
 =?us-ascii?Q?c7p+U0o1LWzjhVwZsPvZxWiQe/c5+D/CjGRgm3nzpnEtab1929m4SDBwvMkO?=
 =?us-ascii?Q?Qezj43lhf1HC90ysjYbwxuyD0D1SXGL7PBfWXbO/Fz7FTTKNlwnJOyiYzmFa?=
 =?us-ascii?Q?SYezmtya1Csym/VEiRNTNogaY3GWtu7NXmo7c0Sk33UFsshygv7g6/jpFCEj?=
 =?us-ascii?Q?HguYVqwTamvWcS8pqcrxyPLbQqv9NaA398aOIe6jxTL8rwt3/LGFWmIVcEDh?=
 =?us-ascii?Q?2hTIOkgHLJloqvK9Au0S+Aw0EEt0Kg8SlwYOc7u6UvTaEzuuwSJsKm7Zs1JO?=
 =?us-ascii?Q?zUleWuKATu8WOQcxqDn/V3sa01l2WyzN6K4CFeKewMYeV12LU6Gine0TqbDi?=
 =?us-ascii?Q?kORzx5TbwZWYBCsSf2G5RBeShg/hiQ3mpNb3A66wCcMraREN5CNmjSVtuTrW?=
 =?us-ascii?Q?1HPw9wLFsV2dEHFZgWNqmFss8TD2yh/pKPtO+sjMUm2wRD0YzZmy7LTOLavP?=
 =?us-ascii?Q?HFyaNbv0GTsFyqf9TU5Zorg22VCDdeFSZUCKx/x3i1jPvTtukZlcBcm0skoq?=
 =?us-ascii?Q?ckhTLl9ovMsoAds6aww5NctvsYxiI8/4vbdVrM9S/Cv82vRt8u6fp9ODaOQM?=
 =?us-ascii?Q?l04bI3fqW0boj1BiQ/PtTaaR1NNJDswxd0ICCDPfKbAoA2cpr/eEKsufvFHN?=
 =?us-ascii?Q?0ibbVYOIAvAyP97opHVo0lAEXbMr4Jdlqn+knHqoXNP8bVzXIjRex06iFATW?=
 =?us-ascii?Q?kpx4n5GdwhK7uwdDO/5yVGC8EHQEGWAUPYyEAKUx312G7lGg8brnzyAbMuLS?=
 =?us-ascii?Q?gHYwxsDzdvA/RE8PRQuvUDBihSfgGIkcBpfs3f66R7tLqODc3mD/kJkUHy4/?=
 =?us-ascii?Q?FuUwHsEEiJaLoyZ2ptfGMTcFGPnH2LxRIvyGSbESOsBZeZU/EGsz3SAB/qR/?=
 =?us-ascii?Q?YcyAGEr4a7uPzbgqKggR/dFa7Q=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2015b5d9-979f-4eed-c4f6-08db5b73ffb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:56:37.2580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TEc+edn1Y1aKtcf/hi4mHJlZpvIH1DNj1XlqUSbgroClWfhl66zpDjnXlDZWxDBzpkFgPZDyngfP1aQTcYmPxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8471
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 22, 2023 at 05:41:19PM -0400, Martin K. Petersen wrote:
>=20
> Niklas,
>=20
> > This series adds support for Command Duration Limits.
>=20
> Applied to 6.5/scsi-staging, thanks!

Thank you Martin!


Damien, Martin,
considering that the libata changes depend on the scsi changes,
and considering that further libata EH cleanups are planned for
6.5 now when the IPR driver is gone, I think that the best move
is to follow the advice of:
https://docs.kernel.org/maintainer/rebasing-and-merging.html#merging-from-s=
ibling-or-upstream-trees

Specifically:
"Merging another subsystem tree to resolve a dependency risks bringing in
other bugs and should almost never be done. If that subsystem tree fails
to be pulled upstream, whatever problems it had will block the merging of
your tree as well.
Preferable alternatives include agreeing with the maintainer to carry both
sets of changes in one of the trees or creating a topic branch dedicated
to the prerequisite commits that can be merged into both trees."



Martin created a topic branch/SHA1 for the CDL series:
18bd7718b5c489b3161b6c2ab4685d57c1e2da3b
in order for him to be able to have a nice merge commit:
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=3D6.=
5/scsi-staging&id=3D8b60e2189fcd8b10b592608256eb97aebfcff147

So, I suggest that, after this has been applied to
6.5/scsi-queue (right now it is only in 6.5/scsi-staging),
that Damien merges the same topic branch/SHA1:
18bd7718b5c489b3161b6c2ab4685d57c1e2da3b
to libata/for-6.5.

Perhaps the fix:
https://lore.kernel.org/linux-scsi/20230523074701.293502-1-dlemoal@kernel.o=
rg/T/#u
could be applied on top of that SHA1, or folded in,
the important thing is that libata merges the exact same SHA1
for the CDL series as scsi-queue.
(Especially since I noticed that Martin did some minor changes to
the ioprio hints patch, namely changed IO to I/O in the comments
describing the macros, so Damien can't just take the patches from
the list as is, as that would create conflicts for Linus when he
merges the two different subsystem trees.)


Kind regards,
Niklas=
