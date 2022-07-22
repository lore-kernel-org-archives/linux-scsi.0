Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22249C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 08:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiGVIam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 04:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiGVIak (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 04:30:40 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6041820F51
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 01:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658478638; x=1690014638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/DQI97DqtlJXw8fCtN949G7wJzXD/nK60kgxwIUwwLI=;
  b=ezQBg2mQ7YwSbcokzWPJ+n2TjPpb/gkVDdUd+DwOBmE4FuXx5v71d5+r
   TcjTwDoHGfk4Er6xXa43gDdrA2MH1J1VTeXGyptx28pbud64C3lam4set
   Ly9lZ4Zy5j+3W8vjezjpF1vAg12hr5mxojwnIRQXtvJrgYOkBsXfMuXpg
   7qbIr62/Vtz7gjHQGz5BFeKjLQWzypL9tfeCi+M8RZ7C3FxijsAIvqA8w
   mZUpKqdUXw71JjWU0CgEkpdAuk7kDB8XPA6U78il1cv9iKm85Kbxx/uFP
   4ZGq5KN1zJJ+ASrTg3fsx0EVMcH5tOYtt3tjJYCKE/jGa52YHRVKgBBEv
   g==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654531200"; 
   d="scan'208";a="310961738"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jul 2022 16:30:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bG4uAC0qdbI+HkED+ekPljrE1PWsnE7UXuWAP4al080VySo5hyLaw4A6G3u80OS2RzLWu4aGfYf1LQ4epNOzKiOZKU0p2oW07YMNrl5a8jeELsuwUXuOxxYEzmTkWXccatnNvJSm41YRdtpOygxBfbljqpDbGIHrDlQGR3G2gulbnl7chq5xZ8De3H3Jsx4Q1qvT55o2xhtCHWRLlw1t0mjBTCseBzH6EvD+EpE+0GN5WElca/R6Xcx4sKVSTnZ57vxWAudUCjZ8HNDWXZXp89KZEzh2xJXM/iWZh9VelusKlzI+Wmao0ooUg9UbKA1+uJ5vYPo2y8lXw/7xc5NFhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DQI97DqtlJXw8fCtN949G7wJzXD/nK60kgxwIUwwLI=;
 b=QvcL4sxQKaKEw8jXeheghxnwYaEVpwtaVE79x5T7v38GKtoaWwVFaFFSrlAiRq5HmaHtJMFyEOVwLouCdYoAhRxNcibDdbYQqYTIQJ2X9RM8gHhv0wHMIPwHk8miLDDvXkqdx6xZYKXBfuxThuEVx4QUDphhXBVYa7g0089h/bQS6sTeRaa/+JDNLQmhQ7jp3qOAliSWAN1Goyoa6S8APAtYV+UhRfUa+kF5arJJaJweE0PblmXd0PlfE8SdmTKqku12tqVuQDcgt7wbctj076t7fsL0WY685Zng1QiSNqhAZu+SEza3uIdld3k2VZ6PoibadE4riXrKEV03MNlpDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DQI97DqtlJXw8fCtN949G7wJzXD/nK60kgxwIUwwLI=;
 b=JmUf1Uv4YcoR51IConZiPLz9oag+GSSedmrBMUH8YWtzeshpJk1HgfJtpNYi3RbvbvKOShG84A2D6kbOhQS4cuk8Ub9Sda/pKY4kMKp+GglrVrbsrITaBY9DOOe5sJp/G2NW0FWZgkr83P2vH9ki1kW4lMfKnPP7uAnFg8CTAbg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4746.namprd04.prod.outlook.com (2603:10b6:5:1e::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Fri, 22 Jul 2022 08:30:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%8]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 08:30:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: RE: [PATCH] scsi: ufs: Increase the maximum data buffer size
Thread-Topic: [PATCH] scsi: ufs: Increase the maximum data buffer size
Thread-Index: AQHYnFqlEXib/0bkm0WwZ/l/9PK7Za2KD59w
Date:   Fri, 22 Jul 2022 08:30:34 +0000
Message-ID: <DM6PR04MB6575FA4433A6743D5940DAB7FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220720170323.1599006-1-bvanassche@acm.org>
In-Reply-To: <20220720170323.1599006-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a844bf1-47be-4816-7f22-08da6bbc72b5
x-ms-traffictypediagnostic: DM6PR04MB4746:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: amzkW0pqALoJz9TVkJ3zqDFHFDy0/orWLAj8YWcHPc9r9+0wu/ZexxA44Ohj7v+ImUb6T3DG9H12SdC1k2Lv4Q2vRbyDZGYxvqX3Pb7Gn9acQPzACcMuNrWUDt8itaMzk89ZesQv52eOeMjNTlRSG+wMXgeUKLIuKMlhNfb+lwwBBOvVmG/+liwm2g9e5l2xd1hgxL20TiZR92gbqV64yAMYHkeMJs+CAdaaFi1gIQdZ9Lf3hah1fHviFB8stnONGAmcTag5thAOBL1bKjnAa9avsMw9nbhrFhf5iAoOpXLm00tOnZEtKkIUyNdVeU+DquTyVLLorzcCvLj96PHC/HOHZK5/YSXoIVozd8uKMV98s1eb0rGM0iGFKcsnKIIkBfM7+p9FXugqR6I3a8gRT6pDQD0A8o+LbYE22OhJ9O7LDlfkIGPTQ7BR7Ducc2V8JxMw0vjBnGpMYIyuZ/yHdX+ybO2tKvEZhAp7J+JhKd3xBlj8x9vuVG87ikjrW5YAyvud6wkcc5QHYcx1vmjEEXhJS1OzsBf+eaT0YBqTBRGpD2O+IbTCqUYP1hBWZgoMC3bBfgXl/5jYAwxnba9NXnWqoSCzcPtem4gYcHAslDG7JbtMzCqYqvEgDSw+rehc/DAkdlkavvajx7FNKPOojcNlYSr6h5xNc6u72rFjsiYv7CO+nuQaErJV2U8G7T0VhnasWeUUDkZydpu/gG+M0eZjm5zofQpE+zJM9mAAzGqqvpB8L1e1P8y4e6JfYZlW78lr5In0ZUs6etCaFO/tOdl4JjwFCExJvVq/vUEaqMSG7lN1CndnQXP3QI3+EjzN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(52536014)(4744005)(8676002)(8936002)(66476007)(5660300002)(66556008)(64756008)(66446008)(66946007)(4326008)(76116006)(55016003)(2906002)(83380400001)(38070700005)(82960400001)(38100700002)(122000001)(71200400001)(86362001)(33656002)(316002)(110136005)(26005)(9686003)(186003)(54906003)(478600001)(41300700001)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7UOX2IXCjU76pz7bJWpafwo5xerTkh6IAIjvrZBrvaOXFW+ixxm390QnKF1E?=
 =?us-ascii?Q?d+nza+A/bEfOJsX0jOBw7qf/Oa6mW9QxwoGsqBvmXWeE/2BvrW3PP+aKGNWo?=
 =?us-ascii?Q?d+PG8XJ9x/ILDMMAcSIwvJe2B3985qglc87pd8MyDdaY3vNMvhlgqHitocgp?=
 =?us-ascii?Q?EQo1SQxW8pMCkEWgsmSHfUcWsVG2GF90WwRgQkwZzDr6u17CZDZMHKMJ9PTo?=
 =?us-ascii?Q?GGzlGoAKk/l2aImK3XekAfx0/DQ4IljivK8LifnzemXApstXd0xDIjzt/E1G?=
 =?us-ascii?Q?JbNJXTJtLPRikJ3OVPTGwl9yyQmn/f4OEIeis6XLkXdtaMBdkXaMiWsC11CC?=
 =?us-ascii?Q?PmaOvQYWiyE8nBeMdszj8YkFpQjsLHwhbQgykNHj//L9Bzwl7LuJKcBhbnhk?=
 =?us-ascii?Q?AhyHNxssqxUIFP1XDROzCttWl04MYkUwd+iJumdeDMw0qwnuww0IwGdGc4GP?=
 =?us-ascii?Q?+z4ImUPLkNksNQ0CnLRF3+pKzvcl0xp64Go5fe5eR+UTirXMyTjEokC5YAL1?=
 =?us-ascii?Q?uAwZjfOeKqrGXg2Q71looT0xKA3Z0ju2rTy3bScySgyXFM1gaJtJ1cNmay79?=
 =?us-ascii?Q?5eQpc2P6TV3Tdg1EgvqjeA8w8107pLjROBV2ZD5cp+TOqO6h9l/vGYAz4IJP?=
 =?us-ascii?Q?GemIfMe/qaH8JMiHkQ3qwStwBr6bOWP5zHUIzUqG6nreK5mAHgwcTqxWviyC?=
 =?us-ascii?Q?PtMm9YEl3oHvWyplrR7vSiQfHTbhn0J+B328mfRehwkKLVTWRpMmQtGOewQg?=
 =?us-ascii?Q?OXGHRvXv5/WGOj+PqdPoQRrPZeOx62LEdZTPwQisCyFhpBIp0OPlOjaqQ6Rm?=
 =?us-ascii?Q?3+uGgYLJVRpwevH6TZMZwkQloMbJuygGKfLSR6u7hhiG+xgy4l3eI1g6POF9?=
 =?us-ascii?Q?C5w82F9kIlKi4KWouGt9i2Loo2tXbGo6D3IWyL7c1zleuZ9+5yzQHe4F19s+?=
 =?us-ascii?Q?FAnkPEOpksHs+aSTq9c2M7qCuwVrg781g2wrGWhWTh0jJJVjnrPZmpY+Mtrt?=
 =?us-ascii?Q?mJ5hW+9xFVAKOL9EZkQBrEDweNfpLcBOBSOqBzgT/zoaawrTgRah+iVwnzy2?=
 =?us-ascii?Q?pG5aQ/4VMLSaOqvmF+PlT2rm6iETdWKAptRCYiy7+uYL6zepjImoMysKCHaP?=
 =?us-ascii?Q?FC0pHE2M83qQRtphESSCu4L+G3YfJGZTEdC41dBKb83wIuMlcUTIorAMqIy9?=
 =?us-ascii?Q?L4Xk2JWJ1mlgCUq9I4phi53LyWj9hZ/OegcOo3NAbS8FN99J7UjnyiKlvo3a?=
 =?us-ascii?Q?pQhIqyK757+/Sd9TOgy8MNSQqub1C8G3F7MSchnd8SwU3PMjOi16y0yC4e/O?=
 =?us-ascii?Q?87Qvqj5k6JM1dxH9huH0CF2GB7SmBM89VGFqkekA4tYTXxh7mXEnnIQ7A8pA?=
 =?us-ascii?Q?HqorsS27RptifUI7iE8V/U+CS6GK1aqwHZk1q5whpOBP/un2cGO7PK0psH2y?=
 =?us-ascii?Q?15x+boXOibcZHpwye7YiuCJrCiYYFL58sM6NBlMSPwMDVdXP/OOmYoScVtim?=
 =?us-ascii?Q?k5m6HS8KNx1F7HGXel6IW4uaxhTmklq5R+LDBXJLuSACkuN4jsXptOIbgS/c?=
 =?us-ascii?Q?6VnFri/8IhBNm+T+y+pBilVBBOTdh4QLUirYKOix?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a844bf1-47be-4816-7f22-08da6bbc72b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 08:30:34.8398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3W0+cRMi//elIaPM/08VwT0EcSACoOFOS1huMsBu3fkpb58ltNllW8lOlYXnfRtHRsWw5BhB5HEkD/+xPDD99Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4746
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Measurements have shown that for some UFS devices the maximum
> sequential
> I/O throughput is achieved with a transfer size above 512 KiB. Hence
> increase the maximum size of the data buffer associated with a single
> request from SCSI_DEFAULT_MAX_SECTORS (1024) * 512 bytes =3D 512 KiB
> into
> 1 GiB.
Did you choose 1GB to align with BLK_DEF_MAX_SECTORS?
If so why not just use it?
Can you share those performance measurements?
For some reason, I always thought that SR performance is saturated somewher=
e around 1MB.

Thanks,
Avri=20
>=20
> Note: the maximum data buffer size supported by the UFSHCI specification
> is 65535 * 256 MiB or about 16 TiB.
