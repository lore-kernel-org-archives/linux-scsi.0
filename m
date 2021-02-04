Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2258C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3C2F64FA1
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBDXOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:14:54 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11348 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBDXOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 18:14:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612480491; x=1644016491;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=tTIZ8cuEf8FMV/CM6WAwmPlbgrwygaThBPcBObuQDr0=;
  b=SlVe6dzO0wwpLhru4qQYrejJA8Itu1h3bUYl/Qxx86UW3F4THQjFSVJH
   t3DaZ2A9ooNGAXsgBbQY3a2ZKTwb4ANtAd2jELGme083Sw/wpyGIgnxZa
   +AI33iISY1xPBRplL+iSl5Mus6kB8uABIpRCwaPxq5YDIPdXmBCVjLlBq
   mlCIoc8DekMSfzVfolR3KAIEuhhYpeP4Cd1NcJtkKV4ahMDb9DCSAtjj5
   DTwsA+zeUb4izjnLKk3JzOcozKy2/fueCr53N0dRMfk2zx25100va3D5I
   VVrMzRhyH98Gwz1ojhjASVEIrsFG/W/whPk1ZSqmcyuF5ajjjOACyW4UL
   A==;
IronPort-SDR: sDzxX2PwkVAFGfwQA1Bc5m9XRihlULkBRsb9VOIfl6hK1/vQ5W5ngi3zUznBMDAkvJ/aNv6hV7
 tvmtj8161gVrFpY7uil3735gJY3qnY+IR95Y8wEnHeXqJEgqrKmeR1krRJsphQzbLPVcguS5MZ
 tvUhcv4aV707sSukam2SpPhkB0JCwBVSou6NYB1/JDzPjU0W3m01sUN3oItAFwZSsqqtVFI5ED
 BbwIyo4kVsdB9NuIYXicd02WSXMaceniEUmep38moAPvmMpq8KpIsjmyDRSMrS8Do3XdGrWNb0
 nGc=
