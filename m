Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB97C49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 16:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A31D2053B
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 16:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KebYHbK3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GKjeRBll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391809AbfISQOA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 12:14:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31211 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388133AbfISQOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Sep 2019 12:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568909638; x=1600445638;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=VvUF9KolcfVTVhPVNcH/xcrtf8S37z8ghg98lO+0jEI=;
  b=KebYHbK3DS4TLRUy++V5adUQ57pHGPxMwJ2n9CNEjbGYJM0ydtfTQ5pf
   Hk/EkvuIFi3pVfsj+6vUiy0x568pL96jFqHl/XjyrTNcMGpgha1gGB1zA
   ekKoFSo/pcHDkKM9TNwOU5FPCf3SuSD5btUz60sauPHwOODB48YCjUpar
   XMG1w+yCu1twOK4vaXst71rkD2jJY8RYmnI9l74rsaNFtsD0rbPK+iWAE
   97oziaPdrKsadvVH0IK0jNVkWq+obwKtvZkqZCnsePrdOjisHMg0DDWOU
   1+NLtlDO+AHrs7llZ/8m9WYFgLjf1DV5wH9U1Qb7XGDv1ZGV7RgDp+x6P
   w==;
IronPort-SDR: UwqTdEN0YU+Hb7AlSgmF36W9j6uS5TSy/eLJbiALXdKi+HmPxiTvUnBwePQe05/sTFb8l35k18
 jDCc0g+jCLqc4iDEcgFZXIRLLo3UmqmhVlQc0egIyKLUCMMKZ1ctXohCzmNSjKbTo5/GQWVC0D
 L4bAVbwF605jyrrPsI6v+gDJA/PrpS16Ar957G9GK7Txvl9SteXEtM5Po55Bl0wPSl3GH6GtRM
 pdBLlVzLMXyC516/+oTqdG+ws6xcyFQn5Fd88NBRxATIvJwIllIfyoDbvuhswAbwQ2oOXnUIgX
 fSY=
X-IronPort-AV: E=Sophos;i="5.64,524,1559491200"; 
   d="scan'208";a="225471958"
Received: from mail-sn1nam02lp2056.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.56])
  by ob1.hgst.iphmx.com with ESMTP; 20 Sep 2019 00:13:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aW1Y6q/RTsKBoVN2sT/sNUaArlxG3MJGpHBs0GIlmKNJ8mEm7EIjM4S37ZBA4wZKSbdHLGiMiTxED9NEotVIqiJ5l+mlnW3BYzXDafjVBmSatL6yAMDgmz5cU9G1+5YfXneJbV+NGdDE5/TbIcsSDzWAZSi6AlWQHBZI8ofP3csXwQDgY/JyUNINdwXiTV7Z7duqXJAnwNB8X6xnFvoaz0mcZOpmxR+opNfl5BB9pJ7Z0rC2A2u0BbMbcqTFMTYEvr8Y5l66CbBHWcxX2Ojvqci4zjNOqe0S1VXpvRcfOtnTep8OP+62Zp4kme2Knipq4xGCw0Ao6+G0/bFKcoqhLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qAKAUkdUeSFjdjZOnEPDaEcgn2eptb5Yv0ysr727JM=;
 b=LUxxasgyIYfTrU/Bb4LhBrZptC3fnZUm1y8L/qPmQiYZKYTCEPde7w+2Gw0BfRsVctDgGVp+xDhsiokgucKA+ipj25TClCBM9aAQI/tCf+i9CNHIg7HFXOaWKnrEo9/yKq7Meon1fBuslGVJQ+OY9eM8NYEPazcNfx/1MBdzdPWg1sJBasmQpDsUeJsi31ADGRXOxlWqhj6PrPD9QvwqBj/fwVX9rJPQyf17N5jZ/CJvTrOwdGPIqB1/WQ3Q+lWBIlwni7clJMKFbKb+1lGo7KRNY6Pcr9Rj1N5go4t/I/Mj9c25OyPipTHkcDfAUwL7ae0RlwwwW5vWmdpSp7XsuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qAKAUkdUeSFjdjZOnEPDaEcgn2eptb5Yv0ysr727JM=;
 b=GKjeRBllt3ZOoLjdQ3dlu1VaQ/btd5ktVfrEkZ3CbJTaFaW3fX4/b/g2wqhVn6mUIVeVMATRyoiwwb2fQH9sJaLB4P1d7dkap4vwXWIKhfh6XDiYqbshnmdvf0gyiioQHkHRYNJNcvCQPgF5LYZVHnNiUPKxnVKX/N+7zJvPTs0=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB3782.namprd04.prod.outlook.com (52.135.214.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.13; Thu, 19 Sep 2019 16:13:56 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::9821:67e1:9799:b117%3]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 16:13:56 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 2/2] blk-mq: always call into the scheduler in
 blk_mq_make_request()
