From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Thu, 13 Dec 2012 16:22:33 +0100
Message-ID: <50C9F2B9.4050500@acm.org>
References: <20121211000013.GI23107@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:47703 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2LMPWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2012 10:22:38 -0500
In-Reply-To: <20121211000013.GI23107@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On 12/11/12 01:00, scameron@beardog.cce.hp.com wrote:
> The driver, like nvme, has a submit and reply queue per cpu.

This is interesting. If my interpretation of the POSIX spec is correct 
then aio_write() allows to queue overlapping writes and all writes 
submitted by the same thread have to be performed in the order they were 
submitted by that thread. What if a thread submits a first write via 
aio_write(), gets rescheduled on another CPU and submits a second 
overlapping write also via aio_write() ? If a block driver uses one 
queue per CPU, does that mean that such writes that were issued in order 
can be executed in a different order by the driver and/or hardware than 
the order in which the writes were submitted ?

See also the aio_write() man page, The Open Group Base Specifications 
Issue 7, IEEE Std 1003.1-2008 
(http://pubs.opengroup.org/onlinepubs/9699919799/functions/aio_write.html).

Bart.

