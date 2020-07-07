Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0600FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 07:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF8A20578
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 07:58:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MqzvpxOU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zSy+IZCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGGH6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 03:58:35 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6907 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGGH6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 03:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594108715; x=1625644715;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5+lyb/LaNXe0pRVPXEb15OYC9Ep1X9RH6DFal31eSZI=;
  b=MqzvpxOUjwy0FwgX3dyQuGVn4Pf05tomXvFqCFc7t8HwmZCjZs6uxD5P
   VkgYIp9sJxHyqZX/5uNx88K+0CG7MP6/XZjuWaZ+SRPoTZx2kZiVYprV1
   b4iG6t1MiuroQbQpk+3C876KcjWiJWvb/CgY1DJ84bHyZOhjTiddEwoz0
   ayff8J8sW5epT5ykhbyXw03RgyB+1+lbZif6EeQw+ClLrhPs8g95jooVy
   p9D2JISFrnqdyyLoC0hgAKSU95p+AA3G2BJ3qBmuhDanlWLOadUbLHJjd
   HVWNV1+4e2muDFCEd9Oz6JgP6k4VAWbyGqVHA+bZvlznq+g4QhmufDyr5
   w==;
IronPort-SDR: lx73By1W5SGbznv66AwDXRyprm2/0ah3gxGzYqcLl7IQpnzTO/lmgHdhMnoxTWi4I4WZMjilyr
 w7XdpcmhTvr+dyok/ny7tB6BgvQtauMg+ja3eHe09fnU0UcH/0rm/Sd5E+dmvwMDhti7cAihdX
 YIg3sKoeudkiCrjurjqz6cXmvgM3Ya1ydzvtdVhVGmy+cLYkKNtdPIhwJ0fHVyCe2thRBs8HP8
 6iKRG6u9oiE8HW5QRSeJs6XYcwipJrXzcI4Q9/ouCeyVyVYgfB4BYIv8HXL+nV5SpU/lFCHc1d
 DYc=
X-IronPort-AV: E=Sophos;i="5.75,323,1589212800"; 
   d="scan'208";a="146119718"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jul 2020 15:58:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cpDSuXa5t2T8H/yvU911TiE1DVvfRQLtrwDF011oK39qSPgZM9L5/oy8vgnjWg7MYjoZNbZVZTNuffWYwpgRMM6/Mhay3o1yYT5ad6oOBQ61DGgObWgjhrs8gHVVvZauiowiyIWueL5CYBI9ZDw1/ZknCEt4er7JdceYkdEjH+ODeHV7hKWATjM2Tgkro58ZJA5vi9BYxoYsQbN+7YNkGyeVxsqRuETOwXawI2bIhQNc3nXZVxHHR61VcnPY9K8ZwJWW9wjbSH8TuhLFntnVgK9vFE4ntaMHObUwDsN8o+EWuHgMONf4+Zjql8r8vNQiVFgha6dypUUYPNz8mhxfLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+lyb/LaNXe0pRVPXEb15OYC9Ep1X9RH6DFal31eSZI=;
 b=TAQyLgA7d/BVXHTDEtoY0SIAZCIDTf8s2zerDJeSBur213K6sR8sVR3qNBeWBGZ0UBuZhMklFxOtMkP/XfynlVIA52yCA6Uwy/3B0e42jt+lKtjbExVsuETL9GEnP1TMm6NSS7nn/b5WN+giwsJE6f/b86bH2wQiWXCeSCxOyV2YkwgRCkda0SkRRW3SPUuv4kOQ272coEQzXMvQ1MwYfRVFGb+zl9PDhpgQ+MrFGYlBz6dTkD8GclXp+JN9X/ZWyyRrUNVC+GHvx9oqyU7ZVYBbSjrEn8W/VbCJDkXzxU2oIgHILOjuNtS9MplNk8dS4+pwfrpuqdtfILszWwqMHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+lyb/LaNXe0pRVPXEb15OYC9Ep1X9RH6DFal31eSZI=;
 b=zSy+IZCGr1VxEBsuW95fcAbScFso6XG2JJjXbbnh/NTfqgbYyHjVW7XY/DhxQStCYRB8UE8YmMtFaUtmExDNiN8OzWJzsqZaK+Qjg8MvUchzFeIXkz7/2RNTUPSbJ0B2EOaFntJoTtjcqZIvPQEDbfD9LFM7INTbF2O/n0WhIiw=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5168.namprd04.prod.outlook.com
 (2603:10b6:805:9f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.29; Tue, 7 Jul
 2020 07:58:32 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 07:58:32 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3/3] scsi: Rename slave_configure to sdev_configure
