Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0D9C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F5E206D5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aizv4gWL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JPsiNt/s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgEHHmI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 03:42:08 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:59139 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgEHHmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 03:42:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588923727; x=1620459727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I37AgaRdpjbs+nxjHGbDP0sZ2qQFxRvb6fyyt1mYazo=;
  b=aizv4gWLhDS370l+gj8gEMW5eFAPckFpfpCAG6Y1ueDd6/IA5TAXrFxp
   lFPy7zECryeR+VZnnlClKZCbygyasiEfyj3YReHQGcMBWA+ixL75YN5J+
   8n5W+oV+k5HegzX65oUqa9KRJ8ZPvfbw3EU19UykAW8DmvFeDVwwLW6Wp
   SNn51HcpAuNh3Xfx/0acGzeqHCLlXu0vDn7pcB5qKKpY1XUg3S8kyYxit
   Lx312I+OHLY4hJph839xLLMZasIBEAOAFfdlAZC62HwW0QolzaSXXNPhR
   jTgOdyqelUZlLcXQj6Vv9d90/Hd9JvEcZPg3j0W+UehfoD4pHgrsYAvZQ
   g==;
IronPort-SDR: v5cUdVYlXsm6JbbwUAuEn+ST/kVbT3WyoDm6mJj7UB5LN5xEv7LN/Ris9c8+ivD7+7W6a+xA4C
 GLX2oX4DNlVD+q7JiPM5qCfZXuOsyA2Wj7M9A3Ge6s7nRG26n40a1NiahI2CDttsaSMNAXAnbI
 2H6vuSIGd9Swc9mOm0jt2zqko4agVjGlZpa59Gie8HsfJDKwNnRlqTalZcK6AQUESRLgMyV0g8
 4wnNDnNVvPXyLU2vi9e8GztMVxmQIYHFvRDoYxPCfADVdYZ8yf187QwIHjySjfMWYjlBPyMfiV
 6mg=
X-IronPort-AV: E=Sophos;i="5.73,366,1583164800"; 
   d="scan'208";a="137546072"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2020 15:42:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDI/fpAKgBMtYG2hX5siiP/m9dUwzW4t9BNUeHreDSIcl4I0VfwHzewnnRLlpe92eXuRjKHmgnnY6AKJ16pypkcXNmi26CrVFJGC5TNJINTAYWYtIfoxNQaXSawj7LZrOQ3qo3XosFTv/r6TUII0dvQoBV2nGIvah5BiU+pYWT40Md0Cc01VpNk4w43Dyi5hYsHm0MliEklgHjc07SlX/MZf056dGIDmRjEIry87sEJwRaIAzOQcVl8MES9cQvEFLUTwnAjvccJVG5uWtAGkewXu9gm/56/xCGvuIFI1fGpAdbtRw4kbcmmd95qsMv43YWAutTZt58L6C1obZHLIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI4rR2ix2q82q3FwbT5MS+j7w5GRAA+rCYccx2AkuBo=;
 b=Cnf0itkomUIQBQ9XHm5cT7HRghV2zPokWvdC/P099xudFoV1+6nMUSzOgo5H+IVnN8Yv4uLh1BpJsN4akxNuY/t9+mgB+JqjHnkpI6qOHNKeyutTi6ZKmLuY8M26N1riR47dkrSTxNaqBy4Z7vm8dSVhBvABe4YqjnW1Z5dsWrsxtozCKvIIyowpv8g9fhLnspdvwDG+iC8x9qt9opzCvRxFJ/+IDOg8oF7FdxPmE2VlKhw2pMRgBp9uZ4ztIudS2fdOejjtCtEb13112TuqRdrR7YZdGabx0Pf8yvuGaLxid4kTgXDzwKMgCMTXCiXdf9q9GzF7o4zWh/BfUZZtTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OI4rR2ix2q82q3FwbT5MS+j7w5GRAA+rCYccx2AkuBo=;
 b=JPsiNt/sPnj97+jrrWZ7Vic5npVADZ4QZoVZxH9eawN1ljp54BC/YRLMi132bhVHqNFZWRnjPY+u6+O199B0IlXRgsQQ/HWAHOZo5EnGPXQC+mxNth3ifFGXG9HyNiHXROy5NNpp3y5Vwl017DGvg58uwDWFMkcmhNln80F2PPo=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4160.namprd04.prod.outlook.com (2603:10b6:805:35::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Fri, 8 May
 2020 07:42:05 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.032; Fri, 8 May 2020
 07:42:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v7 3/8] scsi: ufs: export ufs_fixup_device_setup()
 function
