Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3C18C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiCISlE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:41:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiCISlD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 13:41:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BBC1704DB
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:40:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229GU5uk003070;
        Wed, 9 Mar 2022 18:39:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ISI4Dzjs3cJsUoGodmlQ+AiBQn2fA6J+rI/VcUk6R54=;
 b=R4olVW/eRhzca7Lfn1Ia1ZG5PSA2ySzQOjFnZu9ICihMXnUNwXgjw9UmdKS+4ESOz0or
 zLU9X040C5QZUETGLbClZzghFKJ6PfXQm8xH4QBMoMyEP7aswYLedmJE5zPrkU1JO8Cf
 hClD7RdzwWClrL5LtENGXOFSpmgA/dHEWecVgOy2v6Mc+SaBqE8HBbM9SY9viBJ47xJZ
 bSUK1GC9of0e8EtFZ9OUKzjpqRCWRwJANZuknIZqsYfyApKtwmVIrl7doi5VvqnhmC0o
 Ge+No1q/8I8COS+MMXCSpn9VCdg4bEIeNR1LhqP/4Z8O6Pgzni3qmcsH/UDsSBQjDqxm AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du35rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:39:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229IUUYQ073347;
        Wed, 9 Mar 2022 18:39:56 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3030.oracle.com with ESMTP id 3ekvyw2qf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:39:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCIzdq6l/NO4wJfbt4NtlgP9VCE/5zvHlJlX/9s7E19QoQcEBd4K0pphBcVJoXySLz4VNA/mKnjFDogdstNEtr/9xUU7MT7YFXPhyfXhTQwWIOxMpxtqN15JXk46yCIicbFAEc7HRLLbJQgtSEJ2c++CMIPH3ONOorW7uss0BpzEu500efGTUQEkkeF8exN+F636G4O7qROZmskE4+5UoL6h7+8+uN3b2vuTvk56NblFrXwnG60ZxDAGOoYSwBEU025zPa6YDViiiCdy/bQGGz8NdWRyi094Ha6nCWitMlhyJmuxeTFK4KblDAzH/A2XeDtEUVFbJnlIPlhDZSD4zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISI4Dzjs3cJsUoGodmlQ+AiBQn2fA6J+rI/VcUk6R54=;
 b=FfKuSPIyAlkFNqeVjkSqqI5KBJsVnIRC3r1/0XJ6lfEGv6DULVt4gjypGG6Qp5Fv28HdZNMx+I6a3XR6761//xPeeWGee2sBUCW+OgUPl9FA3vB+MbyiBbj2xRndVMCK5We2Rmi2znjFkKUA/Y343QYMLhYVjCA6/P7EdbnSxMo4VkShe+O9Zltxl2vvzxkaDwxL++L09hiBDUMpiU6QC7dAjtxe3NmAzjTN9h9jgTBNIDqd8RJUYaXZBKid4rwi/p9WBjlMhd3zsQLAqaNryG+UncR2VODAPrUM1MfLp/J/9Fw+GE0LDFd8WCXAnrU/r3noYgy77g1yM8u9GMKxxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISI4Dzjs3cJsUoGodmlQ+AiBQn2fA6J+rI/VcUk6R54=;
 b=S6pB3ud7AQ93ajw1suW10JweuRPXnrGZXTsGkBnc2q8ukpUT/omjyr0MmamBdNL47pV3sBP7cBtlEdblzWdMMf7a4julScNBRlg8ZAq32MGTiUpVRtA+Vup1lIAgkZHQ210lC3tlahrTcQ7P13wUWdBD3+0lW0mg6GtuY5ULMwY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3721.namprd10.prod.outlook.com (2603:10b6:5:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 18:39:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:39:53 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 03/13] qla2xxx: Fix loss of NVME namespaces after driver
 reload test
Thread-Topic: [PATCH 03/13] qla2xxx: Fix loss of NVME namespaces after driver
 reload test
