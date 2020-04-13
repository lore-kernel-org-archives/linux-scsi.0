Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99915C2BB86
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CC692076D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 23:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="M8f/lUo6";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bpEnc9ZZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389939AbgDMXFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 19:05:09 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48273 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389929AbgDMXFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 19:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586819109; x=1618355109;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5enr/Y9HlJBOqTWJ7t1sNq4mI5+bmwr4uPeRY11bnL8=;
  b=M8f/lUo61JxYJ6SbEPIQvcknWBtLklSSZkYfrroMsl/Y3GNshKYDxYkK
   4pVoIPMkYuOd7Ys8dEMxXQ8EftfJzmbObcAfkodKFdGyc5j+bad4SjOVv
   pfk2K0Yf1jZXG2PCWN4liBZUC4Z/mQlbNqNKlzorgj64aNfGK4k+jn/hV
   Pd2/7jM+peaUrPhYIglOorZ7V6uKkddO2fQ7ZCVuDKtiKeD8bQrOUncXo
   m8a5siMKlPYbr+I/Bf15Pbe7Drje/7SaT147wIXRLApvT+8wXWmKRPGFe
   IPBoL2CzubaG3EeXSo4yEWeJQN0pikOBHN1bpIbl3NqhIb31FjE0Xbm3S
   g==;
IronPort-SDR: CKxLyGaA0EGLBkLH9a5TWISL9x2IlsXNBC9ld34T0JiQmk44JdNm4YafvCSxfq/TpJORjM8Aqn
 LMJYK0KShqMcS21DahQJdU5Q+9U+KY1m+apVB2y1/s7yJnW+pVbkRHgWBJxDVpN2R+EA/PwaF2
 ATh54RFOFV/m4x88AV/lKp5sUKyqHHgvfQcf+YlHHXwqDp1sfnb0Gm4qd9I+zVz27zDVTQ/jQ0
 hUQin3W+ltzYkNgwvFeFzV/PRJr/6b4gFXhJaKaeSSQ0jTcb0oWQ+kJ282R3C3ffs+tgXUJi/Z
 DkM=
X-IronPort-AV: E=Sophos;i="5.72,380,1580745600"; 
   d="scan'208";a="136687211"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2020 07:05:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAIjzWsDowoipYuPGpJ/VQ3eoGXQq1Hl2p/wFaNlWyekAmdxo14m8ANwpyWxlEdgo4+gH2D/V6txIcv5HwG3mpr1HYv8Vep+hWVZXO86ada+REvLc0QC10ouvHLJCYnVZqwGrvL7F8izIYjk9diKHpVLhCqQCXX0PTR7sVM0aNGmhbVnFt/S1ze10BK+9Jy7oKEHO70nuu9aKrJ2pLvzba5KK5A3qdLNhGZFZ23LV+/KDvzwJTJ+8y67yqc/KJ3ph7jKg2QQqbcQBzsHzbJIasSH5CaUeb0xHge7CNTM/tSIqQJKybgWTqw1RevFIseoS9Qowbn2/HhylIxUH9+SEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5enr/Y9HlJBOqTWJ7t1sNq4mI5+bmwr4uPeRY11bnL8=;
 b=W3toOX1fu2o0QWkmcmxfVnNpZ8Vq1ZjGenP9XDdv0abDXSMExtXQ0u+A57kwNsADc5Qferuuhi5yWOwItE9psqcQoAW7EkfLu+rblOI78uTB/1XPUXoU1Tb6V+KJMhSMgghuanz5s7TvK8ApO3NHkSYuuZHt/1g8yCZWT0WtSdQ/WJ+ZxjE7ZAGOwfOuuUkQVzpSyCU0CXi82UhtgRdYMbsn4f5UjjYVwwc6ml8hir5zV9yB4XuzN5a+u1fT/G+JhFD2kvMNuDf8sosFwQVYfS8rwg5druenIjFJ+wDVCSo9ocsPQv9a653NCjDYXj9GLI51nSGxdBrB4yAt8zTTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5enr/Y9HlJBOqTWJ7t1sNq4mI5+bmwr4uPeRY11bnL8=;
 b=bpEnc9ZZjWXmT4/Gy/8PYZRxmVtcDeBRl7y2vtAPKitKAVMjA8THWNJbrHDOHeWoWt5WBOd3KFegk/lNr/fwm2XCYUEuvPAg7e+zM0fdnMEuh/kST8LE6VmLkw5Tq3sO6iTtg7+DkIpDZe24hUYl+5TSsYq3OqGOFRqauy9r/vE=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6643.namprd04.prod.outlook.com (2603:10b6:a03:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Mon, 13 Apr
 2020 23:05:06 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%5]) with mapi id 15.20.2900.028; Mon, 13 Apr 2020
 23:05:06 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v4 07/14] scsi_debug: expand zbc support
