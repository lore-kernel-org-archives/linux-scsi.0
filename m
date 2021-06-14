Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D25C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 06:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2162861370
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 06:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhFNGuj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 02:50:39 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:59710 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbhFNGui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 02:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623653317; x=1655189317;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pLxPSOafFzxiS/H0VSQwDDtAgHYoM0AmYeC16jHzJH4=;
  b=CETiM3+xPa3QDy0DhtGdTZ7UIduuLkYLeEllPHlLrSFbMEI0/lEqwzQq
   gNGVyLLKgBb9BCzNTfKlTbcrdZ2OnqlF+r6dbyhY6aNDRABc99nEMD/9k
   OfuVzu9TGW/GE3ocp5OXcl2w9+UksBPvok6AcbrQ6/NbxYNHWBfQCor3K
   Zsv4p9ZuZGu0kvZMJsYHkT8W53zAc52fgWZs88SBeQM4BO/WRYHY1bdl7
   +8PdZdt4wclK0CK7vQsjacDJz4QfS9X0ffb+M4wGAuV7hNorNfO/UorZF
   zLN1aP2Vkn5fNCQmCQ2YwNLulKT2r1RvutmQu8qTlCng3807akXwXlMxY
   w==;
IronPort-SDR: Ce68C9UPtIZM42SCqaev6zJ4Y5ePtZISLG8BsQIe5kNfnjMye6osSs7JLMbD8hrDjxUHywDJ3M
 sAdfjTFmnwBFBxGLdSVsRSKhr1xPKgZymKHCFPTSIwuQIeov9b1xBj3LugSBuwKfcYpX/fxhMC
 7CaEo1FolqyzHnXyEbV3WdpUAGZ4IK9nS+d5aG6VB7NMOPZ/XCvt3ULiK/3XSoKFKj7x/qP31/
 St5AXZVX0bimM0MEN+HWQ3T9zzQZpUEtwW1XAeb5Jzmx8S1Oq+wuBDsTHGXkcchakJu0grtGiH
 Ew8=
X-IronPort-AV: E=Sophos;i="5.83,272,1616428800"; 
   d="scan'208";a="172358049"
Received: from mail-bn8nam11lp2173.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.173])
  by ob1.hgst.iphmx.com with ESMTP; 14 Jun 2021 14:48:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEUmkMmTQvKH+unt9J3fGJ71CvnuZxk7Pj8KYBL4Tk2GPcfstdtpnsl0meOUB2gCrxErBVAYMOhqCEnAShAZkUg0vdVYL9eBaFWwe8cJUVruFpJy4VvgkWHK42dIgq+8WDZv5HXBefeTVkaxgGqQlaCvNxqgl5xyDzMm3UkiN5Ntt6iUADoExygxeE8pgkenMjHnU5jGopnlLP9E8pSkcle8OXohM74Tnu8VMKYWYnyZVBW2gEUfwt8YiOSLm1VHwIztPB9ckIS6DJEG51drf3geKPTwk89YuLp8pOqLA4YrBfUIhRg2k5nj/sFU2m47Aj2KKqlFm81URaDe9JHKRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=se7SoikWaEr8uR0BTlj4hAybLXCAkptleAZCSMAP6ao=;
 b=UfuDmhs9zH8s8VmS7MQa3aLRuXuJHpFAoZ6kA5MXpJx9jQGJkQzzZOjg81dqbhnzZeITDu/pOoiWSSQImf1F4g+P7dvnhad1WJzIkG4T08PzvGzh6Sw913UCEEKX6eajyukOmHLZ78fnK+3LGbrJNEwALkuuJ67u4d6U8RjdZP1UkSVfj+TekMImsrExn+hSJhf53ceGUhsm3plN15zbfjaH1uLYV5gKk8bCdxVX+dMgwrPPYESUTURyTgkoMVEhlgmmm+2DwuEXnuprFkg5BuVJA0H8fZGJOLu8nWhmE2Z65hzK4Xfjos2lo0fpcdq2O3TKRLZ4gRV9hCIcDBguLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=se7SoikWaEr8uR0BTlj4hAybLXCAkptleAZCSMAP6ao=;
 b=Nuhp8lLhYLyw72qYGpg1PFD5ZHIEUAoJ3HKxRSCm8B1FM2Eb8sGRMJLkfKvW6VRB8QY6Oejmds/UF3JHLIY9B3QCri6Izp5cqujQUKChiF86i4G+PXMNs75Rndv2iZdJfEEyqlEaJPVBptMpn2VhGI2CmO5WSVk7ojDZ9CApgb0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.22; Mon, 14 Jun 2021 06:48:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::78af:772c:a69a:95a0%9]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 06:48:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "yohan.joung@sk.com" <yohan.joung@sk.com>
