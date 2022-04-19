Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B9DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 18:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346139AbiDSSLy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiDSSLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 14:11:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA7B3CA64
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 11:09:08 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JHLA16012431;
        Tue, 19 Apr 2022 18:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+b+GFMIPacZ3h/s25K3Z5HwUsxUgQeo2xBko9Yutgzo=;
 b=kJC7OSbeqP1Q6OJxb7Vd9BqMxLlTSoFDktzFs++x9XLzVf4Sgu3IemaZeJHLs6sjIf3i
 bbLq7DrX03bOv8SeT2EhIY5iPTSo+WTLr44+Ocxn2sCpxj8MtbRizqE8TR0KjHvQPcDF
 i4tVv/2/DcdmkiQCcU2T/BReM04sD6b1OZ6ZR6toQWkHLJ38YqV4KeeRJ7CEWNtVUl+9
 9k5k3SPnmDpBw0hZYYWn5o8pvQrCozckfN4Bz34t+2H7VI4Jn+h6vgj28/tqU4MEfovi
 UX3ss/lh7oEpIF04JIpaDS/hBJ9UleW72YJFTioMTR/0MFajRYsqNdDrm5a/rBHtw9le nA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffpbv6wpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:08:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JI5h5Y022766;
        Tue, 19 Apr 2022 18:08:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88qekb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:08:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhNxZ3wrGNQXNIZiimQthCejbb+Tjd7reR9epyi/2hxjcrQXHQ0mMmmiu4TEv/Xa03pFPv3FUjAftK0i6pFG06rQ2HhohzEE3fwr+kSjLed57IDqowwIi/Q0IaWPo31Pa82lEY9bhBOC7DEOqSnvVLSehaqo/ykr0Mo9QPrTeiHdNyf43f2YHIT3mKs+pEA0J/gbza2proKaOeGo2xISc8wIp/Sig/TR3N8Wnr1Xb1VdQI1ipSjhSH8bRDiVc70SYSgZPLdLJ5YS5KM0Z1jBV59uosluYNKq/XbhSibqAGvvLfSMFCMpG/0jBDZNty/OXft0U4DntDuwU+eidNAA3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+b+GFMIPacZ3h/s25K3Z5HwUsxUgQeo2xBko9Yutgzo=;
 b=dxGWoxsilDo7haNt/ksqj6vO2HDC4ScrmEO/7gLOOqAHebahjxra/03Nh89JkTTdW1k4+brm35qbKS9LS+QFL2GUGLeHipVYyn/3iW13kOsEn9RJ741oiigzFIOT2f+0ARz8eZN4eWdQKbtVyvPIzF6bxgcbkOmouimDRm8TyDCEG1Cp1HB+RpT+8O6BSA3nA7uLT0pvXg56H/cvlDQSifT5vTf/g22DVkyKCOaqIE6zVjmf+zanpjMpLsX+7UJc8zupCNPDoIAk2BGsdON7PFyj24gc6qvqd4ONP/vbXnQfPh1113YWgUP5W14guRTxnm7rYKuQViVDfASOeUCwLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+b+GFMIPacZ3h/s25K3Z5HwUsxUgQeo2xBko9Yutgzo=;
 b=gD73op72VoZul+61fmwMlPIGcdIgvlnV5NfP6wJKZshb+2yWUkOfrf5jAi4g4R2/9luHWgbuZPxVF1ivDrG9Of4EFcNH+boPaw9+Ku9d2lulfgTa+eFuLP/8nwZBWPwt4JFLNLOGK+m959NIaOvnuwh1LyavexBTQx6xCHn73og=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH2PR10MB3751.namprd10.prod.outlook.com (2603:10b6:610:1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 18:08:44 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 18:08:44 +0000
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
Subject: Re: [PATCH v4 2/8] mpi3mr: add support for driver commands
Thread-Topic: [PATCH v4 2/8] mpi3mr: add support for driver commands
Thread-Index: AQHYT0b2ih9Ak1nKZUSCPQGBmx/NmKz3knSA
Date:   Tue, 19 Apr 2022 18:08:44 +0000
Message-ID: <BC762F80-EC80-4C4D-BF9C-1C92C0B56EB2@oracle.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
 <20220413145652.112271-3-sumit.saxena@broadcom.com>
In-Reply-To: <20220413145652.112271-3-sumit.saxena@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98ddd70a-08fd-446c-15a8-08da222fa486
x-ms-traffictypediagnostic: CH2PR10MB3751:EE_
x-microsoft-antispam-prvs: <CH2PR10MB3751FBB0A0200F6C1B568D54E6F29@CH2PR10MB3751.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bldYrVVekrybB40akVJbqEw5KlANXJiMUWJSdOhv6NiSJAe/9HqZssbT6/2Cq9ubBT5KXERRBJYmyu6yNarhQ5aty1AXbRJBPJyByTC1sKde5Q//F629K9PF6OXT8XjuBe5ZXQPL+9fFIar5bHY0n1aTJ+cZ64UuUtdDAs9rPagDt1GxgFUMXYaq8wbNT80arnb8rgkhdTd/3yzAXW6FhfA9LOPV2JBfos4NSr95jhxn6F+WmI1+lj0etKWK95vXL+/FTVF2Znklj2+UMNuq/ZIac0wSIp9ab+8pw/D/WUXwmXr/eomUZbCfD9hXeouYpdeBgL+hBP8oELgbEbxb95DRywKwn+9VxMfSuG/kxkXV2f/1etiGmOYVAp89DYGGG//6GoMafwHTvKOoUTwkJRM7DowbeXFDcV4QTbnl16OYv8c4gEmUBWlvcWdk6/FheMvkbyxIxlwzNSuoXl7iABxEvCLjHHTTFkCreS2KYJo6iXd2C8KouNVk1DHHPr0gmxvy5XPWVj/bM5nhUr9FbbMoNVmPLRk3yJcara/+Isq59awetgvzoan0HqzigN1in4HNB7FnlUjG3kEY2FpKiH95b0ubskCudpjXWfUcXuToxdOyRB1HuPSm7nxPqBlLLFIhmbAxzn+SrXmN6ceVJ8drhJ0yAQ2sr0mF8OE9y6Z2cs4WnLB0Cf94ZceZ595W1EO1L8PBPKDES5kQKy1mutIAzCmAMVN9hYwr8ewPZzdVZLY/eUb3rXCvet4jfxwczg6Uk3Io2YFf9HyzIgzG8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(33656002)(7416002)(508600001)(4326008)(44832011)(8676002)(64756008)(66476007)(91956017)(66556008)(54906003)(6916009)(5660300002)(2616005)(6506007)(2906002)(122000001)(53546011)(6512007)(8936002)(36756003)(71200400001)(76116006)(66946007)(38100700002)(86362001)(83380400001)(6486002)(38070700005)(316002)(186003)(30864003)(26005)(32563001)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?31yltdZ0STi/h65Z6wumooSh+SXjf2otQC6pcHXJEq7QThWjpxWVDh9RNNmg?=
 =?us-ascii?Q?m2jegyvW0v65VAcT9qcf9xI6fs83/NPe2X+hITmwonjzJqeCkVWxR568Gak2?=
 =?us-ascii?Q?PsDQMO7w+DtGv4uCNPRMV8T7+PqEvc+8NS5kW1JUNUxYTeJUS/WWV09To7sk?=
 =?us-ascii?Q?A05lM7hqfqPClsUpMH122pS+aisMTVj6Ny4QJehM9zH+bRo7xLsgxxgJrSOM?=
 =?us-ascii?Q?3q9DQ9RPPnppwwYI+CFqmFYieBFFaj7DoyVm08N+m+Bde852BJn6jV1/NyNy?=
 =?us-ascii?Q?I6jDOLyjUGoZRHA5fV+8/pOccwQ2jpo3vZbd4pCQWpa1tdwVBiWaBYuOzLw9?=
 =?us-ascii?Q?7gZ3arxhDuvNWXv7tXMCD8wsCgJiz6LBzzQPX7VmRVbi/BKkRGJa8RNfir8V?=
 =?us-ascii?Q?dTWeJGVNAYfrYT6VYQ6AIveAOjkMrxuos7kFVxdfQe6oTbUXr7XDQ7FP8H/t?=
 =?us-ascii?Q?JJo+yp3DJ6NXdTwE/3vAPSCQK3FydukUz5r2tKlAOHIVN59cpHHXPTQqH3QO?=
 =?us-ascii?Q?b3W0HF2m9PGMKBjIcSg8y8/vQQ0zwHQ6Rj+pcQBKssUFAhHCdCvvY7cQVs99?=
 =?us-ascii?Q?rFuk22m1+fLTpuwgU4QkDntFWgoWxS9Jvyd/hLM1pY1nMbyaLfnv/gc/n6yt?=
 =?us-ascii?Q?9EWQ557bcuGFMaKAPkWjTfJjg5NgBB6LzsKoRoKuP3q7kHmT5o/bCcqn0gjN?=
 =?us-ascii?Q?pz7jmxNKlwQbTgzqQBP6sHFXBIVpZH9qFLx7NfYcNxHmBkJ+Ttd8J7CaLg4e?=
 =?us-ascii?Q?RHKVMshIb83V9vS5UcEhNMGX2S3pjb24rvrlyd3C9QJOAM4LDqbdf6PxxXn1?=
 =?us-ascii?Q?N7b0fIJ6IIKeXfeLi7J6Chwv2axcpbu5+s3glHGIiTqqcEO0gWfjuLF8Ea9u?=
 =?us-ascii?Q?CHhs7qiGn8LzL21h6cVSbVw+8TvcqzIR0+/Xwr9jn5aZ8KPSIadNzcuKPF/r?=
 =?us-ascii?Q?06RIBc/6yYKgJyG9jQ6AqFXCCT+juj+Je61b/ta7aY0mpXHVCi/RjF627tPY?=
 =?us-ascii?Q?KR9n9LXGI0N5+Wn3fhKXObdmyF2Grct3SvNiUNJXEpLf4Uw/VKWMtDM6fNbE?=
 =?us-ascii?Q?H7XOwDSGmM0m9cmJNKuvDa6QVgASlIIuBAmOVH67DojuCiAbBFPieeiqDfPu?=
 =?us-ascii?Q?jWLTYjPD4EdWGZUXXSQCwhZHZ9mrOTI41ZqZ6YOV+btkTj/qqdFPscmUYcps?=
 =?us-ascii?Q?4/Jz9PldVXGdYyUtYoDXa/mGhcLVFPyA3NTLx7mKJ1N9l6LssOarMlZfyC/R?=
 =?us-ascii?Q?2K8Wyrh1DqSTSFjAa8EjwpJxBz8M/QR2D4WMSeG13SNqgWV0Tc+v2+KecKF8?=
 =?us-ascii?Q?hAJS2ImXHYpJCqT5glAJ2p/5K/EQMqtLXAEnslYQAftkGJMLH1h13DBRjn6q?=
 =?us-ascii?Q?rQinQD9uPdghfKzK1RCQt6SYXGlo0r7MEk4/UzGzgV55Jv5kQ9xpfZKox4H4?=
 =?us-ascii?Q?SBryc1Nmp2BGcy3VKexpQqJAMDLVPpzCpvvfVXSC9XUsqpxwtj7KD7YESSlf?=
 =?us-ascii?Q?0+IZzhFFyZZTOV1PJ+xqE7tXX/yr6efnFQwkirRR9aKZ6h29sPMla5qoad3Q?=
 =?us-ascii?Q?sIWlqrvPXzNvBZ+d+vvNV7zYeJgyI9ZEXhRFDaxb9yULCQQdxHAsu7v6mTzE?=
 =?us-ascii?Q?MiPkZnbPtxz1amohWdUPO2kpbvOw130V2xJf9S+3AhkRZFa2DjgovmastLTy?=
 =?us-ascii?Q?ABO33iGkfoQGgNg5ycyAo1BCoG1XSWhPZCAMOStetu1ZZw29OS6AhGK75x+6?=
 =?us-ascii?Q?nsklBlDE9rIgZ3uFsdwT57GFjh6qNIlH18LTw0AFdh4beCxq6a4Z?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <014F31AB6C81B94CB359559D865A5255@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98ddd70a-08fd-446c-15a8-08da222fa486
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 18:08:44.4154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRMjPTQfWYbtqjVpvJAFYbqpzyKyMJyivPqtEIGL6HrxSa2mchr8KWUKpZOGpLrr5FxUt7hH5JpIPxjtZcRec1d45G8IH4pWSJlUux8ZOdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3751
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_06:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190104
X-Proofpoint-GUID: 9NoljiIdp-t28p_wCokOtyUSdpf0M5pC
X-Proofpoint-ORIG-GUID: 9NoljiIdp-t28p_wCokOtyUSdpf0M5pC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 13, 2022, at 7:56 AM, Sumit Saxena <sumit.saxena@broadcom.com> wro=
te:
>=20
> There are certain BSG commands which is to be completed
> by driver without involving firmware. These requests are termed
> as driver commands. This patch adds support for the same.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h        |  16 +-
> drivers/scsi/mpi3mr/mpi3mr_app.c    | 392 +++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_debug.h  |  12 +-
> drivers/scsi/mpi3mr/mpi3mr_fw.c     |  21 +-
> drivers/scsi/mpi3mr/mpi3mr_os.c     |   3 +
> include/uapi/scsi/scsi_bsg_mpi3mr.h | 433 ++++++++++++++++++++++++++++
> 6 files changed, 865 insertions(+), 12 deletions(-)
> create mode 100644 include/uapi/scsi/scsi_bsg_mpi3mr.h
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index f0515f929110..877b0925dbc5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -89,7 +89,7 @@ extern int prot_mask;
> /* Reserved Host Tag definitions */
> #define MPI3MR_HOSTTAG_INVALID		0xFFFF
> #define MPI3MR_HOSTTAG_INITCMDS		1
> -#define MPI3MR_HOSTTAG_IOCTLCMDS	2
> +#define MPI3MR_HOSTTAG_BSG_CMDS		2
> #define MPI3MR_HOSTTAG_BLK_TMS		5
>=20
> #define MPI3MR_NUM_DEVRMCMD		16
> @@ -202,10 +202,10 @@ enum mpi3mr_iocstate {
> enum mpi3mr_reset_reason {
> 	MPI3MR_RESET_FROM_BRINGUP =3D 1,
> 	MPI3MR_RESET_FROM_FAULT_WATCH =3D 2,
> -	MPI3MR_RESET_FROM_IOCTL =3D 3,
> +	MPI3MR_RESET_FROM_APP =3D 3,
> 	MPI3MR_RESET_FROM_EH_HOS =3D 4,
> 	MPI3MR_RESET_FROM_TM_TIMEOUT =3D 5,
> -	MPI3MR_RESET_FROM_IOCTL_TIMEOUT =3D 6,
> +	MPI3MR_RESET_FROM_APP_TIMEOUT =3D 6,
> 	MPI3MR_RESET_FROM_MUR_FAILURE =3D 7,
> 	MPI3MR_RESET_FROM_CTLR_CLEANUP =3D 8,
> 	MPI3MR_RESET_FROM_CIACTIV_FAULT =3D 9,
> @@ -698,6 +698,7 @@ struct scmd_priv {
>  * @chain_bitmap_sz: Chain buffer allocator bitmap size
>  * @chain_bitmap: Chain buffer allocator bitmap
>  * @chain_buf_lock: Chain buffer list lock
> + * @bsg_cmds: Command tracker for BSG command
>  * @host_tm_cmds: Command tracker for task management commands
>  * @dev_rmhs_cmds: Command tracker for device removal commands
>  * @evtack_cmds: Command tracker for event ack commands
> @@ -729,6 +730,10 @@ struct scmd_priv {
>  * @requested_poll_qcount: User requested poll queue count
>  * @bsg_dev: BSG device structure
>  * @bsg_queue: Request queue for BSG device
> + * @stop_bsgs: Stop BSG request flag
> + * @logdata_buf: Circular buffer to store log data entries
> + * @logdata_buf_idx: Index of entry in buffer to store
> + * @logdata_entry_sz: log data entry size
>  */
> struct mpi3mr_ioc {
> 	struct list_head list;
> @@ -835,6 +840,7 @@ struct mpi3mr_ioc {
> 	void *chain_bitmap;
> 	spinlock_t chain_buf_lock;
>=20
> +	struct mpi3mr_drv_cmd bsg_cmds;
> 	struct mpi3mr_drv_cmd host_tm_cmds;
> 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
> 	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
> @@ -872,6 +878,10 @@ struct mpi3mr_ioc {
>=20
> 	struct device *bsg_dev;
> 	struct request_queue *bsg_queue;
> +	u8 stop_bsgs;
> +	u8 *logdata_buf;
> +	u16 logdata_buf_idx;
> +	u16 logdata_entry_sz;
> };
>=20
> /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 9b6698525990..a1ca1f26bd08 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -9,6 +9,381 @@
>=20
> #include "mpi3mr.h"
> #include <linux/bsg-lib.h>
> +#include <uapi/scsi/scsi_bsg_mpi3mr.h>
> +
> +/**
> + * mpi3mr_bsg_verify_adapter - verify adapter number is valid
> + * @ioc_number: Adapter number
> + *
> + * This function returns the adapter instance pointer of given
> + * adapter number. If adapter number does not match with the
> + * driver's adapter list, driver returns NULL.
> + *
> + * Return: adapter instance reference
> + */
> +static struct mpi3mr_ioc *mpi3mr_bsg_verify_adapter(int ioc_number)
> +{
> +	struct mpi3mr_ioc *mrioc =3D NULL;
> +
> +	spin_lock(&mrioc_list_lock);
> +	list_for_each_entry(mrioc, &mrioc_list, list) {
> +		if (mrioc->id =3D=3D ioc_number) {
> +			spin_unlock(&mrioc_list_lock);
> +			return mrioc;
> +		}
> +	}
> +	spin_unlock(&mrioc_list_lock);
> +	return NULL;
> +}
> +
> +/**
> + * mpi3mr_enable_logdata - Handler for log data enable
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function enables log data caching in the driver if not
> + * already enabled and return the maximum number of log data
> + * entries that can be cached in the driver.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval =3D -EINVAL;
> +	struct mpi3mr_logdata_enable logdata_enable;
> +
> +	if (!mrioc->logdata_buf) {
> +		mrioc->logdata_entry_sz =3D
> +		    (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) -=
 4))
> +		    + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
> +		mrioc->logdata_buf_idx =3D 0;
> +		mrioc->logdata_buf =3D kcalloc(MPI3MR_BSG_LOGDATA_MAX_ENTRIES,
> +		    mrioc->logdata_entry_sz, GFP_KERNEL);
> +
> +		if (!mrioc->logdata_buf)
> +			return -ENOMEM;
> +	}
> +
> +	memset(&logdata_enable, 0, sizeof(logdata_enable));
> +	logdata_enable.max_entries =3D
> +	    MPI3MR_BSG_LOGDATA_MAX_ENTRIES;
> +	if (job->request_payload.payload_len >=3D sizeof(logdata_enable)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &logdata_enable, sizeof(logdata_enable));
> +		rval =3D 0;

Just return 0 here

> +	}
> +
> +	return rval;
> +}
> +/**
> + * mpi3mr_get_logdata - Handler for get log data
> + * @mrioc: Adapter instance reference
> + * @job: BSG job pointer
> + * This function copies the log data entries to the user buffer
> + * when log caching is enabled in the driver.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	u16 num_entries, sz, entry_sz =3D mrioc->logdata_entry_sz;
> +
> +	if ((!mrioc->logdata_buf) || (job->request_payload.payload_len < entry_=
sz))
> +		return -EINVAL;
> +
> +	num_entries =3D job->request_payload.payload_len / entry_sz;
> +	if (num_entries > MPI3MR_BSG_LOGDATA_MAX_ENTRIES)
> +		num_entries =3D MPI3MR_BSG_LOGDATA_MAX_ENTRIES;
> +	sz =3D num_entries * entry_sz;
> +
> +	if (job->request_payload.payload_len >=3D sz) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    mrioc->logdata_buf, sz);
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +/**
> + * mpi3mr_get_all_tgt_info - Get all target information
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function copies the driver managed target devices device
> + * handle, persistent ID, bus ID and taret ID to the user
> + * provided buffer for the specific controller. This function
> + * also provides the number of devices managed by the driver for
> + * the specific controller.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval =3D -EINVAL;
> +	u16 num_devices =3D 0, i =3D 0, size;
> +	unsigned long flags;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +	struct mpi3mr_device_map_info *devmap_info =3D NULL;
> +	struct mpi3mr_all_tgt_info *alltgt_info =3D NULL;
> +	uint32_t min_entrylen =3D 0, kern_entrylen =3D 0, usr_entrylen =3D 0;
> +
> +	if (job->request_payload.payload_len < sizeof(u32)) {
> +		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
> +		    __func__);
> +		return rval;
> +	}
> +
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
> +		num_devices++;
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +	if ((job->request_payload.payload_len =3D=3D sizeof(u32)) ||
> +		list_empty(&mrioc->tgtdev_list)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &num_devices, sizeof(num_devices));
> +		return 0;
> +	}
> +
> +	kern_entrylen =3D (num_devices - 1) * sizeof(*devmap_info);
> +	size =3D sizeof(*alltgt_info) + kern_entrylen;
> +	alltgt_info =3D kzalloc(size, GFP_KERNEL);
> +	if (!alltgt_info)
> +		return -ENOMEM;
> +
> +	devmap_info =3D alltgt_info->dmi;
> +	memset((u8 *)devmap_info, 0xFF, (kern_entrylen + sizeof(*devmap_info)))=
;
> +	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> +	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
> +		if (i < num_devices) {
> +			devmap_info[i].handle =3D tgtdev->dev_handle;
> +			devmap_info[i].perst_id =3D tgtdev->perst_id;
> +			if (tgtdev->host_exposed && tgtdev->starget) {
> +				devmap_info[i].target_id =3D tgtdev->starget->id;
> +				devmap_info[i].bus_id =3D
> +				    tgtdev->starget->channel;
> +			}
> +			i++;
> +		}
> +	}
> +	num_devices =3D i;
> +	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> +
> +	memcpy(&alltgt_info->num_devices, &num_devices, sizeof(num_devices));
> +
> +	usr_entrylen =3D (job->request_payload.payload_len - sizeof(u32)) / siz=
eof(*devmap_info);
> +	usr_entrylen *=3D sizeof(*devmap_info);
> +	min_entrylen =3D min(usr_entrylen, kern_entrylen);
> +	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entryl=
en))) {
> +		dprint_bsg_err(mrioc, "%s:%d: device map info copy failed\n",
> +		    __func__, __LINE__);
> +		rval =3D -EFAULT;
> +		goto out;
> +	}
> +
> +	sg_copy_from_buffer(job->request_payload.sg_list,
> +			    job->request_payload.sg_cnt,
> +			    alltgt_info, job->request_payload.payload_len);
> +	rval =3D 0;
> +out:
> +	kfree(alltgt_info);
> +	return rval;
> +}
> +
> +/**
> + * mpi3mr_get_change_count - Get topology change count
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function copies the toplogy change count provided by the
> + * driver in events and cached in the driver to the user
> + * provided buffer for the specific controller.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_get_change_count(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval =3D -EINVAL;
> +	struct mpi3mr_change_count chgcnt;
> +
> +	memset(&chgcnt, 0, sizeof(chgcnt));
> +	chgcnt.change_count =3D mrioc->change_count;
> +	if (job->request_payload.payload_len >=3D sizeof(chgcnt)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &chgcnt, sizeof(chgcnt));
> +		rval =3D 0;

Just do return 0=20

> +	}
> +	return rval;
> +}
> +
> +/**
> + * mpi3mr_bsg_adp_reset - Issue controller reset
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function identifies the user provided reset type and
> + * issues approporiate reset to the controller and wait for that
> + * to complete and reinitialize the controller and then returns
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_bsg_adp_reset(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	long rval =3D -EINVAL;
> +	u8 save_snapdump;
> +	struct mpi3mr_bsg_adp_reset adpreset;
> +
> +	if (job->request_payload.payload_len !=3D
> +			sizeof(adpreset)) {
> +		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
> +		    __func__);
> +		goto out;
> +	}
> +
> +	sg_copy_to_buffer(job->request_payload.sg_list,
> +			  job->request_payload.sg_cnt,
> +			  &adpreset, sizeof(adpreset));
> +
> +	switch (adpreset.reset_type) {
> +	case MPI3MR_BSG_ADPRESET_SOFT:
> +		save_snapdump =3D 0;
> +		break;
> +	case MPI3MR_BSG_ADPRESET_DIAG_FAULT:
> +		save_snapdump =3D 1;
> +		break;
> +	default:
> +		dprint_bsg_err(mrioc, "%s: unknown reset_type(%d)\n",
> +		    __func__, adpreset.reset_type);
> +		goto out;
> +	}
> +
> +	rval =3D mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_APP,
> +	    save_snapdump);
> +
> +	if (rval)
> +		dprint_bsg_err(mrioc,
> +		    "%s: reset handler returned error(%ld) for reset type %d\n",
> +		    __func__, rval, adpreset.reset_type);
> +out:
> +	return rval;
> +}
> +
> +/**
> + * mpi3mr_bsg_populate_adpinfo - Get adapter info command handler
> + * @mrioc: Adapter instance reference
> + * @job: BSG job reference
> + *
> + * This function provides adapter information for the given
> + * controller
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_bsg_populate_adpinfo(struct mpi3mr_ioc *mrioc,
> +	struct bsg_job *job)
> +{
> +	enum mpi3mr_iocstate ioc_state;
> +	struct mpi3mr_bsg_in_adpinfo adpinfo;
> +
> +	memset(&adpinfo, 0, sizeof(adpinfo));
> +	adpinfo.adp_type =3D MPI3MR_BSG_ADPTYPE_AVGFAMILY;
> +	adpinfo.pci_dev_id =3D mrioc->pdev->device;
> +	adpinfo.pci_dev_hw_rev =3D mrioc->pdev->revision;
> +	adpinfo.pci_subsys_dev_id =3D mrioc->pdev->subsystem_device;
> +	adpinfo.pci_subsys_ven_id =3D mrioc->pdev->subsystem_vendor;
> +	adpinfo.pci_bus =3D mrioc->pdev->bus->number;
> +	adpinfo.pci_dev =3D PCI_SLOT(mrioc->pdev->devfn);
> +	adpinfo.pci_func =3D PCI_FUNC(mrioc->pdev->devfn);
> +	adpinfo.pci_seg_id =3D pci_domain_nr(mrioc->pdev->bus);
> +	adpinfo.app_intfc_ver =3D MPI3MR_IOCTL_VERSION;
> +
> +	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> +	if (ioc_state =3D=3D MRIOC_STATE_UNRECOVERABLE)
> +		adpinfo.adp_state =3D MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> +	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
> +		adpinfo.adp_state =3D MPI3MR_BSG_ADPSTATE_IN_RESET;
> +	else if (ioc_state =3D=3D MRIOC_STATE_FAULT)
> +		adpinfo.adp_state =3D MPI3MR_BSG_ADPSTATE_FAULT;
> +	else
> +		adpinfo.adp_state =3D MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +
> +	memcpy((u8 *)&adpinfo.driver_info, (u8 *)&mrioc->driver_info,
> +	    sizeof(adpinfo.driver_info));
> +
> +	if (job->request_payload.payload_len >=3D sizeof(adpinfo)) {
> +		sg_copy_from_buffer(job->request_payload.sg_list,
> +				    job->request_payload.sg_cnt,
> +				    &adpinfo, sizeof(adpinfo));
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +/**
> + * mpi3mr_bsg_process_drv_cmds - Driver Command handler
> + * @job: BSG job reference
> + *
> + * This function is the top level handler for driver commands,
> + * this does basic validation of the buffer and identifies the
> + * opcode and switches to correct sub handler.
> + *
> + * Return: 0 on success and proper error codes on failure
> + */
> +static long mpi3mr_bsg_process_drv_cmds(struct bsg_job *job)
> +{
> +	long rval =3D -EINVAL;
> +	struct mpi3mr_ioc *mrioc =3D NULL;
> +	struct mpi3mr_bsg_packet *bsg_req =3D NULL;
> +	struct mpi3mr_bsg_drv_cmd *drvrcmd =3D NULL;
> +
> +	bsg_req =3D job->request;
> +	drvrcmd =3D &bsg_req->cmd.drvrcmd;
> +
> +	mrioc =3D mpi3mr_bsg_verify_adapter(drvrcmd->mrioc_id);
> +	if (!mrioc)
> +		return -ENODEV;
> +
> +	if (drvrcmd->opcode =3D=3D MPI3MR_DRVBSG_OPCODE_ADPINFO) {
> +		rval =3D mpi3mr_bsg_populate_adpinfo(mrioc, job);
> +		return rval;
> +	}
> +
> +	if (mutex_lock_interruptible(&mrioc->bsg_cmds.mutex))
> +		return -ERESTARTSYS;
> +
> +	switch (drvrcmd->opcode) {
> +	case MPI3MR_DRVBSG_OPCODE_ADPRESET:
> +		rval =3D mpi3mr_bsg_adp_reset(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_ALLTGTDEVINFO:
> +		rval =3D mpi3mr_get_all_tgt_info(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_GETCHGCNT:
> +		rval =3D mpi3mr_get_change_count(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_LOGDATAENABLE:
> +		rval =3D mpi3mr_enable_logdata(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_GETLOGDATA:
> +		rval =3D mpi3mr_get_logdata(mrioc, job);
> +		break;
> +	case MPI3MR_DRVBSG_OPCODE_UNKNOWN:
> +	default:
> +		pr_err("%s: unsupported driver command opcode %d\n",
> +		    MPI3MR_DRIVER_NAME, drvrcmd->opcode);
> +		break;
> +	}
> +	mutex_unlock(&mrioc->bsg_cmds.mutex);
> +	return rval;
> +}
>=20
> /**
>  * mpi3mr_bsg_request - bsg request entry point
> @@ -20,6 +395,23 @@
>  */
> int mpi3mr_bsg_request(struct bsg_job *job)
> {
> +	long rval =3D -EINVAL;
> +	unsigned int reply_payload_rcv_len =3D 0;
> +
> +	struct mpi3mr_bsg_packet *bsg_req =3D job->request;
> +
> +	switch (bsg_req->cmd_type) {
> +	case MPI3MR_DRV_CMD:
> +		rval =3D mpi3mr_bsg_process_drv_cmds(job);
> +		break;
> +	default:
> +		pr_err("%s: unsupported BSG command(0x%08x)\n",
> +		    MPI3MR_DRIVER_NAME, bsg_req->cmd_type);
> +		break;
> +	}
> +
> +	bsg_job_done(job, rval, reply_payload_rcv_len);
> +
> 	return 0;
> }
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_debug.h b/drivers/scsi/mpi3mr/mpi=
3mr_debug.h
> index c7982443f45a..65bfac72948c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_debug.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr_debug.h
> @@ -23,8 +23,8 @@
> #define MPI3_DEBUG_RESET		0x00000020
> #define MPI3_DEBUG_SCSI_ERROR		0x00000040
> #define MPI3_DEBUG_REPLY		0x00000080
> -#define MPI3_DEBUG_IOCTL_ERROR		0x00008000
> -#define MPI3_DEBUG_IOCTL_INFO		0x00010000
> +#define MPI3_DEBUG_BSG_ERROR		0x00008000
> +#define MPI3_DEBUG_BSG_INFO		0x00010000
> #define MPI3_DEBUG_SCSI_INFO		0x00020000
> #define MPI3_DEBUG			0x01000000
> #define MPI3_DEBUG_SG			0x02000000
> @@ -110,15 +110,15 @@
> 	} while (0)
>=20
>=20
> -#define dprint_ioctl_info(ioc, fmt, ...) \
> +#define dprint_bsg_info(ioc, fmt, ...) \
> 	do { \
> -		if (ioc->logging_level & MPI3_DEBUG_IOCTL_INFO) \
> +		if (ioc->logging_level & MPI3_DEBUG_BSG_INFO) \
> 			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> 	} while (0)
>=20
> -#define dprint_ioctl_err(ioc, fmt, ...) \
> +#define dprint_bsg_err(ioc, fmt, ...) \
> 	do { \
> -		if (ioc->logging_level & MPI3_DEBUG_IOCTL_ERROR) \
> +		if (ioc->logging_level & MPI3_DEBUG_BSG_ERROR) \
> 			pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__); \
> 	} while (0)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index e25c02466043..480730721f50 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -297,6 +297,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host=
_tag,
> 	switch (host_tag) {
> 	case MPI3MR_HOSTTAG_INITCMDS:
> 		return &mrioc->init_cmds;
> +	case MPI3MR_HOSTTAG_BSG_CMDS:
> +		return &mrioc->bsg_cmds;
> 	case MPI3MR_HOSTTAG_BLK_TMS:
> 		return &mrioc->host_tm_cmds;
> 	case MPI3MR_HOSTTAG_INVALID:
> @@ -865,10 +867,10 @@ static const struct {
> } mpi3mr_reset_reason_codes[] =3D {
> 	{ MPI3MR_RESET_FROM_BRINGUP, "timeout in bringup" },
> 	{ MPI3MR_RESET_FROM_FAULT_WATCH, "fault" },
> -	{ MPI3MR_RESET_FROM_IOCTL, "application invocation" },
> +	{ MPI3MR_RESET_FROM_APP, "application invocation" },
> 	{ MPI3MR_RESET_FROM_EH_HOS, "error handling" },
> 	{ MPI3MR_RESET_FROM_TM_TIMEOUT, "TM timeout" },
> -	{ MPI3MR_RESET_FROM_IOCTL_TIMEOUT, "IOCTL timeout" },
> +	{ MPI3MR_RESET_FROM_APP_TIMEOUT, "application command timeout" },
> 	{ MPI3MR_RESET_FROM_MUR_FAILURE, "MUR failure" },
> 	{ MPI3MR_RESET_FROM_CTLR_CLEANUP, "timeout in controller cleanup" },
> 	{ MPI3MR_RESET_FROM_CIACTIV_FAULT, "component image activation fault" },
> @@ -2813,6 +2815,10 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mp=
i3mr_ioc *mrioc)
> 	if (!mrioc->init_cmds.reply)
> 		goto out_failed;
>=20
> +	mrioc->bsg_cmds.reply =3D kzalloc(mrioc->reply_sz, GFP_KERNEL);
> +	if (!mrioc->bsg_cmds.reply)
> +		goto out_failed;
> +
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> 		mrioc->dev_rmhs_cmds[i].reply =3D kzalloc(mrioc->reply_sz,
> 		    GFP_KERNEL);
> @@ -3948,6 +3954,8 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc=
)
>=20
> 	if (mrioc->init_cmds.reply) {
> 		memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
> +		memset(mrioc->bsg_cmds.reply, 0,
> +		    sizeof(*mrioc->bsg_cmds.reply));
> 		memset(mrioc->host_tm_cmds.reply, 0,
> 		    sizeof(*mrioc->host_tm_cmds.reply));
> 		for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> @@ -4050,6 +4058,9 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
> 	kfree(mrioc->init_cmds.reply);
> 	mrioc->init_cmds.reply =3D NULL;
>=20
> +	kfree(mrioc->bsg_cmds.reply);
> +	mrioc->bsg_cmds.reply =3D NULL;
> +
> 	kfree(mrioc->host_tm_cmds.reply);
> 	mrioc->host_tm_cmds.reply =3D NULL;
>=20
> @@ -4235,6 +4246,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc=
 *mrioc)
>=20
> 	cmdptr =3D &mrioc->init_cmds;
> 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +	cmdptr =3D &mrioc->bsg_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> 	cmdptr =3D &mrioc->host_tm_cmds;
> 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
>=20
> @@ -4258,7 +4271,7 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc=
 *mrioc)
>  * This is an handler for recovering controller by issuing soft
>  * reset are diag fault reset.  This is a blocking function and
>  * when one reset is executed if any other resets they will be
> - * blocked. All IOCTLs/IO will be blocked during the reset. If
> + * blocked. All BSG requests will be blocked during the reset. If
>  * controller reset is successful then the controller will be
>  * reinitalized, otherwise the controller will be marked as not
>  * recoverable
> @@ -4305,6 +4318,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mr=
ioc,
> 	    mpi3mr_reset_rc_name(reset_reason));
>=20
> 	mrioc->reset_in_progress =3D 1;
> +	mrioc->stop_bsgs =3D 1;
> 	mrioc->prev_reset_result =3D -1;
>=20
> 	if ((!snapdump) && (reset_reason !=3D MPI3MR_RESET_FROM_FAULT_WATCH) &&
> @@ -4377,6 +4391,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mr=
ioc,
> 			    &mrioc->watchdog_work,
> 			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
> 		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
> +		mrioc->stop_bsgs =3D 0;
> 	} else {
> 		mpi3mr_issue_reset(mrioc,
> 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index faf14a5f9123..a03e39083a42 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3589,6 +3589,7 @@ static int mpi3mr_scan_finished(struct Scsi_Host *s=
host,
>=20
> 	mpi3mr_start_watchdog(mrioc);
> 	mrioc->is_driver_loading =3D 0;
> +	mrioc->stop_bsgs =3D 0;
> 	return 1;
> }
>=20
> @@ -4259,6 +4260,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	mutex_init(&mrioc->reset_mutex);
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> 	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
> +	mpi3mr_init_drv_cmd(&mrioc->bsg_cmds, MPI3MR_HOSTTAG_BSG_CMDS);
>=20
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> @@ -4271,6 +4273,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	mrioc->logging_level =3D logging_level;
> 	mrioc->shost =3D shost;
> 	mrioc->pdev =3D pdev;
> +	mrioc->stop_bsgs =3D 1;
>=20
> 	/* init shost parameters */
> 	shost->max_cmd_len =3D MPI3MR_MAX_CDB_LENGTH;
> diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi=
_bsg_mpi3mr.h
> new file mode 100644
> index 000000000000..2319fc48ed78
> --- /dev/null
> +++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
> @@ -0,0 +1,433 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Driver for Broadcom MPI3 Storage Controllers
> + *
> + * Copyright (C) 2017-2022 Broadcom Inc.
> + *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
> + *
> + */
> +
> +#ifndef SCSI_BSG_MPI3MR_H_INCLUDED
> +#define SCSI_BSG_MPI3MR_H_INCLUDED
> +
> +/* Definitions for BSG commands */
> +#define MPI3MR_IOCTL_VERSION			0x06
> +
> +#define MPI3MR_APP_DEFAULT_TIMEOUT		(60) /*seconds*/
> +
> +#define MPI3MR_BSG_ADPTYPE_UNKNOWN		0
> +#define MPI3MR_BSG_ADPTYPE_AVGFAMILY		1
> +
> +#define MPI3MR_BSG_ADPSTATE_UNKNOWN		0
> +#define MPI3MR_BSG_ADPSTATE_OPERATIONAL		1
> +#define MPI3MR_BSG_ADPSTATE_FAULT		2
> +#define MPI3MR_BSG_ADPSTATE_IN_RESET		3
> +#define MPI3MR_BSG_ADPSTATE_UNRECOVERABLE	4
> +
> +#define MPI3MR_BSG_ADPRESET_UNKNOWN		0
> +#define MPI3MR_BSG_ADPRESET_SOFT		1
> +#define MPI3MR_BSG_ADPRESET_DIAG_FAULT		2
> +
> +#define MPI3MR_BSG_LOGDATA_MAX_ENTRIES		400
> +#define MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ	4
> +
> +#define MPI3MR_DRVBSG_OPCODE_UNKNOWN		0
> +#define MPI3MR_DRVBSG_OPCODE_ADPINFO		1
> +#define MPI3MR_DRVBSG_OPCODE_ADPRESET		2
> +#define MPI3MR_DRVBSG_OPCODE_ALLTGTDEVINFO	4
> +#define MPI3MR_DRVBSG_OPCODE_GETCHGCNT		5
> +#define MPI3MR_DRVBSG_OPCODE_LOGDATAENABLE	6
> +#define MPI3MR_DRVBSG_OPCODE_PELENABLE		7
> +#define MPI3MR_DRVBSG_OPCODE_GETLOGDATA		8
> +#define MPI3MR_DRVBSG_OPCODE_QUERY_HDB		9
> +#define MPI3MR_DRVBSG_OPCODE_REPOST_HDB		10
> +#define MPI3MR_DRVBSG_OPCODE_UPLOAD_HDB		11
> +#define MPI3MR_DRVBSG_OPCODE_REFRESH_HDB_TRIGGERS	12
> +
> +
> +#define MPI3MR_BSG_BUFTYPE_UNKNOWN		0
> +#define MPI3MR_BSG_BUFTYPE_RAIDMGMT_CMD		1
> +#define MPI3MR_BSG_BUFTYPE_RAIDMGMT_RESP	2
> +#define MPI3MR_BSG_BUFTYPE_DATA_IN		3
> +#define MPI3MR_BSG_BUFTYPE_DATA_OUT		4
> +#define MPI3MR_BSG_BUFTYPE_MPI_REPLY		5
> +#define MPI3MR_BSG_BUFTYPE_ERR_RESPONSE		6
> +#define MPI3MR_BSG_BUFTYPE_MPI_REQUEST		0xFE
> +
> +#define MPI3MR_BSG_MPI_REPLY_BUFTYPE_UNKNOWN	0
> +#define MPI3MR_BSG_MPI_REPLY_BUFTYPE_STATUS	1
> +#define MPI3MR_BSG_MPI_REPLY_BUFTYPE_ADDRESS	2
> +
> +#define MPI3MR_HDB_BUFTYPE_UNKNOWN		0
> +#define MPI3MR_HDB_BUFTYPE_TRACE		1
> +#define MPI3MR_HDB_BUFTYPE_FIRMWARE		2
> +#define MPI3MR_HDB_BUFTYPE_RESERVED		3
> +
> +#define MPI3MR_HDB_BUFSTATUS_UNKNOWN		0
> +#define MPI3MR_HDB_BUFSTATUS_NOT_ALLOCATED	1
> +#define MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED	2
> +#define MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED	3
> +#define MPI3MR_HDB_BUFSTATUS_RELEASED		4
> +
> +#define MPI3MR_HDB_TRIGGER_TYPE_UNKNOWN		0
> +#define MPI3MR_HDB_TRIGGER_TYPE_DIAGFAULT	1
> +#define MPI3MR_HDB_TRIGGER_TYPE_ELEMENT		2
> +#define MPI3MR_HDB_TRIGGER_TYPE_MASTER		3
> +
> +
> +/* Supported BSG commands */
> +enum command {
> +	MPI3MR_DRV_CMD =3D 1,
> +	MPI3MR_MPT_CMD =3D 2,
> +};
> +
> +/**
> + * struct mpi3mr_bsg_in_adpinfo - Adapter information request
> + * data returned by the driver.
> + *
> + * @adp_type: Adapter type
> + * @rsvd1: Reserved
> + * @pci_dev_id: PCI device ID of the adapter
> + * @pci_dev_hw_rev: PCI revision of the adapter
> + * @pci_subsys_dev_id: PCI subsystem device ID of the adapter
> + * @pci_subsys_ven_id: PCI subsystem vendor ID of the adapter
> + * @pci_dev: PCI device
> + * @pci_func: PCI function
> + * @pci_bus: PCI bus
> + * @rsvd2: Reserved
> + * @pci_seg_id: PCI segment ID
> + * @app_intfc_ver: version of the application interface definition
> + * @rsvd3: Reserved
> + * @rsvd4: Reserved
> + * @rsvd5: Reserved
> + * @driver_info: Driver Information (Version/Name)
> + */
> +struct mpi3mr_bsg_in_adpinfo {
> +	uint32_t adp_type;
> +	uint32_t rsvd1;
> +	uint32_t pci_dev_id;
> +	uint32_t pci_dev_hw_rev;
> +	uint32_t pci_subsys_dev_id;
> +	uint32_t pci_subsys_ven_id;
> +	uint32_t pci_dev:5;
> +	uint32_t pci_func:3;
> +	uint32_t pci_bus:8;
> +	uint16_t rsvd2;
> +	uint32_t pci_seg_id;
> +	uint32_t app_intfc_ver;
> +	uint8_t adp_state;
> +	uint8_t rsvd3;
> +	uint16_t rsvd4;
> +	uint32_t rsvd5[2];
> +	struct mpi3_driver_info_layout driver_info;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_adp_reset - Adapter reset request
> + * payload data to the driver.
> + *
> + * @reset_type: Reset type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_adp_reset {
> +	uint8_t reset_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +
> +/**
> + * struct mpi3mr_change_count - Topology change count
> + * returned by the driver.
> + *
> + * @change_count: Topology change count
> + * @rsvd: Reserved
> + */
> +struct mpi3mr_change_count {
> +	uint16_t change_count;
> +	uint16_t rsvd;
> +};
> +
> +/**
> + * struct mpi3mr_device_map_info - Target device mapping
> + * information
> + *
> + * @handle: Firmware device handle
> + * @perst_id: Persistent ID assigned by the firmware
> + * @target_id: Target ID assigned by the driver
> + * @bus_id: Bus ID assigned by the driver
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_device_map_info {
> +	uint16_t handle;
> +	uint16_t perst_id;
> +	uint32_t target_id;
> +	uint8_t bus_id;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +
> +/**
> + * struct mpi3mr_all_tgt_info - Target device mapping
> + * information returned by the driver
> + *
> + * @num_devices: The number of devices in driver's inventory
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @dmi: Variable length array of mapping information of targets
> + */
> +struct mpi3mr_all_tgt_info {
> +	uint16_t num_devices;
> +	uint16_t rsvd1;
> +	uint32_t rsvd2;
> +	struct mpi3mr_device_map_info dmi[1];
> +};
> +
> +/**
> + * struct mpi3mr_logdata_enable - Number of log data
> + * entries saved by the driver returned as payload data for
> + * enable logdata BSG request by the driver.
> + *
> + * @max_entries: Number of log data entries cached by the driver
> + * @rsvd: Reserved
> + */
> +struct mpi3mr_logdata_enable {
> +	uint16_t max_entries;
> +	uint16_t rsvd;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_pel_enable - PEL enable request payload
> + * data to the driver.
> + *
> + * @pel_locale: PEL locale to the firmware
> + * @pel_class: PEL class to the firmware
> + * @rsvd: Reserved
> + */
> +struct mpi3mr_bsg_out_pel_enable {
> +	uint16_t pel_locale;
> +	uint8_t pel_class;
> +	uint8_t rsvd;
> +};
> +
> +/**
> + * struct mpi3mr_logdata_entry - Log data entry cached by the
> + * driver.
> + *
> + * @valid_entry: Is the entry valid
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @data: Variable length Log entry data
> + */
> +struct mpi3mr_logdata_entry {
> +	uint8_t valid_entry;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint8_t data[1]; /* Variable length Array */
> +};
> +
> +/**
> + * struct mpi3mr_bsg_in_log_data - Log data entries saved by
> + * the driver returned as payload data for Get logdata request
> + * by the driver.
> + *
> + * @entry: Variable length Log data entry array
> + */
> +struct mpi3mr_bsg_in_log_data {
> +	struct mpi3mr_logdata_entry entry[1];
> +};
> +
> +/**
> + * struct mpi3mr_hdb_entry - host diag buffer entry.
> + *
> + * @buf_type: Buffer type
> + * @status: Buffer status
> + * @trigger_type: Trigger type
> + * @rsvd1: Reserved
> + * @size: Buffer size
> + * @rsvd2: Reserved
> + * @trigger_data: Trigger specific data
> + * @rsvd3: Reserved
> + * @rsvd4: Reserved
> + */
> +struct mpi3mr_hdb_entry {
> +	uint8_t buf_type;
> +	uint8_t status;
> +	uint8_t trigger_type;
> +	uint8_t rsvd1;
> +	uint16_t size;
> +	uint16_t rsvd2;
> +	uint64_t trigger_data;
> +	uint32_t rsvd3;
> +	uint32_t rsvd4;
> +};
> +
> +
> +/**
> + * struct mpi3mr_bsg_in_hdb_status - This structure contains
> + * return data for the BSG request to retrieve the number of host
> + * diagnostic buffers supported by the driver and their current
> + * status and additional status specific data if any in forms of
> + * multiple hdb entries.
> + *
> + * @num_hdb_types: Number of host diag buffer types supported
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @rsvd3: Reserved
> + * @entry: Variable length Diag buffer status entry array
> + */
> +struct mpi3mr_bsg_in_hdb_status {
> +	uint8_t num_hdb_types;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t rsvd3;
> +	struct mpi3mr_hdb_entry entry[1];
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_repost_hdb - Repost host diagnostic
> + * buffer request payload data to the driver.
> + *
> + * @buf_type: Buffer type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_out_repost_hdb {
> +	uint8_t buf_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_upload_hdb - Upload host diagnostic
> + * buffer request payload data to the driver.
> + *
> + * @buf_type: Buffer type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @start_offset: Start offset of the buffer from where to copy
> + * @length: Length of the buffer to copy
> + */
> +struct mpi3mr_bsg_out_upload_hdb {
> +	uint8_t buf_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t start_offset;
> +	uint32_t length;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_out_refresh_hdb_triggers - Refresh host
> + * diagnostic buffer triggers request payload data to the driver.
> + *
> + * @page_type: Page type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_out_refresh_hdb_triggers {
> +	uint8_t page_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +};
> +/**
> + * struct mpi3mr_bsg_drv_cmd -  Generic bsg data
> + * structure for all driver specific requests.
> + *
> + * @mrioc_id: Controller ID
> + * @opcode: Driver specific opcode
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + */
> +struct mpi3mr_bsg_drv_cmd {
> +	uint8_t mrioc_id;
> +	uint8_t opcode;
> +	uint16_t rsvd1;
> +	uint32_t rsvd2[4];
> +};
> +/**
> + * struct mpi3mr_bsg_in_reply_buf - MPI reply buffer returned
> + * for MPI Passthrough request .
> + *
> + * @mpi_reply_type: Type of MPI reply
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @reply_buf: Variable Length buffer based on mpirep type
> + */
> +struct mpi3mr_bsg_in_reply_buf {
> +	uint8_t mpi_reply_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint8_t reply_buf[1];
> +};
> +
> +/**
> + * struct mpi3mr_buf_entry - User buffer descriptor for MPI
> + * Passthrough requests.
> + *
> + * @buf_type: Buffer type
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @buf_len: Buffer length
> + */
> +struct mpi3mr_buf_entry {
> +	uint8_t buf_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t buf_len;
> +};
> +/**
> + * struct mpi3mr_bsg_buf_entry_list - list of user buffer
> + * descriptor for MPI Passthrough requests.
> + *
> + * @num_of_entries: Number of buffer descriptors
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @rsvd3: Reserved
> + * @buf_entry: Variable length array of buffer descriptors
> + */
> +struct mpi3mr_buf_entry_list {
> +	uint8_t num_of_entries;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t rsvd3;
> +	struct mpi3mr_buf_entry buf_entry[1];
> +};
> +/**
> + * struct mpi3mr_bsg_mptcmd -  Generic bsg data
> + * structure for all MPI Passthrough requests .
> + *
> + * @mrioc_id: Controller ID
> + * @rsvd1: Reserved
> + * @timeout: MPI request timeout
> + * @buf_entry_list: Buffer descriptor list
> + */
> +struct mpi3mr_bsg_mptcmd {
> +	uint8_t mrioc_id;
> +	uint8_t rsvd1;
> +	uint16_t timeout;
> +	uint32_t rsvd2;
> +	struct mpi3mr_buf_entry_list buf_entry_list;
> +};
> +
> +/**
> + * struct mpi3mr_bsg_packet -  Generic bsg data
> + * structure for all supported requests .
> + *
> + * @cmd_type: represents drvrcmd or mptcmd
> + * @rsvd1: Reserved
> + * @rsvd2: Reserved
> + * @drvrcmd: driver request structure
> + * @mptcmd: mpt request structure
> + */
> +struct mpi3mr_bsg_packet {
> +	uint8_t cmd_type;
> +	uint8_t rsvd1;
> +	uint16_t rsvd2;
> +	uint32_t rsvd3;
> +	union {
> +		struct mpi3mr_bsg_drv_cmd drvrcmd;
> +		struct mpi3mr_bsg_mptcmd mptcmd;
> +	} cmd;
> +};
> +#endif
> --=20
> 2.27.0
>=20

Once you fix small nit, you can add=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

