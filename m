Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59D4C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 23:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F46207E8
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 23:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgFPXoL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 19:44:11 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:48230 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgFPXoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 19:44:10 -0400
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GNbcQG006763;
        Tue, 16 Jun 2020 23:44:05 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 31q67v8hqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 23:44:05 +0000
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5009.houston.hpe.com (Postfix) with ESMTPS id F388351;
        Tue, 16 Jun 2020 23:44:04 +0000 (UTC)
Received: from G9W9209.americas.hpqcorp.net (16.220.66.156) by
 G1W8106.americas.hpqcorp.net (16.193.72.61) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Jun 2020 23:44:04 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (15.241.52.13) by
 G9W9209.americas.hpqcorp.net (16.220.66.156) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Tue, 16 Jun 2020 23:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFu95q2SY/6vRd0AaPgYgYfbOmYvSQuBynjmbEwhA3+yE6jayqDFLCuY+oVLk5ki6zRME+IMSJ8RPQAZb6t8pwGEsmC+kKDzI3IjAtWuh/42UQxzCGl3DzdyKdaGuZZAc88mUruMKqIDrHO6nJx+v55D5e1eaPy13ZVUpzrKn86GThBrbC1Id/AmX+UoRMch6TQtj/v8rzGeR15n/0VEJQvKnMM8sMgvwqSJrySRCwhVJAbEpDrqE1ZKVJil+wL4p8FrlWBGfE0rIx+rduViyeGljZAdYfpyhf4SAba3D9FeUZb4PtYfDL4tZ19XhYI8tl+8V+DoX2ceOztT1wbGtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAsXgVmNfl96ZIjF+oTT8Mcz9k0ZRQwQO6Gnn4WucjI=;
 b=ktQPKkd9FekbWRUEiJw2s7FeOoCRKjOq0moE1czepo+jLZy6CtDAHJl3KUcP/btkxAxMjNaB0pgGYAKUpJO1X2iXu568Mslnf6LNF5WkxEH3p3EoEnQq18+ti7CWeYQ4Rupsq8nhoYmiUzj8dcaA4eI2HI4z0mvaIZ59q2nYqFPRN+EPaq61rsxziHBGAD/IBJtroEQVRe2Ak4euBwhvfX3g93aoB+84Yn0wL2HncgT2S4+d/FTFQgHa6dEYGQfsix+8MTuqufuY2/1+NNoFfidatwnlhdTy3ao6wX7J4UkaVr3iWp4sXtfLRZ234ZiILMi5plxdxiM5jcQoP83ezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:760c::23) by DF4PR8401MB0666.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7607::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.23; Tue, 16 Jun
 2020 23:44:03 +0000
Received: from DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::52b:d206:199b:6b10]) by DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::52b:d206:199b:6b10%12]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 23:44:03 +0000
From:   "Seymour, Shane M" <shane.seymour@hpe.com>
To:     "mwilck@suse.com" <mwilck@suse.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/2] scsi: smartpqi: grab scsi device ref in
 slave_configure()
Thread-Topic: [PATCH 1/2] scsi: smartpqi: grab scsi device ref in
 slave_configure()
