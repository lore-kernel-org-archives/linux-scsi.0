From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: allow persistent reservations without
 CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 17:55:03 +0100
Message-ID: <20120612175503.3462962f@pyramind.ukuu.org.uk>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Jun 2012 18:08:32 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Persistent reservations commands cannot be issued right now without
> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
> is a bit heavy-handed, allow these two commands.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>         Ok for 3.5 as well?

NAK.

Persistent reservations are exactly the kind of command that should have
a security model attached to them.

Red Hat seems to be an ever growing source of "mummy its hard, lets
disable all the security" type fixes. Please stop it.

There is a sensible debate to be had about whether a lesser privilege
ought to be allowed. The real fix to this as with half of the other
crazy attempts to break all the security models that seem to keep spewing
forth is for someone who cares about it (that seems to me Red Hat) add
support for pushing a BPF filter onto a block device command queue. 

All the supporting code is there and used for other stuff, we can even
jit the things, not that it's a fast path here.

Alan
