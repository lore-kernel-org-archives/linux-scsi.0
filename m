From: Christoph Hellwig <hch@infradead.org>
Subject: Re: virtio-scsi issues duplicate tags when async_abort is enabled
Date: Fri, 13 Jun 2014 11:52:21 -0700
Message-ID: <20140613185221.GA11872@infradead.org>
References: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHdzE-8k6A6kVB7DnOc6_XKg6DANLRFmP9+f4oXE1vPoLhOK=g@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: hare@suse.de, hch@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 13, 2014 at 10:58:22AM -0700, Venkatesh Srinivas wrote:
> CC-ing stable as 3.14 and 3.15 are affected; a conservative fix is to
> enable no_async_abort until the problem is better-understood.

No patch attached.  Nevermind this is not a consdervative fix, but a
band aid.  The proper fix is to figure out what's actually going on
here.

>From your trace above it very much looks like a double completion of
some sort.

I've looked at the virtio-scsi code a bit, and one odd thing it does
that comes in handy here is that it doesn't really use a traditional
tag, but rather the address of the scsi command.

Knowning that your above traces mean that we are resending a command
to the HBA/storage that has a pending abort going on.
