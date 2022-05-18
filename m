Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D75C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 18:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbiERSeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 14:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbiERSd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 14:33:59 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0980315D326
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 11:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1652898838; x=1684434838;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JtHVz1qb7/aVom7ayPHkVGooeNHTLnGBUebatJFiXJo=;
  b=ohPsD6uQTIjKdKMq7yDda2xqS456/t/mqt5V+ZzHiNvZT9G7G8B6HXMx
   yYvhKz3arYoueN3x08MTPw0ElmCALAjxSpnhvfFQ3T9umSAMzxuePwrB8
   d2hvhLXF2X59D1Akz++YGu+AEvOc5Gce9kEPYDdb/ciKYcb2a3vFqdnLh
   Czjlm/atlbQEEaqx4cAlci+kBJrPikqUqkiN8yg7ljj+W36z5qfHFvhXw
   GwW2kKwx8/4mJBbSzS2O9heusVnymxq0IIfjQmqzsgWXGITI9nc92sYuD
   cZ95bexffs2laQQkhWQ5212SG7NmF4gUJ2PIA1STed7fW1BvxDihuYEPp
   A==;
X-IronPort-AV: E=Sophos;i="5.91,235,1647273600"; 
   d="scan'208";a="304927295"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2022 02:33:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ir3zP9cZokTyh5Qbn56mNvNOfpmx3ysLLAppb8Uyln8OywPsivlMI4bB7xBKA5C9D8nBQUkE1dL0Q120nfIJ1QDH1axeZfuXDdC6pL06jDzwrYAVtMV+O2li+8cqLeSKWjzb4X7tCc3yDuzkqTbWcxeVUBSd6/+JgXIBXzTvsPXn5teR5Fpr1gVTPP1A7G0Kv7IKoEB3gLZQLlecUAGOl4Qqggx3enjdE0x1RniQQjDmV00T9Yt5hKFxuTxkGAYH5h3p964l4PhZuLQFzxC5rh0zdBG9NT2ECyzKCWStII/31mCnfWXeCf1f81eJHeGvNtH8cYgDtOJ1lcOj5A1o1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtHVz1qb7/aVom7ayPHkVGooeNHTLnGBUebatJFiXJo=;
 b=mSSRX1sBMpAmQpQOx7rKk6vuI4P7AQV49RxurNIL2yNb0cB4xKlIbhyLs6Sltj94kcOH7BNe0ehBNdkPP2D0Rwj2VeHZ2vFWfMsF2emlHAX6xZgoLsvPKgkguVc3Et98VQU65F21bL+Phf87V5RZ4UKu2TMNezTNm2C8ypnCXzY6Go5tiZd5H9xEYHeX7uVQya/rECCJqx567k2FsbSViI67i65UL6lIYQos1DYzROd/fHTxOHMR0GG1JemQNnAEOWcun8XdJndbu90fWv180jVDuG49Mgj9JgFEfy6+31uwJnArDl6eoibhSksoD77h69NRWltty07c+HsWd4YlXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtHVz1qb7/aVom7ayPHkVGooeNHTLnGBUebatJFiXJo=;
 b=am67/VKxaZfCqAHQZKCYOA/M8VkqMmakB1Bu52ewmMmoqfUkCKeAzI6b/PSA39Ic3cUTQzbsR3DWGLLC6IfpJAHUeQLMOUMDA3ga1pH7V7l4f1M30zkgWCvql+qDleu/uO1WbXpZHI9T/nYYN6n5nvIy9ZwQXyvnhVZoWYzO9/A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Wed, 18 May 2022 18:33:55 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::cc4e:5a1e:e4a:e3fb%3]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 18:33:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: RE: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
