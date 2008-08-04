From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Mon, 04 Aug 2008 21:58:23 +0200
Message-ID: <48975F5F.90906@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
	<1217877676.3318.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1217877676.3318.32.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-08-04 at 20:08 +0200, Stefan Richter wrote:
>> As a discussion reminded me today, I believe I should merge the
>> following patch (could have done so much earlier in fact).  Or is there
>> anything speaking against it?
> 
> The value 255 is chosen because it worked before.  What you need to do
> is establish what the upper limit for firewire is (or indeed if it has
> one).

The limit is 65535, following from SBP-2 clause 5.1.2, definition of 
data_size.

[Side note:  The SBP-2 s/g list (a.k.a. page table) consists of 64bit 
wide entries and needs to be contiguous in memory from the POV of the 
FireWire PCI or PCIe controller, and the SBP-2 target reads the table 
from the initiator's memory.  The (fw-)sbp2 driver builds this table as 
a copy of the kernel's s/g list; but this was certainly already to the 
reader clear from the context in the diff.]

>> Meanwhile, SG_ALL has been redefined from 255 to SCSI_MAX_SG_SEGMENTS =
>> 128 without me noticing it.  But since several popular architectures
>> define ARCH_HAS_SG_CHAIN, we may want to go back to 255 in (fw-)sbp2.
>> (Besides, we should also do some tests to figure out an actual optimum.
>> And fw-sbp2.c's struct sbp2_command_orb should become variably sized.)
> 
> Don't bother with optmium ... that's block's job based on what it sees
> from the completions.  All we need to know is maximum.

OK, with the small caveat that the current (fw-)sbp2 driver code is 
somewhat simplistic WRT page table handling and geared towards rather 
short page tables.  But this may be possible to enhance without too much 
difficulty.

>> Does the most relevant user of large transfers with SBP-2 devices,
>> sd-mod, use chained s/g lists?
> 
> pass, but firewire is a reasonably slow bus by modern standards, and you

A 3200 Mb/s spec exists :-) (though no silicon yet, to my knowledge).

> have the protocol overhead for each ORB, so I'd guess there's a point at
> which increasing the transaction size doesn't buy anything.
> 
> James

-- 
Stefan Richter
-=====-==--- =--- --=--
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
