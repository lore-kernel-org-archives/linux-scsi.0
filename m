Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9C9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 17:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DD8065104
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 17:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhCPR6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 13:58:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18439 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239483AbhCPR5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 13:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615917465; x=1647453465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4pYq3RAwa5dH+n3+e3Obv/stQiFpI3VR+iHjF670Uww=;
  b=q4X5ej13Wne7wPpbxiMoe1GnEOzr55epfg87N8RZYMH2QaX83DKXpXw+
   NJMyrAtg3ySIwhAoNRSlRvzM9QfMOG0/TUdeY7ok4pzzrZQYqBq7saqxT
   9x3JrmTNBDEbXJeDo/eDM7I5/bYUQNmxKiUI+pIScig8C7YH4gJ3rJ0kg
   5EmvVPxPljArWtdSvO51DBC2sNjstATw3yX4bh8lAtiUzwUAY4+t1Rimu
   QXFEJGRROHMClStEOh7/FP/r6NFCqZ96kLIWBWNzmN918xhYWuZuk//sw
   FtSE33ZF+HMQ2YJVtMGJqPtFKgPhG9Xas/ylOpRlvgYH/7unWQF4PY7P8
   g==;
IronPort-SDR: QxxXFkiJO5uocrwLv3Vhf1yfl9pHsAhiDMgaPxYVXpGf4ZagfVFfMsTsK55JkmyOX14dhNVLVN
 mgrvCzOAPGBtbZxbvJCGNgjB6vHfmIBx3a9fqAKrnle8gL+fRGziPWQkJ1VrujNemHUx7FdKs6
 2jMWnK+DmqwnCm6ntzuFXQwiFtLgxuFwk+Yj8qeNIJdmWR3e2WRsJIcQFe73GajoFEZ1pzIBVC
 XeOAhUYTjPgPxQxoDHKRy7Wa8H8hI0gzL4tK1BiJaTUjLNxcG84YiH1oWDwFPhvb7ATQCcnheQ
 Vgc=
