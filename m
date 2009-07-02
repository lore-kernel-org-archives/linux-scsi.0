From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
Date: Thu, 02 Jul 2009 20:11:52 +0530
Message-ID: <1246545712.2242.4.camel@jaswinder.satnam>
References: <1246122359.32198.7.camel@hpdv5.satnam>
	 <1246123628.3990.19.camel@mulgrave.site>
	 <1246125388.32198.14.camel@hpdv5.satnam>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755755AbZGBOmW@vger.kernel.org>
In-Reply-To: <1246125388.32198.14.camel@hpdv5.satnam>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-06-27 at 23:26 +0530, Jaswinder Singh Rajput wrote:
> On Sat, 2009-06-27 at 12:27 -0500, James Bottomley wrote:
> > All SCSI patches should be cc'd to the SCSI list
> > 
> > On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> > > userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> > > and scsi_device_type defined in kernel
> > > 
> > > fix the following 'make headers_check' warnings:
> > > 
> > >   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
> > >   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  include/scsi/scsi.h |   13 +++++++------
> > >  1 files changed, 7 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> > > index 084478e..7ba5acf 100644
> > > --- a/include/scsi/scsi.h
> > > +++ b/include/scsi/scsi.h
> > > @@ -156,9 +156,6 @@ scsi_varlen_cdb_length(const void *hdr)
> > >  	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
> > >  }
> > >  
> > > -extern const unsigned char scsi_command_size_tbl[8];
> > > -#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
> > > -
> > >  static inline unsigned
> > >  scsi_command_size(const unsigned char *cmnd)
> > >  {
> > > @@ -166,6 +163,13 @@ scsi_command_size(const unsigned char *cmnd)
> > >  		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
> > 
> > Even a simple eyeball inspection of this patch shows that the removal of
> > COMMAND_SIZE above causes this inline function to fail to compile.
> > 
> > If you can't be bothered even to read your own patches or at the very
> > least compile test them, what makes you think I should bother reading
> > anything you send in?
> > 
> 
> oops I am sorry, actually it should be RFC I want to check whether I
> need to cover more member under __KERNEL__
> 
> [RFC][PATCH] SCSI: userspace cannot use scsi_command_size_tbl, scsi_device_type and friends
> 
> userspace cannot use scsi_command_size_tbl and scsi_device_type defined in kernel
> as well as its friends :
> 
> - SCSI_MAX_VARLEN_CDB_SIZE
> - COMMAND_SIZE
> - struct scsi_varlen_cdb_hdr
> - scsi_varlen_cdb_length()
> - scsi_command_size()
> 
> fix the following 'make headers_check' warnings:
> 
>   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
>   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>


What is the status of this patch.

Thanks,
--
JSR
