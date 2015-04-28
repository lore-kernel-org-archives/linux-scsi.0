From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scatterlist: enable sg chaining for all architectures
Date: Tue, 28 Apr 2015 14:27:43 -0700
Message-ID: <20150428142743.578d1c930aca013b596d7546@linux-foundation.org>
References: <1429973776-7499-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1429973776-7499-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 25 Apr 2015 23:56:16 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Some architectures enable sg chaining option while others do not.
> 
> The requirement to enable sg chaining is that pages must be aligned
> at a 32-bit boundary in order to overload the LSB of the pointer.
> Regardless of whether ARCH_HAS_SG_CHAIN is defined or not, the above
> requirement is always chacked by BUG_ON() in sg_assign_page.  So
> all architectures can enable sg chaining.
> 
> As you can see from the changes in drivers/target/target_core_rd.c,
> enabling SG chaining for all architectures allows us to allocate
> discontiguous scatterlist tables which can be traversed throughout
> by sg_next() without a special handling for some architectures.

Thanks, I'll grab this.  If anyone has concerns, speak now or hold both
pieces!
