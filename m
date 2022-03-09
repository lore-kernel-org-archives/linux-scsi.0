Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490F0C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbiCITON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiCITOM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:14:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76E99285C
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:13:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229J62i2005772;
        Wed, 9 Mar 2022 19:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mUzUQ3NLw+jwdVztVODxK9nr8FgW1Ovk7fjL6Nv/UoM=;
 b=JhgTx+o1YihiQimMb1YgsX2Ta+o8dZway6fNgeLvOMpy4rpCUjcfrw42AZl2AFWXS22Y
 7K7wW8KwLRbqUxjqlcCsvo5m2MK8cbKNtaj4Ob6ytvvxxE4I5Udv5LBDwycrgV3wh0dj
 7G5lh3peF9d8sFH6j+Tifu5bazb9a6567uw/6OgKbaWTUmuJFpq2Q4Yagvtj3FhQGoJZ
 cY58oLZUM02QU4SVBjSB44YN7Hrjbayz7qAIj2/2lvA+Ff93QjAL8J/KYzqxP6KmpQAz
 BUJ1jYVrygtIs7jQy9OhPx7gSrN/tX44M93j8ECtoab0soizvfKrQa2FpXr7HkSKm17u 5g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0u4b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:13:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229J1Gl2147313;
        Wed, 9 Mar 2022 19:13:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3020.oracle.com with ESMTP id 3ekyp34adw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:13:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKuZfCSjgtUocNNAk0boaX2iU+ICD1qFRENXOmdMoMgmXOAwVqAKjgbTqjJ8qcvKRBGWZ8j1Iho4T2l7zQLRQKCt9msCFkCD0Z+nPJYxkpt/MkQrecer/EMIP3+rsEwP2YagGsU/WpNaxBzOaRisYxC1IG7Y3Eqk02juijYY8E+3+/8r9b/BdNPp3u6ws/65+ZSqE2yi0PT3S+vehAJ/zHvca4yMJ9ti7aBMINUKDLymrojaxcAdNmLq2EmNwBUVxlVzJo5v6TOg3zTi5QqNJkptpuINSSMGPioNftKHm8CoFouo1RHw3rkebNWgSZcG9YWe9Mhh7eOTVKmXQFAxsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUzUQ3NLw+jwdVztVODxK9nr8FgW1Ovk7fjL6Nv/UoM=;
 b=aihjpNzkdUu9g6B+g/6ikY6NL5KCgVhePTsB7JAZBZCQg3AvYA9P6wz8aqI9wY3ayrqrUXlkVSeZC1H93tfk8+wcayu/HmOEnh5wDD07r1V17B3tXpPWpyFurqN2pqnyBNqfeceRPk5Umzr9uXJ16sngfuRdUhnH8ADMLCwaC3GRgS1aTT3WE6PeF0VpxR0eemBRoUWGdlvADtAraj0bspSAoL4hnjvhLiygqSONBgdA24doKJEGz73ojgAQBAAs3xbEyzWHZj7bw4zoyHZlEAOFGdXbQpPpO+J2vAYk/LMHn9pHRBpW36haZ/W8+WBB9m065ruUkH3ET5mDTUpD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUzUQ3NLw+jwdVztVODxK9nr8FgW1Ovk7fjL6Nv/UoM=;
 b=irod8kjBPAJZ5CFxRGgq+xG2YQOmL6uFIr+59seiNSrptmacqZha/kGau8iBXMrU5fjAdGGQF7Vmq3ESySvR8XqXs2JhktLnlOZEu/O1qHURyXhhroRnk7SKR07Nq9slSqBj22zGjue+XdzxzrITn/wSmZNx9EWUhsNrAsL+fgw=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.18; Wed, 9 Mar
 2022 19:13:07 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:13:07 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 12/13] qla2xxx: Increase max limit of ql2xnvme_queues
