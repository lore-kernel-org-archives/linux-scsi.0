Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E15A8C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC16A613C4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbhDVRIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:08:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48018 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhDVRIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:08:42 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MH6Hc4195530;
        Thu, 22 Apr 2021 17:08:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fS1IZ0a6TIr2jEXrtMvRNQr79P4p/oLtWAyIlYhNTig=;
 b=JAgkZM4ydSd00Ph25ObsGf8i+XXB2PDNhDwTf+8ktx5zG3zyK2/jlLoWjIArwz9tl3bn
 MsULG3WgzxmE9DSqnBmX1aJKOelQguHi8ElKxypnis20dGOMru4iE/7d5elDr5PS675z
 IAu1eQJpR7bA1NK4LfKO3GlNIMKWy0ogTQBm10mX/nesJgJuznwHd1bjpvSTB8rdUfyP
 Xcv51I9P+poJysWTfZY/3KTD0BG+g3lsGtkO/tDld1B5ulY90VoFKc8J58s5qDKeO/7D
 B1tjxBnUSAmkJuxxt0sY8JyscHACnVdbZ4XSPswNjLkO08u9yb8fAoF9AvdaoswcquPF nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37yn6ce5sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:08:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MH610c166144;
        Thu, 22 Apr 2021 17:08:04 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2059.outbound.protection.outlook.com [104.47.44.59])
        by userp3020.oracle.com with ESMTP id 383cg9adty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:08:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HltgAJfr4z0L/PeRX/g5hHru4SsmnWXgORPNUHOlRNfklJAmR+4LE0zu7doHOr3y0PabquW1pfLwipzeyUxoTP0tx1EL6hGQpIwKskirFU6FqLOdj6voUDdaitxnuD6WGG1mLFXNq16tzYhm3LFpE7CiEdUTcscHDkgTJn3zIq7XZ89x8gMQLXwZ0e0//JQDCGM70qGGb8rLiKNkQ10y4PxYR4sX5fu8IPDoqCk0MEO+Pvy+upbkhjBBoFnTQFP8F6KzCeMAbKYF35ubezrmjkZNX8uqb+8W3f+iKiSZiuI4nldwnFr2zNgV4ikWHkkzmvwuE38g1Qcoj8cNDHilGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fS1IZ0a6TIr2jEXrtMvRNQr79P4p/oLtWAyIlYhNTig=;
 b=HbN+YZccyQXjZRcZr9FMwClN3lt6yAEcyS+pvuDTWcMSIIT60Iefx0/r1ZlDRcZOrAnspRSjfYtWZOi0+v9haXMrieXhDBZKnvomNXh3sXs92eSy7w2VUzkam2yWhGfyZqigTr32Q8KHp8PqX6rtj2pDk+dk6adNhAK3DqNqDzYn3o2XCQRS4hsgK31nfSrC1SwKsrHv/10D0BWmdiVvBT/Z0fnV6yumawv/5z6N4A8N79YoRbL8MaPZ5RAnVwUpGyTD6cEgFaw+EPwCtFmKhRlOBo/WWPyGrBEVxzbdCk2ptGfbd5y+QaXTcuoEIrJOBTQiA7PSE9Ayq0dWnkJJVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fS1IZ0a6TIr2jEXrtMvRNQr79P4p/oLtWAyIlYhNTig=;
 b=Q4fSRWIYLKO6/7Rn1/odegq9HiWXtfkJrOLXItET0JAvxOPLrKufeTKxWrl4to+NV5y1RvDegHSnBQfnDBfE5IpQsB7kV/0lxqMbj4s4V7JdZI07dGgnxq9DdxHr4OHt+nBafwNpf0t+6lxNylfEmXRPa8HIATOUOqllR72+ZUc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 17:08:02 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:08:02 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 17/24] mpi3mr: add support of threaded isr
