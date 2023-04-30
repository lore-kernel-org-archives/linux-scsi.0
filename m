Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEDA1C77B73
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Apr 2023 21:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjD3VKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Apr 2023 17:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjD3VKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Apr 2023 17:10:23 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id BE3BD18C
        for <linux-scsi@vger.kernel.org>; Sun, 30 Apr 2023 14:10:20 -0700 (PDT)
Received: (qmail 278534 invoked by uid 1000); 30 Apr 2023 17:10:19 -0400
Date:   Sun, 30 Apr 2023 17:10:19 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Maxime Bizon <mbizon@freebox.fr>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Message-ID: <87351d78-aab0-4785-a420-d967b266aebd@rowland.harvard.edu>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
 <e9165662-7af2-0540-f823-56a5f051620f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9165662-7af2-0540-f823-56a5f051620f@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 30, 2023 at 12:39:12PM -0700, Bart Van Assche wrote:
> On 4/26/23 12:20, Alan Stern wrote:
> > > This patch fixes the issue, not sure if it's correct:
> > > 
> > > --- a/drivers/usb/storage/scsiglue.c
> > > +++ b/drivers/usb/storage/scsiglue.c
> > > @@ -455,6 +455,9 @@ static int device_reset(struct scsi_cmnd *srb)
> > >          usb_stor_dbg(us, "%s called\n", __func__);
> > > +       if (us->srb == srb)
> > > +               command_abort(srb);
> > > +
> > >          /* lock the device pointers and do the reset */
> > >          mutex_lock(&(us->dev_mutex));
> > >          result = us->transport_reset(us);
> > 
> > Maybe...  But it would be better to check first whether the SCSI core is
> > supposed to be reusing an active srb in this way.
> > 
> > Martin, can tell us what is supposed to happen here?  Is the
> > eh_device_reset_handler routine supposed to be called with a scsi_cmnd
> > for a currently active command?
> 
> Hi Alan,
> 
> I'm not aware of any other .eh_device_reset_handler implementation that
> aborts the command that is passed to this callback before it aborts other
> SCSI commands.

That's not a good description of what's happening.  For one thing, 
usb-storage can process only one command at a time, so the "before it 
aborts other SCSI commands" part doesn't apply.  In fact, the proposed 
patch aborts the current command (which happens to be the same as the 
one passed to the .eh_device_reset_handler routine) before beginning a 
reset.

>  However, I'm not aware of an equivalent of us_data.dev_mutex
> in other SCSI LLDs either. Maybe this deadlock is specific to the USB
> storage handler?

The deadlock, if that's what it is, is related to the fact that 
usb-storage does only one thing at a time.  The mutex is there merely to 
enforce this; removing it wouldn't help matters since the driver still 
wouldn't be capable of doing more than one thing at a time.

The underlying unstated issue is that usb-storage doesn't have any 
timeouts of its own.  If a device fails to complete a command properly 
and the SCSI error handler doesn't abort the command, then the command 
will never finish and the driver will hang.  (Until the device is 
hot-unplugged, of course.)

I suppose a bus reset would probably cause an ongoing command to fail.  
A device reset almost certainly would not, since most device 
implementations of the USB bulk-only mass-storage protocol do a very bad 
job of handling device resets.

Either way, it's a lot cleaner simply to abort the command before 
starting the reset.  If usb-storage can't depend on the SCSI error 
handler to do this for us, it will have to do so itself.

Alan Stern

> Martin, feel free to correct me if I got anything wrong.
> 
> Bart.
