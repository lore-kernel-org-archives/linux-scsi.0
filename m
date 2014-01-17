From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/7] be2iscsi : Fix statistics update in the driver.
Date: Fri, 17 Jan 2014 02:47:19 -0600
Message-ID: <52D8EE17.7070904@cs.wisc.edu>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com> <1389573741-3523-4-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47800 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaAQIra (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 03:47:30 -0500
In-Reply-To: <1389573741-3523-4-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 01/12/2014 06:42 PM, Jayamohan Kallickal wrote:
>  
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
> index 0076119..d21ad9e 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -449,6 +449,25 @@ struct beiscsi_conn {
>  	struct sgl_handle *plogin_sgl_handle;
>  	struct beiscsi_session *beiscsi_sess;
>  	struct iscsi_task *task;
> +
> +	/* CXN statistics */
> +	/* Xmit Counters */
> +	uint32_t noptx_pdus;
> +	uint32_t login_pdus;
> +	uint32_t text_pdus;
> +	uint32_t logout_pdus;
> +	uint32_t snack_pdus;
> +
> +	/* Rx Counters */
> +	uint32_t noprx_pdus;
> +	uint32_t textrsp_pdus;
> +	uint32_t logoutrsp_pdus;
> +	uint32_t async_pdus;
> +	uint32_t rjt_pdus;
> +
> +	/* Error Counters */
> +	uint32_t digest_err;
> +	uint32_t format_err;
>  };
>  

You should put these on the iscsi_conn struct then have
__iscsi_complete_pdu handle the counters.

libiscsi should then also setup processing of those stats. You should
make a libiscsi helper which the drivers call. See iscsi_tcp
iscsi_sw_tcp_conn_get_stats call to iscsi_tcp_conn_get_stats for an
example for how it is done with libiscsi_tcp and lower level stats it
manages.
