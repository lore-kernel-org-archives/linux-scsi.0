From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: mpt2sas + raid10 goes boom
Date: Tue, 9 Apr 2013 12:22:29 +1000
Message-ID: <20130409022229.GA2872@onthe.net.au>
References: <20130408071834.GA15457@onthe.net.au>
 <20130408075351.GA16422@onthe.net.au>
 <20130408093242.34100af7@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.onthe.net.au ([203.22.196.249]:50706 "EHLO
	smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3DICWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Apr 2013 22:22:32 -0400
Content-Disposition: inline
In-Reply-To: <20130408093242.34100af7@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, NeilBrown <neilb@suse.de>

On Mon, Apr 08, 2013 at 09:32:42AM -0400, Joe Lawrence wrote:
> On Mon, 8 Apr 2013 03:53:51 -0400
> "Chris Dunlop" <chris@onthe.net.au> wrote:
> 
>> Upon reflection, given this smells like a controller issue, this
>> may be better addressed to linux-scsi@vger.kernel.org...
>> 
>> On Mon, Apr 08, 2013 at 05:18:34PM +1000, Chris Dunlop wrote:
> [... snip ...]
>> Apr  8 15:08:53 b4 kernel: [  448.657142] md4: WRITE SAME failed.
>> Manually zeroing.
> 
> Hi Chris,
> 
> WRITE SAME was broken in MD RAID 1/10 up until: 
> 
>   c8dc9c6 md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
> 
> and should be present in any kernel that includes the block layer WRITE
> SAME changes:
> 
>  4363ac7 block: Implement support for WRITE SAME
>  579e8f3 block: Make blkdev_issue_zeroout use WRITE SAME

Aha! That did it. My kernels, 3.7.3 and 3.7.10, include the
latter two changes but not the former. A cherry-pick of c8dc9c6
fixed the issue for me.

> Neil -- should c8dc9c6 go to stable?

I think it definitely should. Without it you can't create a
raid10 and it looks like you have a controller issue!


Thanks Joe, and to all who took an interest in my problem!

Cheers,

Chris.
