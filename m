Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4DBC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2E5364FAD
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbhBDXYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:24:40 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:35967 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhBDXYh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 18:24:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612481075; x=1644017075;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=iZImA3NRIWJr1dWj5S/tfV0bAkQUxJiwGVONONojOy0=;
  b=FTTWNDs8Jp7HJyqJ0SRw5IJDCq7A+iCxF0xnTdAdUeTPyn1CB4DuVkM7
   n2GDzlz6IBvOCS+gAP0xMP/PYhxYAp7SfADRBVe61BsTMj/XmSL0l2UfI
   aIyWZiLbCWQ/Tp3BcxXftxgrC0lJH8CQdvj24+ImkR7cdzOsXebFPhcYV
   2BAoMksRbtsm2cJO1ERN1NSsDwafxh2HQK63aVcypVZfSd1LlKqvSbKdg
   CsxM85X5ryjclyecxLFukRJetJ/jM6w2vRzHW+hmdi0ySUrPmhEHlKioE
   hbPiAqxWQHRZQVjIwKFYuQ3GVAWddGPzb5JMJH3vn2pAuDHxwFiOWKRWj
   w==;
IronPort-SDR: SHFs6Ax8XG0ivcCbz0BHuWHYq29heBAjz06n18XFqrXqXIS8kT+KF4IgLcL+2FNE92OZLm329R
 ypRSIDveOKIPpx3tqs0ArJym0JkVNeBicxsD8fviiN/wS6fLcpEyODmbRNC3DP/yeUgxkh5OzJ
 I4tgTJ63eMaL4Seh/j+sIs+y9KT92+kmB4luXN3tPjKngBdC2FOrUFwK03UBhQyCPbYL3BEVI3
 7D+Zct0tnq+7tyd3GEkBJFq6elqeSzBEaH2+vNIHGKucTUgdsheJknc3gGTYZ7cClhhreS5hw+
 L1A=
X-IronPort-AV: E=Sophos;i="5.81,153,1610380800"; 
   d="scan'208";a="159184659"
Received: from mail-sn1nam02lp2058.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.58])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 07:23:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+cxuSGGettnm1ZejpbdKaJk3nGacRwAwjFflAUaoMEyEsd0ib8SkYb04liVOKh5YtUCYaGbCHHdckhzEVxL+m7exYKIVBJTc+zD/ijA5RPPhcdg4ElAuTuJ1GUtnTXX1aT46gc+DQgf0UikERTl9k00J+S/8zzkir/TUoJtlrGEAJvzb3UxKeJ0Uthh5M4tsVc7OwA8ltXQGEUkU+MOuvvqUcwdp68BbfkjlXfjM0Et4MB3+VQnPfKlvVTYMNhZWEfpjLLXMJsh+yQnuTxtWsBUYL3pSIaFhFKn0m3ae74TlgjRxpkvRUwZGTk0KbL/a5H6qvmcNl3erTv3v7QRpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmdjiMlF8pZdCJqIY6fbHa+qLuRVsSwVMYxAyc6ookY=;
 b=j9o7UraWhjeKdarZd+l2MUVCcF3Mbp+8gfeCX89fJtcFPhw26wnxg04unibM/GLPPM9NMXFaCWfsy7AjEXtZDnP6Zzm5qlmm2zUwsfySvjMZFGNV21LtI8JXNJW9gmWWFBT/JFJSFtogh2VvJbaiCjkWjRwD/R7pIAdjDneqLBk+LfwcGHDgjJ6cYQf8ReXglmxnjHoKAVK21x+j3PxMcMW+25A9SGicZuGXZXZMqCDBzi/9J+KbPjXgLnIIuru2CKzpMJs1YavczyDXLEnDVLscSuJTTn8vG53sbaBCFgldSzhaQggl8ZFNj2ZNsTmvVpOjhDoHyn+uhgGs2TX9xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmdjiMlF8pZdCJqIY6fbHa+qLuRVsSwVMYxAyc6ookY=;
 b=wn8BKR7TEsrFr+SoJY/Gry2c0sn+ZgwI3Jy2QqIcwEpV/BSCWekwyFZCBGTop+1AMhJG9Gm7WMFYPOzVsoXex/MWgqnSmG8UyqDw4yrYqwl7Bj4S+bEHa6I/2wsK0/iWQmBrytRsiej37gCetv3rFeYZfVg98lTaPXWdxRdjCXo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7632.namprd04.prod.outlook.com (2603:10b6:a03:32d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 23:23:27 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 23:23:27 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 08/11] target iblock: add backend plug/unplug callouts
