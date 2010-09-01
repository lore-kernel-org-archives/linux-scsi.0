From: Chris Leech <christopher.leech-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] scsi, fcoe,
 libfc: drop scsi host_lock use from fc_queuecommand
Date: Wed, 1 Sep 2010 15:45:03 -0700
Message-ID: <20100901224503.GB4089@cleech-lnx.jf.intel.com>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
	<1283298985.32007.530.camel@haakon2.linux-iscsi.org>
	<4C7DD3E8.9050700@cs.wisc.edu>
	<7C88852EF6F99F4EB538472FCFEBE222013AF95EB2@orsmsx509.amr.corp.intel.com>
	<1283371821.32007.636.camel@haakon2.linux-iscsi.org>
	<1283375187.30431.71.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1283375187.30431.71.camel-B2RhF0yJhE275v1z/vFq2g@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 01, 2010 at 02:06:26PM -0700, Vasu Dev wrote:
> > > It looks safe to me to call scsi_done() w/o host_lock held,
> > 
> > Hmmmm, this indeed this appears to be safe now..  For some reason I had
> > it in my head (and in TCM_Loop virtual SCSI LLD code as well) that
> > host_lock needed to be held while calling struct scsi_cmnd->scsi_done().
> > 
> > I assume this is some old age relic from the BLK days in the SCSI
> > completion path, and the subsequent conversion.  I still see a couple of
> > ancient drivers in drivers/scsi/ that are still doing this, but I
> > believe I stand corrected in that (all..?) of the modern in-use
> > drivers/scsi code is indeed *not* holding host_lock while calling struct
> > scsi_cmnd->scsi_done()..
> > 
> 
> fcoe/libfc moved to scsi_done w/o holding scsi host_lock a while ago
> around dec, 09 and it was done after discussion with Mathew and Chris
> Leech from fcoe side at that time, they may have more to comment on
> this.

There's not a whole lot to comment on.  Matthew Wilcox was helping me
look for opportunities to reduce our host_lock use, and said he didn't
think it was needed around scsi_done anymore.  It held up under testing,
so I submitted a patch.

	Chris
