Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753F4C77B78
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 09:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjEDJDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 05:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjEDJDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 05:03:22 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF478F
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 02:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1683191000; x=1714727000;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RxBP5Q2qtE/PElurhiCCMPy+neqp4Q4yyODn9Y4Vtvk=;
  b=r1P0nQ8SqPEKyPqBLe6E+0gctLa7l9NurFC3dP0Z/mHkILi+8KKbGxVR
   /ozZPUCxZUKHprCbvHrkJiY7T1mtBBzCBhMC6lgmNwmmLmT4dWKL8F0uy
   Mq9XjzYDOlzoPepPbzliy5p5uaqbAswG0/73YIwDsBYOUKbnkN2QBRWO3
   NHYJf9P4MgBA93up44nMm+jfQS2eyaqbIJoPTUg0vby0K76r5BD/xsFsz
   MK7hWf1u4GRb6z2QYhxbFFQM2y/Xdg4xkimGizV72mlUNX1zD42LvNmhS
   A5HP7ZDzyp4mkrOYO/d54gJ/YIDsjz707sOE+MKpBT267BapR9rFs4FFe
   A==;
X-IronPort-AV: E=Sophos;i="5.99,249,1677513600"; 
   d="scan'208";a="228071809"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2023 17:03:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GI4jQ+YZnm13Yo/jj1GDnVih8GE7ScXbkM8d0bwRmjWQgrlqrhlIbhiEme93mni7QUotJR31GJMp404C/mPLVRym55n/gj7iBJIAPGxs3HdahftuW2+4EIcHMUBvp31yE6/wSkXfIsgcg7etsNi7r7SLeXFfU1Nx/WFwbe8jZMP/dTG7YVZdo0bTNFMj3lbU2bW5jDN+wnBVbqn3bYuQCqkoMWQ+e1H7/8HUcdkv4wboF5BIM09EzUb4YN1OedXb+TljLLgfhZZeNzco5jX47FirEOvinZO0Gw7FGU8HkHtFT+wgDDqbCsXukQejbJ4S4tj2blQ0tLNExSK8Rs8u3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5SEwm8s310uRCUQ916fGuI5QGyV/Zchfrxx9obwb8o=;
 b=DHr2hHIRqyzqPOfvuZ0o9ZkmHzQxEGi2R42E6cNueI/tYNzXre8KveiHQCAQYNLBO74gVPv1ekY9+U8MxRP0qMYxjp8u0cDDXHWcGbZLkjMZUQFiwxTfyX6CbGLTU3TSzAvU+jw1Y88dwdsLb5KKlmgAWtXd6J8bj7rDtCckQHC4ac1qdfr3cFFxl9+fENYxEWXTdAPMZrOHHMDk+akBHEsBtDz2vh2Uo2kdtWWJXuigIdV+vedS6MDlC53WImasSkARvdZyxuVAVw4yE+QUuXb1FTswF3cjbRuGIU4NYTv0hX/IL+nfJvA5nklGCfnivS0Y65DB8BOrU+l+rrmL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5SEwm8s310uRCUQ916fGuI5QGyV/Zchfrxx9obwb8o=;
 b=Chjp03ss5YVsqQmSgNLlH8BPy39RfzlqO2eND6HDeMP3nkpncAiIlBMLW6eYCMCaEc/90mreoViULSMkdgbYmUDsWBQQ7RBzQnejDPOzs+NSOc56uwWIlYN9GMlfE0wOHV9wXQa54elRvOr2BI4Zd40zZyQy+Xg5dRPfcLRvdpU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 09:03:16 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fd:6db1:5165:2ade]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fd:6db1:5165:2ade%7]) with mapi id 15.20.6363.022; Thu, 4 May 2023
 09:03:16 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
Subject: Re: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Thread-Topic: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Thread-Index: AQHZfhQAXiRvFe3B3k6X2Zvq3O41cq9J0l2A
Date:   Thu, 4 May 2023 09:03:16 +0000
Message-ID: <ZFN00zRP9ETzF504@x1-carbon>
References: <20230503230654.2441121-1-bvanassche@acm.org>
 <20230503230654.2441121-4-bvanassche@acm.org>
