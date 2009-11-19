From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] be2iscsi: code reorganizing and minor changes
Date: Thu, 19 Nov 2009 15:55:13 -0600
Message-ID: <4B05BEC1.9060203@cs.wisc.edu>
References: <20091118004345.GA10344@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41184 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZKSVzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 16:55:17 -0500
In-Reply-To: <20091118004345.GA10344@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

Jayamohan Kallickal wrote:
>              This patch does a couple of very small, mostly
>     single line changes which I feel will be an overkill to put in
>     individual patches
> 
>  1) moved pci_set_drvdata to inside beiscsi_hba_alloc
>  2) Enabled handling of  TEXT Response
>  3) Added opcode for ISCSI_OP_LOGOUT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP,
>  4) Ask for ack based completion for NOOPOUT and TTT != RESERVERD
> 

I think in the future you still might want to separate these.


> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index ac76b14..109482f 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c


> @@ -564,6 +565,8 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
>  		login_hdr = (struct iscsi_hdr *)ppdu;
>  		login_hdr->itt = io_task->libiscsi_itt;
>  		break;
> +	case ISCSI_OP_TEXT_RSP:
> +		break;


Is this the only thing needed for TEXT pdu handling? Did you test with 
my userspace changes and the libiscsi fixups?
