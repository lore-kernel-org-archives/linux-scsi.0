From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Date: Mon, 5 Jan 2009 09:47:04 +0100
Message-ID: <20090105084703.GA5741@nowhere>
References: <20090104092430.7ffd2c41@infradead.org> <1231135294.8179.45.camel@nigel-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1231135294.8179.45.camel@nigel-laptop>
Sender: linux-acpi-owner@vger.kernel.org
To: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 05, 2009 at 05:01:34PM +1100, Nigel Cunningham wrote:
> Hi Arjan.
> 
> Great work, and valuable too. I'm just wondering if the header file name
> "async.h" is a little too generic? Something like async_init.h perhaps?
> 
> Regards,
> 
> Nigel
>

Hi Nigel,

That's what I thought too at first. But I guess there could be other
users of these async functions than the initcalls.
It looks like out of order workqueues that can synchronize themselves.
It seems a bit more costly than workqueues (since the concept comes along
a loop of creation/destroying of several threads) but more efficient for the
same reason as the number of active threads adapts to the number of CPU and jobs to perform.
The purpose is not the same. But I guess it's more reliable
than workqueues for pathes that require mutiple parallel jobs which need
to locally synchronize on critical pathes.

