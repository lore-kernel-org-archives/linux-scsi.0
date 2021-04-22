Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48741C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 081B561208
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhDVQBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:01:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43788 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbhDVQBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 12:01:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFo56e062589;
        Thu, 22 Apr 2021 16:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/s/xViI4VHPHCrvQ0sbHeA29JV1nF3hg1JPRxJlkHqo=;
 b=0XPXTKR973nQSkiSArS7SqC1VpEXnxr+ylQNC5kSbyiwiD3iplzyi1vHybnWgmtMqTgw
 jwshnsRUmAf6ixb1yw09vDiARCng575H7ozxS85yQ0Of5mJo4QWSsvwRXQf+nVzL12En
 2IdJO9yk/ABA2Yz/QFCZtmU6A4ZzJlcuieveGTJjPw1bFDKjpvGTFM7KZBHvcLcGSDDD
 pdqlKBeDTVP2h2PQCtGSemkCKSrTFqtCAbWVVe9tO9wNb6k+4JZm5UEdoWT31tMY1QiN
 tJA9ECibQVj9u1ybatkJkNCDgSnkbzFhjw/XlyvSZPUIlvHzKMRdm4vQanX9Y/cvENE2 PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37yn6cdyd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 16:01:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFoG0i147203;
        Thu, 22 Apr 2021 16:01:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3809k3r8bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 16:01:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh1SlUpeGyshVcsBz9YHu+Lte5gP1kybDpmGwaIdjjMDGrE2ner9M140RyD1ilFQE6t4PRpvd7K1bmZWsjzUqVY70D6s3KVeFzVqHntJ9db05iu5rIC9qA5haBmC5unq47dkhq4Xn/YCI/YEc3FdMMDEQtg50dy+mUR8HH7xPLMJgrfq1PGzeyIsEg/sG/ZIxP+MvSJ3bndrOO5q8TSy3etwc2Wf+r5iXsaWh3wiu4oPwuEuNEoz7dA+LWsfuSgNgAcnwsZxDe6Fu68uRb2WKfXN7CZGMXpwpmoyJ8B4ge7Lje4kZpPXp3bil6FcnFBZ7zx4qJgCJ4ZcsGzOZb72LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s/xViI4VHPHCrvQ0sbHeA29JV1nF3hg1JPRxJlkHqo=;
 b=LjP/1JFrXF+NdFnDAGLoU1qcWIazuPi4sZVknvPSd+fzMyIV3TGE9OlzPAmaFbmr0K59nraTNrAC2rn2dB9uGuGxMt2FH0C+4d+7KgYxYxstGdh5PqeZ/lKUKfcJwRiuubAxOtShQrkb/8CcjppGQ/clLu7WMhL7Hus9iSItABKAwOpRcdNNn9sXI16SqIXFZCJssQaDunC4aqOZN5na3D7MTTcuVKsMWs/n0GtDRtetqPdoTRJcX367TNlimw1GFw8JX9gTjrEgpsKg7b5qKPWtQqf0f7Geh5Ny3dnhgwzf2/lX24I88HKeZE8mhVALj/J5bd/Y77DuVB1qYJC2eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/s/xViI4VHPHCrvQ0sbHeA29JV1nF3hg1JPRxJlkHqo=;
 b=r2ui5sd5ZbEuNzJF1TKUAvwK2zmDBxdFZX6ROHDrnpqzgf5EfUG/FTwG8Z0tqogxp4OZJY2N4tkM6WXV2E7A7mssLt4bJnNUCb+neaKJ5gT+il69q5je/vYvjyswVo0slc7ZCfzWJbiB2Mr+SoJCt/d9BNGYIBSikFG1joTlnX0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4553.namprd10.prod.outlook.com (2603:10b6:806:11a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 16:01:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 16:01:10 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 16/24] mpi3mr: hardware workaround for UNMAP commands
 to nvme drives
