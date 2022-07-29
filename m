Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65F5C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 17:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiG2RAD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 13:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiG2RAC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 13:00:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49EA89A69
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 10:00:01 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TETEla020928;
        Fri, 29 Jul 2022 16:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=rQhWaqot7k+d3HoL9/4iAZ+ZZRz+kjCe5havKxJHi2Q=;
 b=duGxL+Q1mWcAMVcaSfzkTM7AKUVpEMSi6P5Rr8ZTASD1b1e5p/v/qKFU3P1hOU8BOV5I
 9zpsrNXCVzGRGxbgDCO9i9uasaAO3UpZAaj6/nYdG7HUQfrNyeywkSdusqb8maIfYUlq
 N/+MRYP+eKGBPzsRimsCWhtN9u08BR96kx8rdK2l7OvXN5IDotZJCS8qmH+VZgLuZ6Ut
 5ap02fx/DXwOlmx1kKQFiz8bIvIn+fVRcPsU1QsQRn6QDUfWZdoXVohIWF49QyLa/62H
 m9zXi7Fun2o480gbeHAllQ8fp9W35KJWCgKKgog6i2mXB1bM35z1YhFLwI5arEna9o/i pA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg94gqr4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 16:59:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26TF5UZU035387;
        Fri, 29 Jul 2022 16:59:57 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh636t4mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 16:59:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iot9HFQyOk78XW66zoU8Ce1e1VPEz1qxBQTsHsV7sYy14JNGXC7eHX2izxWvwREZP0F1MRFFHv8JrvtbCKZaK4wgFvYal6dCTlPPVppVEQl1sPH8NerrEvG7y1UBz7DUxWWOO8UzQoVobvrZ49RERCTFt1dHP24W+p1I5kS7hXjo2EaeFQWUkQpaG6HQ2JFeyi8dliFvGnSiqnRbn3VG7oStZDU1bB9Nfm9HVtntBbQhJgbZ5mRQVr/eAuwwGcrvXzO4POYA4oQEddVBfsB6pIungbXnK81jDrgHJqvMyy3w8mToD9+YJ1FlG5mTGZz/qf3iaGqnUGH4Xlz7dgd0ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQhWaqot7k+d3HoL9/4iAZ+ZZRz+kjCe5havKxJHi2Q=;
 b=OLbbR7DSeZ19rX6G0qT1uje6f+/YxiqHYT1OJwm/ddnh2zmKptrjzroeWFOa3Smu+9kwmsxv8ouoiIeRpF4AQPECIJ+bDHg8Z1nJjDSbt24MBRdoGJwMOooDxSZqIik6ft5kQdeMeMQcaZAVwc55hEwbH2YMAZiJ4UGLPH5yMwqHrcTWPra3jdg8wGisbSWRtgVFEcn4P08Qi39Jh9YZjSso5xd9F5N2npCMxFpG0pIAh47D2LL+75OGCD7xvCV9AsZuscjIWT7lTy/eKllBukdMJn8lzz5soWeWV1PYqRDgFFGlqn6sjXl3Nnm/J49oz0FvE+ayMEDb37XtXdhldA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQhWaqot7k+d3HoL9/4iAZ+ZZRz+kjCe5havKxJHi2Q=;
 b=qvL/zP5F5w/B1bnGZou3Agn0YIe81j8IXlFJ1Vvhf37OFZAym2wV2FcwnLz6ztc9dkXcBYD+hOZ3RntfJXWuMYLCt7iUQTONngpboU7Mkzf8/J7a9PBR8MjAcWXGZ+pXQN88G/oboaHy+jkZn2J0mpklkQ1PuJvIbIEHxe4t7gE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB2971.namprd10.prod.outlook.com (2603:10b6:5:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 16:59:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a99d:1057:f4ba:a4eb%3]) with mapi id 15.20.5458.025; Fri, 29 Jul 2022
 16:59:55 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 01/15] mpi3mr: Add config and transport related debug
 flags
Thread-Topic: [PATCH 01/15] mpi3mr: Add config and transport related debug
 flags
