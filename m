Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5A4C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 06:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87AED22CF4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 06:59:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="lg1jQcDo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rTHaiWKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfHTG72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 02:59:28 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44956 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfHTG71 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2019 02:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566284367; x=1597820367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aJANKqUA1SmIHR8QQ1Em4J9Z+nl/19AQtn6P7QFd7bc=;
  b=lg1jQcDojKFzAygoCUZxv8iiEjuPWQlp8gEeN8GXrLlLp+6074w74xSk
   Em8jCfYhXOhO/rbEVLFsgJSKUrq87Uu3hcCn+cZCORSnwGn+P0t1LYIU1
   RthjqK+SdIMnCEvX+PFERbOihCC4Wae2dZ0Jz62hKX6ty7mkXI4n25rdr
   E7xk+rzSqy9pekC0ov8jIg1H9U32aktbqlsJmioH6vu77SFrKNjzCwIG3
   pfpRy0f8wI0htTIEocuPQFQFkxdespIKMykADVgE13KUKyjXEC7Zi7Jt/
   egWufNixwY7Zhrr7flPkuyrpQGkCu/YezSEQkCrtJ1FVJuNyW3fEWfUfP
   g==;
IronPort-SDR: 3B5QErOcJ0SiOCBkI08oOYvoL+1yh3L6c86de6Ydx6LtfSTKOy4rnnaMU7++HClkMHOu6b/I43
 RLEu4nsQgdRt5bHouV3q4bNAAWQAq2fFDj9YaBVeBAe9E4iwjJufWurS8YekqxBxFI7SUmWv7/
 I7ZLeKl4G1/vmYjiMFh4PMEpz2uLp1zJ/f7VPRSThXgVJHkSDlU2KU2IVqIVn1yCwIcI1ShtA5
 SbGnanFSO59VHX2yyn70OZzzgUrerk+ucCK1njKAAuum1pqNLhF0IZc7HSfNZ8Wm2aoTVMvPhI
 oWI=
X-IronPort-AV: E=Sophos;i="5.64,407,1559491200"; 
   d="scan'208";a="117143953"
Received: from mail-sn1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.57])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2019 14:59:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULV2mEVyk6VM9XJqVakgnWxufju+v5pZstNqyZgthQc4EqlLhsD3ZA2CoLHdYspHUoGKr7ZNDBQeJ6kRinSym/JOMarFjjDBkcVsJHJSMhBZVGiVwu6dbLvswwuKj3EfHM4zjqwpt2nZZHOrRrf65RZlmMMduO39yZSRGvHLOHrAyIDqhvITWsUk65i/oHaurCpy0iPU+MquS9+L1uGxOTDYKjgkrYkI3EpWHGLMTJrLt84anejr9D4Rj0KFo//ZeX0yp1iKiIM4EOdLv2Pxl9uZ+IvGO9MGNEtZJVRGoRK7mfFsmOyAJpQy8cbj05aFdK15+/v3b2VBPN5HRA1d9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJANKqUA1SmIHR8QQ1Em4J9Z+nl/19AQtn6P7QFd7bc=;
 b=d6OgmjNt8dkQ636JRtbDEs5yEiMT2fTjlGgSUJn9xYN2OsR7bICDkqh2EJbTo9JvMNsNkXQziK1YFlCwelW4cFqFELBCPaRNt+SOq3L0KOiqc9bzniGmplUn8iL5/BL1CAdEAcLivDmBPPnR+P69KHS/J6rYl1ugdiuVIwgnt7sSiDgw5RGARm6ezsE/0YWJ7gBpyo93qB0m6iLiZ1ZAEQ+oZ0pyILP9LMPDDKBQK59AYtSe9YyNiqRxnovrZ871s5ZYSzLRf5ChBP0BG7nI5ZTqs/QMUn/pekpto9yraar+IsqZZ4hK8lQRA7NZv+Yr8LVyd3fRnjPiq2bVrb2goA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJANKqUA1SmIHR8QQ1Em4J9Z+nl/19AQtn6P7QFd7bc=;
 b=rTHaiWKhMM5AwiTc5Q+tsDFVyLK2no3LZkUFJGKWNeoqy9tFpDKUoslhuEjja8MAC8fSelQJ6kfZKHpcS6iAnoizryEWPvUnlI/q6VXL7tlHn9NPJrVXMX2dk2IhiXu1fMBI4uNXfpK1anH4B3+2dxb96+wNe2sL7twrRw2Dupw=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5965.namprd04.prod.outlook.com (20.178.246.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Tue, 20 Aug 2019 06:59:20 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5d3b:c35e:a95a:51e2]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5d3b:c35e:a95a:51e2%3]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 06:59:20 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>
