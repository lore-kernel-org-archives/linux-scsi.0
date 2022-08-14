Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 091D1C25B06
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Aug 2022 07:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiHNHpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Aug 2022 03:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiHNHpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2022 03:45:45 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B64313F34
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 00:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1660463143; x=1691999143;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c3VyMPnDAPccGYp7fy8kjK8odNzRdey7MOEMqyeMV0U=;
  b=gD8iX+uB7ehPzZKV7kTlmY7pTrQGfGhAFIZWjdqPwL0XlLG5C37R7Zju
   TRZ8573+UZR00M7ROtjsCR4rOgGpOx6miJV6UTP//cqoZRyXYGP69wFeH
   KVX6F80IaCfSyzb4VIEJvRhDQA8CRtp3XrWRtN9ognV0gTFiF+62ATew3
   LuqMGTnCe/NgyhJOBhR1fPj9mxRSdEd0BorjHwNcNeI7kikz+nl+gxeLm
   HgCBMKOYT5ObztB2Ux0I1PQKpH79jn2SDLr6agxMOX8MxzlPAqoL8yj4S
   mX578gcCBhpoAHPzi/s/cMi8WLHzEFY6v9apWcuBzFEBCWt/5du7vy+e2
   w==;
X-IronPort-AV: E=Sophos;i="5.93,236,1654531200"; 
   d="scan'208";a="208652509"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 14 Aug 2022 15:45:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXN2h+vP0hW/d7UprWHu86LKlbt0o233pMTxTmf7sXGi+eb4hRfi7VzkZMWW4069ykMNvYpZfK8At4t7KD6LrTRteN4PqvcuHt/nL8iONB5uiSG2ukw6wGDt1LjClWfBkJNF5mFQC8gsq/l10Gyi/WQXOWMBLiWMSgFQHLXuYrCze+HsXuaN6+OmNtpdRB2kEBHNkfX7eHq/o3Rj1UipsNLLNvxvGgecRwcoYfYDW39/p8/CvsPZu1OS9ErgUzRv6OImG6zbBjspvjzzT+3SKkkc9QPMX0Xg4tdgkWMjspbWh7uSQFKw0k2mOmRSOwL73PaCishrIfUNBr+sL9WGXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLMA6/t0Ex5XOnGWf+PPhLyqq/6IeLzr8T3LSNvl5jU=;
 b=MDPqm5ZWohlLkp1nJn1gkOej4LNT5WWHmppbEgQE7MOK16DZoFfNjAGtybO6V4YMAqERIOG2dcZYOhlPN87qf0lcu2iPJ4KfxHEKtjCqo4/t63gTlcr4TWylvUis1fo4kWmBnq4YuIdLe1PkMvmMpPNvW+2bnvNnosxG1b9KmoeSmFKoJ+bN9BLxgtIW7KxR88FoKNY4YqvBVqurVJN1sy+CCY85RFE4REqeFzoq2XowcpXNXa6DlMy1tRtUkzogo/o0x3IY/PIhreLMtXxZTiXtsL5YUwvabK/w46uQCR/JHDm4wG98zw3Wsc8e65uZumP2lM0U3mDA4xknRoVJFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLMA6/t0Ex5XOnGWf+PPhLyqq/6IeLzr8T3LSNvl5jU=;
 b=fK8uW8x6eRG5/nIQesMgxkGPwt/DpwB1tN1wCbOXdC0Y0CAmFOm0/bSthzuSBmw5FXlbTmaYMYL3j/ruI6hzVUE+z6L4O5EFMAA8GiygfjeTcV7TGHVcp4VJVh3+Zkq0V4z+8M2/gv0CGa1xEW/I0oCK6sPdVgYs+eHDnM7yyw0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BL0PR04MB4500.namprd04.prod.outlook.com (2603:10b6:208:4a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Sun, 14 Aug 2022 07:45:39 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%9]) with mapi id 15.20.5525.010; Sun, 14 Aug 2022
 07:45:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH] scsi: ufs: Reduce the power mode change timeout
