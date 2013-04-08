From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: mpt2sas + raid10 goes boom
Date: Mon, 8 Apr 2013 09:32:42 -0400
Message-ID: <20130408093242.34100af7@jlaw-desktop.mno.stratus.com>
References: <20130408071834.GA15457@onthe.net.au>
	<20130408075351.GA16422@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130408075351.GA16422@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, 8 Apr 2013 03:53:51 -0400
"Chris Dunlop" <chris@onthe.net.au> wrote:

> Upon reflection, given this smells like a controller issue, this
> may be better addressed to linux-scsi@vger.kernel.org...
> 
> On Mon, Apr 08, 2013 at 05:18:34PM +1000, Chris Dunlop wrote:
[... snip ...]
> Apr  8 15:08:53 b4 kernel: [  448.657142] md4: WRITE SAME failed.
> Manually zeroing.

Hi Chris,

WRITE SAME was broken in MD RAID 1/10 up until: 

  c8dc9c6 md: raid1,10: Handle REQ_WRITE_SAME flag in write bios

and should be present in any kernel that includes the block layer WRITE
SAME changes:

 4363ac7 block: Implement support for WRITE SAME
 579e8f3 block: Make blkdev_issue_zeroout use WRITE SAME

Neil -- should c8dc9c6 go to stable?


Regards,

-- Joe