Thread-Topic: [PATCH 08/11] target iblock: add backend plug/unplug callouts
Thread-Index: AQHW+uqAXFP9xXHYdUSkJKfdoREP6w==
Date:   Thu, 4 Feb 2021 23:23:27 +0000
Message-ID: <BYAPR04MB4965A3E11E9A98C287A410F986B39@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-9-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5a9d412d-b551-4d55-4435-08d8c963e04a
x-ms-traffictypediagnostic: SJ0PR04MB7632:
x-microsoft-antispam-prvs: <SJ0PR04MB7632D32623696D8CCD6881BC86B39@SJ0PR04MB7632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e+czJb1WnvRRRRB0ICoNHeQJgEQxrV/Vmdt58j19iYLqGTR9cOXdoHWur7bB6slrKolv6ZFgpNe2qRgAGkPF56bPK1ALLsCdcZq4Wh5rG/6uOdqMfKmHbXkOLCnlkqR4E7WW7b8SrmBDWtsgk4y8gwyYbxPtekTMDtOOii0IY42e9gtWgryveoyxYmEur/B4XkfAIV28pBlreK5vbMIC7dsi/jD8lZj3IJS8eaOBly3M3qsLmp4vEkdj5rLCmH43OXmPRsro5lfxCXwQJASBMhHKvjUGnM+CU5UG9I686YCXGPLmoJ8dv+qgOgwiEUeynvi/nCWH7aywTPSsiJ38sI0KEYWdEW2ofcJlkGPWO7cvWj5LbtwEq+zrfQCexpwHbbP8i728hjRAvUMo+zkQuzDt/QKhzxl3sixs6T2zzBkQxjKXKrxoLHEdfU/C/SsD5QtfcuiC4yNtbFyRv5L3iLyj0YvsXdj7+ntNuPRyWm2iK4aB7g+KKWfIz5UKgF5AElb2f9c0qn8GgckmIHaBaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(8676002)(9686003)(86362001)(71200400001)(186003)(7696005)(55016002)(8936002)(5660300002)(76116006)(2906002)(66556008)(26005)(66446008)(66946007)(53546011)(6506007)(64756008)(478600001)(110136005)(316002)(52536014)(83380400001)(33656002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?amUl/Om5YwX6xdNPO9QtpvXMx9ZkuT0X12pwwaraZVLp6ZRrnCg3ay93ZurE?=
 =?us-ascii?Q?OpK9023dEuU4fFvH6zZ9ZwgpBWAlwxjNnCheo4FK1KtDGelbl3TcZjErCp5D?=
 =?us-ascii?Q?wcgvesTp+9hx8YgcCvMii41JXGTEwcRAw5dWEu6FSfyxHBeTPTnQSKKZsD2R?=
 =?us-ascii?Q?2mNWxvQIs6DEGO/e0AMsy2IbTjZ3YjKL1lWQVun0ljw8uaRnL4bkphQD4iKJ?=
 =?us-ascii?Q?G9JIA0LhjrNqhIY0fM/o0MmonU3dGLuGFLmWrMQApMQYR2sZUp4oCmkrPaYP?=
 =?us-ascii?Q?XMsvAThQuPuzNZ/vaEWj2IrGKyT2mwACNr8d2sEozp9TzK10c+6sYdX4/tmh?=
 =?us-ascii?Q?RXGcxJqJk0LD7kpriAxTceVI6rLCHSiSCEAzlmXjqjvGKrrmqK+BIk/pgjy+?=
 =?us-ascii?Q?cp/ONrSI6MY2iDDIuVR+VzVsxhmzIRlmhQ3e/i723ccP/o/RwUPhR+KcZUVi?=
 =?us-ascii?Q?UNA6ZKJa/5S9DKsORAqr757K6qWNhDbi4uSEbVFcEGt/zhu1vFnU+OmJfnJ/?=
 =?us-ascii?Q?8HzyNQXOBt1+cD4/B0oCjBL67B0NB6n8hyK1U/rgjxkL0zT2R7nFDJVjo6zx?=
 =?us-ascii?Q?BVWquq2Gw+z5CitY1h/s9kEIv7UzHZnr6P9WifpbZpt2nZb3ttiyQtpsMNq/?=
 =?us-ascii?Q?IStW5laiDX0WLVWccn6XWoPXqKN61XLSxHxEJkBG3xxviUtW0O2fRXxzgxfe?=
 =?us-ascii?Q?1tgOYC5COIyij05aDAZB6COUpzx8cy/wnHWWCH5IYd5gpIHa0VIJzYO+COIn?=
 =?us-ascii?Q?dl/URiojygrwa/8OSw/jmtDlxbpFZOqLY00oXZvu8pPtc7zpjgTeOn/K8VZs?=
 =?us-ascii?Q?eUsizQ/xYuOJNp8cd/X9B/XGTseiLc4jKfQWbXjF+31XFRARRfNOrP5hPKnc?=
 =?us-ascii?Q?XkoOIOmIfLqb58rBJokcRMzK/opDKe+UWt9jL59NG6/ej+UhXVfHQfjn1fme?=
 =?us-ascii?Q?qYgVE6Xgj8yyGiUsn/hIoh2nxZstII/39BFwiUEvn7I+y32smyDvD0xVNkUd?=
 =?us-ascii?Q?2nkb3L5+J2Rb52+SZ2aV+QcxduyOPGfi4JFUovF/KRM/tEmovNEjfVXOsJfG?=
 =?us-ascii?Q?mmh7ZmE5XAhyb1/vK+vnbdGtqYfcv3xf+3CdCcMH2TyNYqT/A8urHO/8YCsV?=
 =?us-ascii?Q?XQhvN8llUYocwMRtDk7KjrQ3sXz9208JTuH8E4j4WXeCpMKjVpzG+J1MPK3m?=
 =?us-ascii?Q?ocLG3zNlxHGiUxRK81K2EWalbosdfUJsfoUmexIWVexU9qGJBnFkWzVBeS6w?=
 =?us-ascii?Q?6zJVhKX9rwUsF9BuHay3JHNNIlUOoJCHZ/xXI5BENj92O7oc3KvVD1M+mprB?=
 =?us-ascii?Q?XONwXPMuSnbmg64toryrK67r?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9d412d-b551-4d55-4435-08d8c963e04a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:23:27.3864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/Z95rwAa9BUswiYOdUh05ii96Wtbuh2vm8HmF3MOwXUxXJITaJ2gYZtShqaok4/lffwocZeZopC35/3/X7kvjpFlm9ZLJZTGWKXZ0bpuC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7632
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 03:40, Mike Christie wrote:=0A=
> This patch adds plug/unplug callouts for iblock. For initiator drivers=0A=
> like iscsi which wants to pass multiple cmds to its xmit thread instead=
=0A=
> of one cmd at a time, this increases IOPs by around 10% with vhost-scsi=
=0A=
> (combined with the last patches we can see a total 40-50% increase). For=
=0A=
> driver combos like tcm_loop and faster drivers like the iser initiator, w=
e=0A=
> can still see IOPs increase by 20-30% when tcm_loop's nr_hw_queues settin=
g=0A=
> is also increased.=0A=
>=0A=
> Signed-off-by: Mike Christie <michael.christie@oracle.com>=0A=
> ---=0A=
>  drivers/target/target_core_iblock.c | 41 ++++++++++++++++++++++++++++-=
=0A=
>  drivers/target/target_core_iblock.h | 10 +++++++=0A=
>  2 files changed, 50 insertions(+), 1 deletion(-)=0A=
>=0A=
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_=
core_iblock.c=0A=
> index 8ed93fd205c7..a4951e662615 100644=0A=
> --- a/drivers/target/target_core_iblock.c=0A=
> +++ b/drivers/target/target_core_iblock.c=0A=
> @@ -61,9 +61,18 @@ static struct se_device *iblock_alloc_device(struct se=
_hba *hba, const char *nam=0A=
>  		return NULL;=0A=
>  	}=0A=
>  =0A=
> +	ib_dev->ibd_plug =3D kcalloc(nr_cpu_ids, sizeof(*ib_dev->ibd_plug),=0A=
> +				   GFP_KERNEL);=0A=
> +	if (!ib_dev->ibd_plug)=0A=
> +		goto free_dev;=0A=
> +=0A=
>  	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);=0A=
>  =0A=
>  	return &ib_dev->dev;=0A=
> +=0A=
> +free_dev:=0A=
> +	kfree(ib_dev);=0A=
> +	return NULL;=0A=
>  }=0A=
>  =0A=
>  static int iblock_configure_device(struct se_device *dev)=0A=
> @@ -171,6 +180,7 @@ static void iblock_dev_call_rcu(struct rcu_head *p)=
=0A=
>  	struct se_device *dev =3D container_of(p, struct se_device, rcu_head);=
=0A=
>  	struct iblock_dev *ib_dev =3D IBLOCK_DEV(dev);=0A=
>  =0A=
> +	kfree(ib_dev->ibd_plug);=0A=
>  	kfree(ib_dev);=0A=
>  }=0A=
>  =0A=
> @@ -188,6 +198,30 @@ static void iblock_destroy_device(struct se_device *=
dev)=0A=
>  	bioset_exit(&ib_dev->ibd_bio_set);=0A=
>  }=0A=
>  =0A=
> +static struct se_dev_plug *iblock_plug_device(struct se_cmd *se_cmd)=0A=
> +{=0A=
> +	struct se_device *se_dev =3D se_cmd->se_dev;=0A=
> +	struct iblock_dev *ib_dev =3D IBLOCK_DEV(se_dev);=0A=
> +	struct iblock_dev_plug *ib_dev_plug;=0A=
> +=0A=
> +	ib_dev_plug =3D &ib_dev->ibd_plug[se_cmd->cpuid];=0A=
> +	if (test_and_set_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags))=0A=
> +		return NULL;=0A=
> +=0A=
> +	blk_start_plug(&ib_dev_plug->blk_plug);=0A=
> +	return &ib_dev_plug->se_plug;=0A=
> +}=0A=
> +=0A=
> +static void iblock_unplug_device(struct se_dev_plug *se_plug)=0A=
> +{=0A=
> +	struct iblock_dev_plug *ib_dev_plug =3D=0A=
> +				container_of(se_plug, struct iblock_dev_plug,=0A=
> +					     se_plug);=0A=
I think something like on the new line read much easier for me atleast :-=
=0A=
=0A=
        ib_dev_plug =3D container_of(se_plug, struct iblock_dev_plug,=0A=
se_plug);=0A=
> +=0A=
> +	blk_finish_plug(&ib_dev_plug->blk_plug);=0A=
> +	clear_bit(IBD_PLUGF_PLUGGED, &ib_dev_plug->flags);=0A=
> +}=0A=
> +=0A=
>  static unsigned long long iblock_emulate_read_cap_with_block_size(=0A=
>  	struct se_device *dev,=0A=
>  	struct block_device *bd,=0A=
> @@ -337,7 +371,10 @@ static void iblock_submit_bios(struct bio_list *list=
)=0A=
>  {=0A=
>  	struct blk_plug plug;=0A=
>  	struct bio *bio;=0A=
> -=0A=
> +	/*=0A=
> +	 * The block layer handles nested plugs, so just plug/unplug to handle=
=0A=
> +	 * fabric drivers that didn't support batching and multi bio cmds.=0A=
> +	 */=0A=
>  	blk_start_plug(&plug);=0A=
>  	while ((bio =3D bio_list_pop(list)))=0A=
>  		submit_bio(bio);=0A=
> @@ -870,6 +907,8 @@ static const struct target_backend_ops iblock_ops =3D=
 {=0A=
>  	.configure_device	=3D iblock_configure_device,=0A=
>  	.destroy_device		=3D iblock_destroy_device,=0A=
>  	.free_device		=3D iblock_free_device,=0A=
> +	.plug_device		=3D iblock_plug_device,=0A=
> +	.unplug_device		=3D iblock_unplug_device,=0A=
>  	.parse_cdb		=3D iblock_parse_cdb,=0A=
>  	.set_configfs_dev_params =3D iblock_set_configfs_dev_params,=0A=
>  	.show_configfs_dev_params =3D iblock_show_configfs_dev_params,=0A=
> diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_=
core_iblock.h=0A=
> index cefc641145b3..8c55375d2f75 100644=0A=
> --- a/drivers/target/target_core_iblock.h=0A=
> +++ b/drivers/target/target_core_iblock.h=0A=
> @@ -4,6 +4,7 @@=0A=
>  =0A=
>  #include <linux/atomic.h>=0A=
>  #include <linux/refcount.h>=0A=
> +#include <linux/blkdev.h>=0A=
>  #include <target/target_core_base.h>=0A=
>  =0A=
>  #define IBLOCK_VERSION		"4.0"=0A=
> @@ -17,6 +18,14 @@ struct iblock_req {=0A=
>  =0A=
>  #define IBDF_HAS_UDEV_PATH		0x01=0A=
>  =0A=
> +#define IBD_PLUGF_PLUGGED		0x01=0A=
> +=0A=
> +struct iblock_dev_plug {=0A=
> +	struct se_dev_plug se_plug;=0A=
> +	struct blk_plug blk_plug;=0A=
> +	unsigned long flags;=0A=
> +};=0A=
> +=0A=
>  struct iblock_dev {=0A=
>  	struct se_device dev;=0A=
>  	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];=0A=
> @@ -24,6 +33,7 @@ struct iblock_dev {=0A=
>  	struct bio_set	ibd_bio_set;=0A=
>  	struct block_device *ibd_bd;=0A=
>  	bool ibd_readonly;=0A=
> +	struct iblock_dev_plug *ibd_plug;=0A=
>  } ____cacheline_aligned;=0A=
>  =0A=
>  #endif /* TARGET_CORE_IBLOCK_H */=0A=
=0A=
