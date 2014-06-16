From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [Open-FCoE] [PATCH] fc: ensure scan_work isn't active when
 freeing fc_rport
Date: Mon, 16 Jun 2014 07:15:43 -0400
Message-ID: <20140616111543.GB15165@hmsreliant.think-freely.org>
References: <1401461974-7879-1-git-send-email-nhorman@tuxdriver.com>
 <1401751370.5752.5.camel@vi-devel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57006 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaFPLPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jun 2014 07:15:53 -0400
Content-Disposition: inline
In-Reply-To: <1401751370.5752.5.camel@vi-devel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, james.smart@emulex.com

On Mon, Jun 02, 2014 at 04:22:50PM -0700, Vasu Dev wrote:
> On Fri, 2014-05-30 at 10:59 -0400, Neil Horman wrote:
> > debugfs caught this:
> > WARNING: at lib/debugobjects.c:260 debug_print_object+0x83/0xa0()
> > ODEBUG: free active (active state 0) object type: work_struct
> > hint: fc_scsi_scan_rport+0x0/0xd0 [scsi_transport_fc]
> >  CPU: 1 PID: 184 Comm: kworker/1:1 Tainted: G        W
> > --------------   3.10.0-123.el7.x86_64.debug #1
> > Hardware name: HP ProLiant DL120 G7, BIOS J01 07/01/2013
> > Workqueue: fc_wq_5 fc_rport_final_delete [scsi_transport_fc]
> > Call Trace:
> > [<ffffffff8169efec>] dump_stack+0x19/0x1b
> > [<ffffffff8106cbd1>] warn_slowpath_common+0x61/0x80
> > [<ffffffff8106cc4c>] warn_slowpath_fmt+0x5c/0x80
> > [<ffffffff8133e003>] debug_print_object+0x83/0xa0
> > [<ffffffffa04e2f40>] ? fc_parse_wwn+0x100/0x100
> > 
> > [<ffffffff8133f23b>] debug_check_no_obj_freed+0x22b/0x270
> > [<ffffffffa04e127e>] ? fc_rport_dev_release+0x1e/0x30
> > [<ffffffff811db3e9>] kfree+0xd9/0x2d0
> > [<ffffffffa04e127e>] fc_rport_dev_release+0x1e/0x30
> > [<ffffffff81428032>] device_release+0x32/0xa0
> > [<ffffffff8132701e>] kobject_release+0x7e/0x1b0
> > [<ffffffff81326ed8>] kobject_put+0x28/0x60
> > [<ffffffff81428397>] put_device+0x17/0x20
> > [<ffffffffa04e5025>] fc_rport_final_delete+0x165/0x210
> > [<ffffffff810959b0>] process_one_work+0x220/0x710
> > [<ffffffff81095944>] ? process_one_work+0x1b4/0x710
> > [<ffffffff81095fbb>] worker_thread+0x11b/0x3a0
> > [<ffffffff81095ea0>] ? process_one_work+0x710/0x710
> > [<ffffffff8109e0cd>] kthread+0xed/0x100
> > [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
> > [<ffffffff816b2fec>] ret_from_fork+0x7c/0xb0
> > [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
> > 
> > Seems to be because the scan_work work_struct might be active when the housing
> > fc_rport struct gets freed.  Ensure that we cancel it prior to freeing the rport
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: linux-scsi@vger.kernel.org
> > CC: Robert Love <robert.w.love@intel.com>
> > CC: Vasu Dev <vasu.dev@intel.com>
> > ---
> >  drivers/scsi/scsi_transport_fc.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> > index 4628fd5..5bd552c 100644
> > --- a/drivers/scsi/scsi_transport_fc.c
> > +++ b/drivers/scsi/scsi_transport_fc.c
> > @@ -2548,6 +2548,7 @@ fc_rport_final_delete(struct work_struct *work)
> >  			fc_flush_devloss(shost);
> >  		if (!cancel_delayed_work(&rport->dev_loss_work))
> >  			fc_flush_devloss(shost);
> > +		cancel_work_sync(&rport->scan_work);
> 
> Make sense to ensure pending work canceled, adding James Smart for his
> ACK as transport FC class author. 
> 
> 
> Reviewed-by: Vasu Dev <vasu.dev@intel.com> 
> 
> 
> >  		spin_lock_irqsave(shost->host_lock, flags);
> >  		rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
> >  	}
> 
> 
> 
Ping James, I beleve Christoph is still waiting on a review from you here.

Neil

