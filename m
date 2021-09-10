Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9031DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0C76124D
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 16:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhIJQPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:15:12 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10944 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhIJQO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 12:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631290425; x=1662826425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DKHK/LGtd9Enfrf0/up4X8TItJq5m7liQyBze2ORA/Q=;
  b=i9tQ6aiAB2fNpfGzfSryhItjJdTC9OUPK8QWE7syYyX6hjJmEhepqEg1
   4sxERwkYzgwCTOqilbVg+aTxl4rixWVJr9oGYW2B9WuXxPn17EvqIwOMr
   6BRg2ck8SM/pv6xQqGYICWkpy0DROl3sFFiIiiEB0uDlovlNIrmf1ZCrj
   YRGyRR+L0ttnH1+obwbGCunbBojHyPqnz1sUFPNM1gH9+r984ba93tuHp
   i5+9hlhHhkRjKpn/sPrBqJqoTVLVZGvRBWTmDEQtLmfBNgV2NoFn7L16m
   ZhjEstTB26hcyNTYRDArBml8WqlFUcizvolgq2D6bEtOHx58Bl9+m+SbB
   w==;
X-IronPort-AV: E=Sophos;i="5.85,283,1624291200"; 
   d="scan'208";a="178785184"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
  by ob1.hgst.iphmx.com with ESMTP; 11 Sep 2021 00:13:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2fqXBm3kUjTUc0jxHXk5ZxqlUiPp7kxu2mlDvydrIX7Kl7YkmNWJCeAPpPocubZylij88I/BVn/304U96hpbp1LhDN4SL8aANr3MYcd6V2xn+nByLnTiTwOiRaZ8vR53OdN9ngbwGMqFp0UtD5f+UIJ6PSE5TvbvhpbrlbV4MrAFBbyaXoNcVqN48ilWACxiBO3CHN0GDDpX2OlKunxpde6PBQTzmgc3KH9lm6MLFrcMch290AehkRJY40Sk2uxGzL+UOhoXBt9CCegBFYGDJbalGAVI18KJxMpCeEi2FmA6rPaeZtoXw6Hb2xzSdTr7nYHbWmT5O+I7/N3fUmddQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Wyty8dfh7JkUuG0XeYaq/R0uKPBpfGMZ27zGKr53iBg=;
 b=HB82YqFSJl5PohS+raEiCPk+RCK1Lvk1d9v2kXts6Q9+JoB1EB9jrbb+Yq1YviHDM2zloc+0i3WdUUgHZSgQv92ywn7637bZxMxvku4YsIBz/Mn/nXt6QiTon7miRUizm8CcuY/PxfsZAORVk+V/SDLynxnZxGVRIj1VwMEu9xX34JPMvl7okyJwhufs162o5y7CRkXyexKlGQ9JlP9DyjG9pf9lET7QQU1suVLAv5t32oJFGZ0wonT1qAKdUPy6RZGdOIEnn4fwGc4JucfI1IYsh6CD+waKx2YMDSz973mhVNKn2aRho6RTRdd3R3q1yqhPeP6TOV/vRpagaWuUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wyty8dfh7JkUuG0XeYaq/R0uKPBpfGMZ27zGKr53iBg=;
 b=G4Cad17aTVWVTDtJdvikoq1lmpQDFiN3kjW73ZTUNpKUHDdswBP7dXPs0fPbBxuFXEqxXsnAGscJjtTHv11SAc0vB+nTTVKBWVMv7KFhgo8XnKcZoQE8Nv+fIQL4uEo+/FiV235hsU60IowQ2Ow0KHP2kiz2ptmduzHK2+YFQ5c=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB6510.namprd04.prod.outlook.com (2603:10b6:5:20b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Fri, 10 Sep 2021 16:13:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Fri, 10 Sep 2021
 16:13:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v2 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXpUTh8Dhuh0oH5EaZbJTkdwCAEaub62iAgAGEpIA=
Date:   Fri, 10 Sep 2021 16:13:43 +0000
Message-ID: <DM6PR04MB657592A71CA6394C409788B3FCD69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210909063444.22407-1-avri.altman@wdc.com>
 <20210909063444.22407-2-avri.altman@wdc.com>
 <20210909165145.GA3973437@roeck-us.net>
In-Reply-To: <20210909165145.GA3973437@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e34c60c-4f80-45a9-4874-08d97475f5d7
x-ms-traffictypediagnostic: DM6PR04MB6510:
x-microsoft-antispam-prvs: <DM6PR04MB65103A25EEC633EE7E23069FFCD69@DM6PR04MB6510.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m3BGQpr2nfo89L0Wx7NbDtYH+Z5K4geX7Awa3tiueckFmcJASihW1Vb+ayyhlpAXyTsRkZXopyeu8MMl3vdUohS8QvFneIm1xkFQj1ewOFDfd5iRAIvQSc7/mjEVaaB5Etl6qCRlU7xpI0UzpqAGctFqg8+9YLTyQb4lDLUNXezgrBzWSXjjowliA95JrM7TKJ61CUluGKezOlWwXlaUm72H132Yb4Vri854IUKYVuOrsNU7CU0PCinJlMQUhxZwXioUzGY3mHpFWg2sB4J23eR4FDiChowXjKfyrqmYOGzyTsycDg/opwvB4z+9r6tWR32xgTU0zOJ/WzcixdV3feqSsnj66GekW4bL+HoE7NIE4rGIguNv2hi6wGfu/mCvuXQ10Dswm0BQTjPEV3JprR1g3kOkqzUf7JNIfZSwQfgGHXnDqRtTfYQowTxQ9Q9sc26tl2d/20aOn/4A47eFQp+PG3mZC4lf0knzqKOVXkM1U6I6gLdCjQ9eq20+hP4EbAdiLNyQZWmMfeUkNPYwVFUFBIIGKXbLW9X//yXyyVvij+eEVToElCRWzG+MqIQ4zRjpgyz1Gg7tRQNv+8ObXgbz7BY8jzlsdWCGg5u/fQfXcoAS/uuuQkRsPN9Y1kOYxSf7AmPR5ZiUppzZtoo8s2+vDIjxt1L6egskLvSwvmgXYEuGUmatmaRmXKU3PWuHjiQT94AD3ZK8+kEyiv5ubA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(54906003)(76116006)(66446008)(64756008)(122000001)(7696005)(86362001)(4326008)(38100700002)(66556008)(186003)(6506007)(6916009)(8676002)(5660300002)(9686003)(2906002)(26005)(55016002)(52536014)(71200400001)(478600001)(66946007)(8936002)(66476007)(33656002)(316002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qzfrQEsSmYAknT0XbUeSf+sOTyZZf95NkOxiEiDi9ExFhUzcHdP3rXO+n+9G?=
 =?us-ascii?Q?5s+o3waz/cbrB7UKnFGzRNvLQtR1+Y2BDdVYIX+7nJYIULHwxY1Nza+nfKP4?=
 =?us-ascii?Q?Jz3YXfqqAT2MtYL665zvCQn8gOl07JepvGGyg/RWAwLwLKXyQLYevylNuOjC?=
 =?us-ascii?Q?Wr/P2XhZ5dv0Jbwhc5o0Z/5gS5ESoy/N6VrgbNAu8b/fvaRki9dmERDG3/oC?=
 =?us-ascii?Q?YwsV8j3PvnZufhZVd5o98sGMnFUTdgSQgmcVi38NIJNvr9VXt9c/lj7LnRmB?=
 =?us-ascii?Q?62hXSE9iEXBMpgLCzmHDVFq9PmUtRq/g/yeKEPMFMANUpAaMPZbBMZi7Cm/Z?=
 =?us-ascii?Q?OuPJRb9JvUCwBW+wL29UuV6XQP78hc5tz0eJpk7yCQzNSYP1KGMKRtk+CpTP?=
 =?us-ascii?Q?YlPLPZKr2nibrqI1dtOQ0DFCHjVqojA3Q4Hb3YRGrlCacDRgl+dUenUTetZs?=
 =?us-ascii?Q?HNMqwrIPBJCWtvFz2+2j0tMdC2N28dJopREFjf4eOEQbhcOJCs7ZpdONE4BV?=
 =?us-ascii?Q?qCwauJBjqotw3FIPopeAXJUg0q/ccE3OLXuPTpci2+V5ugLMgWexrKYMwbkn?=
 =?us-ascii?Q?eIcBWEG++ANPstFs2n7KNyq3sH9ZV3/OcZeeDSL6iF0PI8MH2/YjK3GTXoQJ?=
 =?us-ascii?Q?wVFGM3h5hLRALCXZcX3/kBDSjstY8PPZvyPo7sMe6SptL3VuCphKkakZTc1e?=
 =?us-ascii?Q?v47NcMJLUNpxHbrZpObVkstWlyHSP3DCe76oS72uso748afQTYNeMfBLdwoO?=
 =?us-ascii?Q?7OJRL+4A9cAbTmk1VSSNZE1tYNTf7+fr1QuWYq/E7GlUJWmPknzCm6/LRRT0?=
 =?us-ascii?Q?9vuq9Bjwc7WMLyGQD8aqQ6EJt3pqnr9nBh88jjZn4dOZFfVBhGS/n3LenGVl?=
 =?us-ascii?Q?vKO4GWN0QlqwSZ0PIKnRMuzdJNQn4DbeXlSukPAqrIG2z7Hd+KJO0UI5E8Ta?=
 =?us-ascii?Q?QHPoIUhNDUyp4GiOPeAIoFxxoQinFn+dRlYazLQlhbcx4aIGeFCGkTnpHvGJ?=
 =?us-ascii?Q?5oin23ZPtB7nEZRtNZLQL+bNLvhIyO00z0in9azmgLaC99b5ipByYqUYTQS/?=
 =?us-ascii?Q?rCIBAAQHXi8TX2pB2G+h2SW+OxHmPasnZs1u4pRyK8mMAKgJ3lxtWCuy1V0t?=
 =?us-ascii?Q?Ghn6tworwbGuGbsf+Lr0+JW6r2LVxJKtjYKnD4N03srSuc01VKy99l3JMzLU?=
 =?us-ascii?Q?t4MuB+VG92Q3zCy9IZgg+5qiJGfP+WrLESFVzjhKChVWMmKD2EGPiyrV8/5I?=
 =?us-ascii?Q?uVX2i041sCE2SwjXKePbZkWwK1LC0C4X3sjYlQSepQH2X5W7wH7csX5gFA4/?=
 =?us-ascii?Q?6b6rP/ZGYVqdm8MAC1pF/4k0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e34c60c-4f80-45a9-4874-08d97475f5d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 16:13:43.2923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jCjIwFgu6/+T+3TpqgdzDnGms8wlo3vLSGljwHqCRqQXYFqjQvFNWoRASyRPyX/+qh1MFrc82sAlGlVdXTCxtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6510
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +     if (IS_ERR(hwmon)) {
> > +             dev_warn(dev, "Failed to instantiate hwmon device\n");
> > +             kfree(data);
> > +             return PTR_ERR(hwmon);
>=20
> If the error is ignored by the caller, it doesn't make sense to return it=
.
Done.

>=20
> > +     }
> > +
> > +     hba->hwmon_device =3D hwmon;
> > +
> > +     return 0;
> > +}
> > +
> > +void ufs_hwmon_remove(struct ufs_hba *hba) {
> > +     if (hba->hwmon_device) {
> > +             struct ufs_hwmon_data *data =3D
> > +                     dev_get_drvdata(hba->hwmon_device);
> > +
> > +             hwmon_device_unregister(hba->hwmon_device);
> > +             hba->hwmon_device =3D NULL;
> > +             kfree(data);
> > +     }
> > +}
>=20
> That function is never called and thus pointless (suggesting that there m=
ay
> be some structural problem in the code).
Yayks... Forgot to call it from ufshcd_remve()
Thanks.

> >
> >       ufshcd_wb_probe(hba, desc_buf);
> >
> > +     ufshcd_temp_notif_probe(hba, desc_buf);
> > +
>=20
> Is that the appropriate place to make this call ?
Yes I think so.
This path is on link startup when the host reads the device configuration.

> > +#ifdef CONFIG_SCSI_UFS_HWMON
> > +int ufs_hwmon_probe(struct ufs_hba *hba, u8 mask); void
> > +ufs_hwmon_remove(struct ufs_hba *hba); #else static inline int
> > +ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) { return 0; } static
> > +inline void nvme_hwmon_remove(struct ufs_hba *hba) {}
>=20
> ufs_hwmon_remove
Done. Thanks.
