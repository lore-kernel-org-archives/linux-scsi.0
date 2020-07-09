Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEC8C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 08:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F28C2076A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 08:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ohXOT6fC";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="cKrV6/jF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgGIIbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 04:31:45 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18358 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgGIIbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 04:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594283503; x=1625819503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zN+PWKWQe1nG0DCjSwHPCJGWXTse1m7kMC/gehbmMSk=;
  b=ohXOT6fCGWagwxLw0T9lcMqMFKi6W0vOfORP9S97WvwQTW/WmnbuHjs8
   qDhkTPbCAoqzPIZnqv4tBDzyhXD+gYSr6Ea110wO6eVIcwX5mTkHgTuSp
   uMVF+6YGxAkcFX+5u2mxHLxgT2a+S62pUedrPI+Bl7KMqqMG/dQ++tLDR
   FzZPGc11kBkriYDGEyhE0PvfreRo7DaTJwbhv3VyCsQHi32FHxHJf82c6
   oaQFJhMfeI+WZgVYXh9Zu7K/HnBnrcjUopLgJsBC16Zr5axf+ncLHWT4d
   giz/WVfTuBjJ+Ev2yJNRzYd/XZwxnrfQnBbsASivh45EFkt7mvZ0JMpBE
   w==;
IronPort-SDR: 01I4le7/6eVQ3Wcz8/5ZZusEbJI+sFHJayrkWGjiikz3KfiTaTqDUDA3fQw+KZ0a2kdmo/KIRR
 T2usj/11XrqZCqGu8M5nW+W76/gt9E7pDqqBOew9UJaZxhtypfteCdftySDk/3wo5+GS+ljQmu
 An9JkxjTXuhb5XvYSY0GjX0NFaGxrYNKJOoCnSeW18aPioTsRb0UeA81WSWRzOElrx2tSbaHDJ
 QW0HpmAuN2feHqQwI2oYjp77Uq+qk/vV4clicYuEYZRVocQx0dvfPxYq6W/iq39ygCnwxhPV1B
 GJk=
X-IronPort-AV: E=Sophos;i="5.75,331,1589212800"; 
   d="scan'208";a="251244665"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2020 16:31:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/xSqEoiYlO9mtv7iEmQMfcD+Io3Wfyhp71M/lO6lzPMKM3pFFozYbNDG2Xpbf1vXIj9Zw+fgEFMwRkTHaRicRPPkdboOtlmI5i2sG66zHgrOo33/hqFxgC8481+2M68qPVkbgLZyEfFwKFkMWoc24CDOz8alNny1WkQEOZuKn6OnEfVpas04Jg3y9BCHuO3Vo4ljpEuHtY17m7SpPu5WAuYSUtuyk5ob4+S0GQaeoy2IRwpzD4717LHM5ntuSgcsQ2sUTKZ4EhhbB/dEe9RCnwkpiUNoxyLiJbiml4HoW/Z0VRPzREKPCvGXMD57rrvkw6qwisrtakglS+ClaCfrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekkzpRgnrr8/JLPd/gdts79eI2n9NWKRFSIIMpVuMv4=;
 b=RVt1ImSCkwTHxr4VWXyzkkMEc3P1fWgLOOn6QZ0lUwsVZLROUZm6R050QtL7H0Mw5B2szf/PRUHCZz41PZmw8YHN9AX0+4qLQKbJSzKWkxRRHb3thnpu6iwYj6KVQsdGxj5NW+CUj5rLBuEm1M+85vvu7LZPd0W8RHNfD/DXqnqgt+ZbU9HmIu9Eu5RkA0nB38r3fzju3y9TR/fhPGebDv4rkmWFdF8OqYbv7hJXLw6nitmm8gyzcfKr7pwrY3MMiO+l/97Lx6V//Y/++MWH9l7yzRrHJtd1hYGOFQ1c6moeu5C0GBqxn6YI9FPki4u15cJAXzF/5bVTd0brlEG+OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekkzpRgnrr8/JLPd/gdts79eI2n9NWKRFSIIMpVuMv4=;
 b=cKrV6/jFVI71MJPWTOpj/ISDHUfC2SYAL4fU2x9UDyfEniJD4AZgrPVHOC8jgcyas1xUr7gphw+gHmqF+2TPlyDvtDUaP14f7ezdvIBGSj5og54OOm/fHh9sgpgFJCiDn1iv0KPPeTWIL+ivDGT4vzjI8FHzzYRECDS1sdVsc/w=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3997.namprd04.prod.outlook.com (2603:10b6:805:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 9 Jul
 2020 08:31:39 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.031; Thu, 9 Jul 2020
 08:31:39 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH v3] scsi: ufs: Cleanup completed request without interrupt
 notification
Thread-Topic: [PATCH v3] scsi: ufs: Cleanup completed request without
 interrupt notification
