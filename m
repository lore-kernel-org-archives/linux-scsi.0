From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 12/32] cxlflash: Fix to avoid spamming the kernel log
Date: Tue, 29 Sep 2015 15:37:00 -0500
Message-ID: <607D0508-883D-4CF3-8843-5853A376ED38@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222936-9385-1-git-send-email-mrochs@linux.vnet.ibm.com> <560A1C33.8040709@au1.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:45145 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbI2Ujw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 16:39:52 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 29 Sep 2015 14:37:19 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 796CE19D8048
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 14:27:56 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8TKa8f25833136
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 13:36:08 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8TKb2X7029267
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 14:37:04 -0600
In-Reply-To: <560A1C33.8040709@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 29, 2015, at 12:05 AM, Andrew Donnellan <andrew.donnellan@au1.ibm.com> wrote:
> On 26/09/15 09:15, Matthew R. Ochs wrote:
>> During run-time the driver can be very chatty and spam the system
>> kernel log. Various print statements can be limited and/or moved
>> to development-only mode. Additionally, numerous prints can be
>> converted to trace the corresponding device.
>> 
>> The following changes were made:
>>  - pr_debug to pr_devel
>>  - pr_debug to pr_debug_ratelimited
>>  - pr_err to dev_err
>>  - pr_debug to dev_dbg
>> 
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
> 
> Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> 
> Changes mostly look fine, further comments below.
> 
>> --- a/drivers/scsi/cxlflash/main.c
>> +++ b/drivers/scsi/cxlflash/main.c
>> @@ -58,8 +58,8 @@ static struct afu_cmd *cmd_checkout(struct afu *afu)
>>  		cmd = &afu->cmd[k];
>> 
>>  		if (!atomic_dec_if_positive(&cmd->free)) {
>> -			pr_debug("%s: returning found index=%d\n",
>> -				 __func__, cmd->slot);
>> +			pr_devel("%s: returning found index=%d cmd=%p\n",
>> +				 __func__, cmd->slot, cmd);
> 
>>  	pr_debug("%s: cmd failed afu_rc=%d scsi_rc=%d fc_rc=%d "
>> -		 "afu_extra=0x%X, scsi_entra=0x%X, fc_extra=0x%X\n",
>> +		 "afu_extra=0x%X, scsi_extra=0x%X, fc_extra=0x%X\n",
>>  		 __func__, ioasa->rc.afu_rc, ioasa->rc.scsi_rc,
>>  		 ioasa->rc.fc_rc, ioasa->afu_extra, ioasa->scsi_extra,
>>  		 ioasa->fc_extra);
> 
> Minor nitpicking: mention that you fix these in the commit message.

Noted for the future.

>> @@ -240,9 +240,9 @@ static void cmd_complete(struct afu_cmd *cmd)
>>  		cmd_is_tmf = cmd->cmd_tmf;
>>  		cmd_checkin(cmd); /* Don't use cmd after here */
>> 
>> -		pr_debug("%s: calling scsi_set_resid, scp=%p "
>> -			 "result=%X resid=%d\n", __func__,
>> -			 scp, scp->result, resid);
>> +		pr_debug_ratelimited("%s: calling scsi_done scp=%p result=%X "
>> +				     "ioasc=%d\n", __func__, scp, scp->result,
>> +				     cmd->sa.ioasc);
>> 
>>  		scsi_set_resid(scp, resid);
>>  		scsi_dma_unmap(scp);
> 
> Why has the message changed from scsi_set_resid to scsi_done, and should the message be moved to immediately before the scsi_done call?

In a later patch in the series the scsi_set_resid() is actually moved.

