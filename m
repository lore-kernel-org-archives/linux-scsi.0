Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE52C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7994261A16
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbhCXP56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:57:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbhCXP5q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 11:57:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFs1Ko135297;
        Wed, 24 Mar 2021 15:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=j+pUzAVPUX+k/O8/ywWMqMNjRVpIXBJBM45JLadcipM=;
 b=SexpJdS3O8dvkxC+JqEfwH+jmbNT+sSm6FzauzVBkf7ao/AMVRqJkgYAlB95yR7wNi+y
 Sf45smM5C4ouCAPbSS1LTLFqULmKrd+59Q7FmH2/K5uY+wFpIEiPtLaL1u1tjsCYJcAC
 587tJt8kIBj4T8BgewVvkTs2/hIcxJnZ+pFWD+/+UT459hUroPXnu1wG4u04qsuILA6I
 rly9tmOxU8Oot9eI3RFNriOTtfmzEHeBS2tPQ++KISrhb/Twvq6UkhD1ayTe+vkCmPBd
 SvlVQBEYcr36Jw1OVAfnUpDwF2H3GqSfaCOTPvsdy7DYhSj78FoGs+Vy0TRY/TKZwIAs uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn37sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:57:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFuRfN125683;
        Wed, 24 Mar 2021 15:57:43 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3020.oracle.com with ESMTP id 37dty0rj9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:57:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJe2EEUcF2kucmmzlHNegvLq9xmb8LPi8YjZxRyz/xCqKNqhIpiMn+GQPJLB+ZtLxKEy1QZG9rn/lQPuGFI98VgRtE/FWuvNx4hYcaKSTQf9WjL7YYgR5tBAFGy81O7/5z77ejBpqVJKQCxvQbDT1GExjOzL17ARR4z8RHM/LNgogjQHVn/naHOpsZiD3d4NlKcHFPhdvfA5nvCOLY33abGADA68fgsoXHE0bfSlP2ffh2pyXALNUrz/MaX29dmAIXI1AvB+TAtjlcnSre6+fpTNf3E5L29Tg7rKpfXNFPAGGKNfD8TBp1TqD2y4Aa+MbgsNeSnX5/kegktzZg5YHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+pUzAVPUX+k/O8/ywWMqMNjRVpIXBJBM45JLadcipM=;
 b=RF5HZb8IVKDjHp9siVxsLpiF7sZRZRxYroHnD0J9ISYuPR6MTyS6PhpQJwRZqVFP/gMTjRdm5pC+0NMfLgmaJ49KZhye2dtTVxdoABUqCozfu5Z5YItSQnmusF5c8hF9lvmKQodwIGU4njUFdcLbhPDRdog4yoIJeQrJ3DvpF5YVc0w3wTIhQ94T0Hg8n4Bg3pq7p42tkD4wMpq7OqJYj005YYKCRJL47hFNAunL6YvfAji9uKAZA9e8EIZ0kmrHofyfYCRD29DVpfNuQ1xpipbLZ9K5UkSTydcejs2RQKdD4Dt1YfxI+n7CAimf7I83/i+izBJ/uHiMb2+APaxKuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+pUzAVPUX+k/O8/ywWMqMNjRVpIXBJBM45JLadcipM=;
 b=oeLbBn+nzOcJM6XJrlVDeBE/Cni0/fbU1Gs7jXkE7Fs4qsyiiHbf+S+q3jCys1UPcpNCrYUdL7AvpoaPSwTur/bJOJgnYJsBniABbyHQuyp1mL5yvKRk1un7u36T1MZTtfO0mmmE6hLInhoD1Nfq3B+KJFMDLKMm7wMtNvPZjyg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4651.namprd10.prod.outlook.com (2603:10b6:806:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 15:57:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 15:57:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 06/11] qla2xxx: Fix crash in qla2xxx_mqueuecommand
