From: Luben Tuikov <luben@splentec.com>
Subject: Re: inquiry in scsi_scan.c
Date: Sun, 05 Jan 2003 14:36:54 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3E188956.9090907@splentec.com>
References: <UTC200301051307.h05D7da08203.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <UTC200301051307.h05D7da08203.aeb@smtp.cwi.nl>
To: Andries.Brouwer@cwi.nl
Cc: mdharm-kernel@one-eyed-alien.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Andries.Brouwer@cwi.nl wrote:
> 
> The SCSI code has no means of knowing the actual length transferred,
> so has no choice but to believe the length byte in the reply.
> But the USB code does the transferring itself, and knows precisely
> how many bytes were transferred. If 36 bytes were transferred and
> the additional length byte is 0, indicating a length of 5, then the
> USB code can fix the response and change the additional length byte
> to 31, indicating a length of 36. That way the SCSI code knows that
> not 5 but 36 bytes are valid, and it gets actual vendor and model strings.
> 

And what if the transport is *not* USB? Or they used
a similar firmware of their device server in another
product which used another transport?

I suggest that this device is blacklisted in that
SCSI Core would know that the ADDITIONAL LENGTH field
in the INQURY response is incorrectly set (to 0).
I.e. leave it to the interpreter.

A transport is *not* supposed to peek and poke in the
data it transfers!

-- 
Luben
