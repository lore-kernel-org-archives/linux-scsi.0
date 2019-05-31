From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Fri, 31 May 2019 11:12:20 +0200
Message-ID: <dd00ef94-1d28-1401-2375-7603e9543e2d@redhat.com>
References: <20190530112811.3066-1-pbonzini@redhat.com>
 <20190530112811.3066-2-pbonzini@redhat.com>
 <ad0578b0-ce73-85ed-b67d-70c5d8176a23@acm.org>
 <461fe0cd-c5bc-a612-6013-7c002b92dcdc@redhat.com>
 <740d2f33-004e-7a37-1f6e-cf29480439b1@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <740d2f33-004e-7a37-1f6e-cf29480439b1@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 30/05/19 19:54, Bart Van Assche wrote:
> As far as I can see the only impact of defining an empty commit_rqs
> callback on the queueing behavior is that blk_mq_make_request() will
> queue requests for multiple hwqs on the plug list instead of requests
> for a single hwq. The plug list is sorted by hwq before it is submitted
> to a block driver. If that helps NVMe performance it should also help
> SCSI performance.

See the comment in blk_mq_make_request(): sorting by hwq helps NVMe
because it uses bd->last, and blk_mq_make_request() uses the presence of
the ->commit_rqs() as a sign that the driver uses bd->last.  The
heuristic basically trades latency (with plugging, the driver rings the
doorbell a bit later) for throughput (ringing the doorbell is slow, so
we want to do it less).  If the driver doesn't use bd->last and the
doorbell is always rung, plugging adds to the latency without the
throughput benefit.

All that the duplicate blk_mq_ops do is letting blk_mq_make_request()
use the same heuristic for SCSI.  This should be beneficial exactly for
the reason that you mention: if the heuristic helps non-SCSI block
driver performance, it should also help performance of SCSI drivers that
have nr_hw_queues > 1 but no commit_rqs (lpfc, qedi, qla2xxx, smartpqi,
storvsc).

Paolo

> How about always setting commit_rqs = scsi_commit_rqs
> in scsi_mq_ops?
