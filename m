Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50AAAC71130
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 23:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356114AbjHQXgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 19:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356193AbjHQXgt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 19:36:49 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A6435A5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 16:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1692315407; x=1723851407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6wzyduurAysIq9zOxVbw0ERdeUF0Uf4O4293JJNJCao=;
  b=lu+1d4gaG6ZbY0A0IvPlX3F7aJzul7DMM7/hiDa1xCPsOvBgvj2YEUnX
   +ovAsnuK7spLFK4G/94Nn3RWz8fQcd5sW935/o0Z6AtlidB2ulXvG4MbP
   I1CP15Dm9B0U/KYoViuN1oZxaBOi9Ss3WiYkKBkW8SgA+07Xy/2CUE13Q
   OzsJqGQoxWDAMyeIYdIkNN88vfjEL/e6eLEaSowmB2r7JjENXEwWfrVrO
   a3ONiuYmLmxFxmEzT66/JILY63jteQy2JvtiXSuLOGJPrEyHpaSEJ3wRm
   XiFNmQa+GUte0vpSm3XxAp04XosabDxCiHxo8HI4NEVFC3DqNy9IzxaTI
   w==;
X-IronPort-AV: E=Sophos;i="6.01,181,1684771200"; 
   d="scan'208";a="346616281"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 18 Aug 2023 07:36:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVVFnrtoDJjlx1imwHe+awxNm2ht2ALqLunLyyuyXxbGlCNSLtXmwrt8hKsyE3z7NzWNKwphqOJaGMZZO4jdXRViX/WB6IZqiq93HU+4qn7nEHX8C5lDuLIJaTJ2ZZLk5zP1swqlZU7U+CRuOxQ0VbRQn1chY1gy5xX4JKSFqLqLAJGBB65W87qWFknKMAYzY9ZhPMnszLEdqZ/Ti6Ssn0p6UqSp6gk8itl4XNR67CeZ05ezlZesZlpYEYVNBXOmw9Qtz6H1hwZSnNCu/3h8Lr36kOz6YYZvxxxG3CmyofsVMmRQ3aUOSQ7PkcrbvrzR2V17y8Owk/WCAKFXBoi52g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2RkgeOWAmGWWTyb45/n+vzS6l4kor3KYxQVMpjuOok=;
 b=j9urX3IGjD6SMAbup01XHQek7bU/WWNqmy1m7CR346UMb6O84pwnbdYYY3XUY8+a3RhgaX4oE9yDK/ykwoFPVj5GjTcNO5OCOl0GIsmgQfofyqLUfaR21kVRdZV0Kc/sitfXygc8t5wEoIBQWjdCWCcBKl91ziR6Eh+Kvnr3xfi5bWTU3YrCzLcgfy1uBIDU/VfOt7vhIOQFWUuqsClwrhK5uJ3ucvB7ZyML45cVTVjntZduClh4RDrLgv+Fon7DD2F7S0/tiQbE2LFi2jKOp+l7RsNilihg0Cc5nNofQP7ebAM+EccNjokTXU+cvvSt+kkyagbZwe6tPXUHHiHcvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2RkgeOWAmGWWTyb45/n+vzS6l4kor3KYxQVMpjuOok=;
 b=EvC94heQORRajgpi26yS4rpxEkSgLY4JblouF3OPmvXnwk8KZthfRy3AJvIA8TW99EqdLtWS8M8PnvLGx1fITpqlTB/Ky5XjEiIXL4W2stlMmwp31LvbKcajN6h+ZXfi8HFc62MdP+Rgu3VYHybAT6lhhm07Zy5tIOxNuNlb66k=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 23:36:43 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6678.031; Thu, 17 Aug 2023
 23:36:43 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Igor Pylypiv <ipylypiv@google.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Topic: [PATCH 2/3] scsi: libsas: Add return_fis_on_success to
 sas_ata_task
Thread-Index: AQHZ0VO0fxFCEX0RQUu2CJj+KjRNT6/vJK+A
Date:   Thu, 17 Aug 2023 23:36:43 +0000
Message-ID: <ZN6vB0COt0eJU93A@x1-carbon>
References: <20230817214137.462044-1-ipylypiv@google.com>
 <20230817214137.462044-2-ipylypiv@google.com>
