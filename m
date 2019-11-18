Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E172C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 00:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 579262084C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 00:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qBszA7iE";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="HPmGXrR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfKRASx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 19:18:53 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:59890 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfKRASx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Nov 2019 19:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1574036332; x=1605572332;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=bF/mqdfHaiAZu8zVetw+ol2DzBiP1/ET1zt8BugLrpk=;
  b=qBszA7iEKV7/1qtcfsPlZakG9xHcW5Le5/+qANsNyzsS0uXV1r2qKrRy
   KQW1cd/lN4Je4XaNEz/U/d8sbfPt8aoqaDGhtl3YO0/QstNyypK17fZ5Z
   f9yN/YG4sIb3QmlKRW9DB3NclWxQV1NgFrgBQAJK+EJI9w204aXRTQsUq
   Ohw7OWhP4HhmxpmgZS//IqDEIzVdD8BZ9Pf2Uplwq7fK3232mFUBOdRpH
   diRKunfynTivyTrfhvvNVhWKCtrcZh0pR9s9cZf3CYJGkM7uJGXo2EfMo
   7EZDqrxFnu9e2vJLj0a3WmMaOr2reHz+Io0rMXNTjDNRTDg4xKUvhxHwO
   A==;
IronPort-SDR: cMy1RvBhxiwJip9S97akj5RQRjaqE+Mj8TvlRu0el1waN9KLcehIBoED4BGVcgSPOUetHyHm3L
 Tf+lpwu5foDJNGZBKWch1/qzffBqNXyBkjuPQWos01c/sIlYZ6I4oSNMZFvJTZXQk+qxqCdCpD
 yeMBXhDWCg4Jpwl8f8m6r6Bk5210uQcVkeciala3wJ5kk79UnYLOMtKs8J5remGg5bajTUlL/u
 20L8fwxe+S1VGUUlN9Bx19OeTupatfqR1qS/SUknaD1vJLwLGRl56+w9d2qXUtZfvigFubhOwR
 3vY=
X-IronPort-AV: E=Sophos;i="5.68,318,1569254400"; 
   d="scan'208";a="127691768"
Received: from mail-bn3nam01lp2055.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.55])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2019 08:18:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cz9J10K1JA8l87gO1/w2Um8VZ195hNAxzNKkXSPUZUjB8zvwnXd9GLnQne5Wf3n2g4JTj1e4ED7Lpl1ySEqVpeuav9J6T7bxRjmEuRSoDYm8K3RH54w5czo+ogVKWYV1FR/NBFnyF7bM6Ndzej2aZsO0Fc6ZTxwMMdjDGLomXjQ9NPAR4sgzt3FdIbhc0chKHd5ZLwFfubH7wQodx+JnpbGNwQ71osk8jtSV4DSY9uD+CcvId9t9k2ZXTlpwNU6xkdqbHLGC/niC6sHMV7xBsS8bR7syMOzT0PgPiBF7GDcez4kiwd3Qc1byb5PEKF2hgxKXHI5dr8lhQsrmnF6lWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj780KtYNpMyzqI0JGKl9M+dGpkxo6HyBhmhbx/A/N0=;
 b=SSFYAzm5cizwHScF84zZvCCcM8ouw4r/rgl2GSoZVUlgUFK2llkIA+C7fmXWr/dhMUNcYoHBzFv9isqPffsViOjLUqrX4TlQTg9mCHtHvEDWOr3fix0y7oPpEjQM+tuG7WtPgcMi+sGIf03HjfZJZrfhc+J+y31k8djEAGLKT4DrIGsvLjfTTERsF7mtdSoG/qXYdRGhev1VkmduaNwIZiFasd5xBtRm1WnUkjnvZjXj16sxqny2gdXteYC6XokN1v+KtQ/cr/9yBLaW7rTD7ev+rWVKdphEeNza3RGqkd9l2quco5jpBKZEawbpMtzlc6kN8S0v85IqtOTN0zvT+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gj780KtYNpMyzqI0JGKl9M+dGpkxo6HyBhmhbx/A/N0=;
 b=HPmGXrR1SAnTOFq1KJXvtcaMTTN+YoGiUP5upC9G1KAk82RzFUO2q+kNL9sOxlctBR0g5YyZRNtxwopQ8p/wPXKLA4ASQECO+oZu4De58JaR+eD54J1F1JmzU+hGKkjd8hjKYAVFpHIP4NmASLjZ5GGf5ny1swNTh9uwjYkLM9w=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5447.namprd04.prod.outlook.com (20.178.48.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Mon, 18 Nov 2019 00:18:48 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::4176:5eda:76a2:3c40%7]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 00:18:48 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Long Li <longli@microsoft.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Thread-Topic: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
 device queue is busy
