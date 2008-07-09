From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: Generic SCSI Target Mid-level For Linux (SCST),	target
 drivers for iSCSI and QLogic Fibre Channel cards released
Date: Wed, 09 Jul 2008 15:19:14 +0400
Message-ID: <48749EB2.1070902@vlnb.net>
References: <4873BCA5.10103@vlnb.net> <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:56170 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753830AbYGILS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2008 07:18:26 -0400
In-Reply-To: <1215551354.3977.6.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, nab@kernel.org

Hi Nicholas,

Nicholas A. Bellinger wrote:
> Hi Vlad,
> 
> On Tue, 2008-07-08 at 23:14 +0400, Vladislav Bolkhovitin wrote:
>> I'm glad to announce that version 1.0.0 of Generic SCSI Target Middle 
>> Level for Linux (SCST) was released and available for download from 
>> http://scst.sourceforge.net/downloads.html
> 
> Congratulations on reaching your v1.0.0 release!

Thanks!

>> Comparison with the mainstream target middle level STGT you can find on 
>> the SCST vs STGT page http://scst.sourceforge.net/scstvsstgt.html. In 
>> short, SCST has the following main advantages over STGT:
> 
> I noticed that you included a reference to my presentation at LSF 08' on
> your SCST vs. STGT page liked above, and took my description of your
> work (you are more than welcome to come and present your own case at LSF
> '09) very much out of context.

I wasn't on the presentation, so on it might have looked as out of 
context. I have only documents, which I referenced. In them, especially 
in "2008 Linux Storage & Filesystem Workshop" summary, it doesn't look 
as I took it out of context. You put emphasis on "older" vs 
"current"/"new", didn't you ;)? Plus, Mike Christie is also listed as an 
author.

BTW, there are another inaccuracies on your slides:

  - STGT doesn't support "hardware accelerated traditional iSCSI 
(Qlogic)", at least I have not found any signs of it.

  - For SCST you wrote "Only project to support PSCSI, FC and SAS Target 
mode (with out of tree hardware drivers)". This is ambiguous statement, 
but looks like you meant that SCST is intended and limited to support 
only the listed transport. This is incorrect. SCST is intended to 
support ALL possible transports and types backstorage.

> If you wish to reference my presentation, please at least make the
> comparision between LIO-Core+LIO-Target vs. SCST vs. STGT, and NOT JUST
> SCST vs. STGT so that the community are large can understand the
> differences and technical challenges.

The SCST vs STGT page was written a long ago, before I ever looked at 
LIO. I wasn't actually going to refer to your presentation, just added a 
small note to your funny, from my POV, "older" vs "new" architecture 
comparison ;)

But, when I have time for careful look, I'm going to write some LIO 
critics. So far, at the first glance:

  - It is too iSCSI-centric. ISCSI is a very special transport, so looks 
like when you decide to add in LIO drivers for other transports, 
especially for parallel SCSI and SAS, you are going to have big troubles 
and major redesign. And this is a real showstopper for making LIO-Core 
the default and the only SCSI target framework. SCST is SCSI-centric, 
just because there's no way to make *SCSI* target framework not being 
SCSI-centric. Nobody blames Linux SCSI (initiator) mid-layer for being 
SCSI-centric, correct?

  - Seems, it's a bit overcomplicated, because it has too many abstract 
interfaces where there's not much need it them. Having too many abstract 
interfaces makes code analyze a lot more complicated. For comparison, 
SCST has only 2 such interfaces: for target drivers and for backstorage 
dev handlers. Plus, there is half-abstract interface for memory 
allocator (sgv_pool_set_allocator()) to allow scst_user to allocate user 
space supplied pages. And they cover all needs.

  - Pass-through mode (PSCSI) also provides non-enforced 1-to-1 
relationship, as it used to be in STGT (now in STGT support for 
pass-through mode seems to be removed), which isn't mentioned anywhere.

  - There is some confusion in the code in the function and variable 
names between persistent and SAM-2 reservations.

  - There is at least one SCSI standard violation: target and LUN resets 
don't clear the reservation.

Again, it is the first impression, without deep analyze, so I might be 
wrong somewhere.

> The more in fighting between the
> leaders in our community, the less the community benefits.

Sure. If my note hurts you, I can remove it. But you should also remove 
from your presentation and the summary paper those psychological 
arguments to not confuse people.

> Many thanks for your most valuable of time,
> 
> --nab

