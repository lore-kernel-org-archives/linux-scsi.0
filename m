Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB96C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF2F613C9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhDTO71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:59:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39260 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232851AbhDTO70 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 10:59:26 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 10:59:26 EDT
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13KEi2c9005513;
        Tue, 20 Apr 2021 14:48:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Tz6qW1raDB1F+VtKk+4GqHSkfQFhla9YJKZdIMNLYwc=;
 b=ebz9aKKPqbI3Q5f1fJKzsRssOGNHPdU0SWyS1CVbwbZc8un8ylYdsp8k/yeYiQ+EdTm2
 EZofiXO+KnsmbTYutixTeuqMPg+looX0IY1uYQkb1t4JPacPiltUbVx0VqPh2wlnRIiI
 UhDUiib0Fy2hJNhOftb81ovVFMvYp2w7RG1xhkPB/mF4MC3iOZDtK+Q1ZdgRh+9JTjBs
 Steia5H6I+g2ORUt8GwR0Ay4M3/58bkxDHHPsO6eDUNxCMFsYZUUJTHPfwXst2ECYGlq
 +uPYCaBzNSNe/pH4FohnZD/vhQq2I7SJk43Ezdutl69T/BcuQ0midleAcyZ8WSyZ//mj IA== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 381dum88j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 14:48:08 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13KEjcI1120531;
        Tue, 20 Apr 2021 14:48:07 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by userp3030.oracle.com with ESMTP id 3809ky4quh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 14:48:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFCBOZYtC/mhuiqSreOYJZGA/68NIREa1okzdVfghQPkwwE/5aJNj2CtrPz9DYBrvY40dC/x2ngAl4cEN3s9AqEhApaT+7rtseoqqoyxw/EwRZm3RDdo/XXVLlm+PYtlZcQrEWPIeP0XZMdVCGQJC9gvKX+XuGtGkta00n2tSy0OmgqgNJp9WDq7SpnT3uq0NHpZ6EbCsNgRNFch0dpCM6Cza+AbcFl+x8uDISx1He1DgLidjP51bzbB275G8BqZl0UOGDfSDWOZafQ7dSOut6jcHYnWGuM+ffCNLIRenulrOnAGeqFzGtg4+bVVRj9ij+UzDJoRi+2WXfGmCz67kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tz6qW1raDB1F+VtKk+4GqHSkfQFhla9YJKZdIMNLYwc=;
 b=D7mV0XEvC13PECRfgoCQ1KS9m9aGouvcI7+uOfq90dFaY2raPBgqOZSR11IYx3LbtEAs5E6VNwo7YjBqtsGGlm6TgmHp0UqUwEihNkrNESnit6SH/r+Gy+8nNts1vUo1k5WfYMNXdLik3HuL37GPgtGImOpZhRgCKr2IcO8oef8qt4LgAgTxn9nCFEY9CQVasy+1I1+cZ0mlcIUBcIslpVZKQztOTNvDb5guDTSE/6CHUp51YaLCVoqRbuZ2yVp3xtjHLZ1GAcUb0zYe5svSuA5NVckhVnLN6tgAkOHHJqi7dgNXNosQ/5oa+J5SIvlSJw4Z1xqlh4LI5ZlcyNEDLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tz6qW1raDB1F+VtKk+4GqHSkfQFhla9YJKZdIMNLYwc=;
 b=beG4cii9P3nPzcG1bLVnzlwmOWqCxa89TKy9KHl5AHmlp1xRnmLofzHBRXnJuPo0gjILfjX0FvgrrIzPoscfPeVVopNCPgBJCUT6AgyhAGypFSg/09Zxpdly/VZiaXr//Y3OfmQcKdUSDH2mMGfm7OQ+eOasJmFnDvP3KliF1fo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 14:48:05 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 14:48:05 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: target: target_core_pr.c: Fix tabspace error
