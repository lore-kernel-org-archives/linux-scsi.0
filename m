Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C75C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 08:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbiGSIgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 04:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiGSIgI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 04:36:08 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AA311A28
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 01:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1658219767; x=1689755767;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4qA0fQSgPeHKZ0Z3GGMtYr/vh09xU8gNN6NrE5neNOU=;
  b=OIAiXW5b7TVETmxb4wpJsfpfAt+242AYdYkoaOU1h5ksQWsP2tgaszbk
   tvExegkhhoPd4rT8cR30T7DddgaxFVE7Dp3PPo0Xy/jHbytylv89KkGK3
   6mfSFGhSpHt3G3t/+7+gt7xTv3IbmQ3OO9G0ujqTN+3ClR+TWluUkwN+h
   ckPwGCqJnTEiwwwpY9lfORykT8wx3up8HNReLEwpRqRKhaBsopUI+QTbe
   vnHihwIFJrWg8Z3DVxfkWMJjJyx/f3L0rMp5DZObtr7ZSUw6sl/rCoQJD
   egUn+lWHoIkbLMH9xndFDgQTt+ppCElPdu/KIVaHLdmdVRKEvqjIZgc5Q
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,283,1650902400"; 
   d="scan'208";a="204900455"
Received: from mail-mw2nam04lp2176.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.176])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2022 16:36:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLIN0SZJm+lcYT3pJupEGpzHzUBOlU5KoW+o4F3ew65nBpm2BHUuU/YS3RQkqbf2cRz3N8OQdNuRSTcXL5HqDecXd0NcZ1Tg2EblUEnGSKD4sJ9MxwVwzEQkgW2y8sAfZFFAyrH2qgXL6vBFXmreyDigSiVPw1uNPhW5JkV+JAAcTD3HEED9BCsdlG6u8y99/5eX/RmjGH6zpV+bBozk3qIQBc005GgeLTgqTA2Z2SEq+sOm9VJWU3lwKgGIazTTsEjF5BB4fBUgER17IeRVqNXd28GkhW1dQxSyiETIYKXn+TLIc8XCdkHh1tGDC2FdQTbqrPhZ3ZstTfk5cn10fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3gebAdRpBOqVF+P5venWWIuNW2sIIFH1K3+WpMXid4=;
 b=lxVDhA6Kl/7kRIGVHvrR1JxQwGVwpVdiNWkVn94GVAX1jUe9JYCqAoXGx8uJbcpvQYl0OZRoOcg0glXAdyqFv7gYTjUqSUhuE6RIx9d7grkcWCYvT/JzXKCdvnquDg2CuE2UcBX2A6kTGH8MKoAce519zLMjw+6bpvEXn0XadM+63/dolUT/DPKZD6+SXPtwthtcUxSf0uPQWN8mcsLX+DNFMx7XPmiDJRBMZiwaM47DZFbwZlbz1FPaPkH7VylmOvsgduoIkJctH0BVrOLjwZeN32zFbCIdCAF7hAftvXA0lNs3q+sF/JTfGmbUltd+Bd5DpbqpgB2FfOONaGHw3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3gebAdRpBOqVF+P5venWWIuNW2sIIFH1K3+WpMXid4=;
 b=LwG3FHLq7HKH8CbP8in+L6mKgg1R6QF56jjQS6ETu8Kc+Ymi9N/1+5du+hadN5I7ZZ4efIH0puZimvkrtY2adfldu75FUZg2IjG2yrdWXAK6iZCar+tbtj9iD7XE58m6sTTgTkeShJqiV2JWuqqw08YpjL8TklNCAmydfAMPL/k=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO1PR04MB8220.namprd04.prod.outlook.com (2603:10b6:303:163::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Tue, 19 Jul
 2022 08:36:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%9]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 08:36:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>
Subject: RE: [PATCH v2 4/5] scsi: ufs: Add suspend/resume SCSI command
 processing support
Thread-Topic: [PATCH v2 4/5] scsi: ufs: Add suspend/resume SCSI command
 processing support
Thread-Index: AQHYmJGDOb6L/tM/Dk2fJtMr/xN6Kq2FY90Q
Date:   Tue, 19 Jul 2022 08:36:05 +0000
Message-ID: <DM6PR04MB6575A62C5B5985269CC10160FC8F9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220715212515.347664-1-bvanassche@acm.org>
 <20220715212515.347664-5-bvanassche@acm.org>
