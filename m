From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 15:52:41 +0100
Message-ID: <563778B9.7060900@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com> <56371095.6020400@suse.de>
 <20151102133119.GA23234@redhat.com> <56376B8C.5010001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbbKBOwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 09:52:46 -0500
In-Reply-To: <56376B8C.5010001@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



On 02/11/2015 14:56, Hannes Reinecke wrote:
> But then the real question remains:
> 
> What is the 'correct' behaviour for ioctls when no path retry
> is active (or when no paths are present)?
> 
> Should we start path activation?
> If so, should we wait for path activation to finish, risking udev
> killing the worker for that event (udev has a built-in timeout of
> 120 seconds, which we might easily exceed when we need to activate
> paths for large installations or slow path activation ... just
> thinking of NetApp takeover/giveback cycle)?
> If we're not waiting for path activation, where would be the point
> in starting it, seeing that we're not actually interested in the result?
> And if we shouldn't start a path activation, what is the point of
> having code for it in the first place?

That's a fair question, and it depends on what said udev worker actually
does.

In any case, if we don't start path activation we should return
ENOTCONN, not ENOTTY.

Paolo
