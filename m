Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3DCC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiKHXPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiKHXPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:15:06 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53461901D;
        Tue,  8 Nov 2022 15:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667949302; x=1699485302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kQ6xKwcYLBkRIXlIT4BLScT/mvy2VtnT4VOZrza2lRU=;
  b=XodqSxF6U3uyqvPVlG+/9y2C/oIvTMyhY7gK1LFrRpk2o8UZf4cZfROG
   mMFsJTQ/Uw5ZrSGkwELAi97NeO94IQmXdss9fV4AumixEgO4+eT2+f8qD
   WUV1XPGOPV/52N+K3Fgb+LQkT4fgKkk/XOngofrwDSROenXc827yPJwYz
   /3/AWU+l1ekqbYFVS8ZtkyUjPJQVH3/4E72kvPkwUtW3iJLuPLQXq3uhm
   pQ+F/ZjIL2yRx+3+/fI1GMv+wpQgu596LiFhiHpK2fKKIgPrOyJd6xqY8
   Oa3hqQxMUtDdXWDg+/LZJlRJ50xYaS1fZsJh1yvD0q6trSU2iMCMiLxZY
   A==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="320140915"
Received: from mail-sn1anam02lp2049.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.49])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 07:14:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZkkSrPAgn+fnjdagEgvPbUB9MNljymtYoVFTXyY8KRo8StRLm8qE623slYtKSeO11SKLuvn7Rpmb7m8aLd5Xypk7QGsBxXN1lx6ISW+V1V6l3wdkB4fgiHYOX3Ttsdy7bTlRJpKMyYHHdke7ACN1i2RmS/fr+gEQ6SsdlA/4JlOW/m6sEsuGeNwXAZumdWCvUR8Q9ax/2whNfktXsmMKX9s8KJwaELs9YSC0nObfCg8XPt6AhvmpUFHFll4QbAWti6eup3Y9IC1Jr4FNBQlftbrFARhP7RuiC5U5T3T+3uDZBswckFD4NZ5f+UZGTE4M4R5pGIoNnf67jWj9b4KWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHsIBllMTRl1+xcEG7baewbevC0F5yD77g7iHOB/iCY=;
 b=b8WbFK+Dw0/JyBx2YuAz6udcJvqATHXZ8yypP8mfBGWix8EzojXe5KkwYHduyVcNdRg3INpOEAsnPB/mI9LaxGceqlVONbBLJ1niaMTcmx3bhj2TK8JqAVUJN0N7PiLytoPm/lny1mo2oiRyJk07m3DFhD9XXgGhYntEmD8tPmV7V/BG12gud0aApfFVO2nXtcibDKXVAWn3KJpd25W7DYURh5+ICo6EJFO1ipRVrOD7LQvkuAMEdbC1e/2HUSbHKirFQwEriYJQnBYlBHkeWr4DT3uGbgEcsmjt2QqncpCZpr1w03i+2rEyzXxuHseLojBYdROOlk2X5+HrkQUAng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHsIBllMTRl1+xcEG7baewbevC0F5yD77g7iHOB/iCY=;
 b=ObKC7WSGX+ASCpnuHsdk+n6eogU/kg2w9Jwe/beO6ZdgyG2x4tgrCqdXCBHMjoAxXEX8KmSMRbxEK37UfUDQhjD9QEQJS5xQSEEfj4gu/mB+IiaReLZuCg2dszXy+1dpABU2ph89esMNOs9eLXYmjIKfIDiFPwNY6gu+TEhgt64=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6929.namprd04.prod.outlook.com (2603:10b6:a03:22c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 23:14:54 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8%7]) with mapi id 15.20.5791.022; Tue, 8 Nov 2022
 23:14:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     John Garry <john.g.garry@oracle.com>,
        "tj@kernel.org" <tj@kernel.org>, "hare@suse.de" <hare@suse.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
Thread-Topic: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
Thread-Index: AQHY8sN+Uw8brLy8kkmVlm0qWKEegK4zr72AgAB0EoCAAEE4AIABRUEA
Date:   Tue, 8 Nov 2022 23:14:54 +0000
Message-ID: <Y2ri7EVPZb2O9iD8@x1-carbon>
References: <20221107161036.670237-1-niklas.cassel@wdc.com>
 <5a4fa5db-c706-5cf2-1145-bf091445d20e@oracle.com>
 <Y2mbX8MvYrF0FHaI@x1-carbon>
 <976bdcb7-cb97-9332-2bcc-5d98bc41871b@opensource.wdc.com>
