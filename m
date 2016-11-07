From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Mon, 07 Nov 2016 12:51:03 -0800
Message-ID: <1478551863.2422.41.camel@linux.vnet.ibm.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
         <1477706936.2850.27.camel@linux.vnet.ibm.com>
         <96320196-4074-c970-97f0-bffb74713990@sandisk.com>
         <1478267240.3287.8.camel@linux.vnet.ibm.com>
         <d31b2a7f-d591-0c78-9ddf-b9bbee89d832@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751716AbcKGUvL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 15:51:11 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA7KmWZL036304
        for <linux-scsi@vger.kernel.org>; Mon, 7 Nov 2016 15:51:10 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26jw35hey8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Nov 2016 15:51:10 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Mon, 7 Nov 2016 13:51:09 -0700
In-Reply-To: <d31b2a7f-d591-0c78-9ddf-b9bbee89d832@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2016-11-04 at 12:17 -0600, Bart Van Assche wrote:
> On 11/04/2016 07:47 AM, James Bottomley wrote:
> > You know after
> > 
> > if (device_remove_file_self(dev, attr))
> > 
> > returns true that s_active is held and also that KERNFS_SUICIDAL is 
> > set on the node, so the non-self remove paths can simply check for 
> > this flag and return without descending into __kernfs_remove(), 
> > which would mean they never take s_active.  That means we never get 
> > the inversion.
> 
> Hello James,
> 
> The lock inversion is not triggered by the non-self remove paths but 
> by the self-remove path.

I think we should agree first what the problem is.  The inversion
occurs between the sysfs delete path and the device node delete caused
by a remove host.  When both are happening the inversion is that when

	if (device_remove_file_self(dev, attr))
		scsi_remove_device(to_scsi_device(dev));

Happens, after the if, the s_active lock is held then
scsi_remove_device goes on to take the scan_mutex.

Conversely in scsi_remove_host, the mutex is taken first then
scsi_forget_host iterates removing the devices, but sysfs file removal
eventually takes s_active in kernfs_drain, which is called from
kernfs_remove via kernfs_remove_by_name_ns, hence the inversion.

This is therefore a conflict between the self and non-self remove
paths.

> Anyway, can you have a look at the two attached 
> patches?

Well, they're still overly complex, but perhaps due to the
misunderstanding above?  If you look through that trigger case, you'll
see that the fix is simply to check KERNFS_SUICIDAL in
kernfs_remove_by_name_ns and not descend into __kernfs_remove() if it's
set.  I think kernfs_mutex mediates this, but probably only if it's
moved lower down in kernfs_drain.

James

