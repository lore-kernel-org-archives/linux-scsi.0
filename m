Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82C5C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 13:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1222083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 13:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iSrb/ip/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="BXJqGvVg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgG2NFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 09:05:23 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36256 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2NFW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 09:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596027921; x=1627563921;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=M3PtetOJ9MhrxI2gVXyvfm334BQ14wBHyC6eGk2WP8U=;
  b=iSrb/ip/2C7lZ4NLP7209Xt72Tg7WwdjizFFXNQw3mdaWif1kzMUYvr7
   iu6g/ZYq00OgGa0+NSbHkX2Fl2Pc1AKKvVGwt4G7O3FR7bi1113VMW/75
   qyNKUk0I1i3zxQ8OBVG7JXDrqUTHs8Nc6bwalaU4BopqrsPNngie/38MU
   Bd1c0R69O/DvW3odt7sMuak0kr4zH9uf7U/9Z5naU7ocJGS1XWd+M3Iad
   yKxJM4Pj+AxWwt+SD8IwDAJevPhfrbJ0nhdWMiSWQcMH6XnyM1jSaOlpO
   ar+RuHShEpwQsHoJNpXlKHGtqLmLOhSo5gihf7wjSTSQe4KUCmMcSBtOi
   Q==;
IronPort-SDR: douor936eSbKSRbAEb4ibiKcRfMX7En7gDhmyug0f8vF7yJUwkhQ4AqA5bvZqYStPHvpiVfiHY
 GGE4QFkLitUYU85akwCNNM9Sy9caM4ncgcw/d/bwQrqPzfLAJ/BPVOXRNEDESeVmiYOoHZtR7p
 82P84EWmZ1UEGWq3QH3JjHf5ugGrDLaLdYMynwhOBV4WVsANQxDu2aCX90BlvyeOKKLjY7u9n3
 PpTXzbaUGlMv462x6QE69Tg1BVM/W/YN8S18/twY5u/GRbT3MpOlnrXOc8xkeXRFY7QxBKMLwe
 yls=
