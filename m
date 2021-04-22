Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A850C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FAD613E1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhDVRZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:25:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhDVRZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:25:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MH6cFG122577;
        Thu, 22 Apr 2021 17:24:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=U6QP6os+ta3wRbU8UrCtGh1ED3tasdYQoHqmp4wE/lE=;
 b=RWxCUHqK+43UfKtQwTJ+wQM/ao2+8qhgTloMud3vFUVCemB795WWto/V5Muov5SHHFKi
 X95RAyW9MZ/okGI+aneivgA+3t91+Zs21zNc3DX6R+niZQDb34NxSyQb8zKhtb1z9+gz
 eAznXdNlhwCPq2owcurXkicUlZmP36Xw0w2gmNYHaUXWWr6LGZm/fyOA+wqR7lVGuZO7
 KZYrHa1hRhr949gRYpmFr7vX1BMwi4ECkxDP5VOr1zVpYXJJiaZ5F4CW/cFvGKWsNXAr
 /TM3OTNW23PhEgbXTYoyTq3PnzLwr18F34Ny9eMxJpawssX91Uua15P1NcmdE/G3zud8 xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37yveant74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:24:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHJxqF028373;
        Thu, 22 Apr 2021 17:24:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 383cg9b1j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:24:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBAuOOCwX873RktFWEOylZr791Bf9J1iz1/5MFJgvfAVGARm98/M9sB+wUagG/i6D8D8z0/cxMlFrOwH1kkw1QelfQZ6qZDiDMHzt229Td9HzaBiK3wYpsA3YDO9LHPejTLtuGjfaZEeuf5iKalz+WCygysgYgQb8qJwanRI/uJKbArVQ+O7GKkahAeAbjF2YClDEP85GS34M7RYPAZptzA7UdvxY5VPvT8rV8d80qhAe59XjpLBlPJuEpCRMS/hHCo46e3Bid3Nr/yq/f/zvR6P2BU1+/4bP/Y12iJTkHuoBFJe7ynydz8ifpfN3hhWwqBWrWizENjVKAvkcl8R6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6QP6os+ta3wRbU8UrCtGh1ED3tasdYQoHqmp4wE/lE=;
 b=gf2RUe/OsEEm8metw1MfP/cAQWKap+MAZD5FlsiccE3ThL5svwWNdsTTyJK4sv9JULWqXGDmI9Ra0p/olDnx7VKEt9hgYwPiwIcPGJIh59ynZqjClgB3ZhD8JPgzO50TIyjEKXcpX8q9yw7tMU4C9eCsLJH8G081JBEwUq47zzQyjwdOHcmauis/KAz+rbb5zY2ECo8Lsk+jNhq0/licxvoUcEMbUyxZ5bUMLVvwEPli5aexGqJv4HNhGdISQt/mvdeyZWQdYfQtAFXreiDS4yV26Axcw2+b+4LvcPClKFoFpZIUQczcdD8m5H/V+KCnf9IFKPHyfcxqmoBU0BZAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6QP6os+ta3wRbU8UrCtGh1ED3tasdYQoHqmp4wE/lE=;
 b=tyDUJEkzUaxcCPL2q+NSH3b1xKDMnVNWTIxAl/jYzAhjMDefHMkQ9uMbR1gWYiKVzGawhJDHnvgPlYHz7LVf/mZr2UQbFD03MezLQ2PriZ75ixtr6qL3rmCd+sDkQ3Nu5xuE+F34v1c+ewn5u+fc00gF+bXPr6vbNg57aZap+BY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 17:24:50 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:24:50 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 21/24] mpi3mr: add support of PM suspend and resume
