From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: sd: fix entropy gathering for most rotational disks
Date: Tue, 12 Feb 2019 09:06:29 -0700
Message-ID: <e9a411a2-49e2-4897-4e02-1cf790465cbd@kernel.dk>
References: <1549987525.3173.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549987525.3173.17.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Xuewei Zhang <xueweiz@google.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Mikael Pettersson <mikpelinux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 2/12/19 9:05 AM, James Bottomley wrote:
> The problem is that the default for MQ is not to gather entropy,
> whereas the default for the legacy queue was always to gather it.  The
> original attempt to fix entropy gathering for rotational disks under MQ
> added an else branch in sd_read_block_characteristics(). 
> Unfortunately, the entire check isn't reached if the device has no
> characteristics VPD page.  Since this page was only introduced in SBC-3 
> and its optional anyway, most less expensive rotational disks don't
> have one, meaning they all stopped gathering entropy when we made MQ
> the default.  In a wholly unrelated change, openssl and openssh won't
> function until the random number generator is initialised, meaning lots
> of people have been seeing large delays before they could log into
> systems with default MQ kernels due to this lack of entropy, because it
> now can take tens of minutes to initialise the kernel random number
> generator.
> 
> The fix is to set the non-rotational and add-randomness flags
> unconditionally early on in the disk initialization path, so they can
> be reset only if the device actually reports being non-rotational via
> the VPD page.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe
