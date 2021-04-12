Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05A1C43461
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7433D61249
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbhDLKgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:36:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37464 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237219AbhDLKgT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:36:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAVLwb024289;
        Mon, 12 Apr 2021 03:35:58 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu995vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:35:58 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAYg0V030585;
        Mon, 12 Apr 2021 03:35:57 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2053.outbound.protection.outlook.com [104.47.36.53])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu995vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:35:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmFrEX7mXpeCIBHXmL1BAQCf/WFLe2BH73tQMWetN05IjoawcPDrrpXUmv07IDAia3dG1j4La3dQ6H+eBoa40kz4hMv0uouRte8p4XZrripWiMn7CmJAvYXXW4a+hD/5iAgvm7qXMJ85r5SyyaFSJ708KQ7l+kawtv8BuXmuXYKAF6mTVglWoB2HPjjITHQuNFPNfB9kYdtLHOjdzYf7tXRr4LiczCtnIN9LJvWoUDQPoOKu2Ocfcdb40N2aQ3I0QV0HbDEGtVEF4dmNLGi2hlIC+tN80JfEgV6GpfA7dbjrzHonhfMB1vLfk9SW74KjmAwezH3jnV53RmvG6611dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyLvApyJwBuT2INQ6gG9BirEpph/GMeDXyDFGWJg+UQ=;
 b=N2hGiOTpiliU1pD9Kkt3idNXozPCjYkOhjwkNEphMh7HywYS0WuYs6XXjB4vZrwu0vkTTaTdS2iiWbSBO86lnOUH+rNrMUDToyMwvDi3/VGkCv506GPjHsxxH6WnKXlxKZrmFtEEtNUfLSiZV1Fa0TIldm/nzN344vjHT6jp4iJHo8am30ln0wjFN3Gq2wsqN0aj6glajFYPWlEcqsciDFiTy+0yBu2KwMssGpWrU2f3ogM2fUcsc0tKuLyePx3bAxMnGMKa7RvoSO8KALy3D6wXowl1hC00/D1SHKAYw+Og8RVWrLJR307IEjW1PjddBaB98IB6O83vEqTa4UBX5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyLvApyJwBuT2INQ6gG9BirEpph/GMeDXyDFGWJg+UQ=;
 b=h5CzMERz2KwVTbyvN3DscTF7ZGJzsQ8/3nehgGKFCE/s/aurXfzTmE0fH3s5cGrQi2vkEHfQgQBQv+xYLZ05Sq/C2hpgzEp3sSDHjZfNJKPHS7hjOLBsLyz87kHyAFC0G44jfN6WjG5qFsH84sPz5n5ep/QYI54dZdwrvIpop5o=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3348.namprd18.prod.outlook.com (2603:10b6:a03:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 10:35:56 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:35:56 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 13/13] scsi: qedi: always wake up if cmd_cleanup_req
 is set
Thread-Topic: [EXT] [PATCH 13/13] scsi: qedi: always wake up if
 cmd_cleanup_req is set
