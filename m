Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA147C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 09:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiKIJ20 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiKIJ2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 04:28:24 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A285121258;
        Wed,  9 Nov 2022 01:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667986099; x=1699522099;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qTlD9WqBJ52SPA5ljhNN7Ac/zpHc49cH1/ko5CJvJEg=;
  b=AoCKV0f2cKGDhYylpVTgoHYOhkM2okHx9V3/dmo+G2EWY2PUL0LI+23F
   mNriex9iPSeXF7opvp9efCIJLo5oUT0vwWKWwKUQCJex1LYszPp2Ez62E
   UXVbG0POJaVqoNC0SeYOD87SkYc+eayO0Ss6UlmqH82474OZbT/DQtIUM
   QIO/Rq+FaSSzZUUfxyuHVurG1r9xgP8ColSWIVtyLIsjpEIGhd+0Vemtp
   PKqkJ6jpO+G7mFlbLULm7Mv4l0+M2YdpuLvBcMGP+JIu60sP7hBC+XyiB
   ocD08fp4bIHzN/d77BibYgTze6OC6S1pA6iQAs9OMOLHTndog6LSyriRR
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665417600"; 
   d="scan'208";a="221005897"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 17:28:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iguCDOEpIWsik+9OG3EnA+ghkhpurUu9W3sfB+MLxLF+Yuf5ku/Wzu3h04Xs+Q3Seqo6NKvk3iHe9SqVXP/4KWXajpAYUTS8NNUyYWn58W+lzUZmkbI1zoGhaSB4wQDyGRdWfejYNIKl7Znaz3hZv9VkhWqYnojKx0fNsys1Nar+NIjfPUAVzSTDjbjCw7NCWjXi7XpCsiowMr4/J/sYgzyJXfBG8JUEYbSMEIB0wVUKNwUl3qJ6fDdMmJ0ncZvi8kWIgqG/06BCIhe9QbdtrEqA3+qh68exk4W7ckXdBKiuKPFiBPQoAV/HFrUe7yA05/zrksF2abIayIckXoS1Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Np3jCeHsjXdz1tMq4aIcisX6pNlsFy39rleIYGoACTo=;
 b=aiTF/kZsM+SRM36lkpiO6QuVg5YqXeNcDi/MoaCuM5BSjbYgYTlPX8yHgNQjzuUMytTW1Xu95ZcFbd0VJ/qImSSQmOiM1OcdQS6/I5S/PNhRgafP42xrmosYV0bYR58E+d60ZU6iNrqiM+Kydyw09wD+EB4YPJ6gwmeSZPSoUS8/7HEXnvDSKmyHGGeasCgOCijSwnPfYhF/UOIeGzRoVyhkq6+jl8Y7DWlgum7Tu1H6n/e+84B6sdKlBV15YPso8pegZfrNQwEdAufvZ+IL48vDVJzk6LjSGZyxZTp5ueL+oAhdMehQc1gVFpY08efLOMp3pbb80XSbYRA8pYO8Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Np3jCeHsjXdz1tMq4aIcisX6pNlsFy39rleIYGoACTo=;
 b=IIk9z+3uXYhq7VAYQ6fPMggAI69/zMY9AzF9mnlj+ur1tyqm4DN2iFfx0pd+xD1oIlZ8JD5JUK7fZiDzeyLlD7HtUFlkDpR8BWBY6hf1owBeAnmQpLsfzmfglpsmVGlhlfPSemsy535satFPpw36SGQWVk7OvfkA+uPbS+la/fU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB7840.namprd04.prod.outlook.com (2603:10b6:a03:3ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 09:28:13 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8%7]) with mapi id 15.20.5791.022; Wed, 9 Nov 2022
 09:28:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
Thread-Topic: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
Thread-Index: AQHY8sN+Uw8brLy8kkmVlm0qWKEegK4zr72AgAB0EoCAAEE4AIABRUEAgACFHICAACY/AA==
Date:   Wed, 9 Nov 2022 09:28:12 +0000
Message-ID: <Y2tyqn+VAVfL+muq@x1-carbon>
References: <20221107161036.670237-1-niklas.cassel@wdc.com>
 <5a4fa5db-c706-5cf2-1145-bf091445d20e@oracle.com>
 <Y2mbX8MvYrF0FHaI@x1-carbon>
 <976bdcb7-cb97-9332-2bcc-5d98bc41871b@opensource.wdc.com>
 <Y2ri7EVPZb2O9iD8@x1-carbon> <c0a34e41-17ca-cbc1-cf54-9fee23b830a3@suse.de>
