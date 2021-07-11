Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A80C07E96
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 12:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CC26101A
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 12:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKMjz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Jul 2021 08:39:55 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59686 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhGKMjz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Jul 2021 08:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626007038; x=1657543038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EiYrz7oJSm5qA2j8yssyoi5+Ha028L3CSx7bVdtdy88=;
  b=c/sEtoW9CpTyV7KIXhhFomtwpRZquWjDdYJTJr13R4XIZQP1n9VWuRSu
   2/u/3J06vyqyeNHb4BWMWfzyYxP1qnfoezzrqt0J/+7MGmCSjlX1fwKFV
   ADO0dVM6zIlTLf4kUre2i+m4OMOXGfn5TooqlsFoA0x7kaH6e0I+uxOW+
   uKKqTULKTUc9O1c/1xN7UjekFMfOPhbJLbLXwusA2nheZuCThdqng4K8m
   KMaEOkXnsl3zA6cXdIOJ4DuQCnEuS7Y5GxzZF1Emy4hslMoxFqcKR+pcu
   K1o+QYf/dNY0Kq3orLxtZGTQBgniLVKn0TWSaT6vdbzOzLIHLWXlXzJRL
   Q==;
IronPort-SDR: tqoHp/afv0pfBCIfoV66VSvU3dmLYw+R2SKugvdIPGWrkCHwlQqSXLvk40F+DmYtoF84I60iw8
 OoMj8FnNExFcoa8cPdRmIKdk+/CE68V0zkOZ0ljpa0IRJrf6kVPpX5Lk9OSxIm2g+hDoyJty0w
 TBapfDzPbKWQ5XPOwZkMDPfdP/tmM7HDTIig9hj6aalElSvXSaKXdTdqJncvSQ0QGWbEkvWDZM
 qOLM9EyYjYYTS9791o2HdAG8MlCBr5Fp5vqlSz0wKbmNHN4xSmm+Py1RwN8ao9TCEQtKPcJn9R
 Lro=
