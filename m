Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF43C33CA1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 09:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C48620661
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 09:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgBEJbe convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 04:31:34 -0500
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:47462 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728034AbgBEJbd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2020 04:31:33 -0500
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.191) BY m9a0014g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Wed,  5 Feb 2020 09:30:37 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 5 Feb 2020 09:10:55 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (15.124.72.13) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 5 Feb 2020 09:10:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfbPvYUXtYCIEKvLJqeYiQZWvdD617btnOg6/78qo3EVOx98tn4VjkZ/ddzmzJ0m2YuMr2Ob1WQv//dZh9o81EE6bV+fO4U6R6DmkrLk83sucWk6J+7zos8/A5kmjN50eKvPl46pulLh8H9LwE9d3AMevFQrv1yv4fnOmax7uSiiKLEMkTCj/rvxq+lqyxBPcyFWrl9avM9WEWb0qGmgiuBJb+MO5oIolXLHV/MrhEgo1rKApS2n5ysNC4LLJOy94QZvYHWvSQrRmJtPjm5Q3GctURqiBRsr3AxGfgfIxxtye8s5UKvrN0G/UsgC4+RCKyVJH/xKkGibsb1q3Lb99A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lspv/b+LIrOCGs0uyYToHrz2c1xAR4h2rF5nPLtVJOg=;
 b=dLjEcx4bRA1jS0a38Y2djT8LbtG/M81byMMEf+HcSj3SNcJUjLtu6prrs5/Wxoy/Eyq2bqgTEQjXUrNQvOdlG1KM+mT5qAcjEFhfhYHcU2XvRZSPT5w99dq0BGoYnzaRbtWvM/U61mxfpKEL3RmKUq/tWjtL+A3dwGl5fscztHDTzHC0pUOVOaTz1bEok5hpakO4xhvjSBHJS/LvOBBSq3BY2vPR9ZnAfhINcCMt7J2zQVMqaA45ROrWxCdixYGZuchq23tyh+XqKa/ja9TuPzWY+rfNZjckaZuK36k2HVRuBgIQ2S9Vuel1Etu9L3uYSbD4hrT9eZEcZMt9cPEZaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DM5PR18MB1355.namprd18.prod.outlook.com (10.175.223.16) by
 DM5PR18MB1291.namprd18.prod.outlook.com (10.173.209.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Wed, 5 Feb 2020 09:10:53 +0000
Received: from DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::946a:bcb6:670b:8e86]) by DM5PR18MB1355.namprd18.prod.outlook.com
 ([fe80::946a:bcb6:670b:8e86%12]) with mapi id 15.20.2686.034; Wed, 5 Feb 2020
 09:10:53 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "r.bolshakov@yadro.com" <r.bolshakov@yadro.com>
CC:     "hare@suse.de" <hare@suse.de>,
        "qutran@marvell.com" <qutran@marvell.com>,
        "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        "dwagner@suse.de" <dwagner@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't shut down firmware before
 closing sessions
Thread-Topic: [PATCH 2/2] scsi: qla2xxx: don't shut down firmware before
 closing sessions
Thread-Index: AQHVpvNM3hsRz6i1LU6it9oHMBqteA==
Date:   Wed, 5 Feb 2020 09:10:53 +0000
Message-ID: <da4c4412909ce0428217d4e2d2009ee8c54d0ac4.camel@suse.com>
References: <20191129202627.19624-1-martin.wilck@suse.com>
         <20191129202627.19624-2-martin.wilck@suse.com>
         <20191130102358.axyzfb5vxorbvuti@SPB-NB-133.local>
