From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Thu, 05 Apr 2012 11:05:34 -0500
Message-ID: <4F7DC2CE.3040608@cs.wisc.edu>
References: <4F7DA4F8.90104@redhat.com> <4F7DC0D2.6070301@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33789 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab2DEQFn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2012 12:05:43 -0400
In-Reply-To: <4F7DC0D2.6070301@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/05/2012 10:57 AM, Mike Christie wrote:
> The only problem I could think of is if the scan_finished times out,
> then do_scsi_scan_host will return and do_scan_async will call
> scsi_finish_async_scan and scsi_remove_host will continue to run.
> However, if scsi_scan.c was still running something like the sequential
> scan/report luns scanning code or if the scsi eh was running and that is

Ignore the eh comment. The ehhandler is stopped in scsi_host_dev_release.

> what caused the scan_finished to timeout then that could be accessing
> the scsi_host_template and other structs.
> 
> I did not look at all the scan_finished callouts to see what they do.

I looked at the iscsi and fc classes and they should be ok.
