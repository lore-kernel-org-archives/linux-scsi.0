Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B2BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C284B613D1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238702AbhDVPou (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 11:44:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35294 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238740AbhDVPng (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 11:43:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFNtoa013304;
        Thu, 22 Apr 2021 15:42:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IlvV201LJ/TGhGuUpbIWD4EX4UljFBp1zzTuIBslPdg=;
 b=LpcgSbV1i826hjYPp+VZvyB1ugO6zyGQXHd/oNtbPoDP7AJWKV/CDOcIlFQMaSPzqO8d
 VSGVgHKCcvT2GFW7M+EQJmu1LOD1aYZ9XBH7kSa9Oy/VbW3RhmOci2RWmN8uKSIBC44G
 otEtpg7TJkKofukdfUcIaojz+s3Q7ntexM02zup3z2QTThg0IZgGP+VyjyEAurY4KtqU
 j/I8Eu+aVyiOOJifBuxjVCoR7K0XJlvJ3y5OPH/vPu25n6HCcXtEAjJM2B1Qrl4FTacL
 SNcEe0GZ5w0os/F1b8MZsI0NDhkTFxLwkKvOHuT8gZ6RcCiEf/oXq3qGZxqawYcjQp3s Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37yn6cdwk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 15:42:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFQ1td093526;
        Thu, 22 Apr 2021 15:42:52 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 383acywjyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 15:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/PiMJMgj6R0nSqEELJG1ARgaMRIJKoLD9ATYfpefucpBuGZT0EFleQVWiHf6yNOH/rUP1aUmT2oUPH7cvmRbTX0rT9Z8N8Cu31vmP0dUOTZP4PajRccp4CXquDx19Q08KPpHWzgfUQqnWjqNsarr2qJPCuHiU6TqkPNv0dKXd+ZohL39LDqfdnRA9J7l6hrJTTaFVm8Cg/biDW67KE2xbeCSqGZt4l4E1xMPJqdI6a0ZQN/GLZARYQym5csCmEnLrKIzUHjEf/bfRRtV60M5dfcx4x3A33U4OpBkxChlwvRMn/trImBsBwynu5vvNQuOSnhr81M+RpUKvLa43YrmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlvV201LJ/TGhGuUpbIWD4EX4UljFBp1zzTuIBslPdg=;
 b=BwQX9L2INZWnKXwuB4JL2G1BtjhbSGnH+fznVVa/MDs+uNG14qlL+sz7QDsh0SMeo2O+v2s+ilH5Er64dudwq4NecBCQ555FJGuF/Y8wnGvHW4JjQRI5zgurBCKiIvJ2xlWs8yO5HpP5XvgsLon38GzU/+xo/rtZvYkgXCATUr14SvYNKhF5Af2CmCp5dTiB75FC/XlVNjRTqKzZE6/xOwdaRGhF2rHV0ffyO/k6vSfqgzEin6FTS9r8PVFNjoYwvnz/UP+HiV3udnPNVvarZFfSom46dcgVyNcMTJzWC7Z5ToT3smyAmAqy5Rnxb2FCvVShSAGhlFYdMbsVVOv3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlvV201LJ/TGhGuUpbIWD4EX4UljFBp1zzTuIBslPdg=;
 b=zqEOWeA5PYv4/qbGq8H+V140tRr6/xSbMu3MSP2sWqUlKLzPaWYFOgKpm5a9WREgKyg62imEDMN54XQTInXhA466YV1L3EmY+vx7j1zOK//a0e3zAS99qGAN11LIXBCLyA/IOmdUgV5yUS64MKnAtG2/A5wSDDN81qC94FgcpCM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 15:42:49 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 15:42:49 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        "thenzl@redhat.com" <thenzl@redhat.com>
Subject: Re: [PATCH v3 13/24] mpi3mr: implement scsi error handler hooks
Thread-Topic: [PATCH v3 13/24] mpi3mr: implement scsi error handler hooks
Thread-Index: AQHXNQuSUyyf1rLW0U+husGfG/6gsKrAsjSA
Date:   Thu, 22 Apr 2021 15:42:49 +0000
Message-ID: <B64200E2-E6D9-4D9B-88D4-B65C4F53BC72@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-14-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-14-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a29df2c6-1a9f-43c0-4fd5-08d905a548a2
x-ms-traffictypediagnostic: SA2PR10MB4795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB479591E13AFBAEA3B25B266AE6469@SA2PR10MB4795.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +5bWaDTKtGo914CuX4qqgrv8de7kN2WKTVRTMXui0pQPRp+zTRlgQTQfYWOwXF5anK8+lPHkjvF9MydU6wShK9PBFcQSugjrR1k0P7K+BPVYw8hj1xiRjo+BbFvmWIx6eTfpGvd4wi39UIw8arPdfVvMu91ZuvE+f/eZTVlwYJL8hFEjHljCeqMwTBkfy+jzC0U8ooyYeW8DOfnIAPcH8Z7D/1asEqdU/nY8/Hzbte2Rzcl4HkFvCp7CBVZ3tlIpRzAwCkzlN9IaZ8t7uz0vnw5IekD68SDWGy8ChAt3eQ9leRhIbg0L+72+q8i5fx8Y7lzaO/rNMdS6uQF6v992HBcs1aLWBCYbCMxviiP5yJxbiicNX4KO0T//m+FoDyUQ7fwhv9zTIUW2d7jlFFQaECC42QdHnjfgp3nmL2qQOUhojPRiTNx/qGbic/d0IPliPnQWzdVMBQy9xmA7Vxcy3BNr181G7HYEhXFW70X4jaD0gxpvyPpYhmPkwFJX+XCRiw2N7RvNqUp6k4mg735wWXA9VoByMn5UfRCT8R7DgWXKwtkVa5qN2Pex1BBbEeIILrvd4RHnLgsUVPEgc1002PmCXd9cU6WyDPaw7AiXQZMIDcbBOuKZZfJ1vxTzrPXSoYzt1FwdzoeuPmOR8tTK1QJbOvl8L0MEjl51eD+3Z2/FqUvTUFt7EeKhdodXQ2vv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(38100700002)(6486002)(30864003)(26005)(186003)(6916009)(5660300002)(44832011)(6512007)(86362001)(2906002)(2616005)(478600001)(36756003)(83380400001)(33656002)(316002)(4326008)(122000001)(71200400001)(54906003)(6506007)(66946007)(76116006)(53546011)(66446008)(66476007)(64756008)(66556008)(8676002)(8936002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nTdkRIpdFX5iMxI4BYh1WtwXtiWvhHjciahqDYS6e3TPvGKype5cDBB1mkKg?=
 =?us-ascii?Q?hgq18J7NTxAQNI1EBauAXaQe78OIsua6XGYMLozxCTZpDsMlfmq4jdMUCgxh?=
 =?us-ascii?Q?hpPJYpASst8ZvdpLuRH9b/CHX1SZFEwCBnwexDkTdb4W45u0nYucPdDN71Uk?=
 =?us-ascii?Q?//xg+QUxEjCQuwSmjj3CTBpgDeUsSOFloB9HkDSybc44O59OvH/eN8XXAQS6?=
 =?us-ascii?Q?3nnXfEirJ4Q/nulGOJxeEBxZf3UwdWoqyVD11SMpS1fkUbh1x5KbWnT93Wkj?=
 =?us-ascii?Q?WEbU02nyYeDiB0qyWN5GZwjCVHHQckdhOWd+u37kQ3FSS8+H46uB9SC0RLQG?=
 =?us-ascii?Q?Ojyc80Ocini2x8OiCLJwzndVSWtdeVnu45wQcev5vvy/PmmJSq9sc9fkQPkT?=
 =?us-ascii?Q?hPSL6JlPHvh2gQyASz9tkwrUebDSKMqVytNXKIlOMDtq1YtzkwMyZj6Ypv1o?=
 =?us-ascii?Q?38fowirwBqachGvKYYjZxFeI1Ooq85L7pzrHvTVgvLHDyHF0uP9bt1bxTcCk?=
 =?us-ascii?Q?jqfUX4Nx+1GoTSD9I3JdfipNn5uoG6m8KKt0EPPFJ1aj7GSlgw7D0SJ2kc5y?=
 =?us-ascii?Q?HqGcj80QJxJpFjYj+iD4uedvPd/5BY79SX4doW6BtxW9EhLBzfRzGIVwek6p?=
 =?us-ascii?Q?qDh/G/yvX0Hxlaor/Wg5JypJ8ylvcL9y/it3kTwqgOnvqxQ95h5WyasKwAGk?=
 =?us-ascii?Q?+OHHVumDPCqlhKT5FLMorscBoYRHcpBo3f9bu2G0fJNdupVrITL8CpJ3B4kf?=
 =?us-ascii?Q?d7v6jjUw27IjNvTesbq+BCv2ioivv1U0stcOWMEZqHCazy3YA76EByo1Qifc?=
 =?us-ascii?Q?frlonqTqOpqP2NgQ5cf+e1zvk7JO6y8GWLFU7cdeh0bWNwOJqvXsTMtOkRy0?=
 =?us-ascii?Q?WRgdume4M60U7ZcvTgsWt2ikTcUbpQCJlgb8irh0VeZjsDT1yfQFlVTB+zRg?=
 =?us-ascii?Q?qPO1w7Es/OOal5LGxiykltJ18NEpfXx6sBPzaX9mnVaEvTokuFAgwsxMGzGK?=
 =?us-ascii?Q?+OPqIsLQsTzmCFziP0jNWn6Dn7U9IPrCAB377vqF31vu52kcjgv+lAC0weRZ?=
 =?us-ascii?Q?S8/r8FPZjl/ai4usFjsEOro5KzUqlSx7podFw3WCLvfTpbHiHh0M/8/vOV41?=
 =?us-ascii?Q?piUBy2j2Bnw98Vh9Ar0LlNVvnaJmuIIoJTYGXdF8D/Q4qK/Z2AzTpFVT1Zxz?=
 =?us-ascii?Q?di1qAbfEYJsNZNwUb8IDEA7YcZgB8J+/3ZQKuLzn3QiTayqwBLse7Z+TUCOQ?=
 =?us-ascii?Q?NqZPrEBKb0lAod/SQv66y7/YNK/1iy0KFflAxMUCiSrxsRB/maRqxkloWhUj?=
 =?us-ascii?Q?dOKm51j4GNkX7vcFgNVIi6WZMmXme6OB/iOUYw5HD4f+wQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF59AB6601113F41A46476123A965852@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29df2c6-1a9f-43c0-4fd5-08d905a548a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 15:42:49.5571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myiNQYrW2BeZ8vdrbiwz+mYn9iWsS/FJJB4FgiMn/wUk2aBxQX//DpLU9dOgsEPyk9wPsav36QA1ZUmpEEFm/Vb6Sg02QUbEO5wTQyasMUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220121
X-Proofpoint-GUID: Ixa6WsPdN5T3NR9fqGmzNaoYHz5-ttWR
X-Proofpoint-ORIG-GUID: Ixa6WsPdN5T3NR9fqGmzNaoYHz5-ttWR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> SCSI EH hook is added.
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
>=20
> Cc: sathya.prakash@broadcom.com
> Cc: hare@suse.de
> Cc: thenzl@redhat.com
>=20
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |   3 +
> drivers/scsi/mpi3mr/mpi3mr_fw.c |  45 ++++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 349 ++++++++++++++++++++++++++++++++
> 3 files changed, 397 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 801612c9eb2a..fe6c815b918a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -97,6 +97,7 @@ extern struct list_head mrioc_list;
> /* command/controller interaction timeout definitions in seconds */
> #define MPI3MR_INTADMCMD_TIMEOUT		10
> #define MPI3MR_PORTENABLE_TIMEOUT		300
> +#define MPI3MR_ABORTTM_TIMEOUT			30
> #define MPI3MR_RESETTM_TIMEOUT			30
> #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
> #define MPI3MR_TSUPDATE_INTERVAL		900
> @@ -626,6 +627,7 @@ struct scmd_priv {
>  * @chain_bitmap_sz: Chain buffer allocator bitmap size
>  * @chain_bitmap: Chain buffer allocator bitmap
>  * @chain_buf_lock: Chain buffer list lock
> + * @host_tm_cmds: Command tracker for task management commands
>  * @dev_rmhs_cmds: Command tracker for device removal commands
>  * @devrem_bitmap_sz: Device removal bitmap size
>  * @devrem_bitmap: Device removal bitmap
> @@ -748,6 +750,7 @@ struct mpi3mr_ioc {
> 	void *chain_bitmap;
> 	spinlock_t chain_buf_lock;
>=20
> +	struct mpi3mr_drv_cmd host_tm_cmds;
> 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
> 	u16 devrem_bitmap_sz;
> 	void *devrem_bitmap;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 3df689410c8f..c25e96f008d7 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -172,6 +172,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host=
_tag,
> 	switch (host_tag) {
> 	case MPI3MR_HOSTTAG_INITCMDS:
> 		return &mrioc->init_cmds;
> +	case MPI3MR_HOSTTAG_BLK_TMS:
> +		return &mrioc->host_tm_cmds;
> 	case MPI3MR_HOSTTAG_INVALID:
> 		if (def_reply && def_reply->Function =3D=3D
> 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
> @@ -2045,6 +2047,32 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mp=
i3mr_ioc *mrioc)
> 			goto out_failed;
> 	}
>=20
> +	mrioc->host_tm_cmds.reply =3D kzalloc(mrioc->facts.reply_sz, GFP_KERNEL=
);
> +	if (!mrioc->host_tm_cmds.reply)
> +		goto out_failed;
> +
> +	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> +		mrioc->dev_rmhs_cmds[i].reply =3D kzalloc(mrioc->facts.reply_sz,
> +		    GFP_KERNEL);
> +		if (!mrioc->dev_rmhs_cmds[i].reply)
> +			goto out_failed;
> +	}
> +	mrioc->dev_handle_bitmap_sz =3D mrioc->facts.max_devhandle / 8;
> +	if (mrioc->facts.max_devhandle % 8)
> +		mrioc->dev_handle_bitmap_sz++;
> +	mrioc->removepend_bitmap =3D kzalloc(mrioc->dev_handle_bitmap_sz,
> +	    GFP_KERNEL);
> +	if (!mrioc->removepend_bitmap)
> +		goto out_failed;
> +
> +	mrioc->devrem_bitmap_sz =3D MPI3MR_NUM_DEVRMCMD / 8;
> +	if (MPI3MR_NUM_DEVRMCMD % 8)
> +		mrioc->devrem_bitmap_sz++;
> +	mrioc->devrem_bitmap =3D kzalloc(mrioc->devrem_bitmap_sz,
> +	    GFP_KERNEL);
> +	if (!mrioc->devrem_bitmap)
> +		goto out_failed;
> +
> 	mrioc->num_reply_bufs =3D mrioc->facts.max_reqs + MPI3MR_NUM_EVT_REPLIES=
;
> 	mrioc->reply_free_qsz =3D mrioc->num_reply_bufs + 1;
> 	mrioc->num_sense_bufs =3D mrioc->facts.max_reqs / MPI3MR_SENSEBUF_FACTOR=
;
> @@ -3048,6 +3076,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc=
 *mrioc)
> 	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
>=20
> 	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
> +	memset(mrioc->host_tm_cmds.reply, 0,
> +		    sizeof(*mrioc->host_tm_cmds.reply));
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> 		memset(mrioc->dev_rmhs_cmds[i].reply, 0,
> 		    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
> @@ -3141,6 +3171,19 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mri=
oc)
> 	kfree(mrioc->init_cmds.reply);
> 	mrioc->init_cmds.reply =3D NULL;
>=20
> +	kfree(mrioc->host_tm_cmds.reply);
> +	mrioc->host_tm_cmds.reply =3D NULL;
> +
> +	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> +		kfree(mrioc->dev_rmhs_cmds[i].reply);
> +		mrioc->dev_rmhs_cmds[i].reply =3D NULL;
> +	}
> +	kfree(mrioc->removepend_bitmap);
> +	mrioc->removepend_bitmap =3D NULL;
> +
> +	kfree(mrioc->devrem_bitmap);
> +	mrioc->devrem_bitmap =3D NULL;
> +
> 	kfree(mrioc->chain_bitmap);
> 	mrioc->chain_bitmap =3D NULL;
>=20
> @@ -3321,6 +3364,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc=
 *mrioc)
