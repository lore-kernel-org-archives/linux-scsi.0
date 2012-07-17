From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in target_get_sess_cmd()
Date: Tue, 17 Jul 2012 12:28:20 -0700
Message-ID: <5005BCD4.7080006@redhat.com>
References: <1342461882-5848-1-git-send-email-roland@kernel.org> <1342461882-5848-6-git-send-email-roland@kernel.org> <1342480139.18004.309.camel@haakon2.linux-iscsi.org> <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com> <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com> <1342490218.18004.382.camel@haakon2.linux-iscsi.org> <CAL1RGDUVaF_GGwN_0nYD2X87Sa0hwiihuua9HJgK=CJ7HiFv_w@mail.gmail.com> <20120717163909.GB15995@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20120717163909.GB15995@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/17/2012 09:39 AM, Christoph Hellwig wrote:
> On Tue, Jul 17, 2012 at 09:34:49AM -0700, Roland Dreier wrote:
>> Sleeping on things, I now feel pretty strongly that having target_submit_cmd
>> return an error value for "immediate" errors where the command does not
>> make it into the target core is the right approach.
> 
> I think it is.  When I tried to convert other drivers to
> target_submit_cmd while doing the target processing thread removal that
> would have simplified a lot of things.
> 
>> Freeing commands is already one of the most confusing and complex parts
>> of the target code, with "check_stop_free," "cmd_wait_comp" and
>> "SCF_ACK_KREF."  Adding another code flow back to the fabric driver
>> with yet another set of semantics around freeing a command seems like
>> it's making things even harder to maintain.
> 
> True.  And the above mess really needs to be simplified, too.

I'm ok with submit_cmd returning a value for now. Maybe in the end it
doesn't, but getting the code working comes first.

This is one of those areas that needs a complete rewrite, so who cares
if there's some dirt on the floor when the whole joint is due for
remodeling.

-- Andy
