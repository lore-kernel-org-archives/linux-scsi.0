From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH 1/1] cciss: scsi error handling
Date: Fri, 11 Nov 2005 13:38:47 -0600
Message-ID: <45B36A38D959B44CB032DA427A6E10640A7A540D@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750820AbVKKTit@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:

> Two comments:
>
> 1) CONFIG_CISS_SCSI_TAPE should be CONFIG_CCISS_SCSI_TAPE, IMO
>
> 2) is any locking needed in your scsi eh reset handlers?  recent 
> kernels eliminate the lock that's been traditionally held around 
> the handlers.

About the locking first,

So, there's one part that I was a little worried about, where
it does this in a couple places:

        c = (ctlr_info_t **) &scsicmd->device->host->hostdata[0];

(gets our adapter structure by following pointers in the scsi
command)

So, if that pointer chain can change suddenly, then my code is bad.

Can doing "echo scsi remove-single-device . . . > /proc/scsi/scsi"
cause that pointer chain to break?  I noticed I can yank a disk
out from under a mounted filesystem with 
"echo scsi remove-single-device"  It wasn't obvious to me whether
doing that would affect that pointer chain though, though I could
imagine it might.

Or am I barking up the wrong tree worrying about 
the scsicmd->device->host->hostdata pointer chain
getting yanked out from under me?

Apart from possibly the two places where I do that, 
I think it's ok.

About the CONFIG_CISS_SCSI_TAPE, we can change that, although
it's been that way for years, and was following the 
BLK_CPQ_CISS_DA which was there since the drivers inception.
Does it unnecessarily break people's existing .config files?
(not badly of course.)

-- steve

-----Original Message-----
From: Jeff Garzik [mailto:jgarzik@pobox.com]
Sent: Fri 11/11/2005 5:36 AM
To: Miller, Mike (OS Dev)
Cc: axboe@suse.de; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Cameron, Steve
Subject: Re: [PATCH 1/1] cciss: scsi error handling
 
mike.miller@hp.com wrote:
> PATCH 1 of 1
> 
> This patch adds SCSI error handling code to the SCSI portion 
> of the cciss driver.
> 
> Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
> Acked-by: Mike Miller <mike.miller@hp.com>

> +#ifdef CONFIG_CISS_SCSI_TAPE

Two comments:

1) CONFIG_CISS_SCSI_TAPE should be CONFIG_CCISS_SCSI_TAPE, IMO

2) is any locking needed in your scsi eh reset handlers?  recent kernels 
eliminate the lock that's been traditionally held around the handlers.

	Jeff
