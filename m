Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D32AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 20:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392267AbiDUUSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392258AbiDUUS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 16:18:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139202FFED
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 13:15:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LHU1oJ024600;
        Thu, 21 Apr 2022 20:15:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ylx76llesps6dY2yUOPouj+uWwjqD7nns5Ek7d+EzKU=;
 b=YuP2tPE/4BLWcq17tOPCkeIIsVYqQtyX2jcyiDoScSVpZGdLGS0alATFTKAiBG7xiAg3
 Eqy0Hx6VLTXEqe8haXcQZA0028iEIVAhQGDuSQpplv7gYST1zdx7eFOX5D6ZRU8Hke3E
 6x0gQL2TaRaoSc3GhTut7w+dduAwjnu+GeAM6NpHV7MLKhpecEEjsE6CbdLHfsr0CQEi
 E6jEJgRRHDC+f3h1wkg+nW4EDpZm4Q9L57Niz3i6o4DYHTn6DgGjOqI78swDv/ApnZui
 2BCuLixlconJpNAGtCDbj6PLKbIRemC1X9plc8QszMIagt28OTr3jIlSQQX7vNaI4CMt Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9mrax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:15:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LKAlxe008867;
        Thu, 21 Apr 2022 20:15:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm89fd54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:15:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axXZShp9JxtXlTll3CLToMrspLbvw76rSKw7+KcNgcf4HnUnN4MhIrUQfSSDf/5gjm+lBefkmwk0SBQ7MgScP2JCICvHW6NIN+uxmHMzPJDtv+g3QOqrR8jQYCCHt+5/RvOJkji6sEw+UWt1q7BKvTSveIiMMBnwFPhMqKawMLkeOFWu2lhA1zczMTGlFOa1GU8rK+k10OcykBHWMSaRSPepglfdJo6YSPk5OJQhQv7wUJ+RE24jXbqLrXUx/bskfDssaHq8o8ftePiJF6knHiNRVokL2tPLzmACKnGIZx7PSDI3vs7PK3VIZnjeJhttXpPSa4Z7WjdSge669aqiFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ylx76llesps6dY2yUOPouj+uWwjqD7nns5Ek7d+EzKU=;
 b=eZ+hajiDc0I4kclQUrOZDc5CrKwKZ1XeQWQnKTPajSq3icuz6lk6RFwl8e7e+PqGTUweJRvKKQm/P+XXDDNtCx5GldNgYcVr0RQCLSazsU4KiHRvUV4TBYquFIqb1T0aYLAk9n7IdIpMo/VPeA6ENDSZV19ni2VyNJQfJm3ZTF7IqHyl9Md1/smTTmng+XPOrYicQmME0eF+8a5circ5uhixC09osbFGPDp8S8ePyvSaA4WzVNEHRzmZwO5Ak9AuW5G8g7zcZgS84T5tY18EE8gMblcWQ7K1JXb3uey+yn+KKGpwj/EdB26Smez615H3SAMq70ubXYthp/ieiEuSrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ylx76llesps6dY2yUOPouj+uWwjqD7nns5Ek7d+EzKU=;
 b=aXGumq+tT87vKE6uvFwEcxajjLPEMzN65dlYShMhRgQyG8S06ZXUhTV9kZKDbv8CA99QZJkVEXX8Mg8taSYzQRmNTsgakm3VJ4787vtmzDnz3MwZZ8KB8A0T8nj7jaViEQttyAOraVlyXUaVkJKplb7BtbEuX29yUhwjJzInxNE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB4893.namprd10.prod.outlook.com (2603:10b6:5:3a2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 20:15:24 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 20:15:24 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 5/9] scsi: sd_zbc: Return early in
 sd_zbc_check_zoned_characteristics()
Thread-Topic: [PATCH v2 5/9] scsi: sd_zbc: Return early in
 sd_zbc_check_zoned_characteristics()
Thread-Index: AQHYVa4+02rqgy85TUW5SeUueI+Tt6z6zbQA
Date:   Thu, 21 Apr 2022 20:15:24 +0000
Message-ID: <F30DEB4B-DB38-4DED-BF10-D094A07371E0@oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
 <20220421183023.3462291-6-bvanassche@acm.org>
