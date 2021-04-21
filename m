Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468EBC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19D3761360
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242542AbhDURLR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:11:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242581AbhDURLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 13:11:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LGkQV4012041;
        Wed, 21 Apr 2021 17:05:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xGlglqti93UDhdClChQlRTJ/kJFeHnh+SMtQlaBD/48=;
 b=mIS2eSse1RnztuZEQ4xfso2HxdMDDJXI30zbz9DdjvPIzeA0diA/hvBa5Bp22Qzo2WKb
 tpvAud02mivN8QdDa5MI9BcU6tsF49SqKMRqGEKzjE1KAJ1byOswt7c7ViDLpHGC/TIG
 9cnrUw76bWvKwH8JsQ/FyUqLidNFL6mHr81ZqBZ7B1/s/LvbJYC4XntbISxpKZ9H3pe7
 MQChk+gujZ+f3qqZ+h/kFFYmNmwGBObsZfbvWVZ7Kq/jo5SfIz4eAC6pKlNByChi/dT6
 w1JBAETrOSZI0CvqBqpr7nNR3/I21L7fJI/lu1wkUTnIJiQGEVh3enJret7pUen0EOZn eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37yveajnqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 17:05:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LH505g122440;
        Wed, 21 Apr 2021 17:05:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 38098s0wf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 17:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OS8acfifnUcF/L3VVyHuQuxIjtpfVRZNqyAleILd2XGIIj3zmI5VtqUcVb1z8GLp6o+geyZKGEd1L3k56WaL0gnKqRRN11jNzG97YbjEDOunBPeM7Oa9i1bmeegpefKrfLfBz/KqQkU89eBshDQbhGAJAZkjioHMvtB5bzI8nRJl7ZCyX7kjK6eglmPXS4uhhPZAgTJyW9fsnq/uZuZWqeJ9aYkE6bnsKYC9/vxywkvqG/AV/YZHauM96me7jBufwZZdpxdhJ9pz7IdHphQUOUeiNxK6uJYXv+HW8X2dLVt6af+rAmh0aUNJ+Z2bvkKTOsQvvP7WnmfrlpJ0bZ+Qgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGlglqti93UDhdClChQlRTJ/kJFeHnh+SMtQlaBD/48=;
 b=UFt3Z6VQpblk925HRKYJSgd32J8YgKSYaWZDRcz5YqIqxKzdabZHFR4pC5cTYwEQgEKdd/stKp0LHTsTW/ObiCtzYex/0NiRVsCDUalwjUvaH3oS9sNwywxcuh84UgTbPTNLQnoNW86SVZ8CbPQJ5rMVuFeii/CDSW77LBIw1faYRJ6AEUlUpGUJiNCb7vB2cmlTQqyD3zm3iqpW9rFJKKr4msCx14zr4u9l88Ekb29zpcBEf0aCua0GAM1/cGzbs/Ie2XDpeGQVorkaExOurO4EHcW7FsaXkLbvgTrA286qpfLrOJtH/6LpF4R3sZ4sksOOcuEhawJYnz7qjRtkjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGlglqti93UDhdClChQlRTJ/kJFeHnh+SMtQlaBD/48=;
 b=iqzZbqYMhkWARbDqoZ+hZgnHQvbXuIoPXmJdmQHymmqoueoA61DECrrZrhqaygDCb6D0oxm4ofrpB50TibCVxy+DahOt4gcUxjro+5r/yFdLViw8N6ZPBC+4oB0TUchK7JsS1p1L3HE+gYHBQzyPWoV5eirQX5Yd8AfXoBY5YUc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2720.namprd10.prod.outlook.com (2603:10b6:805:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 17:05:27 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 17:05:27 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 03/24] mpi3mr: create operational request and reply
 queue pair
Thread-Topic: [PATCH v3 03/24] mpi3mr: create operational request and reply
 queue pair