Thread-Topic: [PATCH v3 16/24] mpi3mr: hardware workaround for UNMAP commands
 to nvme drives
Thread-Index: AQHXNQuU7DXDVLnOIEu6SHaiGoOv36rAt1OA
Date:   Thu, 22 Apr 2021 16:01:09 +0000
Message-ID: <87D2E221-EB08-4A2A-9F20-7BEBB50F9AB7@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-17-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-17-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 585b54cf-414b-4766-db25-08d905a7d88e
x-ms-traffictypediagnostic: SA2PR10MB4553:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB455306DD8A9E94A37E7DC4FAE6469@SA2PR10MB4553.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9EKsLvQkv5qS7F9PTzWfLFA0DIJlNbCWMJkCL4FaWQMU9zOfOhR+dSABVPhClT1cdylJGUAfip0/3+irTSVf06v+schJ4QyLLCKJOtjAXukylGMDV7LTpV9a9jUktTzzypClpkkb+OKQn+cIfuqYUFEeN0/5bJjAirzHfvSLTSwMu8+0bB9eED+xodR052rbHZYHyAdlpnAkxsPxSVTljwE/vIL3i5TN+u+j3N2gYtssF1gZna877jfkUnHUkhGUg3wO6EMcjNBFr3B+oxGJ9m1h2leLPgtRdRDmy7cR6rAEq6pTPeRpScxPPAoXnNQOP8LJ/9KTCqOvxbC+kxVC7X944UFEuscqSUm60UY0o1nILEaxGVXgyi9CXUbsHoIOcVRqS4ofUFWrdcR7JZiTVO/L3doA4uZTB/cH37P9TJwjNg9azb2Cb9N9WLMs1svVb4SegUcEmw3MjebTp6fyKvirxZxRGxxmNxB6dwRLk5flEglGJp0INWCI3CU7rs3yqkTszVGbalsW9lFIkLTyOfS3UYRD6SPqz++sPmP8fhNq7cFgJuK1JI+D1/61Z3s5IZfYqYFBkoqsvaX24n49mu6io/7EIKwrQkhrA72b6o3s4kHwMStfkTSvGlUiseiiPAeSIyQRoVh/sCv7gHBlFXKB97esKV+Nny7pOj5Z2sfxOw7kHbrtYhIaDSqxia7w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39860400002)(346002)(136003)(478600001)(53546011)(76116006)(86362001)(6506007)(186003)(71200400001)(316002)(6486002)(2906002)(36756003)(44832011)(64756008)(2616005)(6512007)(54906003)(66476007)(38100700002)(66946007)(122000001)(66556008)(33656002)(6916009)(5660300002)(66446008)(4326008)(8936002)(83380400001)(8676002)(26005)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?losfnubTbYflKrkfcgDvLT34vvBs55kHxGfOzKqSCJs+bAJezpapw6qEE9GH?=
 =?us-ascii?Q?P0zYM8Rpjvo/uIACMjoin7fV1b24k6JX+NGKnHJldEDLEHakIw/WWlbRxmj1?=
 =?us-ascii?Q?8aIXBUSeMkHPK9257rLzmMOuB6jNuRiyM2gaNA8Vodh33fj94ReQZjW1ZcqA?=
 =?us-ascii?Q?lEx+QWeJomnhBFONHfjdiPaRU+etHLayfNqWExlKV519MZ/WFBkJTE6mYkli?=
 =?us-ascii?Q?9kNIYBQ/Jrn8OnUzIukWbPi5J3Dja457qTEeX6BhiG4lR7LBtXAjtTO/ypyP?=
 =?us-ascii?Q?Qn8UB4fmfv6B/tXTvHh4+6p2zPSa0IZPTILdq419a9g0UQYlg/xFb7Kc0OGs?=
 =?us-ascii?Q?SXaF/n/tPm9wmUwKn/ObB2co2cPkr660ufqr6w4bHZWAABoO9z6JXCVwjHwR?=
 =?us-ascii?Q?8yblzJMN6zpYQ8NuXPole13cA57chuwUiLz34xvB9wqemL70G/gF9HvFIEho?=
 =?us-ascii?Q?hzAvVtSlOgGix7wCpWsQqxkQE2g4YQfbHAwHELVVRX/IuitMfZuVwjEds50U?=
 =?us-ascii?Q?yfvPM1RBXUxfCMFwpbWAk0MzXiMkgT6ubOjTVn3U2qKjfY0e568pDPMObVeK?=
 =?us-ascii?Q?JWCFz9oDS5tEJo5GAcwbbGGtwzuWV/OcSvG1mdovc2onVjEgvAhVvG1RpNMW?=
 =?us-ascii?Q?qsL7AfRjNhpaE6ACGnbpZN7QXbNGPjtkEMf6lm1zdy9WirFGyXBvmfS/PeOe?=
 =?us-ascii?Q?+ZN9uJ1v/tnIkxw812o2Vf4UdB/Dr1ST+aheDxLA20vPR3tNpCADFgw6rdJZ?=
 =?us-ascii?Q?s6J4lyDpYovCxvktkmWu6FEWaAvRJWeLQAy3yBeYVMKA6c1vQ4JcTGYGlKou?=
 =?us-ascii?Q?UGepmMV+CXgwF2M+Ffe3BV8GRfq382jFhmvQY7qVbPWcTY8HdkbUZwr6dGcG?=
 =?us-ascii?Q?UD5bGDE0HsHR71AuaaJIpiVj+M/XbW2Udhctqdwg19KB9E7OzVoeGdbEGcwp?=
 =?us-ascii?Q?nHglUnULySPjo2SRKPcqxiUD6j5c7cdhNyn8rjZu/N29DRwT6MxyqoRPKtFT?=
 =?us-ascii?Q?c0TB/8yD6ZCWj7zOvoyWxf0woQupmqHFQB3/85gfcFzbXpXhTD7sLP1BF0cg?=
 =?us-ascii?Q?LZP3IP2BYej8kPCLCQQfX3Ip1VbEScDmHHvLkRXwlrF5bdRJkoeOB2pUHuyv?=
 =?us-ascii?Q?ZEYazn9CaETO+nBjCn+5IjytbfJwadJI2NIwb+KqU/DR6YBdSbyKRc1TWNOa?=
 =?us-ascii?Q?F0cDocqJkNQQXY0fd7NimiMLy47iYZ1eMq4kyOSIwT2/9z9Uoel1Q2fAa3/D?=
 =?us-ascii?Q?lmszUVy+dpy0tiuR9VXUqkxNunlDsCkQap0GBNZLPHfwUPQjD0xgv8DVUNAM?=
 =?us-ascii?Q?whdgvUh+3SLlDTxMtzN+rfC8qRn8HyhTiKjCDnqGK02OFQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <963E871C7972AD4E84BA2B5B467CF6F8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 585b54cf-414b-4766-db25-08d905a7d88e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 16:01:09.9346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cvxi+Yegg+HNIwTk7uKlqjIcT8vUQF9ZjaoZddnd6KatHick4qy3NZhyJIyJ0Gvc0tVVcKsIxtoijEhPFHtGO02LDDhC56wUKU6/IgMd9/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220122