Thread-Topic: [PATCH v7 3/8] scsi: ufs: export ufs_fixup_device_setup()
 function
Thread-Index: AQHWJN9wfVRdkxFSx0us2APo8GMGyaidzbPQ
Date:   Fri, 8 May 2020 07:42:04 +0000
Message-ID: <SN6PR04MB4640777E2AEF4A77A642B81BFCA20@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
 <20200508022141.10783-4-stanley.chu@mediatek.com>
In-Reply-To: <20200508022141.10783-4-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2ace9186-ff57-4f69-4f12-08d7f3234dc3
x-ms-traffictypediagnostic: SN6PR04MB4160:
x-microsoft-antispam-prvs: <SN6PR04MB41601E6709F207164F35EB7AFCA20@SN6PR04MB4160.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SzoA5B9hh0q790wd6hld7tPzLUz8lgLsHs97O4KtnZIJSJW0EEe9d3buXIzPz9tSWdD14RAidQ7fLr0guOI6YtTOK1qpBOvQvhMOLg8OOmAEj2QYtxZOTFRrT0Ux5TPMV191X54N1QytlxYnFilCaUTTtN2Ji2zLI8SBherdChBNe8rCgNYLrOGqXnz7fuoDFyfiRreCZRAhLT3vbY3eZA4YlZb6W+E8gsYPINcAldBMS3RsQ8tM6HZ5RnxIMWqDzjiyvygAUGtT1u6C36kHNOGELg7XgDLR027Bt6WVIwhbfd9xIm4VYtajBGFO2OWD3oeCbPSJoKhfAeEnzoYYUg/HgSU44ciL2Rih4DOmY54wBMxbe1RRriFRr4g4E/R5JISlbjpwWWKUpEQXh3jmSFJQkVnjTiU5Zea+tWV3Uq5O2cqsOAD17S0gmK/s8ADKa3FEtyIv4SSiVeA7f+KSAyljzFxTBUsqvwRIrHeKrneNJ7UohNfCvAPC+6+KpkQnwBl6x8a2B/OFvEwrVM3EqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(33430700001)(33440700001)(478600001)(55016002)(83320400001)(76116006)(8676002)(33656002)(5660300002)(316002)(71200400001)(8936002)(186003)(110136005)(558084003)(54906003)(52536014)(7416002)(26005)(83300400001)(83310400001)(83280400001)(83290400001)(9686003)(2906002)(4326008)(7696005)(66476007)(6506007)(66556008)(64756008)(66446008)(86362001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: EwL00SeaswEj5gPo8LIgWFieybVq2HGIZqDNIlGwg4SdPCC4YfrZMHnXrybHzP3+e2jVKmQuioVcvKjusami706g7e7o9gZeXMALOnzq1iPn8AeV0u1xcHCCjmLJxJl3K9oiC+jN+3Zs7osOj+O9uTuRKXHWnOTLM4++4PByGJScgk6CNSLdhyFEWzN794KHuhXd3QZX5NhOYmMwJ+7keG3yhoshjdJiAhh+Vh25sKxihKpnmsiEvrOTuYehNWi+kLnGDQM0BxACyM+b4AqpsS5C/j094Y3B5K5scCgvMntjQb6PV4LfHHcT1AU+lKXIHRDxXscTA09oWTFWP/tKfYT6LhiegnKrNX5bbzlva9bbhSdqkyPXuZsRzNaZWcfozzgDPoGeOP12A2t8OBkMZHi7mPdRo9Wutm5SGTyRWkBla+Jkb+xWQgjFq8tr4Q9FZljtfcmVg49zrS/NBAqrMRYp29x8pDKuKN+zFSSUPRs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ace9186-ff57-4f69-4f12-08d7f3234dc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 07:42:04.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lfgxevXsjmkeYOr9vA3xkFTwczCf6HANctkYezQqr8cvTuei36Q0iHWKLppF+b+R1IA1VQ5lFwnwWbiWKX3D5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4160
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> -static void ufshcd_fixup_dev_quirks(struct ufs_hba *hba)
> +void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix
> *fixups)
>  {
>         struct ufs_dev_fix *f;
>         struct ufs_dev_info *dev_info =3D &hba->dev_info;
Now that you are exporting it, maybe return if (!fixups)?

