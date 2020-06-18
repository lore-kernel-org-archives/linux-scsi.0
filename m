Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDF5C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 08:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF4DF2186A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 08:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="pwZ2UU4L";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="pAVduhht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgFRIgf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:36:35 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:21055 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgFRIgd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 04:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592469392; x=1624005392;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XwSLiLiG85WCJ7CQnL69BqW1sY819O2xIHcp/GcxutY=;
  b=pwZ2UU4LjippvaVPsEXcc2usU6atJNiM+Kn7G1L3k4+98o34cJ7MwgKP
   VXQTt9fWQ/Rt4qGbpJKgY6NNixvgamBgoy/1OXK9vQp70rkOBP6ha6yBR
   NjNh12yMHvaFqR3XSzxOtUEXKSdvHtMOQHvlpW+sJrB9wwHNYu+IrwMox
   uN7ZpCcCv4uiknkLmZCZk9bAwsbr+JyLm1CuqPy17F0lYv2bByI4RutAA
   Xn3y8ZIfYkVckmMzsjS3nJx+7gj4WXvUKswA1enLhqXChHGMCtqv22j+q
   LaztxXOhIFs+zGwqWz9FdoZJCT08mT2tSnQBjWUTDC4/ebIkyyJr8tKNn
   w==;
IronPort-SDR: YX4xKGD5wCErJqsZPthEppAmnjqt9gXe8NA5PYoxHR/d52vDwiop3ViignY1CDWBsiJDsXzkgw
 LQTC9v50hT946gjpBf1wyZAY0pPJS8CR530qd21zAb9UF36YI+hDkNkHS7B5Z08V849KskKzp8
 M/MhVPPGn/IQk4hvuinPf0RY+AkH7rfk5qM/kFg8ICXJpyZP69Ao68yo28tchj6ecYul6x/oLy
 /nBtuYnX5wwUvb4zg2zlMaUIuiJkYkYIawR5CxjfkNc8dfLlbfMva++hs+Q1c4X+yGcKFIAox1
 GRM=
X-IronPort-AV: E=Sophos;i="5.73,526,1583164800"; 
   d="scan'208";a="140304258"
