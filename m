From: "SRINATH,VIJAY (HP-India,ex2)" <vijay.srinath@hp.com>
Subject: scsi disk driver behaviour
Date: Fri, 14 Feb 2003 16:05:46 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A11077E28200D51182EA00D0B775525303798AF5@xin02.india.hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'eric@andante.org'" <eric@andante.org>

hello all,

	Iam running Linux Kernel 2.4.9. I have a disk array with a more than
128 luns. Since the maximum number of disk luns that sd driver can see is
128, i expected to see atleast 128. But i noticed that i was not able to
access any lun at all.
	I investigated further and saw that sd_init() in sd.c was returning
a failure. This was because the code where memory is alloc'd for 'hd_struct'
structures was failing. The code snippet is below

<snip>
/*
* FIXME: should unregister blksize_size, hardsect_size and max_sectors
when
* the module is unloaded.
*/
   sd = kmalloc((sd_template.dev_max << 4) *
                 sizeof(struct hd_struct),
                 GFP_ATOMIC);
   if (!sd)
        goto cleanup_sd;
<snip>
   
	The reason is if dev_max is 128, then the total mem size being
malloc'd becomes 139264. The highest value in the cache_size table is 131072
and apparently this seems to be causing the kmalloc to fail. In fact the
kmalloc fails for any dev_max value greater than 120
	
	Also, the SD_EXTRA_DEVS by default is 2 but if i rebuild my kernel
with CONFIG_SD_EXTRA_DEVS set to 128, then no matter how many devices i have
connected to my host, sd_init() will always fail.

	I did not have this problem with kernel 2.4.2-2, where in i notice
that the check to see if 'sd' kmalloc was successful, was absent.
		
	Iam not sure what the fix needs to be (whether to include the next
size 262144 in the cache_sizes table or whether to remove the check like in
2.4.2-2).

	Appreciate any response on this...

thanks
vijay

