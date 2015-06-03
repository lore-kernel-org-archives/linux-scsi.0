From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: linux-next: build failure after merge of the target-updates tree
Date: Wed, 03 Jun 2015 15:46:05 -0700
Message-ID: <1433371565.18125.10.camel@haakon3.risingtidesystems.com>
References: <20150603181607.70cef830@canb.auug.org.au>
	 <1433361639.2251.111.camel@HansenPartnership.com>
	 <1433369576.18125.7.camel@haakon3.risingtidesystems.com>
	 <1433370812.2251.140.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1433370812.2251.140.camel@HansenPartnership.com>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-06-03 at 15:33 -0700, James Bottomley wrote:
> On Wed, 2015-06-03 at 15:12 -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2015-06-03 at 13:00 -0700, James Bottomley wrote:

<SNIP>

> > > OK, this gives us a cross tree dependency on the SCSI header split
> > > patches.  Nic, if you base your tree off this commit in mine, I'll make
> > > sure to push early in the merge window.
> > > 
> > > commit ba929992522b6d1f866b7021bc50da66f8fdd743
> > > Author: Bart Van Assche <bart.vanassche@sandisk.com>
> > > Date:   Fri May 8 10:11:12 2015 +0200
> > > 
> > >     target: Minimize SCSI header #include directives
> > > 
> > 
> > Rebasing one subsystem's for-next atop another subsystem's for-next is a
> > sure fire way to cause Linus to become irate.
> 
> No, he's fine with it (as long as the trees aren't entangled when
> submitted). We used to do it all the time with the block and SCSI trees;
> it's why the scsi postmerge tree existed.
> 

...

> > But it's not even necessary here anyways, just fold Stephen's patch to
> > add scsi_proto.h to target_core_fabric_configfs.c into the original
> > change, and be done with it.
> 
> I can certainly do that, but other updates to the target tree could
> cause this problem to reoccur in different files.
> 

target_core_fabric_lib.c is the only place where SCSI_PROTOCOL_* is used
and I don't expect this to change before -rc1, so it should be OK to
just fold into the original.
