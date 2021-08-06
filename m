Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB120C4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C224D610FD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244475AbhHFJRM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:17:12 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:29290 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244446AbhHFJRI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628241412; x=1659777412;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xswJI2n3YnyTgGx4T01qTQ0m8doSVI5szoEhWvYiisw=;
  b=qBHPwDV/e9ve7f0JRz9T6yO5hrTyI4OZxDHq2dBoKKFkJ/R9N7gs6tuj
   fWCXa2zOENMANY1Xh87YJRPuNybqC5Ja1D5XwU1G4G4tUxCUjZaVJj7CW
   49PF6MjdcEUtv/PTgVq/AI5a5g9sRVTJ1oa+k0KiVoS/IiQ/odW/C2HRY
   e7j/bvq3FA9Lk924FOc2PVAamuBjePwrTy8Swj4IKphEmloZqZXt1IqrZ
   mABQpTBuOPe5RUfCvkqYNUkxllr+ebX1emPpJ8U+LCeip8S592o+qVZ+r
   qiTZy8hq3T7heb2OsY5UdQdeok09BnR877tfeCfLNJfGCIp5esQ3rjPy1
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="280333406"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 17:16:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD7aAW5NE7ONr+C9EkakdNYbmJhm3esC0m5nRhlmD7cZ8AA0sXmCznqoqN/1gSaHxOdtfhlNcB2HMgQUPSIB+zlO6nDNkhm+qkEmn/sG7VABumTx5w7FFff67ta+jzsGirUAffoqVozmUf3HAUuJapVabwPD0CIIJBTgdY8WjgweszvdNz2bw34/A5Jvk+nKa6WIQVFzIx4IwvnK4Qemo+5ieJvoHhgMicXetUFnG3S8hwQ1B6e2I/RD6qWqtcCnNz5OksxSFEQzhtS4lRa5LX6wdUnW7AVEktpOBdeau8trAFlX6+/AtiUw8O/NFW4PkhOCC1iGVdaoPgYmse3RTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQFtqrCdMw3To6ItSfrMM2i+Ylnh6O4Gl8ZZ+VhUow8=;
 b=kCNzGoxx2N4CpW3u2425kTjX17p94TRKMQoFjYGBVLlk2X705JSaeXUslM91kmwP545/+YgqQZZkBkFcT8qFTFBUslqwMMkFMmybnfIdE0pl4lZy6YqizqhqtJCpm7lQx2tpyUPzUHslu2YSAy5sHYpNXrcoxl7KlKRUEqLSurGOEyKx1twG8fRn0KPCSbGJIyaDhLzHH+eVnxHy6mYKE6/oqEgEm5ekQ911u9FUSGclCf8qEe/V27pxjhRWTs31oqNmqQDDAis5bg0U1uiSV9psAGBcRuOQRMie1/z9LBLv0F5olMAmQoj3ysVJes53GGPIO76H+hNKk+4NKGQdAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQFtqrCdMw3To6ItSfrMM2i+Ylnh6O4Gl8ZZ+VhUow8=;
 b=OGYEduIo5c3LlTFBo8Hmwio2T3nC8UguXm/KW8zj4Ypzzr4a8kobq+cRx7T4p57gobPT5h7F2pbYIfz4WfJy5dcfjFKYdQYXq1+DbVMwDsYmvueX1MeZNxdDs0CzuLKn5bDyXpsG2BT22Uu3L0wvoQnE0oGHDYkmOAq8B8Gm9DU=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4347.namprd04.prod.outlook.com (2603:10b6:5:a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 09:16:50 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 09:16:50 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v2 9/9] scsi: mpt3sas: Introduce sas_ncq_prio_supported
 sysfs sttribute
Thread-Topic: [PATCH v2 9/9] scsi: mpt3sas: Introduce sas_ncq_prio_supported
 sysfs sttribute
Thread-Index: AQHXipa6w5m4dPY2EkGO1R+oPj4a/w==
Date:   Fri, 6 Aug 2021 09:16:50 +0000
Message-ID: <DM6PR04MB708114DA40F44E1589C49D89E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-10-damien.lemoal@wdc.com>
 <af5b7e6c-c27a-f0f4-692e-df39240c98e0@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44889dd1-9c86-4f93-c31c-08d958baec5e
