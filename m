From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 00/10] sg buffer copy helper functions
Date: Tue, 11 Mar 2008 12:05:06 +0200
Message-ID: <47D65952.2050302@panasas.com>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>	<47D5415C.3010904@panasas.com> <20080311070956E.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080311070956E.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, dougg@torque.net, Geert.Uytterhoeven@sonycom.com, tony.luck@intel.com, Mark_Salyzyn@adaptec.com, ed.lin@promise.com, linuxraid@amcc.com, linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 11 2008 at 0:39 +0200, FUJITA Tomonori <tomof@acm.org> wrote:
> CC'ed linux-ide,
> 
> On Mon, 10 Mar 2008 16:10:36 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> On Sun, Mar 09 2008 at 6:44 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>>> This patchset adds new two helper functions to copy data between an SG
>>> table and liner buffer, and converts severl LLDs to use them.
>>>
>>> The new APIs are used mainly in the code to spoof SCSI commands
>>> (INQUIRY, READ CAPACITY, MODE SENSE etc), that is, LLDs build a fake
>>> reposense and copy it to the sg list in scsi_cmnd struct. Several LLDs
>>> have similar functions for such code. This patchset removes such
>>> duplication.
>>>
>>> Another reason to do this work is that because we relaxed the default
>>> alignment requirements (from 511 to 3) post 2.6.24, the above commands
>>> might come with multiple scatter gather entries but several LLDs make
>>> the assumption that such commands come with only one sg entries and
>>> can't handle multiple sg entries. The new APIs can handle multiple sg
>>> entries so LLDs don't need to care about anything.
>>>
>>> The first patch adds the new APIs to lib/scatterlist.c and the rest
>>> are for SCSI. I like to push the whole patchset via scsi-misc (since
>>> it's easier).
>>>
>>> This is against scsi-misc (a6680f71ca27ea78c4c4e577076aecb9ace476f1).
>>>
>>>  arch/ia64/hp/sim/simscsi.c    |   23 ++--------
>>>  drivers/scsi/3w-9xxx.c        |   21 ++++-----
>>>  drivers/scsi/3w-xxxx.c        |   12 +----
>>>  drivers/scsi/aacraid/aachba.c |   49 ++++++++--------------
>>>  drivers/scsi/ips.c            |   50 ++++-------------------
>>>  drivers/scsi/ps3rom.c         |   92 ++++------------------------------------
>>>  drivers/scsi/scsi_debug.c     |   79 ++++++-----------------------------
>>>  drivers/scsi/stex.c           |   66 ++++-------------------------
>>>  include/linux/scatterlist.h   |    5 ++
>>>  include/scsi/scsi_cmnd.h      |   14 ++++++
>>>  lib/scatterlist.c             |   90 ++++++++++++++++++++++++++++++++++++++++
>>>  11 files changed, 182 insertions(+), 319 deletions(-)
>>>
>>>
>> Hi Tomo. Nice cleanup, Cheers.
>>
>> Have you had a look at drivers/usb/storage/protocol.c usb_stor_access_xfer_buf() ?
>> It looks like it could also use these, but there they have a twist where they want
>> to do it in parts. Do you think that the code there could also use the helpers 
>> presented here somehow? (I know that one of the USB guys was asking about it)
> 
> I've not. If the USB people are eager to use the new APIs, I'll try
> though I prefer to keep them simple.
> 

CC: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

> There are other potential users of the new APIs, gdth and libata.
> 
> I think that gdth can use the APIs without any changes to the APIs but
> I leave it to a gdth expert.

Sure I can do that. Thanks

> 
> ata_scsi_simulate could use the new APIs but it directly builds a
> response in the buffer of a sg list instead of building a response in
> temporary buffer and copying it to a sg list. So the new APIs are not
> fit for it. If libata people are fine with switching to the latter,
> I'll send a patch.

Boaz

