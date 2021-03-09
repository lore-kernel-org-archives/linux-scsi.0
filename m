Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF34C4332B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 05:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F6365199
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 05:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCIFEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 00:04:44 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:17169 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhCIFEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 00:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615266253; x=1646802253;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=JwJkQtT9SIJIQOkkWjY6hTwOyGZb+VwTtECw37zH800=;
  b=b8bKpfGag8pZn3xVleuB3tpit6Zkec8pokLwL+N/KTA71VkassUTU+qb
   VHsV2m4BK6ePtldC5kYOm+37hhIPktyDNe9xtf1Zq6LfHOmUtVQT0ht67
   uvIZyaiRdPXXotxMoprm+XfxtVifzwfzJg91kTZL4TWhPBjO0Ow+Z1nxy
   QkE+7pNohGK4UJCz0PRP09MQWZKTMkXTUIs0fLqtCs/pMNNu81YoY9b1C
   ENHIh5sQQMxxIijUlwZjt5yMQK/PH45Pr3do/a1wSrS+AJgxZhSS0ceYG
   esnfcchybk8G9FbNvbaxbatj0Xk+5wi7p+6/NAU7RTIKZW4pA9jM6lrKF
   g==;
IronPort-SDR: HcIgHiS8W9rL6VKQGvJ8i9fJZ980bSlfS/+fHBHsYHLFIJT+PolYXhG4Fn3JdL2YPem4WsRw6g
 TuLWiVQprM5Z7Z0kwullb+/As12arKXUEHbUtBfS1yRNWbUm4qbLFtkdYmamF75IuUTb/xexsm
 8IerHgPd35q8giK1EPh98ZvY6AFSic579wjah0QkFN3nBebhjA73ta4NN4lZT1fsZ/m6KLhqsr
 KDjkZikkT1JlChSH6dKM6qFdJ0zw+XjEQkK8g3hTLiS9lZ+4b/8iZcDRpXj3U+4gw1HC1zsl5+
 5Ug=
X-IronPort-AV: E=Sophos;i="5.81,234,1610380800"; 
   d="scan'208";a="166176086"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 09 Mar 2021 13:04:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/LDDlp4DxIFIPqmM464RnaARoG7zlzaogW4Ydnm71bPP28/sY38/6v1Q/9rafTRJVCUOA61uQi7mKCq4bJRA5Eu1cNXN++B0ew1tH+nYiCIypiVzAhx4HXYyp2g9fY5MoBoo1EnqY/4z/Z+OlD9KxBmLKn4gA1wnlSlbYrZAH5EwIJKuGw80qLOEmU4aWbpT0531bwmtXjjXVTQpJbtWsL99f+7Ak2cmKyizrUCr0q4Yd6AyrySRzf/1km+OQlB7eyW7IdIjBszTTKEO0NI3+sEF9dtTp0p26D1cUs4o3byB8LjqhStzffeJYM6/6Yeop5dYps9F+FVrSsJADO9EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoKtSbCNfMibwvO9YWo82nZiBAeE7uj/7g4ub+k6T0I=;
 b=AZr+g3/b8Doa/P7laAgJfMhp56QYmj3cZ/Uzm8o41ENCR13XwiOwWc7mtR5gEfjC80jNDa695GdHkZIqQ8d2wmGygJf3ws6pQ0AW3tF6zf7EN4a2juC/Iq3rroD9wGEQJVZUVqzD3zhwTKdAShd6XB/jb49bHEqKisukshGzZPqmvCdrKa8L2vaBHPrzY1BTBYVB+iz7yzD30Tt6jtK9NV83ulDRhKvKfdJpVQ0svMHTQ5H+1u+4Iho3S3XiGZTra/s3MbZjZnt/Luw+oK7IyZp9mXNVz7Xu+v7GLFOU+aVq1aakvrhDHBcsGPiOgKuwI3KbTQKKWawmimMJGniTLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoKtSbCNfMibwvO9YWo82nZiBAeE7uj/7g4ub+k6T0I=;
 b=wRMrQ6RheBCRD1yRDEasDcWuD/O0xaDnKL8Hk6GZFDqLOen43f1rntfcLx3+qCuOJEFkXyK8bivyoNkaUp5VtcfIGwvaKduzrdiauKB3agoVYVtUjQS5UU5KRo8p1SpD8qeRE+VgVQlYtfZkTGf1GLQMom2cxoq9f3ypEoWeorI=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7550.namprd04.prod.outlook.com (2603:10b6:a03:327::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 9 Mar
 2021 05:04:09 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.038; Tue, 9 Mar 2021
 05:04:09 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 00/23] target: code cleanup
