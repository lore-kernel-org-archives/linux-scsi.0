Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16B5C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 13:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 769E761A1E
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 13:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhCZNin (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 09:38:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhCZNiP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 09:38:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QDa0DW051329;
        Fri, 26 Mar 2021 13:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rcvMyT3mA9oOCdkWQwMIGHnpo/5wGGNBZc6rviYDT6g=;
 b=aDHYkONxbjZIGm/v4fMqVmGyVumQGjAluFkrdw2+lrnPjCIyagrL2ayHyWG5bQxfZsJj
 IwEm2w4YYFUarNYY0Xc693oHkVyylBJxX5M9/cK7lu/3o6YFx8PW9gsWbMxOPF7VjPev
 /HByQwhwATV69uDiFAXiIICKX46lqAiCmDf008udmrVWX/LqEWdxuAQEm8c7azjLlIZv
 Uki0MtCpWYOj8B7qfufrAma9VUBedV2UdxcXGfA9Qy9/vs+BimgTuBULHRIh+nqoWZsY
 vfND4qu/wiaAHx7R2BnghP3TBxsoyFxgVJmIW1UmJGY9KNjTauy7SNuDz2vhll66FsoB +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37h142241b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 13:38:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QDaZmR110911;
        Fri, 26 Mar 2021 13:38:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 37h14n5g0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 13:38:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVx7HuxRRhoAWVbXhwFm7/hf98R2AQcDP7IQp+UiVGtWmHyQ5rTlXgMzwUD+kzidIvEeZb9ib9B1ipMy/bSgQ9b8wshlsHSoPzkEn0hqFsU0X8/ZxFm2+uLrxdOirVcJbAH5n7ZtJcG+p9oJyH8MTSlVc6AllKXA3URVV1shpkv/bAFPs5tX4xHnkhppvoZ3iYacma4DbD7lb0L+VCk/lpbv4rRoLrwpmm4jSC2yRUIuIWpIbCRQX6whmHSQvKYeOZvQZI1BcTuQH2pGNvvm0qGS47364Qd+GsoCyHb9gbn5Ma68JNhuC01tRXOC//9+c4Ph7F/AjFbgsdHssMh2EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcvMyT3mA9oOCdkWQwMIGHnpo/5wGGNBZc6rviYDT6g=;
 b=Ektv1qUi658En9QrmW2ZuW2p7VGx2pVXUFeyCOjx1KLvwrT9Hd8wLFYPwA8KdNY1K8h0KhwZzlZssMbrM1Iini5n4x2pnXvxlpNZFBzd7uexM1n7M4HucLNYWrDiF9FGBR1Gzy7q95wgz4cQpNELkWXQlBpQaht0x9lSX5c4t0JPC61Z/S9a69ipQ7vPIlPTGFQbu2M7oVfTp3ZAgYUIOraKjfnpFqsHJxxZg2k/MoSMnR5YIP8lLfWvTiZyXrkACWpRoFSm0q6MhBmSnj50eNqib32ZpPAw4REv4tqK88/ZqsxY5c7Wcf0rmIworzF3kAopetyybAkGAltMIzwemQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcvMyT3mA9oOCdkWQwMIGHnpo/5wGGNBZc6rviYDT6g=;
 b=o7pFTVaqNl1ALerAoRRHdou5bUSeDurd8nMzTVmH0DeHoJqi61/H0nfLgHsUumB22YFdJgrOu5Wm/0kS65TUa5bBca4pL2L5zg1ZnLdLBZBTzlZ8aMS3QJ83awFWQTwKys6jioWpETHJuGG3QaUuQ81xAzmzRHkTMpx55W/lO1M=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2575.namprd10.prod.outlook.com (2603:10b6:805:45::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Fri, 26 Mar
 2021 13:38:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Fri, 26 Mar 2021
 13:38:10 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Arun Easi <aeasi@marvell.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 01/11] qla2xxx: Fix IOPS drop seen in some adapters
Thread-Topic: [PATCH 01/11] qla2xxx: Fix IOPS drop seen in some adapters
Thread-Index: AQHXH583EL2vtdObU0ODt/TKq3dy9qqTSpIAgAIq8oCAANXCgA==
Date:   Fri, 26 Mar 2021 13:38:10 +0000
Message-ID: <0426DBE1-4427-4B68-9651-5A2EA1C6B706@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-2-njavali@marvell.com>
 <A1070793-F934-4ECD-8A3F-1DC351595F5E@oracle.com>
 <alpine.LRH.2.21.9999.2103251749440.13940@irv1user01.caveonetworks.com>
In-Reply-To: <alpine.LRH.2.21.9999.2103251749440.13940@irv1user01.caveonetworks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84452b25-93fe-4afd-ae6f-08d8f05c6567
x-ms-traffictypediagnostic: SN6PR10MB2575:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB25750CCA35875BFAB70CB5F7E6619@SN6PR10MB2575.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3+KB/EBURdBPGXFkRtOD1AyrAmoNtSP5+Fy8hCIkvaa1bVUON1dikyOYXiNi3azVf4GP2wAo4vsGZFBQYq5LzflYHOk1Jun4wJnXyKIU16YHyOCvNbKdCpUvKJt3F1NbtFrKvSTB212W88TmaxQa8ncC/lBAWV6xHlYlB8C3UtMkb+c3IVYQfxesE9FMMz5CiowHhhzfFA1FnU0pwcOgxbxV9LVm40jYQHCrZuaHEJxyzmUsGU4hCkDFpYG25rH73TzkIPy+M1eYMa//QsMUQIvdV0JdCsMnSEKGBBW2UfMYEKF0twLkfPDELWsDWVX85p055+BoHROO2Pg427CAuUOD6+zOhlcXHSR2q5kEaK0buol47xQmoHsFB1jeWbxtckld6N+eaBx307C6gECvQGVgqeLUD5FOjzuHzoU6MZo8oaPrKzUz0vNUF0RVjAlZp02J2yftERxF3mOVpn8+2TEyjgnLBgoNtVz9TNDSxM2lFlv/8o8Eh6gggRvaErFpfcdbP4arE/hYhUfxRJOD2Cwz28Sj+SznkCFYdzwChtrGFirAOJc3yS0aksqpcFtkG/tympxckpMKzW2X80KI4SOOrH5ELIzOo0ct+jon4rFN02P7dOordFY0z0Y/7OORHwNMQpyidKYah8TOIR6LNqzLO2/7WlcfcbKhGQDcmzNybnPUHZWXbUrNCaSLqoV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(376002)(39860400002)(76116006)(66476007)(66446008)(66556008)(6486002)(66946007)(64756008)(5660300002)(53546011)(38100700001)(6916009)(6506007)(54906003)(2616005)(44832011)(4744005)(316002)(26005)(8676002)(36756003)(8936002)(86362001)(186003)(4326008)(33656002)(71200400001)(478600001)(6512007)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6wMP+5k2OdhMIX32cOY2qM+vORNwjANCLiNT7ybFSkuVzLMMgbnIBOApRdJn?=
 =?us-ascii?Q?pQFobkknKks0a6OUrpVzY7HOrv2KQ6wvlFd0HbrYbuE1jDSt/V/0l/RbWLy1?=
 =?us-ascii?Q?jGUSNIPDSEkOBO6kkVZedrNJ2oKNOXvb6cRoNoTV+znZCTH32iouetPtS3aG?=
 =?us-ascii?Q?xAfBO6m19pQCiKEp9BS1kNC3ay2bwgsKSj6Iqm9fNNyqWsxpmcF6nnBVR0sN?=
 =?us-ascii?Q?2R0FMJr5+Uck710NvYsjsNO+DVIsVzNIaVvh+eijzgCLivH9le6Gypzf80FS?=
 =?us-ascii?Q?5ff3xPRPOlfUrxpstJOHnOUANgiEgD9b6UkJ2w4lgpEAio6aE/Bu13icuC+M?=
 =?us-ascii?Q?TjDq2RgCDF0pFdG2Ce0hidIVrVS6BgLMiIjfndTyJqg5Vfonu7wrfpB/NgXE?=
 =?us-ascii?Q?nTcdEAiufexxEMVzTzpLhE7hxkBo7Bur1BogQ0TEEAYSqIv0/5gBJ+AW6wgX?=
 =?us-ascii?Q?8E3vqkkNUH0rDy2/et0FqWcBtkTXCYo3Aw6jwoqtRF6XmPeEMHOPdwwgJBH9?=
 =?us-ascii?Q?LYIrmOwyrtLX7drpr6PToCwrhWt6InOX/dAVqDbnI83d/aXo/h+yWkfme0IZ?=
 =?us-ascii?Q?2JXzT7WLDv3su+dkrWrnG/xXOypjZNWd6vE2KPqt/gNBHcfK1W9RsnEHQqJK?=
 =?us-ascii?Q?NMk3NLsYvkSc3SufkiFjDK02rYvN0I3EXC7ypvbncoC9qekIHZDzTc+NcWGA?=
 =?us-ascii?Q?ZUFtRB2WJtS+/z4OFRKaCJF1PlbxtjvnyDM0rzRc8U3FuDoQgjPtlqY2Ddm8?=
 =?us-ascii?Q?pk3y7fhfEo5vYM3TnJ0LEHKXTNczWHMZNg0a52v9owtW+xe3ChVDRw9ivCgw?=
 =?us-ascii?Q?3Yaf5o5EcMfTZoyL1HlPicuP3qodr9SLcUjLBq8vyMMIor3JSCv1eoqIgz8p?=
 =?us-ascii?Q?f/utMibaGA0p/f4p86Rg2UXZS2F0nL8gfRJyct27Gv43hiNkxYOFN+DslPGS?=
 =?us-ascii?Q?xwS6QeumZme6x/AewVm7xcfEck2AQTweBWs0VDYaom9pUgGWa6ASDeAM3QgX?=
 =?us-ascii?Q?yK1bBCJwcxCAw+vSaflptOffQigxnjGKfnjnZ+THBd2E5retVkOoJ3xvzLui?=
 =?us-ascii?Q?tA1MYF1DdX98uFDOjRBfQk8WZcGRrZStOHJhfBkBxRNiLK2XraQPcEKpC07x?=
 =?us-ascii?Q?5jV5nJzte0GfASQeZ051EmQDGYBPUNDJlYSoWJBQh1QI3XM271niWcaA7MWx?=
 =?us-ascii?Q?61jZEaft4dy4UnsW/I9ppeZ9fJnojtPS5o8vRcX9/qhWxk9DE/37fOidDVkZ?=
 =?us-ascii?Q?Ju9KhNbqyXkiyRsOaEBPAJ2hPl15JfrUWsf/jSvUnBsuDA2RLg84U1DbRGnr?=
 =?us-ascii?Q?hM6bXT1kfnRDN0tkXAD9EpKwd9n62pNpKW8N7D+ktNRPGA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5E811216D9C0F4787F3FD3D4634E1B6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84452b25-93fe-4afd-ae6f-08d8f05c6567
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 13:38:10.1286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F1H26Y1ZaH7upAJN0wdV47HBVbC6/sGDkTxrbD+mERETidsmbg3iQtM7u3PTtmz05GVizrq4b4lTpFq+1SW7BJ1UexI//dJPtLbeh27NCwY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2575
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260103
X-Proofpoint-GUID: EHTEPpmYJCd1vuhCdOACUXy_wHiJGEEJ
X-Proofpoint-ORIG-GUID: EHTEPpmYJCd1vuhCdOACUXy_wHiJGEEJ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9934 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 clxscore=1011 impostorscore=0 spamscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260103
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 25, 2021, at 7:53 PM, Arun Easi <aeasi@marvell.com> wrote:
>=20
> Himanshu,
>=20
> Thanks for the review. Comments inline..
>=20
> On Wed, 24 Mar 2021, 8:46am, Himanshu Madhani wrote:
>=20
>>=20
>>=20
>>> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote=
:
>>>=20
>>> From: Arun Easi <aeasi@marvell.com>
>>>=20
>>> Removing the response queue processing in the send path is showing IOPS
>>> drop. Add back the process_response_queue() call in the send path.
>>>=20
>>=20
>> Can you share some details of what effect this change made into IOPS?=20
>>=20
>=20
> I do not remember off the top of my head, I think a few K. I dont have th=
e=20
> perf setup anymore. Would you still prefer a re-spin of this patch?
>=20

I do remember this code path and past effort to improve IOPS with these cha=
nges.=20

I am okay with this change itself. No need to respin.=20

> Regards,
> -Arun

--
Himanshu Madhani	 Oracle Linux Engineering

