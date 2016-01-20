From: Andrew Donnellan <andrew.donnellan-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Re: [PATCH 03/13] irq_poll: fold irq_poll_sched_prep into
 irq_poll_sched
Date: Wed, 20 Jan 2016 18:02:30 +1100
Message-ID: <569F3106.7000205@au1.ibm.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-4-git-send-email-hch@lst.de> <5682584A.5030708@sandisk.com>
 <20151230094253.GB12904@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151230094253.GB12904-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 30/12/15 20:42, Christoph Hellwig wrote:
> On Tue, Dec 29, 2015 at 10:54:18AM +0100, Bart Van Assche wrote:
>> After having applied these changes the SRP initiator didn't receive any
>> RDMA completions anymore. I could remedy that by changing
>> "!test_and_set_bit()" into "test_and_set_bit()":
>
> Yes.  I actually had this bug earlier, fixed it and managed to get
> it back during a rebase, d'oh.

I'm hitting an issue on a ppc64le box running linux-next, which 
according to git bisect is caused by this patch.

It looks like I might be hitting a dodgy error path as well, as we seem 
to be trying to execute data.

Any ideas?


Andrew

---

Sent SIGTERM to all processes
Sent SIGKILL to all processes
  -> smp_release_cpus()
spinning_secondaries = 47
  <- smp_release_cpus()
  <- setup_system()
sr 0:0:1:0: tag#0 Resetting device
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 t0
ata1.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 3
          Test Unit Ready 00 00 00 00 00 00res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1: translated ATA stat/err 0xd1/00 to SCSI SK/ASC/ASCQ 0xb/47/00
sd 1:2:0:0: tag#0 Resetting device
ata1.00: failed to set xfermode (err_mask=0x4)
ipr 0003:04:00.0: Timed out waiting for aborted commands
ipr 0003:04:00.0: Adapter being reset as a result of error recovery.
ata1.00: failed to set xfermode (err_mask=0x4)
ata1.00: failed to set xfermode (err_mask=0x4)
ipr 0001:04:00.0: Adapter being reset as a result of error recovery.
cpu 0x0: Vector: e40 (Emulation Assist) at [c000000000daf2e0]
     pc: c000000000e51ae8: dump_list_lock+0x0/0x4
     lr: c0000000000f46e4: __wake_up_common+0x84/0xf0
     sp: c000000000daf560
    msr: 9000000102089033
   current = 0xc000000000d6f500
   paca    = 0xc00000000fe00000   softe: 0        irq_happened: 0x01
     pid   = 0, comm = swapper/0
Linux version 4.4.0-next-20160118 (ajd@ka1) (gcc version 5.2.1 20150930 
(GCC) ) #13 SMP Tue Jan 19 12:04:19 AEDT 2016
enter ? for help
[link register   ] c0000000000f46e4 __wake_up_common+0x84/0xf0
[c000000000daf560] c000000000da1100 pps_cdev_fops+0xc8/0x100 (unreliable)
[c000000000daf5c0] c0000000000f5264 complete+0x54/0x90
[c000000000daf600] c00000000061f44c ata_qc_complete_internal+0x1c/0x30
[c000000000daf620] c000000000622828 __ata_qc_complete+0xb8/0x190
[c000000000daf660] c0000000005ef6e4 ipr_sata_eh_done+0x64/0x80
[c000000000daf680] c0000000005ef530 ipr_fail_all_ops+0x100/0x250
[c000000000daf740] c0000000005ffbf8 ipr_reset_restore_cfg_space+0x98/0x230
[c000000000daf7b0] c0000000005ed500 ipr_reset_ioa_job+0x80/0xf0
[c000000000daf7e0] c0000000005ebfac ipr_reset_timer_done+0xac/0xe0
[c000000000daf820] c00000000011eae4 call_timer_fn+0x54/0x180
[c000000000daf8b0] c00000000011ef2c run_timer_softirq+0x2ec/0x3a0
[c000000000daf980] c0000000000a4ee8 __do_softirq+0x188/0x3b0
[c000000000dafa70] c0000000000a5358 irq_exit+0xc8/0x100
[c000000000dafa90] c00000000001d894 timer_interrupt+0xa4/0xe0
[c000000000dafac0] c000000000002750 decrementer_common+0x150/0x180
--- Exception: 901 (Decrementer) at c000000000010364 
arch_local_irq_restore+0x74/0x90
[c000000000dafdb0] c000000000dac000 init_thread_union+0x0/0x4000 
(unreliable)
[c000000000dafdd0] c000000000016be8 arch_cpu_idle+0x108/0x160
[c000000000dafe00] c0000000000f5594 default_idle_call+0x44/0x80
[c000000000dafe20] c0000000000f5a48 cpu_startup_entry+0x3d8/0x450
[c000000000dafee0] c00000000000bbe4 rest_init+0xa4/0xc0
[c000000000daff00] c000000000c14014 start_kernel+0x524/0x540
[c000000000daff90] c000000000008c60 start_here_common+0x20/0xa0
0:mon>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
