Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD99C2D0E8
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 07:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC1620705
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 07:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gRttRzhL";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="J2ihjdL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgC0HtL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 03:49:11 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:37026 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0HtK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 03:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585295350; x=1616831350;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3So4KQElf8n6iZiDQZl0yB+pEwm0dJL4dFu3ybCXiHc=;
  b=gRttRzhLhluEcjyTHZaNEuyVEl+iNsdN8bhoRz6cW/WDhjPgN4K905xq
   a9DO+07G+9bb3nSmhKZs5tKIZtc1JHKqMTWgiMYqFaxwEV/5aOJZRgtkF
   x6rOaLvlwOiYY0R2PvPYL5rkLkImibuDVIxPWsMBW/65ErcriiXLewBpD
   xbqrTd91ds6h+mpkVEafbGz5+lwYEVlzA9SBV3o47RmVGrhYqwFwBVrQv
   nFMQpQn6svA86zQbt4CIpJxeIIp4zvqPTN8dVqJXlUvxo1U/ZKFL/tQPO
   yUDyRMC/NGJ0rAQ/A3TSogWQowD4PpYA0w9Ecl8/Q4U8hCxTrhDp/FjEj
   Q==;
IronPort-SDR: vCJzssId70WsgZUQRz4GGkFsBDr2OGOIqee/oFsSrIUXqYyGt7jl8nccCOal88pnils4ExUTyS
 Y4g9B/z174BMfbyDiyjFpBbFSNXBpIYmKYdmPjKPwzl1+ro7NRNtqNlfoky72+LVGqoX54iJil
 GnXeCnOoB4xLDOhKitB/ss/yg0Npy2s6Rku5eTUtUtRrfD0kW3RL+RaURhYyJduqnIu3vF0o2F
 SKyk08pMoZN0xJXB27RmJ/GvT/rfbCHN2pG2zKgcyT2bi+niSR5jtUupFRqcTr0xD2C5QCR/g9
 uJ0=
X-IronPort-AV: E=Sophos;i="5.72,311,1580745600"; 
   d="scan'208";a="133661378"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2020 15:49:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaY2ERPWZhRYodwlNIviTx9OF4pSLI4Pu9B/gh98LA53aNAkdtkShNhzD13BstHP56+SgDXUFSndq5COD5SzNMzJX17LoUDmF9jtMpxp2ik1hfMN1bAXp0pDIWR7lqryQNwBOvt/yliLltyTaae6bdMMFmvIaASgiiW2LYlYeJMURZMziyuEYBSmJ2Xvylo7ijcqtiZxwNjz6AI74x6FA2pbATRXEqHZWPPLRL7Weq/Bkb7BSule4V1esov9D5Ma0KWaELQNplIb3nz9PVWoHe7kovfEX4BoEehiqJb39d9q8wsbpGT93mcqUGFZ7e4vTHLqJn5eRblmO0iWSpJ+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaVdG8BfpUVk+asPQi8jPX6PCq6mY33ZMSKuN47pNOw=;
 b=jUA++6EY2i8VIJ/bPfBK7Q0tVT8U/aQLc4gakORB1kvScfxo+eZ0d+aoCi0sEJgpcztG9QdPM5Vxd5kDuZmu5YVw0WQ7lXsB3yOkR3Fes+Ftre1h3CcPE9ZxZHxt2mN3TX/UPVGqmKZzzR4lTmQbr/EmVk8Tn1yQc799JYSwcJWHzrl/2hu+QoYG1zpkFYXJcPrmji6erkfAgVQYUZMQY++tRAAGcNt1LM+lYLLu2XWBiJeZsB7yh/pwfKzSD3sW6Y4x1dYGIyqyG6rCDD5h/Rsm4UcotWGUAR+ntsRHcdKvxX00A+galMNN+JvdO7s2Iq4p7/Ykwy+f7iEfULwodA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JaVdG8BfpUVk+asPQi8jPX6PCq6mY33ZMSKuN47pNOw=;
 b=J2ihjdL7T/zsUzH9OA9wDREtaXsUoBoB1NnpBMFR5VQSqPTufy29WH2UPUM3WDrNldIdzpo4+Ob5YHz1MEHXO8aHxeXFYdWCGCrUA5YEcRHhKDXD75bNJfUc+HMM2P54imNRjLal+L/+s7ujhcuaP0yIgeiG0mLnj14im6dSyo4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4656.namprd04.prod.outlook.com (2603:10b6:805:aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Fri, 27 Mar
 2020 07:49:04 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 07:49:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH v6 2/2] scsi: ufs: Do not rely on prefetched data
