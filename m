From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [BUG] dm-mpath and scsi persistent reservation
Date: Tue, 21 Oct 2008 15:48:03 -0700
Message-ID: <1224629283.14830.838.camel@chandra-ubuntu>
References: <20081021231910.0fdbeb75@plop>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:58505 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYJUWtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2008 18:49:00 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9LMmih8028248
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 16:48:44 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9LMmxfj144704
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 16:48:59 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9LMmT25014704
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 16:48:30 -0600
In-Reply-To: <20081021231910.0fdbeb75@plop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, alasdair.kergon@redhat.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Christophe,

The SCSI Hardware handler is created for devices with special needs. It
is available in 2.6.27. One can be written for any device to translate
the scsi sense code to a different error code that the dm understands.
Is this something that coule help this situation ?

Have a look at drivers/scsi/device_handler directory.

Hope this helps,

chandra
On Tue, 2008-10-21 at 23:19 +0200, Christophe Varoqui wrote:
> Hi,
> 
> the dm-mpath multipathing driver enqueues write ios returned by
> the scsi layer with a "reservation conflict" error (on assymetric
> storage controllers, like Clariion, where queue_if_no_path is enabled).
> 
> This is wrong, and a potent data-corrupter : wio sent to a reserved
> scsi device should never be retried on this same device.
> 
> Can someone advise on a viable solution for this problem ? I
> understand the Device Mapper being a block remapper, it is not expected
> to receive scsi errors directly ... but maybe some kind of translation
> might be acceptable. Or is there hope in the request-based remapper ?
> 
> Jens, James, Alasdair, ... as maintainers of the involved subsystems,
> would you care to give some advise on the issue.
> 
> Regards,
> cvaroqui
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

