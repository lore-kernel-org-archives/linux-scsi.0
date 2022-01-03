Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168B0C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Jan 2022 00:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiACAsu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jan 2022 19:48:50 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19658 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230182AbiACAsu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jan 2022 19:48:50 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 202994F9000474;
        Mon, 3 Jan 2022 00:48:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=++qXL9wPdOKYvPrP1yc3gDkGD98LdoF/+KkrZjyM6RQ=;
 b=bxLbQYKYbsaUFcXEwT+/mg5DZuwpDCAhwhJVDNhxcyhb9aCutdL4ytDvtGSb0UTKKc3g
 YsPSV37Xm28baCCJP3OEZUYikuAiHXAY62MHQSJmIk/8dr5fiwRmRPlu+U5wZAY9FUY7
 On4C8tNpSMFsqQevz4DIEV5l+Rk2aAwAfB40nYxLaTXkZLg4YavPreTFa7obpDq5xR5W
 5gpKV8nFN+JA5ahtSa5A4Pr28fdTbRWhFDkbvCeS+WrKaSHYd/WIn22Rj5dWRB2fnZ8L
 NqYSUtdZXR6+nR0EHNTIvbfLcyCu1j4bjN8rjr3HOsh0WecTwmgwMR2CiRCgZohqM7vW nA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daejshq0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:48:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2030fVqu190288;
        Mon, 3 Jan 2022 00:48:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by aserp3020.oracle.com with ESMTP id 3daes1npyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 00:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDA15ezNUWZktrgyIiBm7nH0dfFAeJ4ayCNMDPkvLALxnf7Qp6QkqMbai4t3tnr8lh4V+0uRvogfpYPuRZKKor5eOl1u/wwJiFzfD1wSYnMk9vWOFaNE9n7XM76fVX4HFf0GyuGg+cCt0bvPkk5hRJ7f3N50fyY8Mdg3kbcD2wWt5j7AXe2Ms229aY85/p+bg6S/GuxjoPqcKG34LW8oJA3jnotm5l/fkoHpI9o2Qhf7l/kChCNwuXZMrqleG/8jYM9+3+XdDd+/xZGMmC0lVJOmT1WmrzD3xoPiSk0tSw+49IZKVr0NWSq3uK9XqzpePO059wZWK+i/DaucilMh+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++qXL9wPdOKYvPrP1yc3gDkGD98LdoF/+KkrZjyM6RQ=;
 b=MrIFzYUWYnNCT0vu4znQ7ax+lpAEZ4o7kNdyb5GS9AR0MEnSRv005dI/7z+b5uIBapbB29+0vPSBpIPPIA95eisUyftVb67yB7Zu5XXuXaqKYKR0Nq8y2s6HsMTN9/NjPnbVqZCbLPLn2HEG+02RNrgSpq2LeRtkoRZYSjo7+5GLdXWO0ksV7q4WEJ34/0qyqwvYy3+QhmqevXvfrj61bcIWfaaGPLOhZzW9dAgZTcD01v36Eqo3UjlC/T/djD6VVI8qr3xlczMSmVcUgS9n9NuJvsGZ6M18aizkFS5eHR67shoyWw6djcXVvmBMRKbro358MstELHKsRFTt4gVdJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++qXL9wPdOKYvPrP1yc3gDkGD98LdoF/+KkrZjyM6RQ=;
 b=e+E8d8sNFYiCzdsVFx/Fia+fUAgIpXqnzWm7fVBmPLJqhciXvZbeZKTknXRYFGoriCwu8+1mfD5mTBh5z3j5T7+8XHkrxUPclfa0FB9XdPH/COEzqzpV3E+Orhe20RdFXU1us+XOGzJlj8FCm3WTnyl5FcrB3d2P6ZCz6/BT/Ac=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB5710.namprd10.prod.outlook.com (2603:10b6:806:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 00:48:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 00:48:45 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 13/16] qla2xxx: Fix T10 PI tag escape and IP guard options
 for 28XX adapters
Thread-Topic: [PATCH 13/16] qla2xxx: Fix T10 PI tag escape and IP guard
 options for 28XX adapters
