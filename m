Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F612C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3EE61107
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhKKHZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 02:25:34 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:21998 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhKKHZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2021 02:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636615365; x=1668151365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/2UXP/YXTZluUIYjbd44/1hoKfQkFT3fp0HXztQ1umE=;
  b=Rn/y4jwXhiEg98kLJuUtmlAjyWbmvHcpN2TObLxwSaPIPS5VxxOKl5kj
   2SJb4PwPMjepJsH//Y2+CdiVa8LclIOTNJGBQ8qzDzAB3KsvktFpMlii+
   CfuLjSsXKVUTAp78vKlJ0cn+RA+j9zD1XqfLbn3z+QFGSWnRdYSvGVc+x
   ON770S0TIEJvdjqB7wiPu7mUlbIsKh1J2dj0ZGshFN/w0H1fZpVX2EOLP
   uGpdCmpPTSlGOJnhBGm+9BlT5KiusKo/0uE1yNB3c8e85bdF85ff2bhn+
   egEkWL7sgNE5v8wY5ogiaKflvFZHhMSnPsZz2LKPoU3eUpqhF/q/W6Wge
   g==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="297130983"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 15:22:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNo/mWr/tgPVxXUUoO3JaVckTyvVHmml+jOBE0tGzPzF011eciDx8b1+2UCn7GtuWvhgFjBWZP/pegBObsrv06pgwgdA5Ed+7/MqfpyYdStHKRNe4KZTZ02Pf4T2MNonPLxA65rXBTTBU6eKiPd8MvVsAcl31yUE2a/BVQL9I5TqNKwJt3L5LgKgosYRFyfkMTcT3XSlFXSCjNVGzG9ipSy2OT9g+RSGrK1Qhg3sU12xO0ZsQtc3u7tLEA3vpenO9ZiNj242Nh1lzi1TFB3OEtpvnqUDQjlY8d21E4m99xO3xlJHmaVK681CxZNE7di/8B5B4fDhWoR/ZA0tUrbAJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qnNCd6fHK3ijHGSCi2ZbaduYblJf5FKHX/vOJitzwmc=;
 b=kE7OkmIoAEOwoBE0OvbUJNhY+M/saGpR4sU/ZcNwRjvDo/N0YTDU1uHQr/qz6P3M7CZiW91bPGqHuS83RXFlsBUPqruDLBMToX+/CfqibzGgN7Gknj4gH1BDz9NCGY47xHTNCAB5DJhKh5KxJjEVw2djq4AJRLthC/53kXqbV4p947cAZwcBadmJ2UmC8z3DwdwORiTYakghweHVb0JxUi3D1jxKHbmFpJUbV5DINQJ+iZcvWODeXkFhWx6v3e7W846Javw8cFQ312E3gxhgDwCNmDenyv34opV624w9zV1du3D9nuBY8hH92iBfa2eDx8+XhENQe6SmaL8ns25Ptg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnNCd6fHK3ijHGSCi2ZbaduYblJf5FKHX/vOJitzwmc=;
 b=JyE0+c+rgfRR12xYbYTYyE21XwrJ2Zrz+z+kVWKQAwrfNTMAAKM/SVX3GH3Etx/t7VzIFub1Hwvbmt6yMpteYtsTvApBIOCafBK94zkJ9UOERTb7H8r6VnCJz5yd9TcMJr7QYrm4KnCtExdmY285dzm8+hoouRVhbaZ5rMaY6Yc=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1258.namprd04.prod.outlook.com (2603:10b6:4:43::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 11 Nov 2021 07:22:36 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4690.019; Thu, 11 Nov 2021
 07:22:36 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 06/11] scsi: ufs: Rework ufshcd_change_queue_depth()
