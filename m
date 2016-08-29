From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: Oops when completing request on the wrong queue
Date: Mon, 29 Aug 2016 15:06:21 -0300
Message-ID: <87d1krzbz6.fsf@linux.vnet.ibm.com>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
        <871t1kq455.fsf@linux.vnet.ibm.com>
        <bb6f8757-4c3d-8f49-8aff-aa0fdb8bae89@kernel.dk>
        <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk>
        <87shu0hfye.fsf@linux.vnet.ibm.com>
        <87a8g39pg4.fsf@linux.vnet.ibm.com>
        <43693064-dd37-92ce-7753-2a8edb43eab5@kernel.dk>
        <164a4c63-065b-b766-36f3-bcef4aa46a38@kernel.dk>
        <49a954e6-2f96-8a63-ce15-2c82c1a1d36d@kernel.dk>
        <dbe42007-8109-2e21-d0f3-0778007cd152@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <dbe42007-8109-2e21-d0f3-0778007cd152@kernel.dk> (Jens Axboe's
        message of "Wed, 24 Aug 2016 14:36:38 -0600")
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:
>> Can you try this patch? It's not perfect, but I'll be interested if it
>> makes a difference for you.
>

Hi Jens,

Sorry for the delay.  I just got back to this and have been running your
patch on top of 4.8 without a crash for over 1 hour.  I wanna give it
more time to make sure it's running properly, though.

Let me get back to you after a few more rounds of test.

> This one should handle the WARN_ON() for running the hw queue on the
> wrong CPU as well.

On the workaround you added to prevent WARN_ON, we surely need to
prevent blk_mq_hctx_next_cpu from scheduling dead cpus in the first
place, right..  How do you feel about the following RFC?  I know it's
not a complete fix, but it feels like a good improvement to me.

http://www.spinics.net/lists/linux-scsi/msg98608.html

-- 
Gabriel Krisman Bertazi

