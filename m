From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 19:13:30 +0200
Message-ID: <4FD778BA.8040201@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com> <20439.30634.460606.215696@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20439.30634.460606.215696@quad.stoffel.home>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

Il 12/06/2012 19:08, John Stoffel ha scritto:
> Paolo> Persistent reservations commands cannot be issued right now
> Paolo> without giving CAP_SYS_RAWIO to the process who wishes to send
> Paolo> them.  This is a bit heavy-handed, allow these two commands.
> 
> This seems like a bad idea, now anyone can just put in a SCSI
> reservation on a system and then you have to hunt around trying to
> figure it out.  

What's the difference from anyone destroying data on a disk?  You still
need write access to the block device node.  Also, you could already do
the same if you have root permissions on your _local_ machine.

(BTW, please reply to these objections where I already stated them, in
the answer to James Bottomley).

> What's the motivation here?  What's the use case this solves?  

I would like to give access to persistent reservations to VMs, without
having to run qemu as root.  One alternative is to run a userspace iSCSI
initiator, but of course that would only work with iSCSI.

Paolo
