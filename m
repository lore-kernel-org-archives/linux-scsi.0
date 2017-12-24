From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Sun, 24 Dec 2017 12:10:44 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1712221359270.3@nippy.intranet>
References: <20171221024049.36509-1-yanaijie@huawei.com> <1513872544.2931.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:36576 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdLXBKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Dec 2017 20:10:42 -0500
In-Reply-To: <1513872544.2931.13.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>

Hi Bart,

On Thu, 21 Dec 2017, Bart Van Assche wrote:

> There are several reasons why most kernel maintainers ignore patches 
> like this one silently:
> 

I don't disagree with your conclusion but I think that these objections 
may have solutions, at least in principle. Your message prompted me write 
them down. I've long thought that our process has some room for 
improvement.

I think Linux needs an official automatic code reformatter. C.f. TeX and 
math typesetting. Not a bunch of regular expressions, but an actual C 
parser that can produce correct line breaks and indentation based on the 
depth of the parse tree and correctly deal with macro definitions and so 
on. The style guide is probably ambiguous and inconsistent so I'd make 
this reformatter the final arbiter on style matters.

Then it would be possible to automatically regenerate a patch (or rebase a 
commit) so it could still be applied to the tip even after the tip has had 
some clean-up. This becomes possible when all clean-up uses the same 
process, so it produces the same result.

> * Whitespace changes make it harder than necessary to backport patches 
>   to distro kernels. Before a patch that came later than the whitespace 
>   changes can be backported, the whitespace change has to be backported. 
>   Additionally, if a whitespace change touches many source files, the 
>   order in which to backport patches becomes really important.

When a post-clean-up commit needs to be backported to a branch made 
pre-clean-up, the prerequisite changes could be automatically generated 
for the old branch as needed.

Note that this is already possible where the clean-up is scripted e.g.
$ sed -i -e 's,[ \t]*$,,' drivers/scsi/scsi_lib.c
which is actually the subject of this thread.

> * Before a kernel developer posts a patch that fixes a bug she or he has
>   to verify the change history (git log -p) to figure out which patch 
>   introduced the bug. Patches that only change coding style pollute the 
>   change history.

A clean-up commit would be pollution but (assuming the code style rules 
don't change) as a one-off event that patch might be preferable to 
perpetuating readability issues indefinitely. IMHO open source code should 
aim to maximize readability and re-usability (in general).

> * Accepting a patch that only changes whitespace would open the
>   floodgates for other kernel coding style change patches. If a patch 
>   that only changes whitespace would get accepted it will become hard to 
>   keep other kernel coding style change patches out.

Given the right tooling, code style patches need never blight maintainers' 
inboxes again. Such patches could be ignored and/or interpreted as 
suggestions that the maintainer run a script to improve some part of their 
tree under development (given that the resulting merge conflicts would be 
resolved automatically).

In the event that someone needed to work on a messy file, they could start 
with an automatic clean-up but they would not submit the clean-up patch 
because the maintainer can just run the same automatic process. Reviewing 
that patch would be a tedious waste of time. The rest of the submission 
also becomes easier to review. E.g. a patch like this would end up 
shorter,

 static char foo[] = {
 	'b',
-	'a'
+	'a',
+	'r',
 };

because the missing comma would not appear in the diff, as it was fixed 
implicitly. Thus irrelevant style changes disappear from the submission 
and cease to distract reviewers from the effect of the changes, which is 
what matters.

The unreliable checkpatch style checks could then be replaced with a 
simple diff against the output of the reformatter. If a maintainer still 
receives patches with style issues but no other issues, they should be 
able to automatically correct the patch so it produces the correct code 
style and then commit the corrected version without everyone having to go 
through another email submission iteration (which polutes many inboxes). 
This need not break the rest of a patch series or patch queue, which could 
be automatically rebased/regenerated.

Of course, the fly in the ointment is that the reformatter tool would have 
to be infallible, or at least beyond reproach. This seems to imply either 
infinite bikeshedding or else a final decision from above and probably an 
implementation too (something like 'sparse').

AFAIK this idea is purely hypothetical so thanks for entertaining it.

Happy Christmas.

-- 
