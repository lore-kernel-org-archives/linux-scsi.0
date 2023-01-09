Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2FBC5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 21:25:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbjAIVZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 16:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbjAIVYm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 16:24:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85C1D10D
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 13:23:37 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309L5iaw017489;
        Mon, 9 Jan 2023 21:23:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jx4ckawpwCXqe3JsHNXWskjX7t5pgOwY8clFYauZ7q4=;
 b=nHtFzOWxXqi5Eydw+vgREcuUIE6NWSfgZh3+O9+QXp0XhRwrA/c0RG/gilck6ipk/lwx
 4D+mUH4oHyjBaziFtFW7ky8pE3nOHNJOR8ay6kXUeB5djHo2ZdfISrXkoMJtkhsAJUJV
 2MAXMLpkvkcCnJhd+hla7X9sxuml1dQoZC2GhUWeq4P/X6g6YwmxpniAIu7qCjz5SwGm
 2SbB1+OinlHhpHXluzvtsmL2XtySN3rBDpunvvIES2SuLJzcQSQiOyhyhPmIyrRzc7XQ
 phhq4TAeivSZjdhQDe0RjRVHUFCvRkUSf+CbDFBJz0bTniaUFvgEKO4OJoS7CdLu3uUa Rw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btkrjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 21:23:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309KHZ6l007710;
        Mon, 9 Jan 2023 21:23:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy64haty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 21:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a99PVtEzVCbhKHY1j46vXbDFw24n19F72hQE+sxchHHHuYvydjRhHfmaeENbqeJR7TSktReWO4FgHz1FTii+0ZMHngc3KLjbq34Fi0ioJi+Zc+DU+s0MLb42J0Bo/s18aozrAykWBU/Zv6xrUFHEPKmPAb5i3V7lNh4kuxleGjLL8HaUpdg7yKJhK+YeKygNvIFDYV60CN6I6BCWlGn8teAaL8+OrZtxFi5zVq/Pj9baOJNbcGz+aVWwU3MDkre1fSoVVgVCW23xYa5Oo4S/WCsKazZ8wtNBCC8xcG1hT5X7N8mmitaifTuwz3E/5tapjAvcoX5P7NVUJPU8w/Tt8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jx4ckawpwCXqe3JsHNXWskjX7t5pgOwY8clFYauZ7q4=;
 b=P4zSuxAQg8suFaeYXUE9f8mszARjkQT6hlYaz6sXU5gqtCgM+vwEsmpMT9MbVf32XnHRUicO+zRJ1c3rCZgAeZayqLtoPEugRtl0CFdU8Q2CwbchqHd5+swHIy1BP+5qd+hub0ju3xCFQ8dpyNPKHUpFJ9ksjrreuUFM8kcLDGLGEr2Qhuqpa0E4e2g0JBoseUxLncfW1ucFDaLNhwvYIHKdn90Tjj9uh0OUFoT6P6VjBN/Q4tVGbEMo58AsCKCKp3Nb0IhbkKTwJYPstTgGXe7uFfA7Sj37XyckzsDaQUJEi7tiDlPPx4/QtZBjVQlSpyydV90mKmmC0ocawAhWnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx4ckawpwCXqe3JsHNXWskjX7t5pgOwY8clFYauZ7q4=;
 b=aHn+A3BCUSohXYFJRaeJO68sdzyCbSCjUDHJe/nU6TWexJ9TKEZ/Uh6SBYTSRytH1tCPK3zyk+2eEh0uKDMKHV8sBl9zwAdZB2VubLYMd8Zeoe7WYILBcTR1hFeANm1JBwfoLpw9FYpDSxhVYuYAQ0utu+LvXszHmmVTWtopLX8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB4234.namprd10.prod.outlook.com (2603:10b6:5:21f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 21:23:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 21:23:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 05/10] qla2xxx: edif - Fix performance dip due to lock
 contention
Thread-Topic: [PATCH 05/10] qla2xxx: edif - Fix performance dip due to lock
 contention
