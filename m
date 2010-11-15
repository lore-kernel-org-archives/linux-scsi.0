From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: SCSI TMF processing; tag allocation
Date: Mon, 15 Nov 2010 10:28:04 +0100
Message-ID: <4CE0FD24.4030000@fusionio.com>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <20101113123750.GF18258@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101113123750.GF18258@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>> Third, and most importantly, tags should form an increasing sequence and should not be reused until all other tags after it and before it have been reused. This for example can be accomplished if one were to use
>> find_next_zero_bit() with non-zero "offset", it being the last allocated
>> tag in a modulo the number of tags manner. That is, find_next_zero_bit()
>> could wrap as well as starting from an offset or the caller could implement
>> that via two calls to this function, in blk_queue_start_tag().

Care to explain your reasoning? For starvation issues? At least I'm not
aware of any correctness issues in that regard, but doing tag cycling in
this fashion seems like a good idea just to prevent starvation alone by
an ill behaving device.

-- 
Jens Axboe