Received: from mail-co1nam04lp2050.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.50])
  by ob1.hgst.iphmx.com with ESMTP; 18 Jun 2020 16:36:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLa58nEWPttQFaRDubpfg47MME7lE62pSUsnzE6nzFkAm2NtY+OK10NNxxZeUn86nfvMeXgSE4mwsmnwt53GBonM62UDCkC2dn4th+1yWadRTM0/66MUiF/lvD0nEzTLhVOpvTFSVjJEXPw48KUP6x5eA1JEUB8xl98V8TUD44HIFYO5GTfyM2/KFIVrgkYDXCwMNEQBFgteRgNTNrdqdpMsNnFOBRr9D7h/6uBbDU4l86jSayq15yi31GRrptkrCC/sdj702WhrPTaNUZ6AiqW93JZ9N7RsTrZOtTo3NZINKOp6sxhM+AAqHzQsE9SIyPpcldeUOTQpkCM8hh9vZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ob1IKFGwR14XdvrJzTK5pBPfkM5mVkjR50O5aDl/4xM=;
 b=jrTiWunrSlXAIGQxORg4B6DHuKPyAJJqOKQggQ97k9zuT42/KbzURdBpKlCKUA0iq52yVAo1mUMmR7BpPMkUCrvINZ5cUvKfxhy7/IRHL1z50eTc29uoHLPiw9glw/imkV6Ogu4/WR2mHcQNK9Ez8MYk1TBS/Hlh+6v3oai2CKbK9BFXaITPnuFCRJ8kLTFGhY/AefVYcFg9myxSWiWHRK1CtTjSxAht0p13VWAn45rQUNhiKbpuSah1KWNDLLAq/5LnxCRpJCbfeB3s0DlqTHOu24O++n0YrT4AZmcEiHryLWB1D1sp9PJyypCqTTEflMNRflQKlKk94Lg2uZpfHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ob1IKFGwR14XdvrJzTK5pBPfkM5mVkjR50O5aDl/4xM=;
 b=pAVduhhtbE8hb/Z7Djgd8Ny8My/fBwiNms0YdEZlfpX7u9foY2hFFfGqeKMQlp6L7dgZWugw9pxLg64cjX9+9wPXSI6vDFdblh+EYkUxG6b4s64BtJpHBosDNZOFHKpgRc5L8pSDWPNF7KknfMbbPH+t3onaH/78aqTOzjr5BF4=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1254.namprd04.prod.outlook.com (2603:10b6:910:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Thu, 18 Jun
 2020 08:36:20 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3088.028; Thu, 18 Jun 2020
 08:36:20 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Thread-Topic: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Thread-Index: AQHWRNgorE8Ue5/pcEOqVFi0S2b5Lw==
Date:   Thu, 18 Jun 2020 08:36:20 +0000
Message-ID: <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: octiron.net; dkim=none (message not signed)
 header.d=none;octiron.net; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.47.7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3f62fd0-fece-490b-d016-08d81362ad58
x-ms-traffictypediagnostic: CY4PR04MB1254:
x-microsoft-antispam-prvs: <CY4PR04MB125452107F80DDD9E3314288E79B0@CY4PR04MB1254.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4NICvW+E+rssvM26UUcmXjfOfLYS7qvwJAHx73WL549+gsMNi8PIVWUi+k/uAPdXGcNwtHjPPIdFI2VVPMsR3H9AM7iYKU1GTVytTIcp291mPXVE+uBb9t2ZtsleDm+o372qDYvrXxsw1how+7njqWXPjN5nDIw7QaazQLdSAfS2tQ1tn7rYu9NbP4C9QpiO64eUBT2wmLOIowXCUui8Kfmc4XCpV3KZKhDP7piNWRNMty3V14PHWhm/mHcLjuI1T56CkRaH+UslK0PbHX3rM66tU1K+EAu3BFb6R7oLrxB6/0B99ffaXJf4KJpff2QzZ9ZXwmp+T2+cGOfhUMnstg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(7696005)(52536014)(53546011)(6506007)(9686003)(83380400001)(86362001)(55016002)(8676002)(26005)(5660300002)(186003)(66446008)(66476007)(8936002)(64756008)(66556008)(66946007)(76116006)(71200400001)(478600001)(91956017)(33656002)(110136005)(2906002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TNhVn/gBAs7SwaZ3Qkfxf+7AtJMiAJaJayv1jnfbqPD6de24kPB3RPiHJuoo+vofaTFyrNXz8zxsyOtcSZg4JxdsdHviuQf8zU0SjJJwNrwxnM48VlDmHX7IGDA46YHtNedHlv8lfsh6YKuvHuDvtYs4sDZE9MOdOI3wtYtHUYFbs6EJVrhUFTtU8dHBJZh35HnsyV5u0Kt+xPBT8wnIipDJQr5AkatGIiTZRqA7vuOp3mMJOWrbLRY1vkhOA4PqPQf+gFrh5ZkB+nK2koxyCcC6FtHZI7XpMPbYe0NzLSzknwTO2ygh0F5Svn7hhOjD6NT+kWdVm2/KRzj8FjRvnRzGXoCysbSrOPHhDZSUafOFEXkxzw4Ci0dKhTuQnw3ScVZtfx13Ohshtra2/s9T/hspX4uZLFqkwWJ6NGLO6aUDAS9HE79OGARS/CyEd4wb2iMgkSLAu6ty+SMJkcoTfDnm7F1i4T4yti1cJRAjh1I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f62fd0-fece-490b-d016-08d81362ad58
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 08:36:20.6797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qa4u+YYyjghVi+cGisxluOsZZzElD+32Wlz1ixoWkFssvCwgnP3OwV0vEBN3YNUfin78Si3lC+pSrPwPGkhUZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1254
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/18 3:50, Simon Arlott wrote:=0A=
> I need to use "reboot=3Dp" on my desktop because one of the PCIe devices=
=0A=
> does not appear after a warm boot. This results in a very cold boot=0A=
> because the BIOS turns the PSU off and on.=0A=
> =0A=
> The scsi sd shutdown process does not send a stop command to disks=0A=
> before the reboot happens (stop commands are only sent for a shutdown).=
=0A=
> =0A=
> The result is that all of my SSDs experience a sudden power loss on=0A=
> every reboot, which is undesirable behaviour. These events are recorded=
=0A=
> in the SMART attributes.=0A=
=0A=
Why is it undesirable for an SSD ? The sequence you are describing is not=
=0A=
different from doing "shutdown -h now" and then pressing down the power but=
ton=0A=
again immediately after power is cut...=0A=
Are you experiencing data loss or corruption ? If yes, since a clean reboot=
 or=0A=
shutdown issues a synchronize cache to all devices, a corruption would mean=
 that=0A=
your SSD is probably not correctly processing flush cache commands.=0A=
=0A=
> Avoiding a stop of the disk on a reboot is appropriate for HDDs because=
=0A=
> they're likely to continue to be powered (and should not be told to spin=
=0A=
> down only to spin up again) but the default behaviour for SSDs should=0A=
> be changed to stop them before the reboot.=0A=
=0A=
If your BIOS turns the PSU down and up, then the HDDs too will lose power..=
. The=0A=
difference will be that the disks will still be spinning from inertia on th=
e=0A=
power up, and so the HDD spin up processing will be faster than for a pure =
cold=0A=
boot sequence.=0A=
=0A=
> =0A=
> Add a "stop_before_reboot" module parameter that can be used to control=
=0A=
> the shutdown behaviour of disks before a reboot. The default will be=0A=
> to stop non-rotational disks (SSDs) only, but it can be configured to=0A=
> stop all disks if it is known that power will be lost completely on a=0A=
> reboot.=0A=
> =0A=
>   sd_mod.stop_before_reboot=3D<integer>=0A=
>     0 =3D never=0A=
>     1 =3D non-rotational disks only (default)=0A=
>     2 =3D all disks=0A=
> =0A=
> The behaviour on shutdown is unchanged: all disks are unconditionally=0A=
> stopped.=0A=
> =0A=
> The disk I/O will be mostly quiescent at reboot time (and there is a=0A=
> sync first) but this should be added to stable kernels to protect all=0A=
> SSDs from unexpected power loss during a reboot by default. There is=0A=
> the potential for an unexpected power loss to corrupt data depending=0A=
> on the SSD model/firmware.=0A=
> =0A=
> Cc: stable@vger.kernel.org=0A=
> Signed-off-by: Simon Arlott <simon@octiron.net>=0A=
> ---=0A=
>  Documentation/scsi/scsi-parameters.rst |  7 +++++++=0A=
>  drivers/scsi/sd.c                      | 22 +++++++++++++++++++---=0A=
>  2 files changed, 26 insertions(+), 3 deletions(-)=0A=
> =0A=
> diff --git a/Documentation/scsi/scsi-parameters.rst b/Documentation/scsi/=
scsi-parameters.rst=0A=
> index 9aba897c97ac..fd64d0d43861 100644=0A=
> --- a/Documentation/scsi/scsi-parameters.rst=0A=
> +++ b/Documentation/scsi/scsi-parameters.rst=0A=
> @@ -101,6 +101,13 @@ parameters may be changed at runtime by the command=
=0A=
>  			allowing boot to proceed.  none ignores them, expecting=0A=
>  			user space to do the scan.=0A=
>  =0A=
> +	sd_mod.stop_before_reboot=3D=0A=
> +			[SCSI] configure stop action for disks before a reboot=0A=
> +			Format: <integer>=0A=
> +			0 =3D never=0A=
> +			1 =3D non-rotational disks only (default)=0A=
> +			2 =3D all disks> +=0A=
>  	sim710=3D		[SCSI,HW]=0A=
>  			See header of drivers/scsi/sim710.c.=0A=
>  =0A=
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c=0A=
> index d90fefffe31b..1cd652e037ab 100644=0A=
> --- a/drivers/scsi/sd.c=0A=
> +++ b/drivers/scsi/sd.c=0A=
> @@ -98,6 +98,12 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);=0A=
>  MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);=0A=
>  MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);=0A=
>  =0A=
> +static unsigned int stop_before_reboot =3D 1;=0A=
> +=0A=
> +module_param(stop_before_reboot, uint, 0644);=0A=
> +MODULE_PARM_DESC(stop_before_reboot,=0A=
> +		 "stop disks before reboot (1=3Dnon-rotational, 2=3Dall)");=0A=
> +=0A=
>  #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)=0A=
>  #define SD_MINORS	16=0A=
>  #else=0A=
> @@ -3576,9 +3582,19 @@ static void sd_shutdown(struct device *dev)=0A=
>  		sd_sync_cache(sdkp, NULL);=0A=
>  	}=0A=
>  =0A=
> -	if (system_state !=3D SYSTEM_RESTART && sdkp->device->manage_start_stop=
) {=0A=
> -		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");=0A=
> -		sd_start_stop_device(sdkp, 0);=0A=
> +	if (sdkp->device->manage_start_stop) {=0A=
> +		bool stop_disk =3D (system_state !=3D SYSTEM_RESTART);=0A=
> +=0A=
> +		if (stop_before_reboot > 1) { /* stop all disks */=0A=
> +			stop_disk =3D true;=0A=
> +		} else if (stop_before_reboot) { /* non-rotational only */=0A=
> +			stop_disk |=3D blk_queue_nonrot(sdkp->disk->queue);=0A=
> +		}> +=0A=
> +		if (stop_disk) {=0A=
> +			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");=0A=
> +			sd_start_stop_device(sdkp, 0);=0A=
> +		}=0A=
>  	}=0A=
>  }=0A=
>  =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