Thread-Topic: [PATCH] drivers: target: target_core_pr.c: Fix tabspace error
Thread-Index: AQHXNeDAM9i24DGLBUSFRVEPonOnXKq9fJWA
Date:   Tue, 20 Apr 2021 14:48:05 +0000
Message-ID: <1A81A74B-DCA1-482C-8444-EAD143D432F7@oracle.com>
References: <20210420122846.gjh6pmzz2w37tqc5@kewl-virtual-machine>
In-Reply-To: <20210420122846.gjh6pmzz2w37tqc5@kewl-virtual-machine>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cccc33f-c977-43ea-eb49-08d9040b4e62
x-ms-traffictypediagnostic: SA2PR10MB4811:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB481176735AD9678DD866837FE6489@SA2PR10MB4811.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:198;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yBwADwKsWbxQRMbuWcQqeBcIa5LbN7t4+Gk/z5ImEE0UsSvkm+HKUGKolbQJzIdYclhxDj5xk7iLxCgD1h117yUMLLZrzvU9IFJ9Na75235GMGqvZdd2FuAa+eHlQWu5kcAGyVTcKLKZeMF6uL1wEvzTDLmnIl7427RnmJJlEcrEJMwF2ZeAgBMaYuto82f30xPvOmIp99HDQA+krjPCOE8ZOEYXCsOjh68obwPbcfrze4umOzwlYjy4v3qaMSwKFryxIqWwDyvNl5qoZazfmJAPUiJWho+ciDgJn5KDuBF2grGjLItflxL81EEI8lY+E4sAoNzqGeVRdSn9F5oTdasmnR+WdG+n9OedORhivY8f6e/Spvf0Jlh5uQ9QvM1zIlbkrztsJdgg/kXuqcp6HpXZwgC4fD5qcwFHFDeaaQ/mM4y/GNj5LxKxOtDFwFEFyDAe624JFvJWsk05WpLMKUuHSsW574IaohcG2WsivuPps6gzDhaxhXlTZgBgzu76BnrM6RsAOJsENP8FSbEZyTNA9nAB1iNWrtMZVkclSFB3IJ850r8EArWTqk3lF1Z6syOeCE16hw8Viv1FhrXcHFykfHi7JOLXPjDipfRHbV2Vll9nr8BbXTmjU33Yb3LG7cneqv9dZiQDMIp7Q2RLjDUXnj5PT2/Tw9YCHHMXD4k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(39860400002)(376002)(136003)(6506007)(91956017)(6916009)(8676002)(66946007)(44832011)(33656002)(66556008)(53546011)(122000001)(66476007)(2616005)(8936002)(66446008)(71200400001)(26005)(36756003)(76116006)(64756008)(4326008)(38100700002)(316002)(83380400001)(478600001)(54906003)(6486002)(186003)(5660300002)(2906002)(6512007)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GSmDBhtO1hJhvtbmkyz5BiylT0TCWeBsRQxZFiioPcwZYY+20YVIsfQ64Rij?=
 =?us-ascii?Q?lCHUkrLs86bLBRm8fWmirDD05cNNxJbokcpLmdqEaJUqqcE+0+ulGHpWXy2e?=
 =?us-ascii?Q?m0iMBB+LQUxdyhTp91G5m1nmEB8VUWQngWkFpgXQ/jlkFliDyxRTPF29wFGk?=
 =?us-ascii?Q?SY1PH1RTD1SqDZGhtVMbSqzdx3yJDiIS40CMQLeGZrbFP6CeNnOo3yJfTD/7?=
 =?us-ascii?Q?FmNBF5DE9QYpSm88cvaE/UFHKoWeL9ujpXrXgbWbBK772yypl7ZVzPDYxSv9?=
 =?us-ascii?Q?eYu5HbzBTBTrqObQmS8c8gb2HRvltbYyDFE2DwBzoT8JA/I2T6i3zotbWQNv?=
 =?us-ascii?Q?HJNgU/oj4pbrMoTssBOllKz2qsx8J3s8Y4JjYb/9DluhsCzvn1YXx21QU3yQ?=
 =?us-ascii?Q?HmL88hBOhgbi9lZV/S9kgwpAm/HjnSUbzqGAa2fzXOMLEEC4htA8vQPiHU3E?=
 =?us-ascii?Q?XSLp6KvIZcsbYdDfcdYWTIDiNS5mgjjSje5CximA/hgWWKFHg/y/JnOqNiai?=
 =?us-ascii?Q?ezeJfcyeK/+Y7IikFFMMFLGoklYXuaeLhfacQet2quZYx0GWJuqBWIASVQw8?=
 =?us-ascii?Q?9R4TdvJ3LxY9C8/pyndJ5PwK5V5zLQhjK3om0IPfeKLJyEWg1r80J5NiYeW+?=
 =?us-ascii?Q?OKlWxdISBEWlXeF/E18G8fs8slWAFCjbv9HIzHx8CmsgcOcMpJ3F+7XwpGeM?=
 =?us-ascii?Q?C9xHJ1d5/uSUzAGTReImqNeZRIdxbcCCINMBpMM//n7jgjAINyfrn591T9YL?=
 =?us-ascii?Q?fF9qldV3d7Upl7yDT7xmijMC04NYxrnKZUMIWZIhKuZjbrJ1DwnMAIXv1Lmk?=
 =?us-ascii?Q?G6RXr53RxDIm0Lh9AmWtbYRrgwkLjYEYAz/6QTsCjSnMnlyaIikEABTq9HqM?=
 =?us-ascii?Q?/yGNr9tuUCEFfIeo0HxBD1evrs1WmU1giZB1nRX8fjYU9qqZpBhA5Fk9SKX0?=
 =?us-ascii?Q?4X7LSIHomcg1YlNRrBwlQtwaaknX3oTyG5DIeygV9/QpIpLEOV1/GDECt+5n?=
 =?us-ascii?Q?779jkQSB6x3ApvtTzsAzjUKECrlRWv+nWDHIfrqTOCiJZRGO5EytkQn+UtEf?=
 =?us-ascii?Q?OjwMT+ikS5plpIM+IMhSuDQoSBd4Ejc80rUXgfRdkrO1ZmMkpjmBWMLDj723?=
 =?us-ascii?Q?EegrzLlDVDAMIW4sVl2Ixv2fMeZXIoUK+tWyQBk1xibAgIVYDSm5+/iyOH/L?=
 =?us-ascii?Q?fo6+TrmBc7erUVu7HQCLCZtSlT6ufKlxtFNGlr+GgmAh0k/+vYzIC7u53Blm?=
 =?us-ascii?Q?PipEXww2qoHvFwSXLzyRk4JqwVySPXklqkWgk+tLQS4CoKKsPNVVAmxk8Uwh?=
 =?us-ascii?Q?+iiHWGsq0ybl22dHLATff3hbUTkqmeGLSmvU/cQqZdhoww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <957043EB1B554648862D99B90B1A11DA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cccc33f-c977-43ea-eb49-08d9040b4e62
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 14:48:05.5204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3QZRqMw2f3Yn9n3/7YRM67J2+9LUq/XPVMCjxIoU+iYRzdHn6PMYmLGD7mtSvBgGUMhUPUQtdLuHZCvItQER1BHbWqJ5UkJbroyWsTDLVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200111
X-Proofpoint-ORIG-GUID: AJf_ScCZLXMpWMai4lc5gPZAT5CiwOUW
X-Proofpoint-GUID: AJf_ScCZLXMpWMai4lc5gPZAT5CiwOUW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 20, 2021, at 7:28 AM, Shubhankar Kuranagatti <shubhankarvk@gmail.c=
om> wrote:
>=20
> Tabs have been used to replace spaces.
> This is done to maintain code uniformity.
>=20
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
> ---
> drivers/target/target_core_pr.c | 24 ++++++++++++------------
> 1 file changed, 12 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core=
_pr.c
> index d4cc43afe05b..6538b2be1634 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -539,18 +539,18 @@ static int core_scsi3_pr_seq_non_holder(struct se_c=
md *cmd, u32 pr_reg_type,
> 			return 0;
> 		}
>        } else if (we && registered_nexus) {
> -               /*
> -                * Reads are allowed for Write Exclusive locks
> -                * from all registrants.
> -                */
> -               if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
> -                       pr_debug("Allowing READ CDB: 0x%02x for %s"
> -                               " reservation\n", cdb[0],
> -                               core_scsi3_pr_dump_type(pr_reg_type));
> -
> -                       return 0;
> -               }
> -	}
> +		/*
> +		 * Reads are allowed for Write Exclusive locks
> +		 * from all registrants.
> +		 */
> +		if (cmd->data_direction =3D=3D DMA_FROM_DEVICE) {
> +			pr_debug("Allowing READ CDB: 0x%02x for %s"
> +					" reservation\n", cdb[0],
> +					core_scsi3_pr_dump_type(pr_reg_type));
> +
> +			return 0;
> +		}
> +		}

this last one has one too many tab.

> 	pr_debug("%s Conflict for %sregistered nexus %s CDB: 0x%2x"
> 		" for %s reservation\n", transport_dump_cmd_direction(cmd),
> 		(registered_nexus) ? "" : "un",
> --=20
> 2.17.1
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

