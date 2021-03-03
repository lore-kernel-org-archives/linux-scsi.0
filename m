Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49378C43333
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A76B64EE3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348282AbhCDAdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53436 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236717AbhCCQQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 11:16:07 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123FvD0w004281;
        Wed, 3 Mar 2021 08:13:58 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 36ymaudmp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:13:58 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123GDwhq001792;
        Wed, 3 Mar 2021 08:13:58 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by mx0a-0016f401.pphosted.com with ESMTP id 36ymaudmnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:13:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SehGfg39gtFEHLdmvMPQZOEjCaNIZZFxGSm3111W54lykoCt08FWkzJ4e4ONGTHKuEP81Tys7aZXWsv2MxUklt+SsBGMMMAAG2s2hvCL8HSRiNnNzpXPvAlaRnIaGnxxmEFv0OJTF3HYc2rVMF+EqRqQnSGc0n77RiA2MNngXNZ/VHf9rc2FAfDtO5XcJHrFNzaikf++3c1oNOh/IIAuiyjfjweYR8Zz4Q8gH99CQjb6+TGioKHAHUiK0RuA0FUn/9UfUn47yi7d8DNyGF1eNX9ffHn77BJ6SadWuF5XQHD12uY0thrJLnFgVQdOUqxpGyHOgEe/RpEfWJOGxE+Sww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRnnOkYaWItqEN3sTsWNQFKKOkm8KXgo7faM6hS4sD4=;
 b=hDYs5QAMiba4NpnUJaxSr2FIPP0AJfAOMoyR5Wb8oi/y+SCAQ2dCrGna/fh/ttULQP0BO3yFTtKveVFMPuRCaSCnHMsZSXRVeNgxu35+CljSS6KmTJePciJCKgB4rfXRdXKxultit8xo9iy9TZ/A8t44wDQt5pjzkKK8RVp9sN/a3fx0WP6W1atcexaz4hVdZICXXfhpng1W6sB9Wb8ADMsWohYK8oYw2OCJTIYtTtp3bsJkF9sxsWj55BrCBoq4A0tuhY2Njx5cNZCLhVSxLnN19NsCh07Y1dL3BGW9HRRgxiLeI826Jwv1oTvaxLCo/yiYPDeQo+dhY7FXfYv5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRnnOkYaWItqEN3sTsWNQFKKOkm8KXgo7faM6hS4sD4=;
 b=h4JWjEPWirXi+532JBkJkbnhaNGLeDOrQ30VdJmYzBgT85F5SlH4z9xr+rOHBErzn/AFyv+VOlvd3B9lLHuHdVrMco7YtNYI0WFity96Z8YASVPxK+TXcEi28bkh+rcC+4SFSZ6L2dBp+g4US9eSrx1Sq5Peao06ut+ksPxpfQc=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM6PR18MB3739.namprd18.prod.outlook.com (2603:10b6:5:c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 3 Mar
 2021 16:13:56 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e%6]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 16:13:56 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 23/30] scsi: qla2xxx: qla_gs: Fix some incorrect
 formatting/spelling issues
Thread-Topic: [EXT] [PATCH 23/30] scsi: qla2xxx: qla_gs: Fix some incorrect
 formatting/spelling issues
Thread-Index: AQHXEDwrSnJ0+jz6pUKgEYee+g1+kqpyb9Dw
Date:   Wed, 3 Mar 2021 16:13:56 +0000
Message-ID: <DM6PR18MB30525771EE87F6D6655D98ACAF989@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
 <20210303144631.3175331-24-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-24-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.94.50.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c04e752-6489-4e43-e387-08d8de5f58bf
