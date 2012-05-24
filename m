From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
Date: Thu, 24 May 2012 18:19:36 +0800
Message-ID: <CAF1ivSZBasH-Nvw7kvOynN+XQqiOLfeyOnV5HjNbz5dyZJfkoA@mail.gmail.com>
References: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
	<Pine.LNX.4.44L0.1205211059510.1725-100000@iolanthe.rowland.org>
	<CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64374 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab2EXKTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 May 2012 06:19:37 -0400
In-Reply-To: <CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, May 21, 2012 at 11:14 PM, Lin Ming <ming.m.lin@intel.com> wrote=
:
> On Mon, May 21, 2012 at 11:00 PM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
>> On Mon, 21 May 2012, Lin Ming wrote:
>>
>>> On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.=
edu> wrote:
>>> [snip]
>>> > I may have left some parts out from this brief description. =A0Ho=
pefully
>>> > you'll be able to figure out the general idea and get it to work.
>>>
>>> All journal threads and flusher thread of the disk need to be freez=
ed
>>> before suspend and thaw after resume.
>>
>> Why? =A0If any of those threads needs to write something to the disk
>> while the disk is suspended, the disk will simply be resumed.
>
> When tested the patches, I found that kjournald and flusher thread
> frequently resume the disk.

Just found that it's because "printk".

When disk is suspended, it prints out some message, for example,

[  670.597103] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  670.597827] sd 0:0:0:0: [sda] Stopping disk

Then syslogd is waken up to write the log.
So disk is resumed right after suspended.

Lin Ming

>
> I'm not familiar with journal.
> Are the journal threads still need to be in active state when the dis=
k
> is already suspended?
>
>>
>> Alan Stern
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