X-IronPort-AV: E=Sophos;i="5.75,410,1589212800"; 
   d="scan'208";a="144906424"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2020 21:05:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1V12c8TBt10cVZhcNeK/VOjludfnF0QKPcbH3CRdpBY/tMB4VY3e029tUMqjIZWZysXZW0cPYAiOGJkp7l+HQ2Zz+acCWUnvhQPJuIbe+zy/kvkmEgb4Sk/JIau5gIuFEANVpQc1SYRv/1fsaJAhieVk8t1dgRyL8hmLoTKN8nY2IVcZA4jDbBR/P7Z+YXdC3OVmkzuXG7v3ZMZ0RNzQeNuFGpySPbb2RgVda+DYrMP+nii2+yBHw3FruHVrWlbV0nqpcaNnA1HvSvL0bTkW4e76BT/fVoXvtDxW65j16F4HTRrpHVxJjZVrUQG9Vvbeun3fWg3Xr7EQPepLaNY4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztVx6lQ+fnOTBnCFg+F9x2FWFE71ltcRyR82iO2a1Yc=;
 b=UZ/wV3ldLNST42QUJzs7gr3XjT3J504t1hMCbbFJyVgrQ3FZHiw7R3JM+eHg3/4zHGPAxj4f9R3VJP+n+Bz8PiQjMy4l3u21T6tMGM61e/tivvOYTac2ieEVGUAEn09FO0O/Awrgz1vmnrqIGcOMWWnHs8EWKgZPQCT0qKfL6N08PhQDn46UNB9w3ZeoqH1tVWxg18DNHya3QdcBbcK1khBqei0NpXX/FoRBS4Y+SRSsPzgd1UdFI9jCAmRaEE+eJC8eSLIfFKuhaDFviotx0QeY1qbxyGMAuc44qr4KgzGPHIh9vlKofyc2vS7jjtMxR59hjErh39rI19bFIdKvaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztVx6lQ+fnOTBnCFg+F9x2FWFE71ltcRyR82iO2a1Yc=;
 b=BXJqGvVg1EvcdgREVWJHpR9EO7rFUnIq2KeTU7C/gL0NcqMj0ZZKYdVY5cqwunW50KuXC7a/PsOj1yIiaR2POy8Vw245ZpfngW8JKvBjDnKAYyMCFmByxh+x0WnAG5+Zbl5m+XSCNH4qDanemI8mUk/6nlf4yryTWU+7JIeJZG4=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4045.namprd04.prod.outlook.com
 (2603:10b6:805:47::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Wed, 29 Jul
 2020 13:05:17 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.016; Wed, 29 Jul 2020
 13:05:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Deepak Ukey <deepak.ukey@microchip.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "Vasanthalakshmi.Tharmarajan@microchip.com" 
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        "Viswas.G@microchip.com" <Viswas.G@microchip.com>,
        "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "yuuzheng@google.com" <yuuzheng@google.com>,
        "auradkar@google.com" <auradkar@google.com>,
        "vishakhavc@google.com" <vishakhavc@google.com>,
        "bjashnani@google.com" <bjashnani@google.com>,
        "radha@google.com" <radha@google.com>,
        "akshatzen@google.com" <akshatzen@google.com>
Subject: Re: [PATCH V4 1/2] pm80xx : Support for get phy profile
 functionality.
Thread-Topic: [PATCH V4 1/2] pm80xx : Support for get phy profile
 functionality.
Thread-Index: AQHWZaWPUblm3Xx2q02FubSeqt15SQ==
Date:   Wed, 29 Jul 2020 13:05:17 +0000
Message-ID: <SN4PR0401MB3598BDE709BF6D6305C78E3A9B700@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200729125050.5821-1-deepak.ukey@microchip.com>
 <20200729125050.5821-2-deepak.ukey@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 22c73c8d-eff7-42e8-ba44-08d833c00a5f
x-ms-traffictypediagnostic: SN6PR04MB4045:
x-microsoft-antispam-prvs: <SN6PR04MB40458D8028486BF581A879999B700@SN6PR04MB4045.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jriIO2nWurcH/yZP2VuPx4dKm7/lYRxg2uqZTajiMiMfOLklve7i/DiuMWB91pUAr5H5XIicjBMSrBy6By1fia8WuTtZDuwFV9Nh/Uo2v2p2dVaZTlOxXyTBJ1mULEsuzr369RP07I+JG4pnxFSI2vAA4yID/KhqCPPi6MPhmUTDlVsgGd7fXtfK0PvsODsvm3/+rvqjXsioGW+GRleqybZ/73p4+iTzR7QkS2efJumlurDQCpPG08lj+kC7FFv861zt58IZrk1QKT96JOKeJVOjjR+c3YCeXdGOBJv33wO2ECUz8QaG+LBVaxEpGzFs2NBnSjeM1lEcrys8WfowPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(6506007)(33656002)(186003)(7416002)(5660300002)(52536014)(53546011)(4326008)(478600001)(26005)(4744005)(71200400001)(316002)(54906003)(91956017)(66946007)(66446008)(66556008)(66476007)(110136005)(76116006)(86362001)(55016002)(2906002)(8936002)(8676002)(9686003)(64756008)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /GcLr+D850Cwg8HmdaPdV98T1ItbpAjnwPGN3J/grNp6G8Wj9QuwJ8uLXqp9Lp7vVHLfRLaRDkTj96Ju/C3bfpO5D/Wc9ipKYMi5U182Hb0oo/V4FwqWhrKa0boGZBA9BOTi6QTy+QNYexte6FrgCauZKDeVetGsVuOY5KxolKAlw0hJHC5pukDANKg3Dy1QZz7K39lYf3sua75Xo/O3fFpzpmZuck8mDrJPn+CYzGQiDTazUN6rVIsSInsOC3IwouFlen7YHDYBF38B5qgbuAP6UieOzJVCjVn2914fH+PFKNwBnYOEYMdPFvPmsGgFIvLisj42qhNg6TgYxnart+eseJvR+TpA8A1iKn3d+aBJalcTq4uxG/UXoXR9fYrzWFu7eTDPtuwVzMitSKXEKNhyRMrkM2GDVHPbAe/2Nn2MwCT+nbhoGTIxloLGKWuLyKTRCmpo0EJEYtxIFhO4wtWMpKnpLzJAt5y6FGNWp2lbIEykd886LXCdvhFbLD5pYp4hqm9CrsHHK/F3+00L9/4ADzMkXRpqFvznBobRLnRT/fZAeNndLhZm+2Ng/8/wc0lu9HWbv86UPmQfZEhdoB98wB2x5+mBYflzXff+gH7CZP4e6VYe1CdF06ZIlT4EiwdeftBSUc/ThBOPgpIEFA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c73c8d-eff7-42e8-ba44-08d833c00a5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2020 13:05:17.2798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0FQX6ClpkxLxN4KX3rRComzHgDBlmE4eV4r325RlA7WKaIKrNOqXNY0uF1jFCKx18nKTLMCkCFhWCF/mr9SJAxX1ugh0+gDLP8eqZpmLLpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4045
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29/07/2020 14:41, Deepak Ukey wrote:=0A=
> +struct phy_status {=0A=
> +	char		phy_id;=0A=
> +	unsigned int	phy_state:4;=0A=
> +	unsigned int	nlr:4;=0A=
> +	unsigned int	plr:4;=0A=
> +	unsigned int	reserved1:12;=0A=
> +	unsigned char	port_id;=0A=
> +	unsigned int	prts:4;=0A=
> +	unsigned int	reserved2:20;=0A=
> +} __packed;=0A=
=0A=
Does this work on big-endian systems? If I'm not mistaken some of =0A=
these will get exchanged on BE systems.=0A=
