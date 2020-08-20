Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2CCC433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 06:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49F2207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 06:24:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VGAiJnz/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JZiEV2R2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgHTGYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 02:24:23 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45333 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgHTGYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 02:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597904662; x=1629440662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eDYEYJzZNhBFU6gAbCo8Ma5k2H7ZUhzQ/OvxNrJDVls=;
  b=VGAiJnz/paoXFIhcowH+WxGEAkZc02J1CMF241PjUoBAS7rTeNeekGPj
   x116qcTEfxLdrW+jKUpcoqYHppxM7NWYigeOK/Ho4udXMEAd/Epr+dGMA
   OocSKMrLpE/yQcKYnoI7qt4l2ecbPV2wxwTRx7wNaB6Cw7Q8jWRvN7hRK
   WAL1eBsCSB5J612EIllxMZD7UHO/ZSNjDuIN0z62hCCjwTmKy0ZU6a348
   10NLIyXIetSAcbxlceIPlg+wCQpRGPZkz1EP8jIUpfTqLIOP83r/y7O9K
   Jj7V+vq0LmxEs5yF0XCVCS1ODFEicvKBE2UERWhZm4VReR98SJrpu7wiz
   w==;
IronPort-SDR: lUjythBlDJ9wJ6dwr4pVOI0sYozguO2us9AOWRu9YJoItKJkqtneKs11xnXPOqVgVIcoeqt8kB
 gnckW1rpzRwWsCGMIsyG6NLCDn5P8YliR4OrgPkNYjf5o/ZlawkgjkoO0yeoZurZHRbW0WgkHe
 beL3Ne1/7eIHLoP/b82jPY40rPCGUhVImi1yx9hYV9Jn6DgUWfB+4lMlMoXHhKS5IBAjLoGq0q
 joZwB0yPC07g9cfyjXXhagXQ4OwHrFjHaq3b0Ib9kV1q3hQQte5cT862GDi1hJGhpy0g6OLPjf
 rtA=
X-IronPort-AV: E=Sophos;i="5.76,332,1592841600"; 
   d="scan'208";a="145399888"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2020 14:24:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKCose5z/8hD3vtAAEljHORCV+UIu/ntOoR2eNuAi3ZAZTnOgINbazxr/I8GjEBhx1ENL2ocL62mB7MndAy53PcnlLwk6hB00xcNJIh7jiKKnGI5fDwBu99vUeEy0AnvVosV1uzQ1tw3eYK4oLbYcdzAFd1XpsTxJZaK2kDZpL95+Dq6eKl5H9ijU4tJC2bx/yIG/gcsWid11DsPbeWpSi+YmBIw/eYudfN14FuIwgDT/5fKbNzX+yjkNhQ6ncQL/jQKAaDdYT4u6w4kSw9IxJ3usxKT1PWgjp2Ymr6ZIhjCl4FN9psJsfAJTHbdD9qpsqFGeMxD8As+Yq2qQDuc3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m61lVYb36l91KlL1tDDJ+CHnyRlJ44a//Q3eNdpQMbE=;
 b=XvmoPQfbt9CwpbAMVSfkCHFnowHSLzNdXoLjdO36K+2mZMivths+qsrfFRqgUdvblUdzuZ71gC1bClfKYgEDsZe1RfO7bAOR3jp+LJo7N6CLiMCyXxI8/KVHxEBuuPrw+kJXheS1/bnVWsIjmEo8TNXkWrAtdmOz0yyI2BDARi3FcaY7ZS2y+LpYcIvzoruM4UGnbcoNYwdtCYPBdd/1iP5n5fFWv7zNAwGi3oNaZo6CWgCmCgvUfOCir/fEQjUjigxNDZfDDXNad6AkPnepJwggghesjqwQtm/S3R0W7gXKYaAjifVgbbPl3XlbIgKtiW/iah0mLwTdvs/ExlrIdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m61lVYb36l91KlL1tDDJ+CHnyRlJ44a//Q3eNdpQMbE=;
 b=JZiEV2R2tZ+qsu6zUc5E+5od21b397UwMDgMDXojgp4rjFo0+i0uxGA+zq2aXYkKml8T1knwMBecbZmRHrct//vJpvrL8S+0apJxuI3OiRSQniQ6jjCSopPt1DZ4ErYorPomzZMz4PW6pbienF8U5g9mgM6e76M1Skmu+UUXm5s=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6882.namprd04.prod.outlook.com (2603:10b6:a03:21b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 20 Aug
 2020 06:24:17 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 06:24:17 +0000
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: Remove an unpaired
 ufshcd_scsi_unblock_requests() in err_handler()
