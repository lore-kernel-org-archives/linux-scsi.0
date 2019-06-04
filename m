From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Tue, 4 Jun 2019 15:40:18 -0700
Message-ID: <c175c8ae-2cec-6423-5cda-b1abcc4b42e5@acm.org>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190530112811.3066-2-pbonzini@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 5/30/19 4:28 AM, Paolo Bonzini wrote:
> This allows a list of requests to be issued, with the LLD only writing
> the hardware doorbell when necessary, after the last request was prepared.
> This is more efficient if we have lists of requests to issue, particularly
> on virtualized hardware, where writing the doorbell is more expensive than
> on real hardware.
> 
> The use case for this is plugged IO, where blk-mq flushes a batch of
> requests all at once.
> 
> The API is the same as for blk-mq, just with blk-mq concepts tweaked to
> fit the SCSI subsystem API: the "last" flag in blk_mq_queue_data becomes
> a flag in scsi_cmnd, while the queue_num in the commit_rqs callback is
> extracted from the hctx and passed as a parameter.
> 
> The only complication is that blk-mq uses different plugging heuristics
> depending on whether commit_rqs is present or not.  So we have two
> different sets of blk_mq_ops and pick one depending on whether the
> scsi_host template uses commit_rqs or not.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
