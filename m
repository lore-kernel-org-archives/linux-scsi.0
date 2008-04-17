From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3 ver3] scsi: varlen extended and vendor-specific cdbs
Date: Thu, 17 Apr 2008 16:29:13 +0300
Message-ID: <480750A9.2070008@panasas.com>
References: <48059F51.9060401@panasas.com> <20080417123224X.tomof@acm.org>
 <480741B3.2080709@panasas.com> <20080417220450J.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout4.netvision.net.il ([194.90.9.27]:44904 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYDQN3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 09:29:16 -0400
Received: from bh-buildlin2.bhalevy.com ([212.235.53.3])
 by mxout4.netvision.net.il
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZH00MRA1GQH7A0@mxout4.netvision.net.il> for
 linux-scsi@vger.kernel.org; Thu, 17 Apr 2008 16:29:14 +0300 (IDT)
In-reply-to: <20080417220450J.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Pete Wyckoff <pw@osc.edu>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, bzolnier@gmail.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com

On Thu, Apr 17 2008 at 16:04 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> On Thu, 17 Apr 2008 15:25:23 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>   Add support for variable-length, extended, and vendor specific
>>   CDBs to scsi-ml. It is now possible for initiators and ULD's
>>   to issue these types of commands. LLDs need not change much.
>>   All they need is to raise the .max_cmd_len to the longest command
>>   they support (see iscsi patch).
>>
>>   - clean-up some code paths that did not expect commands to be
>>     larger than 16, and change cmd_len members' type to short as
>>     char is not enough.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
>> ---
>>  block/scsi_ioctl.c       |    5 ++---
>>  drivers/scsi/constants.c |   10 +++-------
>>  drivers/scsi/scsi.c      |   15 ++++-----------
>>  drivers/scsi/scsi_lib.c  |    2 +-
>>  include/scsi/scsi.h      |   40 +++++++++++++++++++++++++++++++++-------
>>  include/scsi/scsi_cmnd.h |    2 +-
>>  include/scsi/scsi_host.h |    8 +++-----
>>  7 files changed, 47 insertions(+), 35 deletions(-)
> 
> looks fine to me though I've not tested it.
> --

I agree, we need more testing. I'm doing that right now.
I've been running with the old patch for ages and also
Pete had a nice heavy load on that code. But this here
was not tried as log. Pete if you have a ready made setup
maybe you can give it a go. Tomo perhaps you can add these
3 patches to your tests.

You need:
   linux-block for-2.6.26 branch - for block support of large commands
   scsi-misc - for iscsi's bidi and extended commands
   these three patches. - scsi varlen support
And then the patch for bsg.

But over all I have audit the code and it looks good, Tomo
was right it was redundant code.

Boaz

