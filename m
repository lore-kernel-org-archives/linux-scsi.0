Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86A1C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D47613C3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhDVQue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:50:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbhDVQud (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:50:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFSBPK023174;
        Thu, 22 Apr 2021 15:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7bEzYuPvXA/U46XtWBs9b0vcX8nGK/YiiZa9AZcC678=;
 b=n1B7XimcxbGhfgdPagO1bSfIi/wbMRJJs9YoCmBdfCfSzcX+ZOC6IeMUJt7R8/aHS58n
 SEcWljRvhYGPdsKmLoBEnokC/lWgDlORYSzlYyoAcRF8cArn2VDw5ewJCZzNvU1eBpCO
 WtaAsw0Uwd9T0yL3wC3ga8tNCklBoslnKPwCYgEceirPaIfUop+pQz2chNYqrU+NdfpN
 ve3j0R4pRx7xldqs17JkigkV2d/osMGTTtaM8HwXixUI96Ignl++3YVnsjSkisHVV5i8
 nHvWmnLivdspSm1T1ZHghPM1K8urDzw/xugEEI/Ua/Yo++NH+I2SLIP4N+MRKO+WsuL5 PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y58d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 15:49:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFQGHx023871;
        Thu, 22 Apr 2021 15:49:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3809k3qnaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 15:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNJIKhiY5nDippdbiNEIupSCFxr0goqUWh0KON94oD64Y9sDiqnVf/FeEWeevbk03vB8NAKS6Ob8NvTjJXqvHBKy80g2r82oqS9cBVKa9oOjWXPmIZ75Q+5nc6VaqwIyEckVC5OVh/5AQE0tcrhqYADcIYc9+xARtcriTRZifNX7LUz07K9DVO5Z9ZnwzEZ1VhfVuMX7hj5AMoFtaz4TaIDhNurok7rfy5HOuoqMmatDxypflRgdIWEl/g0SFFYqajtqgycXSQrsYCblI+jQIQ0VnVq4ZXSXNhNCxrus3LBV5LOagpWd2HU+KnWus8dLln3TNtXoUanXtMIO5mdNqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bEzYuPvXA/U46XtWBs9b0vcX8nGK/YiiZa9AZcC678=;
 b=RIG4NuskYk1YvS/QTsFTr1lga+fSR2dr8wApu2URROYlBYnF2w1jP9LnlNLk9t5Dur02qMjOSiYaOgBzlU8+Kbb9HDYz78DQ1VvAJiS5Rjkm5ReEEYZSLvc2yJEGb50Z/fkbJRzfXSWJN9vkrzEpwXfKND61flTYN/fCUbB8rK0fNPYbdSM5zNJOssWt6LuKzobRtBvsNWyRli7dZh7nIusfXxQ3uOYeO1NH3GGZQ7RPoFfLl+2r50aV5WcQHvogbKNBwuR5fpGdkarptNfTfApUC5AkCgXuTM1YzpfX7SP7Kte06IUgwc9bx3nGH+hHINNbr8+wZyDoa7b1WjWTKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bEzYuPvXA/U46XtWBs9b0vcX8nGK/YiiZa9AZcC678=;
 b=tjjBwQtebxtl4X5Uh7pbOl2BKiyKZHLFpNhn6ox4BjfezZP+PCv5plaO8/klMetOiov5jtUEzEk2+MrHAuSbEvMR5Bgk7wbQX2gzjrzzkdCQ+fxjg8ER6k25IA2e5Q2lVDbNROZ4SINOmUwtRi13IwL4i9uNj7+E4BGsF8sqA8M=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2768.namprd10.prod.outlook.com (2603:10b6:805:4a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 15:49:52 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 15:49:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 15/24] mpi3mr: allow certain commands during pci-remove
 hook
Thread-Topic: [PATCH v3 15/24] mpi3mr: allow certain commands during
 pci-remove hook
Thread-Index: AQHXNQuS/kS1WV0CAkm2cs1+v6YXT6rAtCwA
Date:   Thu, 22 Apr 2021 15:49:52 +0000
Message-ID: <68EFAB89-9B68-4A4E-A149-AF60C2C7CFD3@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-16-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-16-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff62da0d-8e6f-409e-3e62-08d905a644ce
x-ms-traffictypediagnostic: SN6PR10MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB27684C8DF1632524AC571329E6469@SN6PR10MB2768.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YcAnwRDRBIATbR2qvq+rjN++Z13ZIAUWRH1qZ9ry/ycs+8hFxfTpxgOM8y1GW/wa9KQnTuotdeWTngIV0uR6G9BqS7jfrX8M9nR0QZYM4R4B5JbV2qju7K0NJ5brIlY/mL4mvo1qMcUYKAqLJhivp7Ev0Bn1bPfAhCcJh6Tz7GxrNVsoKIFa3ZFitHmwEGECHO0sn81CxvaQ9G8u8fAqucZA/YDQbdo/LMN+bJ/mgScRg5eEMNAVKxlOUYfcLiafAYmyRRarIMtU2wKiU/itRwtfN69oE50byesEDCoM8L16hlFpgIHRGh0X9/srFjL9VpNxWIgEReaOu6uwbNAix2zJRuhBa0R1DCex7N74pnjB2u7K7U/HoDKXAvRJa00pDlNJ5ElrWSi7TPkBuD5hUpkW/byicCZy59QJsA0fPa/+w0G/HsUtQuM09tLdfFcdtxcDiPoZ5nUBKa9VfPL/mLEq2Sj1bo8C4Zjj/a/2aKY3cgf6SInC+eR6fwSSNkdKOrpiXKeAJ1tPtzX7lN+q8cG3DzgQf0hh6JfcH7pXSvmSG/1n16lGQpjG1OXa0MtUH8Lob/SCxlCTZ9boNh59/l+EzG7RjU5KrXL5Ezw6Nfqif7ICQhn/1CS6w+KgDA6cnFJtEYZokh5Jz09sdeUqF8FD5gj9bXMmEvLFB+WCKYBbGLc4wq5uvWVUfSGESdTa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(64756008)(54906003)(71200400001)(53546011)(6512007)(6506007)(6486002)(498600001)(36756003)(66946007)(4326008)(66476007)(5660300002)(6916009)(8936002)(66556008)(66446008)(186003)(2616005)(33656002)(86362001)(76116006)(83380400001)(2906002)(44832011)(122000001)(26005)(38100700002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WlUU7dzyMvqlfOHebG4nRqWbafJjfzfATxk/adAkL7pjTTSow6EpU1x9cr0P?=
 =?us-ascii?Q?FQejQN/+3mhgi/j4ibEaaAF8sZk6SU2cuFB0BMGrXR65Cwm7rFbYNKsJp9m8?=
 =?us-ascii?Q?3AiNPYksHws6klw9QN3dDHzzobJGz+mGZ6Ynx7RC81peX47D8sdMDrGTsudR?=
 =?us-ascii?Q?Z+2MuwTqauuuDFQ8wy1e1KbZdyXc8F7k1IYyeR6zGvh0s+vZWS0J3avaQFQu?=
 =?us-ascii?Q?PsZbCZNj7AT1ptGRArSUDLY52OOvxrYSdRNI6fGYIvCy3RmGDF474hxyYv6B?=
 =?us-ascii?Q?EGKioeN4WP0fm6ZlfQuJn/LjUdniQi5Gt8i2i3+Qy1FdrRu61oK9vl4HnOHk?=
 =?us-ascii?Q?qeq47ilvFEaxJ9EfAZ7IbYS2EvfGajPPs7UXXjMn7NM/ETWa6KYHmntO5gHr?=
 =?us-ascii?Q?jVtK+lCSsPLl8vlJyzRev8VCDcFaiI3pSPr79ovfk1Eo5Hl+Uy+31Vftav84?=
 =?us-ascii?Q?Kn69FDOJ1bjZaAO8do+Qb1svS2mw2n3fVuKZ9NYjLrEkkIPSWBvocxf7ZpNz?=
 =?us-ascii?Q?m3Iy5w6lpsL7WVb/gKcOhyCBYQg8B5+qE4HjUM79zaGHHVDGvlkdCn4bX0bS?=
 =?us-ascii?Q?IJkbIYDatiMs+K+Clxx/SvgUJ4eqWIcK+cWDpagB5dMQvKCtcexuoIRMQ31D?=
 =?us-ascii?Q?97khYJoSFv134QBfoNb3CbyDEr+Lw7BA6iAHrAhO9tpeDB9odKiHB2QcZmV7?=
 =?us-ascii?Q?/zfQNYShEUPYfAz66p/3z2LKqspz0pVpOHfSM2F4tfR562072K6918odhzMA?=
 =?us-ascii?Q?ra4hz1aPIkSdLA4DStZu8Cntb+mLqVbX36d07X68Qmy4pRA1qTSNNIReV/qw?=
 =?us-ascii?Q?gI37oG5eUDlB8l5DDDeGE7UgBNpgypJXniu1Fujp3a6JBkgYYvFHfE2JaXoq?=
 =?us-ascii?Q?vJq93ffddwWCojpQD2yFsuAFMt9d19XxnS1Xy96+TcKn9AJ08lVRLn7oVg7T?=
 =?us-ascii?Q?Td5as/K2EetJn/mTCNAOZcUcMHHawq4+CgQL8gyNBngzQX9Hnif3Nm3FcNMY?=
 =?us-ascii?Q?WfPDgM9+5BfiK8HtsLtqG28Kn44SQ9E2AzqqkTa3jJOsbnXINLwTMCkOX5jz?=
 =?us-ascii?Q?A3jkDrpxpCUUbXTqOb/1ba4eBmihCD3dJLQxiJNi75MRo32P9CEOLryfe+52?=
 =?us-ascii?Q?jHryVfKCmuWEBkA3meSTXMU9rL0m7P0bv5fu0BgBZmiGOEWgHTf9fM2dSiw+?=
 =?us-ascii?Q?VOHdHwDYBO91SSVAfxWIq9I0qNiIJqoQ1cC7QisWZa1f3RriW3ydDE6CXefQ?=
 =?us-ascii?Q?BjCzEg3BDshQfF2gAyRFnkisabhxus/dMcBu+cArC1EeZISBYT7go2sW/Ep6?=
 =?us-ascii?Q?yGMmG1EP6T7qbxMaQQBfXtkQjQ05hl4IAJivGwnJkF1d7w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81279FF7CD8C1540A7951CBB0F64B631@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff62da0d-8e6f-409e-3e62-08d905a644ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 15:49:52.6403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEyY83LyBedGddnajnk1srr6aUxEnVnkYTg7sbDO4onLoZOw4chKo9uwAcAhEKGK8DugcJE6Pp3lrnewQW6cdTSqS7uNoaD/7XFy95H9Txk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2768
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220121
X-Proofpoint-ORIG-GUID: K5ut1QSxAqcNXOHP9oa_nfKZkaiAzLhw
X-Proofpoint-GUID: K5ut1QSxAqcNXOHP9oa_nfKZkaiAzLhw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> This patch allows SSU and Sync Cache commands to be sent to the controlle=
r
> instead of driver returning DID_NO_CONNECT during driver unload to flush
> any cached data from the drive.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_os.c | 24 +++++++++++++++++++++++-
> 1 file changed, 23 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 99a60e6777d5..ac30699c7d69 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2786,6 +2786,27 @@ static int mpi3mr_target_alloc(struct scsi_target =
*starget)
> 	return retval;
> }
>=20
> +
> +/**
> + * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
> + * @scmd: SCSI Command reference
> + *
> + * Checks whether a CDB is allowed during shutdown or not.
> + *
> + * Return: TRUE for allowed commands, FALSE otherwise.
> + */
> +
> +inline bool mpi3mr_allow_scmd_to_fw(struct scsi_cmnd *scmd)
> +{
> +	switch (scmd->cmnd[0]) {
> +	case SYNCHRONIZE_CACHE:
> +	case START_STOP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> /**
>  * mpi3mr_qcmd - I/O request despatcher
>  * @shost: SCSI Host reference
> @@ -2821,7 +2842,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
> 		goto out;
> 	}
>=20
> -	if (mrioc->stop_drv_processing) {
> +	if (mrioc->stop_drv_processing &&
> +	    !(mpi3mr_allow_scmd_to_fw(scmd))) {
> 		scmd->result =3D DID_NO_CONNECT << 16;
> 		scmd->scsi_done(scmd);
> 		goto out;
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