x-ms-traffictypediagnostic: DM6PR04MB4347:
x-microsoft-antispam-prvs: <DM6PR04MB43478AA926CD8F0FC47C21D8E7F39@DM6PR04MB4347.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wWkgvJMYIcBH/dBzP/l9rZMQo3NzRQ9tkFeknqbiFkXdJFrLPiYqP3PFUxTpbmsj8NdL/3xbyklsf9Lv1iAZ7RyGmo2nGfj6vrj4kqhvzv81xILLxanqlXylcQRWogNn1gbtq5LgCIVKilNYWVsA34tNuMAXA3crMPWG0UG4g61UVycgZOPVs6/xWlWLBUHQxLSSPMcwMIZY986X+5mzJ9HAdIYg5W/hE6W0yExw6XcBmRM/F6PyfRPDPjD79grltO+zyR+R6luyuOqLmR4/WIQ0eC63dKvjHyW0XoIB3tuNkZj+2t0JeXCpCdA3I9bgqsjBhUjpI/vmTb1GIowbQXbf5U3epx/a2rXjwZX9yZh96mJQzQflBNLe9zLu/H/A8rZGeIvb11Q1+qYjN8c9vWr1po2ZKutzG+MuULnnrkSUpvMfU1Nk2Y76sJuYbWatu4hIvNYBg4FkZNkJJuskSF4VELuf5powPjh1sstP8DMRq1AdqEaXLllSQdH4NXduJeYpNkXAHp2ulHt9o310KBBqeew45kNtkT2AEI/90vMuZFiEQCvp/cYnAzE2FK2WS3cNB2DuOgdxWf49cw8j6C4MnpyN3zLR3FuDJqhh0XY09S2ltprTF1aI5GJ+kqYkAjrILcOqRt9bkLgJux0kcbcakFIM9oAlKIr3HlH7LZVQ1TZxIrmTZiWaii/s4sD6VEy93YQnIXJ4vYQhF5B2tOwi9nR3DSGfBv9HtpCsIl8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(5660300002)(316002)(52536014)(110136005)(8676002)(7696005)(54906003)(33656002)(186003)(66556008)(76116006)(122000001)(71200400001)(508600001)(91956017)(53546011)(38070700005)(6506007)(86362001)(2906002)(55016002)(66946007)(8936002)(66446008)(66476007)(38100700002)(64756008)(9686003)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YmI2Xq22/ec2JobrC/2a9W0cPqQXPEWLbmQPoFvrsShtFtKUYghhWcNduXRU?=
 =?us-ascii?Q?oIh5jbP9ZnYx57Dnj2yocdWsM/TcTobzXT8DWTnGxytBFIuA9A8WDep2j3KF?=
 =?us-ascii?Q?PfshcnPxLFsLrpliAuyL0t8aMouhfHI6He8c++pSnCL8HbxsfScKNP+TfbfD?=
 =?us-ascii?Q?2jSa3V0Cvuo7wiG86gEq2o2Jr47rbu8TVWGXhlWFLFgnWAgQ/YXz2qZu4YpN?=
 =?us-ascii?Q?VWmiMV8OlvG4JTAWn68O/k4OJ2f3fc+41SWBLCndA0bBrxIcr3slBf0GbpO4?=
 =?us-ascii?Q?4VBO4v+u9cDf4MtbpJX5MunqsakZ1FgISW7/ybGbUgnc5vfFOoVPAHhvqu8r?=
 =?us-ascii?Q?8t6ECA6ay9X7Z4Chg7tDRmvHFkwLMvQG5eI5ZxCJXr+xBGI0hVdcf8XzR79S?=
 =?us-ascii?Q?Fb4vKsIVpM9aDWJNiAYtJmfnv4jSPlbM8Ly7Bx0BnqUVI3uF9K3mInPa2Alg?=
 =?us-ascii?Q?7KP4iuxA5/wnZaV/rLCB24eoc7G98TWVsgAM3Qr9f9hc4gCzBTysUXbIg0ts?=
 =?us-ascii?Q?PVVjOrOn1ZpWJCnjln3H6Us7hfPw9f9nbpp5vrGokq6TppOYCTmdAvPtlF5Z?=
 =?us-ascii?Q?vzVM19jBco5wAMqNAfOjIO42Ufydy77OIBD6YO9HapvgMESwgCAk1u0UAKkv?=
 =?us-ascii?Q?+WcF5HxN4NFsO+9fyC472FArd3paNRg8pGm2m4gHH+sgtApRg3nHNg30q0kf?=
 =?us-ascii?Q?veivmfWqgWAJCZep5NzXGRn2GB3/62b6QKqM6+IvUqyTMsrSMq0i+VAhE+0x?=
 =?us-ascii?Q?+cHm2zEurjFZI4lnrRt6IYgrZjLlbEW2CpVwI+SZk67OBJ4rcqQk6Gso9YsT?=
 =?us-ascii?Q?j0ibtPnGqyypWLu35/IufUWoOy/AUdJkmddLU9qj/P1qf3pkWMYf2QsEdGdQ?=
 =?us-ascii?Q?TuTFW9FZlwyTLf72w0U+HPmtk1mKDuFp/fgLtFPG3Pv4iMgNpfhjF1jZjm1W?=
 =?us-ascii?Q?B4ZtdJ+T/dN6R1BnT8zjGeZb709Emf3t3fgRumbC3Mq+YMtzU0sgNyQ4R5QL?=
 =?us-ascii?Q?Y1GlkaWN4kDF42ezaenoBFjpwg7xZW5IfCnqI49AK5Gpa/MVVuOKh/JfLoBb?=
 =?us-ascii?Q?yDJqlb+m0+oMrUvsAOXPm4G6rgFDUJJWaAtFOCmQMERjWtnadbmfHesN9XL0?=
 =?us-ascii?Q?0HDQrO3LGCrLwxAW5YW2fbU0LWaI7fTz0Cw/VdlT/AYS9B2vdCWjancznJNZ?=
 =?us-ascii?Q?3RLGsbf5lurrYXyVMlxdV2TeiLdqcf9d/RzFn/oDFSUl3rkgDG7EtQu2ziyD?=
 =?us-ascii?Q?66lP/gnpKpCQUjizu1+2U0AN+EQTmlb13K20k/lRMY0EYIH4M2rRq6L+H8iy?=
 =?us-ascii?Q?l5kXwHEaCwta+nWo5l/2BZGffR8V8221cQHXk2+/d8rpyUMF0RZLAK7jX+4E?=
 =?us-ascii?Q?0MThdRpVVTtI1659OeVQe39JJXBaDOe2bRbT21VJ1UsLrul9Yw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44889dd1-9c86-4f93-c31c-08d958baec5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 09:16:50.1305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5DpSdYQBvYrpve3sFRyJC0saVIQmNoLYxn8YkwHiWmGoFGI2lPHDbCYpUfr1w6VJvs06wWWVAIbWApFEncFaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4347
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 18:12, Hannes Reinecke wrote:=0A=
> On 8/6/21 9:42 AM, Damien Le Moal wrote:=0A=
>> Similarly to AHCI, introduce the device sysfs attribute=0A=
>> sas_ncq_prio_supported to advertize if a SATA device supports the NCQ=0A=
>> priority feature. Without this new attribute, the user can only=0A=
>> discover if a SATA device supports NCQ priority by trying to enable=0A=
>> the feature use with the sas_ncq_prio_enable sysfs device attribute,=0A=
>> which fails when the device does not support high priroity commands.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 19 +++++++++++++++++++=0A=
>>  1 file changed, 19 insertions(+)=0A=
>>=0A=
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/m=
pt3sas_ctl.c=0A=
>> index b66140e4c370..f83d4d32d459 100644=0A=
>> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
>> @@ -3918,6 +3918,24 @@ sas_device_handle_show(struct device *dev, struct=
 device_attribute *attr,=0A=
>>  }=0A=
>>  static DEVICE_ATTR_RO(sas_device_handle);=0A=
>>  =0A=
>> +/**=0A=
>> + * sas_ncq_prio_supported_show - Indicate if device supports NCQ priori=
ty=0A=
>> + * @dev: pointer to embedded device=0A=
>> + * @attr: sas_ncq_prio_supported attribute descriptor=0A=
>> + * @buf: the buffer returned=0A=
>> + *=0A=
>> + * A sysfs 'read-only' sdev attribute, only works with SATA=0A=
>> + */=0A=
>> +static ssize_t=0A=
>> +sas_ncq_prio_supported_show(struct device *dev,=0A=
>> +			    struct device_attribute *attr, char *buf)=0A=
>> +{=0A=
>> +	struct scsi_device *sdev =3D to_scsi_device(dev);=0A=
>> +=0A=
>> +	return sysfs_emit(buf, "%d\n", scsih_ncq_prio_supp(sdev));=0A=
>> +}=0A=
>> +static DEVICE_ATTR_RO(sas_ncq_prio_supported);=0A=
>> +=0A=
>>  /**=0A=
>>   * sas_ncq_prio_enable_show - send prioritized io commands to device=0A=
>>   * @dev: pointer to embedded device=0A=
>> @@ -3960,6 +3978,7 @@ static DEVICE_ATTR_RW(sas_ncq_prio_enable);=0A=
>>  struct device_attribute *mpt3sas_dev_attrs[] =3D {=0A=
>>  	&dev_attr_sas_address,=0A=
>>  	&dev_attr_sas_device_handle,=0A=
>> +	&dev_attr_sas_ncq_prio_supported,=0A=
>>  	&dev_attr_sas_ncq_prio_enable,=0A=
>>  	NULL,=0A=
>>  };=0A=
>>=0A=
> One wonders where the relationship to the previous patches are, but hey:=
=0A=
=0A=
Yes, hard to see... mpt3sas is the only SAS HBA that can actually carry the=
=0A=
"high prio" bit for the command to the HBA FW SATL using the prio bit of th=
e SAS=0A=
frame for the SCSI command that is to be translated into a high prio SATA c=
ommand.=0A=
=0A=
This driver supports NCQ priority since the first support series in 4.10 ke=
rnel.=0A=
So I added the same change as for libahci to keep it in sync with the pure =
ATA=0A=
side of things.=0A=
=0A=
But sure, it could be a patch on its own outside this series.=0A=
=0A=
> =0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