In-Reply-To: <20191130102358.axyzfb5vxorbvuti@SPB-NB-133.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-originating-ip: [94.218.227.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73aae094-d2c7-463a-d3ab-08d7aa1b4d67
x-ms-traffictypediagnostic: DM5PR18MB1291:|DM5PR18MB1291:
x-ld-processed: 856b813c-16e5-49a5-85ec-6f081e13b527,ExtAddr
x-microsoft-antispam-prvs: <DM5PR18MB129182EFF8246A32F83E49A7FC020@DM5PR18MB1291.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0304E36CA3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(189003)(199004)(6916009)(186003)(8676002)(6512007)(66574012)(478600001)(66446008)(64756008)(66556008)(66476007)(4326008)(2616005)(4001150100001)(316002)(81166006)(8936002)(81156014)(66946007)(76116006)(91956017)(5660300002)(6506007)(71200400001)(54906003)(6486002)(36756003)(26005)(86362001)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR18MB1291;H:DM5PR18MB1355.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fkYres+IkYNNOFEmpTTVUjIYVz7Ak6K3UsAPKm8R7LhVloJqtHmhSZa18lcchFaVbwav/WbbjXoqiXPsgReiu3lN87iZ2oUiu9IJKQyaZPXln/ZKED1aGOKiQ9pmpE7cWL8Mtjznf5vk9CQzU50npWH4vVtCat21B1c0fUolIV6tiX5oeKDwkp7Pk+mAXr+TFrZ5HTk6LCD9F8WWikGMq5jUOQpPdd5PJQr7CqUuwbDezXux8AQC+BI8pvpG6PCQPXHqCyaMxmfMSDLk46IlfDMwZuVKk1x4T/AhiCp9NUTiyRT86Ai6M3LKlcIbEUzkD81Qd/lmraSBOUXf9Et9ee+FZTkmHzLi0+51QKbi8LsWwKj7AN6YMaWxw3yoGrdkP0CYn4MX5cl1gz2wJM4ukkqjatVirD/FrmvE85uudwcutkXXj8lMt6imfVVvUTqd
x-ms-exchange-antispam-messagedata: A2BT4RHurWZM2KoDyNucAKbIDSEd1DR62j30sxMgh38JgZVAWUQUP08GEjSxi1ryd87mTE9F1/VSpnIIxy9X2uEsWJBvno1q+t2YE/3wk66QW05Xn0HwuBqOYph4CIEBTZHWYPcvOxWKMfoMonbBbQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <985DE81958CB234FA1B5123635DAD55F@namprd18.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 73aae094-d2c7-463a-d3ab-08d7aa1b4d67
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2020 09:10:53.5123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8sTkYCMYaBmzP4r+2sICjGf16wakKmFbF+u8J6Uw1ThnvcDuvZaqIB4KrRyC4GnoC37r/SDC1bWJdfO49TdAGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1291
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Roman,

sorry for the late reply. I had temporary issues with email from linux-
scsi, and then was busy with other stuff.

On Sat, 2019-11-30 at 13:23 +0300, Roman Bolshakov wrote:
> On Fri, Nov 29, 2019 at 08:26:36PM +0000, Martin Wilck wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > Since 45235022da99, the firmware is shut down early in the
> > controller
> > shutdown process. This causes commands sent to the firmware (such
> > as LOGO)
> > to hang forever. Eventually one or more timeouts will be triggered.
> > Move the stopping of the firmware until after sessions have
> > terminated.
> > 
> > Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting
> > down chip")
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_os.c | 21 ++++++++++-----------
> >  1 file changed, 10 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/scsi/qla2xxx/qla_os.c
> > b/drivers/scsi/qla2xxx/qla_os.c
> > index 43d0aa0..0cc127d 100644
> > --- a/drivers/scsi/qla2xxx/qla_os.c
> > +++ b/drivers/scsi/qla2xxx/qla_os.c
> > @@ -3710,6 +3710,16 @@ qla2x00_remove_one(struct pci_dev *pdev)
> >  	}
> >  	qla2x00_wait_for_hba_ready(base_vha);
> >  
> > +	qla2x00_wait_for_sess_deletion(base_vha);
> > +
> > +	/*
> > +	 * if UNLOAD flag is already set, then continue unload,
> > +	 * where it was set first.
> > +	 */
> > +	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> > +		return;
> > +
> > +	set_bit(UNLOADING, &base_vha->dpc_flags);
> 
> Hi Martin,
> 
> Moving qla2x00_wait_for_sess_deletion up ensures hw->wq is flushed
> before shutdown is done.
> 
> But I think we need to set UNLOADING bit earlier to break-up async
> discovery chain. The comment just above
> qla2x00_wait_for_sess_deletion
> definition mentions that.

I was unsure about this, because fc_terminate_rport_io() will not send
LOGO any more if UNLOADING is set, which I thought might cause issues
in the SAN. But I suppose it's ok, because after setting flag UNLOADING
we will roughly proceed as follows, sending LOGO if required:

qla2x00_wait_for_sess_deletion()
  qla2x00_mark_all_devices_lost() 
    qlt_schedule_sess_for_deletion() -> set off sess->del_work
qla24xx_delete_sess_fn() (from sess->del_work)
  qlt_unreg_sess -> set off sess->free_work
qlt_free_session_done (from sess->free_work)
  This will send LOGO if sess->logout_on_delete is set.

So, I'll add this to the series, plus Hannes' suggestion to use
test_and_set_bit().

Thanks,
Martin

PS: the qla2xxx driver has multiple flags and tests for "can I access
the controller now?" with (at least for my mind) blurry semantics and
unclear mutual dependencies:

 - dpc_flags: UNLOADING
 - hw->flags.fw_started
 - vha->pci_flags.PFLG_DRIVER_REMOVING
 - qla2x00_chip_is_down() (tests fw_started and the dpc_flags
ISP_ABORT_NEEDED, ABORT_ISP_ACTIVE, ISP_ABORT_RETRY)

I've tried to review how these different flags are used - I don't see
obvious rules as for which flag is tested in what situation. Anyway, as
argued above, I think for the issue at hand using UNLOADING the way you
suggested is correct.

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG Nürnberg GF: Felix
Imendörffer

