Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D823C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 07:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55B4520835
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 07:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YNyKvmHG";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rHIxeSRP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgFJHQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 03:16:35 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3838 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgFJHQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 03:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1591773394; x=1623309394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sHcFTewgvSzoYGhbh8TFpSO5IAs00x0ZxL7bd75hvAc=;
  b=YNyKvmHGOjyJJHUTSZvezK8TxzXyn+Lu6uZIZqWNMGoqIvcmoD/vgMpb
   38X5+Gv7b+z/NE1QSr+6qv0ZhMWAi2FQZCMihWWWtr3ZeKswUqpUOG6rj
   da/hl9OeWUghHBFEym779a3zLL5CrBFknJjYxVhJbZU7edfj1fVSs6TOO
   mJLgIXCHHUq6LGzjw8lLBBswlawsiNNEZYdxXXs1QiGIWbhB8HlaVCkj+
   hpbNjV11lsBdeyGKHzH7qn/7njt5R044ooY/MUM5xrQuxgfcBhQwczgBH
   5R3ZdJBY2rIexnBSJ6uQpfFEvvQP6ZrnJGNxy10euoJqSsfYHxs9+iQbv
   Q==;
IronPort-SDR: rllLeGfDrujFXpTuS/nn3TJFIhmvXpZsJuedEUMPH9eYqpfr/Dv4ij4p0ZhYfTXjVt7kbP5VuR
 jZ+re8MzWnuYoQrVu3+l43CpUWyPcnOQGQTgGg37re2SDd0gqGX58MKn/pY43p3Bnc4zMxz32X
 gJzRZN4v2QKEk5iNTUaNFOh9S8ORu3p+GPuqrV5Vz7HHj0jNTxIzRURqlbAv3Z71YiP2u0xiy6
 dgnNhqF3iUlWcSW3OlMPGImPM/nlPeMktqJFm6DL0/6Kvr0/SGkMU8MzMOvKoVNVXu1ugSKNPt
 NEI=
