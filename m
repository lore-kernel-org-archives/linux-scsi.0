Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CADC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Apr 2022 05:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbiDMFZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Apr 2022 01:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiDMFZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2022 01:25:50 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978794F9D2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 22:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649827410; x=1681363410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FjEDbwWtXLNai5XevPEoz0u7kFU+h837i8s5xqrNr2I=;
  b=YSgJs0V3HMd+Zf6zP3RjV/h+PP2Y+cOmpYb1hj46uNmCyl4D+Qh1QN8U
   Emwjn94aN1O3T/0/ZGKot7L9zlzc24EmdxyspcO27wZwzLkNIIb7W/EEe
   a4DM/68Pf94sLkRkNeZ3KJCINZ20D4ngG7YJySncRVuOpIxNMC9d7bTM2
   X6KhzaaYiwMBRwtcE8tc4msmzaNYpiUkRJ4D52W2UHDYDrKKsVyU2untD
   YxrG7pQoKEpO6k5W0QvcNRBisII3RFjezImcGhcS8BreA6L/Ua6XSmBEW
   ZMUBVB6gofr492S/lf4kNbkQJpq4FLMqx87cc/l63OTO7BqLjhpCIy4TE
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,255,1643644800"; 
   d="scan'208";a="202651005"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 13 Apr 2022 13:23:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfcBmNxeLU+Ja4vTS0dYKVOtrbKu1Udsec0/vWtI0/9pAeK1iFGv/c7zJGnQIpOPb6MwfMW5YX6zR81DRVl+wv3L/f4vfusxkzgOQh/5qiu6NyASxMzUlFCZhar0cugR29v66U4r4JtSLrgQniuKIJCpx8EcR/uwhj1+pFm3eBY33ePqXTZt+qV3OifUYAGjWjkf8Vj19Cee4anHoHvHv8EVRSIrX1ANxrfb/MnQf+mTAECrVyWEZIXGwDHCg2ZFyGtqA/Dj3f0lVmVb5MpaJOcU3xOv+q6aHQiv/gV3bntQA+JKGNd+fxi8OuFLvNYzxY45Wpw6fMWz3O02pAdLvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FjEDbwWtXLNai5XevPEoz0u7kFU+h837i8s5xqrNr2I=;
 b=ic+1/cF5SMK9uB4oIZeORHxyM+X0Wc1eWeSZC5YTHN7M728y8SACJS/4NvsnzjZJ+m/jhzvNiKDMFXdgT4deIEJK1750I2v4hywdNgr1/EPb+unDsUAlTHbp050UXZYYcPYUlKXy+Ob5FF5ZOYVoV0nyHbQj6Xl967S9tuJnfT3qecHbbbyn2lRKvdhIvd4zslylxBtstodk5v3eQJlzvAIBydQEH1Tt6d2H5TP8bi0bZqw8Xx3Quwo5RIqhhHayUB0oosFEDBrsRRM6MEcgLsXu1x2tnasWWRqjeMrkMMgl6p7jLCVCRJ0b4b+ILr60dULHHiNsAb0uY+fqA4A2Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjEDbwWtXLNai5XevPEoz0u7kFU+h837i8s5xqrNr2I=;
 b=KC0mx42wetIY8VaZ5FN6B+DJYKwlDoRfpen4z1pghCS1I68jR/+en9Qb57GY3qG1SnS4OoGdd4Snymj17VQ+tDtFEZ9OYV2v+bQTXYTjszMW7cb764HSU3/rG6Q74izt2GF/XaPOTd6a9Pie2LFjNE7qI9Eph5FpvqQmNflhDqY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SA2PR04MB7707.namprd04.prod.outlook.com (2603:10b6:806:143::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 05:23:27 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5164.018; Wed, 13 Apr 2022
 05:23:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: RE: [PATCH v2 06/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Thread-Topic: [PATCH v2 06/29] scsi: ufs: Remove ufshcd_lrb.sense_buffer
Thread-Index: AQHYTpnxa15+DWgHrEaQg1S+iWsOSKztT9Yw
Date:   Wed, 13 Apr 2022 05:23:27 +0000
Message-ID: <DM6PR04MB6575842A55982ECAADFD4C28FCEC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412181853.3715080-7-bvanassche@acm.org>
In-Reply-To: <20220412181853.3715080-7-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9d73737-c770-455c-e0ee-08da1d0dbd95
x-ms-traffictypediagnostic: SA2PR04MB7707:EE_
x-microsoft-antispam-prvs: <SA2PR04MB770777E5241763F5EDFD028DFCEC9@SA2PR04MB7707.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gbovmQeK1w5EsXdCDUQENqT8dN8zbC1lIB3r9qjBZd578qb3K/j8ArW/WEGEuO0qiRDF323GfY0ckhB21EltMuzHLS07HJRtBy6doetqMj3tSn8e6A+ycNMu2YuYlDpDOUztPyUttoP6Ma4I2/Isg6smzoBhHes9Z/R6SzVsqD5Knm8hy5VRd7NCajoaGCP7mCItsETDKZL23I+D5OHmcm961OfBUN90yIhTa4h/yvawTRkGg7rkmtV6fn85MBpUUjI62iB+1iak+vjyNEKVyVjRS2XVvTELkjNl/3D8Wcg57R+132d3elEcIQqURbhYkdHMc/dn4j8uBvzwq/jMF8sfySwl8qr8VE1rk7Pafg24EQIGsEHeYpn/+ShzY2lUIJmG9pg0d3iMtuSP9VxZEXvh7Ql+/9fnydv0vSMLeuk4k6/j+E3boOeu2de8CkSZ3PCtuPpvCCx+UFUqiNbjsMyL77+B3WpJ/EL+PvwyRWeaXiwDbNTwHYdFbg/eI0SJw6yZKC13MXzuWL7hz6lb8U233lcrhaZ6z7k7C5UkEy3w6CZ8El4aj46m6fyotyLAfyvtbZUTkbdp4gOVFT25j2n8wWeA1VrmJJEyfR7eRjSjaKkjqvwX7z1dHeJUkzRIWCzJ68Rpm9jX5LV2iq7dG9G+Q00qQNDZolswpW46nYWUjt0b9o6/lViWR7X2o2UjugHPvbwSN4nU7CC9F8w9LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(38070700005)(55016003)(82960400001)(33656002)(38100700002)(122000001)(54906003)(8676002)(4744005)(186003)(8936002)(110136005)(9686003)(7696005)(6506007)(5660300002)(316002)(86362001)(4326008)(2906002)(508600001)(52536014)(66946007)(66446008)(66556008)(66476007)(64756008)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wx2g+OFTJ9G5o0is6+uO7Pnd9iIjIRMXHOvpZfh+8cwO/xh7x1yh7bCPgmJB?=
 =?us-ascii?Q?hUMh4vSmtOWtXbL8gWr387VVxyAc7lfrL5rIOg0ta/TznPpaEgWBpOuVZgjd?=
 =?us-ascii?Q?KLaDS1weeuZOByjH1eecfH+yTmu/aBQ723GMUdeoFc7rmIs2eioGdLTtpmLR?=
 =?us-ascii?Q?sQ2Dhje1BjDhNpCZXpNAgQNYrmxgZZs+NNGqKcrM+tBZuoNWKmln1h8YNTlE?=
 =?us-ascii?Q?TTEePmIHeo10frkk/EDnrd65nWcHW+27MeK9x+QluSvgDR9VEdjYH/n3j/rV?=
 =?us-ascii?Q?0z1/HQ2p529ejHG3yYBqVqN85/H8E3sA9gq/vEXUQ19krZquAp131g91UKkG?=
 =?us-ascii?Q?CtfM0bk+KkZH393WDjnVsPEN+ZIfV5PBzLsHTB1X5d3HBVxIARQF6Suisopa?=
 =?us-ascii?Q?BGzZF9N8VVy9VlT2wX33H4eJKOHiOQ1FwhBvkx3ICD10sIQ7RuyurdMy/wEZ?=
 =?us-ascii?Q?/342LnzvBaKaQwyET008hIY9c7d7YN8sHIKldaSk34iFKHf3yqKkNVO+zWR4?=
 =?us-ascii?Q?0AgcR8QpaGz/opVWt6SmI1u6TKfM33QnNp4ba5Tv8LWoYwtdUXyZuo59ApWc?=
 =?us-ascii?Q?zIWn0ssAnr9V0VD0IA0zkhVqdaGGGPvoDwN5HQxgkpcS0/5Enup5AIyYJkf5?=
 =?us-ascii?Q?LJJr8XN4stoHlLzMLKWnZWQ6DdOw3VKJsCNLUTCZynh/1u3+1yc9HWrQbZjj?=
 =?us-ascii?Q?VghJIBb57WB46jts9S0yaR8TeeMHybAM+6pbfu2gv9Ya7UqL0OkECcKM96Qe?=
 =?us-ascii?Q?NgH9QDr2INTpbbYdAz2x3oNdpi1+Vahsbr7hfXO6dqmAFb253hbhAUqB2vDC?=
 =?us-ascii?Q?1pG3cL9IqiAmmE4SvK2+k/UQQjVKL4anUcSDqDqYep1HzpHNVkMz6ezKrCNl?=
 =?us-ascii?Q?YQqWpfU0xK1NRfDlhme4b0wE7iWfSSkzBBRsrkBy2icU/FFhL3abtVM4MQo4?=
 =?us-ascii?Q?/FkHzqusMvcNN1BpBVdXA48Fw/2oA+t9wKuTcXguFcDX5eK1CNkN0HTCr0xE?=
 =?us-ascii?Q?1zyo1dcQ9aqGEeE9kcn2RikADqdzWB/KgNZ9duwrlyRVE7hX78s0FeIDrD55?=
 =?us-ascii?Q?uZbGWCjg8/54iemnwNy5K9s5zWMm/wsEJWeyrZLXxyvTDiWcGFiTG000zbvQ?=
 =?us-ascii?Q?0IHfKfSDO4STch955OyxuHxguqYYeYqOeleyyO+Smkx7bHF9F5BeAv7TCeP/?=
 =?us-ascii?Q?qLZLt9T1jfmuvb0cz3tSCzFnLvC7cKBR9NV1+IrQyYQ0ydLKnrRUAm89MkgD?=
 =?us-ascii?Q?urwXflmNNxMgT5hG92hjpneUmk4+gBmUcNmf8SngIZZOZi66UqseTFNm6LSo?=
 =?us-ascii?Q?clw/JUgEE/zwAtF91a16KquxJQlLSOUubE+LESrIkuCJTMNntydvo1fjLokG?=
 =?us-ascii?Q?KK5Eh3/7R7G5Ljpf70b2ep2mJ3I1KxhPYaKP0rkon0D9N2YxMfWptt942BAb?=
 =?us-ascii?Q?i+6ijWov/yAOydc4w5H+1VDSlQicfZOxKpem9OMBUzz0DSAyILGgtvHmftLU?=
 =?us-ascii?Q?PechMGA9VKsDd+BgA2iSHN5B3eoeiDC9pokM6qiT9fYHUykbAKPSC71AVAkn?=
 =?us-ascii?Q?SUQM5gQJ+5HPKgXPuEH9V4uvKHGxAqREEFDLMWqlbadvlnRDfCJOrUobua9m?=
 =?us-ascii?Q?0Yy31JKqIREhjD6XYvix5rvKu81DnrxGi8Dd+KHcC+3h6hJHmxCE/GxwVXOa?=
 =?us-ascii?Q?yW7VS7ks9A4Oy3CNDWXjHWr1Nlh6TINvzB2R403TBuBqwoQjVzsOMP+bG+av?=
 =?us-ascii?Q?eOTbg6E8fw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d73737-c770-455c-e0ee-08da1d0dbd95
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 05:23:27.7437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lfj/UnP+B+Pnc7qWb91xW0hxovQtUf+6aLF9bhMxHe7KcVnu7FHs0zr2ExedA2gXkuNErZ77NlAKwlL8BD3zZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7707
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> ufshcd_lrb.sense_buffer is NULL if ufshcd_lrb.cmd is NULL and
> ufshcd_lrb.sense_buffer points at cmd->sense_buffer if ufshcd_lrb.cmd is
> set. In other words, the ufshcd_lrb.sense_buffer member is identical to
> cmd->sense_buffer. Hence this patch that removes the
> ufshcd_lrb.sense_buffer structure member.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
