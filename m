From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 16:17:30 -0500
Message-ID: <1206047850.3038.52.camel@localhost.localdomain>
References: <47E2B044.70705@ipax.at>
	 <1206039714.3038.40.camel@localhost.localdomain> <47E2B7EF.1050203@ipax.at>
	 <1206043027.3038.48.camel@localhost.localdomain> <47E2D268.2070609@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42118 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755217AbYCTVRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 17:17:33 -0400
In-Reply-To: <47E2D268.2070609@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-03-20 at 22:08 +0100, Raoul Bhatia [IPAX] wrote:
> hi james,
> 
> James Bottomley wrote:
>  > A work around might be to lower the queue depth to say 4 or 8 and up the
>  > retries (this latter can only be done by altering the SD_MAX_RETRIES
>  > parameter in include/scsi/sd.h and recompiling).
> 
> any suggestions for these parameters:
> 
> include/scsi/sd.h:
>  > #define SD_TIMEOUT              (30 * HZ)
>  > #define SD_MOD_TIMEOUT          (75 * HZ)
>  >
>  > #define SD_MAX_RETRIES          5
>  > #define SD_PASSTHROUGH_RETRIES  1
> 
> shall i alter the timeouts?

The timeouts can be altered on the fly
at /sys/class/scsi_device/<device>/device/timeout

but I'd leave them as is for now ... it wasn't the timeouts that fired.

> what is a good value for the retries? time it by 2? by 5? by 10?

I'd up the retries to say 15 and see if that works.

> moreover, where can i lower the queue?

echo <new depth> > /sys/class/scsi_device/<device>/device/queue_depth

James


