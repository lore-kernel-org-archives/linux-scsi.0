From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: GFP_ATOMIC allocations...
Date: Thu, 29 Aug 2002 10:10:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020829101029.A16346@eng2.beaverton.ibm.com>
References: <20020828202534.G30927@redhat.com> <20020828174737.A27554@eng2.beaverton.ibm.com> <20020828214215.A31167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from northrelay03.pok.ibm.com (northrelay03.pok.ibm.com [9.56.224.151])
	by e1.ny.us.ibm.com (8.12.2/8.12.2) with ESMTP id g7THAQEG013054
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2002 13:10:30 -0400
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by northrelay03.pok.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g7THANw6118766
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2002 13:10:24 -0400
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id g7THAAv15425
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2002 10:10:10 -0700
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g7THAT817891
	for linux-scsi@vger.kernel.org; Thu, 29 Aug 2002 10:10:29 -0700 (PDT)
In-Reply-To: <20020828214215.A31167@redhat.com>; from dledford@redhat.com on Wed, Aug 28, 2002 at 09:42:15PM -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2002 at 09:42:15PM -0400, Doug Ledford wrote:

> I've known people that had actual, real problems because of the GFP_ATOMIC 
> allocations in this code area.  It was related to bringing up a fiber 
> controller that had 100s of disks hanging off of it and therefore wanted 
> to do a *LOT* of atomic allocations in a short period of time, but it was 
> a real problem none the less.  Making the allocations non-atomic would 
> allow the scanning to block waiting on more ram instead of bailing on 
> devices.
> 

There are some bad allocations in sd.c - there's now a (single) GFP_DMA
buffer for test unit ready, spinup and the write protect check, where we
used scsi_malloc() in 2.4.

There are a bunch of vmalloc's most of them should be kmalloc's. 

Here's the sd.c code that does the vmalloc:

#define init_mem_lth(x,n)	x = vmalloc((n) * sizeof(*x))
#define zero_mem_lth(x,n)	memset(x, 0, (n) * sizeof(*x))

	init_mem_lth(sd_dsk_arr, sd_template.dev_max);
	if (sd_dsk_arr) {
		zero_mem_lth(sd_dsk_arr, sd_template.dev_max);
		for (k = 0; k < sd_template.dev_max; ++k) {
			sdkp = vmalloc(sizeof(Scsi_Disk));
			if (NULL == sdkp)
				goto cleanup_mem;
			memset(sdkp, 0, sizeof(Scsi_Disk));
			sd_dsk_arr[k] = sdkp;
		}
	}
	init_mem_lth(sd_disks, sd_template.dev_max);
	if (sd_disks)
		zero_mem_lth(sd_disks, sd_template.dev_max);
	init_mem_lth(sd, maxparts);

	if (!sd_dsk_arr || !sd || !sd_disks)
		goto cleanup_mem;

	zero_mem_lth(sd, maxparts);
	return 0;

#undef init_mem_lth
#undef zero_mem_lth

The sdkp = vmalloc() certainly should be kmalloc().

Each of the init_mem_lth and associated variable:

	static Scsi_Disk ** sd_dsk_arr;
	init_mem_lth(sd_dsk_arr, sd_template.dev_max);

	static struct gendisk **sd_disks;
	init_mem_lth(sd_disks, sd_template.dev_max);

	struct hd_struct *sd;
	init_mem_lth(sd, maxparts);

dev_max maximum is N_SD_MAJORS * SCSI_DISKS_PER_MAJOR right now 128 (8 * 16),
even doubling won't hit kmalloc limits if we want an array of pointers
(256 * 4 or 256 * 8).

So only the last one might need a vmalloc(), since maxparts is max_dev * 16,
and hd_structs are larger.

The only use of sd is in sd_attach to set the part - can we now just
allocate a hd_struct as needed in sd_attach, as part of the struct *p
data? Also it looks like there is never a kfree(p) for the normal
non-error case.

Or, can the size be checked and vmalloc() only called when necessary,
or called if kmalloc() fails?

-- Patrick Mansfield