Thread-Index: AQHXNQt+XQ3FT6a9bUSdOLRhnPUKmaq/NvUA
Date:   Wed, 21 Apr 2021 17:05:27 +0000
Message-ID: <6F6E49D7-A4E5-4FF2-B5F3-AB830F90F578@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-4-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-4-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab0b06e7-61aa-48c0-2c26-08d904e7a95d
x-ms-traffictypediagnostic: SN6PR10MB2720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2720A49642DF8F05B8911D16E6479@SN6PR10MB2720.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XnxYUESmtF7Ikl9M33e7Zh+id38kE9bRmCCBPGVqWff0jwpby8l8GbT+YvUSo3TCPI2gMTDz4kFzRQ2srOwrVBz3HQV1SpdBJjWvlPQi7dkbLAqEvAVKHDEmKkEPjtB/j2O4ADfz7i3sGG5ANai75vwxheDhzakBFyaNR8BPSzBKYEku6yWnzdtPULqvgO/K5DRsChN145N520zC9j4CraZ61lyUOOi7qDUIlf4guLN/VrcY813LJ/OA6DZBfq4r2CmR8TUbXD2zfOUAqP+OcnlZRT0uH340Q2IxkmNnrAL8ZKvi6y1trHEBKwTMEM9pw1ZwchCwJPBs6N0+PLkZPSeOu30NGDqN8Lkd9vXaEOi0Q+dHYhtiiEs337y8rDIEKUoZOtPjuOnX4Jy3UdRrA31HNYBug+gf3aS/gGxZC2V8xRIrzFXLxIzHxTtFGOiKtqV99Gw0WSv+EYMV+2z1AoXWMw6rjTeG6iBhgedMYbj1/isRtpzPRrC19oQMgYPTvmxZD+ondXnakyOZ2qq6LDm9dira5uBDQBPpC/KfRe7udGbpgSc5fS4AzElnh8NYUpRyhQ/w57P5Y11PpJooDo+qz6Eu0HURplOfsY3obATWSczIRz7g9m1do1blA3kscEesBOg9Ubno9XEGFxvYtfQeCmKb4h9su5rZmTvqfHHcNTprE6zm6xFLf0EMLDcs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39860400002)(346002)(366004)(19627235002)(86362001)(6916009)(186003)(5660300002)(6512007)(76116006)(478600001)(66446008)(2906002)(2616005)(30864003)(83380400001)(44832011)(53546011)(6506007)(26005)(122000001)(54906003)(33656002)(71200400001)(6486002)(316002)(66946007)(8676002)(64756008)(36756003)(66556008)(8936002)(4326008)(66476007)(38100700002)(32563001)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?roR50jcMwQRzEIBON0POzEudKEHRGpUNTwRsWXQz93c5TAax0hs0gra7GfBo?=
 =?us-ascii?Q?ly7IaR0oekR+ZpR9U/8bgVodRjzHmgVg8r+3XsU0Gfk8Phh+mEfU0+dAnKTU?=
 =?us-ascii?Q?hCEWQbXAr6zJQR/T+3CWcnvTr2QozBhActR/3y++p/f9T0+D7wEBauI9udk1?=
 =?us-ascii?Q?tlx/MeWdYHpNA+UmcwCGlGWXqV3dOjyLQUjJVVTTHEHRiu0uWXsbw90KAGY2?=
 =?us-ascii?Q?HlINDHQ1wCZtSs4WCSfUOrSjC4WJD16FNafQaTjjirNdQFjks3FM2iOdZfez?=
 =?us-ascii?Q?HSZAXTXLN1W4DO4mpP4wYGPxVHOtvI4X0VCRQTcDVHBwyDtSDxAdTM/gYM9h?=
 =?us-ascii?Q?PAiCISV8bLvbjGxLt0PLhdeVezM3xydQWuGw1RgavVtod6U8O/Ip98hGuJ2O?=
 =?us-ascii?Q?6lkFFEbTXkmgVboJRQW6zhxSdfVn1cjIZafCxYDTB8flpfgKK5LYcWVpSGGk?=
 =?us-ascii?Q?axtUkwf0OMakqm9L5oVPPWQ7lwjLZ9vuLzLr+85S90u5+23WCWF8y5RHvUF8?=
 =?us-ascii?Q?xWO599kBdLjJEbmFY1rlwNTcYfq7AmoxuzmUUxiAGoqpgdVixR4SlUlWpXYc?=
 =?us-ascii?Q?VO79nc+Xy/oS2wfRirKSdEQFYY1etsQW2Ced9cd5UdcBkitgMgsx23xXyOHz?=
 =?us-ascii?Q?kHABJyaJ1U4bnMchoYdMoArC/v/gPa0fly/Fh/w+PuEoKLUsnxaXZkhfaxOS?=
 =?us-ascii?Q?exEXPseWhrVhB5nlAWBWYLG0y2rCCRdidVmih2wQcBC3SpxzipOUWGVQLAz6?=
 =?us-ascii?Q?tSSfvE/SonCjJdKmpyMCPlWfj/LKC4Bl75FO99cz05nfeIUcZSZi1CVZTtlR?=
 =?us-ascii?Q?09Jcc6u1wpumbjAduEbOkM9wKgDFEHB2K3QmQxznbbjZMQbne5TJ1NZuvbkX?=
 =?us-ascii?Q?SUoj7cXXcEWqoHKO18gjaJIjBgzdgjchQYsZkwOPluC308Hr+dRw6PWOVE1u?=
 =?us-ascii?Q?BSV4EVRd2Kwdi0A9cb4uk8BYE7Bxv50IiW5GppuCknXwM41xeJi9fNgt2M8/?=
 =?us-ascii?Q?M8i/Kihkn03dzDWjQEalg/S9kN+xoMUy1MW81jDeRmVPrlLPaNyQwLoDU5Ny?=
 =?us-ascii?Q?8q0zxaTue1ve3vdrTj+IBuZiclnJCti7s7S129iLvPRs10EzfXj+tB4yHius?=
 =?us-ascii?Q?EANqAvKRlud+Bkdanmmrlik80+HRGnv9VNyzoQPDN7CVYGFzzkmozO1PrvMv?=
 =?us-ascii?Q?u3DfzEwO+HnsPDLBaBdSZRb9GHwdh/0Vllwo4ff7Fiyg15rs9jslEW9pe1Kz?=
 =?us-ascii?Q?Cgg2h9ybzzFkIVuEe49IrpFVdEYDtaihwPszJFa4naWGKQzu3ycM1X/ilml/?=
 =?us-ascii?Q?ehh0wcNIGbOyk0NSKESOUJfGgiJJGRme3a/aUnq7AO3PAw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28C0A01DD9E47C448BF5234BBD3B9F44@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0b06e7-61aa-48c0-2c26-08d904e7a95d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 17:05:27.3830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3wLzRZ162Pe+ziXvkal11O/OMjlGWs63NTFPHPNy5WznZH0dcr1K3k+OOp2/NQqTNZ5yjbe4p7yoXdS69JjZulO6U4lQd8lqn0l8faUiHmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210122
