Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB8DC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 23:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348536AbiELXsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 19:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238274AbiELXsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 19:48:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36C5880F8
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:48:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CLwVre024470;
        Thu, 12 May 2022 23:48:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eyFwNTGu1OxIuM/RjCVPEDouMZQjYTxVVsW8ZWnpHRM=;
 b=HOuPNWTcEMugkj4+uG6wRo4yJ0N7qsAuT+x8jz4hckdJ4cmfO+jWnPfNfWIaisCTG0aI
 hoZhwJY9QgdyrBRGThAooWwSO5VP28cNefirzDLwNT3JWsIG0j7aq1uJFHACzAK4qpB/
 tG8cPVkpwamm+lJ9eoSGqX9YD+JOko9uhBNuOuUUDavcpY8AE4rhxvt6o4OtG1aMyxPB
 Psvp1h0G2qw0t/ZHJfZlK7kvjotO5Pweo5qiN82BUuwIGcU72lg3J7e6XOn2fJc9vbHD
 Qdmun7gzTIRxp/Po2WmGoqq7vPBw3tGxB1OVJQVLIeMGgqNMR6b7ORWv3SDf+jUn4I+P Cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwfc0x56u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:48:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24CNjoYX016624;
        Thu, 12 May 2022 23:48:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fyg6ghtak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:48:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=USgl5znL/kySOhVRSNoDyN5bAbSA4sT2LaVcFFABxYL1aeMDlF5nwhdM4husuGrPMzEvr+LoHqjgs3l7jd+RGvwxIikQYOMWPbu8x/lwfEtF/vPC7UuipCovHWgmUzJY+kxsxQqjdzqt8z9beHVhWt8/RFtK3hPBUaI17EB/3AJQhoc1SJoBX4Znv8I4ZSw8wWPwQrrBVmYI5A/8CAq/G3sTlOUbHo7rn/qI74P3JSZviCCVj2gtaDpYIpRy3H6dVlYT/91CyBIddwZ3dJv+ggIeK01M1CGLK7OxBbKkVFJnp3Mhx3+mAO02XbuPqD+u8eWfXyh5xXh9rGdazgxsnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyFwNTGu1OxIuM/RjCVPEDouMZQjYTxVVsW8ZWnpHRM=;
 b=HAiRyb5+4dVl+hpw/II5PDj1xNmYKShAmEklhh9mFYmMgLc/kZ9sBtjDfJZ0jVMGGtI2GQLQG6nRS6j++GeEx5LAkZf/AwOz/XOM8nodF50hC35uOAbIHqJj5B6V17BheF1TQlZVi723ziIjGDMm7aFWEUQdSVPdOLUoKUap/71yCkiPY+zXb9Ym0/qc7shy4KcwSPqWJ90dCz0PC3b7San9aNZ+BmwHUNjLT0AMLX/azE4UG5HtZKLK/65Vwc37eoY7J/4b65MhBjSa2UTO5Jij3EGHyRl5vM7oGVXNpjM/ab1C5TnWmuAaK0FmoQ6GotCd0rrC+XAYuyCRUAK02A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyFwNTGu1OxIuM/RjCVPEDouMZQjYTxVVsW8ZWnpHRM=;
 b=toxHDtAebPSApDILQdtMjMLutK3ogltufz3+fEeR8fok3dEUcHOeo35DmFJQIJpSv5QIoXaffBg7r9xQ40i4FHafPSjaOkuBplS8n3JFgDA+P/vdWg1APh4wAOhy2IFHjm63CfN9sj1ZMFGwcOuBQrjjTV1D3NJPqLJgU61uTXM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR10MB1670.namprd10.prod.outlook.com (2603:10b6:910:e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Thu, 12 May
 2022 23:48:02 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 23:48:02 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     James Smart <jsmart2021@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: Re: [PATCH 3/4] lpfc: rework lpfc_vmid_get_appid() to be protocol
 independent
Thread-Topic: [PATCH 3/4] lpfc: rework lpfc_vmid_get_appid() to be protocol
 independent
Thread-Index: AQHYZKiurT7er7+4VEWAVmNCxRLDla0b7ByA
Date:   Thu, 12 May 2022 23:48:02 +0000
Message-ID: <6F0EC2B7-45C0-4833-972C-22190F5077C2@oracle.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
 <20220510200028.37399-4-jsmart2021@gmail.com>
In-Reply-To: <20220510200028.37399-4-jsmart2021@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e351d73b-a867-4157-b394-08da3471da41
x-ms-traffictypediagnostic: CY4PR10MB1670:EE_
x-microsoft-antispam-prvs: <CY4PR10MB167023BB078CF0752F47BDD2E6CB9@CY4PR10MB1670.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sEsck1iSzRoYLj1Hi7A9jabXmqfffmoaN+7papKma37ymSTydZ9VZsfc9TI6pV6BQForwVY5GFFk1OO7qBb4FG8zPFDIdMlDAaxJS0FkhgG9sctMaf8KG3yLJQT/gspXS2UajYSLBqMXbPgZCgSO2/l6NssKllmtIca3mlFux7UVfGgSbRGGtZcFLZBOJamF44JNwH5SxJW5TrzzlGUATQevR/2zr1r0V/eBvbfnqI/sFv1S8Nnnd3oljM62jtGxFCJQ+NJi9w6geCsdA/BQ6wSUUFh5Hb9EpdGj5moFyOn167/UgniuJ0+mHIykUldl7WxHmCUMFabfafnryh6ONqsmdRrczZevSpkAMPsJagJOS/gwq2wSYopYG4DR4oezPI2QEzxcWdsJn0P1auqHMOYFrkhywtX7J1NcZLm14RL7FC4krQTkSy/KbqA++3D2ZAuV4vXigAeswm3AOv443dIKMPAkLe7dmoqQNlkTMvZfFjpAXZ92MNKgh2xh9W8vW9taEDTksxqGksW27z3tGCgNFtRAgeKLvsFqTGKHvqBXBBNjjOxlVM56qMaPNtBF79DIXbpp9OYGHjo2n/fsx590buadH0J3qq69DaLzvbUo/Aj+nRAGo6H9jL9i6YBabpZPwfdewng5tnlVOhHAM8kays6msbAZLLiWoVvr5uo2esdUkty26YfxlOXxj9P7J4kPZjf0f0b/tAs5syzco4lF38bREQgLZ9nkNe7ANTsgD7oqEOSjkhda9IZMQhZ3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(38100700002)(2906002)(33656002)(44832011)(186003)(83380400001)(5660300002)(36756003)(6486002)(8676002)(91956017)(316002)(4326008)(8936002)(2616005)(76116006)(66946007)(66446008)(66556008)(54906003)(66476007)(64756008)(86362001)(6916009)(26005)(6506007)(508600001)(71200400001)(122000001)(53546011)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SiPEslLTQyJo7FVy7S0owZZhnHZxFZQdaUaGmnvCrlBM8c/nEUfZudpuEVl2?=
 =?us-ascii?Q?Vq4fVE/QExhhsy02aDcIV3ixEe82uDSbqDcR/uVsyBX0vbplt7oQPXUzBK3u?=
 =?us-ascii?Q?/MGmb3ns8tKZEo9TUE+3kMC5B5eUEJEwR1WGgMvzsOUULgo/fi4Ml2hPCRka?=
 =?us-ascii?Q?/LgrLqQep4PTx8z/bmrLvzvhKPpTmAnGOYk8WyJRGKAgysp/Wri0fC5Ery+/?=
 =?us-ascii?Q?kXooF45/DeWtElpxOau7ZmgXecJwZUZFD8bZ4iayQmbHGqaecsPa4cyYFhBI?=
 =?us-ascii?Q?XMA/ic4q1WbO4dg56gpbplMYEC8kLAZwE3ZP02MJcT89YBDZXcjXV3U7QflB?=
 =?us-ascii?Q?Zy97DhheNzgG5JUJLRT7F4azQJs/WWyb3Prky8ZOeqOoezEV6rijd7G2JIUs?=
 =?us-ascii?Q?6nwrmUlMpDUd1EvwGznT9OrJsOCEwObJBb3AbJKaHprMCzmTJtLi1xnb9Ky9?=
 =?us-ascii?Q?EV7HLMaWFahI5FkN9tpBjpGiWZQ4r9Q62b/v06MoRX1bT/599M5jP5dI01v8?=
 =?us-ascii?Q?/+sxxw4P33NlkBCkXpP2FQ/yDnBP5ECroFaQYBgz+TFX+60QK7/flqbQPx2c?=
 =?us-ascii?Q?ADbjwQxBL8qqf9Q2XczTW+FylkqcZULJcPf51ASV4BG9FPBv8NuSNiZ1CM/r?=
 =?us-ascii?Q?XVhOpreduN3yrMWfHw6a25skmNiQeCsJgkg/5RsAXbhY1P2Y7ZDddlwNgH62?=
 =?us-ascii?Q?mm8FeKbhlkI8NVnsqL67MRYNlF/goxlBvpcXMu1ztPZ3HwT6D9EeT9Rngrnf?=
 =?us-ascii?Q?NMe4BJWJz4aJTHLFg9Vqv+CzOdM399qSjbUST87e9gGfcZtQfN0uVciQykRS?=
 =?us-ascii?Q?rB7IQkDrzOSMjNH4JCAWk3buEOPdXBn/8j2CqQ9Npq/vUMG4UnQItbYfFOow?=
 =?us-ascii?Q?dSXBrbM09kbWD5xxK7uVICh1Rf2w1A+/5X5RiG/Z3h7OmKXsO39TD5b7QaBd?=
 =?us-ascii?Q?mlcSc2lTAkVxCEM7dtE1HjjjHDuodbuR+29lptELG4y7vFC/VUXbSSVRALQC?=
 =?us-ascii?Q?88nBZX2rZomnM0TdhLZI505yzdPMrsehcnsFrdO/bmD5UfFrcrYzJ7S5YMCQ?=
 =?us-ascii?Q?uvl0wso5xbmkLzCbHLq6ZaoYvZaBj1xt6/SDVZqethknYTKctDyewWNBhvyM?=
 =?us-ascii?Q?D0wrRjoSlB6kDR78W43JZmrP90RgMfatwWMRRq+awhOLh/v/RwI6DOXVJ8vY?=
 =?us-ascii?Q?nW4Ts9yFCGq3I+7Zs5cjF4FyyZw3srwYWQoTzHOCdGoIXwClhhcX2vP/s2Pk?=
 =?us-ascii?Q?1Q2JxtF7yYH0naaY7H8V6Eq9rJrcLPkP84Bw08TN6PHdkszXZINGDGHI6PFp?=
 =?us-ascii?Q?94DK8zAXhUKh9DtQ2pPMs8xcAdfP5thKieDi4/z6tIR1DpEMmBaCrp6H1VID?=
 =?us-ascii?Q?HS8jZ4G9QX2b/ZQtB/k7DAeTWu8ivATxIxGA+NXvjNnEVL+QFuX6WHKGTsN7?=
 =?us-ascii?Q?CErJ+vPUKyTjBH6uU4lBPiWPAUMkCFZB7+TimB3bRfM6YVdHo+9Q0HwJXrdV?=
 =?us-ascii?Q?QP5wKYtz+pM2eTx+ihV1YUKMDIbOMg8IspAjyOzCnGzmYDJJPHL4WSHVRIah?=
 =?us-ascii?Q?R5HnETMZshmgfzoEZEC3B6jAvxZ5pGT19VCpoZcCNSFyWr9x5H90VGCsP8Fy?=
 =?us-ascii?Q?sKhdbtjPBeX8GmB4qGiIR6gJq9BxyoPJ2s3YqXBHOzq6hY7PiFy/sI014tvT?=
 =?us-ascii?Q?QnXtQqjZlCcE7L4l9tWIYby2S4SYdK+xe8JGZgypdcxrnrRQqmp1xER+zgqz?=
 =?us-ascii?Q?RY8ZaJZfeV3eQQMAfNFMj3PZbCg67qXwufhMsLQKniZgAtA/yFId?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F396703BE2C2F45AA113852AF560BEF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e351d73b-a867-4157-b394-08da3471da41
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 23:48:02.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TXZHlBIF0OIptQ4vTtvvEe5OMQ3AntqNMtz5mmoaLVxY4sCQHBIb1r41aLxw9l0vPWoaeJxk9+ddWqXCT11XYsaUrqn/XuRblu7gqQ04r2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1670
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-12_15:2022-05-12,2022-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120102
X-Proofpoint-ORIG-GUID: B2ZA0okTGt6MUu9ct8gmhDMb4OaMEpsa
X-Proofpoint-GUID: B2ZA0okTGt6MUu9ct8gmhDMb4OaMEpsa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 10, 2022, at 1:00 PM, James Smart <jsmart2021@gmail.com> wrote:
>=20
> Rework lpfc_vmid_get_appid() arguments to remove scsi cmd dependency.
> It's now callable by nvme path.
>=20
> Fixup scsi calling path for arg change.
>=20
> Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
> drivers/scsi/lpfc/lpfc_crtn.h | 5 +++--
> drivers/scsi/lpfc/lpfc_scsi.c | 7 ++++---
> 2 files changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.=
h
> index 913844f01bf5..b1be0dd0337a 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -671,8 +671,9 @@ int lpfc_vmid_cmd(struct lpfc_vport *vport,
> int lpfc_vmid_hash_fn(const char *vmid, int len);
> struct lpfc_vmid *lpfc_get_vmid_from_hashtable(struct lpfc_vport *vport,
> 					      uint32_t hash, uint8_t *buf);
> -int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
> -			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag);
> +int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid,
> +			enum dma_data_direction iodir,
> +			union lpfc_vmid_io_tag *tag);
> void lpfc_vmid_vport_cleanup(struct lpfc_vport *vport);
> int lpfc_issue_els_qfpa(struct lpfc_vport *vport);
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
> index 70d0a4d3d92e..f5f4409e24cd 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5446,9 +5446,10 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct =
scsi_cmnd *cmnd)
> 		uuid =3D lpfc_is_command_vm_io(cmnd);
>=20
> 		if (uuid) {
> -			err =3D lpfc_vmid_get_appid(vport, uuid, cmnd,
> -				(union lpfc_vmid_io_tag *)
> -					&cur_iocbq->vmid_tag);
> +			err =3D lpfc_vmid_get_appid(vport, uuid,
> +					cmnd->sc_data_direction,
> +					(union lpfc_vmid_io_tag *)
> +						&cur_iocbq->vmid_tag);
> 			if (!err)
> 				cur_iocbq->cmd_flag |=3D LPFC_IO_VMID;
> 		}
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

