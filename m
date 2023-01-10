Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A720C5479D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 02:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjAJCDq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 21:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjAJCDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 21:03:45 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB23119281
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 18:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673316223; x=1704852223;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lGOyrtqIoCdpfKL3Ei3+hAUeVxa6+pVtknCfyy7SmVo=;
  b=iq9wFK4++kN5/jS0ZRvMT1Y1GoY8GVTy6E/cDG1ZX/dJL1b9wvRsYOqv
   icL2g4mZ9Fxpr6jPcCMr0EUBjAT7idsl7ojCGLNRipkXmVUmftt+0XeEH
   iOFaI5kV544Wo+28esexmljG0mI068RvuzwqJ6Tw6TeHCHGD0YNcSTSAs
   ncLBaYZQMQNeGn3IRyJiLgwGca0GWBkDJjTiWyuvqQz6JH1AODnc4quud
   fyDDSbxjeJt/TXhG5K/DYkkDPwUiAVarN1MG954/56xATs2ybOASSOmkg
   hdtKpAHyqQVnSYVIDZ2fFclMN1f5APQZuMKXvrk/cXIUtJSIEBkcHsljT
   A==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698931"
Received: from mail-bn1nam02lp2046.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.46])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 10:03:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJJHsPIcfrpg5/r0d2ZoBasKQGM9b86lc1VnC4E1gKPfOsg3HCqOZCi1H4W8bFvpDhln8jv0BacXBMqAyuOMgMTYf6Z+/5EZ/mCGAZ/u9iKYNe546H+1+0ZMfaDr4Kcn4++LvY/L9h2WHJOVUqjjXRhjI3sD7/lCGFGuYPOpluwUBBmzJsKqLNNyUP0s61hacsRW7CDton8A1SbJ0OTjd9XkMubRjOV1AtWVu2O4wVkHYNc0IP1Zhc48zzlSz0U3aBDL5urq1lR0AB7emkntPr9LFJ6IyrTARHqr2itduI2Obgtj+zcY3WtBvtVaG17uaVM/tQxVJ1podl7fJIei6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WDVkuIvLKeZeXAHKwWX9e5qlAP5CbXuzinDXtoW64Jc=;
 b=mf/mKVueyyZUrhMxDJR8cfBIxf23ZssKrD4ufWSRWmR4+1WkM/WgjLvpCNbJ7WSEVFggVWXugkJldtnSVJd4oUG3GQXOXjNH9YIbsnxAb25WGcBz5pSupbbDgmnbxhB/HbzQhEB2bpiPoE+q6Z0NQ0nzkW5exRybkPbc/mOG5UDpVh5brni/9N9JAXLVTIvM8/B8lW45Ru5tc6keCgjuyVFfDZAuDDbJw1MW9w8YcN2rxDpSWVPpjZLY6gyGwyZ5B0yEWcBSPAie+aSlw+CbihimQ2A7YSnQR8THd8lhIUl/QV1k/AppHOpAWzZQi2bqXLHmnW5h9pe2JA2OF76cqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WDVkuIvLKeZeXAHKwWX9e5qlAP5CbXuzinDXtoW64Jc=;
 b=AvpUhnCfRwg0lW6mMjXc84EQX7EyXjup/kA2Mptn2tNi5xMUFhqGPrrML+txTUShpODc4hhA5VyXjx0wIqwr/z+Cp7pz1aX/MOcYWgjSQ3La1QWYPaynCloffle2IS0ypLwRL0hSziNY1lFiCc43XjoGGhh7zQQFgmMYnV9uK0M=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BYAPR04MB4022.namprd04.prod.outlook.com (2603:10b6:a02:b4::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 02:03:34 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871%9]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 02:03:34 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Thread-Topic: [PATCH v2 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Thread-Index: AQHZDo05JVp6pb1K10SXikuESH7thK5rTRmAgAAb0YCAK6l3gA==
Date:   Tue, 10 Jan 2023 02:03:34 +0000
Message-ID: <20230110020333.ynfymzfbrfwjaevm@shindev>
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
 <20221213005243.2727877-2-shinichiro.kawasaki@wdc.com>
 <CAFdVvOyyw3Ri8BW3U=vqtyDq6fiBoJVQSqP=2ib6-WAHFaunLA@mail.gmail.com>
 <20221213071751.qfxh5wjrwyiwvpat@shindev>
In-Reply-To: <20221213071751.qfxh5wjrwyiwvpat@shindev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BYAPR04MB4022:EE_
x-ms-office365-filtering-correlation-id: 772041e8-c800-4131-c186-08daf2aee14b
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJDF+GPvnQmKUaq5boNzvNR03yVQDk/p5d6HIFjHxRR+OFe2ZBZWX1IrYyNd1uYKWX8qOgMAWfvwoChwfatQZz3L2agAuJhMisvI654qrdy+qMIqEFbXlx3LrvxZICfH7ehyIea3lUC3Y8vx016dBl38EBe3xWcVX/wekPVqh/+r+Djda+7sTzIKGj9Hao2L2Uj3nVHVkzFsbxZs7pNXpesfnI+IPhJwjvSls/1O468+l2IET5JERTu+s+eJ8+YnNodP9EZVl04Q2pi0Jg/Q9d96BzRbD/jYwj3Y7h1EvXlKjyUHZiPpJem+t9m5IjPs0ShX/zrANzNg5X0C8DZPu6DjcHPNMCQ1CS1bNshdWSACLUe4t0KdWx7pUKdJokLW06YWyF9PSsSS5hH2niu3t3dgU2N5VTA3Wox7yNFqakAig5nSpxPJQpJitBqM9uDMEI4NanZOMNKTt1wJBXa9A+emqvUy5fcfUsCUrTkrTaBNIVwkXEBEZBR6OZlA1MlDpcxeTVXDRITfPs+33LzEqXAigtb4QvubwNLNCRKqRCd+HU2yIdZYkrO9Bzo1hvO6YCuDIMSGXtoe1ccNcquCWPwhsmAtcZmrSbk/6dP6eVzemHuZ1AxNkrQYvfZxWxwXvhAp+cT/Cp2i4EPPHuZOSjdaJ3CyiXoSuMBNsqSDIgRqwGNdpSS0EpdJ1vniItO5EEjrypFQV0CcMjeRsZUEo45y8bnZPPWEZfZHimjB3qE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(451199015)(44832011)(38070700005)(66556008)(86362001)(4326008)(64756008)(2906002)(66476007)(76116006)(66446008)(8936002)(6916009)(66946007)(5660300002)(3716004)(122000001)(38100700002)(83380400001)(8676002)(71200400001)(6486002)(478600001)(54906003)(316002)(91956017)(82960400001)(41300700001)(33716001)(6512007)(6506007)(1076003)(186003)(9686003)(26005)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OXQM3SkUPFfY7qgPxI8Mmi4fe7MS16XX9qsmKrjN5moxTTcA0XU9avVCbXlq?=
 =?us-ascii?Q?5wPUqs0Xl/372EEwyuGxc/jaEEIxPyE/FGBIkYUKGXFP9aSPWCkRbrKNH0Lm?=
 =?us-ascii?Q?LMo2OurYxRuq/lQ0EYUV0ScdbAd8qWK9r+ZYg5ZEMke9xsB5FtHKJkZ7hVml?=
 =?us-ascii?Q?sw8UD+ZtQSw2ueUV0WHUpxzIPzGASvmVm9KaeUCLESQ62uWBZWzD0evMtGOf?=
 =?us-ascii?Q?gQj2DejtGDZvNHTHcKfSxuOIfCp79KGWfnFgG2XnDjVvprlgiBUqbih12wHt?=
 =?us-ascii?Q?pjb1bnynACvOx/SXXsG4bKbMZjjqbx6SyEbSOor/YLgF9OErlkjZl1huc7kA?=
 =?us-ascii?Q?+RlnorSpejDcIUredQiqhcJNrJW5geejm7bAgQ1pa1mYZNTd92ptJd2Ty5PL?=
 =?us-ascii?Q?jEDf3XSCgzZCDdehskRljem2k9s/mMRUL7oBqQj0EEcJNxkdfTVk48Pbc1z3?=
 =?us-ascii?Q?4jkTwZHyFuF1BYmd4oU986DYzTIJ2F2L260BA2YT8Et4unOMpxshVlVUEWPU?=
 =?us-ascii?Q?G5XR6M23ZJQeo5qciiD1vadpxHDlZpgVtU487qWNDmXhBeNbQc0/+djb/uNJ?=
 =?us-ascii?Q?Y0CZS7ZQdBCVcuaYhYalj0U65MzpJjakH/yUZpgmXx1MFU0bIzTRKmmzcUJs?=
 =?us-ascii?Q?Ssf+e1F1NbCFMLiEzRdxEiS2IjHsUQhZRJu7DnliyXsa8WVBT3nv4WWn+uLn?=
 =?us-ascii?Q?BwgnaH/zeS7snDwaRL5fxTZqp0H3Y82uvDYNXHP6WUgvMJ30DepAt3AcjJD+?=
 =?us-ascii?Q?YlHTJIqQ7b2l6LHI3VipREvRwgIR91YCs+p2hW81Rh5NO3lLT9IsjJQUMGN7?=
 =?us-ascii?Q?pQfH3vZRlMzhKmbWPEEUzOokcTU4qTpvKt59kAZBGWL8Ns2O+W2f/7PqaMxC?=
 =?us-ascii?Q?XAmlK2/aq/vyKznqqaEqgd5N0fzGxgED29EykWp2GLuiifDhpd7/gTYzvGoN?=
 =?us-ascii?Q?+FEX7SmEMWXczpHSbIEMO94rPHqUDKherKEHeOg3Ab3u2DUSJDpX9WDnsw7B?=
 =?us-ascii?Q?7GjL/AXf8mBTxqPcmSXJk0vPH/L+R2wQOsMR8KEFTItKIGdjTLqLcsTw/sk5?=
 =?us-ascii?Q?fF+XhLAW/678Q+tpFjeOfUOBDM35abFwKA7OQdBhnralqw5dZVd9p2Yq3BFN?=
 =?us-ascii?Q?DoEJY1EOL1QZgdmIm0GiEndHoQyo3uZPhhP3Wv5Rd+xwNu7TAIyVvYKR4XD8?=
 =?us-ascii?Q?Tzj6ZD6DA2pZDZ1xHk8ejPE2t0dzmdtrx6OW0gVv4uc03cVr8fh/mNLzSEne?=
 =?us-ascii?Q?2mZdnftVrkYkrFoyMHpeABf9vpSv+oovUmnUfAhB5jmxWf6ENciCySZ990zY?=
 =?us-ascii?Q?m6dL+by24oEFf48sA0gIo72ZGnaPnHGw02owmNiuTYcv2KhT11E/vaUxUsvm?=
 =?us-ascii?Q?waYLdNmHVbaJLPVN3UfUKhnTErolB4+pcl3jE/udXnRY7nwoBAqer682pLCg?=
 =?us-ascii?Q?w4rQP5tOYY0+G0TMzMife/6EQnq+GBDdFJrtT/1Ynd3evuzTG82+2It1K9d3?=
 =?us-ascii?Q?8wKiXhRy+7bqbh0/gY1O0Jiy0iQLYu17KPGnupFprLqP4bgR2yAHfJhLuH8k?=
 =?us-ascii?Q?/BL6z3MVLY9t0feHz9IRdGHs0BD86wMX00BBygACOVb1U27SwK+qEOyIigZ+?=
 =?us-ascii?Q?c3AZY9rCgbZBg4ciGruGWD4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2F35730259ABE346B5BDE0407E61E1DF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: o74lwbFkmInSJMvbY3nlKI7mn1V+vWHjma8mwLlm/59WFsRjO33f0Lr96MIW8xtzk3yjHbTDdO2KQOEMubsAGfnCHrMfZ3rhUb8hHlIIMp3lKRUpMDqrmBMRZyQbi7RV8G9jzm47oZegxQyr3UE3rMsD+ojk9hnEQQURxeXxbzW1gjD3DJhLOFGAUG/Xgg/WwORgDJJJ4plETBROv3wvw+BNaAY2RUqu3EsqGDSrRy7YkN40ALDbcq3UWs4XNLuCECJNNFofCE0Qjcqw47ToPsAhSiK35eCbjpWRiOMiNmC2j4XBqVpFDQ8D0t6Lw+QBVi2Wr2kdbgQ40tnEX0utf3JGxI2/PxKDbUeySXYk8E618yQPw3LhYHI/qHNQi9j2sJj09Nwb60yFaRPHfxnVJho5r2ncf//jn/nRTvT4b0GihvBYQDfS1vtt+8o8ydU4SAg07DITows8DMZg6/scvs6gBEx3wBwGpguRYuEw0akbxXBYdBbDnFPMpc09ctDjCgL3BgQJm8AM5elcAisH7yzQHlpuNpk3glaLbE0+12TPCYrVZ4hh3DPpw4fMDNxb8yixSvikBqnvf59W3loWv00IPtGUxq7mLku5w4lif8gjKg2C5NhDs3RGBmbbnRo9p0/Y/bA75Uwzng32iw438gBIZthsb2EGt1WT/S1CvcFkxnPVH8k4Kv+Oe68hiK1SQG/sTgjtKrUiiOP7Ge42aQx9KXd9VMv8yT3jsODTgOwIAbg8IaNsuvc1VaqmaqaarsaH0gaUSsmr2WVu+bxckLxg/1FilX2xhxNCdGk9UNdRpvHrA145gRblGmSN6qL9ftjKVOCHpdvDMhvB9PZt9Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772041e8-c800-4131-c186-08daf2aee14b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 02:03:34.3948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvXc3ElaJNB258yTRknAvIQomJkyz0Ls+TXaJVNGQ2zQf3LO58GyqAonB+HGlxL2n3/sPeOB3ZcEXoOW4EeHy6feuXR3O2nN1cKHEJfAKK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Dec 13, 2022 / 07:17, Shinichiro Kawasaki wrote:
> Hello Sathya, thanks for the comment.
>=20
> On Dec 12, 2022 / 22:38, Sathya Prakash Veerichetty wrote:
> > On Mon, Dec 12, 2022 at 5:52 PM Shin'ichiro Kawasaki

[...]

> > >         alltgt_info =3D kzalloc(size, GFP_KERNEL);
> > >         if (!alltgt_info)
> > >                 return -ENOMEM;
> > > @@ -358,7 +365,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr=
_ioc *mrioc,
> > >
> > >         sg_copy_from_buffer(job->request_payload.sg_list,
> > >                             job->request_payload.sg_cnt,
> > > -                           alltgt_info, job->request_payload.payload=
_len);
> > > +                           alltgt_info, size);
> > instead of size, this should be min_entry_len+sizeof(u32).
>=20
> Thanks for the comment. I read through mpi3mr_get_all_tgt_info() again. I=
 still
> have three unclear points. Your comments on them will be appreciated.

I've posted v3 using min_entrylen as you suggested. Also I added two more
patches to the series, based on my understanding on the three points I had
noted. Your review will be appreciated.

--=20
Shin'ichiro Kawasaki=