Thread-Topic: [PATCH v6 2/2] scsi: ufs: Do not rely on prefetched data
Thread-Index: AQHWA+Pw3UJgJmAzSE+5Ajw5XEBLVqhcEGrw
Date:   Fri, 27 Mar 2020 07:49:04 +0000
Message-ID: <SN6PR04MB46402B83E0E69E2309A9EDA8FCCC0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1585214742-5466-1-git-send-email-cang@codeaurora.org>
        <1585214742-5466-3-git-send-email-cang@codeaurora.org>
 <yq1lfnmcxmc.fsf@oracle.com>
In-Reply-To: <yq1lfnmcxmc.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [2a00:a040:188:9054:1046:30ec:e40a:caed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d4d0431-8c08-4baa-7fdb-08d7d22352b7
x-ms-traffictypediagnostic: SN6PR04MB4656:
x-microsoft-antispam-prvs: <SN6PR04MB46567256E7C05186E66119FFFCCC0@SN6PR04MB4656.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(478600001)(86362001)(66446008)(52536014)(186003)(33656002)(64756008)(4326008)(8936002)(55016002)(9686003)(66556008)(66476007)(2906002)(76116006)(316002)(4744005)(7696005)(7416002)(81156014)(6506007)(66946007)(110136005)(8676002)(5660300002)(81166006)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NTvsK5IfrDzvWu5TNzsmykLGuO0p7tSTmDBd1f4o3ikhT0t9hDLbi0uB5YwACOiBQaS9mQe9ZMil6PyQaCAA/bhrmJCZtBnedHwnyr5ieo5+1Y5RapZybNvMka/8fcaN/R+fi3ME4iJyRPqdf/2j/zm4x3R69UofYTT+eibqpCOCyDuFZi5ih6JE3PRNUqzAy7i5BLhMphT9y7aifOhgZMd9AwLuGFbX3kQlMCNZmxAVcYpwBMGp9nGrYqWkhs/gr/qhyCenxEbdharh3lPAjl9ujq8KXQL0kCTrYsxiZZ2OwdcSilmRLCFSimclKfxMDucRcEf5rsVkxrgdAABzY3427iBHXVtYZpnOVFveTLHxhuIxTQwrN8SAVcxCZOS9syeas8QNko4jTjzItU+SznPMeOW5FY285YIq9K0bnuXr2U0d6Lq/faFO82nhsoIf
x-ms-exchange-antispam-messagedata: 7f+PGzVqIQ7xkTOc9KTpRNUcRGY5PgRKbiz7xRqEIJW2oOgUIM9VEV08Od2XOzYJ19VUZmpCIBEbbZEtJl8DtFhxMoscUuZ4UubtdnIk66cNZlhgUsAy1hEwJkie9Qk6LEYtsx5xlAqMZezPqDDuJRnlQkBaka4n6g/9XkH4R57GvY8ODA61CJYAbj77I9qc6RNgFsmo2a4yqrUIk+rgEA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4d0431-8c08-4baa-7fdb-08d7d22352b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 07:49:04.7661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KxJMQGJiTGeW8tlZpMMi7ea7/Gq/gbGothmX58lPz5WT1kQrv36xb/lpV7YcDKXFlCxSbPORbsxpkDrRBe7tYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4656
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>=20
> Can,
>=20
> > We were setting bActiveICCLevel attribute for UFS device only once but
> > type of this attribute has changed from persistent to volatile since
> > UFS device specification v2.1. This attribute is set to the default
> > value after power cycle or hardware reset event. It isn't safe to rely
> > on prefetched data (only used for bActiveICCLevel attribute
> > now). Hence this change removes the code related to data prefetching
> > and set this parameter on every attempt to probe the UFS device.
>=20
> Applied patch #2 to 5.7/scsi-queue. Awaiting Avri's feedback on patch
> #1. Thanks!
It looks fine.
Thanks,
Avri

>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
