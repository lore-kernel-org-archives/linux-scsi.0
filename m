Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021D6C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D59D461037
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhHTFRi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 01:17:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9842 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234711AbhHTFRh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 01:17:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17JHBAh2005948;
        Thu, 19 Aug 2021 22:16:55 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ahftmmxn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:16:55 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17K5GtpV016379;
        Thu, 19 Aug 2021 22:16:55 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ahftmmxmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:16:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4qDLmQT1VLMuVdgBUbJELlL4qA12S5akpoRCLdr1AZpglk5QgIRMKMTOwv1BY0+PEsIuOw6v8qMj7V4HCFGA0B3j7NOdVrqcad0rKlwWyxvQlSwaJjmN+HMOAyLB7GYBhkV65hTuPxcSE7aGZ/qUgN507KWgsUEKCwkLzX4gyN5ULbrI98P0Cp7cTr/QStKFWUd3gj9NPxdLyw/LwgCtHQ25THk3eeeTojSxRzC556S4IpwOaVTA/8Z+9YGB2mfnjAlctroC8E8/HtQ2Nuhs//p+N+d5y9Pxk8IrrK7jG6k3JLYRo6cHjsbwPHiaSWAcU6OzeB21uxUR1XZ8MroWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGUMhFWPmPG+3JDz+jezqdZJBjF35dU+SdQ/GhEJ784=;
 b=JHEf+vOthQeBit80UFuLktbE7TXNh61dPKyeNaD2UlnoQ1FLXJrsM23IsEXCvYL6MbiJ1NeLa3MmvnOVH7+gqDbqz1yG9eC1qplLuH9O+cVfSpkrybTGyfK7kTNS9RvhBhdQ9tMS+LqyuBoeAuMML+DsKX5nypLyJL54DlUWOrc9e/apSE1IWp4aOOXXqs0wUK5/0SHWbpKsYJUbAEi6ega74ai67yRj0tXjn66N+gjA4HiY4iit337pTnLzpJXdTWkUsNNQN13CxKRt1kkAXfGWRLA9VOsBaEwqL755rXW0jzGvDiTj0GW/mtMqAPYnfH047byo4/kRAUI6GkhgJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGUMhFWPmPG+3JDz+jezqdZJBjF35dU+SdQ/GhEJ784=;
 b=TGZnC/I2D2qxUOAehqqQrFOvkBcB/T98QnUUEddbyS9Fr+yJPz/2rad/lVK2vtBeU/82u+t2SsKPNptTdxkr9OrVr6tLyM93/DYVZno/R58NUuwXcaqHbv/39cQxVaran8O0dZR9AbER6WIFYQQea1hZubJqYcZwtDk/pPYJCjM=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO6PR18MB4452.namprd18.prod.outlook.com (2603:10b6:303:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 05:16:53 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8%4]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 05:16:53 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 3/3] qla2xxx: Open-code qla2xxx_eh_device_reset()
Thread-Topic: [EXT] [PATCH 3/3] qla2xxx: Open-code qla2xxx_eh_device_reset()
Thread-Index: AQHXlNtQUpNc7WIqcEaDkM5e/SvQ5Kt721UQ
Date:   Fri, 20 Aug 2021 05:16:53 +0000
Message-ID: <CO6PR18MB45001BB5B9D32043186D872FAFC19@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210819091913.94436-1-hare@suse.de>
 <20210819091913.94436-4-hare@suse.de>
