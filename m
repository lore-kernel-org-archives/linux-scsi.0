From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Tue, 6 Dec 2016 15:51:00 +0000
Message-ID: <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0077.outbound.protection.outlook.com ([104.47.34.77]:18959
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751613AbcLFPvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 10:51:02 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tyasui@redhat.com" <tyasui@redhat.com>

On 12/06/16 01:12, Wei Fang wrote:=0A=
> The scsi device is being setted to the SDEV_RUNNING state at the end of=
=0A=
> the scan work. When the remote port reappears, scsi_target_unblock()=0A=
> will be called, but the QUEUE_FLAG_STOPPED flag will not be cleared,=0A=
> since scsi_internal_device_unblock() ignores SCSI devices in SDEV_RUNNING=
=0A=
> state. It results in a permanent stop of the scsi device's request=0A=
> queue. Every requests sended to it will be blocked.=0A=
=0A=
Hello Wei,=0A=
=0A=
scsi_device_set_state() does not allow the transition from =0A=
SDEV_CREATED_BLOCK to SDEV_RUNNING. If a SCSI device is blocked after it =
=0A=
has been added to the __devices list and before scsi_add_lun() finishes =0A=
then I think the scan code will change its state into SDEV_BLOCK. Are =0A=
you sure what you described above is what happened?=0A=
=0A=
Bart.=0A=
