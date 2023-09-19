Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3EFCE79A8
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 18:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjISShQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 14:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjISShP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 14:37:15 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552CA9D
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 11:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695148630; x=1726684630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BzbgwDP4DWzh6+hDOSTV3ni6iWG8i6VNBDzHaw1AFbU=;
  b=BpHtO//P4j+n08EocAIjZKjJU6+iM8kDvUQwTSShtUQDkja9HWBZhPg+
   X+nE6d/wcXkqza4w8BChcM/SAfwmC7EeLEa6P/I2rLkliHWS0RH2iFV+o
   WsJ/sFjusk/uIX8dbD6T1mbm+aejJTMnbl/JFAMUhxM/Wj+yCxej5kcXJ
   aLWf0Y3mHEwx7IPB8Kkza60cCY2XmAfB2WhreRz7We0IQ7gHBpNBA1GTP
   y54eSJYXfzrwL4eKNp41NWTgSoUKmaG0Cc/d90Zho+6VgNHhjXYfpgje6
   5BFph6AE44w3MyUAtmDecIo5k4LCZ8gwDstWmL7V0t5l5TQ7gNi5A10LL
   A==;
X-CSE-ConnectionGUID: LLi1qFdrTKacwq/rlAfJeQ==
X-CSE-MsgGUID: 6Lka5DWZSbeAn0TjPQLFdA==
X-IronPort-AV: E=Sophos;i="6.02,160,1688400000"; 
   d="scan'208";a="248860295"
Received: from mail-bn1nam02lp2047.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.47])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2023 02:37:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBvTCP0lDJOiY+ydhuyrboa5z2OSK3lXpbFWns+S7LW5+/j0LJW7D86P6oMqbQNnqRqLwrZdKzJYTFs5HkEvkrb5JenA97Kee8CG9UAm0B0EDC+8MXxhJ9lI+zoTBf8hCSnCmc7t7pXGSQbBxr0FP8SMq4+4ob/VKnu4pmqG1Bsc5dgV44Z0h3hpsuIwJWzU8pPbRVn1QEZHCi9qh1N8J+4igMXckFH5DUefiWU0xkU6O0pRyRDewHJT0KNZ+keWPkfVYJgYSE2twiENm+WAfCUbYbChMrPB/pBKyU8ZL87MZlwHCW0/kxPO082yePzc2qcCMEJfv6SmEgL5KpthvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zYS6pymfwxtYj7xLrgnRgNm1fcQT+n3nd02uH63mfVc=;
 b=bm9Ikc95LRo9rY19ipY9wv9ROEbAks+GrhcOhOkPcaPYyuObKa5ahAHBXjBtzGTw8NAjMPgNudAhCurl+hRuDWpzX23vBSEvZj/B5CxRtcHeTBXD2BoFjtnegL3TVmAWhfyk4rHrrsOlsaQ4rkPxs980QgNDapDHs+jroi0gvpcxpeDdreirpbpG3hTvIJvzmaXDxhF+BbdaKXCgMn47CxLaYTKfEjIGJWSQuwzXNOd1q22BTmHEs/1/CGmFPqqULEtiXh9Sf41WHQwwl+0HYY7Syu/t/BBDjUSEWHtUjBAvIdPSluPRosfDNQW17mGv6Qf986VHjyTszRpQfYxxZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zYS6pymfwxtYj7xLrgnRgNm1fcQT+n3nd02uH63mfVc=;
 b=LFzxUsZDqhOMfUiBgpg5qpzianc9jnrWasA04JJ8SBYsrU/vIE7NFOVVNoDvRzoDdKwE68rgZx5f1hGLRz6ZoNH++Bkj09VsPtjl0Z38ubBZKra0lOTY/+yYFqV2odBZs8eIZPnd0STZI0qEOZ38ORmKXBLY6VXS6aKjrgcpTxw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB6438.namprd04.prod.outlook.com (2603:10b6:a03:1f2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.15; Tue, 19 Sep
 2023 18:37:03 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8e15:c9a8:1531:8fbe%3]) with mapi id 15.20.6813.013; Tue, 19 Sep 2023
 18:37:03 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: RE: [PATCH 4/4] scsi: ufs: Set the Command Priority (CP) flag for RT
 requests
Thread-Topic: [PATCH 4/4] scsi: ufs: Set the Command Priority (CP) flag for RT
 requests
