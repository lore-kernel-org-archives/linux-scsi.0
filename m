Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156E3C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 09:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE54D2065C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 09:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="o48RXwIo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YvzRHXv0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEOJKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 05:10:46 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3569 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEOJKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 05:10:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589533845; x=1621069845;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=o48RXwIoX6lusSruGxTPucAN63KskHuaJ6+CXsyh2z8lQgvGE9vg15wU
   lRb1ROy0dA1ZwUSmM8Hjc+Jf7PFCSBFXglA9odlP3AHmEAm/zpDQEDxhf
   xvhV0NSzP0qCDmXBMNyxYbhTdKJRW9c7zzLXgfualRdAifUkQWPNQgAIo
   GDgspETwhFJaby3OxiXwBZyNLLQ+5oq4dVRXnx8Z4QFkmTMO3IGio8ndA
   kdwtxxUx5y+v3ZhHxgCwNyQSUu27k9NtKwee8exFvA1EMGCoDw+mF4nVm
   yW5RuC4BI/tF0grakypQy/HeL0sdcDUhmiHeVs6q3HzZYeoGjLc0qXLbz
   Q==;
IronPort-SDR: 9JTq4RKIXR9fgXb/wyr7pCBFaOhLRXyKkli4RtQYQTHDLt4lVmmiEdKJhXXocln65+P+8uPavU
 GRxi9TVEkV+FaukrfCorsiT1GUieMNXM6IqTuiAkWxTXdg4q9NQBQo/vc/gr36qevKqGpMIQMf
 6PIHYbTDnFgzDvbcE+TNogoqgY0fv24Dv4Ln87cleH16I/5kZc7wcklVJIb/9AT1Y4GRtrylPF
 LQepkRgBa85QU+wZMvZUV3XoFObXeeIFwJb6wpP08wgcDizaWbf6tAtfFqZycLmRJslmdt2ZGm
 RNI=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="142108841"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 17:10:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQJM9VNnBs/lf4wyIuUvzAV6Qh5QKasNh+Z5eDpTOUHj4/69eqcrfglrpM98f39NcsiO0Y8UItFQGe3rIfhcqErAXOf8NFLN/Xf7IbQeIZ3NEbE7wcuhzDrsURFWgROvsQmX6Eas5fuSVqa6TjenyYhwCgAZqEGw/64lg720EmYXNigTYb+eVPO0oJp9chkUvKy6904+6ni70rMoEK63B25h41nqM/+CW7Me0pJSq8Gt4UPI7dpYuMe4KYMFYM+tX46IrMsC79nEIpPLCL8+2oVspXtH2Dx8uhTcCtdBeaZuuhmZiAnlgnWX3eiTtiKVC6Wr+boDUQUESF+NF7/hFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=hG4wFubrBHkXPljabtWE/GC0jESuYkpiHwMW3Z6BX8RFKM+ZLdO5IHRmKvB36WmzwO80v5PkDe04WruIgthbXl9UmWMZnoasS2QpJU1TmFPq7gnkh2DXQ7e6VgA3BldiEa0WreTrmiMGA0/o+naGTo0VTlrFnBjr8UwCEUc9AXCycOQ8E1ndTj/4wz0BM8N4A6kLzK+2OdxK5VeeR/6Xfv3FpYRDujQtXN4rmWRP6COrRsYyCJEMumBmpisZFsAKPQBXxWbWBb8J/T/gpdZ5wOekO5imZn5RGKEvvgiYvI4oAJcmfAvzI+WDyFIFjvbzUTFJPoaS22Pb73D+5k+62A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=YvzRHXv0D4lAI5sn+9zi1Q7/QHumDf9A8xjQjOnhd5xsBghtNMrhyEQiyBke0gOHsXvKUS20qtaAhqUa9REZmIG3ZhIa7LA1CtApENnyMPrA+ANdhJRuj+bumbRExhQM8eFREm0TWbqIOrALlZLeTVDN56EBk803HO/A2ntg8Dw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3664.namprd04.prod.outlook.com
 (2603:10b6:803:4b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Fri, 15 May
 2020 09:10:43 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 09:10:43 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Add zoned capabilities device attribute
Thread-Topic: [PATCH] sd: Add zoned capabilities device attribute
Thread-Index: AQHWKnyOs6lOLNtzqkCpmABY3Ic9nA==
Date:   Fri, 15 May 2020 09:10:43 +0000
Message-ID: <SN4PR0401MB35982034A2D5135BF83E7EFA9BBD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200515054856.1408575-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5f40e4f-a319-4422-05d8-08d7f8afd8c0
x-ms-traffictypediagnostic: SN4PR0401MB3664:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB36646AF5CF30544AAB3C15A99BBD0@SN4PR0401MB3664.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIMjL6txwFw6YkB/HoXtASMe+PPjy9w7vRNNNzJXDIkXSBzfhOiWwFC1egEMMNXcgmHzS0mh7genLXX4GYGImHGJ+x88/tROcNpwoVzbkWRpq9fhARuJT48H5Q01u8PMRdA9JWKtWn0iWroSeyKB2gbVr43ELYhbPsMt/amE2uNwQ0UGKjCM/70c+eUeGcZwFK6+9FQb4yu30LVPbVzivc8jy3t3F2jc0LLIHsInEcdE4FdjcW8qUYwGv0gUNW48Rw1iyjg5hUjnm5RudS3D0cAXvAwA8niVbsVANraIj7NWGVND5i7SZ1vE9TToUSibFK5q+QR6fQUL9oCe4zFFe6bmKVi5Y7/pabPg9jkvo5vW5TcSPv9SvZm+Rd7RFEJ616Ki49FvM/jPuVHAIKKFWBTczqRPS1lUzjxetKdWt3CeuARyTZNn9Ak+ga8kNbmx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(316002)(8936002)(5660300002)(478600001)(66476007)(64756008)(19618925003)(33656002)(66556008)(558084003)(66946007)(8676002)(2906002)(52536014)(76116006)(66446008)(9686003)(6506007)(7696005)(91956017)(4270600006)(26005)(71200400001)(86362001)(186003)(110136005)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zs8RUEcpy8zXG3W0dOEDH6VqtG2aIfYri4Ajea57ZGNsAHdZxLOGf433bGV5PXNqdBoH2u6T53kB59JdvD+RzRKKoewWgQjAuIrfw2YaK3p30zwrXoaRs88+RW3uPHR60EYC2mg3UWkSPOuwmUu2NuveV6T1lkFIK+dRwbswYd24vvYRg0Ht3T172spXsxmL1jyWlsGtxKNIoQsKtVCciEmbZmTKig08jFkU9cPFI/B3HkOwAODA+e+x3tXqjpaLcR9NByu+iwIUJSVpvcCiMu2EOSg62xWiNSjyhy2zAXPGTkDkGs+8rTUrJrYa9TnNfq8Ib2JWp+F4kwmBFMh7SnufWV0UPOAXUrKdUeXdo60GsvV6Ec0vu8LCrb9H9Lx+iStnelQQrEW/MGCQmZKGjWA8Hlg9ZO7gHyQtIOaHUoBXMUMOZR8mheK/M7C3J3VxUpaSS8BT2LlaadHtPeeezir6cM/v9BxWqYmuw2j2ybt4kS4KVJCAJLXb2P30sZNg
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f40e4f-a319-4422-05d8-08d7f8afd8c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 09:10:43.4733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CsABo1mCgoeLOdgC0MWXov4yoVBQ+Y0fO1K2Dy+lO6jk6MkvKjMfw//3NHJCbDU6rM+cx4OmKTMpd3taRj+x7vjmK6MZHbpPOuNXzo4Ys9k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3664
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