Thread-Topic: [PATCH 12/13] qla2xxx: Increase max limit of ql2xnvme_queues
Thread-Index: AQHYMsWH9A/9ckHRLEa3a/zxq6kJyay3bd+A
Date:   Wed, 9 Mar 2022 19:13:07 +0000
Message-ID: <77A0A9A6-7CF3-4297-BD79-4A0788784C47@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-13-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-13-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1e43315-4960-424e-6891-08da0200d81e
x-ms-traffictypediagnostic: PH0PR10MB4615:EE_
x-microsoft-antispam-prvs: <PH0PR10MB4615B2F909CE9B845B366E42E60A9@PH0PR10MB4615.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W6lf/U3n7hHkht3bkZnGG/PeKo+xpXgTy4TFCP71jhcfEMY8lofJu+OP28bm2bLAq+gMoH8W9k6fyJQeOKGXrSoMVtZhihU7dLM90xwzcwCBw5Oe5zTN/ms1AzKMNAnWx6uWbh1h/uyCz4CsXMQqE5+LzYBI/AI+/oZ0LCHrvmPRGAcRhgcFDvkgs7tZw0sgwABf88/FAkW2qKxYig+L+J9gvy/FZXYJfplk9zYP2gkPFT/B8QuXXl9A18wz2PwjPokjYPhIoeGlZ9pTCM7bzpYUeB/sPC5C19SJ9B/iNyFXxuakZ9i4CaaH5Sy6E7mjpHJS7axv/UdKx/elfXNnzHFtONyX87Z6TP2Z0UbbnMoJVSTmnBEO193hLLn4lrlLgAACYZa2usCCllBoh5q/8IrSZlfvqsSO9KTShp02yFHd/uMMs3OB3w68hkzmxoSTgBNL1JFfjdKEGK1ajQaSgHDmNlNb6MbfQ57dWjgyzKD+LrY0rg6JK2r3lbdUKLI2WFtU8n558pd0ClK9tLZOK8/Z5EEotAmLIXpPMVTx3yuI1N0hpnwuk5bWhgXrLqNyLmiU9vxCtRZbcH0O6gIDFLHhYTEkltT6/QZM3auw5Q+JfyVe8hAj/uIX5r0g6TnW6TY+EBo5IB4RSK2T/o7f1F/rQAhYCd1Nj9vEIM7V17bRNjSy1x/N+Zvn1e61VWe3nf9NPpxqyCIkNQdi7IMlKv4vbanAbvQvvBENJOEf0kVHkOgnYAPHQrb8XzWWjmf+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2616005)(6506007)(4326008)(44832011)(6486002)(2906002)(36756003)(83380400001)(33656002)(38100700002)(6512007)(8936002)(53546011)(54906003)(122000001)(316002)(6916009)(66946007)(64756008)(66476007)(5660300002)(66446008)(66556008)(8676002)(508600001)(76116006)(38070700005)(71200400001)(86362001)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OWm+OTc/K5ydpqXj/6Ra6CGEx1mej+MTCXLjKP05M3ixAtwENmgTz7oYmyka?=
 =?us-ascii?Q?KjeQ2TlMQ3RUm8MZqjQ9dlR6fk8L0RrCk9rUD99QAgZVQYOxd1gY3pnsIOCH?=
 =?us-ascii?Q?QOwnMT/f1jqQhDcaqPpixjpRXGzRnhtkYaAv/WbaT12TfXed8ZC14khY4HY7?=
 =?us-ascii?Q?dpwUVWeMESI0R7uFJrZgWF61lSMusQwTpSmdrw5wg5n8cS1fpp7ickIJtfQF?=
 =?us-ascii?Q?am8LsgM1rTi0Ez8+tdanN6zRuPQwIYjXuWj11CwlAiXYOYIBHnYpJKRj9YTG?=
 =?us-ascii?Q?aqy411UJZDFlt3itKZwJMtE1vl0tFZhebVHMlmGYITYlhi9LNKkYPNkOAdF0?=
 =?us-ascii?Q?CKzPDCvm9CjyGJ3nkwIUyx3j00l68G3bPjH9QRvfjbinpWM2ry6Aahm6HZuQ?=
 =?us-ascii?Q?4d9lf1k08i9hGGJs20voxCWNmmwEx6e3A8KjSLocGWsdGmL3IZh757zK+A6/?=
 =?us-ascii?Q?31anjUCSQyUtEoykP9iZt2srodOuDCr7VLFYQpGqi6XnrAWXG5qyR3ukCpWg?=
 =?us-ascii?Q?0sNYf8NVUYQ73pkyUZWxXCjwqnFwAvsYzo4rcYW0PSAXvaNMugtNliCemnF8?=
 =?us-ascii?Q?Pu/mVqfF1M5z04z5uttmAMn9ALYyzzzeowqS/wTTig3VjSXXtV0qbkntRn1E?=
 =?us-ascii?Q?eAGPunXVn+iWZgh+olxUhzHp+et6kOGqY7afNyA/xie4pbTeEKSUZLQj1HLw?=
 =?us-ascii?Q?1nmh/NCGg35juAW21yPypA/Clo/2M4tEUXav5X/1jQ6+ZR+XzFMr2fJ7IIBr?=
 =?us-ascii?Q?+lQ0gDMeJH4xnK68ARxZulIqJpV1A8qXVLfhZUZqnJDOXAqI55DQn3x/GqQx?=
 =?us-ascii?Q?Mr65zULiAXQkABRG1llf8lN8QTWjPdRSkDQvsSz2y5lAwjmVD6faNjdq8cyV?=
 =?us-ascii?Q?Agaomx3JaGv392+MqEVTU5xG7AHOUXKhF0bI9nXRZlD3csz1n4Q276JehmOG?=
 =?us-ascii?Q?LBYVUu5jzASFkTCUS3HbkLdWqmC/NHrRdn7iFecgSbf3cZgaCVEK3th9KnBa?=
 =?us-ascii?Q?7r1O9qTtLxTnwdiu0glXf76X7+2++4PhQdEG8StanEbw1y1LcP14sNaE06U5?=
 =?us-ascii?Q?0l7IorEbSdSRYr6b1onAzhOkXJLawJJA0gSCGxMR8JIHRC6PsHxnCm9vzaDa?=
 =?us-ascii?Q?MYF2TXy+Dcp767j+gfXd5uAZkw3F3Oy9/UFVdbhzcGcv1rGrhs5+SILqj9A8?=
 =?us-ascii?Q?olpP4z612HR6fcsf85JhEDADVGFlGZ0vtj1vD2eMKLmdSsbr0wbJ1BIl5dO5?=
 =?us-ascii?Q?lSs0rF9SONhCZ9dS3RQSznXhhwiJQiO5YDH06lObO28MjA1HXbDGsdNPGpFx?=
 =?us-ascii?Q?BzpCue94jVkeMlCK+1gJQcSIp/oHcnSuIrJ/kbZkz+XoC0fWkCY/uUs5el2y?=
 =?us-ascii?Q?vg1KaMN8SUPP5oRK5hZ+XKg2/lGyJUUP025zpidcEZtf7wwUe/SAeNdUnMHX?=
 =?us-ascii?Q?aHIaxShcWCAa12pl5by4E8SfroSks1Vci5JYz74eTpd0Wpj2BjbORhJbTxrA?=
 =?us-ascii?Q?7nZM8j4KbQ7vwLAtfX8j6vvCtrpSwH/8RQ5Zi0I+0RG1Pis7H/LMxN7L49uv?=
 =?us-ascii?Q?tiuFbfNUj9WIffJkCoJpBQa2CFS76Tz67CDcFX8SlZQWgdvciVfa0bRP9PM3?=
 =?us-ascii?Q?/teko+dpLd8bsb+cV3EjckfzCBQ++dDHcXPyknzJWE/SNvijNy5ifvtIEoU1?=
 =?us-ascii?Q?15oAKlTtTtR9iXxni8zMhTiI4fs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4EAAB4D971D3774B82AF381294AA756C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e43315-4960-424e-6891-08da0200d81e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:13:07.4848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Xgs6rcAYw5wRUFxNqUAoBCvSzE/rc8lDapyA1EJZP4iA8F+OFddmLp1sWLn6V9d7DndudxOQnGxN6o4WLK8p2xgDB0EJY82PZ3vzrqrDkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203090103
