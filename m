Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B354C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 14:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC02A610A8
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 14:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhITOGT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 10:06:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26458 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234639AbhITOGR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Sep 2021 10:06:17 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDTncl026691;
        Mon, 20 Sep 2021 14:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=CD2wsRJZHqhq8Zo/A5II2GLCCPpLcXBlfkoScl2IkI0=;
 b=W90dzFaeixVEC+kdF3SdYbNwVPfqKYCp4MYlEPLfvhtGyKnNGzDoQpHDcT+aap5VkQ6a
 B+n01QIRrOZkvAWmbGCgPGeXBbHqIWzMjLXcUVH1DmxT24PNYGZaCwvvdmH+MenMYyC3
 zxQ+JmBPLSlmoMj/v0I3Hr44XoVh/Cc1dELr38kYmT54EvYoxq1Y56T8wvAw3fALJebX
 I9fmR2du+TwVCM8IIkbEX8KPFTYuFR/9vywAxOA0IWvjqys9SStd9foIHX3mF3IltyGx
 EGYAf05bteKzNjDmVcKJ8VH055/M0AL1GeFxjPKN96nZW6+Qa2i78Rdm6Cuzmm8OWxEe rA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b6426ayjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 14:04:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18KE1UbZ054069;
        Mon, 20 Sep 2021 14:04:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by userp3030.oracle.com with ESMTP id 3b557vk5s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 14:04:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BX9BenxiN4P6tck80A4au+1ndhSiJfo6pw2e/wVbKr10hBU3z21V2Z+jdBRJVQ+IY6RaoYyEPORD5Uf/2B833/Q9/Em/7/cWFjsGOuazfQu3VqqcG0o15h4cDIUkSd2756kDe4ojuSLkfzUBhr1dArxfOm9xifFQlMns3D339FX91omB8czSoFc30mAdyT80l/7qy8jjIwE9DPc3Me69MFpvw1w1PfbcdUVvShEmi4ie52qqNxFIC64TL8ggjlQ0rePfAN954U6i4Ms6Kq1U46HPYGSpSrr//w50vWQLXPIiPJvlquHSBDkD7aQXtQ/rXFM6TJbARhVO+i6QPL7gqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CD2wsRJZHqhq8Zo/A5II2GLCCPpLcXBlfkoScl2IkI0=;
 b=QaB+ypGtxkd8nMqZiR3VBsrK/q6MrQ2NY9kLBQbM3UhCNvKArjK9WuzXODE47Mw6USPlZfca1wAISAhVlwrO0ZXim12SqSq5QPiArF5Ru7kAufyVgX2DldhBrf37WmArvpiiYcRzKpBQILcqwa17AyrXGiHXUf0b14CDAXRFrC6CieHnQL6KgqY+oQt1lvfde6R1ZwGIDd3EJSk0CI9fnXwseNmLvz4HdwPsZZLxIzXTKNLoaGEOUMcNu1+Jcind/vSlsqFHLXcklZ52EUu6qMUqHKT/54HfXvZv3C8nVFCxwy+UHK72/nv5pEdOgrkEbb8iiiJBrWImng/PncHAZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CD2wsRJZHqhq8Zo/A5II2GLCCPpLcXBlfkoScl2IkI0=;
 b=RZckRYQQmcpXn9Fn8v89hZe9cOovRa0k8eH9xHsA/RijDUwG4klOCXKb3ghyFvBZE85EE8K1T94hoXS3fs3LfXEcfUoTrUHs3120vKY8leiy0jfb7sv7MeuVbsCay+ev1+Kyxf59oS1iwfyy/Ve7DrRRsSvMYKyviG3pO/K4KpQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN4PR10MB5623.namprd10.prod.outlook.com (2603:10b6:806:20a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Mon, 20 Sep
 2021 14:04:35 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::60b7:cbb4:9c88:941f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::60b7:cbb4:9c88:941f%3]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 14:04:34 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
Thread-Topic: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical
 blocks
