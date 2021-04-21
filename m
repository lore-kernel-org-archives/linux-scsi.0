Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A88C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 18:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 650776144E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 18:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhDUS6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 14:58:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234093AbhDUS6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 14:58:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LId3K0048747;
        Wed, 21 Apr 2021 18:57:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PAErrDVUNy20VfazPZKtQRxiwlkoS5Va8lBs2WMAfX0=;
 b=jtm5kM0o+uT9GH3qgLSbYBhoXBAYhB0TKEAoLj443to0n2VB2nYVYNX6qUySbqYajEvV
 4ISpgT34nBeygyYuc6kpx/8JJ65T3D7vkMyxyiT28uJDKTjroAOskHDGqcIL2zo5ac0T
 heLkb/xueumA1YVnszvkxz9pH8pmX5QhbR8jd/CfqibVdAvB2z+XMgLjkTHDwfa2Kc4Y
 FCuKfBmlNviYPbmowC4wKtUTCXxBfBBLnnJ8paXo8CbJ18/pTWLI+ZBW9tg4rklW7Lv4
 JeW7kVqEjpLhTM2LxuQF02CEJZMDhgCSN+koqM1MQWLf7ag3qILLsw0O47fXV0C0w0nF GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37yqmnk950-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 18:57:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LIesd2075574;
        Wed, 21 Apr 2021 18:57:36 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2053.outbound.protection.outlook.com [104.47.37.53])
        by userp3030.oracle.com with ESMTP id 3809m11epr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 18:57:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ie4VY8T81mySbhITC+QXbotQrd+j5756Qn3r7Eg5b6rZ6RBUsKKeNMsra8ByltlGWibJkxY/Eqw3p92l1N0Q5eEmpBVG/K2x69fpZ2wGvp5f4JWFseUqtKXcKxLLlIR5sRZkri3+FbH6j95bh2+0nbMrg3lwsDjZrWH2avKc41LldvAvuKHESF8SSBZ6NV+F9ynOFOICmaMisR/UXF8AEvcRg67sQsvDOiyFzOasHrWRQK2zMjpLie7tYc/tQ12mPaucrcDSyET8jFZmqiKUnL65vmtyDJVNyAtNKRdFHxNDHbcAhqAoczaFLq6VJ6MrgeOIfohCmXPMbRFV3VJ+8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAErrDVUNy20VfazPZKtQRxiwlkoS5Va8lBs2WMAfX0=;
 b=iiH0L4V/aX5pUGopXO6g1pzJHSA6GGGTzmkQwV55KHezXb+58iF/pHJ74fDLUh3msc1y1V1do0lvqqC5v7uzx4ZIZjlq95kLEYbiO7AGGw8PDWoHaHcaJjr81Tiv2CHdN5Y+cJYWZegOlzkmfm/nhwzVfOwYjdaticmLC1MdR8La6wpBwdHJQQOT0DXTJP1hHcedP83I75uo1AQph4xbpjUv3obYBcYUPWU+cJsSDED62DAVFzFeTejCIAIBFuActsSay/4HenLyLhpOG/6gmu8cYpd1xAr2mwuAR38TgNTzy1OH2r8C7I6MpL4ScmFA7SpIsHfCZGu8QfpPNNnTZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAErrDVUNy20VfazPZKtQRxiwlkoS5Va8lBs2WMAfX0=;
 b=bbZCes9pBvQKkC0VGh5A3qcq0MeZwHHiau3ge84l8Upj6PmgkFmy2ovYrTUmL/raOaJ/JUuPgvS+vNdExu44LgBFAsKmO193UkZ1JwbtX1k4X1WwkbEjMJ0MrbFKU9plpX5QwbjK5sNlp7b/0Jyc6rk2/4h1p4UWA47uXKBXvoM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 18:57:34 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 18:57:34 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 05/24] mpi3mr: add support of internal watchdog thread
