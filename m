Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56A2C83006
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 05:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF79206F0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 05:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="oOrQzwjw";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="P1z0id8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgD2Fsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 01:48:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26380 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbgD2Fsh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 01:48:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T5iv0Y002113;
        Tue, 28 Apr 2020 22:48:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=P7xBKRU/sx3q1DclGqf4eZT50MWqmDp+pCG4pQSefhQ=;
 b=oOrQzwjwWkBKWp7ASoQtamTNFiLQFUgJN/OEEft0e7XpCrZPHhmw/R/uP2bl5bY9Ke/R
 XPmIaJLnQEn+yhT01Y94B2md4ZZPB777Vksd8RxEywxpAj2fdscKOgYyY2LNmlQtGeVa
 4t/cRtDbxA7vha20myL72obLZel06sUb2EHprly4+uroWDV1erzsfBX59cY2SY2AYvdk
 qBux1gX/g/GZChM0LNOLB+xuVsmoyRC6k++FhlDuuhivLxFTUhbQZFfjD2o5LmVs9Dpp
 fz0kCxknBUGtFerLoM4tXzjCH1rBFnF576G3gHWcU6VlRsRWUPepjBSNSKmTiMNpJpEn OQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30mjjqg1se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 22:48:36 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Apr
 2020 22:48:35 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 22:48:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4jXTKOGU9lpPqep7w8e6wQnv3z30wrWxgpKps8TOUo2Vqa/W2MUiDH0zbsKSDbuJjZwYLwCFth0+7R/4qd84pUX9o3aK8wOhEOTtmIouSy+phUqnwz6AvDLgYq9cGCNyzeX68BNofsPoe92uhEei/EkUxqUIHmJsrTPBGQw7a+jQpQh8XYxhB7s6O+h+8nRZxkvdLNjNrSplBm6yvdWNpd1bCEGRsXO9rn4R0T4xDN6ampbSCgoZZXUnBBkB5ow5xj7SuevdHwSmRLeMCIxiDD59P8YcQgSEXvugMzjvJqTHB/e9Hb+ZQex4Zc/QiONDbx0QUZQQpBO++DNq3Przw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7xBKRU/sx3q1DclGqf4eZT50MWqmDp+pCG4pQSefhQ=;
 b=JwWS/2dlslivih4uMSDX+S9Isq0Ewtp7cu1lYlHrx4RvpUd3iXB4ghUYgiFkKokwj4WDTC7zUGSwSZ48/BP89sJel5XQZ6DBIQBxPzb9q42sGRAcsDm09nEaiEUgH/8m0OAox3e0Buw9B38M4jXkm6AG+w45Iu+KxX1IQxyZqWUV+UottBrliqCgUL99KTnPxo0Hk1QfT+hhK8jdn10rNsQ0YrUckSm1ehKsnnMkd0n0bbUHPMTOizpqKRw6MD393lSyw42rTBicvxCAnZlzl5JgTOMmv3fX1ft99lzvQrwtuDfC3hNWmacXL4RRy/S04OT+wOqn+8gLr6nzS5lDbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7xBKRU/sx3q1DclGqf4eZT50MWqmDp+pCG4pQSefhQ=;
 b=P1z0id8GZiy3F7QdKLN0+j1hSWFImXdDYJFpt73kmy3d/s62QIXOO84LhK4/fVTobpXG9n+TWJC60AEg8ZKhm5RqGTMVuIgfR6PSELKMrIIHW1SVTAZYxQAbYlRtNyYX5Ii7p+IEg2XNT81+LzA0rg1oo2jJPSn9VBqnaTRLLZU=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BYAPR18MB2645.namprd18.prod.outlook.com (2603:10b6:a03:132::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 05:48:33 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::19cb:e318:d173:1221]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::19cb:e318:d173:1221%5]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 05:48:33 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>,
        Manish Rangankar <manish.rangankar@cavium.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedi: Check for buffer overflow in
 qedi_set_path()
Thread-Topic: [EXT] [PATCH] scsi: qedi: Check for buffer overflow in
 qedi_set_path()
