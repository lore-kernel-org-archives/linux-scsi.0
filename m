Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDC2C433E6
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD5D92075D
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 06:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="NkwyUh2R";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="cwndr/HN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIBGgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 02:36:01 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:36610 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgIBGgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 02:36:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599028558; x=1630564558;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kRP4kOZXlY1X3FDWe+dHQs3Rk9u7MvcoeOxxvim7ym0=;
  b=NkwyUh2RY3lczUZSY97N5NEus6PWUrPwlGowWBIConwHgYmtOKQPS6c0
   Lf/sxFPc6AzUZPDrOWRDQ9A37Pv3mI22aoTshnbmAovTuYOEyqhdX81dU
   Q5tjwiMSb+ymZxrIvm6GloZk/bk84lgU/C8tv2R/rSbESTHdpLCaStnki
   wpB/8IOo/NBXr+n27lA8y35yOzc6skytj8VHiKj+DZQITWQxJzz1PZOOh
   /6f/BBDEe2wftN/9lf7e9mS/1dqHJmrPaHj8YeINBxoS4lOd7btO8PIAl
   71TMnm1yCmP1Un1YkahCacgWzy19/ARaykqSCuQkSLsQdagN0QZbNrg7k
   g==;
IronPort-SDR: Su9qFgEkK3B0Vwb4cDtcl7PyO6vh2P5wYSZG21Njal7OHrXheVpme6MvN8Zdkwi553NB47fDUG
 vYv4Ntmk1wMrX+/y5VsrkebUpPpgjCNJQYH2C/YgoCyupi67sxYERdkMUuOq0lRTfWlIP2/qMt
 XQZyp7e6pfUwdGiVGZUC9I9MUggZOOPZkbkFYvX9Rm5VJd7EO01H4DJACrFjaE1238hRVSW5x8
 ZovK4Y7CKhbXB/n0WjmEZpBclNhP/EMamJBku9k3vFg+zlhIJf/1g/3oHoDe+IyxkoUIv80f5d
 q7Q=
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="25016427"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Sep 2020 23:35:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 23:35:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 1 Sep 2020 23:35:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0WpifwUkWHzySTeuQPze/dN+Zh/1PqtwU7JQQXG2shP7s1yOGT+P+Dj/GSQndBnqokqvn5CUVscMP4D2Q9B9cILSkV0ymBQ18HM9cFUczMvkchOmczljgpAVOWqbOCBI2LNRZMExi/CmE8m2NB2kpxi62hZzYL1uY360AOaej8NBk6QBodbeo7skFKNSqZTSJ2jBlbM6pthtQjZqxNUwkOToEExmKoKXFGHHrm350jycRqLIFXjrGnQ/Yfl2hdoVI1qmUPCKUo+C/nQPmaZzgiHolPTB8DpMhB4g4yuEzHtwesJIgQt+52jUZkYzoVSJpJKTeWIhMm338lHfZEzNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1JZ1Nub6qVBD1rTdvv2ExHsae78RfBPjbPr0shMJsA=;
 b=Q/3mJEywN2MWkZepFF3vg+bPgeIDG/wv43M5VrFbRdI39fSnTBRqtLIKvIqq01W117hDQ4slJa0neJVy6XU3aT1NkEGR1OQyCxiib0tszqRDxr+IwZ/F+7FoGXsjKiivt5BfCsAoNi/PUCosY/p/SLCnvBghs7jPntK2l9DLanc3Fbw8EiJqLTUaKBLuJ6lqSzUB3x4aQq4PkUOX9CfVSZvkz2qN06sVNkLLV67xYpq2Tr41XFCpTG+FiJvepN2VUknTFzhfXH1HZUgVtUFUkSsvoW582zVS1bxRc+qr8U/j15ABnL18swTAu30qL5bmckM/y8yaHCyD0pDqk15Vcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m1JZ1Nub6qVBD1rTdvv2ExHsae78RfBPjbPr0shMJsA=;
 b=cwndr/HNIYmwUES80gpgNnAEbO+9fVqT29rdyaisYMD3EBjAJhEIk35JKI1ZY9b8t1z0Z+Ipcwa602WJTJ3ZM98zDPr7IZojsinN/wijCspOuGORrV6FEbbroZBZ5lZRTC0USMlOm9fa5I3SYEdiIPeEY4zkhu6aIS+wudy2FLo=
Received: from SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27)
 by SN6PR11MB3247.namprd11.prod.outlook.com (2603:10b6:805:c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.25; Wed, 2 Sep
 2020 06:35:52 +0000
Received: from SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6]) by SN6PR11MB3488.namprd11.prod.outlook.com
 ([fe80::9464:652:6b4f:12e6%6]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 06:35:52 +0000
From:   <Viswas.G@microchip.com>
To:     <martin.petersen@oracle.com>, <Viswas.G@microchip.com.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Deepak.Ukey@microchip.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH v8 1/2] pm80xx : Support for get phy profile
 functionality.
Thread-Topic: [PATCH v8 1/2] pm80xx : Support for get phy profile
 functionality.
