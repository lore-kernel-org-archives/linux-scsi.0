From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: tcm_fc+ libfcoe regression on v3.7-rc2
Date: Wed, 31 Oct 2012 22:49:08 -0700
Message-ID: <1351748948.29493.40.camel@haakon2.linux-iscsi.org>
References: <1351294400.13631.22.camel@haakon2.linux-iscsi.org>
	 <138EA028228D124A900F5E6746F3C2162F5AC54A@ORSMSX102.amr.corp.intel.com>
	 <1351299908.13631.89.camel@haakon2.linux-iscsi.org>
	 <138EA028228D124A900F5E6746F3C2162F5AED8D@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <138EA028228D124A900F5E6746F3C2162F5AED8D@ORSMSX102.amr.corp.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: target-devel <target-devel@vger.kernel.org>, openfcoe-devel <devel@open-fcoe.org>, "Rustad, Mark D" <mark.d.rustad@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Vasu Dev <vasu.dev@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-10-31 at 23:08 +0000, Zou, Yi wrote:
> > On Fri, 2012-10-26 at 23:59 +0000, Zou, Yi wrote:
> >
> > <-- snip -->
> >
> > 
> > Mmmmm, not sure on this one.  There have definitely been changes in the
> > TCM active I/O shutdown codepath to support tcm_qla2xxx active I/O
> > shutdown starting in v3.5 code, so if pre v3.5 code is working as
> > expected it might very well be it.
> > 
> > I'm happy to have a look at this some point in the next week to try and
> > reproduce in vn2vn mode.
> > 
> > > Anyway, I would like to mimic your setup to see if I can reproduce it.
> > >
> > 
> > Sure, the latest target-pending/master HEAD should easily reproduce with
> > slub_debug=FPUZ.
> > 
> > Thanks Yi!
> > 
> > --nab
> > 
> Nick,
> 
> With help from Mark, the original issue I was seeing seems fixed by the following:
> 
> c0158ca workqueue: cancel_delayed_work() should return %false if work item is idle
> 
> which was causing refcnt on exchange being messed up. However there may be other
> issues but let me know if you are still hitting this on rc3.
> 

<nod>  Just verified with target-pending v3.7-rc2 + commit c0158ca and
slub poison overwritten warnings with tcm_fc(FCoE) I/O are gone.

Thanks Yi, MDR & Co!  :)

--nab