In-Reply-To: <20220421183023.3462291-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5262b805-192d-4939-9d25-08da23d3ab4c
x-ms-traffictypediagnostic: DS7PR10MB4893:EE_
x-microsoft-antispam-prvs: <DS7PR10MB48937EF54BCFF1DCB6350231E6F49@DS7PR10MB4893.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: axy2ttyLsZqGBI2CjmghJmqGUjWaBIjgQPDxBKPA8zG125f7k0cRbUCIdU5o1KgvOuCrj+iHuOI8QkpGJzTzAbAxyJ7tzap9ZqjJhtq4y2YZGYkBjmuA4yqoQXywv8TJIMpemjaxOXOE3WCXhS3MHLw2ZcWtAJ1M9wVC3FpGA9z+mrknNo9kSV4aWlV74TXlfeCvSVGpj2rkSwqI0EfEQW0Cc/Sd/SAiRrMDxZuqTzSL5yvLi0Ij4JC7Q7wcmZfL8U1F4808S216YoLOqW1aExfDRm/f+0jdEiQEjx/InBgVgWOrfXIqiZxUQmqSUXuPRI1K4bw17lbTE3xeb1dtZ27A0eE1og8o0rgRkl3UC6PQ35omh2r0GO2MKhFqj80Wgmz1wqQchqo37NtHh43rmmBFSMex5h9PcQtDafm8pWMxW5s5XWim5+Gej+kMy0F5GIRXAw9l85BOPGVKEOMLc4yAESFqBMdw+id5640tBOirEQpCZ2+GX6u3XJDLVA+28Z04asE58xBXAWoPN9n4MSnNXVDCtH+t6L40qcMF5qRbLy5Y07wfKpK+cmPFZ6Vcn/Xs3kOF0qljZwHR97nErgT/+Pj5KekhajE3d9ACiePcXCnED7Vrx+eqDhKGpGmqtTcP6ns3+X1zxdnLMwhRZkPw6K7aPe1YqYKEsTsfxH+/I9moBRnHl+S1uaWTgBQ75eA7k7fmTNdjVVwt7RWbs1TsL/kFrcKZDs752IQ+mQ3L8WdbSooe/12kHt2SRoeE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(38100700002)(44832011)(91956017)(122000001)(36756003)(6916009)(54906003)(316002)(2906002)(26005)(6512007)(186003)(66946007)(66446008)(66476007)(66556008)(8676002)(71200400001)(4326008)(76116006)(64756008)(83380400001)(6486002)(86362001)(8936002)(33656002)(2616005)(508600001)(5660300002)(53546011)(6506007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lIGC6HD4x5+YjKM0tF9YUrgzf7IBWpmX4CdGEKrui+4NcNulY6ZOLNB8l1eo?=
 =?us-ascii?Q?Mur9eB+wnvQhbrAcQtdAXbwSDsyPRW44UGdrk6uIfHV9e7GODf3RCpYHW1xO?=
 =?us-ascii?Q?WBM5VugYRMusIAkJoFPrjgrzWeWJ8orYJntikGKICEymvxb30EySyEJ1FEk0?=
 =?us-ascii?Q?plZoNHNEI3Ye/stHwBd6v4G7nOQeDhOx/lP+xx6618mrYnfiAj9e41p1tZsy?=
 =?us-ascii?Q?QsfqVVmSAyw6RyXu9Kl3jOlDSptNHcQAe+xKxHTfyk7hSklr56UZH6q2sC++?=
 =?us-ascii?Q?uYpT6QxhkAT9Oo1SeEAWJioBh+gTN1/WJ0jjh+Lidfbwjs2Efd7S+Elvkh1y?=
 =?us-ascii?Q?h8+RxPnJ0jZPe6eCP5/MexbIqAg3klSK+IbKxgStw7c/4yLvMzuhuu8t9ast?=
 =?us-ascii?Q?bV7EsSvktSz9kkUNg+azynrjh9i/Tma0zaiPTXfQStL+uhgOItK2YgyIyQi0?=
 =?us-ascii?Q?LhVSRBkINnnA4HDYnW06Sz/yxUOChrskO0Pggszva6IVEU2+QhyCnVj+jBfV?=
 =?us-ascii?Q?xlJyjefEAcJ5oTWpjvG5BxMcgn3BPOM89P+5v9wusbCHdjecPawmSjZKI018?=
 =?us-ascii?Q?+YDdP20KhYab8WiVtxR0cMACDIx73pUFy77mF+34YxD/OvwHNuAZQGUGjOP+?=
 =?us-ascii?Q?hbGRRRqjINUzFXuD9rjGbGi0H4scGlvlXKMH5/zaNi8eCyekX19SVgW2lFHq?=
 =?us-ascii?Q?QHrXq7jIPqews6bWvkKDyCnKuydYJETH9cgzfURfmiW7b5GAiWUKzAfHm8/u?=
 =?us-ascii?Q?lks/1MCSIFwuAEPrXSCxX0Hu6CJtCmLyISpEuMJuX74IXW46V5v5AlLhaRl6?=
 =?us-ascii?Q?rYg14eI5GWx37imW0ghwgUshlevIoChlLI8p4HtyDaCROFyZ3eCu/Xdcs43f?=
 =?us-ascii?Q?in2HjeoVULjl6UbimC8lwFI4/PuxRF4+NWc2HAFMeI7cyed7KozOCdRqqd7J?=
 =?us-ascii?Q?7Xq31AaQTngpoEPB4DH8/szyH8eCVa8EvFetWO3WgfZ/cZcdXBSOCxPzuhYV?=
 =?us-ascii?Q?41CLIy5IOaNYuTTJgi60pg+94u6B8IySzJEX3gjRw20FLw6z1ffl4kR+TA2G?=
 =?us-ascii?Q?dXfO4Mxn08JQAcvoAz+alKE7+f8782mc0phNs9Y27AxU7+GXfucyKLFpVQp3?=
 =?us-ascii?Q?iiE8On281lJFUr0JreiDzDQS6GQYRJfaVbe4As2OaWd+pv0eqd4A3O860MDq?=
 =?us-ascii?Q?tp8aQvItknNkG62v5hrcb65av7aDaOPPEtBWbE3ZxiCfZ/U8xVXVSfc6BIHQ?=
 =?us-ascii?Q?qDgnbTvbmKvXyEf/lUNs/krTsr5m/h1FgwIUI+6WvHqg5oZHhv+4L+JNy+CI?=
 =?us-ascii?Q?b8+xG0aCLsDpe0SeuMOwUb08gu2YNJ9l6zXRnvVDHsyAtdXqug6tNGT+cabC?=
 =?us-ascii?Q?h1ZmaNBQ8wBJrcytwGzYswBZRs754CdQIvIREpE1+LJYVc3OtWiaOfmnyVgK?=
 =?us-ascii?Q?/f3FJhJn7u7LMcziiDf8BJ38+2KyfYBDa1a9l8dV3uDuYqLdCUAvpMd8tTF1?=
 =?us-ascii?Q?PQh08wY4tT3A6Gf0uPFVrKpjQW12swQ3axBAVT0p3FGJOUVtnrHQKPrVh+Ir?=
 =?us-ascii?Q?qz0DAMvmfiyXlNNRFYoyhEZYJmMeHzyJtr7FJu5dPsTWXsiK6uUyIkUar47t?=
 =?us-ascii?Q?spId4KzGN9lnP54PyYqqojwMV1O9b8vpghEnOmJOqW4L7R/c85A3BNZ1expz?=
 =?us-ascii?Q?NBcF7n17u9YPWJhKZAJNRcYVy1LYB/j1jXHyNAaAkzczYmm725E02iYj80e5?=
 =?us-ascii?Q?U/PEMn4a68UoobXQ8pgrR9/seH4STKqd8jbo4bGSoOFEpr+G3fxC?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14CFF48FA6DCC240AF47F66AA5A9DA5A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5262b805-192d-4939-9d25-08da23d3ab4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 20:15:24.4718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFC2AAEOqcpo4S52h4cJ4QW8DQy8cp89V0hK/tWLQP5vNABjHlnmEKexYvYs9IQB3/MM2CJp+6ogcnhHWYOx2HzTBGOeh/6Vtf7CKzMq17w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4893
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_04:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204210107
X-Proofpoint-ORIG-GUID: 4jQl70mLBe1VSO8VKfHcoQs74_z_4FmD
X-Proofpoint-GUID: 4jQl70mLBe1VSO8VKfHcoQs74_z_4FmD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2022, at 11:30 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Return early in sd_zbc_check_zoned_characteristics() for host-aware
> disks. This patch does not change any functionality but makes a later
> patch easier to read.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> [ bvanassche: extracted this change from a larger patch ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sd_zbc.c | 13 +++++++------
> 1 file changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index ac557a5a65c8..c53e166362b9 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -592,14 +592,15 @@ static int sd_zbc_check_zoned_characteristics(struc=
t scsi_disk *sdkp,
> 		sdkp->zones_optimal_open =3D get_unaligned_be32(&buf[8]);
> 		sdkp->zones_optimal_nonseq =3D get_unaligned_be32(&buf[12]);
> 		sdkp->zones_max_open =3D 0;
> -	} else {
> -		/* Host-managed */
> -		sdkp->urswrz =3D buf[4] & 1;
> -		sdkp->zones_optimal_open =3D 0;
> -		sdkp->zones_optimal_nonseq =3D 0;
> -		sdkp->zones_max_open =3D get_unaligned_be32(&buf[16]);
> +		return 0;
> 	}
>=20
> +	/* Host-managed */
> +	sdkp->urswrz =3D buf[4] & 1;
> +	sdkp->zones_optimal_open =3D 0;
> +	sdkp->zones_optimal_nonseq =3D 0;
> +	sdkp->zones_max_open =3D get_unaligned_be32(&buf[16]);
> +
> 	/*
> 	 * Check for unconstrained reads: host-managed devices with
> 	 * constrained reads (drives failing read after write pointer)


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