X-IronPort-AV: E=Sophos;i="5.81,254,1610434800"; 
   d="scan'208";a="107416330"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 10:57:34 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 10:57:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Tue, 16 Mar 2021 10:57:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpqPk2/LPSskjlVgs7q2j9CxevgEZbpVsu5Mf7GjyM+nKFfobPaJtVYVIOU49wd4mtk4yjtaB8EfGrieLZESo3g/kzVv2JwyQN2dKzVQmsYTbxRKwSpcJUcG0T0I46LdA2Cgeys9q8twCuegCQMnC8suaHjWDV2ALSlHS7fGG5vt87TnZuL3ePBKtk+P+kehvfFJGqATqnToQqNx2naOat+WywOjFxTWpfuwHSlcQP0hrYGkYdUU4GayYxClrdcpiBMl8rmUN3THqnBYNKPCmxcxjE0ydPuOVx9lW6FbbFFxMXO4Mtoh+Ww1+GZNr6qquNh53x/96nuoO/4NYe50vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pYq3RAwa5dH+n3+e3Obv/stQiFpI3VR+iHjF670Uww=;
 b=PaYfihPETESa+9sT/oFjne/DS07IPGuiiYzaor2NPtN8FKFKTlYU7Qo1nC4wWW0EhQFF1xNeAufxM2Vp4YWMCsx4Z9+y94reeT8DUdxr4YgOytpg9/FEa4J20X0wC519TF5nmr3eFkp7QFWHtR+koKGLHFZTvagR7pwEhj+UQeLnFrvJLV/XQ6xCub4t8SyZ/jGVZsa8AGpmb1Hm3dlMHLuZcS2jzOMqsdxe64s7ZgdL214MfIZaRG1bKxwaFy9knI7pNBAmFg4egJi/Ud7Rrp1SjhZQxnmGUE2hMCYCpBVaev8bXK9Feqa0BE0gVF5Td7Q6upCqlOXF9hspUbm3FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pYq3RAwa5dH+n3+e3Obv/stQiFpI3VR+iHjF670Uww=;
 b=LtvRU4j26ex6k5A4B2u/zej8Z50f7AY9QrZPiXKUYKq4WcHt+1jiVmagGuXKeCO/yYry/Ua1YRXU+YBPm4ENamDDaiLgqn/Mr/DnUZBjGiTDnV1/Wkwx0r+giUvYwC0utS8aORizyvTq+AdcudpStLDSbZ7S0XYvLeSEVS8bufc=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3518.namprd11.prod.outlook.com (2603:10b6:805:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 17:57:33 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 17:57:32 +0000
From:   <Don.Brace@microchip.com>
To:     <Don.Brace@microchip.com>, <hare@suse.de>,
        <martin.petersen@oracle.com>
CC:     <james.bottomley@hansenpartnership.com>, <hch@lst.de>,
        <john.garry@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Thread-Topic: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
Thread-Index: AQHXCR61OvlQCM/6C0Sy4/3GbWz0Qqp3I2NggA/jniA=
Date:   Tue, 16 Mar 2021 17:57:32 +0000
Message-ID: <SN6PR11MB28482574D7952188C1F54085E16B9@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210222132405.91369-1-hare@suse.de>
 <SN6PR11MB28485909455144E17F9B46A3E1959@SN6PR11MB2848.namprd11.prod.outlook.com>
In-Reply-To: <SN6PR11MB28485909455144E17F9B46A3E1959@SN6PR11MB2848.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afc42415-f2b8-43c5-6565-08d8e8a4f963
x-ms-traffictypediagnostic: SN6PR11MB3518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3518E34FD48DAA24153225C2E16B9@SN6PR11MB3518.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jfuI+RSsJhi8WjVydv9P0Iw6braHTzeIETZRb//Np2ijjb2FAIKF3A8fykKj+B+qh1q8sTj1WVPtphVSUNFDm8N72B833sY1boJn1OxjJGm0MmeuAJbipYu+DxhymVUP326g7wXOXUOPoxhos4EcArKzDqGM09OGYI+sw/DQUQYczhKpgx17gh2BdExWgF0qlCifjac7TWs38rexbNNWLkfILHLcyYpvmsrTj29hAm4eo0nTbaz493445nuajOrvxg2LEJbQd91fzq3UJHQyJQqmelfl8QqJMC5aWxyFSm72tWHHPO9Ar70QOnj7X3+2JNSgBdE/PYetY+7QEqZGzo5/X7gMXljBKeg674GJfxyQwnIrMD1la+Vj8V2zzPu9cb7sqVexAsw/gKlnzYTBuGlslFkICBtUSV7x1ERQvw0FQzWSEUyfeXAOSc9ynX+l3shzG+vqiWOYOXe7a09wrsfeEFGcwRC4djiR9lAATCw77PLYv+M+40mqIokHc6JYIFnuQJ1pYS1MN/rIjzXgMn5l/LO/6lAIFRK68FB34RdgoYQD/igiK/r8pICK1G+5MJQAdPxJ/eNe5xs7UQECCjRD4Hl1G4ldP3OY6o+pcBx2jOoFETvfFCn9Ls1XZZqjvlzvd0O4+4/s58snYfArRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(346002)(136003)(396003)(86362001)(2906002)(52536014)(71200400001)(9686003)(55016002)(110136005)(33656002)(5660300002)(26005)(66946007)(316002)(66476007)(76116006)(64756008)(186003)(6506007)(8936002)(66446008)(966005)(8676002)(66556008)(478600001)(7696005)(4326008)(83380400001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qjN3cjKLHSplNofc7fNa4yQ1D/S/5ApBf5OEhI3MZOS8kqU5m7epHIsmetIF?=
 =?us-ascii?Q?F26FIihUTeKNvnEPYSVA+gwfBR9dBDorUYB1BVorXtVeXmr4ZGjjVYAqfy4l?=
 =?us-ascii?Q?UAVSKOD1di6lcElMNCX/+Wq/EUqMagaYMmvGXF3oCbvNa7ufwOvx8GoJ9k+d?=
 =?us-ascii?Q?W/5s0Q/qWoIoFWWiQBt6/5OVHohIwUlXSNWhJgLuBQAyrT4tNpzzWHCYxvEa?=
 =?us-ascii?Q?/dJ1tQRi2IzGD2BXwoXWPOfsbNAvNkpHd95G+eGdY4uKTgGafP1Qel0bwJ65?=
 =?us-ascii?Q?BoRNRhwMfs3u5oMSeJL4805uEH4DTQNQEpk9bHkfWT6EkynpIZ2kSp70XpMF?=
 =?us-ascii?Q?y+dOrqTUv36sck1+5lfDJMd7OcT6Q8wU5kuNDKMd1o7wZbDyN+O2b55hWIn4?=
 =?us-ascii?Q?KBzR7tcChuQrgRu163hs6TEbNePd9G41z1eQUecJ7rYBYCpxBqUTBun3BUbF?=
 =?us-ascii?Q?wjw51u2lxYCCUEa6Gc1pkcici9sMgrpH/vPKtcKp+c5mJ0b4rLHkPmrv/Isa?=
 =?us-ascii?Q?n5NG9CeeA5XxT17rgziMi+kPqYmEE0r7bal/yTT0GEUILvfJ5b5KqTz03CVr?=
 =?us-ascii?Q?6wDXAwXXHP5aSlq9nhxFMQ64fMl+BAXBat2oIHJABGC93yMjV8BJKsbZnmwm?=
 =?us-ascii?Q?Z11x81p9QYcb+lNmvREqUMrzJWPcylMxenwNYlXAPMaGz8Q5RPAVH9+Y89Mo?=
 =?us-ascii?Q?6roR917qE/Awixp2F4k6g/T5O3tNoCxhznrOumjQUAcDCEH62ubBz4EJMfHE?=
 =?us-ascii?Q?TS6zZDXxCI+xUdLm+qV18zUdt6189Vh5sPFj/rD2qL4y7l3OyO+skqxB5vr/?=
 =?us-ascii?Q?P87BcN3cijmhxQJKInJuxsl1Kg/PIWDw3BLEOvGHj/WpgSsIBbjfXKweSfZP?=
 =?us-ascii?Q?Uj+5fQe4ijuFO3bbYTHgN2caThB9/Yo9HQlbwEEGuQGJ13F6WjFF3WU8b1mX?=
 =?us-ascii?Q?bboWKNSj9vuYhYjqoVtJEwl6dXUJjSZq2ELoDkq6TZkv77Ncrd44qpzc/Miw?=
 =?us-ascii?Q?Ipcrdk4HfHHzEtesemzHe91z+wy3LP+3k0+uvaKtUo2/P/k9PkWlW9T+/RO1?=
 =?us-ascii?Q?GrwN5fHArQWLyngHwOvWm24R/htMupb7tK2vxQIKDazEYHOnthW876g0MoKE?=
 =?us-ascii?Q?u3srADnOolop/8ftKELaz6mlrz6rUBLQ3i3r3oHBfEy1/EBVLL0a6m6Snris?=
 =?us-ascii?Q?t8De7bvNSp80eS5hZWzYbRSP7u/fL2/urdGzPjXTfRVtcCEVJTjn1deai5pC?=
 =?us-ascii?Q?1HQ/XgrfDXcdSmnqngBkCCGOcOo2afLiBC59p2o1ixwE8+PjjL04OOi/Y9UJ?=
 =?us-ascii?Q?3G0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc42415-f2b8-43c5-6565-08d8e8a4f963
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 17:57:32.8167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ltIpqCzzvUG0VylTR8J9H/2zHPQdbWjeIe3V7S+ahWZcTrbO/HYIINnacnhgQ5vZ3tLbvm34BRPzX29Gh+6K4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3518
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----

Subject: RE: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs

-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de]
Subject: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs


Hi all,

quite some drivers use internal commands for various purposes, most commonl=
y sending TMFs or querying the HBA status.
While these commands use the same submission mechanism than normal I/O comm=
ands, they will not be counted as outstanding commands, requiring those dri=
vers to implement their own mechanism to figure out outstanding commands.
The block layer already has the concept of 'reserved' tags for precisely th=
is purpose, namely non-I/O tags which live off a separate tag pool. That gu=
arantees that these commands can always be sent, and won't be influenced by=
 tag starvation from the I/O tag pool.
This patchset enables the use of reserved tags for the SCSI midlayer by all=
ocating a virtual LUN for the HBA itself which just serves as a resource to=
 allocate valid tags from.
This removes quite some hacks which were required for some drivers (eg. fni=
c or snic), and allows the use of tagset iterators within the drivers.

The entire patchset can be found at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
reserved-tags.v7

Don: Cloned and kernel built. I'll have some test results by end of next we=
ek or so...
Thanks,
Don
--
2.29.2

Don:
03/16/2021
Have run a lot of heavy I/O tests. The driver/OS holds together until there=
 are reset operations. The resets do not complete because of 1 patch pendin=
g on Martin Peterson's 5.13/scsi-queue tree
f749d8b7a989 scsi: hpsa: Correct dev cmds outstanding for retried cmds
and pending patch
https://patchwork.kernel.org/project/linux-scsi/patch/161540317205.18786.58=
21926127237311408.stgit@brunhilda/ hpsa: fix regression issue for old contr=
ollers

My testing consisted of running 7 operations in parallel using a lot of HBA=
, LVs, and AIO LVs.
1. mkfs
2. mount
3. rsync to mounted volumes
4. fio to mounted file systems.
5. umount
6. fsck
7. fio to raw disks.

So far, so good, but I need to add in tests that exercise the reserved slot=
s. I'll start that soon after I complete my resulting logfile checks.

Thanks,
Don
