Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24870CA9EAF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D170520856
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 06:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="S4RDPejs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="NUmVrH6f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437707AbfJXGOX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 02:14:23 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26059 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437704AbfJXGOX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Oct 2019 02:14:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571897667; x=1603433667;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=iL/H3CaIegdncNS2TQFn7Arc/yycP6c9sU8QHYKA81I=;
  b=S4RDPejsCOiTQ4QIbPrG4/JL6v/qYK5ZN7IJ33qP7RH5L6nop9BeVexa
   lz4TtL8FJsxBSmX4rDUNocAg15kvAjFtrws5k5y+zKlXmdG2j2NMAW6iU
   PV4Js8MLY9cNWgRSCrLqrbDEJgWqRkoyYuCc4XNeHhCLnnOFpGgTT0CcA
   Jy0E85fWLRjChkShFPwTS2WyOPiZu6gz2HHF/0T2zGo/WQYG9XnEO6dyx
   fzorOUGSHZa736lKyr/+WvwvDM1VfSsgJWM9g7aVq3BoaeewmVlrr4FPW
   90lv+BD8QRYsUNbFaUtci0mGVSmioDTWrQx/XcMT2sWoVJHtOkAPqfeuc
   Q==;
IronPort-SDR: Jy+g6cjFKiWFbpg5zZLvqAiRaD7/BvLqMveFZe5Ds09z5qXnwRgd3sSCtFZiJyzZgySP/4zSIc
 0IgF5itExQICCpFQ8XlcwhRNOC5dES4of+axLFKDzcow0FLfBl+vO74NXR4eJS/rEoO0pkGAQJ
 yComPq1FerPJwConh4w6fq+vhbZ5WYCBoBtXmqkWbKs8i7fC2ipT+rCNN7TWayCuhvQyh4esHa
 mxGv07b5aezl7gKKEH+5eMdrotehJhgNk+klqeHTfCJMdw9j9KiJikserj8nxN90s6oZ3RJCJV
 aUI=
X-IronPort-AV: E=Sophos;i="5.68,223,1569254400"; 
   d="scan'208";a="222335818"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2019 14:14:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZluoIAOr9Dn/zOyQpbW4b0aN5KW0tvauy/XE5OtMcQKpG5Ymuontno86M3qio/fSzenIGXj1pYPB/SnhaAwQI6HXKCJFlprS6K79MWNSR3Xd/c6aqyRsVAfEb0ZLDoLADpfARwqlRj+k78xlQyuZK4Xuq9e8GoRY9+/vS7RyfYhSk7r19BBSmXFORd4xGNh56YBXfs1siDC6of8SB6jnJjhSTLwIIht+xoqlhhUDY5bzNtMJ/VuRbmHk4L9ETiXGowUX95vSOAFvB5HoE6Z75BDk631oqhBnaYHryY17qTumfWpfSgmJqCd1g7poto7v63M93eVTIkdnZwJ88dqFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iL/H3CaIegdncNS2TQFn7Arc/yycP6c9sU8QHYKA81I=;
 b=GWb5uXgx5Nsto0GZEQI3IrsQ2eA7T8I9vr8eWLyBjLNceitb5UTJyjl0xoPMwJjc9UGg0IvrDvCe6HTxvrH2MMo/IY8XWHCSGYAXc98sUghuRDD9nKmMFvsh71iK7qyYiXvfLryxr80G2lvxYRoEQBgToICiQQVUWNpTJvFZZ8L0YBlEf6LNht5Tpn4dK6nx0WHH6rBKmIBWs8qy0rNKG45hCpVruPA65KXqzrmDWJOdp0AIJY1wuoBD5BrUqFjkXUj7seicLwrl4djVEp6mW/cNSwnAdqRv6kqs5en3RKRhADsKhVPI3REY1lP3VQq6JPwNh+c3+C8lRPEJfj2jNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iL/H3CaIegdncNS2TQFn7Arc/yycP6c9sU8QHYKA81I=;
 b=NUmVrH6fWIggYGHCslnPC74G8Loq4Bc9Vve03yfWhPRG3U+xjNpHv0LRIjEnuH4ax4iucUAVNPUC1l7/Pp8qBxNyAPdz2zvE5jAURinlm11loZvxaNQhFClXNPNOAw7tA0pGQWiUDeFktQ89/SgKceAJRF8cJGODLc0g8xEYqGM=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5677.namprd04.prod.outlook.com (20.179.21.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Thu, 24 Oct 2019 06:14:21 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::cd55:cc47:e0ff:1604]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::cd55:cc47:e0ff:1604%6]) with mapi id 15.20.2367.027; Thu, 24 Oct 2019
 06:14:21 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Query: SCSI Device node creation when UFS is loaded as a module
