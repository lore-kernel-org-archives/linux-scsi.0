Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB0AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 18:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbiDSSMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiDSSL5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 14:11:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BEA3CA60
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 11:09:12 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JGxGe1019231;
        Tue, 19 Apr 2022 18:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PZOJS4jBBvS8fJYg1jRv9E2tyVOIOKEduIYSoz5Wg1Y=;
 b=CWo7Qbx7K5iOsHFgQUsTJZmctXlU5tUFpzJed2lR6wvBeFB6jugmPKr34n1ewrz+dB2H
 8x6GbJ1tHzHrGXQCHY2VcBE1ZCMiegDmtv8tDS5L6aaL0PlsiN0ar2lhtktE9zolMCf0
 oEc11C3bAAIkjJqvrGYyaEHn+Ew/YkqJflUuvq6bXugYCYgfJbnaDmTqM9AkIT2ve+V/
 Vi4o2Tk2vmjt5vDVUguO16fSmSy+QWHhgEPNbWi55mJV2LUTLwACbrKumvv2teeszpVg
 txsY9xy2jOypJJO32Jv3CJ3J3Fszlx4Gt0jkHqXX4kJF4rYvucT0q2vKzyT5L2eCruBa IA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffmk2puu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:08:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JI6UnY006149;
        Tue, 19 Apr 2022 18:08:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88fayq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 18:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaTfZkzo9oJXla8E8z5OemXl1dcvoJyYh5/4FCdVdxGNevokQdC6G0Y7l48yY/DcChsojL4rm+JJUb97uU3GWFpxU5Za6u/gB2vwGU2mbn8qEbHQ0lxwbDZopZBOwR0OcLooCkGLX4Bd1ssco+V/75bb+UlYMp/CAwSZeQG2fULIWwqa5wWCsgG5+55uU069zNlXA209Q9BXl9xpc65RNO+Hlc1A49Neu1OFzkLn4hhoaG4fJySVFogr5mohFC7mroBCdXqbkK6nkq0ojTOpj8qAXhDO3+CN2l4Z96qIvQZgSHkzhGNpQNgY99ZePpRfL54yTyNuYijuGNw4LVSuHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZOJS4jBBvS8fJYg1jRv9E2tyVOIOKEduIYSoz5Wg1Y=;
 b=MqR70G6o6923vFjjcsby8WZ4yapxyfAe8wlG/gqeXP4of5Xy7iL33EJ4z1/BzocxYxb5AGeb7/GxS2tJz0VJn7W97RtUy29dGcJVLnIMc9feosB7b6GjqjqFBDcDRAf8F23AhGu29W7IM6ooLnn/QIZWnrfruXgzp6XIV2WRfXYRufUdZ8oojxyGR/ecPfBI2MNtsIaXwyjCqIOBWuJh8rAP4jQ2mPDKN6SQ18j+xgqQX1FrpBs9a4Dh6MO1eoT6FXGycU/N2YZbBNyS2rvzVBFhdV3gOszKWZIrwVCrbw4MbrxosKHSa7pv0222lSkDjx58EPIdkvA8h4E2x6MNNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZOJS4jBBvS8fJYg1jRv9E2tyVOIOKEduIYSoz5Wg1Y=;
 b=xqmLWaKbvzIXMyqyirgIHhT9GpKquw5nenJw5lpWJzxE7yDdnIAtSJY75El9qkuxOt7psoMSSzaNARy6r1jwIYMxOgZhKVC6cFGh7nzwKf7pc2w6RD4cLqpmaGagzPpwjLevuJBXTz83KJjL8SQsl/iYetIy4AkSXHHZgM6vvCE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH2PR10MB3751.namprd10.prod.outlook.com (2603:10b6:610:1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 18:08:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 18:08:48 +0000
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
Subject: Re: [PATCH v4 3/8] mpi3mr: move data structures/definitions from MPI
 headers to uapi header
Thread-Topic: [PATCH v4 3/8] mpi3mr: move data structures/definitions from MPI
 headers to uapi header
Thread-Index: AQHYT0cDhqDBmrnpf0OJhYhae5Fpe6z3knoA
Date:   Tue, 19 Apr 2022 18:08:48 +0000
Message-ID: <04A7CBB4-B03A-43DF-A5B8-8C28F163C7D9@oracle.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
 <20220413145652.112271-4-sumit.saxena@broadcom.com>
In-Reply-To: <20220413145652.112271-4-sumit.saxena@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61fbe9a6-9ce6-4f78-b0cf-08da222fa715
x-ms-traffictypediagnostic: CH2PR10MB3751:EE_
x-microsoft-antispam-prvs: <CH2PR10MB37514E08E58C1A6086D55A73E6F29@CH2PR10MB3751.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jwFsRs0WpjRAQuTd90wyhfYZ/ObP4aZebVaFt70e1cceY6jaT4G4b3WlqSdCbPrE8padYOPm0MeWejnU+JM/sjqbOuh3sbd7awq0hxn+L1+pDLwCGaW1kt3Kv6rk/SkKVPJLahpiZ36LdbwtGqc743jRvYkYMpnFGxMwB1YscTfgjH4qAR0pQcvBYO07pN7LlgV+SX5iZKHl1gTvUf6mlr+ODKAuueRPVUCfEGZG/+nJKR5rVx+V/2rXQAbuha+vwLiepgwVEfhBEIK6heiH41aQqBBjyBngyUC51pux8oL28JNrFv503gf0S6uqFnmmvfXsL0FmdtibPXo7Q3J9gjVR/DxDSCRnVm5hHJjs6JPkEzYqKYYgUciu78fzOX7BI8/i42Tub1L7UpmuszJr1KbXDBpgWs6AliXZyKTA4rC/qbT5ob4rT8tb5ywpJacBjxBc2zRd8Ebqd6XZc90p8uv3DuzcFZbRu0sjIVA1jnIhTYQGfXc/LinEk65PRwoOItYB6ZDy5GL2XQepzbfKdR9SmXjWhF/ddhbZnEBfCANLGoig9q5KSZ67s3X/f0dKOBr5vCjcohbGe0bSMloeiSgcgMT4AfRfgyEsfE9wWb1geiNTXgBOVgUWRz/ObDIzOW58quDp6LXmLVDDM35g0O/RTdlo7BoXtW16HpXjnAxv4KI64o2iDMUhq8hXjlbs4kzkz89Xb8bnn6nkAPGE2j01LruEWPktrM2HYSPoTMvcTc+dWVR2uE2Z5wg8uDN7u9ybPALaz0M2CfNmJnMZ+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(33656002)(7416002)(508600001)(4326008)(44832011)(8676002)(64756008)(66476007)(91956017)(66556008)(54906003)(6916009)(5660300002)(2616005)(6506007)(2906002)(122000001)(53546011)(6512007)(8936002)(36756003)(71200400001)(76116006)(66946007)(38100700002)(86362001)(83380400001)(6486002)(38070700005)(316002)(186003)(30864003)(26005)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8dpVfkhoK/+dG9kGdJSoWkKtp5MN9XcyVD3E4cajyRYUvhBFhbGgdI4qevcU?=
 =?us-ascii?Q?hiUxuKEzdUcB2dvhLHDF2xIOO6vwUnTtF1gQvnAZc4YbwlDhl6Y64f9Gje6a?=
 =?us-ascii?Q?vJjGHmWFgyMrM+Arr4zjpVtJuWNrJdZluhR/n10h6ImCLdhYUcJ+XC6VuR+E?=
 =?us-ascii?Q?/fdo9dfRd1GWz184tH/irXRJsN7UMH38/Dncb0DC59FDFntS2sETibQpgOZY?=
 =?us-ascii?Q?INtsTWbF6Ksnwz1pUUqM2IW4ASGSRJK9xKx/sD8QZfPSDnhDWCD8ASyGC42a?=
 =?us-ascii?Q?ugTo4YnVUvPzs7kYUWXZXQcOcfPuddTLZ8+ceSFLGRQSQVEe9BIkbp2TdRXN?=
 =?us-ascii?Q?omAujFae01D89CMF35O6Oa2IBos3EarJUDDX+d912IXOzmCkhK+oEGUX1Ewr?=
 =?us-ascii?Q?oY19Eg8ZR0b/VM1JnTV/pA32W5P8sQlyvDkActIiV2ogM5bRmVRvCMTIDe21?=
 =?us-ascii?Q?JfP7tvT6/wUVnr41gj+PRkrWt55gAb+l5/JOOSNK4gJ8kcyENFDzhLVEyprz?=
 =?us-ascii?Q?mxT2s0tiUeWFdbzwmq4zSNLqzK+T12CoPoJHJ2x67wnPk0m1eIoMgGbWVRkb?=
 =?us-ascii?Q?ihJAG5jJ8T6aZ3AFsRmXLblKSPFRmaM+StONbFlKQdvJoacQ+BTe5XleYjdM?=
 =?us-ascii?Q?1VH15+nYLiRaSKJ5ETD0b9bTDSDiQCJHjANEuOhvKzxC+pfJvIyT8kBw2IdI?=
 =?us-ascii?Q?7TsPtZae0OapGaermvt65bPQKmITfNbMARCbYs8ghVB4JTNqiwEzwRoNS6uX?=
 =?us-ascii?Q?V4oFv5cNd6gxD3jczSChPBANjYpP9TeKCM2VZIVU4R3PYFarvc3vvEKkGwFe?=
 =?us-ascii?Q?JyZd7anZX7Xg+RM6uhc6VJHvESCbUXk6XLgMWThPFgN2bJkGR9+BetMiMB9s?=
 =?us-ascii?Q?m/SMb+5ZZnZEjKjalYxrrKI+AvxRZNycIFkXJmxhpd6vZzzB5DDx4C8oC5bP?=
 =?us-ascii?Q?pRteAJTGn3czBzOqeAKcVlto+UfAn751YPpJdapH7iF01z/8Qg7Z224Yar9H?=
 =?us-ascii?Q?IAtPVSi7iVjbX+4vYhfyWWocb+4GUdBBvbKzX0/vfi/ss/TjonWwgmw/WXqt?=
 =?us-ascii?Q?MPuwYIjMfm1jkZeOZM3Is9d2aUbfvChFOpb3j8SbCfEGyF9Guo2SYXU+x5JN?=
 =?us-ascii?Q?Z9eBQiGp5aBFIO6mNbcV6jmsBQZ3IY4hGBio1Fud1aosMX40c33X3QgrNoS9?=
 =?us-ascii?Q?j89P2Zrc+k6wh8Th/4QS6zi4VrP2gmDfz8+ErU7VX7nstPbTrTksm1QpOJrg?=
 =?us-ascii?Q?h8Nk4hkN3+dDhgyQgWDiaAxofOTEXqGgRdlch+tr3lZlsUDL2DCD5cVcxEv2?=
 =?us-ascii?Q?lqRtoJ0SgDSFDlSshzVaVYNBO47vCZ4FY0maJ12JB7WvkZKAYJF2nDOtYlSV?=
 =?us-ascii?Q?4iytJ1irKE8djITcFJAxIXRgxFXMI+aadUt3LrVrLDZDYMrMBYCmlx88lXb7?=
 =?us-ascii?Q?wpvV6Atm60wkXg/a2BC925/tCNUeX5DpOQGZaGxceOi9nZ8EcQk8HaQzKZHx?=
 =?us-ascii?Q?Y0UgzTp9kAqaQWt2nJBVj2L5CQZcEogzsgCTUncMu9DCxMLSqHFX37ZUQss7?=
 =?us-ascii?Q?Vbz941U4v99zjr3V6dM7AGb/ELqYWW2uy2VJG3MFM+ZJpDyRzjaXsTDCVkLD?=
 =?us-ascii?Q?pNqvTk6fUYFZ+s/JQFMFqpo03Z0K/L97vgp21JEoA9952j0pE+RUZsiv+ky/?=
 =?us-ascii?Q?BpEKm+3AtHUhQgDAGizm1LBl7X7+Nztgz+dpTplyG0LMyr6IkXi3uC6Zv3QO?=
 =?us-ascii?Q?H+LtF6sFtPwX4M/swREqJSm1P1v+IvZbkx+Ktis0Uo4M3c0tkyQY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <76E79C2F549D0946A2271AC72D7ADF51@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fbe9a6-9ce6-4f78-b0cf-08da222fa715
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 18:08:48.7432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X6ebbrsYRgu8NVsDx3YX/bcojTj+gJZDsrRIuJudwu9sAwDe1j+h1Wz77PG6V5393rPWon4RvAH983DeK9F2cYiDcne7kjz/bBbhOaodSUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3751
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_06:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190104
X-Proofpoint-GUID: 7kw41aalQM7HDL712viCl1hXC_R4f286
X-Proofpoint-ORIG-GUID: 7kw41aalQM7HDL712viCl1hXC_R4f286
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 13, 2022, at 7:56 AM, Sumit Saxena <sumit.saxena@broadcom.com> wro=
te:
>=20
> This patch moves the data structures/definitions which are used by
> user space applications from MPI headers to uapi/scsi/scsi_bsg_mpi3mr.h
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi/mpi30_init.h |  53 ----------
> drivers/scsi/mpi3mr/mpi/mpi30_ioc.h  |  28 ------
> drivers/scsi/mpi3mr/mpi/mpi30_pci.h  |  31 +-----
> drivers/scsi/mpi3mr/mpi3mr.h         |   1 +
> include/uapi/scsi/scsi_bsg_mpi3mr.h  | 139 +++++++++++++++++++++++++++
> 5 files changed, 141 insertions(+), 111 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_init.h b/drivers/scsi/mpi3mr/m=
pi/mpi30_init.h
> index e2e8b22e9122..aac11c58cca9 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_init.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_init.h
> @@ -115,57 +115,4 @@ struct mpi3_scsi_io_reply {
> #define MPI3_SCSI_RSP_ARI0_MASK                 (0xff000000)
> #define MPI3_SCSI_RSP_ARI0_SHIFT                (24)
> #define MPI3_SCSI_TASKTAG_UNKNOWN               (0xffff)
> -struct mpi3_scsi_task_mgmt_request {
> -	__le16                     host_tag;
> -	u8                         ioc_use_only02;
> -	u8                         function;
> -	__le16                     ioc_use_only04;
> -	u8                         ioc_use_only06;
> -	u8                         msg_flags;
> -	__le16                     change_count;
> -	__le16                     dev_handle;
> -	__le16                     task_host_tag;
> -	u8                         task_type;
> -	u8                         reserved0f;
> -	__le16                     task_request_queue_id;
> -	__le16                     reserved12;
> -	__le32                     reserved14;
> -	u8                         lun[8];
> -};
> -
> -#define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK               (0x01)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK_SET           (0x02)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET             (0x03)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET       (0x05)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET           (0x06)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK               (0x07)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_ACA                (0x08)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK_SET           (0x09)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0a)
> -#define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0b)
> -struct mpi3_scsi_task_mgmt_reply {
> -	__le16                     host_tag;
> -	u8                         ioc_use_only02;
> -	u8                         function;
> -	__le16                     ioc_use_only04;
> -	u8                         ioc_use_only06;
> -	u8                         msg_flags;
> -	__le16                     ioc_use_only08;
> -	__le16                     ioc_status;
> -	__le32                     ioc_log_info;
> -	__le32                     termination_count;
> -	__le32                     response_data;
> -	__le32                     reserved18;
> -};
> -
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE                (0x00)
> -#define MPI3_SCSITASKMGMT_RSPCODE_INVALID_FRAME              (0x02)
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_FUNCTION_NOT_SUPPORTED  (0x04)
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_FAILED                  (0x05)
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED               (0x08)
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_INVALID_LUN             (0x09)
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_OVERLAPPED_TAG          (0x0a)
> -#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC           (0x80)
> -#define MPI3_SCSITASKMGMT_RSPCODE_TM_NVME_DENIED             (0x81)
> #endif
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mp=
i/mpi30_ioc.h
> index 633037dc7012..7b306580d30f 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> @@ -38,17 +38,6 @@ struct mpi3_ioc_init_request {
> #define MPI3_WHOINIT_ROM_BIOS                            (0x02)
> #define MPI3_WHOINIT_HOST_DRIVER                         (0x03)
> #define MPI3_WHOINIT_MANUFACTURER                        (0x04)
> -struct mpi3_driver_info_layout {
> -	__le32             information_length;
> -	u8                 driver_signature[12];
> -	u8                 os_name[16];
> -	u8                 os_version[12];
> -	u8                 driver_name[20];
> -	u8                 driver_version[32];
> -	u8                 driver_release_date[20];
> -	__le32             driver_capabilities;
> -};
> -
> struct mpi3_ioc_facts_request {
> 	__le16                 host_tag;
> 	u8                     ioc_use_only02;
> @@ -647,23 +636,6 @@ struct mpi3_event_data_diag_buffer_status_change {
> #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED             (0x0=
1)
> #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED               (0x0=
2)
> #define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED              (0x0=
3)
> -#define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
> -#define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
> -#define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
> -#define MPI3_PEL_LOCALE_FLAGS_CONFIGURATION             (0x0040)
> -#define MPI3_PEL_LOCALE_FLAGS_CONTROLER                 (0x0020)
> -#define MPI3_PEL_LOCALE_FLAGS_SAS                       (0x0010)
> -#define MPI3_PEL_LOCALE_FLAGS_EPACK                     (0x0008)
> -#define MPI3_PEL_LOCALE_FLAGS_ENCLOSURE                 (0x0004)
> -#define MPI3_PEL_LOCALE_FLAGS_PD                        (0x0002)
> -#define MPI3_PEL_LOCALE_FLAGS_VD                        (0x0001)
> -#define MPI3_PEL_CLASS_DEBUG                            (0x00)
> -#define MPI3_PEL_CLASS_PROGRESS                         (0x01)
> -#define MPI3_PEL_CLASS_INFORMATIONAL                    (0x02)
> -#define MPI3_PEL_CLASS_WARNING                          (0x03)
> -#define MPI3_PEL_CLASS_CRITICAL                         (0x04)
> -#define MPI3_PEL_CLASS_FATAL                            (0x05)
> -#define MPI3_PEL_CLASS_FAULT                            (0x06)
> #define MPI3_PEL_CLEARTYPE_CLEAR                        (0x00)
> #define MPI3_PEL_WAITTIME_INFINITE_WAIT                 (0x00)
> #define MPI3_PEL_ACTION_GET_SEQNUM                      (0x01)
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h b/drivers/scsi/mpi3mr/mp=
i/mpi30_pci.h
> index 77270f577f90..901dbd788940 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_pci.h
> @@ -5,24 +5,6 @@
>  */
> #ifndef MPI30_PCI_H
> #define MPI30_PCI_H     1
> -#ifndef MPI3_NVME_ENCAP_CMD_MAX
> -#define MPI3_NVME_ENCAP_CMD_MAX               (1)
> -#endif
> -struct mpi3_nvme_encapsulated_request {
> -	__le16                     host_tag;
> -	u8                         ioc_use_only02;
> -	u8                         function;
> -	__le16                     ioc_use_only04;
> -	u8                         ioc_use_only06;
> -	u8                         msg_flags;
> -	__le16                     change_count;
> -	__le16                     dev_handle;
> -	__le16                     encapsulated_command_length;
> -	__le16                     flags;
> -	__le32                     data_length;
> -	__le32                     reserved14[3];
> -	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
> -};
>=20
> #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_MASK      (0x0002)
> #define MPI3_NVME_FLAGS_FORCE_ADMIN_ERR_REPLY_FAIL_ONLY (0x0000)
> @@ -30,16 +12,5 @@ struct mpi3_nvme_encapsulated_request {
> #define MPI3_NVME_FLAGS_SUBMISSIONQ_MASK                (0x0001)
> #define MPI3_NVME_FLAGS_SUBMISSIONQ_IO                  (0x0000)
> #define MPI3_NVME_FLAGS_SUBMISSIONQ_ADMIN               (0x0001)
> -struct mpi3_nvme_encapsulated_error_reply {
> -	__le16                     host_tag;
> -	u8                         ioc_use_only02;
> -	u8                         function;
> -	__le16                     ioc_use_only04;
> -	u8                         ioc_use_only06;
> -	u8                         msg_flags;
> -	__le16                     ioc_use_only08;
> -	__le16                     ioc_status;
> -	__le32                     ioc_log_info;
> -	__le32                     nvme_completion_entry[4];
> -};
> +
> #endif
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 877b0925dbc5..fb05aab48aa7 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -38,6 +38,7 @@
> #include <scsi/scsi_device.h>
> #include <scsi/scsi_host.h>
> #include <scsi/scsi_tcq.h>
> +#include <uapi/scsi/scsi_bsg_mpi3mr.h>
>=20
> #include "mpi/mpi30_transport.h"
> #include "mpi/mpi30_cnfg.h"
> diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi=
_bsg_mpi3mr.h
> index 2319fc48ed78..870e6d87dd03 100644
> --- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
> +++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
> @@ -81,6 +81,28 @@ enum command {
> 	MPI3MR_MPT_CMD =3D 2,
> };
>=20
> +/**
> + * struct mpi3_driver_info_layout - Information about driver
> + *
> + * @information_length: Length of this structure in bytes
> + * @driver_signature: Driver Vendor name
> + * @os_name: Operating System Name
> + * @driver_name: Driver name
> + * @driver_version: Driver version
> + * @driver_release_date: Driver release date
> + * @driver_capabilities: Driver capabilities
> + */
> +struct mpi3_driver_info_layout {
> +	__le32             information_length;
> +	u8                 driver_signature[12];
> +	u8                 os_name[16];
> +	u8                 os_version[12];
> +	u8                 driver_name[20];
> +	u8                 driver_version[32];
> +	u8                 driver_release_date[20];
> +	__le32             driver_capabilities;
> +};
> +
> /**
>  * struct mpi3mr_bsg_in_adpinfo - Adapter information request
>  * data returned by the driver.
> @@ -430,4 +452,121 @@ struct mpi3mr_bsg_packet {
> 		struct mpi3mr_bsg_mptcmd mptcmd;
> 	} cmd;
> };
> +
> +
> +/* MPI3: NVMe Encasulation related definitions */
> +#ifndef MPI3_NVME_ENCAP_CMD_MAX
> +#define MPI3_NVME_ENCAP_CMD_MAX               (1)
> +#endif
> +
> +struct mpi3_nvme_encapsulated_request {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     change_count;
> +	__le16                     dev_handle;
> +	__le16                     encapsulated_command_length;
> +	__le16                     flags;
> +	__le32                     data_length;
> +	__le32                     reserved14[3];
> +	__le32                     command[MPI3_NVME_ENCAP_CMD_MAX];
> +};
> +
> +struct mpi3_nvme_encapsulated_error_reply {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     ioc_use_only08;
> +	__le16                     ioc_status;
> +	__le32                     ioc_log_info;
> +	__le32                     nvme_completion_entry[4];
> +};
> +
> +/* MPI3: task management related definitions */
> +struct mpi3_scsi_task_mgmt_request {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     change_count;
> +	__le16                     dev_handle;
> +	__le16                     task_host_tag;
> +	u8                         task_type;
> +	u8                         reserved0f;
> +	__le16                     task_request_queue_id;
> +	__le16                     reserved12;
> +	__le32                     reserved14;
> +	u8                         lun[8];
> +};
> +
> +#define MPI3_SCSITASKMGMT_MSGFLAGS_DO_NOT_SEND_TASK_IU      (0x08)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK               (0x01)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_ABORT_TASK_SET           (0x02)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET             (0x03)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET       (0x05)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_TASK_SET           (0x06)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK               (0x07)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_CLEAR_ACA                (0x08)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK_SET           (0x09)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_QUERY_ASYNC_EVENT        (0x0a)
> +#define MPI3_SCSITASKMGMT_TASKTYPE_I_T_NEXUS_RESET          (0x0b)
> +struct mpi3_scsi_task_mgmt_reply {
> +	__le16                     host_tag;
> +	u8                         ioc_use_only02;
> +	u8                         function;
> +	__le16                     ioc_use_only04;
> +	u8                         ioc_use_only06;
> +	u8                         msg_flags;
> +	__le16                     ioc_use_only08;
> +	__le16                     ioc_status;
> +	__le32                     ioc_log_info;
> +	__le32                     termination_count;
> +	__le32                     response_data;
> +	__le32                     reserved18;
> +};
> +
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_COMPLETE                (0x00)
> +#define MPI3_SCSITASKMGMT_RSPCODE_INVALID_FRAME              (0x02)
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_FUNCTION_NOT_SUPPORTED  (0x04)
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_FAILED                  (0x05)
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_SUCCEEDED               (0x08)
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_INVALID_LUN             (0x09)
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_OVERLAPPED_TAG          (0x0a)
> +#define MPI3_SCSITASKMGMT_RSPCODE_IO_QUEUED_ON_IOC           (0x80)
> +#define MPI3_SCSITASKMGMT_RSPCODE_TM_NVME_DENIED             (0x81)
> +
> +/* MPI3: PEL related definitions */
> +#define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
> +#define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
> +#define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)
> +#define MPI3_PEL_LOCALE_FLAGS_CONFIGURATION             (0x0040)
> +#define MPI3_PEL_LOCALE_FLAGS_CONTROLER                 (0x0020)
> +#define MPI3_PEL_LOCALE_FLAGS_SAS                       (0x0010)
> +#define MPI3_PEL_LOCALE_FLAGS_EPACK                     (0x0008)
> +#define MPI3_PEL_LOCALE_FLAGS_ENCLOSURE                 (0x0004)
> +#define MPI3_PEL_LOCALE_FLAGS_PD                        (0x0002)
> +#define MPI3_PEL_LOCALE_FLAGS_VD                        (0x0001)
> +#define MPI3_PEL_CLASS_DEBUG                            (0x00)
> +#define MPI3_PEL_CLASS_PROGRESS                         (0x01)
> +#define MPI3_PEL_CLASS_INFORMATIONAL                    (0x02)
> +#define MPI3_PEL_CLASS_WARNING                          (0x03)
> +#define MPI3_PEL_CLASS_CRITICAL                         (0x04)
> +#define MPI3_PEL_CLASS_FATAL                            (0x05)
> +#define MPI3_PEL_CLASS_FAULT                            (0x06)
> +
> +/* MPI3: Function definitions */
> +#define MPI3_BSG_FUNCTION_MGMT_PASSTHROUGH              (0x0a)
> +#define MPI3_BSG_FUNCTION_SCSI_IO                       (0x20)
> +#define MPI3_BSG_FUNCTION_SCSI_TASK_MGMT                (0x21)
> +#define MPI3_BSG_FUNCTION_SMP_PASSTHROUGH               (0x22)
> +#define MPI3_BSG_FUNCTION_NVME_ENCAPSULATED             (0x24)
> +
> #endif
> --=20
> 2.27.0
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