Thread-Index: AQHYo0vMzOlVpfIue0yVA3tEeIdb462VkqmA
Date:   Fri, 29 Jul 2022 16:59:55 +0000
Message-ID: <AEBC6385-0A82-45DA-BBF4-6B77FC125BDD@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-2-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-2-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40b4893e-dfe3-4bdb-8b73-08da7183c324
x-ms-traffictypediagnostic: DM6PR10MB2971:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OeilAWwCLUqmbV7kamIi0QsB/tOEZ0h51bKGtKjgapAxmGaFal97UfhIrM0KDhsUaHUW8IVaFStVKc1ziqpcQe8WPmzWdpxGiGAtmu2fP5pkdA4IvRMJtZ2D+a67ISL85k2zStYrpiFgy4XNRbJZ4olIwksmrAE08DWMyxbiBLFOQO+6AkaSn/hM5Xbs7kTjFK//PAsvSF1lIFsIQpxAJlf0HcRNM4yRqZssT1xazbXfd0TvAiYCAS5yuGRQpsidSYLXdNXBdcfLu/BzjkqYPPhzX7fPPl7l2EapSKSmnI8Wd40dEJtvdFX07LlTbkQZUKa5bucrK8LfrSuXoBcZ9lIIdDxm45Ibgua6AYvxch2oZy/HCaZVbX7lh6BjlUYw8gRxxVpTYmoDjQjEhj7J9y2zdgeO6jooBCGBAz3+d+IrOjM8DjnxCDFclsprEklWwZDs/zya8Gfg2fgAlvOawubL1pFqewiGZvbsV7YuxYMeQJWsvLgxWryhj7TPOVEI2qGyifnGn6QdL9JGoGHyOH+xmumTq8EyuWoErFddz8T95MorJYsN1epqTJY76Np8kluHrXPtJz9Q5suU11I3CEmzP8k4cZmuGRsUPoDgqLClOFI6WsdIuhLpQPzs3S1mvJ4V8QavxuxPauYtxCN1JFhea6ievppFn5GD9i6M3zROxTDPKr7DXDpSLhj83r17bxVQ19XA25RG7VJjhP//eV79oUIKH9UoLftAE3fMF9qGaVcfLcJFdnVbWWwJLt7IyThnlFXKhkXrGbpjxWOUTEtKp9sMOIa1yobZMkqJto9Qs3pc6DaI1SgURTpwgGss/4a/dzHbPFk/PqhaJwOIdo6Ce/nfBhYdUppSHUDhF1A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(396003)(346002)(136003)(39860400002)(122000001)(44832011)(38070700005)(38100700002)(2906002)(86362001)(186003)(2616005)(107886003)(41300700001)(83380400001)(6506007)(26005)(33656002)(6512007)(53546011)(66476007)(91956017)(76116006)(66946007)(64756008)(66446008)(66556008)(4326008)(71200400001)(54906003)(6486002)(36756003)(8676002)(6916009)(5660300002)(478600001)(316002)(8936002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?598fiPbFjuWXK43pncng1/TvVdg2bxF5qTbKVYKzZoNnJwKXCY1gm7Ql3KFD?=
 =?us-ascii?Q?qrQx/ATp3HbEtOMG9pjJOwtcndUwCKwkQTk3lMGyOIu0ZAza4uPM+fUa/2Mp?=
 =?us-ascii?Q?YfO5nPFNkzW/Ase+ZDVu4iFNXaxAD00iwo3GE7r3o4phbnXX+Mf9pRq9wsjR?=
 =?us-ascii?Q?R2aFVEpBUrxcHxMVcZOaiKIHPS2dLxXq1CS5n4W8pVf5RzFWeujDbl0IYvqp?=
 =?us-ascii?Q?L9gqfHIlk6IOfaH0aoVFwkR6TMxZDtsQQFUV3o2uPvNZkSciVXGXjtlCbBXg?=
 =?us-ascii?Q?9EyOAvWTncHF0EFt+vEcRD9GEYTyMyRGrfYKz+VDrkf5RY7buA7gD1g1GVhP?=
 =?us-ascii?Q?Jy4agsQRP1Xw3xrZC2EKFLyGBpgdgYNt3068datySLt/vqaLAUzrmb6dGw7b?=
 =?us-ascii?Q?wTImEABU6dLBYS8yqBOzts3BfvvGLpdPmC1Ahsbxwjt8h65NOIYEpDL9C7NY?=
 =?us-ascii?Q?ay97Qqf7tdVXR7efcSpRCaA9zJAoyussv+hHstoQz+h+5hcqnm0aIa0Gp6fn?=
 =?us-ascii?Q?hi/MCjBuubWx0nul1VPKRT6JhF3+Cw1NUFewStYGtFqzToj4sWDGdeqPrm7O?=
 =?us-ascii?Q?bbmqaHi8mMosMGWMB4C3Lqpv++dvbDAFXmwCSPVUrQG1OhQt8oDCnbt/36dY?=
 =?us-ascii?Q?4WBi8L4UJwGwM5+WWMNAPgP8vL+AVG/6HcnPK5XWTd8ugHDJeoSjQOTNEDN4?=
 =?us-ascii?Q?VV5R7tmbo+iBlZNhvOj1z7KVu3rwfZeKfGYcRjMXMCzwR1E/xrJ0dw8wDsqI?=
 =?us-ascii?Q?ROTa1vjWPdJFwlOvjMUYFSEwriB7JSuOlihVyL5FNnQM5LKrAVxiR766h4Tn?=
 =?us-ascii?Q?I5O+Xl3nwPZuo3XEJgqCbRJTejssvNv6hn/PcHntPD4tTANcuTZYmwHLcai1?=
 =?us-ascii?Q?sPARiiQSlwUpUfUP01U5Zp/oAdgR2+Nsr9OpT6425JJGSfyl4yZPNINDfD/7?=
 =?us-ascii?Q?Smxp2Z1vVAPvcK/83aiPYL17y4AcT5EcFuhuCFI8cNdEFddYXXSbUUSfSB0+?=
 =?us-ascii?Q?LllybGIM6JRNP5QcQIIbnPLyHSdvoy/Myv0hzzexYIqOu77U8bzh89yhK27b?=
 =?us-ascii?Q?/ujS1WTd6gT5OdjzxlKE+1fkB3Q6Mz4EphqRrFK9aNLCOunHHyHangHu9hx3?=
 =?us-ascii?Q?quSv5QVPOKziWt0gjo/Azaa6FZ5UqLsaRonEBgz/8y5f5PNhaEA/cxJYqBkp?=
 =?us-ascii?Q?0CCscE023xfRZ3A+Po2FxbFV5Ej27WvYNIUVk/mQF3DZ03ycp2/QP7o5SgTU?=
 =?us-ascii?Q?2p5GvxsfuBjxuAlHvsmNW9yHK+6Jrgvfy7P+zV0usNm5Y78NwM20PefVlhaO?=
 =?us-ascii?Q?36Nz/IWdqPkr8iuWPGZZY+NHxHM71BuGl6TYoCkm5WkofI3Q4KFfS4XCq0jx?=
 =?us-ascii?Q?2WVA8yPKP0pa4ox8f7qlq/Gnv2NE0tM3BkWm6dF9NymSyTML2u5RE5RlE9aR?=
 =?us-ascii?Q?XqhiAizLSnylacXvD0H/uqsKet6iFljbrDAqJi7smEP9if5Y7hMCc+GURKB0?=
 =?us-ascii?Q?hhzSgkEh9ruI1Xbv6jS6R3Kjk6PtgQkpzvgLQK+iODksgJilVwx/pJ84YAmP?=
 =?us-ascii?Q?etX7mWU4Wx3aRg4THjX9wz57IFsFKz/XzsEfgSirNlkOSWjP1Y3k8qt4h752?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94F7BA9A35CC8046B64B4155356ED7FF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b4893e-dfe3-4bdb-8b73-08da7183c324
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 16:59:55.4640
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RpUeV/p4vYRiBOAXfmC7cPragSA95kab/kKZexQPrgIagNjPLNzExXjf+6nGsRjwbgiOaCvhUSWMczm6cgtfSSmA1CKan95OxcJIeZHDRgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2971
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_17,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207290074
X-Proofpoint-GUID: S3AVKMVvgZal1w_b6SGL-vMMR3McawhA
X-Proofpoint-ORIG-GUID: S3AVKMVvgZal1w_b6SGL-vMMR3McawhA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Add config and transport request related error & info debug
> flags and functions.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr_debug.h | 27 +++++++++++++++++++++++++++
> 1 file changed, 27 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi=
3mr_debug.h
> index 2464c40..ee6edd8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
> @@ -23,9 +23,13 @@
> #define MPI3_DEBUG_RESET		0x00000020
> #define MPI3_DEBUG_SCSI_ERROR		0x00000040
> #define MPI3_DEBUG_REPLY		0x00000080
> +#define MPI3_DEBUG_CFG_ERROR		0x00000100
> +#define MPI3_DEBUG_TRANSPORT_ERROR	0x00000200
> #define MPI3_DEBUG_BSG_ERROR		0x00008000
> #define MPI3_DEBUG_BSG_INFO		0x00010000
> #define MPI3_DEBUG_SCSI_INFO		0x00020000
> +#define MPI3_DEBUG_CFG_INFO		0x00040000
> +#define MPI3_DEBUG_TRANSPORT_INFO	0x00080000
> #define MPI3_DEBUG			0x01000000
> #define MPI3_DEBUG_SG			0x02000000
>=20
> @@ -122,6 +126,29 @@
> 			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> 	} while (0)
>=20
> +#define dprint_cfg_info(ioc, fmt, ...) \
> +	do { \
> +		if (ioc->logging_level & MPI3_DEBUG_CFG_INFO) \
> +			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> +	} while (0)
> +
> +#define dprint_cfg_err(ioc, fmt, ...) \
> +	do { \
> +		if (ioc->logging_level & MPI3_DEBUG_CFG_ERROR) \
> +			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> +	} while (0)
> +#define dprint_transport_info(ioc, fmt, ...) \
> +	do { \
> +		if (ioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO) \
> +			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> +	} while (0)
> +
> +#define dprint_transport_err(ioc, fmt, ...) \
> +	do { \
> +		if (ioc->logging_level & MPI3_DEBUG_TRANSPORT_ERROR) \
> +			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> +	} while (0)
> +
> #endif /* MPT3SAS_DEBUG_H_INCLUDED */
>=20
> /**
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

