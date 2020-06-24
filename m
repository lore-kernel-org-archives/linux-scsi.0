Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1369AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF9420874
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 07:45:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="HK2lyddy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LhPHMZLM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389985AbgFXHpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 03:45:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:34517 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389943AbgFXHpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 03:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592984740; x=1624520740;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rrObs/dBHbqGffdvkmTOCejnu9Ox0fFcb+SygpbTTGE=;
  b=HK2lyddyujl7Zup+rQes4gdAwQ40z0xS7IBEX8ODkHfNpPzscmQbs1qt
   yg/HFj1tTGadssGADMmrYCG2+PAJ4rlffKYch5eQO4UpP2qEA8o1aakED
   MXuLPmlFbsOwNL37l1ar9B1Gjb50AhvkiOqjBfIEuqma6aiYu1eGSDO2H
   RGCTwbiC0p/FOXtyh1f/mtKJn8gXB+3HowTm2QisVSYbsCDzaf+2cATNJ
   Uicumd7xQPJid4YwssipW0Z4QOpfhOnqjZ0EaDQ8GX37F2HE7voC0BuOk
   oOdPSaX+RwmsIjTLo5YX0+pTBdYkHGeeCOAlhSfz11x39EIFIYlmaOe4O
   g==;
IronPort-SDR: n2dTaUsEPZhe9+qXSOje8x97gK8KGXvBJ7qQm7YtmAhnUdtHpoLPQ2W5kxlXJiq4p86KiOnnPe
 l0QGtxXajSmtbfYFyraSY0DY0fZ76aFq0nlVSagSQl5txaTFnj5ZZm5GEC4g5LQGL7uJNrFKY+
 cv0EVz0HLnNNU6gP0GyucSnvmUOdqBCQlb8Qjn+PFqaXBP1lzj4rHIAh4NdXNfFiO3+RFYIDDP
 DhQvFxF+NMeKtMGHA04yieD+c2lMftGzjvQWlCReNjdwUQN5EwnN2jXHQ2cW7hXvdDYISd7n7y
 93I=
X-IronPort-AV: E=Sophos;i="5.75,274,1589212800"; 
   d="scan'208";a="145104012"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2020 15:45:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Avi6iyoODbf5Au007ffq/ztcNR2klMNvJUnZ+McTSyJ1vc/TiaSOaUD6x3g1W5JxCv8bh6ITEhVk2GjjMISLQ1MF2+kn6eDHA0ecxT+PqoVpTRAbGd+57phgNqSQ7Qaoozt+gvkUJ3eLzRbxHw2UtVJUVPwNU4tK1kUrApdcUtnVTbznWBfcwwueu6ew0u3gN+KDy0aa5EK4XSfOVO5SDxRfZqHQG2X4CkOxtIXcaIKDR//LoXKp+kS/8NiIRxtCOTnNbABAI+Sf2cdfQpLh4ZuO8DyPHKa+Wa+Dx6gQX4LYXWMIPQ/5fWqYwwqAr1u/g1zlTGFppDECjubnTNIXeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrObs/dBHbqGffdvkmTOCejnu9Ox0fFcb+SygpbTTGE=;
 b=Moly98+BqIKKTV8uyHIyEBegUzHCvX/YhcNyuPNWmfECxrYaG6dsPb/rkVaPjgVmR22gDMPGua3i8jBFE5xY5fZgsu4gGlNWPYhApMSmAyXTWUklefxDEZCMR8Rp54KYBj7raV1+H36tRWT1JnvgM10FQ1FqK4kVNtDiGHWwlJj06t2GS0xHrTT/qQinJA50HwqVEVBdK0EPhCdAMRxeqoE72DvC0wPKVmBT6qtQbrKeFmnY1Knqzdf8wTardx/hlhzt5pZ/LDrkTlo6WQ7Wj5UX+kvVTkYELKj8w+T5IHL6j2LcUkTlXnKcRlBLOyVHkP293A3zBc01aPDDNeUpcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rrObs/dBHbqGffdvkmTOCejnu9Ox0fFcb+SygpbTTGE=;
 b=LhPHMZLMD4il+QI7DRxUdQBAbye+7eaINYuvf3trQXTMrUZlVOjb8Y0GwF7yhUjI3GIGVlUS+TEqjQTY6AsxEV2lojeyy7v7+lnmhEh61AX9eHpcYvdb1fa6WTxd2+KJoaRvVE59BmIWZ19p9jGT1hNJ6YwC/8ZZ2q9x3+3Fsvc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4079.namprd04.prod.outlook.com (2603:10b6:805:46::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 07:45:35 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 07:45:35 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
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
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v2] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
Thread-Topic: [PATCH v2] scsi: ufs: Disable WriteBooster capability in
 non-supported UFS device
