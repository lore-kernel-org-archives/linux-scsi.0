From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in
 target_get_sess_cmd()
Date: Tue, 17 Jul 2012 12:39:09 -0400
Message-ID: <20120717163909.GB15995@infradead.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
 <1342461882-5848-6-git-send-email-roland@kernel.org>
 <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
 <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
 <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com>
 <1342490218.18004.382.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUVaF_GGwN_0nYD2X87Sa0hwiihuua9HJgK=CJ7HiFv_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUVaF_GGwN_0nYD2X87Sa0hwiihuua9HJgK=CJ7HiFv_w@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 17, 2012 at 09:34:49AM -0700, Roland Dreier wrote:
> Sleeping on things, I now feel pretty strongly that having target_submit_cmd
> return an error value for "immediate" errors where the command does not
> make it into the target core is the right approach.

I think it is.  When I tried to convert other drivers to
target_submit_cmd while doing the target processing thread removal that
would have simplified a lot of things.

> Freeing commands is already one of the most confusing and complex parts
> of the target code, with "check_stop_free," "cmd_wait_comp" and
> "SCF_ACK_KREF."  Adding another code flow back to the fabric driver
> with yet another set of semantics around freeing a command seems like
> it's making things even harder to maintain.

True.  And the above mess really needs to be simplified, too.
