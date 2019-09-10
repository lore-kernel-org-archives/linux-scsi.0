Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F57C49ED6
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 13:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 890FB21019
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 13:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gb4xaDo1";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="S5HbR1QJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732684AbfIJNhS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 09:37:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:39700 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732546AbfIJNhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 09:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568122636; x=1599658636;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8KKCPSway983SZ7giKWDeI91idfdOVAQ7pgBy3CKcfw=;
  b=Gb4xaDo1erOlPyxf22xsaSJc65c7z19yj6TvnlylvA/lyPWh815SapQi
   2hAfU/JLpbT535XmwCe1mE+hFg3Mq8icWcnZHismVmdooJuU1qU+WtRjS
   tvekc1Hrbj2wrQ12TfIGfN5WGif8/CrVZMAl0NcynqO5qaoRZd4HaPkC1
   Cl9OHVZ++gIClG+HuPkQfbOMZiOOagLkJQcsZ6gK30rabY5YqiteHoPnX
   jsIGTGVcgJAfFo8wYYDAaYidKNgREgjb6D/CUCkh6ACCudJ6PQVbS/Ew/
   x60DpEPuqaGOC8i4spYZikUsvtZsGxjJqLp4x17mi3ynx/j9scDSYlfWk
   w==;
IronPort-SDR: xnXXwp6ziCShDt8RRg0xQCE/VHwlXNOzhFk1suiqE0RgGKCzwuD3VJybdjJPTqSgAVyJoh2WLf
 Jo1zwAH4P6vhudNNofIbUnt4D5Hxg+XzSvnNI5yNrJ92U5XTKGde4qW/hUk5gVxv2hWB+J4XRz
 7P2aYjd+vNxFnlqb6U0tlwaFTLTnYiWFDRf5GBVEPwhycWhHmsmxgtwQPW+6OXWMViQNclKXvR
 RV4B6ENuDiWXCsU+tB05CRAqu/mH0GdoQKEuLIWXe4+RihL6VvVJIVzBARYrnLtY4y5n27mrWb
 ees=
X-IronPort-AV: E=Sophos;i="5.64,489,1559491200"; 
   d="scan'208";a="122466123"
Received: from mail-co1nam03lp2050.outbound.protection.outlook.com (HELO NAM03-CO1-obe.outbound.protection.outlook.com) ([104.47.40.50])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2019 21:37:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4aIMBdZu4Y8cHvYZOb5Iu5eLzGHhn7zVmqF+gEG44wwvrUic1Uu8J+yKQSL++ZNRPkuXoEaWhVgz1Y72sh+46wMht5NqUUTQbRvGhkL2Bmu/PA3h6RlvwSldBbVmgn2thY1p8VUjC5d8QfVweDpRaYyhseKvc6sF8qHFfl0vnQUTivbfCStASxQTJwlKwqXPH49xL3TqFXw9Xz7vw73Jm4TQ4kbj9wX6neHusZlv8qTju9+lVKw4leQpcX7C9ll9gX7Dk+lKjGS1rDsvxewPvCJ6E9ua16kE9PSTHeUhCgsOQQcQtXaExPpzkRSgbz2hUbToXKJFFyvtgvxV3QHwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhkow45OTJuEqUEk+PrfZe1/jEHM0JYxmhjaXir5iSI=;
 b=Npq6JiWFapyi7ouFjWJWQz9cvhivD8exr+UeXzC4ejBUGIxHAZe1+YW4LKNCUSJRSWVqJ/KQISrmb20XlAqu4XmWMvLQIDbUWHTTfNDyPF9syJk/jjsY7cpr+MOHlBZsN5GclBYNObte5wDsP+j4xxblfgpfsSs9cdYDPyqZm+ZkU3K6R48XfqsfI1gvYT3AQWpZLHhI0oyvgQwwK6VobhFCmWESZrkWe34+ftqVk6Psi7w8njRQYt3akyMnbJysUnZikL0QEqiqwp7pQo0CUBwJe3Ajyg/bpH5f3xVGzgfo6gVjWUHDA4G6XlyXYLU66WyUiMKcGiJesQW8ks7L8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhkow45OTJuEqUEk+PrfZe1/jEHM0JYxmhjaXir5iSI=;
 b=S5HbR1QJ9d9V58cSjTT6CAvG5g5ewZGfkW+N0qrub8gLI1Kj5QmGNh+QfruN85R9utrcI9A9ugDjzdmrVY3JOxbpWenx9Rw7ucgQ5rlOk1GZjEWkW7EMWQE44T29JFV9gPCX3CJPGRaJiLpOz5jMC6jb8utXPpV9qma8X3+k6rg=
