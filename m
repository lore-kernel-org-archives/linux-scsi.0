From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Fri, 8 Aug 2003 00:00:56 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local>
References: <20030806231359.A28252@mail.kroptech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:42713 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S270766AbTHGVA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 17:00:58 -0400
In-Reply-To: <20030806231359.A28252@mail.kroptech.com>
List-Id: linux-scsi@vger.kernel.org
To: Adam Kropelin <akropel1@rochester.rr.com>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

No solution but some test results...

On Wed, 6 Aug 2003, Adam Kropelin wrote:

> When trying to read from my SCSI tape drive using the wrong block size I
> get the BUG trace shown below. I ran into this by accident after writing
> a tape with variable blocksize and then trying to 'dd' from it using a
> fixed blocksize.
>
> The BUG trace is from 2.6.0-test2, but it's also reproducable on -test1
> and test2-mm3. The box is running SMP + PREEMPT. SCSI boot-time messages
> are shown below.
>
> Steps to reproduce:
> mt -f /dev/st0 setblk 0   # Set variable block size
> dd if=/dev/zero of=/dev/st0 bs=1237 count=1  # Write an unusual block
> mt -f /dev/st0 setblk 512 # Set block size to 512 fixed
> dd if=/dev/st0 bs=512     # BUG
>
I tried this with a DDS4 drive and sym53c8xx_2 (with bs=1236 because the
sym driver does not like odd counts on wide bus). The result was correct,
i.e., the last dd fails and there is a message in syslog about incorrect
block size.

> --Adam
>
> kernel BUG at include/asm/dma-mapping.h:37!

This comes from 'BUG_ON(direction == DMA_NONE)' in dma_map_sg(). I
inserted a printk into st_do_scsi() in st.c to see if DMA_NONE is used for
some command that should transfer data. No errors seen in these printk
results.

-- 
Kai
