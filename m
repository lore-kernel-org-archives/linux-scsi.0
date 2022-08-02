Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 569ADC00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 21:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiHBVMf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 17:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiHBVMe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 17:12:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE7046D9F
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 14:12:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 272KXvc4028656;
        Tue, 2 Aug 2022 21:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bCz7hU/htztg9zWDfLkgMmIPU+SjjkCoeBxkJq5rpl0=;
 b=YD+iypaI7d5E11c01dyZ76/7p+JdcRlMlW76oZDxWiE3FIkPq01szoNSw+DJqUrClGSe
 gFdiB7bpGhZLwE4hrZT56DnonB6LZ5HmRl8iBs+0jGtyzoymdKMbAuztX7wCNQeKd70U
 eEeJ3OY7iwL85DXbrvYMsiS5inX6k2mNS+xHzYopr1VJnt8iqph66zQKdV67KwU7fitu
 uBfE4EidryKF2o9ze3HT+vRRjP9FXAth7dbEJKc517W+GjOjhwk0EuzSU4lVJR2fgCyo
 qW4rGzFHhutksPoDOcp8/YznjahEqI/U0bJ79z3vlUswtibwRs75TQfWulfBYp43wj0p lg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9r10c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 21:12:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 272Jf5wB007354;
        Tue, 2 Aug 2022 21:12:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu32f296-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 21:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bv0jOL0KMNL/6Skrc8tIRKhIrYHij7spYO5JRhMEhHnyKaZHW6Z5od4bE2tEYFW6UtKpsa3uCYnAYBHfelpkZWH5rUsMKPXgfWYAoQE3LEOSnlEoZH/Wntk/soC+FzuHft4+vod9azE+jxFFjc2IbME2aMwFhDArwiqcalh8gR2JsS8XwpGE+/ruL+fyqaHF0g+LUTory424oG72e5PWhri+1vXUJh8KevKP8Fz06oCcbWxhJ0PGbP+yY/6WP8eEJGJOvvTQdQh6NwhE6lhjtkEuDUlURwSCG7/4w/fiDYphK8QBGD1t5qRhsOwv0LyhKwW2PROFdhLPAMFhycNUmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCz7hU/htztg9zWDfLkgMmIPU+SjjkCoeBxkJq5rpl0=;
 b=iQbXP+4F72Rl6n1qkqRgYtvNJrOF0TtuX43/XFvzItNmiwkhKnTaej8bVfOm3aC1BoKMsTIfdY9AMxa/tj6NhwMEci7xWxFgphZ1+vt15vBviiO4HzF7CW3R2eEBqScbfkhTl975H2/9i2eRQtRv6Zutb30xUS75jk0EkL7fHtX29iYUH/DZzYRcC6LeL7byd/rcrjcw1zVj7IwYp4+qiBEFfWO4P29ODnUc6Khqcb5cg9o2UylBSnF9hun/ovq+yCgDb+8SvEF/2eJWwsVd1LPBh2qXjO65Ns6xfrfJZ9lWCxFI7hRWiRLlA9kpWCw4oAbG45VsA2tvSSry64ujHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCz7hU/htztg9zWDfLkgMmIPU+SjjkCoeBxkJq5rpl0=;
 b=az0VEA9E2LvgK5p7ILT7rbdSICfhWghAI1dM4T6edGsu7SRxc7Y6m+Zyg7dLMObI3tu+/3aDVpqojetAcMSL2yZBpOlEUw6DdKD7R0KRfZClmN0ECoKEK8NYbkblGhf+ypONMGg/k04ItX373L+vQEErSr6q+PyWgcGVLaDmMtY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Tue, 2 Aug
 2022 21:12:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 21:12:29 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 15/15] mpi3mr: Block IOs while refreshing target dev
 objects
Thread-Topic: [PATCH 15/15] mpi3mr: Block IOs while refreshing target dev
 objects
