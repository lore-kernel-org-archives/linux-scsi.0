From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] MD: raid, fix BUG caused by flags handling
Date: Thu, 12 Aug 2010 09:26:30 -0400
Message-ID: <x49mxss3qt5.fsf@segfault.boston.devel.redhat.com>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1281616266-4709-1-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 12 Aug 2010 14:31:04 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jirislaby@gmail.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Neil Brown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> Commit 74450be1 (block: unify flags for struct bio and struct request)
> added direct test of flags in the & form:
>   const bool do_sync = (bio->bi_rw & REQ_SYNC);
> But this doesn't fit into bool with my compiler (gcc 4.5). So change
> the type to ulong to avoid the bug.

At first I wondered why you didn't use the !! trick, but after looking
at the code, I see that the result is |'d into bi_rw.

Looks good.  Sounds like it might have been a real bear to track down.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
