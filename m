From: Alexy Khrabrov <braver@pobox.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Sat, 26 Oct 2002 10:53:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021026145309.GA7695@angle.setup.org>
References: <200210210514.g9L5ElYp006401@angle.badbox.com> <20021021163424.GE28914@redhat.com> <20021022032435.GA11986@angle.setup.org> <3DB4E275.BC760EDE@ix.netcom.com> <20021022161644.GA15234@angle.setup.org> <20021022170316.GA31085@redhat.com> <20021022221958.GA17112@angle.setup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021022221958.GA17112@angle.setup.org>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>
Cc: linux-scsi@vger.kernel.org


OK, I've got the CSC (Corpsys) "sca2lvd" adapters and tried them
with my Barracuda ST150176LC's.  The adapters look much more solid
than the anonymous Taiwan-made "v1.1" ones.  The CSC adapters have
two ig red LEDs onboard, the inner part of the circuit board
has a cover, etc.  

However, they too failed to spin my drives at 160, only at 80.
I went back and enabled Wide Negotiation, then trying
to set speed at 160 caused Adaptec 7899 to recognize
the drives as ASYN, hangup, decreasing it to 80 led to their
recognition as 80 and working fine.  

I went back and tried the "v1.1" adapters in that setting,
Wide Negotiation enabled, 80 sync speed, and they worked
at the same speed (as measured by copying a 5 GB from
the 160 drive).  Doh.

So I reread the drive manual, which says that 
Barracuda 50 drives support ANSI SCSI, SCSI-2 and SCSI-3
(Fast-20 and Fast-40), which it says are the same
as Ultra-1 and Ultra-2 for Fast-20/40, respectively.
Mysteriously, Ultra2 is referred to as Ultra80 elsewhere,
so looks like Fast-40 _is_ 80?  If SCSI veterans could
clarify this, I'd see how 40=80...  Especially, given
aic7xxx says something about 80 (40 MHz) in parentheses...

In all cases, seems that it's really the drive, Barracuda 50
family is Ultra2 <=> Ultra80 (right?) but I was able to
enable Wide Negotiation and set speed to 80, and aic7xxx v6.2.8
showed them registered at 80.  I'm just curious if I still could
kinda spin them up to 160 anyways...  :-)

Hence, so far, both SCA<->68 LVD adapters worked as advertised.
I'm going to get a real 160 SCA drive and test it further.
In the same vein, if I do end up getting an Ultra 320 card,
and I will get an Adaptec one, what should I look for in the
drive to see if it's capable of supporting 320?  I'm interested
in Ultra160 drives, usually SCA ones I can get at closeouts,
but I heard (in the Ultra320 thread) that they can spin at 320
in case they support "HBA" -- can someone please elaborate?

Many thanks, I'll put together a SCA<->68 mini-HOWTO based 
on this.

-- 
Cheers,
Alexy Khrabrov :: www.setup.org :: Age Quod Agis
