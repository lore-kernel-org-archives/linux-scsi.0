From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: oops with tcm_loop
Date: Mon, 10 Oct 2011 20:14:26 -0700
Message-ID: <1318302866.32435.309.camel@haakon2.linux-iscsi.org>
References: <j6hi8k$hg3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <j6hi8k$hg3$1@dough.gmane.org>
Sender: target-devel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-10-05 at 14:23 +0200, Paolo Bonzini wrote:
> When I do this:
> 

Hey Paolo,

> modprobe tcm_loop
> mount -t configfs configfs /sys/kernel/config/
> 
> cd /sys/kernel/config/target/core
> mkdir fileio_0
> mkdir fileio_0/fileio
> echo 'fd_dev_name='$HOME/test2.img',fd_dev_size=5368709120' > fileio_0/fileio/control
> echo 1 > fileio_0/fileio/enable
> 
> cd /sys/kernel/config/target
> mkdir -p loopback/naa.600140554cf3a18e/tpgt_1
> mkdir -p loopback/naa.600140554cf3a18e/tpgt_1/lun/lun_1
> cd loopback/naa.600140554cf3a18e/tpgt_1
> # "Obvious" error here: need to set up nexus before virtual_scsi_port!
> ln -sf ../../../core/fileio_0/fileio lun/lun_1/virtual_scsi_port
> echo naa.60014053226f0388 > nexus
> echo '- - -' > /sys/bus/tcm_loop_bus/drivers/tcm_loop/tcm_loop_adapter_0/host*/scsi_host/host*/scan
> 
> ... I get the following two OOPSes:
> 
> [  264.135309] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
> [  264.136279] IP: [<ffffffffa0510498>] transport_processing_thread+0x61b/0xc8b [target_core_mod]

<SNIP>

> 
> Reproduced with both 3.0.3 and 3.1.0-rc8.
> 

I've been able to track this down to an issue with the explict rescan
sending down scsi_cmnd->device->id == 0 values referencing an
tcm_loop_tpg endpoint from tcm_loop_hba->tl_hba_tpgs[] within
tcm_loop_queuecommand() that has not been configured.

The issue is not directly related to the ordering of the nexus vs.
Port/LUNs, and (unfortuately) can be triggered directly using the
explict rescan.  Anyways, I'm sending out a bugfix patch shortly, and
will make sure this is included in the v3.2-rc1 target patches w/ a Cc
to stable@kernel.org to ensure it's picked up by v3.1.1 and v3.0.5

Thanks alot for reporting!

--nab
