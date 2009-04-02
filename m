From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi tree build failure
Date: Thu, 02 Apr 2009 18:23:42 +0000
Message-ID: <1238696622.13399.11.camel@mulgrave.int.hansenpartnership.com>
References: <20090402164927.97958f84.sfr@canb.auug.org.au>
	 <1238682141.3383.11.camel@mulgrave.int.hansenpartnership.com>
	 <1238692778.15031.56.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1238692778.15031.56.camel@fritz>
Sender: linux-next-owner@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "Dev, Vasu" <vasu.dev@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-04-02 at 10:19 -0700, Robert Love wrote:
> On Thu, 2009-04-02 at 07:22 -0700, James Bottomley wrote:
> > cc: linux-scsi added
> > 
> > On Thu, 2009-04-02 at 16:49 +1100, Stephen Rothwell wrote:
> > > Hi James,
> > > 
> > > Today's linux-next build (powerpc allyesconfig) failed like this:
> > > 
> > > drivers/scsi/fcoe/fcoe.c:982: error: __ksymtab_fcoe_fc_crc causes a section type conflict
> > > drivers/scsi/fcoe/fcoe.c:982: error: __ksymtab_fcoe_fc_crc causes a section type conflict
> > > 
> > > Reverting commit 0c3cb56ec3321b23e9826cccf822470717be6e08 ("[SCSI] fcoe:
> > > cleans up libfcoe.h and adds fcoe.h for fcoe module") makes the error go
> > > away.  I have no idea why - the only clue is that the only global
> > > declaration of fcoe_fc_crc() is removed by that commit.
> > > 
> > > Using a different compiler version (4.1.2) also fixed the problem.
> > 
> > Yes, that would be why I didn't see the issue.
> > 
> I built using gcc version 4.3.2 (on x86_64) and didn't see this either.
> 
> > > I also had to revert commits 60390544fcc212e0657cf1eea639691d09651943
> > > ("[SCSI] fcoe, libfc: fix double fcoe_softc memory alloc") and
> > > ba070644bff4390c965e99b1997f2cbec4157b46 ("[SCSI] fcoe, libfcoe: Add
> > > support for FIP. FCoE discovery and keep-alive") since they followed the
> > > one above.
> > > 
> > > I wonder if that function even needs to be exported as it is only used
> > > withing the one file.
> > 
> > I think it's because the above commit removes the external declaration
> > of fcoe_fc_crc ... so now we have an export symbol with no header
> > defining it.  I think the correct patch is just not to export the
> > symbol.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > index 5cdda6e..94e1e31 100644
> > --- a/drivers/scsi/fcoe/fcoe.c
> > +++ b/drivers/scsi/fcoe/fcoe.c
> > @@ -979,7 +979,6 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
> >  	}
> >  	return crc;
> >  }
> > -EXPORT_SYMBOL_GPL(fcoe_fc_crc);
> >  
> >  /**
> >   * fcoe_xmit() - FCoE frame transmit function
> > 
> > 
> How can we resolve this? Should we provide an updated patch without this
> line or a new patch to remove the line?

Right at the moment, I need someone to verify that this is the fix,
since I don't have a complaining compiler myself.  If it's this simple,
I can adjust the patch accordingly.

James
