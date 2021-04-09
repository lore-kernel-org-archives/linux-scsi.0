Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96560C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 14:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F29660FF1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 14:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhDIOQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:16:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44170 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbhDIOQ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 10:16:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139EFAJ4181296;
        Fri, 9 Apr 2021 14:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WOOcse+VncgP3oIsIvjBsdQAACznZ0Uv9o6xaFoLrpU=;
 b=TpjdY1eP8tfJQnwH64ZW4zx0oj+EyJWkzmacUzh8jm/FOh3g9d+0oAvnGetC/KfwAhLS
 CJQ8s9F4aFNPemhZTonO4EPZiGEgym6dNw3b2KFhQxJcRxkE+MacEmD1DawutnsVDqcK
 QFxrrE+mEy5cvxnw9tOWo5F7uWhexlnZnN3WVzExgr+XnJdn1T91FdjHLV+p9s3Vt8gK
 3AHrpuvQqSzySq+8bdRqc/+VfGR4pV3pCiPpA+7kFbHP3zvAJkk7/9oWBEvQCsHObsrz
 +dL0md1GhLyjRMZmLZUzM6vf0p1o/cxZZi6KxuOd4CJgoVYBfUvKXxLyKyOgO9/mjWi8 bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37rvaw9htb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 14:15:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139EAGrT149565;
        Fri, 9 Apr 2021 14:15:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by aserp3030.oracle.com with ESMTP id 37rvbhnmsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 14:15:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kv99U8oheY94myPdkq0nek6VfaimHeUAU9GBmIBQWYx3E6wbYcSLVolHm+8RJyP57RH9umFduifueYyTVltQyIDaZnb1m6mebJYPWpfIXR+9nJE8QY/n9OZZiPYhX/gd9D9MVWWc5VAlEo1YuzqjuxJfR2cuJsTf2oZ1qeWMxehFfhBps5cEfNBZUMA5O4gZh0vKQv54GOtiVIj7v9nL0js8SNKiak+LtQU+pB3ABFMZzh74q0a2wsDNxY5jnqs3JUVFrKdTcRbSHEzkb8pGcc0r0rx2fMH8jXRtRWzLnrIgnmx0CsfPU2qwYRF2gblPiMXeln9hBaKfnOuqizBj9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOOcse+VncgP3oIsIvjBsdQAACznZ0Uv9o6xaFoLrpU=;
 b=KcdGcYJ58k2hh1vxg/dF54XcytODV7F226XfHhp1BAhnZ+UPwGVsKYAL6Nih0nTKzwi9TJq1H52Je//T86QUVmOivd96iJ5+QPCeFAF5aTpB2Yjgzl5+I1fEUy6TzwJgdJJkeKCGRk1v2DS2PrAioGVEtEmqaMRKvFpUCHExpyaxZhQwTxxU2kVkBl7yuPZZyxM4+tcKQTqN2dbXyF7znToJ/+0WXuMBjxW6EB4ssau6rng8rKiDgt+KGnHw4ksRpDkzWfhjrdw1q+uDpMxHJv46C6EtXNilfjLYbVqu20Zdgtk4amPRjUjlPd6q6B6ldgiPwUs889sRyDW53s+Thg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOOcse+VncgP3oIsIvjBsdQAACznZ0Uv9o6xaFoLrpU=;
 b=I5hEBthgtjcHZ1hw+xl57QeZJxNySsKjjhy+P21kXnLlNxKy0uoSOlnVdbxeDI5YEaAQCOVQMjK2u4OaWQITHu5E3bgybcr4SVYXMZCDQd6D/I3EuCzxo4Z7tMdkeAvGH4X+VrDv0Id4UVdlhevYvpKPDZjDwmKHZfKRM9zU0hY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2912.namprd10.prod.outlook.com (2603:10b6:805:d2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 14:15:56 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 14:15:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Qiheng Lin <linqiheng@huawei.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: qla2xxx: remove unneeded if-null-free check
Thread-Topic: [PATCH -next] scsi: qla2xxx: remove unneeded if-null-free check
Thread-Index: AQHXLTlBwWVQCI/QakK/1FfnyX1QRKqsO0EA
Date:   Fri, 9 Apr 2021 14:15:55 +0000
Message-ID: <A67C5FAE-D566-4704-8A82-216CAC369E2D@oracle.com>
References: <20210409120925.7122-1-linqiheng@huawei.com>
In-Reply-To: <20210409120925.7122-1-linqiheng@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 081cf3d0-f7f4-4e7f-8893-08d8fb61fd8e
x-ms-traffictypediagnostic: SN6PR10MB2912:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB29123FED26644D8C41B81274E6739@SN6PR10MB2912.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CwhqnUXvhYyzUAHqsUjKbj+TIrTUvtdVBqpLGw3MzxBm3y5tPk3J5EuUkDdZV8bXbnt2bzZ2o71R6Jj7K0XrhtDks1S8uMLAIqcqzGUl7lbhqz9Mnj9ohO3NoLGdlXW/UrH1jPR+Ptyo4lvo4flDTHuFfI+zmHMMu6bWj0sZgAafsLWrVZ5RFJ7qInOw+OxYmS8dsm7iM49dspzxgWjxbN/2iGlgQtuS5vgAANHPL4I9gaBK/56W+1h0e72A3tN89pZxZ7sTzt9fZX/9b2VlMaegVnAgjewShW8q3yK1DdZ13D9Snr05DskUg8jwLnkyHXXnepsRkBVAsaBgkdI9dWhRwLIfbA45AgoXigqhcslirB1iKf/UZeAUf2Hg2fCdHVxAiVzOKUcuoMkUnzoea3j2X9ooyLVS+8m/+tw1IkK2mDGoizVdTD/k1OFVQdk1BVwdUoC84TuLkPrc5hG0M340I2aj0kmJGq30YjndOJiJCQxCWDZDTOtNDGBQETiqV+rWvDWLTUgRMxD2sMEv/WoAWeeMtcsDmUVy7gk1wtFp60DzSMZ1V4D8O4NLdfJj5C47inrPtPE9f2F+z33GtKQzBONSw6sm7NcnKQicprKMh5B6woDxdWEYLipE1YJOSKNtVqbG8BKETxnHPVKAuADZhcCJjb2KC4oV0T9tZDd27hJR/EfcQoi1eVecfQtJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(26005)(478600001)(186003)(33656002)(6486002)(83380400001)(36756003)(4326008)(6512007)(8936002)(8676002)(6916009)(38100700001)(44832011)(66476007)(64756008)(66556008)(66446008)(2616005)(6506007)(5660300002)(76116006)(66946007)(316002)(71200400001)(53546011)(54906003)(86362001)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YnSsQLs1MZqnLm8YrLevR+rf2iL/g+nZsaC9RBvZznnOT9Ig8rRyfcxOUZ1R?=
 =?us-ascii?Q?AAK6mDsyawAAA3pA2x1BaiT3BhQFhA4A/TTWYutAuglD2uz8zKOWvILyiNCw?=
 =?us-ascii?Q?zErxnIN3SSQLXpG76wzj5nON8ZtEg9Y2bLBTJgGY90CCTeKzEHm5m7YFlm5w?=
 =?us-ascii?Q?hjY7LFjncuSmhlsYUYN1z0mYD99sEEYb1veXc9s9W8rzzOmmclqNd6nY7gfo?=
 =?us-ascii?Q?KWK23IMBCbOap5rtZTV2tejCuZ6cjYPTjDm2jp5oJ4wYpN9wiDTIZY+ZBagQ?=
 =?us-ascii?Q?Rdp97764mETgVx8LpGk/NR4DdVTQDM0BjAHIgZjdxn9LVu8/KYW8g+Cq4b74?=
 =?us-ascii?Q?30Xykk1Ns7gvDne3chvOnkj+D+F8xG3FoAtpwE6amAZBap6GUKHWLmzGaMB2?=
 =?us-ascii?Q?N9TVP+uybBcsEh2odeh6xhP8W04bkqBE/eQbtr2QwGa+06US1idh7hiPhboM?=
 =?us-ascii?Q?oTSSUMU6+laM30v4dU8EsGrdgm3RqYQLAK59caqX8qUeiObMwNMHiaFNsQU/?=
 =?us-ascii?Q?BPRoE7Rn9IJPmQM23lStuyALOK8DPgtkFK1uOWsAeUfyq40iP0qAfIq6iDDb?=
 =?us-ascii?Q?pCdk14NquGMwyJ3bQOq8/ZrNZO1/HfZ2leWagEP3om4sz+dD/ry3ODSdXr2S?=
 =?us-ascii?Q?61AdUJpNBto3mhcHwnfholsc4mCnyDBppncn5Yq42aEhx78+490bunHmqE6X?=
 =?us-ascii?Q?SuMkERHH/JbZ+OLo3bzHM3GtIU9Csn2M7zTa/XD/XbRTWkprqkvSsxwOooBR?=
 =?us-ascii?Q?aOR6fFryBLxX37AxfLBCrx0ulJNu2g72+3zVaxKzpTGHN+jqJJaNsFHg2PHw?=
 =?us-ascii?Q?O2HG6uDkDx9G73UjUMer/WdpLpz0kEBPFn/QFSi+rHk4ZgyKFWVJAqcOfROX?=
 =?us-ascii?Q?JIN9SFpEuiLJQV1GeJNuDXVt8oB8Mep/+5RXsgth1mdGT7LbIYN+7aRPml9b?=
 =?us-ascii?Q?L/jo1+5FlUO7YXmTYOjJyQY0rvhe4QBIG0BWaZudWLfVD75woCezj7cMKjID?=
 =?us-ascii?Q?cx+/BrwMh3OnUWTkix0Vz1lvMct4cqAs2y1tJg0q1/azNw8ab2ka8ZloYgR/?=
 =?us-ascii?Q?mp8/+3IGWovEjDzH5TM+myEqFIraYS3UDn8BzpEl/7xzTdw5iAwZ+bA8N4Cc?=
 =?us-ascii?Q?zYRmuK5W6PiRFmdAkR6u1AiqhkIs1PLyI1sM9CekwFPp00XGbYFcl0Ka0y10?=
 =?us-ascii?Q?8UFUeeeFgfwskNCye/87y2MV4IkelJcWZFqlZFtbdNzdb0uPPI3fGY1kN6kP?=
 =?us-ascii?Q?Z7i57tm/gjgpEz45D2rAZX0z+jOsQFiA8TYnmgIO1Gy4O6bYOO9gKcJ+/fL9?=
 =?us-ascii?Q?8YXfdN4E3cPgIWIrOKL/SFOAKDHMc0rG7y5qsaH3fKbOEw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC535D355BF2BC43A89717F4BC49A3C5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 081cf3d0-f7f4-4e7f-8893-08d8fb61fd8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 14:15:55.6271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ejVq+g8TmVU5JtPSjk76etF+a+vh0ZbvQCScQOab2ReD3BGUU4A75+mdjh7hmaJeFPgQ3TDjJiwkNoE1zaETWRzM6HCaITnEXLHWpFItQvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2912
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090106
X-Proofpoint-ORIG-GUID: Huj77QtTUe2VUtdPni5jXcwTvjpPwWWc
X-Proofpoint-GUID: Huj77QtTUe2VUtdPni5jXcwTvjpPwWWc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104090107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 9, 2021, at 7:09 AM, Qiheng Lin <linqiheng@huawei.com> wrote:
>=20
> Eliminate the following coccicheck warning:
>=20
> drivers/scsi/qla2xxx/qla_os.c:4622:2-7:
> WARNING: NULL check before some freeing functions is not needed.
> drivers/scsi/qla2xxx/qla_os.c:4637:3-8:
> WARNING: NULL check before some freeing functions is not needed.
>=20
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 12959e3874cb..d74c32f84ef5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4618,8 +4618,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
> 		dma_free_coherent(&ha->pdev->dev,
> 		    EFT_SIZE, ha->eft, ha->eft_dma);
>=20
> -	if (ha->fw_dump)
> -		vfree(ha->fw_dump);
> +	vfree(ha->fw_dump);
>=20
> 	ha->fce =3D NULL;
> 	ha->fce_dma =3D 0;
> @@ -4633,8 +4632,7 @@ qla2x00_free_fw_dump(struct qla_hw_data *ha)
> 	ha->fw_dump_len =3D 0;
>=20
> 	for (j =3D 0; j < 2; j++, fwdt++) {
> -		if (fwdt->template)
> -			vfree(fwdt->template);
> +		vfree(fwdt->template);
> 		fwdt->template =3D NULL;
> 		fwdt->length =3D 0;
> 	}
> --=20
> 2.31.1
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

