Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564B0C3B187
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 01:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2347420848
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 01:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YhY+izDO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="OjqR0TKH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgBLBr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 20:47:57 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:10350 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBLBr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 20:47:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581472077; x=1613008077;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9e6H/fJIqYn74cSdWIiFWfb8fJ5e83HYFyFiBwU3TR0=;
  b=YhY+izDOlQT0xfbA9hr3kgaFuHi0zpVq7HYVJ6x2fX3yGhevfXt8+hnS
   3wbd+YkIJtDoUPcedItIXjegTjvijmueS6KtPUZXulM2Wh+jjK7fZJtrj
   YQ6UD0cXEdZmw5QQr9r8zTyZw6TfRMOhS3OEH4FBqKz7jtnnzuUjX7rA3
   P5WZ8bGTWaDAWxTEzXjSvpIHhaFrSakLe40HcxhVlHMkrr0Oayf+vh9D8
   xc/Z1kEszkVjBeOR0rDVcaJLTjhBGzqoysN8iGhVv44KXr0TkI7migStT
   K67Zueso+22lraZ6HFHMfNs3Ah2Vs0F6AumkYy5uJzR0RF+wUQ8CasqjZ
   Q==;
IronPort-SDR: P5R04omDlltTXJ0Ax1HroYtOqrMTVJJzmWk0m6fWDdxt+5uz3RmitDmIhdKSMo7U6p4LUzk+hI
 Bal9GcArnItv149tE3BZ0LNt9Qc65aWV9Y5IG2XCy0HKW9dco+rNW7kHiQugKd9jgkwtP4s0LC
 ehhCuHQryEcIByGTLenltC+BmIrMtURGsBFtp9zlIQEo8hJm7z9/4BQ+G4MPmuAbHYWSegCqEY
 Ex/ZsVnlySP6fUBetlbM8OtHaUDUVhRLCqebr9lzlD6c5bAHZnXvca4essr5FuT7Z+Uo4bW2z6
 Xzg=
