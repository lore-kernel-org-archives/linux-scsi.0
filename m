Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17AF4C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE8A96138B
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 03:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhJEDgq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 23:36:46 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42060 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJEDgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 23:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633404893; x=1664940893;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=d1SrQQLQj6dUS35+B8Uilc0uB4xIcz9Q8NAiaWgo3Hk=;
  b=Aim2bpXaADSg+p2nNsliHKZnHduYKhu1zxHHdlZeV9ZcKPl4fYiIXigI
   mgCYWYOiBUsjyiBQM/RSkIVyGOLSlrSrkpzIJnZbGR8IdtAoykqtYIPdR
   tiHJNaNNn6rfL5mfNxdA0Hc4V2TtC+Ggmzr1vT4GHHoeokh9/mLQMkIsn
   +X9hpdhdPfWs1edTnFBi1jj6B9ouvXu7jGs7JDsNW4NNIYLqEt43slGGS
   TJEa08HnavzoApKFr8pGIbD4wMebcU3JggtqA7AZS1SPbbWzF9MT8Hmkx
   EnTFSfcqZ2zxgydAMIJPy7YfT1h3jlWLk/d+A/v2IhZxudljo6h7C5WCx
   g==;
X-IronPort-AV: E=Sophos;i="5.85,347,1624291200"; 
   d="scan'208";a="293544293"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2021 11:34:48 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBCg/GVEI+F8PFvvPrVbFXFRv3e7a3PlD7ZZu5E6MdZvsLYJclcb3G1qx1BH9A1yZGCRpBpPiIGG1CF4y/lk9z55JHLbqd8t4Qk/YMsQcvm2cbdMbk52YVOoUVBNSeZcT5QBH1+/w8+LxUAQbm3Kv7m/WCipX4dixxySMLciBxFFJYS+b2gWfyrrJ4+yx53cSXCfHEi3Tf0eu++MnlPOO+I8BEdvBrXLIgVL+gJn/ySRmwHYKYHg20P6FphpNIhiqqI1XE2+CfR5nBD5BU9dhRMquK7HSfaK/vNBOinYyInfCNTYhJnk2geUv3TApH6mEZ6vIDpAd5VYhgGu9OpV8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NEzY+tYBSeNMc7B2o5syueY0RrJzFYaGVNZprYVPEG4=;
 b=jXJx723WUXb9eUahhA6cl10YW8It3r+udVLfNE2Tfnu00GMvGM1Vv50icAYAMcHzeTYbVp7rIrWx1aVoCXWie2daG4UjaKKO1vAUgycbiIef9+zDIBeJrwwPPr7TtLcfw97DXNjCyr6c8pYafWqTJKY46p48u96T/4KJlN36Fb97vmEUVsVRAuZS7Jh7KSA2oR0t/fWTVy6Kb7W7PjK3qvrVAAgTjSP3/AVG7qM/smZ/1fJqkDecFY/bBw7cvoOOsB8hJkFYXrsl3Wji2iRpjqDuDuN0OWOHdIr63CFHtQsT3b5ZJknTWv2bpgWW0skIm3j8Y8TbW5xhn8DvgCwKOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEzY+tYBSeNMc7B2o5syueY0RrJzFYaGVNZprYVPEG4=;
 b=NYQueKB5dFCl8Jby/OGSs2p+Yt6MkKwtQVNK5dPMYa/Nl31H81RA2T4qX/8CUxDy9DTOrKHQbmdW9GxHApAnsXmOITpKFaIS1wymSpS/iKNJ2ZK4mSOVL2DGNcfRR7iCGmAfqFSzJVrpesvpugcC8Tfc6F2U8L4NCyGblV/FuMY=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB4345.namprd04.prod.outlook.com (2603:10b6:5:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 03:34:46 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::7c0e:3e95:80d3:7a70%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 03:34:46 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v21 45/46] sg: add statistics similar to st
Thread-Topic: [PATCH v21 45/46] sg: add statistics similar to st
Thread-Index: AQHXuHUcRWmzqvw/6kGdkzobzy88Bw==
Date:   Tue, 5 Oct 2021 03:34:45 +0000
Message-ID: <DM6PR04MB70816AE786BA1DC87B589C19E7AF9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20211003163151.585349-1-dgilbert@interlog.com>
 <20211003163151.585349-46-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4863d1f5-dfd3-4c68-c39b-08d987b113c9