In-Reply-To: <976bdcb7-cb97-9332-2bcc-5d98bc41871b@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6929:EE_
x-ms-office365-filtering-correlation-id: 3d801dd5-7d35-4e7c-cf81-08dac1df0b8a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bKf/TzJH1k1kydl7XgLi25MXtX9OV/uf6mJRX7bipWHIp4acwAgQrM21j5x2Oh31huvzjNOekNA3zMHpOiiytOMmR8mIrjYyXn1+ODnIxHMaOmu6fSSr4ydDmJlKqNHKd/slDZ+9W7gO5FK8Hc4evQHkR7tWTanFdpDxDGq+iZknm2YyMtdl9KWm9Kq1tDq1+JZU06Awur9V3KSdIazBocYP9xbVyKfbg6FjTp1n4b9G1e583hh8SJGkSdnAWKD+CdB6rFl5GI161lO8t4U44j78KM7aNnUdKx7Rt9uInFpkWCAUvkVRNyL9H6/tGD5a871i9l3XZzgEwXU+nHlSolvHZGjwfRMoAzv5o04x/tEYu7Ta0YvaGWR7wos8gscZjYO5FRx/SymhkQzQs8KebNbWsZnB0ZIrCKJ7YuLXTz1+RbacHnZvnB4z7FmpoSuHZmy33JaCSIl2KArTeXrwiWISsbvZyK57goyoHb1fkZok8JVLE8nx2WISRafhaP+xdhMLG9mCenxTB3qCnG/w/h1t9SkkLiKicFJVW5NQDzWosLl4/KuhNYxl/VVLckoc+qfmhGW4R74QFBETXYLz7ww/QkUo3Cba+sod8ZHWyXbiKRI4+2JnWYTIt3AE7WgR2zcd5N+2Uayv2u+/LXbAw4J5WGigQT5GYHDYuHftM4+ysLH322QXhvCo3fVjWWQ2sE32oRYoMTh8+SoQ63XiydkoSx0wXl4f4q0+rIeUt76EXFSIqSu+BUbt01Iw+v4FAKO9u2H6VUxAS1IZ35wI/hVW2vSSGWWyrZfo3P9GzUEh2fMxE+Djsge3oTRzMoCsMqccnX1jf/aSZROG0Yjhlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199015)(186003)(9686003)(38100700002)(122000001)(26005)(6506007)(83380400001)(2906002)(6512007)(33716001)(54906003)(71200400001)(966005)(76116006)(478600001)(41300700001)(5660300002)(8936002)(91956017)(6862004)(6486002)(66476007)(66946007)(8676002)(64756008)(4326008)(66556008)(316002)(66446008)(38070700005)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7jy/kzubouxAPu/eOtvMjrlKBPz/Ab932bHbY7nOoSU5I0J03wt9K+/o+gb7?=
 =?us-ascii?Q?4sytKOvqzCd5qzUlA27hm0H76yfYGhuGih7fJ5tEF3HvL1lhncGygcHvx1v7?=
 =?us-ascii?Q?IlGYfPxe6+qpwgbZbcsszgW5nwkTC6AFYn22JG5+UVaF6euYZDKXQyDjghfc?=
 =?us-ascii?Q?tKf9HhQPFD7S+wRLnp+fkfKk/jg1STOcCNrolrXCyoRzl7vVTn8+JJJe+2us?=
 =?us-ascii?Q?YqoY0elMxWH9rwcI5Se4F/W7+UMVNi3201oaMFFkXhXrhL2tKHMtRB+aaZHo?=
 =?us-ascii?Q?mZ0QEE/Igdo8eoS9/XpPXN4rfFdzJMJAXfsZD/lsdUxS/6Z71SXj9FIJjZXr?=
 =?us-ascii?Q?VTtoZwaZwnK0aGBLuN4YIE58xkt5qyJ8vh3xthY5PzzdZ8xEmCJVayoqw3wi?=
 =?us-ascii?Q?gaACE+LHseOfCWJViepuTbso5rKq/1Z9j1/gxKYto1okJfFxTq/tzHFpMLlg?=
 =?us-ascii?Q?7zrL4IIvSCW5GB+jkd/b7pOy2ZcuCQUuneq/9WXtInzjwog7A7n9rMroXYdB?=
 =?us-ascii?Q?FQMS+oLD3PAMlC3v14VLI3VpTLPgF3zxC1ERwXsmXjqkEp+owPn1RQzxu0zc?=
 =?us-ascii?Q?xYFnsdEgWoGgu4pvbwqete5bu3ifNErQkUVTfPdvXT01ZDIojswRWbNFfV7C?=
 =?us-ascii?Q?nhcwdUqMZr2z/v9eWO4RsEOBhwQpr1it58RakrrZWswF+XM5QSGTMeWONDVY?=
 =?us-ascii?Q?z7OoZfu8cJHmJz3e7ol4AIewE22FJZCCIvcGLEMw2ukxnXfElAiaOjcfoiWA?=
 =?us-ascii?Q?inYz8fPnSfaM3qQ4EW5tis+MTIsK9BCwA+Ct2bPLHahYzRtSM/k3P0TL428u?=
 =?us-ascii?Q?4TYTd6O88iVc9qOnMf3G62wIKyt7FO1HWMF3ms4fdEGh8v18i1A13nukznst?=
 =?us-ascii?Q?QGmyWOLPJ9An4Tyhc5+XmOlIBwaXx3j1q8I6bsG/95+rszOn4bZNHI7zLYxy?=
 =?us-ascii?Q?PqMaEoPbODQ1EruifegAj1NuORTqErZNDGWNiaQNEr4UicGGkfZUWOX8DycN?=
 =?us-ascii?Q?4oHPgrAQH3u1Br2Lku9/0ihmQHSx60kRs3XtnbghnK4M3JQPlo7jKNWl/wRC?=
 =?us-ascii?Q?+h+gjRc1mn8uXf88WEoQPoJlfZrJmnHGiGHHbvlioU/BT1MzsiEGSh8nnPs4?=
 =?us-ascii?Q?zt9endayN3dCuUVW2qqz/AdeXWgX6QYO1tQxP2p8M/wMlQrUHrhGjtT5q7FN?=
 =?us-ascii?Q?Bl35RCtfAzyaa0onT4pOcjEnxgRqH0jdy31Mf/9wkB1PheydNSduAwa+t88l?=
 =?us-ascii?Q?vGzwUKHT3ePoPqncbAQ25yDJuvhjxo0fAGncl0zdq8bse/JSqxAw4eAYwqqw?=
 =?us-ascii?Q?wwBWjuWQl3SaO/FEejZg9wTG7ngK+geGsn29/1Gb2W1oIpDMYw0DOrF3VIfJ?=
 =?us-ascii?Q?uSuiBOdG03bZKqTPX0pFKk/pSVuXyuHY0VlTEvWNYYBObUusxbuGDfQbqgtC?=
 =?us-ascii?Q?72hfWKrPe3tiC/njyL2GTYmIK8qx46GIrszRwWns0wlvy90DJ7JTrEFzqfyT?=
 =?us-ascii?Q?WAsGYTvfmKsKU+mdnwWitjKNt/lyYQ+GAgYaBAX0FopXDTjvlmmADkqFguS2?=
 =?us-ascii?Q?CTjJ0D0GKaYpBmAEM1nSp0iCdbZnaqRivUkSeM4AeWuP7gXfcqQOf8X4ONFP?=
 =?us-ascii?Q?UA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A7FC04D08A39142B31189F7D515B67C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d801dd5-7d35-4e7c-cf81-08dac1df0b8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2022 23:14:54.1548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qHrHLVKLEq1up0gASHbI80LrkS57ZgPlmSZ0tkLx4OLXuKW60XnrycLZJgQgiWaDBbZtSxeZY2Cd0P7p/oo50w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6929
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2022 at 12:50:44PM +0900, Damien Le Moal wrote:
> >>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> >>> index 4cb914103382..383a208f5f99 100644
> >>> --- a/drivers/ata/libata-scsi.c
> >>> +++ b/drivers/ata/libata-scsi.c
> >>> @@ -1736,6 +1736,26 @@ static int ata_scsi_translate(struct ata_devic=
e *dev, struct scsi_cmnd *cmd,
> >>>   	if (xlat_func(qc))
> >>>   		goto early_finish;
> >>> +	/*
> >>> +	 * scsi_queue_rq() will defer commands when in state SHOST_RECOVERY=
.
> >>> +	 *
> >>> +	 * When getting an error interrupt, ata_port_abort() will be called=
,
> >>> +	 * which ends up calling ata_qc_schedule_eh() on all QCs.
> >>> +	 *
> >>> +	 * ata_qc_schedule_eh() will call ata_eh_set_pending() and then cal=
l
> >>> +	 * blk_abort_request() on the given QC. blk_abort_request() will
> >>> +	 * asynchronously end up calling scsi_eh_scmd_add(), which will set
> >>> +	 * the state to SHOST_RECOVERY and wake up SCSI EH.
> >>> +	 *
> >>> +	 * In order to avoid requests from being issued to the device from =
the
> >>> +	 * time ata_eh_set_pending() is called, to the time scsi_eh_scmd_ad=
d()
> >>> +	 * sets the state to SHOST_RECOVERY, we defer requests here as well=
.
> >>> +	 */
> >>> +	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS))=
 {
> >>> +		rc =3D ATA_DEFER_LINK;
> >>> +		goto defer;
> >>
> >> Could we move this check earlier? I mean, we didn't need to have the q=
c
> >> alloc'ed and xlat'ed for this check to be done, right?
> >=20
> > Sure, we could put it in e.g. ata_scsi_queuecmd() or __ata_scsi_queuecm=
d().
> >=20
> >=20
> > Or, perhaps it is just time to accept that ATA EH is so interconnected =
with
> > SCSI EH, so the simplest thing is just to do:
> >=20
> > --- a/drivers/ata/libata-eh.c
> > +++ b/drivers/ata/libata-eh.c
> > @@ -913,6 +913,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
> > =20
> >         qc->flags |=3D ATA_QCFLAG_FAILED;
> >         ata_eh_set_pending(ap, 1);
> > +       scsi_host_set_state(ap->scsi_host, SHOST_RECOVERY);
>=20
> Why put this in this function ? Nothing in ata_qc_schedule_eh() calls
> scsi_schedule_eh() or scsi_eh_scmd_add(), which set that state.

It does, but after calling blk_abort_request(), we need to wait for
two different workqueues to run their work, before the SHOST_RECOVERY
state gets set:

blk_abort_request() -> kblockd_schedule_work(&req->q->timeout_work) ->
queue_work(kblockd_workqueue, work)

... -> blk_mq_timeout_work() -> blk_mq_handle_expired() ->
blk_mq_rq_timed_out() -> req->q->mq_ops->timeout() (scsi_timeout()) ->
scsi_abort_command() ->
queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);

