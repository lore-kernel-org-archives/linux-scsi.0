From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 1/2] target: Add transport_handle_cdb_direct	optimization
Date: Thu, 16 Jun 2011 12:13:26 -0700
Message-ID: <4DFA55D6.8090101@redhat.com>
References: <1307167290-24832-1-git-send-email-nab@linux-iscsi.org> <1307167290-24832-2-git-send-email-nab@linux-iscsi.org> <20110604140308.GB13359@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab1FPTNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 15:13:31 -0400
In-Reply-To: <20110604140308.GB13359@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 06/04/2011 07:03 AM, Christoph Hellwig wrote:
>> + */
>> +int transport_handle_cdb_direct(
>> +	struct se_cmd *cmd)
>> +{
>> +	if (!cmd->se_lun) {
>> +		dump_stack();
>> +		printk(KERN_ERR "cmd->se_lun is NULL\n");
>> +		return -EINVAL;
>> +	}
>> +	if (in_interrupt()) {
>> +		dump_stack();
>> +		printk(KERN_ERR "transport_generic_handle_cdb cannot be called"
>> +				" from interrupt context\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return transport_generic_new_cmd(cmd);
> 
> I can't really see any reason to add this helper.  It just adds rather
> pointless debug checks for cases that already will blow up "properly" with
> the current code.  Let's keep the callchain lean and just leave it out.

I agree. Also, I don't think there should be a handle_cdb_direct because
I think handle_cdb should call transport_generic_new_cmd, we don't need
a "direct" version. transport_generic_new_cmd should be safe (or made
safe) for calling from interrupt context. There's nothing in it that
demands it be executed in the backstore thread's context, and doing so
just incurs a two context switch latency penalty.

Regards -- Andy
