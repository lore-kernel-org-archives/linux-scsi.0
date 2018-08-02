From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: libfc mutex under RCU read section error since
 "libfc: Fixup disc_mutex handling"
Date: Wed, 1 Aug 2018 18:09:00 -0700
Message-ID: <20180802010900.GA2222132@straylight.hirudinean.org>
References: <20180731175607.GA1237244@straylight.hirudinean.org>
 <e3bd6958-ca17-bc75-2a66-29d7d2a38ebf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e3bd6958-ca17-bc75-2a66-29d7d2a38ebf-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 01, 2018 at 08:29:00AM +0200, Hannes Reinecke wrote:
> On 07/31/2018 07:56 PM, Chris Leech wrote:
> > The libfc and libfcoe modules look to have issues with mutexs being used
> > under rcu_read_lock, which triggers "Illegal context switch in RCU read
> > side critical section" warnings under debug kernels.
> > 
> > I started looking at fc_disc.c where rport discovery code appears to
> > take a mutex for each rport in fc_rport_login/fc_rport_logoff while
> > being called under rcu_read_lock from fc_disc_done.
> > 
> > With the rdata->kref held, I know rcu_read_unlock can be safely called
> > before login fc_rport_login/logoff.  But I don't know if it's safe to
> > then recall rcu_read_lock and simply continue on with the
> > list_for_each_entry_rcu or not.
> > 
> > And as I start looking into this one case, I also get the same class of
> > problem popping up in at least libfcoe:fcoe_ctrl.c from
> > fcoe_ctrl_timer_work as well :(
> > 
> This should've been fixed by my patch series "libfc/fcoe: disc_mutex fixes".
> 
> Can you check if this series is applied in your tree?

Thanks, I missed those and they do fix things up!

One question about "Add WARN_ON() when deleting rports"

>	--- a/drivers/scsi/libfc/fc_rport.c
>	+++ b/drivers/scsi/libfc/fc_rport.c
>	@@ -184,6 +184,7 @@ void fc_rport_destroy(struct kref *kref)
>		struct fc_rport_priv *rdata;
>	 
>		rdata = container_of(kref, struct fc_rport_priv, kref);
>	+	WARN_ON(!list_empty(&rdata->peers));
>		kfree_rcu(rdata, rcu);
>	 }
>	 EXPORT_SYMBOL(fc_rport_destroy);

The list_head isn't reinitialized to make list_empty() return true after
list_del_rcu(), as there may still be readers traversing the list.

So doesn't this warning trigger on every deleted rport?

Thanks!
- Chris