Thread-Topic: [PATCH v4 07/14] scsi_debug: expand zbc support
Thread-Index: AQHV66Q0jOmaKf8utEaf1qVGuuBg3g==
Date:   Mon, 13 Apr 2020 23:05:06 +0000
Message-ID: <BY5PR04MB6900CB37BE3A595454FA476BE7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200225062351.21267-1-dgilbert@interlog.com>
 <20200225062351.21267-8-dgilbert@interlog.com> <yq1a73fvvmi.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [60.117.181.124]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 76cf8ff7-5654-4769-6685-08d7dfff1b4b
x-ms-traffictypediagnostic: BY5PR04MB6643:
x-microsoft-antispam-prvs: <BY5PR04MB6643A72C725E4845B40D61E1E7DD0@BY5PR04MB6643.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(4326008)(4744005)(86362001)(110136005)(7696005)(26005)(54906003)(6506007)(76116006)(91956017)(33656002)(316002)(9686003)(186003)(53546011)(55016002)(66476007)(81156014)(8676002)(5660300002)(8936002)(66446008)(64756008)(66946007)(71200400001)(52536014)(478600001)(2906002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GMzu3YFnypywOmoy4pYQWF37eKcp5AEih6QvQ8Tbel4ZHMWNjn1Wx0fk96jtW+6CyazrJjTOKNfsFJgfTb0Gq3rIcD0phvAe5aX2wM1UJdONlKVuE2D9+161HpRScadeklixBzenKhZjmMVKXvD4M8sldN6faGC4MRqTfs74wbR6pS6enKGEt5ZYXQ3fqQYiywiuqa3sGJxOYxyRM9b1zl7rir/gqylVCiIWXbuqiviRPciMZSTLaJe1EAhRD/IKHG/fO82O+f/fdG6EOKGytzjpZWcHuHl+1jWBya//8Al8LifUX7c+/2Y5DdFnYavfcMS0A+ec3A++SGq/I19p3NzO2KKmdAxSV48ubXtQujNnsbbByHbUgJYUlj8J73U+d+qwFNeFdPiJgvlYGlquQ+1AoP05FujFmQbcahyDfDF8ewcLWDWuqUbPiduuNiky
x-ms-exchange-antispam-messagedata: oXcIRJWGuSfDGAZ2KfcLHUC2lmXUBH50qwkxwppeOPkK1XQZAF4PnzYMwgnLDMs6eror1hDZnC4oCypSQMdPchKXQxL49FfVVEqtSNkP2KzqOQqwmiTcU/ecfzWDvqtLe/zfoEQP6zaMzkm7jS3miw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76cf8ff7-5654-4769-6685-08d7dfff1b4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 23:05:06.2501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B0yw+MHB4iPt0vqvvekuSB+M8xvj9GkY+KM+W+WCmWpy8aZ+EK5wvd/1GrbHs7041RVZmOZClR0BXkINPHOipg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6643
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/04/14 8:03, Martin K. Petersen wrote:=0A=
> =0A=
> Doug,=0A=
> =0A=
>> The ZBC standard "piggy-backs" on many, but not all, of the facilities=
=0A=
>> in SBC. Add those ZBC mode pages (plus mode parameter block=0A=
>> descriptors (e.g. "WP")) and VPD pages in common with SBC. Add ZBC=0A=
>> specific VPD page.=0A=
> =0A=
> Also OK. Would benefit from a Reviewed-by: from Damien.=0A=
> =0A=
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