In-Reply-To: <c0a34e41-17ca-cbc1-cf54-9fee23b830a3@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB7840:EE_
x-ms-office365-filtering-correlation-id: ade1162d-be4c-4ed5-fbf1-08dac234b905
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EXuxmPGmCBTY5wXR0/bD7y2OsZhcf4zBUx+uhrpwqNlUmggNFPNy9XagfPqQ/SHHRB0Rv+JBkQbL1vnyY0VyZ9JE5BxAqFfWGtBbly6vZfwj5Bf2YkMjbS+fYcSQrxEg9FLDDlDPNMUK7B32PTh+D6rTizPUuVFlxSMJgka19DXh0sEYwBoJiNdVnUw8hMm/VcIA9U6m/FmOkXXhlTg0YmlNdU28qbb+oB6TYE5tRtZ1GEcyTOYvDxQ+javuO5DI7/CsgfqFkra7/DoT0Ls0Bntrf4qteW7eY1Rd1KNhhiY+7+UckZ5fQHUHLFWCVsQXX5BbXUxjTR98tu379H8KbCTwKI5eRpliH+1YvryKsNQBTp2m+B4Tz/tMGXp/W/Mk4gavNdkwI0vCCKzk6vOcUzpsLC+6OTpvFMkkZiuzglzu2o2eakuumeVby38onNpi0qqS/ItU+p+AQxz9xdqJnuD7GiIa6bxSoQHbmPzBvWUIAr+SCySiFx1YUpQP7uUnhdcn8+cFHLqYCeG6s+gl+mvikZ970yGoWRfgPVVyiMThvoThh7//R0uNl5qf9XcKdvCCZBsxlSZNs7kbLAVCA/uNOjFRnOzB+QB1ScAUZo2LuraEftCdWWTD0F3l2XqTNbahOhvhi/PufMzifaJnNYNCLxiGU13CzSdqVoDOSxOQS7Lui7ZQK2j0DpwlaM5l8HUbU0vrvCSjo9YzywMsa/spdnAVowI6xVXkzzKYkn9oxTgKFytWO2o0J7NOfQG9kPfcGs11qRJ92rrCMQOPLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(76116006)(91956017)(316002)(66476007)(64756008)(66446008)(66556008)(6486002)(66946007)(38070700005)(478600001)(8936002)(71200400001)(4326008)(5660300002)(54906003)(6916009)(41300700001)(2906002)(83380400001)(8676002)(6506007)(122000001)(86362001)(9686003)(26005)(82960400001)(6512007)(186003)(38100700002)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?z97a/vwEH2bssZz+way+8rwhEbcp+e/ihIr1ZDm37llZsnSlNn+3be8heERP?=
 =?us-ascii?Q?cm2QlJukAUOheEibU06MQXfu/JRcIFtslZ9KWlnshYWyq/O5W5DpRH+tjM0e?=
 =?us-ascii?Q?PVW89MJNRIb+fcEEOaaobsrMlOoGK6BW1ug8zONjscvhdb4OmCO1Ue5JECf4?=
 =?us-ascii?Q?scLCIwatDfREWyC03bADD1kGEub3eOdi6IDQYte+g43Tqdwf5ciSWQvbRhi0?=
 =?us-ascii?Q?yeIzFDu06dRqtf/IOlyrDzRKM9j+HBJ5KEjrEU4mr4vIGJW54irxyAQwzUiW?=
 =?us-ascii?Q?uoyqRJfkP84KrA76QuZv6xkOxsQwG3GDxdbCYAtIiDOYZa8HZlc+YZ2bS3xW?=
 =?us-ascii?Q?LOLsfjqfSloX8kvs6kmravkIqOEv8Zz21x5jOb66HljfFhLGxwGHl4ljiJ8t?=
 =?us-ascii?Q?BSwdaSyZ0pyFcpe7/x+7ujDqZud/7krQgW+bFxbqBewrxOUBSwvIPwMNi6MH?=
 =?us-ascii?Q?hYpUOZ9U7m76icfOoUeB4Fgc+bqqrZGo03JBFUksR9Du1b38FZeiwWpIXs/j?=
 =?us-ascii?Q?oaFt7S0ydmi7ISHFpn+lyDX2uJNooLrvfngCTYkC3XfbWE5qawYiO2ssCo1l?=
 =?us-ascii?Q?3qcVJNqzJH15aEuqqiq5wf8nS1f8VfrylOG8DHsQpL0eXzTvaYRdCMaW9CRl?=
 =?us-ascii?Q?Kn5vCmeuRwYC0VFfVV8Gc6468onnZX73B/by3z6O3q+M3EMRi/Q3TBcRLbBC?=
 =?us-ascii?Q?rf87S37gvky9LJc3K+I4smP+r2QsvKWAAaydZRjOyqt1sJnBJTh4Q2Y9unpY?=
 =?us-ascii?Q?x7RO+EheTb7MEHKfNVR96TyYd7CE5Ix4RhscT7tgJz2rtaMyc2HM1dv/ThVt?=
 =?us-ascii?Q?qWFUVMnbmaq81WQaiFyHLui7aA0OdMo88Fb+WufiVtqCj1kcP0hrUbt+Hzq/?=
 =?us-ascii?Q?u7GAFExEkkAkgkpAFBUowQxFT5G3LMG79M1Xsp5OEgGbUAEQ6qwRGeoBAVUZ?=
 =?us-ascii?Q?BKvTPBiO5o8HsGiTKpLG5mia8DbAguWPvfqOr/EHcBvpquWKLp9+nhWeC+L6?=
 =?us-ascii?Q?NqtiZYEc/5VFKRiTf1s0bzGWOIQ3k1Z+tUn0BNakQNllJJef95LfJ2Zu6dU4?=
 =?us-ascii?Q?t7GKOm/5t1ml/OtbArXbbB5AGNQa7kGqcVSx1K8UbDT7TLP2toXQ4JhMUv4l?=
 =?us-ascii?Q?8n4j6YD8M+MdlblHfZjIMj9TjlvP7rLpH5nsMedcccw3dg+IKWaKgzfzod2u?=
 =?us-ascii?Q?83YIOdN+9B2uldfC/Akz3/359L3MZDmaYxebhCNtbIc/0tG9FHlZmKn9k8YW?=
 =?us-ascii?Q?WyL881dEpFzKWBiD2ZenWLWDKJjAR3vFlN4mz2jpy248uRvGMPn3t/njk2Re?=
 =?us-ascii?Q?3j0euUi+/iKtdQvLxHnDcJ8Kgtipa/nU+O5+O4L0Fk34YHBRGXHCUu7CXdEj?=
 =?us-ascii?Q?bmVJn1oH83PxfsWtEw5XIsoQuZCXsbscMWbsv6wtIOxnAnGJEybiqSyOJUXD?=
 =?us-ascii?Q?npMGDjEvmtrY68EgsZSYZ14PTbTcRl5JJqxKGFI9Zir1/uHzmDacGzzZXiMd?=
 =?us-ascii?Q?kRc5SvsOFaRhxL90G2gOpe9ZhnbHi3O2RdgsqIKdOim8+XOi5oe172TYze7T?=
 =?us-ascii?Q?WboYrvuGP3nF9gfxYsBnU980WFylwOg/Wusqo6zeZBu6JrYWA8LcEHsp+bTw?=
 =?us-ascii?Q?Uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85DB5C363807564793C2EC5EC5C10F5A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade1162d-be4c-4ed5-fbf1-08dac234b905
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 09:28:12.4142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ifccT/P8CZ7jw98pFhxp6TcgtsRWdGIAJkBkhq0LRHYYef4sqVr6uoc8i4kO+201UOZDuxUuqCeSefCK9LCXHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7840
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2022 at 08:11:17AM +0100, Hannes Reinecke wrote:
> Thanks for the detailed explanation, Niklas.
>=20
> However, one fundamental thing is still unresolved:
> I've switched SCSI EH to do asynchronous aborts with commit e494f6a72839
> ("[SCSI] improved eh timeout handler"); since then commands will be abort=
ed
> without invoking SCSI EH.
>=20
> This goes _fundamentally_ against libata's .eh_strategy (as it's never
> invoked), and as such libata _cannot_ use command aborts.
> Which typically wouldn't matter as ATA doesn't have command aborts, and
> realistically any error is causing the NCQ queue to be drained.
>=20
> So SCSI EH scsi_abort_command() really shouldn't queue a workqueue item, =
as
> it'll never be able to do anything meaningful.
>=20
> You need this patch:
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index be2a70c5ac6d..4fb72b73871e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>                 return FAILED;
>         }
>=20
> +       if (!hostt->eh_abort_handler) {
> +               /* No abort handler, fail command directly */
> +               return FAILED;
> +       }
> +
>         spin_lock_irqsave(shost->host_lock, flags);
>         if (shost->eh_deadline !=3D -1 && !shost->last_reset)
>                 shost->last_reset =3D jiffies;
>=20
> to avoid having libata trying to queue a (pointless) abort workqueue item=
,
> and get rid of the various workqueue thingies you mentioned above.
>=20
> And it's a sensible fix anyway, will be sending it as a separate patch.

