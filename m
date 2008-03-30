From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [patch 11/17] scsi: ch.c fix shadowed variable warnings
Date: Sun, 30 Mar 2008 11:59:43 -0700
Message-ID: <1206903583.6543.38.camel@brick>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
	 <1206897715.4224.55.camel@localhost.localdomain>
	 <1206902620.6543.32.camel@brick>
	 <1206903356.4224.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:41099 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYC3S7e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 14:59:34 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1588310wah.23
        for <linux-scsi@vger.kernel.org>; Sun, 30 Mar 2008 11:59:33 -0700 (PDT)
In-Reply-To: <1206903356.4224.87.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, 2008-03-30 at 13:55 -0500, James Bottomley wrote:
> > > 
> > > This isn't really the correct fix, is it?  The driver stupidity is
> > > having a global (although static) variable called err which invites
> > > problems like this.  How about this fix?
> > > 
> > 
> > If you like that better, sure.
> 
> Er, well it's not really a question of like; it's more a question of the
> programming principle of reducing namespace pollution.
> 
> The more global something is (and you start with global headers, then
> arch headers, then globally exported symbols, then subsystem symbols,
> etc ...) the more polluting.  So, the only thing that should be allowed
> to name something totally generic, like 'err' or 'ret' should be right
> at the lowest level (i.e. unexported symbols of local functions).
> 
> Your patch was wrong because you changed the name of the lowest level
> and left the actual polluting symbol in the next level up, thus inviting
> another patch or function addition to do it all over again.  The correct
> way to fix something like this is to rename the more globally polluting
> symbol to make a clash far less likely.

True, but being somewhat unfamiliar with scsi code, I chose the more
localized version that was easier to verify.

Are you going to apply your above version, or did you want me to redo
mine that way?

Harvey

