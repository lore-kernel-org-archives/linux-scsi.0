Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A820C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 20:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1175E6112E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 20:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhINUD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 16:03:59 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55231 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbhINUD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 16:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631649760; x=1663185760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B0UMm8IYSKkU3zq8nRN/jPinCiWgJb/OJbFbrpIipBw=;
  b=cqDAfpifGqt1G7MuCtIxJnycfupn4BmRgzP7ELusYHcITVnvUXJRN2Fn
   3HkRphZdLEogGUzEJC3ncvm8c2ryd4DJopdA1Xod5s3akfVy6yISFUk9U
   uIm5UUYdXQf1vkuzZ9sMffF3FTvOSMXj6E3suBMi+fnLM0+51JK4Za94w
   4H70CPL7FUfI7UapG+iuiE/juIwde83CalteZGQrsFdutzOYKu72oTnoN
   qZc+2WGSDVRaBcu73G6XBcH793zVtiFnhVotP8xcCsvPHRj/vrqQ9Lcsr
   ldJiX9IPIJk9gM6+TZdkCIOkp9fgQEFbTmbBR4HUs+YlxYBZor4GYtysG
   w==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="179079914"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2021 04:02:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk6r/c5s5Hz/jqgzec80YViwpS0UXsKTuWodvNMmpnq0UiDnFnqZhlyP152HeO2Pno1ZhQgG1MX7kBxAgTSWSNitUVLPTS/5V8tkz+JoTfZ9eRJdZLJG7q8sahZDsPjisf0j8An2Z5WXTlilUKkYY8sFgsXRA/N+HW4ZG2+JMn+BLPGpoDAuS9gV3jznREVhr0b+N8PgRnz8ZSeJNTl+12PzMmJ8MxctC0cnWBve/NGWnVjSojGBMQXVRh1W3vpbQ4wjTTCXBgQwvFqxReI3YEzCKeS64xfJwLUYn+lrSK4po8EhmGHA+gO5cf2/z3bm8dfZ8NCvkt7FmuTz6JtpYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=THdvLxjFaUfAgqXnIeNfeBczORruHqHqL+xMhz80Lcw=;
 b=bbpPd5eDZMTSgrXw0wvjaB4H/XvXdDyW9s7dY132HSXbDnOa6cc2cXlW5ZDlmx31gwiVQk8W2Et4xAC8VUi4OT2rmSRETnPYCbVKMoZ7308IPmhNJvVqjzq9bQExh800DZjm7I5u4tH0AEO0fbIFtY7c36juQcwhvxOoya5vaMn5iBeOzgeu8hcq6QO6nkq+qP1rEraF29rDFMrvjR1IUS/+dOmhtyzrITNIq2PrsuKRL2YSguTbhENlaCzPFbeRXNQm52RL3/mB5m77chnBx+5p+wTD/8aSxSIBO58EGZ2kw1wBxeJLwc9VBhiVYOr4n4Yj7yIiVs8KC/3M5lWeNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THdvLxjFaUfAgqXnIeNfeBczORruHqHqL+xMhz80Lcw=;
 b=bDp3obzTcraxCtJqpqL7jZ15Lcpa2iYYzf0BXq8pEuujLyoO7hGcblSw6zMVtSV8qULSblxMQeN1PHWtC8Zca9nYb24jbv8psTbxy6FbF0JD+a+NWfgDQVzS3CstbeJpI+tNa7NSqKaXUgf07zO40RRwmrd0ZbLFW0O9mpbWBHY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5081.namprd04.prod.outlook.com (2603:10b6:5:fe::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Tue, 14 Sep 2021 20:02:38 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 20:02:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v5 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v5 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXqTVBrRkhJGwiQEK7GP2aT950iaujnFsAgABXVkA=
Date:   Tue, 14 Sep 2021 20:02:38 +0000
Message-ID: <DM6PR04MB657572A17D9E6F8FCE3F7A69FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210914065320.8554-1-avri.altman@wdc.com>
 <20210914065320.8554-2-avri.altman@wdc.com>
 <20210914144706.GA3457579@roeck-us.net>
In-Reply-To: <20210914144706.GA3457579@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 487f59d4-167a-4d7b-8f5b-08d977ba9a58
x-ms-traffictypediagnostic: DM6PR04MB5081:
x-microsoft-antispam-prvs: <DM6PR04MB5081D1C5DB11FBBD90349065FCDA9@DM6PR04MB5081.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SmlVrRTvJa9Q86jsKIrWSsq55pwBwDA90hemEjuAOGdct4+8tHjoKSxX26FcMYqpU/gJJ/WEHeGYc3W0GV4D6367n0+0knG241fKyPUpHg02Ls5lcvkRS7CTqXDYX+AewqEZ3Upn1whQTDwmtUT0HkAt1GwAbcYMIP4xstggWt1L7n2/288V9zNUEYCRJwehZ/fh2LtWxMkRG8zi68YbHhjJXvsGvnfSOqoDGoMe1tiEIK/G/YkZFMM07Gq78EZRlDsRtBkgCJEzx21HF/rBwXJLq2uLiis7X0lrp2f3oBAXQ348jDZYKP2h9rCcxygx1oh1cIHkOfjH9w7jenotwabBFZk0BBn941TUxNvA5cUq9yJczYLXDmCmWUutQXTN3JLhASLxuBxlCsXdSO59r3q3CsWc/GEMFxj2kCxMmsL4tjEqa05aHDvqhYPZ0BxhVGT1PunKhEDNwOZ9pt3+7WbDCv0kfkN4XpZ0VBX2HGL1ysz0/QLkJF9DpF35CgPorCM71JHn1ephJHnevyS3VnNAAFIYW7tA9nWKzrVKVU6fVKleNpy1AMu/GfMEl9Jf6SiaXGtPnn2cGSRMzxqkXrJHR+MjKdES1soDCGKHqHTG5M9qnbK8zN9tuixxny92lUSxZSVGTRLJn2DB2mQYP3sxMh2LjP/LTHPdSJvrOGh4WQ57376eGnpdM/R5RcFsFiAsvB95b7zNaqShJ5FaDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(76116006)(26005)(38100700002)(33656002)(9686003)(54906003)(5660300002)(66476007)(52536014)(66446008)(86362001)(71200400001)(6916009)(2906002)(316002)(8936002)(83380400001)(8676002)(7696005)(55016002)(64756008)(4326008)(122000001)(66946007)(6506007)(186003)(478600001)(38070700005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CEXWo5hg4vYg+4/pV26VS/sAXHwqVaSuyvaTfaIUpr7OgNkBwnr841Y/YNQ9?=
 =?us-ascii?Q?mvsh9eB81WOHC7g0Wairpu3U/BeL7HY8hfCKOfplUiYHIyNeMEFoqy1rpypr?=
 =?us-ascii?Q?Z3JIimOlf5t2cwEkaBAUJgsuz5jgtfDMM6ucncvE35r3DxgiOeGgxp5zV2g1?=
 =?us-ascii?Q?QSBQYepJdz7yipph3hm8f4FqFLHXJ81LbWiNM/NfnULjR4Cy+baOVe0IWKu4?=
 =?us-ascii?Q?Ii4/xMbZMJ1CszLobxdm0FFNU1II5Ip4QgC6KvwfnEHS8P9bH5MAz/gKMTrg?=
 =?us-ascii?Q?w03xF2xX4ytPiFbnzoPcQnenOz9rS1/rP2zeAyIclKW04ZKZGABWLEkYOPoV?=
 =?us-ascii?Q?Nwgzf1fh/TuDfXEw8hsl+L+EJ1Hf2p+tDfehJt5Ik9CZ6q+JttV5+/ZttVlL?=
 =?us-ascii?Q?jgxZtFbYX67+GGv+wQWOmnNYLtaaCVNWBXpCb4ruFx8YpGX2+tsMoUuHsdrz?=
 =?us-ascii?Q?ap/21uhEBrahOvTcxBQI+GjSXN/RmIA1lpsUsunBCExTtubTtK0neWrwBv2R?=
 =?us-ascii?Q?USFnmXW4ofw1Bzzfzn1bZWZzZJ2cpwPR3/GPNqNywAKaDJudY5sb/bLQvJxi?=
 =?us-ascii?Q?tOqiWQohRlzkeMQ5D9tQFrDVW/X7bbJY5kbxKQyw4mxRSN2suC4/1GKk/ppf?=
 =?us-ascii?Q?AFkPWjzZgaDtpmWrMt7NqO81iWeCkpj2ItVwmHn9SxvG5Dx5oZT3f+v4HdxO?=
 =?us-ascii?Q?vQUwbld1lmdKjae4DzUfY4J9pW0Jnx3+WoipekTMejEnWewjZ6df/I6v6zzK?=
 =?us-ascii?Q?bTKxYXltsGlsuY9yBP4y6174EPQI3lpaJ8vMKAXVMA8YS+CzpeER53ZlRLYS?=
 =?us-ascii?Q?oaHg0K5CKBxSnaWUG6NVI1sdvMMKM/5gOGJ96ZhX6vUNFkn63JMpm+DARUt0?=
 =?us-ascii?Q?80yGq6dPhUr+dkDMU7P2TP4J7GTjCKEBErUO9df0ejX0SJs4mXme3u0d4wcf?=
 =?us-ascii?Q?PstvI2mz7dtVTUiCDYRH2+8Cs8j6mevS8kDAdoqaZTgTyuhNycQEEGsXFLXU?=
 =?us-ascii?Q?SDNuT5JLNwL3r1YthUxsEpim6uhvqrdXudmJYfhjd3Da60LbWX/4hFUZV0SV?=
 =?us-ascii?Q?bcpsZxPfi/rkCoz66wzDNxT9JazV/CVz+/ZInLhFrX0veVuIPbHrQHr31a1U?=
 =?us-ascii?Q?hIXH5GPwekYEIXA9HpyWuYXQmcwNppMtBXLxWZzaQVeO1NUajrvlodjz1hCG?=
 =?us-ascii?Q?o/IrVEuN4N9NPs1ZFtw02DkVgcT+GkrGe32mnGjU3eqs8KsT204Nz+zsLOtu?=
 =?us-ascii?Q?uizbU8+RlIz9v1HOc+sGmiTn/O/AZTzuoQAxIHNr4AjraPl8j24p+AmZwYy4?=
 =?us-ascii?Q?bj/ELhzejXkjGum+ArZPaPY6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 487f59d4-167a-4d7b-8f5b-08d977ba9a58
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 20:02:38.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DqOdAKXcydMzOQoebakjtjHkoVAZ5xLCsfXjhQ86V4M2Hlo9lLTUCwhi266k2bbFhz1Si1StH3roMioTZakzwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5081
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int ufs_read_temp_enable(struct ufs_hba *hba, u8 mask, long
> > +*val) {
> > +     u32 ee_mask;
> > +     int err =3D 0;
>=20
> Unnecessary initialization
Done.

>=20
> > +
> > +     err =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> QUERY_ATTR_IDN_EE_CONTROL, 0, 0,
> > +                             &ee_mask);
> > +     if (err)
> > +             return err;
> > +
> > +     *val =3D (mask & ee_mask & MASK_EE_TOO_HIGH_TEMP) || (mask &
> > + ee_mask & MASK_EE_TOO_LOW_TEMP);
> > +
> > +     return 0;
> > +}
> > +
> > +static int ufs_get_temp(struct ufs_hba *hba, enum attr_idn idn, long
> > +*val) {
> > +     u32 value;
> > +     int err =3D 0;
Here as well.

> > +
> > +     err =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR, idn,
> 0, 0, &value);
> > +     if (err)
> > +             return err;
> > +
> > +     if (value =3D=3D 0)
> > +             return -ENODATA;
> > +
> > +     *val =3D ((long)value - 80) * MILLIDEGREE_PER_DEGREE;
> > +
> > +     return 0;
> > +}
> > +
> > +static int ufs_hwmon_read(struct device *dev, enum
> hwmon_sensor_types type, u32 attr, int channel,
> > +                       long *val)
> > +{
> > +     struct ufs_hwmon_data *data =3D dev_get_drvdata(dev);
> > +     struct ufs_hba *hba =3D data->hba;
> > +     int err =3D 0;
>=20
> Unnecesaary initialization
Done.

>=20
> > +
> > +     if (type !=3D hwmon_temp)
> > +             return 0;
> > +
> > +     down(&hba->host_sem);
> > +
> > +     if (!ufshcd_is_user_access_allowed(hba)) {
> > +             up(&hba->host_sem);
> > +             return -EBUSY;
> > +     }
> > +
> > +     ufshcd_rpm_get_sync(hba);
> > +
> > +     switch (attr) {
> > +     case hwmon_temp_enable:
> > +              err =3D ufs_read_temp_enable(hba, data->mask, val);
>=20
> extra space before 'err =3D'
Done.