Received: from DM6PR04MB5817.namprd04.prod.outlook.com (20.179.48.92) by
 DM6PR04MB3964.namprd04.prod.outlook.com (20.176.85.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.22; Tue, 10 Sep 2019 13:37:14 +0000
Received: from DM6PR04MB5817.namprd04.prod.outlook.com
 ([fe80::1c67:56a6:4b01:a381]) by DM6PR04MB5817.namprd04.prod.outlook.com
 ([fe80::1c67:56a6:4b01:a381%6]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 13:37:14 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
CC:     Mike Christie <mchristi@redhat.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
Thread-Topic: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
Thread-Index: AQHVZyuWq/Op5bBFkEiasB8XvOZqww==
Date:   Tue, 10 Sep 2019 13:37:13 +0000
Message-ID: <DM6PR04MB581765CF739A729164C6916EE7B60@DM6PR04MB5817.namprd04.prod.outlook.com>
References: <20190909162804.5694-1-mchristi@redhat.com>
 <20190910100000.mcik63ot6o3dyzjv@box.shutemov.name>
 <DM6PR04MB5817096434DE9381DDB55184E7B60@DM6PR04MB5817.namprd04.prod.outlook.com>
 <20190910124116.74pxl73rybmkl5j3@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [213.30.8.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f85023a-9f3c-4290-e1c4-08d735f3fd77
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR04MB3964;
x-ms-traffictypediagnostic: DM6PR04MB3964:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR04MB39643F8FE95514BC84E4493BE7B60@DM6PR04MB3964.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(52314003)(199004)(189003)(15374003)(54094003)(51444003)(316002)(6246003)(76176011)(74316002)(55016002)(3846002)(7696005)(305945005)(9686003)(476003)(8676002)(7736002)(81166006)(229853002)(102836004)(446003)(26005)(25786009)(86362001)(54906003)(81156014)(186003)(486006)(71200400001)(4326008)(71190400001)(33656002)(52536014)(66446008)(66556008)(66066001)(966005)(6436002)(14454004)(5660300002)(64756008)(478600001)(256004)(76116006)(14444005)(91956017)(8936002)(6506007)(53936002)(66946007)(99286004)(53546011)(66476007)(6306002)(6916009)(2906002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB3964;H:DM6PR04MB5817.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /L3LOg+U29a6TbSH1wukuTFNj58ORM/gaexYd6nV+3J7025bPnYlXtPcp8/SjIoXKc57H4285suVngo5k2qZ9PXajtwkyn4/rlP6TGBnyiLfORseyy3OxF9iOn/rZm0sK669eUal0IJyaMdXs4LF42ESjS1MP001qgYtg3TiYVKjMQxYwxoegt1Ilv8L2bTCOigvG6scFzchT2ucX/aJMEe8cRKDoOrUenTYE0UopE5HGJPy6G4BvKSBIds+fVRXXvFkiUcjMpXZhRoAFCCzu6aV3Fi+3GkXFoVYg+NQvT0puVScDwYqJMM/DqmlFhiT8y9MtN9942KhLcx1kl7Z2pEgqZtJtjOtOgZzlJvn/pEpEqO1Dt+icd4WwWuKQ0lY7TKtyUsGrtFJ7DqjkUY4S9+gOH25e4LJ0OsXeyNV6pg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f85023a-9f3c-4290-e1c4-08d735f3fd77
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 13:37:14.0062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ARe3DHAvFYP3B8Lj/Ky2Cdp5xyeblowbah6KKg1aJNOoMFRgEWU9jTOQgET5yyJKxZTlKvN3wyxIxYF5eACTBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3964
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ Miklos=0A=
=0A=
On 2019/09/10 13:41, Kirill A. Shutemov wrote:=0A=
> On Tue, Sep 10, 2019 at 12:05:33PM +0000, Damien Le Moal wrote:=0A=
>> On 2019/09/10 11:00, Kirill A. Shutemov wrote:=0A=
>>> On Mon, Sep 09, 2019 at 11:28:04AM -0500, Mike Christie wrote:=0A=
>>>> There are several storage drivers like dm-multipath, iscsi, and nbd th=
at=0A=
>>>> have userspace components that can run in the IO path. For example,=0A=
>>>> iscsi and nbd's userspace deamons may need to recreate a socket and/or=
=0A=
>>>> send IO on it, and dm-multipath's daemon multipathd may need to send I=
O=0A=
>>>> to figure out the state of paths and re-set them up.=0A=
>>>>=0A=
>>>> In the kernel these drivers have access to GFP_NOIO/GFP_NOFS and the=
=0A=
>>>> memalloc_*_save/restore functions to control the allocation behavior,=
=0A=
>>>> but for userspace we would end up hitting a allocation that ended up=
=0A=
>>>> writing data back to the same device we are trying to allocate for.=0A=
>>>>=0A=
>>>> This patch allows the userspace deamon to set the PF_MEMALLOC* flags=
=0A=
>>>> through procfs. It currently only supports PF_MEMALLOC_NOIO, but=0A=
>>>> depending on what other drivers and userspace file systems need, for=
=0A=
>>>> the final version I can add the other flags for that file or do a file=
=0A=
>>>> per flag or just do a memalloc_noio file.=0A=
>>>>=0A=
>>>> Signed-off-by: Mike Christie <mchristi@redhat.com>=0A=
>>>> ---=0A=
>>>>  Documentation/filesystems/proc.txt |  6 ++++=0A=
>>>>  fs/proc/base.c                     | 53 +++++++++++++++++++++++++++++=
+=0A=
>>>>  2 files changed, 59 insertions(+)=0A=
>>>>=0A=
>>>> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesy=
stems/proc.txt=0A=
>>>> index 99ca040e3f90..b5456a61a013 100644=0A=
>>>> --- a/Documentation/filesystems/proc.txt=0A=
>>>> +++ b/Documentation/filesystems/proc.txt=0A=
>>>> @@ -46,6 +46,7 @@ Table of Contents=0A=
>>>>    3.10  /proc/<pid>/timerslack_ns - Task timerslack value=0A=
>>>>    3.11	/proc/<pid>/patch_state - Livepatch patch operation state=0A=
>>>>    3.12	/proc/<pid>/arch_status - Task architecture specific informati=
on=0A=
>>>> +  3.13  /proc/<pid>/memalloc - Control task's memory reclaim behavior=
=0A=
>>>>  =0A=
>>>>    4	Configuring procfs=0A=
>>>>    4.1	Mount options=0A=
>>>> @@ -1980,6 +1981,11 @@ Example=0A=
>>>>   $ cat /proc/6753/arch_status=0A=
>>>>   AVX512_elapsed_ms:      8=0A=
>>>>  =0A=
>>>> +3.13 /proc/<pid>/memalloc - Control task's memory reclaim behavior=0A=
>>>> +---------------------------------------------------------------------=
--=0A=
>>>> +A value of "noio" indicates that when a task allocates memory it will=
 not=0A=
>>>> +reclaim memory that requires starting phisical IO.=0A=
>>>> +=0A=
>>>>  Description=0A=
>>>>  -----------=0A=
>>>>  =0A=
>>>> diff --git a/fs/proc/base.c b/fs/proc/base.c=0A=
>>>> index ebea9501afb8..c4faa3464602 100644=0A=
>>>> --- a/fs/proc/base.c=0A=
>>>> +++ b/fs/proc/base.c=0A=
>>>> @@ -1223,6 +1223,57 @@ static const struct file_operations proc_oom_sc=
ore_adj_operations =3D {=0A=
>>>>  	.llseek		=3D default_llseek,=0A=
>>>>  };=0A=
>>>>  =0A=
>>>> +static ssize_t memalloc_read(struct file *file, char __user *buf, siz=
e_t count,=0A=
>>>> +			     loff_t *ppos)=0A=
>>>> +{=0A=
>>>> +	struct task_struct *task;=0A=
>>>> +	ssize_t rc =3D 0;=0A=
>>>> +=0A=
>>>> +	task =3D get_proc_task(file_inode(file));=0A=
>>>> +	if (!task)=0A=
>>>> +		return -ESRCH;=0A=
>>>> +=0A=
>>>> +	if (task->flags & PF_MEMALLOC_NOIO)=0A=
>>>> +		rc =3D simple_read_from_buffer(buf, count, ppos, "noio", 4);=0A=
>>>> +	put_task_struct(task);=0A=
>>>> +	return rc;=0A=
>>>> +}=0A=
>>>> +=0A=
>>>> +static ssize_t memalloc_write(struct file *file, const char __user *b=
uf,=0A=
>>>> +			      size_t count, loff_t *ppos)=0A=
>>>> +{=0A=
>>>> +	struct task_struct *task;=0A=
>>>> +	char buffer[5];=0A=
>>>> +	int rc =3D count;=0A=
>>>> +=0A=
>>>> +	memset(buffer, 0, sizeof(buffer));=0A=
>>>> +	if (count !=3D sizeof(buffer) - 1)=0A=
>>>> +		return -EINVAL;=0A=
>>>> +=0A=
>>>> +	if (copy_from_user(buffer, buf, count))=0A=
>>>> +		return -EFAULT;=0A=
>>>> +	buffer[count] =3D '\0';=0A=
>>>> +=0A=
>>>> +	task =3D get_proc_task(file_inode(file));=0A=
>>>> +	if (!task)=0A=
>>>> +		return -ESRCH;=0A=
>>>> +=0A=
>>>> +	if (!strcmp(buffer, "noio")) {=0A=
>>>> +		task->flags |=3D PF_MEMALLOC_NOIO;=0A=
>>>> +	} else {=0A=
>>>> +		rc =3D -EINVAL;=0A=
>>>> +	}=0A=
>>>=0A=
>>> Really? Without any privilege check? So any random user can tap into=0A=
>>> __GFP_NOIO allocations?=0A=
>>=0A=
>> OK. It probably should have a test on capable(CAP_SYS_ADMIN) or similar.=
 Since=0A=
>> these storage daemons are generally run as root anyway, that would still=
 work=0A=
>> for most setup I think.=0A=
>>=0A=
>>>=0A=
>>> NAK.=0A=
>>>=0A=
>>> I don't think that it's great idea in general to expose this low-level=
=0A=
>>> machinery to userspace. But it's better to get comment from people move=
=0A=
>>> familiar with reclaim path.=0A=
>>=0A=
>> Any setup with stacked file systems and one of the IO path component bei=
ng a=0A=
>> user level process can benefit from this. See the problem described in t=
his=0A=
>> patch I pushed for (unsuccessfully as it was a heavy handed solution):=
=0A=
>> https://www.spinics.net/lists/linux-fsdevel/msg148912.html=0A=
>>=0A=
>> As the discussion in this thread shows, there is no existing simple solu=
tion to=0A=
>> deal with this reclaim recursion problem. And automatic detection is too=
 hard,=0A=
>> if at all possible. With the proper access rights added, this user acces=
sible=0A=
>> interface does look very sensible to me.=0A=
> =0A=
> Looking into the thread, have you find out if there's anything on FUSE=0A=
> side that helps it to avoid deadlocks? Or FUSE just relies on luck with=
=0A=
> this?=0A=
=0A=
I did not see anything relevant. The nofs allocations seem to all be in the=
=0A=
writpage/writepages methods for the client side, to prepare requests to sen=
d to=0A=
the fuse daemon serving them. I think that that is equivalent to a regular =
FS=0A=
(e.g. XFS) using NOFS allocations during writeback on top of the emulated d=
evice=0A=
served by a user level daemon (e.g. tcmu-runner in the problem case I repor=
ted).=0A=
So it does look like a fuse daemon actually serving the request may still=
=0A=
trigger a reclaim into the fuse FS. I wonder if such problem ever was repor=
ted=0A=
or if there are some clever tricks I am missing.=0A=
=0A=
Miklos,=0A=
=0A=
Could you comment on this ? Is there a mechanism in fuse preventing the=0A=
userspace fuse daemon memory triggering a reclaim into the fuse FS being pr=
ocessed ?=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
