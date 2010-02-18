From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/7] be2iscsi: Modification of  iscsi_eh_target_reset
Date: Wed, 17 Feb 2010 22:17:23 -0600
Message-ID: <4B7CBF53.5020401@cs.wisc.edu>
References: <20100218014705.GA31130@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45334 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0BRERh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2010 23:17:37 -0500
In-Reply-To: <20100218014705.GA31130@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 02/17/2010 07:47 PM, Jayamohan Kallickal wrote:
> @@ -2449,7 +2449,6 @@ int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>   		break;
>   	case TMF_TIMEDOUT:
>   		spin_unlock_bh(&session->lock);
> -		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);

It is harmless to keep this, right? Just keep it for now so the reset 
handler code behaves the same for all TMF_TIMEDOUT cases.


>   		goto done;
>   	default:
>   		conn->tmf_state = TMF_INITIAL;
> @@ -2476,12 +2475,27 @@ done:
>   	ISCSI_DBG_EH(session, "tgt %s reset result = %s\n", session->targetname,
>   		     rc == SUCCESS ? "SUCCESS" : "FAILED");
>   	mutex_unlock(&session->eh_mutex);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(iscsi_eh_target_reset);
> +

You can remove the export symbol since no one is using it now, and 
remove the libiscsi.h iscsi_eh_target_reset code too.

> +/**
> + * iscsi_eh_recover_target - reset target and possibly the session
> + * @sc: scsi command
> + *
> + * This will attempt to send a warm target reset. If that fails,
> + * we will escalate to ERL0 session recovery.
> + */
> +int iscsi_eh_recover_target(struct scsi_cmnd *sc)
> +{
> +	int rc;
>
> +	rc = iscsi_eh_target_reset(sc);	

Some extra whitespace at the end of that line. You can do a git am 
--wihtespace=fix on your patches before you send and that will fix them 
up for you (just remember to respit the new ones out and send them).
