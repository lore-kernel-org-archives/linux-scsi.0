Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD039C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73C61613CC
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243686AbhDUUcW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:32:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54558 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240021AbhDUUcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:32:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKMFo2010715;
        Wed, 21 Apr 2021 20:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wPAHll0l35/BiJmbq0jS2dQ8t5oY2f/pYME2ltk7ufM=;
 b=nEb/k4JhErEjiiAXQs2XbAt6btCdfP3XPALuhg6aMPwGeM0SAeHpTVbiD9CmvCoZIgcO
 /frHwxCwgD3qySCipDG1vQc2r9M18oIid5YtQbNN8DyLuXufRhU5N6s1HCfdKPI/B6w0
 dtLN3AWk6+UukFWIIf6M+lkBnaCEsieaXYEF+Tm6Fjp74hx9u+WCzCatXZO0MzPKbsH+
 aajuI30symfg0xv8+G5sricxykKRxQJRbtm77fKUE53rsdFZQnIcE1fjFlac+2n2uwXA
 QobaoU6ZKh6fJu0e77GB/yXve5NC5nok/xd+Y+JThL7tu+nhsRuaDvFXKg9RVGniAkwc /w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y2vn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 20:31:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13LKUF3i184217;
        Wed, 21 Apr 2021 20:31:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3020.oracle.com with ESMTP id 3809k2ee7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 20:31:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UAhuOdafglSqsVP52HNUv3ZIyxufF1tz7rcA0UkTHkebJ/XvpwU6MITkUD1fPDe9+QnToZwCJFmSKfJS9WOERQtqUJzDEOrLbHW+jbURKUma6NexYevdfvCW3WEQhCl2tRy5o9r8Q3CKWmtMRRTg2oVASWSnZ0L1wW5wJHoTH9WJZZODFASdMdztHLjHa8eA9YjTjyBCLIweyzyD9CM3anTlvH9vmXNdxIKGcaZbS0+c+9jvkS3znrhEwpCV814gOX+lm5aaLo6sPF6autbeMknMBTkKMhVdy9ulxAwI/MfYs4LZikzawfcz0Zu7OyCpJZ5KzvUuWI1lw+/UBrL2cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPAHll0l35/BiJmbq0jS2dQ8t5oY2f/pYME2ltk7ufM=;
 b=WMUFQqCHe1ZCxG0F8gV7nHYkHSQ5UuYAqoF9VnStirtVrtBAOtGx9pLsDgsMVXtoYwImmI8Z2zmARA8IFALcTshoB1DE3m4w75UgJv0PhVJNqqZ+sekEAvcjxvxlyk017TOiV+CR1V5WulCeEdIImqcs7WfGZGZv08qF6YgT+M6mgiylBfvSug+nMZcUKi1Esox0ZBHreOkQwpaN2i91oBJGBbO8nxjtZSZgJWh1dSq35zsU3C5LaXom12CURsOkOAOXdhNEbQciEHuNZd807whkcAka77rjOy+9sSk8oiHhMEDgcw7c9qm6hDRg6f9GbSIIOsV4wUeVyaXPomwQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPAHll0l35/BiJmbq0jS2dQ8t5oY2f/pYME2ltk7ufM=;
 b=BUSyDb0EcnbcQvrkXrxcIaZNgwtaTjgiz5EoIhaLfoL2buY8Uqf/G/RNq5HAuTOObqdHvkT/XPVwRj82ICre/Y04xN5VgCHxpFjmcsQiqrU6V29Bo8lG4vsZxsI781zMQtOnPrgw2Lu3w3ORKcgqLPV6ZZcfO/XP+7dQC1rsPdc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4683.namprd10.prod.outlook.com (2603:10b6:806:112::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 20:31:41 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 20:31:41 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 07/24] mpi3mr: add support of event handling pcie
 devices part-2
Thread-Topic: [PATCH v3 07/24] mpi3mr: add support of event handling pcie
 devices part-2
