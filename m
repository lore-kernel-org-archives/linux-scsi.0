From: "Zou, Yi" <yi.zou-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fcoe: Don't hold rtnl_mutex in
 fcoe_update_src_mac
Date: Wed, 14 Mar 2012 16:18:40 +0000
Message-ID: <138EA028228D124A900F5E6746F3C2160F6ADCFB@ORSMSX102.amr.corp.intel.com>
References: <bug-42918-11613@https.bugzilla.kernel.org>
 <20120313225254.5473.92174.stgit@localhost6.localdomain6>
 <4F5FE95D.8040408@intel.com> <4F5FFF19.1060601@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4F5FFF19.1060601-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "Fastabend, John R" <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> 
> On 3/13/2012 5:42 PM, Love, Robert W wrote:
> > On 03/13/2012 03:52 PM, Robert Love wrote:
> >> The rtnl_mutex was held to protect calls to dev_uc_add
> >> and dev_uc_del. Holding rtnl is not required as those
> >> functions make use of the netif_addr_lock* API to
> >> protect the MAC changing.
> >>
> >> This change fixes the following regression by removing
> >> the rtnl usage when fcoe_update_src_mac is called.
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=42918
> >>
> >> the existing dependency chain (in reverse order) is:
> >>
> >> ->  #1 (&fip->ctlr_mutex){+.+...}:
> >>         [<c1091f70>] lock_acquire+0x80/0x1b0
> >>         [<c147655d>] mutex_lock_nested+0x6d/0x340
> >>         [<f8970c32>] fcoe_ctlr_link_up+0x22/0x180 [libfcoe]
> >>         [<f894620e>] fcoe_create+0x47e/0x6e0 [fcoe]
> >>         [<f8973dd3>] fcoe_transport_create+0x143/0x250 [libfcoe]
> >>         [<c10527e0>] param_attr_store+0x30/0x60
> >>         [<c1052696>] module_attr_store+0x26/0x40
> >>         [<c11a201e>] sysfs_write_file+0xae/0x100
> >>         [<c11449df>] vfs_write+0x8f/0x160
> >>         [<c1144cbd>] sys_write+0x3d/0x70
> >>         [<c147a0c4>] syscall_call+0x7/0xb
> >>
> >> ->  #0 (rtnl_mutex){+.+.+.}:
> >>         [<c109164b>] __lock_acquire+0x140b/0x1720
> >>         [<c1091f70>] lock_acquire+0x80/0x1b0
> >>         [<c147655d>] mutex_lock_nested+0x6d/0x340
> >>         [<c13a10c4>] rtnl_lock+0x14/0x20
> >>         [<f89445ac>] fcoe_update_src_mac+0x2c/0xb0 [fcoe]
> >>         [<f8971712>] fcoe_ctlr_timer_work+0x712/0xb60 [libfcoe]
> >>         [<c104fb69>] process_one_work+0x179/0x5d0
> >>         [<c10502f1>] worker_thread+0x121/0x2d0
> >>         [<c10550ed>] kthread+0x7d/0x90
> >>         [<c1481a82>] kernel_thread_helper+0x6/0x10
> >>
> >> other info that might help us debug this:
> >>
> >>   Possible unsafe locking scenario:
> >>
> >>         CPU0                    CPU1
> >>         ----                    ----
> >>    lock(&fip->ctlr_mutex);
> >>                                 lock(rtnl_mutex);
> >>                                 lock(&fip->ctlr_mutex);
> >>    lock(rtnl_mutex);
> >>
> >>   *** DEADLOCK ***
> >>
> >> Signed-off-by: Robert Love<robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> ---
> >>   drivers/scsi/fcoe/fcoe.c |    2 --
> >>   1 files changed, 0 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> >> index e959960..85b8203 100644
> >> --- a/drivers/scsi/fcoe/fcoe.c
> >> +++ b/drivers/scsi/fcoe/fcoe.c
> >> @@ -539,13 +539,11 @@ static void fcoe_update_src_mac(struct fc_lport
> *lport, u8 *addr)
> >>   	struct fcoe_port *port = lport_priv(lport);
> >>   	struct fcoe_interface *fcoe = port->priv;
> >>
> >> -	rtnl_lock();
> >>   	if (!is_zero_ether_addr(port->data_src_addr))
> >>   		dev_uc_del(fcoe->netdev, port->data_src_addr);
> >>   	if (!is_zero_ether_addr(addr))
> >>   		dev_uc_add(fcoe->netdev, addr);
> >>   	memcpy(port->data_src_addr, addr, ETH_ALEN);
> >> -	rtnl_unlock();
> >>   }
> >>
> >>   /**
> >>
> > This isn't going to work. We do need rtnl_lock when calling
> > dev_uc_add/del to ensure the driver isn't removed while making the
> > change. I have an alternative patch that I'll post as soon as I clean
> it
> > up a bit.
> >
> > Nacked-by: Robert Love <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> So there is a case you don't have a ref cnt on the netdev here?
> 
> I guess my point is if your carrying around a ptr to the struct why
> haven't you incremented the refcnt. I think the dev_hold() in the
> create path would be enough to stop the above concern.
> 
> Thanks,
> John
I agree, dev_put() is only called until after fcoe ctlr is destroyed, 
which does delete the fip timer as well as cancel_work_sync the fip 
timeout work already, so this patch should be good.

yi

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