Thread-Topic: [PATCH v3 05/24] mpi3mr: add support of internal watchdog thread
Thread-Index: AQHXNQuAhBOPBHYSG06J/6JilkROMKq/VkiA
Date:   Wed, 21 Apr 2021 18:57:34 +0000
Message-ID: <822A43B8-1B59-4EF4-96A6-075BDDC53BA9@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-6-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-6-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00decb56-4995-478e-e348-08d904f752e4
x-ms-traffictypediagnostic: SA2PR10MB4796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB47965A8BCA3BB5CC6AB6CBF7E6479@SA2PR10MB4796.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:128;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OXvzMDSvca5D8LIKDDPWsyxdzpF/s3KMHWLIQr0/dQ7he12cGr2hugxW94/el5j7px5TRh50vUCgHgaDdPXEA43QT9Ek0olEMMaIIto+g/kYC5Qfb7tYwCemm0zSfU+Oar/4Lr4AMB8/aC3p1jxmO12YyqeXTQUwpLRJsWEDMAtYCXhMJOVQozFQZTIdFQ7m4eP5Z6zGdeX2E2B1qTWbgNRDNv6YR1Jh3rw9w6+df7WEsgBF6RNucgoD6uabYXJObnVmcbc3VmfV1PxTTCRL4+20ymrM41MCWTAG1nJTP3qUByi1C7ko5POmOKWZCW+tvFp5NtN2W7UntkGF0m/tC5Omnj9RJXUw9NW2z1q8rvu9jn8MqOcBEDeK3dLd/rOo7IJIa/+PU8HiO3Lewt7ODfCda2zQKniSOu/WkcwbuwbwX2XpdBhXhh/Q5osI2Y78r9wQqhT4MsHSpK6Vp9hpRz7qaimAvAjphKwd/CujUvEQmNSEnDyttxk2DxhiETuZ17JB+UkOQM6uN9OWddsDrs1kPrGIWv7ZWsF24B8q5M00L6YFwbdxunss9gAp/6n4Q7yHEAV/c/mg7wtbQTlf94mnDcq5sEdmeQfi7voGG4uEF0HkH+5a84HPxnwMDVzgJMo/GBA9HGSGaG3mT+43S3gSbS6sQu/9t5VIWZ7/JR67DM4U3iwXCbi9QrH3F7mh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(8936002)(6512007)(186003)(478600001)(4326008)(5660300002)(53546011)(6506007)(71200400001)(26005)(36756003)(316002)(76116006)(122000001)(66556008)(64756008)(66476007)(6486002)(66946007)(83380400001)(54906003)(6916009)(38100700002)(66446008)(33656002)(2616005)(8676002)(2906002)(44832011)(86362001)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Tynp6EdYK/gjvfSAHYjERC4wBSUrSQzoyABDJCjPuP6hode4ATTUO5GqNsND?=
 =?us-ascii?Q?RaTGU6H9aedJd2N0Vrp/7+cnZpRx9qUKgFe02ZG84+z5yKfZfUXnhiRMKv4A?=
 =?us-ascii?Q?A+uod4rqnmALZ2eNFltvYoXPSiNKs8JwvRj+b9knrNPPAvsQNGdrJG/rKCI8?=
 =?us-ascii?Q?z92P6YD5W5oZL3IAigcfcVlbBCxL58px3x4Tm8kijjjv+u7+Rki1K1377z6X?=
 =?us-ascii?Q?AsgkWKiOtZPrf77T1CNQ2lxsoLJI5gUdHtFOkdbR8YNVY6gjbP0seqIarXIs?=
 =?us-ascii?Q?5CLAtX/iWt134G7dboDEiRvyjtCyve/WviKfJQqMjeQ9ZMFIoF143B8zMrYb?=
 =?us-ascii?Q?4NszG1AvzCLHk150s/EYRaL1Zxv0YoETD1RLLItxJgL3jUc4HV2pCR4OYOiM?=
 =?us-ascii?Q?/EwmPM3e0Du00FIPoxTJKZ+oY7o3TW+O4yT2KsPSFOAD4ZlCBABZUcrSeFm0?=
 =?us-ascii?Q?jxqOs1up9EpvxQeQoRcsuNajHMJxRpGjYCXBwYHtyGYvCu1C758bzkbqEYNU?=
 =?us-ascii?Q?f2YUzq1Uuzri6Vdk32hGhJMY0GhZRZEqxUiKarYuzdsrzstWYw1XjvpBcOvx?=
 =?us-ascii?Q?vVvH8iBtFeg21BgawdJtce/yOoqHKGscws4aFfWvcnT8y90Uv0+XH+KVgO0i?=
 =?us-ascii?Q?1AWCDzr30/017amXznL9LM/paWEEbZlu46SkBgy2T2+3XLErthGcpL80UUiN?=
 =?us-ascii?Q?dW1EVyaB1UEWbRtPnPEjr7xz6WlmQIKgUknAnbHLD86GSGUX6q1ufZqnoW0j?=
 =?us-ascii?Q?IMHeuTfl3ELAfjZ8+amAHyot1DXfCD8fuvFJHIoXumI2P+6nHrJaSMlagmfQ?=
 =?us-ascii?Q?R2Hx5gGBKoFMk397E6SezShPc0BKL0wPZGfxme0KK6etTGEa1ZWCfjntz8+E?=
 =?us-ascii?Q?yUoCdefPjg0ZVoiv23tI8XNS+1QCodn3KondhvvyqF7LqU4Kv9o+xTf18aQm?=
 =?us-ascii?Q?gmz0VjU2pZa1EackJ5i+dqDD3tQSrHhThicp8fHevn/pWnxpdsXNjKSXVy3Z?=
 =?us-ascii?Q?Vd9JDNCe8m0F1aBBv6Y0u4XyEmIsCZrN3UnKNGhTv9NQE7vYF5WhB4BG9Hq8?=
 =?us-ascii?Q?vFmbhYGPw1Le1vyfuQ0foJTeYVmi7ewVlG9c0exo5ocMKGLxMwBaTFXQapL3?=
 =?us-ascii?Q?a9LOnPRCd90GNqSSsyo/4CyBlULSY0wQReO+CA6CQEJ3HXbHcF1sRa7A1dN2?=
 =?us-ascii?Q?SevuyaYkS06T3n1b1c4fyBSr1tHMxh+JoUe2awP/HtSMhgOKneIEtZgnUcy/?=
 =?us-ascii?Q?niMVu4QRjUy/SumN7KQJB2PDfqat4DCLvVpJ6pVK1SJKpXfRl+DF1Quibj8d?=
 =?us-ascii?Q?tte5tQuvsvMfMCGRhl5LvO356lUfpsqqFYPlcY+E6O1qqA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D34940869626444B8098E4DFFDCF3B4E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00decb56-4995-478e-e348-08d904f752e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 18:57:34.2593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iS9etPLzqMQCc8lNsiPQP0f/h9xm3OuGv+iMvOOH4DsXm/T+ce3y0KHX1b5N7Ug4zOZqOBrwvA/y6thaPcbN7WyiFMIDtxxbUb45QPCTVVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210129
