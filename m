Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C93C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 04:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9740821852
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 04:32:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgFREcm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 00:32:42 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:25494 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgFREcl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jun 2020 00:32:41 -0400
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05I4VeFP031877;
        Thu, 18 Jun 2020 04:32:25 GMT
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        by mx0b-002e3701.pphosted.com with ESMTP id 31q67v2x2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Jun 2020 04:32:25 +0000
Received: from G1W8108.americas.hpqcorp.net (g1w8108.austin.hp.com [16.193.72.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2353.austin.hpe.com (Postfix) with ESMTPS id E7A1C77;
        Thu, 18 Jun 2020 04:32:24 +0000 (UTC)
Received: from G9W8456.americas.hpqcorp.net (2002:10d8:a15f::10d8:a15f) by
 G1W8108.americas.hpqcorp.net (2002:10c1:483c::10c1:483c) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Thu, 18 Jun 2020 04:32:25 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (15.241.52.10) by
 G9W8456.americas.hpqcorp.net (16.216.161.95) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Thu, 18 Jun 2020 04:32:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiUn9vKXA1YAawJKV7ewoPqaxV5KxQwSrNMIE0QkyR5apLgSYtJfRfmnfzqb2BWI1/zN16XgDS+sCamnS8IrOBgLQyLNsy76HsvwO5Yx/Lxptu5tsXPGIzCGsh0U1jAmhC+lCOIgYtz87jv12q7kPVlApoYxBwh9JTEZ208VYgh1nbeffvzV850BFuBW9oU3+Gzo2wYHxt8420ZPGfTytvj4C1o6rETApiQTesPVZBitnXOMbfwsfdG13y0MhlK9QF5lRIFkpEm3yNMiHkPx1dyPNSjlAeY7JAEtytGFNmcH2C/T/2V5MohM4p9mS3VV0VhK1mAMB7+F82bfXGTM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DwPR4W9DvL0uaqnrNvJwTmCMguQ+45Eq6+rgMkhNjHs=;
 b=n4L1o7/K8XnDBt2H2Cq4RhEqET5gKtB/5NcaaIZM3e3DRfcd4nM3RAK9pFaz+bkcQMqdF0KjOg35nmZoKTKu9sVVKb7bXgjQIcg/BePRbReCbxAiXVoNPlx08NYu8yl/0Lkk4xeUh58zdwwPBNV/2XMt7UAjuiAdYHa254ICksx9iwYW7hBYGqNVMYjvXBb+xZtKZjiCXuOwIxKTaDiK7W81s0hy7ucnMevMGb11c0737n7YYJSLVsYmZv96NC8/I5mITa7ci59VKdSHevGPN7sOlzibt6ou6CBJWe9CxqfDjq1L51PDw1Fg+Hh6i/fjnsnzQvtaBLmdOzO6IBLiuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:760c::23) by DF4PR8401MB1049.NAMPRD84.PROD.OUTLOOK.COM
 (2a01:111:e400:760f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.25; Thu, 18 Jun
 2020 04:32:23 +0000
Received: from DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::52b:d206:199b:6b10]) by DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::52b:d206:199b:6b10%12]) with mapi id 15.20.3088.029; Thu, 18 Jun 2020
 04:32:23 +0000
From:   "Seymour, Shane M" <shane.seymour@hpe.com>
To:     "mwilck@suse.com" <mwilck@suse.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2 3/3] scsi: smartpqi: remove conditional before
 pqi_remove_device()
Thread-Topic: [PATCH v2 3/3] scsi: smartpqi: remove conditional before
 pqi_remove_device()
Thread-Index: AQHWRIJe16guytWd+Uyv95q1DgFhQKjdySeg
Date:   Thu, 18 Jun 2020 04:32:23 +0000
Message-ID: <DF4PR8401MB086003E76B27998EC57A243BFD9B0@DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM>
References: <20200617083514.19174-1-mwilck@suse.com>
 <20200617083514.19174-4-mwilck@suse.com>
