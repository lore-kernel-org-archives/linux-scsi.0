Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F81C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 20:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD52164DA3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 20:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhA0UGJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 15:06:09 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39422 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbhA0UEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 15:04:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RJtsir060468;
        Wed, 27 Jan 2021 20:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VCEr248HUpRM683fctK7JonGwtfgj1IzlmMVu+p2JhU=;
 b=zzZ1V/wzBfYo0RnNG0IParTyr/mrx1UPRkUariyp8tegZ71nQ8ij4eOorGmdTR6uLZ01
 H50LjlCAbXP/dsc3nfYEKmnkJJaqRsbTzQ4bUApGT7bQ3PlkNQHNEpTeuKwSbgU0Pq8L
 MdLMS1kVEyyNX0of1n9ON3Q9tYp40O1ZpLzWSCPnZnIbM9G5/kfniCLUKwoJFvtTmao1
 G+HTg5v3VA7NgoKilo2sPSk2FEYAg2HjfLllmeRr7KJxQ8g/hyWFbR6anRYEREkPpq9n
 uSc+546v6YgkVWOrDS6DxPF4/k1Zraj6N7LzhM6dauUf8FRT+p/aIdt1/X4jBfYCBBWY Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 3689aas6kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 20:03:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10RK0dkI125831;
        Wed, 27 Jan 2021 20:01:35 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by aserp3020.oracle.com with ESMTP id 368wq0pqrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 20:01:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YgnWZz4LYJFvhKTWTbO597S8eeYR2PCrM/utrBWxllkvEFWyE5HoR2DBGkuIJgJsibIinxnPzIzS24kobNl0E885aKzNHZI7hH75D/GiRBe8ADXO6jH9INimDTCN5HKTrcjYg/+Mv///aAhjBPhgPbZuEzc5ZH/E4Wyz0RYb5O55820/+pAU/muRDT8e1aFKrMqxqZUrqNZ2qJp6Y9i2T53pH2yBa3QsZToXscvnxyRYVmBlCucM+oFPp7ydUnJTY8kB8LtZ4wo6VEj5qBh7nWVAs4xWiudbeuWvZZ4Lzbf3jD5z+Wf6GfzyAPR0jkQZlg/D7LwFfv4xaEAvjSQjJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCEr248HUpRM683fctK7JonGwtfgj1IzlmMVu+p2JhU=;
 b=CREkHe6OS/ho0TOM2SDfb7FaNJmDbq3PK+o1tE4ZNaNsMWaEYJRL7HxwzPkFVXBL+5gUPGCkT/sUfstMwSgvyo4L43V6ttAuA2vW5sejVCBnbOsBEQWtFuBd4xdLTTAnjoI+l4r+d2TQNqwTiUHQjoqJM6RPwgYu7mnzRB5FIE+EkvhEdonXYThE9hJxfKQ8AQvsHQ/39lDEe1K7OlBl2boPmR62JyHOOPcxi92GyI6cy0SlmV+XMBU7ZOsZ1XNDZMtEYTc8LlLsXD22aBV5S/j/eeZFTb2nCFQDbjQg8FJ8Kdvf9igmSitN4Se4osqteCYBR4T+p9CGanWy4CwDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCEr248HUpRM683fctK7JonGwtfgj1IzlmMVu+p2JhU=;
 b=Hjxxa7Nwx0JenJLMC1jRCuz+ccR/khdgog+GeaXKj4Hn8iCtHTqw1j7b0QOwASTQsARIcbyqGbg4lsd+52XJocWG6aiCB8WAY1Sknp8VoJyeMvve6rK8ie5Gm4UJ+2MbdArX2dxoBLGp50sXqgx3hiLtgGI54fnjRcVJqnOA+Uo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 20:01:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3784.017; Wed, 27 Jan 2021
 20:01:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Simplify the calculation of variables
