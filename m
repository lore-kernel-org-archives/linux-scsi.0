From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 0/2] target: Add TFO->complete_irq queue_work bypass
Date: Wed, 10 Jun 2015 00:10:46 -0700
Message-ID: <1433920246.7916.121.camel@haakon3.risingtidesystems.com>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>
	 <20150603125756.GA19696@lst.de>
	 <1433401569.18125.112.camel@haakon3.risingtidesystems.com>
	 <20150609071921.GA10590@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150609071921.GA10590@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-06-09 at 09:19 +0200, Christoph Hellwig wrote:
> On Thu, Jun 04, 2015 at 12:06:09AM -0700, Nicholas A. Bellinger wrote:
> > So I've been using tcm_loop + RAMDISK backends for prototyping, but this
> > patch is intended for vhost-scsi so it can avoid the unnecessary
> > queue_work() context switch within target_complete_cmd() for all backend
> > driver types.
> > 
> > This is because vhost_work_queue() is just updating vhost_dev->work_list
> > and immediately wake_up_process() into a different vhost_worker()
> > process context.  For heavy small block workloads into fast IBLOCK
> > backends, avoiding this extra context switch should be a nice efficiency
> > win.
> 
> How about trying to merge the two workers instead?
> 

IIRC, vhost.c has a existing requirement for running completions within
a single kernel thread context for each vhost_dev context -> vhost-scsi
WWPN.

> > Perhaps tcm_loop LLD code should just be limited to RAMDISK here..?
> 
> I'd prefer to not do it especially for the loopback code, as that
> should serve as a simple example.

Fair enough.

> But before making further judgement I'd really like to see the numbers.
> 

Sure, will include some performance + context switch results for -v2.

> Note that something that might help much more is getting rid of
> the remaining irq or bh disabling spinlocks in the target core,
> as that tends to introduce a lot of additional latency.  Moving
> additional code to hardirq context is fairly diametrical to that
> design.

Within for-next RCU enabled target code, the three spinlocks who irq
disable from fast-path submit + completion path are:

* se_cmd->t_state_lock:

Used to update se_cmd->transport_state within target_complete_cmd() from
backend driver irq context, and when passing se_cmd ownership back to
fabric driver code via fast-path transport_cmd_check_stop() response
completion.

Still required while iblock backends are calling target_complete_cmd()
from irq context.
  
* se_device->execute_task_lock

Used for tracking device TMR tasks.  Completion path called from irq 
context in transport_cmd_check_stop() -> target_remove_from_state_list()
when passing se_cmd ownership back to fabric driver.

transport_generic_free_cmd() needs to obtain this lock during se_cmd
exception status too, if the failure occurs before se_cmd->execute_cmd()
submission happens.

* se_session->sess_cmd_lock

Originally required for tcm_qla2xxx, where qla_hw_data->hardware_lock
must be held while performing the initial per se_session shutdown of
outstanding + active se_cmd_list entries.  Other HW LLD fabric drivers
also need this when target-core is responsible for active I/O
shutdown.  

However, not all fabric drivers need to disable irq while acquiring this
specific lock.