Thread-Index: AQHX+JUJOJu4FwC3F0SZJaHS24T4vaxQhiiA
Date:   Mon, 3 Jan 2022 00:48:45 +0000
Message-ID: <50163901-9E03-407C-B85C-F594134C5B25@oracle.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-14-njavali@marvell.com>
In-Reply-To: <20211224070712.17905-14-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7655d514-9036-42a3-268d-08d9ce52cc3c
x-ms-traffictypediagnostic: SA1PR10MB5710:EE_
x-microsoft-antispam-prvs: <SA1PR10MB57106A38F8FC5599588AFB16E6499@SA1PR10MB5710.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nADJ8HpUGHEreByGV7idQwnpiFu6oG2HpF1AIw1xBNk/ZvnytMPWjFV/sPH4UyoX2pMlMvgMROgEvYE18CjWkfBuc296QUQ1bSZau0unnqtoZVh60WblPSy7N7V67+Q6nEeW5gT4UBKFWR+XC7SfZQQ2/9BM7hCP6QjxXuU30yKvTBMOvzQTwSF/4NzwNGcNZLoiI2irVum8ezdzZzlHzoVHE4D35LOnpybuEPh5JmyBHdrSh62CWuIIoLtnxqtZ3JoZlTdPTw9iU6nDsvXf1gg1XH1N6smHTM3ua9Dg45h3q+9qcUMP1cNUBc+yuffIwCvh5hfwh7Kbe3V7ni4dXlFS6RFmnSWw2MZyN2WqaP94rsoTp2msy+nWksSnVgoysu0jOw3oiz9D5o/8d8+i+v30Jl7QuPjZJbuO9hOxqWxf3O2uXmrmkM5y4DkR9RA9aPPD1sJmR1t+LgtirZel3f2s2xlvvui5CKKVAKNtGL6RKR2aHfoX4+iI7X2e2duf0CclfyB7BBMEFpG6IIXWYWgE51jJY0MEcivviaaJHsWst8Ekxk38hoovXi+oPdX1T6aITKxLMhbKISma5ynWEBraJtPGNYSeB1DtbNv+wyLMx4Y4g80R03mqf8x8o0HyeD8K7k1fQ3ti97WCPWzyDrnD2zhdOCAos5O8MqeOMcUBu2GCO6vKyGDW725l9D7CANazEQuAM/qvw2qR9UaQJKF+gvVyS9vxZNMV7dEG8R0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(71200400001)(122000001)(64756008)(186003)(66476007)(86362001)(8676002)(26005)(2616005)(38070700005)(6512007)(83380400001)(316002)(53546011)(6916009)(6506007)(66946007)(66446008)(76116006)(36756003)(44832011)(8936002)(2906002)(4326008)(6486002)(508600001)(66556008)(5660300002)(91956017)(54906003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sH5pVeDDat0rJPoIzXDcRguqjsPZp2nqrmXrJIMR5NK4FXrpdIa2CI5jsSML?=
 =?us-ascii?Q?GDbQXwmz29rVgojhGeMV+8oAR5R5V0P1yO0HJ9hxJvzILFlMy6PkM/jfiZnS?=
 =?us-ascii?Q?evRJxhXHtLclNLw6GFkcTRdhnAFDJ2ZQDqhcRaq+jT+xK3kYZ5hkhXn8N5tJ?=
 =?us-ascii?Q?qtZoYZZ9LqxP1DNh7rpngmxzvo1j2MuTuqL3stxKlboMB66632DhPxSaDEJP?=
 =?us-ascii?Q?N33/aLRLdVfOlGPuw/zVyN1q5fuEYbvHBjfE/nlFFXA7/MJaKFZ7DPTT71Oo?=
 =?us-ascii?Q?ZpgF3IywSmcftRzef9L7IQynj/M+VJEBUdCc37RdxRa/qGptTt0NIUZiEm8J?=
 =?us-ascii?Q?yZ9wa88AhPsAJrRidihsl9y0RbXoBbkRMar5gWntMUrGhwLpdkDEvE0QJj14?=
 =?us-ascii?Q?OtJQkfgDYinv2h7PSV0wZYntRwnRLTW6u20Y5CwDUPsjBQ5ejOf52UYGvBt6?=
 =?us-ascii?Q?/qSA0SXj9mZ8R2zro+M9H645HYqru138Zax3SHUrLFQ8o2xhis+vogYC7ckv?=
 =?us-ascii?Q?0UHqKxPoZk2clGN0MNqm4TnZ4juws/ZB7Js3Nuvxe+WLJ+R8eR9ladalZ6d1?=
 =?us-ascii?Q?OIkkyBDhhs4eiNsPGRg6dT2pWHjvFEqKADvqCsYeHv8n76+LwlGgDhro3ve9?=
 =?us-ascii?Q?rmkvd29KSS8KayKQ6pI6qbIqArTZFT2ezxgjdUhWctRqufJVXWThdoxFdADW?=
 =?us-ascii?Q?ym7ZeqMTVbGrDlLNxpR5NtfxFkuPUa8gZMBoAQmoFp5QbkeoHHkT8RvbbaKw?=
 =?us-ascii?Q?So+SJhg3Q1qBb0Qrpge0ZzIQFxBC/+W3BzX4XsruWcsaCF5HgRmovWPKTxgn?=
 =?us-ascii?Q?bwApjD5S05IPhMmW/77bcebwWBAS8USX1wtVIdiKRebhJJZdj68KiDtWNCz5?=
 =?us-ascii?Q?WvojhZz/AxidfBxmV1Sgx6DDLVvV8obSqUec6hRCrn8AIPIwBrgR1JTciqha?=
 =?us-ascii?Q?4WM1D5EudZf34rW9f4Ezsb6fVE81dB+ESe+AMusCkpg/QeZnVIv5kWSP/pol?=
 =?us-ascii?Q?f1aqmnHw59ulNw+4Th4YgMX1P1oqFpLI16P1webQKTqzKezt8irky+PDDSuF?=
 =?us-ascii?Q?VBM+ylSjcIhvx4xJdV6zpTNTa/uzl45sWwRHTdIlnpoR74uLeS00lZBMLhHz?=
 =?us-ascii?Q?byll7WKZo15VZXQQYsOXEghPmHuIKFpuxqVDRqsw5vZ6YbtiriPZVuDA2Xwb?=
 =?us-ascii?Q?1VDQkRL5aQFfVR9K8PdBhJALp0lIvX/gs+bFfYwC0O+AA+znY0Ph+U72cpTV?=
 =?us-ascii?Q?I9x9A6ZoqzVl7EiWECY9vpQ0NuYKZ8jY2qp/K6+ulzxQVGcqoASS6VvdMnmy?=
 =?us-ascii?Q?H8K7vGEQ4fZumnMD54FnKJBv8K7nLkBSRr5pERU/Yh4/E1Nq62WQMr65kW+4?=
 =?us-ascii?Q?5ECT3QiiSBeph3e0FiyfJkm2Fy0yJgrRVuUQTjh4omZcWrcwRSNoJ+DR5r94?=
 =?us-ascii?Q?X4oYF1CBLMxNExGIe03+N20XNZVLUT7XXia5HtVkFW91/p00O++5XYYd2nH0?=
 =?us-ascii?Q?ZSPXjEbjlrJJNYNdEN45rArM94kbC7rRv3i8cVTqvUhpkMT43xyyIKtCBeQJ?=
 =?us-ascii?Q?hE0cBqtrZnKzq8qTxLikvCkWP2T3ZyPMP+wF8Hn9S4BbHdy5e6VuM+95ZXbM?=
 =?us-ascii?Q?fd0UYXZ1pEcfux4QX7LYWHIGJ9Nq3tnc4NTJFMpkjXLZfKZ3agnh0LC9Pxlz?=
 =?us-ascii?Q?UUdN7RHVX8RoPJyWr9te0YQReUk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3BF2C69610B18B4A90528076FE18E3B1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7655d514-9036-42a3-268d-08d9ce52cc3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 00:48:45.8457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NpRC6GBIoN68wAIJ9LZD08NcywHo698Hen5PAG6El6AwH+h1g8VfFiqdGkRFw5ssT9KHMQCMxTVxDRTn8P5icuOjBQfOXG4od34uUTCx9tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5710
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10215 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030004
X-Proofpoint-ORIG-GUID: ecPeHN5VJESCjq6iYUUXuliHo5oY3UN2
X-Proofpoint-GUID: ecPeHN5VJESCjq6iYUUXuliHo5oY3UN2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> 28XX adapters are capable of detecting both T10 PI tag escape values
> as well as IP guard. This was missed due to the adapter type missed
> in the corresponding macros. Fix this by adding support for 28xx in
> those macros.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index bc0c5df77801..81ca0cba9055 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4271,8 +4271,10 @@ struct qla_hw_data {
> #define QLA_ABTS_WAIT_ENABLED(_sp) \
> 	(QLA_NVME_IOS(_sp) && QLA_ABTS_FW_ENABLED(_sp->fcport->vha->hw))
>=20
> -#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
> -#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
> +#define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
> +					 IS_QLA28XX(ha))
> +#define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
> +					 IS_QLA28XX(ha))
> #define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
> #define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha)=
 || \
> 					IS_QLA28XX(ha))
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

