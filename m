Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9657CC3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 08:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C64E20873
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 08:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gGfZjY6r";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="zOcuAk0E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgBMIYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 03:24:40 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:64755 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgBMIYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 03:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581582279; x=1613118279;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KcoeF3+MqiVotAIAYNT67UtQ9zStRzWTYcSVsBAhEM4=;
  b=gGfZjY6ryA5qkGpreMTtlsr05rAk+z5jz/V88zMPyItIJPuYqpoq7brx
   d678uHemw6PamwveLs4A1QXe/0Jbt7M1aFez9QVVKPAL0Lvem/p5rfZOw
   FFbKaEJqnkMRZMn+OWZOHvFeMkeu4yJ0eZ4CwhjwQDZ8LHYDSBPhYnz0a
   dNJ7dS7hHpO5XToWYkQ1brmwteuJUt+hD/dgwXRWEkogbxqwQzpe7PcNc
   XzB1F6XV0shY2u7cKQ6RWqtAG76EitmFlMqQuU5Sx4QvgVjsxEdu7ItYf
   1Wiu0mMd4qAJguOWizqHMaQMAUC78tycTSuLXFREUvatBahRMa1HvRRN3
   g==;
IronPort-SDR: PNh0+mk6DXxv1ySCnle+X9+FaGVPzrJHFgpPbPIYP5Q301acFMG8AEwNyXjSvOcITzddi92hoa
 GufcfXb8egj5Vwmr+L1eaHE4uohEOM6m9r16q/sCkYdwIeNNzW0PWoe9rm+hs473IX7wZYPLG9
 YBcjxcZwMxrQeA91Vw1FTGDpDgKH/Ly/KcYTeLE5a3D44cJZeKLpDzC7ep3RsKStT+KLWe+gBL
 sF48KVt7yf2halMMH4dvHPXUHg+6MwJvS9A71mQCBPJ3QRHRdlaof4YI3XIwFQE8ATegYHba2Y
 H84=
X-IronPort-AV: E=Sophos;i="5.70,436,1574092800"; 
   d="scan'208";a="237775322"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2020 16:24:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GM3xJ5HqTOGg7c7HzuCjzMcUOa5DyBW03zfHCiicbUmTOoHJCwGnQoU1jGNwWS7js9zhVBaueT/JkOFWolefD7AtWDTF6+IZTraNlNDHniyWTwzUB0SeKoxM8eCxjW2kLG/TZz4yGv7WNMAe40iUon++Z8Ry08PkyMpCjhXm2fsjuWj2WevmARAEYqfBSJEZDnP9K/cHR1wKp30s+TrfDA+1MEFgkrJUAPmf6v11uc68MlPdHZxmFgecbbFGHe663nm+YHFSkBs+jkTkDleutkp8yJjg+Lk3hD7q23vlkze2O89KnSHII/uDVnL+BcOCbrwlFRbICD5pjCRXLtQDxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTiKf+gB4qHy8Wic1CPhNYRXqSWbMDl6iNWoup3WZHU=;
 b=Xm1zT/nOEcJlSud70iiBm8eoTm6sRDwwrEWprcaE4F6lVmNV5HPnKShmJ04Lss9O3laL8ru4mGG6B5Sx42Gf5o8ViSsaCUKdZZFC9hsc6n0LXUoFtx/fhBN4RJg5vRXAdME05MzE+zntu8fRsNRn2KfiW4UX5XJVs5JNDNsL6vU4mglKeRiIDHfqzg31/A8dcbw64k0iO7/JQS54IesJmjJPTdBlxGVMAb5UtR4naxDbnSrP+YOe1A5hB1Q7vOxftd9YGRVY5c1kjgWg7OsTEjG+TupIXBFcAC2UmvYJPSDfauuTwIneldHfgTri4lY4Vh612Rj6Nx6MOe6vnfa8aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTiKf+gB4qHy8Wic1CPhNYRXqSWbMDl6iNWoup3WZHU=;
 b=zOcuAk0EhhM5p/tFBbASMzuNt2vSJC6evv6olgZ0wzKAeyV0ixCTcWCFeyJqQfOhpHe3YWtOR8I88goy87KwdUzSaZPmswYowPl8V1Ih0NuklQBVcObusdjRprV1BWfv61SLFwCfZ7Y/kRuaOxjJJW1J6+TrLoek9FoA1DPbFmU=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5190.namprd04.prod.outlook.com (20.178.51.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.29; Thu, 13 Feb 2020 08:24:36 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::cd8e:d1de:e661:a61%5]) with mapi id 15.20.2707.030; Thu, 13 Feb 2020
 08:24:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Tim Walker <tim.t.walker@seagate.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Topic: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Index: AQHV4EctI/0h/tDOq0WOdKN0iYUQSA==
