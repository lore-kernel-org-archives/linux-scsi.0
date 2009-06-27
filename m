From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
Date: Sat, 27 Jun 2009 23:26:28 +0530
Message-ID: <1246125388.32198.14.camel@hpdv5.satnam>
References: <1246122359.32198.7.camel@hpdv5.satnam>
	 <1246123628.3990.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:40375 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbZF0R4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jun 2009 13:56:46 -0400
In-Reply-To: <1246123628.3990.19.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

On Sat, 2009-06-27 at 12:27 -0500, James Bottomley wrote:
> All SCSI patches should be cc'd to the SCSI list
> 
> On Sat, 2009-06-27 at 22:35 +0530, Jaswinder Singh Rajput wrote:
> > userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
> > and scsi_device_type defined in kernel
> > 
> > fix the following 'make headers_check' warnings:
> > 
> >   usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
> >   usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  include/scsi/scsi.h |   13 +++++++------
> >  1 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> > index 084478e..7ba5acf 100644
> > --- a/include/scsi/scsi.h
> > +++ b/include/scsi/scsi.h
> > @@ -156,9 +156,6 @@ scsi_varlen_cdb_length(const void *hdr)
> >  	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
> >  }
> >  
> > -extern const unsigned char scsi_command_size_tbl[8];
> > -#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
> > -
> >  static inline unsigned
> >  scsi_command_size(const unsigned char *cmnd)
> >  {
> > @@ -166,6 +163,13 @@ scsi_command_size(const unsigned char *cmnd)
> >  		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
> 
> Even a simple eyeball inspection of this patch shows that the removal of
> COMMAND_SIZE above causes this inline function to fail to compile.
> 
> If you can't be bothered even to read your own patches or at the very
> least compile test them, what makes you think I should bother reading
> anything you send in?
> 

oops I am sorry, actually it should be RFC I want to check whether I
need to cover more member under __KERNEL__

[RFC][PATCH] SCSI: userspace cannot use scsi_command_size_tbl, scsi_device_type and friends

userspace cannot use scsi_command_size_tbl and scsi_device_type defined in kernel
as well as its friends :

- SCSI_MAX_VARLEN_CDB_SIZE
- COMMAND_SIZE
- struct scsi_varlen_cdb_hdr
- scsi_varlen_cdb_length()
- scsi_command_size()

fix the following 'make headers_check' warnings:

  usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
  usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/scsi/scsi.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..5ac0157 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -134,6 +134,7 @@ struct scsi_cmnd;
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
 #define	ATA_12		      0xa1	/* 12-byte pass-thru */
 
+#ifdef __KERNEL__
 /*
  *	SCSI command lengths
  */
@@ -166,6 +167,9 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+/* Returns a human-readable name for the device */
+extern const char * scsi_device_type(unsigned type);
+#endif
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
@@ -281,9 +285,6 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
-/* Returns a human-readable name for the device */
-extern const char * scsi_device_type(unsigned type);
-
 /*
  * standard mode-select header prepended to all mode-select commands
  */
-- 
1.6.0.6