Thread-Index: AQHYo0wQuKgC6SxWL0Wu4MmoZu/IRa2cIosA
Date:   Tue, 2 Aug 2022 21:12:29 +0000
Message-ID: <615133A3-CFE0-4134-AAC4-4ECEC5682384@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-16-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-16-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f5f5959-47f1-4550-7432-08da74cbb53c
x-ms-traffictypediagnostic: MW5PR10MB5874:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: etDiChyh+3dAC5DFTcnQX93TWUy6agtELBp2O9QhBQ6VaPTGjF+R3DYkRkXStfZ7wgh/F+OSB0ysV1ssHgTepTiQjNC8amD+Vb7N8Rg6auv2rIbuGEw+qfnEY+OctI7AZT0Oni9MbLIqv7jwThWc/wthga86TzxctafuLOKCqWKqgKQD+u5ivlUcCj8QobbokgS7OGGS/iTc6o3OtAX1TFCja9OdT8PmHWMNbDSD8Flk24rsyQh59jSPHbYV5WmBNfAqJGOm6w9LmXHAluDbsNXTOXOfjRJa9O5Iaj0t8B8niZlmy8NMtEnhqa2VkvAbOX+mggUY1c4+70qyy2sbwqCZhi0B6qdLf6EueEdNDUt9G0ueX/czwiuF0GmOoExFSM/3wz3aEfDN0myWYwVAVaNT2UGGdw3xTj/AxWamaWJQnPanHvUW6DA6SYfgA8btOKsvHIqTANBAeMITYmKn952XPNpLlCDVU8LfTy034bF8Pzc3E/LSA+aAhaI23xJcNZoOwCTG2al3OFpECjYPq40vgyj80HdHAvVCpOul1ylky8PGcUfc4g7LFwM4q4i1eA6rdAiF1BpOK5BjeHoG0ZurV0RyZRxJUl2b2LVVWvFZnLb/8MPCd2KTpPDCMDpfzbI+1pWpehpqPfaTE+GSm+Sjp9RLkMf7a4f99AiUAaUYHiNPVA/YI1MGTuC7HMeF4oID3AaFwNmfBSMZkkgpWrdbhNzTzQvBko5AdGjKwaBi8S9Poe3YtsYv0h4T0CXa1KQ6QapEtZXQQz+FKfGhB/tTC0GJ7D7WD6ZaKzG2uIg7dkapmstFSoNb+3/AbuY1Yl/whD5DjBYfHQjG1G34HrQQEvZVWNiNnpQteKEQyMg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(346002)(136003)(366004)(39860400002)(478600001)(6916009)(186003)(83380400001)(6512007)(6506007)(36756003)(107886003)(26005)(41300700001)(2616005)(54906003)(6486002)(316002)(8936002)(53546011)(4326008)(38070700005)(8676002)(71200400001)(44832011)(2906002)(33656002)(91956017)(38100700002)(66446008)(86362001)(66946007)(122000001)(5660300002)(76116006)(66476007)(64756008)(66556008)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fD71EkhOMzo6An9xvUb3vtt2Cs0zSP+G6jKS8z/z98V1mxXgSGn0nc4KBnQf?=
 =?us-ascii?Q?D6ch2+pQXzIMK84A6dUdKKq9EvZfQm0saPXXV1WifGLLlMEeBQsB1dgTiG76?=
 =?us-ascii?Q?WLCExQr8LwPo9hgL3hbdpKoHl1Nd97jsf5Slyx1n5VXpw7s4kP2Agz4OmT09?=
 =?us-ascii?Q?EFmY3HfqLklWijNIn9ayx16hdH7fmD6ROPOlOaOsFDG2G232jgHBdn2bYL5L?=
 =?us-ascii?Q?Wo29Jx7lLxi9dOwR8UBnB7+TY2dQbB1RVEqgxsY4RuDXIzbYoN2Q62LfKRPK?=
 =?us-ascii?Q?zo/QHokVJTSCTwuKH9/K7DW5nOImgnDHaBv3cYEHKvnaGjNH5WnHDOyT8iar?=
 =?us-ascii?Q?vl39LrhWYFXzYfIODjOcGtdLyxNQiO6QSne54paK5BAaT7i39jKS2MNNx0gn?=
 =?us-ascii?Q?6MKTcs5uvILgQSiBHKywQY78ax4jYehVxgFqnTwtcXT/ibTV3CI/vtVUj97d?=
 =?us-ascii?Q?S0Ug6aYmQ4WT9sJ7QvXq0PHFY93qR/6PIz4Xc7kbcCKMcvnX4tlwEXs7IwIW?=
 =?us-ascii?Q?to4sz+zal7sxtAFmaNFHGr4MK6nHGTVwav58t6oQ5EpWcI5BoBDC24cOjJwM?=
 =?us-ascii?Q?DAGFTjF+YQm+RFSUAWUCVLUJW9ral0I0bFtQF4AT0H1Br+2YhRz9DFheu015?=
 =?us-ascii?Q?QR9AvaaNmqmCQE73sKQ/OrpimgUK/v8x1ulxq1poBiUi22RqJ361vezFPrrN?=
 =?us-ascii?Q?Q6Tr3hKFxV6A5M+1w7NC/KYlUO7g2WjkKmTAabRpHN9/BQLDBL/H4rJdmgFd?=
 =?us-ascii?Q?pkhnCaMeNNEpQh+b+rul7Kw2NVo4eA+sYfs7uEQ4Bnq0rXNB7z6puee5oot6?=
 =?us-ascii?Q?hsD99klrmNQo2DsZAT/4KnBH+qyWGa1xX4YFH53FnXw6PS3fnHntx7LHBZ2s?=
 =?us-ascii?Q?JHF7dJRb3y+Dif2YdVl+CcbsBIOkLSXpwMpRE6yvdU3PpQDAIapGL7SuaAHz?=
 =?us-ascii?Q?en03NC7qT2n85saY4t/0AB07nr6kse7RYS/wGgB/G/2RTE+wJ4PwQgb0ox1d?=
 =?us-ascii?Q?PqL5Mpd2IJ/tsKmkCOwODR8JRbvhIODsHDoFgdu6d52F36KZRtkpKtQovg6y?=
 =?us-ascii?Q?ALm0mm98nrSb8j8kYgvnNsV1Y3kNx6BWcYWgr91X4FJ+qRgoTVk6Da8lo1nr?=
 =?us-ascii?Q?k7zudF/uzLEMVCHcWINXKDMm7lFOOze/MTgOAd3T68fsFtMMZ0Vcab6ZhYYu?=
 =?us-ascii?Q?bklEtyJ82kkEJE/5/AKJP4TrZSkv4xRrBqdrUKP4plVqyLDXKmO33brexfR2?=
 =?us-ascii?Q?qUx77nMhsX4u9ow02hvMjmqAR+jg6oVC9xBja9x8JS3seUUj6iqyEYdAFrs5?=
 =?us-ascii?Q?7q/fCcRJdj4FattlnZO9SxC6aphNJ9kSWVlkDPEik3ikZBsx69xDoMyMLA7S?=
 =?us-ascii?Q?r//LtwJvvJS2EUIYL3WAX6IVRZNrjAYnhbMfTiIjsVQua3AZ1FJaIQgTV51x?=
 =?us-ascii?Q?cTeQJ/TdmvxjrhnuPtPsfdHKegqCxPd635wKRM5viwMVv5fapjVBGw8MTtXP?=
 =?us-ascii?Q?7BAxkkdqs7SJn6xhOn6jgTib3Y3bICkDNUnXZWQ66WaI76rEEgci4Qhi/eoy?=
 =?us-ascii?Q?O3ZtyE7T+VDrpQAJt5vaoDlBoSJVZNJvkXm3WIAN5zVPMc8UYlCFC1hWccYL?=
 =?us-ascii?Q?Lg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E7D275ABACF934C8CF3671D310F2DEB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5f5959-47f1-4550-7432-08da74cbb53c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 21:12:29.3855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SN8NfYjlBNsG6dRBbqlon8NlZv5HUoJy71/5ca12hvCo0K+WJMILj9EAi+3/LcHfy4cfEoyp0jETyaHZj1M3+LB5ogmFTsJTEx/OSbTJDkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-02_14,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208020099
