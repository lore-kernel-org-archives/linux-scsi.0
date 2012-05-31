From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: scsi_lib: fix scsi_io_completion's SG_IO error propagation
Date: Thu, 31 May 2012 20:33:37 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B07DF051A@SACEXCMBX02-PRD.hq.netapp.com>
References: <1338491133-8077-1-git-send-email-snitzer@redhat.com>
 <4FC7CBCA.60707@redhat.com> <20120531202422.GA8731@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:28879 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423Ab2EaUdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2012 16:33:44 -0400
In-Reply-To: <20120531202422.GA8731@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "stable@vger.kernel.org.#.3.4" <stable@vger.kernel.org.#.3.4>

Thanks Mike. Looks good.

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Thursday, May 31, 2012 3:24 PM
> To: Paolo Bonzini
> Cc: linux-scsi@vger.kernel.org; Moger, Babu; hare@suse.de;
> michaelc@cs.wisc.edu; James.Bottomley@hansenpartnership.com;
> stable@vger.kernel.org.#.3.4
> Subject: Re: scsi_lib: fix scsi_io_completion's SG_IO error propagation
> 
> On Thu, May 31 2012 at  3:51pm -0400,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> > Il 31/05/2012 21:05, Mike Snitzer ha scritto:
> > > The following v3.4-rc1 commit unmasked an existing bug in
> > > scsi_io_completion's SG_IO error handling:
> > > 47ac56d [SCSI] scsi_error: classify some ILLEGAL_REQUEST sense as a
> permanent TARGET_ERROR
> > >
> > > Given that certain ILLEGAL_REQUEST are now properly categorized as
> > > TARGET_ERROR the host_byte is being set (before host_byte wasn't ever
> > > set for these ILLEGAL_REQUEST).
> > >
> > > In scsi_io_completion, initialize req->errors with cmd->result _after_
> > > the SG_IO block that calls __scsi_error_from_host_byte (which may
> > > modify the host_byte).
> > >
> > > Before this fix:
> > >
> > >     cdb to send: 12 01 01 00 00 00
> > > ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
> > >     mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
> > >     status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
> > >     00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0x10,
> > >     driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> > > SCSI Status: Check Condition
> > >
> > > Sense Information:
> > > sense buffer empty
> > >
> > > After:
> > >
> > >     cdb to send: 12 01 01 00 00 00
> > > ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=[12, 01, 01, 00, 00, 00],
> > >     mx_sb_len=32, iovec_count=0, dxfer_len=0, timeout=20000, flags=0,
> > >     status=02, masked_status=01, sb[19]=[70, 00, 05, 00, 00, 00, 00, 0b,
> > >     00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=0,
> > >     driver_status=0x8, resid=0, duration=0, info=0x1}) = 0
> > > SCSI Status: Check Condition
> > >
> > > Sense Information:
> > >  Fixed format, current;  Sense key: Illegal Request
> > >  Additional sense: Invalid field in cdb
> > >  Raw sense data (in hex):
> > >         70 00 05 00 00 00 00 0b  00 00 00 00 24 00 00 00
> > >         00 00 00
> > >
> > > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > > Reviewed-by: Babu Moger <babu.moger@netapp.com>
> >
> > Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> > Tested-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Yes, thanks for backfilling the Reported-by and Tested-by Paolo!
