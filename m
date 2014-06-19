From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] ata: Fix the dma state machine lockup for the
 IDENTIFY DEVICE PIO mode command.
Date: Thu, 19 Jun 2014 10:21:48 -0400
Message-ID: <20140619142148.GD26904@htj.dyndns.org>
References: <1403160654-31612-1-git-send-email-stripathi@apm.com>
 <20140619141047.GA26904@htj.dyndns.org>
 <CAOHikRAX1NfeCRWVJtv_FTHHheYxU5uKVk_hytdEmb_j-5_wnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47662 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435AbaFSOVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 10:21:52 -0400
Content-Disposition: inline
In-Reply-To: <CAOHikRAX1NfeCRWVJtv_FTHHheYxU5uKVk_hytdEmb_j-5_wnA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com, Loc Ho <lho@apm.com>

On Thu, Jun 19, 2014 at 07:44:28PM +0530, Suman Tripathi wrote:
> Hi Tejun,
> 
> On Thu, Jun 19, 2014 at 12:20:54PM +0530, Suman Tripathi wrote:
> > +     /*
> > +      * Restart the dma engine if the last cmd issued
> > +      * is IDENTIFY DEVICE command
> > +      */
> > +     if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
> > +             ahci_restart_engine(ap);
> 
> Is it really only for IDENTIFY?  Are other PIO commands okay?
> [Suman] : We root cause it , It is the IDENTIFY DEVICE command . Other are
> ok
> Theprevious version applied it to all PIO commands, right?
> [suman] : The v2 contains only the IDENTIFY DEVICE. The v1 is contains for
> all PIO commands and that didn't work because the ERRATA mentions that it
> happens for the IDENTIFY DEVICE command.

So, it's just ATA_CMD_ID_ATA and ATA_CMD_ID_ATAPI is okay?  That's
kinda weird.

-- 
tejun