Thread-Index: AQHWQ/NaAK7r/ClO/kur26IDxzCZxqjb5wXQ
Date:   Tue, 16 Jun 2020 23:44:03 +0000
Message-ID: <DF4PR8401MB0860FCE55F136884D764F5E2FD9D0@DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM>
References: <20200616153145.16949-1-mwilck@suse.com>
In-Reply-To: <20200616153145.16949-1-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=hpe.com;
x-originating-ip: [121.200.16.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4be73898-5396-48d9-7ebf-08d8124f26a4
x-ms-traffictypediagnostic: DF4PR8401MB0666:
x-microsoft-antispam-prvs: <DF4PR8401MB0666D145F2CB7D4FAAC5543FFD9D0@DF4PR8401MB0666.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D3eEjbM+vB5xeYvdmHBGP75p2abq8B08iGeUm3iiBni0OLzocMzJB8jrzLC3b6h+BkIYK9jeBOqVVVQW2pdxiFuc9BRaokK8CBKcfNwfeQxIixjgh2J7wnA5ETCEr1dYjKwGKKmcUGIwKcq9uiDM+CrvDSgcb9Bda6SYpHt+MtWe78aIhLIypUTjh/2QEqVFMW4rVhacnD4juwP3qxX9JB/LKHkDZn9mabu8eaofyME3bTtt6wX1+O00DHBejSIKEL+bur2+UnrBpfyV+YZ0YjVLFIz/B9IghBoR5uKThytZ37HpIzzgSxa1Il3A0bZi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(5660300002)(6506007)(53546011)(26005)(55016002)(4326008)(76116006)(33656002)(8936002)(186003)(52536014)(7696005)(66476007)(64756008)(66556008)(66446008)(478600001)(8676002)(54906003)(110136005)(83380400001)(9686003)(316002)(66946007)(2906002)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: mk2V7v3kM5/WdWIGW0aSY0My+/SXXYbtdUCnazXfIOGS9eRnq3GqFrrpkrS9mWfRdeimwyuFtdWP12Ng2UTDzVpjXSsS9h4BlE1Ck24D/m1ufsxU2KXJGvn+7JB5Cvw6mhRJIoMda1vSMU1iiICjKmcaSNvFcbHT5oQu8jOOVo7DjCl5QYdmWvj66/sldb7GDkFv/yh/L5rfx1vQ233w1pZa0z//wuIfdvGBPyVtFNxR2b5DrEfOUzOIqvVipeyAjyF29RNbl7GrTD/7sWkz7EHbpX5/MRycE1FgnL5JnHV320WDGehNwQEqA1WFW694xdFsQQqG4fyC/Lx3NIDtlGi231ujwtC9E4VImGl99tzbfjF4uG/O2UpUjWl1SwA1OAznAc95Ps6XZuEVLO/Mjofo5kFx1IWvAQ4y0Bbp3zrJRE/eMDCmmpJKD7k00UdWM1mLwgl4IYALZEoMvQNxXVtK6taMFi0ngZbVig9XHOCKxmQKUw60KxhgjEIzlwEy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-Network-Message-Id: 4be73898-5396-48d9-7ebf-08d8124f26a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 23:44:03.0797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3mrJR1ov+Q5Nr5Dt/jhFViK004s4ETcDb3h+c8ReUiy+kZ+JKykJdwLULO58XyhtqRCO6XJDu/h2jZd/NF6/Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB0666
X-OriginatorOrg: hpe.com
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_13:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of mwilck@suse.com
> Sent: Wednesday, 17 June 2020 1:32 AM
> To: Don Brace <don.brace@microsemi.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: esc.storagedev@microsemi.com; linux-scsi@vger.kernel.org; Martin
> Wilck <mwilck@suse.com>
> Subject: [PATCH 1/2] scsi: smartpqi: grab scsi device ref in slave_configure()
> 
> From: Martin Wilck <mwilck@suse.com>
> 
> We have observed kernel crashes caused by the smartpqi driver holding
> a pointer to a struct scsi_device that had been removed already.
> Fix this by getting and holding a ref for the device as long as
> the driver uses it.
> 
> Use a lock to avoid races between device probing and removal.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/smartpqi/smartpqi.h      |   1 +
>  drivers/scsi/smartpqi/smartpqi_init.c | 122 +++++++++++++++++++++-----
>  2 files changed, 103 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h
> b/drivers/scsi/smartpqi/smartpqi.h
> index 1129fe7a27ed..5801080c8dbc 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -954,6 +954,7 @@ struct pqi_scsi_dev {
>  	struct raid_map *raid_map;	/* RAID bypass map */
> 
>  	struct pqi_sas_port *sas_port;
> +	spinlock_t sdev_lock;		/* protect access to sdev */
>  	struct scsi_device *sdev;
> 
>  	struct list_head scsi_device_list_entry;
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index cd157f11eb22..54a72f465f85 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1514,6 +1514,18 @@ static int pqi_add_device(struct pqi_ctrl_info
> *ctrl_info,
> 
>  #define PQI_PENDING_IO_TIMEOUT_SECS	20
> 
> +static inline struct scsi_device *
> +pqi_get_scsi_device(struct pqi_scsi_dev *device)
> +{
> +	unsigned long flags;
> +	struct scsi_device *sdev;
> +
> +	spin_lock_irqsave(&device->sdev_lock, flags);
> +	sdev = device->sdev;
> +	spin_unlock_irqrestore(&device->sdev_lock, flags);
> +	return sdev;
> +}
> +
>  static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info,
>  	struct pqi_scsi_dev *device)
>  {
> @@ -1530,9 +1542,26 @@ static inline void pqi_remove_device(struct
> pqi_ctrl_info *ctrl_info,
>  			device->target, device->lun,
>  			atomic_read(&device->scsi_cmds_outstanding));
> 
> -	if (pqi_is_logical_device(device))
> -		scsi_remove_device(device->sdev);
> -	else
> +	if (pqi_is_logical_device(device)) {
> +		struct scsi_device *sdev;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&device->sdev_lock, flags);
> +		sdev = device->sdev;
> +		if (sdev)
> +			get_device(&sdev->sdev_gendev);
> +		spin_unlock_irqrestore(&device->sdev_lock, flags);
> +
> +		/*
> +		 * As scsi_remove_device() will call pqi_slave_destroy(),
> +		 * we can't keep the sdev_lock held. But we've taken a ref,
> +		 * so sdev will not go away under us.
> +		 */
> +		if (sdev) {
> +			scsi_remove_device(sdev);
> +			put_device(&sdev->sdev_gendev);
> +		}
> +	} else
>  		pqi_remove_sas_device(device);
>  }
> 
> @@ -1749,7 +1778,7 @@ static inline bool pqi_is_device_added(struct
> pqi_scsi_dev *device)
>  	if (device->is_expander_smp_device)
>  		return device->sas_port != NULL;
> 
> -	return device->sdev != NULL;
> +	return pqi_get_scsi_device(device) != NULL;
>  }
> 
>  static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
> @@ -1861,11 +1890,24 @@ static void pqi_update_device_list(struct
> pqi_ctrl_info *ctrl_info,
>  	 */
>  	list_for_each_entry(device, &ctrl_info->scsi_device_list,
>  		scsi_device_list_entry) {
> -		if (device->sdev && device->queue_depth !=
> -			device->advertised_queue_depth) {
> -			device->advertised_queue_depth = device-
> >queue_depth;
> -			scsi_change_queue_depth(device->sdev,
> -				device->advertised_queue_depth);
> +		struct scsi_device *sdev;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&device->sdev_lock, flags);
> +		sdev = device->sdev;
> +		if (sdev)
> +			get_device(&sdev->sdev_gendev);
> +		spin_unlock_irqrestore(&device->sdev_lock, flags);
> +
> +		if (sdev) {
> +			if (device->queue_depth !=
> +			    device->advertised_queue_depth) {
> +				device->advertised_queue_depth =
> +					device->queue_depth;
> +				scsi_change_queue_depth(sdev,
> +					device->advertised_queue_depth);
> +			}
> +			put_device(&sdev->sdev_gendev);
>  		}
>  	}
> 
> @@ -2082,6 +2124,7 @@ static int pqi_update_scsi_devices(struct
> pqi_ctrl_info *ctrl_info)
>  			device = list_first_entry(&new_device_list_head,
>  				struct pqi_scsi_dev, new_device_list_entry);
> 
> +		spin_lock_init(&device->sdev_lock);
>  		memcpy(device->scsi3addr, scsi3addr, sizeof(device-
> >scsi3addr));
>  		device->is_physical_device = is_physical_device;
>  		if (is_physical_device) {
> @@ -5785,6 +5828,7 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
>  	struct pqi_ctrl_info *ctrl_info;
>  	struct scsi_target *starget;
>  	struct sas_rphy *rphy;
> +	int ret;
> 
>  	ctrl_info = shost_to_hba(sdev->host);
> 
> @@ -5806,23 +5850,59 @@ static int pqi_slave_alloc(struct scsi_device
> *sdev)
> 
>  	if (device) {
>  		sdev->hostdata = device;
> -		device->sdev = sdev;
> -		if (device->queue_depth) {
> -			device->advertised_queue_depth = device-
> >queue_depth;
> -			scsi_change_queue_depth(sdev,
> -				device->advertised_queue_depth);
> -		}
> -		if (pqi_is_logical_device(device))
> -			pqi_disable_write_same(sdev);
> -		else
> -			sdev->allow_restart = 1;
> -	}
> +		ret = 0;
> +	} else
> +		ret = -ENXIO;
> 
>  	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
> 
> +	return ret;
> +}
> +
> +static int pqi_slave_configure(struct scsi_device *sdev)
> +{
> +	struct pqi_scsi_dev *device = sdev->hostdata;
> +	unsigned long flags;
> +
> +	/*
> +	 * Grab a ref to the SCSI device, lest it be removed under us. It will
> +	 * be dropped in pqi_slave_destroy().
> +	 * Don't use scsi_device_get() here, we'd increment our own  use
> count
> +	 */
> +	if (!get_device(&sdev->sdev_gendev))
> +		return -ENXIO;
> +
> +	spin_lock_irqsave(&device->sdev_lock, flags);
> +	device->sdev = sdev;
> +	spin_unlock_irqrestore(&device->sdev_lock, flags);
> +
> +	if (device->queue_depth) {
> +		device->advertised_queue_depth = device->queue_depth;
> +		scsi_change_queue_depth(sdev,
> +					device->advertised_queue_depth);
> +	}
> +	if (pqi_is_logical_device(device))
> +		pqi_disable_write_same(sdev);
> +	else
> +		sdev->allow_restart = 1;
>  	return 0;
>  }
> 
> +static void pqi_slave_destroy(struct scsi_device *sdev)
> +{
> +	struct pqi_scsi_dev *device = sdev->hostdata;
> +	unsigned long flags;
> +
> +	if (!device)
> +		return;
> +
> +	spin_lock_irqsave(&device->sdev_lock, flags);
> +	sdev = device->sdev;
> +	device->sdev = NULL;
> +	spin_unlock_irqrestore(&device->sdev_lock, flags);
> +	put_device(&sdev->sdev_gendev);
> +}
> +
>  static int pqi_map_queues(struct Scsi_Host *shost)
>  {
>  	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
> @@ -6501,6 +6581,8 @@ static struct scsi_host_template
> pqi_driver_template = {
>  	.eh_device_reset_handler = pqi_eh_device_reset_handler,
>  	.ioctl = pqi_ioctl,
>  	.slave_alloc = pqi_slave_alloc,
> +	.slave_configure = pqi_slave_configure,
> +	.slave_destroy = pqi_slave_destroy,
>  	.map_queues = pqi_map_queues,
>  	.sdev_attrs = pqi_sdev_attrs,
>  	.shost_attrs = pqi_shost_attrs,
> --
> 2.26.2

