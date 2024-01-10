Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E410653807
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YGV8X5fZ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wdYrNX4r"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704919769; x=1736455769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PB5/SlmyGp7LluMGcH7UfeO6ixC5fE4ieyumhqnVHVE=;
  b=YGV8X5fZ6xp4sTBsj1Wg1je6sno+lcgTKPY/C9amH7ZD1/hbg+1ABHtr
   9kUHfin7Bn7hVqwzuuT/J36CxgUbHurkeofvxpsLe4MoF9Tc5ClVM00q6
   VxhFTZy5XBTKEnDfhqINEPD4Gh54+JpFSJEOalLJaPt41g53zlTehO9oh
   n5ihgMxPytEyb2OqfBoSNsNeyfQfo80JBgu7Zzr10P1DpVFtIFc4lbACt
   mPOsFFaBFtgYQEst0wamUE+rxflQNQsCV/0V1VcASkLzJfi/p3AVyWdLw
   IGOKP700HjDyEYlloqabm7jC7O45d/Yo/74AJKoyGMFQPe7Bgrv1cs7fw
   Q==;
X-CSE-ConnectionGUID: Ljt6o52yRC+l6ZWM2DzRew==
X-CSE-MsgGUID: 6oo1PmJIQKOWT33m3Fnamw==
X-IronPort-AV: E=Sophos;i="6.04,184,1695657600"; 
   d="scan'208";a="6693491"
Received: from mail-bn1nam02lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2024 04:49:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hbz/4mLmrzfR7VcutPr0HHoORiRWyKZrwn7PzAti2WprVRLlVW6xsFp0ut8nJV9VMB+qBsC21oksDJiL9wX9nxzkF6Qe+gEFclxZh5bg5yFPwWptzN679I61i0kgw/NZEOZX59OnpDZQ3JnyLfzMhLZ4vaA2RgNP+iuVLCuMYctt46+/BxOzKIhRB4YH8xcJIEkY3w66JCEgBrWskKy9TR9t/5ToffQevLPTGO/yl59DPZJT1oZUZfU3RzULbkWv4NcWirEOYECWtPLUKjVZIvA6Rx+YoIhKBF8MbqcV2VxFQsAFSYEHcxFSIjlm4G5osn8MvxX1qV+y/KZaco8NcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKhQGnaJVX6K8Bytr6d8n5axqhE+37sczLlKF3/qZ8c=;
 b=FGmQuQKmDYFL2l2uFyO+OERwI6yOjfzDzOLzpGfZUQzA15jpTE9EMLAk8g0QC0/j1DdBKdRf2z1+wa0Ec1wZXQefk5IdjkaRCzZ5WFNPtGCB2TiMICT+dDMIaSICbcKvUwA54iPWrtgKEI+UO4jppKzsD8yQ/XndJx8bCYdCEhORQk4oSaihMpaCCGDk00p71obnHvKg4p+BeqkCE4gA8QNrTQwE0r00aph/cYRjQjWO/PI2um1YvlIHPXr7zU7cBEDOzTuNw2+SAEEayJnO3A4Muu7qb4EpHO/RazjN0JE4sXpZIP8I/BsWML0Pi8ONkWQ/Qw8LtP9sHIpE2asPBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKhQGnaJVX6K8Bytr6d8n5axqhE+37sczLlKF3/qZ8c=;
 b=wdYrNX4rFFBn42RUSDhWWaWPZ5T+U23EXZTQFcZY/baEEgt1mCSfiqY3RV/JCJm3RRkf41BpCw7ttTuMjiJoAAFoIlpaQGBFR4gz4pP6fu128Ef3RgB9rmD8LqPc6Rs+sRFDl6WQuLkpykOf5QcEbUOImpsuiGU6kDRGiziJLSg=
