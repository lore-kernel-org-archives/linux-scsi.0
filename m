Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71B5C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Apr 2022 06:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiDXGqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Apr 2022 02:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236405AbiDXGp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Apr 2022 02:45:59 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D995A50447
        for <linux-scsi@vger.kernel.org>; Sat, 23 Apr 2022 23:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650782579; x=1682318579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5psDbCB9thpudZbngq7apqAchM9EzSQqBGdCg5dUPtU=;
  b=i7m5lhW7Hw4X/2srEhj5NpRgWenjbGEBP+StJWHHQd+O+PiwxEm+lvTl
   AEYZZWWbm8VrwlPLhIaXMt+HpOBhlKlMQairoqd2QL+gS6RaUUAaPOMy9
   EqNGGb8wNN5KzJRhvHXvhQpml0MLOfP01hubjR0k+SUvPBo9+XoUTxz6f
   O9n3EWF0ISuwpRJeT58mhTPxRfwc1EC73KlIThsSRVgy+lbYOqn9HCXuB
   kJ9CoT0VYciXcVNvHAImUqSP4RpNizBvfURxv87SlWVoFVJggpF7AoJoY
   knPSF4tCxaXQ/77Bh+gN3Xboip5/yAGoFtJbUjQXwQadduVcRZRSRvZeT
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,285,1643644800"; 
   d="scan'208";a="310640440"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2022 14:42:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY3NeBYXrxRTX4anZhQtrdfyLcXtEAxQHu0hTjrVX5cAL1nS4S8I2zNMX9uyVkC6aKxwAOLBR89/Pr4kQ5kHPqqoRWxsyNR0wz02/dGaUFpVU97cV4L3qTtPJI5jJJkf5lcOaczoeIMwVeNY1sak+jNx6NNjMneY/Ap3Tp8PSu6up9VPc1cG2MR7118xRl6nOkt+sdaPjre7ngQWJp/ZpXs70iTGD61CstPhlFA9dcOVIQOCYOyL3/J4HyfBAB721CF6vl+9jCsWDw9m5Rz+iAgQYku6HzJgojj961uMI0vpnDFz9cUgaRrZcpl9oZlJhPLYOx9t76FxONfxcPB8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5psDbCB9thpudZbngq7apqAchM9EzSQqBGdCg5dUPtU=;
 b=eLMllkAuYnToGawC08Y2HSJZg100FwPaVok0Y5Cq4o7UDhkTXpWujkblIjHc7nBM9fw30XN2u/NauugHaLndOxukC6KKqT8AWM6/PwCUUTJ5BmoeQDU8mJyqql6hMQanPCEMVBrPQ1fSfjUqI4VkHE5Xsm+7CGHPYtsqcOmVgS0kfRuXGrmRCapXi9nKxnA6VE22WHcooOyoIvclORjspxD7JNJj6yJxK9XKqzioyCoOWfSBRVoqjnqz/yw4MKwctiPdxd8zBE8dvFUCfJu2mkHei4dtPotQkcxK3b4Q0I0ugO5nw9A3paK2pvUIPji+UqGNcZjrMpkndOveqz/b2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5psDbCB9thpudZbngq7apqAchM9EzSQqBGdCg5dUPtU=;
 b=bzd3TYbpdf4yuG9ZbgO5fS6uAv0cW1UyQTdmFHpgzfqL8xvLmKf1krDkQ77vanKRMkid31urvPnaQiqBE1vBbrhDZiRYtr1f1lzjluO/rGZ7XTRZLaLXbbEY/dj/PqD05buY/qoe2VcT07/giYFK8rvjLBnPzITM8HfoPTtsAEU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MN2PR04MB5949.namprd04.prod.outlook.com (2603:10b6:208:fe::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Sun, 24 Apr 2022 06:42:56 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5186.020; Sun, 24 Apr 2022
 06:42:56 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Konstantin Vyshetsky <vkon@google.com>
Subject: RE: [PATCH] scsi: ufs: Increase fDeviceInit poll frequency
Thread-Topic: [PATCH] scsi: ufs: Increase fDeviceInit poll frequency
Thread-Index: AQHYVRZhyRRshAHUI0+q0kOC6TpCPKz+oqMQ
Date:   Sun, 24 Apr 2022 06:42:56 +0000
Message-ID: <DM6PR04MB6575BFD9DA4927DE4BDE1AD6FCF99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220421002429.3136933-1-bvanassche@acm.org>
In-Reply-To: <20220421002429.3136933-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf3b2bff-3bc7-4c09-aeb4-08da25bdaa9e
x-ms-traffictypediagnostic: MN2PR04MB5949:EE_
x-microsoft-antispam-prvs: <MN2PR04MB59495FDD3A2D169472B079F1FCF99@MN2PR04MB5949.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7ZBB4ufC8awO7XEiEoj20lgfjxURGLsMWCmfhJpXHZknte434KV8A63RCsDgofmw3+citRsT1weGU3zJuopNhueo9jlhoKuby9+g7Nc0GMNeCv8npOTZadVFSufySjbHY1qTRs58Aqj9mt3rfk7YqeUFGN7XNUvAIHvmpqYL34nrU0iR4Sw2thMGyIUBuy2LTfVrEKmtWrZg7pHnMpUQjeU/EjyD6YyRoeeDixtReADNI82HiztmRDnh7fHszu5wcjBMwxcKXTkQInvsiLZvcB71N6MirKwEUngPjDuMQZbPPmXjILRlyDhqu1YhZ6cgIHot/zQw4jwux9aN7mo10AGshfyC8MxqBppcIbcdN2zc2FJ7mR2U47xjBdVr8Ijcr/UW/geIoyVd7MXP+Z4OBsk630+i+H+0zYCOERTxwe5qp+Db4EVRLXclmTU/RmThxNoE4GbqkBTrEcuWtWvaOFmkjDBEPPuTDeOY7IGTVEjLTbNvNwpaGi6gbE/i0R5CX0FtXD0zeFjyt9FUcKPFSnuGY24WM7lHU48eBJxhQcA4/706VGz1fHwdIdU89O6FKHb7i/kWAvrfdskEdIINh+3ix+feHbPDACdbkJJYJg8KtKTzM4LgSH6tuPX7qoGFAqJ8D8W81looEZGfOl/jhu83WxS403ADFgW6rY/YIE/YLsUBkj06pRjQaYUfqrTPvBakeudC7f1iVXllsnmrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(55016003)(71200400001)(38100700002)(38070700005)(26005)(6506007)(122000001)(54906003)(316002)(110136005)(86362001)(9686003)(7696005)(4326008)(66556008)(66446008)(4744005)(76116006)(52536014)(8936002)(64756008)(8676002)(186003)(33656002)(508600001)(66946007)(66476007)(5660300002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tizUajgDIFmVkUvSdxAX7qvAnxLTrxNk2n9ckSV+GceYwV7XqLucvqaqKCl7?=
 =?us-ascii?Q?qk8TvGy/IkWdX75dveqFtnR7WnnzzVzll+Hg8fM+kJZOgrey20uOXW8vI3mM?=
 =?us-ascii?Q?/5llZR1PckoqZZBwwuX0avHUSh/i4bdtDQZAEtAH3PCelYxfl7TTsTt3JqI5?=
 =?us-ascii?Q?XjWe/JP6uYUdtJHycz7JBi+bwN+mWXYfNzIOw8J3OWV7O0l1yhDvf55QjPWU?=
 =?us-ascii?Q?ZU/GlQ39vrhGdzhqJ+4HEW1hDIjAKRou4UamdhOTOiagA7VxZLuEqW6EkDqf?=
 =?us-ascii?Q?pK54sdT4IgKXDJQobWfNEKtm56Fwwd4PHxPUEk9G/wz0k9oNV9mzFJB2ghYK?=
 =?us-ascii?Q?22EG61BqTemDIhCNGYh7Wp5my2GPWK9f+uc46JpHuuklhrhJm1Uf0N0iwfUS?=
 =?us-ascii?Q?jS7zl4KBOzH4lPdDqkAbPZLXTeRyQvYJJaSvA3nfVONlGBulZfU1kJaI5zfR?=
 =?us-ascii?Q?wH+WSBk4EyHEpin3TJTZD5WcY5hhqidjqYnQ+nxZgw1hPvULXr5e6TU9umQN?=
 =?us-ascii?Q?e1H1AirSCMi50qD9zz5TgraqLfJYm0gsn/HqsHLr5ijyfjPOEowXJPa1EKZV?=
 =?us-ascii?Q?tzj5GlTa453E0zEoGOW/z7J8Vvmg1RQ3ospSUAlNKGWEWxQM++/laMw0hg5Y?=
 =?us-ascii?Q?WcDqttdZlIz+b7DH3Ih7sIwmMgyUT6roXXhJzhwhCXc5Hb+WZ8IyWaZDfL/d?=
 =?us-ascii?Q?lTkk4J1vk9+Fhx+4d93k3mjGCh9Ne2c7waV//vy5Q49s4u/EzHdI0He5o4HY?=
 =?us-ascii?Q?LVVAxKSA6jnEu7daZsLDu2EhOZjXgHwUImzxynJ/ChV/hJnnPVaC38qC3Wn1?=
 =?us-ascii?Q?42ALb7JkmdM9Yr87hIGAvXIjbWWIMFEc27pP37+a9ulmypbt2kH4p+RoSZ+U?=
 =?us-ascii?Q?P7iMoreGyKgOJoNvrdOnluZq7dsCWbkWp9FNH/iZvZ6GTbocqS5oWNQb7SiQ?=
 =?us-ascii?Q?W6mZB02tZY/ViooXG3c8MAa2UojJFVU6m1gpuz+vTqtidWyyJNYzI782At3M?=
 =?us-ascii?Q?xAB+Y0HsR8NeKwhH/sMIMnmrUm4sMk860pIaDPXNO0sXLEyWa3F4ZKQCT0Zd?=
 =?us-ascii?Q?fQfDI5w+5HHsf/UN6P3Q4lWw6wMGmvl3qpFmX559a97fJABzlI2YKf28NnlN?=
 =?us-ascii?Q?moU63Wd9spQ5TKwJm4QKYNe62vhjafwIC+RynjAblU5tieAavI1RP8vBPAaq?=
 =?us-ascii?Q?uZ/Mf7T3ZOzxDDyFnrSn4p0elA89tJg3HHWGS6cl78p7efHYiayXy0Empy9Z?=
 =?us-ascii?Q?l7wLoYe6vvlIDyn5OiRcEf7lKzbaXMz5a8KmL9HWuhjkWEDeLfGXZJdYYpi6?=
 =?us-ascii?Q?+Vzg41lJexFLh7OHAJw2TiFz+P0qp5am8aW1JrynHTj5gNgOfEuEbEpPq/Hs?=
 =?us-ascii?Q?KauaPs52j5Sagj1/MgBloD1XrlslYBOf5UDDnpw62bhtOWSTq5lDgcMCLGmr?=
 =?us-ascii?Q?0rdcfeFIVC/cG0n9eNc01wu7j4v3fgNruN4tZurTpRsToL8LPuwpgqTJkLB8?=
 =?us-ascii?Q?L0tc/ArdOVhUTexWPXGns/lnABigWLeUdSDhtgXlsLgPeu0N69vAkdHQDso5?=
 =?us-ascii?Q?S/t59cVl1iiQg0+kcFXQRToQjpbf9NpEbPRO/JU3aZw3cAD+5WAW7YU7ebvf?=
 =?us-ascii?Q?Fr1HiJQT30Q6NVdnH2SrhxeIWYAGOHSeqsq3aWWIdu8bxXe9qgwVg2ilq+Y7?=
 =?us-ascii?Q?G5nKwYjwXznWDCnzpdj8NpY3NWvW+xuMZn3Z+Z7/cNjsQiSZe4ZqX6cOCpjh?=
 =?us-ascii?Q?/wt+4p7XLQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3b2bff-3bc7-4c09-aeb4-08da25bdaa9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2022 06:42:56.7450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MOXg0KQ0krgTKQ7Q4oE7e9TG0Cdly4xlFfuLkRGVO8f+cwvXZceKsOnjGc+MJCrcFpLDlAlqLB4KqR4Vkrep7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5949
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Konstantin Vyshetsky <vkon@google.com>
>=20
> UFS devices are expected to clear fDeviceInit flag in single digit millis=
econds.
> Current values of 5 to 10 millisecond sleep add to increased latency duri=
ng
> the initialization and resume path. This CL lowers the sleep range to 500=
 to
> 1000 microseconds.
>=20
> Signed-off-by: Konstantin Vyshetsky <vkon@google.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Avri Altman <avri.altman@wdc.com>