Thread-Index: AQHWHV+2fB7/XPBS702o6elWr2/oKKiPmEQQ
Date:   Wed, 29 Apr 2020 05:48:33 +0000
Message-ID: <BYAPR18MB29985E46F58EDE47E32D773CD8AD0@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20200428131939.GA696531@mwanda>
In-Reply-To: <20200428131939.GA696531@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.75.137.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e90f39f3-ed69-42b8-2354-08d7ec00f3fd
x-ms-traffictypediagnostic: BYAPR18MB2645:
x-microsoft-antispam-prvs: <BYAPR18MB2645CB4B433C3B3745CF0736D8AD0@BYAPR18MB2645.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39850400004)(86362001)(7696005)(9686003)(186003)(55016002)(55236004)(8676002)(71200400001)(53546011)(6506007)(4326008)(54906003)(316002)(110136005)(8936002)(26005)(5660300002)(2906002)(33656002)(52536014)(66476007)(76116006)(66946007)(64756008)(66446008)(66556008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: phkt1/2uzw0mqWkSUcI1tDPb43EunZydqeh67B+5/LlP40G7V9Ra5tK5rKCwyZUls6JAmhaTJbYNB226nTVwWyoyrfY9xb2W49Q0O3r4Ej2opDzC3cr8W8w4cvxZ4XCP7D3J+ow9gCt7GVj5rcqtRiUrZeUla8/0gcjg/WdZ2z6LyBd769W1rTmum4UglOFKTB0kTHDqo12p1Wf6zpWLjWSgkbmm8LNUdHEZkhGKBhg9qvXH4EsVDpTU60yO74z/ABAyP9Os4KeKOs8StYyzcRx3GqSh6+gd+IbYajpi8v/PuIaT6INPM/mN4iaNeFpF+owhfBMGixRw4w52JX2t+7WgbutJVA+C86VnrtO3u19g4YgJS+UNK3KJDT0qtgjzCdOmc0HFa/+bToVcn1PjecQGRSWdpeAby2GQRT1JlHU9HOwq0QH+C4KLz68uHFdk
x-ms-exchange-antispam-messagedata: CchCJmNyG/HXWjIklVvuI6URjFGvykrGJhkqziOVuAFvshtwlU7oOVle9VhcvJagrU3S5inBQp0Xk46jm/iH7bywvCmK8aCpypgnaaf31m1qIcQXWR43IixDs5gYkTX/YQaceM0HUZCMbLXO52/5FtG+1oK7TaWAT8+Z3OF/xtGZEDiZ3N8pbpIQ/GCIxNTOWhA7y35TsDnDOrZPA0lTqpQLuo1bvuAUtV6haCklBxHlDU0NVKIYgHNT864mY7GIg/qNnQpsECydI+BaQaiOeAEdbBYmQPwKsoTX0noHu9bP7YP55rTMTuxl88xy+sYYU4GIJWbh3F6rBygV82W6Nk1UHfL578uvvkhDTATtjWxV5X1vAjj+v/PlcFAEFdCtUZpcWkOCyi8v43zUOa7v/oGiRlRna5zEVjvV1/d7rZw2qDFQpPjk4O6WXZZdoPAJEdnx16/UPzusRgL3ZjAqZPFM7CzAuSKKpB9Ad8RBDGW7cFdbhPE7nMcdygzx1MzbYmCHL2QKgqdjklNqhGMJQN78lek7xXaqiLlXVNQPf9iZXzoKaQ1QLJ9SOc2MmYYXk5fuSt7Ta4KAdXFir3yAxjGL85FqVC4X9G1a5y+CZsWfHfWp0r2uSRLRgzlRFJ7YzpBku3vQsKBW7x+n59wqQmKn/S1Zo4eKq417+sKcdC+HVGDCWuWk6YWImR9OVnUjxg0Nn0vzWqN5WN2da5tAzt4OI+NctIrsjdWUE/EYrBJCjFR0vp5Na5Mju0rHf3mYFbTnE1oEIVuhyAkxrZpfakpXr5uTCMDouJncxGYmzmA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e90f39f3-ed69-42b8-2354-08d7ec00f3fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 05:48:33.2333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2uNhASmK658ccuiND7UV7ydgwb154wbHaCej1wZxea1fwAxnmrIMt0xKJWZ0LNvcvbBHYr8jOAIwN0JCQsJUoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2645
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_01:2020-04-28,2020-04-29 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Tuesday, April 28, 2020 6:50 PM
> To: QLogic-Storage-Upstream@cavium.com; Manish Rangankar
> <manish.rangankar@cavium.com>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [EXT] [PATCH] scsi: qedi: Check for buffer overflow in
> qedi_set_path()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Smatch complains that the "path_data->handle" variable is user controlled=
.
> It comes from iscsi_set_path() so that seems possible.
> It's harmless to add a limit check.
>=20
> The qedi->ep_tbl[] array has qedi->max_active_conns elements (which is
> always ISCSI_MAX_SESS_PER_HBA (4096) elements).  The array is allocated
> in the qedi_cm_alloc_mem() function.
>=20
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI drive=
r
> framework.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_iscsi.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c
> index b867a143d2638..425e665ec08b2 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -1221,6 +1221,10 @@ static int qedi_set_path(struct Scsi_Host
> *shost, struct iscsi_path *path_data)
>  	}
>=20
>  	iscsi_cid =3D (u32)path_data->handle;
> +	if (iscsi_cid >=3D qedi->max_active_conns) {
> +		ret =3D -EINVAL;
> +		goto set_path_exit;
> +	}
>  	qedi_ep =3D qedi->ep_tbl[iscsi_cid];
>  	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
>  		  "iscsi_cid=3D0x%x, qedi_ep=3D%p\n", iscsi_cid, qedi_ep);

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>

