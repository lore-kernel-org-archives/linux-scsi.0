From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 1/4] iscsi class, qla4xxx and libiscsi: export iscsi session
 state in sysfs
Date: Thu, 15 Mar 2007 08:58:50 -0400
Message-ID: <45F9430A.9010309@emulex.com>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:45785 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224AbXCOM7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2007 08:59:04 -0400
In-Reply-To: <11739019693216-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org





> @@ -1768,7 +1781,8 @@ static void iscsi_start_session_recovery
>  	 * flush queues.
>  	 */
>  	spin_lock_bh(&session->lock);
> -	fail_all_commands(conn);
> +	fail_all_commands(conn,
> +			STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
>  	flush_control_queues(session, conn);
>  	spin_unlock_bh(&session->lock);
>  

I'm assuming you do not support error recovery level 2, right ?

> +int iscsi_session_chkready(struct iscsi_cls_session *session)
...
> +EXPORT_SYMBOL_GPL(iscsi_session_chkready);

Any reason this isn't an inline ?