Thread-Index: AQHXrApDFMjvkLetCUiD27ILyMm+gKus+MwA
Date:   Mon, 20 Sep 2021 14:04:34 +0000
Message-ID: <937A4199-DCD8-4E8E-9B49-36984BAD59B8@oracle.com>
References: <20210917212314.2362324-1-bvanassche@acm.org>
In-Reply-To: <20210917212314.2362324-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 137aa15f-a8e4-42aa-b644-08d97c3f9372
x-ms-traffictypediagnostic: SN4PR10MB5623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR10MB5623FBD0E8F3ECA2067A0DF9E6A09@SN4PR10MB5623.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s4AiDVlQuxP7QoZiRlIb/USxori9ascGjnV8OFxuOhIFi1h4kPqK4VLrUeL7l6skGEXWeOlropC7/QY8G/fG5SBb3VPEMCz4BVDg80kBjVKK9BOoK7m6wp3reypyKeqqNfij87TSUFelDIOLBMU0F2FSwZLSFXaFqhR/NwlyIQC2FODYtoqmNNNLb+w++VTZlI6DcooQeZY1xqVLA8Mw4lFeVFm3mimEK4qLvohxwzreP+wuTlFO4xzKEui8q3Q7HF752PsVZ2mWvesk08bLNAk/QtVrCB3SKH/mhmzfG9Zur6qJ67nzvDnSZDdAA3Q0DyUMNf5i9UOxSmgIaoM9CIEUUm0TeowO2DRE+mhNX7Krito+/d2qC3teXSdXoSc5YXUIBsfEqszzxac0ZoyBF/zjFTLNh2j1Qhi5sPgXursAjG/zuScfJDlgWG0MS1EESikNFpTw+FHAwhgmn9AngqORmOg0Lw/b+fL4oKB6tnrhvaqHLij2Og/7greW5r2S69HA4u/Q6SFN9gKsNw5brI+PN6uEAkiUhL3KZWazoKAEEPY9B+5/3PaqknZeZTK1E1eSSWa3hQIPGCD1tLwg9i+GM/agM0p7p0iPOPnEUyCj110RECd2Z4eGvfNpwhEeLiIOxD1JXAbz8JzP5O1dTLtozUfrT6vKIKQG5u5YKpq2oNq6IIxra2OY00vr0ntMbh+szOPP3jx6m8jMGBDToIxpsW6X3HMfjSrBDEarmiwwn6QAehM6bCIU49lOJJfs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(38100700002)(8676002)(122000001)(2616005)(53546011)(33656002)(508600001)(36756003)(6486002)(316002)(38070700005)(64756008)(76116006)(8936002)(6916009)(66446008)(26005)(4326008)(66556008)(66476007)(6512007)(54906003)(83380400001)(66946007)(6506007)(71200400001)(2906002)(86362001)(5660300002)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sAIzMMuvBiV5CgglZOyV2brpUc7nUyjRuAnPYl5Lsj0EqxICDNHclzU7pdhq?=
 =?us-ascii?Q?Qy4pEAi19atSteJmSMrXGbwVIRssIdRoDQPOn+Bk8zzoTT49vykqpyUMFfiV?=
 =?us-ascii?Q?btbGPwSfnXYtWJfP+rc/6tCN8anrUSw3S/ES9TKrqWOdf6/YuFODUy4lx2vB?=
 =?us-ascii?Q?vVAevhp6aGQDJVnvkxAPd5mb9P2BzByRIssceM63OEFqdikeQVCu56r5TehJ?=
 =?us-ascii?Q?nSZ5h4dcFgtRDcLce9kPzX79IXBr0j+yCTh50UP93vmNgWaBJxj0hLvJ9vPw?=
 =?us-ascii?Q?cRyC0Wu2rhEhd/VhlT1iEVfAQ2ANSkryzQTL7H4+EViP9vbJdZkS2VckmM0s?=
 =?us-ascii?Q?UIvJ6Ly6JnwgoLz18BNZ/I0ombat/rCVOs0QhB38ZR9Dz7fwuA/KFjIcW4GF?=
 =?us-ascii?Q?YgpCZuKmpLGgJ40ol7urXaMqUbu1p89KtHQSLAc1uXFu6gkDcZFZfB6flMxf?=
 =?us-ascii?Q?sf5IwGvrenp00Me1pnCFMSe8nUXdCcZBzANb78G9un6DXfUs5Jm/ul/z/Tec?=
 =?us-ascii?Q?RmOSsG7bKscW8gK0z+L/84nBCvo7YTcBciWVmJP8Thp5uIp+qU7mG1M3HYn9?=
 =?us-ascii?Q?ZjYUWmGmmml0tTyGKR6BD1bmPvaaJ0LhPYzbMB18UDJgdrI3sz4TARf4EJLk?=
 =?us-ascii?Q?EvDkeVcK8sDaxOSM04JvUG1hadlw2FG+//eIPZ2tZNYCNHRJaUj0VAOyjYoN?=
 =?us-ascii?Q?z76vWrVzF3XprECNJU/VMBO4ndp6TE+n6C83atsf7UslJgBRaHIG4QHkyKvl?=
 =?us-ascii?Q?i2caVhOFCQf942vOP0YutM1xSTzkSFKimJFRb/PQLrGBSq6w81p5i+I86fme?=
 =?us-ascii?Q?GyFilgz8jVNuhH5ldDEdoyOdJFM9a2Sm/LIAur7nlXr3akFbRza3k4zJVDBp?=
 =?us-ascii?Q?/sB6AZ7sFt5TjYboDq87cWsWvzm8nY0jfrtFwZr7w8McO1obm09S4QEJig83?=
 =?us-ascii?Q?+yEVCH4TgZlatjsK7zaXswpnkyvs6K8OVQ3VsQqNaZMRr6huzgrZSc1M6Al/?=
 =?us-ascii?Q?ec+6xxUoN2S6Jk2bvdl7y+IzuDllmbqbQyN6FEQkb96iHZQeBNXYXDkyWDq/?=
 =?us-ascii?Q?wz9IFJx6QWGf2u3ItryiuQl4FudrxQ+Zlm8GnqNRUXeJhmQkwZbGtueAkHYi?=
 =?us-ascii?Q?LuzGKHdKqXhj3ZZgzoNntGpu8twcnmoeLQhIzNio/gqBMfQvZtup3XFIK65D?=
 =?us-ascii?Q?O6w/8e7uztUkk3BsDIBsFfDY9HZbNdygcwPJ2sBgvdc8T0v/o0jivmoBDoTt?=
 =?us-ascii?Q?kG0mk//8UeMOPLr9UbKTvgOmL3IJcOFGLXQX5BwWj4ROb1YrwfpSPQeXJJo3?=
 =?us-ascii?Q?93Ipw6uscees6qZ5GbWg2u3CAqa0AGR8cum+iJkQWKTdsw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CBF7564B1FD9534C9DEA40143B409EE2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137aa15f-a8e4-42aa-b644-08d97c3f9372
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 14:04:34.7138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jppJwP7CjfID5/0dsrMrEOcjHOEAONfMhF7DnycvrnV9B+3YMH0Xjmb+nEqsPdYXk8XV2uSXWitWG2JaFTSKYjzCMgzcVNQnaDSnwvoXub8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5623
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10113 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200090
X-Proofpoint-ORIG-GUID: xO2K2T0_p9zpjOhbNRdyQdK8wUpzBfI4
X-Proofpoint-GUID: xO2K2T0_p9zpjOhbNRdyQdK8wUpzBfI4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 17, 2021, at 4:23 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch addresses the following Coverity report about the
> zno * sdkp->zone_blocks expression:
>=20
> CID 1475514 (#1 of 1): Unintentional integer overflow (OVERFLOW_BEFORE_WI=
DEN)
> overflow_before_widen: Potentially overflowing expression zno *
> sdkp->zone_blocks with type unsigned int (32 bits, unsigned) is evaluated
> using 32-bit arithmetic, and then used in a context that expects an
> expression of type sector_t (64 bits, unsigned).
>=20
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sd_zbc.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index b9757f24b0d6..ded4d7a070a0 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -280,7 +280,7 @@ static void sd_zbc_update_wp_offset_workfn(struct wor=
k_struct *work)
> {
> 	struct scsi_disk *sdkp;
> 	unsigned long flags;
> -	unsigned int zno;
> +	sector_t zno;
> 	int ret;
>=20
> 	sdkp =3D container_of(work, struct scsi_disk, zone_wp_offset_work);

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

