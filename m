From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx drivers
Date: Thu, 07 Oct 2004 01:36:52 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41646574.7080107@tls.msk.ru>
References: <linux.scsi.20040621161047.GD16453@master.mivlgu.local> <41644BD5.7030807@tls.msk.ru> <20041006202543.GA22794@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:29519 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S269534AbUJFVfI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 17:35:08 -0400
In-Reply-To: <20041006202543.GA22794@wotan.suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: Sergey Vlasov <vsu@altlinux.ru>, linux-scsi@vger.kernel.org, Luben Tuikov <luben_tuikov@adaptec.com>

Andi Kleen wrote:
> On Wed, Oct 06, 2004 at 11:47:33PM +0400, Michael Tokarev wrote:
[]
>>I found several "OEM" (on-board) aic79xx controllers (mostly on
>>HP boxes) that breaks after the above-mentioned change, which
>>found it's way into 2.6.8 kernel.  For example, HP ProLiant ML
> 
> I don't think it's merged in mainline, no. Or at least 2.6.9rc3 
> doesn't have it.

Interesting.  Well... looks like it's debian stuff.  I'm sorry
about this - should have looked better.  So, that's even better:
the change like this should generate quite some breakage, and
it's good it isn't applied.

And now as I see the problem is debian-specific, the more
"interesting" debian patch looks, here's the description:

## DP: Description: Export proper PCI ID table to hotplug in aic7xxx/aic79xx
## DP: Patch author: Andi Kleen <ak@suse.de>
## DP: Upstream status: submitted (long ago, aic7xx maintaince is horrible)

oh well... :(

(original message (with patch) can be found at
http://groups.google.com/groups?selm=linux.scsi.20040621182440.0743036f.ak%40suse.de
)

[]
>>Also, I tried to guess what all those new PCI ID macros does
>>in the driver, but that's quite a challenge: deeply-nested
>>macros with non-obvious bit manipulation... ;)   So I can't
> 
> They just try to match large groups without too much typing....

Figured that much ;)

> 
> If I remember the patch correctly it only matches the Adaptec vendor id. 

Well not really.  Or, rather, it indeed only matches by 0x9005
as vendor, but there's also _subsytem_ vendor and _subsystem_ device
which does not match now.  Device reports:

device=9005:801f, subsystem=103c:103c (Hewlett-Packard)
device=9005:801f, subsystem=1025:002a (Acer Labs)

etc.  The pci_table correctly matches the device part,
but only accepts subsystem=9005:ffff (which seems to
be wrong).

> For HP there will need to be an special entry (probably needs some
> reverse engineering from the original code) 

Note again it isn't main vendor_id, it's subsystem vendor_id.
Main vendor_id is still 0x9005.

>>Maybe just list all subsystems as wildcards?
> 
> No, i don't think that's a good idea.

Now I've 4 different variations of 9005:801f - the same
card, but with different subsystem ids.  Several of other
AIC97xx cards actually uses wildcarded *sub*system_{vendor,id},
eg 9005:800f.  And there are actually 16 different devices
which where mentioned by Luden in that thread (0x80xx) -- the
driver code basically just ignores subsystem identifiers for
almost all of them.

> At least the vendors should be listed explicitely. 
> Otherwise hotplug autoloading is unhappy because bogus modules 
> get loaded all the time.

Yes -- vendor_id, but not subvendor_id.

/mjt

> I can go over it again at some point, but currently I don't 
> have too much time, so it would be good if someone else would
> tackle it.
> 
> Luben, can you just do a proper pci_id table please? You probably
> know the requirements best.
> 
> -Andi
