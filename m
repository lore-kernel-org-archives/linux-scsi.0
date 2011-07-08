From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/20] target: Enforce 1 page max for control cdb buffer
 sizes
Date: Fri, 8 Jul 2011 15:58:35 -0400
Message-ID: <20110708195835.GB12288@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310078011-15504-5-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:32864
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1GHT6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 15:58:35 -0400
Content-Disposition: inline
In-Reply-To: <1310078011-15504-5-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jul 07, 2011 at 03:33:15PM -0700, Andy Grover wrote:
> Due to all cdbs' data buffers being referenced by scatterlists, buffers
> of more than a page are not contiguous. Instead of handling this in all
> control command handlers, we may be able to get away with just limiting
> control cdb data buffers to one page. The only control CDBs we handle that
> have potentially large data buffers are REPORT LUNS and UNMAP, so if we
> didn't want to live with this limitation, they would need to be modified
> to walk the pages in the data buffer's sgl.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_transport.c |    5 +++++
>  include/target/target_core_base.h      |    1 +
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index e2887c3..f9645b7 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3568,6 +3568,11 @@ static int transport_generic_cmd_sequencer(
>  		cmd->data_length = size;
>  	}
>  
> +	/* Let's limit control cdbs to a page, for simplicity's sake. */
> +	if ((cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)
> +	    && size > PAGE_SIZE)
> +		goto out_invalid_cdb_field;

Normal Linux style would be the operand at the end of the previous line.