Thread-Index: AQHZ6kxB4hKhfxUSakWzTD2zk1glGrAiewxw
Date:   Tue, 19 Sep 2023 18:37:03 +0000
Message-ID: <DM6PR04MB6575255764CC491B595F86BCFCFAA@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230918162058.1562033-1-bvanassche@acm.org>
 <20230918162058.1562033-5-bvanassche@acm.org>
In-Reply-To: <20230918162058.1562033-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|BY5PR04MB6438:EE_
x-ms-office365-filtering-correlation-id: 80712347-6ea2-4450-a883-08dbb93f6aee
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rHWva+vCDoXFGZJ52NC+2X+zqjxNlUxHCcfwX1Tl8JsXsJ2rbwrV6Ccm6pc2BXVEE2QSh8NTS1vz12mKcEZ9IwlXQT1hUCvX5kQKyrewOFIJ/1/SjacaxXjNdKd6UmGCYUuHU45VI8rjKxolilvOlz7d6dFEjBI9lLbSdD3Vwr3dJ5SV1C3PrZVE8dviVTshXxttAtYu19M5XW8HkrS9Ms0QN5V+wyviUT5IJMAr2JUruEOX2Y6bi6ZTQwkVyxFgakDCYPx1qa7VApzu9PEhwlcNweG9j2F9izdSi7xbVeE+i0xnbAtVaVIoqe2r2IEe58u/z/eAroXvaXEKfqt5s5gHDekGBSuJ1IiFSvdEOFx/tOX8T0TfE91uUxGPEDZG/d+dfIaeWyuwbvWq3NetPT+USJillEFH1j4tgXg7SVpcEdSPjaNAOLRtygyckj/rTWrO2lPb7Vj17RsV0IdPAIMplLxyj9Ho9jLk/B0DsTfmKLLY0y1eLQENeIiyqIyaoDwZMv6zMEtTtkfKFKw+eNj6aXbJdOSMXHF2AOD6IW87mZccnOVo1mQ+FI99CwYQnaYyTopTYYGOSQpF8P/vdxJGa3uYatKjuDsYe+RJy198G0ZuyHN8LJmHR2Ztze2l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(366004)(396003)(186009)(1800799009)(451199024)(7696005)(6506007)(478600001)(9686003)(8936002)(54906003)(26005)(71200400001)(2906002)(66476007)(316002)(66946007)(76116006)(66446008)(7416002)(66556008)(64756008)(110136005)(5660300002)(41300700001)(4326008)(8676002)(55016003)(33656002)(82960400001)(38070700005)(86362001)(38100700002)(122000001)(83380400001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iLA1DdEIIeqswecbf05C74CKkDZFSMRNIDVZH9xuQUomlsYd8aDxkWOYxyFL?=
 =?us-ascii?Q?8P6Y8n8xuCCRN/UUi3s7MLqctScVJRu4N77MJa7v1jqqdZ+j+fvkF6f0fBUf?=
 =?us-ascii?Q?aTfediuxs0oK5GqPQ5soP7Si1U4X/XHdgMl/m42QF1YIsYP84WKTjonJp5Oc?=
 =?us-ascii?Q?CJk2TtVn39OHMWEzH8ms/z9G6akPLDHHbcqk6/42wyNtVXAutuUBuP/4s91W?=
 =?us-ascii?Q?A9Log8hB/9dXLufWky9LCEuCzPNuqpCH31DReun0JA6ullRKxb+iXpxnySsc?=
 =?us-ascii?Q?WjjkuP00eW7WZLGumaCwJNF6PI9LYKhKdI4+O0C9siD9gy1S9j6XdvyY9KPj?=
 =?us-ascii?Q?nalZcGnfDs9TS4gBWJKug+9gZv7C9fGAOsEvOJZeY3pFPHqxRIwa/KgZBfAh?=
 =?us-ascii?Q?yhsKxXJPWRSIkO7SARDfZA+K0fEKkVzg+Xl3dQkj1ei8l3wothy89fSRLJbF?=
 =?us-ascii?Q?QKCI/lF8dqq3q1yweN9gGD0rmAddRFzyRpLN/fD59qWk1HtHP15kAKDf9lYI?=
 =?us-ascii?Q?T9UTPCPSVHcaglDlwBQ6rvkoZefvcRoV2Xj4VXdYTpHJ14uTN5k9ytYh8kcI?=
 =?us-ascii?Q?QesaAWFJh0YeeIwa7Y/DaF/+afibMOh9ITP8ct/f8TtT7XmSt9r6vWYxgqId?=
 =?us-ascii?Q?HL2z7uCPeYjPU14XPQn3qUEKE+hQw7L3hBtzKdzld2IiExgJwMM8C3eFTfae?=
 =?us-ascii?Q?Ch3wYICYFVYkHBc/P8+G5wc6DJQM3Hx0acU+T7ifyaqpRbAP227iMjkVwuJa?=
 =?us-ascii?Q?QzLIwTGJL8c4UdA0rSr756/YMQ6iykCy2wZ3c/O+PgXwPDfFvlDffTwkvc/Z?=
 =?us-ascii?Q?UaIKB2F/kDDA7qkJmgXWAmBzg8Vt2UPOLY07cH10LJjurAKnDQJuAvk9SxUu?=
 =?us-ascii?Q?JKqIvnvwzT6gt5yastin5VKpp7f6MKled1z4dMQJk6lO8FkZ/zbO76m3Jiec?=
 =?us-ascii?Q?E/UrsLEZoxbnHd2PN9Oc7wPfAZ7zwQNPTzT7YyG5XANPwsP6RSP3nF+8wmUA?=
 =?us-ascii?Q?azuXqez0hipPRIZ5VzO43HfPxcT8Y9WibQdYdAarkpne9pCXtiL/3qHy/hW9?=
 =?us-ascii?Q?CZ6+gkF9kgMM7OcKsrrgIPJUzHEFMc2STmJULmpSLMqP4FbZRsTyo6iWV0jP?=
 =?us-ascii?Q?EuHVBH6WobaFDCAVTSNuK7grxL2UPJoqCboxWv4t9CgANo9oW4nhnCmiqlH3?=
 =?us-ascii?Q?6ZGZJB6tEE9xY6Y4GpkcYGIyVgl7d76kYFelec27r/2rfBKgVn/REj9RkRhv?=
 =?us-ascii?Q?5hoUDDx9dfMdwOmPfwgL9ODCypj5eMBTugFP5/C1IOzUX5pWElB180nMPwnT?=
 =?us-ascii?Q?TQZFjRC9cmBOKrbTnM7+PeJ54G8XrWiTao/B8qfv01rbpyCj1oKB3snD2pv3?=
 =?us-ascii?Q?AaXclAS9pdSkMiGNKi1PISYpvacJg4hbFHkmuwVFOuU07inqHWvOCH+A4/pN?=
 =?us-ascii?Q?cLt9o4eWdgn+snVWTnSAjpMoeOT+sKTyxOqkbq0dz7PX2FE45Y74QKGlyBxz?=
 =?us-ascii?Q?kqOzI3IHIj9xh26f0FflyG/k3MnZHK2dsyQFMtn4XjC1htwY2AZLS1qVfyoO?=
 =?us-ascii?Q?6NHePfeYH07V4AuXRH5dbdEoo2Q/GIgYZOFzjedr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?nNTiLvXY1pMTDN/CkXc7xnfmbVu+17dE76CuKacQmjY0KycOotzIzsnl87uG?=
 =?us-ascii?Q?e4Q1mKey9lUADZvl4hJV8V9tGFh6+raDc/Hl9CCNseAtJKBE9gNLJtbBcpFw?=
 =?us-ascii?Q?j9KdCah6EczB+JgIWVR2nsZxbUK/afnpGKFAslND+ts8Gl1owQqr8aZbSt/K?=
 =?us-ascii?Q?pIWTW18fyz/3j+wxd6VDC5V2SbH/JMP7FB4refClZO7uq1cFtJwgl2jygub5?=
 =?us-ascii?Q?BSDhcB8YbN9NYywLnwY87P4Kjj0x77OUwcQarzB6xLrYC8jcfBaw4ktr96SL?=
 =?us-ascii?Q?MPMsl1fJOyrP6DPD9V7g8rqdgQ/VYFcyrbP9m5lFjpVaF1icTAcBSm+Ds74L?=
 =?us-ascii?Q?pxsfUojTjmq/hMsz7HcpRugE+Mk5vChz2JJKaWvd6QsQMTKsYEu0AYvpnbfj?=
 =?us-ascii?Q?3Qm6t7f6CWAWHgQXpiYUBBo8zHYNTsLsfSZs2oOX61t0hu4OUbfkQ+quCQBi?=
 =?us-ascii?Q?5tYRuYQQpStfTHvsKoAEhiKd50HhZxgxymoqL9qyQ8ACRbn2GQEj+gMZSYg2?=
 =?us-ascii?Q?HyIeJcEWsMjbrvAnmrrBvVT1ZGnonbtgwGR/V54cgwDSPnPH8BH2oZtemlW2?=
 =?us-ascii?Q?Ej4ILjQo9xvyPucvCKnz73JQGwPlqCDyOZFS7QmCqRZjeCb9B+Yoe1TnwUON?=
 =?us-ascii?Q?G7eUfBgE7CRjsvQXm4wmyTzYnT8zGVBGv8eaSUnS5wHZI9gGO7in2tOEQ9IK?=
 =?us-ascii?Q?YUA0OJ1KEgayrEDk6H/ihwCEkNvxPmZH0DJaj0AsR0pCjhmPX82kOZ1hcbUe?=
 =?us-ascii?Q?ojqj7eBTZCgBKx1vaKG/6jKwHMibvn2PDVsPkvorpTH8aElXWK+OAn0WL0zi?=
 =?us-ascii?Q?LmoQpthpvNvFEXL8UF8NeZP776oaKVV8t3zeyBJRsuGtyOuIb1Ei1PW151NC?=
 =?us-ascii?Q?M4cW7UXfiW1vFhSZqYTUjaTZfroRFBoEXddMmhUwu6npouw+Mc+flYOcV8Ra?=
 =?us-ascii?Q?sxgortNZXQ5vPKMnYTcTgqZ8SQRhOy8yL9zxx6EczDRLbYEUyiUxdizfjuJJ?=
 =?us-ascii?Q?R62x?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80712347-6ea2-4450-a883-08dbb93f6aee
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 18:37:03.1053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wzXMNPEEsd6npAvGLS+ranKnYXhBbuZJB1wzAp69bpbaxFA6v1jOmuvuwwITJRIivMnTiiqWc2Cc4XZ1QTEEIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6438
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Make the UFS device execute realtime (RT) requests before other requests.
> This will be used in Android to reduce the I/O latency of the foreground
> app.
Maybe one more sentence, explaining that ufs CP is agnostic to scsi CDL,
And can be implemented regardless.

Thanks,
Avri
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 4 ++++
>  include/ufs/ufs.h         | 3 ++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c69bf532c4ab..54c3811d5534 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2717,6 +2717,8 @@ static int ufshcd_compose_devman_upiu(struct
> ufs_hba *hba,
>   */
>  static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb
> *lrbp)
>  {
> +       struct request *rq =3D scsi_cmd_to_rq(lrbp->cmd);
> +       unsigned int ioprio_class =3D IOPRIO_PRIO_CLASS(req_get_ioprio(rq=
));
>         u8 upiu_flags;
>=20
>         if (hba->ufs_version <=3D ufshci_version(1, 1))
> @@ -2726,6 +2728,8 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba
> *hba, struct ufshcd_lrb *lrbp)
>=20
>         ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
>                                     lrbp->cmd->sc_data_direction, 0);
> +       if (ioprio_class =3D=3D IOPRIO_CLASS_RT)
> +               upiu_flags |=3D UPIU_CMD_FLAGS_CP;
>         ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
>  }
>=20
> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
> index 0cced88f4531..e77ab1786856 100644
> --- a/include/ufs/ufs.h
> +++ b/include/ufs/ufs.h
> @@ -98,9 +98,10 @@ enum upiu_response_transaction {
>         UPIU_TRANSACTION_REJECT_UPIU    =3D 0x3F,
>  };
>=20
> -/* UPIU Read/Write flags */
> +/* UPIU Read/Write flags. See also table "UPIU Flags" in the UFS standar=
d.
> */
>  enum {
>         UPIU_CMD_FLAGS_NONE     =3D 0x00,
> +       UPIU_CMD_FLAGS_CP       =3D 0x04,
>         UPIU_CMD_FLAGS_WRITE    =3D 0x20,
>         UPIU_CMD_FLAGS_READ     =3D 0x40,
>  };
