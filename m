From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct
	Scsi_Host->cmd_serial_number to atomic_t
Date: Mon, 27 Sep 2010 16:02:28 -0700
Message-ID: <1285628548.8880.64.camel@haakon2.linux-iscsi.org>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org>
	 <4C93BB8E.2080501@cisco.com> <4C9427B6.9050404@cs.wisc.edu>
	 <1284839878.13344.300.camel@haakon2.linux-iscsi.org>
	 <20100927140551.GB8473@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100927140551.GB8473@schmichrtp.mainz.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Joe Eykholt <jeykholt@cisco.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-09-27 at 16:05 +0200, Christof Schmitt wrote:
> On Sat, Sep 18, 2010 at 12:57:58PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2010-09-17 at 21:45 -0500, Mike Christie wrote:
> > > On 09/17/2010 02:03 PM, Joe Eykholt wrote:
> > > >
> > > > How about instead of adding use_serial_number, let's just have the
> > > > drivers that want a serial number call scsi_cmd_get_serial()
> > > 
> > > I think this sounds better.
> > > 
> > 
> > In that case I will go ahead and add explict scsi_cmd_get_serial() calls
> > to the LLDs that use struct scsi_cmnd->serial_number in anything beyond
> > an obvious and simple informational purpose.
> > 
> > > You could also convert drivers to the host tagging if you needed a 
> > > unique id for each command sent to a host.
> > 
> > Hmmm, what does this entail again..?
> > 
> > > 
> > > > and stop calling it from scsi_dispatch_cmd()?   AFAICT, it's only
> > > > used in debug messages in some drivers.  I didn't find other usages
> > > > but didn't do an exhaustive search.
> > > 
> > > The comments for serial_number say that it is only supposed to be used 
> > > for debugging printks and most drivers use it for that.
> > 
> > So I would suppose it would be OK for those drivers to continue to
> > printk serial_number to show the internal serial_number allocation is
> > now disabled by default.
> > 

<SNIP>

> > > 
> > > zfcp looks like it copies it. It does not look like the driver needs it.
> > > 
> > 
> > Ok, I will look at removing it's usage in zfcp or if necessary add an
> > the explict scsi_cmd_get_serial() call.
> 
> In zfcp, the serial_number is only accessed for writing it to debug
> traces. With the change that the driver has to request the serial
> number through use_serial_number, simply remove the serial number from
> zfcp.

Hi Christof,

So since the use of struct scsi_cmnd->serial_number is purely
informational for some LLDs (including zfcp) , I have been putting the
conversion of these LLDs as a low priority ATM.   I would happily accept
a patch to remove these.  8-)

Best,

--nab