Thread-Index: AQHWU5heDqJFApuOo0yQOIjuO+/O36j+4j7g
Date:   Thu, 9 Jul 2020 08:31:38 +0000
Message-ID: <SN6PR04MB4640BEAFE18BDC933FC7EC95FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200706132113.21096-1-stanley.chu@mediatek.com>
In-Reply-To: <20200706132113.21096-1-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 665e6441-f06d-4590-f60a-08d823e28001
x-ms-traffictypediagnostic: SN6PR04MB3997:
x-microsoft-antispam-prvs: <SN6PR04MB399775926FA2C72C1F31482BFC640@SN6PR04MB3997.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 04599F3534
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MTkVQOORCQ+ItNsMGoLA+xuw7LF1bDYRp+iyxbgS3U22JqvUBvxIgcicDMlihE8Ud+3oROmHC6/LkSeZbLSf38EQ9YJr59UmEerTy3ApOlFJ2hlHHKvmAWEOi3wRmJMkco/VPcZ3OpfycvDk0rubeLRn/Y53Hgz+YBbJ5GILgY91uzVf4Su9Y27Kkg73y6GUzya8a49CYslp9IXIejjyJ7xAwv0Uu6cH3yDwjPI1ckyBuNh0xQRp6l99lpzUAhqlS2Te2eO4tWXMWC8ZnJbmHeUFIGhngmJkclU1rbC+byMZ1GzAind3asy0eol/wcxZgB0CltHgfqtWXtNDw4WxRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(8936002)(7416002)(186003)(6506007)(478600001)(52536014)(5660300002)(66556008)(66446008)(66476007)(64756008)(66946007)(76116006)(7696005)(26005)(4326008)(33656002)(55016002)(9686003)(8676002)(110136005)(86362001)(54906003)(316002)(83380400001)(2906002)(71200400001)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VB7j0/TJzQVR6fomZg8zgSw2HNqIn0PNt1thFo7ijLLYY2XFOBjlQeqjGMm6EXMVVeeAqHkoRVSwwOj6zo3ICVtfdTQtzRrfUUMikrbEn5MymvEX3orIjhq/xRZI61GJujBXNSkIw2ZR8zSz49auqHwN8BJEtuh3RjaWt2SpF1iSyfw5bKUWR6GrRZKxoAcMPes6suQDXIMt4yvNwLfSYB6+/RFAFDyJD5R+xOUgj7T3oFbiTpIpBlNpSMxWSYmJxEPD97wSUvm6pGKzXbtliaFmVHxNDwEMTK3mdM5YhY3tk+btsrr49jAb/Bq/ypd42KI5EUWp3jeNwQDRDxpRIfh75XuofTMxx61H2JkSaj8F43Wh3FZrZsO0t96hOnAq5Wo8o4eweN54iB3fibC7K4ETuh1wD7sDbf4hdCircb5BUsGyJXKjsldMyaV0503pUWww4a1+7XtZZSn+RbQrmXtRaXUUjqBiiM7LbNJzDhA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665e6441-f06d-4590-f60a-08d823e28001
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 08:31:38.8429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2cq1zmKEfR9AqZypCwZzRcsU2LIeDFUYQcaCsBQHhFDuXdQ6trcxb+lNRtWAEm8Fr0zG5EVBQ8bOvK+uXIU02w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3997
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> If somehow no interrupt notification is raised for a completed request
> and its doorbell bit is cleared by host, UFS driver needs to cleanup
> its outstanding bit in ufshcd_abort().
Theoretically, this case is already accounted for -=20
See line 6407: a proper error is issued and eventually outstanding req is c=
leared.

Can you go over the scenario you are attending line by line,
And explain why ufshcd_abort does not account for it?

>=20
> Otherwise, system may crash by below abnormal flow:
>=20
> After this request is requeued by SCSI layer with its
> outstanding bit set, the next completed request will trigger
> ufshcd_transfer_req_compl() to handle all "completed outstanding
> bits". In this time, the "abnormal outstanding bit" will be detected
> and the "requeued request" will be chosen to execute request
> post-processing flow. This is wrong and blk_finish_request() will
> BUG_ON because this request is still "alive".
>=20
> It is worth mentioning that before ufshcd_abort() cleans the timed-out
> request, driver need to check again if this request is really not
> handled by __ufshcd_transfer_req_compl() yet because it may be
> possible that the interrupt comes very lately before the cleaning.
What do you mean? Why checking the outstanding reqs isn't enough?

>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8603b07045a6..f23fb14df9f6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6462,7 +6462,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                         /* command completed already */
>                         dev_err(hba->dev, "%s: cmd at tag %d successfully=
 cleared from
> DB.\n",
>                                 __func__, tag);
> -                       goto out;
> +                       goto cleanup;
But you've arrived here only if (!(test_bit(tag, &hba->outstanding_reqs))) =
-=20
See line 6400.=20

>                 } else {
>                         dev_err(hba->dev,
>                                 "%s: no response from device. tag =3D %d,=
 err %d\n",
> @@ -6496,9 +6496,14 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>                 goto out;
>         }
>=20
> +cleanup:
> +       spin_lock_irqsave(host->host_lock, flags);
> +       if (!test_bit(tag, &hba->outstanding_reqs)) {
> +               spin_unlock_irqrestore(host->host_lock, flags);
> +               goto out;
> +       }
>         scsi_dma_unmap(cmd);
>=20
> -       spin_lock_irqsave(host->host_lock, flags);
>         ufshcd_outstanding_req_clear(hba, tag);
>         hba->lrb[tag].cmd =3D NULL;
>         spin_unlock_irqrestore(host->host_lock, flags);
> --
> 2.18.0
