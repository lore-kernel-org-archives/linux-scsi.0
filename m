Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2280EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiCITOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiCITOl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:14:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3056CF543F
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:13:41 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229J68Kd030917;
        Wed, 9 Mar 2022 19:13:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/3sn7PrThUPeU3fJnNQbIefpyzXyIYcr7yIry1t41d0=;
 b=BtdRdQNLJS6uwVMJVoTBtXYSsZh+n32wmY4yLjREl/sBWqTJ3/x7etCcCBJYa2KOg96v
 WTbT8AS/AHP1ELrREkgzJ912jarLkVwouuyjGsTD6Y/62j8u8Vu7yJMS74R8N0785BEz
 b1FXXQsArjqTGhYZUdCTaodJVuRCfKtatuAFUjeQC3s8BKp21YbckGQ0PZ+LL2yDF5ya
 wg2tcrwRCLm9iejDymhy/Jo8bFcuSs6M+lGmbyPsiTnyF94vWQN6/5JVY8NkRssQBn39
 qIjxI8tEIIy4a1vXiuiRPL4u3TGhpH+sPOozfHqxGX3BhrZBFh41NPi3gqYD1OZY27Ba Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyratp6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:13:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229J1guV006260;
        Wed, 9 Mar 2022 19:13:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3030.oracle.com with ESMTP id 3ekwwd00p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:13:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VspaVSl1AqsBUPBbF7HhdBuBAqkXjeHYNK8ObBIkNvY8ImRoFuoe4oTwQrlytC16LrzqgCabcVEu3IIDhUSWzS/dj2jWJOlWIBjyGJx3mK8jTmrorkMooH9GvyprgscCAXadQiV6Ulof8lrozgfG6EXaRXWl5SdXksrw6IcFsX30FBwsLXdAN3JX1Sjhf3RlbOC1i7TpVta6n4yWbnTWpLxwc+j+4yCOpZpNPuSzJ28shd3U6bEQ1hf8OaMReBcKA0qroZpkZ/56eZvUwEvTf4WAlyAz1mUOVh9kpK5u47OFfafxbvgC4C4Us/x/dVGoT6PNlqwNE58gBfqsKF5HpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3sn7PrThUPeU3fJnNQbIefpyzXyIYcr7yIry1t41d0=;
 b=TSOXHi8et9ME5mNck5PGCbu0mckQoZ5mN0VCQ+2lHEdfx53mQ9KDE8VV/cPc1vN/HE7yhitJ63wDjKya+LBOcmHc66E+lVZy0gxljDWuONaKNWowJv5AJFG/uoUjSUVqR+D1qUrRsdP+50w5afWLCuG+k7+Lok9U5xuhddUnsbjtBKNsfaDR9aTAdTXK0qp+YFHwfz/2EPKzlx2WeTMtrNtlsEXiYgXAL8D4HhOra5gXhPGHTOzYgugevLhIZTNVzA1yeMoz9ZHgmkXesiPW/ZRy6J7E2GXzxz/34w69jHf8hg/glEtL0g5GnKnq5uRpfWWEwXAmr4v9DF56xOQWmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3sn7PrThUPeU3fJnNQbIefpyzXyIYcr7yIry1t41d0=;
 b=hGpH8q9MYd87U6ckX/vArscu/JOSwT9BHlb5+RY92W9UZFih1z2bWq6x95BI8GVoAmWDdfxfyKdZviDMHHD43P6ECqS4adS0AoiyxGkeBfdT92pn0TD5T0YL5MgVvOUpVwGvStRUnvesXLTp+Sh3YDO7wuGHbEX99gwCDmGlZlI=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB2581.namprd10.prod.outlook.com (2603:10b6:a02:b9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 19:13:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:13:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 13/13] qla2xxx: Update version to 10.02.07.400-k
