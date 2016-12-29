From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Thu, 29 Dec 2016 11:02:58 -0500
Message-ID: <c67108d8-8aee-012d-047f-96267b289071@akamai.com>
References: <1482985824-7270-1-git-send-email-jbaron@akamai.com>
 <20161229080250.GA11605@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161229080250.GA11605@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, James Bottomley <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On 12/29/2016 03:02 AM, Christoph Hellwig wrote:

> On Wed, Dec 28, 2016 at 11:30:24PM -0500, Jason Baron wrote:
>> Add a new parameter to scsi_internal_device_block() to decide whether
>> or not to invoke scsi_wait_for_queuecommand().
> We'll also need to deal with the blk-mq wait path that Bart has been
> working on (I think it's already in the scsi tree, but I'd have to
> check).
Ok, I'm not sure either.

> Also adding a bool flag for the last call in a function is style that's
> a little annoying.
>
> I'd prefer to add a scsi_internal_device_block_nowait that contains
> all the code except for the waiting, and then make
> scsi_internal_device_block_nowait a wrapper around it.  Or drop the
> annoying internal for both while we're at it :)

The proposed patch brings the code in-line with what is in 4.8 stable
where scsi_internal_device_block() does not call
scsi_wait_for_queuecommand(). So I saw it as a minimal fix to make
my system boot again :)

I was wondering if the original fix is racy in that there could be multiple
threads in the queuecommand. Perhaps we should do something like:
       
    if (ata_12_16_cmd(scmd))
{                                                                                                                                   

                if (!test_and_set_bit(MPT_DEVICE_EXCLUSIVE,
&sas_device_priv_data->flags))
{                                                                         
                       
scsi_internal_device_block(scmd->device);                                                                                                    

                }
else                                                                                                                                               

                        return
SCSI_MLQUEUE_HOST_BUSY;                                                                                                               

        }        

where scsi_internal_device_block() could be taught to wait for
request_fn_active becoming 1 instead of 0.

Thanks,

-Jason
