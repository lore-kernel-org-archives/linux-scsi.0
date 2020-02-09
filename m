Return-Path: <SRS0=cDh3=35=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FA6C35254
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 07:48:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B4120733
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 07:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fGkLnZIP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KyX/AKCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgBIHsn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Feb 2020 02:48:43 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5291 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgBIHsm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2020 02:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581234538; x=1612770538;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=At9kaU6dhvsAg8nH3p10caC+DBQibDul+NDdCuPbgWk=;
  b=fGkLnZIPPHWIhQcnDfdRIawrIjKxkErSx9ud4uq6qUYoKySDG20EHsVM
   7FTh//n5j0+EInq6k7v6CH60ceAlT+f31Jo/ofpsxrlplAB+rMyz8llPE
   oJYFzjLHTEX44WD1cjRogf9xcxVbvOIgoYX7dwVwSMoqq3c4ohR79zjPZ
   87EyXeMQzlWAGXyqQtA3nWluG4mEV7BRFdo7lGjoYMqk/UjP0iO0KxOXu
   5r3LVHgPexXokOAe0lSI5lwQSa1J0R5mmCnG0XXS1+hS+/lTd3AchZwfX
   MKZnYuJBzN6dHPEf0Hzb1meV7ynYW2JncL2UqEdUYBrl38L8Yu68vT3b0
   A==;
IronPort-SDR: gGtsDolP0TGrEwxIr6HUpTE5yD1U8yv8M43ylMSS1x09rCYdulEhxLVRfDtAMzKwhiEh0DyAZ0
 owb95LrAbkqr4Xg6Rq1SFf+XOXiWklIYODebkZn1pebcn2kIT5tH0cWbV7OPuS9nJbZCIPjT6e
 RC98bnlAauheN4JhM6+TqNEVIG14HOTkPGpmcgm4GZv8zzD7Btgy0ZbGmE82d7s2Bbbccwd9Og
 u2hA4Qz9quE6EANIqBxx7yx7VsmWNuCVNiP2HCf3lvVU6Np0RRptf+wDPg/9wKeJ9080TVznkg
 q2M=
X-IronPort-AV: E=Sophos;i="5.70,420,1574092800"; 
   d="scan'208";a="231219297"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2020 15:48:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ND/DEUcT7pQBN894IVly6txf+I8fm73a6uJtMthhkwneX1K4vpUgILqk5B9VHot42vJs5Z64qdXMzzF/dORErV9TV1vMj2/dutkZNE/UlxaXIp2MwuXICTBq6qNcFerfRnBY2S7an/CZXW7fb1W5WBBfoUxeyL9KWBYjthZh+cC9Tr0b7RMstThKgVEE4EyXjJ8hQNQPTRI2S4FLrU6uy4bSXDvkERDZQ+jdC6w6fOxWd5pxI3V0VXw3VcltGtpw/GcGA6uqQNPzkRTgmbeC+R0kKSIrEr0/vefeNRuqo2yLB0V/9wRlEf3OhWsKzwcdvAe1BV+tLRE1r0InESyB/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGESSIVYuSZhh1/v9pO5zFVMaqah/JUohDbv7uUfDhs=;
 b=QBru3cryp9Z5/sOTBZCxR09UEPwRFH9cWvxfzsnvVgvhf7FaaE4FskLx++aF/ZdETF9WVt945dKXKWMDgTWUFkx5mER5JPL48qMA4Dou1/nOAIWaQMVt+fpztQKG91aBQqty4uY1mmWhrcq5ApKE/X1j+KXEqzLtXj8JsoV1zKNGwS3Od3xOZhfn7QbLb5d//KkVpBgrgsZ8n/X4zHI/zyLM6VP/xJn7J6Eupeg1KiidfKowXfZEcDOzXtnjUsLwlhunIeRsaZ1iype7uMjtHIzLAkS/PNVn67MmqKHEHed9xUuh3XBqrDt6ZLX9VR9UNUc6RjbRXJJ+DG+fdxqS3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGESSIVYuSZhh1/v9pO5zFVMaqah/JUohDbv7uUfDhs=;
 b=KyX/AKCiZGRblSSVVt86d2PVEznknpRom54/671ppjyeO9sUBCSNy536JOdDI8tcy0gAOSWU+35eChYi0/oA3vUOfP1vx9smwcF4cZnczBtI3pXUUl9mHp1D2NIUdJA5uOCt+Bfi/e5hG9U05WnjZszy/L8AVufHgiGK1zOgqq8=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5726.namprd04.prod.outlook.com (20.179.21.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.24; Sun, 9 Feb 2020 07:48:37 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::3885:5fac:44af:5de7%7]) with mapi id 15.20.2707.028; Sun, 9 Feb 2020
 07:48:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: RE: [PATCH 5/7] scsi: ufs: Fix ufshcd_hold() caused scheduling while
 atomic
