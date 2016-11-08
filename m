From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Tue, 08 Nov 2016 10:01:41 -0800
Message-ID: <1478628101.2824.27.camel@linux.vnet.ibm.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
         <1478618887.2824.2.camel@linux.vnet.ibm.com>
         <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43056 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753233AbcKHSBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 13:01:50 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA8I006P114285
        for <linux-scsi@vger.kernel.org>; Tue, 8 Nov 2016 13:01:49 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26kh432d2t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 13:01:49 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 8 Nov 2016 11:01:48 -0700
In-Reply-To: <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Eric Biederman <ebiederm@xmission.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2016-11-08 at 08:52 -0800, Bart Van Assche wrote:
> On 11/08/2016 07:28 AM, James Bottomley wrote:
> > On Mon, 2016-11-07 at 16:32 -0800, Bart Van Assche wrote:
> > > diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
> > > index cf4c636..44ec536 100644
> > > --- a/fs/kernfs/dir.c
> > > +++ b/fs/kernfs/dir.c
> > > @@ -1410,7 +1410,7 @@ int kernfs_remove_by_name_ns(struct
> > > kernfs_node
> > > *parent, const char *name,
> > >  	mutex_lock(&kernfs_mutex);
> > > 
> > >  	kn = kernfs_find_ns(parent, name, ns);
> > > -	if (kn)
> > > +	if (kn && !(kn->flags & KERNFS_SUICIDED))
> > 
> > Actually, wrong flag, you need KERNFS_SUICIDAL.  The reason is that
> > kernfs_mutex is actually dropped half way through __kernfs_remove, 
> > so KERNFS_SUICIDED is not set atomically with this mutex.
> 
> Hello James,
> 
> Sorry but what you wrote is not correct.

I think you agree it is dropped.  I don't need to add the bit about the
reacquisition because the race is mediated by the first acquisition not
the second one, if you mediate on KERNFS_SUICIDAL, you only need to
worry about this because the mediation is in the first acquisition.  If
you mediate on KERNFS_SUICIDED, you need to explain that the final
thing that means the race can't happen is the unbreak in the sysfs
delete path re-acquiring s_active ... the explanation of what's going
on and why gets about 2x more complex.

James

>  __kernfs_remove() calls kernfs_drain(). That last function not only 
> drops but also reacquires kernfs_mutex. So both KERNFS_SUICIDAL and 
> KERNFS_SUICIDED are set while holding kernfs_mutex.