In-Reply-To: <20200617083514.19174-4-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=hpe.com;
x-originating-ip: [1.136.107.16]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01178e8e-38da-4941-8139-08d8134098a6
x-ms-traffictypediagnostic: DF4PR8401MB1049:
x-microsoft-antispam-prvs: <DF4PR8401MB1049C3DBF1B85C4A6C825DB2FD9B0@DF4PR8401MB1049.NAMPRD84.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /TGlSa0LWA0GzOTXmfU6rnqV958Wh4ZkaRYNz0xalAM7lQnJK6GAaIaKgzyUN00G/m5xgeVx4t2atOev0GiAa7o4dzMBRpDYnhuAZqUZtKmuWqiWbuT/vK1KIYpl19eAbY49SUpHnP9M6KBMK7JYXgg78095r8YOpkmcr7NQgQMWWCDPPbcVN0YkX/YqBfvtDNdnw4nHR2ekZ15nKwei4wbcbOpXWtrPuu8nmL/FjiD2iNmFdE9/3JzadQsJKDUbaYrxgIx6NVfM4dPXccEQPVhZKOVoGytIzz+zVvko00eL1aK63er6XK8aFj4ui8FTFTAoPoKEu+IHX2ek1X3gJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DF4PR8401MB0860.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(376002)(396003)(346002)(39860400002)(76116006)(6506007)(316002)(53546011)(86362001)(9686003)(66946007)(26005)(8676002)(55016002)(64756008)(83380400001)(66556008)(71200400001)(7696005)(66476007)(8936002)(66446008)(33656002)(186003)(52536014)(5660300002)(478600001)(2906002)(54906003)(110136005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pshS8Nt4Na/UDnAMznIJXekDZcnMmXLvv4Su9xuxWQ6mvb3GN+pLdhO3WY/6RMmcDYk/O+KhDPQIkcaKGcRXKOvDoqhyl+eCYUEBCYZJpWU/1SBizZ/uj1ve5LkLlCI/PLBNiuhM/avSm7+voEe8PZnz/BoaXVuca4msCSBQU9M0scttR9VvzCPoam8pI4xTSM4ambDqgCrZpikj8H5fY4LLIMl22pWzdmvf7fKkzMHrvjbSnS2hrCzsUKY4JTWI3tNc2EHSuw+yFUxUD6DgsxiFhGcjuh0xQW0hujtq9shqSXcJ3oDWjMs1ovsK8tdk/igyLYWXlbPUpxHHokPbb32zFsXdxpAe8e2e+aJyAlyG2/Wo9cc13VeCI/SjQEzao/NAJeC1BsXTzAAXIY/3zx5L43eMOAx2mFJCoTxwCoUGTtUZ+aoMiq6yHqyCa69vY6+Rti1IAR28ryyd5vo764Qx5iENDqsnve8XnoyHHIM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
X-MS-Exchange-CrossTenant-Network-Message-Id: 01178e8e-38da-4941-8139-08d8134098a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 04:32:23.2229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mnzAyiNm9Rqrbkm8wJ4QDoNKBICmAV+06o/5rBDN/QtMMbQhtAZiargcbWSTIS8mYxsBnJX8KGaDyCBPf6VyRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DF4PR8401MB1049
X-OriginatorOrg: hpe.com
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_03:2020-06-17,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180032
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One small typo in the commit message pysical  should be physical.

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>

> -----Original Message-----
> From: mwilck@suse.com [mailto:mwilck@suse.com]
> Sent: Wednesday, 17 June 2020 6:35 PM
> To: Don Brace <don.brace@microsemi.com>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: esc.storagedev@microsemi.com; linux-scsi@vger.kernel.org; Seymour,
> Shane M <shane.seymour@hpe.com>; Martin Wilck <mwilck@suse.com>
> Subject: [PATCH v2 3/3] scsi: smartpqi: remove conditional before
> pqi_remove_device()
> 
> From: Martin Wilck <mwilck@suse.com>
> 
> pqi_remove_device() checks if there's anything to remove, for both
> logical and SAS devices. So these conditionals are redundant.
> They may actually be wrong, because they would skip removing pysical
> devices which are not SMP expanders.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 87089b67ff74..7e4d5c5ea2b0 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1879,8 +1879,7 @@ static void pqi_update_device_list(struct
> pqi_ctrl_info *ctrl_info,
>  		} else {
>  			pqi_dev_info(ctrl_info, "removed", device);
>  		}
> -		if (pqi_is_device_added(device))
> -			pqi_remove_device(ctrl_info, device);
> +		pqi_remove_device(ctrl_info, device);
>  		list_del(&device->delete_list_entry);
>  		pqi_free_device(device);
>  	}
> @@ -2223,8 +2222,7 @@ static void pqi_remove_all_scsi_devices(struct
> pqi_ctrl_info *ctrl_info)
>  		if (!device)
>  			break;
> 
> -		if (pqi_is_device_added(device))
> -			pqi_remove_device(ctrl_info, device);
> +		pqi_remove_device(ctrl_info, device);
>  		pqi_free_device(device);
>  	}
>  }
> --
> 2.26.2

