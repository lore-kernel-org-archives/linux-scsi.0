From: Jim Ramsay <jim.ramsay@gmail.com>
Subject: Re: [PATCH 3/3] Add disk hotswap support to libata RESEND #2
Date: Tue, 6 Sep 2005 13:02:07 -0600
Message-ID: <4789af9e05090612023fb8517c@mail.gmail.com>
References: <355e5e5e05080103021a8239df@mail.gmail.com>
	 <4789af9e050823124140eb924f@mail.gmail.com>
	 <4789af9e050823154364c8e9eb@mail.gmail.com>
	 <430BA990.9090807@mvista.com> <430BCB41.5070206@s5r6.in-berlin.de>
	 <355e5e5e05082407031138120a@mail.gmail.com>
	 <4789af9e05082408111c4a6294@mail.gmail.com>
	 <4789af9e05082409121cc6870@mail.gmail.com>
	 <4789af9e0508291223435f174@mail.gmail.com>
Reply-To: jim.ramsay@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.200]:45976 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750804AbVIFTCI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 15:02:08 -0400
Received: by zproxy.gmail.com with SMTP id r28so864054nza
        for <linux-scsi@vger.kernel.org>; Tue, 06 Sep 2005 12:02:07 -0700 (PDT)
In-Reply-To: <4789af9e0508291223435f174@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org

Regarding the sata_promise.c patch, I think I have found a bug in the
interrupt handler:

Just before the 'try_hotplug' label, you provide a check that will
kick us out of the interrupt handler if the interrupt was just handled
by a DMA command completing successfully.

However, I have seen the occasion where a single IRQ is used to signal
both a DMA completion AND a hotplug event.  Of course in this case the
hotplug event itself would be ignored completely.

So I would recommend getting rid of that check entirely.

-- 
Jim Ramsay
"Me fail English?  That's unpossible!"