Thread-Topic: [PATCH 5/7] scsi: ufs: Fix ufshcd_hold() caused scheduling while
 atomic
Thread-Index: AQHV3hnmgATiAPkOBk2rW7eA93U0SKgSfjAg
Date:   Sun, 9 Feb 2020 07:48:36 +0000
Message-ID: <MN2PR04MB69919F988AA4F1B7BD36408BFC1E0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1581123030-12023-1-git-send-email-cang@codeaurora.org>
 <1581123030-12023-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1581123030-12023-6-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f822112a-e7d7-4444-e322-08d7ad3478c9
x-ms-traffictypediagnostic: MN2PR04MB5726:
x-microsoft-antispam-prvs: <MN2PR04MB5726704F56CAE376CF0F864BFC1E0@MN2PR04MB5726.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0308EE423E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(199004)(189003)(8676002)(6506007)(33656002)(478600001)(26005)(54906003)(110136005)(8936002)(316002)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(186003)(81156014)(81166006)(9686003)(86362001)(2906002)(71200400001)(55016002)(5660300002)(7416002)(52536014)(7696005)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5726;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HcM50yhcU3R1FXDxt7ACLfAyV22qIUlTF9MQyi3/hkeFB4M3dK2ASJh8zqbIpOdn+7fXutfCSvojRgw5FvR1IYdI9txYBd1EWJ/ipjywLELjo6t1522CBaAHL4GuE6zqWCy+icgOIYM9lvR7xmvaQfpuaKWpUh6p2gQ0VwbQk5QM+aehDdSEgZ2SPjFAiVOeobHFvCFvwCLjwCxFW4vle4OtrFJ7RD1l3dUhagYFo04GpVR1YKrzbrX7iyOYAAY5yS19q3EQonaSZsHZnv4bTX+rhjrdWrESPZ8J2u5izm0KMZ/n5UD060fcjv6QdfC2JEikVEdtDUhXwDRCjEzwVPI7IGcW1ySSZUsJ7fO9nB3bajLNBH440hclSeJWDJGPpSiJwLRmSomSaGMQ3yq5GeGqfbAaMQEBnyJHu9Ki9qMhbJwm7k3PfctQfd3vum3c
x-ms-exchange-antispam-messagedata: JxiZLUeFm+9dFRGtRAXTjyQZNTuUpc7B5I8Kc1VunK/YFY/p+Ubp6VIZIBRQNEzYPYxr271NwBrbFLtgZen8zmYLeQGcKwNXUUsHNFwnJkcw6PPa22BpdZuu52D20lGes8aJq9V6EeNrsx05+v/m6Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f822112a-e7d7-4444-e322-08d7ad3478c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2020 07:48:36.8752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dI5cE8FmZagzBaGQ35IXmAFWNbKZl3R6Sj34BPJzgwZPVVNTaIqF/Nv45FvkHiCf7ExCdKxJVqZZOfGzbzl6AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5726
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



You didn't address any of my comments to this patch.

Thanks,
Avri=20
>=20
> The async version of ufshcd_hold(async =3D=3D true), which is only called
> in queuecommand path as for now, is expected to work in atomic context,
> thus it should not sleep or schedule out. When it runs into the condition
> that clocks are ON but link is still in hibern8 state, it should bail out
> without flushing the clock ungate work.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bbc2607..e8f7f9d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1518,6 +1518,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>                  */
>                 if (ufshcd_can_hibern8_during_gating(hba) &&
>                     ufshcd_is_link_hibern8(hba)) {
> +                       if (async) {
> +                               rc =3D -EAGAIN;
> +                               hba->clk_gating.active_reqs--;
> +                               break;
> +                       }
>                         spin_unlock_irqrestore(hba->host->host_lock, flag=
s);
>                         flush_work(&hba->clk_gating.ungate_work);
>                         spin_lock_irqsave(hba->host->host_lock, flags);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> Forum,
> a Linux Foundation Collaborative Project