X-Proofpoint-GUID: DorV6jU-KDcysx9-HCxn-6knfVjwXyEu
X-Proofpoint-ORIG-GUID: DorV6jU-KDcysx9-HCxn-6knfVjwXyEu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> The controller hardware can not handle certain unmap commands for NVMe
> drives, this patch adds support in the driver to check those commands and
> handle as appropriate.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_os.c | 99 +++++++++++++++++++++++++++++++++
> 1 file changed, 99 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index ac30699c7d69..01b82bd2e8df 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2786,6 +2786,100 @@ static int mpi3mr_target_alloc(struct scsi_target=
 *starget)
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_check_return_unmap - Whether an unmap is allowed
> + * @mrioc: Adapter instance reference
> + * @scmd: SCSI Command reference
> + *
> + * The controller hardware cannot handle certain unmap commands
> + * for NVMe drives, this routine checks those and return true
> + * and completes the SCSI command with proper status and sense
> + * data.
> + *
> + * Return: TRUE for not  allowed unmap, FALSE otherwise.
> + */
> +static bool mpi3mr_check_return_unmap(struct mpi3mr_ioc *mrioc,
> +	struct scsi_cmnd *scmd)
> +{
> +	unsigned char *buf;
> +	u16 param_len, desc_len;
> +
> +	param_len =3D get_unaligned_be16(scmd->cmnd + 7);
> +
> +	if (!param_len) {
> +		ioc_warn(mrioc,
> +		    "%s: CDB received with zero parameter length\n",
> +		    __func__);
> +		scsi_print_command(scmd);
> +		scmd->result =3D DID_OK << 16;
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +
> +	if (param_len < 24) {
> +		ioc_warn(mrioc,
> +		    "%s: CDB received with invalid param_len: %d\n",
> +		    __func__, param_len);
> +		scsi_print_command(scmd);
> +		scmd->result =3D (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x1A, 0);
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +	if (param_len !=3D scsi_bufflen(scmd)) {
> +		ioc_warn(mrioc,
> +		    "%s: CDB received with param_len: %d bufflen: %d\n",
> +		    __func__, param_len, scsi_bufflen(scmd));
> +		scsi_print_command(scmd);
> +		scmd->result =3D (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x1A, 0);
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +	buf =3D kzalloc(scsi_bufflen(scmd), GFP_ATOMIC);
> +	if (!buf) {
> +		scsi_print_command(scmd);
> +		scmd->result =3D (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x55, 0x03);
> +		scmd->scsi_done(scmd);
> +		return true;
> +	}
> +	scsi_sg_copy_to_buffer(scmd, buf, scsi_bufflen(scmd));
> +	desc_len =3D get_unaligned_be16(&buf[2]);
> +
> +	if (desc_len < 16) {
> +		ioc_warn(mrioc,
> +		    "%s: Invalid descriptor length in param list: %d\n",
> +		    __func__, desc_len);
> +		scsi_print_command(scmd);
> +		scmd->result =3D (DRIVER_SENSE << 24) |
> +		    SAM_STAT_CHECK_CONDITION;
> +		scsi_build_sense_buffer(0, scmd->sense_buffer, ILLEGAL_REQUEST,
> +		    0x26, 0);
> +		scmd->scsi_done(scmd);
> +		kfree(buf);
> +		return true;
> +	}
> +
> +	if (param_len > (desc_len + 8)) {
> +		scsi_print_command(scmd);
> +		ioc_warn(mrioc,
> +		    "%s: Truncating param_len(%d) to desc_len+8(%d)\n",
> +		    __func__, param_len, (desc_len + 8));
> +		param_len =3D desc_len + 8;
> +		put_unaligned_be16(param_len, scmd->cmnd+7);
> +		scsi_print_command(scmd);
> +	}
> +
> +	kfree(buf);
> +	return false;
> +}
>=20
> /**
>  * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
> @@ -2878,6 +2972,11 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
> 		goto out;
> 	}
>=20
> +	if ((scmd->cmnd[0] =3D=3D UNMAP) &&
> +	    (stgt_priv_data->dev_type =3D=3D MPI3_DEVICE_DEVFORM_PCIE) &&
> +	    mpi3mr_check_return_unmap(mrioc, scmd))
> +		goto out;
> +
> 	host_tag =3D mpi3mr_host_tag_for_scmd(mrioc, scmd);
> 	if (host_tag =3D=3D MPI3MR_HOSTTAG_INVALID) {
> 		scmd->result =3D DID_ERROR << 16;
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