Thread-Topic: [PATCH v3 17/24] mpi3mr: add support of threaded isr
Thread-Index: AQHXNQuUuZKLp7PMWESzST4PUnmyA6rAygMA
Date:   Thu, 22 Apr 2021 17:08:02 +0000
Message-ID: <F651504B-7E5C-400C-A5FA-BDC9581B0EC3@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-18-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-18-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5eb36acf-8841-42c7-e224-08d905b13036
x-ms-traffictypediagnostic: SA2PR10MB4425:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB44255CDFFC1659FB5DB0D027E6469@SA2PR10MB4425.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cgfIk9XhPms4VWQhWA0VNP5TO39sZKhzyq3rpilzqY8RO/OizcPpI0eKGtARKfGxh+tEs41kEJtVj6N8q3TmmrPzAXLRzSP0bOZxDL43b5oTUocE/oXLV/HzaqkXfwSq5h1rV1lHS/ebt2NvHgbh+KzyyzE3Zp4f+xrEnDPVsNw3yVE3wEt17UPsTp2NadQaJ58xSky0uZtUZGtXy22rbDJ/Zg+ViKKT5trDZJYaNdSdu/Ab4JNrq1IeidHKMy2m0dXn1wodjNwiB5BegpJOaB7jGFpoeOTDnnrdvN9ynWryx4rBrlRp7QD1Tvuda6NAeAz7V/r2BnagYo7nTjCUPjfZMl6+zuTxAzl3BolRDvcDFzQxqdMmZK4dXjZA/Ww2U6GiLnODXVmKvOCFiG2sI5OxlRNnY+/L6/OZowXSm2rcUWZ8On3N57JfWbSTY7kl1Nq0A022VKG6d6B2K3nLHQKlXHnyk6nj+6Zp/bATyyBUCJzqaGWLY0Q1yD39Yc7crzF8Nek51KO2vUsyRSTRyoQzkJWIuCGW/mB43Z4JKs0g+2J9UCjFfzU8m6W/9FlcZC5zZDHloKrfuIiIMFOcQ4HuZt/5RrRyaE42RbQL5ToIo+oOI0w+BF6XyZ8Zf/v+gntDVJex43IAhShQTpM1jPAn1oGpJEdwGHVeclIr8woC/CFWSifrgtxMFqBHjN0/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(346002)(39860400002)(136003)(2906002)(54906003)(6916009)(44832011)(33656002)(86362001)(8936002)(71200400001)(76116006)(6506007)(316002)(53546011)(19627235002)(2616005)(66446008)(8676002)(66476007)(36756003)(83380400001)(38100700002)(122000001)(478600001)(66946007)(5660300002)(64756008)(4326008)(6486002)(186003)(6512007)(66556008)(26005)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8tzvk3eZhxNbvvrjDUAmkeV7uJvuGJY2txfAViKxag7Gxi9jSYXRyWb3ivKH?=
 =?us-ascii?Q?Pptq7J6k2q149ff4V39X4MxVrud1i0CojMmYjKFkL0xk1Yqca2Riy8AbdRsV?=
 =?us-ascii?Q?yL5kYjqP0Ei5vSZJIm1JML//+f5xVo/e05mk8hUanxP2YWPaTBekbs4+4HUi?=
 =?us-ascii?Q?aDEKgPBnyQ0YTZsG+/qb+EufLk8eHL15TVQScHFfl9+LMI+KlvEwrxz3WOIr?=
 =?us-ascii?Q?GU7aQOTgRE/2UUGlurlY7PESCc2WPDAkOq2mvcUSDBba+qM1ZbiVDv/w2OJf?=
 =?us-ascii?Q?hhH3D5dcqQbbrbVVgzMTrAFv6pSYUe+qZ1I3ZpYXdMXDSssWEBRQ+X6FRmZu?=
 =?us-ascii?Q?b0hCDqO7PSzzRoc32U3EYxZlZsrQgQTQ47djiMTtrdf6p3twovT8YEzzXMZW?=
 =?us-ascii?Q?Ux31ToQq6CtWyB33WHKDC4DCJJ56OEQYjOVPCYsWifBbfpdpTwvhCFUs/P8L?=
 =?us-ascii?Q?DdIYjHktMo7pX1PtTmShjircZUo41OwoVuJ0hzm/pw0Z1/v49WCPh+q5mLq2?=
 =?us-ascii?Q?en7Yp0GPWVC6r478023ro0nsxV9Pmqa8wvxZmSq1zSt2MVjI+wWQNvsjprpU?=
 =?us-ascii?Q?5pMMPTG/bXapwUBnwlcaQ6Aod+VV4YPM+CU7/njuA6BkNqjALP2Kx6eFqBP4?=
 =?us-ascii?Q?3b7yjKQgZ2jI1RCmutiiLX8ZV5P1kKO6RTabu3nxUMpQuz8957rttAD06PqX?=
 =?us-ascii?Q?p8ynimucRmXsF1gT0YEtwVUQyvzKz6b7iPiZSeUtl3a5YHwdES5Jx3VQG7ww?=
 =?us-ascii?Q?vwTxZceDiNTDCA+2eNAw5tOEE7nvoVmSyj0H9sJV+rGwUHZ/nnrs5fQdWH+R?=
 =?us-ascii?Q?mQh7lpLt0zLiMmDMq3zC5IkmddoowrHIleVSbu7Ie8bSebBS0e4kWY4dM8yD?=
 =?us-ascii?Q?yz/7vCqIR1SUA55f3zlBPebhbQGBh4Dt5qJTxZ1O4YrCHd1mNI92WflzaQbP?=
 =?us-ascii?Q?IKUGXfWL0lAnJ0n6IW8CNF0cHnCHPz8IQPTjXf2lg0jDW0C37g3q4op8IDdo?=
 =?us-ascii?Q?QU4FINfa1soAb8XjsivW67OCSAoSdcsUvBfT400Nppn0GB5vgFSWcm9XCzqm?=
 =?us-ascii?Q?v88Ci1tTpANrhM7onAz5YuX64Az92+p7wcG4C3rSS42wnhgnQv82EoelF/g8?=
 =?us-ascii?Q?QtQpz95bQ5cdibykIiRlCzyWhYipcmP1DLPbhulTLY9KaXWw5PeSV9OxYApi?=
 =?us-ascii?Q?opAZK403DPQS7DbepGYqg8GzVlwIj7fWVsWA6734Ao2bm6z5eSmZaUQ/e01y?=
 =?us-ascii?Q?wUpS1AWTmkELdgDvKW6I+tDhHm7SZQR5Vj3A+1qY1o3c0LF8NV9dW3uWJNoi?=
 =?us-ascii?Q?XoTaiOzi+7ZgIdghwF19vFw4emv1zGfAdXeffoJqz2T/cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C7C84E082528E4592966DC6407C4C63@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eb36acf-8841-42c7-e224-08d905b13036
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:08:02.4866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w+aAw5nw6fNIg1d2tkv/6k/0td9lQpWSnG2/bzyZYfLD69DvMKOh0h3KZd78QT8z//V3/8fP7Rzu0RykAjxiht11+D7ciJG2rasGelRObwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220128
X-Proofpoint-GUID: dscQjfU9lnZ-zNmLrpbn8ThF9237bO-p
X-Proofpoint-ORIG-GUID: dscQjfU9lnZ-zNmLrpbn8ThF9237bO-p
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220128
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Register driver for threaded interrupt.
>=20
> By default, driver will attempt io completion from interrupt context
> (primary handler). Since driver tracks per reply queue outstanding ios,
> it will schedule threaded ISR if there are any outstanding IOs expected
> on that particular reply queue. Threaded ISR (secondary handler) will loo=
p
> for IO completion as long as there are outstanding IOs
> (speculative method using same per reply queue outstanding counter)
> or it has completed some X amount of commands (something like budget).
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    | 12 +++++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 79 +++++++++++++++++++++++++++++++--
> 2 files changed, 88 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index e3ce54f877fa..3ac7b0f119bb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -144,6 +144,10 @@ extern struct list_head mrioc_list;
> /* Default target device queue depth */
> #define MPI3MR_DEFAULT_SDEV_QD	32
>=20
> +/* Definitions for Threaded IRQ poll*/
> +#define MPI3MR_IRQ_POLL_SLEEP			2
> +#define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
> +
> /* SGE Flag definition */
> #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
> 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
> @@ -295,6 +299,9 @@ struct op_req_qinfo {
>  * @q_segment_list: Segment list base virtual address
>  * @q_segment_list_dma: Segment list base DMA address
>  * @ephase: Expected phased identifier for the reply queue
> + * @pend_ios: Number of IOs pending in HW for this queue
> + * @enable_irq_poll: Flag to indicate polling is enabled
> + * @in_use: Queue is handled by poll/ISR
>  */
> struct op_reply_qinfo {
> 	u16 ci;
> @@ -306,6 +313,9 @@ struct op_reply_qinfo {
> 	void *q_segment_list;
> 	dma_addr_t q_segment_list_dma;
> 	u8 ephase;
> +	atomic_t pend_ios;
> +	bool enable_irq_poll;
> +	atomic_t in_use;
> };
>=20
> /**
> @@ -557,6 +567,7 @@ struct scmd_priv {
>  * @shost: Scsi_Host pointer
>  * @id: Controller ID
>  * @cpu_count: Number of online CPUs
> + * @irqpoll_sleep: usleep unit used in threaded isr irqpoll
>  * @name: Controller ASCII name
>  * @driver_name: Driver ASCII name
>  * @sysif_regs: System interface registers virtual address
> @@ -658,6 +669,7 @@ struct mpi3mr_ioc {
> 	u8 id;
> 	int cpu_count;
> 	bool enable_segqueue;
> +	u32 irqpoll_sleep;
>=20
> 	char name[MPI3MR_NAME_LENGTH];
> 	char driver_name[MPI3MR_NAME_LENGTH];
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index c25e96f008d7..76e4c87c0426 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -346,12 +346,16 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_=
ioc *mrioc,
>=20
> 	reply_qidx =3D op_reply_q->qid - 1;
>=20
> +	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
> +		return 0;
> +
> 	exp_phase =3D op_reply_q->ephase;
> 	reply_ci =3D op_reply_q->ci;
>=20
> 	reply_desc =3D mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> 	if ((le16_to_cpu(reply_desc->ReplyFlags) &
> 	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
> +		atomic_dec(&op_reply_q->in_use);
> 		return 0;
> 	}
>=20
> @@ -362,6 +366,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_io=
c *mrioc,
> 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->RequestQueueCI));
> 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
> 		    reply_qidx);
> +		atomic_dec(&op_reply_q->pend_ios);
> 		if (reply_dma)
> 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
> 		num_op_reply++;
> @@ -376,6 +381,14 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_i=
oc *mrioc,
> 		if ((le16_to_cpu(reply_desc->ReplyFlags) &
> 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase)
> 			break;
> +		/*
> +		 * Exit completion loop to avoid CPU lockup
> +		 * Ensure remaining completion happens from threaded ISR.
> +		 */
> +		if (num_op_reply > mrioc->max_host_ios) {
> +			intr_info->op_reply_q->enable_irq_poll =3D true;
> +			break;
> +		}
>=20
> 	} while (1);
>=20
> @@ -384,6 +397,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_io=
c *mrioc,
> 	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ConsumerIndex);
> 	op_reply_q->ci =3D reply_ci;
> 	op_reply_q->ephase =3D exp_phase;
> +	atomic_dec(&op_reply_q->in_use);
>=20
> 	return num_op_reply;
> }
> @@ -393,7 +407,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *=
privdata)
> 	struct mpi3mr_intr_info *intr_info =3D privdata;
> 	struct mpi3mr_ioc *mrioc;
> 	u16 midx;
> -	u32 num_admin_replies =3D 0;
> +	u32 num_admin_replies =3D 0, num_op_reply =3D 0;
>=20
> 	if (!intr_info)
> 		return IRQ_NONE;
> @@ -407,8 +421,10 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void =
*privdata)
>=20
> 	if (!midx)
> 		num_admin_replies =3D mpi3mr_process_admin_reply_q(mrioc);
> +	if (intr_info->op_reply_q)
> +		num_op_reply =3D mpi3mr_process_op_reply_q(mrioc, intr_info);
>=20
> -	if (num_admin_replies)
> +	if (num_admin_replies || num_op_reply)
> 		return IRQ_HANDLED;
> 	else
> 		return IRQ_NONE;
> @@ -417,15 +433,32 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void=
 *privdata)
