Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78648CA9EA1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 12:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AFDE21852
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 12:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VVEolItP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="eqagv+Ig"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408143AbfJRMd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 08:33:56 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2696 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731028AbfJRMd4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 08:33:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571402048; x=1602938048;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=l0DieIXkOd4rOHIChamwUiyXqfHG1CnpsGY4OSFPRS0=;
  b=VVEolItP8p5DT0NYj6MZUHB05uZ6LFXZflLt/feekKeyN5VjEhb39tmh
   LXvAPTj0C6K6UK70hLzfRfo/pLZRCQeoj4/FBgkfZ2ZsE3QX3GiI31HpW
   BlzMLnalUhF1ZrdROa7hbF99O/y06D5ss436eX1Pf5K64o1kfEqJDDbr7
   XhLn3FyUc29w99GrOJOL2bMpCFUwL99qoODw6UO9fFd2k2q1RvFh2WFDO
   YGIW9fUWvPIkFK8ZGL/xaZEm3mvFfVqafwbJGKx6xvOYT+RVYC0VqHtKr
   XxXUwoZFktGV4gRdzoDlWsZWKHJ8bghZfyHtG6hT50I4w8qQnYzBNWEky
   A==;
IronPort-SDR: 6TjgcM0L5rJ8NKHZTH+aIrKMobFa1iZLvAdho44FAZj0k26vXqfz8p0pQIxCYVlqnW61guqyAV
 KRPEU0Y5gzSpHlLYlsolXO5iwwL6HQY6ZgGplWY8vHp6AD1Ksgqat6PgDQB1OGJFHW4jcQX2gq
 D/ARyEqlNAEr/L98xlCLPwr+eaqQOHaKhnKB+oYKWnoQPTOW1Tm3rmskf1tMsURRkRtogsZ2O0
 qYogIcTDXsRG2UrQu76uPJh0KDjJ/PmEcQLjUd638VxM9GJNDvYpTclZ1JKDEe8W3d7udpD6ge
 JT4=
X-IronPort-AV: E=Sophos;i="5.67,311,1566835200"; 
   d="scan'208";a="221907426"
Received: from mail-dm3nam05lp2053.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.53])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2019 20:34:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3BBn8ivWGTQu3ZojDAXU25dNhqUehE+OmV6GBp5HJIZB0iWbgePAbDCu/eb+DzO0m7wUnkxl6IG1elh6Iz6t9eP9KaupP77ijoyqRGfCC8yZhs79HluP7uqZyLjihIEaj7yN9e11MCkIJrzpW1oJR3RcIavvI4qFJrOU2cLkuVPHUqnfxuwl5yMXzwuKMQ0M5LhfH1A/BPx4UQhH4x0OSwPmXTiUY98Yp1HHjXgReyfHZTInSdxu4w316MRJc+Xn4XSJjhNNQppcQ7WjbKTkoY6peuTwWHgTpjgpMwpXNSWN1wFmgvXVV0/l3XD0fw6H/RgXEhM13oPMH7h4anH5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwhIlW5Bdp08Rn0pmQ+FUQuOnzdGjMahPN4r626U/qw=;
 b=LbKEJYuIuP13YZbMvS4R1hnT4mtQqnC7+QYjzi6i7bqY5YNuLeyKxXPp0ysKyHoShTLV83xgJqNWvO/NZgDJkRUtuCKiZPinclgFEpO9FwGWXnjU/C0/sm5y7JQWdlZZQ52xSqHdacyn/eTzsRQCNOidS82o2qnrLQD6kOLUVDuwDapSoY4U+oFjHdmLBpoe6zZGjSak6h+7TZ2GnNVGFT6QoYZ4QiRo/U5HHCYd2Tgygiyc4ERPAV3QNEtgCDB23XLJJAp3kTLTBv5r+wrI+0ugmw1okK2UjAfPEkXAFhrXnVi79tjQyJYnrV/Y/hQh9Bsa0uuVDBE2o9Lb22QJ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwhIlW5Bdp08Rn0pmQ+FUQuOnzdGjMahPN4r626U/qw=;
 b=eqagv+IgOttYXpypSYfc/hhahEn4mhUQbYiimhDYy5iACw4KLFarq8EaQCqd3dKKt/G98bfntQh+5kXM6lw0KXNNKIwdMz26FPpX+vLe+BgPcIS9/JWiUyNWDOJGs3O1eaUdB/MoW4o15askm6rHMsFEPmO2XVBzJqvpMudGiZ8=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB3959.namprd04.prod.outlook.com (52.135.217.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 12:33:53 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f07b:aaec:410d:bcf3]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::f07b:aaec:410d:bcf3%4]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 12:33:53 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     zhengbin <zhengbin13@huawei.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
        "yanaijie@huawei.com" <yanaijie@huawei.com>
Subject: Re: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable
 sshdr
Thread-Topic: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable
 sshdr
