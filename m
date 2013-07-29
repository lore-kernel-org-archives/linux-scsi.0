From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Mon, 29 Jul 2013 08:08:09 -0600
Message-ID: <51F67749.3070606@kernel.dk>
References: <1374248000.2266.20.camel@dabdike> <1374267684.7397.1058.camel@haakon3.risingtidesystems.com> <1374296162.7397.1098.camel@haakon3.risingtidesystems.com> <20130722150359.GA16564@dhcp-26-207.brq.redhat.com> <1374527436.7397.1145.camel@haakon3.risingtidesystems.com> <20130725101641.GB31994@dhcp-26-207.brq.redhat.com> <1374790082.7397.1411.camel@haakon3.risingtidesystems.com> <20130726020928.GL29296@kernel.dk> <1374873276.7397.1512.camel@haakon3.risingtidesystems.com> <1374885793.7397.1537.camel@haakon3.risingtidesystems.com> <20130729111827.GA14283@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130729111827.GA14283@dhcp-26-207.brq.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/29/2013 05:18 AM, Alexander Gordeev wrote:
>> -static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
>> +static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap,
>> +                                        struct scsi_cmnd *sc)
>>  {
>>         struct ata_queued_cmd *qc = NULL;
>> -       unsigned int i;
>> +       struct request *rq = sc->request;
>>  
>>         /* no command while frozen */
>>         if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
>>                 return NULL;
>>  
>> -       /* the last tag is reserved for internal command. */
>> -       for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
> 
> blk-mq does not prevent tag ATA_TAG_INTERNAL from being using. Would it make
> sense to promote queue depth of length (ATA_MAX_QUEUE - 1) while always
> pointing ATA_TAG_INTERNAL to qcmd (see below)?

blk-mq does support a number of reserved tags, information just needs to
be passed in appropriately. So there is support for reserving X number
of error handling / emergency tags.

-- 
Jens Axboe

