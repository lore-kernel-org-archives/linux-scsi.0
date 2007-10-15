From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] git scsi misc include fix
Date: Mon, 15 Oct 2007 16:55:04 -0700
Message-ID: <20071015165504.987e9dac.akpm@linux-foundation.org>
References: <20071014053508.30836.69658.sendpatchset@jackhammer.engr.sgi.com>
	<1192491330.14524.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbXJOX4M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 19:56:12 -0400
In-Reply-To: <1192491330.14524.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: pj@sgi.com, willy@linux.intel.com, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Mon, 15 Oct 2007 19:35:30 -0400
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Sat, 2007-10-13 at 22:35 -0700, Paul Jackson wrote:
> > From: Paul Jackson <pj@sgi.com>
> > 
> > The added line in scsi_eh.h:
> > 	struct scatterlist sense_sgl;
> > fails to compile, with the error:
> > 	field 'sense_sgl' has incomplete type
> > unless scatterlist.h happens to be included
> > somehow already ... which it isn't always.
> > 
> > So include scatterlist.h in scsi_eh.h directly.
> > 
> > Signed-off-by: Paul Jackson <pj@sgi.com>
> > 
> > ---
> > 
> > This patch goes after the patch 'git-scsi-misc.patch'
> > 
> >  include/scsi/scsi_eh.h |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- 2.6.23-mm1.orig/include/scsi/scsi_eh.h	2007-10-13 01:13:26.568876534 -0700
> > +++ 2.6.23-mm1/include/scsi/scsi_eh.h	2007-10-13 01:31:32.911855338 -0700
> > @@ -2,6 +2,7 @@
> >  #define _SCSI_SCSI_EH_H
> >  
> >  #include <scsi/scsi_cmnd.h>
> > +#include <linux/scatterlist.h>
> >  struct scsi_device;
> >  struct Scsi_Host;
> 
> 
> I've added linux-scsi which should be cc'd on all SCSI issues.
> 
> I don't quite believe this, though.  The requirement for struct
> scatterlist is the same before and after the gid scsi-misc patch.  If
> the compile fails with git-scsi-misc because of a missing scatterlist
> include, it should also fail with vanilla 2.6.23 without the git
> patch ... could you see if you can find out why it doesn't?
> 

git-scsi-misc adds this:

struct scsi_eh_save {
	int result;
	enum dma_data_direction data_direction;
	unsigned char cmd_len;
	unsigned char cmnd[MAX_COMMAND_SIZE];

	void *buffer;
	unsigned bufflen;
	unsigned short use_sg;
	int resid;

	struct scatterlist sense_sgl;
};

which will not compile unless the includer has earlier included
scatterlist.h.
