From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 15/18] be2iscsi: Fix the session cleanup when reboot/shutdown
 happens
Date: Wed, 10 Apr 2013 18:41:42 -0500
Message-ID: <5165F8B6.8080506@cs.wisc.edu>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com> <1365219519-3457-15-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38503 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761256Ab3DJXlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 19:41:55 -0400
In-Reply-To: <1365219519-3457-15-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 4/5/13 10:38 PM, Jayamohan Kallickal wrote:
>   During reboot/shutdown cycle, the active sessions were not updated.
>   In iSCSI Boot case, the boot session was alive and this fix informs
>   that the machine is going down, so no more ops happens on that session.
>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |    2 +-
>   drivers/scsi/be2iscsi/be_cmds.h |    3 +++
>   drivers/scsi/be2iscsi/be_main.c |    1 +
>   3 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index e66aa7c..a3bfc1d 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -340,7 +340,7 @@ static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phba)
>   	return NULL;
>   }
>
> -static void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
> +void be2iscsi_fail_session(struct iscsi_cls_session *cls_session)
>   {
>   	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);

I am not sure how this is working or what it fixes. During 
shutdown/reboot when the pci_driver shutdown callback is called, without 
the patch what is happening? Does the host shutdown cause iscsid to try 
and recover the session and that causes a shutdown/reboot hang?

I think you want to use ISCSI_ERR_INVALID_HOST. That would cause a clean 
shutdown of the sessions if iscsid is still up at that time. This would 
cause ep_disconnect to get called and a logout pdu to get sent.

ISCSI_ERR_CONN_FAILED just causes recovery to start (ep_disconnect will 
run if the ep is up and we will try to reconnect).


