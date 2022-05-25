Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D9EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 14:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiEYOwY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 10:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiEYOwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 10:52:23 -0400
Received: from smtp.digdes.com (smtp.digdes.com [85.114.5.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CE12E9D6
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 07:52:19 -0700 (PDT)
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by relay.digdes.com
 (172.16.96.24) with Microsoft SMTP Server (TLS) id 14.3.498.0; Wed, 25 May
 2022 17:52:17 +0300
Received: from DDSM-MAIL01.digdes.com (172.16.100.67) by
 DDSM-MAIL01.digdes.com (172.16.100.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.12; Wed, 25 May 2022 17:52:17 +0300
Received: from smtp.digdes.com (172.16.96.24) by DDSM-MAIL01.digdes.com
 (172.16.100.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.12 via Frontend
 Transport; Wed, 25 May 2022 17:52:17 +0300
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (104.47.13.56) by
 relay.digdes.com (172.16.96.24) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Wed, 25 May 2022 17:52:16 +0300
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bf+0fHvi2ndd+g+Dq9p40BFwLkT5X9W0u3qRdHSprEsMuL+XXG9mfS4YynPs1GXDkmvtyH+9bTLJlpvRhKvJa2fuYO3yWO4iU0S7Sh5qarlsVYsI2F05sTui+xNlRTWZkUjAHYdbjSjv0xDQDySOG9RDiDjudTGCbdurUHHnPeYOFPz44Dr7z4y/0TtzLaznVrIv32RZBriQ81Q4YtjEe5laWpVHtk+giMTN5D5ETLnOvDgXhKQYGebmHUPB7Z/Zgj71IrlwThWF2+5F0cuHg0hrJxAFfJSioqZdiK4+zc1NPZEZQz0P8xVj9Jq3JaIColCgr90K11GFFRlYpYfPMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbrR9uaFhpxq11dNtlXg5WvgOtLH9GwQXyijKThxVeI=;
 b=lnm1pipLjzOGKkJ/1oB9+WONYo2ufHN4uN1Wm4gDN81GsjB2qnBFtdLH7aUsiyZ1Xt52gsDZ1qZgTLOr9gfZm86yAnThOatx2I+/4Z876wyqRKRxo59XHCLvhj1i4zUVXGRpRhKtlqrbzdQvQNBeGTBgmBavYkto+3nRSQhszqgpklN3qi/TUCNddAmR14mZfIlMetGqlMezxYJGadTYnRtTlnkejyBGksfL990DELB65Z8fvv9/I5fuiytiRmtGfIaIHVcHzLrXLcHW81EofBltZmOxTZGEwGWwVjsmSj0O9XDC5EvB8V1fO//NoY6Axmuj7n2MIigqg97R07eYKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=raidix.com; dmarc=pass action=none header.from=raidix.com;
 dkim=pass header.d=raidix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digdes.onmicrosoft.com; s=selector2-digdes-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbrR9uaFhpxq11dNtlXg5WvgOtLH9GwQXyijKThxVeI=;
 b=D/mNduWIGcVZWB8G5Pb3MfD6yXZNhAO4NXQstw2QNFv+JtsQrjHz65N4iU/vpXOYBN1TDJNsLiSydZm9qSeAEuIWVS4K56W1fo73dHXIuIykTyqBDpb+1JbfT8P4tCgOWuDUABcreaeXWNt/A9A2lPjd6xDQz9vcmWW4u0uFiEE=
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1ff::5)
 by VI1PR10MB3182.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:137::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 14:52:13 +0000
Received: from AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29]) by AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6047:e205:1bca:5d29%8]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 14:52:13 +0000
From:   Chesnokov Gleb <Chesnokov.G@raidix.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Index: AQHYbobah7S1K+EECUWb/HaurQb5x60uVaWAgAFZBkI=
Date:   Wed, 25 May 2022 14:52:13 +0000
Message-ID: <AM9PR10MB411874ABB2FF82B263EDD89C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
References: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
 <5ED96E4A-08F0-449A-8A9E-034BCFF1C993@oracle.com>
