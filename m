Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340B0C00144
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 00:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiHBAN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 20:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiHBAN4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 20:13:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2687474F1
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 17:13:54 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271Nwg7C012007;
        Tue, 2 Aug 2022 00:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=INrJMTrq/9bHJ777cDQ/p2NXpaa+l8OTwgomWtOtk0I=;
 b=Z7WKuzkpAobpoFqt8l9oJvy6+prCev9R/HmrxYI/PTpl6lXGxLFVlWf2iL6IKqAip72m
 4J+RBwLRL5ObPUG8chyy5zzO6vx8YzrQLuFW/psf6TlLl4UofSSdDE4WDsFn07bGmU+0
 vqDmeqGXzmq2zBFvauU6+5YQksrc7OKYc/UNUfCswHtcQY94O1NBlNPiOumeXxgzgV/S
 CpHcK+1ZieywqalACwMoNYVljDicPoaCaRbqL/6Nvh2FlAk3Uv/IRR++gY9iC1g9S/6Q
 Au7UcOWOuSPjBwleWdhUT/hBTQxdM3+h1ytb+UECU+UTMHW8HfTVwFH7iC4nuwyiA3m+ rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8s587j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 00:13:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271MJvF5003017;
        Tue, 2 Aug 2022 00:13:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31snps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Aug 2022 00:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1oICaaSIWbdTOXyBWHs97dCEYORq5SnfeL0+KYFl3Guc1iMW9roGn/wgx5Ng9UnTFQOgbcjBNFT42eAb5IsVx3COvDBTMvI19H+xtiow4sbhXFKH65YPGdPO8ioaGrcasyDFhx8N5wG4omNA3UgCXxvZnA8AlxUhGzWXfg7kMc9cy8BZX1tXZkZ1zTRjUcNeRwP+4QYWXUJwKxUSqbUq1WvPQAXpTeU5jKYgMxVhpusL2dUurapI+gHMhLCMfyMg/Iq+n2NkcJlwksmiBtU6g49eXbOVh6JZycly1f24gytSaw2bWXx9cjiOgA6RR50EN+whr56hgm/hvkLubBDMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INrJMTrq/9bHJ777cDQ/p2NXpaa+l8OTwgomWtOtk0I=;
 b=J0qVpUrmL4lE1DAt4+TRrANb9tfatrLtKzgrBgrp+0UzdmIa6PACH+8GQZMH6+nwOcvM4uRjJrO18gnPj0czUeVdWUFxzDU6J7iMNXjaxfNvHPWdW/trLHhm7mtp4EptQaGuMSrYBtLFV8x6dUi2OBLRUlSu/x+G5MXa+eV0o47EAibWuCGF1R5iTvxgvhJwluEuSK4r96Skfj0QC9EbL67nVnf2KoioVfx26nX1yBnyb99V7vnpMh5mUTDGGEfP7QnMLp1Jj02mNebvAl5bsCPRoUGN4Zr25Ec6mFaQsmpdFZPmmtJYsJ0a9c4ae3yLZ5lOA1Rb6qY1TIbWkZFL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INrJMTrq/9bHJ777cDQ/p2NXpaa+l8OTwgomWtOtk0I=;
 b=K//KREupvoI1LaXKESbJvk1cSujZelyT8zX9i1MWBGzNdbbiyq4uMSLtJ7BavmpnQhKmzu/u/EyLNoSfqlVIWXSgqBadbRClA2SGKOfpRbybW/t+JEMi+TNRcNaTcgeVbZbd/FUOx1XnPGnsVHFDw+6+0rJxfPMilWL0uVOerRA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB4000.namprd10.prod.outlook.com (2603:10b6:208:1b8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Tue, 2 Aug
 2022 00:13:51 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::741e:dd09:de30:aee3%3]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 00:13:51 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [PATCH 12/15] mpi3mr: Add framework to issue MPT transport cmds
Thread-Topic: [PATCH 12/15] mpi3mr: Add framework to issue MPT transport cmds
Thread-Index: AQHYo0wJ7uRlTJTIZEq2GpC+EHQ4ea2awuMA
Date:   Tue, 2 Aug 2022 00:13:50 +0000
Message-ID: <A7DBDEA6-E517-4A01-B7A2-7BD215641D12@oracle.com>
References: <20220729131627.15019-1-sreekanth.reddy@broadcom.com>
 <20220729131627.15019-13-sreekanth.reddy@broadcom.com>