Thread-Topic: [PATCH 06/11] qla2xxx: Fix crash in qla2xxx_mqueuecommand
Thread-Index: AQHXH5+GUSdNqlFM10yL6tRprkZpEqqTTZYA
Date:   Wed, 24 Mar 2021 15:57:41 +0000
Message-ID: <9611B8E0-AE00-4C7B-9153-77FE9B53041B@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-7-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3014b0d-e5df-4ac5-317e-08d8eedd8e44
x-ms-traffictypediagnostic: SA2PR10MB4651:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB46517FBC1B6655D55F7D9415E6639@SA2PR10MB4651.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PSm/w3ovj8F96c3M3rzYeR3GKDHCn40rjoJIBKYWCjaJ7Nvp47/TaGF/tKylxEG/SFwBX8h8a8elYD3whaqXw296vb+KwXbNS0xLvfgz+pQjVliAc4n7Eam7pJgaqznhc/sIQtbPedV01ujb6yh0m3kRM8ASbzEba5d2w15t2gp+4O3rP0TUL6FBkoLZEeThP29dbQo3LFHdsVF2d4Qp76xqNz0RPbwEtDozwCfhWDT2KJPnPM+vmLgsGEuWCF9VYWl9vzDqrZPSIsL3CHsZ3NeuagGR/QHmTSLvMHciwiWihpFPdHlw9nomuD88yz19Wq+loORSiyHfwCt3OfZgMidStHRvb1tBXRcmo586EHqKDBZLAAj6eYJPMJ8Eulz/pHkfceqoeruvcx4d3LPcGoCtynXmT8vtYYVp1OxpqhdLqixVFI/Ofhkr4LSlKsdqfMjSxzuQvF5hdWEQW+L8pVPm03ktwlINUDDGiY3yGB/HIcS7aValsBC3lmLWGJfje53JXm1j14vKPVLPivk6X3f2ZTD2xjysqkYywN4uulM18w/ZldENIWnkCTFq3N4uVTZjBBBZJ59QuKHpbBOm8I/EZMFVYFV4VsSACeaMfTWBwZhR3/YgHd2KBs3gzdLe+MU9gvDzffY4IcywMHBRAB+9y1NfAihjOO8RIy2CqgqKmIoZzTYU5R7rAlvP8/zU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(44832011)(33656002)(53546011)(6506007)(2616005)(66556008)(66476007)(66946007)(186003)(64756008)(66446008)(76116006)(26005)(2906002)(38100700001)(86362001)(6486002)(54906003)(6916009)(36756003)(4326008)(6512007)(5660300002)(83380400001)(478600001)(8676002)(316002)(8936002)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?74qX+PDUh8sGoL+Me3QC37x3c1vrYlmJBg+Xqb87qlA51+qUKmVKFpA7JFRP?=
 =?us-ascii?Q?R9fVlBIdGN81PdZNg0HuKM8C/9O0iSPJwOveMrYc0QL3jRmhThIG4WA59VB7?=
 =?us-ascii?Q?vwTNf+FpLLF/uZwoqCNVtm7gEN9rMVtgz6+h2Gw5YZRNcO4zj3U/8YAGhz+y?=
 =?us-ascii?Q?sfaEj6R8pYOAp7kRGnl97ZQ40rprLzcA6qIS/t+ERfBW5mOoL1XY5LEeCi4Y?=
 =?us-ascii?Q?IS0RJPFGn0RN7xYh9pEWKrh3wtVOjY4TQaYuTyFff2TAetd4cx5HeQbiTw6t?=
 =?us-ascii?Q?W9xRl94ZAJeX2orPbP6+Gb7KHbtNbXrz664Jx7jsvxJkDSywdBP469gvCt9Q?=
 =?us-ascii?Q?5UGEdtZeRF+DfCcuCXg/glPus5DHCfR9T/fUCQWZfHLPtAxcFSTpbJYodG7X?=
 =?us-ascii?Q?Xz5edwadYAdJALtmREjvz4+NqPENu1U1j5bKRGjCsFMHsoAKj8TUpL6/qnUW?=
 =?us-ascii?Q?wSEoNgzTCZ4nS6fB6DFluNtk8CKW8OxgGKzec2D8KNubgxZFuN+HodgNbenj?=
 =?us-ascii?Q?K9dyhpujmRD+lWzZWxLLNSox9Ew0Wo9vNDzpWRpoRjBnn02DagZVfvuRwTby?=
 =?us-ascii?Q?E/zuRzkvG+Gnhh1RiZ5gkxfvJPpMbgXmuJlp+VC6Ik0/06/RYjGTfUeTYIfw?=
 =?us-ascii?Q?C8JHMeupDytiGfbzl2tfQW/1Clb0FlcEN6JSZpBeQpUMNxDoqeY8xMPxtqrZ?=
 =?us-ascii?Q?vseFvawJBuD0DlSylGU1tOix0VtT3igkmN9mNzPTGtFKdsFEsCCS+psRQR0E?=
 =?us-ascii?Q?2efpbDJhxmGFxo/xzrsen9MDXGSi+HggqOHPDfCCM1pZm4Uw312U1z18D+yO?=
 =?us-ascii?Q?i24TZLe/Pkr8o6g0eRn8fsE8M0i05FjVxeMbMIk7t/8m/Kjm5mQAaW2GzRlM?=
 =?us-ascii?Q?vvYac7yWywkYI6Wk6vFR50x+WGaXo5pjjM1hMxowiBkZvdq4g9Nxv5k0xU2/?=
 =?us-ascii?Q?Ag/q7bJmeRbxZUMNPx+7QNbuqjtbLwI8WxznOwGXODQYeqFkek2z1FXskM7p?=
 =?us-ascii?Q?4n1NOqnkHgc1Y/DS868Z2HGmp1sYa0Xvg13ffxPUMWiK9g1kr6MTAN5CMmeZ?=
 =?us-ascii?Q?r8yWJiu5/mdrtO33c51jxceDw2Aw/eLetj+VooGxjg5ES4yhTSz/2hgHz/35?=
 =?us-ascii?Q?bBtkHsBwo4mmOKDgr9JA0YqtrDy84G8NgAHKkq+lRzlkodoHQt/auTIEpmJO?=
 =?us-ascii?Q?TIu/whCb993uLoBFQchUw/VgAC5OjJaml3yUL2iI2T5aHEGXw4RpqNClBbqQ?=
 =?us-ascii?Q?5KZ9HDOBoQx5EV0xPvQhrctHjR3/8r0STPrQeOpS7ZFEToEJ79saT8kR+mLn?=
 =?us-ascii?Q?9Fb1YN+4cnpbLW7EyRilmdJT?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C3881A094F83574383BED18D7FE87B4E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3014b0d-e5df-4ac5-317e-08d8eedd8e44
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 15:57:41.3502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1G2nBtnRB+B8Wj5gCxQEYs5TOqrQX6QiLMYdRghcG4maGSZTozp3ZRNJ3laC+jp3UgUZHMzp/4oeoJaaEUH3rkbOdvMXlZFKOPOHaXTFxG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4651
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240117
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
>    RIP: 0010:kmem_cache_free+0xfa/0x1b0
>    Call Trace:
>       qla2xxx_mqueuecommand+0x2b5/0x2c0 [qla2xxx]
>       scsi_queue_rq+0x5e2/0xa40
>       __blk_mq_try_issue_directly+0x128/0x1d0
>       blk_mq_request_issue_directly+0x4e/0xb0
>=20
> Fix incorrect call to free srb in qla2xxx_mqueuecommand, as
> srb is now allocated by upper layers. This fixes smatch warning of
> srb unintended free.
>=20
> Fixes: af2a0c51b120 ("scsi: qla2xxx: Fix SRB leak on switch command timeo=
ut")
> Cc: stable@vger.kernel.org # 5.5
> Reported-by: Laurence Oberman <loberman@redhat.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 7 -------
> 1 file changed, 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 6563d69706ba..6a57399b515f 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1013,8 +1013,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struc=
t scsi_cmnd *cmd,
> 	if (rval !=3D QLA_SUCCESS) {
> 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
> 		    "Start scsi failed rval=3D%d for cmd=3D%p.\n", rval, cmd);
> -		if (rval =3D=3D QLA_INTERFACE_ERROR)
> -			goto qc24_free_sp_fail_command;
> 		goto qc24_host_busy_free_sp;
> 	}
>=20
> @@ -1026,11 +1024,6 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, stru=
ct scsi_cmnd *cmd,
> qc24_target_busy:
> 	return SCSI_MLQUEUE_TARGET_BUSY;
>=20
> -qc24_free_sp_fail_command:
> -	sp->free(sp);
> -	CMD_SP(cmd) =3D NULL;
> -	qla2xxx_rel_qpair_sp(sp->qpair, sp);
> -
> qc24_fail_command:
> 	cmd->scsi_done(cmd);
>=20
> --=20
> 2.19.0.rc0
>=20

Looks good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

