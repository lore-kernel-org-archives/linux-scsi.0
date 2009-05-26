From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 4/4] bnx2i: Add bnx2i iSCSI driver.
Date: Tue, 26 May 2009 09:37:53 -0700
Message-ID: <da824cf30905260937s4029fe7crc723da03fba08c7b@mail.gmail.com>
References: <1243113110-29635-1-git-send-email-mchan@broadcom.com>
	 <1243113110-29635-5-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:5537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbZEZQh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 12:37:56 -0400
Received: from spaceape11.eur.corp.google.com (spaceape11.eur.corp.google.com [172.28.16.145])
	by smtp-out.google.com with ESMTP id n4QGbt6Z021030
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2009 09:37:56 -0700
Received: from qw-out-1920.google.com (qwf5.prod.google.com [10.241.194.69])
	by spaceape11.eur.corp.google.com with ESMTP id n4QGbrUO004152
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2009 09:37:54 -0700
Received: by qw-out-1920.google.com with SMTP id 5so1178185qwf.40
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2009 09:37:53 -0700 (PDT)
In-Reply-To: <1243113110-29635-5-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: James.Bottomley@hansenpartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, anilgv@broadcom.com, benli@broadcom.com

On Sat, May 23, 2009 at 2:11 PM, Michael Chan <mchan@broadcom.com> wrote:
> New iSCSI driver for Broadcom BNX2 devices.
...
> +/*
> + * iSCSI Async CQE
> + */
> +struct bnx2i_async_msg {
...
> +#if defined(__BIG_ENDIAN)
> +       u8 async_event;
> +       u8 async_vcode;
> +       u16 param1;
> +#elif defined(__LITTLE_ENDIAN)
> +       u16 param1;
> +       u8 async_vcode;
> +       u8 async_event;
> +#endif
...

Michael,
I'm feeling a bit dense and am not seeing why byte data
would have to worry about the 32-bit word endianess of the CPU.
Can you give an example of why defined(__BIG_ENDIAN) is needed?

Normally the _*ENDIAN defines are used for bit fields, not byte fields.

Byte data addressable by the CPU (e.g. host memory) is at the same offset
regardless of endianness of the CPU. I feel like I'm missing
something that should be obvious.

thanks,
grant
