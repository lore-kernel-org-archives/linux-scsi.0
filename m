From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] mpt3sas: Use driver scsi lookup to track outstanding IOs
Date: Mon, 25 Feb 2019 18:25:01 +0100
Message-ID: <8fa0a2ac-dcf7-d4fb-fbfe-0e858fc3c453@suse.de>
References: <1550577766-40425-1-git-send-email-sreekanth.reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1550577766-40425-1-git-send-email-sreekanth.reddy@broadcom.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, suganath-prabu.subramani@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2/19/19 1:02 PM, Sreekanth Reddy wrote:
> Use driver's scsiio lookup table to track outstanding IOs at driver level,
> 
> Have done following changes in this patch,
> * Allocated & initialized scsi_lookup table of type
>    (struct scsiio_tracker) and of depth host's can_queue at driver load time
>    and it will be deallocated at driver unload time.
> 
> * Once scmd is receieved, driver will take scsiio_tracker at entry
>    corresponding to scmd's tag value from scsi_lookup table. Then this
>    scsiio_tracker entry is initialized with proper smid, scmd, cb_idx etc.
>    And this scsiio_tracker entry contents are cleared before driver
>    calling scsi_done callback function.
> 
> * scmd's host_scribble variable is used to save the corresponding
>    scsiio_tracker address, later at any time driver can easily retrieve the
>    scmd's corresponding scsiio_tacker using this host_scribble variable.
> 
> * Whenever driver wants to get the outstanding IOs at the driver level
>    then driver can go through this scsi_lookup table and if it observe
>    any entry with non-null scmd then it means that scmd is outstanding
>    at the driver level.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---

What is the reason for this change?
The description only states _what_ you are doing, not why.
Care to elaborate?

Cheers,

Hannes
