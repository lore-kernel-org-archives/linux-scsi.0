Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9CBC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 15:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C3182088E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 15:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ajOhqZD0";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rxBM0jO3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbgE0PFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 11:05:20 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42060 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389316AbgE0PFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2020 11:05:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590591918; x=1622127918;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=lJttfoFqGDFjNiG+6ZUdxmETg9Rx4vbCPVUzH7+9SXM=;
  b=ajOhqZD0rZTu7joLNm0qlAaoGJATvTX1vs1vwP9L8M1mrX5kd8Txmbmv
   UnzlgShuVz0eTYyc6lc41lxEbRbNAsI9uHsCn8nSEIvUD71ZpzHSBC4x0
   pMNb4a1poNSsRoEYEGEqXtt7l2maBnBxlWYskq6aT6jj4ahaKrOVxLcGg
   6LpLHzJX4G+0HuPieWO1j00V0RbMCoPj67fEqfnKcR8pUqgdK6x/kYEVw
   YYTX/8CZAb2/VUSdnmW92ubsuLDRwXEGhaz+luDuscWpv1esY4zFa2kwr
   xLFXVXz2WWUlPgTBavyGjY8Dh5YDnQkkLhJZrth5wSSgQS6N5Ugq3CADT
   Q==;
IronPort-SDR: wEo4p8VtbLJorlwN8pDXHe/cE/kJe2brzFojNGqrw+meNiDG4+wwyuVu5FV1N5i2jzD4BE6czH
 tqgV3eT29KbBivZNEW4IKmDq+tKa+ZdMmZWWsMapOjSrn8OU74tr1ePhez+oT3H1cro4skFSLZ
 o7aDGV9oNMl4Xs0t2Qk1B7sC22cZI7JfBzK05Co1HwRwRrYcRQOJZvW0o7vebV0TpYxU4ailTQ
 SBZ3XHJRGniipLu6AowHah8EDbXZieApKQ344byxKpCcuRdXJFWITv/6v+TmP9DZrbHUNo41Bi
 6QU=
X-IronPort-AV: E=Sophos;i="5.73,441,1583164800"; 
   d="scan'208";a="247677596"
Received: from mail-co1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.55])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2020 23:05:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zswt6e+MVKrwxGAaMbZYGzR+m54iJ2a7cDJeKOGzNdt1FwWVcGz5PXcwD2+bkyBxSbduP018gJDhgt+9jR1E8Oy7uQr6bEkGgtEjNx5xJwdA4+YM+pwBePxHaTIKgMenzDVVojauzAP5/+1sXqkf8bAFh7eJWnlwW9sg1QBvuFnmTSLXqx+L8Qmjh8Ii2GxQZIjG7FeHqX/b+YURuOec1pxf/KVU3KFnXYxddafx8Oi0wf5xQC+hEkdmGdLEaUCTdDtwdxSici9OE5M6S8UIWtO/TO9Xes2xq3w5rARDWnDNWuKfO9dsvf9mQtx9kiausbuKoe+xKI6WbqgDLI9bCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJttfoFqGDFjNiG+6ZUdxmETg9Rx4vbCPVUzH7+9SXM=;
 b=En04yFaZvWT5ligEojDwNI/ZL9xS4qY+W4KYdOakiZamTizkKnk2VLX1eAo7H0jofeFKqrf6IkRax+4v890I1UhsZNV10bjVq1AeQ8d+fRizEWJ52o/k3cSqqL8IwLBv8uwaLFNGavJEBkztUG9Od5DWr15g6bDTsAc4+hMXNyCxnK7F6VsaEiAo8qoRMcuEg3ZAgGX1oyAK+p8RSCPtzf9p3akC218vc9pVv4gs3mDW+w+b7WQBurrXL1KQPv/XhktVqk8N71t9s73xQYuS072+6H7vn+QuMbTQtgJVeJvJkuCwwuPgCMk5yjk+fmVtNKTiRDb+bHxFl8QezcPtjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJttfoFqGDFjNiG+6ZUdxmETg9Rx4vbCPVUzH7+9SXM=;
 b=rxBM0jO3HmgaY8k5DWAU//jdvfHC+thNuFMbCNsozcTZfiKr6k8+5eXPoafHevH2Rr99wLLPIA+Gyp9OmVex0W1ZlSVUnW4iQAlPwZNjYIYjGzbqTn+yBkL24uzZUtQtWUkcYBGHyBOqlI+Uy0Y5d89nclIwiCNic5TkCTQ9ypY=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3632.namprd04.prod.outlook.com
 (2603:10b6:803:46::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Wed, 27 May
 2020 15:05:17 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 15:05:17 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/4] target_core_pscsi: use __scsi_device_lookup()
