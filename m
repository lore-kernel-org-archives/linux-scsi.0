Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB58C4338F
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Jul 2021 12:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF75960F35
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Jul 2021 12:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhGYMAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Jul 2021 08:00:10 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:16723 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhGYMAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jul 2021 08:00:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627216841; x=1658752841;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g8PqeHkXh0kh4txCrrg51sHstFx6jMade3wXGDIja/w=;
  b=pysiV0//+8YV9BF8mbMXup/ouDG36if+/lKS4bR42ULYb7z5ab2gtrZ5
   VdXHfVjbsmFw/ncX1VUwzjEo5/ItYO7zxJdyP58YNRYx1w2sVl6nq+/KC
   7X6DXXSGbAPgXweF/UN129+Cw8j9ifxyDaxWMLakcGLGg1ywA1lvCUA95
   Tc8fuuBywC8Q5ucowPr3CxlA/62K5ZKJEjhrzUAKh6/iIaK2tcKKXOh1t
   /RVfB5pBvS493XmxMncqpauGY5BFYJYLnu8sZOZpJHCDPhWkP4GNshiOy
   CqY1xlF5FlSO5LG1m1yQb+l1D31jVgm4Vpyl7tnmyxgBTQq9zlOSdlV6i
   w==;
X-IronPort-AV: E=Sophos;i="5.84,266,1620662400"; 
   d="scan'208";a="176011889"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2021 20:40:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5fVn1p5by8gWNGOXSMFRuubCrBypwn0I8lBEOs+UiVfMmFQIW81cbrcLqnjF7/V8i2CCfEyQsMVqLPfCzR8AIJwD2RPvBF+mdUZappeX2mQm5yCISaEViEQ+XVEBwAfYNWgNpqPjl6OTx+cjAZ4GoV8CYr12Oblanqwju+FhlBLwvIqmInSPFMKCIHo3Nge7GYQVURz4KRONaXrlyHIEENCnnqr3Uix/+tzEPP/Re6nyT3qFar2LCxrIlfCswCaHNEgokBpQZejXwzx2jfPgwoh3dRmvXcBpBueBX89e6bowv18b7G+cfGEzvRkuwGY6vOhS+o2+tNSOA7bBwvY4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWygvP3nA9RAFFsUyWr0wOnW1ydrjFTJgRK2SRxD2l0=;
 b=D0ldZ4/yOE3KYKrEdBciEpqvmz5fhh09EAPJG9YjJEw3PURASC+AjBUSJcrlzpNJ4XzfhKMpUJ14GPps8Ydfk79TDFG0OnVhLMmAYKj1KSUaKOaflU8F9O1WHm9C1Cd+oLIeYTypoa9L5YO6mjkbvoDJFlmAiyigF62IZt06lCRXN88ZUNmYs70K2k9s5FAb6pBi5/xe5ulTrBnl3PyULpRYvcYGx8l94rQNt8WRcdTHfZQzh5XQP240A1c4uzDxu7ACkUZ0wOnxDBNTohrsRUMwWfPjNaJ85xC7dBkn0gdL8fgxRpXlXBkrTKX8Dz/e2hkTyHAOTGZXgTp1jHKkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWygvP3nA9RAFFsUyWr0wOnW1ydrjFTJgRK2SRxD2l0=;
 b=qNPIcOaXzdko9meHckbw07W8k1O2DIPhKvYIuqZEYDXi+Dcim8WaYORMNoNho03n7jZ/TDAFcc1ywPDAA5AGyC274xbnvFtS1askoHae9+o3E0MmZQIc2eKQ/o1MM62ZNexhfWRJT+3h2jM5crZhVLMiz7t9RBhOt3RvJCqnWwo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5019.namprd04.prod.outlook.com (2603:10b6:5:11::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.29; Sun, 25 Jul 2021 12:40:35 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4352.031; Sun, 25 Jul 2021
 12:40:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH v3 01/18] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
Thread-Topic: [PATCH v3 01/18] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
Thread-Index: AQHXfqqLiK9Pr9p6n0q0qB1K4QofmatTpgPg
Date:   Sun, 25 Jul 2021 12:40:34 +0000
Message-ID: <DM6PR04MB657567852F54BBC6BAEF288DFCE79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210722033439.26550-1-bvanassche@acm.org>
 <20210722033439.26550-2-bvanassche@acm.org>
