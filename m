From: Andi Kleen <ak@muc.de>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [17/27]
Date: Thu, 17 Feb 2005 22:08:27 +0100
Message-ID: <m14qgadhdg.fsf@muc.de>
References: <4214D645.60709@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from one.firstfloor.org ([213.235.205.2]:39565 "EHLO
	one.firstfloor.org") by vger.kernel.org with ESMTP id S261195AbVBQVI2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 16:08:28 -0500
In-Reply-To: <4214D645.60709@adaptec.com> (Luben Tuikov's message of "Thu,
 17 Feb 2005 12:37:09 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Luben Tuikov <luben_tuikov@adaptec.com> writes:


> +/********************************** Misc Macros *******************************/

[... lots of code...]

What are they all good for? As far as I can see every one of them
duplicates or wraps something Linux already has.

How about you just use the native Linux functions directly?

 +
> +#if KDB_ENABLE
> +#define ASSERT(expression)						\
> +	if (!(expression)) {						\
> +		printk("assertion failed: %s, file: %s, line: %d\n",	\
> +			#expression, __FILE__, __LINE__);		\
> +		KDB_ENTER();						\
> +	}
> +#else
> +#define ASSERT(expression)						\
> +	if (!(expression)) {						\
> +		panic("assertion failed: %s, file: %s, line: %d\n",	\
> +			#expression, __FILE__, __LINE__);		\
> +	}
> +#endif

That's called BUG_ON in Linux land.

> +#ifndef list_for_each_entry_safe

[...]

Such compat code does not really belong into a 2.6 driver.

> +
> +#define list_move_all(to_list, from_list)				\

[...]

And this should be put into list.h

-Andi
