Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5554BC35656
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 15:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5412073A
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 15:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IzElhE0b";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fRcfF4f5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgBUPdz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 10:33:55 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48170 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727312AbgBUPdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2020 10:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582299235; x=1613835235;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=cNe2LmVzr4ZV176LN1dAUXmYYmpRruF8M5dAxcL9xM4=;
  b=IzElhE0b8Kmq07zrRIEQcJN3ZfjGF01pWEbUF7jghUgil+ys6X9rR4q2
   cHJYW4hoKtj/s6BwfMIE0SKLz2jxCsyTCJeUwbSmmYkpKtrb7yqQEdww4
   xEXqA/K1Sg66GaWvl5p7hrzXorCR8SWjMPjjLl3BtufhyfutRBuuTKdrL
   9QYf6PaFiijjUIiSnqwsISCvSygK+G8Kawdt72nd8qnUfAhYw6+J6pP+7
   IYCWVYUKLSqVCDCWZtLteKBehNuJy1BgNEjuAsNt331QnNHBQFnAD0yF2
   WsYEkG8JRIOnlHDcaanPNXUwNNnUbgZWAmTga3sccrLgB0jY/IG7NBuOR
   g==;
IronPort-SDR: NkcNXYeAJE9yjZA5s3nv8NxRevnh/ZtV/zhUkI1VyzJ4/X3ErzbneC1FBvp77bKzCiUc0lv9p3
 KLuLS7qHaguNgq9cVrHDkzabiko2tp38HyaTGuSkAEi4XCvLLziFTRAre4ZZtUYjuyWSkmOhEb
 YlYoCqnuKxTLt4WZoVg/Oc/eFqAvNtWgb2ma9TWebPU+9occlxxVDmF8vVCJY/HrOFR+/qLMBN
 usSqxXiTAQ37IpdhUJqtRcphInGtaYnAjwSZZlf45ysea2e6j73cAkwmRLbVl5gPD3VEubgsVz
 LZg=
X-IronPort-AV: E=Sophos;i="5.70,468,1574092800"; 
   d="scan'208";a="134762427"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2020 23:33:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oo14jLDfFHNo1F+nkgekglFk05uWMxFkLPPDhmPORhBXpBB72FU0VlVXvEs2Oxm/v+jRFJZ61TcKOewSdtX3SSI1IBqtwANsGypDypw/JE5x9aqHKXBOHGPzr8lT7jgnJPlY0V2THc12TLzjeW67AwbVzSrzMRI5Rezwujn2PpMvxoQUw1IHMT0Lrhmxm/+oD8PEz01PsGCdXNHLOI2sqdzS67lnpcNCCjGn2Bz8iZboCj7uyttGhA1DmAcCK2+jWmwejA5+MYTNQ7h7MPFCeqlsM/dUgHKppPWrtProLpq8uWHyVpne9+2tTfg+rOHaVumDScEa7R+S55WDkjVkZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kTdH0cDRGM8IxvztgE0fLybdJQFVx5/BfmDzapV7r0=;
 b=WOr9GK/qJbVzj9u4keyOzq5FrJv1wb7sENH+k2SsMQDREToGo6hKhfMiidB7Xei278XPIDFY3t0/iMx9afTZEDX1RDYx+E9T5NoQecP1/N4Ja1F1xoaRWOSmSBEYP6bLqT0o3+Qe2Yc5O72NUaJ6c+D9FbDydXRpMuPtPb0vVPWw+NG8dEQ+KE7CVGy2MRKEwbwShXzeS6CQDQjP6erk6PFJM2V2PkjQdXjs52lp9BvYrGH52wbrXUca0VxVNrYQCStj1rTc9rPtAzno6P3NAY4LmqijnlkCOqOhNneRGaNliQIyw0bH18t6m8tQkHDX9x6rqrNkThLCvbvSDZ2KmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kTdH0cDRGM8IxvztgE0fLybdJQFVx5/BfmDzapV7r0=;
 b=fRcfF4f5NYPJnmmD5zlSg7Lra942A8Essp3ujxlCHN7uvtKxdQ2fqGQvi5Z+w0vSLimkgHwkaNNYccsV7b/1dz82Wfril+pzIWg1tnB5HpnUyxy3qoW5f7Zo6oZWMfOVHNwxYV5bDDuiZMirXjoPw5hTRI1ad0OFefBwP0FnmVE=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3517.namprd04.prod.outlook.com
 (2603:10b6:803:45::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.31; Fri, 21 Feb
 2020 15:33:53 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32%5]) with mapi id 15.20.2750.021; Fri, 21 Feb 2020
 15:33:53 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd_sbc: Fix sd_zbc_report_zones()