Thread-Topic: [PATCH] scsi: ufs: Reduce the power mode change timeout
Thread-Index: AQHYrdxB+bwGvJKz8kKyS4kBYnaxpa2uBtkg
Date:   Sun, 14 Aug 2022 07:45:38 +0000
Message-ID: <DM6PR04MB65752D7162050322A411C76AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220811234401.1957911-1-bvanassche@acm.org>
In-Reply-To: <20220811234401.1957911-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6e9f46a-09c9-43b5-0604-08da7dc8fb55
x-ms-traffictypediagnostic: BL0PR04MB4500:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +uUArImFDC3fVPgZcizvcJ/D7QvxYK7Dib/xPJuV2ilpqLiDacQGawM0bJPBS0PHnJ7R0+omrjsDa3dj4GfTKk2v8MC43f7DpFXvyVFn38bUkPvEK3amm5xsA/goC4JtAXGLhijp+MKWK27kjdfWguKlkk52hpaeEzv03vsNvFt1yZi/4qASoCnGx8K73wCfaNRY4IUhy7aWhLod9a7qbQPx8mqQh6lH4X7zkS7544Vx3B35HqF9cOqaSNOdELJe2t93/yKLGpgTKrlAABMkq2QLuHZpkL9Ym5jfeFjb5LGwoxLOa61kX0fEcuXjif+2+agT/mfrK1oacR2TQVoH3oFMCc3Ex8cO3QFu0xo7dqsZkgbg+uh0xzOJPacuzO4JBODTA27DuATLZm8o6VaZ9ocaDGzN3GwMNiooRmPfNEOBJxx+VVe8aEc3D3ABolZY2En/BN1LG4Cvk4mEAmVUYxrePzVzbo1myGuPndV7yuwZdofD/3CwfQIHDMEA7HZxwanbWtcVIuS6vEtJRJpQefKAKsqUReo1XDzCxXCdi0hV10J0jyN8Igx6+Lqmm/R9LWEhW3sEQcwyMjpPRJKy4i4dVShMmjZzZEBICm/H4ruAOr3GuT1nid/jlSFDd5hosf/CbFQns7Jz2uwae9hBVIvWbWLc69olmaEF9tBJ2FHpSNhHNSiX+Hva7VVYNmjO8X6z9g2/yi1uBQBTR54W3Ai/rajhUy4wXkmkHkz3JHlsWD4uUNLzwZnDroWKHNHKlbNzyay8e9UwEw5XJgMSecJauPkvqpIkScA1P0x96ZrFRVMqtGv8eYBqnltzYTXu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(64756008)(8676002)(54906003)(76116006)(316002)(66946007)(66446008)(55016003)(66476007)(66556008)(5660300002)(8936002)(38100700002)(2906002)(4326008)(52536014)(122000001)(33656002)(82960400001)(86362001)(186003)(6506007)(7696005)(478600001)(41300700001)(83380400001)(71200400001)(9686003)(26005)(38070700005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Emzgtt8crJHdtolUI2EoEhjNfM1ybRk6bfz9QCXe8+IajiCKBnUgoOgS1rp+?=
 =?us-ascii?Q?qzQarHyDcF5O+ge0LugKD3Jaadqn2fIVFh9M4YcIbDtRKrFlWkt2Wjr1HPZY?=
 =?us-ascii?Q?KCNvRpALYG6HDiB2Zd06meRrtJ9emwrTqy68s4hpis01vnVh5wDFBt3THG5y?=
 =?us-ascii?Q?gqbLkKiPm2q142Y2uXzP2s0xliTwpvIerM8qF4J4zs5EmlMUDHLqWifHVq/F?=
 =?us-ascii?Q?Ve20JlGaD03c8gxiMA0oi6wp+5loEkkxlNcKs72O0r4WTxTAsiEqT1+Ts2et?=
 =?us-ascii?Q?I8ZquAwC8aSE+IAxlqzSLWAjDNksL/NXZ6zBYx7VJm0G4Wo61dncFE1OFHZJ?=
 =?us-ascii?Q?O0FoHRRyzvqRjqVMO9koqetgMF9OTJ8hN6c4JqqGZQoqh1yGAW3YDNCh13oM?=
 =?us-ascii?Q?NPZjso8xKrhdm/4spZPPkBHKh6yd69tBkU1e46zDPssjg0msUTnSbc0YLbOK?=
 =?us-ascii?Q?rW9QJi8ybaYOW5i/hVtmIuBnfYhYEDIRNXDX8X58uOrGAMNC+6Fy4gPpOeoQ?=
 =?us-ascii?Q?RnW4NmoXkGabaACk9DR0HRlP4vogBkxAQ19KWwXPWPV1E/6SBZFEX+k4P07p?=
 =?us-ascii?Q?GSJ3Cs0WZOOkxVgeAQX5YQe+x+/IDZpX04SFaSKKYkPco9GAtG0vgJWzdZ5K?=
 =?us-ascii?Q?1dqH3vx2qAx21Pl/xTS3Tv2fNo8ut3LbPMKtHYqXJ/qR/P3tMxddPq0An95z?=
 =?us-ascii?Q?2ZLUKqgCoIY0RzrTASaEDtNNUbHolGz4S77bfpXE2p1tF5DhDqpxQQkDlB/g?=
 =?us-ascii?Q?OXrrE2vzh/Az/5Oa6KRINmFcyQdQ12LU+Z8ZYL8gxTbU64Sgqh30G8rWH7PW?=
 =?us-ascii?Q?0OLYh+rdSy2vUyewaTro3/IyYwjeVAZA/pPRlseIqE4hYLdW/DcEXs5ZZHIe?=
 =?us-ascii?Q?81uB7FjainK6bJuKq/iwIr86aS+y7vmZXnKBVg2NNuNXnI9mF/rrg09NyVoP?=
 =?us-ascii?Q?rvLdZy0v1DmRPzg6dmG/njEotSUFIAJF/v53DZ0tEQGOE0b2+BDJH8JYCRoT?=
 =?us-ascii?Q?UPZS+aUEzgPcHGNSvWda/qg9G/9oQ0MqATpgpv/Oms44qCE6I6M15NwQRM3F?=
 =?us-ascii?Q?q7GqpMOyU93ecOOdmOqPzREGM4mw/5A+gyW3+RvrKIRfM6xgFK/YCERib9Eg?=
 =?us-ascii?Q?aKcbKkLLMhNJ+7YD7ySNSvXfqn8MhF7ekY5p+OXQkFvTOOg/773LmDqM3rwa?=
 =?us-ascii?Q?BLT+Joq7Q6s5rJxs6vA5la9rox6M7XruLS9rRXqZMmOKznrhTbVBE0U9rxQp?=
 =?us-ascii?Q?T72Su2mELi87iM5kM2MbbxcSbhSfoYPuokPH17wHdeu5RiimDvI9+Y3jvEyD?=
 =?us-ascii?Q?ZglQRkzWNsrDJcbEOITxtD7WSfi5OrlSWYAR9dgKrqFcfFFgaSlLUEl1Wvn7?=
 =?us-ascii?Q?I3v2r1QzHTn+X5Fpt1Vp50I+geqqE65ld8xsDzcofJH5N6ZPCC/bMnidbdtZ?=
 =?us-ascii?Q?BEp1DmeKHF1RX65zcpp3krMlf6iKayX3ItlZIefEWCXpQuwPoRL4cOQXrkgA?=
 =?us-ascii?Q?R2kyc/WK4DfwKagpPOgI6s5VSbmWRdSxE8wQ9GtZTPVdBd7HLZFZhn4rZZ99?=
 =?us-ascii?Q?ltyz2nvk2N/LmfmYUqITaQ3qHr2eZ47kcj9oyLdU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?5sd7k5d08TIiR2Biap6vRjQOvoenbg/MtTLp5Nqitz9DJ0W2ZvO+ZDo2NH5s?=
 =?us-ascii?Q?HalJny8RMMlNey1jY5ghfVaR4baeVVDXo9/DUpsIY9yQV273RWDK84E3ArM9?=
 =?us-ascii?Q?FHIj2Z3anl+xKCv9i1faspLf1taN2Ae2HnIbNxbqZ63JENj9EyNg7aazC2T1?=
 =?us-ascii?Q?Pbq33PFU3/UD1P0WK2YV5PV9AHYB54yh1szlHDzH70zGsdhuS9rjXiCEKq8d?=
 =?us-ascii?Q?/vvQfK8WrmefbXM+6x7HbK0X7mROjWjFY3eZj5hPm7Hu/Iz4vkdumf1IDAc1?=
 =?us-ascii?Q?lp+zExAdmztz8uKYDwONl+ReFFVt5k7yhL3QcTKsEryLe33sYTgvpoTR0CHm?=
 =?us-ascii?Q?0WxNi2eSad4NTJ0NqlhvWBsAXYRs91EJ7vII9XC8E4JJ8bhUtkt6vZo1qBUt?=
 =?us-ascii?Q?7qnrH+P4OLaeQIlb9p6qGFhqK4g4d03g7A1LfhtDjMmZ0R+gYPv7+vZ/lz9v?=
 =?us-ascii?Q?kwu23Ytgpf6Br1WwGTEqhw9mTAV2fOQ0mpNksOvOr1Ip4e0ehzHt6qS7bPLJ?=
 =?us-ascii?Q?uQcS9GTM7wrjxB/TfDBqJwWIOClTJcpidA7OEWKLlzFKv+4g3p6a4W00Oetv?=
 =?us-ascii?Q?ANIpsFdYXymcXZo5TbhoBKMIdBHOiHj3I/S4mmdxPONCa2tl1H6yBAq/5rly?=
 =?us-ascii?Q?3tbxIo2a2cz4p4rffv5c0sVubfI13uzXlzQF/EDOhMVdJB69NqGF1wHiJYeB?=
 =?us-ascii?Q?t3fS7MfjsadDhcV5cIUDwmYWqnXlN1KNL1iOAvwYFIbx8OqzvG/UYETp4LPk?=
 =?us-ascii?Q?RUHV0mJeQRp5eYCs3JiBbd8QDwvlyB+jswC1iYDB0C2/Yf9q27DmXX+3irSv?=
 =?us-ascii?Q?gt+9KJ1jWUFa+opjzZAcaD5bzsVSU50hNM/XVVN4G47rkvNf+3aEd5i32pzJ?=
 =?us-ascii?Q?ZwCT7+/6wmKWrqH3pONEe4UtmxXDzTBdfONtL1v5QRPo5ugOlpHeohLZ+HCc?=
 =?us-ascii?Q?D5cTNSgpSNOuvIVzQw/fqIfFXjAPedWfFUrWvGRRe9QsLZlExO3rMpuOHhEi?=
 =?us-ascii?Q?sq/mebi6X/FeWHxaDJ+p0J7f0RDJFOoBscyvd+rlHOUJp7arXdOX2NWn66X4?=
 =?us-ascii?Q?MtbBeJrE?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e9f46a-09c9-43b5-0604-08da7dc8fb55
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2022 07:45:38.9293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OiToLez3u19pfs524B+j6P2Q7thb1rdgfXf1ybyW+aTEedrGQin+wjPOkb/rJkKUkkBF6cALXRKi/Fc4pqQIFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4500
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The current power mode change timeout (180 s) is so large that it can
> cause a watchdog timer to fire. Reduce the power mode change timeout to
> 10 seconds.
Maybe also worth noting that it was invented 20 years ago for scsi ioctl,
And is less applicable for nowadays ufs devices

>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e32b6b834b7f..2dd355a5da54 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8776,6 +8776,8 @@ static int ufshcd_set_dev_pwr_mode(struct
> ufs_hba *hba,
>         struct scsi_device *sdp;
>         unsigned long flags;
>         int ret, retries;
> +       unsigned long deadline;
> +       int32_t remaining;
Maybe use ktime api, like its done throughout the driver?

Thanks,
Avri

>=20
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         sdp =3D hba->ufs_device_wlun;
> @@ -8808,9 +8810,14 @@ static int ufshcd_set_dev_pwr_mode(struct
> ufs_hba *hba,
>          * callbacks hence set the RQF_PM flag so that it doesn't resume =
the
>          * already suspended childs.
>          */
> +       deadline =3D jiffies + 10 * HZ;
>         for (retries =3D 3; retries > 0; --retries) {
> +               ret =3D -ETIMEDOUT;
> +               remaining =3D deadline - jiffies;
> +               if (remaining <=3D 0)
> +                       break;
>                 ret =3D scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &=
sshdr,
> -                               START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> +                                  remaining / HZ, 0, 0, RQF_PM, NULL);
>                 if (!scsi_status_is_check_condition(ret) ||
>                                 !scsi_sense_valid(&sshdr) ||
>                                 sshdr.sense_key !=3D UNIT_ATTENTION)
