From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Try READ CAPACITY 16 first for all SCSI-3 devices
Date: Tue, 27 Jan 2009 19:36:24 +0000
Message-ID: <1233084984.3231.94.camel@localhost.localdomain>
References: <20081223164703.GB19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37764 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755204AbZA0TgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 14:36:25 -0500
In-Reply-To: <20081223164703.GB19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-12-23 at 09:47 -0700, Matthew Wilcox wrote:
> New features are being added to the READ CAPACITY 16 results, so we want
> to try to issue it in preference to READ CAPACITY 10.  Unfortunately,
> some USB devices hang when they see a READ CAPACITY 16, so we limit
> our chances of causing a hang by restricting this command to devices
> which claim conformance to SCSI-3.  USB devices are currently limited
> to claiming at most SCSI-2 conformance.
> 
> Of course, it's entirely legitimate for devices to not implement READ
> CAPACITY 16, so this patch also includes a fallback to READ CAPACITY 10
> for SCSI-3 devices.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> ---
>  drivers/scsi/sd.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f244349..25a923b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1424,11 +1424,14 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
>  	int sector_size;
>  	struct scsi_device *sdp = sdkp->device;
>  
> -	/* Force READ CAPACITY(16) when PROTECT=1 */
> -	if (scsi_device_protection(sdp)) {
> +	if (sdp->scsi_level > SCSI_2) {

Were you going to update this?  Martin Petersen already found an early
SCSI-3 device that crashes upon receiving Read Capacity(16).

James