... -> scmd_eh_abort_handler() -> scsi_eh_scmd_add() ->
scsi_host_set_state(shost, SHOST_RECOVERY)

After setting state to SHOST_RECOVERY, scsi_eh_scmd_add() will
call scsi_eh_inc_host_failed(), which will cause the while (true) loop
in scsi_error_handler() to proceed to perform SCSI EH, and eventually
call shost->transportt->eh_strategy_handler(shost) which for ATA is set
to ata_scsi_error().

Then we have the regular ATA side of things:
ata_scsi_error() -> ata_scsi_port_error_handler() ->
ap->ops->error_handler(ap) -> (for e.g. AHCI) ahci_error_handler() ->
sata_pmp_error_handler() -> ata_eh_autopsy() -> ata_eh_link_autopsy() ->
ata_eh_analyze_ncq_error(). (Where reading the NCQ error log in the
command that brings the device out of error state.)


Looking at this original commit, there are two ways for libata to trigger
SCSI EH:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D7b70fc039824bc7303e4007a5f758f832de56611

ata_qc_schedule_eh(): which is explained above. It indirectly schedules
SCSI with an associated QC.

ata_port_schedule_eh(): It directly schedules EH for @ap without an
associated qc. (I assume this is for e.g. an errors with the link,
where we get an error interrupt and need to read SError register.)


