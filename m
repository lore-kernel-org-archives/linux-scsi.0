From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] sg: fix dxferp in from_to case
Date: Wed, 09 Mar 2016 11:09:21 -0500
Message-ID: <1457539761.16707.81.camel@localhost.localdomain>
References: <56D7CC31.3070800@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663AbcCIQJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2016 11:09:22 -0500
In-Reply-To: <56D7CC31.3070800@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, dvyukov@google.com

On Thu, 2016-03-03 at 00:31 -0500, Douglas Gilbert wrote:
> This patch is in response to this report:
>     http://www.spinics.net/lists/linux-scsi/msg93456.html
> 
> One of the strange things that the original sg driver did was let
> the user provide both a data-out buffer (it followed the
> sg_header+cdb) _and_ specify a reply length greater than zero. What
> happened was that the user data-out buffer was copied into some
> kernel buffers and then the mid level was told a read type operation
> would take place with the data from the device overwriting the same
> kernel buffers. The user would then read those kernel buffers back
> into the user space.
> 
>  From what I can tell, the above action was broken by a change in
> 2008 and syzkaller found that out recently.
> 
>     ChangeLog:
>        make sure that a user space pointer is passed through
>        when data follows the sg_header structure and command.
>        Fix the abnormal case when a non-zero reply_len is also
>        given.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

This looks correct to me.  hp->dxferp used to be set unconditionally,
but commit fad7f01e changed it to only be set in the SG_DXFER_TO_DEV
case.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


