From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] fc: ensure scan_work isn't active when
 freeing fc_rport
Date: Mon, 09 Jun 2014 11:09:43 -0700
Message-ID: <1402337383.5752.153.camel@vi-devel>
References: <1401461974-7879-1-git-send-email-nhorman@tuxdriver.com>
 <1401751370.5752.5.camel@vi-devel>
 <20140606205409.GD2543@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20140606205409.GD2543-B26myB8xz7F8NnZeBjwnZQMhkBWG/bsMQH7oEaQurus@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-06-06 at 16:54 -0400, Neil Horman wrote:
> On Mon, Jun 02, 2014 at 04:22:50PM -0700, Vasu Dev wrote:
> > On Fri, 2014-05-30 at 10:59 -0400, Neil Horman wrote:
> > > debugfs caught this:
> > > WARNING: at lib/debugobjects.c:260 debug_print_object+0x83/0xa0()
> > > ODEBUG: free active (active state 0) object type: work_struct
> > > hint: fc_scsi_scan_rport+0x0/0xd0 [scsi_transport_fc]
> > >  CPU: 1 PID: 184 Comm: kworker/1:1 Tainted: G        W
> > > --------------   3.10.0-123.el7.x86_64.debug #1
> > > Hardware name: HP ProLiant DL120 G7, BIOS J01 07/01/2013
> > > Workqueue: fc_wq_5 fc_rport_final_delete [scsi_transport_fc]
> > > Call Trace:
> > > [<ffffffff8169efec>] dump_stack+0x19/0x1b
> > > [<ffffffff8106cbd1>] warn_slowpath_common+0x61/0x80
> > > [<ffffffff8106cc4c>] warn_slowpath_fmt+0x5c/0x80
> > > [<ffffffff8133e003>] debug_print_object+0x83/0xa0
> > > [<ffffffffa04e2f40>] ? fc_parse_wwn+0x100/0x100
> > > 
> > > [<ffffffff8133f23b>] debug_check_no_obj_freed+0x22b/0x270
> > > [<ffffffffa04e127e>] ? fc_rport_dev_release+0x1e/0x30
> > > [<ffffffff811db3e9>] kfree+0xd9/0x2d0
> > > [<ffffffffa04e127e>] fc_rport_dev_release+0x1e/0x30
> > > [<ffffffff81428032>] device_release+0x32/0xa0
> > > [<ffffffff8132701e>] kobject_release+0x7e/0x1b0
> > > [<ffffffff81326ed8>] kobject_put+0x28/0x60
> > > [<ffffffff81428397>] put_device+0x17/0x20
> > > [<ffffffffa04e5025>] fc_rport_final_delete+0x165/0x210
> > > [<ffffffff810959b0>] process_one_work+0x220/0x710
> > > [<ffffffff81095944>] ? process_one_work+0x1b4/0x710
> > > [<ffffffff81095fbb>] worker_thread+0x11b/0x3a0
> > > [<ffffffff81095ea0>] ? process_one_work+0x710/0x710
> > > [<ffffffff8109e0cd>] kthread+0xed/0x100
> > > [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
> > > [<ffffffff816b2fec>] ret_from_fork+0x7c/0xb0
> > > [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
> > > 
> > > Seems to be because the scan_work work_struct might be active when the housing
> > > fc_rport struct gets freed.  Ensure that we cancel it prior to freeing the rport
> > > 
> > > Signed-off-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
> > > CC: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > CC: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > CC: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/scsi/scsi_transport_fc.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> > > index 4628fd5..5bd552c 100644
> > > --- a/drivers/scsi/scsi_transport_fc.c
> > > +++ b/drivers/scsi/scsi_transport_fc.c
> > > @@ -2548,6 +2548,7 @@ fc_rport_final_delete(struct work_struct *work)
> > >  			fc_flush_devloss(shost);
> > >  		if (!cancel_delayed_work(&rport->dev_loss_work))
> > >  			fc_flush_devloss(shost);
> > > +		cancel_work_sync(&rport->scan_work);
> > 
> > Make sense to ensure pending work canceled, adding James Smart for his
> > ACK as transport FC class author. 
> > 
> > 
> > Reviewed-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
> > 
> Ping on this, Something just occured to me.  I was thinking (perhaps
> erroneously) that this would go through the FCoE tree, but I don't see that
> you've setup a tree yet vasu (and Rob's has been idle for 6 months).  Whats the
> plan for this (and future) fcoe patchs.  Will you have a tree, or will we send
> this through Christophs new scsi tree perhaps?
> 

Thanks Neil for bringing this, I and Rob also had off list discussion on
this just last week. 

Given fcoe is quite mature now and its patches volume is very low, so
getting its kernel patches directly to scsi subsystem should work fine
and should be okay with James or Christophs to pull into scsi subsystem
directly once I've my non-author signoff ACK there as described in this
announcement at http://marc.info/?l=linux-scsi&m=140050839729415&w=2 

If no alternate suggestion or objection to this then I'll formally
announce this on fcoe mailing list.

However for any huges patches series bomb or RFCs, I'll request fcoe
developers to send patches against scsi tree at fcoe devel list first
and then if needed I can roll them up.

Thanks,
Vasu