Thread-Index: AQHWSfrb2VNxrH8GW0ecuB7srIZUBKjnYp8g
Date:   Wed, 24 Jun 2020 07:45:35 +0000
Message-ID: <SN6PR04MB46404FF761B807EB6453F1F6FC950@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200624074110.21919-1-stanley.chu@mediatek.com>
In-Reply-To: <20200624074110.21919-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4681a5c6-94a3-47b8-1b11-08d8181294b4
x-ms-traffictypediagnostic: SN6PR04MB4079:
x-microsoft-antispam-prvs: <SN6PR04MB407992F28F6CA76B70BD379DFC950@SN6PR04MB4079.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8JbNc8o/gMhA2Ttp4kSQ+6f5PIh4hY401xUFPqjXk4xK7OUE+qF4IX5nAqTPvP9gN+iy2Dcin28a98V6VkAkI898VEPhF9m2DZfca4pDNiLbUnVIiVmQiYSxLgGPgF6tHBRPL1BsYLtSjMVoN1B838HJI4xREmsdcn6jNrux0rPYHXesT+hpIpmR85K9vwwjHkZarrBWRIKI+MhqkoUdGo17vhjQcIbdn+DxKD2kVGLQ0LqGtn6up9fOQlhEhhA4SLNqCFDEircCBCZWrqhjdKO+TOlQOGxw0X1X5BSSQv8On3BSCM3n5NKtf72flpp4Fc1cn7wPIaQhSPHWjMFqDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(5660300002)(8936002)(54906003)(110136005)(4326008)(2906002)(66476007)(66946007)(66556008)(83380400001)(9686003)(8676002)(64756008)(4744005)(55016002)(478600001)(7416002)(86362001)(76116006)(186003)(33656002)(26005)(7696005)(71200400001)(52536014)(316002)(6506007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FGcW+Nn4ACXvkwA78J9KCOkG2zk2J+CoIuwuyKFaRM9Vqceog5+C2LhHMQnFbKx+uuC1cB+596s624ezgVmHxOD87Ojd49U7WAoBBjRXWCp4cCg0UNYhQVnmWMHFWjwGSyC+eSiODhgYMESkn488B5yaj1up22/Lev24YNsrfZ3zHylLL6l8j46y/6UPZhxpCVRVzaYy3pJV6a0TrzudPVU8GqjUDkzjhSkX5iNa9xe/eZZa30uSL2jSHJjrPAq5JfULN9TSuus0e4uzH8vqDcAtmVlIkr6op2vjnuoAOO/718S1jphY/DZ0FMblKGW6wS0mDpEYhT2L0cPCf54t9ut3BJ051fmnRpsbP+Ay1eAfxBTaV5J1ArGt4SFnykPgQzKqBB27h4HSYwNBec8Ekcppe/JxRRDJj1fuyhUdDjCWBZDFs2ihLhoo4sKJd6085PZcOZGEEgAHvDW9MRSw1sklTTTrcanmIHSZMdGX2Tg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4681a5c6-94a3-47b8-1b11-08d8181294b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 07:45:35.4535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfelKVxctygHGNfuGSN4lNAV7lW7aa2/0Y03Um6Y4OdYjYVJql+j8pqTzNW7mJ1LGfoLgg/mjQY/DaaA3wCffg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4079
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> If UFS device is not qualified to enter the detection of WriteBooster
> probing by disallowed UFS version or device quirks, then WriteBooster
> capability in host shall be disabled to prevent any WriteBooster
> operations in the future.
>=20
> Fixes: 3d17b9b5ab11 ("scsi: ufs: Add write booster feature support")
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
