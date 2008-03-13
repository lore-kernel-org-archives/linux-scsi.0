From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] consolidate command allocation in a single place
Date: Thu, 13 Mar 2008 11:09:25 -0600
Message-ID: <20080313170924.GK613@parisc-linux.org>
References: <1205427192.2893.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43229 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYCMRJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Mar 2008 13:09:26 -0400
Content-Disposition: inline
In-Reply-To: <1205427192.2893.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>

On Thu, Mar 13, 2008 at 11:53:11AM -0500, James Bottomley wrote:
> Since the way we allocate commands with a separate sense buffer is
> getting complicated, we should isolate setup and teardown to a single
> routine so that if it gets even more complex, there's only one place
> in the code that needs to be altered.

> +static struct scsi_cmnd *
> +scsi_get_command_from_pool(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> +static void
> +scsi_put_command_to_pool(struct scsi_host_cmd_pool *pool,
> +			 struct scsi_cmnd *cmd)

The names are a bit clunky ... 'put command to pool'?  How about
alloc/free instead of get/put?  or:

scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
scsi_pool_free_command(struct scsi_host_cmd_pool *pool, struct scsi_cmnd *cmd)

or even:

scsi_command_pool_alloc(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
scsi_command_pool_free(struct scsi_host_cmd_pool *pool, struct scsi_cmnd *cmd)

(i also wouldn't object to use 'cmnd' or 'cmd' in place of 'command').

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
