From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi:Prevent deletion of SCSI block device in use
Date: Mon, 19 Sep 2016 05:55:51 -0700
Message-ID: <1474289751.2426.3.camel@linux.vnet.ibm.com>
References: <CS1PR84MB002353535902FE5F0DD2B01DE1F40@CS1PR84MB0023.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49159 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755172AbcISM4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Sep 2016 08:56:04 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8JCmRLd101203
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 08:56:03 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25gyyvd6rp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2016 08:56:03 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Mon, 19 Sep 2016 06:56:02 -0600
In-Reply-To: <CS1PR84MB002353535902FE5F0DD2B01DE1F40@CS1PR84MB0023.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gurunath, Vasundhara (STSD)" <vasundhara.gurunath@hpe.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Arackal, Paulose Kuriakose (STSD)" <paulose.kuriakose.arackal@hpe.com>, "Kaur, Jasminder (STSD)" <jasminder.kaur@hpe.com>

On Mon, 2016-09-19 at 09:11 +0000, Gurunath, Vasundhara (STSD) wrote:
> James Bottomley <jejb@linux.vnet.ibm.com> wrote: 
> 
> > > From: "Gurunath, Vasundhara" <vasundhara.gurunath@hpe.com>
> > > 
> > > SCSI block device can be removed, using write to sysfs delete
> > > file as
> > > below:
> > > echo 1 > /sys/block/sdX/device/delete If the device is in use by 
> > > applications, or part of system configuration such as boot
> > > device, 
> > > removal can result in application disruptions or system down
> > > time.
> > > 
> > > An additional write option ? is added to SCSI sysfs interface as 
> > > below, in order to prevent accidental deletion of devices in use.
> > > echo ? > /sys/block/sdX/device/delete
> > > 
> > > In the absence of any usage, this option proceeds with device 
> > > deletion.  If the device is open, deletion is prevented, and
> > > active 
> > > Open and IO counts at the time of deletion is logged. Information
> > > logged during latest delete attempt can be obtained by issuing a
> > > read 
> > > to the delete file as below:
> > > cat  /sys/block/sdX/device/delete
> 
> > OK, so I'm not too keen on this because our entire system is
> > (finally) designed to be hot plug, so echoing 1 to delete simulates
> > a hotplug event, and they >can come in at any time.
> 
> > Can you elaborate on why this is necessary?  Right at the moment,
> > only 
> > root is allowed to write to this file and cause a deletion ... plus
> > the file is pretty >hard to find, buried as it is in sysfs;  So I
> > would have thought it was pretty safe from accidental misuse; why
> > does it need additional protection?
> 
> Some of the requests we got for such checks were from use cases on
> large system configurations with several LUNs.

People ask for a lot of strange stuff, but unpeel this one further and
tell us why they're asking ... what's the use case they're running into
that makes them need something like this?

> The new changes do not disturb existing interfaces. Writes to the
> "delete" sysfs file such as a "1", as advertised in some
> distributions like RedHat today, will continue to delete the LUN.
> However we thought an option to check usages during delete can
> complement existing interfaces. 
>  
> The new changes get activated only when one wants to receive alerts
> on any lingering usages, and writes a "?" to delete the LUN.
> A delete script can write "?" to sysfs delete files in bulk, while
> most LUNs get removed in the first attempt, the usages can be
> investigated if any LUNs remain with active usage counts. 
> 
> Hopefully overhead of these changes is minimal, it is few additional
> checks on usage counts and the log.
> New changes get active only in delete context and doesn't get into 
> I/O paths.

But that's effectively "because we can".  We can do a lot of stuff that
adds what you call minimal overhead (although the cumulative addition
would be significant), so the rule is we do stuff which is necessary or
useful, which is why the question about use cases.

James


