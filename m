Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8309DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 23:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A6120810
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 23:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgFPXoh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 19:44:37 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:55268 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgFPXog (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 19:44:36 -0400
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05GNbIZ6031508;
        Tue, 16 Jun 2020 23:44:31 GMT
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 31q67urjfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Jun 2020 23:44:31 +0000
Received: from G9W8453.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net [16.216.160.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g9t5009.houston.hpe.com (Postfix) with ESMTPS id 2B88366;
        Tue, 16 Jun 2020 23:44:31 +0000 (UTC)
Received: from G9W8453.americas.hpqcorp.net (2002:10d8:a0d3::10d8:a0d3) by
 G9W8453.americas.hpqcorp.net (2002:10d8:a0d3::10d8:a0d3) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 16 Jun 2020 23:44:30 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (15.241.52.13) by
 G9W8453.americas.hpqcorp.net (16.216.160.211) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2 via Frontend Transport; Tue, 16 Jun 2020 23:44:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kv3SWIyteqOot//6lMYwNv5yhQ6EkndJg8cvE2KZaowVu01XuJR4/DvMWjBV2n0uYRVEi092zfniFVhFa+olECjdXFFrsTSWmpkIaVZVErAjTHwtDIyNZFJofrVF/mm8DrA50CBecU2Q4MYvojVSYerhCr7H0ZsL1X9HCZX250vJsr8HArykoHRFunsmkF1N0RiZZW3J24MRe3hKgziThfdfJfomoZt6z8U9Cqg7aHfr3b4wumIvA9iMlHHW8NcFIT2HBV4woQ03cvIFgW2AdbYO6kvkYEtwhjqinNKguhSzVVGOi4poKqWq8IswXsV3A8XcqCiHJYvh2q6Bhjfkmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQ2xpbFYLxA1kkAUISpZ21n9gOrb+OwmffRj9w41vMA=;
 b=N0J1WaM6+LJZDkUv7GQO5c9ulam5q/D1gXCrttcG96y9FWjnWF15JNFQYdlmUBPN4tuzJRN+YPCvd7QYOFcbJqOng5HsTvgSTaPw7r/5zh4ffNjJGGdzi0qj06/xQBuxL1AtNpVNPOEh+vq8eAcq3z+yhV5ShOcM8RpX0i6rWtFBk457ylGN2v+fo+8kzaY04dRWMNSFMwEmAtUQUoX503F+obARVcGqJ5bTNAMkkEwcgXTM4yOHoDYgAKDpsaKubzpv58oPWS81Gpi8WzLjNTo0jrQN2ZNEgZtqGRQLLqXtEgkTlAzPwP2V+4W+qZf2baNZR+gtPUqIMFrw45XjMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:760c::23) by DF4PR8401MB0666.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:7607::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.23; Tue, 16 Jun
 2020 23:44:29 +0000
Received: from DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::52b:d206:199b:6b10]) by DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::52b:d206:199b:6b10%12]) with mapi id 15.20.3088.029; Tue, 16 Jun 2020
 23:44:29 +0000
From:   "Seymour, Shane M" <shane.seymour@hpe.com>
To:     "mwilck@suse.com" <mwilck@suse.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 2/2] scsi: smartpqi: check sdev in pqi_scsi_find_entry
Thread-Topic: [PATCH 2/2] scsi: smartpqi: check sdev in pqi_scsi_find_entry
Thread-Index: AQHWQ/NbGMc+/t57f0q18znz+15d0qjb6CJA
Date:   Tue, 16 Jun 2020 23:44:29 +0000
Message-ID: <DF4PR8401MB0860071563C01471036B9F06FD9D0@DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM>
References: <20200616153145.16949-1-mwilck@suse.com>
 <20200616153145.16949-2-mwilck@suse.com>