Thread-Topic: Query: SCSI Device node creation when UFS is loaded as a module
Thread-Index: AQHVifzRpAwu/fFz+U2OK3QfF15SV6dpT1DA
Date:   Thu, 24 Oct 2019 06:14:20 +0000
Message-ID: <MN2PR04MB6991BEE73A39CBE013373CB9FC6A0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <468eb805fa69da76c88a0a37aa209c7f@codeaurora.org>
In-Reply-To: <468eb805fa69da76c88a0a37aa209c7f@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a80cf45-4be4-42a7-dd69-08d7584968cd
x-ms-traffictypediagnostic: MN2PR04MB5677:
x-microsoft-antispam-prvs: <MN2PR04MB567734F5C421036FBA5F6611FC6A0@MN2PR04MB5677.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(199004)(189003)(14454004)(33656002)(316002)(256004)(8936002)(66066001)(6436002)(66946007)(81156014)(76116006)(8676002)(6116002)(3846002)(66446008)(110136005)(66476007)(64756008)(9686003)(66556008)(81166006)(55016002)(186003)(25786009)(11346002)(446003)(476003)(99286004)(305945005)(6506007)(7696005)(5660300002)(26005)(2906002)(7736002)(76176011)(74316002)(102836004)(52536014)(478600001)(2501003)(86362001)(486006)(229853002)(71190400001)(71200400001)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5677;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wfl1RnRmPJ1o0TybPqvPLZPukEDmlWoNdavbZvXVEPVHpXmWOT7RuTU5eYbIvVKFknAa2fbMfE0uy2+HlWSIKAWQzSpiAL2td9qdV/RVJ1eKHbRO4KLgZY/5GgwGiLdM5w72w4I4iFL6MMA+W4udhCtWkgbyMpgVIEUaizewjdduoxyixlAOzRfeew36rLWKi9wKkmKglxB6HyCmm7l5rH7ZCPMABjaX65IfLq/GYaKQzYJrU7rMysNC92U237Mh786QAfQEEsstigMSjvatmyJ+zkPm/oEEVOq2TbbmxiZfeR24X1HsQ9acZUrnJaIGHFA3Thxta5e/TBex/8R4s8QIoacGc3GLHvzEffKK870jEd6CB/QJGVhRm5/H9z1N0LkyIzVwgQ9pUI/5qH9WlBYhEi09B/hsiD+GnQMmrYiU9XcD+Cc4Of/WnJ1Pigw2
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a80cf45-4be4-42a7-dd69-08d7584968cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 06:14:20.8103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DK8/qrMKX0T4ScHNl/3BzBWehPlDC6cW8dBde/aue/wAMRjJcV8E5YdjQyQWbGsJ6Y4AxrmiZ4ifGx/1/UAmIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5677
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Hi
> I'm loading the ufs-qcom driver as a module but am not seeing the
> /dev/sda* device nodes.
> Looks like it's not being created.
>=20
> I find the sda nodes in other paths being enumerated though:
>=20
> / # find /sys -name sda
> /sys/kernel/debug/block/sda
> /sys/class/block/sda
> /sys/devices/platform/<...>/<xxx>.ufshc/host0/target0:0:0/0:0:0:0/block/s=
da
> /sys/block/sda
>=20
> All Luns are detected and I see sda is detected and prints for all the Lu=
ns as
> below -:
> sd 0:0:0:0: [sda] .... ....-byte logical blocks:
>=20
> ... so on ...
>=20
> But if I link it statically instead of a module, it works fine. All devic=
e nodes are
> created.
>=20
> I'm trying to figure out where/how in SCSI does it create these device no=
des -
> /dev/sd<a/b/c/d> ?
> I've looked into sd.c but I couldn't figure out the exact place yet.
>=20
> Any pointers please?
I guess it's most probably in scsi_sysfs_add_devices, part of the async sca=
n:
ufshcd_async_scan-> ufshcd_probe_hba-> scsi_scan_host->__scsi_scan_target->=
 scsi_probe_and_add_lun...

Thanks,
Avri