X-Proofpoint-GUID: C8Mj9w5ZGdDMIo0Cfq0pqR-qqW0tTaCp
X-Proofpoint-ORIG-GUID: C8Mj9w5ZGdDMIo0Cfq0pqR-qqW0tTaCp
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210120
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Create operational request and reply queue pair.
>=20
> The MPI3 transport interface consists of an Administrative Request Queue,
> an Administrative Reply Queue, and Operational Messaging Queues.
> The Operational Messaging Queues are the primary communication mechanism
> between the host and the I/O Controller (IOC).
> Request messages, allocated in host memory, identify I/O operations to be
> performed by the IOC. These operations are queued on an Operational
> Request Queue by the host driver.
> Reply descriptors track I/O operations as they complete.
> The IOC queues these completions in an Operational Reply Queue.
>=20
> To fulfil large contiguous memory requirement, driver creates multiple
> segments and provide the list of segments. Each segment size should be 4K
> which is h/w requirement. An element array is contiguous or segmented.
> A contiguous element array is located in contiguous physical memory.
> A contiguous element array must be aligned on an element size boundary.
> An element's physical address within the array may be directly calculated
> from the base address, the Producer/Consumer index, and the element size.
>=20
> Expected phased identifier bit is used to find out valid entry on reply q=
ueue.
> Driver set <ephase> bit and IOC invert the value of this bit on each pass=
.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  56 +++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 601 ++++++++++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c |   4 +-
> 3 files changed, 660 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index cf1cfea19826..c26105b23759 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -71,6 +71,12 @@ extern struct list_head mrioc_list;
> #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
> #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
>=20
> +/* Operational queue management definitions */
> +#define MPI3MR_OP_REQ_Q_QD		512
> +#define MPI3MR_OP_REP_Q_QD		4096
> +#define MPI3MR_OP_REQ_Q_SEG_SIZE	4096
> +#define MPI3MR_OP_REP_Q_SEG_SIZE	4096
> +#define MPI3MR_MAX_SEG_LIST_SIZE	4096
>=20
> /* Reserved Host Tag definitions */
> #define MPI3MR_HOSTTAG_INVALID		0xFFFF
> @@ -132,6 +138,9 @@ extern struct list_head mrioc_list;
> 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
> 	MPI3_SGE_FLAGS_END_OF_LIST)
>=20
> +/* MSI Index from Reply Queue Index */
> +#define REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, offset)	(qidx + offset)
> +
> /* IOC State definitions */
> enum mpi3mr_iocstate {
> 	MRIOC_STATE_READY =3D 1,
> @@ -222,15 +231,45 @@ struct mpi3mr_ioc_facts {
> 	u8 sge_mod_shift;
> };
>=20
> +/**
> + * struct segments - memory descriptor structure to store
> + * virtual and dma addresses for operational queue segments.
> + *
> + * @segment: virtual address
> + * @segment_dma: dma address
> + */
> +struct segments {
> +	void *segment;
> +	dma_addr_t segment_dma;
> +};
> +
> /**
>  * struct op_req_qinfo -  Operational Request Queue Information
>  *
>  * @ci: consumer index
>  * @pi: producer index
> + * @num_request: Maximum number of entries in the queue
> + * @qid: Queue Id starting from 1
> + * @reply_qid: Associated reply queue Id
> + * @num_segments: Number of discontiguous memory segments
> + * @segment_qd: Depth of each segments
> + * @q_lock: Concurrent queue access lock
> + * @q_segments: Segment descriptor pointer
> + * @q_segment_list: Segment list base virtual address
> + * @q_segment_list_dma: Segment list base DMA address
>  */
> struct op_req_qinfo {
> 	u16 ci;
> 	u16 pi;
> +	u16 num_requests;
> +	u16 qid;
> +	u16 reply_qid;
> +	u16 num_segments;
> +	u16 segment_qd;
> +	spinlock_t q_lock;
> +	struct segments *q_segments;
> +	void *q_segment_list;
> +	dma_addr_t q_segment_list_dma;
> };
>=20
> /**
> @@ -238,10 +277,24 @@ struct op_req_qinfo {
>  *
>  * @ci: consumer index
>  * @qid: Queue Id starting from 1
> + * @num_replies: Maximum number of entries in the queue
> + * @num_segments: Number of discontiguous memory segments
> + * @segment_qd: Depth of each segments
> + * @q_segments: Segment descriptor pointer
> + * @q_segment_list: Segment list base virtual address
> + * @q_segment_list_dma: Segment list base DMA address
> + * @ephase: Expected phased identifier for the reply queue
>  */
> struct op_reply_qinfo {
> 	u16 ci;
> 	u16 qid;
> +	u16 num_replies;
> +	u16 num_segments;
> +	u16 segment_qd;
> +	struct segments *q_segments;
> +	void *q_segment_list;
> +	dma_addr_t q_segment_list_dma;
> +	u8 ephase;
> };
>=20
> /**
> @@ -401,6 +454,7 @@ struct scmd_priv {
>  * @current_event: Firmware event currently in process
>  * @driver_info: Driver, Kernel, OS information to firmware
>  * @change_count: Topology change count
> + * @op_reply_q_offset: Operational reply queue offset with MSIx
>  */
> struct mpi3mr_ioc {
> 	struct list_head list;
> @@ -408,6 +462,7 @@ struct mpi3mr_ioc {
> 	struct Scsi_Host *shost;
> 	u8 id;
> 	int cpu_count;
> +	bool enable_segqueue;
>=20
> 	char name[MPI3MR_NAME_LENGTH];
> 	char driver_name[MPI3MR_NAME_LENGTH];
> @@ -494,6 +549,7 @@ struct mpi3mr_ioc {
> 	struct mpi3mr_fwevt *current_event;
> 	Mpi3DriverInfoLayout_t driver_info;
> 	u16 change_count;
> +	u16 op_reply_q_offset;
> };
>=20
> int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 330f675444e9..694e54bbb07c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -405,6 +405,8 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc,=
 u8 setup_one)
>=20
> 	irq_flags |=3D PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
>=20
> +	mrioc->op_reply_q_offset =3D (max_vectors > 1) ? 1 : 0;
> +
> 	i =3D pci_alloc_irq_vectors_affinity(mrioc->pdev,
> 	    1, max_vectors, irq_flags, &desc);
> 	if (i <=3D 0) {
> @@ -415,6 +417,12 @@ static int mpi3mr_setup_isr(struct mpi3mr_ioc *mrioc=
, u8 setup_one)
> 		ioc_info(mrioc,
> 		    "allocated vectors (%d) are less than configured (%d)\n",
> 		    i, max_vectors);
> +		/*
> +		 * If only one MSI-x is allocated, then MSI-x 0 will be shared
> +		 * between Admin queue and operational queue
> +		 */
> +		if (i =3D=3D 1)
> +			mrioc->op_reply_q_offset =3D 0;
>=20
> 		max_vectors =3D i;
> 	}
> @@ -723,6 +731,586 @@ int mpi3mr_admin_request_post(struct mpi3mr_ioc *mr=
ioc, void *admin_req,
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_free_op_req_q_segments - free request memory segments
> + * @mrioc: Adapter instance reference
> + * @q_idx: operational request queue index
> + *
> + * Free memory segments allocated for operational request queue
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 =
q_idx)
> +{
> +	u16 j;
> +	int size;
> +	struct segments *segments;
> +
> +	segments =3D mrioc->req_qinfo[q_idx].q_segments;
> +	if (!segments)
> +		return;
> +
> +	if (mrioc->enable_segqueue) {
> +		size =3D MPI3MR_OP_REQ_Q_SEG_SIZE;
> +		if (mrioc->req_qinfo[q_idx].q_segment_list) {
> +			dma_free_coherent(&mrioc->pdev->dev,
> +			    MPI3MR_MAX_SEG_LIST_SIZE,
> +			    mrioc->req_qinfo[q_idx].q_segment_list,
> +			    mrioc->req_qinfo[q_idx].q_segment_list_dma);
> +			mrioc->op_reply_qinfo[q_idx].q_segment_list =3D NULL;
> +		}
> +	} else
> +		size =3D mrioc->req_qinfo[q_idx].num_requests *
> +		    mrioc->facts.op_req_sz;
> +
> +	for (j =3D 0; j < mrioc->req_qinfo[q_idx].num_segments; j++) {
> +		if (!segments[j].segment)
> +			continue;
> +		dma_free_coherent(&mrioc->pdev->dev,
> +		    size, segments[j].segment, segments[j].segment_dma);
> +		segments[j].segment =3D NULL;
> +	}
> +	kfree(mrioc->req_qinfo[q_idx].q_segments);
> +	mrioc->req_qinfo[q_idx].q_segments =3D NULL;
> +	mrioc->req_qinfo[q_idx].qid =3D 0;
> +}
> +
> +/**
> + * mpi3mr_free_op_reply_q_segments - free reply memory segments
> + * @mrioc: Adapter instance reference
> + * @q_idx: operational reply queue index
> + *
> + * Free memory segments allocated for operational reply queue
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_free_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u1=
6 q_idx)
> +{
> +	u16 j;
> +	int size;
> +	struct segments *segments;
> +
> +	segments =3D mrioc->op_reply_qinfo[q_idx].q_segments;
> +	if (!segments)
> +		return;
> +
> +	if (mrioc->enable_segqueue) {
> +		size =3D MPI3MR_OP_REP_Q_SEG_SIZE;
> +		if (mrioc->op_reply_qinfo[q_idx].q_segment_list) {
> +			dma_free_coherent(&mrioc->pdev->dev,
> +			    MPI3MR_MAX_SEG_LIST_SIZE,
> +			    mrioc->op_reply_qinfo[q_idx].q_segment_list,
> +			    mrioc->op_reply_qinfo[q_idx].q_segment_list_dma);
> +			mrioc->op_reply_qinfo[q_idx].q_segment_list =3D NULL;
> +		}
> +	} else
> +		size =3D mrioc->op_reply_qinfo[q_idx].segment_qd *
> +		    mrioc->op_reply_desc_sz;
> +
> +	for (j =3D 0; j < mrioc->op_reply_qinfo[q_idx].num_segments; j++) {
> +		if (!segments[j].segment)
> +			continue;
> +		dma_free_coherent(&mrioc->pdev->dev,
> +		    size, segments[j].segment, segments[j].segment_dma);
> +		segments[j].segment =3D NULL;
> +	}
> +
> +	kfree(mrioc->op_reply_qinfo[q_idx].q_segments);
> +	mrioc->op_reply_qinfo[q_idx].q_segments =3D NULL;
> +	mrioc->op_reply_qinfo[q_idx].qid =3D 0;
> +}
> +
> +/**
> + * mpi3mr_delete_op_reply_q - delete operational reply queue
> + * @mrioc: Adapter instance reference
> + * @qidx: operational reply queue index
> + *
> + * Delete operatinal reply queue by issuing MPI request
> + * through admin queue.
> + *
> + * Return:  0 on success, non-zero on failure.
> + */
> +static int mpi3mr_delete_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
> +{
> +	Mpi3DeleteReplyQueueRequest_t delq_req;
> +	int retval =3D 0;
> +	u16 reply_qid =3D 0, midx;
> +
> +	reply_qid =3D mrioc->op_reply_qinfo[qidx].qid;
> +
> +	midx =3D REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, mrioc->op_reply_q_offset);
> +
> +	if (!reply_qid)	{
> +		retval =3D -1;
> +		ioc_err(mrioc, "Issue DelRepQ: called with invalid ReqQID\n");
> +		goto out;
> +	}
> +
> +	memset(&delq_req, 0, sizeof(delq_req));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "Issue DelRepQ: Init command is in use\n");
> +		mutex_unlock(&mrioc->init_cmds.mutex);
> +		goto out;
> +	}
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->init_cmds.is_waiting =3D 1;
> +	mrioc->init_cmds.callback =3D NULL;
> +	delq_req.HostTag =3D cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	delq_req.Function =3D MPI3_FUNCTION_DELETE_REPLY_QUEUE;
> +	delq_req.QueueID =3D cpu_to_le16(reply_qid);
> +
> +	init_completion(&mrioc->init_cmds.done);
> +	retval =3D mpi3mr_admin_request_post(mrioc, &delq_req, sizeof(delq_req)=
,
> +	    1);
> +	if (retval) {
> +		ioc_err(mrioc, "Issue DelRepQ: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&mrioc->init_cmds.done,
> +	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
> +	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "Issue DelRepQ: command timed out\n");
> +		mpi3mr_set_diagsave(mrioc);
> +		mpi3mr_issue_reset(mrioc,
> +		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
> +		    MPI3MR_RESET_FROM_DELREPQ_TIMEOUT);
> +		mrioc->unrecoverable =3D 1;
> +
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	    !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "Issue DelRepQ: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
> +		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->init_cmds.ioc_loginfo);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	mrioc->intr_info[midx].op_reply_q =3D NULL;
> +
> +	mpi3mr_free_op_reply_q_segments(mrioc, qidx);
> +out_unlock:
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +out:
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_alloc_op_reply_q_segments -Alloc segmented reply pool
> + * @mrioc: Adapter instance reference
> + * @qidx: request queue index
> + *
> + * Allocate segmented memory pools for operational reply
> + * queue.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +static int mpi3mr_alloc_op_reply_q_segments(struct mpi3mr_ioc *mrioc, u1=
6 qidx)
> +{
> +	struct op_reply_qinfo *op_reply_q =3D mrioc->op_reply_qinfo + qidx;
> +	int i, size;
> +	u64 *q_segment_list_entry =3D NULL;
> +	struct segments *segments;
> +
> +	if (mrioc->enable_segqueue) {
> +		op_reply_q->segment_qd =3D
> +		    MPI3MR_OP_REP_Q_SEG_SIZE / mrioc->op_reply_desc_sz;
> +
> +		size =3D MPI3MR_OP_REP_Q_SEG_SIZE;
> +
> +		op_reply_q->q_segment_list =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +		    MPI3MR_MAX_SEG_LIST_SIZE, &op_reply_q->q_segment_list_dma,
> +		    GFP_KERNEL);
> +		if (!op_reply_q->q_segment_list)
> +			return -ENOMEM;
> +		q_segment_list_entry =3D (u64 *)op_reply_q->q_segment_list;
> +	} else {
> +		op_reply_q->segment_qd =3D op_reply_q->num_replies;
> +		size =3D op_reply_q->num_replies * mrioc->op_reply_desc_sz;
> +	}
> +
> +	op_reply_q->num_segments =3D DIV_ROUND_UP(op_reply_q->num_replies,
> +	    op_reply_q->segment_qd);
> +
> +	op_reply_q->q_segments =3D kcalloc(op_reply_q->num_segments,
> +	    sizeof(struct segments), GFP_KERNEL);
> +	if (!op_reply_q->q_segments)
> +		return -ENOMEM;
> +
> +	segments =3D op_reply_q->q_segments;
> +	for (i =3D 0; i < op_reply_q->num_segments; i++) {
> +		segments[i].segment =3D
> +		    dma_alloc_coherent(&mrioc->pdev->dev,
> +		    size, &segments[i].segment_dma, GFP_KERNEL);
> +		if (!segments[i].segment)
> +			return -ENOMEM;
> +		if (mrioc->enable_segqueue)
> +			q_segment_list_entry[i] =3D
> +			    (unsigned long)segments[i].segment_dma;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_alloc_op_req_q_segments - Alloc segmented req pool.
> + * @mrioc: Adapter instance reference
> + * @qidx: request queue index
> + *
> + * Allocate segmented memory pools for operational request
> + * queue.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +static int mpi3mr_alloc_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 =
qidx)
> +{
> +	struct op_req_qinfo *op_req_q =3D mrioc->req_qinfo + qidx;
> +	int i, size;
> +	u64 *q_segment_list_entry =3D NULL;
> +	struct segments *segments;
> +
> +	if (mrioc->enable_segqueue) {
> +		op_req_q->segment_qd =3D
> +		    MPI3MR_OP_REQ_Q_SEG_SIZE / mrioc->facts.op_req_sz;
> +
> +		size =3D MPI3MR_OP_REQ_Q_SEG_SIZE;
> +
> +		op_req_q->q_segment_list =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +		    MPI3MR_MAX_SEG_LIST_SIZE, &op_req_q->q_segment_list_dma,
> +		    GFP_KERNEL);
> +		if (!op_req_q->q_segment_list)
> +			return -ENOMEM;
> +		q_segment_list_entry =3D (u64 *)op_req_q->q_segment_list;
> +
> +	} else {
> +		op_req_q->segment_qd =3D op_req_q->num_requests;
> +		size =3D op_req_q->num_requests * mrioc->facts.op_req_sz;
> +	}
> +
> +	op_req_q->num_segments =3D DIV_ROUND_UP(op_req_q->num_requests,
> +	    op_req_q->segment_qd);
> +
> +	op_req_q->q_segments =3D kcalloc(op_req_q->num_segments,
> +	    sizeof(struct segments), GFP_KERNEL);
> +	if (!op_req_q->q_segments)
> +		return -ENOMEM;
> +
> +	segments =3D op_req_q->q_segments;
> +	for (i =3D 0; i < op_req_q->num_segments; i++) {
> +		segments[i].segment =3D
> +		    dma_alloc_coherent(&mrioc->pdev->dev,
> +		    size, &segments[i].segment_dma, GFP_KERNEL);
> +		if (!segments[i].segment)
> +			return -ENOMEM;
> +		if (mrioc->enable_segqueue)
> +			q_segment_list_entry[i] =3D
> +			    (unsigned long)segments[i].segment_dma;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_create_op_reply_q - create operational reply queue
> + * @mrioc: Adapter instance reference
> + * @qidx: operational reply queue index
> + *
> + * Create operatinal reply queue by issuing MPI request
> + * through admin queue.
> + *
> + * Return:  0 on success, non-zero on failure.
> + */
> +static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
> +{
> +	Mpi3CreateReplyQueueRequest_t create_req;
> +	struct op_reply_qinfo *op_reply_q =3D mrioc->op_reply_qinfo + qidx;
> +	int retval =3D 0;
> +	u16 reply_qid =3D 0, midx;
> +
> +
> +	reply_qid =3D op_reply_q->qid;
> +
> +	midx =3D REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, mrioc->op_reply_q_offset);
> +
> +	if (reply_qid) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "CreateRepQ: called for duplicate qid %d\n",
> +		    reply_qid);
> +
> +		return retval;
> +	}
> +
> +	reply_qid =3D qidx + 1;
> +	op_reply_q->num_replies =3D MPI3MR_OP_REP_Q_QD;
> +	op_reply_q->ci =3D 0;
> +	op_reply_q->ephase =3D 1;
> +
> +	if (!op_reply_q->q_segments) {
> +		retval =3D mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
> +		if (retval) {
> +			mpi3mr_free_op_reply_q_segments(mrioc, qidx);
> +			goto out;
> +		}
> +	}
> +
> +	memset(&create_req, 0, sizeof(create_req));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "CreateRepQ: Init command is in use\n");
> +		goto out;
> +	}
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->init_cmds.is_waiting =3D 1;
> +	mrioc->init_cmds.callback =3D NULL;
> +	create_req.HostTag =3D cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	create_req.Function =3D MPI3_FUNCTION_CREATE_REPLY_QUEUE;
> +	create_req.QueueID =3D cpu_to_le16(reply_qid);
> +	create_req.Flags =3D MPI3_CREATE_REPLY_QUEUE_FLAGS_INT_ENABLE_ENABLE;
> +	create_req.MSIxIndex =3D cpu_to_le16(mrioc->intr_info[midx].msix_index)=
;
> +	if (mrioc->enable_segqueue) {
> +		create_req.Flags |=3D
> +		    MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED;
> +		create_req.BaseAddress =3D cpu_to_le64(
> +		    op_reply_q->q_segment_list_dma);
> +	} else
> +		create_req.BaseAddress =3D cpu_to_le64(
> +		    op_reply_q->q_segments[0].segment_dma);
> +
> +	create_req.Size =3D cpu_to_le16(op_reply_q->num_replies);
> +
> +	init_completion(&mrioc->init_cmds.done);
> +	retval =3D mpi3mr_admin_request_post(mrioc, &create_req,
> +	    sizeof(create_req), 1);
> +	if (retval) {
> +		ioc_err(mrioc, "CreateRepQ: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&mrioc->init_cmds.done,
> +	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
> +	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "CreateRepQ: command timed out\n");
> +		mpi3mr_set_diagsave(mrioc);
> +		mpi3mr_issue_reset(mrioc,
> +		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
> +		    MPI3MR_RESET_FROM_CREATEREPQ_TIMEOUT);
> +		mrioc->unrecoverable =3D 1;
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	    !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "CreateRepQ: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
> +		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->init_cmds.ioc_loginfo);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	op_reply_q->qid =3D reply_qid;
> +	mrioc->intr_info[midx].op_reply_q =3D op_reply_q;
> +
> +out_unlock:
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +out:
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_create_op_req_q - create operational request queue
> + * @mrioc: Adapter instance reference
> + * @idx: operational request queue index
> + * @reply_qid: Reply queue ID
> + *
> + * Create operatinal request queue by issuing MPI request
> + * through admin queue.
> + *
> + * Return:  0 on success, non-zero on failure.
> + */
> +static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
> +	u16 reply_qid)
> +{
> +	Mpi3CreateRequestQueueRequest_t create_req;
> +	struct op_req_qinfo *op_req_q =3D mrioc->req_qinfo + idx;
> +	int retval =3D 0;
> +	u16 req_qid =3D 0;
> +
> +
> +	req_qid =3D op_req_q->qid;
> +
> +	if (req_qid) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "CreateReqQ: called for duplicate qid %d\n",
> +		    req_qid);
> +
> +		return retval;
> +	}
> +	req_qid =3D idx + 1;
> +
> +	op_req_q->num_requests =3D MPI3MR_OP_REQ_Q_QD;
> +	op_req_q->ci =3D 0;
> +	op_req_q->pi =3D 0;
> +	op_req_q->reply_qid =3D reply_qid;
> +	spin_lock_init(&op_req_q->q_lock);
> +
> +	if (!op_req_q->q_segments) {
> +		retval =3D mpi3mr_alloc_op_req_q_segments(mrioc, idx);
> +		if (retval) {
> +			mpi3mr_free_op_req_q_segments(mrioc, idx);
> +			goto out;
> +		}
> +	}
> +
> +	memset(&create_req, 0, sizeof(create_req));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "CreateReqQ: Init command is in use\n");
> +		goto out;
> +	}
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->init_cmds.is_waiting =3D 1;
> +	mrioc->init_cmds.callback =3D NULL;
> +	create_req.HostTag =3D cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	create_req.Function =3D MPI3_FUNCTION_CREATE_REQUEST_QUEUE;
> +	create_req.QueueID =3D cpu_to_le16(req_qid);
> +	if (mrioc->enable_segqueue) {
> +		create_req.Flags =3D
> +		    MPI3_CREATE_REQUEST_QUEUE_FLAGS_SEGMENTED_SEGMENTED;
> +		create_req.BaseAddress =3D cpu_to_le64(
> +		    op_req_q->q_segment_list_dma);
> +	} else
> +		create_req.BaseAddress =3D cpu_to_le64(
> +		    op_req_q->q_segments[0].segment_dma);
> +	create_req.ReplyQueueID =3D cpu_to_le16(reply_qid);
> +	create_req.Size =3D cpu_to_le16(op_req_q->num_requests);
> +
> +	init_completion(&mrioc->init_cmds.done);
> +	retval =3D mpi3mr_admin_request_post(mrioc, &create_req,
> +	    sizeof(create_req), 1);
> +	if (retval) {
> +		ioc_err(mrioc, "CreateReqQ: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&mrioc->init_cmds.done,
> +	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
> +	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "CreateReqQ: command timed out\n");
> +		mpi3mr_set_diagsave(mrioc);
> +		if (mpi3mr_issue_reset(mrioc,
> +		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
> +		    MPI3MR_RESET_FROM_CREATEREQQ_TIMEOUT))
> +			mrioc->unrecoverable =3D 1;
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	    !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "CreateReqQ: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\n",
> +		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->init_cmds.ioc_loginfo);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	op_req_q->qid =3D req_qid;
> +
> +out_unlock:
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +out:
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_create_op_queues - create operational queue pairs
> + * @mrioc: Adapter instance reference
> + *
> + * Allocate memory for operational queue meta data and call
> + * create request and reply queue functions.
> + *
> + * Return: 0 on success, non-zero on failures.
> + */
> +static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
> +{
> +	int retval =3D 0;
> +	u16 num_queues =3D 0, i =3D 0, msix_count_op_q =3D 1;
> +
> +	num_queues =3D min_t(int, mrioc->facts.max_op_reply_q,
> +	    mrioc->facts.max_op_req_q);
> +
> +	msix_count_op_q =3D
> +	    mrioc->intr_info_count - mrioc->op_reply_q_offset;
> +	if (!mrioc->num_queues)
> +		mrioc->num_queues =3D min_t(int, num_queues, msix_count_op_q);
> +	num_queues =3D mrioc->num_queues;
> +	ioc_info(mrioc, "Trying to create %d Operational Q pairs\n",
> +	    num_queues);
> +
> +	if (!mrioc->req_qinfo) {
> +		mrioc->req_qinfo =3D kcalloc(num_queues,
> +		    sizeof(struct op_req_qinfo), GFP_KERNEL);
> +		if (!mrioc->req_qinfo) {
> +			retval =3D -1;
> +			goto out_failed;
> +		}
> +
> +		mrioc->op_reply_qinfo =3D kzalloc(sizeof(struct op_reply_qinfo) *
> +		    num_queues, GFP_KERNEL);
> +		if (!mrioc->op_reply_qinfo) {
> +			retval =3D -1;
> +			goto out_failed;
> +		}
> +	}
> +
> +	if (mrioc->enable_segqueue)
> +		ioc_info(mrioc,
> +		    "allocating operational queues through segmented queues\n");
> +
> +	for (i =3D 0; i < num_queues; i++) {
> +		if (mpi3mr_create_op_reply_q(mrioc, i)) {
> +			ioc_err(mrioc, "Cannot create OP RepQ %d\n", i);
> +			break;
> +		}
> +		if (mpi3mr_create_op_req_q(mrioc, i,
> +		    mrioc->op_reply_qinfo[i].qid)) {
> +			ioc_err(mrioc, "Cannot create OP ReqQ %d\n", i);
> +			mpi3mr_delete_op_reply_q(mrioc, i);
> +			break;
> +		}
> +	}
> +
> +	if (i =3D=3D 0) {
> +		/* Not even one queue is created successfully*/
> +		retval =3D -1;
> +		goto out_failed;
> +	}
> +	mrioc->num_op_reply_q =3D mrioc->num_op_req_q =3D i;
> +	ioc_info(mrioc, "Successfully created %d Operational Q pairs\n",
> +	    mrioc->num_op_reply_q);
> +
> +
> +	return retval;
> +out_failed:
> +	kfree(mrioc->req_qinfo);
> +	mrioc->req_qinfo =3D NULL;
> +
> +	kfree(mrioc->op_reply_qinfo);
> +	mrioc->op_reply_qinfo =3D NULL;
> +
> +
> +	return retval;
> +}
> +
>=20
> /**
>  * mpi3mr_setup_admin_qpair - Setup admin queue pair
> @@ -1598,6 +2186,13 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 		goto out_failed;
> 	}
>=20
> +	retval =3D mpi3mr_create_op_queues(mrioc);
> +	if (retval) {
> +		ioc_err(mrioc, "Failed to create OpQueues error %d\n",
> +		    retval);
> +		goto out_failed;
> +	}
> +
> 	return retval;
>=20
> out_failed:
> @@ -1654,6 +2249,12 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mri=
oc)
> 		mrioc->reply_free_q_pool =3D NULL;
> 	}
>=20
> +	for (i =3D 0; i < mrioc->num_op_req_q; i++)
> +		mpi3mr_free_op_req_q_segments(mrioc, i);
> +
> +	for (i =3D 0; i < mrioc->num_op_reply_q; i++)
> +		mpi3mr_free_op_reply_q_segments(mrioc, i);
> +
> 	for (i =3D 0; i < mrioc->intr_info_count; i++) {
> 		intr_info =3D mrioc->intr_info + i;
> 		if (intr_info)
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index c31ec9883152..3cf0be63842f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -41,7 +41,7 @@ static int mpi3mr_map_queues(struct Scsi_Host *shost)
> 	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
>=20
> 	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> -	    mrioc->pdev, 0);
> +	    mrioc->pdev, mrioc->op_reply_q_offset);
> }
>=20
> /**
> @@ -220,6 +220,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_d=
evice_id *id)
> 	spin_lock_init(&mrioc->sbq_lock);
>=20
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> +	if (pdev->revision)
> +		mrioc->enable_segqueue =3D true;
>=20
> 	mrioc->logging_level =3D logging_level;
> 	mrioc->shost =3D shost;
> --=20
> 2.18.1
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

