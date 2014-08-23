From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Debugging scsi abort handling ?
Date: Sat, 23 Aug 2014 16:05:20 -0500
Message-ID: <1408827920.2181.8.camel@jarvis>
References: <53F8AAA8.8040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52263 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaHWVF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 17:05:26 -0400
In-Reply-To: <53F8AAA8.8040407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2014-08-23 at 16:52 +0200, Hans de Goede wrote:
> Hi All,
> 
> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
> I'm getting quite a few bug reports about issues with UAS drives.
> 
> One if the issues is that there might be a number of bugs in the
> abort handling path, as I don't think that was ever tested properly.

Can you report the actual bugs and we'll try to take a look at them?

> So I'm wondering is there a way to test the abort path with a real
> drive? E.G. submit some command which is known to take a significant
> amount of time, and then abort it right after submitting ?

This scenario can't really happen under the current eh, if by abort
path, you mean the path where we abort the command by sending an abort
TMF in error handling.  The reason is that the command must timeout
before we abort.  If you mean the path where the driver says it aborted
the command and we have to retry, you can test that by returning
DID_ABORT immediately in the queuecommand routine ... I use this to test
some of the EH properties.  What you want to do is to modify the
queuecommand to return abort on a small number of commands (say around
5%) and then try normal operation.  This is what I used to test our
submission and resubmission routines, but I haven't run it for a year or
so.

The final suggestion is that you need to make sure this patch is in
their environment:

commit c69e6f812bab0d5442b40e2f1bfbca48d40bc50b
Author: James Bottomley <JBottomley@Parallels.com>
Date:   Thu Apr 10 13:36:11 2014 -0700

    [SCSI] More USB deadlock fixes

The reason this may make a difference is that USB appears fragile to
issuing commands before you complete a reset.

James


> Thanks & Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


