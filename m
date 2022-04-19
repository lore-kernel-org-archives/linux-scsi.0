Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66788C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 19:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242565AbiDSTTe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 15:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbiDSTTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 15:19:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B3D3B2A6
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 12:16:48 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JHLAQQ012431;
        Tue, 19 Apr 2022 19:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gdxwQT4d4qLKxBJJknRa3ho0d9b5ehJEETaw1kEUb/E=;
 b=yn4NK/qgEmSy0ee/PkVODqiFsum9zt2umcvQc7PQ0DJv6YjgUx1HT/UqG7cPsLIiaLnI
 tZLsl5uNtNk6oV6ddvOUzwOZF6yPsV/b/wW4xUL4Pp4HWzpndfVS6MMtMNgj+EFq5Rtr
 dRqFLRRkaMG5j+obT8Z0syIy+7Wyq30vy0r+5+O5QDOZfT27vfL8uNHLB8lp5tummxMn
 n08UbaHmQ0x4gyabtoCbN8aufC9GFR4o8bBpXL05tCdJujSvrSf1Uhx38N9qAVrya4Nf
 RNCGN6FGY/QhM/wGvKVUSV2tYwEjAFkUBytB7VTlcZp9rf3yrkT64o/7ZHmGkAayx3LF xQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbv73fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:16:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JJ6YXZ015713;
        Tue, 19 Apr 2022 19:16:35 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88ga2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:16:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmiMk0Rfr3vydUOGatkf7maoGErWkA6XfY6X+m9Fpn5cIwXnCKlZ2lgjsoMWuKFgAE4NYLxh5zCCgNcco1/8MZSsBFDyZYlcMuXrKt1dQ44u92r5/iZ8G06F/gY3sjKlupg+lwkVcYlz8kpWDkQK4dqdhi8CvVyRJh92E5i8ZwncECrQypaxk8sBymi8qv+h2SWIeTMlUZHuwel2eF5RjXcJDt02nGhdef8kuZy/FVFsYilS8EkjqZe34HzRapiN5kuGMZBrT7J8uIYreTe5SU3ghaJOr6szEUIEs5GDkQyUolhbT/UWqc9PWFVVyXHb0VKyOKjzAssCmZsGu53TfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdxwQT4d4qLKxBJJknRa3ho0d9b5ehJEETaw1kEUb/E=;
 b=XQH7J2OCpsHemdvFUPdIl7RfdzQGtUedlaj/wdqhuWJlR/p4MrVl6UU4I7Z60gMboTG0TBYVYkfiD3XUiEv9TV2b1Q6297KdILxE+gOMk8DkzC2UdWNkycVfZ+sigz9+gMKL7tN3JbwKGNUVwiuW040el82jfbrcJiJutgs4GTXEojgGWUxuLlg32nGTrsjtGqwMRdUogghOHOHst/zP5lKEHRLdrW2Aomw2qpaXVVqZKIGLh/GVZfBrUnEuw/5gyE2Y7P3INFlaPey9vV5l/7dUGJECINXmeW+79QFju98ZKsso1Jojf/J37cS+jFfMCt0RWQ4ypSTPWTh2r78JJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdxwQT4d4qLKxBJJknRa3ho0d9b5ehJEETaw1kEUb/E=;
 b=QYToM7pMkuF5Y4ARVPtoLzCognxb+JeoPFMtM4Ioue03juDbF4y4AYEXmn7DiewgrcuDKd3CDdhGXXCv6G7X1u3uHQ8NZsUbcvQokNFeo+Q7x63f0NTR4ZcLqiiLLcMH2j9k7qHdXizm08UGXnyD7QTrnDG5P4ZIU57y+TJxBUQ=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3115.namprd10.prod.outlook.com (2603:10b6:5:1a2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 19:16:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:16:29 +0000
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
Subject: Re: [PATCH v4 4/8] mpi3mr: add support for MPT commands
Thread-Topic: [PATCH v4 4/8] mpi3mr: add support for MPT commands
Thread-Index: AQHYT0cLC1BXr6z+2k6ZX0bIzMqsiqz3pWCA
Date:   Tue, 19 Apr 2022 19:16:29 +0000
Message-ID: <C71079DE-9A80-4A41-BE68-E23D85230046@oracle.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
 <20220413145652.112271-5-sumit.saxena@broadcom.com>
In-Reply-To: <20220413145652.112271-5-sumit.saxena@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2dc6c7d-fd56-46b7-8be9-08da22391ba8
x-ms-traffictypediagnostic: DM6PR10MB3115:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3115974387B7C5E0A359B6B1E6F29@DM6PR10MB3115.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwnJViHvoakmqQv/2p+htjsUlKtwixZiOmFjQj66t3lANTtvfgs2Lcd6sHYG77Kz9fIW5U+wLXpssksGDnAwqkwcdry/EeQkC8RsvMHA9nLRzTacDfaJGqoD2sk5GZn9XS190REIDmUzTQ5hKAgvo0xOg44K4YjdC7q+D+uyQxxD9gSsVyb/oeU3gbYCeuYbcTUI2pmkvrVPMQ0lrhM1wS4TRGNjX/2oVQhr4y9CkhH0GNL4HPn8davXNNiQYFn5TO6I6Jb4Apu8oVPmQRhF3wZ88If9F82faS0iToy6+vbtjHSiPCQ2FfC8LGFaMztiPv26thZfGUdN7SEVBWHSFaAkfJ6WuEzK1uJGu4VuM/2xpbpqlQs2ByNoaXb4D4ae1vxNyYqsEM16EMMQnXVqG3wN/My5DC++gD7xVsvK6DFGrAIV5bHVzZq3Gxg4zLKFmRh3nRxMc63NjFik9pPNok2x756xagPhmOgnmsea5NttKlJEx+AlENdj5VyQ6OvVdZHflGB63EOtmWb1wC7kTzaOBkmtfJme/86XRZs3vQ8Otft/efFT54XxlVDHDuocObxDSeJQ+ML3GHYmH+RjffNzCyHrlrmFxrHy9CHxgdKMqbmq2UQ8vh1aDrUXyLyJ5hDlcW8QDVnKb4s2CQ6eIy4wocloav+U8EJSVdAemQaRiEXyeOxHRd01hSFQ58rGOoA4QSIcqCvhSKLoLIMC2oNUzuagmC2noIRVzqwQJbuvV2kROQJNXLGaczNnmyI0oeCrqpkNcC+t35AA4C6Axg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6916009)(86362001)(53546011)(2906002)(66556008)(66446008)(4326008)(66476007)(66946007)(8936002)(64756008)(33656002)(8676002)(44832011)(122000001)(54906003)(316002)(30864003)(91956017)(76116006)(7416002)(6486002)(71200400001)(83380400001)(38070700005)(186003)(38100700002)(5660300002)(36756003)(6506007)(6512007)(26005)(2616005)(32563001)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oht12SEZsf6+ZoHVD6fVJOMaVn5MxBINybLm7nnfeHDYItf+NPc95B2rLK7x?=
 =?us-ascii?Q?z84iIu58Ekx+F7h25VevbQ8vGs1nZFI327uWV5rFNfUcc4JK3ZG8oAdqcZb5?=
 =?us-ascii?Q?RwnUyDRFUkPD0ZBrZo0JkfkU57Xy/JrjM4VVfs3geFtND1Dw7kMMr6Nzu6FM?=
 =?us-ascii?Q?BfqJwPUzN7uKBHU4B1SMnXAGu2iWxIgfF9nEC5QOL+A0BLZqAqjj2sDSRNIY?=
 =?us-ascii?Q?L41oLlogEW0v2J5HvVlZndqafAgAvVTalaZuoD6xU0pFCkX/rpyeU68Ac6W4?=
 =?us-ascii?Q?+/dqhi5Da/1wUK9bEgh8ABveBy/MAIp5y9EI0bIiBiCrrQmUf2JBZDfpZzIT?=
 =?us-ascii?Q?DROpCdm5w0yPb0GH1Bk+PQ6Gwxhors2awuUNh6D4cVzO/4AyaLcrkehaO8QF?=
 =?us-ascii?Q?cr8fCJnfV5WmOL3u9X1hMWxVdP2TfWmiKXy18w0AMtZVVXREuT3b+YoVN/ls?=
 =?us-ascii?Q?woI00B5Mew69kInLIzG9iHUITN/Ga2/q8pgNIlghZVmbGpbU2GImR+NUPIFn?=
 =?us-ascii?Q?vnEct7Xu9FpOtg0k85erRD9eCbvWEgy3Qt9ku3V8sJnhCtwYGx+91LuDbyxR?=
 =?us-ascii?Q?x9d9gsbE8eaECD9IqPgQRRBM589EbarajpMdMqVBAfyhPDscYEGOOhTkcCoP?=
 =?us-ascii?Q?lUuPhzvil6hzp9LBjTRcwPs4p+kYK4XzBorR89P4mDBdmPS0Z29lWXR+s7A/?=
 =?us-ascii?Q?1HrxcFELh7QgY2EdgZtJ8T4+4s4G8iQhP2FjhMdJmzX0rEgkCuOyCuSQJSaE?=
 =?us-ascii?Q?SppCj7U2Y7fxACq//e1EKVbFYnlhQEXLcYoa+sNNAZPxE1lTIL1dUHUn2oD0?=
 =?us-ascii?Q?dnLDZGGqYIHxBTRjBWJ255v32aCkxsHS8/nz9DSayyZSpDl+L66vPaiME8Yw?=
 =?us-ascii?Q?k2/PVLjQUk2ALoX+I+syLzgUJHqJVDCh2KXHSS3zVrllndnCBBzr9lEoKG84?=
 =?us-ascii?Q?DpReMX8m78TRU16TlT38mpSvTFphbxlZTT6YX9NF3BJnG1+5T5EHclmP/usB?=
 =?us-ascii?Q?hRLhd9JdsFdeDOLe8Dr0Yf0zvRlc7kCW4xNcCg+sS8jYXtUEXXf6d/fAWriD?=
 =?us-ascii?Q?NRyjFmkkFF6PRTuU4QfdsaG9rbte+1cO8PaNb6f54XZUi0kbdei/U2jh0vQJ?=
 =?us-ascii?Q?LsS3xEjFjNKzkEyrsUR8Jd+zTa0GCOmslmdCAxGaOAe1gAm3pLS7q3fk+v3r?=
 =?us-ascii?Q?bj4uCQgah4F2+/V5qqz46cckWHZtkE74U2bKrAmVh6B2SDTQS/AbHMXfAMFk?=
 =?us-ascii?Q?+4zIDwtAnD/iY+XhmQ2X+87wJpe3JnX46QKTDxTGY7Ws1Gq0fPkpiQJYibbS?=
 =?us-ascii?Q?nKGezsLjHa8jPyk87ak6cZyYFQVD+R4qxd+3J0++mgT07JJKo02799pxx2UF?=
 =?us-ascii?Q?9iFlwnJqw67rm4oAzOqo86l1jRquZ9/4s0Q3ak3H5ogg49Rutwv0d3PTOW7q?=
 =?us-ascii?Q?o43uwprIoiHHdgwcWXtKGhtrGH4Jggrx0z5towxgLEqWiO3SguQMbCrVFLXn?=
 =?us-ascii?Q?qJMxUgrFPYUzV11gyd/dcDLlNxEbd5zldBkhi74685mK8ccb3fk50hX7GxwS?=
 =?us-ascii?Q?kFITZo5TpuuEmv8XwwQX2SPSKhdT2ZDIFa/qMd5t06hg3fYfWQj77H1+pyDK?=
 =?us-ascii?Q?trgPJA+74c39458lrjpDGFuwzyqfUdTR4asAQ6+AiSzKsRS0XW++zg4u81eI?=
 =?us-ascii?Q?jFAGzCFAmi2dA8viJUPLG72Smg3Yv02dXOiqroamb6yw5Xzpgs0Cr5fi7WxB?=
 =?us-ascii?Q?1VDKpXvjOMD2lXZkTWAXqN2S3wKc1CEStkL5qHcwruzFJWh8+xIj?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C1B4747D3C5D34592CF929FAC2A1C78@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2dc6c7d-fd56-46b7-8be9-08da22391ba8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 19:16:29.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ad507+giVJIiC+4Pyb7bTrnsGo/ZdsBCrDo6InsCzyZiFtZ92QqMDGKzVxjRiuvmS7fRXvuVoeicsajTEbTIZazPSIk0lG0oknbkvH1Z5QU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3115
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_06:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190109
X-Proofpoint-GUID: yTaR4kdKBLDjM4UrMGLuOlrtBvrZKKet
X-Proofpoint-ORIG-GUID: yTaR4kdKBLDjM4UrMGLuOlrtBvrZKKet
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 13, 2022, at 7:56 AM, Sumit Saxena <sumit.saxena@broadcom.com> wro=
te:
>=20
> There are certain management commands requiring firmware intervention.
> These commands are termed as MPT commands. This patch adds support for
> the same.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h       |  29 ++
> drivers/scsi/mpi3mr/mpi3mr_app.c   | 519 ++++++++++++++++++++++++++++-
> drivers/scsi/mpi3mr/mpi3mr_debug.h |  25 ++
> drivers/scsi/mpi3mr/mpi3mr_os.c    |   4 +-
> 4 files changed, 574 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index fb05aab48aa7..37be9e28e0b2 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -189,6 +189,27 @@ extern int prot_mask;
>  */
> #define MPI3MR_MAX_APP_XFER_SECTORS	(2048 + 512)
>=20
> +/**
> + * struct mpi3mr_buf_map -  local structure to
> + * track kernel and user buffers associated with an BSG
> + * structure.
> + *
> + * @bsg_buf: BSG buffer virtual address
> + * @bsg_buf_len:  BSG buffer length
> + * @kern_buf: Kernel buffer virtual address
> + * @kern_buf_len: Kernel buffer length
> + * @kern_buf_dma: Kernel buffer DMA address
> + * @data_dir: Data direction.
> + */
> +struct mpi3mr_buf_map {
> +	void *bsg_buf;
> +	u32 bsg_buf_len;
> +	void *kern_buf;
> +	u32 kern_buf_len;
> +	dma_addr_t kern_buf_dma;
> +	u8 data_dir;
> +};
> +
> /* IOC State definitions */
> enum mpi3mr_iocstate {
> 	MRIOC_STATE_READY =3D 1,
> @@ -557,6 +578,7 @@ struct mpi3mr_sdev_priv_data {
>  * @ioc_status: IOC status from the firmware
>  * @ioc_loginfo:IOC log info from the firmware
>  * @is_waiting: Is the command issued in block mode
> + * @is_sense: Is Sense data present
>  * @retry_count: Retry count for retriable commands
>  * @host_tag: Host tag used by the command
>  * @callback: Callback for non blocking commands
> @@ -572,6 +594,7 @@ struct mpi3mr_drv_cmd {
> 	u16 ioc_status;
> 	u32 ioc_loginfo;
> 	u8 is_waiting;
> +	u8 is_sense;
> 	u8 retry_count;
> 	u16 host_tag;
>=20
> @@ -993,5 +1016,11 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mr=
ioc,
> int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
> void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
> void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
> +int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
> +	u16 handle, uint lun, u16 htag, ulong timeout,
> +	struct mpi3mr_drv_cmd *drv_cmd,
> +	u8 *resp_code, struct scsi_cmnd *scmd);
> +struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
> +	struct mpi3mr_ioc *mrioc, u16 handle);
>=20
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index a1ca1f26bd08..66d4000d8cc5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -195,7 +195,6 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc=
 *mrioc,
> 	kfree(alltgt_info);
> 	return rval;
> }
> -
> /**
>  * mpi3mr_get_change_count - Get topology change count
>  * @mrioc: Adapter instance reference
> @@ -385,6 +384,521 @@ static long mpi3mr_bsg_process_drv_cmds(struct bsg_=
job *job)
> 	return rval;
> }
>=20
> +/**
> + * mpi3mr_bsg_build_sgl - SGL construction for MPI commands
> + * @mpi_req: MPI request
> + * @sgl_offset: offset to start sgl in the MPI request
> + * @drv_bufs: DMA address of the buffers to be placed in sgl
> + * @bufcnt: Number of DMA buffers
> + * @is_rmc: Does the buffer list has management command buffer
> + * @is_rmr: Does the buffer list has management response buffer
> + * @num_datasges: Number of data buffers in the list
> + *
> + * This function places the DMA address of the given buffers in
> + * proper format as SGEs in the given MPI request.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_bsg_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
> +	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt, u8 is_rmc,
> +	u8 is_rmr, u8 num_datasges)
> +{
> +	u8 *sgl =3D (mpi_req + sgl_offset), count =3D 0;
> +	struct mpi3_mgmt_passthrough_request *rmgmt_req =3D
> +	    (struct mpi3_mgmt_passthrough_request *)mpi_req;
> +	struct mpi3mr_buf_map *drv_buf_iter =3D drv_bufs;
> +	u8 sgl_flags, sgl_flags_last;
> +
> +	sgl_flags =3D MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE |
> +		MPI3_SGE_FLAGS_DLAS_SYSTEM | MPI3_SGE_FLAGS_END_OF_BUFFER;
> +	sgl_flags_last =3D sgl_flags | MPI3_SGE_FLAGS_END_OF_LIST;
> +
> +	if (is_rmc) {
> +		mpi3mr_add_sg_single(&rmgmt_req->command_sgl,
> +		    sgl_flags_last, drv_buf_iter->kern_buf_len,
> +		    drv_buf_iter->kern_buf_dma);
> +		sgl =3D (u8 *)drv_buf_iter->kern_buf + drv_buf_iter->bsg_buf_len;
> +		drv_buf_iter++;
> +		count++;
> +		if (is_rmr) {
> +			mpi3mr_add_sg_single(&rmgmt_req->response_sgl,
> +			    sgl_flags_last, drv_buf_iter->kern_buf_len,
> +			    drv_buf_iter->kern_buf_dma);
> +			drv_buf_iter++;
> +			count++;
> +		} else
> +			mpi3mr_build_zero_len_sge(
> +			    &rmgmt_req->response_sgl);
> +	}
> +	if (!num_datasges) {
> +		mpi3mr_build_zero_len_sge(sgl);
> +		return;
> +	}
> +	for (; count < bufcnt; count++, drv_buf_iter++) {
> +		if (drv_buf_iter->data_dir =3D=3D DMA_NONE)
> +			continue;
> +		if (num_datasges =3D=3D 1 || !is_rmc)
> +			mpi3mr_add_sg_single(sgl, sgl_flags_last,
> +			    drv_buf_iter->kern_buf_len, drv_buf_iter->kern_buf_dma);
> +		else
> +			mpi3mr_add_sg_single(sgl, sgl_flags,
> +			    drv_buf_iter->kern_buf_len, drv_buf_iter->kern_buf_dma);
> +		sgl +=3D sizeof(struct mpi3_sge_common);
> +		num_datasges--;
> +	}
> +}
> +
> +/**
> + * mpi3mr_bsg_process_mpt_cmds - MPI Pass through BSG handler
> + * @job: BSG job reference
> + *
> + * This function is the top level handler for MPI Pass through
> + * command, this does basic validation of the input data buffers,
> + * identifies the given buffer types and MPI command, allocates
> + * DMAable memory for user given buffers, construstcs SGL
> + * properly and passes the command to the firmware.
> + *
> + * Once the MPI command is completed the driver copies the data
> + * if any and reply, sense information to user provided buffers.
> + * If the command is timed out then issues controller reset
> + * prior to returning.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +
> +static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned in=
t *reply_payload_rcv_len)
> +{
> +	long rval =3D -EINVAL;
> +
> +	struct mpi3mr_ioc *mrioc =3D NULL;
> +	u8 *mpi_req =3D NULL, *sense_buff_k =3D NULL;
> +	u8 mpi_msg_size =3D 0;
> +	struct mpi3mr_bsg_packet *bsg_req =3D NULL;
> +	struct mpi3mr_bsg_mptcmd *karg;
> +	struct mpi3mr_buf_entry *buf_entries =3D NULL;
> +	struct mpi3mr_buf_map *drv_bufs =3D NULL, *drv_buf_iter =3D NULL;
> +	u8 count, bufcnt =3D 0, is_rmcb =3D 0, is_rmrb =3D 0, din_cnt =3D 0, do=
ut_cnt =3D 0;
> +	u8 invalid_be =3D 0, erb_offset =3D 0xFF, mpirep_offset =3D 0xFF, sg_en=
tries =3D 0;
> +	u8 block_io =3D 0, resp_code =3D 0;
> +	struct mpi3_request_header *mpi_header =3D NULL;
> +	struct mpi3_status_reply_descriptor *status_desc;
> +	struct mpi3_scsi_task_mgmt_request *tm_req;
> +	u32 erbsz =3D MPI3MR_SENSE_BUF_SZ, tmplen;
> +	u16 dev_handle;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +	struct mpi3mr_stgt_priv_data *stgt_priv =3D NULL;
> +	struct mpi3mr_bsg_in_reply_buf *bsg_reply_buf =3D NULL;
> +	u32 din_size =3D 0, dout_size =3D 0;
> +	u8 *din_buf =3D NULL, *dout_buf =3D NULL;
> +	u8 *sgl_iter =3D NULL, *sgl_din_iter =3D NULL, *sgl_dout_iter =3D NULL;
> +
> +	bsg_req =3D job->request;
> +	karg =3D (struct mpi3mr_bsg_mptcmd *)&bsg_req->cmd.mptcmd;
> +
> +	mrioc =3D mpi3mr_bsg_verify_adapter(karg->mrioc_id);
> +	if (!mrioc)
> +		return -ENODEV;
> +
> +	if (karg->timeout < MPI3MR_APP_DEFAULT_TIMEOUT)
> +		karg->timeout =3D MPI3MR_APP_DEFAULT_TIMEOUT;
> +
> +	mpi_req =3D kzalloc(MPI3MR_ADMIN_REQ_FRAME_SZ, GFP_KERNEL);
> +	if (!mpi_req)
> +		return -ENOMEM;
> +	mpi_header =3D (struct mpi3_request_header *)mpi_req;
> +
> +	bufcnt =3D karg->buf_entry_list.num_of_entries;
> +	drv_bufs =3D kzalloc((sizeof(*drv_bufs) * bufcnt), GFP_KERNEL);
> +	if (!drv_bufs) {
> +		rval =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	dout_buf =3D kzalloc(job->request_payload.payload_len,
> +				      GFP_KERNEL);
> +	if (!dout_buf) {
> +		rval =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	din_buf =3D kzalloc(job->reply_payload.payload_len,
> +				     GFP_KERNEL);
> +	if (!din_buf) {
> +		rval =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	sg_copy_to_buffer(job->request_payload.sg_list,
> +			  job->request_payload.sg_cnt,
> +			  dout_buf, job->request_payload.payload_len);
> +
> +	buf_entries =3D karg->buf_entry_list.buf_entry;
> +	sgl_din_iter =3D din_buf;
> +	sgl_dout_iter =3D dout_buf;
> +	drv_buf_iter =3D drv_bufs;
> +
> +	for (count =3D 0; count < bufcnt; count++, buf_entries++, drv_buf_iter+=
+) {
> +
> +		if (sgl_dout_iter > (dout_buf + job->request_payload.payload_len)) {
> +			dprint_bsg_err(mrioc, "%s: data_out buffer length mismatch\n",
> +				__func__);
> +			rval =3D -EINVAL;
> +			goto out;
> +		}
> +		if (sgl_din_iter > (din_buf + job->reply_payload.payload_len)) {
> +			dprint_bsg_err(mrioc, "%s: data_in buffer length mismatch\n",
> +				__func__);
> +			rval =3D -EINVAL;
> +			goto out;
> +		}
> +
> +		switch (buf_entries->buf_type) {
> +		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD:
> +			sgl_iter =3D sgl_dout_iter;
> +			sgl_dout_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_TO_DEVICE;
> +			is_rmcb =3D 1;
> +			if (count !=3D 0)
> +				invalid_be =3D 1;
> +			break;
> +		case MPI3MR_BSG_BUFTYPE_RAIDMGMT_RESP:
> +			sgl_iter =3D sgl_din_iter;
> +			sgl_din_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_FROM_DEVICE;
> +			is_rmrb =3D 1;
> +			if (count !=3D 1 || !is_rmcb)
> +				invalid_be =3D 1;
> +			break;
> +		case MPI3MR_BSG_BUFTYPE_DATA_IN:
> +			sgl_iter =3D sgl_din_iter;
> +			sgl_din_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_FROM_DEVICE;
> +			din_cnt++;
> +			din_size +=3D drv_buf_iter->bsg_buf_len;
> +			if ((din_cnt > 1) && !is_rmcb)
> +				invalid_be =3D 1;
> +			break;
> +		case MPI3MR_BSG_BUFTYPE_DATA_OUT:
> +			sgl_iter =3D sgl_dout_iter;
> +			sgl_dout_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_TO_DEVICE;
> +			dout_cnt++;
> +			dout_size +=3D drv_buf_iter->bsg_buf_len;
> +			if ((dout_cnt > 1) && !is_rmcb)
> +				invalid_be =3D 1;
> +			break;
> +		case MPI3MR_BSG_BUFTYPE_MPI_REPLY:
> +			sgl_iter =3D sgl_din_iter;
> +			sgl_din_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_NONE;
> +			mpirep_offset =3D count;
> +			break;
> +		case MPI3MR_BSG_BUFTYPE_ERR_RESPONSE:
> +			sgl_iter =3D sgl_din_iter;
> +			sgl_din_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_NONE;
> +			erb_offset =3D count;
> +			break;
> +		case MPI3MR_BSG_BUFTYPE_MPI_REQUEST:
> +			sgl_iter =3D sgl_dout_iter;
> +			sgl_dout_iter +=3D buf_entries->buf_len;
> +			drv_buf_iter->data_dir =3D DMA_NONE;
> +			mpi_msg_size =3D buf_entries->buf_len;
> +			if ((!mpi_msg_size || (mpi_msg_size % 4)) ||
> +					(mpi_msg_size > MPI3MR_ADMIN_REQ_FRAME_SZ)) {
> +				dprint_bsg_err(mrioc, "%s: invalid MPI message size\n",
> +					__func__);
> +				rval =3D -EINVAL;
> +				goto out;
> +			}
> +			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
> +			break;
> +		default:
> +			invalid_be =3D 1;
> +			break;
> +		}
> +		if (invalid_be) {
> +			dprint_bsg_err(mrioc, "%s: invalid buffer entries passed\n",
> +				__func__);
> +			rval =3D -EINVAL;
> +			goto out;
> +		}
> +
> +		drv_buf_iter->bsg_buf =3D sgl_iter;
> +		drv_buf_iter->bsg_buf_len =3D buf_entries->buf_len;
> +
> +	}
> +	if (!is_rmcb && (dout_cnt || din_cnt)) {
> +		sg_entries =3D dout_cnt + din_cnt;
> +		if (((mpi_msg_size) + (sg_entries *
> +		      sizeof(struct mpi3_sge_common))) > MPI3MR_ADMIN_REQ_FRAME_SZ) {
> +			dprint_bsg_err(mrioc,
> +			    "%s:%d: invalid message size passed\n",
> +			    __func__, __LINE__);
> +			rval =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> +	if (din_size > MPI3MR_MAX_APP_XFER_SIZE) {
> +		dprint_bsg_err(mrioc,
> +		    "%s:%d: invalid data transfer size passed for function 0x%x din_si=
ze=3D%d\n",
> +		    __func__, __LINE__, mpi_header->function, din_size);
> +		rval =3D -EINVAL;
> +		goto out;
> +	}
> +	if (dout_size > MPI3MR_MAX_APP_XFER_SIZE) {
> +		dprint_bsg_err(mrioc,
> +		    "%s:%d: invalid data transfer size passed for function 0x%x dout_s=
ize =3D %d\n",
> +		    __func__, __LINE__, mpi_header->function, dout_size);
> +		rval =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	drv_buf_iter =3D drv_bufs;
> +	for (count =3D 0; count < bufcnt; count++, drv_buf_iter++) {
> +		if (drv_buf_iter->data_dir =3D=3D DMA_NONE)
> +			continue;
> +
> +		drv_buf_iter->kern_buf_len =3D drv_buf_iter->bsg_buf_len;
> +		if (is_rmcb && !count)
> +			drv_buf_iter->kern_buf_len +=3D ((dout_cnt + din_cnt) *
> +			    sizeof(struct mpi3_sge_common));
> +
> +		if (!drv_buf_iter->kern_buf_len)
> +			continue;
> +
> +		drv_buf_iter->kern_buf =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +		    drv_buf_iter->kern_buf_len, &drv_buf_iter->kern_buf_dma,
> +		    GFP_KERNEL);
> +		if (!drv_buf_iter->kern_buf) {
> +			rval =3D -ENOMEM;
> +			goto out;
> +		}
> +		if (drv_buf_iter->data_dir =3D=3D DMA_TO_DEVICE) {
> +			tmplen =3D min(drv_buf_iter->kern_buf_len,
> +			    drv_buf_iter->bsg_buf_len);
> +			memcpy(drv_buf_iter->kern_buf, drv_buf_iter->bsg_buf, tmplen);
> +		}
> +	}
> +
> +	if (erb_offset !=3D 0xFF) {
> +		sense_buff_k =3D kzalloc(erbsz, GFP_KERNEL);
> +		if (!sense_buff_k) {
> +			rval =3D -ENOMEM;
> +			goto out;
> +		}
> +	}
> +
> +	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex)) {
> +		rval =3D -ERESTARTSYS;
> +		goto out;
> +	}
> +	if (mrioc->bsg_cmds.state & MPI3MR_CMD_PENDING) {
> +		rval =3D -EAGAIN;
> +		dprint_bsg_err(mrioc, "%s: command is in use\n", __func__);
> +		mutex_unlock(&mrioc->bsg_cmds.mutex);
> +		goto out;
> +	}
> +	if (mrioc->unrecoverable) {
> +		dprint_bsg_err(mrioc, "%s: unrecoverable controller\n",
> +		    __func__);
> +		rval =3D -EFAULT;
> +		mutex_unlock(&mrioc->bsg_cmds.mutex);
> +		goto out;
> +	}
> +	if (mrioc->reset_in_progress) {
> +		dprint_bsg_err(mrioc, "%s: reset in progress\n", __func__);
> +		rval =3D -EAGAIN;
> +		mutex_unlock(&mrioc->bsg_cmds.mutex);
> +		goto out;
> +	}
> +	if (mrioc->stop_bsgs) {
> +		dprint_bsg_err(mrioc, "%s: bsgs are blocked\n", __func__);
> +		rval =3D -EAGAIN;
> +		mutex_unlock(&mrioc->bsg_cmds.mutex);
> +		goto out;
> +	}
> +
> +	if (mpi_header->function !=3D MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) {
> +		mpi3mr_bsg_build_sgl(mpi_req, (mpi_msg_size),
> +		    drv_bufs, bufcnt, is_rmcb, is_rmrb,
> +		    (dout_cnt + din_cnt));
> +	}
> +
> +	if (mpi_header->function =3D=3D MPI3_BSG_FUNCTION_SCSI_TASK_MGMT) {
> +		tm_req =3D (struct mpi3_scsi_task_mgmt_request *)mpi_req;
> +		if (tm_req->task_type !=3D
> +		    MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK) {
> +			dev_handle =3D tm_req->dev_handle;
> +			block_io =3D 1;
> +		}
> +	}
> +	if (block_io) {
> +		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
> +		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
> +			stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
> +			    tgtdev->starget->hostdata;
> +			atomic_inc(&stgt_priv->block_io);
> +			mpi3mr_tgtdev_put(tgtdev);
> +		}
> +	}
> +
> +	mrioc->bsg_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->bsg_cmds.is_waiting =3D 1;
> +	mrioc->bsg_cmds.callback =3D NULL;
> +	mrioc->bsg_cmds.is_sense =3D 0;
> +	mrioc->bsg_cmds.sensebuf =3D sense_buff_k;
> +	memset(mrioc->bsg_cmds.reply, 0, mrioc->reply_sz);
> +	mpi_header->host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_BSG_CMDS);
> +	if (mrioc->logging_level & MPI3_DEBUG_BSG_INFO) {
> +		dprint_bsg_info(mrioc,
> +		    "%s: posting bsg request to the controller\n", __func__);
> +		dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
> +		    "bsg_mpi3_req");
> +		if (mpi_header->function =3D=3D MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH) {
> +			drv_buf_iter =3D &drv_bufs[0];
> +			dprint_dump(drv_buf_iter->kern_buf,
> +			    drv_buf_iter->kern_buf_len, "mpi3_mgmt_req");
> +		}
> +	}
> +
> +	init_completion(&mrioc->bsg_cmds.done);
> +	rval =3D mpi3mr_admin_request_post(mrioc, mpi_req,
> +	    MPI3MR_ADMIN_REQ_FRAME_SZ, 0);
> +
> +
> +	if (rval) {
> +		mrioc->bsg_cmds.is_waiting =3D 0;
> +		dprint_bsg_err(mrioc,
> +		    "%s: posting bsg request is failed\n", __func__);
> +		rval =3D -EAGAIN;
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&mrioc->bsg_cmds.done,
> +	    (karg->timeout * HZ));
> +	if (block_io && stgt_priv)
> +		atomic_dec(&stgt_priv->block_io);
> +	if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		mrioc->bsg_cmds.is_waiting =3D 0;
> +		rval =3D -EAGAIN;
> +		if (mrioc->bsg_cmds.state & MPI3MR_CMD_RESET)
> +			goto out_unlock;
> +		dprint_bsg_err(mrioc,
> +		    "%s: bsg request timedout after %d seconds\n", __func__,
> +		    karg->timeout);
> +		if (mrioc->logging_level & MPI3_DEBUG_BSG_ERROR) {
> +			dprint_dump(mpi_req, MPI3MR_ADMIN_REQ_FRAME_SZ,
> +			    "bsg_mpi3_req");
> +			if (mpi_header->function =3D=3D
> +			    MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH) {
> +				drv_buf_iter =3D &drv_bufs[0];
> +				dprint_dump(drv_buf_iter->kern_buf,
> +				    drv_buf_iter->kern_buf_len, "mpi3_mgmt_req");
> +			}
> +		}
> +
> +		if (mpi_header->function =3D=3D MPI3_BSG_FUNCTION_SCSI_IO)
> +			mpi3mr_issue_tm(mrioc,
> +			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
> +			    mpi_header->function_dependent, 0,
> +			    MPI3MR_HOSTTAG_BLK_TMS, MPI3MR_RESETTM_TIMEOUT,
> +			    &mrioc->host_tm_cmds, &resp_code, NULL);
> +		if (!(mrioc->bsg_cmds.state & MPI3MR_CMD_COMPLETE) &&
> +		    !(mrioc->bsg_cmds.state & MPI3MR_CMD_RESET))
> +			mpi3mr_soft_reset_handler(mrioc,
> +			    MPI3MR_RESET_FROM_APP_TIMEOUT, 1);
> +		goto out_unlock;
> +	}
> +	dprint_bsg_info(mrioc, "%s: bsg request is completed\n", __func__);
> +
> +	if ((mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> +	     !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		dprint_bsg_info(mrioc,
> +		    "%s: command failed, ioc_status(0x%04x) log_info(0x%08x)\n",
> +		    __func__,
> +		    (mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
> +		    mrioc->bsg_cmds.ioc_loginfo);
> +	}
> +
> +	if ((mpirep_offset !=3D 0xFF) &&
> +	    drv_bufs[mpirep_offset].bsg_buf_len) {
> +		drv_buf_iter =3D &drv_bufs[mpirep_offset];
> +		drv_buf_iter->kern_buf_len =3D (sizeof(*bsg_reply_buf) - 1 +
> +					   mrioc->reply_sz);
> +		bsg_reply_buf =3D kzalloc(drv_buf_iter->kern_buf_len, GFP_KERNEL);
> +
> +		if (!bsg_reply_buf) {
> +			rval =3D -ENOMEM;
> +			goto out_unlock;
> +		}
> +		if (mrioc->bsg_cmds.state & MPI3MR_CMD_REPLY_VALID) {
> +			bsg_reply_buf->mpi_reply_type =3D
> +				MPI3MR_BSG_MPI_REPLY_BUFTYPE_ADDRESS;
> +			memcpy(bsg_reply_buf->reply_buf,
> +			    mrioc->bsg_cmds.reply, mrioc->reply_sz);
> +		} else {
> +			bsg_reply_buf->mpi_reply_type =3D
> +				MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS;
> +			status_desc =3D (struct mpi3_status_reply_descriptor *)
> +			    bsg_reply_buf->reply_buf;
> +			status_desc->ioc_status =3D mrioc->bsg_cmds.ioc_status;
> +			status_desc->ioc_log_info =3D mrioc->bsg_cmds.ioc_loginfo;
> +		}
> +		tmplen =3D min(drv_buf_iter->kern_buf_len,
> +			drv_buf_iter->bsg_buf_len);
> +		memcpy(drv_buf_iter->bsg_buf, bsg_reply_buf, tmplen);
> +	}
> +
> +	if (erb_offset !=3D 0xFF && mrioc->bsg_cmds.sensebuf &&
> +	    mrioc->bsg_cmds.is_sense) {
> +		drv_buf_iter =3D &drv_bufs[erb_offset];
> +		tmplen =3D min(erbsz, drv_buf_iter->bsg_buf_len);
> +		memcpy(drv_buf_iter->bsg_buf, sense_buff_k, tmplen);
> +	}
> +
> +	drv_buf_iter =3D drv_bufs;
> +	for (count =3D 0; count < bufcnt; count++, drv_buf_iter++) {
> +		if (drv_buf_iter->data_dir =3D=3D DMA_NONE)
> +			continue;
> +		if (drv_buf_iter->data_dir =3D=3D DMA_FROM_DEVICE) {
> +			tmplen =3D min(drv_buf_iter->kern_buf_len,
> +				     drv_buf_iter->bsg_buf_len);
> +			memcpy(drv_buf_iter->bsg_buf,
> +			       drv_buf_iter->kern_buf, tmplen);
> +		}
> +	}
> +
> +out_unlock:
> +	if (din_buf) {
> +		*reply_payload_rcv_len =3D
> +			sg_copy_from_buffer(job->reply_payload.sg_list,
> +					    job->reply_payload.sg_cnt,
> +					    din_buf, job->reply_payload.payload_len);
> +	}
> +	mrioc->bsg_cmds.is_sense =3D 0;
> +	mrioc->bsg_cmds.sensebuf =3D NULL;
> +	mrioc->bsg_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->bsg_cmds.mutex);
> +out:
> +	kfree(sense_buff_k);
> +	kfree(dout_buf);
> +	kfree(din_buf);
> +	kfree(mpi_req);
> +	if (drv_bufs) {
> +		drv_buf_iter =3D drv_bufs;
> +		for (count =3D 0; count < bufcnt; count++, drv_buf_iter++) {
> +			if (drv_buf_iter->kern_buf && drv_buf_iter->kern_buf_dma)
> +				dma_free_coherent(&mrioc->pdev->dev,
> +				    drv_buf_iter->kern_buf_len,
> +				    drv_buf_iter->kern_buf,
> +				    drv_buf_iter->kern_buf_dma);
> +		}
> +		kfree(drv_bufs);
> +	}
> +	kfree(bsg_reply_buf);
> +	return rval;
> +}
> +
> /**
>  * mpi3mr_bsg_request - bsg request entry point
>  * @job: BSG job reference
> @@ -404,6 +918,9 @@ int mpi3mr_bsg_request(struct bsg_job *job)
> 	case MPI3MR_DRV_CMD:
> 		rval =3D mpi3mr_bsg_process_drv_cmds(job);
> 		break;
> +	case MPI3MR_MPT_CMD:
> +		rval =3D mpi3mr_bsg_process_mpt_cmds(job, &reply_payload_rcv_len);
> +		break;
> 	default:
> 		pr_err("%s: unsupported BSG command(0x%08x)\n",
> 		    MPI3MR_DRIVER_NAME, bsg_req->cmd_type);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi=
3mr_debug.h
> index 65bfac72948c..2464c400a5a4 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
> @@ -124,6 +124,31 @@
>=20
> #endif /* MPT3SAS_DEBUG_H_INCLUDED */
>=20
> +/**
> + * dprint_dump - print contents of a memory buffer
> + * @req: Pointer to a memory buffer
> + * @sz: Memory buffer size
> + * @namestr: Name String to identify the buffer type
> + */
> +static inline void
> +dprint_dump(void *req, int sz, const char *name_string)
> +{
> +	int i;
> +	__le32 *mfp =3D (__le32 *)req;
> +
> +	sz =3D sz/4;
> +	if (name_string)
> +		pr_info("%s:\n\t", name_string);
> +	else
> +		pr_info("request:\n\t");
> +	for (i =3D 0; i < sz; i++) {
> +		if (i && ((i % 8) =3D=3D 0))
> +			pr_info("\n\t");
> +		pr_info("%08x ", le32_to_cpu(mfp[i]));
> +	}
> +	pr_info("\n");
> +}
> +
> /**
>  * dprint_dump_req - print message frame contents
>  * @req: pointer to message frame
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index a03e39083a42..450574fc1fec 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -634,7 +634,7 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_by=
_handle(
>  *
>  * Return: Target device reference.
>  */
> -static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
> +struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
> 	struct mpi3mr_ioc *mrioc, u16 handle)
> {
> 	struct mpi3mr_tgt_dev *tgtdev;
> @@ -2996,7 +2996,7 @@ inline void mpi3mr_poll_pend_io_completions(struct =
mpi3mr_ioc *mrioc)
>  *
>  * Return: 0 on success, non-zero on errors
>  */
> -static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
> +int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
> 	u16 handle, uint lun, u16 htag, ulong timeout,
> 	struct mpi3mr_drv_cmd *drv_cmd,
> 	u8 *resp_code, struct scsi_cmnd *scmd)
> --=20
> 2.27.0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

