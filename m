Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBFDC2BB40
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 22:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EBCC22510
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 22:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408429AbgLNWPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 17:15:04 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56343 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408195AbgLNWOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 17:14:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607984091; x=1639520091;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M8rmYWvlqAoif/E9u9XywbYVnYpxax6i0jFF0gnEmog=;
  b=BRQrbyRrljY/9hk6Ft9qqtpu0K4A1TNNr7Eywhb0Qv8seEFzMwr7laUv
   rier/wLEacKnHAOVgRiklr0lzRae8txkHRqxGeh+vC5dCM9bqBSBiMyJv
   7CRr1hSqYlBJ6LtyuOfLrcLPeEwbONWZrsh4z+YLAvJ6/U6zedFcQfA89
   ZZQs0Q0pmTfD5b56JVrW6TYFnUTOgX5O8+uj4orhEN1Xqc2lFbVq+gw6d
   MN1EzxlxX/VR8iyovmHuPrJ8arsBsqXV9yge47xCCKxoFgP4HRxjqsFrn
   x5pwnBmpxeM7CIbfHNOklieGOCfIxgkO7Dvg4UGQKCeyCQrq5vLRCcD0w
   g==;
IronPort-SDR: Tp3EbnfyUaI5AOqm+hEfjfybllrEAt6TrRmP1z6XLNwCDSUpEtWwYIMDOhiDpCAan9hzMw+EQw
 hGsox1ka+y+Eed6lFZoeumYTQwdBcGpvCxkmFBa9RA9IOQYF/ncvMwrGqyGwMB+GAf19fDlxPD
 P75SMhQ5isIzwXY+giHBVO07bd/Rthm/oRMYL61gckAeJSxeaGLcNR2bNfspIlvvdfDMym+kcg
 ymxIYm2y6fhKR2ueNVPc5tq8cAFA+lyept7RCX4cyb+wDDzdJCldJXQBTcNO1+qY1JBnu8uv5P
 eT0=
X-IronPort-AV: E=Sophos;i="5.78,420,1599494400"; 
   d="scan'208";a="155169512"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 15 Dec 2020 06:13:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgvOcD0P7X0yNTxD3srUaobgBKZLgOsUfdP6WdD1NrYkZ4hIW9sHtf3GIw9Yv+tgQCmhexhlD3EVeSXJCx7EGjXtVRUFLpBIOrc22B4V3BywYtV+YGDsPsJecZ6EuATHTVTFb+rtzcetpk4cdTPWDxNGxB04Er9xX/QNfFU6rQT+8JsHTf4lCqYrt1EtzsBu/R7uwMs5vio37bEURXqjnmVINHguNKk7kZ2u0dbgKjZzVp1qMiPfg1r13LDfNlBS6VU1Zuc3JpzGRUG2sZCBZfWs6G6jjWNPxbW4npOkeo5ORV9CGMfaPSnrC6rwSPmhCSNkbgF30NaoDyohOE1v9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tw0F6r/OVnJ7BrcaOIOi7NuZq+SFQOmJ+ugtycf3b/4=;
 b=UAggpyxDwHAtz+rwDEzZACJlSf7VDYwW2cSeItSk8FFHX4Mp7FMiPMmigdCZrSv97UG16WKSrlH1iUddG28VHox2A8FMnfs2HklJpJ+E88N8G7TFchxhwanMjk0We0oe7u5tvzxd39qwVq6KOiTzNy4qAU+iBQlU31/GRV/UIZ9Z6SFcwwbrZsVWDmp7Wt5HM3UenqiXIef98qwsSjLU/FCyiRbwdo5TdPJE4CCGozuFPHX2JSTcdOSdh1fyfsaUDAFfHclhS/8Rk+RW8GACcjqNPY53NuF4M1FVwWEztuX3TNJDaYtn2mYd2kQz4XEL8bb1UCwYCO8qZiVoS3CqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tw0F6r/OVnJ7BrcaOIOi7NuZq+SFQOmJ+ugtycf3b/4=;
 b=fUZUshKjf+Oij4thv/fS0Ok/unaJhezMGWI7tvPKvNxROM4hZyz/bJm91+QbFH8oaV9eO4uSLe0wrFvjshvauasiRGuDq40HUUB6lwMkh6CrgEYCKdGFidc21lI3GWlo6iaNYymZFKBxxJrySfPUlC8XsGWrw1fQSef/9GPCraY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4426.namprd04.prod.outlook.com (2603:10b6:5:a2::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.25; Mon, 14 Dec 2020 22:13:39 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 22:13:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "joe@perches.com" <joe@perches.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 0/6] Several changes for the UPIU trace