X-Proofpoint-ORIG-GUID: j8EEk_zUOwuVICjGVeo9ZK3m3gMwO0OR
X-Proofpoint-GUID: j8EEk_zUOwuVICjGVeo9ZK3m3gMwO0OR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Block the IOs on the target devices until corresponding
> target device's target dev objects are refreshed as part
> of post controller reset operation.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr_os.c | 25 +++++++++++++++----------
> 1 file changed, 15 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index d4f37b1..c7d9e46 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -424,6 +424,8 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *=
mrioc)
> 			tgt_priv->io_throttle_enabled =3D 0;
> 			tgt_priv->io_divert =3D 0;
> 			tgt_priv->throttle_group =3D NULL;
> +			if (tgtdev->host_exposed)
> +				atomic_set(&tgt_priv->block_io, 1);
> 		}
> 	}
> }
> @@ -835,6 +837,7 @@ void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc=
 *mrioc,
> 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
> 	if (tgtdev->starget && tgtdev->starget->hostdata) {
> 		tgt_priv =3D tgtdev->starget->hostdata;
> +		atomic_set(&tgt_priv->block_io, 0);
> 		tgt_priv->dev_handle =3D MPI3MR_INVALID_DEV_HANDLE;
> 	}
>=20
> @@ -1077,6 +1080,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc =
*mrioc,
> 		scsi_tgt_priv_data->dev_type =3D tgtdev->dev_type;
> 		scsi_tgt_priv_data->io_throttle_enabled =3D
> 		    tgtdev->io_throttle_enabled;
> +		if (is_added =3D=3D true)
> +			atomic_set(&scsi_tgt_priv_data->block_io, 0);
> 	}
>=20
> 	switch (dev_pg0->access_status) {
> @@ -4576,6 +4581,16 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
>=20
> 	stgt_priv_data =3D sdev_priv_data->tgt_priv_data;
>=20
> +	if (atomic_read(&stgt_priv_data->block_io)) {
> +		if (mrioc->stop_drv_processing) {
> +			scmd->result =3D DID_NO_CONNECT << 16;
> +			scsi_done(scmd);
> +			goto out;
> +		}
> +		retval =3D SCSI_MLQUEUE_DEVICE_BUSY;
> +		goto out;
> +	}
> +
> 	dev_handle =3D stgt_priv_data->dev_handle;
> 	if (dev_handle =3D=3D MPI3MR_INVALID_DEV_HANDLE) {
> 		scmd->result =3D DID_NO_CONNECT << 16;
> @@ -4588,16 +4603,6 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
> 		goto out;
> 	}
>=20
> -	if (atomic_read(&stgt_priv_data->block_io)) {
> -		if (mrioc->stop_drv_processing) {
> -			scmd->result =3D DID_NO_CONNECT << 16;
> -			scsi_done(scmd);
> -			goto out;
> -		}
> -		retval =3D SCSI_MLQUEUE_DEVICE_BUSY;
> -		goto out;
> -	}
> -
> 	if (stgt_priv_data->dev_type =3D=3D MPI3_DEVICE_DEVFORM_PCIE)
> 		is_pcie_dev =3D 1;
> 	if ((scmd->cmnd[0] =3D=3D UNMAP) && is_pcie_dev &&
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

