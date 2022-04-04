Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C92C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Apr 2022 06:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242277AbiDDG1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Apr 2022 02:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiDDG1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2022 02:27:15 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164B317ABF
        for <linux-scsi@vger.kernel.org>; Sun,  3 Apr 2022 23:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649053519; x=1680589519;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f0J0gkqtiSs/1w2hDzUgr1+ryetdrz32ODfLN350ZaY=;
  b=nVYuaPpZjd1rC07x28ePAGHwY/H3oWRkQKF6k+1faqCtHFeFV8rM/IwA
   TKR9BKkFtkO+7s2HJSMT5jIN7iBG8HKbpLF4+2N4E01naZMvxu1OBM2ny
   lRdjw4RjHnZf5TPlmSjHGCwMEgaa/YWk3qluLXcTpKTqQp88kVRIAmhBc
   hyFq7u37Z0msxdB3vvqGb+eF5rHwP4LSliKsJJUnYl3xMT0oGVGX/WQFZ
   GvIMAMBNO4+GSLVUjgpjdaxFmXjODPJ7+XQWftNo7/0XB56FEt88wAcq9
   Lqx62/ai1zRo5bzBd2e81I8OYj3d+3Vc4dj1AggPDSfCA8m5muJIyYTYD
   g==;
X-IronPort-AV: E=Sophos;i="5.90,233,1643644800"; 
   d="scan'208";a="308971673"
Received: from mail-sn1anam02lp2041.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
  by ob1.hgst.iphmx.com with ESMTP; 04 Apr 2022 14:25:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es553gAncvMbfCTzFUh3QzlqjbkB2ool+PCq1h5zzdcX7Gkzs23fIq0LakKnG1+o7mPatzeKTLe58XzBTdfPyupNFW+ibQ6y2x5juOneN+o+bNwjfDXHMKogFfMgYfNzu5BRSA7VNgAKnoYxFl4afKwPWRjEotapk6iqpjesaJ0k5PtounXpO/lb1rnX+OZZlKgvKCWigPJJcNVBzxRD3apbP7dk8Gk9NOQtk7BFSu7K03kOLAgVsHJdkqvm1yvcqTmw183C3OKM+nOsgejGYaU3ZVjj2tktvp+FeQ9aN68aHCu/BsHWmfEL4envHz6TISTrw7vdx2eJhj1YgpdjkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0J0gkqtiSs/1w2hDzUgr1+ryetdrz32ODfLN350ZaY=;
 b=CZREyKqZouiRxmvt+xJgFwoUzm8yq4X9jSRJxXegbflaFksBDP698uj4jTs6lxKmVbNFQamW5A8Fb/SwpFJUUNW1zj6vFQf0I8sFZpbOGiG54YPscMzd6wWWvl0T6oEoNBN/Lt9q0+7rhRY6dTiw/estrGPqgNJLJRAcjgkVy2j4vvjUttKfdJUHVVvLmuf2SY57lMy9qxDK+GOviXlo0E4V530C38wiyG2OwTYzb8PufuPXVqS09O3ylr+SlBpVmZbJH8NRB1eEEDUE3747Ung+efuGFmUf9NFKE5uApmstvf+48wI8HoLd6SV5RWM8aUj2kVAEpIve4yA9v7pj8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0J0gkqtiSs/1w2hDzUgr1+ryetdrz32ODfLN350ZaY=;
 b=KNjQSANtlD7PGWOGzJAjMLoaakS6XEBdV+98pvKlufHEeI4YBlM2VUpjKA5rBsbV4suRirZu3DtCULkpDsAZCzsnv+2mLmcdv7EK9eEGgHkoRFdlSYQrnfbU8ySngbFk92fAv0D2+/bWWZ4clhMMhs9ZydZ+nR6W6KPfqdVmlog=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB7958.namprd04.prod.outlook.com (2603:10b6:8:1::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Mon, 4 Apr 2022 06:25:17 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 06:25:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH 15/29] scsi: ufs: Remove the driver version