x-ms-traffictypediagnostic: DM6PR04MB4345:
x-microsoft-antispam-prvs: <DM6PR04MB43452CF8C62B575061F14410E7AF9@DM6PR04MB4345.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kjOUWI22ej/jFx2NY6TlxjfuQ2kIV2Bi2I7uiAflEWY+HMA5UoRywwgx370BlKsGnxIFe8qDlbNUUODjgWKg6wbf0jxdmTwBjk75ISIeCQmtq7VrCh9OLPidJE0KSqlZeTh0fpIsTnQa2vIBlSpP93jnZ6Vq5Wh41TEohEqnk9893kIDnRNgLWNkJmGUUMDGdS3Nyz3oMcHNbq2dhtEBmsi372JnZ7bLbGPAtFAegiHlu2RVrUHLwJO4Oo1FGPn43UK4hoh4nGcdD8+rSoVtHtemkKEgEx6hyvbhelv/U67X4tmTEyNZkfNjV/118K4D29Ssi08O9CAS6V5rtT/k1BYYFnG0+jKatfXEhPKFUu0BenGQQwEnypUfeqblVc/lEVh2hxB6m2QEATLasGkd+3ZgkpXpgBNkzJJKZcXt8jzK8avexomtZOr0snSGwV+dZGjkyXQWgMHbUli7JBUM/lEt1h5Vlqu0uSRU7DDR6LfGXML73CKpv7bu6U8yYZdy8vcMHKUxeHJHhIbwlJCeKStJFJHHtQ0ebrM9gn6k7SkS4rqTH7w2IX0MR8cg+Zlg/fLg+yYFv5wdateew4uGAXYSwmwlQq2GwJBXwGPME9+8quxk6y+vSDAVW2q1MUK/HffxA8Pt8bpCM5DYKQ+HZt9vYcNAeMsbtCWdLJrcc+DK2ssMXVBG2N8oFR12wkGGBOqiSk7yZaIs/ic8YEZ+MQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(86362001)(4326008)(2906002)(6506007)(66946007)(38070700005)(7696005)(66446008)(66476007)(64756008)(66556008)(55016002)(9686003)(91956017)(76116006)(26005)(52536014)(122000001)(508600001)(83380400001)(71200400001)(38100700002)(33656002)(110136005)(8936002)(5660300002)(30864003)(8676002)(316002)(186003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NvzxVyQbwlSU9ofaNsjXiAXQhMnuRVydkdCGiUIJO5Yi1Hi3L2tu3Rf9PvUc?=
 =?us-ascii?Q?UIBzHb7sSC7ESE4qpyJLQKLpPBJf04H4bJCfYKmX2rFBoiJ+GfKa1yJcUsZf?=
 =?us-ascii?Q?iqUuCJ/ExqwmqhnEaPkUArnw8r8FK+//KI4mXEPxWb3NXKDjVFHusJLgTj2C?=
 =?us-ascii?Q?j6MO0ns2YT/EIIH6B9qWuCVOU3lUcv20B4DlD7xPcAykq8MiKurylGyLm3XF?=
 =?us-ascii?Q?v+Q7GU5FMp6WlT1CtpM+g0WE1gemWuGZaNRxhr3+nUlQwRkNFBtZSShPnPQY?=
 =?us-ascii?Q?eQ9SmPnknJkZWTrOexPHn+98DRp1XEc4fPYWFPhAfyLq9mzI2HUsY+DI7fQ2?=
 =?us-ascii?Q?C/3fK3OHGnmifdwpgwjppAIpE+mXzK3gFCRwi99KV8/9DewydtIRvR0sOU5X?=
 =?us-ascii?Q?qYU6wNaOgdolPj2B0ZdSQi7C2DscsFtXkm8pR4jenEcgwtNWEx/ftxk1cwmP?=
 =?us-ascii?Q?cPJWylVgd3qbI66wFp0jx3wUg817LEnmSP5zHOJnWw5Y0V5OMhxCHRmui74r?=
 =?us-ascii?Q?BCtM6xyRgDPE3990wKuWzG+PpbsIMLH3ve9hOcnUQsJyRmWpzWBlsU1rb+D8?=
 =?us-ascii?Q?QX7h/x2PXA22eFlyB3rkxUSuPPx2qCWSFqm/xzaFpaT+jz7T5qMvJKmREjT6?=
 =?us-ascii?Q?AHcUhNQDJLwgjlr4mHA9PnOc+uVfkEDWBl1mFYGwDyNJBBUpizvvwuQzwucu?=
 =?us-ascii?Q?q44SNGjv+L88o1Zy97voyzn1qMYLoUbRZMkcByfGCifiW1qhgA4M/iq1K8nz?=
 =?us-ascii?Q?wmxNwo+3j093U6hMvUQOG2U0fiGPlyt3dcnn6X8nAC5rONC5BpSsYn1A8OIr?=
 =?us-ascii?Q?RUii9dDE/PCIkcE4KokGnSvhb/rtDjbnNFyP3phW8apKOFzH26PO34XEiGnb?=
 =?us-ascii?Q?0jLd52vNC/dntoR4iC89u74eKEihugVbLHm9V4P1W4lHKo5vwhp/SiVXK23L?=
 =?us-ascii?Q?RmZaoyrEcw6a+rchrJOH9bfuyyFmYbS4tfyTmbhQQ+W6NEu9pLrOqzI1xLp8?=
 =?us-ascii?Q?0QWYa9dVRobbNE1geW8juyDP0vWkx+xt53uuYvzOLdTBygAYE7EJB+dVmq4T?=
 =?us-ascii?Q?fyiNlKctogwk16myXEgA3Ha0M8CfhnlWx32J8du5w2WmPda7QZqL/ovlX52O?=
 =?us-ascii?Q?E8GqSJkoJ37DVSeYfon2+3bvNkulfWjlZv27e2sWzB+rPUNqEAaHWNPYcIZl?=
 =?us-ascii?Q?tVR2Oh+b15qw9JmA8kRirGHeV+2oyy1jU36hvZUtfIcHwjqfDwrX9f2hdCLP?=
 =?us-ascii?Q?XtC3l0RvaJQOgvmZZGOyAgJagR0IZF0BhiJsbZ3wWgl07Bwyv41fTR9U0/Pr?=
 =?us-ascii?Q?4A+pOdNrSxX5Hf9xKwqee5/e6nhUQg522LFgo4gBktwD1A=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4863d1f5-dfd3-4c68-c39b-08d987b113c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2021 03:34:45.9093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wl+bFplMs8QBvvtJYpUzQTyyPNUCK7dqNZq/nPraj3FWpxQ2il1pV69yE4vUafi7xw816UyQzaeSIpgCyY/9vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4345
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/04 1:38, Douglas Gilbert wrote:=0A=
> Using the existing statistics gathering framework from the st=0A=
> driver, collect statistics for access via sysfs. The sysstat=0A=
> package already has a utility called tapestat for presenting=0A=
> st statistics. Its author is keen to use the existing=0A=
> tapestat code for showing sg statistics (rather than write a=0A=
> new utility).=0A=
> =0A=
> In keeping with the sg driver being SCSI command agnostic, the=0A=
> "read" statistics are compiled for requests that have "data-in"=0A=
> user data while write statistics are compiled for requests that=0A=
> have "data-out" user data.=0A=
> =0A=
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>=0A=
=0A=
Looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
> ---=0A=
>  drivers/scsi/sg.c | 260 ++++++++++++++++++++++++++++++++++++++++------=
=0A=
>  1 file changed, 228 insertions(+), 32 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c=0A=
> index ed61d8f8fcba..c5f0c11e2c71 100644=0A=
> --- a/drivers/scsi/sg.c=0A=
> +++ b/drivers/scsi/sg.c=0A=
> @@ -213,7 +213,7 @@ struct sg_request {	/* active SCSI command or inactiv=
e request */=0A=
>  	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */=0A=
>  	u8 cmd_opcode;		/* first byte of SCSI cdb */=0A=
>  	blk_qc_t cookie;	/* ids 1 or more queues for blk_poll() */=0A=
> -	u64 start_ns;		/* starting point of command duration calc */=0A=
> +	ktime_t start_dur;	/* start time if before completion */=0A=
>  	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */=0A=
>  	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */=0A=
>  	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */=0A=
> @@ -256,8 +256,10 @@ struct sg_device { /* holds the state of each scsi g=
eneric device */=0A=
>  	u32 index;		/* device index number */=0A=
>  	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */=0A=
>  	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */=0A=
> +	spinlock_t stats_lock;=0A=
>  	char name[DISK_NAME_LEN];=0A=
>  	struct cdev *cdev;=0A=
> +	struct sg_dev_stats *statsp;=0A=
>  	struct xarray sfp_arr;=0A=
>  	struct kref d_ref;=0A=
>  };=0A=
> @@ -275,6 +277,19 @@ struct sg_comm_wr_t {  /* arguments to sg_common_wri=
te() */=0A=
>  	const u8 __user *u_cmdp;=0A=
>  };=0A=
>  =0A=
> +struct sg_dev_stats {	/* copied from drivers/scsi/st.h scsi_tape_stats *=
/=0A=
> +	u64 read_byte_cnt;	/* data-in bytes */=0A=
> +	u64 write_byte_cnt;	/* data-out bytes */=0A=
> +	u64 read_cnt;		/* Count of data-in requests */=0A=
> +	u64 write_cnt;		/* Count of data-out requests */=0A=
> +	u64 other_cnt;		/* Count of non-data requests */=0A=
> +	u64 resid_cnt;		/* Count of cmds with resid_len > 0 */=0A=
> +	u64 tot_read_time;	/* time spent completing data-in requests */=0A=
> +	u64 tot_write_time;	/* time spent completing data-out requests */=0A=
> +	u64 tot_ndata_time;	/* time spent completing non-data requests */=0A=
> +	atomic_t in_flight;	/* Number of I/Os in flight */=0A=
> +};=0A=
> +=0A=
>  /* tasklet or soft irq callback */=0A=
>  static void sg_rq_end_io(struct request *rq, blk_status_t status);=0A=
>  /* Declarations of other static functions used before they are defined *=
/=0A=
> @@ -306,6 +321,8 @@ static struct sg_request *sg_mk_srp_sgat(struct sg_fd=
 *sfp, bool first,=0A=
>  static int sg_sfp_blk_poll(struct sg_fd *sfp, int loop_count);=0A=
>  static int sg_srp_q_blk_poll(struct sg_request *srp, struct request_queu=
e *q,=0A=
>  			     int loop_count);=0A=
> +static u32 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr=
_stp,=0A=
> +		      bool *is_durp);=0A=
>  #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(SG_DEBUG)=0A=
>  static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);=
=0A=
>  #endif=0A=
> @@ -1016,11 +1033,17 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_reque=
st *srp)=0A=
>  {=0A=
>  	bool at_head, is_v4h, sync;=0A=
>  	struct request *rqq =3D READ_ONCE(srp->rqq);=0A=
> +	struct sg_device *sdp =3D sfp->parentdp;=0A=
>  =0A=
>  	is_v4h =3D test_bit(SG_FRQ_IS_V4I, srp->frq_bm);=0A=
>  	sync =3D test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);=0A=
>  	SG_LOG(3, sfp, "%s: is_v4h=3D%d\n", __func__, (int)is_v4h);=0A=
> -	srp->start_ns =3D ktime_get_boottime_ns();=0A=
> +	if (sdp->statsp) {=0A=
> +		atomic_inc(&sdp->statsp->in_flight);=0A=
> +		WRITE_ONCE(srp->start_dur, ktime_get_boottime());=0A=
> +	} else {=0A=
> +		WRITE_ONCE(srp->start_dur, 0);=0A=
> +	}=0A=
>  	srp->duration =3D 0;=0A=
>  =0A=
>  	if (!is_v4h && srp->s_hdr3.interface_id =3D=3D '\0')=0A=
> @@ -1194,11 +1217,47 @@ sg_copy_sense(struct sg_request *srp, bool v4_act=
ive)=0A=
>  	return sb_len_ret;=0A=
>  }=0A=
>  =0A=
> +static void=0A=
> +sg_do_stats(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)=
=0A=
> +{=0A=
> +	int dir =3D v4_active ? srp->s_hdr4.dir : srp->s_hdr3.dxfer_direction;=
=0A=
> +	ktime_t kt =3D READ_ONCE(srp->start_dur);=0A=
> +	u64 ns =3D (kt > 0) ? ktime_to_ns(kt) : 0;=0A=
> +	struct sg_device *sdp =3D sfp->parentdp;=0A=
> +	struct sg_dev_stats *statsp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!statsp)=0A=
> +		return;=0A=
> +	spin_lock(&sdp->stats_lock);=0A=
> +	if (dir =3D=3D SG_DXFER_TO_DEV) {		/* data-out, write-like */=0A=
> +		statsp->tot_write_time +=3D ns;=0A=
> +		++statsp->write_cnt;=0A=
> +		statsp->write_byte_cnt +=3D srp->sgat_h.dlen;=0A=
> +	} else if (dir =3D=3D SG_DXFER_FROM_DEV) {	/* data-in, read-like */=0A=
> +		statsp->tot_read_time +=3D ns;=0A=
> +		++statsp->read_cnt;=0A=
> +		statsp->read_byte_cnt +=3D srp->sgat_h.dlen;=0A=
> +		if (srp->in_resid > 0)=0A=
> +			++statsp->resid_cnt;=0A=
> +	} else {	/* no data transfer (e.g. TEST UNIT READY) */=0A=
> +		statsp->tot_ndata_time +=3D ns;=0A=
> +		++statsp->other_cnt;=0A=
> +	}=0A=
> +	atomic_dec(&statsp->in_flight);=0A=
> +	spin_unlock(&sdp->stats_lock);=0A=
> +}=0A=
> +=0A=
>  static int=0A=
>  sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_act=
ive)=0A=
>  {=0A=
>  	u32 rq_res =3D srp->rq_result;=0A=
>  =0A=
> +	if (sfp->parentdp->statsp) {=0A=
> +		const enum sg_rq_state sr_st =3D SG_RS_BUSY;=0A=
> +=0A=
> +		sg_do_stats(sfp, srp, v4_active);=0A=
> +		srp->duration =3D sg_get_dur(srp, &sr_st, NULL);=0A=
> +	}=0A=
>  	if (unlikely(srp->rq_result & 0xff)) {=0A=
>  		int sb_len_wr =3D sg_copy_sense(srp, v4_active);=0A=
>  =0A=
> @@ -1626,49 +1685,41 @@ sg_calc_sgat_param(struct sg_device *sdp)=0A=
>  	sdp->max_sgat_sz =3D sz;=0A=
>  }=0A=
>  =0A=
> -static u32=0A=
> -sg_calc_rq_dur(const struct sg_request *srp)=0A=
> -{=0A=
> -	ktime_t ts0 =3D ns_to_ktime(srp->start_ns);=0A=
> -	ktime_t now_ts;=0A=
> -	s64 diff;=0A=
> -=0A=
> -	if (ts0 =3D=3D 0)=0A=
> -		return 0;=0A=
> -	if (unlikely(ts0 =3D=3D S64_MAX))	/* _prior_ to issuing req */=0A=
> -		return 999999999;	/* eye catching */=0A=
> -	now_ts =3D ktime_get_boottime();=0A=
> -	if (unlikely(ts0 > now_ts))=0A=
> -		return 999999998;=0A=
> -	/* unlikely req duration will exceed 2**32 milliseconds */=0A=
> -	diff =3D ktime_ms_delta(now_ts, ts0);=0A=
> -	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;=0A=
> -}=0A=
> -=0A=
> -/* Return of U32_MAX means srp is inactive state */=0A=
>  static u32=0A=
>  sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,=0A=
>  	   bool *is_durp)=0A=
>  {=0A=
>  	bool is_dur =3D false;=0A=
> -	u32 res =3D U32_MAX;=0A=
> +	s64 dur_ns;=0A=
> +	ktime_t start_dur =3D READ_ONCE(srp->start_dur);=0A=
>  =0A=
> +	if (ktime_to_ns(start_dur) <=3D 0) {=0A=
> +		is_dur =3D true;=0A=
> +		dur_ns =3D 0;=0A=
> +		goto fini;=0A=
> +	}=0A=
>  	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {=0A=
> -	case SG_RS_INFLIGHT:=0A=
>  	case SG_RS_BUSY:=0A=
> -		res =3D sg_calc_rq_dur(srp);=0A=
> +		if (test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {=0A=
> +			dur_ns =3D ktime_to_ns(start_dur);=0A=
> +			is_dur =3D true;=0A=
> +			break;=0A=
> +		}=0A=
> +		dur_ns =3D 1;=0A=
> +		break;=0A=
> +	case SG_RS_INFLIGHT:=0A=
> +		dur_ns =3D ktime_sub(ktime_get_boottime(), start_dur);=0A=
>  		break;=0A=
>  	case SG_RS_AWAIT_RCV:=0A=
>  	case SG_RS_INACTIVE:=0A=
> -		res =3D srp->duration;=0A=
> +		dur_ns =3D ktime_to_ns(start_dur);=0A=
>  		is_dur =3D true;	/* completion has occurred, timing finished */=0A=
>  		break;=0A=
> -	default:=0A=
> -		break;=0A=
>  	}=0A=
> +fini:=0A=
>  	if (is_durp)=0A=
>  		*is_durp =3D is_dur;=0A=
> -	return res;=0A=
> +	return ktime_to_ms(ns_to_ktime(dur_ns));=0A=
>  }=0A=
>  =0A=
>  static void=0A=
> @@ -1679,8 +1730,6 @@ sg_fill_request_element(struct sg_fd *sfp, struct s=
g_request *srp,=0A=
>  =0A=
>  	xa_lock_irqsave(&sfp->srp_arr, iflags);=0A=
>  	rip->duration =3D sg_get_dur(srp, NULL, NULL);=0A=
> -	if (rip->duration =3D=3D U32_MAX)=0A=
> -		rip->duration =3D 0;=0A=
>  	rip->orphan =3D test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);=0A=
>  	rip->sg_io_owned =3D test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);=0A=
>  	rip->problem =3D !!(srp->rq_result & SG_ML_RESULT_MSK);=0A=
> @@ -2478,6 +2527,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t stat=
us)=0A=
>  	int a_resid, slen;=0A=
>  	u32 rq_result;=0A=
>  	unsigned long iflags;=0A=
> +	ktime_t start_tm;=0A=
>  	struct sg_request *srp =3D rqq->end_io_data;=0A=
>  	struct scsi_request *scsi_rp =3D scsi_req(rqq);=0A=
>  	struct sg_device *sdp;=0A=
> @@ -2504,7 +2554,9 @@ sg_rq_end_io(struct request *rqq, blk_status_t stat=
us)=0A=
>  =0A=
>  	SG_LOG(6, sfp, "%s: pack_id=3D%d, res=3D0x%x\n", __func__, srp->pack_id=
,=0A=
>  	       rq_result);=0A=
> -	srp->duration =3D sg_calc_rq_dur(srp);=0A=
> +	start_tm =3D READ_ONCE(srp->start_dur);=0A=
> +	if (start_tm > 0)=0A=
> +		WRITE_ONCE(srp->start_dur, ktime_sub(ktime_get_boottime(), start_tm));=
=0A=
>  	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&=0A=
>  		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {=0A=
>  		u32 scsi_stat =3D rq_result & 0xff;=0A=
> @@ -2652,9 +2704,12 @@ sg_add_device_helper(struct scsi_device *scsidp)=
=0A=
>  		kfree(sdp);=0A=
>  		return ERR_PTR(error);=0A=
>  	}=0A=
> +	spin_lock_init(&sdp->stats_lock);=0A=
>  	return sdp;=0A=
>  }=0A=
>  =0A=
> +static const struct attribute_group *sg_dev_groups[];=0A=
> +=0A=
>  static int=0A=
>  sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)=0A=
>  {=0A=
> @@ -2679,6 +2734,8 @@ sg_add_device(struct device *cl_dev, struct class_i=
nterface *cl_intf)=0A=
>  		error =3D PTR_ERR(sdp);=0A=
>  		goto out;=0A=
>  	}=0A=
> +	sdp->statsp =3D kzalloc(sizeof(*sdp->statsp), GFP_KERNEL);=0A=
> +	/* don't worry if NULL, probably a lot of devices */=0A=
>  =0A=
>  	error =3D cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);=0A=
>  	if (error)=0A=
> @@ -2688,6 +2745,8 @@ sg_add_device(struct device *cl_dev, struct class_i=
nterface *cl_intf)=0A=
>  	if (sg_sysfs_valid) {=0A=
>  		struct device *sg_class_member;=0A=
>  =0A=
> +		if (sdp->statsp)=0A=
> +			sg_sysfs_class->dev_groups =3D sg_dev_groups;=0A=
>  		sg_class_member =3D device_create(sg_sysfs_class, cl_dev->parent,=0A=
>  						MKDEV(SCSI_GENERIC_MAJOR,=0A=
>  						      sdp->index),=0A=
> @@ -2714,6 +2773,7 @@ sg_add_device(struct device *cl_dev, struct class_i=
nterface *cl_intf)=0A=
>  	return 0;=0A=
>  =0A=
>  cdev_add_err:=0A=
> +	kfree(sdp->statsp);=0A=
>  	write_lock_irqsave(&sg_index_lock, iflags);=0A=
>  	idr_remove(&sg_index_idr, sdp->index);=0A=
>  	write_unlock_irqrestore(&sg_index_lock, iflags);=0A=
> @@ -2741,6 +2801,7 @@ sg_device_destroy(struct kref *kref)=0A=
>  	 */=0A=
>  =0A=
>  	xa_destroy(&sdp->sfp_arr);=0A=
> +	kfree(sdp->statsp);=0A=
>  	write_lock_irqsave(&sg_index_lock, flags);=0A=
>  	idr_remove(&sg_index_idr, sdp->index);=0A=
>  	write_unlock_irqrestore(&sg_index_lock, flags);=0A=
> @@ -3882,6 +3943,141 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_st=
r)=0A=
>  }=0A=
>  #endif=0A=
>  =0A=
> +static ssize_t read_cnt_show(struct device *dev, struct device_attribute=
 *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->read_cnt);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(read_cnt);=0A=
