From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH blktests v2 3/3] sg/001: add regression test for syzcaller
 generated GPF in sg_read path
Date: Tue, 23 May 2017 16:46:57 +0200
Message-ID: <631117b1-9a4c-f91e-d884-72ff820d1afb@suse.de>
References: <cover.1495201975.git.jthumshirn@suse.de>
 <79600648b662bc8b9e701ff6627986887384585b.1495201975.git.jthumshirn@suse.de>
 <20170522175905.GA17738@vader.DHCP.thefacebook.com>
 <b8de93e9-af4b-d0fc-270e-b938f68688b4@suse.de>
 <f278026c-42f6-9022-f72a-84439141f5d7@kernel.dk>
 <491d4221-8d89-8284-0971-d6f0e47b6463@suse.de>
 <5417a4c9-fb9f-af9e-fa4a-fffb113a0f30@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5417a4c9-fb9f-af9e-fa4a-fffb113a0f30@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@osandov.com>
Cc: Linux Block Layer Mailinglist <linux-block@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/23/2017 04:39 PM, Jens Axboe wrote:
> I tried to look up that commit:
> 
>  48ae8484e9fc ("scsi: sg: don't return bogus Sg_requests")
> 
> but that isn't in Linus' tree. Even searched for just the title, still
> didn't find anything.

It's queued up in Martin's tree [1].

> 
> I'm assuming this is a bug in the sg.c driver, in which case the 2/3
> prep and real test case looks fine. For generic device testing, we
> should just use SG_IO and not bother with sg.c at all. The world would
> be a better place if we could just get rid of sg.c...

Agreed. Yes the bug is in the sg.c driver and we did have quite some of
these lately thanks to the syzcaller folks.

My intention with these tests was to have a place where we can throw in
the syzcaller reproducers and run it in nicely Qemu.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=4.12/scsi-fixes&id=48ae8484e9fc324b4968d33c585e54bc98e44d61

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