In-Reply-To: <20230817214137.462044-2-ipylypiv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH0PR04MB7383:EE_
x-ms-office365-filtering-correlation-id: 6895e1fb-3b35-4c90-975b-08db9f7ad053
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nAvWX1c8GQOkA7uRFt0onsO/5w7fHWyKpYzArbZIkcpgCHDPskZGZFc4mzI3mHzdwLQY347hxwRm4WfFGui7Md9RmeNKhCZ4x2nCjqCcw6mbX8NTp/kDfogBsNPkeEj1Ew7fWRdbXvcxy2lFaX24PIwVqTGxnSdIjnr++JfoWgz8QKJipAq6jLivxHwgB8WF0p97Z0emiX1lPMwBRU/CKSrlc8QPYP0dDtImRDpXjjv/cbc74AqVdpjv0/qIasPcUQCs3mqcVUaN2GI140g/Ju8PitPQSJoWUaHBSfG0UfW7yt7vXp2l/8oUuoyHaxaomWrAqI3iphWUF8pyz0t92oyl2yZ8VokCoH8CwtCrnAAPlgNUD+vbiEYV8luLNjHkfTVo/FB5c/bxoH7xTmRBtN9IUJugySVnC/jtMo+tXjK4r5YxpvmY83AJ5H6qMB1RjJDG5PDr+vqhoNn0nu6vey6jNgtYgz9CRFT9mWjQ99oc8TIPeOOirLxdnTTyTMV0sXHIokwKAWf15VaJECVs6UaVATiKcP6K9JXmeWGSphrbwv+LQ54ATjjjOAf7lN+47OrP6ZXEBN9DKm9H0cMds+ti0zOb6bpHQAwlSle4t45OFLRWTXbh2i0ZK8OysNOw7mud8+6LkBvcqtWbz/l5Lw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199024)(1800799009)(186009)(86362001)(38100700002)(122000001)(38070700005)(33716001)(82960400001)(478600001)(76116006)(966005)(5660300002)(66556008)(66446008)(66476007)(64756008)(91956017)(71200400001)(6506007)(6486002)(6916009)(54906003)(316002)(66946007)(9686003)(6512007)(26005)(41300700001)(8936002)(4326008)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Svn3idCEKLP2PPDJJ5qQTMf/8swJ9ccCOItQyrOsZz9OiIWox9snUqDl3EB?=
 =?us-ascii?Q?FnkitxBsJ1ZQAeza/sutt4E50L7tUCzVZogX97Z8qsR3qFAiq9Ivwe/Y0BxY?=
 =?us-ascii?Q?4Dwi6uAPxvHXSwtGE8IxaoyEHB+TdtTkax5k8SBANK1PWW4v1NpgocwncyNT?=
 =?us-ascii?Q?Tmo96ejyZMWlIvUG6ezI2jS3UvG+kIgEeyOS62bxMaIQKJ1+tAPUcWEuob9q?=
 =?us-ascii?Q?zEvwgd6imMMRXJdceXUgtnwwaJ0MVac9nxL7Sv2gNF0YcaFU0RgqP8gLw5Kf?=
 =?us-ascii?Q?MSAcM0eavISCMXo56SWSDavz4mCGYr9N17RcWOdSnoTfjW94j7a5ZwaWJLsb?=
 =?us-ascii?Q?o5AuOuqE05BBLhaPDagrXBGGqL7hbf8a60Us/H5p/g2hOtVDYOfOESyfIgWc?=
 =?us-ascii?Q?KgpX8zZ14zOv4zPmfSJ90D1h2Dm7L9ZOu7HN/EFNJeqhVDfo9WnFgf8/Kj0d?=
 =?us-ascii?Q?RuYPspYEno6WryCZj1PigTKB3tXRE02njCN6XcYabBNZ501iUfC56qwi7A9N?=
 =?us-ascii?Q?XE6jIenaqaKL/b6FE5qWJMm5wHNiqzsHGdLAM3tomGiYZ1fdmvaVGy049DK+?=
 =?us-ascii?Q?uJ3DCwDA8MIqtqOCpg7sXwH/1GmvBVM7kGXzpVuDfYnvdJJ9vwGHrCd32URz?=
 =?us-ascii?Q?4SH+A9aK/WoO/AbpebPSo9Ofd1iEogc5hxV9pZxFihbiKSIXx5UBjCDOuM4z?=
 =?us-ascii?Q?GnFa6wc7j6KwgkReXV9OWnctxjYlOkCVnW4oRrf/33Uz02pcpl6k8xySf/TC?=
 =?us-ascii?Q?y84CGUb6V65rMRIBKM4tln11ltKEsmD+5GbHhtTJLyoQObRvQ0eGbbdSP3HD?=
 =?us-ascii?Q?mdG4kCZrVveUSuit+D8x2OuX379UBcXg7uZ7M5u4t2KBnFd+eF0G2TQUsf30?=
 =?us-ascii?Q?Gp5VmOHPnaVM+XoOysJg9Mk+kmHyam6Jz9ao7JQl0MCTyEcYgiUvm4j186Ep?=
 =?us-ascii?Q?p+zZzryjniNTAfFcviVUy7yHVp7FrBpTF+LuH8yryPCL51wu8zqFofs9ty75?=
 =?us-ascii?Q?m0/3qIa5LnE+oAFq/2iiD26ZPXMN1Ys9mo2qcMiem3GyfoqmAG/S1u9bACZC?=
 =?us-ascii?Q?OveXORKXrBuLinEDMUJaqzVgZOUpT5O31wUXiAWut11vW5qolhk0tWGq9CkA?=
 =?us-ascii?Q?H6/CxzDr4BvHo+LbLVuTV2lhrqNuvmFoEiSnAvLUa67TZ+B9UjfxQfLqAkKr?=
 =?us-ascii?Q?oUi/Q2Gux+YW6Qh6aXFhpfKbU43YsoiWrdH2HKDOsAuSVlQrspGkaI9S3qzY?=
 =?us-ascii?Q?X2FH9vlbHHzNvADzseZTWfidJxutHQLH7SGqOzrvDyTt6SPTnC5ML7my3xD0?=
 =?us-ascii?Q?HDTWeXXFKHW76TWil/JgGMBf/bvqLGiLVnlw3+FO5Rdzk23hWQVB0tdbwfIy?=
 =?us-ascii?Q?McnyvEL6CKMt2LuWdXFK+uB01kyiCs9yyoLkSwdVpQ57InWqjJWQ3y+kCLG4?=
 =?us-ascii?Q?twBdt+ABfZSYjk3fxwZjm39vAuEmUjFWO8tyYIBnnVbHxEFmJ7Xl0UuPbMTl?=
 =?us-ascii?Q?Su2G2Dz+Oyrd6D/UNTnRKdaqvJQdtWvRSMKNIMHSTdl+/wQ8Ar/Zh00OYUt0?=
 =?us-ascii?Q?mWr6X67NWvOZzM8tFRKxLvrm+plYTVvHIT2BHOWox7V6oxvSoUygtOANx35L?=
 =?us-ascii?Q?jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C035184982B04F4297707E1851661884@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?lOrVBnfnktLQ6hDhBh6UAmwKWaQMokeO96QUcmeppP6sRWrZyBDBHkYZD4e9?=
 =?us-ascii?Q?EL3ndN96epctnVQGoDUdNSLZv/DKXlPwOeY9hsu6a96LYocFu6XDjOjkpJG8?=
 =?us-ascii?Q?bpLHBikBHnxAln8k0lJvGoRgU6UmfntwID1lt2TkaAAHWNpCZD5pkbTFWs5+?=
 =?us-ascii?Q?QYEWMYAD/iB2c7sv25gxXndxfQZCPnCdk0qHGHZivapxazarujhSPZtKiDJP?=
 =?us-ascii?Q?oH7XF4Lw8NHqOr69XoCKLiB3Aw/fsFg2oKjuDLINQxBmAAErs95MYFVHbZDl?=
 =?us-ascii?Q?NjN9Cco2b/YFrW7z7Ghf1MlYJo0eVv28FtI+ftr12RgbDrmjoJTQ8oOpuScM?=
 =?us-ascii?Q?wxUN9Vc0AwmwOEAcgLgPgNdKQ7cp8ZMG0YyqxS8ZT90OCI6R7f35JNvsTety?=
 =?us-ascii?Q?IN5Ia4qkuVCblSn34r5UeW0/SF8KbWZPD+yrnLH6J25YSwiKBgm0TQNg1ggG?=
 =?us-ascii?Q?mNGOUsCt0VIN8th9rMkJ+dSVvUfWkHwh93ppsRqOhDM9QnEDgjh/cOhaOzYc?=
 =?us-ascii?Q?HEkVGJGLtMRNXo39cX2956J94mlkn1D2JXoG63DrYJadTjjTGlUaYwLbW/Y4?=
 =?us-ascii?Q?jneGT/e9fLEZZsGWmurdzx7d7Fd9Bnube3T/Nxd0MSZtU1nJMbpOrGMQ4TKE?=
 =?us-ascii?Q?z9+jRV+FZuBPRjOFOQRHoLrDPs26qEk/n7HYuV9i2xzpqwn5McKAKQ8whxII?=
 =?us-ascii?Q?NZobzOD5TJdPCUFE1acDSSbfyBkGTE/6rgmJqBZYx/pkU0Ywj0p9OBi3UePM?=
 =?us-ascii?Q?CdbliLCYdcK2860auUCQ70qW58qSFmjO+Spzfqdi3yTaAD+s9aRldPl//YfG?=
 =?us-ascii?Q?RlZ6JFvWgItvy9Ftu1uzAT3qDjkOEarMDv6F9JmH7crkHqB1ueGnml/Z0DxR?=
 =?us-ascii?Q?93JvE7wWh0WgNscY26dnPiMvh3H0JZtP8IoKteLNgJJqLU8XQjETp98QZxGo?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6895e1fb-3b35-4c90-975b-08db9f7ad053
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2023 23:36:43.2719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PtWqXVzcj/OE6FGve9goLNmDZr/YmvrXs2mTRqfRiNoxOYJmcgQf2NZ2xMhzozqayO1oh7pzgqEa+OoBu9G2tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 17, 2023 at 02:41:36PM -0700, Igor Pylypiv wrote:

