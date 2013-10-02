From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] target: Fixes for COMPARE_AND_WRITE backend I/O
 failure cases
Date: Tue, 01 Oct 2013 22:17:14 -0700
Message-ID: <1380691034.19256.36.camel@haakon3.risingtidesystems.com>
References: <1380672796-437-1-git-send-email-nab@daterainc.com>
	 <20131002043157.GA3057@glanzmann.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20131002043157.GA3057@glanzmann.de>
Sender: target-devel-owner@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-10-02 at 06:31 +0200, Thomas Glanzmann wrote:
> Hello Nab,
> 
> > Thomas, these are all fairly obvious fixes to me, and I've been able
> > to confirm them on my setup.  Please confirm on your end, and I'll
> > plan to push them for v3.12-rc4 by the end of the week.
> 
> I confirm that the fixes work. Thank you for fixing this. I did the
> following:
> 
>         - Applied the patches on top of your for-next, recompiled,
>           installed modules and kernel got rid of
>           '/lib/modules/3.11.0-rc5+/extra/' which contained target
>           modules with an unknown symbol __dynamic_pr_debug (from the
>           debug build, I assume)
> 
>         - Started the target, discovered from two esx servers, created
>           VMFS (no error), deployed one VM, used XCOPY to clone it three
>           times, powered it on and did 4 svmotion in parallel.
> 
> So the fix works. I also have the feeling that the xcopy code became
> faster, but I first have to meassure it.
> 

Great, thanks for the confirmation here.

> I'll today some more testing with rescans from 12 ESX and svmotion
> (XCOPY) of 24 VMs in parallel. But everything is looking good from my
> site. I'm also working on the discovery patch.
> 

There is one other regression wrt to the struct iscsi_cmd pre-allocation
changes in v3.12-rc1 code that I'm still tracking down, that you may end
up encountering during stress testing.

It's currently caused by tag starvation under heavy (remotely generated)
I/O load, and manifests itself as percpu_ida_alloc() sleeping
indefinitely in iscsit_allocate_cmd() waiting for new tag(s) to become
available while StatSN acknowledgement is (AFAICT) being blocked
elsewhere.

FYI, the output of 'echo w > /proc/sysrq-trigger', and/or the hung task
checker should produce a stack-trace to this effect.

Please let me know if you encounter any issues, and a patch to address
this bit should be along in the next 24-48 hours.

--nab