Date:   Thu, 13 Feb 2020 08:24:36 +0000
Message-ID: <BYAPR04MB58160C04182D5FE3A15842BBE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200212220328.GB25314@ming.t460p>
 <BYAPR04MB581622DDD1B8B56CEFF3C23AE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200213075348.GA9144@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 949aca89-f8b6-42f6-9158-08d7b05e2946
x-ms-traffictypediagnostic: BYAPR04MB5190:
x-microsoft-antispam-prvs: <BYAPR04MB5190897EC6E418D025AB8E2DE71A0@BYAPR04MB5190.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 031257FE13
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(199004)(189003)(81166006)(316002)(53546011)(7696005)(8936002)(81156014)(966005)(6506007)(8676002)(4326008)(86362001)(6916009)(478600001)(52536014)(76116006)(66556008)(66476007)(91956017)(54906003)(66946007)(2906002)(55016002)(71200400001)(26005)(33656002)(66446008)(64756008)(9686003)(186003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5190;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rhlbNBoq4GaQLoD+yYenanwjqUF6tV9cW/4n1bfGob9eloN7q1zhm84BbHFgFHOVyhBfqWZY7fq7A47k9FbSv4YLh47MdBtzTlUJV4uFl5WbpUjCBYeWpzovHvpiSpwnNh/FGjCXhrD3znBYs1ctLLZHt2KnnGNkplhfmWxlejooiaZorvndsD+C7XJE6H6fYJsQXDTMneiQvHToqkck55oTBJy16uLpBgo1QDEvfRaF8SILdmIDTWOl4Py+arWuGUuvveNuCRM8jO+x+BkV8Q/7t9zYKE3UpTWXUWn8Kd75ns20SgyNfXo0VeyxdlgVYfRteeNm9qD/l/hFpzHtgODfGW9fsU+JN6YkCQES9F1eFF2xJe7Jh1leuAwPD3T/Bjojw6+PYytIT8XLmR+6cmhv1T66xIl1y+7nNYxfZ7buD3T9L8JgwAnQ8v1Z0Mym3kFKiRDc7h7hwEoAeeTWkIeVYSzjNUOLSiTNTBJnBttFJnJP99P1G/7gWV+m0iPcCLxQi1cA/XQ3dnv1WoftYQ==
x-ms-exchange-antispam-messagedata: zYm/VR0RJav12+/qKBUetzonqs+dow9J7m2+wYHjQ64B3c9Zf+Fj/RYV9A+MIwFdBSUEB9MK6BtQ8iTx6h0F+RccZ7miCein6G+Gjq17MMMD23D2C9YFq5aFF9o4+XGYvkhIp3KGkLTeZjo+gcd4kA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949aca89-f8b6-42f6-9158-08d7b05e2946
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2020 08:24:36.0230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43EPe00/HRDM3yTPYJF3XfUJ6VIKHqpI8dZbAX7FrGy0Ovn0uPZGZo/9dWnsBWkciXOblp/iFW9XS/LRshkTLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5190
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/02/13 16:54, Ming Lei wrote:=0A=
> On Thu, Feb 13, 2020 at 02:40:41AM +0000, Damien Le Moal wrote:=0A=
>> Ming,=0A=
>>=0A=
>> On 2020/02/13 7:03, Ming Lei wrote:=0A=
>>> On Wed, Feb 12, 2020 at 01:47:53AM +0000, Damien Le Moal wrote:=0A=
>>>> On 2020/02/12 4:01, Tim Walker wrote:=0A=
>>>>> On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wrote:=
=0A=
>>>>>>=0A=
>>>>>> On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:=0A=
>>>>>>> Background:=0A=
>>>>>>>=0A=
>>>>>>> NVMe specification has hardened over the decade and now NVMe device=
s=0A=
>>>>>>> are well integrated into our customers=92 systems. As we look forwa=
rd,=0A=
>>>>>>> moving HDDs to the NVMe command set eliminates the SAS IOC and driv=
er=0A=
>>>>>>> stack, consolidating on a single access method for rotational and=
=0A=
>>>>>>> static storage technologies. PCIe-NVMe offers near-SATA interface=
=0A=
>>>>>>> costs, features and performance suitable for high-cap HDDs, and=0A=
>>>>>>> optimal interoperability for storage automation, tiering, and=0A=
>>>>>>> management. We will share some early conceptual results and propose=
d=0A=
>>>>>>> salient design goals and challenges surrounding an NVMe HDD.=0A=
>>>>>>=0A=
>>>>>> HDD. performance is very sensitive to IO order. Could you provide so=
me=0A=
>>>>>> background info about NVMe HDD? Such as:=0A=
>>>>>>=0A=
>>>>>> - number of hw queues=0A=
>>>>>> - hw queue depth=0A=
>>>>>> - will NVMe sort/merge IO among all SQs or not?=0A=
>>>>>>=0A=
>>>>>>>=0A=
>>>>>>>=0A=
>>>>>>> Discussion Proposal:=0A=
>>>>>>>=0A=
>>>>>>> We=92d like to share our views and solicit input on:=0A=
>>>>>>>=0A=
>>>>>>> -What Linux storage stack assumptions do we need to be aware of as =
we=0A=
>>>>>>> develop these devices with drastically different performance=0A=
>>>>>>> characteristics than traditional NAND? For example, what schedular =
or=0A=
>>>>>>> device driver level changes will be needed to integrate NVMe HDDs?=
=0A=
>>>>>>=0A=
>>>>>> IO merge is often important for HDD. IO merge is usually triggered w=
hen=0A=
>>>>>> .queue_rq() returns STS_RESOURCE, so far this condition won't be=0A=
>>>>>> triggered for NVMe SSD.=0A=
>>>>>>=0A=
>>>>>> Also blk-mq kills BDI queue congestion and ioc batching, and causes=
=0A=
>>>>>> writeback performance regression[1][2].=0A=
>>>>>>=0A=
>>>>>> What I am thinking is that if we need to switch to use independent I=
O=0A=
>>>>>> path for handling SSD and HDD. IO, given the two mediums are so=0A=
>>>>>> different from performance viewpoint.=0A=
>>>>>>=0A=
>>>>>> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iolanthe.=
rowland.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXB=
xCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=
=3DtsnFP8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D=0A=
>>>>>> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=3DIGD=
lg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSn=
Hpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSbytUjuRrrQgZ=
pvV3bxZYFDHe4&e=3D=0A=
>>>>>>=0A=
>>>>>>=0A=
>>>>>> Thanks,=0A=
>>>>>> Ming=0A=
>>>>>>=0A=
>>>>>=0A=
>>>>> I would expect the drive would support a reasonable number of queues=
=0A=
>>>>> and a relatively deep queue depth, more in line with NVMe practices=
=0A=
>>>>> than SAS HDD's typical 128. But it probably doesn't make sense to=0A=
>>>>> queue up thousands of commands on something as slow as an HDD, and=0A=
>>>>> many customers keep queues < 32 for latency management.=0A=
>>>>=0A=
>>>> Exposing an HDD through multiple-queues each with a high queue depth i=
s=0A=
>>>> simply asking for troubles. Commands will end up spending so much time=
=0A=
>>>> sitting in the queues that they will timeout. This can already be obse=
rved=0A=
>>>> with the smartpqi SAS HBA which exposes single drives as multiqueue bl=
ock=0A=
>>>> devices with high queue depth. Exercising these drives heavily leads t=
o=0A=
>>>> thousands of commands being queued and to timeouts. It is fairly easy =
to=0A=
>>>> trigger this without a manual change to the QD. This is on my to-do li=
st of=0A=
>>>> fixes for some time now (lacking time to do it).=0A=
>>>=0A=
>>> Just wondering why smartpqi SAS won't set one proper .cmd_per_lun for=
=0A=
>>> avoiding the issue, looks the driver simply assigns .can_queue to it,=
=0A=
>>> then it isn't strange to see the timeout issue. If .can_queue is a bit=
=0A=
>>> big, HDD. is easily saturated too long.=0A=
>>>=0A=
>>>>=0A=
>>>> NVMe HDDs need to have an interface setup that match their speed, that=
 is,=0A=
>>>> something like a SAS interface: *single* queue pair with a max QD of 2=
56 or=0A=
>>>> less depending on what the drive can take. Their is no TASK_SET_FULL=
=0A=
>>>> notification on NVMe, so throttling has to come from the max QD of the=
 SQ,=0A=
>>>> which the drive will advertise to the host.=0A=
>>>>=0A=
>>>>> Merge and elevator are important to HDD performance. I don't believe=
=0A=
>>>>> NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort=0A=
>>>>> within a SQ without driving large differences between SSD & HDD data=
=0A=
>>>>> paths?=0A=
>>>>=0A=
>>>> As far as I know, there is no merging going on once requests are passe=
d to=0A=
>>>> the driver and added to an SQ. So this is beside the point.=0A=
>>>> The current default block scheduler for NVMe SSDs is "none". This is=
=0A=
>>>> decided based on the number of queues of the device. For NVMe drives t=
hat=0A=
>>>> have only a single queue *AND* the QUEUE_FLAG_NONROT flag cleared in t=
heir=0A=
>>>> request queue will can fallback to the default spinning rust mq-deadli=
ne=0A=
>>>> elevator. That will achieve command merging and LBA ordering needed fo=
r=0A=
>>>> good performance on HDDs.=0A=
>>>=0A=
>>> mq-deadline basically won't merge IO if STS_RESOURCE isn't returned fro=
m=0A=
>>> .queue_rq(), or blk_mq_get_dispatch_budget always return true. NVMe's=
=0A=
>>> .queue_rq() basically always returns STS_OK.=0A=
>>=0A=
>> I am confused: when an elevator is set, ->queue_rq() is called for reque=
sts=0A=
>> obtained from the elevator (with e->type->ops.dispatch_request()), after=
=0A=
>> the requests went through it. And merging will happen at that stage when=
=0A=
>> new requests are inserted in the elevator.=0A=
> =0A=
> When request is queued to lld via .queue_rq(), the request has been=0A=
> removed from scheduler queue. And IO merge is just done inside or=0A=
> against scheduler queue.=0A=
=0A=
Yes, for incoming new BIOs, not for requests passed to the LLD.=0A=
=0A=
>> If the ->queue_rq() returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE, th=
e=0A=
>> request is indeed requeued which offer more chances of further merging, =
but=0A=
>> that is not the same as no merging happening.=0A=
>> Am I missing your point here ?=0A=
> =0A=
> BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE or getting no budget can be=0A=
> thought as device saturation feedback, then more requests can be=0A=
> gathered in scheduler queue since we don't dequeue request from=0A=
> scheduler queue when that happens, then IO merge is possible.=0A=
> =0A=
> Without any device saturation feedback from driver, block layer just=0A=
> dequeues request from scheduler queue with same speed of submission to=0A=
> hardware, then no IO can be merged.=0A=
=0A=
Got it. And since queue full will mean no more tags, submission will block=
=0A=
on get_request() and there will be no chance in the elevator to merge=0A=
anything (aside from opportunistic merging in plugs), isn't it ?=0A=
So I guess NVMe HDDs will need some tuning in this area.=0A=
=0A=
> =0A=
> If you observe sequential IO on NVMe PCI, you will see no IO merge=0A=
> basically.=0A=
> =0A=
>  =0A=
> Thanks,=0A=
> Ming=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
