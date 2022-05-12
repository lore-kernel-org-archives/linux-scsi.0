Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84091C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 23:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359648AbiELXuT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 19:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359640AbiELXuR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 19:50:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8EC289BF7
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 16:50:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CNIvvr017478;
        Thu, 12 May 2022 23:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dN39/ROhKsSFMu1U8q1/J6PWEK8IqzL5a03QwOCVff4=;
 b=YtMQwVudywQoeVhwhfxSdsfDmnD8IQpYY6q8FOFdRgMtBNSGzQErsZgnGYcCJfpy3Bog
 HxkAGwsOAlBi7hAPofzH6iJWg4QtS6faITiwI2a6qUv7jTFq0340rvCtjATnU+DQwPd9
 WjDehJIiM0b4mlDHzqcC2Re6Cz2Mrmzh3CprFrdikq6Oh1gGbNQUcAZ6MgiSvC4KPYrp
 P5y5ONWCSdqlFupj3WracJ511xqlQ2N2i+DhQhz+hFKlslFdQtUeQzbWOGPy+RKg97n/
 MOQoWIXlkxnJmn5ucVeCtrDB2KRkKNW9L+1oAZzDOrTG4DNC6e3CNyc111xLss+MFgTD zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwgn9wmuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:50:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24CNjYvf030564;
        Thu, 12 May 2022 23:50:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf75ddvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 May 2022 23:50:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRnxECsBJTE1JJjRBFtlU8073SyTN8vj46jQWdSabix6L69AY8qj1U8wj4Ff6Fr7YvaEZaAzO0aMgpT+3UZkJ1SV0dByH/Ofu1CGKXCpJQd1OW7bxVKD1s9+hMEw1dYjHio4evg6+9WWAqdgOiMmf4En756sdL210Q9oHEvdJGzTVElC6kXTzAO+jb57YAHoNmt3jlqPZf7xdRxIltopW09E4JXUpo1N3yfP8QX9TGZqhPf/sUcK6MkBNKjVEzVD//UDK5nhaAGAH+EEq/VcVn0KlUacYEg5o3V6bahpqhzbjzV9vwh9Mc8GQRR45tmnDIDnXLAJQBra3wdMYbwxuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dN39/ROhKsSFMu1U8q1/J6PWEK8IqzL5a03QwOCVff4=;
 b=Jf+2Z2/iuW6kRFAEWztUYTWG3jyjEHG4Gr4jihu185IyYcRyb2jlfPyYaa0DuAwBrr2QbBODdBeerhAsUKIvVNu+lMlMW3gKSnfooIPmhIoK+1hLtLUlliteThaLtDbq3YNcYUPlkmGdyLMwLyYNvm9F9smuElM8fyoQjiSrBEhwCrd6KJ281XxognIG77UWg9VlhTPpa7sKxJ2lSt7Qyx+TxdF6ctngfBmI/uyXSLbsqnZhme80Al7akO4BtDWZj/rj/16r3JPGYhJuwjMvoZmYmJ4E1mkHybUlUWeW1fv+mU8wkcxLs7w80h5V5RNlrCp4g8L3tyhjXE5nuOcimw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dN39/ROhKsSFMu1U8q1/J6PWEK8IqzL5a03QwOCVff4=;
 b=Gvw841YaU4oHxx9TyEwkEdn2/epqYCzcMGQN5P0uYgLWK51vdUgXF81JvxHSBrSp5HTubFhYbpzRBAOc32WeoFmg+O0QqBQtWFa7yBgR2wXwVcQyYny3XSFoegaIZuG1qZRSFuqXTHvfOghf5d/Fv2xrYrr6YPAx4rXjqWjzyUg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4745.namprd10.prod.outlook.com (2603:10b6:806:11b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 23:50:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 23:50:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     James Smart <jsmart2021@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: Re: [PATCH 4/4] lpfc: Add support for vmid tagging of NVMe I/Os
Thread-Topic: [PATCH 4/4] lpfc: Add support for vmid tagging of NVMe I/Os
Thread-Index: AQHYZKiozQocLuEjJE6jXswkJQd7oq0b7LKA
Date:   Thu, 12 May 2022 23:50:08 +0000
Message-ID: <B016AEDB-EC82-4FC3-BC13-25C25F10D7CB@oracle.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
 <20220510200028.37399-5-jsmart2021@gmail.com>
In-Reply-To: <20220510200028.37399-5-jsmart2021@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 13130540-7977-400e-3e98-08da3472255f
x-ms-traffictypediagnostic: SA2PR10MB4745:EE_
x-microsoft-antispam-prvs: <SA2PR10MB47457471CF4968F97D172985E6CB9@SA2PR10MB4745.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dFkkhQlYGF1J7cxYXutDW8jMdMJFtkB6Ymv13C9fzjus/uQa13pgk1KKzci+7uSzT3um7GNHL1/3XozFnJdKN5wqI4iQMmn7bYZPhvGSL4zdbvWB1buLaOEpT8hn/3b2pRVIQa/cdayeT/aV6FPuhXGUYvUFeS2NM65ZqyhXPgv8acSLE6LXi+j5/eNDnl0srAx2s/urjV4+xQGpcXe5bu7KwO3q9R5TC0uRuffsyLxGK8t4V0zjmYWP+V3YJ0KpdVAA0xGwoX5agQ+HdkiULxbhYkNN1G38jMd4gADvVPIoN76xBPH6D7O3Y++CfjHn1KGb+66vZ+sPt99UA7tVsjhJI3PLkFl9beqvsdpRQuXAN4wrd/oWDzn2FWfTqzIYE5+xD/EC2Or/EacaOUQ5QgXeAU971zbFsX2yWLV0gSiZHXO4K09bSKJlZx5a205Whkz51LFNN8c5S0COXArk6bJ7GAORJhAJUNcyh8jaeNf1yR1dXGQvgGhDzmIXroeiyRut6sx6GB+GcVF8gUW2ZxXAZvAJrawP/4hXJCuxxM9oY4W9KjTSxHq38lfvAfHe/+cClBCRrDIdnWMHIL0y8wWxHSbDKspnOXAezOfLgp/CHPyYQYi/Af8E0gwiouQKnnEHi5kAOkZkWNJmbWUmdUAcV19fIIWAAmlKy4S8F9z+rUNEbPTB0ujSoT8gJXZ59OuiXT6OGHFlkaegfoT5n/VbF+U5MGixJ+TZASv60eT7kJNRgc0KJy3e+qXZBRqo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(26005)(86362001)(36756003)(38070700005)(38100700002)(6512007)(508600001)(8936002)(83380400001)(2906002)(122000001)(316002)(53546011)(44832011)(2616005)(66446008)(66556008)(8676002)(91956017)(64756008)(4326008)(76116006)(66946007)(66476007)(5660300002)(186003)(54906003)(71200400001)(6916009)(6506007)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jmXY/WudrHe14AxmcqQW4ZIFeeBuM71869f8JZbR5DfduX2zv9jNZw43KZWk?=
 =?us-ascii?Q?CtESH3hW17UXYXXb4YwT6mDA6hiCRDN2+HHNJyFKIo5eaIFTuFKm9+stJre0?=
 =?us-ascii?Q?eOZq1Q57c+cjAZfKKV8TpFJ/RTvdFO7eP4mEq0n29Kf04IPHcYgOSjnZfKqv?=
 =?us-ascii?Q?fwZOeNwH4gHzSr+dXbUvTIZUdAZ8tdAU+ChZkvqqtUfva/enBjsMMOrF13iX?=
 =?us-ascii?Q?ehwVuydTCrUtCM6312pIfBgGGOo/XDzoRrVWJwUm365jtTKlTGwumry3ndA0?=
 =?us-ascii?Q?kIVW1zHg5JSXlkBvh3QlA3MRUJ0PsIXdwDBTbGBFcS6XJnINbjoSseTmlb35?=
 =?us-ascii?Q?OHZ4e0mSOsNZGcSAB4/O7B8HaC1u578y9lquIa0aEU1sQSIXP8vSJUffT7Hd?=
 =?us-ascii?Q?MbCZkiDUOFYpA+MKXb1/JjacDV8CpDIOTUE/yJD9CE7qlb98FAp2K7u8Qbjv?=
 =?us-ascii?Q?NxPDWvIbWyV2XHuIPtx72zS+6N85ML8qD3AeEBLPQ4JBVP4murFL5RZQaMmu?=
 =?us-ascii?Q?IuwXb5fltC/arAvyq87ZSc35tQExs6ToYyOOoEQDAcAY3lG1S4h6LpRJJzzZ?=
 =?us-ascii?Q?mRs/cePRz6nigHd2EkS/lGe+WpCwA/Iv48TMxEgN3j1vISo/KCmFSrvnKlQk?=
 =?us-ascii?Q?vklBiAn/PpmtQrbk7l+rWOye+C4XcCo3QXxDkHaXK/YSPDDyMvanwKkx/pcy?=
 =?us-ascii?Q?ldhUt/mcPQkh33BYwy7wcDh0fI/I7MchyIeu+b4JpFyXpKwiD/pxtrCC5uuz?=
 =?us-ascii?Q?5SUN1JVqiSlainjC1K6IcBifk1NWbB7gZ4Ubcbz4XumbEeZoaKd3d6D6GEXp?=
 =?us-ascii?Q?3pMXWg0E66ielxeaMKZ2Qaw5l7k8uiBstg57yGaukJCUfWMcdkU1uoyo8rsu?=
 =?us-ascii?Q?wu6s3o64M9BS2z8mlBzTafYWZ73MIECYx3oRXS3BuM6e4ZzqKrsm6G/N45I3?=
 =?us-ascii?Q?/PRn1J+oQsI1RhHK8v4qMIuAChUu9mJ9WekfpJbXgAGKA3mt7yqQC8jmuHku?=
 =?us-ascii?Q?v1HjS8HmIktLSJdLxHzIWPFNgMMfUhoAZx+BcgMBSyEYH8aeiMZPGJXhrilN?=
 =?us-ascii?Q?kvIqa9t3ItggapKZirT3dyd7gRYxxoxx73GfrkpPdS5BcCT/gwYmaIHq25dx?=
 =?us-ascii?Q?vsAuo5yh31piFXE/p7qYoFrU587jfpFsRIhsVEdggQ6dah9k6NSQ5AAOvyY3?=
 =?us-ascii?Q?TTLE+/8/2J5Y1v+Wnb1/bt+L4jKz3dObpykJTUAeUoKXzbetwzozOhI2WNrB?=
 =?us-ascii?Q?RWrAUGNrm8RrPB7OQ/x/aFnKzLx8zdd6F1/fp0Voa+sNJQuUJDWGDZnQPvbl?=
 =?us-ascii?Q?irrJqnehBi+1XEIBBDsl+GgzFZyrvz3ft3tUTBnRumPOEjHN2KQ5C/Csc6zX?=
 =?us-ascii?Q?ceLWpS+IXzdJYt4VqFRlfapHuiDmcFlyVkXA0kiSYH4lMAkw/AMjr9sZX/2v?=
 =?us-ascii?Q?tOeowmiHBoIJfhlYfCNh/JA9jfMA/Faa7sPwqlx5C8m94hB3C59Wa3FaA/CK?=
 =?us-ascii?Q?EXn263Q4+MGaC4g7Uhi4rTAiv+wioLfP6AsOPS835p+XZN6TFHYUuQpxgev/?=
 =?us-ascii?Q?z0sWxpsf733kIqTqiQ4pcFBqPI2Me1flLudOfk89Um6XcKLMbxGuuBM5PUIC?=
 =?us-ascii?Q?A0jbVeuNOWJ8m19FV1EZRKrUICFejs3v+1YYT0rQBFwTp+9pimDGaAqXSLZp?=
 =?us-ascii?Q?nnjmyvjjzLV3Ei/RmlgnM2j8UHqGQGwT7m5CzLejkKNFVF3eXZXWP5Agchxf?=
 =?us-ascii?Q?avglDcFQws2byr8iO81sh6pjdYoU+TRK3/MiH0U0SOZy0xjQsEqJ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <579702C8B16AFB44AA68D3198E97A559@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13130540-7977-400e-3e98-08da3472255f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 23:50:08.4105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RDnsyqj1V72IU+hiF4fMunpzR6UO9JQgfkJJE+IAKq7yx5rBJygRojS9UesXXBmZtwxpBF+ZAtfDbi6njAb4AJOeF3zmEGytIWZMJKNWdxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4745
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-12_15:2022-05-12,2022-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120102
X-Proofpoint-GUID: TAZc5AcqbUSFurHEF59F9H4tt4vzDsYl
X-Proofpoint-ORIG-GUID: TAZc5AcqbUSFurHEF59F9H4tt4vzDsYl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 10, 2022, at 1:00 PM, James Smart <jsmart2021@gmail.com> wrote:
>=20
> Modify the nvme io path to look for vmid support and call the
> transport to obtain the io's appid value.
>=20
> Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
> drivers/scsi/lpfc/lpfc_nvme.c | 45 +++++++++++++++++++++++++++++++++++
> 1 file changed, 45 insertions(+)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.=
c
> index 5385f4de5523..335e90633933 100644
> --- a/drivers/scsi/lpfc/lpfc_nvme.c
> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
> @@ -1279,6 +1279,19 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
>=20
> 	/* Words 13 14 15 are for PBDE support */
>=20
> +	/* add the VMID tags as per switch response */
> +	if (unlikely(lpfc_ncmd->cur_iocbq.cmd_flag & LPFC_IO_VMID)) {
> +		if (phba->pport->vmid_priority_tagging) {
> +			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
> +			bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
> +			       lpfc_ncmd->cur_iocbq.vmid_tag.cs_ctl_vmid);
> +		} else {
> +			bf_set(wqe_appid, &wqe->fcp_iwrite.wqe_com, 1);
> +			bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
> +			wqe->words[31] =3D lpfc_ncmd->cur_iocbq.vmid_tag.app_id;
> +		}
> +	}
> +
> 	pwqeq->vport =3D vport;
> 	return 0;
> }
> @@ -1504,6 +1517,11 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port =
*pnvme_lport,
> 	struct lpfc_nvme_fcpreq_priv *freqpriv;
> 	struct nvme_common_command *sqe;
> 	uint64_t start =3D 0;
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	u8 *uuid =3D NULL;
> +	int err;
> +	enum dma_data_direction iodir;
> +#endif
>=20
> 	/* Validate pointers. LLDD fault handling with transport does
> 	 * have timing races.
> @@ -1662,6 +1680,33 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port =
*pnvme_lport,
> 	lpfc_ncmd->ndlp =3D ndlp;
> 	lpfc_ncmd->qidx =3D lpfc_queue_info->qidx;
>=20
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	/* check the necessary and sufficient condition to support VMID */
> +	if (lpfc_is_vmid_enabled(phba) &&
> +	    (ndlp->vmid_support ||
> +	     phba->pport->vmid_priority_tagging =3D=3D
> +	     LPFC_VMID_PRIO_TAG_ALL_TARGETS)) {
> +		/* is the I/O generated by a VM, get the associated virtual */
> +		/* entity id */
> +		uuid =3D nvme_fc_io_getuuid(pnvme_fcreq);
> +
> +		if (uuid) {
> +			if (pnvme_fcreq->io_dir =3D=3D NVMEFC_FCP_WRITE)
> +				iodir =3D DMA_TO_DEVICE;
> +			else if (pnvme_fcreq->io_dir =3D=3D NVMEFC_FCP_READ)
> +				iodir =3D DMA_FROM_DEVICE;
> +			else
> +				iodir =3D DMA_NONE;
> +
> +			err =3D lpfc_vmid_get_appid(vport, uuid, iodir,
> +					(union lpfc_vmid_io_tag *)
> +						&lpfc_ncmd->cur_iocbq.vmid_tag);
> +			if (!err)
> +				lpfc_ncmd->cur_iocbq.cmd_flag |=3D LPFC_IO_VMID;
> +		}
> +	}
> +#endif
> +
> 	/*
> 	 * Issue the IO on the WQ indicated by index in the hw_queue_handle.
> 	 * This identfier was create in our hardware queue create callback
> --=20
> 2.26.2
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

