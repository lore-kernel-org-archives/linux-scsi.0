Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99DCC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 03:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3418208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 03:01:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="OlormisN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgDUDBo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 23:01:44 -0400
Received: from mail-eopbgr1300138.outbound.protection.outlook.com ([40.107.130.138]:21573
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbgDUDBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 23:01:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aL8JfyPZue9epS9yNp3Rqv4HuP3xRpbx/MGnM1Fd+cM0f+aR/DhpCff5HnKiz7uGLLGo3CKpWGZvoAtls4JXrO0xPcSntLVfHmRX14fTLaHdz3eUFLFuZD6CXF2dmWUQvFVRgNjTnnZ2xO9RIm0yu8vKigMRsjmrVor8YMtxk5Cxss+MwQnmZxsFpZkBwKeOL9MHPaxuuEvAL6O5HrSqmoq333ZbGD4XPyrIeNtScbcWXMH7drChX37BEkAehfqxsVneKqHMyPNSYdXXMn6beg5sXHNlnpC2+GxrUy+L5Jsw5SUGBzNskqt/9UuOwHfBK9BXeogEsXnKCo69N948dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FHJgEI51uMJLwahWmbcOZM/zvuUvFOjSYKo1+e1WpE=;
 b=FGjMTpgK2ONrvKYtouJP/P072sJpMTycXz09jt1iz1hgHllL71PiVYjE6EgMVWihbXh121FHSjeBJOy4j5n5Ydy3IB5EbXibesBminO80vg5HVWVEgVMm7YE+m1dc7xLdkGJ1V5id+Kf+zKuH9BkiritWObtnOzC/NNWxVw7Jaei4+sruyKXrrfmyW11DbwnOIJ7cwY56x52IU448HqQZF1c0nifPWmON7wjI4PjKa0LfvQmQtgZjbf8IOL3CoNCW1B/FKRVX2NReWKAkkaVld0yaAxbQsk/v953o5drFR0jlsXpA7rXsvITD37DNiVTYjqpDVHK5dJbZ9iwP0UAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FHJgEI51uMJLwahWmbcOZM/zvuUvFOjSYKo1+e1WpE=;
 b=OlormisNrEBUCCsz+TYRJyyaN5T+3NSrI4ezFjD4y5X3aP+A5ETR7yzmehfnL2FCUVyLVgvLg/xD3Z1PZYb8/H3TkZ/FAKE2in5us3KZDil5Q1U9IvKNk3Djmpw3nIaNS1T/pqsjxBGtexYMKF6uv081PyY9Pdl0UeiNOzKBVv8=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::12)
 by HK0P153MB0177.APCP153.PROD.OUTLOOK.COM (2603:1096:203:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Tue, 21 Apr
 2020 03:01:35 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2958.001; Tue, 21 Apr 2020
 03:01:35 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Ming Lei <ming.lei@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hare@suse.de" <hare@suse.de>,
        Michael Kelley <mikelley@microsoft.com>,
        Long Li <longli@microsoft.com>
Subject: RE: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to
 SDEV_BLOCK
Thread-Topic: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to
 SDEV_BLOCK
Thread-Index: AQHWFSr+H/+YbDb0+UyY0wbeDKQCaqiC51HQ
Date:   Tue, 21 Apr 2020 03:01:34 +0000
Message-ID: <HK0P153MB02739AAF1415BCC36D8C4EB2BFD50@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <1587170445-50013-1-git-send-email-decui@microsoft.com>
 <20200418024158.GB17090@T590>
In-Reply-To: <20200418024158.GB17090@T590>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-21T03:01:32.9138726Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cb35d881-2cae-4e5f-8a92-6c9fe43744ec;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:8ad:e9e1:6b1b:63b1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 48eb23b3-d673-410e-99d5-08d7e5a04d46
x-ms-traffictypediagnostic: HK0P153MB0177:|HK0P153MB0177:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HK0P153MB01778178F6BFB6390D025E38BFD50@HK0P153MB0177.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(64756008)(5660300002)(186003)(66476007)(316002)(53546011)(71200400001)(6506007)(52536014)(76116006)(82960400001)(66446008)(10290500003)(66556008)(66946007)(82950400001)(478600001)(9686003)(86362001)(107886003)(55016002)(4326008)(110136005)(7696005)(8936002)(2906002)(8990500004)(81156014)(33656002)(54906003)(8676002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mkTCl0iRzf9u69iX/x9vbokwKzHyIFvAzryiaGgv3WIFNtWlHT3D8mowzCxGB7Kq3FdVZ3hT9CnNxzOExnN7z13YywScnsVU91zALh1rZlXIwM0+auTMDEA4sHruN2vw6CNznkr68BhlKQNAX/mqhQA6OqefT21GpTXgujWbcuiWdQOj9jiNDrLFBWfxiwaGtHN+5Tv5W+s9iRZ+lBPzYJgCtiIAuFeHXJN5TpFXAZ2eKD5tQI/lANonxnEY4itqxWFqc+3FK8f0fQa9Pgl/SCsEWmC/HLJmxIVXSUduKsT7VSU+iHbb+Bt1rxULI4jJ/tpUuzmtPIz8//76JlR4NruUFBdqSDGXesvnjykigcRakvG3HBkPBPn1i2s4Yi3fcVOb5LdHiwAAXpAKfq+Unp4V7O0D9dKTuxejnKQSsz1az6d1Oyk4g6O8umQ8Ga6i
x-ms-exchange-antispam-messagedata: pzllJ8BJH3Dg3uK7vTkyuAjn/IrV8qbCscm8temMtTjx51sHnNojFoJbRVng+E28WkOjMzlLXwDFjpwjBAhHn7ZwaVdO6s4sD9S89xkOza6nm1BWQXiNwZO68KyA4ACbGDA3wo4V7d80buKsryNTxkxuigiypbFVGqXXFRZHZ1Fc8E8eWEO+WDxwBl5Gsl7c54/T23ZwAny+Qh5vDbyrFZHtxlBUvJUqYLF4BVKGp8nk51GPzuT3OLopJNwXuyOHHPbhu25q+ZliH+kIYDULW+WY5P134A6U03mtDFXguz/Pk0uUPMBZ0mpwuJWsFR2bk2Y0YoQ50NiYJZqWs16rxfbAQ7nJxo8CV8ohl/EHbK3SvYNxraXK6t56k5LIdO71EzcJ7bB9IlSa/x7dpbdTNpCp3tkd+mma7/kPEZA+ecBSI9xugoFJWvGbVfSnTyGalOzDv5zHNYAnw5sLHgzm92XvWUDjtad+LlxV0znG1UleMdAkbYwTfgDgnvY+D86Y/q2VTnPEdu9JqK9VXIV4AuojJNTySHfLo5s5vc2URo+5RyJXBisIHpq1H5Jhkj0mHwoOaxzft+Zurtz2ZwYcpO3Zd8ulF4p5LT25Zqh0bitYc1P96O4jkQHfl08Bh7TSKLxeHQ/YZsBYCAi1SpQ/H2fJpBKuF0mm1L3Opcg1zjRHdoekqEvsbMJlTVEBGsp05clNANFnP5lPKsi4VLVaFWaxW2rDptOZXaK5CCKjdDftlYYW8WlqOwST2SCFjzVGN1/8ptBfZWnaXA5pqtPANCMd6nbiG26/zxktmR0xbPT4+bRbdjiwFyuTL6Aqtj/jrWNYIl1xEHBpM8J1xF9m52bXOMRY10zJXSRITePjfp8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48eb23b3-d673-410e-99d5-08d7e5a04d46
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 03:01:34.5937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1q8fmkoCrux6qxTonuGJvUn5uGD2BkFy+1XRPN9452Dv6fWLVqOJPPL5/yyQCB2GYz7zJceKn0gprCtReaCXYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0177
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Ming Lei <ming.lei@redhat.com>
> Sent: Friday, April 17, 2020 7:42 PM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: jejb@linux.ibm.com; martin.petersen@oracle.com;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; hch@lst.de;
> bvanassche@acm.org; hare@suse.de; Michael Kelley
> <mikelley@microsoft.com>; Long Li <longli@microsoft.com>
> Subject: Re: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE=
 to
> SDEV_BLOCK
>=20
> On Fri, Apr 17, 2020 at 05:40:45PM -0700, Dexuan Cui wrote:
> > The APIs scsi_host_block()/scsi_host_unblock() are recently added by:
> > 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper functio=
n")
> > and so far the APIs are only used by:
> > 3d3ca53b1639 ("scsi: aacraid: use scsi_host_(block,unblock) to block I/=
O")
> >
> > However, from reading the code, I think the APIs don't really work for
> > aacraid, because, in the resume path of hibernation, when aac_suspend()=
 ->
> > scsi_host_block() is called, scsi_device_quiesce() has set the state to
> > SDEV_QUIESCE, so aac_suspend() -> scsi_host_block() returns -EINVAL.
> >
> > Fix the issue by allowing the state change.
> >
> > Fixes: 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper
> function")
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > ---
> >  drivers/scsi/scsi_lib.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 47835c4b4ee0..06c260f6cdae 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2284,6 +2284,7 @@ scsi_device_set_state(struct scsi_device *sdev,
> enum scsi_device_state state)
> >  		switch (oldstate) {
> >  		case SDEV_RUNNING:
> >  		case SDEV_CREATED_BLOCK:
> > +		case SDEV_QUIESCE:
> >  		case SDEV_OFFLINE:
> >  			break;
> >  		default:
>=20
> Looks reasonable because SDEV_BLOCK is one more strict state than
> QEIESCE, so:

Thanks, Ming!

> Reviewed-by: Ming Lei <ming.lei@redha.com>
>=20
> Thanks,
> Ming

There should be a small typo: s/redha/redhat :-)

Thanks,
-- Dexuan
