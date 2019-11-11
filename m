Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC31C17445
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 13:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA3C421925
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 13:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mxgnD4cs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Et+HZTYq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKKNvn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 08:51:43 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29542 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKNvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 08:51:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573480303; x=1605016303;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=soaugNuhgv5QbAOyYKhAJL+UVU/irQ8EzycQHM9wGWk=;
  b=mxgnD4cseSjIVjvQ/fUVpgRTCMp42SDemP3yxy9tFRHPxHFJHFd0fp7W
   oq0Eq4FSTxDspaA6I5cKoB1vxE7ztcW2wsGR45pH7qbRy1yY+PhCZ8LsV
   nWFTcsBNmuXgwvGRslYjKQfREAk8KamOsR16oZOEJepqc3/5huK8CBaNR
   BJyihrbYYmzbzlh/UYXhMFEFD6ujbqNp2bG4wJNISXt9y7z8ur4JJSbmK
   Mt3+c0787EHQuEswJysPb91AMF9CDfWOONjCyVI3asscCY7uU3x7CvYQk
   KJcuwZzfa2tCivE1lfz/w5G1QWcxvP1vvWQGFkaNJe9wxYJApzaKg4x1F
   Q==;
IronPort-SDR: zt30+3nXhi1A+SFPbbypbFeMb1p6A0pKiNTVykZ43X6nFp0QxDXGNQGJ/wF8qHxncb7W6foUIo
 VPm1kVB/7ZkQ0OEOyUXC7Pd79jn+VtvOo+2XSkehlXQP+cXyxDz1nRq30SvCjIUdlgE4+RNMOq
 LrhQGEongo2gF/rn/NPXdGe5DkgWTAkicVr9KnFsw5h/elHOwY4A9vDlNkftXIalfBaSlxmZyC
 AFiIEejxPQsi0w1sK5gTqMGC/fQxvZEgHuZc38BRIN6AAWzt2f+f9DLtEh8emt5DVzsZgEEw3K
 AHM=
X-IronPort-AV: E=Sophos;i="5.68,293,1569254400"; 
   d="scan'208";a="123415529"
