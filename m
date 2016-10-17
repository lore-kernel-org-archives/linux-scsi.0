From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/2] scsi: Handle Unit Attention when issuing SCSI command
Date: Mon, 17 Oct 2016 14:17:54 -0200
Message-ID: <87y41nhrv1.fsf@linux.vnet.ibm.com>
References: <1476384477-3060-1-git-send-email-krisman@linux.vnet.ibm.com>
        <1476422360.22309.29.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935057AbcJQQSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 12:18:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9HGHG2o043824
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 12:18:00 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 264yja04n7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 12:18:00 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Mon, 17 Oct 2016 14:17:57 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 9390B1DC006F
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 12:17:55 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u9HGHtW54788256
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 14:17:55 -0200
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u9HGHtjc004845
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 14:17:55 -0200
In-Reply-To: <1476422360.22309.29.camel@linux.vnet.ibm.com> (James Bottomley's
        message of "Fri, 14 Oct 2016 13:19:20 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

James Bottomley <jejb@linux.vnet.ibm.com> writes:

> On Thu, 2016-10-13 at 15:47 -0300, Gabriel Krisman Bertazi wrote:
>> @@ -210,6 +219,13 @@ int scsi_execute(struct scsi_device *sdev, const
>> unsigned char *cmd,
>>  	 */
>>  	blk_execute_rq(req->q, NULL, req, 1);
>>  
>> +	if (scsi_sense_unit_attention(sense) && req->retries > 0) {
>> +		memset(sense, 0, SCSI_SENSE_BUFFERSIZE);
>> +		retries = req->retries - 1;
>> +		blk_put_request(req);
>> +		goto retry;
>> +	}
>
> OK, so this is more theory, but I think you can actually reuse the same
> request to go around this loop without doing a get/put.  I've cc'd Jens
> to confirm, since no other driver I can find does this, but if it's
> legal, it saves freeing and reallocating the request.  You can then
> replace the goto with a do { } while (...) which makes the loop obvious
> to the next person looking at this.

Hi James,

I don't think the block layer currently has the machinery to reuse the
request.  I think it would be easy to add for the MQ case but I
don't know about SQ.  If we don't clean up or reinit the request before
re-sending, we'll hit the BUG_ON in blk_start_request:

  BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));

Do you wanna take a v3 of the patch and fix this on a future patch, or
should I be looking into patching the block layer interface?  I'll be
looking into it, but I need to get familiar with the SQ code first.

-- 
Gabriel Krisman Bertazi