Thread-Topic: [PATCH] scsi: ufs: Remove an unpaired
 ufshcd_scsi_unblock_requests() in err_handler()
Thread-Index: AQHWdR9eLwo1QgZADUa7GqtKpJda3qlAinkg
Date:   Thu, 20 Aug 2020 06:24:16 +0000
Message-ID: <BY5PR04MB67057E61AB1866ADD61A3748FC5A0@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <1597728047-39936-1-git-send-email-cang@codeaurora.org>
In-Reply-To: <1597728047-39936-1-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82f19f05-c0ba-4f3b-15f5-08d844d1aa71
x-ms-traffictypediagnostic: BY5PR04MB6882:
x-microsoft-antispam-prvs: <BY5PR04MB688279BA8BEDE5895BD406ABFC5A0@BY5PR04MB6882.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8OoQIX1gSjoaIObyvXWJaCWqkyNe3fxhGi4SKC6PCN7XDr5MDBAoO9sfF3X0ZIsuLYSRXVQGO4WC1TnZbREjqbDIJw5EYzQUamx1HgitzbtaO0oC20ulZb45pnBz2fuO5eiXny5ST8fCOhuHRx4mRHtdoD2cEscMB1aQdQjG0Q15URNB8BPcUjpEC1Qupo+9ERF6QmjldYtruSyLI77Oola/yKT5FovW8SLXcGRUn9BnNLzy7Z0LObbngwUi09gaFae3K2E37hHsNZpVhNKQYy1/B63l6JO/JtuTq4CcnVOYLZkTR+ZKFTGNG9Dt+HKVEBPXUYqh55Lv4GiL4UUENA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66446008)(64756008)(66946007)(76116006)(71200400001)(83380400001)(2906002)(7416002)(86362001)(6506007)(33656002)(26005)(186003)(52536014)(498600001)(5660300002)(4326008)(7696005)(110136005)(8676002)(4744005)(8936002)(9686003)(55016002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jtLwSSRzqCV+/qcsowXLFSwe8IgfZk/5ZsLTWVzsfsmUVh39wSSLnPI6c6ebloEeh1OJ4olCw/Fy+rK6EYj5AWGoWdTGZkOmoC78TQnTQCXiKOalzNbsw5Pi/QalX0fWSGGMzQSicGOBR8YQFWfa/Cp8+ASSu+cPlPomKeloKobnR+DR4OZHbNklFMhxvEr/uNhy6lsFauzYQXh0W3c+ByVmRlEqKSdbLnatR1MQ2duXHz1fO9OkvBkqELl0rz/P5IaKP+dh4ti7MUKpq+ei20CHe11k/xOh8qF5bdWK66zGrdACq8gzkvwowWkw+HRtaAHNj7SeOMMYIJbckGsSUbbO+xxH/9qCN2sBDERVu1CD36n1sv2oecVnqbDCJj1goMSDBaGPrllwWPt09Ntz+WTQHAGSkBA+zDDc4qPZsVUr59a7ji8kP9GXwXi6cmDyWYWrtQlMFjpxp4a4gMishmUUb/tDMWlsmyTDBWpbeL0/Rn5fbVvAGmEuVEzmKrgkq/WCj/xSV3Hq7eF2GmBE6ZgjAmdDr9ttINJPeMV3hq2gAqCiTTkvvN44gUgNCsbh/79QAJFZdBTsmJbLkiVrWzGXJMP8Dj+vWXIwTQzjxJdJH9NiuyLrAjK6cHCvaebYe75wrwhXni0krJco/90uyA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f19f05-c0ba-4f3b-15f5-08d844d1aa71
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 06:24:16.9962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D3tkxkUjzhF0ulcXDk87nTB1qIHwzQRhzqgyBcZYkiiqjQYB0BnNloyO/vKR5VTZoCWqRnQcNdavPbbsizDURg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6882
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Commit 5586dd8ea250a ("scsi: ufs: Fix a race condition between error
> handler and runtime PM ops") moves the ufshcd_scsi_block_requests() insid=
e
> err_handler(), but forgets to remove the ufshcd_scsi_unblock_requests() i=
n
> the early return path. Correct the coding mistake.

"fixes" tag please, for those who don't read the commit message.
Thanks,
Avri
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2b55c2e..b8441ad 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5670,7 +5670,6 @@ static void ufshcd_err_handler(struct work_struct
> *work)
>                 if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
>                         hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
>                 spin_unlock_irqrestore(hba->host->host_lock, flags);
> -               ufshcd_scsi_unblock_requests(hba);
>                 return;
>         }
>         ufshcd_set_eh_in_progress(hba);
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x
> Foundation Collaborative Project.