In-Reply-To: <20210722033439.26550-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0dbe8c86-421d-4300-a0ac-08d94f696620
x-ms-traffictypediagnostic: DM6PR04MB5019:
x-microsoft-antispam-prvs: <DM6PR04MB501974C1166A36821A24598FFCE79@DM6PR04MB5019.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXX6j5boyrv14BYkav/hLHq8jXlc8XRgXLky/sLUe5icNhjBT5JGVwUWL5mOaESSFUNW3PqQSS9BhBJWYNC2L0aph8aQdwS/Idb/0WDe9UJvTkDDQ38eK7BdPfmKtQidS1oNnNOqznLQIzXbhoIpPLqtZmNtc0f49gkIhBy3Ov+pmMfV1QJtczAdB+DEIBl2w2q1QCj8h0CFXZPdHjopHdWv7lMWQARIOzS49JJNslbi479okp2nE2Bx2T+G2C3+f82dGu6khQOPmxDQ+qdjcPL06Aw0Jv2w7Cvtx90Spdz/NWoGOgw2izAE4NQYv7tWKAuXJ07vIgnYVw+Ym3m/+tAXM0nHyJgvmy1uw+ikdUvcS0n8Bb72ySF+z+ury9Uv9m0o0fHaunbzGNuBlIw9VxBA6oBe/PGU3wgnu6SHwbfa4mOL4HQyXNs5BMj9VRXUwhmV/LoT0FrkUV1mMUt58rozgxW8ll2DBb5UzCqSVsjHpqp6vdXavy+e4YWSEpVmQxhB1pm5w+MdZMsbgY6HGMOEF5Yns5BmuXiqYddYzFtnAP2496NgPhvJglRafCMd1qmKdB27UBmyd/Q+ckr50nIPS057x8NT5WgqjCPLa8SyB/EGIbU4vhJren8s0E+f063IV+D0dsM1lP/A/wAD5RrCxZuHHrJnXjyKknMN4WuOLZ8SPaLO7hj8DneO8RlEmEG2qSu+itL7y9Hzh29hsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(64756008)(66946007)(33656002)(66476007)(66556008)(38100700002)(4326008)(54906003)(76116006)(122000001)(8936002)(110136005)(186003)(86362001)(83380400001)(5660300002)(66446008)(26005)(316002)(2906002)(71200400001)(8676002)(6506007)(478600001)(9686003)(7696005)(55016002)(52536014)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KrXYFo2xZzIDbA3HI5AJt0u+fkGaTLPtb4V8OY+nhRFnZsIIpjlHykRWuJkC?=
 =?us-ascii?Q?sZ1bVWSQvaGQGx+NUMPTIbyl8pIo2WIlIBL1ScQWyBFr9HsRyg4YpbF8T2DE?=
 =?us-ascii?Q?7JnlXIlCpD1lVsAuMluhTXASM21hyF7+MDsVtnpn+x8b1M0Mlq8soQMYS0Br?=
 =?us-ascii?Q?Krxmbcx/V4pybpFIFyyoj4dzoCiBfNFq/pGcBd+iW53QrRs5kkXIu4q3oOW8?=
 =?us-ascii?Q?Gl4JSvOWaiBInE17qScExIaEjryPZ24bBbpih73Zk3TvPaBi0gW9b3cdPDVG?=
 =?us-ascii?Q?5H+UFdQgoQWb1FBPEasWaBuJ5UG7JTPIDoTASr8fmdcBw7bLua4XPKoyXVvY?=
 =?us-ascii?Q?cGdPOIDXYDdYSCzLCIATH3+wRJ6E96jgiPt8E/KoGQbhDNYjUThhM6JKw1yl?=
 =?us-ascii?Q?N71F5I6+Ou+en7vfhKw2JjDe68EF9n4vDeEXmIhF98gIQJGWMmtocEJcLO5w?=
 =?us-ascii?Q?P1q8Om6txcKpEiq3V07lNSCem/ajqbip3y95hnSTOnM7XvcHuKMccIWak+aY?=
 =?us-ascii?Q?sfQaYNllnR7IsZmQW/rufcLglnHBwJVWueb7ot5XyoNf+KfDeN1MF9QoRWtQ?=
 =?us-ascii?Q?RPjKmE4SR4prSmaZ+zz0e2SWiiyNSx4dles2kVexvA7Ngo8QNYYQAR1FtDCC?=
 =?us-ascii?Q?4qGzgduwduiYgw4FT9Rif2rAQqh3NZbJGc+sL5WeskfrJlmOeu9A+rPz/VoR?=
 =?us-ascii?Q?x2KpxQPiKZ422pD/ezHqNyM5+tisAo9YnnKoTxq3ZQdfIWCQjEAetZ3DmICh?=
 =?us-ascii?Q?1BM5uLS/StNwNnIQRzWXg2RpKCk/BvRH9nLsintB9C6M7Lq+ddgjbexbpA3m?=
 =?us-ascii?Q?mUexTtnUQEiOwhH40p9oUeAy0poIeRmISt8GuleGs2rlIHFl4xcQA/zeRlJ6?=
 =?us-ascii?Q?lptYFP1mCCi/rM9eeEntsmgDfxJYTSdvZrRHJpO/dD/cEY73biClQ6ckitm9?=
 =?us-ascii?Q?YoQpN+Uux9JkLt0l4AChGzzSwYWUP/sNkZLRTtz+jLIDsp19RYBhJPovHoAD?=
 =?us-ascii?Q?ZD7QjrzrAEsFeVPyXtdzmOvhBigccx95rBvwL3MlOHi6r6OaWB09Y+Z8VyZz?=
 =?us-ascii?Q?MUE/5kO+MtyQcz+WrDJAlwaMUWguWfvaN113s9F8WpbMshGrya2wNkYilV/o?=
 =?us-ascii?Q?0FA1RFtXseqyaxkz+zOEUn+IPZqqGMopJkajP39Dw0qftSgtRzYmiGapaQ5E?=
 =?us-ascii?Q?XsB8YQ2IYCtEbZM1/3cLb+eXnzdXZ+mHIqTVpxVs6grzvFe+Rk0sNZmICdAn?=
 =?us-ascii?Q?DBX3JFwyj6UN9cR5DddJhfDKA99zjd/HQrQhVho1nAwynIZ3/WMO0Q+19nKC?=
 =?us-ascii?Q?RFg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbe8c86-421d-4300-a0ac-08d94f696620
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2021 12:40:34.7883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JcIZJFRk7kQZnLexhsucsxb3x+zQwYzcy2mnIZT7jdLxWlyRd5zI41KpkIzzhwMkirbm8CHrvSu1ERFcIRrKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> If param_offset > buff_len then the memcpy() statement in
> ufshcd_read_desc_param() corrupts memory since it copies
> 256 + buff_len - param_offset bytes into a buffer with size buff_len.
> Since param_offset < 256 this results in writing past the bound of the ou=
tput
> buffer.
>=20
> Fixes: cbe193f6f093 ("scsi: ufs: Fix potential NULL pointer access during
> memcpy")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

Your fix is fine IMO.
However, the root cause of this weird bug is that rpmb has its own unit des=
criptor,
But ufshcd_map_desc_id_to_length doesn't accept index as argument, and retu=
rned 0x2d instead of 0x23, as it should.

Thanks,
Avri
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 064a44e628d6..6c251afe65f9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3418,9 +3418,11 @@ int ufshcd_read_desc_param(struct ufs_hba
> *hba,
>=20
>         if (is_kmalloc) {
>                 /* Make sure we don't copy more data than available */
> -               if (param_offset + param_size > buff_len)
> -                       param_size =3D buff_len - param_offset;
> -               memcpy(param_read_buf, &desc_buf[param_offset], param_siz=
e);
> +               if (param_offset >=3D buff_len)
> +                       ret =3D -EINVAL;
> +               else
> +                       memcpy(param_read_buf, &desc_buf[param_offset],
> +                              min_t(u32, param_size, buff_len -
> + param_offset));
>         }
>  out:
>         if (is_kmalloc)