Thread-Index: AQHXNQuCM1zy3gW2N02AqqlR8FSADaq/cJMA
Date:   Wed, 21 Apr 2021 20:31:40 +0000
Message-ID: <40556DB0-AC51-40BF-BB6A-44F4529E4A38@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-8-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-8-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ee09ffd-9cec-4036-a621-08d90504788b
x-ms-traffictypediagnostic: SA2PR10MB4683:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4683E8D423C0F0819962E83BE6479@SA2PR10MB4683.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /8GcdWVKOMHxGC/AK5izIvby9/Qb+SFABI50xBSR3EyzVv7uocHOJEzzNfqh5KBgqMR8cSKS1xWHJgk91zBUba4CqsB0sBhEQbHLMNj+xz0hsnFKEzmCvc7AYDAU65k2OlhqY0RiVCDmMH1dhp0ATIxin6KBrevnWIp4u8WDo9bCSKrJ+dQQglP1w8f8Xk6yBuxM40FiLqtzyK29+wESHUQ+n3vCRwKQzvSxpRoC+QlROLNTq8vcLg3WMdJf+bhNH18t47E+wuM4cYmLfAQ4X3mYU7k1n0o6qjs2xKb3hTmaPPK1fFjwyTc+3VzjExcxIQYioFScUFusStv4xTRTmqQXZHE45Y/q/gQtDoslneJsotmYBPPqdQ/+7o24Qs51CafxqqYkOJLPFD5I/LP99VZmt4Va8q9A0zsjVUezG+Xcvi48HnFCyylr/+TaeAIw134ZMNf1bzL3+ntWxyZna0VjsilkYIu68glUrnOPRL5XhCqlOzEQuKHvtkrqmbesTSyUHK3w7+ZtQMGQjR0X94exwZh5LC8LvA/ja0LSbzQahUAn2fyCKy/c+MhSdKdsfcXWsO+kmrzuKZzx5YTHwyvTw9BN8+4rMomEDufWTHSegIRaSuiVs5Exa3iy/CN610Jblp+cuR1m+eAU1ndeljUMMxs/O5OmdxH9dgS4Z1OsEryTbtIXd1lygJ6ecSfV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(396003)(366004)(64756008)(2906002)(38100700002)(66446008)(66946007)(66556008)(8676002)(4326008)(76116006)(5660300002)(36756003)(53546011)(8936002)(6506007)(2616005)(6916009)(19627235002)(71200400001)(478600001)(6486002)(122000001)(66476007)(316002)(86362001)(33656002)(26005)(83380400001)(186003)(6512007)(44832011)(54906003)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?90y+rGpzG7swBsjkQga+P5VjIJMQLRj3B1/5z1EyAWX7B6IqLyNRuox83kLm?=
 =?us-ascii?Q?KtmtK0RjDhwhLilvykpSryVm4fHCkkH9CtmYA5WVS4zdUgwvHt+N5WvttfC/?=
 =?us-ascii?Q?PNPOhQgSlwE+kmip2fSuxsDlzlmrmL133HhCvLWqxsvXircHNUtfH6aCC2SB?=
 =?us-ascii?Q?5xihLjvk6Es1vJyfqPIIGecOVFq3Z/fu1+8InuE+fQIlpRpkNITz9v0c2blv?=
 =?us-ascii?Q?vytQlfkacTEsqTc8JvWRvFMmemDBuEoDjWteXx1IDyCKAaaw/Yo89JiXpNNw?=
 =?us-ascii?Q?aGn5U2FOZeBY9RGS2GS16EB6hJwGuCaq5k0v2LwcovccJyzv+dQdZ1jJTjsD?=
 =?us-ascii?Q?nWodh7q6a/Q690+ynwwitI5FIzhyX7VhnU9BTyXSxr1bXUBOVnnS2PdktOpO?=
 =?us-ascii?Q?ZHundIkD5j2bUfcaHeS/hTOteRjK5IO1xTqctgRISBAHNij3QjNo/E3m1/XA?=
 =?us-ascii?Q?PMWW9pjXGvNjv5750KpWzVMZMMwD5ZZZI6TpH2nJgbhfI++ZOV4bgyMYW2dJ?=
 =?us-ascii?Q?4+rC8jCk2J8Lh6VbY4CuQMsuXpgPTac80uuQz1Owngq2oTFRcMP0EUS21WLW?=
 =?us-ascii?Q?LwinwRWrkZ/D4t46aWA0/gYrBYQBL9gQnuwltvVCTb/95MzkBUpw9AwmvY50?=
 =?us-ascii?Q?Uk/+CzLweWeXg+4m6YaN1dXabxv0csuDDbyBpf/of1OArsRaLgTbjS3wJPWO?=
 =?us-ascii?Q?OwLyJI/EONpC/Gun0Wh3JdXS+VlDbcL7z9WcSug42PZii5ieeEZh6Xq6i8ZJ?=
 =?us-ascii?Q?dqKLaHYdrpFIBkiTBjNQqYpJqvz5GJw66dx3Bdnjovj8NTZs39Y1Jo33SVJA?=
 =?us-ascii?Q?ZvpJZ7bVnnnOUtMG+0aE0ltOC5TG6NZqmfDX0Ys9213C1+c4E1nduhnGEBq+?=
 =?us-ascii?Q?vpdsPWQ8w803Y/S39y98TXtq/aB/xgiujquIcKb/fKFmjDBYNbmmTKtJUHbc?=
 =?us-ascii?Q?iyhD8ThbsFtCY6NFEc1YQhQw+Gd7gH6GwwNtIINTY/qKK63IHqvhTnYUZyqp?=
 =?us-ascii?Q?fSMuhoUzZIqzSjkkyU6jEAUBw4sYg3qvrPIpd1yOzEel9QtRZwHZl0+JIaV/?=
 =?us-ascii?Q?HeClNDvcdiOpwuFVevtZE5Ar4bXzVyTbelHfPrA0rD9jov8M2inQE8wKE7ri?=
 =?us-ascii?Q?ehdeeXpCMBV43WSq3sGZEjpUTbgGzzjB/k+9cJQQXXKlEREEy7oPyclE5+1Z?=
 =?us-ascii?Q?hvlS1ODKZ0s9HZxgR89w1hFGr/Nw6Qr4GOViUuYIz96SMpLj9hziK/DylLam?=
 =?us-ascii?Q?U1mUrkn28iY/gKEjGqENJKHNklVJPz2danZojc6SfBegM/JbgGq5foal0EQz?=
 =?us-ascii?Q?dK16JvWIDeAvYNUQ7/SL4sJa2W5RmL0tKMKRwjQpjr4UXA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4D6C285EFBD97E4F8B3DD2A44B28A222@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ee09ffd-9cec-4036-a621-08d90504788b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2021 20:31:40.8439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gIEy4DeBqBQqmpGEY62owAa+asET8uaXuph0clxWv9ZH7z8HVOcPkf/9FuCZWxIkdR239Uhy1qPI3TTAQruGKXZ2NSpJjKb1LBQ4YLZ9dVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4683
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210138
X-Proofpoint-ORIG-GUID: FwbMX63HDAvyqz0ssTitsekPc7dzhKbH
X-Proofpoint-GUID: FwbMX63HDAvyqz0ssTitsekPc7dzhKbH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Firmware can report various MPI Events.
> Support for certain Events (as listed below) are enabled in the driver
> and their processing in driver is covered in this patch.
>=20
> MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST
> MPI3_EVENT_PCIE_ENUMERATION
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_fw.c |   2 +
> drivers/scsi/mpi3mr/mpi3mr_os.c | 202 ++++++++++++++++++++++++++++++++
> 2 files changed, 204 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index f275fbd287f2..7f3b553e5b86 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2745,6 +2745,8 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DISCOVERY);
> 	mpi3mr_unmask_events(mrioc, MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST);
> +	mpi3mr_unmask_events(mrioc, MPI3_EVENT_PCIE_ENUMERATION);
>=20
> 	retval =3D mpi3mr_issue_event_notification(mrioc);
> 	if (retval) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index d13e8c89892b..3d78c558fe2a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -566,6 +566,40 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3m=
r_ioc *mrioc,
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_update_sdev - Update SCSI device information
> + * @sdev: SCSI device reference
> + * @data: target device reference
> + *
> + * This is an iterator function called for each SCSI device in a
> + * target to update the target specific information into each
> + * SCSI device.
> + *
> + * Return: Nothing.
> + */
> +static void
> +mpi3mr_update_sdev(struct scsi_device *sdev, void *data)
> +{
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	tgtdev =3D (struct mpi3mr_tgt_dev *) data;
> +	if (!tgtdev)
> +		return;
> +
> +	switch (tgtdev->dev_type) {
> +	case MPI3_DEVICE_DEVFORM_PCIE:
> +		/*The block layer hw sector size =3D 512*/

Small nit.. space between comment start and after comment end

> +		blk_queue_max_hw_sectors(sdev->request_queue,
> +		    tgtdev->dev_spec.pcie_inf.mdts / 512);
> +		blk_queue_virt_boundary(sdev->request_queue,
> +		    ((1 << tgtdev->dev_spec.pcie_inf.pgsz) - 1));
> +
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> /**
>  * mpi3mr_rfresh_tgtdevs - Refresh target device exposure
>  * @mrioc: Adapter instance reference
> @@ -654,6 +688,33 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *=
mrioc,
> 			tgtdev->is_hidden =3D 1;
> 		break;
> 	}
> +	case MPI3_DEVICE_DEVFORM_PCIE:
> +	{
> +		Mpi3Device0PcieFormat_t *pcieinf =3D
> +		    &dev_pg0->DeviceSpecific.PcieFormat;
> +		u16 dev_info =3D le16_to_cpu(pcieinf->DeviceInfo);
> +
> +		tgtdev->dev_spec.pcie_inf.capb =3D
> +		    le32_to_cpu(pcieinf->Capabilities);
> +		tgtdev->dev_spec.pcie_inf.mdts =3D MPI3MR_DEFAULT_MDTS;
> +		/* 2^12 =3D 4096 */
> +		tgtdev->dev_spec.pcie_inf.pgsz =3D 12;
> +		if (dev_pg0->AccessStatus =3D=3D MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
> +			tgtdev->dev_spec.pcie_inf.mdts =3D
> +			    le32_to_cpu(pcieinf->MaximumDataTransferSize);
> +			tgtdev->dev_spec.pcie_inf.pgsz =3D pcieinf->PageSize;
> +			tgtdev->dev_spec.pcie_inf.reset_to =3D
> +			    pcieinf->ControllerResetTO;
> +			tgtdev->dev_spec.pcie_inf.abort_to =3D
> +			    pcieinf->NVMeAbortTO;
> +		}
> +		if (tgtdev->dev_spec.pcie_inf.mdts > (1024 * 1024))
> +			tgtdev->dev_spec.pcie_inf.mdts =3D (1024 * 1024);
> +		if ((dev_info & MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_MASK) !=3D
> +		    MPI3_DEVICE0_PCIE_DEVICE_INFO_TYPE_NVME_DEVICE)
> +			tgtdev->is_hidden =3D 1;
> +		break;
> +	}
> 	case MPI3_DEVICE_DEVFORM_VD:
> 	{
> 		Mpi3Device0VdFormat_t *vdinf =3D
> @@ -765,6 +826,9 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_io=
c *mrioc,
> 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
> 	if (tgtdev->is_hidden && tgtdev->host_exposed)
> 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> +	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev->starget)
> +		starget_for_each_device(tgtdev->starget, (void *) tgtdev,
> +		    mpi3mr_update_sdev);
> out:
> 	if (tgtdev)
> 		mpi3mr_tgtdev_put(tgtdev);
> @@ -818,6 +882,54 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_i=
oc *mrioc,
> 	}
> }
>=20
> +/**
> + * mpi3mr_pcietopochg_evt_bh - PCIeTopologyChange evt bottomhalf
> + * @mrioc: Adapter instance reference
> + * @fwevt: Firmware event reference
> + *
> + * Prints information about the PCIe topology change event and
> + * for "not responding" event code, removes the device from the
> + * upper layers.
> + *
> + * Return: Nothing.
> + */
> +static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
> +	struct mpi3mr_fwevt *fwevt)
> +{
> +	Mpi3EventDataPcieTopologyChangeList_t *event_data =3D
> +	    (Mpi3EventDataPcieTopologyChangeList_t *)fwevt->event_data;
> +	int i;
> +	u16 handle;
> +	u8 reason_code;
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +
> +	for (i =3D 0; i < event_data->NumEntries; i++) {
> +		handle =3D
> +		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
> +		if (!handle)
> +			continue;
> +		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> +		if (!tgtdev)
> +			continue;
> +
> +		reason_code =3D event_data->PortEntry[i].PortStatus;
> +
> +		switch (reason_code) {
> +		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
> +			if (tgtdev->host_exposed)
> +				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
> +			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
> +			mpi3mr_tgtdev_put(tgtdev);
> +			break;
> +		default:
> +			break;
> +		}
> +		if (tgtdev)
> +			mpi3mr_tgtdev_put(tgtdev);
> +	}
> +}
> +
> +
> /**
>  * mpi3mr_fwevt_bh - Firmware event bottomhalf handler
>  * @mrioc: Adapter instance reference
> @@ -865,6 +977,11 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc=
,
> 		mpi3mr_sastopochg_evt_bh(mrioc, fwevt);
> 		break;
> 	}
> +	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> +	{
> +		mpi3mr_pcietopochg_evt_bh(mrioc, fwevt);
> +		break;
> +	}
> 	default:
> 		break;
> 	}
> @@ -1170,6 +1287,72 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_=
ioc *mrioc, u16 handle,
> 	clear_bit(cmd_idx, mrioc->devrem_bitmap);
> }
>=20
> +/**
> + * mpi3mr_pcietopochg_evt_th - PCIETopologyChange evt tophalf
> + * @mrioc: Adapter instance reference
> + * @event_reply: Event data
> + *
> + * Checks for the reason code and based on that either block I/O
> + * to device, or unblock I/O to the device, or start the device
> + * removal handshake with reason as remove with the firmware for
> + * PCIe devices.
> + *
> + * Return: Nothing
> + */
> +static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventNotificationReply_t *event_reply)
> +{
> +	Mpi3EventDataPcieTopologyChangeList_t *topo_evt =3D
> +	    (Mpi3EventDataPcieTopologyChangeList_t *) event_reply->EventData;
> +	int i;
> +	u16 handle;
> +	u8 reason_code;
> +	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
> +	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data =3D NULL;
> +
> +	for (i =3D 0; i < topo_evt->NumEntries; i++) {
> +		handle =3D le16_to_cpu(topo_evt->PortEntry[i].AttachedDevHandle);
> +		if (!handle)
> +			continue;
> +		reason_code =3D topo_evt->PortEntry[i].PortStatus;
> +		scsi_tgt_priv_data =3D  NULL;
> +		tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, handle);
> +		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata)
> +			scsi_tgt_priv_data =3D (struct mpi3mr_stgt_priv_data *)
> +			    tgtdev->starget->hostdata;
> +		switch (reason_code) {
> +		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
> +			if (scsi_tgt_priv_data) {
> +				scsi_tgt_priv_data->dev_removed =3D 1;
> +				scsi_tgt_priv_data->dev_removedelay =3D 0;
> +				atomic_set(&scsi_tgt_priv_data->block_io, 0);
> +			}
> +			mpi3mr_dev_rmhs_send_tm(mrioc, handle, NULL,
> +			    MPI3_CTRL_OP_REMOVE_DEVICE);
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING:
> +			if (scsi_tgt_priv_data) {
> +				scsi_tgt_priv_data->dev_removedelay =3D 1;
> +				atomic_inc(&scsi_tgt_priv_data->block_io);
> +			}
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_RESPONDING:
> +			if (scsi_tgt_priv_data &&
> +			    scsi_tgt_priv_data->dev_removedelay) {
> +				scsi_tgt_priv_data->dev_removedelay =3D 0;
> +				atomic_dec_if_positive
> +				    (&scsi_tgt_priv_data->block_io);
> +			}
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED:
> +		default:
> +			break;
> +		}
> +		if (tgtdev)
> +			mpi3mr_tgtdev_put(tgtdev);
> +	}
> +}
> +
> /**
>  * mpi3mr_sastopochg_evt_th - SASTopologyChange evt tophalf
>  * @mrioc: Adapter instance reference
> @@ -1365,6 +1548,12 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mr=
ioc,
> 		mpi3mr_sastopochg_evt_th(mrioc, event_reply);
> 		break;
> 	}
> +	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> +	{
> +		process_evt_bh =3D 1;
> +		mpi3mr_pcietopochg_evt_th(mrioc, event_reply);
> +		break;
> +	}
> 	case MPI3_EVENT_DEVICE_INFO_CHANGED:
> 	{
> 		process_evt_bh =3D 1;
> @@ -1373,6 +1562,7 @@ void mpi3mr_os_handle_events(struct mpi3mr_ioc *mri=
oc,
> 	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> 	case MPI3_EVENT_SAS_DISCOVERY:
> 	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
> +	case MPI3_EVENT_PCIE_ENUMERATION:
> 		break;
> 	default:
> 		ioc_info(mrioc, "%s :Event 0x%02x is not handled\n",
> @@ -1959,6 +2149,18 @@ static int mpi3mr_slave_configure(struct scsi_devi=
ce *sdev)
> 	if (!tgt_dev)
> 		return retval;
>=20
> +	switch (tgt_dev->dev_type) {
> +	case MPI3_DEVICE_DEVFORM_PCIE:
> +		/*The block layer hw sector size =3D 512*/

Same comment here as earlier, space before/after comment.

> +		blk_queue_max_hw_sectors(sdev->request_queue,
> +		    tgt_dev->dev_spec.pcie_inf.mdts / 512);
> +		blk_queue_virt_boundary(sdev->request_queue,
> +		    ((1 << tgt_dev->dev_spec.pcie_inf.pgsz) - 1));
> +		break;
> +	default:
> +		break;
> +	}
> +
> 	mpi3mr_tgtdev_put(tgt_dev);
>=20
> 	return retval;
> --=20
> 2.18.1
>=20

Patch itself is good. Please fix small nits and add by=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering=