X-Proofpoint-ORIG-GUID: 7H6b_DyS4wu1XKMXgPhIL0HFPpJYmr8P
X-Proofpoint-GUID: 7H6b_DyS4wu1XKMXgPhIL0HFPpJYmr8P
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210129
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Watchdog thread is driver's internal thread which does few things like
> detecting FW fault and reset the controller, Timestamp sync etc.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  11 +++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 125 ++++++++++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c |   3 +
> 3 files changed, 139 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 00a1b63a6e16..7769ba16c9bc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -478,6 +478,10 @@ struct scmd_priv {
>  * @sense_buf_q_dma: Sense buffer queue DMA address
>  * @sbq_lock: Sense buffer queue lock
>  * @sbq_host_index: Sense buffer queuehost index
> + * @watchdog_work_q_name: Fault watchdog worker thread name
> + * @watchdog_work_q: Fault watchdog worker thread
> + * @watchdog_work: Fault watchdog work
> + * @watchdog_lock: Fault watchdog lock
>  * @is_driver_loading: Is driver still loading
>  * @scan_started: Async scan started
>  * @scan_failed: Asycn scan failed
> @@ -491,6 +495,7 @@ struct scmd_priv {
>  * @chain_buf_lock: Chain buffer list lock
>  * @reset_in_progress: Reset in progress flag
>  * @unrecoverable: Controller unrecoverable flag
> + * @diagsave_timeout: Diagnostic information save timeout
>  * @logging_level: Controller debug logging level
>  * @current_event: Firmware event currently in process
>  * @driver_info: Driver, Kernel, OS information to firmware
> @@ -572,6 +577,11 @@ struct mpi3mr_ioc {
> 	spinlock_t sbq_lock;
> 	u32 sbq_host_index;
>=20
> +	char watchdog_work_q_name[20];
> +	struct workqueue_struct *watchdog_work_q;
> +	struct delayed_work watchdog_work;
> +	spinlock_t watchdog_lock;
> +
> 	u8 is_driver_loading;
> 	u8 scan_started;
> 	u16 scan_failed;
> @@ -589,6 +599,7 @@ struct mpi3mr_ioc {
> 	u8 reset_in_progress;
> 	u8 unrecoverable;
>=20
> +	u16 diagsave_timeout;
> 	int logging_level;
>=20
> 	struct mpi3mr_fwevt *current_event;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 787483fc60eb..4c45e12154d6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1475,6 +1475,129 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mri=
oc,
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_watchdog_work - watchdog thread to monitor faults
> + * @work: work struct
> + *
> + * Watch dog work periodically executed (1 second interval) to
> + * monitor firmware fault and to issue periodic timer sync to
> + * the firmware.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_watchdog_work(struct work_struct *work)
> +{
> +	struct mpi3mr_ioc *mrioc =3D
> +	    container_of(work, struct mpi3mr_ioc, watchdog_work.work);
> +	unsigned long flags;
> +	enum mpi3mr_iocstate ioc_state;
> +	u32 fault, host_diagnostic;
> +
> +	/*Check for fault state every one second and issue Soft reset*/
> +	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> +	if (ioc_state =3D=3D MRIOC_STATE_FAULT) {
> +		fault =3D readl(&mrioc->sysif_regs->Fault) &
> +		    MPI3_SYSIF_FAULT_CODE_MASK;
> +		host_diagnostic =3D readl(&mrioc->sysif_regs->HostDiagnostic);
> +		if (host_diagnostic & MPI3_SYSIF_HOST_DIAG_SAVE_IN_PROGRESS) {
> +			if (!mrioc->diagsave_timeout) {
> +				mpi3mr_print_fault_info(mrioc);
> +				ioc_warn(mrioc, "Diag save in progress\n");
> +			}
> +			if ((mrioc->diagsave_timeout++) <=3D
> +			    MPI3_SYSIF_DIAG_SAVE_TIMEOUT)
> +				goto schedule_work;
> +		} else
> +			mpi3mr_print_fault_info(mrioc);
> +		mrioc->diagsave_timeout =3D 0;
> +
> +		if (fault =3D=3D MPI3_SYSIF_FAULT_CODE_FACTORY_RESET) {
> +			ioc_info(mrioc,
> +			    "Factory Reset Fault occurred marking controller as unrecoverable=
"
> +			    );
> +			mrioc->unrecoverable =3D 1;
> +			goto out;
> +		}
> +
> +		if ((fault =3D=3D MPI3_SYSIF_FAULT_CODE_DIAG_FAULT_RESET)
> +		    || (fault =3D=3D MPI3_SYSIF_FAULT_CODE_SOFT_RESET_IN_PROGRESS)
> +		    || (mrioc->reset_in_progress))
> +			goto out;
> +		if (fault =3D=3D MPI3_SYSIF_FAULT_CODE_CI_ACTIVATION_RESET)
> +			mpi3mr_soft_reset_handler(mrioc,
> +			    MPI3MR_RESET_FROM_CIACTIV_FAULT, 0);
> +		else
> +			mpi3mr_soft_reset_handler(mrioc,
> +			    MPI3MR_RESET_FROM_FAULT_WATCH, 0);
> +	}
> +
> +schedule_work:
> +	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> +	if (mrioc->watchdog_work_q)
> +		queue_delayed_work(mrioc->watchdog_work_q,
> +		    &mrioc->watchdog_work,
> +		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> +	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +out:
> +	return;
> +}
> +
> +/**
> + * mpi3mr_start_watchdog - Start watchdog
> + * @mrioc: Adapter instance reference
> + *
> + * Create and start the watchdog thread to monitor controller
> + * faults.
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc)
> +{
> +	if (mrioc->watchdog_work_q)
> +		return;
> +
> +	INIT_DELAYED_WORK(&mrioc->watchdog_work, mpi3mr_watchdog_work);
> +	snprintf(mrioc->watchdog_work_q_name,
> +	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
> +	    mrioc->id);
> +	mrioc->watchdog_work_q =3D
> +	    create_singlethread_workqueue(mrioc->watchdog_work_q_name);
> +	if (!mrioc->watchdog_work_q) {
> +		ioc_err(mrioc, "%s: failed (line=3D%d)\n", __func__, __LINE__);
> +		return;
> +	}
> +
> +	if (mrioc->watchdog_work_q)
> +		queue_delayed_work(mrioc->watchdog_work_q,
> +		    &mrioc->watchdog_work,
> +		    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> +}
> +
> +/**
> + * mpi3mr_stop_watchdog - Stop watchdog
> + * @mrioc: Adapter instance reference
> + *
> + * Stop the watchdog thread created to monitor controller
> + * faults.
> + *
> + * Return: Nothing.
> + */
> +void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc)
> +{
> +	unsigned long flags;
> +	struct workqueue_struct *wq;
> +
> +	spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> +	wq =3D mrioc->watchdog_work_q;
> +	mrioc->watchdog_work_q =3D NULL;
> +	spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +	if (wq) {
> +		if (!cancel_delayed_work_sync(&mrioc->watchdog_work))
> +			flush_workqueue(wq);
> +		destroy_workqueue(wq);
> +	}
> +}
> +
>=20
> /**
>  * mpi3mr_setup_admin_qpair - Setup admin queue pair
> @@ -2631,6 +2754,8 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc)
> {
> 	enum mpi3mr_iocstate ioc_state;
>=20
> +	mpi3mr_stop_watchdog(mrioc);
> +
> 	mpi3mr_ioc_disable_intr(mrioc);
>=20
> 	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 01be5f337826..7b0d52481929 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -570,6 +570,7 @@ static int mpi3mr_scan_finished(struct Scsi_Host *sho=
st,
> 	if (mrioc->scan_started)
> 		return 0;
> 	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
> +	mpi3mr_start_watchdog(mrioc);
> 	mrioc->is_driver_loading =3D 0;
>=20
> 	return 1;
> @@ -856,9 +857,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_=
device_id *id)
> 	spin_lock_init(&mrioc->admin_req_lock);
> 	spin_lock_init(&mrioc->reply_free_queue_lock);
> 	spin_lock_init(&mrioc->sbq_lock);
> +	spin_lock_init(&mrioc->watchdog_lock);
> 	spin_lock_init(&mrioc->chain_buf_lock);
>=20
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> +
> 	if (pdev->revision)
> 		mrioc->enable_segqueue =3D true;
>=20
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

