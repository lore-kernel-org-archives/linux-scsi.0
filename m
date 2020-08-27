Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E366C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 15:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447EE22BEB
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 15:00:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NbKWhfB1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="waUeHoiF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgH0PAE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 11:00:04 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4103 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728954AbgH0MJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 08:09:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598530162; x=1630066162;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wvrpnphLiMVYcx9jsQEJk6CIYPezv/F0KLXqTaQ9Hjw=;
  b=NbKWhfB1E1fz67PXvfs1tUDCXx7Lb3QLw1lFaoeVn2IP5NEglsl4O3ls
   F1wKdnpMFyOUJhApDniE4m3NYr2+djJKZ3npy+M1SUyde7KloyJxTiq6N
   uxLuIdb0HNUkDx7gpV7E88WfukFJmOYzqSbJW1IRcCnx53e3AWLa+Snd7
   CZrjxiOrURXJ1I8IZ7iRVXNj8NfVcf0G59vvMgWpku8Di+M3PyWScChq7
   ZMFnHjnNkm9d0VcREI6WO51j7aja2pvqMe+zX1XHesQbj1Jp/6mPGoCpr
   30u5wppgxONLUt27NmVaSJ1LE4li2NDskjW3hKooiC7hsTisMrCX1ihVD
   w==;
IronPort-SDR: dkO5J3VIPiOTUK/EIbT8kmqjvoiEfNcVhqqoKZtVDZuzXqAM+23KHQ3X+GDEsevtATgaZFLf8g
 6sNalnUtNl88tUbFEFzSBj6UiHWFm8BtYJEbf67hLusKyumlpcuZK5/WJdnBsY1fTYAkElQpYw
 t5h1tIYxulYKAM5Ffs7DLaaiLQF7FTRsk2jjsnumGjDri+WWIdCCTPvbdao70QJr8YaBYw0JcH
 /ZnWiEu4fkfWGDCl/lmL3CcqoDhgNW1Eld6I3d646kJaEFtEsISRbQ8Xzj0EngkuHeHdYRUUy4
 VNg=