x-ms-traffictypediagnostic: DM6PR18MB3739:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3739DDCE160B2F9FC76EC16CAF989@DM6PR18MB3739.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tb4Qdon70Z+vWiR6chBig6rBMLmGwGwqeyiUTFVb3N4fIDbrBGdYTV5BCTfFHiav9QLacaUfqtBDqrBqneJS4NNs8a3FpCBCVHwOqw3tBrwpMfzFSYgrlvQy5SVgqjfqHkIpx15PTE1Fjg2tYKo6Bibc5wxgnS4S6fk1zFXdFBofsEpaV7xaFseRWcVHGgiwX6Qtv4Kp5OpYzLOPuNwCTikkemrW1tlaRLk5sf3GMUE5HDwD58pKUyyArVlFA3++8qkISXh28PGvR5FH0wdjaaXw/hngk1JnrHdha4R2o2EcKxAW7tiFgPeUVM1QKmElXQtMIJ31iWtv5ipljeE7oF7FrGZGv7CEKAfVtcxSqzoMR9Oa74vXb5N8x8Co7MvqKlHVtBjk+43N1wgHGohLO3nyziUjVmcuYvdmATdYuJ79b+kr0BMD3EqOmasuTlbefoiJxhU91dXa0PHs6HRLs42dGkPTNjRkhrJDyaBPjoEIVYg4zdmdNpeASBLZ5tykwLWLgsX3433U7Y/dr9n1JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(26005)(64756008)(8676002)(6916009)(66556008)(8936002)(86362001)(71200400001)(83380400001)(186003)(7696005)(6506007)(66946007)(76116006)(33656002)(66476007)(54906003)(9686003)(66446008)(5660300002)(316002)(55236004)(478600001)(52536014)(53546011)(4326008)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OQeWMklxNWujjMIUsF7h7iUXqgul91X2kfrnUPfrc+g4bYyHliNwRnsZs3aT?=
 =?us-ascii?Q?hy/6mQAnUN5Q0F5eCZ0lpGiFhESJMh0oLsw5QHP9NM4N4SQCpVCRkP5wAE+c?=
 =?us-ascii?Q?niJdzb7FwDqDSlqaGKuIZFNaGcmOWDkK9zh0EGIu505ja9FF2JbG3wb32zuP?=
 =?us-ascii?Q?wZpA0+0RNZAzQEZzuypmyBwUmoOOOr+fMYbMC1ivD2bP0/eWH8CODabzKNUw?=
 =?us-ascii?Q?cBl3mMmgnMVowd1PcYUX1f+CVnj/swsdrhX7NsNFSrMsJOnlFBCEiSTqnNp4?=
 =?us-ascii?Q?I6Q4iHZgdke1Egvuk6DcXMA80wClLcSNazFDmh8kRw2p20NV8olsaqW/MWZX?=
 =?us-ascii?Q?Kxa+5WPkXoHxTQSTQTCtZV40SeLMjyN4VOGUxKSxYvItccSaWxqOgPqOQkd4?=
 =?us-ascii?Q?R1KxjMCb7MywfVjh4dhtT+zp6CXSDbkAfu5pgD9QykpDMUvbO9gbPn8XvQyA?=
 =?us-ascii?Q?yMvQgjYTtP8b4xZGNv07+AEnslH+fGvcpeRvKpMZoGU59JMKwU3Q4zmBJ6WZ?=
 =?us-ascii?Q?G4Zk8PiT8fd4MTLqxnhlgwXngGX3MoPCGpu+eYFcj9QqYQkj8fst47qeoUaV?=
 =?us-ascii?Q?8/YEaw1zNijlG5kch4dQLfci9PDjTMSBsrLzexismx8e+AptIwfttogd1niX?=
 =?us-ascii?Q?doXY8oSshEGIGQC1b0ZuDrp5xySyVvwFl7gcN6mjqpUTsvxvhq3Enold3guD?=
 =?us-ascii?Q?geFoLB3VOdvIH5O9HdBq25/D02qF/5691ccPnZAbhFyKWenL2x31l21ocs2K?=
 =?us-ascii?Q?hpUsu7ofwx3rfbiGSdTT+hoxKH1bdH0zMNJJGWDdJI6S2BF3/3qHsJExM/HS?=
 =?us-ascii?Q?bMvd+OyfNbPlhmBPfBIU6ZpaH595xPPMZFGC/11AzaA19EmielUOC0x6Ku8O?=
 =?us-ascii?Q?g6qA+3sNCVZgEi8NNeYqFFMpmJvjcZm9MsVxDy++bxoiJvcGGxTrbilBu0xx?=
 =?us-ascii?Q?dEGCqTWhWERldWCYA5lmGSM4m7Pn+uGC2JKRUUMvfRQiAqtWji1FxdPKefJW?=
 =?us-ascii?Q?cg9mkzspuV5QrX7YyIeXju8KC2ZVetKvSlbDNpGnFWfXK8OpC4Iq24SVdaNV?=
 =?us-ascii?Q?MpNNBiPDx/J3khlmNSMhOOJ6BbJvwVJvXHC/ig5vL6c+RA1sKLL0VNWVDsws?=
 =?us-ascii?Q?r7Gtgf1bWkO9/f8jU+Zc2bqxq8CF6PTHLIwXSSuZG1zD2J3K1pAFCgg3jeDY?=
 =?us-ascii?Q?/Y5H6FeNzenF80r4hFRPAg7tEqEfcCX0aFASm/F1UYdpu4us1g5uAo48zxv/?=
 =?us-ascii?Q?iCfh8ArMfyAfBB/rTl4ANapLCbgqDb203nxuz6/9RDV85aCXbGlOdE6yzUrN?=
 =?us-ascii?Q?E7wS5jqJr7SkpV76wW/cYvgH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c04e752-6489-4e43-e387-08d8de5f58bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 16:13:56.3486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JeJXRHZh0xXCWR+ia2/ZLIIa4a0TJKxsDBvFOWW92EuOw1h5mA9xfBEpDUEnmCh42C6cS/MIDv5H8STwh4k+KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3739
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Lee Jones <lee.jones@linaro.org>
> Sent: Wednesday, March 3, 2021 8:16 PM
> To: lee.jones@linaro.org
> Cc: linux-kernel@vger.kernel.org; Nilesh Javali <njavali@marvell.com>; GR=
-
> QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>;
> James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org
> Subject: [EXT] [PATCH 23/30] scsi: qla2xxx: qla_gs: Fix some incorrect
> formatting/spelling issues
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fixes the following W=3D1 kernel build warning(s):
>=20
>  drivers/scsi/qla2xxx/qla_gs.c:1259: warning: expecting prototype for
> qla2x00_snd_rft_id(). Prototype was for qla2x00_sns_rft_id() instead
>  drivers/scsi/qla2xxx/qla_gs.c:1492: warning: expecting prototype for
> qla2x00_prep_ct_req(). Prototype was for qla2x00_prep_ct_fdmi_req()
> instead
>  drivers/scsi/qla2xxx/qla_gs.c:1596: warning: expecting prototype for
> perform HBA attributes registration(). Prototype was for
> qla2x00_hba_attributes() instead
>  drivers/scsi/qla2xxx/qla_gs.c:1851: warning: expecting prototype for
> perform Port attributes registration(). Prototype was for
> qla2x00_port_attributes() instead
>  drivers/scsi/qla2xxx/qla_gs.c:2284: warning: expecting prototype for
> perform RPRT registration(). Prototype was for qla2x00_fdmi_rprt() instea=
d
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/qla2xxx/qla_gs.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index 517d358b0031a..8e126afe61b11 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -1247,7 +1247,7 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha,
> sw_info_t *list)
>  }
>=20
>  /**
> - * qla2x00_snd_rft_id() - SNS Register FC-4 TYPEs (RFT_ID) supported by =
the
> HBA.
> + * qla2x00_sns_rft_id() - SNS Register FC-4 TYPEs (RFT_ID) supported by =
the
> HBA.
>   * @vha: HA context
>   *
>   * This command uses the old Exectute SNS Command mailbox routine.
> @@ -1479,7 +1479,7 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t
> *vha, uint32_t req_size)
>  }
>=20
>  /**
> - * qla2x00_prep_ct_req() - Prepare common CT request fields for SNS quer=
y.
> + * qla2x00_prep_ct_fdmi_req() - Prepare common CT request fields for SNS
> query.
>   * @p: CT request buffer
>   * @cmd: GS command
>   * @rsp_size: response size in bytes
> @@ -1582,7 +1582,7 @@ qla25xx_fdmi_port_speed_currently(struct
> qla_hw_data *ha)
>  }
>=20
>  /**
> - * qla2x00_hba_attributes() perform HBA attributes registration
> + * qla2x00_hba_attributes() - perform HBA attributes registration
>   * @vha: HA context
>   * @entries: number of entries to use
>   * @callopt: Option to issue extended or standard FDMI
> @@ -1837,7 +1837,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void
> *entries,
>  }
>=20
>  /**
> - * qla2x00_port_attributes() perform Port attributes registration
> + * qla2x00_port_attributes() - perform Port attributes registration
>   * @vha: HA context
>   * @entries: number of entries to use
>   * @callopt: Option to issue extended or standard FDMI
> @@ -2272,7 +2272,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
>  }
>=20
>  /**
> - * qla2x00_fdmi_rprt() perform RPRT registration
> + * qla2x00_fdmi_rprt() - perform RPRT registration
>   * @vha: HA context
>   * @callopt: Option to issue extended or standard FDMI
>   *           command parameter
> --
> 2.27.0

Lee,

Thanks for the patch.
Ack-by: Nilesh Javali <njavali@marvell.com>
