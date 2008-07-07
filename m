From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: linux-next: scsi tree build failure
Date: Mon, 7 Jul 2008 09:53:40 -0500
Message-ID: <20080707145340.GB21578@linux.vnet.ibm.com>
References: <20080707222528.280f0b9e.sfr@canb.auug.org.au> <1215441589.3274.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1215441589.3274.17.camel@localhost.localdomain>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org, benh@kernel.crashing.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

* James Bottomley (James.Bottomley@HansenPartnership.com) wrote:
> Correct cc's added
> 
> On Mon, 2008-07-07 at 22:25 +1000, Stephen Rothwell wrote:
> > Hi James,
> > 
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > 
> > drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'map_sg_data':
> > drivers/scsi/ibmvscsi/ibmvscsi.c:431: error: 'FW_FEATURE_CMO' undeclared (first use in this function)
> > drivers/scsi/ibmvscsi/ibmvscsi.c:431: error: (Each undeclared identifier is reported only once
> > drivers/scsi/ibmvscsi/ibmvscsi.c:431: error: for each function it appears in.)
> > drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'ibmvscsi_queuecommand':
> > drivers/scsi/ibmvscsi/ibmvscsi.c:750: error: 'FW_FEATURE_CMO' undeclared (first use in this function)
> > drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'send_mad_adapter_info':
> > drivers/scsi/ibmvscsi/ibmvscsi.c:864: error: 'FW_FEATURE_CMO' undeclared (first use in this function)
> > drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'ibmvscsi_do_host_config':
> > drivers/scsi/ibmvscsi/ibmvscsi.c:1412: error: 'FW_FEATURE_CMO' undeclared (first use in this function)
> > drivers/scsi/ibmvscsi/ibmvscsi.c: At top level:
> > drivers/scsi/ibmvscsi/ibmvscsi.c:1769: error: unknown field 'get_io_entitlement' specified in initializer
> > drivers/scsi/ibmvscsi/ibmvscsi.c:1769: warning: missing braces around initializer
> > drivers/scsi/ibmvscsi/ibmvscsi.c:1769: warning: (near initialization for 'ibmvscsi_driver.driver')
> > drivers/scsi/ibmvscsi/ibmvscsi.c:1769: warning: initialization from incompatible pointer type
> > 
> > Caused because commit 341b56db6804040aa9559e913865108424e3b18b ("[SCSI]
> > ibmvscsi: driver enablement for CMO"), which was 15/16 in a series, has
> > been merged before any of the other patches in the series.  I have
> > reverted that commit.
> 
> Do I detect the fact that IBM sent a patch for a SCSI driver for which
> the core features weren't yet enabled (and which I couldn't check, not
> having a ppc build system)?
> 
> James

I didn't not properly note in the patch description my intent to have
this merged in the linuxppc-dev tree.  The patch is part of a larger set
enabling the feature.  Linux-scsi was CC'ed for this driver for review.

Robert Jennings