In-Reply-To: <20220729131627.15019-13-sreekanth.reddy@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27de4db3-e140-43c4-5237-08da741be0c5
x-ms-traffictypediagnostic: MN2PR10MB4000:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9825rw2WYPJ98oQ0Hzc8PXBCgVQOPXJS3qEDDVsTDQCWfY3oX/tKMWH8hR6I/WKgnfxJ880c/20B6OuUbC9Swogm/p3XdZflqKagbJH+Pum54pIutIUpZ8tan3RL2u5GCpjAakDsHT9L+mhW6HThMIkoMEHyDkYRBYx8dJOK7m37rUpG6gGg7EkIMzOS8aFnty6P2o0c94eTc5YlXFvDZN5mzM7i49kgRW9eFxApoeUdk/TFJwbE4FgTdISGu1aJ1HehB2UstcNVbLJ1oHBYprEYzVvB3MPL9Ar95uNIOUMvaLXPA9IPTR2uKBSmLC1fs53QTFCG/nQHbRUCOP/RyWTsCePunHxs20XWt33f7/FQz/Hp+Cp3kpo5Jd5UjKp/5Jv7RId19Ucqf4t+aDzUUm4R8HnrstxtFoR3QMeC3ByjdfRitGg5xUK6eotHWweRRT99xOpX3+AtkrSSx9ryTTw9ycX/9TXhUflUn3Pcom99G7hAS8NBS7SZR/R7nkybToNFO/A0mxUdFzY0yevcx6dt1+iZFf0YfkwNuS3msYhvna4mjIS7G4DcMRd/TCBfZzQpiK065PYuKOrMFF2h4ZZogNrFWCeufdaBf40Gx/q5epHwVxvMZnGKEWCiOOU3/J0MrSFYOhveJfAQde3D27tijKceOjlCwOcn23CdrgZrLm8vns1biYYPiA58X/2pg2x+5pHC/TbMXv+0DFr7pLAvAMZwmJrf8hBxy0rOGQZrA0kJeIJ7CQbccSLFtnqDuy8SayCSh8l3nPfTB8xVAf1tMh8ifRfCdnRoaVwcioLLpa3add2H3WJ91VUm0gd49nCvGowCj4IXuG86wCDIkByxDeQ+hhBeeZOBAhbRX98=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(396003)(346002)(39860400002)(8936002)(33656002)(41300700001)(91956017)(83380400001)(4326008)(64756008)(6512007)(8676002)(66946007)(66556008)(66446008)(66476007)(26005)(76116006)(316002)(186003)(44832011)(107886003)(2616005)(30864003)(6916009)(5660300002)(54906003)(71200400001)(86362001)(478600001)(6486002)(38070700005)(2906002)(122000001)(38100700002)(36756003)(6506007)(53546011)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9c1VxqEw94zTgOaJUESjxnV3ZlVv+Bm3ZyxWCPE8zew6DxfBsK47xDfGx6GW?=
 =?us-ascii?Q?EkWevMzR92J42oLqVnhB6Rm7f/n0nksuKWnGx2dUGsn3Fggn6xAzxE+eV/R5?=
 =?us-ascii?Q?3zwDtCwYuGpBjSdwmHUWaMHpJiRihIksymRRYyvNWi3wwaaQexBeb5EvN85f?=
 =?us-ascii?Q?IKYp+J04DRI1t7wP4+FE+Lt0gSXOKuzR8OkzbIAsFKzlsIvL23fqvp1QeAWX?=
 =?us-ascii?Q?j3uv0Dp7oZ9XxHEi7AKgC+oWwkz1Z+QeC6eQ8aZ4tg2tqDRTI1VimwmF6PG0?=
 =?us-ascii?Q?xJ8FN0CjT3Cus8VyxMkvFwvfxjpmkZcRnVFNc9YSn36aP5nFuemCz5YGyRP+?=
 =?us-ascii?Q?hn5bVUr38eWSKVAedpwduFKQQ41T7he18ctHIYHHU338lBeLb12TQJVOZgZ6?=
 =?us-ascii?Q?un38ikB4TPA4J0fzCGLn1hTUSRqWyr0fExSEwvWZO3hwHdrzm99B4lhxgTRn?=
 =?us-ascii?Q?+fKtHH3xKEWaw/z1RDwO0/QReH+jrlpMZMqlvLISFq+ttMQMU4CSjbei2k5i?=
 =?us-ascii?Q?ucFqxn1VTKudFnjm7m69wvgtxs/FqQuczli/Xj3ZsTRD+borJRyYEIC17CML?=
 =?us-ascii?Q?gcxq7dkzO86iG5EHZRtGVMgzQowt7Anxm2SiYY1nK1BJu1vmJhc+Atq9No+a?=
 =?us-ascii?Q?pK64pH9Eu6qmYfeugF2N3bZMmNCaE8El3+UrLxMeqHr4l+x3jYCewNytbpO5?=
 =?us-ascii?Q?7lCEOVRsMJ8t0Ax1qjNFuJDYGAb/50RpOdBnTWrrt+Nv0Own+EZePT2TFyzI?=
 =?us-ascii?Q?tIz0g6ZS0omXp7anFYSDpKbkAb9PW9MYQQyE1jnxEo/NeoRBQKW2AqcLC6Da?=
 =?us-ascii?Q?tq9eyQW+FKcctJMucE104Pix4RraGZGmf3lZXMUVZxeN7uGJTzIJS/ollra6?=
 =?us-ascii?Q?eRpdxBAOagnzZdPqGuv+W0Xmk71mGsRiyz5sZSdVWiyZ8dYGOktPMdNF+cxX?=
 =?us-ascii?Q?UGz5KRT88GujelFXAfsgZjnzkCWe5Fnb2QgUETnF0wk8zuWQ0B210yrFHb7B?=
 =?us-ascii?Q?BCGxYbM/pn5MvsGfFrxaUU9yI2xQNDs/9tbcXgWJTbFMVrJ+w912THD9e5CZ?=
 =?us-ascii?Q?ks3N4cbGuoqBF0QT5yTEGQUSPi/dpKcSVXJZrRJzVki1GFIYc32BA2eeUSYW?=
 =?us-ascii?Q?Eo0pKGPjY9EWPzZLN76E1jc6id7k9qpg0kzcXFy3wpgLaQ2Nk0rhTqurn2nH?=
 =?us-ascii?Q?QwLMcjeaJUTwnBOuvgWFEZHCmFtnwQo3igpYp/nabLusE7sSvjWSQyiYI94T?=
 =?us-ascii?Q?ZtvWUU0eLtx9cbYqLioQFo/wWi77U8U/IjJRMMLxye66Z8EIMeDqbFil2XSu?=
 =?us-ascii?Q?FSLXjP3nxTOtzomba69Xe5KWlrWU9jHwc1T2vgBD+7ceODSliS60xDjWFVOX?=
 =?us-ascii?Q?fUPPO/SQ5YWuK+T8UfdexzcGj3gKfn8HexotDAJvD5ESRv7C5IUN9/vnAbDx?=
 =?us-ascii?Q?/4iX3/5xqCtLl4epEzzXK88kV6mkVdBGf67EpKutjjaCFJEpVk/GV88EplWZ?=
 =?us-ascii?Q?c+Ep6Bk/fhUtDbu5yLYCwl5U8buXJpRVxwR1P2MtEZTVbUH9HdLysi+cGrWI?=
 =?us-ascii?Q?s6yn0EBIfhZx8WkoWeNf8Rg32Tz3oyH5GUQgpt96ouO0zv8TErnxwg0NeigM?=
 =?us-ascii?Q?2g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1336B79F76718D43855A997140D9B682@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27de4db3-e140-43c4-5237-08da741be0c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2022 00:13:51.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /RPoAJ8ZMHSqgN5iH4REkcHHaxYqQHtbG89o9/j+gRrfRelQwjNbZX6ABM5RFz8BB75aJAXxuhmRiSnJDF5xhllOTyecLWau0al7YgIhK4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4000
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010121
X-Proofpoint-GUID: x35BSBcBIT1gDbaqjlqR6HNVqkX1pD6B
X-Proofpoint-ORIG-GUID: x35BSBcBIT1gDbaqjlqR6HNVqkX1pD6B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 29, 2022, at 6:16 AM, Sreekanth Reddy <sreekanth.reddy@broadcom.co=
m> wrote:
>=20
> Added framework to issue MPT transport commands to
> controllers.
> Also issued the MPT transport commands to get the
> manufacturing info of sas expander device.
>=20
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h           |   6 +-
> drivers/scsi/mpi3mr/mpi3mr_fw.c        |  17 ++
> drivers/scsi/mpi3mr/mpi3mr_os.c        |   2 +
> drivers/scsi/mpi3mr/mpi3mr_transport.c | 228 +++++++++++++++++++++++++
> 4 files changed, 252 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 21ea021..a6c880c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -99,9 +99,10 @@ extern atomic64_t event_counter;
> #define MPI3MR_HOSTTAG_PEL_WAIT		4
> #define MPI3MR_HOSTTAG_BLK_TMS		5
> #define MPI3MR_HOSTTAG_CFG_CMDS		6
> +#define MPI3MR_HOSTTAG_TRANSPORT_CMDS	7
>=20
> #define MPI3MR_NUM_DEVRMCMD		16
> -#define MPI3MR_HOSTTAG_DEVRMCMD_MIN	(MPI3MR_HOSTTAG_BLK_TMS + 1)
> +#define MPI3MR_HOSTTAG_DEVRMCMD_MIN	(MPI3MR_HOSTTAG_TRANSPORT_CMDS + 1)
> #define MPI3MR_HOSTTAG_DEVRMCMD_MAX	(MPI3MR_HOSTTAG_DEVRMCMD_MIN + \
> 						MPI3MR_NUM_DEVRMCMD - 1)
>=20
> @@ -279,6 +280,7 @@ enum mpi3mr_reset_reason {
> 	MPI3MR_RESET_FROM_SYSFS_TIMEOUT =3D 24,
> 	MPI3MR_RESET_FROM_FIRMWARE =3D 27,
> 	MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT =3D 29,
> +	MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT =3D 30,
> };
>=20
> /* Queue type definitions */
> @@ -1004,6 +1006,7 @@ struct scmd_priv {
>  * @cfg_page_sz: Default configuration page memory size
>  * @sas_transport_enabled: SAS transport enabled or not
>  * @scsi_device_channel: Channel ID for SCSI devices
> + * @transport_cmds: Command tracker for SAS transport commands
>  * @sas_hba: SAS node for the controller
>  * @sas_expander_list: SAS node list of expanders
>  * @sas_node_lock: Lock to protect SAS node list
> @@ -1188,6 +1191,7 @@ struct mpi3mr_ioc {
>=20
> 	u8 sas_transport_enabled;
> 	u8 scsi_device_channel;
> +	struct mpi3mr_drv_cmd transport_cmds;
> 	struct mpi3mr_sas_node sas_hba;
> 	struct list_head sas_expander_list;
> 	spinlock_t sas_node_lock;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 9155434..1bf3cae 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -312,6 +312,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host=
_tag,
> 		return &mrioc->pel_abort_cmd;
> 	case MPI3MR_HOSTTAG_PEL_WAIT:
> 		return &mrioc->pel_cmds;
> +	case MPI3MR_HOSTTAG_TRANSPORT_CMDS:
> +		return &mrioc->transport_cmds;
> 	case MPI3MR_HOSTTAG_INVALID:
> 		if (def_reply && def_reply->function =3D=3D
> 		    MPI3_FUNCTION_EVENT_NOTIFICATION)
> @@ -913,6 +915,10 @@ static const struct {
> 	{ MPI3MR_RESET_FROM_SYSFS_TIMEOUT, "sysfs TM timeout" },
> 	{ MPI3MR_RESET_FROM_FIRMWARE, "firmware asynchronous reset" },
> 	{ MPI3MR_RESET_FROM_CFG_REQ_TIMEOUT, "configuration request timeout"},
> +	{
> +		MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT,
> +		"timeout of a SAS transport layer request"
> +	},
Fix coding style mismatch here

> };
>=20
> /**
> @@ -2866,6 +2872,10 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mp=
i3mr_ioc *mrioc)
> 	if (!mrioc->bsg_cmds.reply)
> 		goto out_failed;
>=20
> +	mrioc->transport_cmds.reply =3D kzalloc(mrioc->reply_sz, GFP_KERNEL);
> +	if (!mrioc->transport_cmds.reply)
> +		goto out_failed;
> +
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> 		mrioc->dev_rmhs_cmds[i].reply =3D kzalloc(mrioc->reply_sz,
> 		    GFP_KERNEL);
> @@ -4072,6 +4082,8 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc=
)
> 		    sizeof(*mrioc->pel_cmds.reply));
> 		memset(mrioc->pel_abort_cmd.reply, 0,
> 		    sizeof(*mrioc->pel_abort_cmd.reply));
> +		memset(mrioc->transport_cmds.reply, 0,
> +		    sizeof(*mrioc->transport_cmds.reply));
> 		for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> 			memset(mrioc->dev_rmhs_cmds[i].reply, 0,
> 			    sizeof(*mrioc->dev_rmhs_cmds[i].reply));
> @@ -4217,6 +4229,9 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
> 	kfree(mrioc->chain_bitmap);
> 	mrioc->chain_bitmap =3D NULL;
>=20
> +	kfree(mrioc->transport_cmds.reply);
> +	mrioc->transport_cmds.reply =3D NULL;
> +
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
> 		kfree(mrioc->dev_rmhs_cmds[i].reply);
> 		mrioc->dev_rmhs_cmds[i].reply =3D NULL;
> @@ -4417,6 +4432,8 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc=
 *mrioc)
> 	cmdptr =3D &mrioc->pel_abort_cmd;
> 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
>=20
> +	cmdptr =3D &mrioc->transport_cmds;
> +	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
> }
>=20
> /**
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index a486fe3..3b20096 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4840,6 +4840,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci=
_device_id *id)
> 	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
> 	mpi3mr_init_drv_cmd(&mrioc->bsg_cmds, MPI3MR_HOSTTAG_BSG_CMDS);
> 	mpi3mr_init_drv_cmd(&mrioc->cfg_cmds, MPI3MR_HOSTTAG_CFG_CMDS);
> +	mpi3mr_init_drv_cmd(&mrioc->transport_cmds,
> +	    MPI3MR_HOSTTAG_TRANSPORT_CMDS);
>=20
> 	for (i =3D 0; i < MPI3MR_NUM_DEVRMCMD; i++)
> 		mpi3mr_init_drv_cmd(&mrioc->dev_rmhs_cmds[i],
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index c449820..44a30d7 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -9,6 +9,225 @@
>=20
> #include "mpi3mr.h"
>=20
> +/**
> + * mpi3mr_post_transport_req - Issue transport requests and wait
> + * @mrioc: Adapter instance reference
> + * @request: Properly populated MPI3 request
> + * @request_sz: Size of the MPI3 request
> + * @reply: Pointer to return MPI3 reply
> + * @reply_sz: Size of the MPI3 reply buffer
> + * @timeout: Timeout in seconds
> + * @ioc_status: Pointer to return ioc status
> + *
> + * A generic function for posting MPI3 requests from the SAS
> + * transport layer that uses transport command infrastructure.
> + * This blocks for the completion of request for timeout seconds
> + * and if the request times out this function faults the
> + * controller with proper reason code.
> + *
> + * On successful completion of the request this function returns
> + * appropriate ioc status from the firmware back to the caller.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +static int mpi3mr_post_transport_req(struct mpi3mr_ioc *mrioc, void *req=
uest,
> +	u16 request_sz, void *reply, u16 reply_sz, int timeout,
> +	u16 *ioc_status)
> +{
> +	int retval =3D 0;
> +
> +	mutex_lock(&mrioc->transport_cmds.mutex);
> +	if (mrioc->transport_cmds.state & MPI3MR_CMD_PENDING) {
> +		retval =3D -1;
> +		ioc_err(mrioc, "sending transport request failed due to command in use=
\n");
> +		mutex_unlock(&mrioc->transport_cmds.mutex);
> +		goto out;
> +	}
> +	mrioc->transport_cmds.state =3D MPI3MR_CMD_PENDING;
> +	mrioc->transport_cmds.is_waiting =3D 1;
> +	mrioc->transport_cmds.callback =3D NULL;
> +	mrioc->transport_cmds.ioc_status =3D 0;
> +	mrioc->transport_cmds.ioc_loginfo =3D 0;
> +
> +	init_completion(&mrioc->transport_cmds.done);
> +	dprint_cfg_info(mrioc, "posting transport request\n");
> +	if (mrioc->logging_level & MPI3_DEBUG_TRANSPORT_INFO)
> +		dprint_dump(request, request_sz, "transport_req");
> +	retval =3D mpi3mr_admin_request_post(mrioc, request, request_sz, 1);
> +	if (retval) {
> +		ioc_err(mrioc, "posting transport request failed\n");
> +		goto out_unlock;
> +	}
> +	wait_for_completion_timeout(&mrioc->transport_cmds.done,
> +	    (timeout * HZ));
> +	if (!(mrioc->transport_cmds.state & MPI3MR_CMD_COMPLETE)) {
> +		mpi3mr_check_rh_fault_ioc(mrioc,
> +		    MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT);
> +		ioc_err(mrioc, "transport request timed out\n");
> +		retval =3D -1;
> +		goto out_unlock;
> +	}
> +	*ioc_status =3D mrioc->transport_cmds.ioc_status &
> +		MPI3_IOCSTATUS_STATUS_MASK;
> +	if ((*ioc_status) !=3D MPI3_IOCSTATUS_SUCCESS)
> +		dprint_transport_err(mrioc,
> +		    "transport request returned with ioc_status(0x%04x), log_info(0x%0=
8x)\n",
> +		    *ioc_status, mrioc->transport_cmds.ioc_loginfo);
> +
> +	if ((reply) && (mrioc->transport_cmds.state & MPI3MR_CMD_REPLY_VALID))
> +		memcpy((u8 *)reply, mrioc->transport_cmds.reply, reply_sz);
> +
> +out_unlock:
> +	mrioc->transport_cmds.state =3D MPI3MR_CMD_NOTUSED;
> +	mutex_unlock(&mrioc->transport_cmds.mutex);
> +
> +out:
> +	return retval;
> +}
> +
> +/* report manufacture request structure */
> +struct rep_manu_request {
> +	u8 smp_frame_type;
> +	u8 function;
> +	u8 reserved;
> +	u8 request_length;
> +};
> +
> +/* report manufacture reply structure */
> +struct rep_manu_reply {
> +	u8 smp_frame_type; /* 0x41 */
> +	u8 function; /* 0x01 */
> +	u8 function_result;
> +	u8 response_length;
> +	u16 expander_change_count;
> +	u8 reserved0[2];
> +	u8 sas_format;
> +	u8 reserved2[3];
> +	u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
> +	u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
> +	u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
> +	u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
> +	u16 component_id;
> +	u8 component_revision_id;
> +	u8 reserved3;
> +	u8 vendor_specific[8];
> +};
> +
> +/**
> + * mpi3mr_report_manufacture - obtain SMP report_manufacture
> + * @mrioc: Adapter instance reference
> + * @sas_address: SAS address of the expander device
> + * @edev: SAS transport layer sas_expander_device object
> + * @port_id: ID of the HBA port
> + *
> + * Fills in the sas_expander_device with manufacturing info.
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int mpi3mr_report_manufacture(struct mpi3mr_ioc *mrioc,
> +	u64 sas_address, struct sas_expander_device *edev, u8 port_id)
> +{
> +	struct mpi3_smp_passthrough_request mpi_request;
> +	struct mpi3_smp_passthrough_reply mpi_reply;
> +	struct rep_manu_reply *manufacture_reply;
> +	struct rep_manu_request *manufacture_request;
> +	int rc =3D 0;
> +	void *psge;
> +	void *data_out =3D NULL;
> +	dma_addr_t data_out_dma;
> +	dma_addr_t data_in_dma;
> +	size_t data_in_sz;
> +	size_t data_out_sz;
> +	u8 sgl_flags =3D MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST;
> +	u16 request_sz =3D sizeof(struct mpi3_smp_passthrough_request);
> +	u16 reply_sz =3D sizeof(struct mpi3_smp_passthrough_reply);
> +	u16 ioc_status;
> +
> +	if (mrioc->reset_in_progress) {
> +		ioc_err(mrioc, "%s: host reset in progress!\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	data_out_sz =3D sizeof(struct rep_manu_request);
> +	data_in_sz =3D sizeof(struct rep_manu_reply);
> +	data_out =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +	    data_out_sz + data_in_sz, &data_out_dma, GFP_KERNEL);
> +	if (!data_out) {
> +		rc =3D -ENOMEM;
> +		goto out;
> +	}
> +
> +	data_in_dma =3D data_out_dma + data_out_sz;
> +	manufacture_reply =3D data_out + data_out_sz;
> +
> +	manufacture_request =3D data_out;
> +	manufacture_request->smp_frame_type =3D 0x40;
> +	manufacture_request->function =3D 1;
> +	manufacture_request->reserved =3D 0;
> +	manufacture_request->request_length =3D 0;
> +
> +	memset(&mpi_request, 0, request_sz);
> +	memset(&mpi_reply, 0, reply_sz);
> +	mpi_request.host_tag =3D cpu_to_le16(MPI3MR_HOSTTAG_TRANSPORT_CMDS);
> +	mpi_request.function =3D MPI3_FUNCTION_SMP_PASSTHROUGH;
> +	mpi_request.io_unit_port =3D (u8) port_id;
> +	mpi_request.sas_address =3D cpu_to_le64(sas_address);
> +
> +	psge =3D &mpi_request.request_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, data_out_sz, data_out_dma);
> +
> +	psge =3D &mpi_request.response_sge;
> +	mpi3mr_add_sg_single(psge, sgl_flags, data_in_sz, data_in_dma);
> +
> +	dprint_transport_info(mrioc,
> +	    "sending report manufacturer SMP request to sas_address(0x%016llx),=
 port(%d)\n",
> +	    (unsigned long long)sas_address, port_id);
> +
> +	if (mpi3mr_post_transport_req(mrioc, &mpi_request, request_sz,
> +	    &mpi_reply, reply_sz, MPI3MR_INTADMCMD_TIMEOUT, &ioc_status))
> +		goto out;
> +
> +	dprint_transport_info(mrioc,
> +	    "report manufacturer SMP request completed with ioc_status(0x%04x)\=
n",
> +	    ioc_status);
> +
> +	if (ioc_status =3D=3D MPI3_IOCSTATUS_SUCCESS) {
> +		u8 *tmp;
> +
> +		dprint_transport_info(mrioc,
> +		    "report manufacturer - reply data transfer size(%d)\n",
> +		    le16_to_cpu(mpi_reply.response_data_length));
> +
> +		if (le16_to_cpu(mpi_reply.response_data_length) !=3D
> +		    sizeof(struct rep_manu_reply))
> +			goto out;
> +
> +		strscpy(edev->vendor_id, manufacture_reply->vendor_id,
> +		     SAS_EXPANDER_VENDOR_ID_LEN);
> +		strscpy(edev->product_id, manufacture_reply->product_id,
> +		     SAS_EXPANDER_PRODUCT_ID_LEN);
> +		strscpy(edev->product_rev, manufacture_reply->product_rev,
> +		     SAS_EXPANDER_PRODUCT_REV_LEN);
> +		edev->level =3D manufacture_reply->sas_format & 1;
> +		if (edev->level) {
> +			strscpy(edev->component_vendor_id,
> +			    manufacture_reply->component_vendor_id,
> +			     SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN);
> +			tmp =3D (u8 *)&manufacture_reply->component_id;
> +			edev->component_id =3D tmp[0] << 8 | tmp[1];
> +			edev->component_revision_id =3D
> +			    manufacture_reply->component_revision_id;
> +		}
> +	}
> +
> +out:
> +	if (data_out)
> +		dma_free_coherent(&mrioc->pdev->dev, data_out_sz + data_in_sz,
> +		    data_out, data_out_dma);
> +
> +	return rc;
> +}
> +
> /**
>  * __mpi3mr_expander_find_by_handle - expander search by handle
>  * @mrioc: Adapter instance reference
> @@ -1223,6 +1442,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
> 			mpi3mr_print_device_event_notice(mrioc, true);
> 	}
>=20
> +	/* fill in report manufacture */
> +	if (mr_sas_port->remote_identify.device_type =3D=3D
> +	    SAS_EDGE_EXPANDER_DEVICE ||
> +	    mr_sas_port->remote_identify.device_type =3D=3D
> +	    SAS_FANOUT_EXPANDER_DEVICE)
> +		mpi3mr_report_manufacture(mrioc,
> +		    mr_sas_port->remote_identify.sas_address,
> +		    rphy_to_expander_device(rphy), hba_port->port_id);
> +
> 	return mr_sas_port;
>=20
>  out_fail:
> --=20
> 2.27.0
>=20

With small nit fixed, You can add

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

