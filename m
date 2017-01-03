From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthru commands
Date: Tue, 3 Jan 2017 15:46:48 -0500
Message-ID: <bd5a8849-e533-7d27-750b-0d89b8918c22@akamai.com>
References: <20161229080250.GA11605@infradead.org>
 <1483226343.2518.32.camel@linux.vnet.ibm.com>
 <1483280506.5512.1.camel@sandisk.com>
 <20170101.113311.417107391370623850.davem@davemloft.net>
 <1483292364.2345.5.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([23.79.238.175]:62143 "EHLO
        prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933948AbdACUrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2017 15:47:11 -0500
In-Reply-To: <1483292364.2345.5.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>, Bart.VanAssche@sandisk.com
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, sagi@grimberg.me, sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org, hch@lst.de, Sreekanth.Reddy@broadcom.com, chaitra.basappa@broadcom.com, dledford@redhat.com

On 01/01/2017 12:39 PM, James Bottomley wrote:
> On Sun, 2017-01-01 at 11:33 -0500, David Miller wrote:
>> From: Bart Van Assche <Bart.VanAssche@sandisk.com>
>> Date: Sun, 1 Jan 2017 14:22:11 +0000
>>
>>> My recommendation is to revert commit 18f6084a989b ("scsi: mpt3sas: Fix
>>> secure erase premature termination"). Since the mpt3sas driver uses the
>>> single-queue approach and since the SCSI core unlocks the block layer
>>> request queue lock before the .queuecommand callback function is called,
>>> multiple threads can execute that callback function (scsih_qcmd() in this
>>> case) simultaneously. This means that using scsi_internal_device_block()
>>> from inside .queuecommand to serialize SCSI command execution is wrong.
>>
>> But this causes a regression for the thing being fixed by that
>> commit.
>
> Right, we don't do that; that's why I didn't list it as one of the
> options.
>
>> Why don't we figure out what that semantics that commit was trying to
>> achieve and implement that properly?
>
> Now that I look at the reviews, each of the reviewers said what the
> correct thing to do was: return SAM_STAT_BUSY if SATL commands are
> outstanding like the spec says.  You all get negative brownie points
> for not insisting on a rework.
>
> Does this patch (compile tested only) fix the problems for everyone?
>

Hi,

Yes, with this patch applied my system boots :)

...

> @@ -4083,6 +4077,16 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
>  		return 0;
>  	}
>
> +	/*
> +	 * Bug work around for firmware SATL handling
> +	 */
> +	if (sas_device_priv_data->ata_command_pending) {
> +		scmd->result = SAM_STAT_BUSY;
> +		scmd->scsi_done(scmd);
> +		return 0;
> +	}
> +	set_satl_pending(scmd, true);
> +
>  	sas_target_priv_data = sas_device_priv_data->sas_target;
>
>  	/* invalid device handle */


I was also wondering if 2 threads could both fall through and do:
'set_satl_pending(scmd, true)'; ?

Afaict there is nothing preventing that race?

Thanks,

-Jason

