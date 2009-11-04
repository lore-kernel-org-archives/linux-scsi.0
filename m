From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ses enclosure stuff not working with Promise Vtrak J610S JBOD
Date: Wed, 04 Nov 2009 10:20:54 -0600
Message-ID: <1257351654.2697.55.camel@mulgrave.site>
References: <4AF17AD3.6060909@Calva.COM>
	 <1257348128.2697.29.camel@mulgrave.site>  <4AF1A38E.3000009@Calva.COM>
	 <1257350834.2697.52.camel@mulgrave.site>  <4AF1A7E7.7070307@Calva.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51071 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbZKDQUy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 11:20:54 -0500
In-Reply-To: <4AF1A7E7.7070307@Calva.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Hughes <john@Calva.COM>
Cc: linux-scsi@vger.kernel.org

On Wed, 2009-11-04 at 17:12 +0100, John Hughes wrote:
> James Bottomley wrote:
> > Could you tell me what the enclosure page 0 (supported diagnostic pages)
> > and page 10 (additional information page that allows us to do the
> > matching) say?  I suspect the enclosure either doesn't support the page
> > needed for the matching or there's some problem with the way the
> > information is encoded.
> >   
> Ok, here we go.   (I wonder whether the "<<<additional: response too 
> short>>>" at the end of page 10 has something to do with the problem).

Possibly ... that tends to indicate the enclosure data returned stopped
in the middle of the actual specification ... although looking at the
output this doesn't seem to be the case.  The zeros at the end
definitely indicate we have enough data, just that the expected
termination doesn't seem to be present.

> # sg_ses -p 0 /dev/sg17
>   PROMISE   3U-SAS-16-D BP    0107
>     enclosure services device
> Supported diagnostic pages:
>   Supported diagnostic pages [0x0]
>   Configuration (SES) [0x1]
>   Enclosure status/control (SES) [0x2]
>   Threshold In/Out (SES) [0x5]
>   Enclosure busy (SES-2) [0x9]
>   Additional (device) element status (SES-2) [0xa]

This may also be a problem.  My enclosure returns page 7 as well.  The
traversal routine has special code to try to parse page 10 without a
page 7 ... I don't think I actually ever tested that ...

James