Thread-Topic: [PATCH 3/3] scsi: Rename slave_configure to sdev_configure
Thread-Index: AQHWU80uZCT1lNFZIUSPPdRRAylhRg==
Date:   Tue, 7 Jul 2020 07:58:32 +0000
Message-ID: <SN4PR0401MB3598B2AD894BC9C1611C26DB9B660@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200706193920.6897-1-willy@infradead.org>
 <20200706193920.6897-4-willy@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ffb49584-bf87-49d3-b29b-08d8224b8b22
x-ms-traffictypediagnostic: SN6PR04MB5168:
x-microsoft-antispam-prvs: <SN6PR04MB5168897E351619D71473139D9B660@SN6PR04MB5168.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:86;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XQr5Rzc4qX7o+URs8gjCqmv18b5lwX5TpN0PwPCKRSZzImrxsjiwM69HN3xVn9NfvKOUDMNCDOoe/wWeC80j7ENY5Zbpni+e4a86Ue8hSEex9wsphSTUV8EJiKXJIFxrHIBtjVuUbv2S0TjBIFdKGRwuiW2uo6mUsG85KMktTag4Gd7o0puLbWlmGEr/CTjvPm55C0EzwTiSrZw/SMiEaDGs5lYvc8a7sckh6wZB/77xCdFbgjFEn1PTbdsIstmhllGFwpGBNO+UBeS3GmpZ+fy+4wNbVMKwnLC8XepexxcoJW/oRxuYbTO4NhqTItgw7BX6IyT7p9cI+qFs/REdpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(2906002)(186003)(53546011)(71200400001)(6506007)(66476007)(66556008)(66446008)(52536014)(64756008)(66946007)(86362001)(9686003)(55016002)(8676002)(26005)(76116006)(91956017)(33656002)(478600001)(8936002)(7696005)(558084003)(5660300002)(316002)(4326008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ALEmw2bhA1ky9HQ9EdjU/sYW1WkBgKENeyB4X61xyqK6/J0495yPCNCO1eF3zqItxeHbqSj9PNWJUH7UxGZ3QEcCKgpt83CBUnxSDxG4qNuggMpS+9mi7X7I4jLNssAecBfylX4Fg7fZPB5IyZ7UQ95rhfVicEIdfV+QFuvqMu7tx+tXsRDXZp/LUOY5Z9320R4RJBWAj5zF7jg7JWXvLOp25vK21Xvq/hmcx6RJLP+CvcaEi/w5k41nzRGtH1UhvJajzATjN7l+vNufJCZaVIFrES7hZUJiYmxqBfxWwZCzDoBMMV/yokf7Cl5tstXZTGNQjgxgbaWNacawdCHvivpDvX/Zm1DTLG2jDyKnLSHv97xqM+8sh+aexQNGYQytBbX1OJ6FytYXaBviYeRR2fBXKDZLaN9C42/tZ0mVm8mcRUJ+3OgeqMZdnGfLCnKf8UTMWT6Yjq3ho1H6nh5TVGRgHshZi1FWDBiyqJeO05ZRhdvp+/Vz2vZpvoafoznR
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb49584-bf87-49d3-b29b-08d8224b8b22
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 07:58:32.3911
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DZs6gcr3chlcIuLNlybf6+qY4bosF0/rLosVSHrfFosRS980kIdr7Vhavfi4aJB1MHkBgxZy3AaotlH+++FA824YFh865PueWsgoSlw9YUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5168
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/07/2020 21:39, Matthew Wilcox (Oracle) wrote:=0A=
> Match sdev_init() and sdev_destroy().=0A=
=0A=
s/sdev_init/sdev_prep/=0A=
