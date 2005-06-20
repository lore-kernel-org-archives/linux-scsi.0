From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC]: performance improvement by coalescing requests?
Date: Mon, 20 Jun 2005 17:01:06 -0400
Message-ID: <42B72E92.7050306@pobox.com>
References: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:52898 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261586AbVFTVBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 17:01:12 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Salyzyn, Mark wrote:
> This is not a patch to be applied to any release, for discussion only.
> 
> We have managed to increase the performance of the I/O to the driver by
> pushing back on the scsi_merge layer when we detect that we are issuing
> sequential requests (patch enclosed below to demonstrate the technique
> used to investigate). In the algorithm used, when we see that we have an
> I/O that adjoins the previous request, we reduce the queue depth to a
> value of 2 for the device. This allows the incoming I/O to be
> scrutinized by the scsi_merge layer for a bit longer permitting them to
> be merged together into a larger more efficient request.
> 
> By limiting the queue to a depth of two, we also do not delay the system
> much since we keep one worker and one outstanding remaining in the
> controller. This keeps the I/O's fed without delay.
> 
> The net result was instead of receiving, for example, 64 4K sequential
> I/O requests to an eager controller more than willing to accept the
> commands into it's domain, we instead see two 4K I/O requests, followed
> by one 248KB I/O request.

Since you have

./drivers/scsi/aacraid/linit.c: .use_clustering  = ENABLE_CLUSTERING,

this smells like a bug or scheduler issue.  The block layer should 
-already- be coalescing requests.

What happens when you change I/O schedulers?  That may be a source of 
problems too.

	Jeff


