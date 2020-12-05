Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD7EC433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 08:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 619DB22D6F
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 08:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgLEIO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 03:14:26 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:32775 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbgLEIM3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 03:12:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607155964; x=1638691964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gFc5oZYvAh5wSQP41kBNzBxu3qs7lFBf7h+5BDapJ2M=;
  b=jP5fyaQ2YJ2DuMjGPwfJpwv0+N5NNPP0ppjC9PJH+kUr1wBh85WC/R/e
   yZeDh39tsfyLJ9tYrTt3c9o2WfcEc8Ec5otslJ8uk7N73Xa6gzi+sQHI1
   4D8nB9EII049C+uNdqqMJO6Xq5Tltwp0puJlzlfW9lJHtSOrdkdRZ6DLI
   FahiBcCR0ZCKzLiFt28p8/HnSUqhLJWe81Lsi2qBnXcCMqGqeh3Vk08sR
   LwZOsOdth2iCWBA0M42HRIMbMowYVEjkQVmHKhuZ2IuCBOfcW8qZ/w4sx
   cuELDoEHwkp1qPsTfNS6e574i4Z69D6BPtD86WNw/fz0fmjqZ1MuR54hu
   g==;
IronPort-SDR: 0n/vUQhDyhOAC3rSy5knG33exjKkUSFOKsB6CtkWWATuTeQlndA9V7FSmYebqtrAkl3NaO6iij
 vWttOAHuXupMTK2fJLGavW1O+lkV/baQBAiUMJ0EYEAcszGHY3m08FrMtxXnXV4vPEm4ZO/ZN7
 d5xnk7VlhvFrNaKQ9b+Q5fDn4nubm5eb7kfOoD42oOh58xJW3Tj5HYs+UAt2zD2wr2bQZcU0us
 Ytsd7orpOZZWPnviXk7LaIDcZqVsskVIEwRgu77qST1ifZp0kuMC8EKlaX4n0Iz/JnIoI1cTnO
 6pg=
X-IronPort-AV: E=Sophos;i="5.78,395,1599494400"; 
   d="scan'208";a="158955832"
