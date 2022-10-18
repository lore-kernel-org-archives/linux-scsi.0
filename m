Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41DBC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 15:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJRPFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 11:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiJRPFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 11:05:07 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B4786FB0;
        Tue, 18 Oct 2022 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666105504; x=1697641504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JDxH2ixhK0CoLNsi58wPy0KmBhzk7leR5RRIQwjDv0s=;
  b=Qqj8R2sXTqmHqYO64UgoSogSfLkBcAkZzPE5fh4aYolQGWEFoEJ4ZvjZ
   NSGlgEH8PHnjaWm3DJhs/0BnCIMRMKl5uQcceeyLedrKVJPGi9bQtlM1e
   cyx3OcCHwC67sdO3znZkzjw3dIQWhHvs0ZK+n0GJZX3x9dO+xgSHeq/bK
   EC2HwUr54GrG/c5wY4zQvdvLLFK0zUGKYC1PgxcHVZjyH552+t3iX2ZEK
   1jTfkTAWnEP8qq9e+yZc7h/bI+KY1naPkqQNvFl0ZQmaUiMT+TQBjOcVb
   e59T33QVwebvYe/myhkTFUAJyIDD6piASmRUMEJR0v69UIM3yjckzlK7Q
   w==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661788800"; 
   d="scan'208";a="326237067"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2022 23:05:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUX19cQu47szxAUFecMmWC7xUYqDrncvoVgCWMtGQZHyQ21/6Sawx8etRhwNAuUCGf9Z3/VAJpHxYFcUnaPJwaO6pE8S7q0OSec/Y9yazOWuh/jLbGModHBayVcFgc/ouIErJLP5jylQnyO8qKxswuMVx764384c8JfkiEDsBvFsX+0XHHEB574GpYhGN8aglQK5uUcoSx+/mvn83jsn/UD6J9fnl8lWF2kMRlT927wTNpwOAbZ7J1ddoyL41m4v+gkyIqm4pqKutilC5SEl6ZAvA/X7v8C+eO09ID0KL/S7CocOXLHWTq1PwscYUIFL6PiF5N5JRIKKY3F+OudN1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QmknGfWH7En87b2W6kJ7ZXotiCe3ezGyvXw87pNato=;
 b=Ozd9BWgws1r1RO2iXIQaSqKQk/hZileT2R33AigXoJc1o0kjc8YBwL9OYHwoPAVOVYKy0iJbHMx8NYxYuxBFUefrZzH8gCTSDsp2H0PyGv56/+suzD771hBARxXh8MRf7mMGmOybEAQdzElgr/r1549IniN1FBz8gYDUQU6XWoVZEEL1DV6a9pbhOOiHRsxnBfyWo9A6PrtN5iBk038Vyf5hILaOGiz1L4skywRQe6l7L81+nnmC3lIaaTEyr1vMlrMJitPIam40U43YoPPv7+12zdAZZ4rE0t7biYftGD9IpJN2epDvkctcJ3G2OuKTk288U5ucPxTpgiN54B8qFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QmknGfWH7En87b2W6kJ7ZXotiCe3ezGyvXw87pNato=;
 b=bNa6ZNOuM4J/tGg2JCZM9HF5+47L/Iuuyx+poDJZWsP12/fZ8I+yc5VG/oqY+VRlsVHQMU7RopCH8pa2tAUgjQje/oK3LqKcpRvuXiUPFIaziEPYFIL9gFbFSm1NCs8MhTrZFwPrxHLQPdRiIstQulHUe/pBMGMhSG4sHPG/AZc=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM5PR04MB0202.namprd04.prod.outlook.com (2603:10b6:3:70::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 15:04:59 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::966:8440:b721:5425]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::966:8440:b721:5425%6]) with mapi id 15.20.5709.015; Tue, 18 Oct 2022
 15:04:59 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     John Garry <john.garry@huawei.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: Re: libata and software reset
