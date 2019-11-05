Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2EDC1747C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 13:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE3F21928
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 13:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="R+hbTX/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbfKENu1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:50:27 -0500
Received: from mail-eopbgr720082.outbound.protection.outlook.com ([40.107.72.82]:28997
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388615AbfKENu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 08:50:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d02uPBlThCvvdwjnjLNLiRMaZ9LwWnIlkY682A9Zy4HL1L4JE7iOwhHpzeHFi8b/PIuHhwrNXiFsYHfdj7ODHRcVqhqon6P8sMyIJHCWqZy5Sw1gC7sWg9svQESBb+a0B4YYtDzWqk5tFYyh8jzP6hEvemLP2OAZAlNfWhEBI5lf63dHsqh8hgkx4iBN4I/6U4dTL62ZfK5MVuoV6MCE/U4xgTnk7oxyNn2btKHHjbeMT4YDBo8TWRLFa1+QU5Kti6Q3TeQd/CKE6IEqYPhP2AYrTlQBX7Lk5JPy0Y4hW/AtYrZTB9A0CssrKhv4LBcPkoadrwmrn3tHkKFIlxBjYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBHxiafY2o9Rxbs2WKn1m8WDxCf/onq7w0DLR1uyn1k=;
 b=Jm0SeOn/Nw4LkaEBN0nuT7hcdO5wcW4yMHFg+fQZxk80WYSX7rPkFSbzp8NigYUlUdm+glh4Me+C1R1s55tOcJ9n1RSixJaLFmVqQZy42T3E/+EB2iVAfPGaOSgKRJjtAPauo2QQlVVQCK4yNldGXHVhGsvvdmW1/5ojO/ayC7QIaCcuoVv9WM2sfOGc3428uUE7Q3IH2hhodF8GigalQF6nQbijmodlQpDzfMaxMIU52vRB1G9Gf/6hWde1Z0FeJRXVVq2E3GMa6dfKKnJCQygq3eXD/S5Nd/6HUQppp+tQ/A23iZkKXNiDtzhk2L74V4p8caRQavS//QGrDl4xtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBHxiafY2o9Rxbs2WKn1m8WDxCf/onq7w0DLR1uyn1k=;
 b=R+hbTX/XmPeFRRUz0j9q++ybwfJdtPmkVFurWgePXT55Pze9Dx+4UBxGwPQK15iwxpOezNHl0czfZ5Z6XCxGpL8nQ/C+3O5xZsJzAHltLIfzejcroqcBOPdjzCcWYnlPlLTAivALo7insh2IHhFIzT0jJeKCs323a4q4EcnpVDQ=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3940.namprd08.prod.outlook.com (52.132.6.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 13:50:22 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 13:50:21 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH RFC v2 4/5] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
Thread-Topic: [EXT] [PATCH RFC v2 4/5] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
Thread-Index: AQHVk3HzaAE2ARtmo0Ge74jIZK0q1Kd8k4zA
Date:   Tue, 5 Nov 2019 13:50:21 +0000
Message-ID: <BN7PR08MB568437EAF8BF59CF9101C507DB7E0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191105004226.232635-1-bvanassche@acm.org>
 <20191105004226.232635-5-bvanassche@acm.org>
In-Reply-To: <20191105004226.232635-5-bvanassche@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTMzZmNiYjIyLWZmZDMtMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzM2ZjYmIyMy1mZmQzLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjcyNCIgdD0iMTMyMTc0MzU0MTk3NTkxOTcxIiBoPSJsdHZzYVlsZmMwZ3k2TWIxM01xK3JueWhZNWM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1eef2700-02e5-42cc-bab8-08d761f71a1b
x-ms-traffictypediagnostic: BN7PR08MB3940:|BN7PR08MB3940:|BN7PR08MB3940:
x-microsoft-antispam-prvs: <BN7PR08MB394010BAFEDBA72412879247DB7E0@BN7PR08MB3940.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(55016002)(7736002)(26005)(64756008)(6436002)(11346002)(476003)(486006)(81156014)(8676002)(7696005)(81166006)(6506007)(76176011)(54906003)(8936002)(55236004)(102836004)(66946007)(66476007)(186003)(66556008)(76116006)(66066001)(229853002)(86362001)(110136005)(316002)(99286004)(6116002)(3846002)(305945005)(74316002)(2906002)(446003)(66446008)(4326008)(14454004)(71190400001)(71200400001)(5660300002)(52536014)(33656002)(25786009)(256004)(14444005)(478600001)(6246003)(9686003)(4744005)(7416002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3940;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GlZ3OYinNl71R8mSI4Ajfl6wiKtPMWdE8AoNP8CaDyS198LP2iuY/PIrwx6Igx+YuFtJcaPjB6SEBID5y9THSU/AsdlccFPiXBwms5KXcQaqu48mzBq9PevO29tkSsRX0E9Xdneknqrjs7YETm0Bf4tyetE+cuRJzTkIRzNTokxa2HjOhtkhYDSuH0KpN+23rb6npxUUjoLYPfdloh19TysUKTMJWHoDD4k0n4w6UFc4ywqLSc8hpoMBxv18f4Yq5YptV5HzxwN9IhlNRFhO1XCAK7I73614z61gNPxUs6nrag0dW/ctnpfuH6PW7cShKKXGyQZyBqXoSJPK9h5itveyhEslz1BS3C1ksml+2uz6qj1pAHSxQ70+optRpmSwlUMre1CkZ6dIylCRE0sBNRcBceSjEUN5OWdP8D8aPTQ12v5+UCkjiiXD2nnB7Dpj
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eef2700-02e5-42cc-bab8-08d761f71a1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 13:50:21.7136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 56+EawSthD3IvsLfQFpTA3C8P2JA/4MAF2SXT3czuuJk1RIGnz1yTeEidxCqV6CwIfPU03DgJKejkzQoilKW/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3940
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Bart

> -	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba,
> &free_slot));
> +	req =3D blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> +	req->end_io_data =3D &wait;
> +	free_slot =3D req->tag;
> +	WARN_ON_ONCE(free_slot < 0 || free_slot >=3D hba->nutmrs);
>  	ufshcd_hold(hba, false);
>=20
Understand now , you delete ufshcd_get_tm_free_slot(). Run a big circle to =
get a free_slot from reserved tags by calling blk_get_request().
But UFS data transfer queue depth is 32, not 32 + hba->nutmrs.  How to make=
 sure we see the tag is consistent across block/scsi/ufs?
Thanks,
=20
//Bean
