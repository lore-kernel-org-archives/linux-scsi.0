Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17661C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 22:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 137C8206E5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 22:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="JZQ3zLjL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKMWEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 17:04:12 -0500
Received: from mail-eopbgr820047.outbound.protection.outlook.com ([40.107.82.47]:42047
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfKMWEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 17:04:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mUlCm/QI5IDqIGNoouRhlKNFWlhFi2IwYXJbXQJvROpcvIgSQ3yb5llSa2M6Twi6jsAoBhfTqgE6HBop9qa52CpwMcDLcTpyFjFrC78oJobxjl5MMHB2n9B9AFGPB+FGHTl/4FH96evEjCT9Ta7Vk0BNMRZjcZ27rYjTUtn02NY7OW+5UHkFgv4cJaApbL2znYQ5SZkA4CYt1X6W1FO3WD1R6q07z4fOmzIXD6w+wCpx8UaS63NDfZ2OuDhRapHtZGoix6ulG9ujv1hVF7ICwvthX0HIM6Gi9mAn2yZJ8ryDrc58xWOCFc4ZNySDENSydkjYM4sRenVYIhsJ44Ml9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Omqvw/ODgVQaJfSk48IdNf+pV26D49dbIGG3elsLY0=;
 b=C2UwZ9FPSDTs4+yWlkKkaz6KsJwGk1U4diF85RgINrHVqZu8d6CSu+1Y9pCzUmTADv90QMRYVu7CaBjfZma2pECmPo5M+YoODfEPJC0iIWgwYsT4G7fGKq2qBoeRgXnolucbJU6qrrf/w/i/+H3+ckHFAxyheXPREPRoAl09630AAJHcMmFnhz7MdqSlFRUJrl90oz37BEhCE1YlSyuRQi4FC6yoIt1rmunpYjQ7LbXDIwfOdIMSBFnPMs6ff9eyuJ4uCH5yJKaW5MIs4F0qSiGDyvqk9vxSM6Am56+v2W/t8BhNpvtPw9PKR3Ppra5RDIMylihnInj/PIYJTXsZGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Omqvw/ODgVQaJfSk48IdNf+pV26D49dbIGG3elsLY0=;
 b=JZQ3zLjLdaZGc6Ki5zm4at0S2pbP4lAQIPm2scYNJjRWfV/ogE3X84nNtaHHTJRD4ZpO5sueXee4Ss7wjx3W8JY8V4FOpXMhML4xeKFe/wdI0cfHQNo+iJ9UQKeSI5Mbkz45AfnXD/8uwT1ws17lo4JBlzfLAAT9yl4JBnCRAOc=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4403.namprd08.prod.outlook.com (52.133.220.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:04:03 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:04:03 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 5/5] scsi: ufs: Complete pending requests in host
 reset and restore path
Thread-Topic: [EXT] [PATCH v1 5/5] scsi: ufs: Complete pending requests in
 host reset and restore path
Thread-Index: AQHVlgzPbiOALT34b0a4wX/4UETvQqeJrjpQ
Date:   Wed, 13 Nov 2019 22:04:03 +0000
Message-ID: <BN7PR08MB56849EEE83414549F4787BCEDB760@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-6-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTdlOGE2NzVkLTA2NjEtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw3ZThhNjc1Zi0wNjYxLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEyMjMiIHQ9IjEzMjE4MTU2MjQwMzE2Njg1MiIgaD0id2hybUw2UG14M1lIMnBPSmRiNkpUOXFqS01jPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e166170-6832-458d-eeb6-08d768856510
x-ms-traffictypediagnostic: BN7PR08MB4403:|BN7PR08MB4403:|BN7PR08MB4403:
x-microsoft-antispam-prvs: <BN7PR08MB44031AF8701692D0ADBED029DB760@BN7PR08MB4403.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(189003)(199004)(66946007)(81166006)(66446008)(8936002)(81156014)(446003)(8676002)(66476007)(66556008)(64756008)(6246003)(14454004)(6116002)(316002)(76176011)(229853002)(478600001)(3846002)(7696005)(2906002)(71190400001)(7416002)(71200400001)(186003)(256004)(110136005)(26005)(25786009)(55016002)(54906003)(9686003)(55236004)(74316002)(6506007)(6436002)(14444005)(305945005)(7736002)(52536014)(2501003)(102836004)(486006)(476003)(66066001)(76116006)(2201001)(86362001)(5660300002)(4326008)(99286004)(11346002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4403;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NMyOs95vVpiBOpG6eI9A/87lxUzxO3pKUG8nDYyfuil9/PromukTL7VeZrEKLJJjo2BhauRiDOMXYvNYn+NQHdz0+26M9oE8SUfqQ+WYVJ/pZeTgAOnqA8t/uHwLyNlq0N75vpOxrnhDylewFYxb8H+JZLd8eChU+vsnJ+SEfXbwaiXis7fa0sKxbcu78/QalN5FavFqtjKCQliC9Xoql3PleRjJA0uqmuvO5LAnyFN7jeSMcfF415d5e/SOZSCw3WYLarrD/jGZk3K7dSzIoFZ3gPlNUg0F+VlUHh8ImmP5SilIjurMByOeL5nmY7CWL5/Kzx3EozINHpIh2lDXyUvwH8/KOMwJfHt42bj3Mou3XL5YwtPgkvS3bDmOjdFUIlG4T5fFT9U6xhbIztpe1YN72WIdyUHVyLl3zsc+FANg111Di0Eeu6gSVVyyfKVt
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e166170-6832-458d-eeb6-08d768856510
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:04:03.1093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P0WAiTMAbKLrA1RiolEmKpFu3CTighF4eYWFWAwhgqN8Rf7bMnIP5pGU/DPzzya11A1DA1+FRkD9ovboK4qNSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4403
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> In UFS host reset and restore path, before probe, we stop and start the h=
ost
> controller once. After host controller is stopped, the pending requests, =
if any,
> are cleared from the doorbell, but no completion IRQ would be raised due =
to the
> hba is stopped.
> These pending requests shall be completed along with the first NOP_OUT
> command(as it is the first command which can raise a transfer completion
> IRQ) sent during probe.

Hi, Can
I am not sure for this point, because there is HW/SW device reset before or=
 after host reset/restore.
Device HW/SW reset also will clear the pended tasks in device side. That wi=
ll be better.
I think Qcom platform already enabled HW reset.

//Bean

> Since the OCSs of these pending requests are not SUCCESS(because they are=
 not
> yet literally finished), their UPIUs shall be dumped. When there are mult=
iple
> pending requests, the UPIU dump can be overwhelming and may lead to stabi=
lity
> issues because it is in atomic context.
> Therefore, before probe, complete these pending requests right after host
> controller is stopped.
