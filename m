From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] block: add alt_size
Date: Sat, 09 May 2009 23:04:12 +0900
Message-ID: <4A058D5C.6030206@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
	<1241828002-12742-2-git-send-email-tj@kernel.org>
	<ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, Mauelshagen@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hello,

Kay Sievers wrote:
> What does "alt_" stand for? I think that should be more descriptive in
> an exported interface.

Alternative.

> And can we please keep the "size_*" in front of the name, so that they
> group together?

Maybe, but size_alt?  Any better ideas?

> Also, values with magic block counts, while there is no way to get the
> blocksize with the same interface, are pretty weird. I think the
> current "size" attribute is just a bug.

Logical block size is fixed at 512 bytes.  Offset and size are always
represented in multiples of 512 bytes and only get converted to
hardware block size in the lld.

> Not sure, how that should be solved, by adding a "blocksize" attribute
> that is always in the same context as the current "size*" values, or
> by just using bytes for new attributes here.
> 
> Almost all tools I've seen using these attributes, have hardcoded *
> 512 in there, which may cause trouble pretty soon. And this is mostly
> a failure of the interface and not of the users, I think.

No, it will never break.  It will always be 512.  It's there to give
nine bit shift to allow additional 9 bit of addressing without going
to the next full blown bitwidth.  It's chosen to be the lowest common
denominator which gives enough addressing boost to hold things
together till the next bitwidth becomes popular.

For userlevel exporting, it might have been better to use just bytes
there as preformance isn't really an issue, but, well, it's already
determined, so..

Thanks.

-- 
tejun
