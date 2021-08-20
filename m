Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3CFC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 606E761037
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhHTFRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 01:17:08 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65310 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235776AbhHTFRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 01:17:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17JHBB74005963;
        Thu, 19 Aug 2021 22:16:25 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ahftmmxky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:16:25 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17K5C6pq007465;
        Thu, 19 Aug 2021 22:16:25 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ahftmmxkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:16:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2A9d3bG1XBzGq4UQHGzi+ZWWZKaxLjnZlU6ixufFIVlJ6XrQhbe11pu+Ql090oowmHP19dJtHMg6x5IBFagnPmN2QhB/l6otwdWzVpfigvhqZHb5psSldbGsVQR0C7E5A4ffAPJqqfIpEsR0HvuME3T9fzMPvx/bUhHW7hG0JfTn6Kr0J7/bZ+tSPB3hLKxB23DSM6cKOyiBdh39+680/ppSy/pT56fXqkkbbtNDX0qx4lluLWGPyZzONBy6j7B0JwNtDH00wE+KwfsM32jJmtp0r0qw/wdrRna9jPDqPI/fuRsymhck3C1Oj32vvz0DRjydRfdWZ2MWH0tF5y7+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKrWxfTWtHvRIpO4H2um/IZ0ikt06EWERtzjtk2SwfA=;
 b=SU6QpjMVeTIHZW/tUsGwnZWO8MAiX56dO+S3NRc9/aDcWYysgBypUPAFwNL5XrYDN+fbuP5d+DxYOax6RRKTv/g9OR8/QBcaOpd/ilE4GpFr+kbJcsviTC73vq0iSHHAg7/jIvUsU/IBrUrFz2/utjp33clDL//wrq7J32UMpiY3K7bcwRne+4Wfrdie+56FTdeGleBVyOoeBrVn/W//fw78RBuAohRQuf8XXT+2RdmmjSc5XRYgPBMa1C78AzC5wp2urdq2cU6oSvRK28BepYME8s1peNa35jfLbl1QRMab6L4VxIdxlm2jStoLrpCKklvCXWxFQhttI4cAf56dxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKrWxfTWtHvRIpO4H2um/IZ0ikt06EWERtzjtk2SwfA=;
 b=h7RBDT16HjBFxtm+gpTGq4RKw0h/iVqYeD9gz/KfkUCq+F8pTEflhIlwCiOIhv6HdorsdUMoRcD2Q2atQQpJj0TEi8ukDgToTRRJfT824QRQ8Wr8cAHmTB0UJ0j+jsjfiUixUho+AE/9MI9KP+0ZZorQ+wU1FMpuKxuKGvUnfzE=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO6PR18MB4452.namprd18.prod.outlook.com (2603:10b6:303:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 05:16:23 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8%4]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 05:16:23 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 2/3] qla2xxx: Open-code qla2xxx_eh_target_reset()
Thread-Topic: [EXT] [PATCH 2/3] qla2xxx: Open-code qla2xxx_eh_target_reset()
Thread-Index: AQHXlNtQtgfOwSJhGkimMncgxSdEr6t72zTg
Date:   Fri, 20 Aug 2021 05:16:23 +0000
Message-ID: <CO6PR18MB4500FD50F55E447CCE443599AFC19@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210819091913.94436-1-hare@suse.de>
 <20210819091913.94436-3-hare@suse.de>
