From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 10:05:27 -0500
Message-ID: <20151102150527.GA23665@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com>
 <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com>
 <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com>
 <56371095.6020400@suse.de>
 <20151102133119.GA23234@redhat.com>
 <56376B8C.5010001@suse.de>
 <563778B9.7060900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbbKBPF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 10:05:28 -0500
Content-Disposition: inline
In-Reply-To: <563778B9.7060900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Mon, Nov 02 2015 at  9:52am -0500,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> 
> 
> On 02/11/2015 14:56, Hannes Reinecke wrote:
> > But then the real question remains:
> > 
> > What is the 'correct' behaviour for ioctls when no path retry
> > is active (or when no paths are present)?
> > 
> > Should we start path activation?
> > If so, should we wait for path activation to finish, risking udev
> > killing the worker for that event (udev has a built-in timeout of
> > 120 seconds, which we might easily exceed when we need to activate
> > paths for large installations or slow path activation ... just
> > thinking of NetApp takeover/giveback cycle)?
> > If we're not waiting for path activation, where would be the point
> > in starting it, seeing that we're not actually interested in the result?
> > And if we shouldn't start a path activation, what is the point of
> > having code for it in the first place?
> 
> That's a fair question, and it depends on what said udev worker actually
> does.
> 
> In any case, if we don't start path activation we should return
> ENOTCONN, not ENOTTY.

Currently, if we don't start path activation we're returning EIO.
ENOTCONN is used for when we do start path activation (and ENOTCONN is
the means for DM core to retry)

We _could_ change the ENOTCONN to be EAGAIN and EIO to ENOTCONN...
