Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DC7C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C046143B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbhDUVJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:09:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbhDUVJ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:09:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKqHBV039104;
        Wed, 21 Apr 2021 21:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NszrzYNBYlj3nPXzmrhpmjkDzvUqU64nLaqLgYu2tQA=;
 b=WrXL+aQ5bXAuenQitdGtVggFAyT5u9hNhCnfBpBAGuZLjNHeXB8roiAWbhCPtRKWWOTb
 eRQCO/czs/W7JepL8JllWreBqirLbYPadkzW81luENScEwCONpk8JANZJO1GzMFW/QN4
 /kdm5FuUGwWAIqA67AMrwWsguR25QxdVLqpqX6UMjCmRnB39wWJkqU9zrq70foyMKXjw
 nFopbkrc3cGTVTrTDHpJFNrD0iuqgyYN2xeQtakl33oC853MFIT+oprzm80QedC2PFnn
 d/89C0J+Fq/WFLsjuzgq9Yy8IaDJvttxbr05hw7C4+EPWK36wnUDc/g3hN/RG1bzoP+6 4g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y2y1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 21:08:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKoCum072864;
        Wed, 21 Apr 2021 21:08:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 3809k2fv34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 21:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5yZCmQ1qR4Y8j3H0f5IkTok7/D65kgVMR9E3cphEQUtFtYndloZNcy3W3rjK91S7Te2YRoidSBMep9qEbfiDGyScMUOZUEyG8RybelR+sCGpxYNH9GeUhoI+lvqfcCfwltrBEG1nAvVbRTnyJizA8pDN0oQqg86zIOpUlPIBquEjYNEjfhvgYuVdDM+3r1/6+ZKnzkct+HXP6Au8h7lIXms7M5Y7fd/sIsT1EG1WlrsF8t9hqiMlhXhXf0FVS0Ql5bPxWjjEyNQ+6d9zQxqxXmrBbrWSL2QzYA2nFYRRTzLirfXb9idtvD8/9X9dpznZOyqFIX+FCN2Tpn7HSnqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NszrzYNBYlj3nPXzmrhpmjkDzvUqU64nLaqLgYu2tQA=;
 b=X97lHVxkueAQkBhDSzaz7HqZOkaqYrWYEtLxNLyufi8XtqkYIG4s1+uo6psPae5p4YSSJy7S/6uF9SG7ewwvbJDif1EHJYO0I83nNLdyoNITt1LOwr2FGFF2y+RtrV9EA7YdxswHQlsZOKyP6OJBFUPvdJ07DijMhOfbS4oHGylNwcAZD+IdLyghNV7yuyEybxF8LUPvOWto0IQD9iV/tCO/XOOyT9C/jTlpzCoVWEgrQg8mWVSqOubqQCuVp4H19PsjfrSMKUJZhaGrMU4qNXOBfDx0Nmm7oTL2Msq4tNeClUbpPldzmF2aKdaSZENl3lCEDvpfVekEYebjqIcIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NszrzYNBYlj3nPXzmrhpmjkDzvUqU64nLaqLgYu2tQA=;
 b=DOp12kfpzJ18B5DkbKk2EOiZasvKlvRMbgccotP3n8wnXCD5KsPuPu04Fn0CQGeyJtIu8SSbWNXKMPcZCKhX7hX1qkECs0Xm4ZSm6TJuHilN9s2jQa3xURl/lBrNuveSN6GMOpZR6iLp9IhPgQw+MjvMkcZMrQVdJ8EQHkdI74w=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 21:08:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 21:08:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 10/24] mpi3mr: add support of timestamp sync with
 firmware
Thread-Topic: [PATCH v3 10/24] mpi3mr: add support of timestamp sync with
 firmware