Thread-Topic: [PATCH] scsi: sd_sbc: Fix sd_zbc_report_zones()
Thread-Index: AQHV5u8mtLDHoG2CaUuquQf370HZOg==
Date:   Fri, 21 Feb 2020 15:33:53 +0000
Message-ID: <SN4PR0401MB35984CBF44735A92BC71B8339B120@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200219063800.880834-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cdd69259-676f-4146-7422-08d7b6e37530
x-ms-traffictypediagnostic: SN4PR0401MB3517:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB3517D97660AAA3AA4057098C9B120@SN4PR0401MB3517.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(136003)(39860400002)(376002)(366004)(199004)(189003)(64756008)(76116006)(33656002)(66556008)(5660300002)(110136005)(8676002)(52536014)(66946007)(66476007)(316002)(558084003)(91956017)(478600001)(66446008)(55016002)(186003)(2906002)(9686003)(26005)(7696005)(71200400001)(86362001)(81166006)(8936002)(6506007)(81156014)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR0401MB3517;H:SN4PR0401MB3598.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1vHTwi7jdX4py1ok+BbfPwL6cGI2LWKab1SY1KpEvGXoKA2vKqMXHsWRhEqaI5LgIwkOw2DcgHMy57EFiGuZdvl4ivL0LQfT7iPvOqI+RRZB21kGUvaM1EUYBK4253sdcaElXTJW/WRjAJ8U+LjyiaeBZqTt5eN6RdPj+6dDGPuZFb9s+E5qddZkfUN730nazxcFSSBd4WuA9wB7KgahrqSEzElItbD/Pi4/NI44UpQ2FNPQy0YF0cu8umi7G4syrO+xchGAcMEfEEpDnaY/gbt516wPCN4kCSvzkCaFjMbwg/kVfqjXee1ROIXc/Sz1uA/rzJg+PKzx3C2VhIVUWik475Iefxy032hV1BaJpvRFdmknh9vTcqLaXru2FsDmqi2A6+PUTLoSxxI0am7w3GuffqwmvNUQoHcQJENDEKeCdDChHjZzRPRJ9u0xoB70
x-ms-exchange-antispam-messagedata: tSOmPZvVzWOw0mLYWQgdiTzsaPqLe5JfTHO0adjir0872XGbFcZ+PTMyn7k60eSJ1QAaXP5KlfLr+12WH5Xvt1E8/WMsJmif/EQCUFDBtvH8MIJSUmLXUUjB2mb8fAWrq3YYAKmBXU8lw0NbAvYuZQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdd69259-676f-4146-7422-08d7b6e37530
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 15:33:53.4256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f7nFjKEKkYPIHANBCIFfYloY49UF3Jtw8m3tmX/URHJxKpuB69kg4CvGxweIewAMw7HFPyiv1BqHQ9DYlhhaKY6DKlfkykvv9Y78b3aLkSk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3517
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/02/2020 07:38, Damien Le Moal wrote:=0A=
> Fixes: d41003513e61 ("block: rework zone reporting")=0A=
> Cc: Cc:<stable@vger.kernel.org>  # v5.5=0A=
=0A=
Double Cc:=0A=
Otherwise looks good,=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
