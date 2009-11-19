From: "Jayamohan Kalickal" <jayamohank@serverengines.com>
Subject: Re: [PATCH 4/4] be2iscsi: code reorganizing and minor changes
Date: Thu, 19 Nov 2009 14:23:24 -0800
Message-ID: <20091119222324.d192ab2d@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail192.messagelabs.com ([216.82.241.243]:15472 "EHLO
	mail192.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbZKSWXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 17:23:21 -0500
In-Reply-To: 4B05BEC1.9060203@cs.wisc.edu
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

No, I haven't tested it with libiscsi fixups. 

The whole packet including header is passed upwards ,so, I don't see a reason it won't work.

Will I get your changes in the latest git tree?

-Jay

  _____  
From: Mike Christie [mailto:michaelc@cs.wisc.edu]
To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Sent: Thu, 19 Nov 2009 13:55:13 -0800
Subject: Re: [PATCH 4/4] be2iscsi: code reorganizing and minor changes

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

___________________________________________________________________________________
This message, together with any attachment(s), contains confidential and proprietary information of
ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
intended recipient of this message, please immediately advise the sender by reply email message and
delete all copies of this message and any attachment(s). Thank you.

