From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
Date: Sat, 12 Jul 2014 02:50:06 +0000
Message-ID: <328b7a6174ef4dd8a54a7db5ac959834@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-4-git-send-email-kys@microsoft.com>
 <20140709084300.GD6012@infradead.org>
 <a31a45eddb544024a7538458b98c3611@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404935792.2184.5.camel@dabdike.int.hansenpartnership.com>
 <2f3ae589e6f149acbe4c5dd79f905971@BY2PR03MB299.namprd03.prod.outlook.com>
 <1404944843.2184.8.camel@dabdike.int.hansenpartnership.com>
 <20140711063216.GA20660@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:13365
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752399AbaGLCuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 22:50:23 -0400
In-Reply-To: <20140711063216.GA20660@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mkp@mkp.net" <mkp@mkp.net>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "apw@canonical.com" <apw@canonical.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "jasowang@redhat.com" <jasowang@redhat.com>



> -----Original Message-----
> From: hch@infradead.org [mailto:hch@infradead.org]
> Sent: Thursday, July 10, 2014 11:32 PM
> To: James Bottomley
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org; mkp@mkp.net;
> hch@infradead.org; devel@linuxdriverproject.org; apw@canonical.com;
> stable@vger.kernel.org; linux-scsi@vger.kernel.org; ohering@suse.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 4/8] Drivers: scsi: storvsc: Filter WRITE_SAME_16
> 
> On Wed, Jul 09, 2014 at 10:27:24PM +0000, James Bottomley wrote:
> > If we fix it at source, why would there be any need to filter?  That's
> > the reason the no_write_same flag was introduced.  If we can find and
> > fix the bug, it can go back into the stable trees as a bug fix, hence
> > nothing should ever emit write_same(10 or 16) and additional driver
> > code is redundant (and counter productive, since if this ever breaks
> > again you're our best canary).
> >
> > This looks like it might be the problem but Martin should confirm (I
> > think the problem comes to us from the RC16 code which unconditionally
> > sets WS16).
> 
> I think the problem is a differnet one.  If we have the logical provisioning
> EVPD it configures what method to use, but if we don't have one we simply
> check for a max unmap blocks field, and if that's not present use WRITE
> SAME.
> 
> The patch checks the no_write_same flag before doing that, for which we
> also have to do the write_same setup before the discard setup in
> sd_revalidate_disk.
> 
> Ky: does hyperv support UNMAP?  If so any idea why it doesn't set the
> maximum unmap block count field in the EVPD?

Windows hosts do support UNMAP and set the field in the EVPD. However, since the host
advertises SPC-2 compliance, Linux does not even query the VPD page.
 
> 
> If we want to enable UNMAP in this case I'd prefer a blacklist entry than
> trying UNMAP despite the device not advertising it.
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index ba756b1..fbccfd2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2614,9 +2614,10 @@ static void sd_read_block_limits(struct scsi_disk
> *sdkp)
> 
>  			if (sdkp->max_unmap_blocks)
>  				sd_config_discard(sdkp, SD_LBP_UNMAP);
> -			else
> +			else if (!sdkp->device->no_write_same)
>  				sd_config_discard(sdkp, SD_LBP_WS16);
> -
> +			else
> +				sd_config_discard(sdkp, SD_LBP_DISABLE);
>  		} else {	/* LBP VPD page tells us what to use */
> 
>  			if (sdkp->lbpu && sdkp->max_unmap_blocks) @@ -
> 2766,6 +2767,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	 */
>  	if (sdkp->media_present) {
>  		sd_read_capacity(sdkp, buffer);
> +		sd_read_write_same(sdkp, buffer);
> 
>  		if (sd_try_extended_inquiry(sdp)) {
>  			sd_read_block_provisioning(sdkp);
> @@ -2776,7 +2778,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_write_protect_flag(sdkp, buffer);
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
> -		sd_read_write_same(sdkp, buffer);
>  	}
> 
>  	sdkp->first_scan = 0;