Thread-Topic: [PATCH 00/23] target: code cleanup
Thread-Index: AQHXDZaFrqqcc3FAg0CITiO3Md3Z3g==
Date:   Tue, 9 Mar 2021 05:04:09 +0000
Message-ID: <BYAPR04MB496548D9C37AD2AFCB2974E886929@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46c36b35-fdf9-4cf4-7593-08d8e2b8c5d0
x-ms-traffictypediagnostic: SJ0PR04MB7550:
x-microsoft-antispam-prvs: <SJ0PR04MB7550D972B7482F67D2914C4286929@SJ0PR04MB7550.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i99NZc/0Gp8klkpykMbjHH5eoPLHtX2sh4OrgTz1dY58ltKzINKHz/G63B6rbiwYczN7r++xLZFhd+gLtQzJOoYP3umiC5s86lpqGja6kC1Miwof64ES8JqPIJZFyMmk9cwq80NeXLx0MM8t5tuD98+Uj5BnT50tQ2j/z/uvA+jLHirdRZDSDhBHfFmx5dAIQsfkm99NV7riTHRh8NEpvAQW6DVebIIRI+Orhph1cWie270SOF/HbMk6Of8uiNg1lfS4WNy0ZBRQTkIGVCmD2KSiW58bFbR+x3jZ3bjWS/5vm0nCvkGQLNBq4GKSLw4I5stmkA9O5CXCMg/OhK1ljdtw1kk2arnaNhNiaf0yQpJgJwt+BcRTH3PZSHyLAjiQNcr1kvT7VPI00yc1yC+WP9f9IFRpl+oy3q+VyX6rNZNlncO+cEejJ1EnAwtNr+SdKZL29jH+VnpceKEyrL/r/4/DtuPnRzZZ2OZX/LRzepAIl0239MzTZLnPeUIuEan/IobTIJk1bi4zH/KKLZIlQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(54906003)(110136005)(76116006)(91956017)(66946007)(64756008)(66446008)(66556008)(66476007)(53546011)(6506007)(7696005)(2906002)(86362001)(4744005)(498600001)(71200400001)(4326008)(52536014)(8936002)(26005)(186003)(9686003)(55016002)(8676002)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?E0QWlG+TeY+5Ow+U/zYUP5EmUljgFpbbEMsSUXHuDlVTCeCio0ip++DCm9t6?=
 =?us-ascii?Q?81I/XXvH7aWM6qs1pcdAIhnpd3RkXcD0IJefFygvG/MLN0Xp7bvmB8Twef+7?=
 =?us-ascii?Q?o09s+IaGGuywgrcgac6dcUpPTA3F+jp5gy+PfpIEpZgYCDMQo8y9Cwje8RfS?=
 =?us-ascii?Q?4Jz9itMMUDa1ZvSH6+LI1yk3gjTQseKE3jbQ2Ib5QVvM31tmOsuiUs9/Bqha?=
 =?us-ascii?Q?pVcQdXkbiwtxL6nw5X3fY9TMO1Xn9QJ0RayGYvAQS9bCF2NGqYV28bfQIZey?=
 =?us-ascii?Q?Cmlx2GIs//MhJ9nFVDXZ/RLtx82HmRDAP4bX5l3nKW2Ed0x5n54jRJKUfTuc?=
 =?us-ascii?Q?nRqIFonv5It0FRr4IY5CGtr+/6Kai/iC1rEAQVSvvzVXSHx7PWvghU4//1PI?=
 =?us-ascii?Q?OJ3DbzJZI/tUboSQyhc7vfUZdfS7CmWZlfwgqqDFAz37JECtPHOXr/sTk9n/?=
 =?us-ascii?Q?RykUrSd3G70mnFBW+Jk2QIKGrmESzy9JvW6M+Y/ExHLbhbZov3QixMNTHO5r?=
 =?us-ascii?Q?P0JgYLwG4Hc5X3IqkDJGXRS4z/nk9oyWB9dIQ/DgzUM7jE1wkIFK43B+qf0Q?=
 =?us-ascii?Q?+WwsOtrVNtCo8dy8xHP/Fx9UsIGx7l3FD1RP8qXfrtWlf0P38qrENwZxTx6a?=
 =?us-ascii?Q?I1o8EJjGVmLtTGDDwqMUVuCQTvqJioNSOosOQkxh6Z1fo3LpKVP63Rb1UNJe?=
 =?us-ascii?Q?7rCLvT+VJKyzpiFvhMd6B8S/nJQO2k1+mr9yZYgkPQ35g/R0R5jwSHdU9qNs?=
 =?us-ascii?Q?JykRS6QSFLWQ15wHXmzhBCmqltBjuPEYjaYsB7hNLrUwubEgHJHriZd2LgTW?=
 =?us-ascii?Q?LOMCpAKZcGnay7WCO8qIDAhCKrU6LAKFN4cWcFftU2ToX/qwEJrtoBHMHKnq?=
 =?us-ascii?Q?mhFILHuMBbbBU8OZnx/Rg/Af/4UTtHmjIE92JsRslifDETYwoXf9twmrt8z3?=
 =?us-ascii?Q?YLWYbxr/F5GczYOd5BKYW0MsuvRWxqsUV5prfR6raB9JnNvpVwr8edYUmuvY?=
 =?us-ascii?Q?UtRfymLceG/dRklbWAqrdybH/vjSM969NHchKhJUl0Io/Pi6CwC1xpBBobCC?=
 =?us-ascii?Q?NWfo7RbYS/EwTuHehrR/T9Zfxq+Y87ncMcWKai/Fs+VOoaIsF0GJFeSm1vxM?=
 =?us-ascii?Q?ovdbVSZbX5s4v7U4VUjXad88gcQsv0ePSVfXyLURLjZor8wRa/jGf+eHTnpW?=
 =?us-ascii?Q?3JStw9XTdDA1GT0aPdRsi863Ih5C59Mgo1WE9NqAxu/p43qWSmUk9wCbxtEl?=
 =?us-ascii?Q?c1FY7+uVfa+1aMsKYoXtDNMEnYYVzM1xiOh9T8ycKLNMHUCtjvLDonkdFtfF?=
 =?us-ascii?Q?n09h0jbUAtanADjUtVmQ+lYWKAOmCH7SfqoarxIp3SYKIg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c36b35-fdf9-4cf4-7593-08d8e2b8c5d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 05:04:09.2338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /CIilQ0FqsDrfbz3k3wUnfMdH0cwNazrK/TWMt0R8dzVyOLM/oM0wRtJlEme8XhpTn03f/isnFq0di61HZrJib4eaL0Lh74kmN9zzXkyVKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7550
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart, Martin, Hannes,=0A=
=0A=
On 2/27/21 21:56, Chaitanya Kulkarni wrote:=0A=
> Hi,=0A=
>=0A=
> This removes unused macros, various memset, extra variable in the =0A=
> target/iblock for bio get and fixes type mismatch for the same.=0A=
>=0A=
> The unused macros warning are found at compile time and they are=0A=
> documented in each patch commit log. For memset removal, there are no=0A=
> warnings.=0A=
>=0A=
> First four patches are target_core_iblock.c cleanup. The next six=0A=
> patches are removal of the unused macros followed by elevan patches to =
=0A=
> remove the memset for local array buffers. The last patch is for=0A=
> removing the duplicate memset to initialize the buffer to 0xff.=0A=
>  =0A=
> I've tested this patch series with creating target bdev backend with=0A=
> loop back transport, fio verification job seems to work fine.=0A=
>=0A=
> Any feedback is welcome.=0A=
>=0A=
> This is generated on today's linux-block for-next.=0A=
>=0A=
> -ck=0A=
=0A=
any comments on this ?=0A=