In-Reply-To: <20200616153145.16949-2-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=hpe.com;
x-originating-ip: [121.200.16.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 712c8bf7-f8af-466a-8a4c-08d8124f3652
x-ms-traffictypediagnostic: DF4PR8401MB0666:
x-microsoft-antispam-prvs: <DF4PR8401MB0666DC49E222FA7FCA8EC421FD9D0@DF4PR8401MB0666.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 04362AC73B
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ykLE8nFinJPfxVLb9HIHi0q9hEb/zd35PnuYiIU189tePsZUsEWumrQdxzulxXxDSPhmUKQkL/EnVbzsxizGuDz6PbuXltk3utoiYr9fYql+eKWGOkVJMhzy3o+ja263tPZt3DUj8MCSnHPXnd2JEKMnSREuMAwX/Cek/woixwWKuJwT8QE+KfVwiIed/A/sjyrrU73DnvAMl1dfh0JiFfVLY1qBzXF+LTIFEwuIODgoMiGmYUrmfxGSwY+Zp5cvVgJme9zJro58LrQQ+UmXY2ChlRmkonJ1vG9xKGQH2757fco8+7BJDRUE/lZpfc5Uxzdi4BkIpi/oydvDcHbmNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(5660300002)(6506007)(53546011)(26005)(55016002)(4326008)(76116006)(33656002)(8936002)(186003)(52536014)(7696005)(66476007)(64756008)(66556008)(66446008)(478600001)(8676002)(54906003)(110136005)(83380400001)(9686003)(316002)(66946007)(2906002)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vFKt4Vm3ePsJ8q3iGsH1ilpmkDI+q8K43jakuJiiOPk+LCxXIUTHHnUiDHhGS6uJwAiEzpWxltJmYcv0FyUqhZcgX2w8e1oDeEDnSdu6L+/nOuJakN7DW+Wd61HV2Ei1MH17t/TKgRbWRmcoY6WS8Aodh9ACyA8Ro1PYCG2FABnJg3NRuR4NVXjexxEM+VKfqvJJwuxqYmVNbHzSsWfgvNvi7hig8tikzY95qeg/ydXWXYKdki/LEXO8tUyrKe1egMNIODJAHoUQ5StXdJOZPUFbt+JX5arurkkvUQCLniGGF8sjg0TCR3cTcAUPRNoXZvAVp39nnI5tb0p0SYozBsobnUUVZ2P/QxywFBt5Mf2hD8dLR0LwG0I/xhpcJQWycm+hcMHKzF5LVTjmmEFHQAQu2Pr5fJzZMwHOdQOt3gtWTcb9ajMyfOGnNEWCVtPDZ9w2RTOzPcvDA6OWfybScoKvdLRr+BdAEvM53wTrSe4lnNBaAxtnFR8TNRm+flAa
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-Network-Message-Id: 712c8bf7-f8af-466a-8a4c-08d8124f3652
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2020 23:44:29.4651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O23xWGzojK4ZodZk9rey9G0WMVcvgwB9HPUTxz/4ASSpJnO/XoCUVmjfRB1cilPUacT/0nLbI6kjElLvnd3iuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB0666
X-OriginatorOrg: hpe.com
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_13:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
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
> Subject: [PATCH 2/2] scsi: smartpqi: check sdev in pqi_scsi_find_entry
> 
> From: Martin Wilck <mwilck@suse.com>
> 
> If a scsi device has been destroyed e.g. using the sysfs "delete"
> attribute, subsequent host rescans won't re-discover it. This
> patch makes it work at least via the smartqpi-specific "rescan"
> sysfs attribute.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 54a72f465f85..87089b67ff74 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1612,7 +1612,8 @@ static enum pqi_find_result
> pqi_scsi_find_entry(struct pqi_ctrl_info *ctrl_info,
>  			device->scsi3addr)) {
>  			*matching_device = device;
>  			if (pqi_device_equal(device_to_find, device)) {
> -				if (device_to_find->volume_offline)
> +				if (device_to_find->volume_offline ||
> +				    !pqi_get_scsi_device(device))
>  					return DEVICE_CHANGED;
>  				return DEVICE_SAME;
>  			}
> --
> 2.26.2

