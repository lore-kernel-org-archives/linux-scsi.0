From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH] [SCSI] remove arbitrary SD_MAX_DISKS namespace limit
Date: Mon, 03 Oct 2011 13:29:24 -0500
Message-ID: <4E89FF04.4040208@oracle.com>
References: <4E89E721.7000308@oracle.com> <1317664679.3041.48.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:39473 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1JCS3f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 14:29:35 -0400
In-Reply-To: <1317664679.3041.48.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 10/03/2011 12:57 PM, James Bottomley wrote:
> On Mon, 2011-10-03 at 11:47 -0500, Dave Kleikamp wrote:
>> I see no reason to limit the SCSI disk namespace to sdXXX. We test
>> systems with more than 18278 LUNs.
>
> I suppose we kept the old limit for historical reasons, so I've no real
> objection to raising it, except the error messages now need to be beefed
> up.  We need one for the ida_get_new() failure and the original
> exhaustion messages needs to move to the sd_format_disk_name() check ...
> that's now what checks we don't go over the possible size in
> DISK_NAME_LEN (I know at 32 it's way beyond INT_MAX ... but just in case
> someone decides to lower it) ... probably it's the same error message
> (but better make it unique for the static checkers).

I'll defer to your judgment on how to fix this. I didn't look at your
git tree, just mainline. Just bumping up SD_MAX_DISKS is sufficient.
Wrapping the calculation in another (( ...) + 1) * 26 should get us
through another decade, I would think. :-) Or any reasonably high
number. INT_MAX?

Thanks,
Shaggy
