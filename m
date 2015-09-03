From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv3] Update scsi host to use ida for host number
Date: Thu, 3 Sep 2015 09:06:41 -0700
Message-ID: <55E87011.2030401@suse.com>
References: <1441152208-20634-1-git-send-email-lduncan@suse.com>
 <20150902064830.GA17978@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46013 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755579AbbICQGy (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Thu, 3 Sep 2015 12:06:54 -0400
In-Reply-To: <20150902064830.GA17978@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, hare@suse.com, jthumshirn@suse.de

On 09/01/2015 11:48 PM, Christoph Hellwig wrote:
> On Tue, Sep 01, 2015 at 05:03:28PM -0700, Lee Duncan wrote:
>> +static int host_get_index(int *index)
>> +{
>> +	int error = -ENOMEM;
>> +
>> +	do {
>> +		if (!ida_pre_get(&host_index_ida, GFP_KERNEL))
>> +			break;
>> +		spin_lock(&host_index_lock);
>> +		error = ida_get_new(&host_index_ida, index);
>> +		spin_unlock(&host_index_lock);
>> +	} while (error == -EAGAIN);
>> +
>> +	return error;
>> +}
>> +
>> +static inline void host_put_index(int index)
>> +{
>> +	spin_lock(&host_index_lock);
>> +	ida_remove(&host_index_ida, index);
>> +	spin_unlock(&host_index_lock);
>> +}
> 
> I really hate how this pattern (and the equivalent for IDA) are
> spread all over.  Any chance to have some simple_ida/simple_idr helpers
> instead of duplicating it again an again.
> 
> Besides that why aren't we using and idr here and use it for host lookup
> as well?
> .
> 

Good question. My original goal was just to fix the host_no wrap-around
problem, but I agree, the hosts.c module could benefit from using idr,
making scsi_host_lookup(hostnum) much simpler, and possible faster.

I will submit another patch.

This means I won't need the sequence any longer that you wanted made
into helper functions, though I'd still be glad to create the helper
functions and convert some of the ida users, if you wish.
-- 
Lee Duncan

