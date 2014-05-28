From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCHv2 0/5] Support 64-bit LUNs
Date: Wed, 28 May 2014 16:30:11 -0400
Message-ID: <1401309011.3813.212.camel@localhost.localdomain>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaE1Uan (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 16:30:43 -0400
In-Reply-To: <1400583791-123120-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On Tue, 2014-05-20 at 13:03 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> this patchset updates the SCSI stack to support full 64-bit LUNs.
> The first patch is a simple fix; the next patch updates
> the sequential scan logic to be compliant with SPC.
> The third patch addresses a firmware issue with earlier
> qla2xxx HBAs.
> The last two patches update the SCSI stack and all drivers
> to use 64-bit LUNs where appropriate.
> 
> Two drivers have issues with 64bit LUNs:
> - The qla2xxx driver uses a 32-bit LUN value for TMFs.
>   But as the driver uses a max_lun value from 0xFFFF
>   we should be safe for the time being.
> - The zfcp driver uses a 32-bit LUN for debug records; the
>   record format would need to be updated to cope with
>   64-bit LUNs. But again, this driver uses 0xFFFFFFFF
>   for max_lun, so it doesn't do any harm.
> 
> The other changes have been pretty straightforward.
> 
...

So, the patches look like they will work fine...  I think we
should make sure the comments/documentation match the code, though.

For example:
  - Remove this reference in Documentation/scsi/tmscsim.txt:

  "The default for LUN Check depends on CONFIG_SCSI_MULTI_LUN."

  - include/scsi/scsi_host.h comment needs adjusting due to
    fields moved in struct Scsi_Host:

        /*                                                                                                                                                                                                         
         * These three parameters can be used to allow for wide
scsi,                                                                                                                                              
         * and for host adapters that support multiple
busses                                                                                                                                                      
         * The first two should be set to 1 more than the actual max
id                                                                                                                                            
         * or lun (e.g. 8 for SCSI parallel
systems).                                                                                                                                                              
         */
        unsigned int max_channel;
        unsigned int max_id;
        u64 max_lun;

  - int_to_scsilun() and scsilun_to_int() no longer take/return an int.
    Yes, the names are exported and that is a pain but it seems to me
    that this is just asking for an inadvertent truncation of the value.
    Also, the following comment is no longer true:

 *     Note: the scsilun_to_int() routine does not truly handle
all                                                                                                                                                
 *     8bytes of the lun value. This functions restores only as
much                                                                                                                                               
 *     as was set by the routine.          

So, is ibmvfc the only driver that actually supports a LUN value that is
>32 bits?  Or do we have other drivers that are ready to use this?

Regardless, I think we should move forward with these changes.
My concerns could easily be addressed with a subsequent patch.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>






                                         