Hello Igor,

> For Command Duration Limits policy 0xD (command completes without
> an error) libata needs FIS in order to detect the ATA_SENSE bit and
> read the Sense Data for Successful NCQ Commands log (0Fh).
>=20
> Set return_fis_on_success for commands that have a CDL descriptor
> since any CDL descriptor can be configured with policy 0xD.
>=20
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
> ---
>  drivers/scsi/libsas/sas_ata.c | 3 +++
>  include/scsi/libsas.h         | 1 +
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
> index 77714a495cbb..da67c4f671b2 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -207,6 +207,9 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
d_cmd *qc)
>  	task->ata_task.use_ncq =3D ata_is_ncq(qc->tf.protocol);
>  	task->ata_task.dma_xfer =3D ata_is_dma(qc->tf.protocol);
> =20
> +	/* CDL policy 0xD requires FIS for successful (no error) completions */
> +	task->ata_task.return_fis_on_success =3D ata_qc_has_cdl(qc);

In ata_qc_complete(), for a successful command, we call fill_result_tf()
if (qc->flags & ATA_QCFLAG_RESULT_TF):
https://github.com/torvalds/linux/blob/v6.5-rc6/drivers/ata/libata-core.c#L=
4926

My point is, I think that you should set
task->ata_task.return_fis_on_success =3D ata_qc_wants_result(qc);