Thread-Topic: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
Thread-Index: AQHYZX24h7KenIxRZk6WVB+69AHld60lAGrw
Date:   Wed, 18 May 2022 18:33:54 +0000
Message-ID: <DM6PR04MB6575FA415FA75628ACD6E9E9FCD19@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220511212552.655341-1-bvanassche@acm.org>
In-Reply-To: <20220511212552.655341-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2986bf04-9f3c-43c1-102d-08da38fcf6c5
x-ms-traffictypediagnostic: CH2PR04MB7078:EE_
x-microsoft-antispam-prvs: <CH2PR04MB7078CE5C6CD7B96080B25316FCD19@CH2PR04MB7078.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9YJauhWX+7lv8TDXVYsMTtYhasRnaOqt9krCTrK7mQe+J8j8mQrUvAiEb5mev/PKKZI6j0QzxohOdNO+AQzBoYaMi9AlDOOobKNOA4oTqYJwMKz74Ty9b2nT3FrIHR3CiBTJ2Wuhi7wChyIX57AdiGwBsz9zmuL9JdJiLqX16LtJNHjcPZ5LjiubGNw8LnY1YY5d6MbV2q4MJ1li4RqJktCOGcZSizN4/hhmW1A2I+de82zlr5FsQ9PyKnvuYeEMFQQAf3341NUSNerD+u4s1HnMQ9zgvNw8nJqKLcOoUoJXLRm4vNFwnJR/h6BCa8L77cTvhWzp5A82kbAw8uvvl18nQFx4T9ihtsITVNch6LRMqu0RTCmCBWi22sXbf0Wdkm4LWJJTmKVZ/y9WiEaAxcDXwOtO4xDGvPQJBDPBaswanLIlDiJP66N9WJyEYK1QtPLX3I8T+fEwXWZ8AHysYiczRs6YoZeGtuSLY4Y55AJspL8l8iBTOCJuzFntQwKlsEwELd+QgqL2tqAkedA3F0afKvnQNJNE6IFs9RAOxYu6LuWwrOZ6XRx8uWajNqjMQKKaymTKTTQX3K/J5JbVabkiqNiqJ61Qkqb9tk71DQBQCT+bUy/Tgp+Ry3eny5XncWLXjaele5UztSFnR1po/JCrtvtx3bU+feg/Pq/UEADmKNjva4c6Yb2zr95Ieu8WW1OwaBVbfEj6VjSXKMJKcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6506007)(5660300002)(7696005)(86362001)(55016003)(8936002)(52536014)(2906002)(82960400001)(9686003)(26005)(122000001)(38070700005)(4744005)(186003)(33656002)(71200400001)(64756008)(508600001)(4326008)(76116006)(66446008)(66556008)(66946007)(66476007)(110136005)(54906003)(38100700002)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UCEqG6Rh11S3PmawVvtCAs75oqrIW7qvqsQO45Df2PKZgMHQFd2NPdUq+dbA?=
 =?us-ascii?Q?1tBs4umaVCaKeelVMwHf0z7NfCKi+h/V2d72Zj5WxA7QwyApxooZrUs8Qlu1?=
 =?us-ascii?Q?dm71KKdEH9MZ9hgzsU+EkMULwQbm2oo1OYKZpzbo90VJ4pmY+2MmKvOi+sac?=
 =?us-ascii?Q?Z2ypcLVwUcszt3nuEUfA4wPdrLo8pBYs1Ryok0TglPZs4Kp1OgyIrsxKOrsi?=
 =?us-ascii?Q?jdyyFbAGdeyxsLYC1eJm6nqv/zEej4CLUd0ERsQzt0TpbwrTD/6HpZJLqWiw?=
 =?us-ascii?Q?hzRIsmO5J961PE7qe3XYeXd3GN+3qqCGpjx/zq0wSplEpPk1ln/tH8mgkaWK?=
 =?us-ascii?Q?c6CsYeuZ6gbgXNIBe6dsVdZ2T5b0caFqYy/EkcM9mXte+3eNYTxiPUovGOsF?=
 =?us-ascii?Q?BBRuHt0O4IGl7MJkItg/xPD7r206eO3wl7vh+Ry98O3q1dsPvEyExmoudo8I?=
 =?us-ascii?Q?COocoM1QYUWWA41yNQ0fKqCSbu0bokX39zhi4z+fsb/zYe2FSOYntgxgBLdF?=
 =?us-ascii?Q?vIDfBSxhUUDwv4kcyf/iZEEaYoOAWdYjzRXr/DlOls8GwJN1FxiPciAPeBBb?=
 =?us-ascii?Q?FhRntz3NgaYhq/GHbJFi6o3xt5GahT6CZj8y2hmQbBOddtdyUumMRIr9NNOY?=
 =?us-ascii?Q?8c2JicDCj5KWo+IBnfqKMXKfU7Il4jL6PtNKFaCouDlszoxv5M6PvgUTkJ+5?=
 =?us-ascii?Q?+9KEduxBC0QoKNH6TInUSK+AVeaD06AqFaDfao4r2RlJfnsAv3ONhO9R5w1r?=
 =?us-ascii?Q?ttOBWwPFtkpLYBQkPej8EUn0R41uQqA0jyZWl6IB38mAcOuD/Rpfo4P8mPcf?=
 =?us-ascii?Q?pNzqpaHUlQZuhXq5GFB8fS6/Onh5rudU/5dVakzKfmbA/7uiTyZwgJUBASOJ?=
 =?us-ascii?Q?QJnBUc1Uu9dKuy7qWcdmAndxJYPx9uV9KbbmuljkJyjBiUuyMF5Fp7jwLsvo?=
 =?us-ascii?Q?ijRYSnwS8t626cjhWmrDwDWwkms8U90IBLDCQYDMS5wu/niRpPf6SYTJzCAS?=
 =?us-ascii?Q?MTUv4sdS4zIhQPxL0tZI9zOOmrCRSEc8OIptSoxtyn1aNUHM12j++SQh7Bti?=
 =?us-ascii?Q?vss/no2+Z4428xNCxJBERQP0IycBoXzyI9DoLeFI0BRz3ojeK6SzWTH/tHNe?=
 =?us-ascii?Q?4BgdRzFYKqPIiyx3soyW/6KRaWOIK3CWk5S7JcNzx7Ck5eg8WB+a+/Vx3UYo?=
 =?us-ascii?Q?5tEoK5cKi45WFO7EiSS32m3wdu/k/NV7vjvzJFURfuo4tPA7I9Bu09Ow8W6j?=
 =?us-ascii?Q?5PwxdASS3lKl6k7SA3ITSAp9u628dbZzM3q4JJ8yAdzsCvh3epkRg9g9MKIw?=
 =?us-ascii?Q?h82Z6yhgE8UWHUyZJzy8xgSgqfyoGgfBI02NL9MxgYBsOnyU3fG5DXDL0U+H?=
 =?us-ascii?Q?34LjbBJKMyEBT83fEzUoP3QxNlPb/P4NYQmnWOqKKNiQtJEIr4NaZPhh1RXS?=
 =?us-ascii?Q?ShGv5PvByc2JvtJQ6D3Xsc0KmWi4riqaiVy515Nogznqd30bEpWSbvaCFGqj?=
 =?us-ascii?Q?P4DjT9+SnSB4uCh7Oq1cszMcEOkBdVFQ8sliix/Dd9ujazdZwRn9DRdfde5X?=
 =?us-ascii?Q?aHgKQAnbSNHfAelcmGHhjzC7XB6kajndK4UiliY+u18KuS2r8X9qLkgwGMzm?=
 =?us-ascii?Q?oct1WhGcA8id8CIL3pHFqiNoL0kqowe3fiuHwQkpJpU8lhDjb1/2Jo1d7GGb?=
 =?us-ascii?Q?jSavLQ9gRnY263vO7PivZ5dG6i797kxK4icuZLBky80GyvuWiT42DBi1hwIC?=
 =?us-ascii?Q?QNYU4UwiFA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2986bf04-9f3c-43c1-102d-08da38fcf6c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 18:33:54.8901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ajfNqlx7VjRFfKJS6g8Sfgs8JZjn6nfYOYK1trtlB5b+5e6cBZERuj0d9MGoDuJWskxqg1yh8PlWNoG6/bJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7078
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Split the drivers/scsi/ufs directory into 'core' and 'host' directories
> under the drivers/ufs/ directory. Move shared header files into the
> include/ufs/ directory. This separation makes it clear which header
> files UFS drivers are allowed to include (include/ufs/*.h) and which
> header files UFS drivers are not allowed to include
> (drivers/ufs/core/*.h).
>=20
> Update the MAINTAINERS file. Add myself as a UFS reviewer.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Keoseong Park <keosung.park@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <avri.altman@wdc.com>
