From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC] How to fix an async scan - rmmod race?
Date: Thu, 05 Apr 2012 18:00:44 +0000
Message-ID: <4F7DDDCC.1070506@acm.org>
References: <4F7DA4F8.90104@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:48514 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab2DESAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Apr 2012 14:00:51 -0400
In-Reply-To: <4F7DA4F8.90104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, michaelc@cs.wisc.edu

On 04/05/12 13:58, Tomas Henzl wrote:

> When a rmmod is tried then in some cases the kernel is not able to handle a paging request:
> [  727.154296] BUG: unable to handle kernel paging request at ffffffffa01874b8
> From what I observerved it happens when when we call the rmmod only a while after a modprobe
> (in this case it is the mpt2sas driver). More accurately said, it happens when rmmod is called
> while scsi async is still at work. The driver is removed but the scsi_host_template is still filled
> with now invalid pointers, in this case it is most likely the hostt->scan_finished which causes the BUG.


Are you sure the above analysis is correct ? I've triggered several
million device removal events with ib_srp but I haven't ever seen the
above crash. Maybe your patch for the SCSI core is hiding a race in the
mpt2sas device removal code.

Bart.