Thread-Index: AQHVhYyCcNbzIyfeY0GgnW2gA/uyVA==
Date:   Fri, 18 Oct 2019 12:33:52 +0000
Message-ID: <BYAPR04MB5816509E3EF6BCA68672B901E76C0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af75192c-4921-4533-5a7d-08d753c76f86
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BYAPR04MB3959:
x-microsoft-antispam-prvs: <BYAPR04MB39597E38B6AB957DB0668005E76C0@BYAPR04MB3959.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(199004)(189003)(9686003)(76116006)(66476007)(5660300002)(64756008)(66446008)(66556008)(66946007)(6436002)(55016002)(478600001)(33656002)(2906002)(305945005)(4326008)(7736002)(25786009)(81166006)(74316002)(8676002)(81156014)(8936002)(52536014)(6246003)(14444005)(256004)(2201001)(7696005)(99286004)(71200400001)(71190400001)(186003)(2501003)(26005)(102836004)(316002)(86362001)(76176011)(53546011)(6506007)(54906003)(14454004)(110136005)(3846002)(6116002)(486006)(66066001)(229853002)(446003)(476003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3959;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XXurOkW+yJih0au9fGPV+eiBl5Uk4B07lF0gIrQIRojBkH1ZHuSxK9TpM8s6wA+0hzqXjpPylP9BKa3KvbOeWzN/av6HBK4GuDXaMpIeEUBEkUyjLmeidDLzUBE0mcR4aid/ucy/bPmWd+84jG5cLm5tPZbJtp/b3g3OMxPjfOlgF/UMhPPO1Z42TtZnYQ4j44Yyzp1n0/tUC5rFj48r6jvQUfFf2nOtUDajnEtv9oKy5lPLd/YcTQFbncdmwVDZ+NC8SOywXQdS85DGuvNOI4rUxR73mfwvUcpCaVrgqmqLLFLYUfb4du0iednlpf+XDBE4w/o/cLi/cGwYqoGhT6+uuVJmEOYAd8wY53xLNYG+jqHw9Ttj7q/dqy3QQ0UAXmNvyWVmM4IYejjzxm1QNhKaRijd4o+1CB3/DGj8KgQiIy4rR3KaCYLRlESvVcWZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af75192c-4921-4533-5a7d-08d753c76f86
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 12:33:52.9228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CuvPKiz/0CTpe5TbY8Opx8Oa+Ad5KBDNg5d3kQ0YVVzY35S19aYMa1eSd1M7O2vdzaGS3RZpHyPneK+c2vLDGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3959
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/10/18 17:17, zhengbin wrote:=0A=
> v1->v2: modify the comments suggested by Bart=0A=
> v2->v3: fix bug in sr_do_ioctl=0A=
> v3->v4: let "fix bug in sr_do_ioctl" be a separate patch=0A=
> v4->v5: fix uninit-value access bug in callers, not in __scsi_execute=0A=
=0A=
An explanation text of the series would be great...=0A=
=0A=
What about defining a little helper function for checking=0A=
=0A=
driver_byte(err) =3D=3D DRIVER_SENSE && scsi_sense_valid(&sshdr)=0A=
=0A=
instead of having that hard-coded everywhere ? That would make the code=0A=
a lot cleaner and more readable.=0A=
=0A=
Something like:=0A=
=0A=
static inline bool scsi_driver_sense_valid(int result,=0A=
					   struct scsi_sense_hdr *sshdr)=0A=
{=0A=
	return driver_byte(result) =3D=3D DRIVER_SENSE &&=0A=
	       scsi_sense_valid(sshdr);=0A=
}=0A=
=0A=
=0A=
> =0A=
> zhengbin (13):=0A=
>   scsi: core: need to check the result of scsi_execute in=0A=
>     scsi_report_opcode=0A=
>   scsi: core: need to check the result of scsi_execute in=0A=
>     scsi_test_unit_ready=0A=
>   scsi: core: need to check the result of scsi_execute in=0A=
>     scsi_report_lun_scan=0A=
>   scsi: sr: need to check the result of scsi_execute in sr_get_events=0A=
>   scsi: sr: need to check the result of scsi_execute in sr_do_ioctl=0A=
>   scsi: scsi_dh_emc: need to check the result of scsi_execute in=0A=
>     send_trespass_cmd=0A=
>   scsi: scsi_dh_rdac: need to check the result of scsi_execute in=0A=
>     send_mode_select=0A=
>   scsi: scsi_dh_hp_sw: need to check the result of scsi_execute in=0A=
>     hp_sw_tur,hp_sw_start_stop=0A=
>   scsi: scsi_dh_alua: need to check the result of scsi_execute in=0A=
>     alua_rtpg,alua_stpg=0A=
>   scsi: scsi_transport_spi: need to check whether sshdr is valid in=0A=
>     spi_execute=0A=
>   scsi: cxlflash: need to check whether sshdr is valid in read_cap16=0A=
>   scsi: ufs: need to check whether sshdr is valid in=0A=
>     ufshcd_set_dev_pwr_mode=0A=
>   scsi: ch: need to check whether sshdr is valid in ch_do_scsi=0A=
> =0A=
>  drivers/scsi/ch.c                           | 6 ++++--=0A=
>  drivers/scsi/cxlflash/superpipe.c           | 2 +-=0A=
>  drivers/scsi/device_handler/scsi_dh_alua.c  | 6 ++++--=0A=
>  drivers/scsi/device_handler/scsi_dh_emc.c   | 3 ++-=0A=
>  drivers/scsi/device_handler/scsi_dh_hp_sw.c | 6 ++++--=0A=
>  drivers/scsi/device_handler/scsi_dh_rdac.c  | 8 +++++---=0A=
>  drivers/scsi/scsi.c                         | 2 +-=0A=
>  drivers/scsi/scsi_lib.c                     | 3 +++=0A=
>  drivers/scsi/scsi_scan.c                    | 3 ++-=0A=
>  drivers/scsi/scsi_transport_spi.c           | 1 +=0A=
>  drivers/scsi/sr.c                           | 3 ++-=0A=
>  drivers/scsi/sr_ioctl.c                     | 6 ++++++=0A=
>  drivers/scsi/ufs/ufshcd.c                   | 3 ++-=0A=
>  13 files changed, 37 insertions(+), 15 deletions(-)=0A=
> =0A=
> --=0A=
> 2.7.4=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
