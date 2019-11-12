Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED8DC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 12:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 883D021E6F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 12:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="GLKlHgs/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfKLMZN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 07:25:13 -0500
Received: from mail-eopbgr720063.outbound.protection.outlook.com ([40.107.72.63]:65054
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfKLMZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 07:25:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0tjBgq09iWY1S5QVJYaST37li7l2a+UwJWA6j2zDjry/V/iXeKlJB0GpbOfEUTnmj3vkXm7jqQqpAT4oVO0JVIsh7IMMfWWWdbH86rSGXP8CCtjyaO1JbAAkOhQ2eQxwlApXO7YkLjgpYw8PFSNcBHrxRkPDVZFvHiL6O+LcoMfjI5caA+1X1cHQUz6tJYDaxV60A/x+07XJw4Q9ZIobQ4bbXj5v7j3BPb5m7DT0gjOrXDzodmi6/VkqhcspMnj/WhDzV6eDxnyaDuumqBAH0LPAah1yG74AZY7N3/Fmnzfs7/wrbuNcP0yJ/i6eV7qO478gkt6/oMBN8YMujfZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeN8ByGZv/qXnbFlA3JSUBa715QFW6/gGQi3M43SK+s=;
 b=Fqm2HwM2IvW8wOiqvQk4VYEpfbLyEliGmH1cVgSllPis0JF2wBLMpj4t6AaygZ0ibVcZL3MQhhWNpCt/eolkqTsGmDsLzHp6CxBftiHT+vw3y3j5G8iwMsOUnKQQAhJ4LxC7ZVKke1VySpJ4ExjzHqkb/H0Yj4q5fo3LsJ2PFTlVodbD0mqNHFcCX+EdYRsA4d4FXMsKNHHpXuesNaGGNwSyYneacaMi+wRcgKl2StJnv7o7Asm3J0qMRvWGLNF4ToRyfl//MwPeAwG4Xn1kjSj/w7vsBdSKo0jTJxlbK7+GmNSxGJ+pQEEIfM44mhwhwcCV3OBfaGb4R+mkYQ2rTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeN8ByGZv/qXnbFlA3JSUBa715QFW6/gGQi3M43SK+s=;
 b=GLKlHgs/k0+WO47i2PtbJCce8skLtQImqsDdwZOfA9EvAyxDb9fpG6LS07/aT5sUwvnaIxIejgJ8j/ZB9vCWd3jOhUIW8jCy6tj9qPZTaH3Ohgpqt/u6IKCcbTsVoMSkTIgRSYpZKXumMkuHTldCSAcW2iDiI8e5Jj7gJrl765Y=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4228.namprd08.prod.outlook.com (52.133.222.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 12:25:08 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 12:25:08 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
CC:     Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH v4 1/3] ufs: Avoid busy-waiting by eliminating tag
 conflicts
Thread-Topic: [EXT] [PATCH v4 1/3] ufs: Avoid busy-waiting by eliminating tag
 conflicts
Thread-Index: AQHVmLhI39wKNaHOIEurBf75Iaih2KeHUvyg
Date:   Tue, 12 Nov 2019 12:25:08 +0000
Message-ID: <BN7PR08MB5684739C6BEC8C5D7E4A0223DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191111174841.185278-1-bvanassche@acm.org>
 <20191111174841.185278-2-bvanassche@acm.org>
In-Reply-To: <20191111174841.185278-2-bvanassche@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTc0Y2FkYjlkLTA1NDctMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw3NGNhZGI5ZS0wNTQ3LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjczMCIgdD0iMTMyMTgwMzUxMDU5MDQwMDU2IiBoPSJxS2h5YWtMZFg5RlhhMW1ld1dVSEFZUWFxYU09IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8f150a3a-e539-44e0-1462-08d7676b5b45
x-ms-traffictypediagnostic: BN7PR08MB4228:|BN7PR08MB4228:|BN7PR08MB4228:
x-microsoft-antispam-prvs: <BN7PR08MB422870D08C5E8519A769614DDB770@BN7PR08MB4228.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(189003)(199004)(64756008)(66446008)(66476007)(66556008)(14444005)(7416002)(86362001)(256004)(5660300002)(102836004)(66946007)(52536014)(76176011)(14454004)(74316002)(305945005)(7736002)(6506007)(76116006)(478600001)(25786009)(7696005)(486006)(316002)(66066001)(6116002)(81156014)(54906003)(6436002)(6246003)(229853002)(99286004)(8936002)(71200400001)(71190400001)(55016002)(33656002)(81166006)(26005)(3846002)(186003)(476003)(110136005)(4744005)(4326008)(2906002)(9686003)(446003)(8676002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4228;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pty5BbwWpYyEMMvxg2i3UVDV7bRRnALv9Q3CGGSB+rt506a4ea5eCr0XqbLWnMzwO77oVv/UGKgzpMvW8pNqR3200Zo2VAcTv17cOiYiVkEdhsgSEC6Pwfn/s2l9v5uQbFdIhBxlf9PIGHCs03x024rsdDfaMu56O8fao5uNmmrY7Zd1KlU76uYKvzyAsScgjQQ3WjXdOG8pB7R2hu5OP6kWKiGAVvKiYRRPrV4hMu0dk1VT9bgrPtNslPtaAgUku4XUGxnquv/SeznsJCY/6rgh+gOk1sEQsFKIpBqbPOuQcv8em+iULsBOfHgP8nOqS+g31985gecl+9dyNP9yYf2QAf5hZj7GLodHgUHJhZ0n+TuIBYMDYMwAOzIHYRvns2FAQb1SFpo7VOgABG+JDHpe0JXwYNHwOdTJG8va5kmQuUhcs9JKkfa+K/gZoOEI
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f150a3a-e539-44e0-1462-08d7676b5b45
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 12:25:08.5322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JdzHnXKZIbARD0WQzrrh1c/VLgweFCpCPpBvTf+YnEhIdG8bsqdnYij8rd0GGlVohqb8rtSpQxZyQ+F32xR2PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4228
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bart

> +	req =3D blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +	tag =3D req->tag;
> +	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
....
> &tag));
> +	req =3D blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +	tag =3D req->tag;
> +	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
>=20
......
>=20
> +	err =3D -ENOMEM;
> +	hba->cmd_queue =3D blk_mq_init_queue(&hba->host->tag_set);
> +	if (!hba->cmd_queue)

It is possible  to return ERR_PTR(-ENOMEM)  in  blk_mq_init_queue(),,
Here just checkup if not NULL is not safe enough.

//Bean
