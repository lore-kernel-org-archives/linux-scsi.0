From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ch.c fix sparse shadowed variable warnings
Date: Tue, 01 Apr 2008 09:51:37 -0500
Message-ID: <1207061497.3100.14.camel@localhost.localdomain>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
	 <1206897715.4224.55.camel@localhost.localdomain>
	 <1206902620.6543.32.camel@brick>
	 <1206903356.4224.87.camel@localhost.localdomain>
	 <1206903583.6543.38.camel@brick>
	 <1207019451.3192.92.camel@localhost.localdomain>
	 <1207026330.12466.12.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40694 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbYDAOvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 10:51:41 -0400
In-Reply-To: <1207026330.12466.12.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Mon, 2008-03-31 at 22:05 -0700, Harvey Harrison wrote:
> Replace the global err array with ch_err.
> drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
> drivers/scsi/ch.c:116:3: originally declared here
> 
> Replace the temporary cmd buffer with ch_err to avoid shadowing the cmd
> function parameter.
> drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
> drivers/scsi/ch.c:596:20: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> James, incorporated your comments.

Yes, that looks fine, thanks.

I have a challenge for you:  It looks like this driver has three
incorrect unconditional uses of GFP_DMA.  It gets a 512 byte bufer and
then only uses 256 bytes of it on several occasions and the routine with
the shadowed cmd variable looks like it should be calling
ch_read_element_status() rather than duplicating it.

James


