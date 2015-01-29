From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 0/6] scsi: Some seq_file cleanups/optimizations
Date: Thu, 29 Jan 2015 09:22:56 -0500
Message-ID: <20150129092256.1c84193c@gandalf.local.home>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
	<1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
	<alpine.LNX.2.00.1501291636140.7510@nippy.intranet>
	<87wq46aqvz.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87wq46aqvz.fsf@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 29 Jan 2015 10:16:16 +0100
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> Steven, you've been doing some cleanup in this area, among other things
> trying to make all the seq_* functions return void. Could you fill me in
> on the status of that?

Yes, the entire seq_*() operations are ambiguous in how they handle
filling the buffers. Don't worry about side effects of using one seq
operation over another (I highly doubt anyone will notice).

I had to stop doing the cleanups to work on other things, but I have
patches to make all seq operations perform the same (and also use the
new seq_buf infrastructure).

And, please ignore any return value from the seq operations. If you
want to know if the buffer is full use seq_has_overflowed() to find out.

I'll try to continue this clean up as a side project.

-- Steve