Thread-Topic: [PATCH 2/4] target_core_pscsi: use __scsi_device_lookup()
Thread-Index: AQHWNDEbl+6R0tq+CkmgkUCJLtXGYQ==
Date:   Wed, 27 May 2020 15:05:17 +0000
Message-ID: <SN4PR0401MB35983240F2B35A363F18F2FD9BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-3-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59801fc4-41d3-4987-7ffe-08d8024f5dd6
x-ms-traffictypediagnostic: SN4PR0401MB3632:
x-microsoft-antispam-prvs: <SN4PR0401MB3632018B57D8DA2C0D67F18D9BB10@SN4PR0401MB3632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UbIhCxIKDPN7hZHmcRdJCB13SMSEh59UMhsn/r7GUG96xZgpkpqNhKZZD4S/Za42xp9uHBe8K3AvYGfpOY81H22UCc9/dC9ufBNyksY0kgV1ew35d+bWjBSgfGu2vJpZlLaUJe3f2gzTPX9KDS96YHa78l+YfiREben6Hak70icTLEuvl/CEEItSoZfMS4KngFYF0IWYNqAgl+ty9+/5z0BpcBBgZQkiQvuKUNILj1a3suq0tIRjCxvG+R1aI1+9LBUjrWafd0Ef/vAg8aFx/15Pf0XI8WkXPNBj1Uj5hGMRedqhKH82qHkbSTw8KZOITtnZU4ctHdL1Lcsg1dR/bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(558084003)(186003)(4326008)(9686003)(6506007)(478600001)(53546011)(52536014)(2906002)(55016002)(7696005)(33656002)(66476007)(8936002)(64756008)(5660300002)(26005)(8676002)(91956017)(76116006)(66946007)(110136005)(66446008)(66556008)(54906003)(71200400001)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sZJJav3ZO03B3ybyjhT3FW77KdIbYqymXE7cqc7xtqTBOGedW3ymfQb8Yvp1ScQULnGaSY5ZvXDU/MJQnLj7Rt089sC7yVe6HnZBp4cAcaIUbri2vLDKlubdVWmX5Bj5eiEqhFyAlZMSJMmG3DcCugZ1hAWgYwiiFwHb1q1BRZ2AndI8xCuyzZG2vlIE0KFt96Ta5cB1RBYms2G0mAOI1NmKEboEru7vnv5mZUVUxRmpKjTnXg0UCY+h1oMofXDvF/3HIHyufdMWfSrAQ04/sTBdw3OTNGXsoykbBeQ+sQ0ACArEvsZZYiq522p8H/fgcTPpy/HhjlE4y/s5/arFqU5b41wTOI8gxx5fYTjigC6AhRZZfaPAVl+cz/fU7r1SCUt7pyfJUchpdkBKeSb/SCunYB5r9TVzrr4DkKIIPfmQKUwde+CQXcjuvL0K3mJ4Tv3m5WtLmeoyWszr+pbLudK79+UNSFBp2MJEmMkWKEQaEXhLrfn6hIeF/2Ln+hFL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59801fc4-41d3-4987-7ffe-08d8024f5dd6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 15:05:17.0996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H3Wx657s4sLO+quxDL35GUm2PEv4wyimVnMun7K9odWX7mHlFMSjQeuH1dXmrCKpVFOLTXu0oG+RqiPuqv4ou8/9nzm83dtfk4QRZH5pm3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3632
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/05/2020 16:14, Hannes Reinecke wrote:=0A=
> Instead of walking the list of devices manually use the helper=0A=
> function to return the device directly.=0A=
=0A=
I think this a nice cleanup irrespective of the rest of the series.=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