Thread-Index: AQHZFb92vl3+A+jXTku1T44O7uMXq66WtbOA
Date:   Mon, 9 Jan 2023 21:23:32 +0000
Message-ID: <65B9EAB4-5C08-419B-9976-381FA59E4540@oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-6-njavali@marvell.com>
In-Reply-To: <20221222043933.2825-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.300.101.1.3)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|DM6PR10MB4234:EE_
x-ms-office365-filtering-correlation-id: f5291b8a-4d73-4a02-0753-08daf287c24f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: StUtjVOp7KgPAFeeps25HewOOq6zHpz75BUrDhcyv2RAiE0njIPN2urOvsoza1pMGjKdfz3WSK2u+uqEM2ImUqqeoJv/a8mUi1O43jyDDj3cBUtdE7eGFI0IDNPv4rVIkLAi12FG/bqnaGcQCJHnxk560onVJn7gSOSKheDnYlTGM+7mkXHAuTX4ZgQogHrPEEsRCAwEZymULrrF+/TzH8xpwu2CkMcfkZ9z3ajoDau8GRgEJgenEUH/Y4KaLF/X8SiZMfM5VMgnW6KXz41CQcAXBu1FCvEswapxPQJb/iBrNvioYzMj96Z3DSzVK3VOipiLro1qKGSXTp/q5Q3W6F5j1OBW+PocJuxRPIzPjcEqe4v1/FMMeqEh/57LSq/3hm7kcMXJQDYD4uqjkg9FWPyfHcmM77krrHbnJy1S3C9h9LiKQAAyQ42DtIy5XwAyI7QSAz5H3ibCZw0umt0g7ddwXfKViIpVJgMJdL9ONV5/VcbZwnyAU06Cot1mKkMfrdXJCVYH9h7JEiZ8S1ArT3JUDrWq+Pk3E2A43SISJl+qM8bKtbINkh3ZnJQPJGtQkaePMubNhMOL4iAQFaUna1wIp4hLX3Msl7ZSvZ5X4NcJFUIXBXcdvh5gq2Vy8N4aFMdCi7oTeG5oiwxCXS4r7r6I3wpiEiSm3xSeJYSQDy8tmakYIvLwKBilXnRSnA2D+HFTpSU02horEGnKhp7UuVTnMNdWDUdlHf0gmuF7wMg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(36756003)(38070700005)(86362001)(66446008)(8676002)(64756008)(66946007)(66556008)(8936002)(76116006)(30864003)(4326008)(2906002)(66476007)(44832011)(6916009)(5660300002)(33656002)(38100700002)(122000001)(83380400001)(478600001)(316002)(71200400001)(91956017)(54906003)(6486002)(41300700001)(53546011)(2616005)(186003)(6506007)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ix357klKdZgjNhmqrWdPfRENkJBKBX+bSgjyC8IHvHkgE2go1FubyxUYkZai?=
 =?us-ascii?Q?k+XuT/zOE0H/or01nbhwOJrAv9mSWwAdjT7cERADky3pGdUfvCC9yX9nMl0f?=
 =?us-ascii?Q?DGI1r69HN/CnmGRU6YvUEM4p0AQ2/iFJAdPX8w08JDQE9v1G+C4FrRAWEA3T?=
 =?us-ascii?Q?Q1mzCGJXnDtAyPLoRRZI8T8wDYTT2xQiIf4LOngcTZ/1QThk4H288zXojciY?=
 =?us-ascii?Q?e4eFDjEuVSEXGy+4SHoKgUkemrMwTepxz3t4j7JrafewDeMeXSdpp+2Mhl+l?=
 =?us-ascii?Q?2DjIRIVyi39Xu+fY01W90SnzZid3FJ3YE/6Nix/raBt3L+RbBeRQQTRJOfXk?=
 =?us-ascii?Q?lQWT2NG8CWeGDmCi5Z8JN2n1RZo/FbrTStZEgYE64xXT/8IV42ZU3PBIFqiD?=
 =?us-ascii?Q?hd2F3kObwbn/TWRENk15xVI25AiWqVlKvY+z2Z1JljJyYF6W8J5uP4nefDnp?=
 =?us-ascii?Q?VKXyNq6mjKEa35mL+W4rqrnjTgBKvogw+xUqxd2H5yYQKSjy49jwYxkFHFXr?=
 =?us-ascii?Q?Hy+YdEeZ8bnlsqQ2iU22OOsusG4TRlP/aEJERzWnxTtx1w47feLJ3biOe8H3?=
 =?us-ascii?Q?6IY2fHc3a0tFal4Xzc9XY0EYIolxxGpuPJ0NmouZRQkNUUP8ECt0NMQJg0kx?=
 =?us-ascii?Q?xn2Q+z3TuopOSylhVCMWQ3YaMoN8h9qVkzg1gS0n3oJ1wqI9LC5h3WQE2Wf9?=
 =?us-ascii?Q?XOLiQM3aQxbyXcXJdMzEDvIzZnHBb3J18mI3A3+i9+Xv1EUTfGURtLpExWrX?=
 =?us-ascii?Q?Km2UiHU0qdByk9Td1s+UGB2fJcWX/2qRRxIQODnG6Yrze3sCD72bB8Owd1tQ?=
 =?us-ascii?Q?NeE3PoAxP8rmLHS0/M21wcYCYCSLE7prfnO/xn9phzja1ZMN+zbHDYwg61in?=
 =?us-ascii?Q?85Epviib4iJDKsf5MMU9AoEA06KYRLdZjUszHgWmDY81YvVhd59DCPohP0nH?=
 =?us-ascii?Q?rp+lyzGjRjSP+8p1P2FycoZrYMqh3sRNAcxUa1euWQ65/ulDGJLVurB9ns21?=
 =?us-ascii?Q?x9qCcRqmWGetX/SWdYNVVk5gQu46gCAGzblI9DPZJ4o306TKsjXYfI9FmH8Y?=
 =?us-ascii?Q?nUh8iqm7CNg8/PwuQ3C408FyiW+bj+lEJfNG8A+JTsTjx644+HXZFu6Jinim?=
 =?us-ascii?Q?jyyBqn7XuNr7CVokJdRWCOm9dPLQMOr6GvbEjVk3/Hh9G4f5/jS1l8hmq8vG?=
 =?us-ascii?Q?luS2K46eRlqIsgTAndYvYV+AQewIsJFXNSAfpuZMQP16csB0vJ8maGN1ojlv?=
 =?us-ascii?Q?iQdFRTdzAMKhhHobL+pRrvFlz1muasAehxPbtD/7rGTek9JhI1IoKDOR0gRB?=
 =?us-ascii?Q?vlsdEGPmry8gkvgk0+HWJinJyVbBAaaSsjIP953k9cq2fNaV8+K49IDTV+22?=
 =?us-ascii?Q?IsXXN2YSndMC5HaGjDBEnkpqDuns1a7lgs3ty/tKwrWgfXz63dPrbmnFAhQA?=
 =?us-ascii?Q?Pm0n3NOzUznN7Gbtu0wfqgAiB8yej5P2iixAADnq/caY0qC9Koprjv26TLOk?=
 =?us-ascii?Q?hkHHL77ukmy95QTNOG4BdQZLH4OXxPETgSwG1yip0A/SVmYJBtOy/CHhEaq6?=
 =?us-ascii?Q?3PDJ8uCA6HgELaAcSyf/WuyM3yiqCCpG6rtjpgilMexsRAQ802W76WJKf2vC?=
 =?us-ascii?Q?vkdfpnwoXtUkt09v7hFlPdpxPPoaTzLvEy5PIewYMCR3wMvzCvk/E2gZevH6?=
 =?us-ascii?Q?Vh9UDKoGVTn1q+IHmcSwGs06Hu8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6D4E4408A8240F4EBB5FABB9975B7CAC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ivx6Riw2Nud8Fd9MDmSHM1gPzSiOvfcoBh6reEabbyYkm4xvS2ZwYzdONArNA5SGnoGYq/IAgXP16HlRDE2TW83jGdLZ5w6FyHJCvAtt7k25Dzzb7w52n308PsfBO8/+IcoaGEC77TOu0dcBPWd98B7M7L60efABNFkBt+FSzrQkVaE0eOBAgrBhi82JMDawGsoNJiLeS4w4ZgwFBw3uLkgeNtXVslrejTmCWV86GvOMgwjI9hN3GCUsi8tqCpSutjFM1CUWy+CgyZXg1hcXw9B2pzzUJ6NB5HvrSTwwPMYcdWAjg/bicEbijLjLmb7loLOuDtmyfxDKuybIJctVrcpspDOMeafD/D//5xweMSoaC/gZYwvrHGSaVsVkVxFtwK+AURJBaQ6Ue2FQgPUUbBhWPaDDBkjTOkAasYqiggJEn8DKhu3xQ3ZS4mrY3tOji2bTOtT5WR4A7AcPaErvbB7W/LDkztumEt7Z9ToZfcoSh5tDFwLJJO/xhrQhxBzNwm4zawe7iw9omPUred0GHK0kAtSPrqPo4iIIm7LsSuGgUQmz/Bh4mTNJ/4srh/YtxvcPjZQoKjsB1PoeTaoUFvb0Q/5dPlVQhtDodmZrfO+Dp1+GfI4lBSkAgPbQWeg6kLdk4PTwkbo4jKKtW+XUvXRrYf5ZeLgenuqir1CNpK+3pyn8dB67GIMw1jUc7C4yr6J8uN2ILYjv+kIt+JU4cg+WN/tzmyfcnuVLlBC9LbxKz4ZypaJh6GgYOBieoJ0XLuhS334+ceNWDdpisF/2WT0AME8oGKClW5eeaFFKEiY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5291b8a-4d73-4a02-0753-08daf287c24f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 21:23:32.0187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: swYo7x4U6Cx65I9cHOS5RaBsR0B4uGks/Hi5Y9y4n/87MisEJspkgpLj6hCNyJRg7gyKVuWBB9CaJ/CAntEfEZ0fhItk0dItExAKhEgEWBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4234
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090149
X-Proofpoint-GUID: v0JGNgMjOtLMKlJ5GtNWuNaTeB4Z2Alh
X-Proofpoint-ORIG-GUID: v0JGNgMjOtLMKlJ5GtNWuNaTeB4Z2Alh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org




