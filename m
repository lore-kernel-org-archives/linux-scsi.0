From: Tejun Heo <tj@kernel.org>
Subject: Re: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Mon, 20 Dec 2010 18:12:56 +0100
Message-ID: <4D0F8E98.9070500@kernel.org>
References: <201012201105.08993.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201012201105.08993.Martin@lichtvoll.de>
Sender: linux-ide-owner@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On 12/20/2010 11:05 AM, Martin Steigerwald wrote:
> Hi!
> 
> top - 10:49:07 up 3 days, 14:24,  8 users,  load average: 2.31, 2.62, 2.28
> Tasks: 198 total,   2 running, 194 sleeping,   0 stopped,   2 zombie
> Cpu(s):  6.8%us, 93.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  
> 0.0%st
> Mem:   2073660k total,  1941152k used,   132508k free,   153876k buffers
> Swap:  4000180k total,   243452k used,  3756728k free,   676612k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                               
>   735 root      20   0     0    0    0 R 85.2  0.0 137:28.94 scsi_eh_11
> 
> I don't see anything in dmesg. Everything appears to work as normal, 
> except for the slowness. Which got a bit better upon renicing scsi_eh_11 
> to 19 (not knowing whether its really safe, but it works for now).
> 
> Interrupts appear to be within usual range as well:

Can you please apply the following patch, trigger the problem and
attach the kernel log?

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..c748b5a 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -888,12 +888,19 @@ void ata_eh_fastdrain_timerfn(unsigned long arg)
  */
 static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)
 {
+	static int xxx;
 	int cnt;

 	/* already scheduled? */
 	if (ap->pflags & ATA_PFLAG_EH_PENDING)
 		return;

+	if (!(ap->pflags & ATA_PFLAG_LOADING) && xxx < 16) {
+		ata_port_printk(ap, KERN_WARNING, "XXX ata_eh_set_pending()\n");
+		dump_stack();
+		xxx++;
+	}
+
 	ap->pflags |= ATA_PFLAG_EH_PENDING;

 	if (!fastdrain)

-- 
tejun