Thread-Index: AQHWdyGWrXbEKONvEEqLhfPGQkid6alUoL4/gABW2wA=
Date:   Wed, 2 Sep 2020 06:35:51 +0000
Message-ID: <SN6PR11MB348809CB28AA66A7905490949D2F0@SN6PR11MB3488.namprd11.prod.outlook.com>
References: <20200820185123.27354-1-Viswas.G@microchip.com.com>
        <20200820185123.27354-2-Viswas.G@microchip.com.com>
 <yq1pn75f09i.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1pn75f09i.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [43.229.88.89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed5fc872-639b-4c7c-a6f0-08d84f0a7019
x-ms-traffictypediagnostic: SN6PR11MB3247:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB324723C0E05BB74D65B6F52A9D2F0@SN6PR11MB3247.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x95YF3elxP73vX/6Oz5eoOEYRO5pvozvoBIEuqIBXwEn3Z2Wee1OF7lknyVZ5Ucgz8H5OpEy+9oltq6pqSH8wAgdUVFoD5YNE6+XHw971cYHTJLZnRFd2l4L4G4RILBbGkwZxlLuT1x1YQX2+XfNvSywdBIPSgdtHb9FOWPFRWVaaD0M5bzpzwFkHZQf3Ndb1gNieiRe0hC2Xc94JF4c58UaYH2CXCYNMqXQhB0e6JgkJ8XoWIfbB4O4qhj020QGMUvzf0Vz873uE6hDSIkUA9Q6cE0g1dwcXMRGPJSy8UUvOWZRy2xCqwYTrnm2iUlwPv1ygEUprJVkS4QXxOWCEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3488.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(26005)(478600001)(6506007)(55236004)(7696005)(55016002)(186003)(54906003)(9686003)(110136005)(316002)(76116006)(83380400001)(5660300002)(71200400001)(2906002)(33656002)(53546011)(86362001)(52536014)(66476007)(8936002)(4326008)(66556008)(8676002)(66946007)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JbbLZY/Cw8EJdnxjHxWNu6UTYB9BsEBdN1jVOB/0gHsVFBCq+4FLcAaO7F1PhQgM07eeKZtUPd/k/PIh/rpaM23AKLOeiX5iR1F1+OMMKwWY0n7KsXqHKl39mwYA+dllvFoUap0RQIz5myO2K9PT3fsaeY/hh/MaI3h6oJATDpJAcxX3rr4DEWXL/AFwXZY6au23XCOb3PqN2iQ4c/1h7OEC9eW2G6B5d/W6xcqvcyZ3+4i0NwBTfB7mZhKjTdpWBsNv+nvZt+yN3N+sJJzVKS/VSvPS5Sm8r1wQRyNBUbW2UajfulIGg8khlcnW1bkt1sgBNzyb6rXPdY5bWnJhfgUL8ch9fiSrW1UN6HXzrbnXh5KIuZmrsnTqZ2owt/GrUTlwaGQ41b8as22xv/dQCvb/OeuXaHd9NPjMZNcr3IAHfDwnAvNGjhiUjpCC3QbSXEBSxgw4izXteMuD3Oe7W4kVuUxlRNPW2ltzKQC0wJUmJ76Tq/e8PBtZf/SOON0oLh5mh8+yIeO94SnV20REU3k98yljBLjOxH2PsJhKKUTJzuEJhSvnQsFcFi2wKowNnUW3BaJbPCEnO+LSzFJW7Te2jYCtU7fOnoUBWyXihQnhkA7tbHnGKBUpOZ4PAeSyeBHBP/p2GdJjNkYIzo9J1g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3488.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5fc872-639b-4c7c-a6f0-08d84f0a7019
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 06:35:52.0142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ko/2CX6xivZqvi5KWltaOzNw575NW8aF65b0j0X3miqVwDSEMtJkXIspkfEZj4XQ7y/x+Ew4GsfSw6HhwB2DOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3247
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Martin K. Petersen <martin.petersen@oracle.com>
> Sent: Wednesday, September 2, 2020 6:50 AM
> To: Viswas G <Viswas.G@microchip.com.com>
> Cc: linux-scsi@vger.kernel.org; Vasanthalakshmi Tharmarajan - I30664
> <Vasanthalakshmi.Tharmarajan@microchip.com>; Viswas G - I30667
> <Viswas.G@microchip.com>; Deepak Ukey - I31172
> <Deepak.Ukey@microchip.com>; martin.petersen@oracle.com;
> yuuzheng@google.com; auradkar@google.com; vishakhavc@google.com;
> bjashnani@google.com; radha@google.com; akshatzen@google.com
> Subject: Re: [PATCH v8 1/2] pm80xx : Support for get phy profile
> functionality.
>=20
> EXTERNAL EMAIL: Do not click links or open attachments unless you know
> the content is safe
>=20
> Viswas,
>=20
> > Added the support to get the phy profile which gives information about
> > the phy states, port and errors on phy.
>=20
> Where are these parameters made visible?
>=20
> Also, why not make the phy_errcnt members __le32 instead of using
> __force?

This was added to avoid sparse compiler warnings reported.

>=20
> +               } else if (page_code =3D=3D SAS_PHY_ERR_COUNTERS_PAGE) {
> +                       phy_err =3D (struct phy_errcnt *)ccb->resp_buf;
> +                       phy_err_cnt =3D
> +                       (struct phy_errcnt *)pPayload->ppc_specific_rsp;
> +                       phy_err->InvalidDword =3D
> +                       le32_to_cpu((__force __le32)phy_err_cnt->InvalidD=
word);
> +                       phy_err->runningDisparityError =3D le32_to_cpu
> +                       ((__force __le32)phy_err_cnt->runningDisparityErr=
or);
> +                       phy_err->LossOfSyncDW =3D le32_to_cpu
> +                       ((__force __le32)phy_err_cnt->LossOfSyncDW);
> +                       phy_err->phyResetProblem =3D le32_to_cpu
> +                       ((__force __le32)phy_err_cnt->phyResetProblem);
> +               }
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
