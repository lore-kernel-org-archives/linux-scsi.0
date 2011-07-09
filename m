From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 03/20] target: Make all control CDBs scatter-gather
Date: Fri, 08 Jul 2011 17:35:24 -0700
Message-ID: <4E17A24C.9050004@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com> <1310078011-15504-4-git-send-email-agrover@redhat.com> <20110708195755.GA12288@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab1GIAfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 20:35:30 -0400
In-Reply-To: <20110708195755.GA12288@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/08/2011 12:57 PM, Christoph Hellwig wrote:
>> @@ -4892,7 +4854,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
>>  	 * cmd->t_mem_list of struct se_mem->se_page
>>  	 */
>>  	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
>> -		ret = transport_allocate_resources(cmd);
>> +		ret = transport_generic_get_mem(cmd);
>>  		if (ret < 0)
>>  			return ret;
>>  	}
> 
> Before transport_allocate_resources used to be a no-op for
> SCF_SCSI_NON_DATA_CDB cdbs, which got lots with your patch.  Given that
> they should have a zero length your patch should be fine, but such
> subtilities would be nice to be documented in the changelog.

I'm just going to add a test to the conditional to only call get_mem if
cmd->data_length is nonzero, seems better.

-- Andy
