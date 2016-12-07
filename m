From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Wed, 7 Dec 2016 04:40:03 +0000
Message-ID: <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
 <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584763FB.9010602@huawei.com>
 <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584784D7.1070009@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0044.outbound.protection.outlook.com ([104.47.33.44]:23072
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750825AbcLGEkG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 23:40:06 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tyasui@redhat.com" <tyasui@redhat.com>

On 12/06/16 19:41, Wei Fang wrote:=0A=
> On 2016/12/7 10:45, Bart Van Assche wrote:=0A=
>> The purpose of the scsi_device_set_state(sdev, SDEV_RUNNING) call in=0A=
>> scsi_sysfs_add_sdev() is to change the device state from SDEV_CREATED=0A=
>> into SDEV_RUNNING. Have you tried to modify scsi_sysfs_add_sdev() such=
=0A=
>> that it only changes the device state into SDEV_RUNNING if the current=
=0A=
>> state is SDEV_CREATED and also such that it changes SDEV_CREATED_BLOCK=
=0A=
>> into SDEV_BLOCK?=0A=
>=0A=
> Does those code in scsi_add_lun() have done this thing?=0A=
>         ...=0A=
>         ret =3D scsi_device_set_state(sdev, SDEV_RUNNING);=0A=
>         if (ret) {=0A=
>                 ret =3D scsi_device_set_state(sdev, SDEV_BLOCK);=0A=
>                 ...=0A=
>         }=0A=
>         ...=0A=
> You mean we shouldn't change the device state from SDEV_BLOCK=0A=
> into SDEV_RUNNING in scsi_sysfs_add_sdev()?=0A=
>=0A=
> I thought it doesn't matter that the state is changed from SDEV_BLOCK=0A=
> to SDEV_RUNNING in scsi_sysfs_add_sdev(), if the queue can be unblocked=
=0A=
> in scsi_internal_device_unblock() in SDEV_RUNNING state. But it=0A=
> was broken since commit 5c10e63c943b.=0A=
=0A=
Hello Wei,=0A=
=0A=
I am aware that commit 5c10e63c943b caused the behavior change. But that =
=0A=
doesn't mean that a fix has to undo the changes introduced by that =0A=
commit. We do not only want to make sure that the SCSI core works as =0A=
intended but also that the SCSI core code is as easy to comprehend as =0A=
reasonably possible. Adding "&& sdev->sdev_state !=3D SDEV_RUNNING" in =0A=
scsi_internal_device_unblock() would require a long comment to explain =0A=
why that code has been added. I think modifying scsi_sysfs_add_sdev() =0A=
such that it does not unblock devices will result in code that is easier =
=0A=
to understand.=0A=
=0A=
Bart.=0A=