Thread-Topic: [PATCH 15/29] scsi: ufs: Remove the driver version
Thread-Index: AQHYRU/aQ5I8Swht+kysSwu6M3Ud8azfTqWw
Date:   Mon, 4 Apr 2022 06:25:17 +0000
Message-ID: <DM6PR04MB6575D041934C1B0BC217226BFCE59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-16-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-16-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92340bc5-4f4c-4538-548e-08da1603e2ee
x-ms-traffictypediagnostic: DM8PR04MB7958:EE_
x-microsoft-antispam-prvs: <DM8PR04MB7958059E73B1C7F9306BAE62FCE59@DM8PR04MB7958.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Kv04ehqajw/9cU3VhhxbBcMCkti7wk5SMaLtLnCIQL4fi4viEYZIzrAqFJhBUQ0FqD/7+9bdOor4SZHb8AJO+aB6tFMhvhi+VV689AppFj0xPtodS4y/BYHOVaj92tBGwnEHrPzkv0c7anRUGYnsrTlLFIbtIgKuAoXrkg4dyy91KkoDOpaDr9j8r8A4rK/etTSlP1VkZnl57eIAdv7si/rinT9WebiRN5I9nxtmWzUmmSC7BP1vD3sl58QOpklY9etQVMzDbltvfe3upH2eb856yY9ZtwPwLdqnH2vZXJwXtLDlDQMgdRSTnn7ysVeEOhIErUBSw1+MhRrcLus194a9E+GEStB+ePoRWpr+UFoFsht7UQu01ahrtmwu/Y1WgTUyXo+rmK0Cx3ra8REc2hJAp3+rgDxQZj3Kh4/XhAb0ToIJ/wcC7+OuszSfWDLc795JrirSGqxA3jyMFiZUFc3iLKJRpAKFhcj173pGJI7cvwk5KYNFVTezhk9YY/+AIqc46MTAyhtnf1H/CAxcr7fG92SsBp+J59ELb/3k3s3Hw/deR4LMYtESUlwj99HhvLC8fDNxcORQpAZKbaj1QbeFr/zFu4UeDB84qZ2kf1uRl8AMX0M8A3QpgbaM40y5KcjbUozPfZiW57ROcLGW9CUsxBCCgH1EJ74nEtxbToRoY2JxXNsPSbSPnSorVE8/0yWAwFoDB2ky67TzO1Faw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(33656002)(7696005)(66946007)(9686003)(55016003)(5660300002)(122000001)(4326008)(64756008)(66446008)(66476007)(8676002)(66556008)(86362001)(558084003)(26005)(186003)(54906003)(82960400001)(52536014)(316002)(110136005)(71200400001)(38100700002)(7416002)(38070700005)(8936002)(6506007)(2906002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LSnaWkZ3HRQ27812ScjXn2cV2fR4duRKJlCh0b+iRPd/Anxy5YbneHWURGWa?=
 =?us-ascii?Q?/WPdAEJvDvY7Gtffet8TkoXOOUzmG9/M1m5WQO2GQHUpJAlRSP9YFQMfrVtP?=
 =?us-ascii?Q?dGULKOoZ6hIMhXadgC0+uyg85Q++uvYkC1xDEoq0oDe6RXS7KwwYeFM8UyPh?=
 =?us-ascii?Q?5+uvmMtsbCgcfzwD3cI3jPiihVzt+A3K2MD7VYVhzZ+DT5gt+exdSLUDl+N6?=
 =?us-ascii?Q?FWDsPFDqt0vVaKiwcD1aJuKqzHByWznzUWwtLqtNpmqPVsVEFxZLoMCx9Is1?=
 =?us-ascii?Q?pgB6llFSPfR7sHTGRXJWG/arqDys7HqlvMUrpwVka7Konkm8LdhMM28RJ6cj?=
 =?us-ascii?Q?vxl8X5wchCWFFhrcX50qUcLDp8pJSroXiR2uwlxrAeSmce0jO8lTs4aeq3kO?=
 =?us-ascii?Q?G/JavFgKhUwtVjiyStkBaSn85id3GLXG+YDuV4B56PGhyZ3WyIOZpAhCHa0X?=
 =?us-ascii?Q?cjnYd+xdP7/tefOKsxKLAtE7wiPYWCHRyTIUFLChIjTZfReJFZC746DItynY?=
 =?us-ascii?Q?dmskhwEWFV9HdfyyDwQpG4oOqAiuOF95RmZKXV+wJ+m1ZDuo6erHlk16USSe?=
 =?us-ascii?Q?Q3d8mEF17i+SZAgr3UkFBFjWA3GpED1Uhcqdg4fnPrKoqFcxXbM49z9hytPo?=
 =?us-ascii?Q?T5lZ5cJk5idh/7NsIMt7YqucI6UTF4mlGMwcC3N0KQN5NmGV+EEPejzp0pGe?=
 =?us-ascii?Q?KYwcawDbkE5uhvHZAn2Ai7PQJePXddpLdt46LR8UMqCkqxZ0hLHA0IdlhpZ3?=
 =?us-ascii?Q?O5AsGz7i87d/sfMt7MOFkOWPburHMaMMXplZVdo7sNG+bU7xPX90ntuUNeO2?=
 =?us-ascii?Q?/s1VN8mMJGyCujKnwJUlCEIWSwZoDKmGb3zwr6E9+46PK1RFRqApc8L2ZGPy?=
 =?us-ascii?Q?VkXJbCHVFoJWGO3DhyR6x0Kr/Nzi9RYFsjEkRwkttbQENS5WOaxihkSwwswm?=
 =?us-ascii?Q?jpiK/WaET4ZOraqN7FGmclnePoGvS3yyaorq67zXRBMcH7DOM3BtqgztwmjU?=
 =?us-ascii?Q?Zln/EBru0PPqQg+9XP6Xesu6tz+cICAj5ELBtXwt6YDzzVnziBDHhxlzVlaP?=
 =?us-ascii?Q?bkUHPQbruYeu8uJ+Cc60E+rN2EGL/57oh3ge9+1fP/bHIKn31aKUvnZIuiTW?=
 =?us-ascii?Q?c5kf0PPYsSbRefb6lX04ZuCzY/jPdE082rB4voqfIOQjkka7x8XWxp6uHiR2?=
 =?us-ascii?Q?9Ynj5qnSp/uEcl7+gqvUYrAC993oBzNaLTJ3ki49Z24GFUIz2H7USkA6loki?=
 =?us-ascii?Q?+pByRcS4d1jgJjODaRzM2gmQNf5O+J7k3946e6jsl6lk9in/vTRSu5+sfjU3?=
 =?us-ascii?Q?lQjRqJwkSP23FVsWwBP1S56k4U8rP4d1hyNiq+qGGShNcPampEtkW+JIWvOy?=
 =?us-ascii?Q?Bo5F/Yb6xYnfldJI5M9CWZIk0y7OsGjqkpvi87u5HHNVhg6XH+YuChiyHwpA?=
 =?us-ascii?Q?VUt3qiRHrSLOU/kL4CoaoJTU6wIGfPD6hyHc10G6T1Evjd0IqLMIOGoZ882G?=
 =?us-ascii?Q?EFUONHECng+xJLm9QojShri3W51tlwZexXLOhCoSCyKPMwTejpr1O5CyzJHK?=
 =?us-ascii?Q?WFqgraIweukr/nIg7TobQGo3pAiBKK1SDsgLVpK5kV5wAmeZU1G3q4Hm0xj+?=
 =?us-ascii?Q?IfeUE+y7ZvqM6LPWuOgUS/oZ/mSshtxswiu+NhYSt11nbFzeQuESDeHAwOhP?=
 =?us-ascii?Q?Q/GwOeFHtqfpn+k5znwjCShCfeiDAk8X1q0lumOWaqeOtng7kY1lu+IhWwNZ?=
 =?us-ascii?Q?K27G29TPRQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92340bc5-4f4c-4538-548e-08da1603e2ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2022 06:25:17.3548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qs0/kNyZJ+3bh7BBNysr/AWbz4vv1myHMvaooBWWUoUK5dfKHj7bpFbTqzpsCtE2Bx/7pFcnbUQiXbTRqbvVRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7958
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Driver version numbers are not useful in upstream kernel code. Hence
> remove the driver version number from the UFS driver.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