where ata_qc_wants_result()
returns true if ATA_QCFLAG_RESULT_TF is set.

(ata_set_tf_cdl() will set both ATA_QCFLAG_HAS_CDL and ATA_QCFLAG_RESULT_TF=
).

That way, e.g. an internal command (i.e. a command issued by
ata_exec_internal_sg()), which always has ATA_QCFLAG_RESULT_TF set,
will always gets an up to date tf status and tf error value back,
because the SAS HBA will send a FIS back.

If we don't do this, then libsas will instead fill in the tf status and
tf error from the last command that returned a FIS (which might be out
of date).


> +
>  	if (qc->scsicmd)
>  		ASSIGN_SAS_TASK(qc->scsicmd, task);
> =20
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 159823e0afbf..9e2c69c13dd3 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -550,6 +550,7 @@ struct sas_ata_task {
>  	u8     use_ncq:1;
>  	u8     set_affil_pol:1;
>  	u8     stp_affil_pol:1;
> +	u8     return_fis_on_success:1;
> =20
>  	u8     device_control_reg_update:1;
> =20
> --=20
> 2.42.0.rc1.204.g551eb34607-goog
>=20

Considering that libsas return value is defined like this:
https://github.com/torvalds/linux/blob/v6.5-rc6/include/scsi/libsas.h#L507

Basically, if you returned a FIS in resp->ending_fis, you should return
SAS_PROTO_RESPONSE. If you didn't return a FIS for your command, then
you return SAS_SAM_STAT_GOOD (or if it is an error, a SAS_ error code
that is not SAS_PROTO_RESPONSE, as you didn't return a FIS).

Since you have implemented this only for pm80xx, how about adding something
like this to sas_ata_task_done:

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 77714a495cbb..e1c56c2c00a5 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -114,6 +114,15 @@ static void sas_ata_task_done(struct sas_task *task)
                }
        }
=20
+       /*
+        * If a FIS was requested for a good command, and the lldd returned
+        * SAS_SAM_STAT_GOOD instead of SAS_PROTO_RESPONSE, then the lldd
+        * has not implemented support for sas_ata_task.return_fis_on_succe=
ss
+        * Warn about this once. If we don't return FIS on success, then we
+        * won't be able to return an up to date TF.status and TF.error.
+        */
+       WARN_ON_ONCE(ata_qc_wants_result(qc) && stat->stat =3D=3D SAS_SAM_S=
TAT_GOOD);
+
        if (stat->stat =3D=3D SAS_PROTO_RESPONSE ||
            stat->stat =3D=3D SAS_SAM_STAT_GOOD ||
            (stat->stat =3D=3D SAS_SAM_STAT_CHECK_CONDITION &&




Kind regards,
Niklas=
