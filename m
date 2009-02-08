From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: Fix some debug printf types
Date: Sun, 08 Feb 2009 13:08:34 -0600
Message-ID: <498F2DB2.6060503@cs.wisc.edu>
References: <496B621A.6000300@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53912 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbZBHTIl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Feb 2009 14:08:41 -0500
In-Reply-To: <496B621A.6000300@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> 
> A couple of prints at lib/iscsi_tcp had the %Z missing from the
> kprint format string. Just to show that debug_prints are not enabled
> much.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/iscsi_tcp.c    |    2 +-
>  drivers/scsi/libiscsi_tcp.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 23808df..a566aa9 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -415,7 +415,7 @@ iscsi_sw_tcp_send_linear_data_prep(struct iscsi_conn *conn, void *data,
>  	struct hash_desc *tx_hash = NULL;
>  	unsigned int hdr_spec_len;
>  
> -	debug_tcp("%s(%p, datalen=%d%s)\n", __func__, tcp_conn, len,
> +	debug_tcp("%s(%p, datalen=%Zd%s)\n", __func__, tcp_conn, len,
>  		  conn->datadgst_en? ", digest enabled" : "");
>  


I got these fixed when I did the modparam debug patch.

I used a lower case z (%zd) though. I thought I saw that in a review 
comment from Andrew Morton or in a kernel janitor patch, so I thought 
that was the preferred way to do it in kernel code, but was not 100% 
sure. Let me know if I goofed and I will fix it.

Thanks.
