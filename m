From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 3/3] cxlflash: Virtual LUN support
Date: Wed, 12 Aug 2015 15:00:54 -0500
Message-ID: <55CBA5F6.8060603@linux.vnet.ibm.com>
References: <1439226594-7944-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439290473.28873.3.camel@neuling.org>	 <55CA71FB.7090705@linux.vnet.ibm.com> <1439349851.28873.48.camel@neuling.org>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:38271 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbbHLUBD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 16:01:03 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Wed, 12 Aug 2015 14:01:03 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id C69983E4003F
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 14:01:00 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7CK0MY325165864
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 13:00:22 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7CK0vK5011006
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 14:01:00 -0600
In-Reply-To: <1439349851.28873.48.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

Mikey:

Comments inline below.

- Manoj Kumar

On 8/11/2015 10:24 PM, Michael Neuling wrote:

>> The ioctls have a standard header structure, with version etc. that are
>> sanity checked before we get here. The other fields are sanity checked
>> where they are used, i.e. in get_context().
>
> That was my point.  Let's do it upfront so it's clear they've been
> checked.

Thanks for clarifying. We are going to sanity check the common header
portions up front. The others that are specific to the ioctl, will be
checked prior to use in each ioctl handler.


>>> Virt has not been sanity checked.  So now resize can contain bad data.
>>>
>>>
>>>> +	resize.rsrc_handle = rsrc_handle;
>>
>> Same as above. As mentioned earlier, the size is immaterial. The rest of
>> the parameters are set here (rsrc_handle).
>
> Humm.
>

Same as above.

>>>> +#define LXT_LUNIDX_SHIFT  8	/* LXT entry, shift for LUN index */
>>>> +#define LXT_PERM_SHIFT    4	/* LXT entry, shift for permission bits */
>>>
>>> What is LXT?
>>
>> LXT = lun translation table. There is one LXT entry per set of
>> contiguous blocks for a virtual LUN (known both to the host and to the
>> AFU). Will clarify this with inline comments.
>
> Please document this acronym before using it.

Good point. Will add a comment clarifying what an LXT is.



