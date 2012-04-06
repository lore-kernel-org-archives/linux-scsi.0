From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 17:32:35 +0200
Message-ID: <4F7F0C93.1060803@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F7EB9E4.4050205@acm.org> <4F7EC1F8.9030706@redhat.com> <4F7EEBFD.8000809@redhat.com> <4F7EFFDE.3020003@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab2DFPcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2012 11:32:45 -0400
In-Reply-To: <4F7EFFDE.3020003@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

On 04/06/2012 04:38 PM, Bart Van Assche wrote:
> On 04/06/12 13:13, Tomas Henzl wrote:
>
>> This means that after scsi_remove_host is left and the driver rmmoded
>> we call scsi_host_put which in the end calls scsi_host_dev_release
>> and this function tries to use the now invalid host_template
>> functions again.
> There are already several other ways in which the host template can be
> accessed after scsi_remove_host() finished:
> * Via the scsi_proc_hostdir_rm() call in scsi_host_dev_release().
This ^ is actually the case i wrote about in my previous mail.

> * From the SCSI error handler thread.
> * From inside scsi_dispatch_cmd().
>
> Why isn't the SCSI error handler thread stopped from inside
> scsi_remove_host() ? And why isn't scsi_proc_hostdir_rm() invoked from
> inside scsi_remove_host() ? Am I missing something ?
I'm not the right person to answer this, but it might be really so bad
that the only reason is that module unload of a scsi driver is not used often.

Going back to my initial case, resetting the host template to zero in 
scsi_remove_host and using a locking mechanism to protect host template
would also solve the scan problem (and maybe some other too), what do you think?

tomash

>
> Thanks,
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