X-Proofpoint-ORIG-GUID: -aRIu7Ess4y4zag4FuBIdUfpfLbnzCGH
X-Proofpoint-GUID: -aRIu7Ess4y4zag4FuBIdUfpfLbnzCGH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Shreyas Deodhar <sdeodhar@marvell.com>
>=20
> Increase max limit of ql2xnvme_queues to (max_qpair - 1).
>=20
> Cc: stable@vger.kernel.org
> Fixes: 65120de26a547 ("scsi: qla2xxx: Add ql2xnvme_queues module param to=
 configure number of NVMe queues")
> Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_nvme.c | 15 ++++++++++-----
> drivers/scsi/qla2xxx/qla_nvme.h |  1 -
> drivers/scsi/qla2xxx/qla_os.c   |  1 -
> 3 files changed, 10 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 794a95b2e3b4..87c9404aa401 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -799,17 +799,22 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha=
)
> 	ha =3D vha->hw;
> 	tmpl =3D &qla_nvme_fc_transport;
>=20
> -	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES || ql2xnvme_queues > MAX_NVME_=
HW_QUEUES) {
> +	if (ql2xnvme_queues < MIN_NVME_HW_QUEUES) {
> 		ql_log(ql_log_warn, vha, 0xfffd,
> -		    "ql2xnvme_queues=3D%d is out of range(MIN:%d - MAX:%d). Resetting =
ql2xnvme_queues to:%d\n",
> -		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, MAX_NVME_HW_QUEUES,
> -		    DEF_NVME_HW_QUEUES);
> +		    "ql2xnvme_queues=3D%d is lower than minimum queues: %d. Resetting =
ql2xnvme_queues to:%d\n",
> +		    ql2xnvme_queues, MIN_NVME_HW_QUEUES, DEF_NVME_HW_QUEUES);
> 		ql2xnvme_queues =3D DEF_NVME_HW_QUEUES;
> +	} else if (ql2xnvme_queues > (ha->max_qpairs - 1)) {
> +		ql_log(ql_log_warn, vha, 0xfffd,
> +		       "ql2xnvme_queues=3D%d is greater than available IRQs: %d. Reset=
ting ql2xnvme_queues to: %d\n",
> +		       ql2xnvme_queues, (ha->max_qpairs - 1),
> +		       (ha->max_qpairs - 1));
> +		ql2xnvme_queues =3D ((ha->max_qpairs - 1));
> 	}
>=20
> 	qla_nvme_fc_transport.max_hw_queues =3D
> 	    min((uint8_t)(ql2xnvme_queues),
> -		(uint8_t)(ha->max_qpairs ? ha->max_qpairs : 1));
> +		(uint8_t)((ha->max_qpairs - 1) ? (ha->max_qpairs - 1) : 1));
>=20
> 	ql_log(ql_log_info, vha, 0xfffb,
> 	       "Number of NVME queues used for this port: %d\n",
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.h b/drivers/scsi/qla2xxx/qla_n=
vme.h
> index d0e3c0e07baa..d299478371b2 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.h
> +++ b/drivers/scsi/qla2xxx/qla_nvme.h
> @@ -14,7 +14,6 @@
> #include "qla_dsd.h"
>=20
> #define MIN_NVME_HW_QUEUES 1
> -#define MAX_NVME_HW_QUEUES 128
> #define DEF_NVME_HW_QUEUES 8
>=20
> #define NVME_ATIO_CMD_OFF 32
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 89c7ac36a41a..8f47dd421e33 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -344,7 +344,6 @@ MODULE_PARM_DESC(ql2xnvme_queues,
> 	"Number of NVMe Queues that can be configured.\n"
> 	"Final value will be min(ql2xnvme_queues, num_cpus,num_chip_queues)\n"
> 	"1 - Minimum number of queues supported\n"
> -	"128 - Maximum number of queues supported\n"
> 	"8 - Default value");
>=20
> static struct scsi_transport_template *qla2xxx_transport_template =3D NUL=
L;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