The commit message here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dee7863bc68fa6ad6fe7cfcc0e5ebe9efe0c0664e

"In short, SCSI host is not supposed to know about exceptions unrelated
to specific device or command.  Such exceptions should be handled by
transport layer proper.  However, the distinction is not essential to
ATA and libata is planning to depart from SCSI, so, for the time
being, libata will be using SCSI EH to handle such exceptions."

So it appears that this distinction is not important for libata.
Sure, if libata EH function ata_scsi_error() sees any commands in
host->eh_cmd_q, then we know that they timed out or aborted.
But ata_scsi_cmd_error_handler() will leave any QC alone that
has ATA_QCFLAG_FAILED flag set.
Those QCs will instead be processed by ata_scsi_port_error_handler()
which totally ignores the host->eh_cmd_q list supplied by SCSI EH,
and only looks at QCs with ATA_QCFLAG_FAILED set.


So it would be tempting to do something like:
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1001,8 +1001,7 @@ static int ata_do_link_abort(struct ata_port *ap, str=
uct ata_link *link)
                }
        }
=20
-       if (!nr_aborted)
-               ata_port_schedule_eh(ap);
+       ata_port_schedule_eh(ap);
=20
        return nr_aborted;


However, doing so would go against how this API is supposed to be used, see=
:
36fed4980529 ("[SCSI] libsas: cleanup spurious calls to scsi_schedule_eh")