Thread-Index: AQHVnR45YZU1Ch7oXEGY0W7soieOsg==
Date:   Mon, 18 Nov 2019 00:18:48 +0000
Message-ID: <BYAPR04MB5816F43072584F8F20EF4292E74D0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191117080818.2664-1-ming.lei@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 13cbf91c-95aa-40ba-44b2-08d76bbce1f2
x-ms-traffictypediagnostic: BYAPR04MB5447:
x-microsoft-antispam-prvs: <BYAPR04MB54470C2EBCA5BDD2C910C4C8E74D0@BYAPR04MB5447.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(199004)(189003)(54094003)(2501003)(66946007)(14454004)(66476007)(66446008)(478600001)(66556008)(52536014)(4326008)(81166006)(64756008)(316002)(33656002)(5660300002)(6246003)(8676002)(110136005)(99286004)(76116006)(81156014)(25786009)(91956017)(186003)(6506007)(53546011)(305945005)(102836004)(446003)(26005)(7736002)(476003)(3846002)(6116002)(66066001)(86362001)(54906003)(8936002)(2906002)(229853002)(71200400001)(55016002)(6436002)(9686003)(14444005)(256004)(7696005)(71190400001)(76176011)(7416002)(486006)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5447;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: thWhMxOm+STN8yFTPBoHEhwMmh1ZCjZC3pGeWc6F1l8dv4qVnh8LfqEo4QXrthI/3d26Gofiragl3POwNsVepSlJnGyk7hjb835I1k6ZYkzPUDyo811obcJbnhj+z3Q3DtyD9QLD2S7UWFvbAXnTYrm8X6167/w6whob1sdcRIUWSD5nlCgSE/X1LaAXiND9u9nARIIzRQIF3t7Gd8DJyIWPeU6qfOQM+vxEzXhLzYK8amrWrAFMlB9fNa6/bdiGLSDe2XwV+n0aM04sMc7OY4fBbG512u2fetdTfZslPMHMg07PcJz8YlDdGsEVg12lwQq3Wvvqh9VuGyASa8FkUHtR0qfgeyzsBL9o/F0BpRClaEVproGj/7jGa4+Rumk+fK9VEL80vnic009cmvRCGMpTEqBEbx/ZCU9BLxzjgf/l5447jofAVLqTjA10pEga
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13cbf91c-95aa-40ba-44b2-08d76bbce1f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 00:18:48.3789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VeUTE7i2FSyUcH2OOQ7mT4D7hc2iiih/2SAvQz9ZpY+gH3KH6wyOGNCABStfZt82bs1bhejdhflaiiTAd+E5HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5447
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/11/17 17:08, Ming Lei wrote:=0A=
> Now the requeue queue is run in scsi_end_request() unconditionally if bot=
h=0A=
> target queue and host queue is ready. We should have re-run request queue=
=0A=
> only after this device queue becomes busy for restarting this LUN only.=
=0A=
> =0A=
> Recently Long Li reported that cost of run queue may be very heavy in=0A=
> case of high queue depth. So improve this situation by only running=0A=
> requesut queue when this LUN is busy.=0A=
=0A=
s/requesut/request=0A=
=0A=
Also, shouldn't this patch have the tag:=0A=
=0A=
Reported-by: Long Li <longli@microsoft.com>=0A=
=0A=
?=0A=
=0A=
Another remark is that Long's approach is generic to the block layer=0A=
while your patch here is scsi specific. I wonder if the same problem=0A=
cannot happen with other drivers too ?=0A=
=0A=
> =0A=
> Cc: Jens Axboe <axboe@kernel.dk>=0A=
> Cc: Ewan D. Milne <emilne@redhat.com>=0A=
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>=0A=
> Cc: Hannes Reinecke <hare@suse.de>=0A=
> Cc: Bart Van Assche <bvanassche@acm.org>=0A=
> Cc: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Cc: Long Li <longli@microsoft.com>=0A=
> Cc: linux-block@vger.kernel.org=0A=
> Signed-off-by: Ming Lei <ming.lei@redhat.com>=0A=
> ---=0A=
>  drivers/scsi/scsi_lib.c    | 29 +++++++++++++++++++++++++++--=0A=
>  include/scsi/scsi_device.h |  1 +=0A=
>  2 files changed, 28 insertions(+), 2 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
> index 379533ce8661..212903d5f43c 100644=0A=
> --- a/drivers/scsi/scsi_lib.c=0A=
> +++ b/drivers/scsi/scsi_lib.c=0A=
> @@ -612,7 +612,7 @@ static bool scsi_end_request(struct request *req, blk=
_status_t error,=0A=
>  	if (scsi_target(sdev)->single_lun ||=0A=
>  	    !list_empty(&sdev->host->starved_list))=0A=
>  		kblockd_schedule_work(&sdev->requeue_work);=0A=
> -	else=0A=
> +	else if (READ_ONCE(sdev->restart))=0A=
>  		blk_mq_run_hw_queues(q, true);=0A=
>  =0A=
>  	percpu_ref_put(&q->q_usage_counter);=0A=
> @@ -1632,8 +1632,33 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ct=
x *hctx)=0A=
>  	struct request_queue *q =3D hctx->queue;=0A=
>  	struct scsi_device *sdev =3D q->queuedata;=0A=
>  =0A=
> -	if (scsi_dev_queue_ready(q, sdev))=0A=
> +	if (scsi_dev_queue_ready(q, sdev)) {=0A=
> +		WRITE_ONCE(sdev->restart, 0);=0A=
>  		return true;=0A=
> +	}=0A=
> +=0A=
> +	/*=0A=
> +	 * If all in-flight requests originated from this LUN are completed=0A=
> +	 * before setting .restart, sdev->device_busy will be observed as=0A=
> +	 * zero, then blk_mq_delay_run_hw_queue() will dispatch this request=0A=
> +	 * soon. Otherwise, completion of one of these request will observe=0A=
> +	 * the .restart flag, and the request queue will be run for handling=0A=
> +	 * this request, see scsi_end_request().=0A=
> +	 *=0A=
> +	 * However, the .restart flag may be cleared from other dispatch code=
=0A=
> +	 * path after one inflight request is completed, then:=0A=
> +	 *=0A=
> +	 * 1) if this reqquest is dispatched from scheduler queue or sw queue o=
ne=0A=
> +	 * by one, this request will be handled in that dispatch path too given=
=0A=
> +	 * the request still stays at scheduler/sw queue when calling .get_budg=
et()=0A=
> +	 * callback.=0A=
> +	 *=0A=
> +	 * 2) if this request is dispatched from hctx->dispatch or=0A=
> +	 * blk_mq_flush_busy_ctxs(), this request will be put into hctx->dispat=
ch=0A=
> +	 * list soon, and blk-mq will be responsible for covering it, see=0A=
> +	 * blk_mq_dispatch_rq_list().=0A=
> +	 */=0A=
> +	WRITE_ONCE(sdev->restart, 1);=0A=
>  =0A=
>  	if (atomic_read(&sdev->device_busy) =3D=3D 0 && !scsi_device_blocked(sd=
ev))=0A=
>  		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);=0A=
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h=0A=
> index 202f4d6a4342..9d8ca662ae86 100644=0A=
> --- a/include/scsi/scsi_device.h=0A=
> +++ b/include/scsi/scsi_device.h=0A=
> @@ -109,6 +109,7 @@ struct scsi_device {=0A=
>  	atomic_t device_busy;		/* commands actually active on LLDD */=0A=
>  	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */=0A=
>  =0A=
> +	unsigned int restart;=0A=
>  	spinlock_t list_lock;=0A=
>  	struct list_head cmd_list;	/* queue of in use SCSI Command structures *=
/=0A=
>  	struct list_head starved_entry;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
