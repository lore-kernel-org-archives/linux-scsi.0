From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 14:38:22 +0000
Message-ID: <4F7EFFDE.3020003@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7EB9E4.4050205@acm.org> <4F7EC1F8.9030706@redhat.com> <4F7EEBFD.8000809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:46077 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2DFOi1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 10:38:27 -0400
In-Reply-To: <4F7EEBFD.8000809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

On 04/06/12 13:13, Tomas Henzl wrote:

> This means that after scsi_remove_host is left and the driver rmmoded

> we call scsi_host_put which in the end calls scsi_host_dev_release
> and this function tries to use the now invalid host_template
> functions again.
There are already several other ways in which the host template can be
accessed after scsi_remove_host() finished:
* Via the scsi_proc_hostdir_rm() call in scsi_host_dev_release().
* From the SCSI error handler thread.
* From inside scsi_dispatch_cmd().

Why isn't the SCSI error handler thread stopped from inside
scsi_remove_host() ? And why isn't scsi_proc_hostdir_rm() invoked from
inside scsi_remove_host() ? Am I missing something ?

Thanks,

Bart.
