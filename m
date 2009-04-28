From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Tue, 28 Apr 2009 17:15:47 +0000
Message-ID: <1240938947.3380.50.camel@mulgrave.int.hansenpartnership.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
	 <87ljpmk29b.fsf@basil.nowhere.org>
	 <20090428125705.48ef09e1@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760379AbZD1RQS@vger.kernel.org>
In-Reply-To: <20090428125705.48ef09e1@dhcp-100-2-144.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Styner, Douglas W" <douglas.w.styner@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-04-28 at 12:57 -0400, Chuck Ebbert wrote:
> On Mon, 27 Apr 2009 09:02:40 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > "Styner, Douglas W" <douglas.w.styner@intel.com> writes:
> > 
> > >
> > > ======oprofile 0.9.3 CPU_CLK_UNHALTED for top 30 functions
> > > Cycles% 2.6.24.2                   Cycles% 2.6.30-rc2
> > > 74.8578 <database>                   67.6966 <database>
> > 
> > The dip in database cycles is indeed worrying.
> > 
> > > 1.0500 qla24xx_start_scsi          1.1724 qla24xx_start_scsi
> > > 0.8089 schedule                    1.0578 qla24xx_intr_handler
> > > 0.5864 kmem_cache_alloc            0.8259 __schedule
> > > 0.4989 __blockdev_direct_IO        0.7451 kmem_cache_alloc
> > > 0.4357 __sigsetjmp                 0.4872 __blockdev_direct_IO
> > > 0.4152 copy_user_generic_string    0.4390 task_rq_lock
> > > 0.3953 qla24xx_intr_handler        0.4338 __sigsetjmp
> > 
> > And also why the qla24xx_intr_handler became ~2.5x as expensive.
> > Cc linux-scsi and qla24xx maintainers.
> > 
> 
> They are getting 31000 interrupts/sec vs. 22000/sec on older kernels.

Should be fixed by:

http://marc.info/?l=linux-scsi&m=124093712114937

If someone could verify, I'd be grateful.

Thanks,

James
