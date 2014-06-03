From: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] bnx2fc: Improve stats update mechanism
Date: Tue, 3 Jun 2014 10:15:43 -0700
Message-ID: <1401815743.3956.39.camel@lbirv-waie-lx2.broadcom.com>
References: <1401462115-8072-1-git-send-email-nhorman@tuxdriver.com>
 <1401487183.3956.28.camel@lbirv-waie-lx2.broadcom.com>
 <20140531024754.GB27184@localhost.localdomain>
 <DBC33EB2-5AB1-4DFC-B7DE-EAAC47C0E978@broadcom.com>
 <20140531123757.GA27590@localhost.localdomain>
 <20140603145417.GC20038@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20140603145417.GC20038-B26myB8xz7F8NnZeBjwnZQMhkBWG/bsMQH7oEaQurus@public.gmane.org>
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
Cc: "fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-06-03 at 10:54 -0400, Neil Horman wrote:
> On Sat, May 31, 2014 at 08:37:57AM -0400, Neil Horman wrote:
> > On Sat, May 31, 2014 at 05:13:11AM +0000, Eddie Wai wrote:
> > > 
> > > 
> > > On May 30, 2014, at 7:48 PM, "Neil Horman" <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org> wrote:
> > > 
> > > > On Fri, May 30, 2014 at 02:59:43PM -0700, Eddie Wai wrote:
> > > >> Thanks for fixing this.  The patch generally looks good, but I do have a
> > > >> few comments.
> > > >> 
> > > >> On Fri, 2014-05-30 at 11:01 -0400, Neil Horman wrote:
> > > >>> Recently had this warning reported:
> > > >>> 
> > > >>> [  290.489047] Call Trace:
> > > >>> [  290.489053]  [<ffffffff8169efec>] dump_stack+0x19/0x1b
> > > >>> [  290.489055]  [<ffffffff810ac7a9>] __might_sleep+0x179/0x230
> > > >>> [  290.489057]  [<ffffffff816a4ad5>] mutex_lock_nested+0x55/0x520
> > > >>> [  290.489061]  [<ffffffffa01b9905>] ? bnx2fc_l2_rcv_thread+0xc5/0x4c0 [bnx2fc]
> > > >>> [  290.489065]  [<ffffffffa0174c1a>] fc_vport_id_lookup+0x3a/0xa0 [libfc]
> > > >>> [  290.489068]  [<ffffffffa01b9a6c>] bnx2fc_l2_rcv_thread+0x22c/0x4c0 [bnx2fc]
> > > >>> [  290.489070]  [<ffffffffa01b9840>] ? bnx2fc_vport_destroy+0x110/0x110 [bnx2fc]
> > > >>> [  290.489073]  [<ffffffff8109e0cd>] kthread+0xed/0x100
> > > >>> [  290.489075]  [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
> > > >>> [  290.489077]  [<ffffffff816b2fec>] ret_from_fork+0x7c/0xb0
> > > >>> [  290.489078]  [<ffffffff8109dfe0>] ? insert_kthread_work+0x80/0x80
> > > >>> 
> > > >>> Its due to the fact that we call a potentially sleeping function from the bnx2fc
> > > >>> rcv path with preemption disabled (via the get_cpu call embedded in the per-cpu
> > > >>> variable stats lookup in bnx2fc_l2_rcv_thread.
> > > >>> 
> > > >>> Easy enough fix, we can just move the stats collection later in the function
> > > >>> where we are sure we won't preempt or sleep.  This also allows us to not have to
> > > >>> enable pre-emption when doing a per-cpu lookup, since we're certain not to get
> > > >> You mean this allows us to not have to 'disable' pre-emption, right? 
> > > >> 
> > > >> Can you elaborate on how we can be sure that we won't get preempted
> > > >> immediately after retrieving the CPU variable?  I would think it'll be
> > > >> okay to call get_cpu at this stage as there won't be any sleepable mutex
> > > >> lock calls before the put_cpu.
> > > > We can't be sure, but I would assert it doesn't really matter at this point.
> > > > The area in which we update stats is so small that, even if we do hit the
> > > > unlikely chance that we get pre-empted, and then rescheduled on a different cpu,
> > > > it won't matter.  We could add the get_cpu/put_cpu back if you're really intent
> > > > on it, but I'm not sure its worthwhile given that this is a hot path.
> > > I agree with your assessment.  But code wise just so bnx2fc is consistent to the software FCoE counterpart, I would advice to use the same get_cpu to retrieve that stats CPU variable.  Thanks.
> > 
> > Actually I woke up this morning meaning to send a follow on note addressing
> > that.  The Soft FCoE counterpart to this function acutally works the way bnx2fc
> > reception does after my patch here.  Thats because the stats are updated with
> > the cpu held, but the frame is actually received by the fc layer immediately
> > after cpu_put is called.  The implication is that the task can get preempted
> > right after we update the stats and re-enable preemption, meaning that we may
> > actually receive the frame on a different cpu than the cpu we updated the stats
> > on.  I was planning on sending a patch to switch get_cpu/put_cpu in the soft
> > FCoE code to just use smp_processor_id(), since it doesn't help anything.
> > 
> > bnx2fc is actually in a slightly better position than soft FCoE.  soft FCoE
> > creates a thread for each cpu, but doesn't explicitly assign single cpu affinity
> > for each task, meaning per-cpu stats are actually relevant.  For bnx2fc, you
> > only create a single task at module init, meaning there is no parallel reception
> > of frames.  As such the per-cpu tasks are really more of an aggregate measure
> > (since the stat updates are all serialized anyway by the single thread accross
> > cpus).
That's correct.  bnx2fc uses only a single thread for this L2 recv path
because fast path traffic normally goes to the offload path.
> > 
> > The bottom line is that you can't hold a cpu while both doing the work of frame
> > reception and updating statistics, unless you want to avoid sleeping functions
> > in the entire receive path, and once you separate the two by only holding the
> > cpu during stats update, you run the risk of changing the cpu after you've
> > processed the frame, but before you dereference the per_cpu pointer.
> > 
> > I can still re-add the get_cpu/put_cpu if you want, but I really don't see the
> > purpose of the extra overhead given the above, and my intention is to remove it
> > from the soft FCoE code as well.
Nah, just as long as we are consistent, that's good enough for me!
Thanks.
> > 
> > Regards
> > Neil
> > 
> Can I get further comment or an ACK on this so the fcoe tree can pull it in?
Acked-by:  Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Thanks!
> Neil
> 
> > _______________________________________________
> > fcoe-devel mailing list
> > fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
> > http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel
> > 
