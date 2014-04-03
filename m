From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 3/6] be2iscsi: Fix MCCQ posting for Mbx-Cmd after driver
 initialization is complete
Date: Thu, 3 Apr 2014 05:02:56 +0000
Message-ID: <d28ae082-c08a-4ac1-ad7f-044d6220fb98@CMEXHTCAS1.ad.emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
 <1395938371-2149-3-git-send-email-Jayamohan.Kallickal@emulex.com>
 <5334C639.9000007@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:22360 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbaDCFDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 01:03:00 -0400
In-Reply-To: <5334C639.9000007@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@gmail.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Sony John-N <Sony.John-N@Emulex.Com>, "cleech@redhat.com" <cleech@redhat.com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Thursday, March 27, 2014 5:46 PM
To: Jayamohan Kallickal; jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal; Sony John-N
Subject: Re: [PATCH 3/6] be2iscsi: Fix MCCQ posting for Mbx-Cmd after driver initialization is complete

On 03/27/2014 09:39 AM, Jayamohan Kallickal wrote:
>  Even before probe for function was completed, iSCSI Daemon had 
> initiated login  to target while OS was coming up. The targets which 
> had node.startup=automatic,  login process was initiated.Since 
> function specific initialization was still in  progress this lead to kernel panic.
>  The reson was MCCQ was not yet created and login Mbx_Cmd was sent on MCCQ.
>  wrb_from_mccq() failed with kernel-panic access.
> 
>  In the fix checking in alloc_mcc_tag() if driver initialization is complete or not.
>  Based on the result driver continues or return with an Error.
> 
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 8 ++++++++  
> drivers/scsi/be2iscsi/be_main.c | 2 ++  
> drivers/scsi/be2iscsi/be_main.h | 1 +
>  3 files changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c 
> b/drivers/scsi/be2iscsi/be_cmds.c index 1432ed5..4cabf5f 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -118,6 +118,14 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba 
> *phba)  {
>  	unsigned int tag = 0;
>  
> +
> +	if (phba->state & BE_ADAPTER_INIT_PHASE) {
> +		beiscsi_log(phba, KERN_ERR,
> +			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> +			    "BC_%d : Driver Initialization still in progress\n");
> +		return tag;
> +	}
> +

>I think normally we do not call scsi_host_add and expose the host until the driver can handle requests from entry points like sysfs and queuecommand.

>Can you just move iscsi_host_add from beiscsi_hba_alloc to beiscsi_dev_probe after beiscsi_setup_boot_info is called?

Tried moving iscsi_add_host and it did not help the issue where the ep_connect was being called before the probe is completed.

Chris Leech has a solution for this and when applied along with this patch works for us.


