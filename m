Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485FEC433F1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3513D221E2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="e7ojmdTQ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Gif9B6D4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgHFHIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 03:08:12 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:51737 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgHFHII (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 03:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596697688; x=1628233688;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i6ILggSoaj8v+P+32X8VOpmr3H4b2DO0DSnanQJVCC0=;
  b=e7ojmdTQ/O9vIKxkm2fUQS9x1wxIqOcopg9kAFubDhU+6BFJwIlRVjco
   dPRMVLh36E00NZUUAmuDpxf0zV3c37pHIN3TSOdMuiDTF0fZwfmdvHF35
   ERNlWX+w5QQgarX652cbiosiOjgf5TlcCW+O/X6POHWpyflgaEe5TPOEg
   rhg8IsTtJVyTtVtrbZtYLMtBM+BIcG3AAwJPJo9Ml2lKZOi3//kvoXdPv
   uJgGzPgX+L895YWJhEBrq4r/Y5q59iAqeW1qvKOyWtXXWblvPjuN2tk/J
   h36T+1/kOvjjX6M3HoInj/eWZnO1CNKHT8FByRzhlsXtACK+nUsWqDaEB
   A==;
IronPort-SDR: NOVNs/GY3mIuw41Gn/c6of4WA6AVXxzo56tEZrJ2kxET437SZqlSRLsKy0Xqel0ofbnVSWRg4l
 iSchgpEHjfBh2FbvR49jbMRcaPI9r3ARF99dOsS2E0h/FjHqkc4AyY6jc0AyVbyae5c0bzLA5F
 be1pUF30aSY65XfoZQ0yL/Rz7nR/89b02rUF4Ukv1pQa6L+AP8kiqaJcmrz4P5AFsEQcVUV0Il
 UXBmoDW/uivHRBN2RccovCv7AtcMJsk5lN4NRjl+WNSUigrQPJtnTtNclivfNHYvKleakdQK4H
 f20=
X-IronPort-AV: E=Sophos;i="5.75,440,1589212800"; 
   d="scan'208";a="148590151"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2020 15:08:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ell9rZxyJYRHgdnCUsnzgQHZwMUnzhLQtt5jJ2AupYck8F8mZoLWebWTfRzL000gkZI0cvuoswV7PCbFaaDbtATYo2wUJGLbUN65zzUSb7gzCESSdzHoSMqSsB1kZuLcvlzgnBCLJG5zmsnxBCTPPGTmRmWyZBUB5MQGmn/fxyt0zYgAsDohujzGMmsAD4eqKrxg4O23EbxB9RvUIyZAb7PgrN5WVl9YrVE6Ase0tR2KbAi+VsBWZht4rv9xXkXdfdGuZT58O+k5HI+ksY6/WgW1c6evkwYMqUnAdaDWzGdoTuZ9hluh0DGxNKqGcPOGkzUIc9YMdOgkSGphOiSdlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6ILggSoaj8v+P+32X8VOpmr3H4b2DO0DSnanQJVCC0=;
 b=UKaJSY4P4BmNhU9iStgT8ZOvo4GmgdM2Ald10/0lWrnjGIEnMAxH0edpHQEJN918NjAIXHjKEplv0BbxlLovVSIk0W3cvX9LLiifvmPb5QNMYcAYNrIBbLk3p9QvUSziIB1NRmZCIFWN0s4j1itYY/tjhJVxsZSvpL/0Th0A0mV1Ix9M3pFI2cy+pDXvhCkP8hVQOV+5wkvtWpV/5y2vl5sspPMC4MHUDBz5EV14vWeK84AaQFTPb455UszJidqnr16Irf5P8ve1khRDGoq8e7S0hmOQwXkvOL2u4ZA5L9ANzBW5QfkK3NpOETYfcyWKUUwazRUkZbaAFhlofhlKDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6ILggSoaj8v+P+32X8VOpmr3H4b2DO0DSnanQJVCC0=;
 b=Gif9B6D4fewqjJbwPCaTy3+o06DnN0dH9zSkg5SlOYFBy/ML3fsWiVJGbJeGwQPJXfRe0RqTGqBaBZNgq6ma06+kJ+WCNOwlqQLAd4FrF0QoUKPJUknSt6l22vXCkPkRYXibm2TymuM7MHw7z9xa0EmYiSoiqXBPpYXTBbR6tUo=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN4PR0401MB3632.namprd04.prod.outlook.com (2603:10b6:803:46::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Thu, 6 Aug
 2020 07:08:06 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 07:08:06 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] scsi: ufs: ti-j721e-ufs: Fix error return in
 ti_j721e_ufs_probe()