Thread-Topic: [PATCH v3 0/6] Several changes for the UPIU trace
Thread-Index: AQHW0laTiGmP3/RbQ06ZncSGQQv6/an3JGug
Date:   Mon, 14 Dec 2020 22:13:39 +0000
Message-ID: <DM6PR04MB657559FA01C44B411BBDBDBCFCC70@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201214202014.13835-1-huobean@gmail.com>
In-Reply-To: <20201214202014.13835-1-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6d5c03e7-3185-4a17-61d2-08d8a07d8296
x-ms-traffictypediagnostic: DM6PR04MB4426:
x-microsoft-antispam-prvs: <DM6PR04MB442699A9420B4E5ECBC11CEDFCC70@DM6PR04MB4426.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K2cV2cuq84oSgBhoeGF8pqAGya+4a8HY0Kwema0jSFglkOblPv5pYOi5dXs5T/+rom0kWTHK4Z+Q9jBAKUZ5q3bK6efZWs3hpwtRK2nSGNmm8OFGZ8mQNhyrC22C6lD75s3pMk+v09k1F+hUZwl9xlMUS3+goZq/jnt3eU0P7if9Ho8aC2GGjKRNwUy/kOqcFIBAqUQXJD7+b8kmI4tZ5gBRAojOjf+WN2Pw3WsCx0ZwrcLezevoWQxaRa32yVvATbIlogsOlPFDKDmxmf8sDegnE0VORjd2eTsq+qY2zQtXsh9Z2tHdK7hW1K0nXQuou0943dl2Dj/drplirBy2NL9ZDx5AjzJk2KwOR3DQVlRy3DruR/9jZyX9lI+bvlQ2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(8676002)(4326008)(186003)(5660300002)(2906002)(54906003)(33656002)(86362001)(110136005)(508600001)(66556008)(66476007)(66446008)(66946007)(7696005)(52536014)(6506007)(7416002)(8936002)(921005)(64756008)(53546011)(76116006)(26005)(83380400001)(9686003)(71200400001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0maaOja3RdVA7cTZ1Q419poNyceZiWuyyiC3QKru+x48Qg+YcwCc4Is28kh6?=
 =?us-ascii?Q?Lna6RGyaF1KqROD5aAGvdNJFvZPjsi2JprpmjiSl94SeW4KVFkJ+5l7oE9QJ?=
 =?us-ascii?Q?z9JH8wEtKfG9oWJIZ95SKZcF7/YKritTKB/+3MjzQeeUOCE+aJofTQNZsdzo?=
 =?us-ascii?Q?DvQafq4fAEwdupMIumBBzpOm/Kx6WH6DXuZ9fkXUAxOEHethvR9woTzPhB5X?=
 =?us-ascii?Q?AiNsFWCh3LO5Q8cWo3rxlquFNDagfuUHgaNCrJLGOUSi8Tagufs9J3X1Ghi8?=
 =?us-ascii?Q?zZvwpOZYQEAb7QfGirQjrgCqU7V1KEUzYksCr0Fof/guMEgaNGoCaoFk7D0J?=
 =?us-ascii?Q?8AuQNz5jczZEuypBUJ1Kaw+hMKBgq/XaEsf6vibWZ//NUgxLMkLzaSDe4+I1?=
 =?us-ascii?Q?1+LH9ogPkHeDGLz6Cy3O30f5pJmR2q7Qza0HJtRLTJ8s1Gn/rt797H3hO1hG?=
 =?us-ascii?Q?jaWCs2e6A8cA+DSvqHWLphQqRScht1ToJiODZCXn+cEkSkGIgrAEq77Hq4XJ?=
 =?us-ascii?Q?jF6UCzSSXS2vfgYUnloiljOMx4apPlk3rZ6mEfWWhnYTweRtN1ZXkkRaSIc2?=
 =?us-ascii?Q?hN2V8DvDn9LCHQp3iHc+otyAMhR/32fm6HtiqyuNDHSZf21u5443DoZG6ogj?=
 =?us-ascii?Q?MAfKakYj5EJnfL5EFzs+AUVMm1BWLuypbwyTiTGSrznLxb/8PZ1a1uYt35wv?=
 =?us-ascii?Q?TrbLOHuOkrEPYeZVwP3J4GshXJ511kAx90o2hj9ScLK3e06XdRXkoLds154v?=
 =?us-ascii?Q?2tEFScgUZQDyM6dP2SrK1N6EEpH4V/9e8j0HXHs4Hd5Ks4lc7qYTZrhLbMy9?=
 =?us-ascii?Q?9dgMG6/Nb1x56lUo9GkOd7Zb/g7TlE2U8hxrLLwnm3+F2qmuyDjTo0OZfpyP?=
 =?us-ascii?Q?WU0cSS+ZbfMRiS4wczXhiYs3x4Eu2BGVL2iFZfL4/k2LujYqMaeVIyZV8Ph0?=
 =?us-ascii?Q?Kk7jQncIbkcVEnW23v7x5H/X7ddLPJdM7IIn0dAJgMo=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5c03e7-3185-4a17-61d2-08d8a07d8296
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2020 22:13:39.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6gqvgJ7bxDMf8eA5tUGslxOY8IkorJoIKB405pbABvBYAjMnhC677V7MUY8WfyCiXQwZ6dH3Gym7b5qw8EJhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4426
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bean Hi,
I support this series.
I think it is a good idea to print the response on complete,
But you need to change the prefix strings, otherwise you are breaking the c=
urrent parsers.

Say that you have a trace log, generated sometime during 2020 using the cur=
rent upiu trace.
It would look something like:
"send" <request upiu>
"complete" <request upiu>

And another log generated sometime during 2021 after your change is merged:
"send" <request upiu>
"complete" < ****response upiu ****>

The current parser won't be able to differentiate between those logs.
Just change the prefix strings to be "send_req" and "complete_rsp", or some=
thing,
so the parsing tools that support the new format will be able to differenti=
ate it from the old one.
 =20
Also, once the parser can differentiate the new format from the old,
whatever follows its fine: cdb / osf / tsf or whatever makes sense to you.

Thanks,
Avri
=20

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: Monday, December 14, 2020 10:20 PM
> To: alim.akhtar@samsung.com; Avri Altman <Avri.Altman@wdc.com>;
> asutoshd@codeaurora.org; jejb@linux.ibm.com;
> martin.petersen@oracle.com; stanley.chu@mediatek.com;
> beanhuo@micron.com; bvanassche@acm.org; tomas.winkler@intel.com;
> cang@codeaurora.org; rostedt@goodmis.org; joe@perches.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v3 0/6] Several changes for the UPIU trace
>=20
> CAUTION: This email originated from outside of Western Digital. Do not cl=
ick
> on links or open attachments unless you recognize the sender and know tha=
t
> the content is safe.
>=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Changelog:
>=20
> V2--V3:
>   1. Fix a typo in patch 1/6 (Reported-by: Joe Perches <joe@perches.com>)
>=20
> V1--V2:
>   1. Convert __get_str(str) to __print_symbolic()
>   2. Add new patches 1/6, 2/6,3/6
>   3. Use __print_symbolic() in patch 6/6
>=20
> Bean Huo (6):
>   scsi: ufs: Remove stringize operator '#' restriction
>   scsi: ufs: Use __print_symbolic() for UFS trace string print
>   scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is
>     disabled
>   scsi: ufs: Distinguish between query REQ and query RSP in query trace
>   scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM
>     UPIU trace
>   scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
>=20
>  drivers/scsi/ufs/ufs.h     |  17 ++++++
>  drivers/scsi/ufs/ufshcd.c  |  72 ++++++++++++++++---------
>  include/trace/events/ufs.h | 108 +++++++++++++++++++++++--------------
>  3 files changed, 131 insertions(+), 66 deletions(-)
>=20
> --
> 2.17.1

