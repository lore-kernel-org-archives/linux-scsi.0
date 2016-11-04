From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Fri, 04 Nov 2016 07:47:20 -0600
Message-ID: <1478267240.3287.8.camel@linux.vnet.ibm.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
         <1477706936.2850.27.camel@linux.vnet.ibm.com>
         <96320196-4074-c970-97f0-bffb74713990@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39470 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934360AbcKDNr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2016 09:47:28 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA4DhwR3061488
        for <linux-scsi@vger.kernel.org>; Fri, 4 Nov 2016 09:47:28 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26gsexj3x8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 04 Nov 2016 09:47:27 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Fri, 4 Nov 2016 07:47:27 -0600
In-Reply-To: <96320196-4074-c970-97f0-bffb74713990@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2016-11-03 at 16:27 -0600, Bart Van Assche wrote:
> On 10/28/2016 08:08 PM, James Bottomley wrote:
> > This is a deadlock caused by an inversion issue in kernfs (suicide
> > vs
> > non-suicide removes); so fixing it in SCSI alone really isn't
> > appropriate.  I count at least five other subsystems all using this
> > mechanism, so they'll all be similarly affected.  It looks to be
> > fairly
> > simply fixable inside kernfs, so please fix it that way.
> 
> Hello James,
> 
> How about fixing this deadlock with the below patch?

Without a description file, it's a bit hard to follow, but reading the
patch it's somewhat cumbersome and also incomplete: you change the API
for self removal, so every driver that uses the
device_remove_file_self() scheme (about five of them) has to be
changed.  I was actually thinking of something much simpler:

You know after

if (device_remove_file_self(dev, attr))

returns true that s_active is held and also that KERNFS_SUICIDAL is set
on the node, so the non-self remove paths can simply check for this
flag and return without descending into __kernfs_remove(), which would
mean they never take s_active.  That means we never get the inversion.

This should be about a 10 line patch because there are only two places
this check needs to be done: kernfs_remove() and
 kernfs_remove_by_name_ns().

It has the advantage that the api isn't altered so all the other driver
callers simply pick up the benefit.

There may be a bit of back end cleanup to do on the eventual parent
directory removal because I think it needs to wait for all the suicidal
nodes to signal they've finally suicided.

James

