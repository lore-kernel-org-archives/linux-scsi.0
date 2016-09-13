From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi:Prevent deletion of SCSI block device in use
Date: Tue, 13 Sep 2016 14:25:50 -0400
Message-ID: <1473791150.4648.32.camel@localhost.localdomain>
References: <1473784685-2194-1-git-send-email-vasundhara.gurunath@hpe.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752337AbcIMSZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 14:25:52 -0400
In-Reply-To: <1473784685-2194-1-git-send-email-vasundhara.gurunath@hpe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, paulose.kuriakose.arackal@hpe.com, jasminder.kaur@hpe.com

On Tue, 2016-09-13 at 22:08 +0530, Gurunath, Vasundhara wrote:
> From: "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>
> 
> SCSI block device can be removed, using write to sysfs
> delete file as below:
> echo 1 > /sys/block/sdX/device/delete
> If the device is in use by applications, or part of
> system configuration such as boot device, removal can
> result in application disruptions or system down time.
> 
> An additional write option ? is added to SCSI sysfs
> interface as below, in order to prevent accidental
> deletion of devices in use.
> echo ? > /sys/block/sdX/device/delete
> 
> In the absence of any usage, this option proceeds with
> device deletion.  If the device is open, deletion is
> prevented, and active Open and IO counts at the time of
> deletion is logged. Information logged during latest
> delete attempt can be obtained by issuing a read to the
> delete file as below:
> cat  /sys/block/sdX/device/delete
> 

This looks like debugging code added to find some culprit
who deleted a device they weren't supposed to, and make it
more difficult for them.

I don't think we'd want this in normal usage.

-Ewan



