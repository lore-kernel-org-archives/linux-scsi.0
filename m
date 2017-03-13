From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv4 09/12] mpt3sas: simplify task management functions
Date: Mon, 13 Mar 2017 16:15:05 +0100
Message-ID: <d7a9b006-2c03-f404-c554-caa2b4ed32c1@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
 <1487759512-3873-10-git-send-email-hare@suse.de>
 <CAK=zhgo5WrsDjRVAHFotAj+CX6SWNuNjVoYgX9io-KPWfAjugQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751361AbdCMPPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 11:15:12 -0400
In-Reply-To: <CAK=zhgo5WrsDjRVAHFotAj+CX6SWNuNjVoYgX9io-KPWfAjugQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 03/06/2017 06:16 AM, Sreekanth Reddy wrote:
> I feel that using these flags are not working as expected. From the
> driver's prospective it should return status of the TM based on
> whether it has cleared reference of the timed out IO in the driver or
> not (i.e. if it is successfully able to clear the reference (i.e.
> cleared from scsi lookup) of the timed out IO from driver, firmware
> then return success status otherwise return failure status). It should
> not check for it's above layer reference.
> 
Looking into it you are actually right.

The SCSI midlayer will only decrease a 'device_busy' and the like if the
commands are completed, ie after ->scsi_done() has been called.
But the whole point of the error handler OTOH is that ->scsi_done() is
_not_ called, but rather the commands are left alone until SCSI EH
completed, and only _then_ calling ->scsi_done().

Hence 'device_busy' et al trivially can never be zero while SCSI EH is
running.

I'll be rewriting that for the next submission.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
