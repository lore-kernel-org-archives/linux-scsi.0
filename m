Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA54C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A1E361278
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbhDLKel (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:34:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49642 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239413AbhDLKeU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:34:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAV28m024153;
        Mon, 12 Apr 2021 03:33:54 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu995rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:33:54 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAVmdJ024411;
        Mon, 12 Apr 2021 03:33:53 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu995r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:33:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJ1Tf8mTQWwVYNFqrUmazC0b6Wu4qjcFB4UKMtWJtcmBuGn16C9MXcEjckuqLCL5JlbsNeRkB7Upn/9PIvDrLAPfqV6PLKqJbMRlDsNb5EE4efp2c0K8EEtR0qjCCiZh0jd3FyeFNqT71mjG0GSE4a817pPqG27geZcaMJa27plMxs/RsOLBxhKXyj/u85J6z+LN8+vY9V4NamsCSOu0T/x/LW2xiv0YiELB2EXYbdyoK68M+FVjVRhM2GT9dEaY2hzgkDVpTuCOUgNDXhzehmczICGFhgicVtkLEHO7BMC9NWX3kGCjK3qtlnXQxJAvydg9ximodoRj47ARnmgfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlXpUBIiWn/HRR96X2pRTEfwLnGhsgzSklihvtaI0Sw=;
 b=Em+0IxT8IPdPGFWh2H/zZIev8Dg81LALmNEp/oWISwTA55PSuvsuJqQ6byziz1W1KfJRPZraFJ5VvA6cdmQB9f3+UdWsK0cyZpqGDJPQ01sOwQj2Uax2aHx8aZpqbTyC6lpc2VLgZmYIiGJyL74Gwc6yYRNt6TwMo84O5SwCfLvgmmDZGlA4Lup5cawrJx5YOlEf6WnpNX6jgGMrpZSBaVHgndDVFxJiGc57ftkon82ihahv2VAP7NrSCpjKbcU9p19gl3tBXJ0hZN2RB3mTGjWSvYCeZUyfHatb6OVQ7QFJRbQaoO+gi1ordaCW9+ld4E9zQBoiz47oH+L9SLRYpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlXpUBIiWn/HRR96X2pRTEfwLnGhsgzSklihvtaI0Sw=;
 b=mxR6i+MSRl33WJqNM8G4oz4VotenJiCtcNZSDbe0mhlhfmTqB6jjDihoZ1D6oPmBWTbUwc5uL2YKrHbNWkRweG+bib8M81BppdcXRvMcOXSi03FejgV7PAlaxgML54StbwGT5i/IWXI7SuMAiD1OeSZmljZSh2yc7uYwPotNwYM=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3348.namprd18.prod.outlook.com (2603:10b6:a03:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 12 Apr
 2021 10:33:52 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:33:52 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 10/13] scsi: qedi: fix session block/unblock abuse
 during cleanup
Thread-Topic: [EXT] [PATCH 10/13] scsi: qedi: fix session block/unblock abuse
 during cleanup
Thread-Index: AQHXLjkDOGxhyCl3LUSCJiEBIE1fAKqwsiRw
Date:   Mon, 12 Apr 2021 10:33:51 +0000
Message-ID: <BYAPR18MB29982E75FD0C81C25DE5F1A1D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-11-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-11-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68ec3bd8-a81c-43b3-1cbc-08d8fd9e7747
x-ms-traffictypediagnostic: BY5PR18MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3348FC370235CAB9AFCA194AD8709@BY5PR18MB3348.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: becZyrsKxLts02chHaOW9cpOa9+vspJkISXbNKtP72B3DNQg2+KM2l/EKOT1frWSvto9Pp4uGYmnv/MxemTIqf4AE88Hi7jpgJzrBY2AXrp2tH4WKJ5jvpTWj/ppQGzDPEBQM6Ll1j5srne8e5kEcJZTyjonh7DdG9YIOENyWnQwWF9HcO4rKaomaP6ixxxYhvEkBiPQhEn6oraMFrgYHn9VxhpTH7HujhhGcQloXH9mK08EtJCuMQQCmFturUMtO7eScvT4WL2q1CiEYwce1xH1kHXBmCt49YMkHJZ3vn0tx3b+Xki4IiAtEXnnLqFiTGr6SxftcCT1qr5Jz2ERsGdEbDFxYLafevGGsIFxvEzwwzzWXFKtJmeT4+bU5xcU7xxGYyOTheNjOq+QXa/E3y7oAmb0VcI9OzTN+6KCauloGUNlcaXPn3ynjJcHgUJiLpQNdkZnB0faQTIK79maR8ajXHThtb3wW1zUxRXlVD13jkjsuVtlBe8Lcu+xzpRNHy6PSj7s1PXr1TG+bgl5l2PdJ4a+vVpCu1YW/4uRdNlTtNxxeg18NVggVA6Rz/rHGDBZbblZpi5VpolvSkI70EL1SEjo2/CW+wSGDrxBY1o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(5660300002)(2906002)(26005)(38100700002)(9686003)(110136005)(478600001)(7696005)(83380400001)(64756008)(66946007)(71200400001)(316002)(66446008)(66556008)(86362001)(186003)(76116006)(8936002)(8676002)(33656002)(6506007)(53546011)(55016002)(52536014)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UBU3iprTZR0nrsJ7OUW+gYth+vJmzQ1wA3uxs6u21fICcyPdL+U81yDh23+u?=
 =?us-ascii?Q?Jme/4IXq+kOk/Tvzw+vIZQMw/MThbJvPbV2gtr42mklt/DRZOdZ2jk0Bz4W0?=
 =?us-ascii?Q?Pp9m/39X/xKoh0vsjI6f2yQ0aPChe1RJbLRuXOg0CXuZJdu7Kt/c1uW3xCE5?=
 =?us-ascii?Q?uWonV2u7e+NY2f9UO2a4QYV88QVdQQHdb/lDcymwNu3yOag6TVhE2fEhjX6F?=
 =?us-ascii?Q?qMEmXy38Mv7PEEUSnkcx7b2AnK+M37xeoPc3evo/QjMtZCH8SHWpBphud01Y?=
 =?us-ascii?Q?QPL/HkNW3QPrTStc00mkcMagpCJa49ur1tTac4MLzTvmqNQPJbj+Nmt4Nh3P?=
 =?us-ascii?Q?5BiNL2i1whrH7GNjBkSmo4m4XrHFYKOqD1ra60abtN2JLhC7Kx4Jvb76TIWa?=
 =?us-ascii?Q?FEEyWZw+wtv2S2KOqRWVT/SdxfhvGklLJKmGFPKPvMLpQ/hSXtYWJ7Cj8NdJ?=
 =?us-ascii?Q?tZWnjvJq5hXsXNuqp16vnXBh8PIGl4HC/8IgmlkO/hv4LfarQXFp4zODao2+?=
 =?us-ascii?Q?PPXlCYf2JLKFht7n3O4UzfSWL5fbl7yAS7F18tqdzQvoCInhYrHHHfiEfVlo?=
 =?us-ascii?Q?sj+CDjoG5GpRqLMWhxNNSNSvUXbg3odWLYNc3NS3WEbovZYI0AmInTqEjydv?=
 =?us-ascii?Q?BWQP9xDEOms+oeUa9MCluI0fUqrgIkStgaqOK0rKYj/zWp21jYwr9d2mIgPu?=
 =?us-ascii?Q?ZQ3GrxDf8s6kLYmDXc+7YWrGIszKenB7RVJBohtHBjRZkdxP3m+WWemEl8fy?=
 =?us-ascii?Q?s6IOStr0nyxvXsroOMa+u3ODP8sGyp4Py0aHZc0kUun6jVHI0rmX2W1fB+33?=
 =?us-ascii?Q?lC7nZzD5copVmK1rVAaErPLYAgbuYcl0O+K/on8XaNe2fwquHLl5LB/ayP7+?=
 =?us-ascii?Q?YfjdIeD6m5jwbpNiu6uwM45uSm9P3PBOI8NaJwlsZWFgxlnJHpWv1niu0rRe?=
 =?us-ascii?Q?gF6TfOBGWrxjeXJtoB7okBZF5YyL7t88JP7qUL2wFB+g/DFF2GvFkfTu/WF5?=
 =?us-ascii?Q?r/JhloQyzPE7rJmKU4C7SYnHpySTeDQ9v4o3o/qjc3abLYGoHHEqpu4pw1ia?=
 =?us-ascii?Q?UaPh0p45NS0YIjCluQiGgZmqANLBR+AmhWbDSrGLqNDYWmhQ5DowXs5nF7dZ?=
 =?us-ascii?Q?PeMI+Sd+rjOB5QHH88gYiHCdqv7wMIrb0ctq6WGbeUO4G+fEpBZKOGz4iOUk?=
 =?us-ascii?Q?0cIrw29wbD1F0nG0tE8xQPMGw4VIv9Dh7rI3VXXUJbuXFiGWyqwtVzCGplTc?=
 =?us-ascii?Q?BV13fljtBkenU4/t33xn43nHTri2agVz0kj7a5ByNg+JSK+p02nok+XaHp/F?=
 =?us-ascii?Q?ppvAZXya2FWhY+pei8N3g+oB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ec3bd8-a81c-43b3-1cbc-08d8fd9e7747
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:33:51.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cqpN/W9C/OO2CRyVb7fLHku7fVg9gA0gPl8PIj5vu5MyDsERkb406XIKdVtHcDT+TDlFHdVfAuHGd1NGLl//6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3348
X-Proofpoint-GUID: myZ5t9-ERIl3nN0Q6zuoCYMI4iRZO5UC
X-Proofpoint-ORIG-GUID: D2bG5DJt4rRYf8s5XTZymlxWHh6ID7fh
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
> Subject: [EXT] [PATCH 10/13] scsi: qedi: fix session block/unblock abuse =
during
> cleanup
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Drivers shouldn't be calling block/unblock session for cmd cleanup becaus=
e the
> functions can change the session state from under libiscsi.
> This adds a new a driver level bit so it can block all IO the host while =
it drains the
> card.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi.h       |  1 +
>  drivers/scsi/qedi/qedi_iscsi.c | 17 +++++++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h index
> c342defc3f52..ce199a7a16b8 100644
> --- a/drivers/scsi/qedi/qedi.h
> +++ b/drivers/scsi/qedi/qedi.h
> @@ -284,6 +284,7 @@ struct qedi_ctx {
>  #define QEDI_IN_RECOVERY	5
>  #define QEDI_IN_OFFLINE		6
>  #define QEDI_IN_SHUTDOWN	7
> +#define QEDI_BLOCK_IO		8
>=20
>  	u8 mac[ETH_ALEN];
>  	u32 src_ip[4];
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c index
> 821225f9beb0..536d6653ef8e 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -330,12 +330,22 @@ qedi_conn_create(struct iscsi_cls_session
> *cls_session, uint32_t cid)
>=20
>  void qedi_mark_device_missing(struct iscsi_cls_session *cls_session)  {
> -	iscsi_block_session(cls_session);
> +	struct iscsi_session *session =3D cls_session->dd_data;
> +	struct qedi_conn *qedi_conn =3D session->leadconn->dd_data;
> +
> +	spin_lock_bh(&session->frwd_lock);
> +	set_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
> +	spin_unlock_bh(&session->frwd_lock);
>  }
>=20
>  void qedi_mark_device_available(struct iscsi_cls_session *cls_session)  =
{
> -	iscsi_unblock_session(cls_session);
> +	struct iscsi_session *session =3D cls_session->dd_data;
> +	struct qedi_conn *qedi_conn =3D session->leadconn->dd_data;
> +
> +	spin_lock_bh(&session->frwd_lock);
> +	clear_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags);
> +	spin_unlock_bh(&session->frwd_lock);
>  }
>=20
>  static int qedi_bind_conn_to_iscsi_cid(struct qedi_ctx *qedi, @@ -789,6 =
+799,9
> @@ static int qedi_task_xmit(struct iscsi_task *task)
>  	if (test_bit(QEDI_IN_SHUTDOWN, &qedi_conn->qedi->flags))
>  		return -ENODEV;
>=20
> +	if (test_bit(QEDI_BLOCK_IO, &qedi_conn->qedi->flags))
> +		return -EACCES;
> +
>  	cmd->state =3D 0;
>  	cmd->task =3D NULL;
>  	cmd->use_slowpath =3D false;
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>
