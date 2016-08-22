From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 4/5] nvme-fabrics: Add target FC transport support
Date: Mon, 22 Aug 2016 10:28:39 -0700
Message-ID: <9641de6d-1bfb-394c-d4e0-712c8ef6d740@broadcom.com>
References: <5792b91e.51+4Ind0/2MxGqHU%james.smart@broadcom.com>
 <20160811212238.GG18013@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33589 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755101AbcHVR2u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 13:28:50 -0400
Received: by mail-pf0-f171.google.com with SMTP id y134so34386994pfg.0
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 10:28:41 -0700 (PDT)
In-Reply-To: <20160811212238.GG18013@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org



On 8/11/2016 2:22 PM, Christoph Hellwig wrote:
>
>> +	queue->work_q = alloc_workqueue("ntfc%d.%d.%d", 0, 0,
>> +				assoc->tgtport->fc_target_port.port_num,
>> +				assoc->a_id, qid);
> Do we really need a workqueue per queue?

I thought we did - so there was always an execution context for the 
nvmet layer when a command is received. My understanding was the nvmet 
layer processes the cmd synchronously. I avoided per cpu - as I assumed 
the synchronous flows would end up blocking other connections to other 
subsystems/controllers.

If that's not the case - can you describe the nvmet layer better so I 
understand what we need ?


>
> No reference counting?
>

yes - will make a pass at it.

-- james

