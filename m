Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8A3E95A67
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Oct 2023 13:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344800AbjJHNPc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Oct 2023 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344778AbjJHNPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Oct 2023 09:15:31 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id D6E8DC6
        for <linux-scsi@vger.kernel.org>; Sun,  8 Oct 2023 06:15:28 -0700 (PDT)
Received: (qmail 109736 invoked by uid 1000); 8 Oct 2023 09:15:27 -0400
Date:   Sun, 8 Oct 2023 09:15:27 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 4/6] usb-storage,uas: use host helper to generate
 driver info
Message-ID: <a80f9bde-5969-498e-8dcf-9af9848d9c2a@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-5-gmazyland@gmail.com>
 <65bd429f-6740-4aa6-af00-e72d27074115@rowland.harvard.edu>
 <e71d958f-8954-465e-a296-c09763d0e3a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e71d958f-8954-465e-a296-c09763d0e3a1@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Oct 08, 2023 at 12:41:42PM +0200, Milan Broz wrote:
> On 10/6/23 20:44, Alan Stern wrote:
> > Okay, this one is a bit of a mess.  Unavoidably so, I'm afraid.
> 
> yes. What I need to know if it is acceptable approach (I spent quite
> a lot of time on it and still have no better idea...  At least with
> a patch that is not too invasive).

Yes, the basic idea is acceptable (subject to the comments in my 
earlier email).  In fact, it's probably the best we can do, given the 
constraints we face.

> Here I compared generated tables with old pre-processor generated
> and it looks the same. (Also I keep it on kernel.org branch, so
> 0-day bot reports obvious mistakes.)
> 
> ...
> 
> > > This translation is unnecessary for a 64-bit system, but I keep it
> > > in place for simplicity.
> > > (Also, I did not find a reliable way a host-compiled program can detect
> > > that the target platform has 32-bit unsigned long (usual macros do not
> > > work here!).
> > 
> > How about testing CONFIG_64BIT?  Would that not do what you want?
> 
> Yes, that was my last idea too, but I am not sure if it correct (and I have
> no longer access to more exotic platforms to check it).

I'm reasonably sure that it's the right thing to check.

> Also using kernel config defines in host-compiled code is tricky, but
> it should be possible.

Yeah; I'm not certain about how to do it.  One possibility is simply to 
parse the .config file directly at runtime, if the Kbuild system doesn't 
provide the CONFIG_* macros when compiling a host program.

> I will try to ask my former colleagues, though.
> 
> > However, I agree that it's better to keep things simple by using the
> > same code base for 32-bit and 64-bit kernels.
> 
> Yes, that was my plan for now. So you want to keep it as it is?
> 
> We can add optimization for 64-bit with additional patch later, it should be
> pretty easy once I know how to detect that target platform really has
> 64-bit unsigned long so no translation is needed.

Yes, I agree that this is the approach we should take.

Alan Stern
