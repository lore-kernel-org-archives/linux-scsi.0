Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D347C432C0
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DFC3206DF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="gH2wMBjs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfLDBcW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 20:32:22 -0500
Received: from mail-eopbgr760054.outbound.protection.outlook.com ([40.107.76.54]:23108
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfLDBcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Dec 2019 20:32:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aydpmxQYKLOJpndKFO7+EpDKJNF94DoZHqGefz/5nc6/CbIzGbymNykg3xETnhrOTXrbBQPgXRDf4sN0T7Y7RvIeQqoRZkmErvPqpzbLTygOD8E6PMjdBMewI6mb7yTT9pgtmRb2Kdp8bbW7PIsIcMCXvCek6D6pSoGxIoOmDEXhqlPPbTY5Ib+kGvgnLcCPesaobdZjaEN4YeXgk8oSsOLDBAUIlNHHCJFtSau3Mso4mY/fPooQdoVcIXkbRjCDQia6ZhBR4ckHidJ0kgivVAzwy804wo92OTtrK0kDmLIDOao9hsd1pgJ9fkA53NGkj1nqMUhH62MiOL/M/VYySg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrguCRLH21nnEqxqKwUJfqkPWlDmI0WL75/iHTkWPQg=;
 b=Zofd+xQvWVDv5q1mtCJ14E/OdhyA4TlPQ1FsFwCiwZiC6b14sJ5k4sNwLFNX4Z3GuyURFOXNLIkvrG5MA3Xd/jEe+P0iZPcXsd00W3j5zuhiCOYIYbylVbktNQ2cz7Qdsd7pKhEzhwL/KqsVzRaZf4x8ptuVOlo560K1ri0VD7EnPHNm7lKxU4snrydKS6MoDLp2bLNHTZHoyVFGeV+SaVtsxuWYmqNcs6fxvmXvaEDXcHeOB6MWb+ILewGzMbGSa1PB19WOGKzJXd6eKiEbkWNcB7Tnpr/Pe2h9nUVUsn5KhqSojqChoCncarQ+bM6ld0odTr5sn+NEgyb9YKIZqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrguCRLH21nnEqxqKwUJfqkPWlDmI0WL75/iHTkWPQg=;
 b=gH2wMBjsq+btdAvI4IB1U84xCbNwY4t8XEs73P4OaDeClKLokT0ZWBXddU0607h5+5+ArjQ6l3tgL48xZF821CvroP+MsGoiqV4n27/DRKPgnvJfy9plUl/QKWJH8CZabZBqA7ZnYqXkFQnB6NtAu8jByKocVx7VOrkjRISlNb4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4129.namprd08.prod.outlook.com (52.132.221.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 4 Dec 2019 01:31:16 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::28af:57b0:8402:1d1c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::28af:57b0:8402:1d1c%5]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 01:31:16 +0000
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
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v4 2/5] scsi: ufs: Use DBD setting in mode sense
Thread-Topic: [EXT] [PATCH v4 2/5] scsi: ufs: Use DBD setting in mode sense
Thread-Index: AQHVmeeyRoCYU8GCukeAUehkQ2hyx6epUNrw
Date:   Wed, 4 Dec 2019 01:31:15 +0000
Message-ID: <BN7PR08MB5684CD4124A6251E0C7A22CDDB5D0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-3-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573624824-671-3-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWMxMDFhNjVhLTE2MzUtMTFlYS04Yjg2LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxjMTAxYTY1Yy0xNjM1LTExZWEtOGI4Ni1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE5NCIgdD0iMTMyMTk4OTY2NzI1Njk5MjE3IiBoPSJhWVU0aFE1QlFGUS8rOEcvYW9GZC9FaHhBbTA9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.139]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a49fcc57-4b45-4890-0fd4-08d77859a7e7
x-ms-traffictypediagnostic: BN7PR08MB4129:|BN7PR08MB4129:|BN7PR08MB4129:
x-microsoft-antispam-prvs: <BN7PR08MB4129E6C1C9C0F184B514B0C8DB5D0@BN7PR08MB4129.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(199004)(189003)(71200400001)(3846002)(558084003)(6116002)(71190400001)(5660300002)(316002)(186003)(14454004)(6436002)(33656002)(26005)(8936002)(55236004)(74316002)(54906003)(102836004)(305945005)(99286004)(478600001)(7736002)(110136005)(7416002)(6506007)(8676002)(7696005)(2201001)(11346002)(256004)(446003)(9686003)(6246003)(86362001)(4326008)(66476007)(229853002)(81166006)(76176011)(2906002)(2501003)(81156014)(76116006)(64756008)(55016002)(66556008)(25786009)(66446008)(66946007)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4129;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yeVS/EMYJbw17W9RBW7nLURcGT2KC6J9CfLFp5Znw+YZBK2dVK2Cs1KqrIeuqBf3L92K9/NrpHUzJn+IFo8z4SwQB0diikciJgxyGxeed3GxqdSg3f9ouJVNMkBgbAh1CzIWLcm3YljfHqiAN0Jh5fIlNQ6jDZpolr81v7ELFPzu3qTZnxMLbo54wtZAytd8dVynaL8BblyCY8+JwQECIrk9J3iNN72KxGtbIo4++gCwo4fhZUmqdw8xpESPXZTRmUEamEoCni4Axta+CpkWXgkZ5m0CCRWpJN1eXD7apEiUXBUXhI+EaD49Ci4K3TF0vNAM/pC8mZHgPCfguATPf0QR45FsceH4BcoahXvB2F5/bf15WyWWdszRlQTS31brIVTbITlCsKtXzrtf4KwmfazNBB+fz4CurzsEDvoof2dZIUgucjLVN9gkl3g/+D/J
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49fcc57-4b45-4890-0fd4-08d77859a7e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 01:31:15.8825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6rM4Z0ZKvs2r96Zi/YPtT4A/O+FNbayEqvYci/Oikt0oTtVA/BhrXnjKOVlcubtonYGiPHzud+BnmqDXAcXkXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4129
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
