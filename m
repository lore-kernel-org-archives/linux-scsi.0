From: Chris Boot <bootc@bootc.net>
Subject: Re: FireWire/SBP2 Target mode
Date: Mon, 06 Feb 2012 13:13:24 +0000
Message-ID: <4F2FD1F4.9050702@bootc.net>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <4F2A60DC.9030007@ladisch.de>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: Clemens Ladisch <clemens@ladisch.de>, Boaz Harrosh <bharrosh@panasas.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

I've been forging ahead in the last few days with my target code and 
have got to a point where it appears to work fairly well and now needs 
some real testing and ideally some initial review.

So far I've tested that I can export LUNs to Linux and Mac OS X machines 
and they can read/write data without issues as you might expect. I've 
even installed Mac OS X onto an exported LUN and booted from it on an 
old PowerBook without issue.

You can pull the code from:
git://github.com/bootc/Linux-SBP-2-Target.git

Or use GitHub to have a look etc...:
https://github.com/bootc/Linux-SBP-2-Target

I used the following script to set up a LUN on the target:

modprobe firewire-sbp-target
mkdir /sys/kernel/config/target/sbp
mkdir /sys/kernel/config/target/sbp/test
mkdir /sys/kernel/config/target/sbp/test/unit_0
mkdir /sys/kernel/config/target/sbp/test/unit_0/lun/lun_0
ln -s /sys/kernel/config/target/core/iblock_0/test 
/sys/kernel/config/target/sbp/test/unit_0/lun/lun_0/test
echo 1 > /sys/kernel/config/target/sbp/test/unit_0/enable

Please note that you can't then disable a unit until all the targets are 
logged-out. For Linux this usually means 'rmmod firewire_sbp2'. This is 
one of the first things I'd like to fix but I'm not entirely sure how to 
go about it yet.

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net
