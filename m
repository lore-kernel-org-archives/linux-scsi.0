From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2 1/5] add scsi_build_sense_buffer helper function
Date: Tue, 25 Mar 2008 19:01:52 +0900
Message-ID: <20080325190152L.fujita.tomonori@lab.ntt.co.jp>
References: <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<47E8C9B7.1040406@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:36509 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbYCYKEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 06:04:40 -0400
In-Reply-To: <47E8C9B7.1040406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, tomof@acm.org, James.Bottomley@HansenPartnership.com

On Tue, 25 Mar 2008 11:45:27 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Tue, Mar 25 2008 at 2:26 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > This adds scsi_build_sense_buffer, a simple helper function to build
> > sense data in a buffer.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > ---
> >  drivers/scsi/scsi_error.c |   28 ++++++++++++++++++++++++++++
> >  include/scsi/scsi_eh.h    |    4 +++-
> >  2 files changed, 31 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 1221d2c..221f31e 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -1993,3 +1993,31 @@ int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
> >  	}
> >  }
> >  EXPORT_SYMBOL(scsi_get_sense_info_fld);
> > +
> > +/**
> > + * scsi_build_sense_buffer - build sense data in a buffer
> > + * @desc:	Sense format (non zero == descriptor format,
> > + * 		0 == fixed format)
> > + * @buf:	Where to build sense data
> > + * @key:	Sense key
> > + * @asc:	Additional sense code
> > + * @ascq:	Additional sense code qualifier
> > + *
> > + **/
> > +void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
> > +{
> > +	if (desc) {
> > +		buf[0] = 0x72;	/* descriptor, current */
> > +		buf[1] = key;
> > +		buf[2] = asc;
> > +		buf[3] = ascq;
> > +		buf[7] = 0;
> > +	} else {
> > +		buf[0] = 0x70;	/* fixed, current */
> > +		buf[2] = key;
> > +		buf[7] = 0xa;
> > +		buf[12] = asc;
> > +		buf[13] = ascq;
> > +	}
> > +}
> > +EXPORT_SYMBOL(scsi_build_sense_buffer);
> > diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> > index 37a7614..d3a133b 100644
> > --- a/include/scsi/scsi_eh.h
> > +++ b/include/scsi/scsi_eh.h
> > @@ -57,7 +57,9 @@ extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
> >  
> >  extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
> >  				   u64 * info_out);
> > - 
> > +
> > +extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
> > +
> >  /*
> >   * Reset request from external source
> >   */
> Tomo Hi.
> 
> Thanks for doing this. It was requested before by few people.
> 
> I have one small request please? This is to help me  with my "sense" effort.
> (See here: http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=shortlog;h=boaz_sense_effort)
> Could you change it that a struct scsi_cmnd * is passed to the new API, instead of the
> u8 * directly. This is because I'm removing the buffer at scsi_cmnd. Something like:
> 
> extern void scsi_build_sense_buffer(struct scsi_cmnd *, int desc, u8 key, u8 asc, u8 ascq);

Unfortunately, it doesn't work for scsi_debug (doesn't build sense
data in scsi_cmnd).

I guess, later on you could change something like:

extern void __scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);

void scsi_build_sense_buffer(struct scsi_cmnd *cmd, int desc, u8 key, u8 asc, u8 ascq)
{
	__scsi_build_sense_buffer(desc, cmd->sense_buffer, desc, key, asc, ascq);
}