Thread-Topic: [PATCH v3 21/24] mpi3mr: add support of PM suspend and resume
Thread-Index: AQHXNQudtmPlE3aBCEyGn88gjpOErKrAzrUA
Date:   Thu, 22 Apr 2021 17:24:50 +0000
Message-ID: <7E0473CE-0581-4769-AC20-DCC0F5E6FCEE@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-22-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-22-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8adcee40-b147-4946-0b70-08d905b38903
x-ms-traffictypediagnostic: SA2PR10MB4732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4732E3B679370E53384EF360E6469@SA2PR10MB4732.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:229;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 93oCSgtC7p6yNuVoiKsmEdmTSv8YTQn78o14SKp16rySH9rPBcP6GRQI6WV+cX1Wv280th2Jk67MsBVjBkV63v2w6jmhg9vDHoSwMk9riho9JKRBiFAh7begazYKfse5gOejn/seg1UiDevfRfCWxUcbJXXOwTjlKB4nyZxoDcfyxf9lwvZ+NLjDe3FfyRfJA4oBBLrSB/e/RyaI+L+ezEDwNySgct8Z8WGyC1MeX5fg6scVwRHrJox1GN/N01ItItXThZiFuHWDyLa6mZC2Lz2IKuYqiNCiJLsw8WPI+WBogks/AUfelt2eG0JgWKLCUF1/vHSZsgroH7wynR1T+wX2TFtXHDzU2VGf+7j5u+Rd1JKfTL4cBENZoJg71BehIzcek9Qs1LGeUNcwmyxCeD87rNgU60ruX9EwYXSmAoqQC/O09a9baST2YxC1cQoRFWYTbobS6a/K4mofKuOVchy64HjQKP4egmXZrxa0Zbg1UKE3wSryn6b9RSaEHkrr2GbBQ+fVz3uEgCQm5pZERqzCsgTkto4cK4ZEk17BhPwdHpkFG6y3CO3G4eksqOaydBNsQ1MRy2NWSLrepkVdHR4Ory1h8oeoufhtAzVhQaM3I/snqU5bnHJ7mHk8XzgBKRngzy5ItjtapT+ooT1YLEdz9uzA1FG3ygUsFW7Pqs6V9ZlhdA/tEn1yI2T6lwvT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(122000001)(6486002)(33656002)(2906002)(478600001)(316002)(71200400001)(83380400001)(44832011)(86362001)(8936002)(76116006)(66476007)(38100700002)(66446008)(64756008)(5660300002)(66946007)(36756003)(53546011)(26005)(4326008)(2616005)(54906003)(6916009)(15650500001)(66556008)(6506007)(6512007)(8676002)(186003)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?G3rU9NlVDsjuiMMgCKDbcyGrWap5HY884cqMqCxSSgo4Yt1M23r8iKUIDTjA?=
 =?us-ascii?Q?Mn8HoXUudPPLtf6VQF2tidv/tLKwzqxRxftRt0suaqj3Siy+dSiF2ZbfOEy7?=
 =?us-ascii?Q?LXbuvLmI8dgiNDMBVwAuhy8E6rti8HPGkuzosRiqgSEP87NFnj+WJaPf1qmn?=
 =?us-ascii?Q?s51lmFkhvjneu8HbR6B9FgQJSXLQPCul5t25d7OuSvWt3snsXVk0JS11L9uv?=
 =?us-ascii?Q?JEn1v1dHYMuRKW9MiBXGGX5BetE0xsA2hds0ayoPXI/+J4Sc4+c2dAWB/Xt9?=
 =?us-ascii?Q?ZcIm5d911JZt6H83Cvq0MC91iwUvgpA4Xz4LPyrnSbyESxPmC0jfsqTiCwRE?=
 =?us-ascii?Q?HI9GzIMXlQDaPvdwW0jDgqMmWgtOFKTmPIWW1ebmhATTS2vNi0FPsAYwOBgI?=
 =?us-ascii?Q?rtAdhUi7hACeoEE1eztZ1UzHyfA8LJzzybJyV+qAQGzqamRwigZj/ENjJyQ2?=
 =?us-ascii?Q?GeDTgS7b+DZnPFD7p4ozxJykmTVM5lUDH+w7Z/afgc9sJzcCy00zK5/PgdnJ?=
 =?us-ascii?Q?9czeSwH9mDV1zZasBK6KtK70o9hoaApGkgRdtztr/i7BKs8wTWPlsSWUvvSt?=
 =?us-ascii?Q?Wx3Ou89cRgudvjhls1TwKwu3utfEXsSSLNW+2nYKjoCqwJQ+JREOyEKLZ6Og?=
 =?us-ascii?Q?pzvCgvE6alvFvnBHI0udeElxzXvHEGicLjmq3DeAnnrmZmnpFk4nV+geNY66?=
 =?us-ascii?Q?iue3HgJZ0LYeOo4a9dWltKN7H0Bd8VHP0vvhkacbOLezGoh4KkuFXNBvABLc?=
 =?us-ascii?Q?hxleJ4bkMnc0G25bOfL32YZ6eowndAO/83kCGUHLqM2toLnak2azRJsHWN2f?=
 =?us-ascii?Q?S9mYEUVzRvx4f1QgVrpMs+pcWJuo7JVjGwc6CgrJ6zMk6MusEbAvhz0FfXJ7?=
 =?us-ascii?Q?V23iMbEln3suJkl+3iohEASc6R5QFS55tcvPcppHk8a6C7+jTYR+oyRajFOW?=
 =?us-ascii?Q?oltSrYhAu0RUUhC9AX3Y0HZqEIfaBJa459CK75t/YcvOh5v+CqKwkJYUlFTj?=
 =?us-ascii?Q?KHkcJi3nS0PIggn69BksMp+dSDMh8fpt2ZS1NkVzd9Vi7z94P0LMT66/snrW?=
 =?us-ascii?Q?4TVZ2/oseDZEQgZBIDdO9vmrQ2m68RR9AKrzkDTs/V5+F8bowDKknKhj7d8w?=
 =?us-ascii?Q?eWCzcIvYF6jo3rrDyyPQq44QDyMF2SlQl/lMFwX80relRXeJPU2Vpe7eyGFX?=
 =?us-ascii?Q?TwRTXHDoOU8oZWU8y5XjciU0IhI1HvGu9kltL7gvO8vtspl41+mG07J2Cl1Y?=
 =?us-ascii?Q?8E9l0nCLFCozESdctt0GQLotwB7KptgquIptE7MnhYm6p+XAdoVzSq+7nRKp?=
 =?us-ascii?Q?ZOFc9WDEgCr3UDh95Bbpxxhpnr3NxpJLs4CaLOcIrBA/5A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9A35EA703190EA4186F923CC6A45EECC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8adcee40-b147-4946-0b70-08d905b38903
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:24:50.4530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8OXwuUTbF9QP0ZRKikx1thneqWR1oqTtFe/07wHgwNZlAm/fn2kc4pl0tGyAWTZgq0yka194sNuI+s4oYG1+NNN8g2Vb8mvJPJlbEicEuSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220130
X-Proofpoint-GUID: vhN6lAkgwSUoAROEZJcK3_OAGRMEE8c3
X-Proofpoint-ORIG-GUID: vhN6lAkgwSUoAROEZJcK3_OAGRMEE8c3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220127
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_os.c | 85 +++++++++++++++++++++++++++++++++
> 1 file changed, 85 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index ccee3e7359ec..05473b0f3c9e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3409,6 +3409,87 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
>=20
> }
>=20
> +#ifdef CONFIG_PM
> +/**
> + * mpi3mr_suspend - PCI power management suspend callback
> + * @pdev: PCI device instance
> + * @state: New power state
> + *
> + * Change the power state to the given value and cleanup the IOC
> + * by issuing MUR and shutdown notification
> + *
> + * Return: 0 always.
> + */
> +static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> +	struct mpi3mr_ioc *mrioc;
> +	pci_power_t device_state;
> +
> +	if (!shost)
> +		return 0;
> +
> +	mrioc =3D shost_priv(shost);
> +	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> +		ssleep(1);
> +	mrioc->stop_drv_processing =3D 1;
> +	mpi3mr_cleanup_fwevt_list(mrioc);
> +	scsi_block_requests(shost);
> +	mpi3mr_stop_watchdog(mrioc);
> +	mpi3mr_cleanup_ioc(mrioc, 1);
> +
> +	device_state =3D pci_choose_state(pdev, state);
> +	ioc_info(mrioc, "pdev=3D0x%p, slot=3D%s, entering operating state [D%d]=
\n",
> +	    pdev, pci_name(pdev), device_state);
> +	pci_save_state(pdev);
> +	pci_set_power_state(pdev, device_state);
> +	mpi3mr_cleanup_resources(mrioc);
> +
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_resume - PCI power management resume callback
> + * @pdev: PCI device instance
> + *
> + * Restore the power state to D0 and reinitialize the controller
> + * and resume I/O operations to the target devices
> + *
> + * Return: 0 on success, non-zero on failure
> + */
> +static int mpi3mr_resume(struct pci_dev *pdev)
> +{
> +	struct Scsi_Host *shost =3D pci_get_drvdata(pdev);
> +	struct mpi3mr_ioc *mrioc;
> +	pci_power_t device_state =3D pdev->current_state;
> +	int r;
> +
> +	mrioc =3D shost_priv(shost);
> +
> +	ioc_info(mrioc, "pdev=3D0x%p, slot=3D%s, previous operating state [D%d]=
\n",
> +	    pdev, pci_name(pdev), device_state);
> +	pci_set_power_state(pdev, PCI_D0);
> +	pci_enable_wake(pdev, PCI_D0, 0);
> +	pci_restore_state(pdev);
> +	mrioc->pdev =3D pdev;
> +	mrioc->cpu_count =3D num_online_cpus();
> +	r =3D mpi3mr_setup_resources(mrioc);
> +	if (r) {
> +		ioc_info(mrioc, "%s: Setup resources failed[%d]\n",
> +		    __func__, r);
> +		return r;
> +	}
> +
> +	mrioc->stop_drv_processing =3D 0;
> +	mpi3mr_init_ioc(mrioc, 1);
> +	scsi_unblock_requests(shost);
> +	mpi3mr_start_watchdog(mrioc);
> +
> +	return 0;
> +}
> +#endif
> +
> +
> static const struct pci_device_id mpi3mr_pci_id_table[] =3D {
> 	{
> 		PCI_DEVICE_SUB(PCI_VENDOR_ID_LSI_LOGIC, 0x00A5,
> @@ -3424,6 +3505,10 @@ static struct pci_driver mpi3mr_pci_driver =3D {
> 	.probe =3D mpi3mr_probe,
> 	.remove =3D mpi3mr_remove,
> 	.shutdown =3D mpi3mr_shutdown,
> +#ifdef CONFIG_PM
> +	.suspend =3D mpi3mr_suspend,
> +	.resume =3D mpi3mr_resume,
> +#endif
> };
>=20
> static int __init mpi3mr_init(void)
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

