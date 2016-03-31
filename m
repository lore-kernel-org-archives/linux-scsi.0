From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/5] libiscsi: Remove set-but-not-used variables
Date: Thu, 31 Mar 2016 09:59:33 +0200
Message-ID: <4623e5d03607a9a81fb0cec74084332a@suse.de>
References: <56FC1A3B.4040704@sandisk.com> <56FC1A7C.1020501@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbcCaH7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 03:59:34 -0400
In-Reply-To: <56FC1A7C.1020501@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-03-30 20:27, Bart Van Assche wrote:
> Avoid that building with W=1 causes gcc to report warnings about
> set-but-not-used variables.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/libiscsi.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 120150a..c051694 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2127,7 +2127,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	struct iscsi_conn *conn;
>  	struct iscsi_task *task;
>  	struct iscsi_tm *hdr;
> -	int rc, age;
> +	int age;
> 
>  	cls_session = starget_to_session(scsi_target(sc->device));
>  	session = cls_session->dd_data;
> @@ -2188,10 +2188,8 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	hdr = &conn->tmhdr;
>  	iscsi_prep_abort_task_pdu(task, hdr);
> 
> -	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout)) 
> {
> -		rc = FAILED;
> +	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout))
>  		goto failed;
> -	}
> 
>  	switch (conn->tmf_state) {
>  	case TMF_SUCCESS:

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