> On Dec 21, 2022, at 8:39 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> User experienced performance dip on measuring IOPS while
> EDIF enabled. During IO time, driver uses dma_pool_zalloc call
> to allocate a chunk of memory. This call contains a lock behind the
> scene which contribute to lock contention.
> Save the allocated memory for reuse and avoid the lock.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |  22 +++++-
> drivers/scsi/qla2xxx/qla_edif.c |  29 ++------
> drivers/scsi/qla2xxx/qla_gbl.h  |   5 +-
> drivers/scsi/qla2xxx/qla_init.c |  12 ++++
> drivers/scsi/qla2xxx/qla_iocb.c |  10 +--
> drivers/scsi/qla2xxx/qla_mid.c  | 116 ++++++++++++++++++++++++++++++++
> drivers/scsi/qla2xxx/qla_os.c   |  12 ++--
> 7 files changed, 170 insertions(+), 36 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 4bf167c00569..6f6190404939 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -384,6 +384,13 @@ struct els_reject {
> struct req_que;
> struct qla_tgt_sess;
>=20
> +struct qla_buf_dsc {
> + u16 tag;
> +#define TAG_FREED 0xffff
> + void *buf;
> + dma_addr_t buf_dma;
> +};
> +
> /*
>  * SCSI Request Block
>  */
> @@ -392,14 +399,16 @@ struct srb_cmd {
> uint32_t request_sense_length;
> uint32_t fw_sense_length;
> uint8_t *request_sense_ptr;
> - struct ct6_dsd *ct6_ctx;
> struct crc_context *crc_ctx;
> + struct ct6_dsd ct6_ctx;
> + struct qla_buf_dsc buf_dsc;
> };
>=20
> /*
>  * SRB flag definitions
>  */
> #define SRB_DMA_VALID BIT_0 /* Command sent to ISP */
> +#define SRB_GOT_BUF BIT_1
> #define SRB_FCP_CMND_DMA_VALID BIT_12 /* DIF: DSD List valid */
> #define SRB_CRC_CTX_DMA_VALID BIT_2 /* DIF: context DMA valid */
> #define SRB_CRC_PROT_DMA_VALID BIT_4 /* DIF: prot DMA valid */
> @@ -3722,6 +3731,16 @@ struct qla_fw_resources {
>=20
> #define QLA_IOCB_PCT_LIMIT 95
>=20
> +struct  qla_buf_pool {
> + u16 num_bufs;
> + u16 num_active;
> + u16 max_used;
> + u16 reserved;
> + unsigned long *buf_map;
> + void **buf_array;
> + dma_addr_t *dma_array;
> +};
> +
> /*Queue pair data structure */
> struct qla_qpair {
> spinlock_t qp_lock;
> @@ -3775,6 +3794,7 @@ struct qla_qpair {
> struct qla_tgt_counters tgt_counters;
> uint16_t cpuid;
> struct qla_fw_resources fwres ____cacheline_aligned;
> + struct  qla_buf_pool buf_pool;
> u32 cmd_cnt;
> u32 cmd_completion_cnt;
> u32 prev_completion_cnt;
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index d17ba6275b68..8374cbe8993b 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -3007,26 +3007,16 @@ qla28xx_start_scsi_edif(srb_t *sp)
> goto queuing_error;
> }
>=20
> - ctx =3D sp->u.scmd.ct6_ctx =3D
> -    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
> - if (!ctx) {
> - ql_log(ql_log_fatal, vha, 0x3010,
> -    "Failed to allocate ctx for cmd=3D%p.\n", cmd);
> - goto queuing_error;
> - }
> -
> - memset(ctx, 0, sizeof(struct ct6_dsd));
> - ctx->fcp_cmnd =3D dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
> -    GFP_ATOMIC, &ctx->fcp_cmnd_dma);
> - if (!ctx->fcp_cmnd) {
> + if (qla_get_buf(vha, sp->qpair, &sp->u.scmd.buf_dsc)) {
> ql_log(ql_log_fatal, vha, 0x3011,
> -    "Failed to allocate fcp_cmnd for cmd=3D%p.\n", cmd);
> +    "Failed to allocate buf for fcp_cmnd for cmd=3D%p.\n", cmd);
> goto queuing_error;
> }
>=20
> - /* Initialize the DSD list and dma handle */
> - INIT_LIST_HEAD(&ctx->dsd_list);
> - ctx->dsd_use_cnt =3D 0;
> + sp->flags |=3D SRB_GOT_BUF;
> + ctx =3D &sp->u.scmd.ct6_ctx;
> + ctx->fcp_cmnd =3D sp->u.scmd.buf_dsc.buf;
> + ctx->fcp_cmnd_dma =3D sp->u.scmd.buf_dsc.buf_dma;
>=20
> if (cmd->cmd_len > 16) {
> additional_cdb_len =3D cmd->cmd_len - 16;
> @@ -3145,7 +3135,6 @@ qla28xx_start_scsi_edif(srb_t *sp)
> cmd_pkt->fcp_cmnd_dseg_len =3D cpu_to_le16(ctx->fcp_cmnd_len);
> put_unaligned_le64(ctx->fcp_cmnd_dma, &cmd_pkt->fcp_cmnd_dseg_address);
>=20
> - sp->flags |=3D SRB_FCP_CMND_DMA_VALID;
> cmd_pkt->byte_count =3D cpu_to_le32((uint32_t)scsi_bufflen(cmd));
> /* Set total data segment count. */
> cmd_pkt->entry_count =3D (uint8_t)req_cnt;
> @@ -3177,15 +3166,11 @@ qla28xx_start_scsi_edif(srb_t *sp)
> return QLA_SUCCESS;
>=20
> queuing_error_fcp_cmnd:
> - dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd, ctx->fcp_cmnd_dma);
> queuing_error:
> if (tot_dsds)
> scsi_dma_unmap(cmd);
>=20
> - if (sp->u.scmd.ct6_ctx) {
> - mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
> - sp->u.scmd.ct6_ctx =3D NULL;
> - }
> + qla_put_buf(sp->qpair, &sp->u.scmd.buf_dsc);
> qla_put_fw_resources(sp->qpair, &sp->iores);
> spin_unlock_irqrestore(lock, flags);
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 958892766321..d802d37fe739 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -1015,5 +1015,8 @@ int qla2xxx_enable_port(struct Scsi_Host *shost);
>=20
> uint64_t qla2x00_get_num_tgts(scsi_qla_host_t *vha);
> uint64_t qla2x00_count_set_bits(u32 num);
> -
> +int qla_create_buf_pool(struct scsi_qla_host *, struct qla_qpair *);
> +void qla_free_buf_pool(struct qla_qpair *);
> +int qla_get_buf(struct scsi_qla_host *, struct qla_qpair *, struct qla_b=
uf_dsc *);
> +void qla_put_buf(struct qla_qpair *, struct qla_buf_dsc *);
> #endif /* _QLA_GBL_H */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index fc540bd13a90..ce9e28b4d339 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -9442,6 +9442,13 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi=
_qla_host *vha, int qos,
> goto fail_mempool;
> }
>=20
> + if (qla_create_buf_pool(vha, qpair)) {
> + ql_log(ql_log_warn, vha, 0xd036,
> +    "Failed to initialize buf pool for qpair %d\n",
> +    qpair->id);
> + goto fail_bufpool;
> + }
> +
> /* Mark as online */
> qpair->online =3D 1;
>=20
> @@ -9457,7 +9464,10 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi=
_qla_host *vha, int qos,
> }
> return qpair;
>=20
> +fail_bufpool:
> + mempool_destroy(qpair->srb_mempool);
> fail_mempool:
> + qla25xx_delete_req_que(vha, qpair->req);
> fail_req:
> qla25xx_delete_rsp_que(vha, qpair->rsp);
> fail_rsp:
> @@ -9483,6 +9493,8 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha,=
 struct qla_qpair *qpair)