Thread-Topic: [PATCH] scsi: qla2xxx: Simplify the calculation of variables
Thread-Index: AQHW9AeX2TRd5K8GiUSNNvRxrb08UKo75leA
Date:   Wed, 27 Jan 2021 20:01:31 +0000
Message-ID: <FA227E6E-536F-4C00-9BB1-7346EBDA2F7A@oracle.com>
References: <1611650554-33019-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611650554-33019-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06b690d6-fb28-4887-2d20-08d8c2fe5823
x-ms-traffictypediagnostic: SN6PR10MB3022:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB302299D8C0B0A76565ADFFC1E6BB9@SN6PR10MB3022.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8nvtmrTt0XU6ThS10vTiUbQ5JKE3Lv6GvJOvuu94VQ92lmKjFMa8WGp6jpajRMh623bNykBZBA3qDWhuJ+OLWBiTwIXaOKW1r7/FjmVKG/n8nKy8Ffd1ZyIonJQJH/ZNdRP+Zc2axlA+E+ddgOCatM9SHL47hE9akLHrBL00/65kSjnJuoUhRMvu5S67+QkEuvYhE4FCwBAl4pm/CFn21up3Pks4IbgNMlJn6NzMTYVHiUWoObm3ZULMRn5YgiIGohPXimjfMm3h+chLpgKNpjHD/oexobCcOTW31EpSlGMRKQFCHzaVV5LaFhGXOXnceJ+VrmHbnxBrIrwpWYGgnqM5ZTT20NzMo5DpfTFSFZ7TyO980PTUIeobWlP9zm1iyF63Uwowiz9fq5Swd6fKuSoYdxePQJIYik17lDG6o7Pft/+5Q7Ok/tYUl+7WmvKdgk0J5iTCY00lf0hZ2MFSnInYYEFsA2Er3OhTVZhe3VQF9UFXHIDXpkUzej0otYHlWWl3VRYIEQ18oUUuMERbHaJl/FeepuaYOXKo4MqZ6AK/0DPhQX7WFHnnU1MMvGhBefJR1TTNHnm8t0PdLf8erQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39860400002)(5660300002)(4326008)(91956017)(8936002)(8676002)(76116006)(66476007)(4744005)(478600001)(2906002)(186003)(36756003)(66946007)(33656002)(316002)(6512007)(26005)(83380400001)(6486002)(53546011)(66446008)(54906003)(2616005)(6506007)(86362001)(6916009)(71200400001)(66556008)(64756008)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4T+dQmP5uuisiFBYL7m4bHK4goc+1vZAQ/L1E1philRFdj1714RNLv1CsrEb?=
 =?us-ascii?Q?OEsr2OmARek2L6rl3sdUE8HlTukhKFtwbLJSq0PIvcfA1gNsyDXpHJkPKVAz?=
 =?us-ascii?Q?35Iyx1/aB2mJW+tbYeqUZ0aMIDwSq1xYFVEuuYHRxGgN/KL7THZKIxMyothE?=
 =?us-ascii?Q?s51XTSHALSaejgkhwOxcCUZRbrz5rnJtJR6rQLNEzVGQaBSx0GVY5X3NaQ6p?=
 =?us-ascii?Q?VXHKZivC0q5PDrW7PYZ8dryMEgipFw7DWqRyF944lWMUlH/fFUJaJXqJAJ1x?=
 =?us-ascii?Q?RhHxcGIU1UZ+SQVcAu1+UYUnenqZrmPm98F6AXpqUjkxlSXtVudVpLL2YsQ+?=
 =?us-ascii?Q?DhdtGsoLFX8oiemzVLlPVTsfQhM9JofrnLyoR8ZUiJaniQtjOrtxM041ojmY?=
 =?us-ascii?Q?JM68gPyRrI+hRoKQIMSG+/wmD7osMcSq0/YQpU7wNSg0RfBDC1jURm2oSm+P?=
 =?us-ascii?Q?6FFmCyoXrveuxqQQFJnHZ2Pvf/jvFULlbdqZz3P9nUEGEpbwq6oBlur0h66k?=
 =?us-ascii?Q?9xMz7l/qGQj0JMS5B74TmE2anWq7XtJhu3jnlD0q7Uc8SwaJ15DY/6zr/DmP?=
 =?us-ascii?Q?c9guA84i2DkoJEJCCVdnWT92bQ0RnypUFmlvS9zbzfNCIAm4lCckEjQbvyM7?=
 =?us-ascii?Q?XMeDgQf1BnOs+dV9fIPtTHJlxTB1sz+nhHnG2N00QibCQAWxsN5/QYDKP1+7?=
 =?us-ascii?Q?gM6qtSre2ayw1R0IMohIcEZFNYrUL6vhOq59lKGE1JdxVjvjnTTWQq0GfYO0?=
 =?us-ascii?Q?vIiPoBnBNH+1yt1BlbYZTzA907CsO9LJwUsHnSNxJonNPegI7Q9PjX3ge5ES?=
 =?us-ascii?Q?aKKGxYuQ4PUIy7hv1XDaFyilGXjwWfwicg/5IkVsSwdZgnInIE5LV+1Miebd?=
 =?us-ascii?Q?MS1NY5nsXXoIWxlTDiQBh94GyGcvEppHkdYkqKnJjxihPvhNTe1Y+Ew7fAXM?=
 =?us-ascii?Q?TMDXlRAfz84lKuyaCXDfHiGbh/jC1zkKF+bHACQ10A81sMQX+kGt05FESMj5?=
 =?us-ascii?Q?PbUYGAaXSZaq7br7TlLt5oukKhq/rLSE9IYr/AI/dfpVnGuBimhepokmALO2?=
 =?us-ascii?Q?elAk73Fd8N05s3B4X7sqR2R/Cu/lzg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B310DA6B45DDB4DA9BC4379FCE09972@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b690d6-fb28-4887-2d20-08d8c2fe5823
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 20:01:31.6504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OrxwIYtSrdgcPaPDlGNeJt6wN4NmP83QDxXejgitQT/3RRo90ohCtpeSnK6MDtVLEctsZ9a9lxr6oJV/AsPYUhoXAbECqT6BKsWBRJshULk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270100
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9877 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270099
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jan 26, 2021, at 2:42 AM, Jiapeng Zhong <abaci-bugfix@linux.alibaba.co=
m> wrote:
>=20
> Fix the following coccicheck warnings:
>=20
> ./drivers/scsi/qla2xxx/qla_nvme.c:288:24-26: WARNING !A || A && B is
> equivalent to !A || B.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index eab559b..38196b2 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -285,7 +285,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port =
*lport,
> 	srb_t           *sp;
>=20
>=20
> -	if (!fcport || (fcport && fcport->deleted))
> +	if (!fcport || fcport->deleted)
> 		return rval;
>=20
> 	vha =3D fcport->vha;
> --=20
> 1.8.3.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

