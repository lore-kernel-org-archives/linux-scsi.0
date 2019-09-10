Return-Path: <SRS0=qYHy=XF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2B8C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 12:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 113012089F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Sep 2019 12:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Qp/CX1SD";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Llu1dAVX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfIJMFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 08:05:37 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:29277 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIJMFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 08:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1568117137; x=1599653137;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=naPgreOrv+jbplJUeYbYK1HSrWlw/hU8Yk2K8iPwzZM=;
  b=Qp/CX1SDLQPMUT7uNE5D5G7ccYFvCifm7vGdf+p0ZV7fn/c1RT+8i/0P
   l1j15crxpxZebWHrNUrCIStlAo6OqYjxKpMRKMfwcdRN/CCvnUml1Ux86
   H/O5Yg7nYCsHBiE0M1awxBehplGPCNA9H+nCD+jnNyu7WYuWTn+Axphuo
   DK9bq2fFFz6Y/LNpsPc7PJPoHDA3UmWDrNv8eosTY/ZLsBLsOWh1S9QjB
   CVDmgCPHVpPePspWwZrYtPSEGPsS1O2IFQ2lrUZYZj8Lis1np9VY6EHlh
   IeXgXEKKDIsNVGXC+YddB1/xtudpGRgMuO+ZjeXaMJGkzMNWXyamL8MrL
   Q==;
IronPort-SDR: 60UeObbVLR1ovluIHwP4rlrNF+DVHxpn26EDl0e2Cla30zhi1fMRejfO/2UDY14suNRvHBWhDM
 cDJ0DWJ78mDC9H+qgv8MT2O0jboEvW2vHefkod5piLDRlcqazo/JeblJBzU0knkBQxzguhLfXg
 Kco+yMU54CK5qBX18hOYGNELOHDnds4laYlPdRdzKeTl7zAIO/dvm7vWIPzyRQW46fRns5qJZD
 /diEb6VhA0i4VPa6Rrr6jaHCkSLB0qq0R8HQkl71SAiQPe6DnfrwTOCsab32RnW296TQRAGtgh
 bKc=
X-IronPort-AV: E=Sophos;i="5.64,489,1559491200"; 
   d="scan'208";a="119491830"
Received: from mail-co1nam05lp2057.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.57])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2019 20:05:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fH2tOszrsWonHU4WFR530DIfnf9BOmqE8H7j9Mgo11aHcPXqyzUn9yAMM0VgONLTJ3LHxEzEeCHsQ2RIEmC7fLS+FgeG1LorXC4Lsc2oT69932PoyiOqvspg6JPcHtQ9eYe08DG1uuJcwpNjCvxC4+XewMDwEC4/CM1UX+/dR7y6/DhVSY7Is8BI41N72nmh1wBVnb1Oiu5X3P1L5V/l0N2jw6jdlVYIojo8ubHPi9yS0z7vELh71gjLH9uQ1i7/UIVVt0nDk+PogmktJ8VnlY4ioveIvWITnEslzUnbvLs+mcwmZtaEqdhJhYyISLxn7tY07dMfgFKT8stxxcOOgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5Xtce5IzlhYIqSnG3eOSlANtfHLHGZbCjZuFA7zPic=;
 b=VQLfdPFX+OYUfbmUkBJ6XK11+ss50QKHvMlDHbE4OtZ4PrU56JLQuffmfPl+CEJUuY4jd+uugvwDVXc9XXR1BLiLTWorMHmmT2IWfe14U7MI724sUTdQT/2Opjytj0aGk2qU91epuCqxHyGiwaVNtBSeeKW453st+AxvtO2c2NJmCv70osOcBZxaqhLnEkyzn8KgFXxTovswcs0k8yei+9SdW0XbKRryB/X8H106Ya65++zuT/Q9MBRlSDzFaGZq0ybANxHGoMQSS1NgSuflsDP2fmKol6auN0pxJL+TPw8DEpruqmqt5aig8ixAZvY/SGF8aqWfr1x5ZUi8FutQGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5Xtce5IzlhYIqSnG3eOSlANtfHLHGZbCjZuFA7zPic=;
 b=Llu1dAVXsbVjwrnoij+BD628EaSSwH3RyEkQJZNBdFPID9WS6D9pjtqs5cuabXEboipARqRzvEcNi+caoDwQiK7dDE3sDrj6ZHn+ytoyRDwPJutynawIKqdNKN/dBANBt65ujWPAKlvSp+nWT/XOhNJVQ07eAIKGcIuAHZbodEg=
Received: from DM6PR04MB5817.namprd04.prod.outlook.com (20.179.48.92) by
 DM6PR04MB6731.namprd04.prod.outlook.com (10.186.141.201) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 12:05:33 +0000