>=20
> 	cmdptr =3D &mrioc->init_cmds;
> 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> +	cmdptr =3D &mrioc->host_tm_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
>=20
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> 		cmdptr =3D &mrioc->dev_rmhs_cmds[i];
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 946a62610b55..fd5fdc61169e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2075,6 +2075,212 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc=
 *mrioc,
> 	return ret;
> }
>=20
> +/**
> + * mpi3mr_print_response_code - print TM response as a string
> + * @mrioc: Adapter instance reference
> + * @resp_code: TM response code
> + *
> + * Print TM response code as a readable string.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_print_response_code(struct mpi3mr_ioc *mrioc, u8 resp=
_code)
> +{
> +	char *desc;
> +
> +	switch (resp_code) {
> +	case MPI3MR_RSP_TM_COMPLETE:
> +		desc =3D "task management request completed";
> +		break;
> +	case MPI3MR_RSP_INVALID_FRAME:
> +		desc =3D "invalid frame";
> +		break;
> +	case MPI3MR_RSP_TM_NOT_SUPPORTED:
> +		desc =3D "task management request not supported";
> +		break;
> +	case MPI3MR_RSP_TM_FAILED:
> +		desc =3D "task management request failed";
> +		break;
> +	case MPI3MR_RSP_TM_SUCCEEDED:
> +		desc =3D "task management request succeeded";
> +		break;
> +	case MPI3MR_RSP_TM_INVALID_LUN:
> +		desc =3D "invalid lun";
> +		break;
> +	case MPI3MR_RSP_TM_OVERLAPPED_TAG:
> +		desc =3D "overlapped tag attempted";
> +		break;
> +	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
> +		desc =3D "task queued, however not sent to target";
> +		break;
> +	default:
> +		desc =3D "unknown";
> +		break;
> +	}
> +	ioc_info(mrioc, "%s :response_code(0x%01x): %s\n", __func__,
> +	    resp_code, desc);
> +}
> +
> +/**
> + * mpi3mr_issue_tm - Issue Task Management request
> + * @mrioc: Adapter instance reference
> + * @tm_type: Task Management type
> + * @handle: Device handle
> + * @lun: LUN ID
> + * @htag: Host tag of the TM request
> + * @drv_cmd: Internal command tracker
> + * @resp_code: Response code place holder
> + * @cmd_priv: SCSI command private data
> + *
> + * Issues a Task Management Request to the controller for a
> + * specified target, LUN and command and wait for its completion
> + * and check TM response. Recover the TM if it timed out by
> + * issuing controller reset.
> + *
> + * Return: 0 on success, non-zero on errors
> + */
> +static int mpi3mr_issue_tm(struct mpi3mr_ioc *mrioc, u8 tm_type,
> +	u16 handle, uint lun, u16 htag, ulong timeout,
> +	struct mpi3mr_drv_cmd *drv_cmd,
> +	u8 *resp_code, struct scmd_priv *cmd_priv)
> +{
> +	Mpi3SCSITaskMgmtRequest_t tm_req;
> +	Mpi3SCSITaskMgmtReply_t *tm_reply =3D NULL;
> +	int retval =3D 0;
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data =3D NULL;
> +	struct op_req_qinfo *op_req_q =3D NULL;
> +
> +	ioc_info(mrioc, "%s :Issue TM: TM Type (0x%x) for devhandle 0x%04x\n",
> +	    __func__, tm_type, handle);
> +	if (mrioc->unrecoverable) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "%s :Issue TM: Unrecoverable controller\n",
> +		    __func__);
> +		goto out;
> +	}
> +
> +	memset(&tm_req, 0, sizeof(tm_req));
> +	mutex_lock(&drv_cmd->mutex);
> +	if (drv_cmd->state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "%s :Issue TM: Command is in use\n", __func__);
> +		mutex_unlock(&drv_cmd->mutex);
> +		goto out;
> +	}
> +	if (mrioc->reset_in_progress) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "%s :Issue TM: Reset in progress\n", __func__);
> +		mutex_unlock(&drv_cmd->mutex);
> +		goto out;
> +	}
> +
> +	drv_cmd->state =3D MPI3MR_CMD_PENDING;
> +	drv_cmd->is_waiting =3D 1;
> +	drv_cmd->callback =3D NULL;
> +	tm_req.DevHandle =3D cpu_to_le16(handle);
> +	tm_req.TaskType =3D tm_type;
> +	tm_req.HostTag =3D cpu_to_le16(htag);
> +
> +	int_to_scsilun(lun, (struct scsi_lun *)tm_req.LUN);
> +	tm_req.Function =3D MPI3_FUNCTION_SCSI_TASK_MGMT;
> +
> +	tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> +	if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
> +		scsi_tgt_priv_data =3D (struct mpi3mr_stgt_priv_data *)
> +		    tgtdev->starget->hostdata;
> +		atomic_inc(&scsi_tgt_priv_data->block_io);
> +	}
> +	if (cmd_priv) {
> +		op_req_q =3D &mrioc->req_qinfo[cmd_priv->req_q_idx];
> +		tm_req.TaskHostTag =3D cpu_to_le16(cmd_priv->host_tag);
> +		tm_req.TaskRequestQueueID =3D cpu_to_le16(op_req_q->qid);
> +	}
> +	if (tgtdev && (tgtdev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_PCIE)) {
> +		if (cmd_priv && tgtdev->dev_spec.pcie_inf.abort_to)
> +			timeout =3D tgtdev->dev_spec.pcie_inf.abort_to;
> +		else if (!cmd_priv && tgtdev->dev_spec.pcie_inf.reset_to)
> +			timeout =3D tgtdev->dev_spec.pcie_inf.reset_to;
> +	}
> +
> +	init_completion(&drv_cmd->done);
> +	retval =3D mpi3mr_admin_request_post(mrioc, &tm_req, sizeof(tm_req), 1)=
;
> +	if (retval) {
> +		ioc_err(mrioc, "%s :Issue TM: Admin Post failed\n", __func__);
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&drv_cmd->done, (timeout * HZ));
> +
> +	if (!(drv_cmd->state & MPI3MR_CMD_COMPLETE)) {
> +		ioc_err(mrioc, "%s :Issue TM: command timed out\n", __func__);
> +		drv_cmd->is_waiting =3D 0;
> +		retval =3D -1;
> +		mpi3mr_soft_reset_handler(mrioc,
> +		    MPI3MR_RESET_FROM_TM_TIMEOUT, 1);
> +		goto out_unlock;
> +	}
> +
> +	if (drv_cmd->state & MPI3MR_CMD_REPLY_VALID)
> +		tm_reply =3D (Mpi3SCSITaskMgmtReply_t *)drv_cmd->reply;
> +
> +	if (drv_cmd->ioc_status !=3D MPI3_IOCSTATUS_SUCCESS) {
> +		ioc_err(mrioc,
> +		    "%s :Issue TM: handle(0x%04x) Failed IOCStatus(0x%04x) Loginfo(0x%=
08x)\n",
> +		    __func__, handle, drv_cmd->ioc_status,
> +		    drv_cmd->ioc_loginfo);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +
> +	if (!tm_reply) {
> +		ioc_err(mrioc, "%s :Issue TM: No TM Reply message\n", __func__);
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +
> +	*resp_code =3D le32_to_cpu(tm_reply->ResponseData) &
> +	    MPI3MR_RI_MASK_RESPCODE;
> +	switch (*resp_code) {
> +	case MPI3MR_RSP_TM_SUCCEEDED:
> +	case MPI3MR_RSP_TM_COMPLETE:
> +		break;
> +	case MPI3MR_RSP_IO_QUEUED_ON_IOC:
> +		if (tm_type !=3D MPI3_SCSITASKMGMT_TASKTYPE_QUERY_TASK)
> +			retval =3D -1;
> +		break;
> +	default:
> +		retval =3D -1;
> +		break;
> +	}
> +
> +	ioc_info(mrioc,
> +	    "%s :Issue TM: Completed TM Type (0x%x) handle(0x%04x) ",
> +	    __func__, tm_type, handle);
> +	ioc_info(mrioc,
> +	    "with ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
> +	    drv_cmd->ioc_status, drv_cmd->ioc_loginfo,
> +	    le32_to_cpu(tm_reply->TerminationCount));
> +	mpi3mr_print_response_code(mrioc, *resp_code);
> +
> +out_unlock:
> +	drv_cmd->state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&drv_cmd->mutex);
> +	if (scsi_tgt_priv_data)
> +		atomic_dec_if_positive(&scsi_tgt_priv_data->block_io);
> +	if (tgtdev)
> +		mpi3mr_tgtdev_put(tgtdev);
> +	if (!retval) {
> +		/*
> +		 * Flush all IRQ handlers by calling synchronize_irq().
> +		 * mpi3mr_ioc_disable_intr() takes care of it.
> +		 */
> +		mpi3mr_ioc_disable_intr(mrioc);
> +		mpi3mr_ioc_enable_intr(mrioc);
> +	}
> +out:
> +	return retval;
> +}
> +
> /**
>  * mpi3mr_bios_param - BIOS param callback
>  * @sdev: SCSI device reference
> @@ -2132,6 +2338,145 @@ static int mpi3mr_map_queues(struct Scsi_Host *sh=
ost)
> 	    mrioc->pdev, mrioc->op_reply_q_offset);
> }
>=20
> +/**
> + * mpi3mr_eh_host_reset - Host reset error handling callback
> + * @scmd: SCSI command reference
> + *
> + * Issue controller reset if the scmd is for a Physical Device,
> + * if the scmd is for RAID volume, then wait for
> + * MPI3MR_RAID_ERRREC_RESET_TIMEOUT and checke whether any
> + * pending I/Os prior to issuing reset to the controller.
> + *
> + * Return: SUCCESS of successful reset else FAILED
> + */
> +static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(scmd->device->host);
> +	int retval =3D FAILED, ret;
> +
> +
> +	ret =3D mpi3mr_soft_reset_handler(mrioc,
> +	    MPI3MR_RESET_FROM_EH_HOS, 1);
> +	if (ret)
> +		goto out;
> +
> +	retval =3D SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Host reset is %s for scmd(%p)\n",
> +	    ((retval =3D=3D SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_eh_target_reset - Target reset error handling callback
> + * @scmd: SCSI command reference
> + *
> + * Issue Target reset Task Management and verify the scmd is
> + * terminated successfully and return status accordingly.
> + *
> + * Return: SUCCESS of successful termination of the scmd else
> + *         FAILED
> + */
> +static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(scmd->device->host);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	u16 dev_handle;
> +	u8 resp_code =3D 0;
> +	int retval =3D FAILED, ret =3D 0;
> +
> +
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Attempting Target Reset! scmd(%p)\n", scmd);
> +	scsi_print_command(scmd);
> +
> +	sdev_priv_data =3D scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +		    "SCSI device is not available\n");
> +		retval =3D SUCCESS;
> +		goto out;
> +	}
> +
> +	stgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +	dev_handle =3D stgt_priv_data->dev_handle;
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Target Reset is issued to handle(0x%04x)\n",
> +	    dev_handle);
> +
> +	ret =3D mpi3mr_issue_tm(mrioc,
> +	    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET, dev_handle,
> +	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
> +	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
> +
> +	if (ret)
> +		goto out;
> +
> +	retval =3D SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Target reset is %s for scmd(%p)\n",
> +	    ((retval =3D=3D SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	return retval;
> +}
> +
> +/**
> + * mpi3mr_eh_dev_reset- Device reset error handling callback
> + * @scmd: SCSI command reference
> + *
> + * Issue LUN reset Task Management and verify the scmd is
> + * terminated successfully and return status accordingly.
> + *
> + * Return: SUCCESS of successful termination of the scmd else
> + *         FAILED
> + */
> +static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
> +{
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(scmd->device->host);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	u16 dev_handle;
> +	u8 resp_code =3D 0;
> +	int retval =3D FAILED, ret =3D 0;
> +
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Attempting Device(LUN) Reset! scmd(%p)\n", scmd);
> +	scsi_print_command(scmd);
> +
> +	sdev_priv_data =3D scmd->device->hostdata;
> +	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
> +		sdev_printk(KERN_INFO, scmd->device,
> +		    "SCSI device is not available\n");
> +		retval =3D SUCCESS;
> +		goto out;
> +	}
> +
> +	stgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +	dev_handle =3D stgt_priv_data->dev_handle;
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Device(LUN) Reset is issued to handle(0x%04x)\n", dev_handle);
> +
> +	ret =3D mpi3mr_issue_tm(mrioc,
> +	    MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, dev_handle,
> +	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
> +	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
> +
> +	if (ret)
> +		goto out;
> +
> +	retval =3D SUCCESS;
> +out:
> +	sdev_printk(KERN_INFO, scmd->device,
> +	    "Device(LUN) reset is %s for scmd(%p)\n",
> +	    ((retval =3D=3D SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +
> +	return retval;
> +}
> +
> /**
>  * mpi3mr_scan_start - Scan start callback handler
>  * @shost: SCSI host reference
> @@ -2547,6 +2892,9 @@ static struct scsi_host_template mpi3mr_driver_temp=
late =3D {
> 	.slave_destroy			=3D mpi3mr_slave_destroy,
> 	.scan_finished			=3D mpi3mr_scan_finished,
> 	.scan_start			=3D mpi3mr_scan_start,
> +	.eh_device_reset_handler	=3D mpi3mr_eh_dev_reset,
> +	.eh_target_reset_handler	=3D mpi3mr_eh_target_reset,
> +	.eh_host_reset_handler		=3D mpi3mr_eh_host_reset,
> 	.bios_param			=3D mpi3mr_bios_param,
> 	.map_queues			=3D mpi3mr_map_queues,
> 	.no_write_same			=3D 1,
> @@ -2634,6 +2982,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
>=20
> 	mutex_init(&mrioc->reset_mutex);
> 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
> +	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
>=20
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

