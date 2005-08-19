From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: libata error handling
Date: Fri, 19 Aug 2005 15:00:31 -0400
Message-ID: <43062C4F.3070505@adaptec.com>
References: <20050729050654.GA10413@havoc.gtf.org> <20050807054850.GA13335@htj.dyndns.org> <430556BF.5070004@pobox.com> <430570B5.60109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964994AbVHSTAe@vger.kernel.org>
In-Reply-To: <430570B5.60109@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On 08/19/05 01:40, Tejun Heo wrote:
>   I genearally agree that the events are somewhat standard for block 
> devices but IMHO SCSI EH also has fair amount SCSI-specific assumptions 
> and ATA is a bit too different from SCSI to fit cleanly into it.  For 
> example, when handling NCQ errors, the whole task set is aborted and the 
> status is retrieved with read log page.  This can be worked around in 
> one of the hooks and emulate SCSI behavior, but it just doesn't really 
> fit well.  And I think that recovering via translation layer is a bit 
> too much translation.
> 
>   So, my thought is that SCSI EH assumptions are a bit too specific to 
> be used as standard for block devices.

Ok, so everyone seems to agree on this.
 
>   It's true that we must do SCSI specific tasks inside libata if we use 
> eh_strategy_handler but I don't think switching to fine-grained EH will 
> reduce the amount of SCSI-specific things inside libata.  I think as 
> long as we can insulate LLDD's from SCSI layer, either way should be 
> okay later.

True, this is the goal.  Separation between device management
and how that device got to you, is the future and should be the
a goal.

>   I agree that being the only user does incur difficulties, but my very 
> subjective feeling is that the original libata EH implementation was 
> just a bit too fragile to start with.  eg. not grabbing host lock on EH 
> entrance causing command completion vs. EH handling race and handling 
> errors in several different ways.
> 
>   Heh... Maybe I'm just reluctant to let go of my patches.  Anyways, 
> I'll now stand down and see how things go and try to help.

Please don't do that.  One thing everyone in the Linux community knows
is that Linux-SCSI needs fresh minds and fresh ideas.  Especially from
knowlegable folks in the storage protocols and standards.

	Luben
