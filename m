From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Fri, 06 Apr 2012 09:24:40 +0000
Message-ID: <4F7EB658.9060109@acm.org>
References: <4F7DA4F8.90104@redhat.com> <4F7DDDCC.1070506@acm.org> <4F7E0EBF.80407@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:49854 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2DFJYo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 05:24:44 -0400
In-Reply-To: <4F7E0EBF.80407@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Tomas Henzl <thenzl@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>

On 04/05/12 21:29, Mike Christie wrote:

> Tomas's bug occurs when drivers use scsi_scan_host, use the async scsi
> device scanning, and then rmmod the LLD while the scan is still in progress.
> 
> I think a general problem that we might hit similar to Tomas's issue is
> when scanning from userspace then rmmoding the driver. Maybe that means
> we need a more generic fix? Or, maybe that could be handled by having
> scsi_scan() do a try_module_get before scanning.

That suggestion certainly makes sense to me. But Tomas' approach has the
advantage that it guarantees that scanning will have finished once
scsi_remove_hosts() returned and hence has less potential for triggering
race conditions than an approach based on try_module_get().

Bart.
