From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [RESEND PATCH v3] scsi: stex: Remove use of struct timeval
Date: Sat, 31 Oct 2015 00:37:51 +0100
Message-ID: <4881842.skchM6NLXo@wuerfel>
References: <20151030083040.GA31741@tina-laptop> <1446195000.16404.55.camel@suse.de> <CAB__kk=s_axDoU4PBr0_6ME+1TTYD_D4+u=t9Vaq9+uMWtazPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAB__kk=s_axDoU4PBr0_6ME+1TTYD_D4+u=t9Vaq9+uMWtazPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Friday 30 October 2015 01:54:10 Tina Ruchandani wrote:
> >
> > Thanks for the conversion. Can you please check if other (scsi) drivers
> > have the same y2038 issues? A quick "git grep do_gettimeofday
> > drivers/scsi/  | wc -l" reveals 30 occurrences (of cause not all are
> > problematic).

In fact all of them are problematic, just for different reasons.

* Some drivers actually overflow in 2038 in a way that causes problems
  in those drivers. These obviously need to be fixed right away.

* A second class of drivers pass time_t/timeval/timespec values to
  or from user space. Even in cases where the absolute numbers are
  small (monotonic times, or time intervals), we have to change them
  to be able to deal with 32-bit user space that will be compiled
  against a modified libc using 64-bit time_t.

* All other driver are likely not broken, but we want to change them
  anyway, to annotate the fact that we have looked at them. My goal
  is to remove the definition of time_t (and all derived structures)
  from the kernel once all drivers have been converted, to ensure that
  we are not adding new broken users, and to have a reasonable
  confidence that we have in actually found the ones that were wrong.

> Hi Johannes,
> Yes, there are quite a few occurrences of timeval within scsi. I had
> sent some of the trivial back in the Feb-May 2015 period, and they
> were ack-ed by my then mentor and a couple of other people, but not
> merged or ack-ed by someone from linux-scsi. Until today, I thought
> using "RESEND" would be impolite, but now I will resend the other ones
> as well. Arnd Bergmann is leading this effort and may have more
> insightful comments.
> 

I provided a "Reviewed-by" tag in https://lkml.org/lkml/2015/5/5/201 .
Normally, when patches get picked up directly from the list, the
person who merges it should add the tags directly.

However, if you have to re-send the patch (with or without
small modifications), you should add that tag after your
Signed-off-by, so it does not get lost when the new patch is
applied.

	Arnd