Thread-Index: AQHXLjkIOWNd62d80ESelzmgTyG3gKqwsrIw
Date:   Mon, 12 Apr 2021 10:35:54 +0000
Message-ID: <BYAPR18MB299845DD228648025CB6F038D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-14-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-14-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cfa754c-45da-440f-8081-08d8fd9ec128
x-ms-traffictypediagnostic: BY5PR18MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3348C70698B3F4A5B01AA0D1D8709@BY5PR18MB3348.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GJBgC4DEUlmOwNTZ9t5o+ZFKVlftpmsSQNAfeAk6ozR23JFrOl7ZYvPVmDHPvjmtRWxuKdmwovRiK3XaEWWEzCepECRD3vzHghr99QOXF47+hUbumtiWOtPDlOuLEtZNpYEL/EyED6aJCxAyF2WFnmWkrZ/qwVVRy0NMLob2Kle078gi+kuMT3ZcvTm+BNDfD9TKt3wVLw+Go0QkFIRri5MYDrn5wxEZ+b+Q9MaU553MgaT40OSVqbIZQe0A2VijBF/8qvZALwegItSpkAx8u9WHw/kZukL2/I7u1ebr4M612H0yFx11YQ5TUxmZa45YHQWKayUTl/hoskmJuhXvpPYWNRQxePJyHBsHotqzxYS7S6C4zdXBSMBVjS2admtBqAj/dxa2lWkxGwQ8no1pG+o+hH9kCo59AO4N4rqO4EtI6jNd9ykJobiiHi9xZXBOGmSMiIYIyDSnnicK3c25wW4JVV8mL89/mlkxp3nZ64xV7k+5ReOQ2vkaIBRdopxR5XQ9W3GpwK5DA8GHSJTnmACwD7z/Ww7l6tFlxjBOByOwYRj2pG/8O3xa9M3okCutk7gTcmqnMAlz2iGo6nHzj9PxV/b+bafX7NOH1kWQYeM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(26005)(38100700002)(9686003)(110136005)(478600001)(7696005)(83380400001)(64756008)(66946007)(71200400001)(316002)(66446008)(66556008)(86362001)(186003)(76116006)(8936002)(8676002)(33656002)(6506007)(53546011)(55016002)(52536014)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?L1+iKf0koPBybK5UTUPxagBmqGeUXEm2rilZRywYYzWliCAXrf61XSNy8tqB?=
 =?us-ascii?Q?qXgYEbpH/LCCEJjvDmmgEQ8wcl1Arf8PhO7KIFYs3jPGPEeJmOKx+dzG6nEe?=
 =?us-ascii?Q?HrTRZLr14SJ0WFb/yRLcF4t4G1kOiNzSppM1xZ0HiZ/Q2v8eZ+diHXaZ0R6b?=
 =?us-ascii?Q?+l5zACOXBHr6Be0lqy2IX0RlEsbBOtBM50r0QzxYoWAc9YCx1qXkJ7OGTmGS?=
 =?us-ascii?Q?uAS5RT42AfNU4pLLnCcwzM36AdX+5miffo+gETFxJsvAUNb0wmOme9eRCcdP?=
 =?us-ascii?Q?twLooXZpP7qMtFbqUlZmzHsDBscTGupROoel5viGq5tSWwz+xByl+dF2nxAw?=
 =?us-ascii?Q?7tXJuhvJn0a4wmwTqCcveb5JMbDVLnVE0ynDt5FNHxwqB5DmEw02kFWAdV/K?=
 =?us-ascii?Q?LwrTij05NQgMVhe4C+2qCNd4XoPjP+j5Y0LUdZrwWCMdrl7ePvCBpz5PcWTI?=
 =?us-ascii?Q?YV14+f6F5qNvf5WA8kKPnhkKODpElGOFjkNwcwekAO9OfViRpHnGBqGii5ao?=
 =?us-ascii?Q?EaQHmNlvgWA48cL96zB0Kp/MG3nePdRf+WtYNyT9p2dtf2CSVTgv6d3GCi1H?=
 =?us-ascii?Q?kxlURfixN8lzd3RVLjNEbJSVJH7jtBrehXGOTL6JDFlH6Ntu6gS4a1HIaNGl?=
 =?us-ascii?Q?lz7pqSbRd6m0E+CiyucDju2sxUHUQdUCEecg1S6UBt6Nbs/9uiIRTpLDk7OC?=
 =?us-ascii?Q?bE77fg6jyLZZeRb6XLl+w5w2nDGkuNbcubd1j6ppuIYivcBhO8xMdERd98ow?=
 =?us-ascii?Q?qq17qYpOybST+7wOgy50unxvxeHMklTmRjB9c+SiBB+sGA2cKBW5PdBLXn3x?=
 =?us-ascii?Q?4Lwf7OYDl2TbkKAVpGfsjKOqlxc7lewzvlCBgpkGXC0p/HWd9QUzySXV7BrC?=
 =?us-ascii?Q?Rexe4skSNciqnQcxfUcGkx7W85A/rtuh8jatJhYDYABfpUf0dn8IvpO65+ax?=
 =?us-ascii?Q?Y+Q0DYQWv3CbgFRpntU2tZwmU5mk2W0u+jx1CsHClh3s4dscdfoKtHEBqfA0?=
 =?us-ascii?Q?WpNdtwS4ubvV1M9L6e8xw4LGTxvlStVXWimRNnFX0239OL+07PAI1eaeN3NI?=
 =?us-ascii?Q?GiV9edTJXYVzmlQwmnNpDeS4FkW4Sl/TYR4j6VQdHzq5lpThiAuoJ0MrIsmZ?=
 =?us-ascii?Q?jIjfKHDBm1Ao0neZhQ1FBxY1IGmVaGW98hLfsCvh4oHKqXw54pA8BCXdTD/3?=
 =?us-ascii?Q?AxdWDEOOGBsgXba0Qf2HYOZVQjmckEfGgBdRN/H0/HfRo0AcFOXjdYX0ds62?=
 =?us-ascii?Q?PjRonWRN5S1pIKcyraP8RYvBSFDGTkv0hi+cyM1ZGGNgp7s1NN27KCw11r7B?=
 =?us-ascii?Q?JYyEe8D+Jww9qTC8/kFy0wk+?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cfa754c-45da-440f-8081-08d8fd9ec128
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:35:55.9092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3I0dPYeTYcyaTSgyIAwr14PLN8m1OxBxe3Z6Xlwwg523mjS5bEwTX8/uDOnG8wXUbc+SvapAEg1dDOztpyPt0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3348
X-Proofpoint-GUID: bEM2GcERaUwluXo3_DAnkgpgMCxRhBOZ
X-Proofpoint-ORIG-GUID: xudgL8j1ctDN4vv0yUf5RYr7l_giis3o
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Sunday, April 11, 2021 12:10 AM
> To: lduncan@suse.com; martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; Santosh Vernekar <svernekar@marvell.com>;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 13/13] scsi: qedi: always wake up if cmd_cleanup_re=
q is
> set
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> If we got a response then we should always wake up the conn. For both the
> cmd_cleanup_req =3D=3D 0 or cmd_cleanup_req > 0, we shouldn't dig into
> iscsi_itt_to_task because we don't know what the upper layers are doing.
>=20
> We can also remove the qedi_clear_task_idx call here because once we sign=
al
> success libiscsi will loop over the affected commands and end up calling =
the
> cleanup_task callout which will release it.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 31 ++++---------------------------
>  1 file changed, 4 insertions(+), 27 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> 13dd06915d74..13d1250951a6 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -739,7 +739,6 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,  {
>  	struct qedi_work_map *work, *work_tmp;
>  	u32 proto_itt =3D cqe->itid;
> -	u32 ptmp_itt =3D 0;
>  	itt_t protoitt =3D 0;
>  	int found =3D 0;
>  	struct qedi_cmd *qedi_cmd =3D NULL;
> @@ -823,37 +822,15 @@ static void qedi_process_cmd_cleanup_resp(struct
> qedi_ctx *qedi,
>=20
>  check_cleanup_reqs:
>  	if (qedi_conn->cmd_cleanup_req > 0) {
> -		spin_lock_bh(&conn->session->back_lock);
> -		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
> -		protoitt =3D build_itt(ptmp_itt, conn->session->age);
> -		task =3D iscsi_itt_to_task(conn, protoitt);
> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
> -			  "cleanup io itid=3D0x%x, protoitt=3D0x%x,
> cmd_cleanup_cmpl=3D%d, cid=3D0x%x\n",
> -			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
> -			  qedi_conn->iscsi_conn_id);
> -
> -		spin_unlock_bh(&conn->session->back_lock);
> -		if (!task) {
> -			QEDI_NOTICE(&qedi->dbg_ctx,
> -				    "task is null, itid=3D0x%x, cid=3D0x%x\n",
> -				    cqe->itid, qedi_conn->iscsi_conn_id);
> -			return;
> -		}
> -		qedi_conn->cmd_cleanup_cmpl++;
> -		wake_up(&qedi_conn->wait_queue);
> -
>  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
>  			  "Freeing tid=3D0x%x for cid=3D0x%x\n",
>  			  cqe->itid, qedi_conn->iscsi_conn_id);
> -		qedi_clear_task_idx(qedi_conn->qedi, cqe->itid);
> -
> +		qedi_conn->cmd_cleanup_cmpl++;
> +		wake_up(&qedi_conn->wait_queue);
>  	} else {
> -		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
> -		protoitt =3D build_itt(ptmp_itt, conn->session->age);
> -		task =3D iscsi_itt_to_task(conn, protoitt);
>  		QEDI_ERR(&qedi->dbg_ctx,
> -			 "Delayed or untracked cleanup response, itt=3D0x%x,
> tid=3D0x%x, cid=3D0x%x, task=3D%p\n",
> -			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
> +			 "Delayed or untracked cleanup response, itt=3D0x%x,
> tid=3D0x%x, cid=3D0x%x\n",
> +			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id);
>  	}
>  }
>=20
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