Thread-Topic: libata and software reset
Thread-Index: AQHY4vTnd/ima6e2tUyH0znpXTje864UQA6A
Date:   Tue, 18 Oct 2022 15:04:59 +0000
Message-ID: <Y07AmUoyq8+HVzQU@x1-carbon>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
In-Reply-To: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM5PR04MB0202:EE_
x-ms-office365-filtering-correlation-id: 57844288-5e6c-460a-e823-08dab11a2035
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kld+AUsKj6YSTZdMtm2F/BMAd+cnkNFNMEDOaYArNFxOGek0BEeaSLyHDOJ7NIqoB1kk3JB6WQUplBFilKmfJ/uXpeS0Lel4jGVpzX7iHdc+PnKLxc/zhMXsw85bw7ZIIeFmsHgIgKt6FUEIQTvhKN6MLY4LF4rNByYywO8Me3c6kVGQ/8s6DhsgF27YnkJeoVkjOoJGrwog069SHLZBSr2bCACbjAv1DKuvvbitaLDwjePChETDccpE4omEPRWse5VEoMfdUG7oXNAb4++v7nNphKYd8wa+0EABog/C+Jo72a+Qp2eqxXe1BniSkUJ/6b3vdiRhyC6emCiKzZf+0JxhiSf+hbzN9CVE+wnnV0jAEaqo+GGCYDsL69klsyDkuy0NYklQe/5chLAIEyW96n9e90qVjnjkl8k8PXShI9J+xUjPunwvDcyxNJumAhPc8ybWjocaMSMHl6R/r16WW6PglGLkZzbMTHM97dnpoDP/hfm7rE5CAmiILuen8BWarq7qdRbZHW62rx1c0zYAkm7MOtTtusurI0diPZ9ok7ZbwW6tNXwzmrEuukqUYU/M4XSSWNYTs62nU1Yk2gxinAoD7+QPeENNejEp3bTGc+SdhLlbA5jailql1YMpjc+LtH4MCYof6iuomY1dbjZ5gK3RhOWhX7fFdzpBTrGrpsiJ9EdTb9iDRFgQC77BpDrpO6Vri4QjzkbzoF0Zrir5ZpCU74rlA9OGzStc9TvdiVIeEbLm3Q4Mcp08H3h4d1gzMKjaiqI0URuCmV5yLOeP6urLc/FZ3lisVg/cwegp/r8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199015)(54906003)(5660300002)(76116006)(66556008)(6916009)(316002)(6512007)(64756008)(66946007)(6506007)(478600001)(41300700001)(9686003)(66446008)(4326008)(8676002)(26005)(2906002)(6486002)(186003)(8936002)(66476007)(71200400001)(83380400001)(82960400001)(33716001)(38070700005)(3480700007)(38100700002)(91956017)(86362001)(122000001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kRXWAUF3ojH96R+HZQPhIDl0uaAVP4FGwSE/bILawYD7UviG/WSaSfcM0WXS?=
 =?us-ascii?Q?RJTKQCERUY758+U/xPbwBjCCaCjZZ22lve/IA1AvpWFiEP2QrkSHaeal2vrm?=
 =?us-ascii?Q?OLlj9qyDgJgL+ywXU+X7vpilkqz82HgAPbOlNVoZrqZmOwXBQmtt8tB9BcVy?=
 =?us-ascii?Q?6j+PEa6YZLfoPT/kUcytlYKrHX2yJlblHWyzS7wN4mctedmCLKBxOaFwtcai?=
 =?us-ascii?Q?HpKbI81nRNWfM6Fky3a2ZaAhuAID3cuXkCh2Mvquf5CAHGTfnHjUGq9qLSjr?=
 =?us-ascii?Q?yfy1UiCQbJRyuWHkAGSnlE/vijuJO/kX0Hmzr9v7Sjco/FGqrR2Db9aqMEUb?=
 =?us-ascii?Q?X2Sb17FtBM+NRYvshVDRqKSICduG1aBUUUsqSgOZvkkvgKPhig2B5aodKZ0U?=
 =?us-ascii?Q?zgrInc/QZOXI5WIkWvQ8PRvyG3EqHtvBcL0/8630yX/Wh62BgUGVnzjJidHz?=
 =?us-ascii?Q?ojwvzSqS4x3uw1+dWIipTYzp12W1PFK977fzC0KLHPk3AncIbpx4rvcch/nz?=
 =?us-ascii?Q?6yO4cE4Q6a3ihqM4itAen69rsGqM4ivWqHpIJnrCzGomYh+JIvBCFgPUmEy4?=
 =?us-ascii?Q?7rO4C2QvxWl4CeAvbf/3qyp4VuRnmnL7naKB8Sfj16HtLBIokms6QR8r64Zs?=
 =?us-ascii?Q?qByEuIzIiGnO7eE/EwPR1J2zg4yglXQHnp4aWrmJVg/IFujJN4qpbhNWaiO6?=
 =?us-ascii?Q?7FOUXTwi96kigRZgm0GSW/rPpDBdVyt/rioVCLVQsy6EWw+MyKAHypVXTJTE?=
 =?us-ascii?Q?ZlzZk4hJHyz/fqqqN81yR60FNQMBnB4zJlb5HWF0BGrYnLEQOQhxKyTMraHa?=
 =?us-ascii?Q?udwrUj7ppMwftpZ9U5c6aHStrFOfUOhkpAME3zTHFd7DtnDkWLZ5UNqeDS+D?=
 =?us-ascii?Q?1XR5ZjJ00LYQ/yAhIUhL0b+G94a0DyJyrbbtQ3wGsgeqLd4Af9M0zeev6rke?=
 =?us-ascii?Q?uojpd694i0MxavJY0dj7slEwIAcRqH/KylYB6tA/znRjxEyVjyP0sM3u+nL/?=
 =?us-ascii?Q?/4i8Bb2O3z0KYWlaeTFgTGi5k8hXhNGgG0/SyVFs+il4vkrPp+9cGTM2MRqd?=
 =?us-ascii?Q?p5fGm2Fml/gx/IoUUQcvIPc8dna48od/J+R9Fq4l91gRvP/mgsNpYwpuH/X1?=
 =?us-ascii?Q?lZAM9Tsd6wFHOT2jRkgpIkhKaSegSVIbYXGwA1g2uXRlGEJNlOhlmjtB9z1t?=
 =?us-ascii?Q?HoWBuJWTRQanzylrAoyaWjMue9g5nZ77xR+08k8Jd1nk1QdYavSUKFIAxxpn?=
 =?us-ascii?Q?vZGdXitQDK5hh9uCFaHaPn0us6E4tza+6NAtsICZbGMGDKJVAwFMy/xRGztC?=
 =?us-ascii?Q?yGXzY3+JOy2FikAMO2e6fwpjjnd41ZeTdClHBKD/lokcqOoHuX0/CztsNbj+?=
 =?us-ascii?Q?ir2rLafT2snuJ6j4z8d5o/rreMJMPNZSwsg2u/MXaMXj6woXJh5SkiEHheD4?=
 =?us-ascii?Q?9hOq9DQEre48tHOiy0oQLjPCexSZyeCwkvXwX04UiYvQZqw4Pae3QvHmCoCl?=
 =?us-ascii?Q?mx9YiwZlXf4UgNxMSHFSJgcgsTyAynwc00NRax3d2giY4CtXU3MofaGXCotu?=
 =?us-ascii?Q?nVB5q+EkgieqBDrrz8cLjDE7S+C5vujldz+5wfpG61BVETIolcX1MLTFrNiY?=
 =?us-ascii?Q?YA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8ACAFE4764A88C40AF6C3BBEB2DE78A5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57844288-5e6c-460a-e823-08dab11a2035
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 15:04:59.3860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D/PxexLQ7wdurEMY0UPk5zEln18Z3J36H0X87dwlLuyyHib/lqt44pshIV0h/Vk34bsgtOU3GZr3Z4rATxsdYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0202
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 18, 2022 at 02:24:00PM +0100, John Garry wrote:
> Hi guys,
>
> In the hisi_sas driver there are times in which we need to issue an ATA
> software reset. For this we use hisi_sas_softreset_ata_disk() ->
> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow task"
> mechanism to issue the command.
>
> I would like if libata provided such a function to issue a software reset=
,
> such that we can send the command as an ATA queued command.
>
> The problem is that often when we would want to issue this software reset
> the associated ata port is frozen, like in ATA EH, and so we cannot issue
> ATA queued commands - internal or normal - at that time.
>
> Is there any way to solve this? Or I am just misunderstanding how and whe=
n
> ATA queued commands can and should be used?
>

Hello John,

See the kdoc above __ata_port_freeze():
"This function is called when HSM violation or some other
condition disrupts normal operation of the port.  Frozen port
is not allowed to perform any operation until the port is
thawed, which usually follows a successful reset.

ap->ops->freeze() callback can be used for freezing the port
hardware-wise (e.g. mask interrupt and stop DMA engine).  If a
port cannot be frozen hardware-wise, the interrupt handler
must ack and clear interrupts unconditionally while the port
is frozen."


ata_port_operations.qc_issue() is obviously an operation on the port,
so it makes sense that it is not allowed.
Interrupts are also usually masked or disabled at this time, so we
won't get an IRQ with the completion.

Perhaps one could argue that there could be an API to execute a polled
command. But if the port is in a bad state, e.g. a HSM error (RDY bit
is not set), issuing a command would likely fail anyway, regardless if
using polling or IRQs.


> I assume that ata_port_operations.softreset callback requires a method to=
 be
> able to issue the softreset directly from the driver, like ahci_softreset=
()
> -> ahci_do_softreset() -> ahci_exec_polled_cmd().

Yes, looking .softreset in a few ata drivers, they all seem issue the
softreset directly from the driver.
(e.g. ahci_do_softreset() calls ahci_exec_polled_cmd() which just always
uses bit 0 in PORT_CMD_ISSUE, so it ignores hw_tag.)

But I don't think that I fully understand your problem.

hisi_sas_softreset_ata_disk() -> sas_execute_ata_cmd() -> sas_execute_tmf()
calls lldd_execute_task() (hisi_sas_queue_command()) and then calls
waits for completion.

How is this different from e.g. the libahci case?
Doesn't this end up being the same as resetting the port directly from the
driver? (if we ignore all the callbacks)
Or do you actually get stuck on a ata_port_is_frozen() check somewhere?


Kind regards,
Niklas=