In-Reply-To: <20220715212515.347664-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91e925b0-0a62-4a82-b2b3-08da6961b84e
x-ms-traffictypediagnostic: CO1PR04MB8220:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sq970P/43HpZtxTekn9Jf+7os7Qd6zU58SLk7N80VyUmcNDqYv1FjkBC/9QnG6RXzkchAxwXOvdYSzeWOlXadS5ivY4vilTLvJAdZIK4/S3KMwSIeox3+vSqvncQ48NSwV6Bc9cBFAZn6eXIsuHDDQK+vCYBqeuUfZw/n3mTP3bpqSVzFYlvf2U3S1Qa57vvMtH8o7GkP47Kf+gSxjwfHLh6m0KyPTw5TQCu0SmcxLgC+e/8DmwCtYStd6Th8rXTgMwEXpNzJ3bXWQf2crxbmoVxgohM8QarpJ6HJ3hyikux/npkc2x+fGfpA/KMnbqcE2f904PVcFMqqBtzXzwZ7eSjH8T76cEDn4b53QdewCSKnMaNaH/ptMbDdE3+Dm8b1GTfYwx5i+njjPCH0JpZ4TvTrHEcdp3xcs+n/4Sfq3h65UXqbHRab7ktDmmTRX7hFbuJAawYDBoTuJCsBLn649wKjeRS4c3yCcZ4qFTzIY6y/XqDFtdUiebkoic1Af519/iM7qYXvp6PGHjHb06MmNmWaYL3opVGDwhh+3GaNSomXgTkGyCop9wrn21G+bohX4lgTBv72FlRneyw6rr+uuzYZ2TbnW+8JCkbNBOMq5NmNdo1eGgAcfZrqo3PsDlffPn03J+kXe1LNxdGY4QfV8XTlFP/9s//jZKy0koHAc8tW3ln3qGstlhDkhX5tcgg66xsoS7PfUX1VdS/icmFaDCLjuunA3E33KYvRdhTWZtfAjuEFJS7NThoVHOpEYvG9ne0z3ZEZn0HJSgg1xLUyRGtjDtM5K+ERUf4sanxIW9ugyyhN4P10o5tOXoIYg9t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(8936002)(52536014)(33656002)(86362001)(66476007)(76116006)(4326008)(8676002)(66446008)(66946007)(64756008)(66556008)(6506007)(38100700002)(110136005)(15650500001)(54906003)(38070700005)(316002)(55016003)(82960400001)(7696005)(9686003)(122000001)(26005)(41300700001)(186003)(83380400001)(71200400001)(478600001)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CmuZuS5A0ncujhV8h2rFwI7/nddYxLXVrCCKYXHGSsleS/qnvSVQgl2JiO7d?=
 =?us-ascii?Q?Dq0ftL/ZfauHgrFE21atCLOeGRWITeDMWAyQMWI6Cjo3Gzl0xVMWLdA/r+DZ?=
 =?us-ascii?Q?1bosrCG/RLASsCS5puTxeIig/W/Z6Whv9LlfADKexDWicvQnfSq7AStTbboB?=
 =?us-ascii?Q?9Z+EKP20zW9fDGVg+E4u5XoZovkPK06zwqEOF8rjw+7nmG/fcigh1Bwe28K3?=
 =?us-ascii?Q?uc5/YllLZxxdpFPdHwEvFETKCqvc7s/MZJ/UHKwZuDBr5grHuzFXLhdhCgoi?=
 =?us-ascii?Q?uufKOuPwzVd50mYuMapj1WoxbVJtG639JzOnjgg2jAQitS3Fh3+JPuw+03Dj?=
 =?us-ascii?Q?noh+sChOtT61AVlQ88Laa6CqqTNYGdhnvrJoVY5VkpttCSOkHvx9JjYvEFT5?=
 =?us-ascii?Q?ipPcywb1YgiTD3gBX4Vubz5Ps2fSh37lCmk+AUiUaf8C5gcf6d8Ce7XLnVPu?=
 =?us-ascii?Q?u3tBTY9XZEDTa2EzZPXZ6OFQE7WYbQ1Xd1V494sklU+sg4ROkv5xPAZcNq09?=
 =?us-ascii?Q?PepTIsb462xL8mw8lygBTyno/quO59fH/OuzTqVRDJYsqgOr7kyx5x1CXGUd?=
 =?us-ascii?Q?BFzXGeY6uAmqRUOr+y9/Ej+ms8hr23QZrZHZEKictHNsFuHW9su5u2E8k6oS?=
 =?us-ascii?Q?joR0Hv3CPOmp1v+gvkNvUiuBoZOaDi4lHX19W2Zheqjemdv3YbqnfF+SruJE?=
 =?us-ascii?Q?hVq80MKtrFDO2enr/B610ksK6EsBfr14zxzn/kmsuT0LTru0Rl2zO/Om9F2A?=
 =?us-ascii?Q?ppKYebAF6Nzlw/qEa0JhMwF3rkN5N7Uwmk2HJ1jHzRh3rTPrxpqn47fwlUv1?=
 =?us-ascii?Q?GITrU0jqb6FU59BVa3iV/cVDc6j0Xgh+CjSSa7W+KNtg451H25IR9Cyr8JzW?=
 =?us-ascii?Q?93zyLgJQusq3lfr9nuxY3V2kadWsBD8rWLPNy2Vg8vL0aPfXeSILFqhV/EGz?=
 =?us-ascii?Q?boURjodd1/Jyb+m3k/8JNROnLt9CzQ+eEWfl2ZeL1mEX6xNEVfmv+gSW+FEo?=
 =?us-ascii?Q?4eshHt3yzEMlyWooQbwn55iu+Nc8z4HI1AYO2lFfwpi/PwD2ghU282MK43Hu?=
 =?us-ascii?Q?fdLUm9vEU6FvgYujYg0Cz2nS4/OWnXHPZjzsaEscN/bc4RxfD2RzH4Qa+0xe?=
 =?us-ascii?Q?trN0amwQX8ZO/qsQ17NO4rcBktMCoOrFvSoy1LRzEEgmXnuE3/Hi7IW26Gl7?=
 =?us-ascii?Q?skBse8Fi1esNIqMgyU/0M2CzJj4eX0/pZl9v3bRdtI2e/IC8qni9lGYeCyPJ?=
 =?us-ascii?Q?4kFkCMBmqHEvhpDJp2pCAaBlbmJa7ZOitO+t3JgeViWkuJip/y77CMhXq1Ye?=
 =?us-ascii?Q?YwQoeYfsP7xzmMfflPrh06jgTsxyCFdqbKFQZNr/vdAFCLsNi3SHhZNsBAYv?=
 =?us-ascii?Q?tDrnO0MQcwTYtMTWdJrysVkosDXHCGq7FVtGqBVlejbsnQ+/6HzR+aSaLexF?=
 =?us-ascii?Q?kHSuVGRRYr/nk8NSbxt2QTR2L4rf3x7z5BJFSs148/Nk4vTbf3aYc7y7Isu1?=
 =?us-ascii?Q?Rb0trLM7OzMEZM1VsgKyaf7fa80ORkbpF9UZfw7KJDscO5sUHvAA7hmvD1gb?=
 =?us-ascii?Q?kRy/NGx9ogQDprSZx/G4zo2g5FapeS+OyPdFHiBG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e925b0-0a62-4a82-b2b3-08da6961b84e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 08:36:05.0787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ETExwdupnFhU8tk4A1Rf8jThKU2EVbKb187J906iY9CSjLpRGkNjWLig+GXKeDnnN0L8FksZfSxK8wxTngYyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8220
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> This functionality is needed by UFS drivers to e.g. suspend SCSI command
> processing while reprogramming encryption keys if the hardware does not
> support concurrent I/O and key reprogramming.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
>  include/ufs/ufshcd.h      |  3 +++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5739e9d1b970..8363d2ff622c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1700,6 +1700,26 @@ static void ufshcd_ungate_work(struct
> work_struct *work)
>         ufshcd_scsi_unblock_requests(hba);
>  }
>=20
> +/*
> + * Block processing of new SCSI commands and wait until pending SCSI
> + * commands and TMFs have finished. ufshcd_exec_dev_cmd() and
> + * ufshcd_issue_devman_upiu_cmd() are not affected by this function.
> + *
> + * Return: 0 upon success; -EBUSY upon timeout.
> + */
> +int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us)
> +{
> +       return ufshcd_clock_scaling_prepare(hba, timeout_us);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_freeze_scsi_devs);
> +
> +/* Resume processing of SCSI commands. */
> +void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba)
> +{
> +       ufshcd_clock_scaling_unprepare(hba, true);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_unfreeze_scsi_devs);
> +
>  /**
>   * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_rel=
ease.
>   * Also, exit from hibern8 mode and set the link as active.
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 7fe1a926cd99..6d78bcbedb9e 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1194,6 +1194,9 @@ void ufshcd_release(struct ufs_hba *hba);
>=20
>  void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
>=20
> +int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us);
> +void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba);
> +
>  void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn
> desc_id,
>                                   int *desc_length);

