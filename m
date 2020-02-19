Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D399C3404C
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 02:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E113E24658
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 02:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AXhTyJhh";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="li3JG/PC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgBSCcK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 21:32:10 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57098 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgBSCcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 21:32:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1582079529; x=1613615529;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=d/P3KLOqq4BG+frr+7a9a5SEDUzkSSe9DPxDxOOX4+U=;
  b=AXhTyJhhQo+cJNhevYoaB5MN3D/BdmDI0ckqpRlrhK3+G6CcLgvRIEfJ
   uirq34Zs+B+Y7/qLsP2VYHSRPaBoFNzxyAu1fKReE1CYMTO8Zz4BNdEfJ
   KP0PFdo2IplAF2Vz1oTx3AcOXnULvjDlxvoB0c8j1Wcs74l7wycCv3Sdh
   r7tPXNTs+loslVoGdd3zn9n80JIX/8mo973FAgSBEeDILgqD2fZmDB/0x
   ljhSyBMoIEedLAjHzp2wLyE8Znz/lTwA0yFf5WsqkK8dfhdfpAvKlCHLW
   wG76QXz02gmP+kFyhtA5Smi78TC+tXgBGZ2I5nieUNYmtfigFnY3RqRkH
   A==;
IronPort-SDR: 3jb19B5RGWQMyHCisxahNFfPaTcuhzdnadS0cUm9N4xrUjJQ6JAMSt4jvoIQhnlamrLFBkIVNz
 cTcpNHaYqKQmCupnsdln5/wETxQ8B3wa5YehXa00al2dNslHL7Pimn07UW8bP/hco9fKyD3dc1
 K+eyXQbgPO1w8ANw68fXKynAQIDyTc2b3ZxVNLwBxUW9pnswhSXO08rzqRxh4hRJDipNzqSchQ
 7/qUqyu2Hd/GP5DrY36CgifWSxQZbZFrUifON2TUUDQqkY/gxp9R9t41t4ZnclE8yRBcdTYr7h
 /Bo=
X-IronPort-AV: E=Sophos;i="5.70,458,1574092800"; 
   d="scan'208";a="134506821"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 19 Feb 2020 10:32:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=No7dZUJ+TwIcACRdG00x0CubDY/+mKE+sdokUlNPwiN9EqKNha8L0wsct3T8kUEWVSA9WT/bb4eNPOu4rXFY76sXOP7pD3Dnb6uSoDXNLrPnNFZHDgJ+7JGoWhrOxMFtqtJFQNr2WAaEOaxfbCoP+2NjVzNcXsnc+pUX0shgH8tNWMUjalpVtbq88HZU9mk1fv7GsWU5O7xBbeba7zAx1bxFe3VOCaScwLvfmZzg2eSNJ0SNrzeNc3wgk9q49vAwbeGNAKXcIouYk7rC5F74e5q7LMnHCDTRRjdW//xsjuydCnVDyBrZplct0bMyS0A2wVFQvjUR+XOcmTFXmvH53A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7E5w7ludWAn88gCx3yIbuPUlycvQxxGhnrtsyKLpcU=;
 b=mixg/O8FFz/uLj+xm+PCdIAG9bZg12uzp+hX97IZll42bo5Ei3lqhTJbYrZQ9rv/beGiOhY0TWlzS/CbFGE1kLQbcFsfs6x7EIa9qLXEMsXZGLpVuvf4vQonSPhagzqIqeoyim5HmUn0LQFzBQOqUujBv/I+SjDGOI9IjR7cVdAsXNNu5f5PC+8j5wJPqvTMf/k0sFgnl4D89qVbzh/8faGcftb1H8TXuB+IPpjQteTa8NW/+Vt3qPFpIDNmP2BxC6qO3n6aAwzqY2+BeJcC5gilQ8l7XVaJEjAx1DHHGDeLZnUUd7nMTLdfpyH3lLZrUchyxMfL0fFfMXmlN0swVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7E5w7ludWAn88gCx3yIbuPUlycvQxxGhnrtsyKLpcU=;
 b=li3JG/PCpU+lMKiA0rlPtIor5/DJe9/tTAB49u4T8sKBZ5+MwpaeKq2I97hAIOcoIs+FncbNsrL7e5h9QCzU6a4zFuxsj1UmU8UXTkMvZECpd7sQhg4QP0eaE8lVViABsrTVE+vmobdbNHU7HqNxDuLwI+zB9q4qxq3iO4UMuEI=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5304.namprd04.prod.outlook.com (20.178.50.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.29; Wed, 19 Feb 2020 02:32:07 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::6daf:1b7c:1a61:8cb2%6]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 02:32:07 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Keith Busch <kbusch@kernel.org>,
        Tim Walker <tim.t.walker@seagate.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Topic: [LSF/MM/BPF TOPIC] NVMe HDD
