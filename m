From: Andrew Morton <akpm@osdl.org>
Subject: Re: iowait problems on 2.6, not on 2.4
Date: Sat, 29 May 2004 21:52:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529215226.68605319.akpm@osdl.org>
References: <200405261743.28111.antlarr@tedial.com>
	<20040526205225.7a0866aa.akpm@osdl.org>
	<200405281516.41901.antlarr@tedial.com>
	<20040528154525.6ed5f7b9.akpm@osdl.org>
	<1085877991.18642.336.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:4582 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261685AbUE3ExT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 00:53:19 -0400
In-Reply-To: <1085877991.18642.336.camel@compaq.xsintricity.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: antlarr@tedial.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Doug Ledford <dledford@redhat.com> wrote:
>
> But, I could be wrong.  Give it a try and see what happens.  In the 2.4
>  kernels I would tell you to tweak /proc/sys/vm/{min,max}-readahead,
>  don't know if those two knobs still exist in 2.6 and if they have the
>  same effect.  Andrew?

blockdev --setra N /dev/sda 			(N is in 512 byte units)

echo N > /sys/block/sda/queue/read_ahead_kb	(N is in kilobytes)

Also there was breakage (recently fixed) in which /dev/sdaN's readahead
setting was being inherited from the blockdev on which /dev resides.  But
reading regular files is OK.