In-Reply-To: <20210819091913.94436-4-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7d043c9-05fe-464d-ae2b-08d96399b8fb
x-ms-traffictypediagnostic: CO6PR18MB4452:
x-microsoft-antispam-prvs: <CO6PR18MB4452CB2FD00C79BA6F6C3E6DAFC19@CO6PR18MB4452.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:328;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E0msduLxOaUByJkwXiUjhQ4kkVUDgEXXxr+aLAKN8zdNUrtRbubg9JkTCF9ZQvqMngv/WfR8bs7ZVOOetwEc58jPsHP4H5Ma+PaKQENKoXyUn4pL6Rz8sJNrx99mtDfqtPJm1RNYiInCIAoCifkXlFsua7pAh9hOvvBDC4gwiLjrTUN/vJsLAhRN0HvRC9VpKhpPSRIoEme04nn7yrEfAo7bslq/1rN55vQ+hvnwCphR2TUouOQivSCoOvpAwEL7sDdHnhOfj1LHk7TQQXLCRqujrzt4RzWtmM0H5JbdK5Az+CLI3V+DF1aWV+Q55HpL6PfCeTKulsELn/ltlfA7C6BoAMSmLat9TprqdhDWOnNjkPNf/UQr8yPtZ6YVmQHQ76cdjncWDKI8QSNUP5slh3VEKNhtlO2tEU2irSZ0QdSbb8nNZ+cqeR3RrbOXn6wn+dxA0STACY5uCrtGPLjkDmyyhhWo9gA5TvZtUyTse+c4scei4fOnnlBWvkUw3mnv1roIpMwD/cBHPszzlld6vK0zRGqvd3Z5RU1eg/O0oJ6et3zZPjDCxWzLgup8GBhYEnR8GeI0MghUpyyzO7xjjqpzHri5kAgfUm549YA6Jxh9DKmS554xWkjgYOg0x5mAbm9//EbO+fZm5QLmKcofCoTCJxCLNEdEYGiW60w5RIY+5ImGyKHhYA0/XTitfN6uCUAyVhkJ5z+TIgDXLkhzKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(76116006)(66946007)(8676002)(55016002)(83380400001)(122000001)(86362001)(110136005)(33656002)(38070700005)(38100700002)(54906003)(2906002)(71200400001)(5660300002)(316002)(26005)(4326008)(478600001)(8936002)(7696005)(186003)(53546011)(6506007)(66476007)(66446008)(9686003)(64756008)(52536014)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZxZAVCJ1s0KXXGrbAvdCL51v8DfjD+zL/YQMztQHIymdneCz05Y0UMy9eWVQ?=
 =?us-ascii?Q?AUzm3+TaKZMicmkXwsSvD0Fw+wkh5J+J6KCgwAJEg2RF4vJ8WDOGNPRvvYuO?=
 =?us-ascii?Q?xA+3ziWdjphnY0qa7a/Ify4vFK8ZEndY+PnhAhYUW9e2ZdPzjSRLtM1Niq1P?=
 =?us-ascii?Q?rviAKx8HC+Sga+xgDihd1hPWSRqXTu6NtkZwJCVMw75IpvG2/j81DBA4Lima?=
 =?us-ascii?Q?OO5I0Yzw+NJ/H65+ltV+K4zI6R1LFXB8fLswnCAfonTJdoQcz6+Khl5DoWvN?=
 =?us-ascii?Q?cGFFhQLZOKM53wN4yj/uR6XOhKD5lM7DJWcbpzxHgt4AogpUBkFPEwKHWa6f?=
 =?us-ascii?Q?vjOUq9K1sDgchoorIURSOa2ade96JjS4i0hXSJiyQgxq7btDLj4i7H9moFM1?=
 =?us-ascii?Q?pRww9gbzNG+HUsDy63KF/ozxdY2VLHROWaZ/Dt63/nXrt5Yhwfg1NNCBb5qN?=
 =?us-ascii?Q?yJn6jQNosr2h0WOAx1aBPLvhaqm8W7sGdUKnZKMazCXdljOvp4aevHaV3d3T?=
 =?us-ascii?Q?/j+PT9yfePmJM845fU+e1/i+LQK9MGvOJv88gRICztSoF543SQ4HJA0IBfpC?=
 =?us-ascii?Q?5jxyprhUkAIO0zLlpsq3GcMU+bgMNvsnmvL2CTvtk8DQIbjwQHRsfJkytXcR?=
 =?us-ascii?Q?T1LBf9y+OLYr8TpenSmguH5G6jNBoSLWR8ESjJXYKxr62hZVRGcdQwu8Se6u?=
 =?us-ascii?Q?F0iq4G6PH3NYvyJ3Xmk7AnBQccuKOqBKAQKNIS59JmkBLtEIIKQrl+dma1g7?=
 =?us-ascii?Q?Tt0oc/lNQa4OgsnPqaDY94J7dZjpbRLJGAZ/c5njpQ1+rMLWFgHECjZPIDQI?=
 =?us-ascii?Q?uG5p0UIF7vtOjrpx5CST/qRGvJcgPBzwEW2II0zq5YIaWghnkSD/nU+5rMex?=
 =?us-ascii?Q?ROC2xxCxiVtJShSQzujV7V6z1TMUVMmAN8oyxv+hxZzb+2ts2NJ49zou1tK1?=
 =?us-ascii?Q?maMGUwOeIOKi2Y30HE3Vwp/FONNEhoZAp+SS10tv9n/UH8ZEfkREM71Dtbiz?=
 =?us-ascii?Q?E5EDTPtJ3+zD7Cu6Ux5J0L1IymAywoHRJXm7gFUEkj/MpXcPbdP9WqWkOx5J?=
 =?us-ascii?Q?PiT5m/7gMSqNmxDCT3yS7TBcgxTUK1ndqMYpKdGQk8N6ccddHavpDq/ShwrO?=
 =?us-ascii?Q?iJRCiuXtGZM9ggEhBbPRSz9OaYW0/IVX+zy0esM9IZjwYipSYHCjfK/1C64N?=
 =?us-ascii?Q?E4YEFk13B+LoGlJY/8259RzbNFKl23SO13XqnBQwH51X1OsFY9vpFLKNIVsq?=
 =?us-ascii?Q?bblA0U/gkDHc3fJytgq327rPFWvn4UQr8q5NgDwowX6n4n06oFoqFzkTz+R7?=
 =?us-ascii?Q?v6gsMfxTWYTA5KVcljZSkWxN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d043c9-05fe-464d-ae2b-08d96399b8fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 05:16:53.2372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PbHyNxW6a8HVff15JQeK0vZszDayqCLKhzGLwYYQSvjcC4JaJ8RAY2KbCfAlj2OmYHYukp4HArfBxt5nb8wbJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4452
