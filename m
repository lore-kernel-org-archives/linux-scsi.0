From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: dangling pointers and/or reentrancy in scmd_eh_abort_handler?
Date: Wed, 21 May 2014 22:34:17 +0200
Message-ID: <537D0DC9.5010900@redhat.com>
References: <537A105B.4080504@redhat.com> <537A1E88.9080803@acm.org> <537A2CB8.9060302@redhat.com> <537A34C6.7090905@acm.org> <loom.20140521T161608-391@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56403 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUUeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 16:34:23 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so1982897eek.12
        for <linux-scsi@vger.kernel.org>; Wed, 21 May 2014 13:34:22 -0700 (PDT)
In-Reply-To: <loom.20140521T161608-391@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Wu <wudx05@gmail.com>, linux-scsi@vger.kernel.org

Il 21/05/2014 16:16, Mark Wu ha scritto:
> Is it possible that when scsi_done is invoked, the scsi command or the
> request has been freed and then reallocated for a new I/O request?  Because
> of this the bit flag REQ_ATOM_COMPLETE becomes unreliable.  Thanks!

It is up to the driver to ensure that the interrupt handler will not 
process the Scsi_Cmnd* after returning from the eh_abort_handler.  If 
you do this, what you say cannot happen.  Otherwise you'll get a variety 
of failures, the most common of which for me are OOPSes and a BUG in 
blk_finish_request.

Paolo