Thread-Topic: [PATCH 13/13] qla2xxx: Update version to 10.02.07.400-k
Thread-Index: AQHYMsWFr2vcYc1Z+02rfqmxNpeAnay3bgCA
Date:   Wed, 9 Mar 2022 19:13:36 +0000
Message-ID: <90DF5A41-68C3-4624-8C24-E8E95DAC526E@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-14-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-14-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80e5624f-5344-4562-8d7d-08da0200e92b
x-ms-traffictypediagnostic: BYAPR10MB2581:EE_
x-microsoft-antispam-prvs: <BYAPR10MB25812D42ADEB429A3457846DE60A9@BYAPR10MB2581.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 62vbYzwyNXaiGE2NRygNyXheqr5ZxY7w390Cv2uDfBGc1fLGz2J6CwO1KgJX/Ef+kkJi1XjThbZ3F+X8B4wFZVvnygfc82zsJi8c51ET0FD2BAVnKdx/dBb963WzXCoc59ESxIaZk77m2C80GlfEH/PjC3e6xTT8WhifnnJ2NO3xASo0DC6Mu+soKnuzt7JPjr+PUpbbrRYwX+gJoAWM3QGoLy7+MQdIfAJHayjhanh3vOs6jbPZt/FMYEA8kulYfecTUJjzx+A5V+UsKE6SqhtNuEIfqZnYznws8oLSuADNIkUJBntBbtuxbZB79kWxHUzzWWO9C0hWh2qGLyYwHnnuCsnxYvOvtvxM0s47DQ9fc1hyzzTEgfTozsJTV+MCeg7SE19HAlgOjChOofmws4QZ95oFrgV7shxu7WgWJBAbhgqe5jXjc21gr4wg5GTYjnATDSXNeD0ZNfTYPR5ogplqdcQzqaX8JD/YiEWYmLv5prO2fIrE3UEwYwFhK0tPyVAY+aauYydms2Dnhh+JOCmGfrV7tcjutjo2ymMsEHyfv+hgPMaYfKgXC1j9q+dE5Ne3gKAAX0dVy2/Fw41Ethi42a16oxESTw4FGrxOA/oYDtr9DMHDzg/L02OML5zcm/rxrXE6iHa+utNnFU8cSXIKNkDYq/eBkyqrMz9Yr1en4BiZAKmvaWohgks0fVP8IxyhwvpSvjDlOHRzypZxVSIO70ir7hs0tCTmiP9YUESi8X0d78/5P/cGLA+Nmtpq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(54906003)(86362001)(38070700005)(316002)(122000001)(91956017)(66476007)(66556008)(76116006)(66946007)(66446008)(71200400001)(6486002)(4326008)(508600001)(8676002)(36756003)(64756008)(8936002)(6512007)(2906002)(5660300002)(44832011)(4744005)(53546011)(83380400001)(38100700002)(2616005)(33656002)(6506007)(186003)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MBWtLOKIJs7qBbj61+L4rmOy49UX9TCl+V2xrgRaprIxw1kmOaFlC9Rx9OvY?=
 =?us-ascii?Q?SiREac9EPkP5cH0kM4cuhGnSxunXo6XJZJiccMfTkPIivCYaYt8CJ4acnMP9?=
 =?us-ascii?Q?YkrB1yeVdEOO1J+mPJMg0M3TFz1Aq7v9I+YXs8KQz4sUTPgziEdjtdyq04yA?=
 =?us-ascii?Q?QopwqWdVb1eimgAHAkw/dBzrtGhyi+o5G9fu2hhp2jgjlrV7YT/Ilys9riNa?=
 =?us-ascii?Q?lJCqrKhYQryi5I958EFEey8QkCCtIBC9pW5HurhFCoUNxD/s/+JeA0agJxK0?=
 =?us-ascii?Q?6qh0BivK+G9Dgb+hXluUK6ZwWkG7r2jxMl24vbknE//10Pl9xLrQJBCZhndo?=
 =?us-ascii?Q?YbqYhDoqtXe5G1fnPAsEUKcZRcehA9jY1D4vvt9uR3megCXB5lT5L8RAkTAt?=
 =?us-ascii?Q?EOkErqbgdTlDRlF7WCcAhW6CUhqs3u7pYxqEBnvyYFudmXY41RYfc8QTTZRu?=
 =?us-ascii?Q?UwmuD6UYwGhT5w+P0jR9/m0hsOJH2xbQENjBEn4xzLOTkQ9UexjLbnSJBqHZ?=
 =?us-ascii?Q?nGId1JePny2Yyk7zpVyoGuAtb2zrXUVOS1iGk84Xzi1UBVgUIwAru8GaciSw?=
 =?us-ascii?Q?h7EnhMQHYF5yxjFA68l+oEgnQfoxjTmj0I8oDa5LNkQTeySfYeaq4KPw4X1m?=
 =?us-ascii?Q?jY+kPv7Kicegpm4OEd+V5cV7HjMdfl3GNobf+VT4NbCMdBk3TkX6NW4Jk505?=
 =?us-ascii?Q?MACbRPNmQsyry58cSVLezFimkWsmDk/XMSs27EyinRoQIbb8/7htJ1uwJ5ho?=
 =?us-ascii?Q?gl9VBlK0Q1jRicsx8E8enewADyVPSzk4PNJf4mI36xqZ6ldvdKkyqqiFAbaB?=
 =?us-ascii?Q?XFV1BidHuTxf67jtTpIzHIJRJ0HpKK5rx6JfkCrBdSBXfZskS3DEw2VpzbdD?=
 =?us-ascii?Q?S0gbamITfdvxKK0STIgb9lRcMbj6BV8M0cQd2VHfl/Nu8BZJ2LX2HiPhUOYA?=
 =?us-ascii?Q?ixDF74z+qytqJpcqiWdS+Q2bZyqDGclsCKjLakNZQx72qO2OARJmQGoAq92+?=
 =?us-ascii?Q?jLbTfBR86pYQ6XMF6pyDucTXRUuukxX4lTBfLRaO0D+7scsp86kEeU+zrON7?=
 =?us-ascii?Q?hlsjCWlcKVgnupAJivH8WWB9WDs0LdCEpFHCI10qQvMg8RbcTHyrJ2P924cO?=
 =?us-ascii?Q?XclRehSWtjyNmLB940E3J9az+/7m8CatNyhYz8h9VyP1QRYuLhyVaNQeBo8R?=
 =?us-ascii?Q?vEqnr9+CxC4th2CKxV7fh2zRRvlST/Sr+IFlUHiO9FNBMKoVT8O/4Gq0zGWE?=
 =?us-ascii?Q?3+8wjVgwv6yFWFku/0afGnizWGjxrV1aszMryfuF7/+o37XpgIk0irlgwQcp?=
 =?us-ascii?Q?sdIyljEtSTQOpo+/i6EQ9cPgW/75GFpFFPl3I3AEHnob2lNm+feKNqNWSboV?=
 =?us-ascii?Q?JAe1LVZHgf9uyGhjKTcaoWrEfXZC3X4U0puB72U1xdF40l56FW8+prHoBbsu?=
 =?us-ascii?Q?oXflYnJhgXZQnuMriPNMwr5Vd6mnG9n2fiT1CoLnMfK6r+EJbqOfJA61ndpL?=
 =?us-ascii?Q?0/b3qGYonpC6vfE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <251755CE4F5B3C4A9F5CC97888BB1570@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e5624f-5344-4562-8d7d-08da0200e92b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:13:36.0766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2uHrariQWLCceIBfK9k74HM3zOyXzthhour4L6lRyARGPsLP3Q0/QNJFjCD8Zrg4csy3lFwcS9Llg2UO0TU/50JBTIAuoUn7eJNz+DuJUcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2581
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090103
X-Proofpoint-GUID: 0YBI1XYvJvPj5Afg23bbuW2SKJWoiaWg
X-Proofpoint-ORIG-GUID: 0YBI1XYvJvPj5Afg23bbuW2SKJWoiaWg
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_version.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/ql=
a_version.h
> index 913d454f4949..b09d7d2080c0 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
> /*
>  * Driver version
>  */
> -#define QLA2XXX_VERSION      "10.02.07.300-k"
> +#define QLA2XXX_VERSION      "10.02.07.400-k"
>=20
> #define QLA_DRIVER_MAJOR_VER	10
> #define QLA_DRIVER_MINOR_VER	2
> #define QLA_DRIVER_PATCH_VER	7
> -#define QLA_DRIVER_BETA_VER	300
> +#define QLA_DRIVER_BETA_VER	400
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

