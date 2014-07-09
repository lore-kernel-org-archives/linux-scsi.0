From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/14] scsi: only maintain target_blocked if the driver
	has a target queue limit
Date: Wed, 9 Jul 2014 17:05:48 +0200
Message-ID: <20140709150548.GB25257@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-11-git-send-email-hch@lst.de> <53BD254D.4000806@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53BD254D.4000806@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 09, 2014 at 01:19:41PM +0200, Hannes Reinecke wrote:
>>    host_not_ready:
>> -	atomic_dec(&scsi_target(sdev)->target_busy);
>> +	if (scsi_target(sdev)->can_queue > 0)
>> +		atomic_dec(&scsi_target(sdev)->target_busy);
>>    not_ready:
>>   	/*
>>   	 * lock q, handle tag, requeue req, and decrement device_busy. We
>>
> Hmm. 'can_queue' can be changed by the LLDD. Don't we need some sort of 
> synchronization here?

While a few drivers change the host can_queue value at runtime none
do for the target.  While I don't think driver should even change the
host one even modification to the target one is perfectly fine as long
as no driver drops it to zero.
