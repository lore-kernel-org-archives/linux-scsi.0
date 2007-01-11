From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Thu, 11 Jan 2007 11:30:53 -0800
Message-ID: <45A6906D.3040805@us.ibm.com>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:42218 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXAKTbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 14:31:01 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BJUuJb014063
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 14:30:56 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BJUuaK507530
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 12:30:56 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BJUtHh016545
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 12:30:56 -0700
In-Reply-To: <45A6570C.3090308@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Tarjei Huse <tarjei@scanventure.no>, linux-scsi@vger.kernel.org, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>

[cc'ing a few contacts at adaptec]

Douglas Gilbert wrote:
> Tarjei Huse wrote:
>> Hi, I'm working on getting Linux to use my SATA drives on an IBM x306
>> running a HostRaid controller that uses the adaptech 9405w chipset.
<snip>
>> c) In the thread Darrick Wong refers to another branch[1] that contains
>> (according to him) a lot of fixes for this chipset. Is that branch
>> confirmed to work with my chipset?

Yes.  I'd also strongly recommend consideration of patches #23 and #26
from here:

http://sweaglesw.net/~djwong/docs/sas_ata-patches/

I create my kernel tree by cloning the linux-2.6 git tree and then
applying scsi-misc-2.6, scsi-rc-fixes-2.6 and aic94xx-sas-2.6 patches
atop that.  And then the giant long slew of patches atop *that*.

>> I have also tried to compile the latest rc of the 2.6.20 kernel and
>> loaded up the aic94xx driver + firmware. I then ended up getting the
>> same errors that started the above mentioned thread on this list.

Yes, because you need the changes that are in aic94xx-sas that add SATA
support.  Ideally that message would have printed something less
cryptic, such as "SATA device found but not supported in this driver!",
but that's water under the bridge at this point.

> it was too old) showed the same problems (tmf timeouts). Then

The TMF timeout problems (and several other bugs) were fixed in v18 of
the sequencer firmware blob.  Alexis, Ed, and Gilbert are currently
working to have the firmware blob posted on Adaptec's web site.  I think
the sequencer is up to v28 now?

(Vaporware, I know, but hopefully we can nip this one in the bud soon.)

> Luben Tuikov sent me a version of his driver with a "use_msi"
> related fix in it. My 48300 has been rock solid since. The last
> time I tried "Darrick's" driver (about a week ago) it failed in
> the fashion unto which I have become accustomed.

I'm not certain that I'm completely aware of the failures that you're
seeing with the driver.  Can you send me the BIOS firmware level, the
sequencer version (probably v17 since that's the only one that I know of
that's available on the 'net), and a dmesg output?

> I have encouraged people to talk amongst themselves about the
> use_msi patch, but I don't believe that I should be reverse
> engineering that patch. There are other issues. As you may
> understand from the above, I am walking on a bit of a tight rope
> here.

Are you enabling MSI mode?  There is a known bug where one needs to kick
one of the CHIMINTEN bits if a certain flag is set, though none of the
IBM boxes require MSI (and at the moment it isn't working anyway...).

>> 2. http://www.jimmy.co.at/weblog/?p=71

Egad.

Anyway, patches are forthcoming.

--D
