From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Sun, 28 Oct 2018 08:44:06 -0700
Message-ID: <20181028154405.GA26300@infradead.org>
References: <20181025225548.GA10326@flashbox>
 <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org>
 <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
 <1540589437.66186.124.camel@acm.org>
 <CAKwvOdm-xYRqCBXhLC1ceC44_rEmggW4qiSgGpRkpL+p-NadVg@mail.gmail.com>
 <1540591147.66186.127.camel@acm.org>
 <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
 <1540592684.66186.136.camel@acm.org>
 <yq1o9bfcydm.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1o9bfcydm.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Nick Desaulniers <ndesaulniers@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, ooo@electrozaur.com, Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 27, 2018 at 09:28:21AM -0400, Martin K. Petersen wrote:
> The OSD protocol failed to get traction in the industry, adoption was
> very limited. If the code just plugged straight into existing kernel
> interfaces it would be easier to justify keeping it around. However, the
> OSD support requires bidirectional command support so we carry a bunch
> of additional plumbing in both block and SCSI to accommodate it. There
> are no other users of these interfaces, so dropping OSD would mean we
> could simplify some (hot) code paths. That would be a win in my book.
> Consequently, if a patch were to materialize that disentangled and
> removed OSD, I'd be inclined to merge it.

In addition to the exofs and osd removal I sent out I've also done the
SCSI cleanup here:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/remove-scsi-osd

unfortunately the bsg-lib code also uses the block bidi support, but
then again at least for the blk-mq case that code isn't too bad,
and Jens is about to remove the legacy request code.