In-Reply-To: <5ED96E4A-08F0-449A-8A9E-034BCFF1C993@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 835804b9-b918-544c-18bb-4af0f8bcded3
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=raidix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8133823-6118-4a85-101b-08da3e5e2758
x-ms-traffictypediagnostic: VI1PR10MB3182:EE_
x-microsoft-antispam-prvs: <VI1PR10MB31820258B72C9720972865549DD69@VI1PR10MB3182.EURPRD10.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xUqF+4aKw70s7m49RUGXY5ZG+9Fun1G82t7zdIkrJ+YyKYS7P7MIiWWKGrbZ0wEarawdl1yE/CujtWk0VBjeF+u/vH9KTENN/IG9L18OLpKw1lFb5ZxdHa3tkF8164UQ4aBz47pNWYQ7BshNMNIDq1u6+4pg4m98qClmRWZbfVu0XrrnobA//+YZv/xD1+FtrzzMoo/UZ+K3yFDEoXdTJbQfYtFAR1PUg7xM+R68WKK+/Hcty2nBPqmejP0V0LUlPbvyJBFQEHFVSVv/IxSoG6toxcAei8iE1HKUXy4YK6bW1t1jFO/AR7sPFj+CwwQYo9hhSr6lxghODjIaS5Jov9CGyA/xRmF2KgeF3ZKYERXLfuWy4YiaWOYjUuN3u0KGrPgPxEaPiyqq/IwnOXnvv1iHkvUGoF2MZXBW3+MLhJDpVD6NNmyG/kTp5SXbs8UPxeuGUIOxqmo4pgy11q8245Ysv+0ZxmAP9WhAtIrgfqQrOGBMpJGnpZi6jNXT3/+wgcpqvUcUIh2MZU1gCf/cjvvqcsej1gA7olFA2eIH362bqAyZ7jECeqteTZDt6ehmnuPxmlonLoQw5JvMcd21/gR7i7Jz77J5KboUjVLIrvBvkKYF13jPDdPMyl9MDZVcteApLOoN3V/eelTKJAIjIFa6FfOyB0BD6iI6gxoS3+Md14VtwlSxzAnpbGbSGvTtfY1MKfik26rkVNhCdwx5Sg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(186003)(91956017)(33656002)(7696005)(55016003)(8936002)(316002)(38100700002)(66556008)(2906002)(71200400001)(558084003)(9686003)(4326008)(66946007)(26005)(66476007)(76116006)(66446008)(64756008)(38070700005)(5660300002)(8676002)(122000001)(6506007)(86362001)(52536014)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?VyA6aG+dkAT2CTZ09i7vrArUaDMBj4d6bACByWmkbW5ejoSNu9emMqKEHd?=
 =?iso-8859-1?Q?IxNJKlI75Sc+J3spauv5BmQv3J1nlwbDk+VKBfJ77vyk5parCujYgqAw7C?=
 =?iso-8859-1?Q?qO6ut8xG0yFSsQWw6BjuUWjrtK8IfDYrZ+ryitd0eC2shgncskQKqe+weN?=
 =?iso-8859-1?Q?bsH9wc60GbCPNGEtl2y/z/JvUI+aBdBIS5UrVW0rsaEbkLIyBbYXCKtevi?=
 =?iso-8859-1?Q?EXLdVL+j8w2yXbtkK96N8QTngeUCQS9tHs+XkWXCdf3WCLEIsRkmJPYBUb?=
 =?iso-8859-1?Q?MsmWCluv/aRLQIClgMASN0s8Y2lCsmKyOcdJoMl6/n/NMRic/jlu7yOOoJ?=
 =?iso-8859-1?Q?A27RVLN5p+vUUvXtlQGexbhLUyUb7CTc9R06O5WjaLR067vWeZbZ4BGBVy?=
 =?iso-8859-1?Q?f8mEzaGrXloMpCCliSDrISSg0z7baMDn2rc/+9/Wu20hmAjGU5+7B3GWz4?=
 =?iso-8859-1?Q?y3/w8QPs9nKzCI7XXk3FqeEdVzgWT6yVBhv2GdFjh6fsKZ2OtjvWQBXtmg?=
 =?iso-8859-1?Q?UO1FkwQiOdxxbjzCw0AuIFBjiqyJTjwb8qLn2J3qBgaxSoYLMWVMybS1HJ?=
 =?iso-8859-1?Q?ziMkWcjb+o7VX8sOiQjgphiPtU7V0qEAEUZgwdxVlGxpS4z1GdSna1SSNl?=
 =?iso-8859-1?Q?wsUK417LlSDrYkU4IdYxp+GZA1aCh6hEv/NaIli0lyKdNKa1IRSC6FibuA?=
 =?iso-8859-1?Q?AQmzGISjyhUlviUh3cdTG2i3M6BwXcdq8s3jZpDuU2vLGozMQExZnkGOuH?=
 =?iso-8859-1?Q?39iNFCunOM206Iid/JVoIssvlMwvcYwxEj3m6yRyTF7JcfbCUFs7HIb87A?=
 =?iso-8859-1?Q?lg5vf3gpI02iQBtABrp/SnA/aHKV3pKC8ioKPU9NGO1EkYMUXk+3jvPd3l?=
 =?iso-8859-1?Q?qGnSwe+zJGoBflTwctaoHyG2ujY7dwSd2su1VLwOefUQ9/pLc4nMgsbI8S?=
 =?iso-8859-1?Q?BFuDK41/40uYLsCmXcv0Ohk9eCcgijPr3kwv4utEhpDr25Grp0hHkMxiS2?=
 =?iso-8859-1?Q?XwVwpkyUqI5fM6UViC8ppqjsVFE1wH5Vk6+h+FdL8jSqwqPzQzMMzMteCw?=
 =?iso-8859-1?Q?zvIaiVdcLWU4dYDn1+0QWHrCZArRBtZJii1ieMCmfmyhh/oLG4+Pvw9FYb?=
 =?iso-8859-1?Q?osP8wDsA+7hSh5QSGbjNaDKfgwCT/OLFoHzCdJ5eT7HCNbhtKmmtAsdmQP?=
 =?iso-8859-1?Q?RMR+CahXOR2+keTOt0R057PblWsxQkYbr8Kc3FWGhMlvYSJvIyMRFkxYwB?=
 =?iso-8859-1?Q?kTId5/uH1yGAEz9GkQxEBk/Ks2+pkQDcR7EKh28B1XOIYu4MuZDgbWnyLO?=
 =?iso-8859-1?Q?Yb/hx/p8F8U+D6UGV/XqY+Xo8He48JMG6z20pkBgNPleNIAKi/ze0TEWSR?=
 =?iso-8859-1?Q?Bn2z5IdwtJnVc9qw5cYHKmIUmn2IXu+nc/ZHvD/UCer0GegQ5eUGbEfc1U?=
 =?iso-8859-1?Q?+NUGkT3Nj/YZYXubBi9q+T+cbu2+8PCFL0j+/qzIzgY8tOaNFmoedeSu7T?=
 =?iso-8859-1?Q?ON3spLAFIuxLHEeEW+Za7K+7Mcd+JE5OOF5P+//+JIi6rKerog5vmwlElS?=
 =?iso-8859-1?Q?bt1tXb1zciz8V5hY+1iCGMHS/aeLuuvm8kHvS+Y2vke+TtGHxn65oo5gFC?=
 =?iso-8859-1?Q?adf2Unrp4iZavLqtHVprOojT8oloIbQLwlj2te+9jzEytProOvIqf+pGme?=
 =?iso-8859-1?Q?i4PgNcd1TA/cLsFpbxsYwml8KiFQ/iJV705EsMuDJthFuwk3mrf4WbSbBl?=
 =?iso-8859-1?Q?iNWt5Hd+Fl615kvrONCPf6xGhx9nOrQRDmCdkBT5Gp1jw6AFsj/JzxG6ic?=
 =?iso-8859-1?Q?FHwKcOr5RA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e8133823-6118-4a85-101b-08da3e5e2758
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 14:52:13.3808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70c55e28-9cd7-4753-937e-c751128a9d38
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bOOG+Qthx2gq0WExvOK9MXM4bzZXGyUjHBHM9vnutGOn9BRPe+unWAXXIcbR16OOvAEU6jDdfPC6En/6Ptm99g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3182
X-OriginatorOrg: raidix.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Once s-o-b is fixed, Please add=0A=
>=0A=
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>=0A=
=0A=
I'm still newbie in linux kernel contribution, so I'm not sure what exactly=
 I need to do.=0A=
Do I need to resend the patch with fixed s-o-b as a second version?=0A=
=0A=
Thanks,=0A=
Gleb.=
