From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: FW: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Mon, 22 Mar 2010 16:45:43 -0500
Message-ID: <4BA7E507.1010605@cs.wisc.edu>
References: <20100319224835.GA31748@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40868 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756259Ab0CVVmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2010 17:42:08 -0400
In-Reply-To: <20100319224835.GA31748@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: fujita.tomonori@lab.ntt.co.jp, jayamohank@serverengines.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, open-iscsi@googlegroups.com

On 03/19/2010 05:48 PM, Ravi Anand wrote:
>> On Thu, 18 Mar 2010 16:02:52 -0500
>> Mike Christie<michaelc@cs.wisc.edu>  wrote:
>>
>>> On 03/18/2010 08:58 AM, FUJITA Tomonori wrote:
>>>>
>>>> - You invent your hardware specific data structure for the simplest
>>>>     operation such as setting IP address.
>>>
>>> I think this is what Jay is not trying to do. I think the patch has some
>>> extra code like the ISCSI_BSG_HST_VENDOR parts that makes it confusing -
>>> it got me too. The ISCSI_BSG_HST_VENDOR code in be2iscsi looks like it
>>> is basically disabled (should remove for a formal patch when he sends
>>> for merging).
>>>
>>> It looks like there is a common struct iscsi_bsg_common_format that is
>>> getting passed around, and then in be2iscsi the driver is using that
>>> info to make a be2iscsi specific command. So scsi_transport_iscsi /
>>> ISCSI_SET_IP_ADDR / iscsi_bsg_common_format  gets translated by b2iscsi
>>> to b2iscsi / OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR / be_modify_ip_addr.
>>
>> Yeah, seems you are right. But looks like this patchset also adds the
>> vendor specific message support (ISCSI_BSG_HST_VENDOR)?
>>
.......

> Here's an early snapshot of the patch which we are working on to add
> the support using bsg vendor specific part - btw this is based on the previous
> iscsi bsg patch  and need to be synced up with what was posted recently.

Just to make sure we are all on the same page. Tomo's comments above 
means that for your comment about updating to the new code does not mean 
that you should just use the new HST_VENDOR cmd, and it does not mean 
that we only should use a common struct/cmd for net operations that Jay 
handled.

For other common operations we should do like Tomo suggested, and Jay 
started with the network stuff, and make common operations. You guys 
should also not feel like you have to use the format Jay posted with. We 
can modify it so it make sense for everyone.


> +	switch (msgcode) {
> +	case ISCSI_BSG_HST_VENDOR:
> +		rval = qla4xxx_process_vendor_specific(job);
> +		break;
> +	case ISCSI_BSG_HST_PING:
> +		rval = qla4xxx_ping(job);
> +		break;
> +	default:
> +		break;
> +	}
> +
