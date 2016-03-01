From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Bug 112241] Under heavy load FC TARGET going to Oops
Date: Mon, 29 Feb 2016 21:16:04 -0800
Message-ID: <1456809364.19657.184.camel@haakon3.risingtidesystems.com>
References: <bug-112241-11613@https.bugzilla.kernel.org/>
	 <bug-112241-11613-ZpqrUiCAaU@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <bug-112241-11613-ZpqrUiCAaU@https.bugzilla.kernel.org/>
Sender: target-devel-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Anthony,

On Mon, 2016-02-29 at 02:26 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=112241
> 
> Anthony <anthony.bloodoff@gmail.com> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>      Kernel Version|4.3.3                       |4.5.0
> 
> --- Comment #2 from Anthony <anthony.bloodoff@gmail.com> ---
> With kernel 4.5.0 on target, system hang after clients connects to target.
> 

So there are two things going on here.

First, the BUG_ON your ESX <-> LIO FC setup triggered has been addressed
recently in v4.5-rc4 and later kernels with the following series:

http://www.spinics.net/lists/target-devel/msg11822.html

Note these patches will be making it back to earlier stable kernels over
the next weeks.

However, this specific bug is a final consequence of larger ESX v5.5u2+
host side issue of AtomicTestandSet (ATS) heartbeat being enabled (by
default) for all VMFS5 mounts:

https://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2113956

Other folks have been hitting this recently, here's some extra
background:

http://permalink.gmane.org/gmane.linux.scsi.target.devel/11574
http://www.spinics.net/lists/target-devel/msg12124.html

Note this effects all targets w/ VAAI ATS (including EMC, IBM, 3PAR,
SolidFire, etc) and the current solution for ESX v5.5u2+ is to either:

  - Explicitly disable ATS heartbeat usage on all VMFS5 mounts as 
    described in the VMWare -kb article, or:
  - Explicitly disable all ATS logic completely from LIO using 
    emulate_caw=0 on all backends connected to ESX v5.5u2+ hosts
    with VMFS5.

You can google for 'esx ats heartbeat bug' to see the gory details.

Thanks for reporting!

--nab
