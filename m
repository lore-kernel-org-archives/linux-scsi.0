From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 3/5] nvme-fabrics: Add host FC transport support
Date: Mon, 22 Aug 2016 10:24:39 -0700
Message-ID: <892d8974-2fc9-7fac-fda5-b7c628b17906@broadcom.com>
References: <5792b91d.bp8ih+rK5Jet+Cpn%james.smart@broadcom.com>
 <20160811211652.GF18013@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33936 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932233AbcHVRYl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 13:24:41 -0400
Received: by mail-pf0-f179.google.com with SMTP id p64so34356604pfb.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 10:24:41 -0700 (PDT)
In-Reply-To: <20160811211652.GF18013@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


> Are you going to send a FC support patch for nvme-cli as well?

I will, but concentrating on core support for now. I expect a fair 
number of things need to be done in the cli.


>
>> +	assoc_rqst->assoc_cmd.ersp_ratio = cpu_to_be16(ersp_ratio);
>> +	assoc_rqst->assoc_cmd.sqsize = cpu_to_be16(qsize);
>> +	/* TODO:
>> +	 * assoc_rqst->assoc_cmd.cntlid = cpu_to_be16(?);
>> +	 * strncpy(assoc_rqst->assoc_cmd.hostid, ?,
>> +	 *	min(FCNVME_ASSOC_HOSTID_LEN, NVMF_NQN_SIZE));
>> +	 * strncpy(assoc_rqst->assoc_cmd.hostnqn, ?,
>> +	 *	min(FCNVME_ASSOC_HOSTNQN_LEN, NVMF_NQN_SIZE];
>> +	 */
> What is the problem with filling all these out based on the information
> in the nvme_host structure?

Well, I want to get them from the same place that the fabrics routines 
do when they build a capsule. So they should come from the opts struct. 
It's missing the controller id, so I'll need to address that.


>
> This probably needs to be moved, similar to the patch Sagi just
> did for RDMA.  In general it might be a good idea to look at the
> various recent RDMA changes and check if they need to be brought over.

yeah - I typically do a resync every time I repost.


>
>> +	/*
>> +	 * TODO: blk_integrity_rq(rq)  for DIX
>> +	 */
> We'll hopefully be able to just move the DIX handling to common code.
> Any help appreciated..

Yes and no....    and likely a separate discussion.  If DIF is passed, 
you should involve the host port to validate on egress as well has what 
the target controller will do. Although it brings up some headaches if 
the host detects an error (e.g. protocol requires target to be part of 
it).  If DIF is inserted, the question will be whether you want to 
insert DIF at the egress point of the host port or do you pass it over 
the fabric w/o dif and have the tgt controller insert it.  I assume 
we'll need to talk more.

>
> This seems to miss reference counting on the lport and rport structure.
yes - an area of weakness right now.

> It would be good to sort this out before merging. 

I'll make a pass at it.

-- james