X-IronPort-AV: E=Sophos;i="5.70,428,1574092800"; 
   d="scan'208";a="133988267"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Feb 2020 09:47:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSls46g3CtCqZ2j6fGWxK4VubJEF314T7DzHpypE1GXqjF6RdozvzZH9KUjjUG175v77kWtQPdAM04B20dqUNiWPBQG7mjuFp5P0c7k3pGaXIjaz1cRjwbUFsIEEI5tIVXJylkb+X2kIqLEDvt0dUTaBaQfQCkkUJ9q2kCcod9E2ERSqpVI3uK0FMD+braMHHV/N+PGaTvUgN/AiqHBRW5tEA/nxnT2vT/vn/hZOQza2zzMo/AJikXlzZz/By8eqed8YJKPtsKZ+8tN1y7hQTU03+qbU6RU9AFRXCVdT7UaZpyyfgzylfm0gYLoO6IAQ/e4R6+Zth8fvPv76iqf0MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9e6H/fJIqYn74cSdWIiFWfb8fJ5e83HYFyFiBwU3TR0=;
 b=LzSSuqpf8Qem8p9FINY87LBHFYB6G+8kSZBXCziCyMGaZhY5PDvKt1GoUzWkGr0+yAxEb1xpypJGO31Gx5MVKOkllm/7XBiWQ5ttOGJgV0CW38qFs6ZLglI192g3+cPuGBQv7Jrykwk6HBQNUh50PXb5NTaBhcS6XrxtHJDe+bnpnOZyxHDivZEdAGq51GL5f8nYuvIkV6WU5KgnZsM3BTvRa/dt0JDzDk1ni+TbgDe+V23b/ulR+oxtNYpgdXZxrrhuvbb6Nv4igZ8+I/WVpGmBvLwUkH3Nn4wnVNcHjHoOitW5VVinHWas8hnR7HOSaMG3kHWhw3dnENxdpei/Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9e6H/fJIqYn74cSdWIiFWfb8fJ5e83HYFyFiBwU3TR0=;
 b=OjqR0TKH4UGSb9Ba5t7dUryhzZjC/vZKUBY1McivYEV7i5Q0hFyyE3KVHlxUSsVwvjHY3KB8gYP1Hm0GY+IcEUGDby4YLJ488VNhQsPeWoc/TgvHTiwRqDivJ1gmQZyLG3JdUKcZiJ1A3qh1favi403yv/+pdiJRB1y41OjzN3M=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB3846.namprd04.prod.outlook.com (52.135.213.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.25; Wed, 12 Feb 2020 01:47:54 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 01:47:54 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Tim Walker <tim.t.walker@seagate.com>,
        Ming Lei <ming.lei@redhat.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Topic: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Index: AQHV4EctI/0h/tDOq0WOdKN0iYUQSA==
Date:   Wed, 12 Feb 2020 01:47:53 +0000
Message-ID: <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 291d8f55-320c-420f-e7b9-08d7af5d93ae
x-ms-traffictypediagnostic: BYAPR04MB3846:
x-microsoft-antispam-prvs: <BYAPR04MB3846B7AD273BA2F9384DD183E71B0@BYAPR04MB3846.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(199004)(189003)(71200400001)(66556008)(4326008)(66946007)(66476007)(66446008)(64756008)(76116006)(91956017)(2906002)(52536014)(81166006)(316002)(26005)(86362001)(5660300002)(7696005)(53546011)(966005)(33656002)(81156014)(54906003)(55016002)(186003)(9686003)(8676002)(110136005)(478600001)(6506007)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3846;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I9vp/R68yWPiUg9PkZy+V1lOtKfYwQInBLXBxqNm4CpgLcFBGgPjAV8BBi1bG2OsI7HUsVpy+wbUsgbSRFRSqNYWhuPjI9eibZJQWy517HJZQXHKzaqWA7Py76NgMvuVVaXenhaHIRkrqcqCUgNfbtM0BT7cna2pn2kX3r8+cIlJV1Fr26YLGO6FbnP2c66Bq/mn5B5eCCPE0Fb0iuCled0a8F5vd08Yq00Y6/TxXxOtaiqftf9xWe5fmqC0Qf7hru/5nu0+Qcw7esAjMK2fUhggU036Kbi8doVf1D0zDAGa//CTLWAfclx12K+etBub7cngnGGProEPauJP+f9RV2U9lEzMkxDlByYs3TBXDzmq5mvvoZQyiVclQtkiCKAuVmIW5aezNb/AmwHZYhmdR81RLBlZil2IP8xAKRum5kE4pLnmU87bUuk6psPpy5wXUhOgZQm7AtBGP9yglKeCxaMy6EvG6UC7agsHa9Em4bGcpbuwvIvLh6Nmu4qm0PnhAEnkw+eDH/O3rGkzDFfIEQ==
x-ms-exchange-antispam-messagedata: A+/8b4R2oyBEUXn2fUKLin4M7/gSrHDhy22JdxqXb2OOBq4xnzyg4+gkyDt/nZS5qB6pHb9wj+pBxOYDtkvKHuwfsJDkzGfsjCxlC3Jt+kb21j2waPhad0aN4gl8OFXTaH7748xySDj7/A7Tj+5rFA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 291d8f55-320c-420f-e7b9-08d7af5d93ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 01:47:53.9268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f9Jv9X8E9UP1gqOoMkOXfJJ7GF7k0jebQnRhp4myXvaqHV4MattThf3A+lWqzjlFendqF8XS+k7Jkr5uPcvrEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3846
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/02/12 4:01, Tim Walker wrote:=0A=
> On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wrote:=0A=
>>=0A=
>> On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:=0A=
>>> Background:=0A=
>>>=0A=
>>> NVMe specification has hardened over the decade and now NVMe devices=0A=
>>> are well integrated into our customers=92 systems. As we look forward,=
=0A=
>>> moving HDDs to the NVMe command set eliminates the SAS IOC and driver=
=0A=
>>> stack, consolidating on a single access method for rotational and=0A=
>>> static storage technologies. PCIe-NVMe offers near-SATA interface=0A=
>>> costs, features and performance suitable for high-cap HDDs, and=0A=
>>> optimal interoperability for storage automation, tiering, and=0A=
>>> management. We will share some early conceptual results and proposed=0A=
>>> salient design goals and challenges surrounding an NVMe HDD.=0A=
>>=0A=
>> HDD. performance is very sensitive to IO order. Could you provide some=
=0A=
>> background info about NVMe HDD? Such as:=0A=
>>=0A=
>> - number of hw queues=0A=
>> - hw queue depth=0A=
>> - will NVMe sort/merge IO among all SQs or not?=0A=
>>=0A=
>>>=0A=
>>>=0A=
>>> Discussion Proposal:=0A=
>>>=0A=
>>> We=92d like to share our views and solicit input on:=0A=
>>>=0A=
>>> -What Linux storage stack assumptions do we need to be aware of as we=
=0A=
>>> develop these devices with drastically different performance=0A=
>>> characteristics than traditional NAND? For example, what schedular or=
=0A=
>>> device driver level changes will be needed to integrate NVMe HDDs?=0A=
>>=0A=
>> IO merge is often important for HDD. IO merge is usually triggered when=
=0A=
>> .queue_rq() returns STS_RESOURCE, so far this condition won't be=0A=
>> triggered for NVMe SSD.=0A=
>>=0A=
>> Also blk-mq kills BDI queue congestion and ioc batching, and causes=0A=
>> writeback performance regression[1][2].=0A=
>>=0A=
>> What I am thinking is that if we need to switch to use independent IO=0A=
>> path for handling SSD and HDD. IO, given the two mediums are so=0A=
>> different from performance viewpoint.=0A=
>>=0A=
>> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.o=
rg_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iolanthe.rowl=
and.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQ=
JZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3Dtsn=
FP8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D=0A=
>> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.o=
rg_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=3DIGDlg0l=
D0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_=
uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSbytUjuRrrQgZpvV3=
bxZYFDHe4&e=3D=0A=
>>=0A=
>>=0A=
>> Thanks,=0A=
>> Ming=0A=
>>=0A=
> =0A=
> I would expect the drive would support a reasonable number of queues=0A=
> and a relatively deep queue depth, more in line with NVMe practices=0A=
> than SAS HDD's typical 128. But it probably doesn't make sense to=0A=
> queue up thousands of commands on something as slow as an HDD, and=0A=
> many customers keep queues < 32 for latency management.=0A=
=0A=
Exposing an HDD through multiple-queues each with a high queue depth is=0A=
simply asking for troubles. Commands will end up spending so much time=0A=
sitting in the queues that they will timeout. This can already be observed=
=0A=
with the smartpqi SAS HBA which exposes single drives as multiqueue block=
=0A=
devices with high queue depth. Exercising these drives heavily leads to=0A=
thousands of commands being queued and to timeouts. It is fairly easy to=0A=
trigger this without a manual change to the QD. This is on my to-do list of=
=0A=
fixes for some time now (lacking time to do it).=0A=
=0A=
NVMe HDDs need to have an interface setup that match their speed, that is,=
=0A=
something like a SAS interface: *single* queue pair with a max QD of 256 or=
=0A=
less depending on what the drive can take. Their is no TASK_SET_FULL=0A=
notification on NVMe, so throttling has to come from the max QD of the SQ,=
=0A=
which the drive will advertise to the host.=0A=
=0A=
> Merge and elevator are important to HDD performance. I don't believe=0A=
> NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort=0A=
> within a SQ without driving large differences between SSD & HDD data=0A=
> paths?=0A=
=0A=
As far as I know, there is no merging going on once requests are passed to=
=0A=
the driver and added to an SQ. So this is beside the point.=0A=
The current default block scheduler for NVMe SSDs is "none". This is=0A=
decided based on the number of queues of the device. For NVMe drives that=
=0A=
have only a single queue *AND* the QUEUE_FLAG_NONROT flag cleared in their=
=0A=
request queue will can fallback to the default spinning rust mq-deadline=0A=
elevator. That will achieve command merging and LBA ordering needed for=0A=
good performance on HDDs.=0A=
=0A=
NVMe specs will need an update to have a "NONROT" (non-rotational) bit in=
=0A=
the identify data for all this to fit well in the current stack.=0A=
=0A=
> =0A=
> Thanks,=0A=
> -Tim=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
