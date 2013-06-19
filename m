From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Wed, 19 Jun 2013 17:27:04 +0200
Message-ID: <51C1CDC8.4070103@acm.org>
References: <51C1B5CA.2030302@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:52156 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934891Ab3FSP1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 11:27:08 -0400
In-Reply-To: <51C1B5CA.2030302@profitbricks.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: David Dillow <dillowda@ornl.gov>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Roland Dreier <roland@kernel.org>

On 06/19/13 15:44, Jack Wang wrote:
>> +		/*
>> +		 * It can occur that after fast_io_fail_tmo expired and before
>> +		 * dev_loss_tmo expired that the SCSI error handler has
>> +		 * offlined one or more devices. scsi_target_unblock() doesn't
>> +		 * change the state of these devices into running, so do that
>> +		 * explicitly.
>> +		 */
>> +		spin_lock_irq(shost->host_lock);
>> +		__shost_for_each_device(sdev, shost)
>> +			if (sdev->sdev_state == SDEV_OFFLINE)
>> +				sdev->sdev_state = SDEV_RUNNING;
>> +		spin_unlock_irq(shost->host_lock);
>
> Do you have test case to verify this behaviour?

Hello Jack,

This is what I came up with after analyzing why a so-called "port 
flapping" test failed. The concept of that test is simple: use 
ibportstate to disable and reenable the proper IB port on the switch 
with random intervals and check whether I/O starts running again if the 
path remains operational long enough. When running such a test for a few 
days with random intervals between a few seconds and a few minutes 
sooner or later it will occur that scsi_try_host_reset() succeeds and 
that scsi_eh_test_devices() fails. That will cause the SCSI error 
handler to offline devices. Hence the above code to change the offline 
state into running after a reconnect succeeds. I'm not proud of that 
code but I couldn't find a better solution. Maybe the above code won't 
be necessary anymore once we switch to Hannes' new SCSI error handler.

Bart.
