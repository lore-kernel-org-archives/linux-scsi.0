From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Mon, 04 Aug 2008 14:21:16 -0500
Message-ID: <1217877676.3318.32.camel@localhost.localdomain>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-08-04 at 20:08 +0200, Stefan Richter wrote:
> As a discussion reminded me today, I believe I should merge the
> following patch (could have done so much earlier in fact).  Or is there
> anything speaking against it?

The value 255 is chosen because it worked before.  What you need to do
is establish what the upper limit for firewire is (or indeed if it has
one).

> Meanwhile, SG_ALL has been redefined from 255 to SCSI_MAX_SG_SEGMENTS =
> 128 without me noticing it.  But since several popular architectures
> define ARCH_HAS_SG_CHAIN, we may want to go back to 255 in (fw-)sbp2.
> (Besides, we should also do some tests to figure out an actual optimum.
> And fw-sbp2.c's struct sbp2_command_orb should become variably sized.)

Don't bother with optmium ... that's block's job based on what it sees
from the completions.  All we need to know is maximum.

> Does the most relevant user of large transfers with SBP-2 devices,
> sd-mod, use chained s/g lists?

pass, but firewire is a reasonably slow bus by modern standards, and you
have the protocol overhead for each ORB, so I'd guess there's a point at
which increasing the transaction size doesn't buy anything.

James



-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
