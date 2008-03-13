From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] consolidate command allocation in a single place
Date: Thu, 13 Mar 2008 12:15:41 -0500
Message-ID: <1205428542.2893.26.camel@localhost.localdomain>
References: <1205427192.2893.22.camel@localhost.localdomain>
	 <20080313170924.GK613@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44818 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757099AbYCMRPq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Mar 2008 13:15:46 -0400
In-Reply-To: <20080313170924.GK613@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

On Thu, 2008-03-13 at 11:09 -0600, Matthew Wilcox wrote:
> On Thu, Mar 13, 2008 at 11:53:11AM -0500, James Bottomley wrote:
> > Since the way we allocate commands with a separate sense buffer is
> > getting complicated, we should isolate setup and teardown to a single
> > routine so that if it gets even more complex, there's only one place
> > in the code that needs to be altered.
> 
> > +static struct scsi_cmnd *
> > +scsi_get_command_from_pool(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> > +static void
> > +scsi_put_command_to_pool(struct scsi_host_cmd_pool *pool,
> > +			 struct scsi_cmnd *cmd)
> 
> The names are a bit clunky ... 'put command to pool'?  How about
> alloc/free instead of get/put?  or:
> 
> scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> scsi_pool_free_command(struct scsi_host_cmd_pool *pool, struct scsi_cmnd *cmd)
> 
> or even:
> 
> scsi_command_pool_alloc(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> scsi_command_pool_free(struct scsi_host_cmd_pool *pool, struct scsi_cmnd *cmd)
> 
> (i also wouldn't object to use 'cmnd' or 'cmd' in place of 'command').

Yes, but it's following the naming convention in the file.  OK, I don't
like it as well, that's why the new functions in the following patch
have alloc/free.

James