Hello Hannes,

This is how it looks before your patch:
scsi_logging_level -s -E 7

[   33.737069] sd 0:0:0:0: [sda] tag#0 abort scheduled
[   33.738812] sd 0:0:0:0: [sda] tag#3 abort scheduled
[   33.749085] sd 0:0:0:0: [sda] tag#0 aborting command
[   33.751393] sd 0:0:0:0: [sda] tag#0 cmd abort failed
[   33.753541] sd 0:0:0:0: [sda] tag#3 aborting command
[   33.755565] sd 0:0:0:0: [sda] tag#3 cmd abort failed
[   33.763051] scsi host0: Waking error handler thread
[   33.765727] scsi host0: scsi_eh_0: waking up 0/2/2
[   33.768815] ata1.00: exception Emask 0x0 SAct 0x9 SErr 0x0 action 0x0
[   33.772211] ata1.00: irq_stat 0x40000000
[   33.774187] ata1.00: failed command: WRITE FPDMA QUEUED
[   33.776962] ata1.00: cmd 61/00:00:00:00:0f/01:00:00:00:00/40 tag 0 ncq d=
ma 131072 out
[   33.776962]          res 43/04:00:00:00:00/00:00:00:00:00/00 Emask 0x400=
 (NCQ error) <F>
[   33.783598] ata1.00: status: { DRDY SENSE ERR }
[   33.785252] ata1.00: error: { ABRT }
[   33.791290] ata1.00: configured for UDMA/100
[   33.792195] sd 0:0:0:0: [sda] tag#0 scsi_eh_0: flush finish cmd
[   33.793426] sd 0:0:0:0: [sda] tag#3 scsi_eh_0: flush finish cmd
[   33.794653] ata1: EH complete

