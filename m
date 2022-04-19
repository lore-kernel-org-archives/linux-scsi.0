Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC465C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 23:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238639AbiDSXyh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiDSXyg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:54:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296CC2CC8B
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 16:51:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JKsCbR009531;
        Tue, 19 Apr 2022 23:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tZIIJbhVPL/jEDalctsjI4vGztxKrrUBOJZd7iwPGPE=;
 b=PtPpYVGXbzYLA/36SQsEH6ZBboJGfVvDyw6qvexGuj7yotgw2zn6iFKftRpOCSD1qCP7
 BBjjmsCvcoxmc3bIWR6iq9neWWGm9VhxTeQS2En8YdLjgaaJhiM1tgS0JFUJpOXRECHU
 80aRSd6PX6/zDcerUcV7ULjr7BuDNkS6mHqBQRSCR6gruAmSoryWlBY6Je01MvHCpMSR
 Q4mVDWf9+wrtBt+YzrBvR0WncbULsViFel9VtHW6ESiJ1gK83v0j9TFz3BnnrHAiuU6h
 oIuiILhZ0hf0rJ9KZz3C6heGU4rVUDFvKvlnDmk0HCt3BHyxjcD16x/W0zbOf/EB0DSa jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2qggn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 23:51:42 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JNpfJi027347;
        Tue, 19 Apr 2022 23:51:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88uwsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 23:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYT94NSoNAVhvSFsihSDWLQUmeL4pvMJ+SeXUo5bDeySIkzyzPgG7jcZyIZv4SIGKmPs6of3RV7rKMZozq0EhKFyFxKMUK5/Vs3UVfmI8RahEjtyMlgvtTcckOlSYKy70tRcmTDjqeJiU8zzsnPuLKU/IrDKmB9YhtTfpEND93sbIJxCKaSmc0KRze/F66MMJzavz7qHfq/7hoBo135nfyy1SjMPIwlYdqIMhWvIWknA/DlSooSITXxOEO08p29+IDcir0zOdg5p1Cj/f6Rks4AKNlBwDiS/JKoCV6tMbo18qmS6CIlV3wE2FLsJjhroFqRLBYAdPMaj495NlpbXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZIIJbhVPL/jEDalctsjI4vGztxKrrUBOJZd7iwPGPE=;
 b=Msrll01w6m+6ccwikubfxoUbY/eGzmMZHxfFfzq5mBEMf7luwqlmzjNLHJwZKfEM8fa3nlr7lV9btM4TzfnSxBVHxomr4TzQgVwHdkrejbKV8R66UfGB8h1VuoNDuv9TYWazjQUbPBrCPk/ltsWa6fY5eIUmrAoIvZ0uley/302d/smrILj8KV+pMfT5kv5Iq3G7g3Zv+p5Z2z3RH1GLSDdg4M+/35EgBXnVKL5F6T8jfhfmgcf+oTBTg7Qi2pnLohz+RCqz3Xt9AmdZSNVF5HYISLUBcI3G0yDExHsTJgCmJtux/eCvDX51HccBcxF1D5jGW/YPX4ZirYmU8xMWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZIIJbhVPL/jEDalctsjI4vGztxKrrUBOJZd7iwPGPE=;
 b=ReC5FJSdddbgopEaM4H5+IDqz+MyU1UI3szv6OmK0vEi+zYjAUOz4SQg3Q/KxgDNqOI+WcnTavrUlZErGyUsVHG8e2wqCTBC5nQ3w4TmjCmhOLNZYar/DsZ/7wC0kxs1TBE6h59jABcvLumCS0k7lK6MI+z7AdrxdSPDyIec+Fg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5046.namprd10.prod.outlook.com (2603:10b6:408:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 23:51:38 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 23:51:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "prayas.patel@broadcom.com" <prayas.patel@broadcom.com>
Subject: Re: [PATCH v4 5/8] mpi3mr: add support for PEL commands
Thread-Topic: [PATCH v4 5/8] mpi3mr: add support for PEL commands
Thread-Index: AQHYT0cT2jLii2AGnku+2rMXeoEdtqz38kEA
Date:   Tue, 19 Apr 2022 23:51:37 +0000
Message-ID: <98FCBCF4-A3DD-4E4E-9BD8-D0805905173B@oracle.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
 <20220413145652.112271-6-sumit.saxena@broadcom.com>
In-Reply-To: <20220413145652.112271-6-sumit.saxena@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fec37b9-d7e4-4105-29b8-08da225f8b30
x-ms-traffictypediagnostic: BN0PR10MB5046:EE_
x-microsoft-antispam-prvs: <BN0PR10MB5046A3400D81617932310A8EE6F29@BN0PR10MB5046.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SW3WvkF4G9zKFuOQqwCvDBFEG2HbLqBXhrLrzAyIE5M7RD1I+VgVCd3nxvkmK0lhJPafGPcdW0oPuaxfqgvlX6tMFAVj2vDUvWD+L4xV+NFEH+xsORgnro8KbAIcf5k2/dUOQPxiv7Jnrf8TAxF7QWpgKIe48ZOwqJyGBrDnXC0KBgs+eQxvsRcc1W6hCsHDor23qu/GG/3ueV3lbGO0dClWycWLwD37LGGcthFnYJyhQ4VpoQsonogKgW4aC6gvf0OwPNwDh2ns/3t/FvJhCq9y7v6nETtIPr7krg4pFOzXntyfZMHOQC6Gt5XfTIYDCM6J3y5nudcchsMwllaxB8fQNMs0zit9e19rhbpVdBL395tOa5ffU9P+LpZ8okJdUmOzZyo21hQzSIGd4dB2k/pC5SgtJgGuwfnoqIOMCJIwCBuubHHkCY/dSoEDZGKjX5tPgG0qVZH01ng+4Fv14Pp03cUXvQs7rOEJ0skFyQb7ZGBaV6E9ZcYYlY6Jko9JVeE3iQEA+EQ1UXZ3qqut89hb5yfCZ9AbbDUtnZlItcQlge/UKBJKRQJ3hvnJlJv7pKaoaL5FlBndX75GTO/VDFyDZDGDt+fvl56UW7p+kVL6nWaIlxYaT2hNmqeQg/sGenUiWVJNU+JqxnzUfLHzcy+yNSmosk3usnclSFLXCjKyoOV4lkS+YDrAGF+gcrm71+IynZ4jVNiNu9txVVWfvZ2s5GSFJhGzSImh831RNQhpDztaQYl0sWsJuR0es52sDkzHrc8G1HxNFaxYyKIOew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(33656002)(76116006)(44832011)(66476007)(186003)(6916009)(86362001)(2616005)(71200400001)(30864003)(316002)(36756003)(7416002)(5660300002)(6506007)(6512007)(54906003)(66946007)(66446008)(8676002)(38070700005)(91956017)(508600001)(53546011)(83380400001)(122000001)(8936002)(66556008)(6486002)(4326008)(2906002)(64756008)(32563001)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+7D2qKkmeVDGgQWx++D0qjvOGkXxELXny5QnXTQlhiC/kvD18IKNqvS3Lzzf?=
 =?us-ascii?Q?6b5qUzP+B4PFNsVcadCugy5CXCfq5uaxCv8qdZKkQkU5vspP5aA5BvoRaPFf?=
 =?us-ascii?Q?+lp1nfjVVN99J5jKwIOZ6JOtnOn68K+txBAjfu5JnzUT+c4ktmsmpGUrt1dI?=
 =?us-ascii?Q?UhaFHaUE6b6D81L0/IUkMQzg0HALQcdlOt66plU7KivNMn7fgeeeT2zvCmK3?=
 =?us-ascii?Q?piczAOwHmsA7z+Y7nnCwXULrDZ6/28QDLHCDFZp0gOrce8aw/ahJJMh9QLKs?=
 =?us-ascii?Q?4oIhnARNFxSmE47yyyAwPrcMtmTVO/1ieOpWi+9mgYdMiI8gNtvP1TqEeb+Q?=
 =?us-ascii?Q?S3rjFlr5e+bTtC9LM3u229NAGE/2bOn/8g5ylJBywTEE+SwE+ro+7d/1A542?=
 =?us-ascii?Q?5VFpv9cQnohbv/0wx4vAq7QunNCFpS7fHdA4U9U9qGVXF87I/gfFZsASWd/B?=
 =?us-ascii?Q?hk+8EVf0i/z9hy/xMhDCse6hbndTFNx69kEIjLHQMVLVfxMfNGIS9mHPJdEM?=
 =?us-ascii?Q?m/65xFodgQcDfX/wy4lB1kzufgBdMrrBciwDVELCKHUW3T0JrVpfUSrfWkug?=
 =?us-ascii?Q?Ht7UwdduofJb5LmJYLwthhwFwkseXtWgxfcCAxSRHuqcb0WKzDDe8ym9hPyo?=
 =?us-ascii?Q?kR/qSkcqIbHdIml6FYy+e6XT8BZIs8GqeqoJ0c8jRzE790X32thdyri0SAiQ?=
 =?us-ascii?Q?jrniqD3PHjpWNjuWf9NL6+bAKUg2FuTZbO5wuR6bBU/nBOdVMZYf7U2XIobi?=
 =?us-ascii?Q?CIR40w/fBLcrhQYFIi8KdgynVIkiE1WtMrhV0hDyRkvsBlF4fFQDvFbBQz4W?=
 =?us-ascii?Q?bWXGiN7yhnW36UHV1XFDyjwaKaQj+mt32t5O7mmYsl6IwQY6wY1BPE4DxVcu?=
 =?us-ascii?Q?oVww7XiM/kztgl15SvWXLaFNkFSZHHmhYl6ox3JtMx8p9Da0TfH/RoGKq/V8?=
 =?us-ascii?Q?Jqr7GzbZSqucmWYkViAozECQqP+PuUcsDw0avo/Ziy20+yYLuJPUtHHx9w9K?=
 =?us-ascii?Q?rn/lyM7NIvF09X7w2frdr90MEADEfSOAAltBhDD1sjylUnA3ADEckuZVis7R?=
 =?us-ascii?Q?aHYgrvbzhCuzbMem9kQjwgwuY7lV76jgPwwbq9c5mN8cK/HsA7xuiOee89N3?=
 =?us-ascii?Q?pMdUMi2My9mhg37BG7brGQlb8HjeRPtBBahUmQTni/5qe7KH+zwveju3DJAw?=
 =?us-ascii?Q?lQJhE0FAfTpTMC/o7EsWueBuaYxfyWUxcG/h8s7ocFjYUEP7YOxfiFON5hYq?=
 =?us-ascii?Q?6VHq0WkANVU4hx/CZ5f6/mqSGVvUiI7ECHLymONAj4RoxBNXFSRduphN1MuQ?=
 =?us-ascii?Q?a0K4TFun3fzMw9YrbDSWPH8h36rvL2jkNpHROLP1oNvWJOtmjT6f/g8emM3E?=
 =?us-ascii?Q?s9C/9LhKRE8pKssQxSbJTXA+YO4z+EUILDjbt2MYtA0Qk3WES+G7KZ2zwBuA?=
 =?us-ascii?Q?YM6LXUgscCEi9z4Y1jIhnpKE47FExLRse9wqedY3j8+Wve2fwdCVl+Arxmf0?=
 =?us-ascii?Q?uEfoPrgz/yoDNA83j9fnlQiK5Qbtt/Lhk9evWiTYLLPmDVI0S+OFgURgTTMg?=
 =?us-ascii?Q?byBJ2kZWvvs1Eal1pnNGUD/5yc33cCd9L2Ph732CpECYBpLn9Sf7aRljc0C5?=
 =?us-ascii?Q?P/IvW1mrCq0JuVFHCYtf79w9fEa0yTrMYJfcwfX+e8B55GyN1s7IbNEmkslW?=
 =?us-ascii?Q?ZMC+0euuQFIkkJh3TJGlwME2CqWRNR6BjywCf1U8hSsxiEl9ih9VqAjv3Iw3?=
 =?us-ascii?Q?9lnHIciZ9ZLt3CXKrBq7eTeCUUmKHXDjZ+9HUWc5mGyJL+hpr9CgXsHF3X65?=
x-ms-exchange-antispam-messagedata-1: 5Fi80ZPjkJJJ1g==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFF47095A364D740A8A1F9F7311691A6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fec37b9-d7e4-4105-29b8-08da225f8b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 23:51:37.7367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 70l+SRkFzzOd6xsYflgS0cbD3+CKpBFdrX5/7ekQbVLy/qwdqqcm80vctx3GXNka5m7wwHZP4vQLH8CY2NgIeCJDzMNCzBC+4YKbpeiYsg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_08:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190130
X-Proofpoint-GUID: oTbb5AAGTPptHjUHPWXl67Y0kuaXw1PC
X-Proofpoint-ORIG-GUID: oTbb5AAGTPptHjUHPWXl67Y0kuaXw1PC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 13, 2022, at 7:56 AM, Sumit Saxena <sumit.saxena@broadcom.com> wro=
te:
>=20
> This patch includes driver support for the management applications to
> enable the persistent event log(PEL) notification. Upon receipt of events=
,
> driver will increment sysfs variable named as event_counter. Application
> would poll for event_counter value and any change in it would signal the
> applications about events.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h     |  36 +++-
> drivers/scsi/mpi3mr/mpi3mr_app.c | 205 ++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_fw.c  | 310 +++++++++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c  |  42 +++++
> 4 files changed, 592 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 37be9e28e0b2..cc54231da658 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -53,6 +53,7 @@
> extern spinlock_t mrioc_list_lock;
> extern struct list_head mrioc_list;
> extern int prot_mask;
> +extern atomic64_t event_counter;
>=20
> #define MPI3MR_DRIVER_VERSION	"8.0.0.68.0"
> #define MPI3MR_DRIVER_RELDATE	"10-February-2022"
> @@ -91,6 +92,8 @@ extern int prot_mask;
> #define MPI3MR_HOSTTAG_INVALID		0xFFFF
> #define MPI3MR_HOSTTAG_INITCMDS		1
> #define MPI3MR_HOSTTAG_BSG_CMDS		2
> +#define MPI3MR_HOSTTAG_PEL_ABORT	3
> +#define MPI3MR_HOSTTAG_PEL_WAIT		4
> #define MPI3MR_HOSTTAG_BLK_TMS		5
>=20
> #define MPI3MR_NUM_DEVRMCMD		16
> @@ -152,6 +155,7 @@ extern int prot_mask;
>=20
> /* Command retry count definitions */
> #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
> +#define MPI3MR_PEL_RETRY_COUNT 3
>=20
> /* Default target device queue depth */
> #define MPI3MR_DEFAULT_SDEV_QD	32
> @@ -748,6 +752,16 @@ struct scmd_priv {
>  * @current_event: Firmware event currently in process
>  * @driver_info: Driver, Kernel, OS information to firmware
>  * @change_count: Topology change count
> + * @pel_enabled: Persistent Event Log(PEL) enabled or not
> + * @pel_abort_requested: PEL abort is requested or not
> + * @pel_class: PEL Class identifier
> + * @pel_locale: PEL Locale identifier
> + * @pel_cmds: Command tracker for PEL wait command
> + * @pel_abort_cmd: Command tracker for PEL abort command
> + * @pel_newest_seqnum: Newest PEL sequenece number
> + * @pel_seqnum_virt: PEL sequence number virtual address
> + * @pel_seqnum_dma: PEL sequence number DMA address
> + * @pel_seqnum_sz: PEL sequenece number size
>  * @op_reply_q_offset: Operational reply queue offset with MSIx
>  * @default_qcount: Total Default queues
>  * @active_poll_qcount: Currently active poll queue count
> @@ -894,8 +908,20 @@ struct mpi3mr_ioc {
> 	struct mpi3mr_fwevt *current_event;
> 	struct mpi3_driver_info_layout driver_info;
> 	u16 change_count;
> -	u16 op_reply_q_offset;
>=20
> +	u8 pel_enabled;
> +	u8 pel_abort_requested;
> +	u8 pel_class;
> +	u16 pel_locale;
> +	struct mpi3mr_drv_cmd pel_cmds;
> +	struct mpi3mr_drv_cmd pel_abort_cmd;
> +
> +	u32 pel_newest_seqnum;
> +	void *pel_seqnum_virt;
> +	dma_addr_t pel_seqnum_dma;
> +	u32 pel_seqnum_sz;
> +
> +	u16 op_reply_q_offset;
> 	u16 default_qcount;
> 	u16 active_poll_qcount;
> 	u16 requested_poll_qcount;
> @@ -918,6 +944,7 @@ struct mpi3mr_ioc {
>  * @send_ack: Event acknowledgment required or not
>  * @process_evt: Bottomhalf processing required or not
>  * @evt_ctx: Event context to send in Ack
> + * @event_data_size: size of the event data in bytes
>  * @pending_at_sml: waiting for device add/remove API to complete
>  * @discard: discard this event
>  * @ref_count: kref count
> @@ -931,6 +958,7 @@ struct mpi3mr_fwevt {
> 	bool send_ack;
> 	bool process_evt;
> 	u32 evt_ctx;
> +	u16 event_data_size;
> 	bool pending_at_sml;
> 	bool discard;
> 	struct kref ref_count;
> @@ -1022,5 +1050,11 @@ int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 t=
m_type,
> 	u8 *resp_code, struct scsi_cmnd *scmd);
> struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
> 	struct mpi3mr_ioc *mrioc, u16 handle);
> +void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd);
> +int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd);
> +void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> +	u16 event_data_size);
>=20
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 66d4000d8cc5..c5c447defef3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -11,6 +11,95 @@
> #include <linux/bsg-lib.h>
> #include <uapi/scsi/scsi_bsg_mpi3mr.h>
>=20
> +/**
> + * mpi3mr_bsg_pel_abort - sends PEL abort request
> + * @mrioc: Adapter instance reference
> + *
> + * This function sends PEL abort request to the firmware through
> + * admin request queue.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int mpi3mr_bsg_pel_abort(struct mpi3mr_ioc *mrioc)
> +{
> +	struct mpi3_pel_req_action_abort pel_abort_req;
> +	struct mpi3_pel_reply *pel_reply;
> +	int retval =3D 0;
> +	u16 pe_log_status;
> +
> +	if (mrioc->reset_in_progress) {
> +		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
> +		return -1;
> +	}
> +	if (mrioc->stop_bsgs) {
> +		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
> +		return -1;
> +	}
> +
> +	memset(&pel_abort_req, 0, sizeof(pel_abort_req));
> +	mutex_lock(&mrioc->pel_abort_cmd.mutex);
> +	if (mrioc->pel_abort_cmd.state & MPI3MR_CMD_PENDING) {
> +		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
> +		mutex_unlock(&mrioc->pel_abort_cmd.mutex);
> +		return -1;
> +	}
> +	mrioc->pel_abort_cmd.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->pel_abort_cmd.is_waiting =3D 1;
> +	mrioc->pel_abort_cmd.callback =3D NULL;
> +	pel_abort_req.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_PEL_ABORT);
> +	pel_abort_req.function =3D MPI3_FUNCTION_PERSISTENT_EVENT_LOG;
> +	pel_abort_req.action =3D MPI3_PEL_ACTION_ABORT;
> +	pel_abort_req.abort_host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_PEL_WAIT);
> +
> +	mrioc->pel_abort_requested =3D 1;
> +	init_completion(&mrioc->pel_abort_cmd.done);
> +	retval =3D mpi3mr_admin_request_post(mrioc, &pel_abort_req,
> +	    sizeof(pel_abort_req), 0);
> +	if (retval) {
> +		retval =3D -1;
> +		dprint_bsg_err(mrioc, "%s: admin request post failed\n",
> +		    __func__);
> +		mrioc->pel_abort_requested =3D 0;
> +		goto out_unlock;
> +	}
> +
> +	wait_for_completion_timeout(&mrioc->pel_abort_cmd.done,
> +	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
> +	if (!(mrioc->pel_abort_cmd.state & MPI3MR_CMD_COMPLETE)) {
> +		mrioc->pel_abort_cmd.is_waiting =3D 0;
> +		dprint_bsg_err(mrioc, "%s: command timedout\n", __func__);
> +		if (!(mrioc->pel_abort_cmd.state & MPI3MR_CMD_RESET))
> +			mpi3mr_soft_reset_handler(mrioc,
> +			    MPI3MR_RESET_FROM_PELABORT_TIMEOUT, 1);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	if ((mrioc->pel_abort_cmd.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	     !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		dprint_bsg_err(mrioc,
> +		    "%s: command failed, ioc_status(0x%04x) log_info(0x%08x)\n",
> +		    __func__, (mrioc->pel_abort_cmd.ioc_status &
> +		    MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->pel_abort_cmd.ioc_loginfo);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	if (mrioc->pel_abort_cmd.state & MPI3MR_CMD_REPLY_VALID) {
> +		pel_reply =3D (struct mpi3_pel_reply *)mrioc->pel_abort_cmd.reply;
> +		pe_log_status =3D le16_to_cpu(pel_reply->pe_log_status);
> +		if (pe_log_status !=3D MPI3_PEL_STATUS_SUCCESS) {
> +			dprint_bsg_err(mrioc,
> +			    "%s: command failed, pel_status(0x%04x)\n",
> +			    __func__, pe_log_status);
> +			retval =3D -1;
> +		}
> +	}
> +
> +out_unlock:
> +	mrioc->pel_abort_cmd.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->pel_abort_cmd.mutex);
> +	return retval;
> +}
> /**
>  * mpi3mr_bsg_verify_adapter - verify adapter number is valid
>  * @ioc_number: Adapter number
> @@ -108,6 +197,87 @@ static long mpi3mr_get_logdata(struct mpi3mr_ioc *mr=
ioc,
> 	return -EINVAL;
> }
>=20
> +/**
> + * mpi3mr_bsg_pel_enable - Handler for PEL enable driver
> + * @mrioc: Adapter instance reference
> + * @job: BSG job pointer
> + *
> + * This function is the handler for PEL enable driver.
> + * Validates the application given class and locale and if
> + * requires aborts the existing PEL wait request and/or issues
> + * new PEL wait request to the firmware and returns.
> + *
> + * Return: 0 on success and proper error codes on failure.
> + */
> +static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
> +				  struct bsg_job *job)
> +{
> +	long rval =3D -EINVAL;
> +	struct mpi3mr_bsg_out_pel_enable pel_enable;
> +	u8 issue_pel_wait;
> +	u8 tmp_class;
> +	u16 tmp_locale;
> +
> +	if (job->request_payload.payload_len !=3D sizeof(pel_enable)) {
> +		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
> +		    __func__);
> +		return rval;
> +	}
> +
> +	sg_copy_to_buffer(job->request_payload.sg_list,
> +			  job->request_payload.sg_cnt,
> +			  &pel_enable, sizeof(pel_enable));
> +
> +	if (pel_enable.pel_class > MPI3_PEL_CLASS_FAULT) {
> +		dprint_bsg_err(mrioc, "%s: out of range class %d sent\n",
> +			__func__, pel_enable.pel_class);
> +		rval =3D 0;
> +		goto out;
> +	}
> +	if (!mrioc->pel_enabled)
> +		issue_pel_wait =3D 1;
> +	else {
> +		if ((mrioc->pel_class <=3D pel_enable.pel_class) &&
> +		    !((mrioc->pel_locale & pel_enable.pel_locale) ^
> +		      pel_enable.pel_locale)) {
> +			issue_pel_wait =3D 0;
> +			rval =3D 0;
> +		} else {
> +			pel_enable.pel_locale |=3D mrioc->pel_locale;
> +
> +			if (mrioc->pel_class < pel_enable.pel_class)
> +				pel_enable.pel_class =3D mrioc->pel_class;
> +
> +			rval =3D mpi3mr_bsg_pel_abort(mrioc);
> +			if (rval) {
> +				dprint_bsg_err(mrioc,
> +				    "%s: pel_abort failed, status(%ld)\n",
> +				    __func__, rval);
> +				goto out;
> +			}
> +			issue_pel_wait =3D 1;
> +		}
> +	}
> +	if (issue_pel_wait) {
> +		tmp_class =3D mrioc->pel_class;
> +		tmp_locale =3D mrioc->pel_locale;
> +		mrioc->pel_class =3D pel_enable.pel_class;
> +		mrioc->pel_locale =3D pel_enable.pel_locale;
> +		mrioc->pel_enabled =3D 1;
> +		rval =3D mpi3mr_pel_get_seqnum_post(mrioc, NULL);
> +		if (rval) {
> +			mrioc->pel_class =3D tmp_class;
> +			mrioc->pel_locale =3D tmp_locale;
> +			mrioc->pel_enabled =3D 0;
> +			dprint_bsg_err(mrioc,
> +			    "%s: pel get sequence number failed, status(%ld)\n",
> +			    __func__, rval);
> +		}
> +	}
> +
> +out:
> +	return rval;
> +}
> /**
>  * mpi3mr_get_all_tgt_info - Get all target information
>  * @mrioc: Adapter instance reference
> @@ -374,6 +544,9 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_jo=
b *job)
> 	case MPI3MR_DRVBSG_OPCODE_GETLOGDATA:
> 		rval =3D mpi3mr_get_logdata(mrioc, job);
> 		break;
> +	case MPI3MR_DRVBSG_OPCODE_PELENABLE:
> +		rval =3D mpi3mr_bsg_pel_enable(mrioc, job);
> +		break;
> 	case MPI3MR_DRVBSG_OPCODE_UNKNOWN:
> 	default:
> 		pr_err("%s: unsupported driver command opcode %d\n",
> @@ -899,6 +1072,38 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job, unsigned int *reply
> 	return rval;
> }
>=20
> +/**
> + * mpi3mr_app_save_logdata - Save Log Data events
> + * @mrioc: Adapter instance reference
> + * @event_data: event data associated with log data event
> + * @event_data_size: event data size to copy
> + *
> + * If log data event caching is enabled by the applicatiobns,
> + * then this function saves the log data in the circular queue
> + * and Sends async signal SIGIO to indicate there is an async
> + * event from the firmware to the event monitoring applications.
> + *
> + * Return:Nothing
> + */
> +void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> +	u16 event_data_size)
> +{
> +	u32 index =3D mrioc->logdata_buf_idx, sz;
> +	struct mpi3mr_logdata_entry *entry;
> +
> +	if (!(mrioc->logdata_buf))
> +		return;
> +
> +	entry =3D (struct mpi3mr_logdata_entry *)
> +		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
> +	entry->valid_entry =3D 1;
> +	sz =3D min(mrioc->logdata_entry_sz, event_data_size);
> +	memcpy(entry->data, event_data, sz);
> +	mrioc->logdata_buf_idx =3D
> +		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);
> +	atomic64_inc(&event_counter);
> +}
> +
> /**
>  * mpi3mr_bsg_request - bsg request entry point
>  * @job: BSG job reference
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 480730721f50..74e09727a1b8 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -15,6 +15,8 @@ mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_=
type, u32 reset_reason);
> static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
> static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
> 	struct mpi3_ioc_facts_data *facts_data);
> +static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd);
>=20
> static int poll_queues;
> module_param(poll_queues, int, 0444);
> @@ -301,6 +303,10 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 hos=
t_tag,
> 		return &mrioc->bsg_cmds;
> 	case MPI3MR_HOSTTAG_BLK_TMS:
> 		return &mrioc->host_tm_cmds;
> +	case MPI3MR_HOSTTAG_PEL_ABORT:
> +		return &mrioc->pel_abort_cmd;
> +	case MPI3MR_HOSTTAG_PEL_WAIT:
> +		return &mrioc->pel_cmds;
> 	case MPI3MR_HOSTTAG_INVALID:
> 		if (def_reply && def_reply->function =3D=3D
> 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
> @@ -2837,6 +2843,14 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mp=
i3mr_ioc *mrioc)
> 	if (!mrioc->host_tm_cmds.reply)
> 		goto out_failed;
>=20
> +	mrioc->pel_cmds.reply =3D kzalloc(mrioc->reply_sz, GFP_KERNEL);
> +	if (!mrioc->pel_cmds.reply)
> +		goto out_failed;
> +
> +	mrioc->pel_abort_cmd.reply =3D kzalloc(mrioc->reply_sz, GFP_KERNEL);
> +	if (!mrioc->pel_abort_cmd.reply)
> +		goto out_failed;
> +
> 	mrioc->dev_handle_bitmap_sz =3D mrioc->facts.max_devhandle / 8;
> 	if (mrioc->facts.max_devhandle % 8)
> 		mrioc->dev_handle_bitmap_sz++;
> @@ -3734,6 +3748,16 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 		goto out_failed;
> 	}
>=20
> +	if (!mrioc->pel_seqnum_virt) {
> +		dprint_init(mrioc, "allocating memory for pel_seqnum_virt\n");
> +		mrioc->pel_seqnum_sz =3D sizeof(struct mpi3_pel_seq);
> +		mrioc->pel_seqnum_virt =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
> +		    GFP_KERNEL);
> +		if (!mrioc->pel_seqnum_virt)
> +			goto out_failed_noretry;
> +	}
> +
> 	retval =3D mpi3mr_enable_events(mrioc);
> 	if (retval) {
> 		ioc_err(mrioc, "failed to enable events %d\n",
> @@ -3843,6 +3867,16 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8=
 is_resume)
> 		goto out_failed;
> 	}
>=20
> +	if (!mrioc->pel_seqnum_virt) {
> +		dprint_reset(mrioc, "allocating memory for pel_seqnum_virt\n");
> +		mrioc->pel_seqnum_sz =3D sizeof(struct mpi3_pel_seq);
> +		mrioc->pel_seqnum_virt =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
> +		    GFP_KERNEL);
> +		if (!mrioc->pel_seqnum_virt)
> +			goto out_failed_noretry;
> +	}
> +
> 	if (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q) {
> 		ioc_err(mrioc,
> 		    "cannot create minimum number of operational queues expected:%d cre=
ated:%d\n",
> @@ -3958,6 +3992,10 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrio=
c)
> 		    sizeof(*mrioc->bsg_cmds.reply));
> 		memset(mrioc->host_tm_cmds.reply, 0,
> 		    sizeof(*mrioc->host_tm_cmds.reply));
> +		memset(mrioc->pel_cmds.reply, 0,
> +		    sizeof(*mrioc->pel_cmds.reply));
> +		memset(mrioc->pel_abort_cmd.reply, 0,
> +		    sizeof(*mrioc->pel_abort_cmd.reply));
> 		for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> 			memset(mrioc->dev_rmhs_cmds[i].reply, 0,
> 			    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
> @@ -4064,6 +4102,12 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
> 	kfree(mrioc->host_tm_cmds.reply);
> 	mrioc->host_tm_cmds.reply =3D NULL;
>=20
> +	kfree(mrioc->pel_cmds.reply);
> +	mrioc->pel_cmds.reply =3D NULL;
> +
> +	kfree(mrioc->pel_abort_cmd.reply);
> +	mrioc->pel_abort_cmd.reply =3D NULL;
> +
> 	for (i =3D 0; i < MPI3MR_NUM_EVTACKCMD; i++) {
> 		kfree(mrioc->evtack_cmds[i].reply);
> 		mrioc->evtack_cmds[i].reply =3D NULL;
> @@ -4112,6 +4156,16 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
> 		    mrioc->admin_req_base, mrioc->admin_req_dma);
> 		mrioc->admin_req_base =3D NULL;
> 	}
> +
> +	if (mrioc->pel_seqnum_virt) {
> +		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
> +		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
> +		mrioc->pel_seqnum_virt =3D NULL;
> +	}
> +
> +	kfree(mrioc->logdata_buf);
> +	mrioc->logdata_buf =3D NULL;
> +
> }
>=20
> /**
> @@ -4260,6 +4314,254 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_i=
oc *mrioc)
> 		cmdptr =3D &mrioc->evtack_cmds[i];
> 		mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> 	}
> +
> +	cmdptr =3D &mrioc->pel_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +
> +	cmdptr =3D &mrioc->pel_abort_cmd;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +
> +}
> +
> +/**
> + * mpi3mr_pel_wait_post - Issue PEL Wait
> + * @mrioc: Adapter instance reference
> + * @drv_cmd: Internal command tracker
> + *
> + * Issue PEL Wait MPI request through admin queue and return.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_pel_wait_post(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd)
> +{
> +	struct mpi3_pel_req_action_wait pel_wait;
> +
> +	mrioc->pel_abort_requested =3D false;
> +
> +	memset(&pel_wait, 0, sizeof(pel_wait));
> +	drv_cmd->state =3D MPI3MR_CMD_PENDING;
> +	drv_cmd->is_waiting =3D 0;
> +	drv_cmd->callback =3D mpi3mr_pel_wait_complete;
> +	drv_cmd->ioc_status =3D 0;
> +	drv_cmd->ioc_loginfo =3D 0;
> +	pel_wait.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_PEL_WAIT);
> +	pel_wait.function =3D MPI3_FUNCTION_PERSISTENT_EVENT_LOG;
> +	pel_wait.action =3D MPI3_PEL_ACTION_WAIT;
> +	pel_wait.starting_sequence_number =3D cpu_to_le32(mrioc->pel_newest_seq=
num);
> +	pel_wait.locale =3D cpu_to_le16(mrioc->pel_locale);
> +	pel_wait.class =3D cpu_to_le16(mrioc->pel_class);
> +	pel_wait.wait_time =3D MPI3_PEL_WAITTIME_INFINITE_WAIT;
> +	dprint_bsg_info(mrioc, "sending pel_wait seqnum(%d), class(%d), locale(=
0x%08x)\n",
> +	    mrioc->pel_newest_seqnum, mrioc->pel_class, mrioc->pel_locale);
> +
> +	if (mpi3mr_admin_request_post(mrioc, &pel_wait, sizeof(pel_wait), 0)) {
> +		dprint_bsg_err(mrioc,
> +			    "Issuing PELWait: Admin post failed\n");
> +		drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +		drv_cmd->callback =3D NULL;
> +		drv_cmd->retry_count =3D 0;
> +		mrioc->pel_enabled =3D false;
> +	}
> +}
> +
> +/**
> + * mpi3mr_pel_get_seqnum_post - Issue PEL Get Sequence number
> + * @mrioc: Adapter instance reference
> + * @drv_cmd: Internal command tracker
> + *
> + * Issue PEL get sequence number MPI request through admin queue
> + * and return.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd)
> +{
> +	struct mpi3_pel_req_action_get_sequence_numbers pel_getseq_req;
> +	u8 sgl_flags =3D MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
> +	int retval =3D 0;
> +
> +	memset(&pel_getseq_req, 0, sizeof(pel_getseq_req));
> +	mrioc->pel_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->pel_cmds.is_waiting =3D 0;
> +	mrioc->pel_cmds.ioc_status =3D 0;
> +	mrioc->pel_cmds.ioc_loginfo =3D 0;
> +	mrioc->pel_cmds.callback =3D mpi3mr_pel_get_seqnum_complete;
> +	pel_getseq_req.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_PEL_WAIT);
> +	pel_getseq_req.function =3D MPI3_FUNCTION_PERSISTENT_EVENT_LOG;
> +	pel_getseq_req.action =3D MPI3_PEL_ACTION_GET_SEQNUM;
> +	mpi3mr_add_sg_single(&pel_getseq_req.sgl, sgl_flags,
> +	    mrioc->pel_seqnum_sz, mrioc->pel_seqnum_dma);
> +
> +	retval =3D mpi3mr_admin_request_post(mrioc, &pel_getseq_req,
> +			sizeof(pel_getseq_req), 0);
> +	if (retval) {
> +		if (drv_cmd) {
> +			drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +			drv_cmd->callback =3D NULL;
> +			drv_cmd->retry_count =3D 0;
> +		}
> +		mrioc->pel_enabled =3D false;
> +	}
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_pel_wait_complete - PELWait Completion callback
> + * @mrioc: Adapter instance reference
> + * @drv_cmd: Internal command tracker
> + *
> + * This is a callback handler for the PELWait request and
> + * firmware completes a PELWait request when it is aborted or a
> + * new PEL entry is available. This sends AEN to the application
> + * and if the PELwait completion is not due to PELAbort then
> + * this will send a request for new PEL Sequence number
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd)
> +{
> +	struct mpi3_pel_reply *pel_reply =3D NULL;
> +	u16 ioc_status, pe_log_status;
> +	bool do_retry =3D false;
> +
> +	if (drv_cmd->state & MPI3MR_CMD_RESET)
> +		goto cleanup_drv_cmd;
> +
> +	ioc_status =3D drv_cmd->ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc, "%s: Failed ioc_status(0x%04x) Loginfo(0x%08x)\n",
> +			__func__, ioc_status, drv_cmd->ioc_loginfo);
> +		dprint_bsg_err(mrioc,
> +		    "pel_wait: failed with ioc_status(0x%04x), log_info(0x%08x)\n",
> +		    ioc_status, drv_cmd->ioc_loginfo);
> +		do_retry =3D true;
> +	}
> +
> +	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
> +		pel_reply =3D (struct mpi3_pel_reply *)drv_cmd->reply;
> +
> +	if (!pel_reply) {
> +		dprint_bsg_err(mrioc,
> +		    "pel_wait: failed due to no reply\n");
> +		goto out_failed;
> +	}
> +
> +	pe_log_status =3D le16_to_cpu(pel_reply->pe_log_status);
> +	if ((pe_log_status !=3D MPI3_PEL_STATUS_SUCCESS) &&
> +	    (pe_log_status !=3D MPI3_PEL_STATUS_ABORTED)) {
> +		ioc_err(mrioc, "%s: Failed pe_log_status(0x%04x)\n",
> +			__func__, pe_log_status);
> +		dprint_bsg_err(mrioc,
> +		    "pel_wait: failed due to pel_log_status(0x%04x)\n",
> +		    pe_log_status);
> +		do_retry =3D true;
> +	}
> +
> +	if (do_retry) {
> +		if (drv_cmd->retry_count < MPI3MR_PEL_RETRY_COUNT) {
> +			drv_cmd->retry_count++;
> +			dprint_bsg_err(mrioc, "pel_wait: retrying(%d)\n",
> +			    drv_cmd->retry_count);
> +			mpi3mr_pel_wait_post(mrioc, drv_cmd);
> +			return;
> +		}
> +		dprint_bsg_err(mrioc,
> +		    "pel_wait: failed after all retries(%d)\n",
> +		    drv_cmd->retry_count);
> +		goto out_failed;
> +	}
> +	atomic64_inc(&event_counter);
> +	if (!mrioc->pel_abort_requested) {
> +		mrioc->pel_cmds.retry_count =3D 0;
> +		mpi3mr_pel_get_seqnum_post(mrioc, &mrioc->pel_cmds);
> +	}
> +
> +	return;
> +out_failed:
> +	mrioc->pel_enabled =3D false;
> +cleanup_drv_cmd:
> +	drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +	drv_cmd->callback =3D NULL;
> +	drv_cmd->retry_count =3D 0;
> +}
> +
> +/**
> + * mpi3mr_pel_get_seqnum_complete - PELGetSeqNum Completion callback
> + * @mrioc: Adapter instance reference
> + * @drv_cmd: Internal command tracker
> + *
> + * This is a callback handler for the PEL get sequence number
> + * request and a new PEL wait request will be issued to the
> + * firmware from this
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd)
> +{
> +	struct mpi3_pel_reply *pel_reply =3D NULL;
> +	struct mpi3_pel_seq *pel_seqnum_virt;
> +	u16 ioc_status;
> +	bool do_retry =3D false;
> +
> +	pel_seqnum_virt =3D (struct mpi3_pel_seq *)mrioc->pel_seqnum_virt;
> +
> +	if (drv_cmd->state & MPI3MR_CMD_RESET)
> +		goto cleanup_drv_cmd;
> +
> +	ioc_status =3D drv_cmd->ioc_status & MPI3_IOCSTATUS_STATUS_MASK;
> +	if (ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		dprint_bsg_err(mrioc,
> +		    "pel_get_seqnum: failed with ioc_status(0x%04x), log_info(0x%08x)\=
n",
> +		    ioc_status, drv_cmd->ioc_loginfo);
> +		do_retry =3D true;
> +	}
> +
> +	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
> +		pel_reply =3D (struct mpi3_pel_reply *)drv_cmd->reply;
> +	if (!pel_reply) {
> +		dprint_bsg_err(mrioc,
> +		    "pel_get_seqnum: failed due to no reply\n");
> +		goto out_failed;
> +	}
> +
> +	if (le16_to_cpu(pel_reply->pe_log_status) !=3D MPI3_PEL_STATUS_SUCCESS)=
 {
> +		dprint_bsg_err(mrioc,
> +		    "pel_get_seqnum: failed due to pel_log_status(0x%04x)\n",
> +		    le16_to_cpu(pel_reply->pe_log_status));
> +		do_retry =3D true;
> +	}
> +
> +	if (do_retry) {
> +		if (drv_cmd->retry_count < MPI3MR_PEL_RETRY_COUNT) {
> +			drv_cmd->retry_count++;
> +			dprint_bsg_err(mrioc,
> +			    "pel_get_seqnum: retrying(%d)\n",
> +			    drv_cmd->retry_count);
> +			mpi3mr_pel_get_seqnum_post(mrioc, drv_cmd);
> +			return;
> +		}
> +
> +		dprint_bsg_err(mrioc,
> +		    "pel_get_seqnum: failed after all retries(%d)\n",
> +		    drv_cmd->retry_count);
> +		goto out_failed;
> +	}
> +	mrioc->pel_newest_seqnum =3D le32_to_cpu(pel_seqnum_virt->newest) + 1;
> +	drv_cmd->retry_count =3D 0;
> +	mpi3mr_pel_wait_post(mrioc, drv_cmd);
> +
> +	return;
> +out_failed:
> +	mrioc->pel_enabled =3D false;
> +cleanup_drv_cmd:
> +	drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +	drv_cmd->callback =3D NULL;
> +	drv_cmd->retry_count =3D 0;
> }
>=20
> /**
> @@ -4383,6 +4685,12 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *m=
rioc,
> 	if (!retval) {
> 		mrioc->diagsave_timeout =3D 0;
> 		mrioc->reset_in_progress =3D 0;
> +		mrioc->pel_abort_requested =3D 0;
> +		if (mrioc->pel_enabled) {
> +			mrioc->pel_cmds.retry_count =3D 0;
> +			mpi3mr_pel_wait_post(mrioc, &mrioc->pel_cmds);
> +		}
> +
> 		mpi3mr_rfresh_tgtdevs(mrioc);
> 		mrioc->ts_update_counter =3D 0;
> 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> @@ -4392,6 +4700,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mr=
ioc,
> 			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> 		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> 		mrioc->stop_bsgs =3D 0;
> +		if (mrioc->pel_enabled)
> +			atomic64_inc(&event_counter);
> 	} else {
> 		mpi3mr_issue_reset(mrioc,
> 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 450574fc1fec..19298136edb6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -14,6 +14,7 @@ LIST_HEAD(mrioc_list);
> DEFINE_SPINLOCK(mrioc_list_lock);
> static int mrioc_ids;
> static int warn_non_secure_ctlr;
> +atomic64_t event_counter;
>=20
> MODULE_AUTHOR(MPI3MR_DRIVER_AUTHOR);
> MODULE_DESCRIPTION(MPI3MR_DRIVER_DESC);
> @@ -1415,6 +1416,23 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3m=
r_ioc *mrioc,
> 	}
> }
>=20
> +/**
> + * mpi3mr_logdata_evt_bh -  Log data event bottomhalf
> + * @mrioc: Adapter instance reference
> + * @fwevt: Firmware event reference
> + *
> + * Extracts the event data and calls application interfacing
> + * function to process the event further.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_logdata_evt_bh(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_fwevt *fwevt)
> +{
> +	mpi3mr_app_save_logdata(mrioc, fwevt->event_data,
> +	    fwevt->event_data_size);
> +}
> +
> /**
>  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
>  * @mrioc: Adapter instance reference
> @@ -1467,6 +1485,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mri=
oc,
> 		mpi3mr_pcietopochg_evt_bh(mrioc, fwevt);
> 		break;
> 	}
> +	case MPI3_EVENT_LOG_DATA:
> +	{
> +		mpi3mr_logdata_evt_bh(mrioc, fwevt);
> +		break;
> +	}
> 	default:
> 		break;
> 	}
> @@ -2298,6 +2321,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mri=
oc,
> 		break;
> 	}
> 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
> +	case MPI3_EVENT_LOG_DATA:
> 	{
> 		process_evt_bh =3D 1;
> 		break;
> @@ -4568,6 +4592,12 @@ static struct pci_driver mpi3mr_pci_driver =3D {
> #endif
> };
>=20
> +static ssize_t event_counter_show(struct device_driver *dd, char *buf)
> +{
> +	return sprintf(buf, "%llu\n", atomic64_read(&event_counter));
> +}
> +static DRIVER_ATTR_RO(event_counter);
> +
> static int __init mpi3mr_init(void)
> {
> 	int ret_val;
> @@ -4576,6 +4606,16 @@ static int __init mpi3mr_init(void)
> 	    MPI3MR_DRIVER_VERSION);
>=20
> 	ret_val =3D pci_register_driver(&mpi3mr_pci_driver);
> +	if (ret_val) {
> +		pr_err("%s failed to load due to pci register driver failure\n",
> +		    MPI3MR_DRIVER_NAME);
> +		return ret_val;
> +	}
> +
> +	ret_val =3D driver_create_file(&mpi3mr_pci_driver.driver,
> +				     &driver_attr_event_counter);
> +	if (ret_val)
> +		pci_unregister_driver(&mpi3mr_pci_driver);
>=20
> 	return ret_val;
> }
> @@ -4590,6 +4630,8 @@ static void __exit mpi3mr_exit(void)
> 		pr_info("Unloading %s version %s\n", MPI3MR_DRIVER_NAME,
> 		    MPI3MR_DRIVER_VERSION);
>=20
> +	driver_remove_file(&mpi3mr_pci_driver.driver,
> +			   &driver_attr_event_counter);
> 	pci_unregister_driver(&mpi3mr_pci_driver);
> }
>=20
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

