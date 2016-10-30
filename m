From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Sun, 30 Oct 2016 14:25:58 -0600
Message-ID: <1477859158.2777.10.camel@linux.vnet.ibm.com>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
         <1477706936.2850.27.camel@linux.vnet.ibm.com>
         <BLUPR02MB168399B25661CFC9D1DA93F381AF0@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757332AbcJ3U0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 30 Oct 2016 16:26:10 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9UKNfsf095239
        for <linux-scsi@vger.kernel.org>; Sun, 30 Oct 2016 16:26:09 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26dgkqcvhm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 30 Oct 2016 16:26:09 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Sun, 30 Oct 2016 14:26:08 -0600
In-Reply-To: <BLUPR02MB168399B25661CFC9D1DA93F381AF0@BLUPR02MB1683.namprd02.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, 2016-10-30 at 19:22 +0000, Bart Van Assche wrote:
> On 10/28/16 19:08, James Bottomley wrote:
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
> Can you clarify this further? To me this looks like the result of how
> the SCSI core works rather than an issue in the kernfs layer.

I'm at a bit of a loss, the problem looks clear from the original
trace, so I'm not really sure what's not clear to you.

The inversion is between the scan mutex and s_active which is the
rather fanciful name Tejun gave to the hand rolled mutex in
kernfs_node.

The reason for the inversion is that s_active is taken when you open a
sysfs file, including the delete one.  There's a special suidice path
to allow that file to be deleted while something else holds the lock. 
 However, if the delete path also takes any lock, and there's a way to
get into delete not via writing to sysfs (which is pretty much
universally true) then you get an inversion because kernfs_node mutex
is also taken when the file is removed, which is why it's not specific
to scsi.

Since you press the issue, I've got to say I'm not a huge fan of trying
to escape from a lock inversion by making some path asynchronous
because it usually leads to even more problems on down the road.  If
there's some problem with the generic fix, there is a way of fixing
this in SCSI without introducing asynchronicity.

James