So we do get the scmd:s sent to ATA EH (strategy_handler).

In scmd_eh_abort_handler(), scsi_try_to_abort_cmd() will return FAILED
since hostt->eh_abort_handler is not implemented for libata, so
scmd_eh_abort_handler() will do goto out; which calls scsi_eh_scmd_add().


This is how it looks after your patch:
scsi_logging_level -s -E 7

[  223.417749] scsi host0: Waking error handler thread
[  223.419782] scsi host0: scsi_eh_0: waking up 0/2/2
[  223.423101] ata1.00: exception Emask 0x0 SAct 0x80002 SErr 0x0 action 0x=
0
[  223.425362] ata1.00: irq_stat 0x40000008
[  223.426778] ata1.00: failed command: WRITE FPDMA QUEUED
[  223.428925] ata1.00: cmd 61/00:08:00:00:0f/01:00:00:00:00/40 tag 1 ncq d=
ma 131072 out
[  223.428925]          res 43/04:00:00:00:00/00:00:00:00:00/00 Emask 0x400=
 (NCQ error) <F>
[  223.436077] ata1.00: status: { DRDY SENSE ERR }
[  223.438015] ata1.00: error: { ABRT }
[  223.441179] ata1.00: Security Log not supported
[  223.445698] ata1.00: Security Log not supported
[  223.448475] ata1.00: configured for UDMA/100
[  223.449790] sd 0:0:0:0: [sda] tag#1 scsi_eh_0: flush finish cmd
[  223.451063] sd 0:0:0:0: [sda] tag#19 scsi_eh_0: flush finish cmd
[  223.452648] ata1: EH complete

So your patch looks good to me, like you said, it removes a
a pointless queue_work().

Do we perhaps want to remove the !hostt->eh_abort_handler check
from scmd_eh_abort_handler(), now when you've moved it earlier
(to scsi_abort_command()) ? Perhaps we need to keep it, since
the function used for checking this, scsi_try_to_abort_cmd()
is used in other places as well.


Kind regards,
Niklas=
