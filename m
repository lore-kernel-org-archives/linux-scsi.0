From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: BUG in dma-mapping.h:218 // MESH SCSI driver not working
Date: Mon, 03 Aug 2009 09:13:37 +1000
Message-ID: <1249254817.18245.1.camel@pasglop>
References: <4A68E1CE.4040307@scarlet.be>
	 <1248425553.25467.20.camel@pasglop>  <4A70937B.7040201@scarlet.be>
	 <1248910358.1509.27.camel@pasglop>  <4A70DE54.5090406@scarlet.be>
	 <1248915149.1509.29.camel@pasglop>  <4A7553E7.6030804@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:58152 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbZHBXN5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Aug 2009 19:13:57 -0400
In-Reply-To: <4A7553E7.6030804@scarlet.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stef Simoens <stef.simoens@scarlet.be>
Cc: linuxppc-dev@lists.ozlabs.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2009-08-02 at 10:52 +0200, Stef Simoens wrote:
> Hey Benjamin,
> 
Thanks for the bisection. I'll have a look when I'm back from skiing :-)
In the meantime, maybe Fujita has an idea ?

Mesh is an old crappy piece of HW with an old driver full of dark
secrets that Paulus wrote eons ago, so I'd rather avoid cracking it
open :-)
 
Cheers,
Ben.

> Benjamin Herrenschmidt schreef: 
> > On Thu, 2009-07-30 at 01:42 +0200, Stef Simoens wrote:
> >   
> > > What would be the best approach?
> > > - if the kernel boots, it's obviously 'good'
> > > - but what if the kernel hits the 'BUG', should I apply your patch
> > > then? If it doesn't work with your patch, would it be 'bad' then? 
> > >     
> A few reboots later...
> As you said, during my bisecting, at a certain moment I needed your
> patch (I booted, got a problem, patched the tree with your patch,
> rebooted, it worked).
> 
> Then, git says:
> f078727b250c2653fc9a564f15547c17ebac3f99 is first bad commit
> commit f078727b250c2653fc9a564f15547c17ebac3f99
> Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date:   Sun Dec 14 01:23:45 2008 +0900
> 
>     [SCSI] remove scsi_req_map_sg
>     
>     No one uses scsi_execute_async with data transfer now. We can
> remove
>     scsi_req_map_sg.
>     
>     Only scsi_eh_lock_door uses scsi_execute_async. scsi_eh_lock_door
>     doesn't handle sense and the callback. So we can remove
>     scsi_io_context too.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> 
> :040000 040000 c4621d866c1ee5fd8d30e44f702a4966b8ebdc44
> 3ffca800399e52ef12f1001721c0c7ff431efafd M    drivers
> :040000 040000 805c02c4ad3c63c45dffa18f413e92bfca99caf6
> 6fb58bb5fb19c4198fa7d626d6241086655c6307 M    include
> 
> At this moment, the reason for the crash is different then in v2.6.30
> I noted the following (I hope to have written the most important
> stuff).
> driver 'sd' needs update
> mesh: lost arbitration  
> sd 0:0:0:0 sda read CAPACITY failed
> sd ...
> sd 0:0:0:0 sdb read CAPACITY failed
> sd ...
> mice  
> sd ...
> mice: PS/2 ...
> TCP cubic ... 
> Initializing XFRM ...
> NET ... protcol 17   
> XFS ...
> VFS : unable to mount root FS
> 
> If you want more input ... please let me know.
> -- 
> Kr,
> Stef Simoens
> plain text document attachment (git-bisect-log)
> git bisect start
> # good: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
> git bisect good 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
> # bad: [577c9c456f0e1371cbade38eaf91ae8e8a308555] Linux 2.6.30-rc1
> git bisect bad 577c9c456f0e1371cbade38eaf91ae8e8a308555
> # bad: [5658ae9007490c18853fbf112f1b3516f5949e62] V4L/DVB (10342): gspca - stv06xx: Add ctrl caching to the vv6410.
> git bisect bad 5658ae9007490c18853fbf112f1b3516f5949e62
> # good: [08abe18af1f78ee80c3c3a5ac47c3e0ae0beadf6] Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
> git bisect good 08abe18af1f78ee80c3c3a5ac47c3e0ae0beadf6
> # good: [6e15cf04860074ad032e88c306bea656bbdd0f22] Merge branch 'core/percpu' into percpu-cpumask-x86-for-linus-2
> git bisect good 6e15cf04860074ad032e88c306bea656bbdd0f22
> # bad: [eedf2c5296a8dfaaf9aec1a938c1d3bd73159a30] Merge git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async-for-30
> git bisect bad eedf2c5296a8dfaaf9aec1a938c1d3bd73159a30
> # good: [0870352bc6e0dee485c86a0c99dd60e7089c8917] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6
> git bisect good 0870352bc6e0dee485c86a0c99dd60e7089c8917
> # good: [febb02bdfe5e2c6ceaa0a38d8b7afca3d98f415a] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6
> git bisect good febb02bdfe5e2c6ceaa0a38d8b7afca3d98f415a
> # bad: [21283916322f579a580e413652cdefbfa3ec676f] [SCSI] zfcp: remove undefined subtype for status read response
> git bisect bad 21283916322f579a580e413652cdefbfa3ec676f
> # good: [6864abd8b730435d6ae9cb061095229a5a85153f] [SCSI] osd: Kconfig file for in-tree builds
> git bisect good 6864abd8b730435d6ae9cb061095229a5a85153f
> # bad: [b3f1f9aa082b2ab86dec4db3d8b1566af345387e] [SCSI] ses: code_set == 1 is tested twice
> git bisect bad b3f1f9aa082b2ab86dec4db3d8b1566af345387e
> # bad: [ea41e41588c248ee8b8162869c1e1c0565a4b3f6] [SCSI] scsi_dh_rdac: Retry for Quiescence in Progress in rdac device handler
> git bisect bad ea41e41588c248ee8b8162869c1e1c0565a4b3f6
> # bad: [f078727b250c2653fc9a564f15547c17ebac3f99] [SCSI] remove scsi_req_map_sg
> git bisect bad f078727b250c2653fc9a564f15547c17ebac3f99
> # good: [78a42ce8fb2604c459e9ebb2a4f2d546b8250111] [SCSI] osst: make all the buffer the same size
> git bisect good 78a42ce8fb2604c459e9ebb2a4f2d546b8250111
> # good: [26243043f207b3faa00594a33e10b2103205f27b] [SCSI] osst: replace scsi_execute_async with the block layer API
> git bisect good 26243043f207b3faa00594a33e10b2103205f27b

