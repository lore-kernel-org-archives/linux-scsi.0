From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding directly
 to prep
Date: Mon, 02 Aug 2010 23:01:23 -0400
Message-ID: <4C578683.5010409@teksavvy.com>
References: <1277917264.2839.153.camel@mulgrave.site> <20100701104653O.fujita.tomonori@lab.ntt.co.jp> <20100702110343.GA27159@lst.de> <20100705160023S.fujita.tomonori@lab.ntt.co.jp> <20100705192413.GA24189@lst.de> <4C3253C0.8040900@teksavvy.com> <4C3254A3.6080709@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:43523 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752835Ab0HCDBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2010 23:01:25 -0400
In-Reply-To: <4C3254A3.6080709@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-ide@vger.kernel.org

On 10-07-05 05:54 PM, Mark Lord wrote:
>> On 05/07/10 03:24 PM, Christoph Hellwig wrote:
>>>
>>> What codebase were you testing on? Sorry, but curently I'm a bit lost
>>> in the maze of patches. I've got both and intel and an OCZ SSD
> ..
>
> Do you, or anyone else with one, know what the upper limit is on
> TRIM operations with the Intel SSDs ?
>
> I need to know the maximum amount of TRIM ranges they will process
> in a single command.
>
> Eg. Indilinx-based SSDs don't appear to have a limit -- they'll accept
> a TRIM command with thousands of LBA ranges included.
>
> Sandforce-based SSDs appear to restrict things to max 4KB of range data.
>
> So.. what about Intel?


Well, I still don't know about Intel drives -- anyone?

But for the latest hardware, some manufacturers are now reporting
their TRIM limits in word[105] of the identify data,
as described (optional) in the latest draft ATA ACS-2 specs.

It appears that Sandforce drives officially only allow 512-bytes of range data.
So I'll limit hdparm's TRIM functions to match word[105] when it is specified.

The Indilinx drives I have here don't report anything in word[105], though.

Cheers