X-IronPort-AV: E=Sophos;i="5.84,231,1620662400"; 
   d="scan'208";a="278095971"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jul 2021 20:37:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lk1jOhQa8WNLwyhfKsbsOnNTPETQlTm4G9EiW5XoKXiNEWMfLNFA0wlt+2ybprLQQQTUVWbOq1jqO5Hpdrf3Omr2CywdM0CnFwEcWZNz3aNM3VFIWy28kOHz8tYOpFMl3YX6EYC0cgh9cfE6cBTbxkSjHtLa5LFuzneyu4SEmlW9mueVUzjykPDfSZmpODXabCaZUOPlV2eiLzNAO12qrCl0clARv/KyqV5rACMCyvEJd6hE4yZ3uT+CQ0XeHwQGQ3Jqqh74x4szbmq5CIuyq+StL46TpnWTlLVA3iKxKV32T5OgRK1tvuhrXrJjUhNhfMez3L4733gF8wt88L8xyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZS2SL+ts7j4zbtBWB6XMEaEO3mlkY6s6j+IrLw0A2E=;
 b=ZcdApG96PjZDugt2S5spBsqaMEWDMGervNft3pnebw6I+KH30fDVIS/TK6u7Rmo8mGX5GjRoJbl9L5d5PwSaQMFQlhNtKFyAL9i8UnzHbJ5NeUIVwS3z1t/QgKFCKqXCrEslrC08u06/xlbamsA2FKheSI0D//hOqjUkULKQqZiFR3H51D0dkWb/gHE7PTYtyjtV62DjumS4X2b1WPz6I+rb/BKNAyZ8vE73PtypV4HX6RidBBWWv+81CGvhnQp1gwOkh2BJcyJw2+QeQ1TcJIxazcrrRn72vLbKI9WechIRMLKeT2FOFVm6q5QsiBWEsE4uEXE0fUBLS51YArwalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZS2SL+ts7j4zbtBWB6XMEaEO3mlkY6s6j+IrLw0A2E=;
 b=MXhOSbO4iYAFUxZWF9Qy112QI71jxTwEQtnOrAc/u2aUh1j+g77n1JSAzi+/PagzO2Mrvx3Bn71cJSP3/fQ8GaY5DTbMd5HP91GR2UBsXhdc1TKxL9QKzTk5owqZ0HgAMclALzMzHZl0pnbuUw7Z50TZTc341cS93qnG0NPLeUM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5353.namprd04.prod.outlook.com (2603:10b6:5:109::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.22; Sun, 11 Jul 2021 12:37:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4308.026; Sun, 11 Jul 2021
 12:37:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Thread-Topic: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
Thread-Index: AQHXdQDgAGtkX44t6kOse8My4O1WHqs9tRkwgAADb9A=
Date:   Sun, 11 Jul 2021 12:37:04 +0000
Message-ID: <DM6PR04MB6575FFEE355474C7ACD9BA4FFC169@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cad29b7-25a1-4a31-8463-08d9446896d3
x-ms-traffictypediagnostic: DM6PR04MB5353:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB53536719E638467B4707F945FC169@DM6PR04MB5353.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PKhIJc+cRZG61nSb7nzpcuYmfZt9uktbScWhml0ma1+C0I97a+kbqznlNyibj/08CzN3T/IW4IpbSzflBJKEjViDMv49P5AZ+Rz5eZNvGWS1AZ5FOBxOibD5c1sbCScBcJ2emOBVLp8NhYVG1blfcS/uBs/KEJnZ9+q0jx1t9Js1euHn+8Jl3XK22sY1PMAkTjKXIq4aRu4dSB4Hl3lhRNEr049jg7d8JejOjyCkBvxRoq+61IcSzRyls/UUJYshipDB1jmdaNOmY8RjHCol5ueDGalwdhCnUO8oTAO2sOiCqLpuo9T/4XEhV+i21ZtjDu41sG63lb7ZDJ+Q/kMPeg32QuEq2ybFfZ4ZXwEC5nL542ya/s9jdVf2GrpQ1ioUCM6N44BTAfIxIdDAzrKWB7LCJ3Vt/3VfJ+MjUlE/cALSUkSd4eLcqobq3GqMQ3rZysdJIbiZ4tSYLprmQAMB97G26PguDcGae6xilQSQzvBnAyfBrZyAUqcm/rVKT3QQul3zRXBQmNqd+0/7r0pMn2kdpjPCkbGyZbRo1JbGfY6tPlWpQnwtw2S5NjZ58MQOiwI95/Q0k3HL5cZgOuzXLbdCkJDWZejxOegO8hAAlgQ/3xRdFQcvIO7Y69QMNPicnQwqfWEMSQiuuXSZicQTMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(76116006)(5660300002)(66946007)(2906002)(7696005)(478600001)(8936002)(6506007)(7416002)(55016002)(83380400001)(66476007)(66446008)(64756008)(66556008)(2940100002)(26005)(8676002)(4326008)(52536014)(71200400001)(186003)(38100700002)(86362001)(122000001)(54906003)(33656002)(110136005)(9686003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fM/8bdO0h3donPYqc4tsPHt2MQo4FBtHXBYnaxelBMSFSXb4jWIFOpsexN0H?=
 =?us-ascii?Q?QvaHPnQclvTLSVRh7UIMx9Ug12Ds0WcmaCXvObzmgupTbBP/yHiynFNX7iVa?=
 =?us-ascii?Q?ee/1jL/9v+8wFh1gvQJ2Dr/ij1pl9N0dRZiRxYNf7qbXbiWeFspR6idJfHVN?=
 =?us-ascii?Q?GngaCqe+XLX9R41j7Ig2FzJth4vblapUWYFMn0rdmY1sjT4gKDt7dljUUzgZ?=
 =?us-ascii?Q?NKSUFSPpdOPwIgKAWoJRE5iRDPCjhkkz81AkmGxhfY7DFI5x1N+nlGX7M7TU?=
 =?us-ascii?Q?c42Y+Hsyf+Yx02mRXKcYkITQxH9kvOHyNTIs2dkw/S7lINDiBly1as1I9Rz3?=
 =?us-ascii?Q?h5Iux6M2h8r2i94xMSJJqE5CSoZm7ilDeqwfkaEAo2EyD5k74ttLIWJw64bO?=
 =?us-ascii?Q?SLiQSigHALDinWSDcquKv4X/TRVPgVNmybMOAG2BWCmToxwqKHHZaX2aJcTc?=
 =?us-ascii?Q?Xpd0Ch12L8ifJ1kDwBJoK0VrDZzTIF45K8ZOx5n64d4+Lf6mnzUtPPOoL1O6?=
 =?us-ascii?Q?ABHODFEuYsG8lzK5Y/4225+gavgGdNIfoX097sDtoPKKyHiWmjCSsNbFQsv3?=
 =?us-ascii?Q?yi5WpSMG4gshLRf/hzpzZAbjb40L+X4Zp7DIrQ0RBn4Xu32HwxTvif8nzsc9?=
 =?us-ascii?Q?U+COKVkyMVo4EWiH4WJlWPeWOucVTMltXaYRi/UmiVWQgRk23Do9PIXxirRP?=
 =?us-ascii?Q?EoOkls94LLMwUl8jwm0a1xTPA1yQ7u4qZCe4d9XfpXDQ79NYXAGtx4Tb126K?=
 =?us-ascii?Q?L5qwc67UIjSfqZ0eQbIMd3wxKdvtmj5dDpObKdeFv7vpZhVh98g3jLzkDwuP?=
 =?us-ascii?Q?uigpjNzbPeOWUQMISTysaMld/3gz9muAtEJ356r8pB62CnQLsDSGevO3DjBf?=
 =?us-ascii?Q?G8cRa03JRtochEix9H6mcOfSz0LqAX/0Zf95vJxQl2vv108NRyc3an5Tx5jo?=
 =?us-ascii?Q?axZwKxud0NeQwPqoKOaxyq6cG3doJ3hpznJiUjijEQ6SKTBC+qQnzdo7xE/L?=
 =?us-ascii?Q?NZ5GQZZMjUuca+ENMevrouBoJEDdcVZmzj/LUZQ5Vf1sSzGGnyfNTAM4WBf3?=
 =?us-ascii?Q?jhsgWC/Xcx0Xowhr11fTgKiIjbpNaI0TMd8czlibavtmPybs7DtNSBXLd6xZ?=
 =?us-ascii?Q?gbLswKsJeEJ9RaL0g/7YVSDRyzU3yvjEskzGXxOnWDktrflDWg+yWgRIaJ0I?=
 =?us-ascii?Q?2m5JD0Mqoie9I7q9WDmsXIq5gXpbEVjVGxrsY/SDcQpwPAsB9VXro1YKT+RG?=
 =?us-ascii?Q?Lo9l7ewspw+DbXjCrJjz7vDVvs1x23BQcHcTrRutrU/fDFgQ1JWykgdY+4uv?=
 =?us-ascii?Q?2MF23O75wXCyaCi2mWDfl60s?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cad29b7-25a1-4a31-8463-08d9446896d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2021 12:37:04.6302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DlmQB38Mbn0rvp2X7BAEshHQkkvk9ErHjGEDrsM3ZP26xzfsrT8H2peUQUNqFYPrTmQKU3RuO1T5dqPiQyP6Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5353
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One more small comment.

Thanks,
Avri

> >
> > The following unlikely races can be triggered by the completion path
> > (ufshcd_trc_handler()):
> > - After the UTRLCNR register has been read from interrupt context and
> >   before it is cleared, the UFS error handler reads the UTRLCNR registe=
r.
> >   Hold the SCSI host lock until the UTRLCNR register has been cleared t=
o
> >   prevent that this register is accessed from another CPU before it has
> >   been cleared.
> > - After the doorbell register has been read and before outstanding_reqs
> >   is cleared, the error handler reads the doorbell register. This can a=
lso
> >   result in double completions. Fix this by clearing outstanding_reqs
> >   before calling ufshcd_transfer_req_compl().
> >
> > Due to this change ufshcd_trc_handler() no longer updates
> > outstanding_reqs
> > atomically. Hence protect all other outstanding_reqs changes with the S=
CSI
> > host lock.
> But isn't the whole point of using REG_UTP_TRANSFER_REQ_LIST_COMPL is to
> eliminate the host lock
> As a source of contention?
>=20
> >
> > This patch is a performance improvement because it reduces the number
> of
> > atomic operations in the hot path (test_and_clear_bit()).
> Both Can & Stanley reported a performance improvement of RR with
> "Optimize host lock..".
> Can those short numerical studies can be repeated with this patch?
Please use rq_affinity =3D 2 this time.

Thanks,
Avri

>=20
> Thanks,
> Avri
>=20
> >
> > See also commit a45f937110fa ("scsi: ufs: Optimize host lock on transfe=
r
> > requests send/compl paths").
> >
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> > Cc: Stanley Chu <stanley.chu@mediatek.com>
> > Cc: Can Guo <cang@codeaurora.org>
> > Cc: Asutosh Das <asutoshd@codeaurora.org>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++-------------------
> >  1 file changed, 17 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 83a32b71240e..996b95ab74aa 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -2088,6 +2088,7 @@ static inline
> >  void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> >  {
> >         struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
> > +       unsigned long flags;
> >
> >         lrbp->issue_time_stamp =3D ktime_get();
> >         lrbp->compl_time_stamp =3D ktime_set(0, 0);
> > @@ -2096,19 +2097,12 @@ void ufshcd_send_command(struct ufs_hba
> > *hba, unsigned int task_tag)
> >         ufshcd_clk_scaling_start_busy(hba);
> >         if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
> >                 ufshcd_start_monitor(hba, lrbp);
> > -       if (ufshcd_has_utrlcnr(hba)) {
> > -               set_bit(task_tag, &hba->outstanding_reqs);
> > -               ufshcd_writel(hba, 1 << task_tag,
> > -                             REG_UTP_TRANSFER_REQ_DOOR_BELL);
> > -       } else {
> > -               unsigned long flags;
> >
> > -               spin_lock_irqsave(hba->host->host_lock, flags);
> > -               set_bit(task_tag, &hba->outstanding_reqs);
> > -               ufshcd_writel(hba, 1 << task_tag,
> > -                             REG_UTP_TRANSFER_REQ_DOOR_BELL);
> > -               spin_unlock_irqrestore(hba->host->host_lock, flags);
> > -       }
> > +       spin_lock_irqsave(hba->host->host_lock, flags);
> > +       __set_bit(task_tag, &hba->outstanding_reqs);
> > +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +
> > +       ufshcd_writel(hba, 1 << task_tag,
> > REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >         /* Make sure that doorbell is committed immediately */
> >         wmb();
> >  }
> > @@ -2890,7 +2884,9 @@ static int ufshcd_wait_for_dev_cmd(struct
> ufs_hba
> > *hba,
> >                  * we also need to clear the outstanding_request
> >                  * field in hba
> >                  */
> > -               clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
> > +               spin_lock_irqsave(hba->host->host_lock, flags);
> > +               __clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
> > +               spin_unlock_irqrestore(hba->host->host_lock, flags);
> >         }
> >
> >         return err;
> > @@ -5197,8 +5193,6 @@ static void ufshcd_transfer_req_compl(struct
> > ufs_hba *hba,
> >         bool update_scaling =3D false;
> >
> >         for_each_set_bit(index, &completed_reqs, hba->nutrs) {
> > -               if (!test_and_clear_bit(index, &hba->outstanding_reqs))
> > -                       continue;
> >                 lrbp =3D &hba->lrb[index];
> >                 lrbp->compl_time_stamp =3D ktime_get();
> >                 cmd =3D lrbp->cmd;
> > @@ -5241,6 +5235,7 @@ static void ufshcd_transfer_req_compl(struct
> > ufs_hba *hba,
> >  static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool
> use_utrlcnr)
> >  {
> >         unsigned long completed_reqs;
> > +       unsigned long flags;
> >
> >         /* Resetting interrupt aggregation counters first and reading t=
he
> >          * DOOR_BELL afterward allows us to handle all the completed
> requests.
> > @@ -5253,6 +5248,7 @@ static irqreturn_t ufshcd_trc_handler(struct
> > ufs_hba *hba, bool use_utrlcnr)
> >             !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
> >                 ufshcd_reset_intr_aggr(hba);
> >
> > +       spin_lock_irqsave(hba->host->host_lock, flags);
> >         if (use_utrlcnr) {
> >                 completed_reqs =3D ufshcd_readl(hba,
> >                                               REG_UTP_TRANSFER_REQ_LIST=
_COMPL);
> > @@ -5260,14 +5256,16 @@ static irqreturn_t ufshcd_trc_handler(struct
> > ufs_hba *hba, bool use_utrlcnr)
> >                         ufshcd_writel(hba, completed_reqs,
> >                                       REG_UTP_TRANSFER_REQ_LIST_COMPL);
> >         } else {
> > -               unsigned long flags;
> >                 u32 tr_doorbell;
> >
> > -               spin_lock_irqsave(hba->host->host_lock, flags);
> >                 tr_doorbell =3D ufshcd_readl(hba,
> > REG_UTP_TRANSFER_REQ_DOOR_BELL);
> > -               completed_reqs =3D tr_doorbell ^ hba->outstanding_reqs;
> > -               spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +               completed_reqs =3D ~tr_doorbell & hba->outstanding_reqs=
;
> >         }
> > +       WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
> > +                 "completed: %#lx; outstanding: %#lx\n", completed_req=
s,
> > +                 hba->outstanding_reqs);
> > +       hba->outstanding_reqs &=3D ~completed_reqs;
> > +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> >
> >         if (completed_reqs) {
> >                 ufshcd_transfer_req_compl(hba, completed_reqs);
