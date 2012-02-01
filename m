From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: FireWire/SBP2 Target mode
Date: Wed, 1 Feb 2012 22:41:56 +0100
Message-ID: <20120201224156.0773ebc6@stein>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de>
	<4F29978A.3010707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4F29978A.3010707@redhat.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Andy Grover <agrover@redhat.com>
Cc: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Feb 01 Andy Grover wrote:
> You're saying the sbp2 protocol can theoretically be used other places
> besides firewire? I'd say put it all in the fabric module for now.

While SBP-2 is explicitly specified for IEEE 1394 a.k.a. FireWire only,
it could be used on any bus architecture which implements IEEE 1212
"Control and Status Registers (CSR) Architecture for Microcomputer
Buses".  But IEEE 1394 a.k.a. FireWire is nowadays the only remaining IEEE
1212 implementation, as far as I know.

On the other hand, the transport protocol SBP-2 can be used to encapsulate
various protocols besides SCSI.  A long time ago I heard that there were
SBP-2 printers that weren't SCSI printers, but I may have confused
something.

The current version of the protocol, SBP-3 which extends SBP-2
in an upwards compatible way, has been developed specifically in
order to transport AV/C command sets.  (AV/C is a set of specifications
from the 1394 Trade Association that build on top of IEC 61883 "Consumer
audio/video equipment - Digital interface" and is used for camcorders,
audio interfaces, studio-grade video equipment, TV set top boxes etc.)
But I am not aware of any existing SBP-3 target or SBP-3 initiator which
actually implements AV/C.

So in short,
  - SBP-2/3 is only used on the FireWire bus.
  - Potentially there could be SBP-2/3 targets or initiators that
    implement something else than SCSI.  But stock SBP-2/3 initiator
    drivers of popular OSs are SCSI initiators, and non-SCSI SBP-2/3
    targets are extremely rare or don't exist actually.
-- 
Stefan Richter
-=====-===-- --=- ----=
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Keep Your Developer Skills Current with LearnDevNow!
The most comprehensive online learning library for Microsoft developers
is just $99.99! Visual Studio, SharePoint, SQL - plus HTML5, CSS3, MVC3,
Metro Style Apps, more. Free future releases when you subscribe now!
http://p.sf.net/sfu/learndevnow-d2d