> +=0A=
> +static ssize_t read_byte_cnt_show(struct device *dev, struct device_attr=
ibute *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->read_byte_cnt);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(read_byte_cnt);=0A=
> +=0A=
> +static ssize_t read_ns_show(struct device *dev, struct device_attribute =
*attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->tot_read_time);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(read_ns);=0A=
> +=0A=
> +static ssize_t write_cnt_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->write_cnt);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(write_cnt);=0A=
> +=0A=
> +static ssize_t write_byte_cnt_show(struct device *dev, struct device_att=
ribute *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->write_byte_cnt);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(write_byte_cnt);=0A=
> +=0A=
> +static ssize_t write_ns_show(struct device *dev, struct device_attribute=
 *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->tot_write_time);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(write_ns);=0A=
> +=0A=
> +static ssize_t in_flight_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%d\n", atomic_read(&sp->in_flight));=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(in_flight);=0A=
> +=0A=
> +static ssize_t io_ns_show(struct device *dev, struct device_attribute *a=
ttr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n",=0A=
> +			  sp->tot_read_time + sp->tot_write_time + sp->tot_ndata_time);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(io_ns);=0A=
> +=0A=
> +static ssize_t other_cnt_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->other_cnt);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(other_cnt);=0A=
> +=0A=
> +static ssize_t resid_cnt_show(struct device *dev, struct device_attribut=
e *attr, char *buf)=0A=
> +{=0A=
> +	struct sg_device *sdp =3D dev_get_drvdata(dev);=0A=
> +	struct sg_dev_stats *sp =3D sdp->statsp;=0A=
> +=0A=
> +	if (!sdp || !sp)=0A=
> +		return -EINVAL;=0A=
> +	return sysfs_emit(buf, "%llu\n", sp->resid_cnt);=0A=
> +}=0A=
> +static DEVICE_ATTR_RO(resid_cnt);=0A=
> +=0A=
> +static struct attribute *sg_stats_attrs[] =3D {=0A=
> +	&dev_attr_read_cnt.attr,=0A=
> +	&dev_attr_read_byte_cnt.attr,=0A=
> +	&dev_attr_read_ns.attr,=0A=
> +	&dev_attr_write_cnt.attr,=0A=
> +	&dev_attr_write_byte_cnt.attr,=0A=
> +	&dev_attr_write_ns.attr,=0A=
> +	&dev_attr_in_flight.attr,=0A=
> +	&dev_attr_io_ns.attr,=0A=
> +	&dev_attr_other_cnt.attr,=0A=
> +	&dev_attr_resid_cnt.attr,=0A=
> +	NULL,=0A=
> +};=0A=
> +=0A=
> +static struct attribute_group sg_stats_group =3D {=0A=
> +	.name =3D "stats",=0A=
> +	.attrs =3D sg_stats_attrs,=0A=
> +};=0A=
> +=0A=
> +static const struct attribute_group *sg_dev_groups[] =3D {=0A=
> +	&sg_stats_group,=0A=
> +	NULL,=0A=
> +};=0A=
> +=0A=
>  #if IS_ENABLED(SG_PROC_OR_DEBUG_FS)=0A=
>  =0A=
>  #define SG_SNAPSHOT_DEV_MAX 4=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
