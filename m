From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi:Prevent deletion of SCSI block device in use
Date: Tue, 13 Sep 2016 10:17:01 -0700
Message-ID: <1473787021.2214.45.camel@linux.vnet.ibm.com>
References: <1473784685-2194-1-git-send-email-vasundhara.gurunath@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754771AbcIMRRL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Sep 2016 13:17:11 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8DHCbWX070284
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2016 13:17:10 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25dwtya4r1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2016 13:17:10 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 13 Sep 2016 11:17:08 -0600
In-Reply-To: <1473784685-2194-1-git-send-email-vasundhara.gurunath@hpe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, paulose.kuriakose.arackal@hpe.com, jasminder.kaur@hpe.com

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

OK, so I'm not too keen on this because our entire system is (finally)
designed to be hot plug, so echoing 1 to delete simulates a hotplug
event, and they can come in at any time.

Can you elaborate on why this is necessary?  Right at the moment, only
root is allowed to write to this file and cause a deletion ... plus the
file is pretty hard to find, buried as it is in sysfs; So I would have
thought it was pretty safe from accidental misuse; why does it need
additional protection?

James


