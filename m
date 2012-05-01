From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
Date: Tue, 01 May 2012 10:09:54 +0200
Message-ID: <4F9F9A52.8010100@redhat.com>
References: <1334756761-12312-1-git-send-email-pbonzini@redhat.com> <1334758148.4410.51.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40757 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2EAIJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2012 04:09:58 -0400
In-Reply-To: <1334758148.4410.51.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Hu Tao <hutao@cn.fujitsu.com>

Il 18/04/2012 16:09, James Bottomley ha scritto:
>> > Fix a race in TMF path, where cmd may have been already freed
>> > by virtscsi_complete_free after waking up from the completion.
> There's no may about this; the command will be freed long before the
> completion waiter is awoken.  The description could be clearer.
> 
> The problem is a use after free in virtscsi_tmf because the
> virtio_scsi_command is freed before the completion returns.
> 
> The fix is to make callers specifying a completion responsible for
> freeing the command in all cases.

I don't see this in the pull request, were you waiting for v2 with a
better commit message?

Paolo
