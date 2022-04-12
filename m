Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8313EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 03:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbiDLDHz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 23:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiDLDHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 23:07:54 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCC919C27
        for <linux-scsi@vger.kernel.org>; Mon, 11 Apr 2022 20:05:37 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 80FC4615F6;
        Tue, 12 Apr 2022 03:05:36 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 786AF4CA15;
        Tue, 12 Apr 2022 03:05:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id xgN7ON-nTDkD; Tue, 12 Apr 2022 03:05:36 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 6A1BD4CA14;
        Tue, 12 Apr 2022 03:05:34 +0000 (UTC)
Message-ID: <67af49ba-0d39-d0f6-b6fb-cd49dd32bbb3@interlog.com>
Date:   Mon, 11 Apr 2022 23:05:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 0/6] scsi: fix scsi_cmd::cmd_len
Reply-To: dgilbert@interlog.com
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20220410173652.313016-1-dgilbert@interlog.com>
 <20220411050325.GA13927@lst.de>
 <aa2a08cc-ba98-b538-2448-d528e8eef917@interlog.com>
 <20220411155258.GA25715@lst.de>
Content-Language: en-CA
In-Reply-To: <20220411155258.GA25715@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-04-11 11:52, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 11:06:17AM -0400, Douglas Gilbert wrote:
>> On 2022-04-11 01:03, Christoph Hellwig wrote:
>>> This still misses any good explanation of why we want all this.
>>
>> Advantages:
>>     - undoes regression in ce70fd9a551af, that is:
>>         - cdb_len > 32 no longer allowed (visible to the user space), undone
> 
> What exact regression causes this for real users and no just people
> playing around with scsi_debug?

Sorry, you are regressing something that has been in place for over
20 years and required by SPC (1 through 5) standards. The onus
should not be on me to prove that regression is not safe. It should
be the other way around (i.e. for you to prove that it is safe).

I admit that working with scsi_debug can be fun, but it seems to me a
few other people have found it a useful tool. Some football advice
might apply here: play the ball, not the man.

>>         - but we still have this one:
>>             - prior to lk5.18 sizeof(scsi_cmnd::cmnd) is that of a
>>               pointer but >= lk5.18 sizeof(scsi_cmnd::cmnd) is 32 (or 16)
> 
> Please check the total size of struct scsi_cmnd, which is what really
> matters.

 From my laptop (64 bit) where scsi_cmnd1 is the original struct scsi_cmnd:
     xtwo70 kernel: sizeof(struct scsi_cmnd)=376, sizeof(struct scsi_cmnd1)=392

So is slightly > 4% (higher on 32 bit machines) insignificant?

Since I have that measurement code in place, try a few other things ....
Changing scsi_cmnd::flags to be a u8 and putting sense_buffer and host_scribble
next to one another (they are pointers) gives:
     xtwo70 kernel: sizeof(struct scsi_cmnd)=360, sizeof(struct scsi_cmnd1)=392

Now we are at a 8% reduction.

> 
>>     - makes all scsi_cmnd objects 16 bytes smaller
> 
> Do we have data why this matters?

In commit ce70fd9a551af7424a7dace2a1ba05a7de8eae27 you wrote:

    "Now that each scsi_request is backed by a scsi_cmnd, there is no need to
     indirect the CDB storage.  Change all submitters of SCSI passthrough
     requests to store the CDB information directly in the scsi_cmnd, and while
     doing so allocate the full 32 bytes that cover all Linux supported SCSI
     hosts instead of requiring dynamic allocation for > 16 byte CDBs.  On
     64-bit systems this does not change the size of the scsi_cmnd at all, while
     on 32-bit systems it slightly increases it for now, but that increase will
     be made up by the removal of the remaining scsi_request fields."

  $ cd drivers/scsi
  $ find . -name '*.c' -exec grep "SCSI_MAX_VARLEN_CDB_SIZE" {} \; -print
	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
./iscsi_tcp.c
		shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
./cxgbi/libcxgbi.c

include/scsi/scsi_proto.h:#define SCSI_MAX_VARLEN_CDB_SIZE 260

Two examples that make your "the full 32 bytes that cover all ..." assertion
false.

Also those quoted comments seem to give weight to the argument that
writer believes that the size of scsi_cmnd matters. If so, I agree,
smaller is better.

>>     - hides the poorly named dtor for scsi_cmnd objects (blk_mq_free_request)
>>       within a more intuitively named inline: scsi_free_cmnd
> 
> I don't think this is in any way poorly named.

Seriously?

As well, having a scsi_cmnd destructor opens up the possibility of deferring
kmem_cache_free(scsi_sense_cache, cmd->sense_buffer) from scsi_mq_exit_request()
to that destructor. Then if scsi_cmnd objects are re-used,
scsi_mq_init_request() need only get a cmd->sense_buffer if one has not yet
been allocated. Again, I present no data, but pretty obviously a performance
win.


Another advantage of that patchset:
    - in scsi_initialize_rq() the patch initializes CBD to Test Unit Ready
      (6 zeros), previously it did a memset(scmd->cmnd, 0, 32), so that is
      another small win.
      That initialization could be further optimized with:
          scmd->l_cdb.dummy_tur = 0;    /* clears first 8 zeros */
          scmd->cmd_len = SCSI_TEST_UNIT_READY_CDB_LEN;
      to bypass memset() completely.


>> Disadvantages:
>>      - burdens each access to a CDB with (scsi_cmnd::flags & SCMD_LONG_CDB)
>>        check
>>      - LLDs that want to fetch 32 byte CDBs (or longer) need to use the
>>        scsi_cmnd_get_cdb() access function. For CDB lengths <= 16 bytes
>>        they can continue to access scsi_cmnd::cmnd directly
> 
> It adds back the dynamic allocation for 32-byte CDBs that we got rid of.
> It also breaks all LLDS actually using 32-byte CDBS currently as far as
> I can tell.

As Bart pointed out, the dynamic allocation for 32-byte CDBs is relatively
rare, more than made up for by the 4% reduction in struct scsi_cmnd's size.

As for the second sentence, if this patchset is accepted, I will find
and fix those. The ones I did check limited cdb_s to 16 bytes.

Doug Gilbert

