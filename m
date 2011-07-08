From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/20] target: Make all control CDBs scatter-gather
Date: Fri, 8 Jul 2011 15:57:55 -0400
Message-ID: <20110708195755.GA12288@infradead.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
 <1310078011-15504-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:32862
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab1GHT54 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 15:57:56 -0400
Content-Disposition: inline
In-Reply-To: <1310078011-15504-4-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

> @@ -2972,19 +2955,6 @@ static int transport_get_sense_data(struct se_cmd *cmd)
>  	return -1;
>  }
>  
> -static int transport_allocate_resources(struct se_cmd *cmd)
> -{
> -	u32 length = cmd->data_length;
> -
> -	if ((cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
> -	    (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB))
> -		return transport_generic_get_mem(cmd, length);
> -	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB)
> -		return transport_generic_allocate_buf(cmd, length);
> -	else
> -		return 0;
> -}
> -
>  static int
>  transport_handle_reservation_conflict(struct se_cmd *cmd)
>  {


> @@ -4892,7 +4854,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>  	 * cmd->t_mem_list of struct se_mem->se_page
>  	 */
>  	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
> -		ret = transport_allocate_resources(cmd);
> +		ret = transport_generic_get_mem(cmd);
>  		if (ret < 0)
>  			return ret;
>  	}

Before transport_allocate_resources used to be a no-op for
SCF_SCSI_NON_DATA_CDB cdbs, which got lots with your patch.  Given that
they should have a zero length your patch should be fine, but such
subtilities would be nice to be documented in the changelog.

>  			 * REQUEST, and the additional sense code set to INVALID
>  			 * FIELD IN PARAMETER LIST.
>  			 */
> +			transport_kunmap_first_data_page(cmd);
>  			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;

I would have preferred to switch to goto based unwinding from the start.
But it's not a major issue, so if no one else complains I'm fine with it
beeing fixed up in a later patch.

> +EXPORT_SYMBOL(transport_kmap_first_data_page);

> +EXPORT_SYMBOL(transport_kunmap_first_data_page);

Any reason these are exported?

> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -109,7 +109,6 @@ enum se_cmd_flags_table {
>  	SCF_EMULATED_TASK_SENSE		= 0x00000004,
>  	SCF_SCSI_DATA_SG_IO_CDB		= 0x00000008,
>  	SCF_SCSI_CONTROL_SG_IO_CDB	= 0x00000010,
> -	SCF_SCSI_CONTROL_NONSG_IO_CDB	= 0x00000020,
>  	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
>  	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
>  	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,

You should be able to kill SCF_PASSTHROUGH_CONTIG_TO_SG as well.