Received: from mail-sn1nam02lp2057.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.57])
  by ob1.hgst.iphmx.com with ESMTP; 05 Dec 2020 16:11:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KynyzYnKt3kKkyX2svhQhxSqnKl3o7k1VZAEohTx85FiPQNpbPAKrwuJBiTzkxoc9YkgzoAE8OeimfN50vMjd7/fY/aF3P1iKoVXejkfNAPknzUwrDu7NBD2lBT4zSbi69gc+OMcdO1nP4lKIS8fkvbGH7QLQGwq9Y6+x+6SjBc8T5Ji2qXxtesIQhr8HtCwbD4QK8CVb/dpIF7kFx7F1bErpTIADuP+OWrUE6tMk7kzvzU5me2mxbfSCIaFXVoP+ZuhOk4XEwYMj9oJ1v4W4KvFEz226BameA/zHWEHquxf2FScIxwKVLvnzLSwYGK4e8Jv8w8lx3agcRZeWsW7Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaD8ZXAnKZIbm34csWyxO0eghQirkjHU3q8r7YKqEDY=;
 b=LUtgXKdGgAHLIFfeyEp+9PKeLoUSle2xWkNijCJ7d9H9YGf///c3p8EOodquZguH77vw/kgNfC6nCfaPvZ9X7SsaDUxqKjhgtILda4lmx33pF3SZS1XDZXWsmUvf6qzz8CElen2vcjeAO7MyfTGJz+c0kX0zhBpWQxjd0EdRMez655orh/itFKXWa8IGIluuiNRfNr6Kv0+kWs/Z+inEvsilSg1eD5tuN+JXCKBvo/9QdpcF0a3V6lMSnWcXPOgeka04mdzfeBhbokNTR4RcArgLZj6x3B//Q/ED8wN7syne8i6e8Fu5/Lm28q4kE0RzE+PCEjCAeQ1agQcIs5BCPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QaD8ZXAnKZIbm34csWyxO0eghQirkjHU3q8r7YKqEDY=;
 b=rjQ1HGWbrjCAGsTKgnBqhijbWzxY/GO0nM2QFXqMUzOnlCj5jBmWexbqRSakHhLCErwcEH1rnOhMmvqQc50ow3cRpgj86Ew3wa5kwcTYXbmnOSLEKSyjusdl3I6+D6HjdV/5fTB5gbDMyjVrpPpNfOc/QXvL6qbaGipWtHFD/kI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1132.namprd04.prod.outlook.com (2603:10b6:3:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Sat, 5 Dec 2020 08:11:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 08:11:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
Thread-Topic: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
Thread-Index: AQHWycQXp6g3K07ih063gLNOLCVad6noJ+8Q
Date:   Sat, 5 Dec 2020 08:11:32 +0000
Message-ID: <DM6PR04MB6575519252EE03084136683CFCF00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201203223137.1205933-1-arnd@kernel.org>
In-Reply-To: <20201203223137.1205933-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6f148da8-b97a-465d-9b8b-08d898f560b0
x-ms-traffictypediagnostic: DM5PR04MB1132:
x-microsoft-antispam-prvs: <DM5PR04MB11321B148C42D4DC79F520BAFCF00@DM5PR04MB1132.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0vX69iZjiidiaTOU+BP7WLFawmjGBZlo7ZMeP8pFOJbqKdNpFdIpamHbeHbRLH6o3JlbGZzkhniYOyN5eINALEc/gldEnn+i2MCtrWZyEE2AYK8cWK8yx9PTxqqQ1ib21V8msN3//D5N7VHb3awBekKU7pkQEI9z3N3QKLYv2+jLqdhhJ1tq0iNyj3vnH8gfd2ncsNlF2N+Zkjqhiu7FKxeUwx6Pty4JOHPEZpkP4ESJD7AAbRvdOmfXNzh7KkUwOjgQ3XX3HbVu4pL0kARUrj32ioQHfqUae8tWCiP5L5HpmEH/myeojMDFRqfbNL7HAX1ApiLtLbqWP04BIOxnPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(83380400001)(26005)(86362001)(7416002)(478600001)(71200400001)(2906002)(33656002)(76116006)(6506007)(8676002)(55016002)(52536014)(8936002)(5660300002)(9686003)(66946007)(64756008)(66556008)(66476007)(186003)(110136005)(66446008)(7696005)(316002)(4326008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PKHaWZnRR9hrjfNvsjLmvPc2Ov9gHPLoU06XbN7hnGqRVX8d1ZUre9NjejRT?=
 =?us-ascii?Q?jTvebCG6ktLoikf/lQJzpuANP/lF7bMcQswhv1ce0X4pH9X1TDc8/mBYJQN3?=
 =?us-ascii?Q?/sJwFWqmOwBYLHV5XZlLukd9YQTH8y+EJZ9pHmhKfcyRTCil6gzKhOO5aX65?=
 =?us-ascii?Q?706THAeRPjSdV543mLXf4nWs+Kt7YvLeYZ8jS+Vgx9l+m354/QRMi9jogVat?=
 =?us-ascii?Q?2K4xkKMBSylrosOcXf/UaU+iTAXOF5W2w0EatauiQNa9TCnrWxOaU+pm1Tyz?=
 =?us-ascii?Q?iEaeIa/9TUwRcGy6OmOXlckJD2/LQz660+TucoqO4Sz6mkqAdgT/EiDoEkrq?=
 =?us-ascii?Q?QcF/PaVKeB59TNdWj+WB5s3MO5BnFMuHw/RXa2Gf7MbBHy+0sPkz8FLSFo4Q?=
 =?us-ascii?Q?190s+V2Fn1p+mQFohS4wghPt1I4/RvsURkkZCPo0ihxHk1hip7MHrFYhr17k?=
 =?us-ascii?Q?F801IbVS2x8a0nYWpgG0qpZUrBveSZnXLaMqHPeMsOlv2qgMj28wbdZzMqbb?=
 =?us-ascii?Q?R/Ku+8f5MgaequriwGLGc1DZZPcQFe1TKXvojDpw+QBoTwSPFZz/oJqvT56D?=
 =?us-ascii?Q?qHrG0noqsdmvBYklevQepJDulXADxoWrnFE61YUQnH8eLQlCNRe+bgaCNXhJ?=
 =?us-ascii?Q?fPU2TMV9+Xw2IzHeBIWZOltXDNti13KQmvcNGYye1O3vG3DbcwPs6y/q5KCP?=
 =?us-ascii?Q?Fuzu3YyApGZAJeQp6wijZMa7+/FyPzjIGAXsDixcs0wQnp0yj+Fp0zzLfXAZ?=
 =?us-ascii?Q?OdMP8SS44Nfs7yAdyCH9g40VRUfWsn90KQxdLhD8wICeL7DN8gMfyCz185+p?=
 =?us-ascii?Q?JdrR0kmpFyVjmg6BtQ6GqpHx2lDsaRZJ5w5hWdiaRDdNpsr1+mNvQKi0sV9C?=
 =?us-ascii?Q?J9HyXUcoWAw8Vd/Sz2Te4IKtGxMleGJ82WAzEuzzwfiJ9gSqB442SOq3C9FU?=
 =?us-ascii?Q?PlrU0HHj/OB6N/+8M0dfUuvSnHTJuJlTK+iv1f1rzyo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f148da8-b97a-465d-9b8b-08d898f560b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2020 08:11:32.8934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WZ+oNriRy4FtAVEm2YpFZGJGwlzbDSzE0MeQg7JPDr/XV14+PvP/PJtOsVuhyDI7Dtl7oNcBMA0JjDQBu+5+uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> clang complains about a possible code path in which a variable is
> used without an initialization:
>=20
> drivers/scsi/ufs/ufshcd.c:7690:3: error: variable 'sdp' is used uninitial=
ized
> whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~
> include/asm-generic/bug.h:63:36: note: expanded from macro 'BUG_ON'
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (=
0)
>                                    ^~~~~~~~~~~~~~~~~~~
>=20
> Turn the BUG_ON(1) into an unconditional BUG() that makes it clear
> to clang that this code path is never hit.
>=20
> Fixes: 4f3e900b6282 ("scsi: ufs: Clear UAC for FFU and RPMB LUNs")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f165baee937f..b4f7c4263334 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7687,7 +7687,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba
> *hba, u8 wlun)
>         else if (wlun =3D=3D UFS_UPIU_RPMB_WLUN)
>                 sdp =3D hba->sdev_rpmb;
>         else
> -               BUG_ON(1);
> +               BUG();
>         if (sdp) {
>                 ret =3D scsi_device_get(sdp);
>                 if (!ret && !scsi_device_online(sdp)) {
> --
> 2.27.0

