From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/15] target: Make all control CDBs scatter-gather
Date: Tue, 28 Jun 2011 16:22:29 -0400
Message-ID: <20110628202229.GA16234@infradead.org>
References: <1309289377-8029-1-git-send-email-agrover@redhat.com>
 <1309289377-8029-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42318
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab1F1UWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 16:22:30 -0400
Content-Disposition: inline
In-Reply-To: <1309289377-8029-4-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

> @@ -209,6 +216,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
>  			 * REQUEST, and the additional sense code set to INVALID
>  			 * FIELD IN PARAMETER LIST.
>  			 */
> +			transport_kunmap_first_data_page(cmd);
>  			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
>  		}
>  		rc = -1;
> @@ -260,8 +268,10 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
>  			 * If not matching target port group ID can be located
>  			 * throw an exception with ASCQ: INVALID_PARAMETER_LIST
>  			 */
> -			if (rc != 0)
> +			if (rc != 0) {
> +				transport_kunmap_first_data_page(cmd);
>  				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
> +			}

It would be good to use goto unwinding here and in all other control
CDB handlers that may return errors.

