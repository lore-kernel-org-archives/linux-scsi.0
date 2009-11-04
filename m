From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 12:05:48 -0600
Message-ID: <1257357948.10416.9.camel@mulgrave.site>
References: <4AF17AD3.6060909@Calva.COM>
	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM>
	 <1257350834.2697.52.camel@mulgrave.site>  <4AF1A7E7.7070307@Calva.COM>
	 <1257351654.2697.55.camel@mulgrave.site>  <4AF1C172.6080509@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbZKDSFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 13:05:48 -0500
In-Reply-To: <4AF1C172.6080509@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-11-04 at 19:01 +0100, John Hughes wrote:
> James Bottomley wrote:
> > On Wed, 2009-11-04 at 17:12 +0100, John Hughes wrote:
> >   
> >> # sg_ses -p 0 /dev/sg17
> >>   PROMISE   3U-SAS-16-D BP    0107
> >>     enclosure services device
> >> Supported diagnostic pages:
> >>   Supported diagnostic pages [0x0]
> >>   Configuration (SES) [0x1]
> >>   Enclosure status/control (SES) [0x2]
> >>   Threshold In/Out (SES) [0x5]
> >>   Enclosure busy (SES-2) [0x9]
> >>   Additional (device) element status (SES-2) [0xa]
> >>     
> >
> > This may also be a problem.  My enclosure returns page 7 as well.  The
> > traversal routine has special code to try to parse page 10 without a
> > page 7 ... I don't think I actually ever tested that ...
> >   
> As far as I can tell you only use page 7 to get the slot names, but you 
> ignore the "addl_desc_ptr" information in page10 if you didn't get page7.
> 
> With the following patch I get the "device" directories in the enclosure 
> bay directories, even for the SATA drive.  (Maybe this is because the 
> SATA drive is behind a so-called "aamux" device).
> 
> I also find the "enclosure_device:xxx" link in the 
> /sys/block/sdxx/device directory
> 
> # ls -l /sys/block/sdaa/device/enclosure_device:13
> lrwxrwxrwx 1 root root 0 2009-11-04 18:57 /sys/block/sdaa/device/enclosure_device:13 -> ../../../../../../../../../../../../class/enclosure/4:0:14:0/13
> 
> Yay!
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 55b034b..725a095 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -389,9 +389,9 @@ static void ses_enclosure_data_process(struct enclosure_devi
>                 len = (desc_ptr[2] << 8) + desc_ptr[3];
>                 /* skip past overall descriptor */
>                 desc_ptr += len + 4;
> -               if (ses_dev->page10)
> -                       addl_desc_ptr = ses_dev->page10 + 8;
>         }
> +       if (ses_dev->page10)
> +               addl_desc_ptr = ses_dev->page10 + 8;

Ah, yes ... knew I'd done something stupid.

Could you format this properly (as in with description) and add a signed
off by line and I'll put it in the bug fixes tree.

Thanks,

James


