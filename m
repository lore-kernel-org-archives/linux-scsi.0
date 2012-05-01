From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
Date: Tue, 01 May 2012 09:52:19 +0100
Message-ID: <1335862339.2996.5.camel@dabdike>
References: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
	 <1334758148.4410.51.camel@dabdike> <4F9F9A52.8010100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33002 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab2EAIw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 04:52:29 -0400
In-Reply-To: <4F9F9A52.8010100@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hu Tao <hutao@cn.fujitsu.com>

On Tue, 2012-05-01 at 10:09 +0200, Paolo Bonzini wrote:
> Il 18/04/2012 16:09, James Bottomley ha scritto:
> >> > Fix a race in TMF path, where cmd may have been already freed
> >> > by virtscsi_complete_free after waking up from the completion.
> > There's no may about this; the command will be freed long before the
> > completion waiter is awoken.  The description could be clearer.
> > 
> > The problem is a use after free in virtscsi_tmf because the
> > virtio_scsi_command is freed before the completion returns.
> > 
> > The fix is to make callers specifying a completion responsible for
> > freeing the command in all cases.
> 
> I don't see this in the pull request, were you waiting for v2 with a
> better commit message?

That would be because you didn't reply.  I was expecting either a
comment or a rewording of the change log.  My inbox works by threads
rising to the top and completed ones going into the patch queue.  If
no-one replys to a thread expecting one, it just gets lost.

James


