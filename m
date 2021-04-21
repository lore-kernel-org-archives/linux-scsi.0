Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D462C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 295D661453
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244610AbhDURGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:06:43 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55396 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244611AbhDURGl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 13:06:41 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LH3r20104765;
        Wed, 21 Apr 2021 17:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WUz7auwga177jLCeSNnIwLjmKts0rFFRmWBsMcKff5Y=;
 b=L/4XyAXD9POY/5ULAmEr9OZ7uVkkA7CF1L7IRAFKw8aylzTOq71hO3VUxt9vHVAmlNYB
 a/pDbBuH2OXoc3ZNxumdczDy2o4q+wZQv3kjgC6FDnGVsOSwuxbFxTWqy3mJXM6ELi+l
 JL4Fe8NMc4ei3cKhmRJfA36HFMGV/7M1QQ2yxKMj6qNX1qtQNiDyiZ9nz1xrdb0SxgjM
 4bEdrbslPGf5p0FO3bk4ovTflovqBNqNkcwWg3VADJJLWoo/bjnNiDb0RScE+O698hlb
 Zlls3lOfnGjdewcbdkbJ+uKwjkvJjWDVV72D84W9ZuBpkKiB1SUoktuleNEOFrAkM1sd hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37yn6cb2ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 17:06:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LH61kd190891;
        Wed, 21 Apr 2021 17:06:01 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 3809eujy8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 17:06:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gplw1NGToYFMhFyCjRwAv/GsIXxb4NQ8KCKPQrgg43JGrOZ2s0fmR4CIEqg2Oi1f5msvVk9EOcTchJVJNkal61oqoAmMw4duNtbPYUS4RgtepSWCFie1hnvwx6HDdAm2ZH3EiT82xd/fT9xvImVKuaBGvdodylkqgo8n+aEvhaESTEVxJMuLg715G7X7iusLyTYoJuS5iGEYaJo9iMy7QUGPOaUlq7cnbD8G7jB6M1qxggfSzz0PWMUDNSDnQVBpAUnRdySentHxQ6HuZ10OF+w0tL2vwQLNaq8eSPziDfckd5mcMq4AzAtD2Cr/4E5aINjpKg3DfNOlZAU8cjwdtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUz7auwga177jLCeSNnIwLjmKts0rFFRmWBsMcKff5Y=;
 b=SD1tk28lBMEFsYgOefUwPlfimk6HRfOU+HMMlPIyw/dZHIEdxA0vgf7oOq426McYFS+3wZ/GRKB8xfWM1KO5cgRc4ofrSmG5z+vCPZWdq5NJcwd3EDq0iPD5YvpuVP3bZh6ZeeTBWg4ZX10eCCN9jPAVs5TCFlDyMXmeyyF19APCZa8uP5V3jVqduHGGdUiYWsnY6IW7aWjE3oxXNqkfGJSGyCu54yQz8WaTP/OaZ7xmxrwynJ0yNQw2RIV9YkkNiui8yy9ZEnNeF35aTSVZtOw2qa1W7qUEKA+VqP94W9bOsnlclFeqZF+7/IDQsY1otQ+i/0SzrSEAwIiOFjdB4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUz7auwga177jLCeSNnIwLjmKts0rFFRmWBsMcKff5Y=;
 b=Qg9puvcZmnr+1nEiYymITdOp8bm6hWVJNAXBsITql4ja7C/Fox7sJONHF/z/+rTBZ9t6p4iUbLe+WC7Y195PHUvPK30nmAMHJ4IMsZVzEPxV3kvYucK+27k2xjBVWA8D4YWgvL9fNHT7GkqzUAa551WSMNZ8tMo6KqheyyzW0/I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4524.namprd10.prod.outlook.com (2603:10b6:806:118::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Wed, 21 Apr
 2021 17:05:44 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 17:05:44 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v3 04/24] mpi3mr: add support of queue command processing