Received: from BL0PR04MB4850.namprd04.prod.outlook.com (2603:10b6:208:5f::14)
 by CYYPR04MB8905.namprd04.prod.outlook.com (2603:10b6:930:cb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.17; Wed, 10 Jan
 2024 20:49:18 +0000
Received: from BL0PR04MB4850.namprd04.prod.outlook.com
 ([fe80::56e9:30a:5826:79fa]) by BL0PR04MB4850.namprd04.prod.outlook.com
 ([fe80::56e9:30a:5826:79fa%4]) with mapi id 15.20.7181.018; Wed, 10 Jan 2024
 20:49:18 +0000
From: Niklas Cassel <Niklas.Cassel@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>
CC: Kevin Locke <kevin@kevinlocke.name>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ming Lei
	<ming.lei@redhat.com>, Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Thread-Topic: [Regression] Hang deleting ATA HDD device for undocking
Thread-Index:
 AQHaQmrU1AR/SYLpv0uiByM2A945NLDQb+2AgAAF8ACAAY3ggIAAAc0AgAARIQCAAXFyAA==
Date: Wed, 10 Jan 2024 20:49:18 +0000
Message-ID: <ZZ8CzOaXBkxyKxNw@x1-carbon>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
 <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
 <d585753a-b5f3-410f-a949-8b52252307ab@acm.org>
In-Reply-To: <d585753a-b5f3-410f-a949-8b52252307ab@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR04MB4850:EE_|CYYPR04MB8905:EE_
x-ms-office365-filtering-correlation-id: a999e509-5646-4eff-8072-08dc121d9d4c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZdfUHGrT7Mh+HEiUaaJdWRXOAroK4lyIhri0dl2FGQbp0zF3lLT0F0kfCoECwVreukRJ9X8zSGlByLt68W7i+vrtEDen9NlG+67a1NeIrpqJ2kxmD7Nu8oHjuKvbtchKXzSpit0/SilopT8zSgWYSS7swxByElVoWmeDyj1ELopEYPqA88cui5B9QIbI6OJSsEPa+9gVGMI46mmTG81dSO2t9L6BhEitZsry78qxZ//h+xLpSUnfI/RxQI73MXKPGSJFXhsyk7UDGirGGfCoNtUg/g09Uzd6WoSfFWYoeZOxb97SiIR+dJ661bnyj2KcIw13w72VwCnNqnAk+CmkOmtlFGUQT0vBlpioJyOPBSRSbx6Q6GM7RICpGsShmKR+blcI66O9JZHyH1Wx2TYc2rRR/qJihr66YrF9v1iouGJXKJIbaYaNIg450+17Ttg9sEVzyEsFlbTiKBL7z2XrQ2X7uA8AT+TQSwXE+znvuXMIyT/F15J+7d92BLnzyb2N4Qvpd+CA+M7tg7uJ0NjgqdLKkhGaPG4OpC1ahZ3oFGFdixNXEFxDMzX2u1/uhRn9bHnW+JeRBVeBfHA3Z9yTL1LNjBTJAEZNBXHFjVM8CBOFg+UPAu6LRNayow1ly4zE
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB4850.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(396003)(346002)(366004)(136003)(39860400002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(71200400001)(83380400001)(26005)(6512007)(6506007)(9686003)(53546011)(478600001)(6486002)(8676002)(8936002)(91956017)(38100700002)(4326008)(76116006)(64756008)(66476007)(66946007)(6916009)(316002)(54906003)(66446008)(66556008)(86362001)(82960400001)(122000001)(5660300002)(2906002)(33716001)(41300700001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fRESQKsz8dJAaoKbp4Hf4uEsLMiaa9WN2dLZGZJdp1eOJVrQ/ZkSLJQVqC5I?=
 =?us-ascii?Q?gNM8zL+FNXdiOCgfNbRTRPwnTmkogHyclJIu/RZJbbIwVTlwMyJubVnllduP?=
 =?us-ascii?Q?HstshZXc4sITMo1keGa1/t7p5AfusuOI8PjkjlL4wV7JDrA1NmjajAholnht?=
 =?us-ascii?Q?SThcy0DbjSot8fHD1VUY76eBb2Wk2+2EEfsDmhdqe7sKyVqC3hSDMTr96ksh?=
 =?us-ascii?Q?umVKeXNQRhTQ25g3BsE6nlffMA1W//ogxXGlz4BBQ6CoIFsDRPxF09aoAcCy?=
 =?us-ascii?Q?jvMKYFJydyg40UBgnPzTYOKYa/bBQ7JhuntIfrXUpFYngB6kUj9ujF958Qp6?=
 =?us-ascii?Q?FuYK+1VZUAwnJ+bpmC+JvNDrIJ+Y6gF//FScZ5beXY0KisJol4vRY9t9trlJ?=
 =?us-ascii?Q?0GewRREEDNmBXayYAro84wajBv7vDIUgzowGFtOyFvxuZE1XMSu4CCE5fo2m?=
 =?us-ascii?Q?7c8aBV7N15st7zjJN0w90oyl7FvbUMj7b/P0XFmqZfctqlopjXNmYMLS++Sj?=
 =?us-ascii?Q?cgU7LjztIdu/6C9AKF1bKoerkT6wxNBDAoXqCH0ATJenBUus3qGzbV6HaOSi?=
 =?us-ascii?Q?T8KhQbP74vfpYYMoCYzzgsl3UBp/tRPzEcyOAOu+4EejHnVzvPoYjF1vID0C?=
 =?us-ascii?Q?ay5MzGKmp8/poquhV7baxxD+QF71P3PMnLNzw8zXV6uTJrSco6AD9CVzwIts?=
 =?us-ascii?Q?4zMXr+u8T+l/3JLeg0LW6eN5gUz8iy7ti+jGi4WO8gIjz65qBKJL/QS2xmBQ?=
 =?us-ascii?Q?IrzLjA7+Z2NaIolK/ueXBXh59m4v3W+LN+zatWA2pYWbAWBBWL0GdA+BdWnf?=
 =?us-ascii?Q?oxFd6r9otel986qHnIJcURUaQhxiwJp3k/xfdgUBnsMOde4IGfqxmt62KQ+b?=
 =?us-ascii?Q?oEMsHoNrOWALiHr+5x15Tqjkv25LGL5wvfDeJ3zI85QJrOljl5ZT+jKPG1Mt?=
 =?us-ascii?Q?IaTNIW/76BauzmyVbJhqGW6jupx8G9bRDaEBrB/cDjkZqVHd/rRKpDEIY/QR?=
 =?us-ascii?Q?AT1SF4JdLzR5/LJ0xxqqAhbTuF6m8eenmrd4VVCsGJoUQzc06IZUVnqs3S+p?=
 =?us-ascii?Q?G+r2XY2cKv0lUxbaEyY2qNCCP2l9bsRac2VqBnz592rlfLtkLT+kNfiFuRSw?=
 =?us-ascii?Q?c+5YngHCDfetBB2IoEwVGGU7k2ALwjuZEJjhRbClt+E7aTm9V3MyCfRresBC?=
 =?us-ascii?Q?TFg5XdXb2wu8T5DX8kaCmsIiw/I/yIeGRX6D2EFZjTxRZxkUHQbbV+qWuK7s?=
 =?us-ascii?Q?zActvv0lRm4JqwPZOHO5Vsxh+WbK5dGdYVckYeO19EdGRdVOOkNL2GEGL2mM?=
 =?us-ascii?Q?WgmjcnSJt5kUfR4bQc4hr67ggQZGilhqJMSJIAjjw7zkm4m0+snqa79NSGQL?=
 =?us-ascii?Q?vIZ7Z8/LpzeKWhdf0y4oB94+vLX+eB2+6CMiIOk3Yx+nPyQfRjwQh9X3WRMT?=
 =?us-ascii?Q?BrrFJTtb4wgGzkkVcLzobfHt956OKfUTADngi9WWKI8Q7fuUzim7y7VNVpiJ?=
 =?us-ascii?Q?L2UdX+l/cVn/z6tT+xW8I7S/SS3L9UmJol0GmIugpFejWKGerQVs/5VIpvWK?=
 =?us-ascii?Q?zutNjrKqWwE9fuB7Rpog7yyGaXvUO7frBhrAuLF5uOdk/Y4OiCnmFYMTSaks?=
 =?us-ascii?Q?Ag=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <41BAAEC3BE6D314BB3A2EF65B5550811@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nTjqNONLJLQwOZDA2yIJAeifZ4lggIdblWypv8xX3HtCipawRXOrYzdFxPWzEkxPEe3WjSXrc7xBd2IaLXrh42KsqBrvL8uxIOPDTbI3oIqt4yMG7jKV+yo4dU62rWEcwSihZAr3/HTwsqGMPOcSh8QjWmOnd12HCh2lsy5PisNbxgYq2JK8FTFproSP2SPDOJJunHPYm6jnbyo/gFhn1kcelMgqGm3vXFO0suT9F96YVfRl9zl2UuFuftcryVioyUxvsq2TlFfR6r97ufXlNirGGXe+1xfkWtGsQI7Rc+BKpRFYnGZmdhKvOTImfg7WY2ykD+oFv0JSP193NYxQdr8ZMK8pZF2kT6bw+96i0gSbCzLgZN31+VGubRkFeqbAaG6C3DhQxeQb71Pp6YoRKt9psP5qRk7Ym+24kDJKwmiZqdqTGZFzL6WUdc7yIkdM19/lEJ5G3Ei6ltNi+DkJUBpMJg9cPtc/G447tJNyO0WhtZIWCn775QsT5C/7W5ZK8MGpLkRtK7uY+FN0QQj588yZyYcdtkjOVTu6uXoxhuZYsl4TuIu0zV6KSf0dCbC1dfM1QsVNfE3rtF8rLElVc9ee9acyM6CA/W8OPIsWGfGF7QUDjl91v+kbmbgGhBHz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB4850.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a999e509-5646-4eff-8072-08dc121d9d4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2024 20:49:18.1708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z4fZUHuBtxyi8WDK5DW7fYHhOe9tcKZVyxula9sfgQMhCHWs746NkAEuZFcHnvuYdrM3uNd2IQ08AHFEeGVRkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR04MB8905

Hello Bart,

On Tue, Jan 09, 2024 at 02:46:58PM -0800, Bart Van Assche wrote:
> On 1/9/24 13:45, Kevin Locke wrote:
> > On Tue, 2024-01-09 at 13:39 -0800, Bart Van Assche wrote:
> > > (cd /sys/class/scsi_host && grep -aH . */state)
> > > (cd /sys/class/scsi_device && grep -aH . */device/{device_{blocked,bu=
sy},state})
> >=20
> > Sure thing.  Running the above commands produced the following output:
> >=20
> > host0/state:running
> > host1/state:running
> > host2/state:running
> > host3/state:running
> > host4/state:running
> > host5/state:running
> > 0:0:0:0/device/device_blocked:0
> > 0:0:0:0/device/device_busy:1
> > 0:0:0:0/device/state:running
>=20
> So the SCSI host state (host1) is fine but the information about the SCSI
> devices associated with host1 is missing, most likely because sysfs
> information of SCSI devices is removed before a SYNCHRONIZE CACHE command
> is submitted. The device_del(dev) call in __scsi_remove_device() happens
> after scsi_device_set_state(sdev, SDEV_CANCEL) so the SCSI device should
> be in the SDEV_CANCEL state. scsi_device_state_check() should translate
> SDEV_CANCEL into BLK_STS_OFFLINE.
>=20
> There are several tests in the blktests suite that trigger SCSI device
> deletion, e.g. block/001. All blktests tests pass on my test setup.
> Additionally, I haven't seen any blktests failure reports recently that
> are related to device deletion. If I try to delete an ATA device in a VM,
> that works fine (kernel v6.7):
>=20
> # dmesg -c >/dev/null
> # echo 1 > /sys/class/scsi_device/3:0:0:0/device/delete
> # dmesg -c
> [  215.533228] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
> [  215.543932] ata3.00: Entering standby power mode
>=20
> Running rescan-scsi-bus.sh -a brings this device back.
>=20
> I'm not sure what I'm missing but I think that it's something ATA-specifi=
c.
> Since I'm not an ATA expert, I hope that an ATA expert can help. There ar=
e
> at least two ATA experts on the Cc-list of this email.

Thank you for your help debugging this.

It is easy to reproduce the hang in QEMU against a ATA device using:

# hdparm -Y /dev/sda
# echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/delete=20


I can get it working again by simply reverting this part of your patch:

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -163,8 +163,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, =
int reason, bool unbusy)
         */
        cmd->result =3D 0;
=20
-       blk_mq_requeue_request(scsi_cmd_to_rq(cmd),
-                              !scsi_host_in_recovery(cmd->device->host));
+       blk_mq_requeue_request(scsi_cmd_to_rq(cmd), true);
 }


What goes on:
When libata receives a completion for a ATA_CMD_SLEEP command, it sets
flag ATA_DFLAG_SLEEPING, in order to know that the device is sleeping.

In order to take a device out of sleep a link reset is performed.

This link reset is currently performed very late in the call chain,
after a new SCSI command has been translated to an ATA command,
but before the ATA command is actually issued to the device.
(See ata_qc_issue(), which calls ata_link_abort() if flag
ATA_DFLAG_SLEEPING is set.)

While the ata_link_abort() will abort all QCs, using blk_abort_request(),
(regardless if the command was issued to the device or no were issued or no=
t),
which will result in scsi_timeout() being called, which calls
scsi_eh_scmd_add() for all the commands.

scsi_eh_scmd_add() sets the SCSI host state to recovery, and then adds the
command to shost->eh_cmd_q.

However, after 8b566edbdbfb ("scsi: core: Only kick the requeue list if
necessary"), it seems that after when libata EH strategy handler calls
scsi_eh_flush_done_q(), the failed commands get requeued
(scsi_eh_flush_done_q() calls scsi_queue_insert()), but the queue is never
kicked after EH is done, so the command is never sent down to the device.

Most likely because scsi_eh_scmd_add(), which sets the SCSI host state
to recovery, together with your modification to __scsi_queue_insert(),
causes the queue to never get kicked.

I have a patch that works around this issue by instead deferring the
SYNCHRONIZE CACHE command, and letting the block layer requeue the
command (see patch attached at the end of this email), instead of
relying on SCSI EH to requeue the command.

However, I'm worried that applying that libata patch will simply hide
an actual problem in SCSI, which might lead to someone else stumbling
on this SCSI bug in the future.

Thoughts?


Kind regards,
Niklas




diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 09ed67772fae..fd4da14eefc6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5038,14 +5038,6 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
                if (ata_sg_setup(qc))
                        goto sys_err;
=20
-       /* if device is sleeping, schedule reset and abort the link */
-       if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
-               link->eh_info.action |=3D ATA_EH_RESET;
-               ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
-               ata_link_abort(link);
-               return;
-       }
-
        trace_ata_qc_prep(qc);
        qc->err_mask |=3D ap->ops->qc_prep(qc);
        if (unlikely(qc->err_mask))
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0a0f483124c3..f7cbe2d9141d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1682,10 +1682,20 @@ static void ata_scsi_qc_complete(struct ata_queued_=
cmd *qc)
 static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cm=
d,
                              ata_xlat_func_t xlat_func)
 {
-       struct ata_port *ap =3D dev->link->ap;
+       struct ata_link *link =3D dev->link;
+       struct ata_port *ap =3D link->ap;
        struct ata_queued_cmd *qc;
        int rc;
=20
+       /* if device is sleeping, defer, schedule reset and abort the link =
*/
+       if (unlikely(dev->flags & ATA_DFLAG_SLEEPING)) {
+               link->eh_info.action |=3D ATA_EH_RESET;
+               ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
+               ata_link_abort(link);
+               rc =3D ATA_DEFER_LINK;
+               goto defer_nofree;
+       }
+
        qc =3D ata_scsi_qc_new(dev, cmd);
        if (!qc)
                goto err_mem;
@@ -1732,6 +1742,7 @@ static int ata_scsi_translate(struct ata_device *dev,=
 struct scsi_cmnd *cmd,
=20
 defer:
        ata_qc_free(qc);
+defer_nofree:
        if (rc =3D=3D ATA_DEFER_LINK)
                return SCSI_MLQUEUE_DEVICE_BUSY;
        else=