Received: from mail-dm3nam03lp2056.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.56])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 21:51:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXPiopL0UA5S4Sjto7PO1ufmL1CkN48777/wh1Zp/KuGkn0aZiVQAN5xbE8OTy2ZsZGefgAS/mYwKvS7G42sK3DbMi1XmS5Si0A+7zYoQQVhC2NpOyqHoSIcT/96lxGUXv/M4QMBw6MHf9UkLlzu331q4iPbT/Pem+XEoL6r1+XU0CDSHzJNnTu+FNO07UC3STjQZ3fliTeC4po9RGHsU8hyI2ncy/nyORDDlbEbvZCzpeleARt89B8kKGZhdH/TXHke4OmYQ9x4l+ftLkLMPA6ATYcJcFRjpFJHq81ubIjrzoVqDKHKWqaVoKhakklZiEGNm93FS6JDy1eJc3zBGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BV52x/Az3Y4WyjD4vazFzGpecEKEmuOfNtZ6a2cUW0=;
 b=HxJEvLUD2XHpEFRBKBdbUum+r2I3aFqUou9Pnd0jV57/P8+9Sbu91JCFC1uLembe9oo2lkw6Fyiu2vb3D793D7NaJYEOwpv+KkPM406iQZNZ9i0PAAtpm1T5Z1ataWM4Yl/iHWFrJsJezr8oQ+Gvc723nPWmcpauMQdnYm8r0fSHZsGIwGt3PuCQeMcgQ1fUIaMDYA8Bwf+xoKOyCG3AJw7iBx1OJbJFA++4+dWhEshB9s3MyOp6ANj+UxZ8AlPL46GqnOKfBlInur+4BkhM5XV/C40i4vhph86IqFw5xlCSgLIrvjkXl5YTNeCQ5oA7EGtqcXv7SlfdVdXOb2/xrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BV52x/Az3Y4WyjD4vazFzGpecEKEmuOfNtZ6a2cUW0=;
 b=Et+HZTYqZ5YMmoQZdkE3Bd/7nYLximwbVKE6BV/oKx22d89ugnjWhoIM+euqJlv/NtgPWvJ2EUS2NsjEasM2EZVxf+XWHbvZzqfLS6PDhwzJMpS8WP9NUM7XwVcv+i1g9keNmCQiQ+l7Zuk1GXcwkaOO4da0qJKJMkmn1njAAKc=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6717.namprd04.prod.outlook.com (10.141.117.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Mon, 11 Nov 2019 13:51:41 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 13:51:40 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [PATCH RFC v3 3/3] ufs: Simplify the clock scaling mechanism
 implementation
Thread-Topic: [PATCH RFC v3 3/3] ufs: Simplify the clock scaling mechanism
 implementation
Thread-Index: AQHVlD51ZGkxDi1UCUWATmFwT++grqeGBIzQ
Date:   Mon, 11 Nov 2019 13:51:40 +0000
Message-ID: <MN2PR04MB6991EF413FE9DD0AE8D990FCFC740@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191106010628.98180-1-bvanassche@acm.org>
 <20191106010628.98180-4-bvanassche@acm.org>
In-Reply-To: <20191106010628.98180-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 805765db-0a2a-4296-904c-08d766ae47b5
x-ms-traffictypediagnostic: MN2PR04MB6717:
x-microsoft-antispam-prvs: <MN2PR04MB6717E2FE0C5A526FA21CEE8FFC740@MN2PR04MB6717.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(189003)(199004)(51444003)(86362001)(3846002)(4326008)(6116002)(66066001)(66946007)(64756008)(66446008)(5660300002)(66476007)(66556008)(6246003)(55016002)(76116006)(478600001)(74316002)(7736002)(316002)(52536014)(305945005)(25786009)(99286004)(110136005)(102836004)(7696005)(9686003)(2906002)(486006)(229853002)(6506007)(76176011)(71200400001)(14454004)(6436002)(33656002)(256004)(14444005)(186003)(26005)(8676002)(54906003)(81156014)(81166006)(446003)(8936002)(476003)(11346002)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6717;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sY/hsVoBfBmt86n2VjcUEBZ/9tb2CRlRtO8OaZz4gbBvaisSI7LwslwNU5/GJklsGUZccsXQF1Q0xqC+eLWKbx4H6qPbiH62T6QdT/XwDCH/XnJEJKSHGzz2yvUUZWF7tVnKDpN9zG9RK8bnWAeccTegGjyym4IPwrvPYWbaju6DWFcigcKfx7/g8L+dJ2l0Emsz8pg2DtkM/CQnO/ZyYrob3dqy5wJ80R0AKxiqbEY9exysso1oKAi3WOCs4PfrYJwXrvRnqJH1yO1Y+myaZOgF6J6co9zgzEWKFWKi00Wkv7u2bWU/GUmRmCUEogxoagf6di0wvlqKdIn2zdFIZS2+3idpob2IuyHA3G0KZoZRFpFNX5SnGccJdHcyJmuZd/yNco1HYfo0bHpVKcyFueCOBRq/5LAgnq6wZ0bK6l2Th998/oWCub8Qg7afUjEL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 805765db-0a2a-4296-904c-08d766ae47b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 13:51:40.6094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ilfnUDVyF/KKHZavBuh/jqsP+09wJBmOCm7pWIkqdSRmQSXiNBIDA+80yXQzmruVexqeRxdGcJctX5M1g6fyIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6717
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some small nit:
ufshcd_scsi_{block,unblock}_requests are no longer using scsi_block_request=
s,
so maybe just omit the _scsi_ part of the name.

I think that you can add Bean's tested-by to this patch as well, because cl=
ock-scaling
Is happening all the time, in oppose to, e.g. task management, which is, on=
 some
Platforms, hard to reproduced.

Thanks,
Avri

>=20
>=20
> Scaling the clock is only safe while no commands are in progress. Use
> blk_mq_{un,}freeze_queue() to block submission of new commands and to wai=
t
> for ongoing commands to complete.
>=20
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 134 ++++++++++++--------------------------
>  drivers/scsi/ufs/ufshcd.h |   3 -
>  2 files changed, 43 insertions(+), 94 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 2c6300fd5c75..d1912ba5d2d9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -292,14 +292,49 @@ static inline void ufshcd_disable_irq(struct ufs_hb=
a
> *hba)
>=20
>  static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)  {
> -       if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
> -               scsi_unblock_requests(hba->host);
> +       struct scsi_device *sdev;
> +
> +       blk_mq_unfreeze_queue(hba->tmf_queue);
> +       blk_mq_unfreeze_queue(hba->cmd_queue);
> +       shost_for_each_device(sdev, hba->host)
> +               blk_mq_unfreeze_queue(sdev->request_queue);
>  }
>=20
> -static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
> +static int ufshcd_scsi_block_requests(struct ufs_hba *hba,
> +                                     unsigned long timeout)
>  {
> -       if (atomic_inc_return(&hba->scsi_block_reqs_cnt) =3D=3D 1)
> -               scsi_block_requests(hba->host);
> +       struct scsi_device *sdev;
> +       unsigned long deadline =3D jiffies + timeout;
> +
> +       if (timeout =3D=3D ULONG_MAX) {
> +               shost_for_each_device(sdev, hba->host)
> +                       blk_mq_freeze_queue(sdev->request_queue);
> +               blk_mq_freeze_queue(hba->cmd_queue);
> +               blk_mq_freeze_queue(hba->tmf_queue);
> +               return 0;
> +       }
> +
> +       shost_for_each_device(sdev, hba->host)
> +               blk_freeze_queue_start(sdev->request_queue);
> +       blk_freeze_queue_start(hba->cmd_queue);
> +       blk_freeze_queue_start(hba->tmf_queue);
> +       shost_for_each_device(sdev, hba->host) {
> +               if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
> +                               max_t(long, 0, deadline - jiffies)) <=3D =
0) {
> +                       goto err;
> +               }
> +       }
> +       if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
> +                               max_t(long, 0, deadline - jiffies)) <=3D =
0)
> +               goto err;
> +       if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
> +                               max_t(long, 0, deadline - jiffies)) <=3D =
0)
> +               goto err;
> +       return 0;
> +
> +err:
> +       ufshcd_scsi_unblock_requests(hba);
> +       return -ETIMEDOUT;
>  }
>=20
>  static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int =
tag,
> @@ -971,65 +1006,6 @@ static bool
> ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>         return false;
>  }
>=20
> -static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
> -                                       u64 wait_timeout_us)
> -{
> -       unsigned long flags;
> -       int ret =3D 0;
> -       u32 tm_doorbell;
> -       u32 tr_doorbell;
> -       bool timeout =3D false, do_last_check =3D false;
> -       ktime_t start;
> -
> -       ufshcd_hold(hba, false);
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> -       /*
> -        * Wait for all the outstanding tasks/transfer requests.
> -        * Verify by checking the doorbell registers are clear.
> -        */
> -       start =3D ktime_get();
> -       do {
> -               if (hba->ufshcd_state !=3D UFSHCD_STATE_OPERATIONAL) {
> -                       ret =3D -EBUSY;
> -                       goto out;
> -               }
> -
> -               tm_doorbell =3D ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_B=
ELL);
> -               tr_doorbell =3D ufshcd_readl(hba,
> REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -               if (!tm_doorbell && !tr_doorbell) {
> -                       timeout =3D false;
> -                       break;
> -               } else if (do_last_check) {
> -                       break;
> -               }
> -
> -               spin_unlock_irqrestore(hba->host->host_lock, flags);
> -               schedule();
> -               if (ktime_to_us(ktime_sub(ktime_get(), start)) >
> -                   wait_timeout_us) {
> -                       timeout =3D true;
> -                       /*
> -                        * We might have scheduled out for long time so m=
ake
> -                        * sure to check if doorbells are cleared by this=
 time
> -                        * or not.
> -                        */
> -                       do_last_check =3D true;
> -               }
> -               spin_lock_irqsave(hba->host->host_lock, flags);
> -       } while (tm_doorbell || tr_doorbell);
> -
> -       if (timeout) {
> -               dev_err(hba->dev,
> -                       "%s: timedout waiting for doorbell to clear (tm=
=3D0x%x, tr=3D0x%x)\n",
> -                       __func__, tm_doorbell, tr_doorbell);
> -               ret =3D -EBUSY;
> -       }
> -out:
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       ufshcd_release(hba);
> -       return ret;
> -}
> -
>  /**
>   * ufshcd_scale_gear - scale up/down UFS gear
>   * @hba: per adapter instance
> @@ -1079,26 +1055,15 @@ static int ufshcd_scale_gear(struct ufs_hba *hba,
> bool scale_up)
>=20
>  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)  {
> -       #define DOORBELL_CLR_TOUT_US            (1000 * 1000) /* 1 sec */
> -       int ret =3D 0;
>         /*
>          * make sure that there are no outstanding requests when
>          * clock scaling is in progress
>          */
> -       ufshcd_scsi_block_requests(hba);
> -       down_write(&hba->clk_scaling_lock);
> -       if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> -               ret =3D -EBUSY;
> -               up_write(&hba->clk_scaling_lock);
> -               ufshcd_scsi_unblock_requests(hba);
> -       }
> -
> -       return ret;
> +       return ufshcd_scsi_block_requests(hba, HZ);
>  }
>=20
>  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)  {
> -       up_write(&hba->clk_scaling_lock);
>         ufshcd_scsi_unblock_requests(hba);
>  }
>=20
> @@ -1528,7 +1493,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>                  */
>                 /* fallthrough */
>         case CLKS_OFF:
> -               ufshcd_scsi_block_requests(hba);
> +               ufshcd_scsi_block_requests(hba, ULONG_MAX);
>                 hba->clk_gating.state =3D REQ_CLKS_ON;
>                 trace_ufshcd_clk_gating(dev_name(hba->dev),
>                                         hba->clk_gating.state); @@ -2395,=
9 +2360,6 @@ static
> int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>                 BUG();
>         }
>=20
> -       if (!down_read_trylock(&hba->clk_scaling_lock))
> -               return SCSI_MLQUEUE_HOST_BUSY;
> -
>         spin_lock_irqsave(hba->host->host_lock, flags);
>         switch (hba->ufshcd_state) {
>         case UFSHCD_STATE_OPERATIONAL:
> @@ -2462,7 +2424,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  out_unlock:
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>  out:
> -       up_read(&hba->clk_scaling_lock);
>         return err;
>  }
>=20
> @@ -2616,8 +2577,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>         struct completion wait;
>         unsigned long flags;
>=20
> -       down_read(&hba->clk_scaling_lock);
> -
>         /*
>          * Get free slot, sleep if slots are unavailable.
>          * Even though we use wait_event() which sleeps indefinitely, @@ =
-2652,7
> +2611,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>=20
>  out_put_tag:
>         blk_put_request(req);
> -       up_read(&hba->clk_scaling_lock);
>         return err;
>  }
>=20
> @@ -5451,7 +5409,7 @@ static void ufshcd_check_errors(struct ufs_hba
> *hba)
>                 /* handle fatal errors only when link is functional */
>                 if (hba->ufshcd_state =3D=3D UFSHCD_STATE_OPERATIONAL) {
>                         /* block commands from scsi mid-layer */
> -                       ufshcd_scsi_block_requests(hba);
> +                       ufshcd_scsi_block_requests(hba, ULONG_MAX);
>=20
>                         hba->ufshcd_state =3D UFSHCD_STATE_EH_SCHEDULED;
>=20
> @@ -5757,8 +5715,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>         unsigned long flags;
>         u32 upiu_flags;
>=20
> -       down_read(&hba->clk_scaling_lock);
> -
>         req =3D blk_get_request(q, REQ_OP_DRV_OUT, 0);
>         if (IS_ERR(req))
>                 return PTR_ERR(req);
> @@ -5838,7 +5794,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>         }
>=20
>         blk_put_request(req);
> -       up_read(&hba->clk_scaling_lock);
>         return err;
>  }
>=20
> @@ -8307,8 +8262,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>         /* Initialize mutex for device management commands */
>         mutex_init(&hba->dev_cmd.lock);
>=20
> -       init_rwsem(&hba->clk_scaling_lock);
> -
>         ufshcd_init_clk_gating(hba);
>=20
>         ufshcd_init_clk_scaling(hba);
> @@ -8394,7 +8347,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem
> *mmio_base, unsigned int irq)
>=20
>         /* Hold auto suspend until async scan completes */
>         pm_runtime_get_sync(dev);
> -       atomic_set(&hba->scsi_block_reqs_cnt, 0);
>         /*
>          * We are assuming that device wasn't put in sleep/power-down
>          * state exclusively during the boot stage before kernel.
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> 6e0b87e8f875..cea71057fa90 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -517,7 +517,6 @@ struct ufs_stats {
>   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level f=
or
>   *  device is known or not.
> - * @scsi_block_reqs_cnt: reference counting for scsi block requests
>   */
>  struct ufs_hba {
>         void __iomem *mmio_base;
> @@ -721,9 +720,7 @@ struct ufs_hba {
>         enum bkops_status urgent_bkops_lvl;
>         bool is_urgent_bkops_lvl_checked;
>=20
> -       struct rw_semaphore clk_scaling_lock;
>         struct ufs_desc_size desc_size;
> -       atomic_t scsi_block_reqs_cnt;
>=20
>         struct device           bsg_dev;
>         struct request_queue    *bsg_queue;
> --
> 2.24.0.rc1.363.gb1bccd3e3d-goog