CC:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "d_hyun.kwon@samsung.com" <d_hyun.kwon@samsung.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "j-young.choi@samsung.com" <j-young.choi@samsung.com>,
        "jaemyung.lee@samsung.com" <jaemyung.lee@samsung.com>,
        "jaeyoung21.choi@sk.com" <jaeyoung21.choi@sk.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "jh.i.park@samsung.com" <jh.i.park@samsung.com>,
        "jieon.seol@samsung.com" <jieon.seol@samsung.com>,
        "keosung.park@samsung.com" <keosung.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "sungjun07.park@samsung.com" <sungjun07.park@samsung.com>
Subject: RE: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached sub-region
Thread-Topic: [PATCH v37 3/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Thread-Index: Addgq8fAZ5jjWmnhQIC9oaNz2KTkmwAPPcJg
Date:   Mon, 14 Jun 2021 06:48:31 +0000
Message-ID: <DM6PR04MB65752F72F99EFF4BD41A4B0EFC319@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <d38fbfa83d1f421c8a0d201a3cb6dce3@sk.com>
In-Reply-To: <d38fbfa83d1f421c8a0d201a3cb6dce3@sk.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: sk.com; dkim=none (message not signed)
 header.d=none;sk.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24715649-cbf6-4557-b2cf-08d92f006c75
x-ms-traffictypediagnostic: DM6PR04MB4154:
x-microsoft-antispam-prvs: <DM6PR04MB41545D37E0A6501B22F09826FC319@DM6PR04MB4154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kecqkJcYc9H7LATJRp5CKbjOAK5kzkuvvOoUUlDzFmNq/7rlA9Tt5ks8xXrbbuF0Yw9hj8Acg64/a6pzPWP7og6Wqk5ukKVf7qXm78Z49XAbO0sZ9VaQwU7FkqJjILJ4oejjfz2TduoddV4JpFa7VSTXJHc5xEFWKxq1nF9ROlhyR93ga/aBUsXk9T6/FuUNjk4VYJw46uAW6ZKq/kWKQ9oRPpbvp4eUnFGON4xnH5bzfobw4gO10weakKBAzxQ9tTFS5d42XCi8crrG9fKJOP5kp2Fc9Kq+jzYpRMFcJt2j2/l/1RiIv4Ubj4gNCMd0qDjCUlzYJPGWXFrj2Ik7MsX34dx3TenaGJ2haQKpioUUbRQ8MjkS/mM7X6rg3seP+1ebf62FNBJ9iJ7GnRN9ZSgnQ+pWXMUdTUWNjSCm7rSkcDEL75UALvdK5/RfV9fpysolk37NVGO/kHgzcPA77GJO+/2fWv1n7RZ70HUj+UG2PXgJ4uS1vmp507gI+21qs10I/3Ee7BNrMy15rDTHgYhocNeG/wVjEMUl6hUTovwnR7sTsWSovF6nxYAqDBHUKe8KR9RmEv5/wHSYyRnRZFizvkOKPz5W2PafVu690ho=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(8936002)(52536014)(6916009)(316002)(7416002)(2906002)(8676002)(54906003)(5660300002)(33656002)(7696005)(26005)(122000001)(66476007)(66556008)(66946007)(76116006)(9686003)(478600001)(55016002)(71200400001)(6506007)(186003)(86362001)(64756008)(38100700002)(4326008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7HoyNuCF0kCkg5n+JpcOYNt7sw51z4Y/U+Jxw4XRjeQuhobtZVu0hrKOZP2g?=
 =?us-ascii?Q?ycpwnH/NOFx0r/YoK7ZkLBC3xjd9ABXiIksp3U+8fsePHllpq3d0uzFzMm8A?=
 =?us-ascii?Q?4IpgYFco5Lqm18n9s7TSQdWtNH6y4LJRo3EFYlmt/O+P97I936f+yqqvH96k?=
 =?us-ascii?Q?yC4VH3jLyoTH/YirpSQXsVmJI9vAurqZGlosXN4jDEfUwmT37EWUJifX8KOS?=
 =?us-ascii?Q?6owIZNA6utvxwS1vLycouvwU/gLRnV1rzSzL9czQoc4N2AGTMCkA18NtwIER?=
 =?us-ascii?Q?ZFIMibM0aV9lSbJA7s+5Wxha9NdR/rzJiGdf0F5uUOPUnxgy0QJI5ultSmE4?=
 =?us-ascii?Q?FOHP0plCcU+NXN8eYgEncxW0BZuhqXLS57fm5jDojdnl5Ww0J/OekCi4lvT9?=
 =?us-ascii?Q?dJudEitv9H5pAuv0/YbVlnd1QXsTDLrUMjUlvu3fWowLjY6CRPO+iKZDn2cN?=
 =?us-ascii?Q?+bnfaljcTnPRFkj9+NZQ3hWWpoXBVBXPK1vWqDvRwkjrPUPyoK15tHzaomXh?=
 =?us-ascii?Q?r3Azt79iFnBF/v58cy/dG8K+YTtKi21cnWarrdP5rknDQRu3zYiwo59mwQDU?=
 =?us-ascii?Q?ssXzDQfOu9Ig7/q/ovSNdxWUom6h3lEsGEwTMgz9fyXE1ycaLyQEK1QvCehC?=
 =?us-ascii?Q?BdliwS4abJWnX1N98M2jxbvyPmk9OEUgYIBdnlQDmPEoh6hzEFUgqFUCFRdW?=
 =?us-ascii?Q?DDmIoN30r8TrUW2FkX0SFUMDT9I0csgEqsudpDa67zl0Uct1blCJrkMwdGmV?=
 =?us-ascii?Q?Ysq4LGDcupYtTDTkgpyoC9TlZEqfXtoSl38brgCtCpzseV45jgwj1vid4nn6?=
 =?us-ascii?Q?O613sZ7Z/89u0uPwOSubT8rslq+huEoYHuY2Tfks9MBJ7meGu66y+XwjXh/Y?=
 =?us-ascii?Q?gabLd9UynUAIDOeiquYQFqz4+t8QJ7yy4/+zhG9fyVQ3zwhdOivoQPlzi/Jn?=
 =?us-ascii?Q?CmKq/KYbCpDmmzEnTX9wutsPbVi9pqzwv4ySQn7dyd5hSf/2Mcx7+mGgwrb9?=
 =?us-ascii?Q?POkEegvoi6UyPCu46kSi+eLdkb3sNkTLlz1ErXV91XsQ72aKKw7d1d751UvV?=
 =?us-ascii?Q?ssVaqrWWJyefwJP9eCAL/rPB9LTfvqMF0FI4nzkb+TmFxEEQcA5O9NVJeIPQ?=
 =?us-ascii?Q?izuRxuhi5zhI5m7uEx1VAq4VjrWn6XVP0jbL/4ZY2PDSU7fO6gD+Bzszcq1v?=
 =?us-ascii?Q?QhGlnFNw+ot1uBxvVa7X8+ExnQOvWGV+mO39s5Xu1qt6DtsR0gwV7x9PNvkg?=
 =?us-ascii?Q?VKTpUrUT8R3aGKBHC4OeWr3x5iia0GH1kQN0RJM/J6QaV/8m4Hdon0hVa5pC?=
 =?us-ascii?Q?ptU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24715649-cbf6-4557-b2cf-08d92f006c75
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2021 06:48:31.4539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z5v2CtjY1L22+tzawKe5RsNTChSCbzgzdIzzuFyev4vx0utl53brKe74UfDIGog0wJV64AbooTtsApWq/Y5bKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > >+      /*
> > > >+       * If the region state is active, mctx must be allocated.
> > > >+       * In this case, check whether the region is evicted or
> > > >+       * mctx allcation fail.
> > > >+       */
> > > >+      if (unlikely(!srgn->mctx)) {
> > > >+              dev_err(&hpb->sdev_ufs_lu->sdev_dev,
> > > >+                      "no mctx in region %d subregion %d.\n",
> > > >+                      srgn->rgn_idx, srgn->srgn_idx);
> > > >+              return true;
> > > >+      }
> > > >+
> > > >+      if ((srgn_offset + cnt) > bitmap_len)
> > > >+              bit_len =3D bitmap_len - srgn_offset;
> > > >+      else
> > > >+              bit_len =3D cnt;
> > > >+
> > > >+      if (find_next_bit(srgn->mctx->ppn_dirty, bitmap_len,
> > > >+                        srgn_offset) < bit_len + srgn_offset)
> > > >+              return true;
> > > >+
> > >
> > > It seems unnecessary to search through bitmap_len
> > > How about searching by transfer size?
> > >
> > > if (find_next_bit(srgn->mctx->ppn_dirty,
> > >               bit_len + srgn_offset, srgn_offset) < bit_len + srgn_of=
fset)
> > Isn't bit_len should be used for size, and not bit_len + srgn_offset ?
>=20
> then find_next_bit checks from start to bit_len.
> find_next_bit stops checking if start is greater than bit_len.
> it does not check for dirty as transfer_size.
Right. Size (nbits in _find_next_bit) practically means @end - Confusing...
Either way, Is this tad optimization worth another spin in your opinion?

Thanks,
Avri

>=20
> Thanks
> Yohan
>=20
> >
> > Thanks,
> > Avri
> >
> > >
> > > Thanks
> > > Yohan