CC:     "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "marc.w.gonzalez@free.fr" <marc.w.gonzalez@free.fr>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [PATCH v3] scsi: ufs: fix broken hba->outstanding_tasks
Thread-Topic: [PATCH v3] scsi: ufs: fix broken hba->outstanding_tasks
Thread-Index: AQHVVpQbxg4blIrORUGV5dAIJDZTz6cDnA3w
Date:   Tue, 20 Aug 2019 06:59:20 +0000
Message-ID: <MN2PR04MB6991207C24518D8878CBAB5AFCAB0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1566222208-19890-1-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1566222208-19890-1-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0d00bff-8a3f-40cc-1a56-08d7253bed36
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5965;
x-ms-traffictypediagnostic: MN2PR04MB5965:
x-microsoft-antispam-prvs: <MN2PR04MB5965FA1706002CB707DA0291FCAB0@MN2PR04MB5965.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(189003)(199004)(7736002)(6436002)(66476007)(66446008)(14454004)(305945005)(81166006)(11346002)(446003)(25786009)(4744005)(229853002)(2501003)(8936002)(478600001)(71190400001)(5660300002)(99286004)(7416002)(186003)(6246003)(52536014)(86362001)(74316002)(2906002)(256004)(8676002)(76116006)(55016002)(33656002)(53936002)(26005)(71200400001)(102836004)(76176011)(64756008)(476003)(316002)(54906003)(2201001)(9686003)(6116002)(4326008)(66946007)(6506007)(3846002)(66066001)(66556008)(110136005)(81156014)(7696005)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5965;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0O2TfFYjkjwHTQTK82aRDrxqUjMuFaR7xfTK4qYKdL/m13mVWRx/CMhyZjXsOpncn1YgQzEdg7NWvvaqYkO+KuFhQDhZutFQT/FX4tHYHDhlU5ktnRQGpX8WGzVPca3+A6xfNWPEEUFPMCihHIwWxZ2aZDMGEK/alxzYOSwS0mP0vr2MhkSKqvbR5joNidHl8KpWpymALcvYBFdR4d8/lzS+lhel0Pd5H3t/Qo6b3Oi8UFEjmAJWeGBGBQ0ZA/7NWDfeiFfYptDn5iT50n2DcPWSxPQQi5AZ9i91x2MdV/a7UZFe+6zErmeQ59hZIXZW5aJl3d2BwkUAQA5nwR3a7jJY9G5a3x4hsfGlDNTr0XgeLRKVqmoIL+0lVzGVqxKVylFhYBvLbELC60dQgWs9PMynoMGF4S+WnVL7vOmrGQ4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d00bff-8a3f-40cc-1a56-08d7253bed36
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 06:59:20.7156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bTUJidLFCGVqjb5hCtHvnMIwiQO7stpqrnufncmDE/q0csurZoM29EAhN2jOXrAKk/EwRU+SxWUcFwoc7XwhKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5965
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Currently bits in hba->outstanding_tasks are cleared only after their
> corresponding task management commands are successfully done by
> __ufshcd_issue_tm_cmd().
>=20
> If timeout happens in a task management command, its corresponding
> bit in hba->outstanding_tasks will not be cleared until next task
> management command with the same tag used successfully finishes.
>=20
> This is wrong and can lead to some issues, like power issue.
> For example, ufshcd_release() and ufshcd_gate_work() will do nothing
> if hba->outstanding_tasks is not zero even if both UFS host and devices
> are actually idle.
>=20
> Solution is referried from error handling of device commands: bits in
> hba->outstanding_tasks shall be cleared regardless of their execution
> results.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

