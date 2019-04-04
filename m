From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [PATCH] usb: uas: fix usb subsystem hang after power off hub
 port
Date: Thu, 4 Apr 2019 15:33:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1904041522150.1288-100000@iolanthe.rowland.org>
References: <AE5419EAB4965843B3C0C1FE29F1FFE5891C86@JPYOKXMS103.jp.sony.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AE5419EAB4965843B3C0C1FE29F1FFE5891C86@JPYOKXMS103.jp.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kento.A.Kobayashi@sony.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Oliver Neukum <oneukum@suse.com>, gregkh@linuxfoundation.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Jacky.Cao@sony.com, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 4 Apr 2019 Kento.A.Kobayashi@sony.com wrote:

> Hi,
> 
> >> Root Cause
> >> - Block layer timeout happens after power off UAS USB device which is accessed as reproduce step. During timeout error handler process, scsi host state becomes SHOST_CANCEL_RECOVERY that causes IO hangs up and lock cannot be released. And in final, usb subsystem hangs up.
> >> Follow is function call:
> >> blk_mq_timeout_work 
> >>   …->scsi_times_out  (… means some functions are not listed before this function.)
> >>     …-> scsi_eh_scmd_add(scsi_host_set_state to SHOST_RECOVERY) 
> >>       … -> scsi_error_handler
> >>         …-> uas_eh_device_reset_handler
> >>             -> usb_lock_device_for_reset  <- take lock
> >>               -> usb_reset_device
> >>                 …-> rebind = uas_post_reset (return 1 since ENODEV) 
> >>                 …-> usb_unbind_and_rebind_marked_interfaces (rebind=1)
> >>                    …-> uas_disconnect  (scsi_host_set_state to SHOST_CANCEL_RECOVERY)
> >>                         … -> scsi_queue_rq
  >>                              -> scsi_host_queue_ready(return 0 causes IO hangs up.)
> >
> >How does scsi_queue_rq get called here?  As far as I can see, this shouldn't happen.
> 
> We confirmed the function call path on linux 4.9 when this problem occured since we are working on it. In linux 4.9, the last function is scsi_request_fn instead of scsi_queue_rq. In staging.git, we think the scsi_queue_rq is called by follow path.
> uas_disconnect
> |- scsi_remove_host
>  |- scsi_forget_host
>   |- __scsi_remove_device
>    |- device_del
>     |- bus_remove_device
>      |- device_release_driver
>       |- device_release_driver_internal
>        |- __device_release_driver
>         |- drv->remove(dev) (sd_remove)  
>          |- sd_shutdown
>           |- sd_sync_cache
>            |- scsi_execute
... (unnecessary internal details elided)
>                     |- blk_mq_dispatch_rq_list
>                      |- q->mq_ops->queue_rq (scsi_queue_rq)

So it looks as though the SCSI subsystem doesn't like to have a reset 
handler call scsi_remove_host.  Commands dispatched by the removal 
routines are forced to wait for the reset recovery to finish, which 
won't happen until those commands have been completed.

Is this a bug in the SCSI core?  If not, we need to know what is the
right way to do things when a reset handler detects that the SCSI host
has been hot-unplugged.

James, Martin, any suggestions?

Alan Stern
