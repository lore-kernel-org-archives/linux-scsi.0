From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 1/6] ilog2: create truly constant version for sparse
Date: Tue, 17 Apr 2018 17:07:04 -0700
Message-ID: <CA+55aFxLY2=RVAD8m-3bf4vKWpPKWSmjN_tLVWwb4Y7w81UTbA@mail.gmail.com>
References: <20180417233511.6573-1-mwilck@suse.com> <20180417233511.6573-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417233511.6573-2-mwilck@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 17, 2018 at 4:35 PM, Martin Wilck <mwilck@suse.com> wrote:
> Sparse emits errors about ilog2() in array indices because of the use of
> __ilog2_32() and __ilog2_64(),

If sparse warns about it, then presumably gcc with -Wvla warns about it too?

And if thats the case, then __builtin_constant_p() and a ternary
operation isn't good enough, because gcc -Wvla is even more anal than
sparse is.

Which is why we have that __is_constexpr() magic for min/max().

So I suspect that what you'd want is

  #define ilog2(n) \
        __builtin_choose_expr(__is_constexpr(n), \
                const_ilog2(n), \
                __builtin_choose_expr(sizeof(n) <= 4, \
                        __ilog2_u32(n), \
                        __ilog2_u64(n)))

or something. Hmm?

           Linus