Thread-Topic: [PATCH v3 04/24] mpi3mr: add support of queue command processing
Thread-Index: AQHXNQuAFMcMMYE4V0a0otjewqPBqKq/NwoA
Date:   Wed, 21 Apr 2021 17:05:44 +0000
Message-ID: <85B66BB1-25FD-4C2F-90D5-C652612C2131@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-5-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-5-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37dbda1c-c92c-4f9d-e069-08d904e7b3a9
x-ms-traffictypediagnostic: SA2PR10MB4524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4524A1AA733DA823BB21AD0AE6479@SA2PR10MB4524.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:317;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YvrYm2pQxPS9Ofye4NzN2cUP66vx5wqpI5ZIJs/6Dld8NLjwU5HLUU9znWPvxbEl+cl2+3odc1dkLu+S+sK2TaGi4gQufzG80onwrHKKoiz2XweQ6M5XQzJqmxaJm4ib+8wKJ5bYC2+rMG9TAf05EabvZBL7d/pUK5UC+Y3h2MKXpjTHUIl85ybiqEXUiKlTO62R2Y2LOqoOSKkdhnZEjtYcHzvYxoZKhnHFCQE32IeO7e4305gJuyviuOMeRj+s2Bk8+UwmeiZ9a8hO0FNqJ9M5TMse82bN/fPYC/B01s3UaiVqWP5uQlJrVnW6x6ExSiFnlh/qmOuPZv8khKLOcA3Wf72nN8dDKR/prHpkOtTp3c0MFSn8DLmAyCHmIi4IJN35ZqfPaQ/uIn/vD5APUU1I3XabdrMZHUAD1MNcy5Q3h8PRAfbhbGWszy2OeEBCyIh0wGT98Qj1TrV0rxZGDJy+PjtJApgTiL0Sa2O8tRIIHIwDdR54yTPqUyfXDqmdFgf9P41alMbBgp6BphM/jWCIyjuE5Trv1mcEywLaHLVafLi03CS4tpz14SBW9ZVoUsKieWhhgKHXxNldJF2LTisguL0OlrqFNwlEUDeNTkvT9Eck1SMyko+u9AhbOCdUX4eJc+7FIMYjAgH8YtDCtAiQTjbnr6n0SUbeNrGuf3DeoTnarcemRk/T6/QuvJUi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(366004)(136003)(83380400001)(2616005)(478600001)(316002)(44832011)(5660300002)(26005)(4326008)(33656002)(53546011)(19627235002)(30864003)(64756008)(76116006)(66446008)(66946007)(6486002)(186003)(66556008)(66476007)(71200400001)(2906002)(36756003)(8936002)(6916009)(54906003)(38100700002)(6512007)(122000001)(6506007)(86362001)(8676002)(32563001)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?i6/ZJuLYpYgnTWgKHprJGWbjPOTCwVyPQWmFRzf2SQTniVMSClgF7QJW4UgJ?=
 =?us-ascii?Q?T2DIHvRnQr0TuVs8s1Es4oIDDCc8c0t1LX2RZXhljv8n5UTT3BGVi0CY+t+Q?=
 =?us-ascii?Q?uz3ONVTD3Q9amaOhxHcGDIxf8uHHkzRq1fomVZqQ+iWsQjgMQHlGnYlkYTyh?=
 =?us-ascii?Q?1lz97gdmq7GfZ4kPvu23z3NHPL7zbHOotnkRHg/a+WsfQgdimO+z3Zc96QaA?=
 =?us-ascii?Q?A/INDdcR+PhbFQy6xQPLWFaomFsIKHRe4lYSzsXVDJ95mRrjBW6Rs1SeF62P?=
 =?us-ascii?Q?VVpNo60P2QTrIBK6+XJIZOKe6RRypPzpb0jLZp3KLyUE4EgH8uBrvqMb6cAF?=
 =?us-ascii?Q?5UZxB1LlWFvffdQxCpakmpJQacjKbwM38tCa1MzJXyjqqwtw6QduPDCRJ/nq?=
 =?us-ascii?Q?MAaMsBFwLNYBM7Y4hSbKE2bmbKs5fanUBmh0+VyI0eSoLiFDIF6KlbVgmOF/?=
 =?us-ascii?Q?1uawuICxk1HMzoq3lP+/9jiAyC2b8oC2BMCILw21pWLP3ZOAbxo2rOJWdkya?=
 =?us-ascii?Q?cjpOKHaY5SG/iKqyuHgaWkdLaopQBUvbnz9I202btTVJm+6CZ0o1NV6UWt4V?=
 =?us-ascii?Q?lLokWukqL875Ti6fPVbmjraqPD9j4pWFEcBwFbmMF66AQ6F97QHa08tE8UHP?=
 =?us-ascii?Q?RZFcSE5eacNo/SZ0iZ5kDOJR5kP6LivLUc05vMi60wfAGTCRpcR4/PLAEhBY?=
 =?us-ascii?Q?dPvAEnRHLRsxIGq96baL43vSv5URCX4TjTShVeiFOsz0oecGtTdH8tVD5WlN?=
 =?us-ascii?Q?LEC73yk2wQ29RVNR1TYOTZy7e3oe7/bN6ML7t9RrRYBuKXs0F+Zxo6CswUWC?=
 =?us-ascii?Q?npLP7/Nb4lJ42E9eySKD5FqTfg6CNaT8tXKfsjzjNsm35xsLTyBXIcoSzbpr?=
 =?us-ascii?Q?arm7o5KjiOjkSKic8hbK0eguVol6U83C2Lbzfo5lkyJB0bxThB51vRndRnXC?=
 =?us-ascii?Q?sFPKCXixmzaTY9dzSIFnyAMsOmI2asNwxgaCUP61EAI4atsUwZ7X7Ejju8R7?=
 =?us-ascii?Q?8s7ehK3AaFz5iM6PG2DR4d37zb+LP/lMOTD6sQik46FmQOju1lF0RRba8KYM?=
 =?us-ascii?Q?4W7TY/SXNKKlzx4Azs2Xb5BSMU9He6sp8quADT8v338SKFduhis0eVCsK5uE?=
 =?us-ascii?Q?iyRU//DhfXkZfEk8q9mNjDwsKtJebjr1F7S/QyVGrWlAqzWZNAgZ9ldW0x+t?=
 =?us-ascii?Q?hz7UhPHfJZqQcvNVQS49t+XjIcFB991+ftqB3t3ZcCZNVo1JUfLlTBanDw38?=
 =?us-ascii?Q?Ty4KQQNPw248Gj28uN27PcS5hz77gceO7s/XtpIx4bK+n3gMOdkW4A3E7Tko?=
 =?us-ascii?Q?d2wWN6b/Uu/sU9/+Vzn1MisdcY9EN3O0rALeJgXdzgB2RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <357B68C9060DFC46B61F271A2FF84467@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37dbda1c-c92c-4f9d-e069-08d904e7b3a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 17:05:44.6629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PpPMN2Zh2Inj9ltoZYM+Sp4Dr/97YAXFi+xAWdHqBC3NBbuIUvvA84xWfvUwdOuHtVfuebg+tZF33wsCy6qvFmOEmpg/MNgInS5v0S1GQPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4524
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104210122
X-Proofpoint-GUID: oOykYOE4d4z5MMf72CfS5wwaJGcMp3B9
X-Proofpoint-ORIG-GUID: oOykYOE4d4z5MMf72CfS5wwaJGcMp3B9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Send Port Enable Request to FW for Device Discovery.
> As part of port enable completion driver calls scan_start and
> scan_finished hooks.
> scsi layer reference like sdev, starget etc is added but actual
> device discovery will be supported once driver add complete event
> process handling (It is added in subsequent patches)
>=20
> This patch provides interface which is used to interact with FW
> via operational queue pairs.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> Cc: hare@suse.de
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  51 +++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 249 ++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 645 +++++++++++++++++++++++++++++++-
> 3 files changed, 943 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index c26105b23759..00a1b63a6e16 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -96,6 +96,7 @@ extern struct list_head mrioc_list;
>=20
> /* command/controller interaction timeout definitions in seconds */
> #define MPI3MR_INTADMCMD_TIMEOUT		10
> +#define MPI3MR_PORTENABLE_TIMEOUT		300
> #define MPI3MR_RESETTM_TIMEOUT			30
> #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
>=20
> @@ -312,7 +313,43 @@ struct mpi3mr_intr_info {
> 	char name[MPI3MR_NAME_LENGTH];
> };
>=20
> +/**
> + * struct mpi3mr_stgt_priv_data - SCSI target private structure
> + *
> + * @starget: Scsi_target pointer
> + * @dev_handle: FW device handle
> + * @perst_id: FW assigned Persistent ID
> + * @num_luns: Number of Logical Units
> + * @block_io: I/O blocked to the device or not
> + * @dev_removed: Device removed in the Firmware
> + * @dev_removedelay: Device is waiting to be removed in FW
> + * @dev_type: Device type
> + * @tgt_dev: Internal target device pointer
> + */
> +struct mpi3mr_stgt_priv_data {
> +	struct scsi_target *starget;
> +	u16 dev_handle;
> +	u16 perst_id;
> +	u32 num_luns;
> +	atomic_t block_io;
> +	u8 dev_removed;
> +	u8 dev_removedelay;
> +	u8 dev_type;
> +	struct mpi3mr_tgt_dev *tgt_dev;
> +};
>=20
> +/**
> + * struct mpi3mr_stgt_priv_data - SCSI device private structure
> + *
> + * @tgt_priv_data: Scsi_target private data pointer
> + * @lun_id: LUN ID of the device
> + * @ncq_prio_enable: NCQ priority enable for SATA device
> + */
> +struct mpi3mr_sdev_priv_data {
> +	struct mpi3mr_stgt_priv_data *tgt_priv_data;
> +	u32 lun_id;
> +	u8 ncq_prio_enable;
> +};
>=20
> /**
>  * struct mpi3mr_drv_cmd - Internal command tracker
> @@ -442,12 +479,16 @@ struct scmd_priv {
>  * @sbq_lock: Sense buffer queue lock
>  * @sbq_host_index: Sense buffer queuehost index
>  * @is_driver_loading: Is driver still loading
> + * @scan_started: Async scan started
> + * @scan_failed: Asycn scan failed
> + * @stop_drv_processing: Stop all command processing
>  * @max_host_ios: Maximum host I/O count
>  * @chain_buf_count: Chain buffer count
>  * @chain_buf_pool: Chain buffer pool
>  * @chain_sgl_list: Chain SGL list
>  * @chain_bitmap_sz: Chain buffer allocator bitmap size
>  * @chain_bitmap: Chain buffer allocator bitmap
> + * @chain_buf_lock: Chain buffer list lock
>  * @reset_in_progress: Reset in progress flag
>  * @unrecoverable: Controller unrecoverable flag
>  * @logging_level: Controller debug logging level
> @@ -532,6 +573,9 @@ struct mpi3mr_ioc {
> 	u32 sbq_host_index;
>=20
> 	u8 is_driver_loading;
> +	u8 scan_started;
> +	u16 scan_failed;
> +	u8 stop_drv_processing;
>=20
> 	u16 max_host_ios;
>=20
> @@ -540,6 +584,7 @@ struct mpi3mr_ioc {
> 	struct chain_element *chain_sgl_list;
> 	u16  chain_bitmap_sz;
> 	void *chain_bitmap;
> +	spinlock_t chain_buf_lock;
>=20
> 	u8 reset_in_progress;
> 	u8 unrecoverable;
> @@ -556,8 +601,11 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)=
;
> void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
> int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc);
> void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc);
> +int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
> int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
> u16 admin_req_sz, u8 ignore_reset);
> +int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
> +			   struct op_req_qinfo *opreqq, u8 *req);
> void mpi3mr_add_sg_single(void *paddr, u8 flags, u32 length,
> 			  dma_addr_t dma_addr);
> void mpi3mr_build_zero_len_sge(void *paddr);
> @@ -568,6 +616,9 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *m=
rioc,
> void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
> 				     u64 sense_buf_dma);
>=20
> +void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
> +				  Mpi3DefaultReplyDescriptor_t *reply_desc,
> +				  u64 *reply_dma, u16 qidx);
> void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc);
> void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 694e54bbb07c..787483fc60eb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -25,6 +25,23 @@ static inline void mpi3mr_writeq(__u64 b, volatile voi=
d __iomem *addr)
> }
> #endif
>=20
> +static inline bool
> +mpi3mr_check_req_qfull(struct op_req_qinfo *op_req_q)
> +{
> +	u16 pi, ci, max_entries;
> +	bool is_qfull =3D false;
> +
> +	pi =3D op_req_q->pi;
> +	ci =3D READ_ONCE(op_req_q->ci);
> +	max_entries =3D op_req_q->num_requests;
> +
> +	if ((ci =3D=3D (pi + 1)) || ((!ci) && (pi =3D=3D (max_entries - 1))))
> +		is_qfull =3D true;
> +
> +	return is_qfull;
> +}
> +
> +
> static void mpi3mr_sync_irqs(struct mpi3mr_ioc *mrioc)
> {
> 	u16 i, max_vectors;
> @@ -283,6 +300,85 @@ static int mpi3mr_process_admin_reply_q(struct mpi3m=
r_ioc *mrioc)
> 	return num_admin_replies;
> }
>=20
> +/**
> + * mpi3mr_get_reply_desc - get reply descriptor frame corresponding to
> + *	queue's consumer index from operational reply descriptor queue.
> + * @op_reply_q: op_reply_qinfo object
> + * @reply_ci: operational reply descriptor's queue consumer index
> + *
> + * Returns reply descriptor frame address
> + */
> +static inline Mpi3DefaultReplyDescriptor_t *
> +mpi3mr_get_reply_desc(struct op_reply_qinfo *op_reply_q, u32 reply_ci)
> +{
> +	void *segment_base_addr;
> +	struct segments *segments =3D op_reply_q->q_segments;
> +	Mpi3DefaultReplyDescriptor_t *reply_desc =3D NULL;
> +
> +	segment_base_addr =3D
> +	    segments[reply_ci / op_reply_q->segment_qd].segment;
> +	reply_desc =3D (Mpi3DefaultReplyDescriptor_t *)segment_base_addr +
> +	    (reply_ci % op_reply_q->segment_qd);
> +	return reply_desc;
> +}
> +
> +
> +static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_intr_info *intr_info)
> +{
> +	struct op_reply_qinfo *op_reply_q =3D intr_info->op_reply_q;
> +	struct op_req_qinfo *op_req_q;
> +	u32 exp_phase;
> +	u32 reply_ci;
> +	u32 num_op_reply =3D 0;
> +	u64 reply_dma =3D 0;
> +	Mpi3DefaultReplyDescriptor_t *reply_desc;
> +	u16 req_q_idx =3D 0, reply_qidx;
> +
> +	reply_qidx =3D op_reply_q->qid - 1;
> +
> +	exp_phase =3D op_reply_q->ephase;
> +	reply_ci =3D op_reply_q->ci;
> +
> +	reply_desc =3D mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> +	if ((le16_to_cpu(reply_desc->ReplyFlags) &
> +	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase) {
> +		return 0;
> +	}
> +
> +	do {
> +		req_q_idx =3D le16_to_cpu(reply_desc->RequestQueueID) - 1;
> +		op_req_q =3D &mrioc->req_qinfo[req_q_idx];
> +
> +		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->RequestQueueCI));
> +		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
> +		    reply_qidx);
> +		if (reply_dma)
> +			mpi3mr_repost_reply_buf(mrioc, reply_dma);
> +		num_op_reply++;
> +
> +		if (++reply_ci =3D=3D op_reply_q->num_replies) {
> +			reply_ci =3D 0;
> +			exp_phase ^=3D 1;
> +		}
> +
> +		reply_desc =3D mpi3mr_get_reply_desc(op_reply_q, reply_ci);
> +
> +		if ((le16_to_cpu(reply_desc->ReplyFlags) &
> +		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) !=3D exp_phase)
> +			break;
> +
> +	} while (1);
> +
> +
> +	writel(reply_ci,
> +	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ConsumerIndex);
> +	op_reply_q->ci =3D reply_ci;
> +	op_reply_q->ephase =3D exp_phase;
> +
> +	return num_op_reply;
> +}
> +
> static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
> {
> 	struct mpi3mr_intr_info *intr_info =3D privdata;
> @@ -1311,6 +1407,74 @@ static int mpi3mr_create_op_queues(struct mpi3mr_i=
oc *mrioc)
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_op_request_post - Post request to operational queue
> + * @mrioc: Adapter reference
> + * @op_req_q: Operational request queue info
> + * @req: MPI3 request
> + *
> + * Post the MPI3 request into operational request queue and
> + * inform the controller, if the queue is full return
> + * appropriate error.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
> +	struct op_req_qinfo *op_req_q, u8 *req)
> +{
> +	u16 pi =3D 0, max_entries, reply_qidx =3D 0, midx;
> +	int retval =3D 0;
> +	unsigned long flags;
> +	u8 *req_entry;
> +	void *segment_base_addr;
> +	u16 req_sz =3D mrioc->facts.op_req_sz;
> +	struct segments *segments =3D op_req_q->q_segments;
> +
> +	reply_qidx =3D op_req_q->reply_qid - 1;
> +
> +	if (mrioc->unrecoverable)
> +		return -EFAULT;
> +
> +	spin_lock_irqsave(&op_req_q->q_lock, flags);
> +	pi =3D op_req_q->pi;
> +	max_entries =3D op_req_q->num_requests;
> +
> +	if (mpi3mr_check_req_qfull(op_req_q)) {
> +		midx =3D REPLY_QUEUE_IDX_TO_MSIX_IDX(
> +		    reply_qidx, mrioc->op_reply_q_offset);
> +		mpi3mr_process_op_reply_q(mrioc, &mrioc->intr_info[midx]);
> +
> +		if (mpi3mr_check_req_qfull(op_req_q)) {
> +			retval =3D -EAGAIN;
> +			goto out;
> +		}
> +	}
> +
> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "OpReqQ submit reset in progress\n");
> +		retval =3D -EAGAIN;
> +		goto out;
> +	}
> +
> +	segment_base_addr =3D segments[pi / op_req_q->segment_qd].segment;
> +	req_entry =3D (u8 *)segment_base_addr +
> +	    ((pi % op_req_q->segment_qd) * req_sz);
> +
> +	memset(req_entry, 0, req_sz);
> +	memcpy(req_entry, req, MPI3MR_ADMIN_REQ_FRAME_SZ);
> +
> +	if (++pi =3D=3D max_entries)
> +		pi =3D 0;
> +	op_req_q->pi =3D pi;
> +
> +	writel(op_req_q->pi,
> +	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ProducerIndex);
> +
> +out:
> +	spin_unlock_irqrestore(&op_req_q->q_lock, flags);
> +	return retval;
> +}
> +
>=20
> /**
>  * mpi3mr_setup_admin_qpair - Setup admin queue pair
> @@ -1900,6 +2064,91 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_i=
oc *mrioc)
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_port_enable_complete - Mark port enable complete
> + * @mrioc: Adapter instance reference
> + * @drv_cmd: Internal command tracker
> + *
> + * Call back for asynchronous port enable request sets the
> + * driver command to indicate port enable request is complete.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_port_enable_complete(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_drv_cmd *drv_cmd)
> +{
> +
> +	drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +	drv_cmd->callback =3D NULL;
> +	mrioc->scan_failed =3D drv_cmd->ioc_status;
> +	mrioc->scan_started =3D 0;
> +
> +}
> +
> +/**
> + * mpi3mr_issue_port_enable - Issue Port Enable
> + * @mrioc: Adapter instance reference
> + * @async: Flag to wait for completion or not
> + *
> + * Issue Port Enable MPI request through admin queue and if the
> + * async flag is not set wait for the completion of the port
> + * enable or time out.
> + *
> + * Return: 0 on success, non-zero on failures.
> + */
> +int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async)
> +{
> +	Mpi3PortEnableRequest_t pe_req;
> +	int retval =3D 0;
> +	u32 pe_timeout =3D MPI3MR_PORTENABLE_TIMEOUT;
> +
> +	memset(&pe_req, 0, sizeof(pe_req));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "Issue PortEnable: Init command is in use\n");
> +		mutex_unlock(&mrioc->init_cmds.mutex);
> +		goto out;
> +	}
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_PENDING;
> +	if (async) {
> +		mrioc->init_cmds.is_waiting =3D 0;
> +		mrioc->init_cmds.callback =3D mpi3mr_port_enable_complete;
> +	} else {
> +		mrioc->init_cmds.is_waiting =3D 1;
> +		mrioc->init_cmds.callback =3D NULL;
> +		init_completion(&mrioc->init_cmds.done);
> +	}
> +	pe_req.HostTag =3D cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	pe_req.Function =3D MPI3_FUNCTION_PORT_ENABLE;
> +
> +	retval =3D mpi3mr_admin_request_post(mrioc, &pe_req, sizeof(pe_req), 1)=
;
> +	if (retval) {
> +		ioc_err(mrioc, "Issue PortEnable: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +	if (!async) {
> +		wait_for_completion_timeout(&mrioc->init_cmds.done,
> +		    (pe_timeout * HZ));
> +		if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +			ioc_err(mrioc, "Issue PortEnable: command timed out\n");
> +			retval =3D -1;
> +			mrioc->scan_failed =3D MPI3_IOCSTATUS_INTERNAL_ERROR;
> +			mpi3mr_set_diagsave(mrioc);
> +			mpi3mr_issue_reset(mrioc,
> +			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
> +			    MPI3MR_RESET_FROM_PE_TIMEOUT);
> +			mrioc->unrecoverable =3D 1;
> +			goto out_unlock;
> +		}
> +		mpi3mr_port_enable_complete(mrioc, &mrioc->init_cmds);
> +	}
> +out_unlock:
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +out:
> +	return retval;
> +}
> +
>=20
> /**
>  * mpi3mr_cleanup_resources - Free PCI resources
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 3cf0be63842f..01be5f337826 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -26,6 +26,471 @@ module_param(logging_level, int, 0);
> MODULE_PARM_DESC(logging_level,
> 	" bits for enabling additional logging info (default=3D0)");
>=20
> +/* Forward declarations*/
> +/**
> + * mpi3mr_host_tag_for_scmd - Get host tag for a scmd
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + *
> + * Calculate the host tag based on block tag for a given scmd.
> + *
> + * Return: Valid host tag or MPI3MR_HOSTTAG_INVALID.
> + */
> +static u16 mpi3mr_host_tag_for_scmd(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd)
> +{
> +	struct scmd_priv *priv =3D NULL;
> +	u32 unique_tag;
> +	u16 host_tag, hw_queue;
> +
> +	unique_tag =3D blk_mq_unique_tag(scmd->request);
> +
> +	hw_queue =3D blk_mq_unique_tag_to_hwq(unique_tag);
> +	if (hw_queue >=3D mrioc->num_op_reply_q)
> +		return MPI3MR_HOSTTAG_INVALID;
> +	host_tag =3D blk_mq_unique_tag_to_tag(unique_tag);
> +
> +	if (WARN_ON(host_tag >=3D mrioc->max_host_ios))
> +		return MPI3MR_HOSTTAG_INVALID;
> +
> +	priv =3D scsi_cmd_priv(scmd);
> +	/*host_tag 0 is invalid hence incrementing by 1*/
> +	priv->host_tag =3D host_tag + 1;
> +	priv->scmd =3D scmd;
> +	priv->in_lld_scope =3D 1;
> +	priv->req_q_idx =3D hw_queue;
> +	priv->chain_idx =3D -1;
> +	return priv->host_tag;
> +}
> +
> +/**
> + * mpi3mr_scmd_from_host_tag - Get SCSI command from host tag
> + * @mrioc: Adapter instance reference
> + * @host_tag: Host tag
> + * @qidx: Operational queue index
> + *
> + * Identify the block tag from the host tag and queue index and
> + * retrieve associated scsi command using scsi_host_find_tag().
> + *
> + * Return: SCSI command reference or NULL.
> + */
> +static struct scsi_cmnd *mpi3mr_scmd_from_host_tag(
> +	struct mpi3mr_ioc *mrioc, u16 host_tag, u16 qidx)
> +{
> +	struct scsi_cmnd *scmd =3D NULL;
> +	struct scmd_priv *priv =3D NULL;
> +	u32 unique_tag =3D host_tag - 1;
> +
> +	if (WARN_ON(host_tag > mrioc->max_host_ios))
> +		goto out;
> +
> +	unique_tag |=3D (qidx << BLK_MQ_UNIQUE_TAG_BITS);
> +
> +	scmd =3D scsi_host_find_tag(mrioc->shost, unique_tag);
> +	if (scmd) {
> +		priv =3D scsi_cmd_priv(scmd);
> +		if (!priv->in_lld_scope)
> +			scmd =3D NULL;
> +	}
> +out:
> +	return scmd;
> +}
> +
> +/**
> + * mpi3mr_clear_scmd_priv - Cleanup SCSI command private date
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + *
> + * Invalidate the SCSI command private data to mark the command
> + * is not in LLD scope anymore.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_clear_scmd_priv(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd)
> +{
> +	struct scmd_priv *priv =3D NULL;
> +
> +	priv =3D scsi_cmd_priv(scmd);
> +
> +	if (WARN_ON(priv->in_lld_scope =3D=3D 0))
> +		return;
> +	priv->host_tag =3D MPI3MR_HOSTTAG_INVALID;
> +	priv->req_q_idx =3D 0xFFFF;
> +	priv->scmd =3D NULL;
> +	priv->in_lld_scope =3D 0;
> +	if (priv->chain_idx >=3D 0) {
> +		clear_bit(priv->chain_idx, mrioc->chain_bitmap);
> +		priv->chain_idx =3D -1;
> +	}
> +}
> +
> +/**
> + * mpi3mr_process_op_reply_desc - reply descriptor handler
> + * @mrioc: Adapter instance reference
> + * @reply_desc: Operational reply descriptor
> + * @reply_dma: place holder for reply DMA address
> + * @qidx: Operational queue index
> + *
> + * Process the operational reply descriptor and identifies the
> + * descriptor type. Based on the descriptor map the MPI3 request
> + * status to a SCSI command status and calls scsi_done call
> + * back.
> + *
> + * Return: Nothing
> + */
> +void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
> +	Mpi3DefaultReplyDescriptor_t *reply_desc, u64 *reply_dma, u16 qidx)
> +{
> +	u16 reply_desc_type, host_tag =3D 0;
> +	u16 ioc_status =3D MPI3_IOCSTATUS_SUCCESS;
> +	u32 ioc_loginfo =3D 0;
> +	Mpi3StatusReplyDescriptor_t *status_desc =3D NULL;
> +	Mpi3AddressReplyDescriptor_t *addr_desc =3D NULL;
> +	Mpi3SuccessReplyDescriptor_t *success_desc =3D NULL;
> +	Mpi3SCSIIOReply_t *scsi_reply =3D NULL;
> +	struct scsi_cmnd *scmd =3D NULL;
> +	struct scmd_priv *priv =3D NULL;
> +	u8 *sense_buf =3D NULL;
> +	u8 scsi_state =3D 0, scsi_status =3D 0, sense_state =3D 0;
> +	u32 xfer_count =3D 0, sense_count =3D 0, resp_data =3D 0;
> +	u16 dev_handle =3D 0xFFFF;
> +	struct scsi_sense_hdr sshdr;
> +
> +	*reply_dma =3D 0;
> +	reply_desc_type =3D le16_to_cpu(reply_desc->ReplyFlags) &
> +	    MPI3_REPLY_DESCRIPT_FLAGS_TYPE_MASK;
> +	switch (reply_desc_type) {
> +	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_STATUS:
> +		status_desc =3D (Mpi3StatusReplyDescriptor_t *)reply_desc;
> +		host_tag =3D le16_to_cpu(status_desc->HostTag);
> +		ioc_status =3D le16_to_cpu(status_desc->IOCStatus);
> +		if (ioc_status &
> +		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
> +			ioc_loginfo =3D le32_to_cpu(status_desc->IOCLogInfo);
> +		ioc_status &=3D MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
> +		break;
> +	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_ADDRESS_REPLY:
> +		addr_desc =3D (Mpi3AddressReplyDescriptor_t *)reply_desc;
> +		*reply_dma =3D le64_to_cpu(addr_desc->ReplyFrameAddress);
> +		scsi_reply =3D mpi3mr_get_reply_virt_addr(mrioc,
> +		    *reply_dma);
> +		if (!scsi_reply) {
> +			panic("%s: scsi_reply is NULL, this shouldn't happen\n",
> +			    mrioc->name);
> +			goto out;
> +		}
> +		host_tag =3D le16_to_cpu(scsi_reply->HostTag);
> +		ioc_status =3D le16_to_cpu(scsi_reply->IOCStatus);
> +		scsi_status =3D scsi_reply->SCSIStatus;
> +		scsi_state =3D scsi_reply->SCSIState;
> +		dev_handle =3D le16_to_cpu(scsi_reply->DevHandle);
> +		sense_state =3D (scsi_state & MPI3_SCSI_STATE_SENSE_MASK);
> +		xfer_count =3D le32_to_cpu(scsi_reply->TransferCount);
> +		sense_count =3D le32_to_cpu(scsi_reply->SenseCount);
> +		resp_data =3D le32_to_cpu(scsi_reply->ResponseData);
> +		sense_buf =3D mpi3mr_get_sensebuf_virt_addr(mrioc,
> +		    le64_to_cpu(scsi_reply->SenseDataBufferAddress));
> +		if (ioc_status &
> +		    MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_LOGINFOAVAIL)
> +			ioc_loginfo =3D le32_to_cpu(scsi_reply->IOCLogInfo);
> +		ioc_status &=3D MPI3_REPLY_DESCRIPT_STATUS_IOCSTATUS_STATUS_MASK;
> +		if (sense_state =3D=3D MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY)
> +			panic("%s: Ran out of sense buffers\n", mrioc->name);
> +		break;
> +	case MPI3_REPLY_DESCRIPT_FLAGS_TYPE_SUCCESS:
> +		success_desc =3D (Mpi3SuccessReplyDescriptor_t *)reply_desc;
> +		host_tag =3D le16_to_cpu(success_desc->HostTag);
> +		break;
> +	default:
> +		break;
> +	}
> +	scmd =3D mpi3mr_scmd_from_host_tag(mrioc, host_tag, qidx);
> +	if (!scmd) {
> +		panic("%s: Cannot Identify scmd for host_tag 0x%x\n",
> +		    mrioc->name, host_tag);
> +		goto out;
> +	}
> +	priv =3D scsi_cmd_priv(scmd);
> +	if (success_desc) {
> +		scmd->result =3D DID_OK << 16;
> +		goto out_success;
> +	}
> +	if (ioc_status =3D=3D MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN &&
> +	    xfer_count =3D=3D 0 && (scsi_status =3D=3D MPI3_SCSI_STATUS_BUSY ||
> +	    scsi_status =3D=3D MPI3_SCSI_STATUS_RESERVATION_CONFLICT ||
> +	    scsi_status =3D=3D MPI3_SCSI_STATUS_TASK_SET_FULL))
> +		ioc_status =3D MPI3_IOCSTATUS_SUCCESS;
> +
> +	if ((sense_state =3D=3D MPI3_SCSI_STATE_SENSE_VALID) && sense_count
> +	    && sense_buf) {
> +		u32 sz =3D min_t(u32, SCSI_SENSE_BUFFERSIZE, sense_count);
> +
> +		memcpy(scmd->sense_buffer, sense_buf, sz);
> +	}
> +
> +	switch (ioc_status) {
> +	case MPI3_IOCSTATUS_BUSY:
> +	case MPI3_IOCSTATUS_INSUFFICIENT_RESOURCES:
> +		scmd->result =3D SAM_STAT_BUSY;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_DEVICE_NOT_THERE:
> +		scmd->result =3D DID_NO_CONNECT << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_IOC_TERMINATED:
> +		scmd->result =3D DID_SOFT_ERROR << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_TASK_TERMINATED:
> +	case MPI3_IOCSTATUS_SCSI_EXT_TERMINATED:
> +		scmd->result =3D DID_RESET << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_RESIDUAL_MISMATCH:
> +		if ((xfer_count =3D=3D 0) || (scmd->underflow > xfer_count))
> +			scmd->result =3D DID_SOFT_ERROR << 16;
> +		else
> +			scmd->result =3D (DID_OK << 16) | scsi_status;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN:
> +		scmd->result =3D (DID_OK << 16) | scsi_status;
> +		if (sense_state =3D=3D MPI3_SCSI_STATE_SENSE_VALID)
> +			break;
> +		if (xfer_count < scmd->underflow) {
> +			if (scsi_status =3D=3D SAM_STAT_BUSY)
> +				scmd->result =3D SAM_STAT_BUSY;
> +			else
> +				scmd->result =3D DID_SOFT_ERROR << 16;
> +		} else if ((scsi_state & (MPI3_SCSI_STATE_NO_SCSI_STATUS))
> +		    || (sense_state !=3D MPI3_SCSI_STATE_SENSE_NOT_AVAILABLE))
> +			scmd->result =3D DID_SOFT_ERROR << 16;
> +		else if (scsi_state & MPI3_SCSI_STATE_TERMINATED)
> +			scmd->result =3D DID_RESET << 16;
> +		else if (!xfer_count && scmd->cmnd[0] =3D=3D REPORT_LUNS) {
> +			scsi_status =3D SAM_STAT_CHECK_CONDITION;
> +			scmd->result =3D (DRIVER_SENSE << 24) |
> +			    SAM_STAT_CHECK_CONDITION;
> +			scmd->sense_buffer[0] =3D 0x70;
> +			scmd->sense_buffer[2] =3D ILLEGAL_REQUEST;
> +			scmd->sense_buffer[12] =3D 0x20;
> +			scmd->sense_buffer[13] =3D 0;
> +		}
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_DATA_OVERRUN:
> +		scsi_set_resid(scmd, 0);
> +		fallthrough;
> +	case MPI3_IOCSTATUS_SCSI_RECOVERED_ERROR:
> +	case MPI3_IOCSTATUS_SUCCESS:
> +		scmd->result =3D (DID_OK << 16) | scsi_status;
> +		if ((scsi_state & (MPI3_SCSI_STATE_NO_SCSI_STATUS))
> +			|| (sense_state =3D=3D MPI3_SCSI_STATE_SENSE_FAILED)
> +			|| (sense_state =3D=3D MPI3_SCSI_STATE_SENSE_BUFF_Q_EMPTY))
> +			scmd->result =3D DID_SOFT_ERROR << 16;
> +		else if (scsi_state & MPI3_SCSI_STATE_TERMINATED)
> +			scmd->result =3D DID_RESET << 16;
> +		break;
> +	case MPI3_IOCSTATUS_SCSI_PROTOCOL_ERROR:
> +	case MPI3_IOCSTATUS_INVALID_FUNCTION:
> +	case MPI3_IOCSTATUS_INVALID_SGL:
> +	case MPI3_IOCSTATUS_INTERNAL_ERROR:
> +	case MPI3_IOCSTATUS_INVALID_FIELD:
> +	case MPI3_IOCSTATUS_INVALID_STATE:
> +	case MPI3_IOCSTATUS_SCSI_IO_DATA_ERROR:
> +	case MPI3_IOCSTATUS_SCSI_TASK_MGMT_FAILED:
> +	case MPI3_IOCSTATUS_INSUFFICIENT_POWER:
> +	default:
> +		scmd->result =3D DID_SOFT_ERROR << 16;
> +		break;
> +	}
> +
> +	if (scmd->result !=3D (DID_OK << 16) && (scmd->cmnd[0] !=3D ATA_12) &&
> +	    (scmd->cmnd[0] !=3D ATA_16)) {
> +		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
> +		    scmd->result);
> +		scsi_print_command(scmd);
> +		ioc_info(mrioc,
> +		    "%s :Command issued to handle 0x%02x returned with error 0x%04x lo=
ginfo 0x%08x, qid %d\n",
> +		    __func__, dev_handle, ioc_status, ioc_loginfo,
> +		    priv->req_q_idx+1);
> +		ioc_info(mrioc,
> +		    " host_tag %d scsi_state 0x%02x scsi_status 0x%02x, xfer_cnt %d re=
sp_data 0x%x\n",
> +		    host_tag, scsi_state, scsi_status, xfer_count, resp_data);
> +		if (sense_buf) {
> +			scsi_normalize_sense(sense_buf, sense_count, &sshdr);
> +			ioc_info(mrioc,
> +			    "%s :sense_count 0x%x, sense_key 0x%x ASC 0x%x, ASCQ 0x%x\n",
> +			    __func__, sense_count, sshdr.sense_key,
> +			    sshdr.asc, sshdr.ascq);
> +		}
> +	}
> +out_success:
> +	mpi3mr_clear_scmd_priv(mrioc, scmd);
> +	scsi_dma_unmap(scmd);
> +	scmd->scsi_done(scmd);
> +out:
> +	if (sense_buf)
> +		mpi3mr_repost_sense_buf(mrioc,
> +		    le64_to_cpu(scsi_reply->SenseDataBufferAddress));
> +}
> +
> +/**
> + * mpi3mr_get_chain_idx - get free chain buffer index
> + * @mrioc: Adapter instance reference
> + *
> + * Try to get a free chain buffer index from the free pool.
> + *
> + * Return: -1 on failure or the free chain buffer index
> + */
> +static int mpi3mr_get_chain_idx(struct mpi3mr_ioc *mrioc)
> +{
> +	u8 retry_count =3D 5;
> +	int cmd_idx =3D -1;
> +
> +	do {
> +		spin_lock(&mrioc->chain_buf_lock);
> +		cmd_idx =3D find_first_zero_bit(mrioc->chain_bitmap,
> +		    mrioc->chain_buf_count);
> +		if (cmd_idx < mrioc->chain_buf_count) {
> +			set_bit(cmd_idx, mrioc->chain_bitmap);
> +			spin_unlock(&mrioc->chain_buf_lock);
> +			break;
> +		}
> +		spin_unlock(&mrioc->chain_buf_lock);
> +		cmd_idx =3D -1;
> +	} while (retry_count--);
> +	return cmd_idx;
> +}
> +
> +/**
> + * mpi3mr_prepare_sg_scmd - build scatter gather list
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + * @scsiio_req: MPI3 SCSI IO request
> + *
> + * This function maps SCSI command's data and protection SGEs to
> + * MPI request SGEs. If required additional 4K chain buffer is
> + * used to send the SGEs.
> + *
> + * Return: 0 on success, -ENOMEM on dma_map_sg failure
> + */
> +static int mpi3mr_prepare_sg_scmd(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd, Mpi3SCSIIORequest_t *scsiio_req)
> +{
> +	dma_addr_t chain_dma;
> +	struct scatterlist *sg_scmd;
> +	void *sg_local, *chain;
> +	u32 chain_length;
> +	int sges_left, chain_idx;
> +	u32 sges_in_segment;
> +	u8 simple_sgl_flags;
> +	u8 simple_sgl_flags_last;
> +	u8 last_chain_sgl_flags;
> +	struct chain_element *chain_req;
> +	struct scmd_priv *priv =3D NULL;
> +
> +	priv =3D scsi_cmd_priv(scmd);
> +
> +	simple_sgl_flags =3D MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE |
> +	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
> +	simple_sgl_flags_last =3D simple_sgl_flags |
> +	    MPI3_SGE_FLAGS_END_OF_LIST;
> +	last_chain_sgl_flags =3D MPI3_SGE_FLAGS_ELEMENT_TYPE_LAST_CHAIN |
> +	    MPI3_SGE_FLAGS_DLAS_SYSTEM;
> +
> +	sg_local =3D &scsiio_req->SGL;
> +
> +	if (!scsiio_req->DataLength) {
> +		mpi3mr_build_zero_len_sge(sg_local);
> +		return 0;
> +	}
> +
> +	sg_scmd =3D scsi_sglist(scmd);
> +	sges_left =3D scsi_dma_map(scmd);
> +
> +	if (sges_left < 0) {
> +		sdev_printk(KERN_ERR, scmd->device,
> +		    "scsi_dma_map failed: request for %d bytes!\n",
> +		    scsi_bufflen(scmd));
> +		return -ENOMEM;
> +	}
> +	if (sges_left > MPI3MR_SG_DEPTH) {
> +		sdev_printk(KERN_ERR, scmd->device,
> +		    "scsi_dma_map returned unsupported sge count %d!\n",
> +		    sges_left);
> +		return -ENOMEM;
> +	}
> +
> +	sges_in_segment =3D (mrioc->facts.op_req_sz -
> +	    offsetof(Mpi3SCSIIORequest_t, SGL))/sizeof(Mpi3SGESimple_t);
> +
> +	if (sges_left <=3D sges_in_segment)
> +		goto fill_in_last_segment;
> +
> +	/* fill in main message segment when there is a chain following */
> +	while (sges_in_segment > 1) {
> +		mpi3mr_add_sg_single(sg_local, simple_sgl_flags,
> +		    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
> +		sg_scmd =3D sg_next(sg_scmd);
> +		sg_local +=3D sizeof(Mpi3SGESimple_t);
> +		sges_left--;
> +		sges_in_segment--;
> +	}
> +
> +	chain_idx =3D mpi3mr_get_chain_idx(mrioc);
> +	if (chain_idx < 0)
> +		return -1;
> +	chain_req =3D &mrioc->chain_sgl_list[chain_idx];
> +	priv->chain_idx =3D chain_idx;
> +
> +	chain =3D chain_req->addr;
> +	chain_dma =3D chain_req->dma_addr;
> +	sges_in_segment =3D sges_left;
> +	chain_length =3D sges_in_segment * sizeof(Mpi3SGESimple_t);
> +
> +	mpi3mr_add_sg_single(sg_local, last_chain_sgl_flags,
> +	    chain_length, chain_dma);
> +
> +	sg_local =3D chain;
> +
> +fill_in_last_segment:
> +	while (sges_left > 0) {
> +		if (sges_left =3D=3D 1)
> +			mpi3mr_add_sg_single(sg_local,
> +			    simple_sgl_flags_last, sg_dma_len(sg_scmd),
> +			    sg_dma_address(sg_scmd));
> +		else
> +			mpi3mr_add_sg_single(sg_local, simple_sgl_flags,
> +			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
> +		sg_scmd =3D sg_next(sg_scmd);
> +		sg_local +=3D sizeof(Mpi3SGESimple_t);
> +		sges_left--;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_build_sg_scmd - build scatter gather list for SCSI IO
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI command reference
> + * @scsiio_req: MPI3 SCSI IO request
> + *
> + * This function calls mpi3mr_prepare_sg_scmd for constructing
> + * both data SGEs and protection information SGEs in the MPI
> + * format from the SCSI Command as appropriate .
> + *
> + * Return: return value of mpi3mr_prepare_sg_scmd.
> + */
> +static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd, Mpi3SCSIIORequest_t *scsiio_req)
> +{
> +	int ret;
> +
> +	ret =3D mpi3mr_prepare_sg_scmd(mrioc, scmd, scsiio_req);
> +	if (ret)
> +		return ret;
> +
> +	return ret;
> +}
> +
>=20
> /**
>  * mpi3mr_map_queues - Map queues callback handler
> @@ -44,6 +509,73 @@ static int mpi3mr_map_queues(struct Scsi_Host *shost)
> 	    mrioc->pdev, mrioc->op_reply_q_offset);
> }
>=20
> +/**
> + * mpi3mr_scan_start - Scan start callback handler
> + * @shost: SCSI host reference
> + *
> + * Issue port enable request asynchronously.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_scan_start(struct Scsi_Host *shost)
> +{
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +
> +	mrioc->scan_started =3D 1;
> +	ioc_info(mrioc, "%s :Issuing Port Enable\n", __func__);
> +	if (mpi3mr_issue_port_enable(mrioc, 1)) {
> +		ioc_err(mrioc, "%s :Issuing port enable failed\n", __func__);
> +		mrioc->scan_started =3D 0;
> +		mrioc->scan_failed =3D MPI3_IOCSTATUS_INTERNAL_ERROR;
> +	}
> +
> +}
> +
> +/**
> + * mpi3mr_scan_finished - Scan finished callback handler
> + * @shost: SCSI host reference
> + * @time: Jiffies from the scan start
> + *
> + * Checks whether the port enable is completed or timedout or
> + * failed and set the scan status accordingly after taking any
> + * recovery if required.
> + *
> + * Return: 1 on scan finished or timed out, 0 for in progress
> + */
> +static int mpi3mr_scan_finished(struct Scsi_Host *shost,
> +	unsigned long time)
> +{
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +	u32 pe_timeout =3D MPI3MR_PORTENABLE_TIMEOUT;
> +
> +	if (time >=3D (pe_timeout * HZ)) {
> +		mrioc->init_cmds.is_waiting =3D 0;
> +		mrioc->init_cmds.callback =3D NULL;
> +		mrioc->init_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +		ioc_err(mrioc, "%s :port enable request timed out\n", __func__);
> +		mrioc->is_driver_loading =3D 0;
> +		mpi3mr_soft_reset_handler(mrioc,
> +		    MPI3MR_RESET_FROM_PE_TIMEOUT, 1);
> +	}
> +
> +	if (mrioc->scan_failed) {
> +		ioc_err(mrioc,
> +		    "%s :port enable failed with (ioc_status=3D0x%08x)\n",
> +		    __func__, mrioc->scan_failed);
> +		mrioc->is_driver_loading =3D 0;
> +		mrioc->stop_drv_processing =3D 1;
> +		return 1;
> +	}
> +
> +	if (mrioc->scan_started)
> +		return 0;
> +	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
> +	mrioc->is_driver_loading =3D 0;
> +
> +	return 1;
> +}
> +
> +
> /**
>  * mpi3mr_slave_destroy - Slave destroy callback handler
>  * @sdev: SCSI device reference
> @@ -126,10 +658,114 @@ static int mpi3mr_target_alloc(struct scsi_target =
*starget)
> static int mpi3mr_qcmd(struct Scsi_Host *shost,
> 	struct scsi_cmnd *scmd)
> {
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	struct scmd_priv *scmd_priv_data =3D NULL;
> +	Mpi3SCSIIORequest_t *scsiio_req =3D NULL;
> +	struct op_req_qinfo *op_req_q =3D NULL;
> 	int retval =3D 0;
> +	u16 dev_handle;
> +	u16 host_tag;
> +	u32 scsiio_flags =3D 0;
> +	struct request *rq =3D scmd->request;
> +	int iprio_class;
> +
> +	sdev_priv_data =3D scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		scmd->result =3D DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
>=20
> -	scmd->result =3D DID_NO_CONNECT << 16;
> -	scmd->scsi_done(scmd);
> +	if (mrioc->stop_drv_processing) {
> +		scmd->result =3D DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +
> +	if (mrioc->reset_in_progress) {
> +		retval =3D SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +	stgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +
> +	dev_handle =3D stgt_priv_data->dev_handle;
> +	if (dev_handle =3D=3D MPI3MR_INVALID_DEV_HANDLE) {
> +		scmd->result =3D DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +	if (stgt_priv_data->dev_removed) {
> +		scmd->result =3D DID_NO_CONNECT << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +
> +	if (atomic_read(&stgt_priv_data->block_io)) {
> +		if (mrioc->stop_drv_processing) {
> +			scmd->result =3D DID_NO_CONNECT << 16;
> +			scmd->scsi_done(scmd);
> +			goto out;
> +		}
> +		retval =3D SCSI_MLQUEUE_DEVICE_BUSY;
> +		goto out;
> +	}
> +
> +	host_tag =3D mpi3mr_host_tag_for_scmd(mrioc, scmd);
> +	if (host_tag =3D=3D MPI3MR_HOSTTAG_INVALID) {
> +		scmd->result =3D DID_ERROR << 16;
> +		scmd->scsi_done(scmd);
> +		goto out;
> +	}
> +
> +	if (scmd->sc_data_direction =3D=3D DMA_FROM_DEVICE)
> +		scsiio_flags =3D MPI3_SCSIIO_FLAGS_DATADIRECTION_READ;
> +	else if (scmd->sc_data_direction =3D=3D DMA_TO_DEVICE)
> +		scsiio_flags =3D MPI3_SCSIIO_FLAGS_DATADIRECTION_WRITE;
> +	else
> +		scsiio_flags =3D MPI3_SCSIIO_FLAGS_DATADIRECTION_NO_DATA_TRANSFER;
> +
> +	scsiio_flags |=3D MPI3_SCSIIO_FLAGS_TASKATTRIBUTE_SIMPLEQ;
> +
> +	if (sdev_priv_data->ncq_prio_enable) {
> +		iprio_class =3D IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
> +		if (iprio_class =3D=3D IOPRIO_CLASS_RT)
> +			scsiio_flags |=3D 1 << MPI3_SCSIIO_FLAGS_CMDPRI_SHIFT;
> +	}
> +
> +	if (scmd->cmd_len > 16)
> +		scsiio_flags |=3D MPI3_SCSIIO_FLAGS_CDB_GREATER_THAN_16;
> +
> +	scmd_priv_data =3D scsi_cmd_priv(scmd);
> +	memset(scmd_priv_data->mpi3mr_scsiio_req, 0, MPI3MR_ADMIN_REQ_FRAME_SZ)=
;
> +	scsiio_req =3D (Mpi3SCSIIORequest_t *) scmd_priv_data->mpi3mr_scsiio_re=
q;
> +	scsiio_req->Function =3D MPI3_FUNCTION_SCSI_IO;
> +	scsiio_req->HostTag =3D cpu_to_le16(host_tag);
> +
> +	memcpy(scsiio_req->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
> +	scsiio_req->DataLength =3D cpu_to_le32(scsi_bufflen(scmd));
> +	scsiio_req->DevHandle =3D cpu_to_le16(dev_handle);
> +	scsiio_req->Flags =3D cpu_to_le32(scsiio_flags);
> +	int_to_scsilun(sdev_priv_data->lun_id,
> +	    (struct scsi_lun *)scsiio_req->LUN);
> +
> +	if (mpi3mr_build_sg_scmd(mrioc, scmd, scsiio_req)) {
> +		mpi3mr_clear_scmd_priv(mrioc, scmd);
> +		retval =3D SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +	op_req_q =3D &mrioc->req_qinfo[scmd_priv_data->req_q_idx];
> +
> +	if (mpi3mr_op_request_post(mrioc, op_req_q,
> +	    scmd_priv_data->mpi3mr_scsiio_req)) {
> +		mpi3mr_clear_scmd_priv(mrioc, scmd);
> +		retval =3D SCSI_MLQUEUE_HOST_BUSY;
> +		goto out;
> +	}
> +
> +out:
> 	return retval;
> }
>=20
> @@ -143,6 +779,8 @@ static struct scsi_host_template mpi3mr_driver_templa=
te =3D {
> 	.slave_configure		=3D mpi3mr_slave_configure,
> 	.target_destroy			=3D mpi3mr_target_destroy,
> 	.slave_destroy			=3D mpi3mr_slave_destroy,
> +	.scan_finished			=3D mpi3mr_scan_finished,
> +	.scan_start			=3D mpi3mr_scan_start,
> 	.map_queues			=3D mpi3mr_map_queues,
> 	.no_write_same			=3D 1,
> 	.can_queue			=3D 1,
> @@ -218,6 +856,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_d=
evice_id *id)
> 	spin_lock_init(&mrioc->admin_req_lock);
> 	spin_lock_init(&mrioc->reply_free_queue_lock);
> 	spin_lock_init(&mrioc->sbq_lock);
> +	spin_lock_init(&mrioc->chain_buf_lock);
>=20
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> 	if (pdev->revision)
> @@ -287,6 +926,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
> 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> 		ssleep(1);
>=20
> +	mrioc->stop_drv_processing =3D 1;
>=20
> 	scsi_remove_host(shost);
>=20
> @@ -319,6 +959,7 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
> 	mrioc =3D shost_priv(shost);
> 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> 		ssleep(1);
> +	mrioc->stop_drv_processing =3D 1;
>=20
> 	mpi3mr_cleanup_ioc(mrioc);
>=20
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