X-Proofpoint-GUID: 3hLc2TiZP8zBM4FKWALHVUTD2OeOkgAZ
X-Proofpoint-ORIG-GUID: 8PcLWQ_gTHJ0SYwLfNPiYx5tNkuV62XQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-20_01,2021-08-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Hannes Reinecke <hare@suse.de>
> Sent: Thursday, August 19, 2021 2:49 PM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; Nilesh Javali
> <njavali@marvell.com>; linux-scsi@vger.kernel.org; Hannes Reinecke
> <hare@suse.de>
> Subject: [EXT] [PATCH 3/3] qla2xxx: Open-code qla2xxx_eh_device_reset()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Device reset and target reset will be using different calling sequences,
> so open-code __qla2xxx_eh_generic_reset() in qla2xxx_eh_device_reset(),
> and remove the now obsolete function __qla2xxx_eh_generic_reset().
> No functional changes.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 54 +++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 7786af46224a..ea804dc69b6f 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1388,18 +1388,27 @@ static char *reset_errors[] =3D {
>  };
>=20
>  static int
> -__qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
> -    struct scsi_cmnd *cmd, int (*do_reset)(struct fc_port *, uint64_t, i=
nt))
> +qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
>  {
> -	scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> -	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
> +	struct scsi_device *sdev =3D cmd->device;
> +	scsi_qla_host_t *vha =3D shost_priv(sdev->host);
> +	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
> +	fc_port_t *fcport =3D (struct fc_port *) sdev->hostdata;
> +	struct qla_hw_data *ha =3D vha->hw;
>  	int err;
>=20
> +	if (qla2x00_isp_reg_stat(ha)) {
> +		ql_log(ql_log_info, vha, 0x803e,
> +		    "PCI/Register disconnect, exiting.\n");
> +		qla_pci_set_eeh_busy(vha);
> +		return FAILED;
> +	}
> +
>  	if (!fcport) {
>  		return FAILED;
>  	}
>=20
> -	err =3D fc_block_scsi_eh(cmd);
> +	err =3D fc_block_rport(rport);
>  	if (err !=3D 0)
>  		return err;
>=20
> @@ -1407,8 +1416,8 @@ __qla2xxx_eh_generic_reset(char *name, enum
> nexus_wait_type type,
>  		return SUCCESS;
>=20
>  	ql_log(ql_log_info, vha, 0x8009,
> -	    "%s RESET ISSUED nexus=3D%ld:%d:%llu cmd=3D%p.\n", name, vha-
> >host_no,
> -	    cmd->device->id, cmd->device->lun, cmd);
> +	    "DEVICE RESET ISSUED nexus=3D%ld:%d:%llu cmd=3D%p.\n", vha-
> >host_no,
> +	    sdev->id, sdev->lun, cmd);
>=20
>  	err =3D 0;
>  	if (qla2x00_wait_for_hba_online(vha) !=3D QLA_SUCCESS) {
> @@ -1417,52 +1426,35 @@ __qla2xxx_eh_generic_reset(char *name, enum
> nexus_wait_type type,
>  		goto eh_reset_failed;
>  	}
>  	err =3D 2;
> -	if (do_reset(fcport, cmd->device->lun, 1)
> +	if (ha->isp_ops->lun_reset(fcport, sdev->lun, 1)
>  		!=3D QLA_SUCCESS) {
>  		ql_log(ql_log_warn, vha, 0x800c,
>  		    "do_reset failed for cmd=3D%p.\n", cmd);
>  		goto eh_reset_failed;
>  	}
>  	err =3D 3;
> -	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
> -	    cmd->device->lun, type) !=3D QLA_SUCCESS) {
> +	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
> +	    sdev->lun, WAIT_LUN) !=3D QLA_SUCCESS) {
>  		ql_log(ql_log_warn, vha, 0x800d,
>  		    "wait for pending cmds failed for cmd=3D%p.\n", cmd);
>  		goto eh_reset_failed;
>  	}
>=20
>  	ql_log(ql_log_info, vha, 0x800e,
> -	    "%s RESET SUCCEEDED nexus:%ld:%d:%llu cmd=3D%p.\n", name,
> -	    vha->host_no, cmd->device->id, cmd->device->lun, cmd);
> +	    "DEVICE RESET SUCCEEDED nexus:%ld:%d:%llu cmd=3D%p.\n",
> +	    vha->host_no, sdev->id, sdev->lun, cmd);
>=20
>  	return SUCCESS;
>=20
>  eh_reset_failed:
>  	ql_log(ql_log_info, vha, 0x800f,
> -	    "%s RESET FAILED: %s nexus=3D%ld:%d:%llu cmd=3D%p.\n", name,
> -	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device-
> >lun,
> +	    "DEVICE RESET FAILED: %s nexus=3D%ld:%d:%llu cmd=3D%p.\n",
> +	    reset_errors[err], vha->host_no, sdev->id, sdev->lun,
>  	    cmd);
>  	vha->reset_cmd_err_cnt++;
>  	return FAILED;
>  }
>=20
> -static int
> -qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
> -{
> -	scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> -	struct qla_hw_data *ha =3D vha->hw;
> -
> -	if (qla2x00_isp_reg_stat(ha)) {
> -		ql_log(ql_log_info, vha, 0x803e,
> -		    "PCI/Register disconnect, exiting.\n");
> -		qla_pci_set_eeh_busy(vha);
> -		return FAILED;
> -	}
> -
> -	return __qla2xxx_eh_generic_reset("DEVICE", WAIT_LUN, cmd,
> -	    ha->isp_ops->lun_reset);
> -}
> -
>  static int
>  qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
>  {
> --
> 2.29.2

Reviewed-by: Nilesh Javali <njavali@marvell.com>