Received: from DM6PR04MB5817.namprd04.prod.outlook.com
 ([fe80::1c67:56a6:4b01:a381]) by DM6PR04MB5817.namprd04.prod.outlook.com
 ([fe80::1c67:56a6:4b01:a381%6]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 12:05:33 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mike Christie <mchristi@redhat.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
Thread-Topic: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
Thread-Index: AQHVZyuWq/Op5bBFkEiasB8XvOZqww==
Date:   Tue, 10 Sep 2019 12:05:33 +0000
Message-ID: <DM6PR04MB5817096434DE9381DDB55184E7B60@DM6PR04MB5817.namprd04.prod.outlook.com>
References: <20190909162804.5694-1-mchristi@redhat.com>
 <20190910100000.mcik63ot6o3dyzjv@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [213.30.8.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 000959f4-a8fe-46d8-a6d6-08d735e72ec1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DM6PR04MB6731;
x-ms-traffictypediagnostic: DM6PR04MB6731:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR04MB67314BDAA9D6FD1839D493ECE7B60@DM6PR04MB6731.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(15374003)(189003)(199004)(52314003)(8936002)(53936002)(256004)(9686003)(55016002)(14444005)(66946007)(66476007)(52536014)(86362001)(14454004)(66066001)(64756008)(66446008)(7696005)(478600001)(316002)(53546011)(6506007)(2906002)(4326008)(25786009)(33656002)(229853002)(66556008)(8676002)(81166006)(102836004)(81156014)(476003)(446003)(5660300002)(26005)(6306002)(6246003)(186003)(6436002)(99286004)(91956017)(76116006)(110136005)(7736002)(486006)(305945005)(74316002)(71200400001)(54906003)(76176011)(966005)(71190400001)(3846002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR04MB6731;H:DM6PR04MB5817.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: raaW51p2unL46BRJPzIAsAp+Y1ogb7hHRyccCpnciK6Ei91w2c2rQnVLpHvVt2nSd82NiTFNpYvlwme1nBJpyzuj8dSU1yAxsLeYT6hTGBk7HUh/GRh1x+siB8C1KpZ1N7oWUusLzdBSpzhpbvpjj956DrUFLkn46or3IbtaGqySMZWOHTfRKAag6A9+N4/HJbJckSRO6p9QoDALNG37cmFmoKYPoTEMQKU8iqFNFg6w4AdrrJniSqDUBHr1tN0GeKSxvBBuZjl6WviPpRfRB1l+8NKobpJy7RabREHTqMdwySiiZLcsFS67ytcvW5W9LXlEweFCyTvgLkEupKcfTnZ+/aBIZY34T43f23bo8WtDlOk/gqj+ib+8FiXtUVcHIV8DqlEyhgiTVIc6FidU4DUrQwEm2VE2JEYfY4f5sK4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 000959f4-a8fe-46d8-a6d6-08d735e72ec1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 12:05:33.2566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7gTA7MUPcjo/S85q4brTvVfngRNmRv0rpwOtazYc6GDTVQLcopnlYyK/o50NBRrhZHxvzunNnX7wnQ2JFNfL/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6731
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019/09/10 11:00, Kirill A. Shutemov wrote:=0A=
> On Mon, Sep 09, 2019 at 11:28:04AM -0500, Mike Christie wrote:=0A=
>> There are several storage drivers like dm-multipath, iscsi, and nbd that=
=0A=
>> have userspace components that can run in the IO path. For example,=0A=
>> iscsi and nbd's userspace deamons may need to recreate a socket and/or=
=0A=
>> send IO on it, and dm-multipath's daemon multipathd may need to send IO=
=0A=
>> to figure out the state of paths and re-set them up.=0A=
>>=0A=
>> In the kernel these drivers have access to GFP_NOIO/GFP_NOFS and the=0A=
>> memalloc_*_save/restore functions to control the allocation behavior,=0A=
>> but for userspace we would end up hitting a allocation that ended up=0A=
>> writing data back to the same device we are trying to allocate for.=0A=
>>=0A=
>> This patch allows the userspace deamon to set the PF_MEMALLOC* flags=0A=
>> through procfs. It currently only supports PF_MEMALLOC_NOIO, but=0A=
>> depending on what other drivers and userspace file systems need, for=0A=
>> the final version I can add the other flags for that file or do a file=
=0A=
>> per flag or just do a memalloc_noio file.=0A=
>>=0A=
>> Signed-off-by: Mike Christie <mchristi@redhat.com>=0A=
>> ---=0A=
>>  Documentation/filesystems/proc.txt |  6 ++++=0A=
>>  fs/proc/base.c                     | 53 ++++++++++++++++++++++++++++++=
=0A=
>>  2 files changed, 59 insertions(+)=0A=
>>=0A=
>> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesyst=
ems/proc.txt=0A=
>> index 99ca040e3f90..b5456a61a013 100644=0A=
>> --- a/Documentation/filesystems/proc.txt=0A=
>> +++ b/Documentation/filesystems/proc.txt=0A=
>> @@ -46,6 +46,7 @@ Table of Contents=0A=
>>    3.10  /proc/<pid>/timerslack_ns - Task timerslack value=0A=
>>    3.11	/proc/<pid>/patch_state - Livepatch patch operation state=0A=
>>    3.12	/proc/<pid>/arch_status - Task architecture specific information=
=0A=
>> +  3.13  /proc/<pid>/memalloc - Control task's memory reclaim behavior=
=0A=
>>  =0A=
>>    4	Configuring procfs=0A=
>>    4.1	Mount options=0A=
>> @@ -1980,6 +1981,11 @@ Example=0A=
>>   $ cat /proc/6753/arch_status=0A=
>>   AVX512_elapsed_ms:      8=0A=
>>  =0A=
>> +3.13 /proc/<pid>/memalloc - Control task's memory reclaim behavior=0A=
>> +-----------------------------------------------------------------------=
=0A=
>> +A value of "noio" indicates that when a task allocates memory it will n=
ot=0A=
>> +reclaim memory that requires starting phisical IO.=0A=
>> +=0A=
>>  Description=0A=
>>  -----------=0A=
>>  =0A=
>> diff --git a/fs/proc/base.c b/fs/proc/base.c=0A=
>> index ebea9501afb8..c4faa3464602 100644=0A=
>> --- a/fs/proc/base.c=0A=
>> +++ b/fs/proc/base.c=0A=
>> @@ -1223,6 +1223,57 @@ static const struct file_operations proc_oom_scor=
e_adj_operations =3D {=0A=
>>  	.llseek		=3D default_llseek,=0A=
>>  };=0A=
>>  =0A=
>> +static ssize_t memalloc_read(struct file *file, char __user *buf, size_=
t count,=0A=
>> +			     loff_t *ppos)=0A=
>> +{=0A=
>> +	struct task_struct *task;=0A=
>> +	ssize_t rc =3D 0;=0A=
>> +=0A=
>> +	task =3D get_proc_task(file_inode(file));=0A=
>> +	if (!task)=0A=
>> +		return -ESRCH;=0A=
>> +=0A=
>> +	if (task->flags & PF_MEMALLOC_NOIO)=0A=
>> +		rc =3D simple_read_from_buffer(buf, count, ppos, "noio", 4);=0A=
>> +	put_task_struct(task);=0A=
>> +	return rc;=0A=
>> +}=0A=
>> +=0A=
>> +static ssize_t memalloc_write(struct file *file, const char __user *buf=
,=0A=
>> +			      size_t count, loff_t *ppos)=0A=
>> +{=0A=
>> +	struct task_struct *task;=0A=
>> +	char buffer[5];=0A=
>> +	int rc =3D count;=0A=
>> +=0A=
>> +	memset(buffer, 0, sizeof(buffer));=0A=
>> +	if (count !=3D sizeof(buffer) - 1)=0A=
>> +		return -EINVAL;=0A=
>> +=0A=
>> +	if (copy_from_user(buffer, buf, count))=0A=
>> +		return -EFAULT;=0A=
>> +	buffer[count] =3D '\0';=0A=
>> +=0A=
>> +	task =3D get_proc_task(file_inode(file));=0A=
>> +	if (!task)=0A=
>> +		return -ESRCH;=0A=
>> +=0A=
>> +	if (!strcmp(buffer, "noio")) {=0A=
>> +		task->flags |=3D PF_MEMALLOC_NOIO;=0A=
>> +	} else {=0A=
>> +		rc =3D -EINVAL;=0A=
>> +	}=0A=
> =0A=
> Really? Without any privilege check? So any random user can tap into=0A=
> __GFP_NOIO allocations?=0A=
=0A=
OK. It probably should have a test on capable(CAP_SYS_ADMIN) or similar. Si=
nce=0A=
these storage daemons are generally run as root anyway, that would still wo=
rk=0A=
for most setup I think.=0A=
=0A=
> =0A=
> NAK.=0A=
> =0A=
> I don't think that it's great idea in general to expose this low-level=0A=
> machinery to userspace. But it's better to get comment from people move=
=0A=
> familiar with reclaim path.=0A=
=0A=
Any setup with stacked file systems and one of the IO path component being =
a=0A=
user level process can benefit from this. See the problem described in this=
=0A=
patch I pushed for (unsuccessfully as it was a heavy handed solution):=0A=
https://www.spinics.net/lists/linux-fsdevel/msg148912.html=0A=
=0A=
As the discussion in this thread shows, there is no existing simple solutio=
n to=0A=
deal with this reclaim recursion problem. And automatic detection is too ha=
rd,=0A=
if at all possible. With the proper access rights added, this user accessib=
le=0A=
interface does look very sensible to me.=0A=
=0A=
Best regards.=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
