From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 24 May 2013 09:13:03 +0200
Message-ID: <519F12FF.6090809@redhat.com>
References: <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org> <519CDDA4.2050100@redhat.com> <20130522193009.GA23845@mtj.dyndns.org> <519D360D.4050309@redhat.com> <20130522221737.GA12339@mtj.dyndns.org> <519DC926.4000106@redhat.com> <20130523090222.GA26592@mtj.dyndns.org> <519DE5AD.7080303@redhat.com> <20130524014405.GB16882@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130524014405.GB16882@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 24/05/2013 03:44, Tejun Heo ha scritto:
> On Thu, May 23, 2013 at 11:47:25AM +0200, Paolo Bonzini wrote:
>>> No no, I'm not talking about it not working for the users - it's just
>>> passing the commands, it of course works.  I'm doubting about it being
>>> a worthy security isolation layer.  cdb filtering (of any form really)
>>> has always been something on the border.  It always was something we
>>> got stuck with due to lack of other immediate options.
>>
>> I understood correctly then. :)  I agree it's not the best, but it's not
>> completely broken either.  It has bugs, and that's what these patches
>> try to fix.
> 
> The same filtering table being applied to different classes of
> hardware is a software bug, but my point is that the practive
> essentially entrusts non-insignificant part of security enforcement to
> the hardware itself.  The variety of hardware in question is very wide
> and significant portion has historically been known to be flaky.

Unproven theory, and contradicted by actual practice.  Bugs are more
common in the handling of borderline conditions, not in the handling of
unimplemented commands.

If you want to be secure aginst buggy firmware, the commands you have to
block are READ and WRITE.  Check out the list of existing USB quirks.

>>> I'm wondering whether combining 3 into 4 would be good enough.
>>
>> No, it wouldn't.  I learnt it the hard way (by having a patch nacked :))
>> at http://thread.gmane.org/gmane.linux.kernel/1311887.
> 
> Of course you can't do that by adding dangerous commands to the
> existing filtering table which is allowed by default.  I'm saying
> "count me out" knob could be good enough.  Neither is perfect but at
> least the latter doesn't affect the default cases.

You need to allow more commands.

The count-me-out knob allows all commands.

You cannot always allow all commands.

Ergo, you cannot always use the count-me-out knob.

Paolo