Thread-Index: AQHYMsV+JjswdUCCUkOmMcDVybAjT6y3ZJUA
Date:   Wed, 9 Mar 2022 18:39:53 +0000
Message-ID: <2B529B73-9FFB-4E14-AE2E-1D16FD0F8CE9@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-4-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f563ee33-8593-430d-8606-08da01fc3367
x-ms-traffictypediagnostic: DM6PR10MB3721:EE_
x-microsoft-antispam-prvs: <DM6PR10MB3721C7C1FEDE33E18B11A910E60A9@DM6PR10MB3721.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MPyXXlwrA8L8G3dZ4yFvYssD93F3R9H30pQU94rTzw8b57MeP6QGNS+GFZBdRAXlRl30ZMXNxyv89K/zMDT5/anulZtIoqdYfRIkHBuLhf6DwrfmrjnNT8QOcEmS4tLqHF4wVwpry4WodE/9270dHc5NbUC/HUZN3FImnL4NpLbgfV0WJVX8KQjuhtvx3ssvdQLsc9SdPxLiTEMK4d5svAplLVYo1+bQvDFRtDCIa7aYESAj7YhgYaHT/ojmw7BhVgZAns+tbV4AcDd8h/RXNUDEfKZtKqmQt7THUMFi4uFSUXEl/Tqvbx+oPG5xM7r7MUixXPKyvzJSwR970RcvtYqkJHby0Yk82pLMVlBNKR58nQMsGx9bwMxga40CwFwYYoeE9j4IbefvTFzeWysc+FxYXwHfZ4+A0qaO0sHADViH2AX3ogEjnNC1ByOYt1j8hfr7lyh4+lj3WIVJBjJxxNrHY3n2salMqVyNQmDJfpTSGgYMDnpkhHvdcrWy/bJQn/kKHNbJsqTugadpIq7K7U1riswW4cTvxI8zMU7JfW96XONq0CgLH/lpT4nxy4ECGGqTZ/H6k+QeFZ34jhf10r2cR7rUOyFFnATy57Z7jELkmHYxKoWo2C2DJ+hvxzfMzgJeyiVi9tS347iCJjDkPvhntVYYjCm/AaWv8A/j0aFby0p1AxZLI81eLuDxYbt2VbVQRbA/h7pNnhascq3x4ziP2C22VNOdt/3IABCCgl7+E971HTEc19rgLU9ysOJ7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(316002)(6506007)(54906003)(33656002)(6486002)(508600001)(2616005)(36756003)(186003)(26005)(83380400001)(6512007)(66556008)(53546011)(91956017)(4326008)(66946007)(76116006)(66446008)(66476007)(38100700002)(8676002)(64756008)(2906002)(38070700005)(8936002)(6916009)(5660300002)(122000001)(71200400001)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PXl2vUh2CEU0IBWHNMeXerORXjcS9ccGoNaTQNYibj0E+9jh+TUdZEATBYSn?=
 =?us-ascii?Q?rJgfF8kVqVJZ06mJQtMUX8ut9hR6SyhA7bnDEQALUZDgKxiKG09VUZwe/pXP?=
 =?us-ascii?Q?6MHQu2zIgBmyyCSgC2vUDEoRsOHQ9PTvW2UZ5e5rlnjh+2PVQlwrJTxZgBVe?=
 =?us-ascii?Q?Mu/ildf7rOPqifPptNuGGU0mi4lXhMUrNHy6LTTiGhIYaZqJE0wLZ3vGXriX?=
 =?us-ascii?Q?cjOIepC6hjEff3ZHngT5DSLxVVWSUXnhwillIxVHD0mZu5WjrXtVFVZ5RFbm?=
 =?us-ascii?Q?6BrohZXZT+U8BnnVbXrQT1K5i/u6/+bx2ffG6OPlLsBpY+ks8U2kP0OBe5yq?=
 =?us-ascii?Q?3IqvDcZ9yaB1vkyufWwYrtUtQRFeEGUrOWcEcaXJNsIWmtAXA2PquDXIlhuQ?=
 =?us-ascii?Q?UplM4dBMeLdGTD4WVM0FujvkbS/Rjogy4C0oqEJDWZeZHci3DI3WdBlXOrJ3?=
 =?us-ascii?Q?GKJKodaPP1xgGcxyNNVsuAMUAmErWqoMG71EACAnq2X6NPh2NetapAKaU0Ft?=
 =?us-ascii?Q?rUm8LcES4decGc107GkqSUtLT2i+INHWGO845RVJ0QL7JvJHT4fBub+W9XTM?=
 =?us-ascii?Q?rPxBG8wuMVporhTajSBawsrQLkAIIh7dJilXcyfvcoKg++BB1yBC5Fu3HZU7?=
 =?us-ascii?Q?JjvPUaiqu9uANCGdDMuWiWyysCPVqaHFH/RdXvR8xCD7gueV7QpYR8O6VEA0?=
 =?us-ascii?Q?L7WRfA3s4KmSHCfeKo33b8w+cvoV0L2GEnu9LR7VPGUjUZX5N1oa+F/cZaRP?=
 =?us-ascii?Q?HiQ0fFoNJu22s3pKvMzDtNzr/exQdJyIpHkzZO4QGK1sx8GUemNAiNng17/i?=
 =?us-ascii?Q?XPUJUJUpUNzQRE3PXu1KiVM1BJWEe2uoYP7RQSwYZDYSCuJET1RAeAzFcK1Y?=
 =?us-ascii?Q?iK6xEtmp46ydF79Rgd//c/24ctHowmPFbNb+jnKpLdRARxs/+4NQcxTNK0Ab?=
 =?us-ascii?Q?ukH98pCLXWCkAadaZvNMJ5grp/R7k5spOLz9ankPjZfCronFW8rBe1zAs4++?=
 =?us-ascii?Q?B3x+Vy+I43glNNbt7SiEtRRA0QAxCOjSEobBFOzDrLirZ52/7RltQDBgmEA9?=
 =?us-ascii?Q?9RdPEJTWm2jPG51a9L87PRZOwyM7cm8KTb97DVRAxk99GpeQRlhX7Aqena32?=
 =?us-ascii?Q?gbhG2EHzWjl3MJuuFUHewD4qhjnI7rZJul3BeTQrMfFPieG/20voLEec0Lxr?=
 =?us-ascii?Q?a0g7LpExQozL9/m8Ltlrum9nd41/TnP8fCR03Q8tg0cOu+Nfn31VOANwdo13?=
 =?us-ascii?Q?0LbxfWGyczZ+AdTG+mEYf7Wjx8s/pMKlXrDMVa40UGMtUmQnTCFSsnhviD4B?=
 =?us-ascii?Q?B0j+b+4JqjDzBnTGF0c8ttIO+dywU6K33rttTL0+wZBITs/Ht+jacDCGWt6r?=
 =?us-ascii?Q?/RJ0zhkeLMCvXs0y4F0JO8o+aofqKaiwMkXW6b4HSK1mL8isJZQSLHhhN/Uf?=
 =?us-ascii?Q?43pARKg14KYzxx31DU6qlmcxNxFCm48taoeJ9u3CyWvCBFpFX/SBZamkYzHi?=
 =?us-ascii?Q?W5Lkv8O+e3ZSyr+l3FdG5HBEszmF/bRsjnHAIfhQ0H+phxPQSJ/xCvxWjkJN?=
 =?us-ascii?Q?2ZPs85zD93ArmFdN8NH8sIYPkLhx/yUomv/XytuMYjFsjoqiD77x5DVHUXIZ?=
 =?us-ascii?Q?E+SG6zJijFPkz2P+FZj7Ohou2k8K99LYnjpac0pTIhFPhCocwbOFkmgBW/i6?=
 =?us-ascii?Q?Toc7XQIx5nwTUEByJn3tnAVEX9g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8C544824B1E92D4ABD38A66E77CCC1DC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f563ee33-8593-430d-8606-08da01fc3367
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:39:53.1217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etNmzlE3/+eNWW065udEV90e7lxkhXhS1LrOT0YwS5pCmxNfoigiawPQBJWNV2NJj2VZ3WVpzK+OIDVFPzacoZooDh4e3SfMAV+JSz6Vc50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3721
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090101
X-Proofpoint-ORIG-GUID: _5--5AFGxlwj2C9o_xKUIXvfAshSMVtA
X-Proofpoint-GUID: _5--5AFGxlwj2C9o_xKUIXvfAshSMVtA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Driver registration of localport can race when it
> happens at the remote port discovery time. Fix
> this by calling the registration under a mutex.
>=20
> Reported-by: Marco Patalano <mpatalan@redhat.com>
> Tested-by: Marco Patalano <mpatalan@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and t=
ransport registration")
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 30 ++++++++++++++++++++----------
> 1 file changed, 20 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 5723082d94d6..3bf5cbd754a7 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -782,8 +782,6 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
> 	ha =3D vha->hw;
> 	tmpl =3D &qla_nvme_fc_transport;
>=20
> -	WARN_ON(vha->nvme_local_port);
> -
> 	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_H=
W_QUEUES) {
> 		ql_log(ql_log_warn, vha, 0xfffd,
> 		    "ql2xnvme_queues=3D%d is out of range(MIN:%d - MAX:%d). Resetting q=
l2xnvme_queues to:%d\n",
> @@ -797,7 +795,7 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
> 		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
>=20
> 	ql_log(ql_log_info, vha, 0xfffb,
> -	    "Number of NVME queues used for this port: %d\n",
> +	       "Number of NVME queues used for this port: %d\n",
> 	    qla_nvme_fc_transport.max_hw_queues);
>=20
> 	pinfo.node_name =3D wwn_to_u64(vha->node_name);
> @@ -805,13 +803,25 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha=
)
> 	pinfo.port_role =3D FC_PORT_ROLE_NVME_INITIATOR;
> 	pinfo.port_id =3D vha->d_id.b24;
>=20
> -	ql_log(ql_log_info, vha, 0xffff,
> -	    "register_localport: host-traddr=3Dnn-0x%llx:pn-0x%llx on portID:%x=
\n",
> -	    pinfo.node_name, pinfo.port_name, pinfo.port_id);
> -	qla_nvme_fc_transport.dma_boundary =3D vha->host->dma_boundary;
> -
> -	ret =3D nvme_fc_register_localport(&pinfo, tmpl,
> -	    get_device(&ha->pdev->dev), &vha->nvme_local_port);
> +	mutex_lock(&ha->vport_lock);
> +	/*
> +	 * Check again for nvme_local_port to see if any other thread raced
> +	 * with this one and finished registration.
> +	 */
> +	if (!vha->nvme_local_port) {
> +		ql_log(ql_log_info, vha, 0xffff,
> +		    "register_localport: host-traddr=3Dnn-0x%llx:pn-0x%llx on portID:%=
x\n",
> +		    pinfo.node_name, pinfo.port_name, pinfo.port_id);
> +		qla_nvme_fc_transport.dma_boundary =3D vha->host->dma_boundary;
> +
> +		ret =3D nvme_fc_register_localport(&pinfo, tmpl,
> +						 get_device(&ha->pdev->dev),
> +						 &vha->nvme_local_port);
> +		mutex_unlock(&ha->vport_lock);
> +	} else {
> +		mutex_unlock(&ha->vport_lock);
> +		return 0;
> +	}
> 	if (ret) {
> 		ql_log(ql_log_warn, vha, 0xffff,
> 		    "register_localport failed: ret=3D%x\n", ret);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

