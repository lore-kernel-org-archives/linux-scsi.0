Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CA2C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF8420869
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 17:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="gzzG5js0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbfKGRps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 12:45:48 -0500
Received: from mail-eopbgr680069.outbound.protection.outlook.com ([40.107.68.69]:21890
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727132AbfKGRps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Nov 2019 12:45:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHENo8+scyvcbnD6FNdFWew+4XHQEIB8nQnzeFbmGZt99m+AJGRiDNOIdDzQkc6WWPRJjdqixqvCEu+u6/E1q1QoNv4QzrxXjA/J/FenD0nW0gutNcKIp2qy35Emrqrms6iQwQVle9CC8WtHsInDj2tr8E9v0chKapXSPRW1TURSDLdqs9l7nheN8hXKLacIbePXmLLFr1t/ATMKAZqcDYSC8aFFkcer4aHgPoTk70v0EjOUE5b3CCShCCA8RZMjpjpFQwVTOY/f4d8WOnoPU3X1R77xIP6zR9V3jUfXdQKOV/qciJ/HJs+xvQK2L2kg8iEbVL7QMX1JbCuhhKii9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdUESJqL4XA49BwjRJrRb6yxu+3BbU4KtV3x48wJLRE=;
 b=dNJb2P/bn6OWZNLgXuWYvwQJD5QOaz9Kr1Lh8SsA3uSk2E1eSIPACOWnwA/dbAOIDWSweGW7UfZKLA2fiPomzbzvGiwrqAaCZmt8pVoew2E1BR6sCsa2KjFmulJnG9dxuCAVPffQPWiWnyKLzBeu+Bz0qf1S9Sjr/L8NAs7uJBoq6pA+jpedhOlGCOqm+mZ4VqINApFz3B/uRMBPVJoKnc/+oenXDhcokIW6DPImarlEMqvpJw3KjIGAdGbX57t8V+MrkE2dKEx51d9jQfnWFNfbvYZh9edgKX1YD99W8QgYRRkVopb50sNBR1muzBPVSXjVXhcZiPrYeNNnWydQVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdUESJqL4XA49BwjRJrRb6yxu+3BbU4KtV3x48wJLRE=;
 b=gzzG5js0x86zGL6rmo3F9V9H5qSvQlgmHkW2Xe3EiWZRr4k5KGT4YoBcMvl0uB/5SEybdvASGOZRCyW3eciVrf+2JxgC/Jzi1CwDE7zWXufGqoDx5HyXvJ2EF5HOV4w6K6zbYbK5eqI9ntvlRNqXi6EH/s/pIOL7zaaB1d+NaAc=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3969.namprd08.prod.outlook.com (52.132.7.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 17:45:44 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 17:45:44 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [EXT] [PATCH RFC v3 2/3] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
Thread-Topic: [EXT] [PATCH RFC v3 2/3] ufs: Use blk_{get,put}_request() to
 allocate and free TMFs
Thread-Index: AQHVlD5ydYpV4eLXhECk6sfrL9LDH6d//bjg
Date:   Thu, 7 Nov 2019 17:45:43 +0000
Message-ID: <BN7PR08MB5684CD995988A0C0B0D9ECA3DB780@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20191106010628.98180-1-bvanassche@acm.org>
 <20191106010628.98180-3-bvanassche@acm.org>
In-Reply-To: <20191106010628.98180-3-bvanassche@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTZhNmYyYTZiLTAxODYtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2YTZmMmE2ZC0wMTg2LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjQwNSIgdD0iMTMyMTc2MjIzNDIxMjU3MDIzIiBoPSJxWXpoenFpaVlPSEVRcE13aGdPcVFCbXVlQWc9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d58bcfe1-faee-4cf3-7ec8-08d763aa505c
x-ms-traffictypediagnostic: BN7PR08MB3969:|BN7PR08MB3969:|BN7PR08MB3969:
x-microsoft-antispam-prvs: <BN7PR08MB396973BB71963CC5DAE10D6ADB780@BN7PR08MB3969.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(64756008)(305945005)(86362001)(8936002)(33656002)(81166006)(5660300002)(52536014)(54906003)(3846002)(71200400001)(8676002)(66946007)(76116006)(14454004)(316002)(4326008)(6116002)(110136005)(66556008)(229853002)(66446008)(66476007)(71190400001)(55236004)(256004)(6436002)(11346002)(186003)(446003)(486006)(81156014)(6246003)(99286004)(55016002)(66066001)(476003)(2906002)(26005)(76176011)(25786009)(74316002)(6506007)(7736002)(102836004)(478600001)(558084003)(9686003)(7696005)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3969;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +J+iy8jYGoxv/BinnR3MyPA9nBGnRSqMtov/Pm3q6ThIpdPTM6iyNMTiNrgDyF3hIvaMR/CCPY4y7Bk4J6f+takH0e92dVBMDERNSM02WYvie0f+prXntR42KCTVZgJz2p7TpYAljrFhEmIqYUt3sTG/dZBXGU2k/z+kp5XmoKP6lwFsKPWErTcdDcJwNTSA2J5N1mutlkwY0HVwWrgIYWTvEJOGwPbAIcVM/bdBRJ1qsmUaDbEacHVWpZoKKgz3cGdVDveU7fhsir/NlWEJX7Zy224CRvT89K0HqMW8ZZYK/J+PB3fw9/gTJ/C0+ERZld0USgdSkbmQDw09Mk1jz77viw6utajkwF3XbcxDC9xzJq/sG9uUico1uUcLw3m+sjc8IoU8hgcgQ05vAuPOALzyi7Yz2tuVjwdCO/od+q5DrzdrCOtHUzKzulDHj65J
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58bcfe1-faee-4cf3-7ec8-08d763aa505c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:45:43.7493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: At0Fl5bQjtxe/Qp1gWtTwOjBkkJAIvWzEDpF/QubTXClw6UQbZNPQYm8BXTVvK/KTq37Fwv5vvBcYoojNi1a7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3969
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bean Huo <beanhuo@micron.com>

//Bean