X-IronPort-AV: E=Sophos;i="5.73,495,1583164800"; 
   d="scan'208";a="141028445"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2020 15:16:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oK4uulboYy5rUxsI9/DWWF1keFgBS5yewj5D53tD1CVbDSD+hbCSNKTiBThMjeGPfXbvFbL9Z4FO3OWjP0nyru++lRjLe5Rq7StQy905KUVaYOxgs9OUd8YH3BymwtARyCM1TcVwzwhWpHYqRFNmz6hxo4s6wAY0O0fVOEK2aKQN8GiKX3ranfgCCWTG16RE/y15z0N/vGRBv1RmiM6Fz7BMHZOLEOkpJQB4tOrtObeLQj9EsnFB++0V7yq2CQdRRAQKFiE+1XxTe7QI8U4XEbQVzd0oox4OJktiQiCX6k1TkqZLJ4kHFrV06AQ9xwa/MrMRhfs4BepGGum4Inp5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAFPXcS5ofoxT8E3UMYeNkP4z5Q0dYk+7F44su0mSY4=;
 b=F9Gx3cD3DI64uKq6kXiU7yzcCMVIg6UZoWr+EYHNqHmlFl/KnCjaJEIrNGHhoNaMg0y+Lfoz0mlA40L/3fSdO2ZgtM8M3vqMFYuCCBoyMbbI8NU7RhJBBg/JZ7/v+t4vC/b0g6naqRAlklEE100WGaUnJ6yiiaWy27+2KaBa5Lx1YFAzMVD4jCXtB8wBgxWqUfiHX3KA2J8Ui38B+9R/safne1tEFdl7RtYeMOx2hAap0wMP3HJbGFgM2xW3fPoG37WmdHGCVQcJGnHauv6C9iznqAJmxfBc7c1nDqHWXyJYp6/CjKj/MoChCRqUYEUVSgi1jr4k8FWY82FfaORykg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAFPXcS5ofoxT8E3UMYeNkP4z5Q0dYk+7F44su0mSY4=;
 b=rHIxeSRPCc5IVvAkFCfI9KkGNzRYCRDz/xhGaO4qXNyf9+QPPuhp2dgolpvPertAhnA2PMb7S9DVgSfafHEEFcBiONT0IeD1WJFSG6QxhcTfqp4XRIfGMH/HjTGyiRyMGjHh0GLiASIN3Ox3jIAWO/bJLFOuoPioxWoYS3qlou8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4400.namprd04.prod.outlook.com (2603:10b6:805:39::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 10 Jun
 2020 07:16:32 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3088.018; Wed, 10 Jun 2020
 07:16:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "kjlu@umn.edu" <kjlu@umn.edu>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>
Subject: RE: [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on error
Thread-Topic: [PATCH] scsi: ufs-bsg: Fix runtime PM imbalance on error
Thread-Index: AQHWPsyO1tMSQcTvHEyUblbEcRc526jRb/8Q
Date:   Wed, 10 Jun 2020 07:16:31 +0000
Message-ID: <SN6PR04MB464040E5275E7F5C28CFB9E9FC830@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200522045932.31795-1-dinghao.liu@zju.edu.cn>
 <yq1k10fsmaj.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1k10fsmaj.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54beff7a-faa4-4992-fd07-08d80d0e33c5
x-ms-traffictypediagnostic: SN6PR04MB4400:
x-microsoft-antispam-prvs: <SN6PR04MB4400427759B785B34752C9E9FC830@SN6PR04MB4400.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0430FA5CB7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zfbMVJpZrSYtC24wKSEs6HhbLoRuh4DXE/PtBi7BnUMvHR2WXvfvMABySvRy7um9CUzsGgHxsyEBeUD7+tnqg/uyO7r6v/TWZmHFkOfjAXxGSoM+oMgquFMZUGp1cGm0liGKfzo1F0nHPJ4byP+9WQJ8hTfPqzEgsicNt2CmXca5QJyAT54jQ+FGYOlKPlkHrpWREd2FEYtesO//H5wmMrjnrmgmCiezZ2021FO70BT/N7OqrwAFuBLdjI2/1twQl6WdS9uwzoeUSdQk9ZD6+9D80EpBPnawAJrRvAPTpM3cePh/pPb7RJXRF0dyW717
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(71200400001)(66556008)(76116006)(186003)(2906002)(54906003)(6506007)(5660300002)(9686003)(316002)(26005)(66476007)(66946007)(55016002)(66446008)(6916009)(52536014)(64756008)(478600001)(8676002)(4326008)(83380400001)(86362001)(8936002)(7696005)(7416002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ZhdHKjrwygb8oUAdnZlm3n3zCVChIdPjkUh5mOeMnkpXyp+x27nAVItngdNi45dXlZ/lKBKBF0Gn9qGqi7H7R0FWAWN64sr27qsDEYLtyIhkhsbil/BvConh1OyJKOBvmp1GFTXFWRwqThJPVkCglI0zo2bKCnWwtR+ZqonZa6pGVmJE2X/3MfCqbrVzAEjXWsbz55+AYcVx8mbUsHO2qhLaJvROo6F+ApLDGEj4fBuBQEwCLKL7up1X+RTZwxusLXMIaR6CQfcPJtnHFWV3zuixuqihsKi9dkbKVs0OIZpqlGkAGhjTxs70WdeRAYfWSs3DznaVFT+D6UdVD7foFUI2Z+adneBFtnyahM4kGFV1yxC/Na0Epm8Ml25nEE5CkHxNapfJOoQIw+XfakG00VZb6E4ZkPwhVlrFM9aL/94Iuc/EJJQO7M+YM2Nl8HCKWdPo4J1/oftM/i4OKDSpPM8XnzOWs3uQKe5MnmXx17w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54beff7a-faa4-4992-fd07-08d80d0e33c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2020 07:16:31.9863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LTaJgzcYCY0IVh8AQJT4YSRQjBNcc/jaFPmAk20mwAkbdXv7CK9dcmC8mOQvLBKdPC4ScWAOkDS3zr6yPCua2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4400
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
=20
> Avri: Please review!
>=20
> > When ufs_bsg_alloc_desc_buffer() returns an error code,
> > a pairing runtime PM usage counter decrement is needed
> > to keep the counter balanced.
> >
> > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Please add:
Fixes: 74e5e468b664 (scsi: ufs-bsg: Wake the device before sending raw upiu=
 commands)

Reviewed-by: Avri Altman <avri.altman@wdc.com>

Thanks,
Avri

> > ---
> >  drivers/scsi/ufs/ufs_bsg.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
> > index 53dd87628cbe..516a7f573942 100644
> > --- a/drivers/scsi/ufs/ufs_bsg.c
> > +++ b/drivers/scsi/ufs/ufs_bsg.c
> > @@ -106,8 +106,10 @@ static int ufs_bsg_request(struct bsg_job *job)
> >               desc_op =3D bsg_request->upiu_req.qr.opcode;
> >               ret =3D ufs_bsg_alloc_desc_buffer(hba, job, &desc_buff,
> >                                               &desc_len, desc_op);
> > -             if (ret)
> > +             if (ret) {
> > +                     pm_runtime_put_sync(hba->dev);
> >                       goto out;
> > +             }
> >
> >               /* fall through */
> >       case UPIU_TRANSACTION_NOP_OUT:
>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