X-IronPort-AV: E=Sophos;i="5.81,153,1610380800"; 
   d="scan'208";a="269609349"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 07:13:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBuZtylbXsKSJaGIai9l92bBKhbMCkcYt095QFve9HbYEL1FurDXZVYSdd41xIomrNjB+QCFXQ1OEGcPfvWFTpO7RJ0UvM+DM311a9Rhw/SJCwuBA+GRYv+wyD/lp8gVbPCru4e1SbJenspyn5Huxdz6mdbig4O5G9/5A/RM3yeE5geBF5lGT8oVQjNUb1WS/7dj96K6a0TaDIsIjgbFRFnLTZDzyEV1hy5cZdCDckkaZX9huf+LIJ60GJ1AemiT6d1gwpiZIbman4VwrCXMt0DJIuVwEWdSa8ErsxPpYxneUM5OPytSO5WtXBU8MavOZopO2jXmsEXtCeid9xDi0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0dhsCkn6DI890QsxAwfZRCKGE4VBpisXNrHrM2YeYE=;
 b=VP1cv+V2SFXi3YscQqApjabsfFsuPgEk+WVYgmlLe9cefJOKgLNcMEdR7tTSpmxaR7EfpdHkQBu/G0a2ALOHXnRwg6jKgus3Dp/h7HU9s81yf6IUx0iJz+ho/HzfJfl9bg4Y4XyTBypE68ht2IE/chrXtYtUAjLAtrWs/D1GGbWjEJRs6P6wMHLEoQEb5cE4d/h/hkhLzdTC7c0T3v7Od6xk8T9GM5Ob3koeDBbeWEXOzWR466H1bv1uM3hARc6dqCYDoBohFI46a1+2nkgg7HIP381f0r3CK49OXG8uh59MI5oyIbyZi5hWtSjtzb2qvR/3077ZtFXSimoyS1D60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0dhsCkn6DI890QsxAwfZRCKGE4VBpisXNrHrM2YeYE=;
 b=bbrc3xoObuf1aW9q6tfsuVWY+Btzd862niHztOm3jE537MeZLBKiIB1+n3t03A5XKU0LisSGNeT/0dsMdNYA3M2m/aQynoUxrCRf4DbxcceNIQjVsUzWvmW8CT0GnDfcw7i+7OmOqLeRGpWWVHRdZPb8P0kL7tWJrjC8JgGXUIA=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7694.namprd04.prod.outlook.com (2603:10b6:a03:32a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 23:13:42 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 23:13:42 +0000
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
Subject: Re: [PATCH 02/11] target: add workqueue cmd submission helper
Thread-Topic: [PATCH 02/11] target: add workqueue cmd submission helper
Thread-Index: AQHW+uqzo5O8YYXWckq45ttHWy2b0w==
Date:   Thu, 4 Feb 2021 23:13:42 +0000
Message-ID: <BYAPR04MB4965C9444DFCF8D77E4A9D2286B39@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-3-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc7e683f-dc9c-4807-0c60-08d8c96283db
x-ms-traffictypediagnostic: SJ0PR04MB7694:
x-microsoft-antispam-prvs: <SJ0PR04MB769433E3784FDC4819A1CAB586B39@SJ0PR04MB7694.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZBzcVVD2hQo+52U+LQr+Cs1wfjDFXFtIRkuxjwpz2JdgeKt2bqfgskLItQh8BDC8wT+A3+a7Idaat3UHkiFAwVLjx2VH/bFLb/ad4M+SqoEH7ye2Y+/OBXZW43P9IezNt+hq2l/OTAI6W2dAKfRMCdi97mkCL0WymByglZqRtZLCvUMMQNzz6u3MRNyFZt00qcinFl6XJ/NsE1bfAReeKBT/9NdEApuCSEZsTiGccGkx502hBmG235h3mp2o5N7V/8nLkLM00N4t1iUe2pWNmMvp8ZGrvzjlAbixG3EyqZaYSOiRJz5skGngrBNrYEV7LK6YMJVGVxBxM12CUTq7yW9EZRTfg/1IvF3c52XtKwlcEzup/3FzhMvX4d4Y85W0xauhmTAouAFK4zXRfLbh4xSUOnh8PLVf7vjzyOOjUo2gJgT5Le4gfDzKbbqt6SLpduSIHtztCqLDdNhxT/A9fQPZ0OS59VoveGPxRP2Py+Jorayn6CQyDu5Qm3wztXlmYkTx1Y8ZJIKQ3c2bjty0rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(5660300002)(66476007)(64756008)(86362001)(33656002)(8676002)(76116006)(55016002)(7696005)(66556008)(9686003)(8936002)(110136005)(2906002)(316002)(6506007)(71200400001)(66446008)(53546011)(52536014)(478600001)(66946007)(83380400001)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?izT/k+gd9deZ+HtPZAQm8uHifkcmYn4g6/hWsz9zOgI+4AzId90Uef6qROrF?=
 =?us-ascii?Q?C6xFGVMZW8x6I0Bm5bRAbp2elKaK1578xrvnNqjEUiixBEDu/qjkr2fu/m99?=
 =?us-ascii?Q?pFCn4J4GnqZxZX1ssUFNXzLN/6yA4KjLJH+a2zhHRFdiXj7nm8CAR1Wz3Mmt?=
 =?us-ascii?Q?DmC8ZDmG7eAIllfxEvSW3gEt7TgERvGy4+Eti6tjEl8E61/6vp0gl1ijRbNM?=
 =?us-ascii?Q?1G/h3jfLGNeyoRbL/z03hpK1wWmAbvARwjK3pat5CqCAZGEkiz+ZJMtnwLmS?=
 =?us-ascii?Q?ZYfK+7RXKuuc/bw5ScUlZFAUo0Ck+/29H/1+o9ZQ1dRPXBbbFIQEMugsi5QV?=
 =?us-ascii?Q?yq9F41ZzKc9y9XTU3RwvyX23GSy2XqjFJXsVCJgVrnN2nlkP8vff5zehivgh?=
 =?us-ascii?Q?/hWOF6RlciI2IS6hf9iQrcuxSU4j7ZTlXD44SPP+wdVeQrjp81feSUfYQ+PD?=
 =?us-ascii?Q?5u1e9MiwNUnXOZI9fg7cD3m63l0z8ffStDPrTctcgg+2XOWYZkVkZ4vtY17M?=
 =?us-ascii?Q?qNS0+uY/yiJu4WCU3YiBBa7AJ9EKPrSRF1Yuh9xznyKyG9BTxvHvMzACPqwo?=
 =?us-ascii?Q?wD6u0d5pzXBE97U4vopOtUy9xseCcVasNyVvxydaeAL5D+o/Pk4KiFbwhAvC?=
 =?us-ascii?Q?URVneDwIdA3MvFh0akGVzqJv4kL63Itf6RgV5fEXKaZW4jyzTlISG+fbt8m9?=
 =?us-ascii?Q?N3Aeig7Tje3mosDRhyMGANOQp7ZGkIBy8psoDE8Xbf87Tjedv9xH8QQBhxtA?=
 =?us-ascii?Q?S5s/dJzmEZIEwJkGSBMHV/vML4+IlSfXfIK/EQxZCHTg5vS0SLPtXV/p52lI?=
 =?us-ascii?Q?S7Hjb5Gblr8k3HwE77N1NfFU9cN5r8G2mdR7hn+aFz7BFM2meJYILIpzx+qh?=
 =?us-ascii?Q?XV+USdMifLgyZI9kWC5YQFOxiIMguCKiXix2m+IBLN52HkwBOXv44iH4uGA8?=
 =?us-ascii?Q?TSgFkVWXTRDEUVgjME2b4c+aFJlKJs6c4nkOPLZ1RWuZLBe9AJiB7RDQOJ4U?=
 =?us-ascii?Q?1umJZClNX43TIu4339zEFtk9vKgkzXuZcyTeE6wvIQmMWULepIkvjNRPFV6n?=
 =?us-ascii?Q?tVemy9EwWiSi7e/6fPRyCek2SVVjDvNKv59ZTo/lh1phtYBsURKxD7H1ICfl?=
 =?us-ascii?Q?JZ4fSTB9OtaAr3sqkDng6KIo0Ql/P8Y5uewvijXulzvZLwnfJOM7wId1MPpu?=
 =?us-ascii?Q?NbeAK0buZWoDbbYeuOUlfCbrR+iPGmO7lwGz0pzoBL4ThZog5Gzww8kX2+80?=
 =?us-ascii?Q?/knvH7CfdcHSqV6e8s2JiS5Jjg/Yd5rLtTy2ew2PiGetaO7m6FJj6gt5UVTN?=
 =?us-ascii?Q?fZGymRYtSOiIFFpnCjgCpPfB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7e683f-dc9c-4807-0c60-08d8c96283db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:13:42.7414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e/st0J+tg1S0WATIM4M5XFb5+fr0kyO2jKrF499k0tN6lnDQrcAalELj7BqP7KtB+FEdO1uv9Av9jYjM/FKNPqS7zPSWXF3qgCaFNNohtlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7694
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 03:41, Mike Christie wrote:=0A=
> loop and vhost-scsi do their target cmd submission from driver=0A=
> workqueues. This allows them to avoid an issue where the backend may=0A=
> block waiting for resources like tags/requests, mem/locks, etc=0A=
> and that ends up blocking their entire submission path and for the=0A=
> case of vhost-scsi both the submission and completion path.=0A=
>=0A=
> This patch adds a helper these drivers can use to submit from the=0A=
> lio workqueue. This code will then be extended in the next patches=0A=
> to fix the plugging of backend devices.=0A=
>=0A=
> Signed-off-by: Mike Christie <michael.christie@oracle.com>=0A=
> ---=0A=
>  drivers/target/target_core_transport.c | 102 ++++++++++++++++++++++++-=
=0A=
>  include/target/target_core_base.h      |  10 ++-=0A=
>  include/target/target_core_fabric.h    |   3 +=0A=
>  3 files changed, 111 insertions(+), 4 deletions(-)=0A=
>=0A=
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c=0A=
> index 7c5d37bac561..dec89e911348 100644=0A=
> --- a/drivers/target/target_core_transport.c=0A=
> +++ b/drivers/target/target_core_transport.c=0A=
> @@ -41,6 +41,7 @@=0A=
>  #include <trace/events/target.h>=0A=
>  =0A=
>  static struct workqueue_struct *target_completion_wq;=0A=
> +static struct workqueue_struct *target_submission_wq;=0A=
>  static struct kmem_cache *se_sess_cache;=0A=
>  struct kmem_cache *se_ua_cache;=0A=
>  struct kmem_cache *t10_pr_reg_cache;=0A=
> @@ -129,8 +130,15 @@ int init_se_kmem_caches(void)=0A=
>  	if (!target_completion_wq)=0A=
>  		goto out_free_lba_map_mem_cache;=0A=
>  =0A=
> +	target_submission_wq =3D alloc_workqueue("target_submission",=0A=
> +					       WQ_MEM_RECLAIM, 0);=0A=
> +	if (!target_submission_wq)=0A=
> +		goto out_free_completion_wq;=0A=
> +=0A=
>  	return 0;=0A=
>  =0A=
> +out_free_completion_wq:=0A=
> +	destroy_workqueue(target_completion_wq);=0A=
>  out_free_lba_map_mem_cache:=0A=
>  	kmem_cache_destroy(t10_alua_lba_map_mem_cache);=0A=
>  out_free_lba_map_cache:=0A=
> @@ -153,6 +161,7 @@ int init_se_kmem_caches(void)=0A=
>  =0A=
>  void release_se_kmem_caches(void)=0A=
>  {=0A=
> +	destroy_workqueue(target_submission_wq);=0A=
>  	destroy_workqueue(target_completion_wq);=0A=
>  	kmem_cache_destroy(se_sess_cache);=0A=
>  	kmem_cache_destroy(se_ua_cache);=0A=
> @@ -218,6 +227,69 @@ static void target_release_sess_cmd_refcnt(struct pe=
rcpu_ref *ref)=0A=
>  	wake_up(&sess->cmd_count_wq);=0A=
>  }=0A=
>  =0A=
> +static void target_queued_submit_work(struct work_struct *work)=0A=
> +{=0A=
> +	struct se_sess_cmd_queue *sq =3D=0A=
> +				container_of(work, struct se_sess_cmd_queue,=0A=
> +					     work);=0A=
> +	struct se_session *se_sess =3D sq->se_sess;=0A=
> +	struct se_cmd *se_cmd, *next_cmd;=0A=
> +	struct llist_node *cmd_list;=0A=
> +=0A=
> +	cmd_list =3D llist_del_all(&sq->cmd_list);=0A=
> +	if (!cmd_list)=0A=
> +		/* Previous call took what we were queued to submit */=0A=
> +		return;=0A=
> +=0A=
> +	cmd_list =3D llist_reverse_order(cmd_list);=0A=
> +	llist_for_each_entry_safe(se_cmd, next_cmd, cmd_list, se_cmd_list)=0A=
> +		se_sess->tfo->submit_queued_cmd(se_cmd);=0A=
> +}=0A=
> +=0A=
> +static void target_queue_cmd_work(struct se_sess_cmd_queue *q,=0A=
> +				  struct se_cmd *se_cmd, int cpu)=0A=
> +{=0A=
> +	llist_add(&se_cmd->se_cmd_list, &q->cmd_list);=0A=
> +	queue_work_on(cpu, target_submission_wq, &q->work);=0A=
> +}=0A=
> +=0A=
> +/**=0A=
> + * target_queue_cmd_submit - queue a se_cmd to be executed from the lio =
wq=0A=
> + * @se_sess: cmd's session=0A=
> + * @cmd_list: cmd to queue=0A=
> + */=0A=
> +void target_queue_cmd_submit(struct se_session *se_sess, struct se_cmd *=
se_cmd)=0A=
> +{=0A=
> +	int cpu =3D smp_processor_id();=0A=
> +=0A=
> +	target_queue_cmd_work(&se_sess->sq[cpu], se_cmd, cpu);=0A=
> +}=0A=
> +EXPORT_SYMBOL_GPL(target_queue_cmd_submit);=0A=
> +=0A=
> +static void target_flush_queued_cmds(struct se_session *se_sess)=0A=
> +{=0A=
> +	int i;=0A=
> +=0A=
> +	if (!se_sess->sq)=0A=
> +		return;=0A=
> +=0A=
> +	for (i =3D 0; i < se_sess->q_cnt; i++)=0A=
> +		cancel_work_sync(&se_sess->sq[i].work);=0A=
> +}=0A=
> +=0A=
> +static void target_init_sess_cmd_queues(struct se_session *se_sess,=0A=
> +					struct se_sess_cmd_queue *q,=0A=
> +					void (*work_fn)(struct work_struct *work))=0A=
> +{=0A=
> +	int i;=0A=
> +=0A=
> +	for (i =3D 0; i < se_sess->q_cnt; i++) {=0A=
> +		init_llist_head(&q[i].cmd_list);=0A=
> +		INIT_WORK(&q[i].work, work_fn);=0A=
> +		q[i].se_sess =3D se_sess;=0A=
> +	}=0A=
> +}=0A=
> +=0A=
Can we opencode above function if there is only one caller ?=0A=
unless there is a specific reason to have it on its own which I failed to=
=0A=
understand.=0A=
>  /**=0A=
>   * transport_init_session - initialize a session object=0A=
>   * @tfo: target core fabric ops=0A=
> @@ -228,6 +300,8 @@ static void target_release_sess_cmd_refcnt(struct per=
cpu_ref *ref)=0A=
>  int transport_init_session(const struct target_core_fabric_ops *tfo,=0A=
>  			   struct se_session *se_sess)=0A=
>  {=0A=
> +	int rc;=0A=
> +=0A=
>  	INIT_LIST_HEAD(&se_sess->sess_list);=0A=
>  	INIT_LIST_HEAD(&se_sess->sess_acl_list);=0A=
>  	spin_lock_init(&se_sess->sess_cmd_lock);=0A=
> @@ -235,13 +309,34 @@ int transport_init_session(const struct target_core=
_fabric_ops *tfo,=0A=
>  	init_completion(&se_sess->stop_done);=0A=
>  	atomic_set(&se_sess->stopped, 0);=0A=
>  	se_sess->tfo =3D tfo;=0A=
> -	return percpu_ref_init(&se_sess->cmd_count,=0A=
> -			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);=0A=
> +=0A=
> +	if (tfo->submit_queued_cmd) {=0A=
> +		se_sess->sq =3D kcalloc(nr_cpu_ids, sizeof(*se_sess->sq),=0A=
> +				      GFP_KERNEL);=0A=
> +		if (!se_sess->sq)=0A=
> +			return -ENOMEM;=0A=
> +=0A=
> +		se_sess->q_cnt =3D nr_cpu_ids;=0A=
> +		target_init_sess_cmd_queues(se_sess, se_sess->sq,=0A=
> +					    target_queued_submit_work);=0A=
> +	}=0A=
> +=0A=
> +	rc =3D percpu_ref_init(&se_sess->cmd_count,=0A=
> +			     target_release_sess_cmd_refcnt, 0, GFP_KERNEL);=0A=
> +	if (rc)=0A=
> +		goto free_sq;=0A=
> +=0A=
> +	return 0;=0A=
> +=0A=
> +free_sq:=0A=
> +	kfree(se_sess->sq);=0A=
> +	return rc;=0A=
>  }=0A=
>  EXPORT_SYMBOL(transport_init_session);=0A=
>  =0A=
>  void transport_uninit_session(struct se_session *se_sess)=0A=
>  {=0A=
> +	kfree(se_sess->sq);=0A=
>  	/*=0A=
>  	 * Drivers like iscsi and loop do not call target_stop_session=0A=
>  	 * during session shutdown so we have to drop the ref taken at init=0A=
> @@ -1385,7 +1480,6 @@ void transport_init_se_cmd(=0A=
>  {=0A=
>  	INIT_LIST_HEAD(&cmd->se_delayed_node);=0A=
>  	INIT_LIST_HEAD(&cmd->se_qf_node);=0A=
> -	INIT_LIST_HEAD(&cmd->se_cmd_list);=0A=
>  	INIT_LIST_HEAD(&cmd->state_list);=0A=
>  	init_completion(&cmd->t_transport_stop_comp);=0A=
>  	cmd->free_compl =3D NULL;=0A=
> @@ -2968,6 +3062,8 @@ void target_wait_for_sess_cmds(struct se_session *s=
e_sess)=0A=
>  {=0A=
>  	int ret;=0A=
>  =0A=
> +	target_flush_queued_cmds(se_sess);=0A=
> +=0A=
>  	WARN_ON_ONCE(!atomic_read(&se_sess->stopped));=0A=
>  =0A=
>  	do {=0A=
> diff --git a/include/target/target_core_base.h b/include/target/target_co=
re_base.h=0A=
> index 50103a22b0e2..97138bff14d1 100644=0A=
> --- a/include/target/target_core_base.h=0A=
> +++ b/include/target/target_core_base.h=0A=
> @@ -488,7 +488,7 @@ struct se_cmd {=0A=
>  	/* Only used for internal passthrough and legacy TCM fabric modules */=
=0A=
>  	struct se_session	*se_sess;=0A=
>  	struct se_tmr_req	*se_tmr_req;=0A=
> -	struct list_head	se_cmd_list;=0A=
> +	struct llist_node	se_cmd_list;=0A=
>  	struct completion	*free_compl;=0A=
>  	struct completion	*abrt_compl;=0A=
>  	const struct target_core_fabric_ops *se_tfo;=0A=
> @@ -612,6 +612,12 @@ static inline struct se_node_acl *fabric_stat_to_nac=
l(struct config_item *item)=0A=
>  			acl_fabric_stat_group);=0A=
>  }=0A=
>  =0A=
> +struct se_sess_cmd_queue {=0A=
> +	struct llist_head	cmd_list;=0A=
> +	struct work_struct	work;=0A=
> +	struct se_session	*se_sess;=0A=
> +};=0A=
> +=0A=
>  struct se_session {=0A=
>  	atomic_t		stopped;=0A=
>  	u64			sess_bin_isid;=0A=
> @@ -629,6 +635,8 @@ struct se_session {=0A=
>  	void			*sess_cmd_map;=0A=
>  	struct sbitmap_queue	sess_tag_pool;=0A=
>  	const struct target_core_fabric_ops *tfo;=0A=
> +	struct se_sess_cmd_queue *sq;=0A=
> +	int			q_cnt;=0A=
>  };=0A=
>  =0A=
>  struct se_device;=0A=
> diff --git a/include/target/target_core_fabric.h b/include/target/target_=
core_fabric.h=0A=
> index cdf610838ba5..899948967a65 100644=0A=
> --- a/include/target/target_core_fabric.h=0A=
> +++ b/include/target/target_core_fabric.h=0A=
> @@ -80,6 +80,7 @@ struct target_core_fabric_ops {=0A=
>  	int (*queue_status)(struct se_cmd *);=0A=
>  	void (*queue_tm_rsp)(struct se_cmd *);=0A=
>  	void (*aborted_task)(struct se_cmd *);=0A=
> +	void (*submit_queued_cmd)(struct se_cmd *);=0A=
>  	/*=0A=
>  	 * fabric module calls for target_core_fabric_configfs.c=0A=
>  	 */=0A=
> @@ -166,6 +167,8 @@ int	target_submit_tmr(struct se_cmd *se_cmd, struct s=
e_session *se_sess,=0A=
>  		unsigned char *sense, u64 unpacked_lun,=0A=
>  		void *fabric_tmr_ptr, unsigned char tm_type,=0A=
>  		gfp_t, u64, int);=0A=
> +void	target_queue_cmd_submit(struct se_session *se_sess,=0A=
> +				struct se_cmd *se_cmd);=0A=
>  int	transport_handle_cdb_direct(struct se_cmd *);=0A=
>  sense_reason_t	transport_generic_new_cmd(struct se_cmd *);=0A=
>  =0A=
=0A=
