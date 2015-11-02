From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 16:45:09 +0100
Message-ID: <56378505.6080601@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com> <56371095.6020400@suse.de>
 <20151102133119.GA23234@redhat.com> <56376B8C.5010001@suse.de>
 <563778B9.7060900@redhat.com> <20151102150527.GA23665@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbKBPpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 10:45:14 -0500
In-Reply-To: <20151102150527.GA23665@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



On 02/11/2015 16:05, Mike Snitzer wrote:
> > In any case, if we don't start path activation we should return
> > ENOTCONN, not ENOTTY.
> 
> Currently, if we don't start path activation we're returning EIO.
> ENOTCONN is used for when we do start path activation (and ENOTCONN is
> the means for DM core to retry)
> 
> We _could_ change the ENOTCONN to be EAGAIN and EIO to ENOTCONN...

This makes sense... though of course testing the impact of this on
userspace is going to be hard. :(  Chances are that userspace is not
expecting EAGAIN either.

Even if they did, how would someone know that they can now retry the
ioctl after getting EAGAIN?  Should they just do it in a loop?

Paolo
