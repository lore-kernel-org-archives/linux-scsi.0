From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 2/4] cciss: use mutex instead of flag to indicate busy
 initializing
Date: Thu, 23 Jul 2009 17:32:52 -0700
Message-ID: <20090723173252.a83eac26.akpm@linux-foundation.org>
References: <20090721195517.20740.18994.stgit@bob.kio>
	<20090721195527.20740.1301.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751842AbZGXAdC@vger.kernel.org>
In-Reply-To: <20090721195527.20740.1301.stgit@bob.kio>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 21 Jul 2009 13:55:27 -0600
Andrew Patterson <andrew.patterson@hp.com> wrote:

> cciss: use mutex instead of flag to indicate busy initializing
> 
> Convert busy_initializing from simple integer flag to mutex, so we
> can use it to block and thus avoid some race conditions.
> 

But the code never blocks on busy_initializing.  The only place where
we do a mutex_lock() is in cciss_init_one().  Everywhere else we're
using the mutex as a boolean flag in weird ways.

I really don't have the time to work out what we're trying to do here. 
Does the code actually work?  If so I'm thinking we should merge it and
pretend that someone else did it :(
