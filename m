From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi_lib: fix scsi_io_completion's SG_IO error propagation
Date: Thu, 31 May 2012 16:24:22 -0400
Message-ID: <20120531202422.GA8731@redhat.com>
References: <1338491133-8077-1-git-send-email-snitzer@redhat.com>
 <4FC7CBCA.60707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000Ab2EaUYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2012 16:24:33 -0400
Content-Disposition: inline
In-Reply-To: <4FC7CBCA.60707@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-scsi@vger.kernel.org, babu.moger@netapp.com, hare@suse.de, michaelc@cs.wisc.edu, James.Bottomley@hansenpartnership.com, stable@vger.kernel.org.#.3.4

On Thu, May 31 2012 at  3:51pm -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 31/05/2012 21:05, Mike Snitzer ha scritto:
> > The following v3.4-rc1 commit unmasked an existing bug in
> > scsi_io_completion's SG_IO error handling:
> > 47ac56d [SCSI] scsi_error: classify some ILLEGAL_REQUEST sense as a permanent TARGET_ERROR
> > 
> > Given that certain ILLEGAL_REQUEST are now properly categorized as
> > TARGET_ERROR the host_byte is being set (before host_byte wasn't ever
> > set for these ILLEGAL_REQUEST).
> > 
> > In scsi_io_completion, initialize req->errors with cmd->result _after_
> > the SG_IO block that calls __scsi_error_from_host_byte (which may
> > modify the host_byte).
> > 
> > Before this fix:
> > 
> >     cdb to send: 12 01 01 00 00 00
> > ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
> >     mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
> >     status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
> >     00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0x10,
> >     driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> > SCSI Status: Check Condition
> > 
> > Sense Information:
> > sense buffer empty
> > 
> > After:
> > 
> >     cdb to send: 12 01 01 00 00 00
> > ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
> >     mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
> >     status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
> >     00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0,
> >     driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> > SCSI Status: Check Condition
> > 
> > Sense Information:
> >  Fixed format, current;  Sense key: Illegal Request
> >  Additional sense: Invalid field in cdb
> >  Raw sense data (in hex):
> >         70 00 05 00 00 00 00 0b  00 00 00 00 24 00 00 00
> >         00 00 00
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > Reviewed-by: Babu Moger <babu.moger@netapp.com>
> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Tested-by: Paolo Bonzini <pbonzini@redhat.com>

Yes, thanks for backfilling the Reported-by and Tested-by Paolo!