Thread-Topic: [PATCH 2/2] blk-mq: always call into the scheduler in
 blk_mq_make_request()
Thread-Index: AQHVbs8K3cwX+YB3YkG6oq7+AYxM/w==
Date:   Thu, 19 Sep 2019 16:13:56 +0000
Message-ID: <BYAPR04MB5816CE9F237CF189E56AF420E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190919094547.67194-1-hare@suse.de>
 <20190919094547.67194-3-hare@suse.de>
 <BYAPR04MB5816F1F98D8F408D23C1AF47E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20190919142344.GB11207@ming.t460p>
 <935518233f147da073414dcbcdb2abb5@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [79.98.72.135]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0dfee997-43f1-4b70-bae2-08d73d1c5f3a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB3782;
x-ms-traffictypediagnostic: BYAPR04MB3782:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB3782487E420F89E8107CE7A1E7890@BYAPR04MB3782.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(189003)(51914003)(199004)(33656002)(81166006)(81156014)(6246003)(486006)(8676002)(71190400001)(71200400001)(55016002)(14444005)(256004)(9686003)(26005)(4326008)(76116006)(66066001)(91956017)(2906002)(446003)(66446008)(66946007)(64756008)(66556008)(66476007)(186003)(8936002)(476003)(14454004)(316002)(7736002)(6116002)(25786009)(102836004)(6436002)(99286004)(3846002)(86362001)(229853002)(6506007)(110136005)(54906003)(74316002)(7416002)(305945005)(53546011)(7696005)(5660300002)(76176011)(478600001)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3782;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U24iuwNcjGupPiMf/95Vz1Ynq4ZhFSXW4bJv37NgEo/RaQ+W0IZXR2nIe0pgN3egTqP8adHDYrZNqFx6oJLTdvqBrU9nyZ0le1CF6MQDN0eWNS0jD2/sIeGnWM/uOPTk0FkK+xNmkmFhkRO2aDCtGIoNG3qTySTZNlETPezH+Mb5jxBrJBlEvAZafcfelMbUV7Dtp4WIcb/6IpKVsBD6ba0vWVIsBMzcUsgTRAzgLB0rfmFTT846eZ9u7suI4bXJWrDqEwG+09VaBHOi5isqLCCiLxaNV+VfZZndFMvAZK6PGsJsP41gkLuVEfalS/E6LtP6QLjSIjfSuqLWU/FbArUFIlVfguexhMydEvks6A787mogXCUJ5rGpUXmhEw907P43lwbOBeajzLEUFSGQvMvymh8R1IHpnj4NbgkK1h0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dfee997-43f1-4b70-bae2-08d73d1c5f3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 16:13:56.0698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ujvP631waIKtMXAseQTJcYDWEZR7wZAHIW/76C7WIkPHeF7z5GYDYew9evDVJTRoUyYKnNB7lM7LBnQBzZRXiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3782
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/19 17:48, Kashyap Desai wrote:=0A=
>>>> -	} else if (plug && (q->nr_hw_queues =3D=3D 1 || q->mq_ops-=0A=
>>> commit_rqs)) {=0A=
>>>> +	} else if (plug && q->mq_ops->commit_rqs) {=0A=
>>>>  		/*=0A=
>>>>  		 * Use plugging if we have a ->commit_rqs() hook as well,=0A=
> as=0A=
>>>>  		 * we know the driver uses bd->last in a smart fashion.=0A=
>>>> @@ -2020,9 +2019,6 @@ static blk_qc_t blk_mq_make_request(struct=0A=
>> request_queue *q, struct bio *bio)=0A=
>>>>  			blk_mq_try_issue_directly(data.hctx,=0A=
> same_queue_rq,=0A=
>>>>  					&cookie);=0A=
>>>>  		}=0A=
>>>> -	} else if ((q->nr_hw_queues > 1 && is_sync) || (!q->elevator &&=0A=
>>>> -			!data.hctx->dispatch_busy)) {=0A=
>>>> -		blk_mq_try_issue_directly(data.hctx, rq, &cookie);=0A=
> Hannes -=0A=
> =0A=
> Earlier check prior to "commit 6ce3dd6eec114930cf2035a8bcb1e80477ed79a8"=
=0A=
> was only (q->nr_hw_queues > 1 && is_sync).=0A=
> I am not sure if check of nr_hw_queues are required or not at this place,=
=0A=
> but other part of check (!q->elevator && !data.hctx->dispatch_busy) to=0A=
> qualify for direct dispatch is required for higher performance.=0A=
> =0A=
> Recent MegaRaid and MPT HBA Aero series controller is capable of doing=0A=
> ~3.0 M IOPs and for such high performance using single hardware queue,=0A=
>  commit 6ce3dd6eec114930cf2035a8bcb1e80477ed79a8 is very important.=0A=
=0A=
Kashyap, Ming,=0A=
=0A=
Thanks for the information. We will restore this case.=0A=
=0A=
> =0A=
> Kashyap=0A=
> =0A=
> =0A=
>>>=0A=
>>> It may be worth mentioning that blk_mq_sched_insert_request() will do=
=0A=
>>> a direct insert of the request using __blk_mq_insert_request(). But=0A=
>>> that insert is slightly different from what=0A=
>>> blk_mq_try_issue_directly() does with=0A=
>>> __blk_mq_issue_directly() as the request in that case is passed along=
=0A=
>>> to the device using queue->mq_ops->queue_rq() while=0A=
>>> __blk_mq_insert_request() will put the request in ctx->rq_lists[type].=
=0A=
>>>=0A=
>>> This removes the optimized case !q->elevator &&=0A=
>>> !data.hctx->dispatch_busy, but I am not sure of the actual performance=
=0A=
>>> impact yet. We may want to patch=0A=
>>> blk_mq_sched_insert_request() to handle that case.=0A=
>>=0A=
>> The optimization did improve IOPS of single queue SCSI SSD a lot, see=0A=
>>=0A=
>> commit 6ce3dd6eec114930cf2035a8bcb1e80477ed79a8=0A=
>> Author: Ming Lei <ming.lei@redhat.com>=0A=
>> Date:   Tue Jul 10 09:03:31 2018 +0800=0A=
>>=0A=
>>     blk-mq: issue directly if hw queue isn't busy in case of 'none'=0A=
>>=0A=
>>     In case of 'none' io scheduler, when hw queue isn't busy, it isn't=
=0A=
>>     necessary to enqueue request to sw queue and dequeue it from=0A=
>>     sw queue because request may be submitted to hw queue asap without=
=0A=
>>     extra cost, meantime there shouldn't be much request in sw queue,=0A=
>>     and we don't need to worry about effect on IO merge.=0A=
>>=0A=
>>     There are still some single hw queue SCSI HBAs(HPSA, megaraid_sas,=
=0A=
> ...)=0A=
>>     which may connect high performance devices, so 'none' is often=0A=
> required=0A=
>>     for obtaining good performance.=0A=
>>=0A=
>>     This patch improves IOPS and decreases CPU unilization on=0A=
> megaraid_sas,=0A=
>>     per Kashyap's test.=0A=
>>=0A=
>>=0A=
>> Thanks,=0A=
>> Ming=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