In-Reply-To: <20230503230654.2441121-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB7081:EE_
x-ms-office365-filtering-correlation-id: 233a2f01-ad54-43d5-375d-08db4c7e65f6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: myVfOpGpyv4ys3TOvJyQgXFYvimlFfA34SEgAquw1k+nGPzffuP4Ag6UzpRK4/nofTzFz7PcmTeL/UEgMYNrVvqoVKTkufK4p2XP/MQo6zH7nHtVX2sqo4lc7OZZsoUSO69d0ZgsYC1axlySiuNWGyiPTrxuvCJiC/5vN1R8NktgDvaLckgyfdkNyytwR3Ha1hIMEBJxv1WmiRR2zuZTeVAYufskIhpOtspVP+5SD3KEoZT7OtjNkxd6RGDOIwZymyUT9kN23NBsclMK2B9h/ULEQq4YPN4TGpYEywMYiSUoA96fv8krBd0bAsky4n9zn2use2H7adrZCQeFOgWx9lmxHd6P+FUYgve8iU1WKPy4EfSoblPOBDG6LyhEEDR52ERW9Kif5FxHsNkqpMQgRvp8KAFB9NWtYkN2EaQlcm0bGYH9v804aNVJ2L4Bw/HUpMEXMzDvnMYDTp9C/6vXYTC+THLGU1jWMFS0wMgiV8vKxeUDqvgfGylAl0PbMlADQYjnrOQ5wIxvMHwWBAbKiQW91qqWz+6hACKC/nvLA50N5OdwK8SFga5LrNkuKUR8Wki9PVcHruqsrfVXIMWx6HJx5eWO7nkqU69dOS2yhCAbsHVCM5zbTq9olF5C93e/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199021)(54906003)(83380400001)(82960400001)(122000001)(316002)(38070700005)(38100700002)(6506007)(6512007)(86362001)(6916009)(4326008)(66946007)(76116006)(33716001)(91956017)(478600001)(41300700001)(2906002)(66556008)(66446008)(64756008)(66476007)(186003)(7416002)(8936002)(8676002)(9686003)(26005)(5660300002)(71200400001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?al+Vq4wFBQUFdecfSkjQ+UL+uvazfPiynqaT6sxwS0+qnsItQXBkLEppvbaV?=
 =?us-ascii?Q?rDVbEuKWevX1C+NVrWCvXczy4CHL/AIEAoLFhbK+mVRbDWf9jy//SjvJn/Yx?=
 =?us-ascii?Q?mZbTP8lEGGVnTMSC/4NYJPRlC9krEC8MF5oznfz7iPvLgRiAowVmcCVkZDFN?=
 =?us-ascii?Q?crZm/GVyyJDhsXtl0gghvoipqqUHnU2DfE+IL9QB4bJFUZ+yvLIXcwX9pBlx?=
 =?us-ascii?Q?RJInQ6i2kgQm/N6ZecoWwX0V/W7dTq0e2/lQR6v93fJ6abszWZKBHK59u9n8?=
 =?us-ascii?Q?+2Q4LcyJrH3gHsmeK74YCPtkKCW+Hk+46CsG0CvLa/FzfIeRJRhVv7/huq6G?=
 =?us-ascii?Q?XAWw1WaosA8Q2d3hsC487r5C6+A1QRggQ9AthcwFhxWkvbZRYhiXl9LwUQTy?=
 =?us-ascii?Q?UQxHUQQPC+VXQsFJhnk0Zx/XWe8/X+oKXqodRlXEOuL2uNrEQEWoJ0mSpELe?=
 =?us-ascii?Q?bbswc6IjBeRanKffQmGyV/8LBW6//5i9AjHRhcaBq6SlkBLahwsbaASrLRiB?=
 =?us-ascii?Q?l+R1Q4fsLjVob2oI45KpGwUhcfQZlPFBU+wKioeLHeqVHhEVJttlJxiUXsKe?=
 =?us-ascii?Q?f4m/BtHFQlkY4CPxayLQBgffg4Mhz3QctFz4zh5bk86gdVrtoM03Oa0c+ERB?=
 =?us-ascii?Q?rdeod62qN6clpNxf7OQWHyrTcyBg5oNFzOGzSgqps1l7vqPP1KeQrmlYLosU?=
 =?us-ascii?Q?GNQ4jBpkgEZzytW78cuV7NuBUVM2iZtkJDjjNymAkpVBPbby30R3w6jfbCYU?=
 =?us-ascii?Q?iOqp2QfhA+MY2EpwhT640mo07naIDcc7mLb/TRvCC0RN1L3VBe6ubvHDD4n3?=
 =?us-ascii?Q?kIzbbu36evFbk/xtUYJMfYsxCqLlYNzkxKkIkl2kUic+9NgjO0JDohLB6Ilt?=
 =?us-ascii?Q?ggc120yGg7nZHptc3VDohit23cWHiE0C8NgfqzdMrGeAB1fw63yyGWxuVBLv?=
 =?us-ascii?Q?t2nNpRwlvlrEaSp+pBkk150dZLrjp3fHl8yzLy8+HmVv6ziNS0hyFCfgyVvU?=
 =?us-ascii?Q?vttUbREG72MCnHgYYAi7REo0mPbuoXkhTjRqzEtfDyxAAZ30MI+p+XusrPqc?=
 =?us-ascii?Q?U3+ZxRNtJPppfPKd2rjoNMXf3GRyZc0jjKrulU7VcwZ4O7RG7XWywwqRNQew?=
 =?us-ascii?Q?c3hZp4dh4088srYMA3YTXEazLbAoZ2CWFzeNRv0K0NzAoiLznBuraYuwfDbW?=
 =?us-ascii?Q?V9RdqR8QYwSODTmSVvvlX+znajDBQhgH+FyKSFaozsARNSDtA9JgmOvr2L21?=
 =?us-ascii?Q?JORyMkITRMjbU82ja5vD9+C9Heu73O3SXTMFQcdfVOPlH+LvnvJaVq8HuMMd?=
 =?us-ascii?Q?MiVJZbyKMaGSGHFC9zp96F2kKsLzy0sHucMf0rvyeuYLoLUwnrwzxTd/yxRR?=
 =?us-ascii?Q?szwX7cOGZkj8SDBjL25JN6SyawyM+BNPn9Xf4sMvTdy6nVxlou7cra7RiP3i?=
 =?us-ascii?Q?PHqXC7hnAJ2JpWEwIQywLWMIc+V7fbI+eFpr5M3LtYngmuKkdn213ZV1jRsg?=
 =?us-ascii?Q?xyZWr9gKrhNmr/sIb/4J4BHxey8HNKqSMWgWcDWAOKJyegQ9Cb/ne9XsupSJ?=
 =?us-ascii?Q?khxO20NJf9T9zt4B54KIkgZsgariNV0CRFxHQ/3MWWRAsJ+SqxgKPMwCeTM6?=
 =?us-ascii?Q?wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8AE34D22BE17A840A1E04463503E009D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?bkUuoTUkSxHlUKOZ5+19OiTx4m/2Z267u7A0bFWtohv08kDCUrApLpzuMMGw?=
 =?us-ascii?Q?KgJ4VOVRQ0YMUKvhb6TRe7LJ2RWZsBmcArzX/YGI+Lekf/hclrRPvZ080a6/?=
 =?us-ascii?Q?WFxJx/J1aIa0mp6a+mY3swkcFk16Z6FohiaqvCoBhnUQA6WRc2p0A1Q9kzKM?=
 =?us-ascii?Q?jx0FeV47CGLeVi6JRxmYFzdn6yMZaD/8YsKDTxTqu1alfFCG6+Cgpyj1vOpD?=
 =?us-ascii?Q?TrrNS+nZpr9dlSZMyQvTbSiohpzFwsqKAu/9MwHzLSwNdeln8q1TnFP47cwa?=
 =?us-ascii?Q?yWbgl0IR+yagZSaUmJ1GL5yWkdwpZl6MHghqIC2j1ej5wf8d12rUYOIwdNqm?=
 =?us-ascii?Q?C7LHCQhbHaIH4SFJ01giCg07M3KhxyvNnVmHG+lVlrXd+YgkFMMuoGDPAlnW?=
 =?us-ascii?Q?LPsRdt3VaivkAdM/MpDVz4HGcvzEZ6WjQyC/aDn3AkrWlLkJcmkOWPgAi3nv?=
 =?us-ascii?Q?lyxBxilALSE7vkQfVCJN44LO5w0ufTRd37or79+4WDQMEZtTku1c8GCloH/L?=
 =?us-ascii?Q?evIQlsTs5PqtybkHSJLg8Uh2fvCXnaKyGXmn/bjBNHOxMPOw9A7ehX6jXI+B?=
 =?us-ascii?Q?k2wv2J0Zp9SylDRK7zcI9jlZhdJA1lxgM2kwuCiHjj8s/ZtS5Od0ycdn4fK/?=
 =?us-ascii?Q?jNU179mNdEcpbJp9zztxYwfTvCwH5QhmLun0ulCoC6nOXyQ2dc4cgfU7DlDG?=
 =?us-ascii?Q?Ate8QF+F3yQf6wCNPg6V2C9DKwI/yUQ+HMqljrOYRDZG0OaWN22IGH7EVe33?=
 =?us-ascii?Q?FU9idw0BCMxUDc7tLR+SnDxiV0cffmhAxRcVgWCBLjz/XHNrdSgPjdKJ/GY3?=
 =?us-ascii?Q?+Ph565CDME0KDH0iJtPQVhqUOie/beQuSX7VoOeLlmHKxHcMnYWcBQpYB5Lj?=
 =?us-ascii?Q?bsBqu9haeLXzmkk/B8MdkUKbWjaFKTCvbHP6MSE8RA4YEBIl0eAQ/WAzZ3Gs?=
 =?us-ascii?Q?OTmNJyFKUP6tA441FdUuaHa8ke0pQIVUmmL80hqyTqc=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233a2f01-ad54-43d5-375d-08db4c7e65f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 09:03:16.3210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tDTo9tWZrGdHsATzXEpHpOMax4VW9dqCd/hO6thSuP6vPua+tUOcHsJVwA3x99pyhJA3ATs3BHMwNB7OC+zvDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7081
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 03, 2023 at 04:06:52PM -0700, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the sense key, ASC and ASCQ codes available in the
> ftrace output.
>=20
> Cc: Niklas Cassel <niklas.cassel@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/scsi.h | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..6c4be1ebe268 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,9 +269,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__field( u8, sense_key )
> +		__field( u8, asc )
> +		__field( u8, ascq )
>  	),
> =20
>  	TP_fast_assign(
> +		struct scsi_sense_hdr sshdr;
> +
>  		__entry->host_no	=3D cmd->device->host->host_no;
>  		__entry->channel	=3D cmd->device->channel;
>  		__entry->id		=3D cmd->device->id;
> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	=3D scsi_prot_sg_count(cmd);
>  		__entry->prot_op	=3D scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> +		    scsi_command_normalize_sense(cmd, &sshdr)) {
> +			__entry->sense_key =3D sshdr.sense_key;
> +			__entry->asc =3D sshdr.asc;
> +			__entry->ascq =3D sshdr.ascq;
> +		} else {
> +			__entry->sense_key =3D 0;
> +			__entry->asc =3D 0;
> +			__entry->ascq =3D 0;
> +		}
>  	),
> =20
>  	TP_printk("host_no=3D%u channel=3D%u id=3D%u lun=3D%u data_sgl=3D%u pro=
t_sgl=3D%u " \
>  		  "prot_op=3D%s driver_tag=3D%d scheduler_tag=3D%d cmnd=3D(%s %s raw=
=3D%s) " \
> -		  "result=3D(driver=3D%s host=3D%s message=3D%s status=3D%s)",
> +		  "result=3D(driver=3D%s host=3D%s message=3D%s status=3D%s "
> +		  "sense_key=3D%u asc=3D%#x ascq=3D%#x))",

With the extra parentheses removed (as mentioned by Hannes):

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