Thread-Index: AQHXNQuQOS07ah1ABU+dmsr3YcZm2aq/evKA
Date:   Wed, 21 Apr 2021 21:08:48 +0000
Message-ID: <3701C613-497F-4D21-9E3D-0DE9C5779AAB@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-11-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-11-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e88fde64-85ed-4959-3bd7-08d90509a825
x-ms-traffictypediagnostic: SA2PR10MB4811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4811AE185C89A6288C58F719E6479@SA2PR10MB4811.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 77uF+Ib7S4ULDzhauio8g6p1pa92uzsW340iWggUZR45em6rhXp/5zLmvR8e8D0dDk5Mav5oFT/25TgcNOuDZVirfKn5CadsBfeGJLFqcFUQgOB85hXT2ZV5kgzrO2NE/P6r5CuLT3bbjdJ0S0jsyEr7sx5qZuYZqfegnUu5k6eVOH6Knmw3q3zpMuOX350SGasr1KNoQpyDYc7/JhVKf71eAsn3tXgQNXB/S60756GDx0TJNWfw2ci/ydy39oL0d0Fs5cG/MoBabgrybrQRjxArlRbwXs8J5R6ZQBRX6KMuNO57gurlfpccvWWr9S92bd3viwI6TzQJtChtFVAMBLYfuoCilnnPEuxPKLwNGr4q3wvU2MzPLX45CYqkvoR0x+DXylIxH/48NqeLDymK4VpoBceUP+vY9AGlWf2PTWjNEI6E0VVGZRZLzwzv9yqxZgaNEDYHBHeZCAsslh+TnoVwbrU2C3bp/3+g4qLbMR/iitLrIkauc55jHHIXpUhG0ykAtxo3w4oREO0qcgmcLxxjgNjgNtvqS6QLqQY6mbUzo+oMcAmsYX4ea6fUTpf/GrzjYd24Z/XyJchj22ql4aNfAQcaIkvpAy7ydKl8mYy1Tf2F/yhj2NC6CjU3my/kVqCE0BeXjrNWfqK0WEBh5JNjvFTCCXZ1GQNPQbgR9NPCzobCMK4K/ngyhVzYUM12
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(4326008)(38100700002)(316002)(44832011)(8676002)(26005)(33656002)(76116006)(64756008)(83380400001)(478600001)(54906003)(6486002)(186003)(2906002)(5660300002)(6506007)(36756003)(6512007)(86362001)(66476007)(2616005)(66556008)(53546011)(122000001)(66446008)(71200400001)(8936002)(6916009)(66946007)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oyZPrT+LWvdQ/F1DWa+kDkW8a0T2VwPs2kO4Ad0V+92PJS+NBKhqXpYQo1WK?=
 =?us-ascii?Q?qDGgshIwjElnDnfm/Kqk+P6mkGp51inB+X49juRbVHW3Cf5fBM09TK15Y8pr?=
 =?us-ascii?Q?wDGfDlTZSh99UI9x+PUbYZjzrs7et0aPCYAuqmiStjL5d7QGZqnqt1osGJIG?=
 =?us-ascii?Q?xEOLsEHhe2mqoRTDrujqpt0Vw83Efglf/PPDMsZKhCP1pk8LiX0gXw73jEe9?=
 =?us-ascii?Q?MCzyvTItwDzw+9uT4TzWUSD1lRT6+AtC4lhTXIOehWUUAZ3Xhar1iDb8Auo1?=
 =?us-ascii?Q?rGwG1biDapxHS1fmeT5/bqgfUFoQG1wSg7wgVPChHdGU7hTAUrCzVqQ/Is+3?=
 =?us-ascii?Q?6tWMOSSay+QChJfwrDX1h7DTIVdeiTcnimtlorXivJo5ElVH7YehrVS38lRg?=
 =?us-ascii?Q?G/7DIbI4SefabzK+uFO/zBgicVQMAcf1TYyRZDUhC5yo1Rztm6B1iKcA/NEJ?=
 =?us-ascii?Q?5OPDvTQb6fkmuD5j4nRckRuUEEPZoMHRBJbeCvUE3DC3nrx3EFCtTesIErSE?=
 =?us-ascii?Q?I6LO8sJFm83rxL7k+Cv7dgsqVUnImXL0S9khgy85qsKUEV93PP4iW7DseIk1?=
 =?us-ascii?Q?OEFRaHVOLQlVTd2k8y8IZq8+JCO5RS16fpkEbM2QGXaBtr3XTIO/LQUKXdh1?=
 =?us-ascii?Q?Brj5/CzvZmPqStOJZSURP0q7Fdsz+UfRTw/Ykb1KB4aPLWyK0M+K331aPZwf?=
 =?us-ascii?Q?Ij4OxCfAZ43jEfleHlXSr6bxcIcIZxypIJNkK83lEE2GD/Sw+9k3rqMe07u/?=
 =?us-ascii?Q?sSOkL6VH1Q8LE6MgiLQspUUGd7nhZdH1oWdyusIouLH/+THNXBt27CXt0tUN?=
 =?us-ascii?Q?trN5k9x+YmU+mDOuy06p1P9b6XwPObclJFm8LQXqI19525oe1vMkoGHX4ymV?=
 =?us-ascii?Q?PJmS5DKMC2nJvLNWRpVxi5n+p5uoJb9EQkPQyHVa5bk+1lqd6vRp4QzAwq+t?=
 =?us-ascii?Q?esGOWg9I+Dg1an+SFJjdJnwHf0COqUfHfSpcguTBvxBt5CnbSwShKxGxOe38?=
 =?us-ascii?Q?xZYTAXtqzIx+QHhKxz9+RQNshK/e9l6q8yV4nGgiU80vA20tdNx3PD0pH3Uo?=
 =?us-ascii?Q?EBMa9CbOKlBfXs7kCOSFPhXBLI4kAD88QncztRsCp2jtZnV37T9IwPirSBCZ?=
 =?us-ascii?Q?Sy8GRrAkxiy4QHQ9YCZuiM4XPOtpZHcPys92BmGAPQONQ7Xf4jR+C7x414xp?=
 =?us-ascii?Q?a7DXbHWL6COYkvIUx8gP2UK78HHja5FgJlXp2gkKSt29+ZLpTmMq8l4BtExj?=
 =?us-ascii?Q?9X464fWPmOv5pAHYtBM63dd9KqSVxRT27xWnCGxe0c+svGMe0y/AOnjyLjlZ?=
 =?us-ascii?Q?uCtt9FIIpMhamdRE8Wi8Hhka4fKXAOGXJoc0wkf/asxq6g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E7A2086B921714CA04E33373F6C75B9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e88fde64-85ed-4959-3bd7-08d90509a825
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 21:08:48.2344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9zXqQryH3r05SGrPjbwk5HDcLTNTNQGBZ/CkGmyOGSS2fuEBai4E2On1YXIAOcbctyRvFNZ5VpsgIjD3COnmh+pqDVpI35v77eZQC6RXFLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210141
X-Proofpoint-ORIG-GUID: 2j2x0ohmRDfUpOOD02eOHoOJ5USzS1VO
X-Proofpoint-GUID: 2j2x0ohmRDfUpOOD02eOHoOJ5USzS1VO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> This operation requests that the IOC update the TimeStamp.
>=20
> When the I/O Unit is powered on, it sets the TimeStamp field value to
> 0x0000_0000_0000_0000 and increments the current value every millisecond.
> A host driver sets the TimeStamp field to the current time by using an
> IOCInit request. The TimeStamp field is periodically updated by host driv=
er.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  3 ++
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 74 +++++++++++++++++++++++++++++++++
> 2 files changed, 77 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index d18bfb954bc4..801612c9eb2a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -99,6 +99,7 @@ extern struct list_head mrioc_list;
> #define MPI3MR_PORTENABLE_TIMEOUT		300
> #define MPI3MR_RESETTM_TIMEOUT			30
> #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
> +#define MPI3MR_TSUPDATE_INTERVAL		900
> #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
>=20
> #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
> @@ -631,6 +632,7 @@ struct scmd_priv {
>  * @dev_handle_bitmap_sz: Device handle bitmap size
>  * @removepend_bitmap: Remove pending bitmap
>  * @delayed_rmhs_list: Delayed device removal list
> + * @ts_update_counter: Timestamp update counter
>  * @fault_dbg: Fault debug flag
>  * @reset_in_progress: Reset in progress flag
>  * @unrecoverable: Controller unrecoverable flag
> @@ -753,6 +755,7 @@ struct mpi3mr_ioc {
> 	void *removepend_bitmap;
> 	struct list_head delayed_rmhs_list;
>=20
> +	u32 ts_update_counter;
> 	u8 fault_dbg;
> 	u8 reset_in_progress;
> 	u8 unrecoverable;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index a74eb4914c9d..4e28a0efb082 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1482,6 +1482,74 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrio=
c,
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_sync_timestamp - Issue time stamp sync request
> + * @mrioc: Adapter reference
> + *
> + * Issue IO unit control MPI request to synchornize firmware
> + * timestamp with host time.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +static int mpi3mr_sync_timestamp(struct mpi3mr_ioc *mrioc)
> +{
> +	ktime_t current_time;
> +	Mpi3IoUnitControlRequest_t iou_ctrl;
> +	int retval =3D 0;
> +
> +	memset(&iou_ctrl, 0, sizeof(iou_ctrl));
> +	mutex_lock(&mrioc->init_cmds.mutex);
> +	if (mrioc->init_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "Issue IOUCTL TimeStamp: command is in use\n");
> +		mutex_unlock(&mrioc->init_cmds.mutex);
> +		goto out;
> +	}
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->init_cmds.is_waiting =3D 1;
> +	mrioc->init_cmds.callback =3D NULL;
> +	iou_ctrl.HostTag =3D cpu_to_le16(MPI3MR_HOSTTAG_INITCMDS);
> +	iou_ctrl.Function =3D MPI3_FUNCTION_IO_UNIT_CONTROL;
> +	iou_ctrl.Operation =3D MPI3_CTRL_OP_UPDATE_TIMESTAMP;
> +	current_time =3D ktime_get_real();
> +	iou_ctrl.Param64[0] =3D cpu_to_le64(ktime_to_ms(current_time));
> +
> +	init_completion(&mrioc->init_cmds.done);
> +	retval =3D mpi3mr_admin_request_post(mrioc, &iou_ctrl,
> +	    sizeof(iou_ctrl), 0);
> +	if (retval) {
> +		ioc_err(mrioc, "Issue IOUCTL TimeStamp: Admin Post failed\n");
> +		goto out_unlock;
> +	}
> +
> +	wait_for_completion_timeout(&mrioc->init_cmds.done,
> +	    (MPI3MR_INTADMCMD_TIMEOUT * HZ));
> +	if (!(mrioc->init_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "Issue IOUCTL TimeStamp: command timed out\n");
> +		mrioc->init_cmds.is_waiting =3D 0;
> +		mpi3mr_soft_reset_handler(mrioc,
> +		    MPI3MR_RESET_FROM_TSU_TIMEOUT, 1);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	if ((mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	    !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "Issue IOUCTL TimeStamp: Failed IOCStatus(0x%04x) Loginfo(0x%08x)\=
n",
> +		    (mrioc->init_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->init_cmds.ioc_loginfo);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +
> +out_unlock:
> +	mrioc->init_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->init_cmds.mutex);
> +
> +out:
> +	return retval;
> +}
> +
> /**
>  * mpi3mr_watchdog_work - watchdog thread to monitor faults
>  * @work: work struct
> @@ -1500,6 +1568,11 @@ static void mpi3mr_watchdog_work(struct work_struc=
t *work)
> 	enum mpi3mr_iocstate ioc_state;
> 	u32 fault, host_diagnostic;
>=20
> +	if (mrioc->ts_update_counter++ >=3D MPI3MR_TSUPDATE_INTERVAL) {
> +		mrioc->ts_update_counter =3D 0;
> +		mpi3mr_sync_timestamp(mrioc);
> +	}
> +
> 	/*Check for fault state every one second and issue Soft reset*/
> 	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> 	if (ioc_state =3D=3D MRIOC_STATE_FAULT) {
> @@ -3313,6 +3386,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mr=
ioc,
> 		mrioc->reset_in_progress =3D 0;
> 		scsi_unblock_requests(mrioc->shost);
> 		mpi3mr_rfresh_tgtdevs(mrioc);
> +		mrioc->ts_update_counter =3D 0;
> 		spin_lock_irqsave(&mrioc->watchdog_lock, flags);
> 		if (mrioc->watchdog_work_q)
> 			queue_delayed_work(mrioc->watchdog_work_q,
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

