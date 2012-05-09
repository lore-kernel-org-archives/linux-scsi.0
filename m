From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Add missing call to qlt_fc_port_deleted()
Date: Wed, 09 May 2012 13:48:56 -0700
Message-ID: <1336596536.31443.154.camel@haakon2.linux-iscsi.org>
References: <1336585861-23603-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1336585861-23603-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Arun Easi <arun.easi@qlogic.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-05-09 at 10:51 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> qla2x00_schedule_rport_del() calls fc_remote_port_delete(), which
> starts a timer to tear down an rport structure.  We need a call to
> qlt_fc_port_deleted() here.  Otherwise, if the FC transport timer
> expires and tears down the rport, the initiator will be logged out and
> the target code's notion of what sessions it has will get out of sync
> with the rest of the driver and the firmware.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 11d41c7..a43ebce 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -2879,8 +2879,10 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
>  		spin_unlock_irqrestore(vha->host->host_lock, flags);
>  		set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
>  		qla2xxx_wake_dpc(base_vha);
> -	} else
> +	} else {
>  		fc_remote_port_delete(rport);
> +		qlt_fc_port_deleted(vha, fcport);
> +	}
>  }
>  
>  /*

Really nice catch here Roland...

This might end up explaining one of the issues encountered on 3.4-rc1
code with qla83xx HW on physical link failure, namely the
'Kobject crash during libfc rport reset' bug that was originally looking
like:

<6>[  770.597133] qla_target(0): session for wwn 21:00:00:24:ff:31:4c:4c (loop_id 0, s_id 0:0:e8, confirmed completd
<6>[  771.236397] qla_target(0): session for port 21:00:00:24:ff:31:4c:4d (loop ID 0) scheduled for deletion in 35 0
<6>[  771.251959] qla_target(0): local session for port 21:00:00:24:ff:31:4c:4d (loop ID 0) reappeared
<6>[  771.261750] qla_target(0): local session for port 21:00:00:24:ff:31:4c:4d (loop ID 0) became global
<6>[  771.744503] qla_target(0): local session for wwn 21:00:00:24:ff:31:4c:4d (loop_id 0, s_id 0:0:e8, confirmed cd
[0]more>
<6>[ 4142.288765] qla_target(0): session for port 21:00:00:24:ff:31:4c:4d (loop ID 0) scheduled for deletion in 35 0
<6>[ 4142.288775] qla_target(0): session for port 21:00:00:24:ff:31:4c:4c (loop ID 0) scheduled for deletion in 35 0
<4>[ 4142.291760] qla_target(0): Link failure detected
<4>[ 4142.322792] qla_target(0): Link failure detected
<3>[ 4172.300187]  rport-9:0-1: blocked FC remote port time out: removing rport
<3>[ 4172.302114]  rport-8:0-1: blocked FC remote port time out: removing rport
<6>[ 4259.079198] qla_target(0): session for wwn 21:00:00:24:ff:31:4c:4c (loop_id 0, s_id 0:0:ef, confirmed completd
<6>[ 4260.589361] qla_target(0): local session for wwn 21:00:00:24:ff:31:4c:4d (loop_id 0, s_id 0:0:e8, confirmed cd
<1>[ 4260.986975] BUG: unable to handle kernel NULL pointer dereference at           (null)
<1>[ 4260.995721] IP: [<ffffffff81190e7c>] kobject_get_path+0x7a/0xe8
<4>[ 4261.002327] PGD 0
<4>[ 4261.004574] Oops: 0000 [#1] SMP
[0]kdb> bt
Stack traceback for pid 3268
0xffff88025d8563e0     3268        2  1    0   R  0xffff88025d856750 *qla2xxx_8_dpc
<c> ffff8802640099e0<c> 0000000000000018<c> ffff880264009a10<c> 00000000fffffffe<c>
<c> ffff880255994038<c> ffff88025bcdc000<c> ffff880266431d20<c> ffffffff8142f010<c>
<c> ffff880264009ab0<c> ffffffff81191539<c> ffff880264009a80<c> ffffffff8111d0de<c>
Call Trace:
 [<ffffffff81191539>] ? kobject_uevent_env+0x1b0/0x54b
 [<ffffffff8111d0de>] ? internal_create_group+0x53/0x172
 [<ffffffff811918df>] ? kobject_uevent+0xb/0xd
 [<ffffffff8122f3ba>] ? device_add+0x47e/0x608
 [<ffffffff8122dc27>] ? get_device+0x14/0x1a
 [<ffffffff81234646>] ? transport_remove_classdev+0x57/0x57
 [<ffffffff81234115>] ? attribute_container_add_class_device+0x11/0x22
 [<ffffffff8123465b>] ? transport_add_class_device+0x15/0x31
 [<ffffffff81234202>] ? attribute_container_device_trigger+0x6f/0xa9
 [<ffffffff812345ed>] ? transport_add_device+0x10/0x12
 [<ffffffffa001104d>] ? fc_remote_port_add+0x63e/0x734 [scsi_transport_fc]
 [<ffffffffa038e826>] ? qla2x00_update_fcport+0x25f/0x351 [qla2xxx]
 [<ffffffff810bd426>] ? kmem_cache_alloc+0x39/0xb3
 [<ffffffffa038f2a9>] ? qla2x00_configure_loop+0x7b2/0x1415 [qla2xxx]
 [<ffffffffa039da9a>] ? __qla2x00_marker+0xf2/0x103 [qla2xxx]
 [<ffffffffa039029a>] ? qla2x00_loop_resync+0x9c/0x105 [qla2xxx]
[0]more>
Only 'q' or 'Q' are processed at more prompt, input ignored
 [<ffffffffa038b921>] ? qla2x00_do_dpc+0x42d/0x529 [qla2xxx]
 [<ffffffffa038b4f4>] ? qla2x00_do_work+0x1eb/0x1eb [qla2xxx]
 [<ffffffffa038b4f4>] ? qla2x00_do_work+0x1eb/0x1eb [qla2xxx]
 [<ffffffff81041337>] ? kthread+0x84/0x8c
 [<ffffffff81369024>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810412b3>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81369020>] ? gs_change+0x13/0x13


AFAICT the kobject oops triggered here via qla2x00_update_fcport() ->
fc_remote_port_add() would seem to be the manifestation of the missing
call to qlt_fc_port_deleted() you're fixing here, and not a qla83xx
specific issue..

Have you seen something similar with your testing ahead of this
bugfix..?

--nab