Thread-Topic: [PATCH 06/11] scsi: ufs: Rework ufshcd_change_queue_depth()
Thread-Index: AQHX1cxHk6Tfq/uH602mXUdAahbEbav97dvQ
Date:   Thu, 11 Nov 2021 07:22:36 +0000
Message-ID: <DM6PR04MB6575DE9B188092CBE7A893DEFC949@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-7-bvanassche@acm.org>
In-Reply-To: <20211110004440.3389311-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4e2d603-1bfb-4c9b-24c2-08d9a4e40925
x-ms-traffictypediagnostic: DM5PR04MB1258:
x-microsoft-antispam-prvs: <DM5PR04MB1258A188C24C0642360981FBFC949@DM5PR04MB1258.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:208;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wKk7ipH++p5i6zWr5Gi7QBAJt75ZEalNfUXiY267fuPREm3dC7Ov2xOzJxd8SBlbxyDQBjagqDZbSWaiZWYE/ERaSaCCn+QibZPrqAM2ykni8hJAdmTZORev6OwmBYNFf5wMBYwAMJ9K6t9M/2OYWGmbF06aVAepcmolm1MioMwzzi5V3qDIaEH4huGZCBHdoyUrrFpTxbzhpe1AbuniOUSwa8x2N+4AcKwNtDiJ9H83RUOIrGzzhu5EqcHtD3cQKr6PY2p4haP2x5so3Vl8IS8XtDFUTdQut1uqUuvBU2lHmTt4u5GxnoIbnmVp42Z42ua95bQ6/U2oLtQlHlEGbHAfY+IVA2cl/dbKqxArRb3peDTgsevyXeTrr/0sWrcZSA17rUaVferQZ9mgFxLFET9haDRb39nwwrRTkxvPea9XO8mWihFG0IQBKcW/Dze58vVojf1z8JoxnkcUeErtqZ6pGp1hZCV3Z76FAwQftkjoOqSEqulOdDYVCbSll0gbS3vfBFnNX3QtxVejFFS9ZOFZHWUlBPwR+5RNivvkRSpN5dxCPs7D71ydDZXpY5iY3pkt2nF+29N0q4akNsguu1OYY1K6NcQ6VVtRyGMZ5K1cYfAgABZHDEG9ijFknpRP/t5yN69glMeWq1HYu6roM5f5CIQUdOkIKCh4xm4Tk/0agMjXBOAmyDfp9xOgDmDMI4e0dD32oWQgvwHpg+fTQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(86362001)(4326008)(7416002)(66946007)(186003)(4744005)(38070700005)(316002)(66446008)(508600001)(54906003)(64756008)(110136005)(9686003)(76116006)(83380400001)(6506007)(52536014)(82960400001)(71200400001)(8676002)(66556008)(66476007)(8936002)(5660300002)(38100700002)(26005)(122000001)(33656002)(2906002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rnr/SqsfPPpEu/oDkuuGFklGceJ9XLAOo2Crd1Cr6gRqi8BMFLTAmtpKUg9d?=
 =?us-ascii?Q?Y364CedI7XlVHa4A5y4BLkfPjg0GefuzztZ0rXJxkms8eZNXnyAuQQvOJo8J?=
 =?us-ascii?Q?mquZwhea4KrtE6nidijnZpRUfxO6hDA0RyTHSOPir2Ii82LjHkT2DoFCqQ2z?=
 =?us-ascii?Q?mxo4pRl6LLE0S1xA0vmerVhk4Pzp7m0TU6EPAle4QplLUz+jfHb8sPtz5oHr?=
 =?us-ascii?Q?cfGhxr5JBqE7Onrz3SGsn6ZMNxsT5Pc9gtRv8iLxa2CDaMZgJMyyQI5c17UV?=
 =?us-ascii?Q?XMZqsdypyGcw5+pzFdsaqNHpvSEd7rz6cZMliWtzkfBdYPb+UD6O/1JuO6qP?=
 =?us-ascii?Q?ZXWkkURBJeKadYOc+xC3SajCr7de/uL7Y5on9YRed1bj6RCYTOGpgxEOXjbK?=
 =?us-ascii?Q?f4AeC1cxnwLNJEY9HxQ4mZ3fh8LcPLr4G/DYvJSFz1KV0gSxQrltrYulY+8j?=
 =?us-ascii?Q?1jsjMk/QYZFZiMpibzyqPfhrBZIk+4FNV8YYkvggE3o63Px6v4p5VrYMPUSb?=
 =?us-ascii?Q?X2+1frndaxdA+ZVNCOiLqWg8FVeDKI9DjHzN94ivfBAEE1JSMoJ0tKTQLsIF?=
 =?us-ascii?Q?DCc3MLjCUskl/owOtMHhZcmi63vAm61uAKL8J21wdTNipqTJX1zocpThbeZq?=
 =?us-ascii?Q?/SxUNGH7TVEVWNoYqr65AEXAAbYJPjGw/aFoBRCsou5eZsneAPGsX1vT1l0m?=
 =?us-ascii?Q?tVVzsj7IDS3AGmGVVHxPZtmbuUD54Tt+SiZJk9hSOZ9RKewo/WucHdfgcY4L?=
 =?us-ascii?Q?FckrnMT49tED6aNwf+9MGWr/X+e03dIeeIV4PabNs5+Bp6KnLHi2ZoMxYSfF?=
 =?us-ascii?Q?qPGMwHaJPkgQhf9wkA61gsvpA67nBo1VOIVjSWZzZvK/AuGZ26/gJfq85s6o?=
 =?us-ascii?Q?ACYC01UPSxBsZ9Avuocai5+m6Xo4ysvSRtz2lNgsiEZHC2MSl7JFWtDGb92B?=
 =?us-ascii?Q?m3MomyLyynFP/i95XuGvORDvFHrYF/Tz6iYeFQoRUbfKLSvYXmkKn0Qb4+5Z?=
 =?us-ascii?Q?1s7u2m53UuGvZU4sATtsNhPkRXBXc9BLXTAGHpLWC0ARfJcSNekROL3hWKDn?=
 =?us-ascii?Q?IHndSCKV2lY2q4dbSC2+8Uo6ZE8gKoiw2zfxmwl6ayIkYYjnwbdEYUcBEgS3?=
 =?us-ascii?Q?+hORjxOfge44+R+rK68ZDMPcl1oGydve8PdrwrWdlKpDPJ1TFqqhNdw9FV2E?=
 =?us-ascii?Q?NNKM2sOVzagNKj/0dGnGOrEEZQNAB5e8Ps+INc0nVHptAOkRrtyuACxSZjuM?=
 =?us-ascii?Q?095sLe7uq/jfxabBuQYyt6nkopQiN3eunCcLBz9l1tvqoFXljbMk2y6kffY/?=
 =?us-ascii?Q?TI4iq86cH0NuLA9e2nMlQ0+4dvk/8AcLOI7AyY3JAUFfvz4uddjVt8h1B5Fe?=
 =?us-ascii?Q?00Hg25Bi2tiyNytDhXGufhft/D6qFRBb6/firQjEcg8D+Q7Uy1+woMNOaLRl?=
 =?us-ascii?Q?HXSkOJzfRJA9WxKF/NP9ET4gtNlFPTKC9xsoRfz9DADBXbEO+e2nkYEbJfz2?=
 =?us-ascii?Q?3d0EQVWcbpiy/XHHucKN3QdJ6msQ5myorUyzJWN2tCGHJZbznPBB6S0IuWAb?=
 =?us-ascii?Q?HFxN9YJkjz+PxW2nATfebohT+x+j3D2c+H9zlX19BBmjcNb3EGXdyjRhPgDv?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e2d603-1bfb-4c9b-24c2-08d9a4e40925
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 07:22:36.0811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XX7BnM7La/aBiRK9De/2he3kH87iv9ddfvRYltkeD7TLF7/EHlUXR8DZR/uRrYAsOJECapCRRIuzNKc/Iklslw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1258
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Prepare for making sdev->host->can_queue less than hba->nutrs. This patch
> does not change any functionality.
ufshcd_set_queue_depth() may also needs similar adjustments?

Thanks,
Avri

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 312e8a5b7733..8400d8e9a6f7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4955,11 +4955,7 @@ static int ufshcd_slave_alloc(struct scsi_device
> *sdev)
>   */
>  static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth=
)  {
> -       struct ufs_hba *hba =3D shost_priv(sdev->host);
> -
> -       if (depth > hba->nutrs)
> -               depth =3D hba->nutrs;
> -       return scsi_change_queue_depth(sdev, depth);
> +       return scsi_change_queue_depth(sdev, min(depth,
> + sdev->host->can_queue));
>  }
>=20
>  static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *=
sdev)