X-IronPort-AV: E=Sophos;i="5.76,359,1592841600"; 
   d="scan'208";a="147185815"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Aug 2020 20:08:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNrvt00Zo7KsCZzcsX4Map4iN84yvVtXDZia3W80AAlB6hApVRyEynBCqY6cuI0GnjPWkdlEajR7Pc1qxT4fHcoXM6e2qGpVsXl1A2+2ZXf3e/mqxo3JCPYaRJxmswGKwfshz2nx2sfuELFqvSrdJ+DQok7v8SLbQbZi5RBIPcKJsKBiZ9bXMr7G/m+uWoicJwc6NM2Qj+sIbpCKs+fnNoXllvt7rFty8ypl85w3ESujOX8DHNaXhiDOTh9xL7ONAQuvt9HeQmWFtML4WkTwwuPTnwUHA1Fr3IwviEWO0mXS9r840sNcKxga53jURdp1M4u4LzHbusqKYkmSKgXzxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvrpnphLiMVYcx9jsQEJk6CIYPezv/F0KLXqTaQ9Hjw=;
 b=nurYlv7dM2o0pAY4EcyyPZPMpQKY0VMaWrcKIIXl6eunovOHVTfPyTv05ojxg/dNshdk3xTnjunNCMXviagoGbJ7NyuuC89kLqTpzqu82ZugEKYdvizZn1M/qU5dL8+4d3NAHTz/9zRMHfWz4sUQcXHY2qmiWsWqaKEKATOwQ5m5Y1vcmQ3RAefQ0NUUWW9vxTSev7P//LGWGjHz1m6OgDKs9qlt7uggzxMOSV4tMpi26EeW0CvN/LN11QM3+lo/9Ubzkwf2aiNjtjs7hQbMimap7UBLkHggj8CAitaFqOQd185AqQX7zTwa4sWVvg9id90T7O1FOIMvxthVcpZFog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvrpnphLiMVYcx9jsQEJk6CIYPezv/F0KLXqTaQ9Hjw=;
 b=waUeHoiF0f3Q4kEEa+eGxSY9bsOE0QEncvQEkIdUcnk50xcVLwmyRzf+Ci0mpZPUFgHdMzm4/OBFto9dzfCPYG8ExkCIDGzRaqLf0Vc3FJDPHK0zaIUlv3+Iaaiw+MlQ56PL+DbJp/0TiSeTWAtVr7ztJya+RdgDUPyhjQLQF5g=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6613.namprd04.prod.outlook.com (2603:10b6:a03:1dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Thu, 27 Aug
 2020 12:08:37 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3326.021; Thu, 27 Aug 2020
 12:08:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
Thread-Topic: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
Thread-Index: AQHWfEKlBabm3VmckUqm60akqaE3LKlL3NPQ
Date:   Thu, 27 Aug 2020 12:08:37 +0000
Message-ID: <BY5PR04MB6705AFCA7E52233C4BE295ADFC550@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
In-Reply-To: <20200827072030.24655-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd27b8ae-b090-4f51-49bd-08d84a81edd4
x-ms-traffictypediagnostic: BY5PR04MB6613:
x-microsoft-antispam-prvs: <BY5PR04MB6613C13D52FB2E6E8FE8E826FC550@BY5PR04MB6613.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m2XuyDbnUY1/jY6I0LtqJ+7yKG+v2So+EhjdKRdnZD4a5p1yfHBv/gk0xy5hREsC0VEGi7lkn8qxmRzVmS5eB62JeAm7/O4kQbYk9Ax7RvJIxPPm0sZy/iG8OqN8qUSAQuHYLtH/PBKstPg/RgTsNo0KrYK0PMmf1GBkPyok/5XwwFNng3vkoYkngNcHuLApd3cduJynu8kuqTLi9lceSJ2pGTTkF4XmzS7ugX9Tt6ghjkmGkG99bg1nUpDoeOwT5EAEujAFa/pi+FReS7gQqu9EOP1jYHv29J12jVwexR1vQiuBf8b7oc+SMBwjcIssqDwJWFqIgUfavfqmT41vKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(7696005)(4326008)(54906003)(316002)(9686003)(8936002)(55016002)(2906002)(110136005)(66446008)(64756008)(478600001)(76116006)(52536014)(86362001)(71200400001)(66556008)(66476007)(558084003)(26005)(186003)(66946007)(33656002)(5660300002)(8676002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: T2a5UnJvA+xLyR1pxQCaEEKu0ZNmEptBA2BGEQObNfy9YxbUVM+TpquVIx1u5zuccSgl7wX8G06f1CnfWFC1h1Gs9BbFJ85tXxDAMWzT3MCwJ6WRmaakADJhKXszP/h1Ba3ri5BC8y+ZDN7l+zrY82C5mFli/0mj3QwPIpYTKp2ZbpI5Km7FoeJ/kOAU2y4DP1AksTROvyohDbZH+cLcDIo/fn1bVx1iv4P0yPwNpYCw1/GNCHN/qL+utUrl5CVxlowwVfiM1/1NHtXi5zEaJKT7SCW63v+zmsHVvtIeborardt8rpYFzmlE/hTOx7ggPmxQHOefknzOFpPuYlfI9rcqktcQU+ntH5jMaXH6JR2mNu/1xVtcPM6Vtpw1AneFGn+roC9ZDK+am6CJyCDlvvHD/idtXEfnZvbvB4A+EDpRxpB/dtht6+NrrJ0f6hu8px53a4u1zPrpMw7m1bdsYA74eolX8c8TYOW3JYR4ng/7eUaWPVoPGNKNUQJAt8rqK8XamJDmpZyLbZTPY5dIAaQ25B2jNDvPIkKjsgWhUicp0ZhO0G/mD7Bw0TOcdTF7hp7jxOG6TYVas/4jw0zwSe/pDxOBNFKVH2gx5yBmoZGV1rHnPN0Vl9H1w/MfDtNRb8yJefehrXFOM6ir+87E4Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd27b8ae-b090-4f51-49bd-08d84a81edd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2020 12:08:37.3099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZQcFfbKxxhHziGgQuBBj8ZM7D5qS4OjngklyBcHRs/24HySMAzTUrT7pigY94b3vWlD+flcXSW/zKYUrs7y6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6613
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Intel host controllers support the setting of latency tolerance.
> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
> raw register values are also exposed via debugfs.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