> static irqreturn_t mpi3mr_isr(int irq, void *privdata)
> {
> 	struct mpi3mr_intr_info *intr_info =3D privdata;
> +	struct mpi3mr_ioc *mrioc;
> +	u16 midx;
> 	int ret;
>=20
> 	if (!intr_info)
> 		return IRQ_NONE;
>=20
> +	mrioc =3D intr_info->mrioc;
> +	midx =3D intr_info->msix_index;
> 	/* Call primary ISR routine */
> 	ret =3D mpi3mr_isr_primary(irq, privdata);
>=20
> -	return ret;
> +	/*
> +	 * If more IOs are expected, schedule IRQ polling thread.
> +	 * Otherwise exit from ISR.
> +	 */
> +	if (!intr_info->op_reply_q)
> +		return ret;
> +
> +	if (!intr_info->op_reply_q->enable_irq_poll ||
> +	    !atomic_read(&intr_info->op_reply_q->pend_ios))
> +		return ret;
> +
> +	disable_irq_nosync(pci_irq_vector(mrioc->pdev, midx));
> +
> +	return IRQ_WAKE_THREAD;
> }
>=20
> /**
> @@ -440,6 +473,36 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdat=
a)
>  */
> static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
> {
> +	struct mpi3mr_intr_info *intr_info =3D privdata;
> +	struct mpi3mr_ioc *mrioc;
> +	u16 midx;
> +	u32 num_op_reply =3D 0;
> +
> +	if (!intr_info || !intr_info->op_reply_q)
> +		return IRQ_NONE;
> +
> +	mrioc =3D intr_info->mrioc;
> +	midx =3D intr_info->msix_index;
> +
> +	/* Poll for pending IOs completions */
> +	do {
> +		if (!mrioc->intr_enabled)
> +			break;
> +
> +		if (!midx)
> +			mpi3mr_process_admin_reply_q(mrioc);
> +		if (intr_info->op_reply_q)
> +			num_op_reply +=3D
> +			    mpi3mr_process_op_reply_q(mrioc, intr_info);
> +
> +		usleep_range(mrioc->irqpoll_sleep, 10 * mrioc->irqpoll_sleep);
> +
> +	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
> +	    (num_op_reply < mrioc->max_host_ios));
> +
> +	intr_info->op_reply_q->enable_irq_poll =3D false;
> +	enable_irq(pci_irq_vector(mrioc->pdev, midx));
> +
> 	return IRQ_HANDLED;
> }
>=20
> @@ -1155,6 +1218,9 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_i=
oc *mrioc, u16 qidx)
> 	op_reply_q->num_replies =3D MPI3MR_OP_REP_Q_QD;
> 	op_reply_q->ci =3D 0;
> 	op_reply_q->ephase =3D 1;
> +	atomic_set(&op_reply_q->pend_ios, 0);
> +	atomic_set(&op_reply_q->in_use, 0);
> +	op_reply_q->enable_irq_poll =3D false;
>=20
> 	if (!op_reply_q->q_segments) {
> 		retval =3D mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
> @@ -1476,6 +1542,10 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrio=
c,
> 		pi =3D 0;
> 	op_req_q->pi =3D pi;
>=20
> +	if (atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios)
> +	    > MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
> +		mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll =3D true;
> +
> 	writel(op_req_q->pi,
> 	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ProducerIndex);
>=20
> @@ -2804,6 +2874,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re=
_init)
> 	u32 ioc_status, ioc_config, i;
> 	Mpi3IOCFactsData_t facts_data;
>=20
> +	mrioc->irqpoll_sleep =3D MPI3MR_IRQ_POLL_SLEEP;
> 	mrioc->change_count =3D 0;
> 	if (!re_init) {
> 		mrioc->cpu_count =3D num_online_cpus();
> @@ -3089,6 +3160,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc=
 *mrioc)
> 		mrioc->op_reply_qinfo[i].ci =3D 0;
> 		mrioc->op_reply_qinfo[i].num_replies =3D 0;
> 		mrioc->op_reply_qinfo[i].ephase =3D 0;
> +		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
> +		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
> 		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
>=20
> 		mrioc->req_qinfo[i].ci =3D 0;
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

