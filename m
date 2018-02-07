From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] libiscsi: ensure session spin lock usage consistent
Date: Wed, 7 Feb 2018 16:57:34 -0600
Message-ID: <5A7B845E.2050003@redhat.com>
References: <20180205191323.5274-1-lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751562AbeBGW5f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 17:57:35 -0500
In-Reply-To: <20180205191323.5274-1-lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>, hare@suse.de

On 02/05/2018 01:13 PM, Lee Duncan wrote:
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 82c3fd4bc938..055357b2fe9e 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1248,9 +1248,9 @@ int iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  {
>  	int rc;
>  
> -	spin_lock(&conn->session->lock);
> +	spin_lock_bh(&conn->session->lock);
>  	rc = __iscsi_complete_pdu(conn, hdr, data, datalen);
> -	spin_unlock(&conn->session->lock);
> +	spin_unlock_bh(&conn->session->lock);
>  	return rc;

This one is actually needed because qla4xxx_task_work calls it from
process context.