I did decide to try it anyway, but it turns out both this and the previous
suggestion:

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -913,6 +913,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)

        qc->flags |=3D ATA_QCFLAG_FAILED;
        ata_eh_set_pending(ap, 1);
+       scsi_host_set_state(ap->scsi_host, SHOST_RECOVERY);


Both actually lead to two error interrupts.
(We should only have one.)

QEMU shows that this is from scsi_restart_operations(),
which temporary clears the SHOST_RECOVERY bit, then calls
scsi_run_host_queues().

Since we've reached this far, that must mean that in
#3  scsi_queue_rq

when the:
if (unlikely(scsi_host_in_recovery(shost))) {
check was done, we were not in recovery.

But from that time, to #0, we must have received an error irq,
because a:
(gdb) p /x scmd->device->host->shost_state
$9 =3D 0x5

which is SHOST_RECOVERY,


#0  __ata_scsi_queuecmd (scmd=3Dscmd@entry=3D0xffff8881016d7b88, dev=3D0xff=
ff888101e124c0) at drivers/ata/libata-scsi.c:4256
#1  0xffffffff819c1d8b in ata_scsi_queuecmd (shost=3D<optimized out>, cmd=
=3D0xffff8881016d7b88) at drivers/ata/libata-scsi.c:4337
#2  0xffffffff81995c41 in scsi_dispatch_cmd (cmd=3D0xffff8881016d7b88) at d=
rivers/scsi/scsi_lib.c:1516
#3  scsi_queue_rq (hctx=3D<optimized out>, bd=3D<optimized out>) at drivers=
/scsi/scsi_lib.c:1757
--Type <RET> for more, q to quit, c to continue without paging--
#4  0xffffffff81578a42 in blk_mq_dispatch_rq_list (hctx=3Dhctx@entry=3D0xff=
ff8881008e0000, list=3Dlist@entry=3D0xffffc90000367da0, nr_budgets=3D0, nr_=
budgets@entry=3D1) at block/blk-mq.c:2056
#5  0xffffffff8157ef1b in __blk_mq_do_dispatch_sched (hctx=3D0xffff8881008e=
0000) at block/blk-mq-sched.c:173
#6  blk_mq_do_dispatch_sched (hctx=3Dhctx@entry=3D0xffff8881008e0000) at bl=
ock/blk-mq-sched.c:187
#7  0xffffffff8157f238 in __blk_mq_sched_dispatch_requests (hctx=3Dhctx@ent=
ry=3D0xffff8881008e0000) at block/blk-mq-sched.c:313
#8  0xffffffff8157f2fb in blk_mq_sched_dispatch_requests (hctx=3Dhctx@entry=
=3D0xffff8881008e0000) at block/blk-mq-sched.c:339
#9  0xffffffff81573cc0 in __blk_mq_run_hw_queue (hctx=3D0xffff8881008e0000)=
 at block/blk-mq.c:2174
#10 0xffffffff8157546c in __blk_mq_delay_run_hw_queue (hctx=3D<optimized ou=
t>, async=3D<optimized out>, msecs=3Dmsecs@entry=3D0) at block/blk-mq.c:225=
0
#11 0xffffffff815756a6 in blk_mq_run_hw_queue (hctx=3D<optimized out>, asyn=
c=3Dasync@entry=3Dfalse) at block/blk-mq.c:2298
#12 0xffffffff81575990 in blk_mq_run_hw_queues (q=3D0xffff888102530000, asy=
nc=3Dasync@entry=3Dfalse) at block/blk-mq.c:2346
#13 0xffffffff8199221d in scsi_run_queue (q=3D<optimized out>) at drivers/s=
csi/scsi_lib.c:457
#14 0xffffffff81994ead in scsi_run_host_queues (shost=3Dshost@entry=3D0xfff=
f888101ca2000) at drivers/scsi/scsi_lib.c:475
#15 0xffffffff819918bf in scsi_restart_operations (shost=3D0xffff888101ca20=
00) at drivers/scsi/scsi_error.c:2134
#16 scsi_error_handler (data=3D0xffff888101ca2000) at drivers/scsi/scsi_err=
or.c:2327


So it appears that simply checking if SHOST_RECOVERY is set in
scsi_queue_rq() is not enough. Since this is done without holding
ap->lock (which is in libata..), we can always get an error irq.

So the only reliable way to ensure that we don't send down requests
while the drive is in error state, is to have a check against
ATA_PFLAG_EH_PENDING inside __ata_scsi_queuecmd(), while holding
the ap->lock.
Will send a V3 that is similar to V2, but with the check inside
__ata_scsi_queuecmd().


Kind regards,
Niklas=
