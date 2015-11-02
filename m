From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: IBM request to allow unprivledged ioctls [Was: Revert "dm mpath:
 fix stalls when handling invalid ioctls"]
Date: Mon, 2 Nov 2015 10:57:05 +0100
Message-ID: <56373371.8040104@redhat.com>
References: <1446121463-17828-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <20151029131810.GA26841@redhat.com> <5634DF67.7060302@redhat.com>
 <20151031181312.GA11587@redhat.com> <5635115B.7080805@redhat.com>
 <20151031224707.GA12805@redhat.com> <56371095.6020400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33176 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbbKBJ5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 04:57:10 -0500
Received: by wijp11 with SMTP id p11so47632140wij.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 01:57:09 -0800 (PST)
In-Reply-To: <56371095.6020400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: hch@lst.de, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org



On 02/11/2015 08:28, Hannes Reinecke wrote:
> 
> With the original code we would need to wait for path activation
> before we would be able to figure out if the ioctl is valid.
> However, the callback to verify the ioctl is sd_ioctl(), which as
> a first step calls scsi_verify_ioctl().
> So my reasoning was that we can as well call scsi_verify_ioctl()
> early, and allow it to filter out known invalid ioctls.
> Then we wouldn't need to wait for path activation and return
> immediately.

That in principle makes sense.  Unfortunately, before path activation
you can only find out if a ioctl is valid.  You cannot find out which
ioctls are _in_valid, because path activation sets the bdev and that
might make all ioctls valid.

> Incidentally, in the 'r == -ENOTCONN' case, we're waiting
> for path activation, but then just bail out with -ENOTCONN.
> As we're not resetting -ENOTCONN, where's the point in activate the
> paths here?
> Shouldn't we retry to figure out if -ENOTCONN is still true?

That makes sense too.  You've done the work, might as well reap the
benefits...

Paolo
