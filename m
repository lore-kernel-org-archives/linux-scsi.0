From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND 2/5] kexec: Export kexec_in_progress
Date: Mon, 08 Dec 2014 15:13:51 -0600
Message-ID: <5486148F.6020208@linux.vnet.ibm.com>
References: <201412021847.sB2Ilfvc002145@d01av04.pok.ibm.com> <547E09B7.7030507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53732 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaLHVN6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2014 16:13:58 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 8 Dec 2014 14:13:57 -0700
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0BDE819D803F
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2014 14:02:35 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB8LEa2L48693492
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2014 14:14:36 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB8LDrX5000653
	for <linux-scsi@vger.kernel.org>; Mon, 8 Dec 2014 14:13:54 -0700
In-Reply-To: <547E09B7.7030507@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ebiederm@xmission.com
Cc: James.Bottomley@HansenPartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, anton@samba.org, kexec@lists.infradead.org

On 12/02/2014 12:49 PM, Brian King wrote:
> On 12/02/2014 12:47 PM, Brian King wrote:
>> A kexec boot for some ipr SAS adapters was seen to take ~20 seconds
>> just doing ipr adapter initialization. This is due to the fact that
>> a kexec invokes the driver's shutdown handler which places the adapter
>> into a state that requires a hard reset and resulting firmware initialization
>> to be usable again, which takes significant time. By exporting kexec_in_progress,
>> this process can be optimized significantly in the driver by essentially
>> placing the adapter into a state where this hardware reset and re-initialization
>> can be bypassed, eliminating this delay in kexec boot.
>>
>> Cc: Eric Biederman <ebiederm@xmission.com>
>> Cc: kexec <kexec@lists.infradead.org>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/kexec.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
>> --- scsi-queue/kernel/kexec.c~kexec_export_in_prog	2014-12-02 12:13:22.820325731 -0600
>> +++ scsi-queue-bjking1/kernel/kexec.c	2014-12-02 12:13:22.825325687 -0600
>> @@ -2768,3 +2768,5 @@ int kernel_kexec(void)
>>  	mutex_unlock(&kexec_mutex);
>>  	return error;
>>  }
>> +
>> +EXPORT_SYMBOL_GPL(kexec_in_progress);
>> _
>>
> 
> Eric,
> 
> Can I get your ack on this so this can go through the scsi tree? The last time I sent this
> out you had some issues with the patch description.

Eric - can I get your ack here?

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