>=20
> qpair->delete_in_progress =3D 1;
>=20
> + qla_free_buf_pool(qpair);
> +
> ret =3D qla25xx_delete_req_que(vha, qpair->req);
> if (ret !=3D QLA_SUCCESS)
> goto fail;
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 9a7cc0ba5f58..b9b3e6f80ea9 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -623,7 +623,7 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd=
_type_6 *cmd_pkt,
> }
>=20
> cur_seg =3D scsi_sglist(cmd);
> - ctx =3D sp->u.scmd.ct6_ctx;
> + ctx =3D &sp->u.scmd.ct6_ctx;
>=20
> while (tot_dsds) {
> avail_dsds =3D (tot_dsds > QLA_DSDS_PER_IOCB) ?
> @@ -3459,13 +3459,7 @@ qla82xx_start_scsi(srb_t *sp)
> goto queuing_error;
> }
>=20
> - ctx =3D sp->u.scmd.ct6_ctx =3D
> -    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
> - if (!ctx) {
> - ql_log(ql_log_fatal, vha, 0x3010,
> -    "Failed to allocate ctx for cmd=3D%p.\n", cmd);
> - goto queuing_error;
> - }
> + ctx =3D &sp->u.scmd.ct6_ctx;
>=20
> memset(ctx, 0, sizeof(struct ct6_dsd));
> ctx->fcp_cmnd =3D dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 274d2ba70b81..5976a2f036e6 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -1080,3 +1080,119 @@ void qla_update_host_map(struct scsi_qla_host *vh=
a, port_id_t id)
> qla_update_vp_map(vha, SET_AL_PA);
> }
> }
> +
> +int qla_create_buf_pool(struct scsi_qla_host *vha, struct qla_qpair *qp)
> +{
> + int sz;
> +
> + qp->buf_pool.num_bufs =3D qp->req->length;
> +
> + sz =3D BITS_TO_LONGS(qp->req->length);
> + qp->buf_pool.buf_map   =3D kcalloc(sz, sizeof(long), GFP_KERNEL);
> + if (!qp->buf_pool.buf_map) {
> + ql_log(ql_log_warn, vha, 0x0186,
> +    "Failed to allocate buf_map(%ld).\n", sz * sizeof(unsigned long));
> + return -ENOMEM;
> + }
> + sz =3D qp->req->length * sizeof(void *);
> + qp->buf_pool.buf_array =3D kcalloc(qp->req->length, sizeof(void *), GFP=
_KERNEL);
> + if (!qp->buf_pool.buf_array) {
> + ql_log(ql_log_warn, vha, 0x0186,
> +    "Failed to allocate buf_array(%d).\n", sz);
> + kfree(qp->buf_pool.buf_map);
> + return -ENOMEM;
> + }
> + sz =3D qp->req->length * sizeof(dma_addr_t);
> + qp->buf_pool.dma_array =3D kcalloc(qp->req->length, sizeof(dma_addr_t),=
 GFP_KERNEL);
> + if (!qp->buf_pool.dma_array) {
> + ql_log(ql_log_warn, vha, 0x0186,
> +    "Failed to allocate dma_array(%d).\n", sz);
> + kfree(qp->buf_pool.buf_map);
> + kfree(qp->buf_pool.buf_array);
> + return -ENOMEM;
> + }
> + set_bit(0, qp->buf_pool.buf_map);
> + return 0;
> +}
> +
> +void qla_free_buf_pool(struct qla_qpair *qp)
> +{
> + int i;
> + struct qla_hw_data *ha =3D qp->vha->hw;
> +
> + for (i =3D 0; i < qp->buf_pool.num_bufs; i++) {
> + if (qp->buf_pool.buf_array[i] && qp->buf_pool.dma_array[i])
> + dma_pool_free(ha->fcp_cmnd_dma_pool, qp->buf_pool.buf_array[i],
> +    qp->buf_pool.dma_array[i]);
> + qp->buf_pool.buf_array[i] =3D NULL;
> + qp->buf_pool.dma_array[i] =3D 0;
> + }
> +
> + kfree(qp->buf_pool.dma_array);
> + kfree(qp->buf_pool.buf_array);
> + kfree(qp->buf_pool.buf_map);
> +}
> +
> +/* it is assume qp->qp_lock is held at this point */
> +int qla_get_buf(struct scsi_qla_host *vha, struct qla_qpair *qp, struct =
qla_buf_dsc *dsc)
> +{
> + u16 tag, i =3D 0;
> + void *buf;
> + dma_addr_t buf_dma;
> + struct qla_hw_data *ha =3D vha->hw;
> +
> + dsc->tag =3D TAG_FREED;
> +again:
> + tag =3D find_first_zero_bit(qp->buf_pool.buf_map, qp->buf_pool.num_bufs=
);
> + if (tag >=3D qp->buf_pool.num_bufs) {
> + ql_dbg(ql_dbg_io, vha, 0x00e2,
> +    "qp(%d) ran out of buf resource.\n", qp->id);
> + return  -EIO;
> + }
> + if (tag =3D=3D 0) {
> + set_bit(0, qp->buf_pool.buf_map);
> + i++;
> + if (i =3D=3D 5) {
> + ql_dbg(ql_dbg_io, vha, 0x00e3,
> +    "qp(%d) unable to get tag.\n", qp->id);
> + return -EIO;
> + }
> + goto again;
> + }
> +
> + if (!qp->buf_pool.buf_array[tag]) {
> + buf =3D dma_pool_zalloc(ha->fcp_cmnd_dma_pool, GFP_ATOMIC, &buf_dma);
> + if (!buf) {
> + ql_log(ql_log_fatal, vha, 0x13b1,
> +    "Failed to allocate buf.\n");
> + return -ENOMEM;
> + }
> +
> + dsc->buf =3D qp->buf_pool.buf_array[tag] =3D buf;
> + dsc->buf_dma =3D qp->buf_pool.dma_array[tag] =3D buf_dma;
> + } else {
> + dsc->buf =3D qp->buf_pool.buf_array[tag];
> + dsc->buf_dma =3D qp->buf_pool.dma_array[tag];
> + memset(dsc->buf, 0, FCP_CMND_DMA_POOL_SIZE);
> + }
> +
> + qp->buf_pool.num_active++;
> + if (qp->buf_pool.num_active > qp->buf_pool.max_used)
> + qp->buf_pool.max_used =3D qp->buf_pool.num_active;
> +
> + dsc->tag =3D tag;
> + set_bit(tag, qp->buf_pool.buf_map);
> + return 0;
> +}
> +
> +
> +/* it is assume qp->qp_lock is held at this point */
> +void qla_put_buf(struct qla_qpair *qp, struct qla_buf_dsc *dsc)
> +{
> + if (dsc->tag =3D=3D TAG_FREED)
> + return;
> +
> + clear_bit(dsc->tag, qp->buf_pool.buf_map);
> + qp->buf_pool.num_active--;
> + dsc->tag =3D TAG_FREED;
> +}
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index ac3d0bc1b230..f8758cea11d6 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -733,15 +733,17 @@ void qla2x00_sp_free_dma(srb_t *sp)
> }
>=20
> if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
> - struct ct6_dsd *ctx1 =3D sp->u.scmd.ct6_ctx;
> + struct ct6_dsd *ctx1 =3D &sp->u.scmd.ct6_ctx;
>=20
> dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
>    ctx1->fcp_cmnd_dma);
> list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
> ha->gbl_dsd_inuse -=3D ctx1->dsd_use_cnt;
> ha->gbl_dsd_avail +=3D ctx1->dsd_use_cnt;
> - mempool_free(ctx1, ha->ctx_mempool);
> }
> +
> + if (sp->flags & SRB_GOT_BUF)
> + qla_put_buf(sp->qpair, &sp->u.scmd.buf_dsc);
> }
>=20
> void qla2x00_sp_compl(srb_t *sp, int res)
> @@ -817,14 +819,13 @@ void qla2xxx_qpair_sp_free_dma(srb_t *sp)
> }
>=20
> if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
> - struct ct6_dsd *ctx1 =3D sp->u.scmd.ct6_ctx;
> + struct ct6_dsd *ctx1 =3D &sp->u.scmd.ct6_ctx;
>=20
> dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
>    ctx1->fcp_cmnd_dma);
> list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
> ha->gbl_dsd_inuse -=3D ctx1->dsd_use_cnt;
> ha->gbl_dsd_avail +=3D ctx1->dsd_use_cnt;
> - mempool_free(ctx1, ha->ctx_mempool);
> sp->flags &=3D ~SRB_FCP_CMND_DMA_VALID;
> }
>=20
> @@ -834,6 +835,9 @@ void qla2xxx_qpair_sp_free_dma(srb_t *sp)
> dma_pool_free(ha->dl_dma_pool, ctx0, ctx0->crc_ctx_dma);
> sp->flags &=3D ~SRB_CRC_CTX_DMA_VALID;
> }
> +
> + if (sp->flags & SRB_GOT_BUF)
> + qla_put_buf(sp->qpair, &sp->u.scmd.buf_dsc);
> }
>=20
> void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani 			Oracle Linux Engineering

