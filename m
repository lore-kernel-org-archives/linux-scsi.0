From: Andrew Morton <akpm@digeo.com>
Subject: Re: 2.5.63-mm2
Date: Tue, 4 Mar 2003 23:40:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030304234042.2553deed.akpm@digeo.com>
References: <20030302180959.3c9c437a.akpm@digeo.com>
	<1046815078.12931.79.camel@ibm-b>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1046815078.12931.79.camel@ibm-b>
List-Id: linux-scsi@vger.kernel.org
To: Mark Wong <markw@osdl.org>
Cc: linux-scsi@vger.kernel.org

Mark Wong <markw@osdl.org> wrote:
>
> It appears something is conflicting with the old Adapatec AIC7xxx.  My
> system halts when it attempts to probe the devices (I think it's that.) 
> So I started using the new AIC7xxx driver and all is well.  I don't see
> any messages to the console that points to any causes.  Is there
> someplace I can look for a clue to the problem?
> 
> I actually didn't realize I was using the old driver and have no qualms
> about not using it, but if it'll help someone else, I can help gather
> information.
> 

Well aic7xxx_old fails for me in 2.5.62, as well as later kernels.
Always in the same way.  It gets stuck at boot:

(gdb) bt
#0  wait_for_completion (x=0xc8dbfea8) at kernel/sched.c:1408
#1  0xc024295d in scsi_wait_req (SRpnt=0xf7e22a00, cmnd=0xc8dbfeec, buffer=0xc03fce60, bufflen=36, timeout=6000, 
    retries=3) at drivers/scsi/scsi.c:673
#2  0xc024839f in scsi_probe_lun (sreq=0xf7e22a00, inq_result=0xc03fce60 "", bflags=0xc8dbff20)
    at drivers/scsi/scsi_scan.c:1050
#3  0xc024877e in scsi_probe_and_add_lun (host=0xf7e92600, q=0xc8dbff80, channel=0, id=2, lun=0, bflagsp=0xc8dbff54)
    at drivers/scsi/scsi_scan.c:1372
#4  0xc0248a8e in scsi_scan_target (shost=0xf7e92600, q=0xc8dbff80, channel=0, id=2) at drivers/scsi/scsi_scan.c:1835
#5  0xc0248b7e in scsi_scan_host (shost=0xf7e92600) at drivers/scsi/scsi_scan.c:1892
#6  0xc0243b9e in scsi_add_host (shost=0xf7e92600, dev=0x0) at drivers/scsi/hosts.c:314
#7  0xc0243fbd in scsi_register_host (shost_tp=<incomplete type>) at drivers/scsi/hosts.c:513
#8  0xc03b3259 in init_this_scsi_driver () at drivers/scsi/scsi_module.c:38
#9  0xc03a07d5 in do_initcalls () at init/main.c:472
#10 0xc03a0803 in do_basic_setup () at init/main.c:497
#11 0xc01050a7 in init (unused=0x0) at init/main.c:535
