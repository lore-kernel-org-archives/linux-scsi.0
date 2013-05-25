From: James Smart <James.Smart@emulex.com>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Sat, 25 May 2013 14:07:32 -0400
Message-ID: <51A0FDE4.7050506@emulex.com>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:14523 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab3EYSHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 May 2013 14:07:34 -0400
In-Reply-To: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Jej B <James.Bottomley@hansenpartnership.com>

Roland,

I agree, and am already working around that limitation.

-- james s


On 5/23/2013 2:14 PM, Roland Dreier wrote:
> At LSF this year, we had a discussion about error handling and in
> particular the problem that SCSI midlayer error handling waits for the
> entire SCSI host (HBA) to quiesce before it starts to abort commands
> etc.
>
> James made the suggestion that FC should handle things the way SAS
> does, because SAS has a strategy handler that does things the right
> way.  However, now that I finally sit down and look at the code, I
> don't see how this is the case.  It seems inherent in the way that
> scsi_eh_scmd_add() and the thread in scsi_error_handler() work (in
> particular the strategy handler can't even be called until host_failed
> == host_busy; we don't bump host_failed without SHOST_RECOVERY set,
> which stops queueing commands to any devices attached to the whole
> HBA).
>
> James, am I understanding your suggestion properly?  If so can you
> explain what you meant about the libsas code -- I see that it has its
> own strategy handler but as I said before we've already stopped every
> device attached to the HBA before we ever get there.
>
> To recapitulate the problem here, we might have a whole fabric
> attached to an HBA via SAS or FC, and be doing 500K IOPS happily to 50
> devices.  Then a single LUN goes wonky and all the IO stops while we
> try to recover that single device, which might take minutes.
>
> I know this has been discussed before, but can we find a way forward
> here?  Is there some way we can start with per-device error recovery
> and avoid disrupting IO that we can see is working fine?
>
> Thanks,
>    Roland
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

