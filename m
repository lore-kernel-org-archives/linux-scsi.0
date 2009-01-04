From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up
 kernel boot
Date: Sun, 4 Jan 2009 10:33:34 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901041024360.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org> <20090104092857.5fbf6b2d@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20090104092857.5fbf6b2d@infradead.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org



On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> +
> +typedef u64 async_cookie_t;
> +typedef void (async_func_ptr) (void *data, async_cookie_t cookie);
> +
> +extern void async_schedule(async_func_ptr *ptr, void *data);
> +extern void async_synchronize_full(void);
> +extern void async_synchronize_cookie(async_cookie_t cookie);

Hmm. The cookie use doesn't seem to make much sense.

Why do you pass in the cookie to the async function, but don't return it 
to the caller? That seems backwards - you'd normally expect that it is the 
_caller_ that wants the cookie (to synchronise with a specific async 
call), not the callee. But now the only one who knows the cookie is the 
wrong entry - just the callee, not the caller.

Yes, yes, I read the explanation in the comments, and it says that the 
callee should do it to guarantee its own ordering, and your acpi port 
thing does that in order to apparently start a sequence that is 
asynchronous only wrt the synchronous code, but not wrt itself. That's a 
_very_ odd model, but whatever works. But wouldn't it still make sense to 
let the caller wait for individual events too?

IOW, I'd just suggest changing the interface so that "async_schedule()" 
also returns the cookie. 

			Linus