In-Reply-To: <20210819091913.94436-3-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f5f3d67-f5b8-4fe2-9c0f-08d96399a734
x-ms-traffictypediagnostic: CO6PR18MB4452:
x-microsoft-antispam-prvs: <CO6PR18MB4452B97D543016E27FCB3139AFC19@CO6PR18MB4452.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKZwTlXxJ0TrLaCxrCHHh9kPYUrhc77keu0g2qwCNt/fuGkdMyBrFzxSVbCMFyID0XwBaZQuHAKnWnb7mHc1AmEc+Uk/l/TwTixN4hcU6WRQ7vGGcoE0T4ZSdDcmUmKEZ6e6/D/IiTziuQxuqlGm7ujVrOcWumcHFuZyuOI71MA97ZRvLYYND961Sc6PXCo0S5KzuU+3OEYfoaOXj1EyqeXbwDP3hKpnRR4y6QPpn+5JRxLQqGkiCWzEMEMLuTudR0ZxQZGBndXvUnUeJiSN+wVoyf9iqWxPPEc13bO7zzxg7zOKq2bEqSe9U2lKIFMtUsk0udnn9Ftnse3fetID2zwKT/aE/KLYt3QhmwUngi2YIxjwVjDQFctxnzgxsa64+i3Bs6omTQvkAZifWXfcR31apUoI77TZXnLHVC3QXnzEv5Y8HnVpguzuweg8AMjgHnvNsqi1FWY0XNv8RYTTAoC6A8nY3iqfT4GSF4Vfnzo/iFoonHNSPVeKw1DOiWy7s4NdGlhtxCDWg6PBBzUwmzTSJruqf/FjwT9GKXM925LUmOL2hWYckSHHCb+U+E7rwwP+iZaVaiinQlC18IpV36QKj9J6tcGEQyg0L3Bx/+BKpiPq1gXxqSoc4ourSBmsvl/Tc5tbQUWhaVFIKS+tWHthton+uXXJz4zkQK9f1ooqCsdv0RnLR6uwBilClZT9SWTy89sBjLf1Dy2A3AbAVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(76116006)(66946007)(8676002)(55016002)(83380400001)(122000001)(86362001)(110136005)(33656002)(38070700005)(38100700002)(54906003)(2906002)(71200400001)(5660300002)(316002)(26005)(4326008)(478600001)(8936002)(7696005)(186003)(53546011)(6506007)(66476007)(66446008)(9686003)(64756008)(52536014)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jpAYyZRDnA6n5sPq3vMDzbFmIzr5Wwsjzeg5NMFkLVxZV6oCWbP5+NCfranh?=
 =?us-ascii?Q?WWf18R+GP0R9mi2Z8LRp2qkl5filOBDUDYseD00q8JzOMX/oElk1cQxg/tky?=
 =?us-ascii?Q?n4cXVJkLf1IjVioi1HTWyIoZ6pmj1P0YcqG97Pm/XrvhvAbbrJkEB7fVtqrM?=
 =?us-ascii?Q?zm8C/+ciEJL9BmKoUqlPJpGL7Xpq16zgLfbodV616hvwycLNV8CQGCHG/GXu?=
 =?us-ascii?Q?d1pyEAGckFi6u83r6bRGycS1mktYpPmnGvUvhV5mTqPoUaN4g0HDwtlr+rXI?=
 =?us-ascii?Q?SzOqO9e8gg26A8knnjL+d73QFeoYY6lT/vBfbTKiPBiI/xA2O3vY6Fo5dnNU?=
 =?us-ascii?Q?aVcnpeJpdL3kHIKYARqH4dfhafWjE86IcMXiYwc33WPD2PINN5AGHYEIVw5w?=
 =?us-ascii?Q?XysqDpSsVJxn6ZYpk5FZj8r0tChTdQbYX3qLejYde0Cr3r5uv7Sj3nY6YEdJ?=
 =?us-ascii?Q?JVH7NKgX7BR5IMCcZRDWotpqL0dlW1nokxNHzjE3Px/xS9oE51ztZuWv6pCP?=
 =?us-ascii?Q?7XGsq4oQuujKWsG4xQed4okR7ZDNL7xxfwwdWD1ed1DA6WILwnfsAc5coXZJ?=
 =?us-ascii?Q?FMSLH5TeNyezqjUJLw5awj4Y/7ZZejsHpMdYJEJ1EGSD4OyiOs1iJR4wX6gM?=
 =?us-ascii?Q?JAulPAr41tIJRTVpA7eb/LtOmNuEHxh1zaDGVl+u4Ih/3HLT64CKlDK6qtvP?=
 =?us-ascii?Q?L5iQGhhOMBopgwLAl64yDLOvnnCTndLkoOreMZ9kYUWvJksiHnHrKPsOJlLb?=
 =?us-ascii?Q?e4vbEb88+CEU5WV3eBpMqTDFbWoEThfcZ1a3TIZlgQhGM6rTPfElsGArXNMq?=
 =?us-ascii?Q?/keWnsk63MhNUATKV67Q5x9xMuR20ZaFgPA67hgRmr1Ln49BoRSuILJBeryD?=
 =?us-ascii?Q?oA/ohKPm/hH0b9TCzhcIR84Av4b+n4TnjcPGuIAgKZ899oTC8cRAaBYjseKM?=
 =?us-ascii?Q?OAXuHT9gUXuQGAFdPy1MLsd4NfvDUhek4BYKobd/8Bn489rr37ONZdvC1zeX?=
 =?us-ascii?Q?Ds/LgggJjzaCKNq21ZP6znUidadkCszLBYu2wo1NGpU53/YqdqTtfgaUWbhd?=
 =?us-ascii?Q?MTXJK0uAnzBxhUaNctPgqmeZJtz5efXM7iG2vBSsBDBdN0AWRGrD6K/qJBV5?=
 =?us-ascii?Q?XoJITLb6LM9NH7u/AAA5OuuB7aNeYfP+Y94ttKJl5H//peYa0uywnkuHYP0+?=
 =?us-ascii?Q?cHKwl9bSO68NggmCZ3/M/rgwavGB1YJcPTKzh2ns2gsPJIwGr6/veIJWJHao?=
 =?us-ascii?Q?AP0bivsJYgIh1UO6hQGb7u8dQua/LiojXJv1TRLb/z0CphLKTWJiEbOvNgG6?=
 =?us-ascii?Q?xuVKi6jsTqiUT6jQTTEjMqoL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5f3d67-f5b8-4fe2-9c0f-08d96399a734
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 05:16:23.4023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTG3XkhzUNzA1Bsho7Tg4qtcBOF04K7jxoaqCzpLHk/V/X9x76pbf2GBsa27Rvcr8fJow/1P97C9Vztqthfnxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4452
X-Proofpoint-GUID: W1L7-lg0f-N766r34PgN32JSmYKv06C-
X-Proofpoint-ORIG-GUID: JqJAi5JQeLndqbxmZoz2bKxYkufsyHV8
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
> Subject: [EXT] [PATCH 2/3] qla2xxx: Open-code qla2xxx_eh_target_reset()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Device reset and target reset will be using different calling sequences,
> so open-code __qla2xxx_eh_generic_reset() in qla2xxx_eh_target_reset().
> No functional changes.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 56 +++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 54254bd3a7d7..7786af46224a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1466,8 +1466,12 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
>  static int
>  qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
>  {
> -	scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> +	struct scsi_device *sdev =3D cmd->device;
> +	struct fc_rport *rport =3D starget_to_rport(scsi_target(sdev));
> +	scsi_qla_host_t *vha =3D shost_priv(rport_to_shost(rport));
>  	struct qla_hw_data *ha =3D vha->hw;
> +	fc_port_t *fcport =3D *(fc_port_t **)rport->dd_data;
> +	int err;
>=20
>  	if (qla2x00_isp_reg_stat(ha)) {
>  		ql_log(ql_log_info, vha, 0x803f,
> @@ -1476,8 +1480,54 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
>  		return FAILED;
>  	}
>=20
> -	return __qla2xxx_eh_generic_reset("TARGET", WAIT_TARGET, cmd,
> -	    ha->isp_ops->target_reset);
> +	if (!fcport) {
> +		return FAILED;
> +	}
> +
> +	err =3D fc_block_rport(rport);
> +	if (err !=3D 0)
> +		return err;
> +
> +	if (fcport->deleted)
> +		return SUCCESS;
> +
> +	ql_log(ql_log_info, vha, 0x8009,
> +	    "TARGET RESET ISSUED nexus=3D%ld:%d cmd=3D%p.\n", vha->host_no,
> +	    sdev->id, cmd);
> +
> +	err =3D 0;
> +	if (qla2x00_wait_for_hba_online(vha) !=3D QLA_SUCCESS) {
> +		ql_log(ql_log_warn, vha, 0x800a,
> +		    "Wait for hba online failed for cmd=3D%p.\n", cmd);
> +		goto eh_reset_failed;
> +	}
> +	err =3D 2;
> +	if (ha->isp_ops->target_reset(fcport, 0, 0) !=3D QLA_SUCCESS) {
> +		ql_log(ql_log_warn, vha, 0x800c,
> +		    "target_reset failed for cmd=3D%p.\n", cmd);
> +		goto eh_reset_failed;
> +	}
> +	err =3D 3;
> +	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
> +	    0, WAIT_TARGET) !=3D QLA_SUCCESS) {
> +		ql_log(ql_log_warn, vha, 0x800d,
> +		    "wait for pending cmds failed for cmd=3D%p.\n", cmd);
> +		goto eh_reset_failed;
> +	}
> +
> +	ql_log(ql_log_info, vha, 0x800e,
> +	    "TARGET RESET SUCCEEDED nexus:%ld:%d cmd=3D%p.\n",
> +	    vha->host_no, sdev->id, cmd);
> +
> +	return SUCCESS;
> +
> +eh_reset_failed:
> +	ql_log(ql_log_info, vha, 0x800f,
> +	    "TARGET RESET FAILED: %s nexus=3D%ld:%d:%llu cmd=3D%p.\n",
> +	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device-
> >lun,
> +	    cmd);
> +	vha->reset_cmd_err_cnt++;
> +	return FAILED;
>  }
>=20
>=20
> /***************************************************************
> ***********
> --
> 2.29.2

Reviewed-by: Nilesh Javali <njavali@marvell.com>
