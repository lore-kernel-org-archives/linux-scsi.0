From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/3] Enabling ATA Command Priorities
Date: Wed, 19 Oct 2016 14:38:45 -0400
Message-ID: <20161019183845.GL18532@htj.duckdns.org>
References: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>
Cc: axboe@kernel.dk, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 17, 2016 at 11:27:27AM -0700, Adam Manzanares wrote:
> This patch builds ATA commands with high priority if the iocontext of a process
> is set to real time. The goal of the patch is to improve tail latencies of 
> workloads that use higher queue depths. This requires setting the iocontext 
> ioprio on the request when it is initialized
> 
> This patch has been tested with an Ultrastar HE8 HDD and cuts the 
> the p99.99 tail latency of foreground IO from 2s down to 72ms when
> using the deadline scheduler. This patch works independently of the
> scheduler so it can be used with all of the currently available 
> request based schedulers. 
> 
> Foreground IO, for the previously described results, is an async fio job 
> submitting 4K read requests at a QD of 1 to the HDD. The foreground IO is set 
> with the iopriority class of real time. The background workload is another fio
> job submitting read requests at a QD of 32 to the same HDD with default 
> iopriority.
> 
> This feature is enabled for ATA devices by setting the ata ncq_prio_on device 
> attribute to 1. An ATA device is also checked to see if the device supports per
> command priority.

Applied 1-3 to libata/for-4.10 w/ some modifications.

Thanks.

-- 
tejun