Thread-Index: AQHV4EctI/0h/tDOq0WOdKN0iYUQSA==
Date:   Wed, 19 Feb 2020 02:32:07 +0000
Message-ID: <BYAPR04MB5816DF16BC3720ABF286671EE7100@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com> <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
 <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
 <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
 <20200218174114.GA17609@redsun51.ssa.fujisawa.hgst.com>
 <20200219013137.GA31488@ming.t460p>
 <BYAPR04MB58165C6B400AE30986F988D5E7100@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200219021540.GC31488@ming.t460p>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f203ed99-4d3f-4600-26ce-08d7b4e3ea55
x-ms-traffictypediagnostic: BYAPR04MB5304:
x-microsoft-antispam-prvs: <BYAPR04MB53041A8D3B381FE2656206ACE7100@BYAPR04MB5304.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(189003)(199004)(6916009)(5660300002)(8676002)(966005)(81166006)(186003)(478600001)(86362001)(81156014)(26005)(8936002)(52536014)(71200400001)(53546011)(66946007)(55016002)(6506007)(66476007)(66556008)(64756008)(4326008)(66446008)(54906003)(76116006)(91956017)(9686003)(33656002)(7696005)(2906002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5304;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kynxLJPlPRYuBNtau/qWcpJBon5Y0Y3qdJaGYXF2cJRARIFs68cEhlVc4049UGfMTCZQI3SVerOiL5uSXXxiN0mb5HB5PIlM9zqcSowNB/YQUBVmuCSixT5Vvg5biKdfqDFO84L9FmcAbWgE3mnRCrq9RgfrtSrxpNDjUtMdNZmwacgC+HL4ATSvV/X5URlXADfW4K2qwUg1eX9S6hHwrUkU+rpDxwKN9pgppxbwvQhpJwqLRJUQXXesehbzyxaoQafNBctKV6hL+yzjcefIznpW9EkaZdVl1ImLmWbed7HN/uIiYe5w3BMJe1VRJ+YKH0YF7USNytpAdt+UAlgeViuPpswl9vAjcOOOF0rfcrGazO14yRtrEUl4KLWtDYY/8C91k79fKDSO+NXGhR35M8iGnvpHFSYPcn3uoop7TkH0lOtEF1PiQYLvQP7j8MZdy/vSZjZh65SFYXT9GgzOHPys77tasjIN8mE1UBTZAmeAwoObS7lXz741WjsIQp6dJaCiNqrXzc4GZisbnANGrw==
x-ms-exchange-antispam-messagedata: ELDBh8ctL8BsIUdoRlBHiA/jywqMGZ1QFy/wpzg0YFlZLpLe1cW8v3U/PaFE2qbeAzVvbx8CN6fyfpuG41gpT1CmCN2MT7KtaxBFDyUrPE5sUaUpQ6LJ8W11HPkUZvfSjJOpVVt8CLS9VK2C07Ompw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f203ed99-4d3f-4600-26ce-08d7b4e3ea55
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 02:32:07.7060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KMFPnZHUEQzpHUaBXPvdINZgmukXuXI+lA7tk3ZuO5cSbJryqNnnnshSOggi3bDbxDh30BdWVg36DCwayZPacg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5304
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/02/19 11:16, Ming Lei wrote:=0A=
> On Wed, Feb 19, 2020 at 01:53:53AM +0000, Damien Le Moal wrote:=0A=
>> On 2020/02/19 10:32, Ming Lei wrote:=0A=
>>> On Wed, Feb 19, 2020 at 02:41:14AM +0900, Keith Busch wrote:=0A=
>>>> On Tue, Feb 18, 2020 at 10:54:54AM -0500, Tim Walker wrote:=0A=
>>>>> With regards to our discussion on queue depths, it's common knowledge=
=0A=
>>>>> that an HDD choses commands from its internal command queue to=0A=
>>>>> optimize performance. The HDD looks at things like the current=0A=
>>>>> actuator position, current media rotational position, power=0A=
>>>>> constraints, command age, etc to choose the best next command to=0A=
>>>>> service. A large number of commands in the queue gives the HDD a=0A=
>>>>> better selection of commands from which to choose to maximize=0A=
>>>>> throughput/IOPS/etc but at the expense of the added latency due to=0A=
>>>>> commands sitting in the queue.=0A=
>>>>>=0A=
>>>>> NVMe doesn't allow us to pull commands randomly from the SQ, so the=
=0A=
>>>>> HDD should attempt to fill its internal queue from the various SQs,=
=0A=
>>>>> according to the SQ servicing policy, so it can have a large number o=
f=0A=
>>>>> commands to choose from for its internal command processing=0A=
>>>>> optimization.=0A=
>>>>=0A=
>>>> You don't need multiple queues for that. While the device has to fifo=
=0A=
>>>> fetch commands from a host's submission queue, it may reorder their=0A=
>>>> executuion and completion however it wants, which you can do with a=0A=
>>>> single queue.=0A=
>>>>  =0A=
>>>>> It seems to me that the host would want to limit the total number of=
=0A=
>>>>> outstanding commands to an NVMe HDD=0A=
>>>>=0A=
>>>> The host shouldn't have to decide on limits. NVMe lets the device repo=
rt=0A=
>>>> it's queue count and depth. It should the device's responsibility to=
=0A=
>>>=0A=
>>> Will NVMe HDD support multiple NS? If yes, this queue depth isn't=0A=
>>> enough, given all NSs share this single host queue depth.=0A=
>>>=0A=
>>>> report appropriate values that maximize iops within your latency limit=
s,=0A=
>>>> and the host will react accordingly.=0A=
>>>=0A=
>>> Suppose NVMe HDD just wants to support single NS and there is single qu=
eue,=0A=
>>> if the device just reports one host queue depth, block layer IO sort/me=
rge=0A=
>>> can only be done when there is device saturation feedback provided.=0A=
>>>=0A=
>>> So, looks either NS queue depth or per-NS device saturation feedback=0A=
>>> mechanism is needed, otherwise NVMe HDD may have to do internal IO=0A=
>>> sort/merge.=0A=
>>=0A=
>> SAS and SATA HDDs today already do internal IO reordering and merging, a=
=0A=
>> lot. That is partly why even with "none" set as the scheduler, you can s=
ee=0A=
>> iops increasing with QD used.=0A=
> =0A=
> That is why I asked if NVMe HDD will attempt to sort/merge IO among SQs=
=0A=
> from the beginning, but Tim said no, see:=0A=
> =0A=
> https://lore.kernel.org/linux-block/20200212215251.GA25314@ming.t460p/T/#=
m2d0eff5ef8fcaced0f304180e571bb8fefc72e84=0A=
> =0A=
> It could be cheap for NVMe HDD to do that, given all queues/requests=0A=
> just stay in system's RAM.=0A=
=0A=
Yes. Keith also commented on that. SQEs have to be removed in order from=0A=
the SQ, but that does not mean that the disk has to execute them in order.=
=0A=
So I do not think this is an issue.=0A=
=0A=
> Also I guess internal IO sort/merge may not be good enough compared with=
=0A=
> SW's implementation:=0A=
> =0A=
> 1) device internal queue depth is often low, and the participated request=
s won't=0A=
> be enough many, but SW's scheduler queue depth is often 2 times of=0A=
> device queue depth.=0A=
=0A=
Drive internal QD can actually be quite large to accommodate for internal=
=0A=
house-keeping commands (e.g. ATI/FTI refreshes, media cache flushes, etc)=
=0A=
while simultaneously executing incoming user commands. These internal task=
=0A=
are often one of the reason for SAS drives to return QF at different=0A=
host-seen QD, and why in the end NVMe may need a mechanism similar to task=
=0A=
set full notifications in SAS.=0A=
=0A=
> 2) HDD drive doesn't have context info, so when concurrent IOs are run fr=
om=0A=
> multiple contexts, HDD internal reorder/merge can't work well enough. blk=
-mq=0A=
> doesn't address this case too, however the legacy IO path does consider t=
hat=0A=
> via IOC batch.>=0A=
> =0A=
> Thanks, =0A=
> Ming=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