Thread-Topic: [PATCH v2] scsi: ufs: ti-j721e-ufs: Fix error return in
 ti_j721e_ufs_probe()
Thread-Index: AQHWa78US7jgK0oOakiuuLwn+3qzRakqqPlg
Date:   Thu, 6 Aug 2020 07:08:06 +0000
Message-ID: <SN6PR04MB4640BBD412F95CE2A1E28942FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200806070135.67797-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200806070135.67797-1-jingxiangfeng@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e29a1af5-db84-4ee0-db5f-08d839d777b5
x-ms-traffictypediagnostic: SN4PR0401MB3632:
x-microsoft-antispam-prvs: <SN4PR0401MB3632945E2F53E4A3F503662AFC480@SN4PR0401MB3632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K7t/cDt5GvDig3hqYCE/Zv9nF2Dv6NQMX76HYzzDm4UJb45v4cZvdChAq+L1rqlVVs4c1ulrl0UHsQRmtp2SnlrmwBc+yT4CCIN6RJFYTgZY30a3CutdryP6uQShNbOlUX+ovKRqznIQ7KGe73E2X5uoXpd21hpcCiEdATwShwtMC2DDU4zcGM2AiH9TJcqAegR7eLOrQ7qpHx6b3tcdxAqKZMrrUIr7eSISQ3+0VdF7WZU0HOMDw4xHbGaHPA1ATH6KCW3yieZJCQvvpV3slWfB2xO9vx48xIctKdG89PJLqfzLGey6OBMi8OBeflCy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(52536014)(8936002)(71200400001)(76116006)(33656002)(478600001)(5660300002)(26005)(86362001)(186003)(110136005)(7696005)(2906002)(8676002)(9686003)(558084003)(66446008)(55016002)(64756008)(316002)(4326008)(66556008)(6506007)(54906003)(66946007)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 70IOZBX+cMUjTNgQvd7fyKf65W6UampALIpqFvK4/iJLHqq8xY73gEEuA8yiqmyOUq0hi+VcWIOwHQt1o03Bly9hH0A30o/QF9I/JyoITMSFmcuS0i44aK49xJfsqLeYQl1drboRRJLfenAuktq4OwxuBWOIJcI89HA+bLjG6Nfs2q88PNAGSmQhfBmKZesvuKdXCJsejzTlZEW/NKZzuJzNdAymhygwm4Q7/7f3CDqD2r2D4oX0mZV0vZw9/zqLjrZDBnvkwLrYQxsJPMyGz1FiN9trJvtX060/E0s+jI8+kOzU+Lfy36O7hYz39WGLE6XIxkqmcXdKaMxST0DsoBqikKGxVl30GJWI0mRKfrJZQBE809Lf5c3LHOHlW/NqxOnXUabW1D8OKJpw3vnSS6ud2BXl01+ydNz/8ByyD2IFLhLj9lLKfuVu8CSqp8ScdkV/IVBID847/IbOiIODTqcjUPmnKqtMPDu2dc6ktFtUdOfxAEuPyIGO2Qaf4U5zJ5drynJLHc1EXqom9Acr6Pxsyo6Sv4vjlxXqew8L3tSWCxETWpojjHLgWatBcGmjA6iREhLHZ/+MQOyvQha5XFFxXYke5nU11nf3/Hvi8Bc5Ut/n8J6WeX82hDc9UJkEMfge1dySMnO5D+60tGx+Vw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e29a1af5-db84-4ee0-db5f-08d839d777b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 07:08:06.1064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTQTgR8EP0cyvjF/SaztC9kuY1BjPBfzyrxcgI/B+g8oPJ//QBeTRgrYehMdSfQuodc2ueDZjJ/hvFGwhLiYkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3632
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Fix to return error code PTR_ERR() from the error handling case instead
> of 0.
>=20
> Fixes: 22617e216331 ("scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtim=
e
> changes")
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
