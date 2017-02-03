From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCHv2 0/6] sanitize sg
Date: Fri, 3 Feb 2017 13:52:51 +0100
Message-ID: <f0d314c9-6728-5651-1b69-25c74a454522@suse.de>
References: <1486124305-104141-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752385AbdBCMwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 07:52:55 -0500
In-Reply-To: <1486124305-104141-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On 02/03/2017 01:18 PM, Hannes Reinecke wrote:
> Hi all,
>
> the infamous syzkaller incovered some more issues in the sg driver.
> This patchset fixes those two issues (and adds a fix for yet another
> potential issue; checking for a NULL dxferp when dxfer_len is not 0).
> It also removes handling of the SET_FORCE_LOW_DMA ioctl, which never
> worked since the initial git checkin. And does some code cleanup by
> removing the private list implementation, using standard lists instead.
>
> As usual, comments and reviews are welcome.
>
> Changes to v1:
> - Include reviews from Christoph
> - Add patch to close race condition in sg_remove_sfp_usercontext()
> - Remove stale variable 'save_scat_len'
>
> Hannes Reinecke (5):
>    sg: disable SET_FORCE_LOW_DMA
>    sg: remove 'save_scat_len'
>    sg: protect accesses to 'reserved' page array
>    sg: use standard lists for sg_requests
>    sg: close race condition in sg_remove_sfp_usercontext()
>
> Johannes Thumshirn (1):
>    sg: check for valid direction before starting the request
>
>   drivers/scsi/sg.c | 284 +++++++++++++++++++++++++++---------------------------
>   include/scsi/sg.h |   1 -
>   2 files changed, 141 insertions(+), 144 deletions(-)
>

For the whole series
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>

(sg_inq not broken, sg_turs not broken, syzcaller bug on fixed  and 
syzcaller use-after-free fixed, no additional messages in dmesg with a 
KASAN and LOCKDEP enabled kernel)


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
