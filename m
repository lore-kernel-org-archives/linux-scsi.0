From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
Date: Wed, 25 Jul 2012 11:41:11 +0200
Message-ID: <500FBF37.50603@redhat.com>
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <500FBAE8.2050107@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 25/07/2012 11:22, Boaz Harrosh ha scritto:
>>> >>  	for_each_sg(table->sgl, sg_elem, table->nents, i)
>>> >> -		sg_set_buf(&sg[idx++], sg_virt(sg_elem), sg_elem->length);
>>> >> +		sg_set_page(&sg[idx++], sg_page(sg_elem), sg_elem->length,
>>> >> +			sg_elem->offset);
>> > 
>> > This can simply be
>> > 
>> >    sg[idx++] = *sg_elem;
>> > 
>> > Can you repost it with this change, and also add stable@vger.kernel.org
>> > to the Cc?  Thanks very much!
>> > 
> 
> No! Please use sg_set_page()! Look at sg_set_page(), which calls sg_assign_page().
> It has all these jump over chained arrays. When you'll start using long
> sg_lists (which you should) then jumping from chain to chain must go through
> sg_page(sg_elem) && sg_assign_page(), As in the original patch.

Hi Boaz,

actually it seems to me that using sg_set_page is wrong, because it will
not copy the end marker from table->sgl to sg[].  If something chained
the sg[] scatterlist onto something else, sg_next's test for sg_is_last
would go beyond the table->nents-th item and access invalid memory.

Using chained sglists is on my to-do list, I expect that it would make a
nice performance improvement.  However, I was a bit confused as to
what's the plan there; there is hardly any user, and many arches still
do not define ARCH_HAS_SG_CHAIN.  Do you have any pointer to discussions
or LWN articles?

I would need to add support for the long sglists to virtio; this is not
a problem, but in the past Rusty complained that long sg-lists are not
well suited to virtio (which would like to add elements not just at the
beginning of a given sglist, but also at the end).  It seems to me that
virtio would prefer to work with a struct scatterlist ** rather than a
long sglist.

Paolo
