From: "Guilherme G. Piccoli" <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Mon, 6 Feb 2017 11:19:41 -0200
Message-ID: <631008bd-1e05-2c88-b153-695c76128eb4@linux.vnet.ibm.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
 <56447FF7.40600@dev.mellanox.co.il> <5644FD6C.9070805@cs.wisc.edu>
 <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
 <56461502.70306@cs.wisc.edu>
 <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
 <20161107181556.cnhwst4nu63xtrqk@straylight.hirudinean.org>
 <5820C68E.6050206@linux.vnet.ibm.com>
 <20161109052142.j4psips7yvx7uohx@straylight.hirudinean.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------C6172F10CCBA83E84B9E7370"
Return-path: <open-iscsi+bncBD235QUNTYKBB7XP4HCAKGQEKOEEI7A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20161109052142.j4psips7yvx7uohx-r8IHplWLGbA5tHQWs+pTeqPFFGjUI2lm2LY78lusg7I@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomopongratz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------C6172F10CCBA83E84B9E7370
Content-Type: text/plain; charset=UTF-8

On 09/11/2016 03:21, Chris Leech wrote:
> On Mon, Nov 07, 2016 at 04:23:10PM -0200, Guilherme G. Piccoli wrote:
>>
>> Sure! Count on us to test any patches. I guess the first step is to
>> reproduce on upstream right? We haven't tested specifically this
>> scenario for long time. Will try to reproduce on 4.9-rc4 and update here.
> 
> Great, I'm looking forward to hearing the result.
> 
> Assuming it reproduces, I don't think this level of fine grained locking
> is necessarily the best solution, but it may help confirm the problem.
> Especially if the WARN_ONCE I slipped in here triggers.

Chris, sorry for my huge delay.
Finally I was able to perform tests and I have good news - seems your
patch below fixed the issue.

Firstly, I was able to reproduce with kernel 4.10-rc6. See the file
repro.out - it's a dump from xmon, the kernel debugger from PowerPC.
With this tool we can dump the exception details, registers, PACA
(Processor Address Communication Area, ppc specific structure) and
dmesg. It took me less than 15 minutes to reproduce.

Then, I applied your patch on the top of this kernel and the benchmark
was able to successfully complete, in about 3 hours. We can see the
WARN() you added was reached, the attached file dmesg-cleech_patch shows
the kernel log with your patch.

The workload was FIO benchmark doing both reads and writes to the remote
storage via iSCSI, connected over ethernet direct cabling (10Gb speed).
Distro was Ubuntu 16.04.1 .

Any more tests or info you need, please let me know!
Cheers,


Guilherme


> - Chris
> 
> ---
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f9b6fba..fbd18ab 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -560,8 +560,12 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
>  	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
>  	task->state = state;
> 
> -	if (!list_empty(&task->running))
> +	spin_lock_bh(&conn->taskqueuelock);
> +	if (!list_empty(&task->running)) {
> +		WARN_ONCE(1, "iscsi_complete_task while task on list");
>  		list_del_init(&task->running);
> +	}
> +	spin_unlock_bh(&conn->taskqueuelock);
> 
>  	if (conn->task == task)
>  		conn->task = NULL;
> @@ -783,7 +787,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		if (session->tt->xmit_task(task))
>  			goto free_task;
>  	} else {
> +		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->mgmtqueue);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
> 
> @@ -1474,8 +1480,10 @@ void iscsi_requeue_task(struct iscsi_task *task)
>  	 * this may be on the requeue list already if the xmit_task callout
>  	 * is handling the r2ts while we are adding new ones
>  	 */
> +	spin_lock_bh(&conn->taskqueuelock);
>  	if (list_empty(&task->running))
>  		list_add_tail(&task->running, &conn->requeue);
> +	spin_unlock_bh(&conn->taskqueuelock);
>  	iscsi_conn_queue_work(conn);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_requeue_task);
> @@ -1512,22 +1520,26 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	 * only have one nop-out as a ping from us and targets should not
>  	 * overflow us with nop-ins
>  	 */
> +	spin_lock_bh(&conn->taskqueuelock);
>  check_mgmt:
>  	while (!list_empty(&conn->mgmtqueue)) {
>  		conn->task = list_entry(conn->mgmtqueue.next,
>  					 struct iscsi_task, running);
>  		list_del_init(&conn->task->running);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		if (iscsi_prep_mgmt_task(conn, conn->task)) {
>  			/* regular RX path uses back_lock */
>  			spin_lock_bh(&conn->session->back_lock);
>  			__iscsi_put_task(conn->task);
>  			spin_unlock_bh(&conn->session->back_lock);
>  			conn->task = NULL;
> +			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
>  		rc = iscsi_xmit_task(conn);
>  		if (rc)
>  			goto done;
> +		spin_lock_bh(&conn->taskqueuelock);
>  	}
> 
>  	/* process pending command queue */
> @@ -1535,19 +1547,24 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>  					running);
>  		list_del_init(&conn->task->running);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
>  			fail_scsi_task(conn->task, DID_IMM_RETRY);
> +			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
>  		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
>  		if (rc) {
>  			if (rc == -ENOMEM || rc == -EACCES) {
> +				spin_lock_bh(&conn->taskqueuelock);
>  				list_add_tail(&conn->task->running,
>  					      &conn->cmdqueue);
>  				conn->task = NULL;
> +				spin_unlock_bh(&conn->taskqueuelock);
>  				goto done;
>  			} else
>  				fail_scsi_task(conn->task, DID_ABORT);
> +			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
>  		rc = iscsi_xmit_task(conn);
> @@ -1558,6 +1575,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		 * we need to check the mgmt queue for nops that need to
>  		 * be sent to aviod starvation
>  		 */
> +		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> @@ -1577,12 +1595,15 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		conn->task = task;
>  		list_del_init(&conn->task->running);
>  		conn->task->state = ISCSI_TASK_RUNNING;
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		rc = iscsi_xmit_task(conn);
>  		if (rc)
>  			goto done;
> +		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> +	spin_unlock_bh(&conn->taskqueuelock);
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  	return -ENODATA;
> 
> @@ -1738,7 +1759,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  			goto prepd_reject;
>  		}
>  	} else {
> +		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->cmdqueue);
> +		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
> 
> @@ -2897,6 +2920,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  	INIT_LIST_HEAD(&conn->mgmtqueue);
>  	INIT_LIST_HEAD(&conn->cmdqueue);
>  	INIT_LIST_HEAD(&conn->requeue);
> +	spin_lock_init(&conn->taskqueuelock);
>  	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
> 
>  	/* allocate login_task used for the login/text sequences */
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4d1c46a..c7b1dc7 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -196,6 +196,7 @@ struct iscsi_conn {
>  	struct iscsi_task	*task;		/* xmit task in progress */
> 
>  	/* xmit */
> +	spinlock_t		taskqueuelock;  /* protects the next three lists */
>  	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
>  	struct list_head	cmdqueue;	/* data-path cmd queue */
>  	struct list_head	requeue;	/* tasks needing another run */
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

--------------C6172F10CCBA83E84B9E7370
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-cleech_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-cleech_patch"

[    0.000000] opal: OPAL detected !
[    0.000000] Allocated 4718592 bytes for 2048 pacas at c00000000fb80000
[    0.000000] Page sizes from device-tree:
[    0.000000] base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
[    0.000000] base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
[    0.000000] base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
[    0.000000] base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
[    0.000000] base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
[    0.000000] base_shift=20: shift=20, sllp=0x0130, avpnm=0x00000000, tlbiel=0, penc=2
[    0.000000] base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
[    0.000000] base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
[    0.000000] Page orders: linear mapping = 24, virtual = 16, io = 16, vmemmap = 24
[    0.000000] Using 1TB segments
[    0.000000] Initializing hash mmu with SLB
[    0.000000] Linux version 4.10.0-rc6-gpiccoli-cleech+ (root@fs28) (gcc version 5.4.0 20160609 (Ubuntu/IBM 5.4.0-6ubuntu1~16.04.4) ) #7 SMP Fri Feb 3 11:06:52 CST 2017
[    0.000000] Found initrd at 0xc0000000030e0000:0xc00000000566f5ef
[    0.000000] OPAL: Power8 LPC bus found, chip ID 0
[    0.000000] Using PowerNV machine description
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] CPU maps initialized for 8 threads per core
[    0.000000]  (thread shift is 3)
[    0.000000] Freed 4390912 bytes for unused pacas
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size    = 0x0
[    0.000000] phys_mem_size     = 0x1000000000
[    0.000000] dcache_bsize      = 0x80
[    0.000000] icache_bsize      = 0x80
[    0.000000] cpu_features      = 0x27fc7aed18500249
[    0.000000]   possible        = 0x7fffffff18500649
[    0.000000]   always          = 0x0000000018100040
[    0.000000] cpu_user_features = 0xdc0065c2 0xef000000
[    0.000000] mmu_features      = 0x7c004001
[    0.000000] firmware_features = 0x0000000110000000
[    0.000000] htab_address      = 0xc000000ff8000000
[    0.000000] htab_hash_mask    = 0x7ffff
[    0.000000] -----------------------------------------------------
[    0.000000] cma: Reserved 3280 MiB at 0x0000000f2b000000
[    0.000000] numa: Initmem setup node 0 [mem 0x00000000-0xfffffffff]
[    0.000000] numa:   NODE_DATA [mem 0xfff376300-0xfff37ffff]
[    0.000000] numa: Initmem setup node 8
[    0.000000] numa:   NODE_DATA [mem 0xfff35c600-0xfff3662ff]
[    0.000000] numa:     NODE_DATA(8) on node 0
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe40000000)
[    0.000000] PCI host bridge /pciex@3fffe40000000  ranges:
[    0.000000]  MEM 0x00003fe000000000..0x00003fe07ffeffff -> 0x0000000080000000 
[    0.000000]  MEM 0x00003b0000000000..0x00003b0fffffffff -> 0x00003b0000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x800)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe40100000)
[    0.000000] PCI host bridge /pciex@3fffe40100000  ranges:
[    0.000000]  MEM 0x00003fe080000000..0x00003fe0fffeffff -> 0x0000000080000000 
[    0.000000]  MEM 0x00003b1000000000..0x00003b1fffffffff -> 0x00003b1000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x1000)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe41000000)
[    0.000000] PCI host bridge /pciex@3fffe41000000  ranges:
[    0.000000]  MEM 0x00003fe800000000..0x00003fe87ffeffff -> 0x0000000080000000 
[    0.000000]  MEM 0x00003c0000000000..0x00003c0fffffffff -> 0x00003c0000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x10800)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe41100000)
[    0.000000] PCI host bridge /pciex@3fffe41100000  ranges:
[    0.000000]  MEM 0x00003fe880000000..0x00003fe8fffeffff -> 0x0000000080000000 
[    0.000000]  MEM 0x00003c1000000000..0x00003c1fffffffff -> 0x00003c1000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x11000)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe41200000)
[    0.000000] PCI host bridge /pciex@3fffe41200000 (primary) ranges:
[    0.000000]  MEM 0x00003fe900000000..0x00003fe97ffeffff -> 0x0000000080000000 
[    0.000000]  MEM 0x00003c2000000000..0x00003c2fffffffff -> 0x00003c2000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x11800)
[    0.000000] OPAL nvram setup, 589824 bytes
[    0.000000] Top of RAM: 0x1000000000, Total RAM: 0x1000000000
[    0.000000] Memory hole size: 0MB
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 1024 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 1048576 pages, LIFO batch:1
[    0.000000] Could not find start_pfn for node 8
[    0.000000] Initmem setup node 8 [mem 0x0000000000000000-0x0000000000000000]
[    0.000000] On node 8 totalpages: 0
[    0.000000] percpu: Embedded 3 pages/cpu @c000000f29000000 s149016 r0 d47592 u262144
[    0.000000] pcpu-alloc: s149016 r0 d47592 u262144 alloc=1*1048576
[    0.000000] pcpu-alloc: [0] 000 001 002 003 [0] 004 005 006 007 
[    0.000000] pcpu-alloc: [0] 008 009 010 011 [0] 012 013 014 015 
[    0.000000] pcpu-alloc: [0] 016 017 018 019 [0] 020 021 022 023 
[    0.000000] pcpu-alloc: [0] 024 025 026 027 [0] 028 029 030 031 
[    0.000000] pcpu-alloc: [0] 032 033 034 035 [0] 036 037 038 039 
[    0.000000] pcpu-alloc: [0] 040 041 042 043 [0] 044 045 046 047 
[    0.000000] pcpu-alloc: [0] 048 049 050 051 [0] 052 053 054 055 
[    0.000000] pcpu-alloc: [0] 056 057 058 059 [0] 060 061 062 063 
[    0.000000] pcpu-alloc: [0] 064 065 066 067 [0] 068 069 070 071 
[    0.000000] pcpu-alloc: [0] 072 073 074 075 [0] 076 077 078 079 
[    0.000000] pcpu-alloc: [0] 080 081 082 083 [0] 084 085 086 087 
[    0.000000] pcpu-alloc: [0] 088 089 090 091 [0] 092 093 094 095 
[    0.000000] pcpu-alloc: [0] 096 097 098 099 [0] 100 101 102 103 
[    0.000000] pcpu-alloc: [0] 104 105 106 107 [0] 108 109 110 111 
[    0.000000] pcpu-alloc: [0] 112 113 114 115 [0] 116 117 118 119 
[    0.000000] pcpu-alloc: [0] 120 121 122 123 [0] 124 125 126 127 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1047552
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: root=UUID=3c17131a-9724-4e4f-b094-b4b5ed53e767 ro xmon=on
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 520192 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 1048576 bytes
[    0.000000] early log buf free: 122760(93%)
[    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
[    0.000000] Memory: 63365760K/67108864K available (11904K kernel code, 1600K rwdata, 3524K rodata, 4416K init, 2972K bss, 384384K reserved, 3358720K cma-reserved)
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=128, Nodes=9
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=128.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=128
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000000] ICS OPAL backend registered
[    0.000000] time_init: decrementer frequency = 512.000000 MHz
[    0.000000] time_init: processor frequency   = 3325.000000 MHz
[    0.000004] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
[    0.001617] clocksource: timebase mult[1f40000] shift[24] registered
[    0.002672] clockevent: decrementer mult[83126e98] shift[32] cpu[56]
[    0.002890] Console: colour dummy device 80x25
[    0.003769] console [hvc0] enabled
[    0.004460] bootconsole [udbg0] disabled
[    0.005281] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.005407] pid_max: default: 131072 minimum: 1024
[    0.005657] Security Framework initialized
[    0.005698] Yama: becoming mindful.
[    0.005755] AppArmor: AppArmor initialized
[    0.006484] Dentry cache hash table entries: 8388608 (order: 10, 67108864 bytes)
[    0.043771] Inode-cache hash table entries: 4194304 (order: 9, 33554432 bytes)
[    0.062677] Mount-cache hash table entries: 131072 (order: 4, 1048576 bytes)
[    0.062982] Mountpoint-cache hash table entries: 131072 (order: 4, 1048576 bytes)
[    0.064969] ftrace: allocating 30000 entries in 11 pages
[    0.081982] EEH: PowerNV platform initialized
[    0.082227] POWER8 performance monitor hardware support registered
[    0.084367] smp: Bringing up secondary CPUs ...
[    0.191655] random: fast init done
[    0.316763] smp: Brought up 2 nodes, 128 CPUs
[    0.317180] numa: Node 0 CPUs: 64-127
[    0.317237] numa: Node 8 CPUs: 0-63
[    0.332220] devtmpfs: initialized
[    0.454062] evm: security.selinux
[    0.454306] evm: security.SMACK64
[    0.454355] evm: security.SMACK64EXEC
[    0.454403] evm: security.SMACK64TRANSMUTE
[    0.454450] evm: security.SMACK64MMAP
[    0.454498] evm: security.ima
[    0.454546] evm: security.capability
[    0.455868] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.461102] NET: Registered protocol family 16
[    0.478350] cpuidle: using governor ladder
[    0.502371] cpuidle: using governor menu
[    0.502761] pstore: using zlib compression
[    0.502964] pstore: Registered nvram as persistent store backend
[    0.640041] PCI: Probing PCI hardware
[    0.640298] PCI host bridge to bus 0004:00
[    0.640359] pci_bus 0004:00: root bus resource [mem 0x3fe000000000-0x3fe07ffeffff] (bus address [0x80000000-0xfffeffff])
[    0.640485] pci_bus 0004:00: root bus resource [mem 0x3b0000000000-0x3b0fdfffffff 64bit pref]
[    0.640692] pci_bus 0004:00: root bus resource [bus 00-ff]
[    0.640859] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to ff
[    0.640918] pci 0004:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.641132] pci 0004:00:00.0: PME# supported from D0 D3hot D3cold
[    0.641523] pci 0004:00:00.0: PCI bridge to [bus 01]
[    0.641652] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to 01
[    0.641779] PCI host bridge to bus 0003:00
[    0.641835] pci_bus 0003:00: root bus resource [mem 0x3fe080000000-0x3fe0fffeffff] (bus address [0x80000000-0xfffeffff])
[    0.641959] pci_bus 0003:00: root bus resource [mem 0x3b1000000000-0x3b1fdfffffff 64bit pref]
[    0.642068] pci_bus 0003:00: root bus resource [bus 00-ff]
[    0.642136] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to ff
[    0.642179] pci 0003:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.642376] pci 0003:00:00.0: PME# supported from D0 D3hot D3cold
[    0.642925] pci 0003:00:00.0: PCI bridge to [bus 01]
[    0.643051] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to 01
[    0.643220] PCI host bridge to bus 0002:00
[    0.643276] pci_bus 0002:00: root bus resource [mem 0x3fe800000000-0x3fe87ffeffff] (bus address [0x80000000-0xfffeffff])
[    0.643400] pci_bus 0002:00: root bus resource [mem 0x3c0000000000-0x3c0fdfffffff 64bit pref]
[    0.643508] pci_bus 0002:00: root bus resource [bus 00-ff]
[    0.643575] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to ff
[    0.643617] pci 0002:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.643803] pci 0002:00:00.0: PME# supported from D0 D3hot D3cold
[    0.644339] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.644461] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to 01
[    0.644583] PCI host bridge to bus 0001:00
[    0.644637] pci_bus 0001:00: root bus resource [mem 0x3fe880000000-0x3fe8fffeffff] (bus address [0x80000000-0xfffeffff])
[    0.644763] pci_bus 0001:00: root bus resource [mem 0x3c1000000000-0x3c1fdfffffff 64bit pref]
[    0.644874] pci_bus 0001:00: root bus resource [bus 00-ff]
[    0.644940] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to ff
[    0.644981] pci 0001:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.645167] pci 0001:00:00.0: PME# supported from D0 D3hot D3cold
[    0.645566] pci 0001:01:00.0: [10b5:8725] type 01 class 0x060400
[    0.645662] pci 0001:01:00.0: reg 0x10: [mem 0x3fe883000000-0x3fe88303ffff]
[    0.646088] pci 0001:01:00.0: PME# supported from D0 D3hot D3cold
[    0.646404] pci 0001:01:00.1: [10b5:87d0] type 00 class 0x088000
[    0.646444] pci 0001:01:00.1: reg 0x10: [mem 0x3fe883040000-0x3fe883041fff]
[    0.646923] pci 0001:01:00.2: [10b5:87d0] type 00 class 0x088000
[    0.646963] pci 0001:01:00.2: reg 0x10: [mem 0x3fe883042000-0x3fe883043fff]
[    0.647436] pci 0001:01:00.3: [10b5:87d0] type 00 class 0x088000
[    0.647476] pci 0001:01:00.3: reg 0x10: [mem 0x3fe883044000-0x3fe883045fff]
[    0.648127] pci 0001:01:00.4: [10b5:87d0] type 00 class 0x088000
[    0.648167] pci 0001:01:00.4: reg 0x10: [mem 0x3fe883046000-0x3fe883047fff]
[    0.648707] pci 0001:00:00.0: PCI bridge to [bus 01-11]
[    0.648794] pci 0001:00:00.0:   bridge window [mem 0x3fe880000000-0x3fe8837fffff]
[    0.648812] pci 0001:00:00.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.649301] pci 0001:02:01.0: [10b5:8725] type 01 class 0x060400
[    0.649802] pci 0001:02:01.0: PME# supported from D0 D3hot D3cold
[    0.650096] pci 0001:02:08.0: [10b5:8725] type 01 class 0x060400
[    0.650426] pci 0001:02:08.0: PME# supported from D0 D3hot D3cold
[    0.650726] pci 0001:02:09.0: [10b5:8725] type 01 class 0x060400
[    0.651057] pci 0001:02:09.0: PME# supported from D0 D3hot D3cold
[    0.651354] pci 0001:02:0a.0: [10b5:8725] type 01 class 0x060400
[    0.651686] pci 0001:02:0a.0: PME# supported from D0 D3hot D3cold
[    0.651987] pci 0001:02:0b.0: [10b5:8725] type 01 class 0x060400
[    0.652321] pci 0001:02:0b.0: PME# supported from D0 D3hot D3cold
[    0.652629] pci 0001:02:0c.0: [10b5:8725] type 01 class 0x060400
[    0.652966] pci 0001:02:0c.0: PME# supported from D0 D3hot D3cold
[    0.653244] pci 0001:01:00.0: PCI bridge to [bus 02-11]
[    0.653331] pci 0001:01:00.0:   bridge window [mem 0x3fe880000000-0x3fe882ffffff]
[    0.653350] pci 0001:01:00.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.656632] pci 0001:03:00.0: [14e4:168a] type 00 class 0x020000
[    0.656693] pci 0001:03:00.0: reg 0x10: [mem 0x3c1000000000-0x3c10007fffff 64bit pref]
[    0.656734] pci 0001:03:00.0: reg 0x18: [mem 0x3c1000800000-0x3c1000ffffff 64bit pref]
[    0.656776] pci 0001:03:00.0: reg 0x20: [mem 0x3c1004000000-0x3c100400ffff 64bit pref]
[    0.656805] pci 0001:03:00.0: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.657061] pci 0001:03:00.0: PME# supported from D0 D3hot D3cold
[    0.657398] pci 0001:03:00.1: [14e4:168a] type 00 class 0x020000
[    0.657460] pci 0001:03:00.1: reg 0x10: [mem 0x3c1001000000-0x3c10017fffff 64bit pref]
[    0.657502] pci 0001:03:00.1: reg 0x18: [mem 0x3c1001800000-0x3c1001ffffff 64bit pref]
[    0.657545] pci 0001:03:00.1: reg 0x20: [mem 0x3c1004010000-0x3c100401ffff 64bit pref]
[    0.657574] pci 0001:03:00.1: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.657821] pci 0001:03:00.1: PME# supported from D0 D3hot D3cold
[    0.658127] pci 0001:03:00.2: [14e4:168a] type 00 class 0x020000
[    0.658189] pci 0001:03:00.2: reg 0x10: [mem 0x3c1002000000-0x3c10027fffff 64bit pref]
[    0.658230] pci 0001:03:00.2: reg 0x18: [mem 0x3c1002800000-0x3c1002ffffff 64bit pref]
[    0.658273] pci 0001:03:00.2: reg 0x20: [mem 0x3c1004020000-0x3c100402ffff 64bit pref]
[    0.658301] pci 0001:03:00.2: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.658552] pci 0001:03:00.2: PME# supported from D0 D3hot D3cold
[    0.658863] pci 0001:03:00.3: [14e4:168a] type 00 class 0x020000
[    0.658924] pci 0001:03:00.3: reg 0x10: [mem 0x3c1003000000-0x3c10037fffff 64bit pref]
[    0.658966] pci 0001:03:00.3: reg 0x18: [mem 0x3c1003800000-0x3c1003ffffff 64bit pref]
[    0.659008] pci 0001:03:00.3: reg 0x20: [mem 0x3c1004030000-0x3c100403ffff 64bit pref]
[    0.659037] pci 0001:03:00.3: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.659287] pci 0001:03:00.3: PME# supported from D0 D3hot D3cold
[    0.659672] pci 0001:02:01.0: PCI bridge to [bus 03]
[    0.659761] pci 0001:02:01.0:   bridge window [mem 0x3fe880000000-0x3fe8807fffff]
[    0.659780] pci 0001:02:01.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.660171] pci 0001:02:08.0: PCI bridge to [bus 04-08]
[    0.660474] pci 0001:09:00.0: [104c:8241] type 00 class 0x0c0330
[    0.660536] pci 0001:09:00.0: reg 0x10: [mem 0x3fe880800000-0x3fe88080ffff 64bit]
[    0.660578] pci 0001:09:00.0: reg 0x18: [mem 0x3fe880810000-0x3fe880811fff 64bit]
[    0.660818] pci 0001:09:00.0: supports D1 D2
[    0.660823] pci 0001:09:00.0: PME# supported from D0 D1 D2 D3hot
[    0.661117] pci 0001:02:09.0: PCI bridge to [bus 09]
[    0.661204] pci 0001:02:09.0:   bridge window [mem 0x3fe880800000-0x3fe880ffffff]
[    0.661451] pci 0001:0a:00.0: [1b4b:9235] type 00 class 0x010601
[    0.661498] pci 0001:0a:00.0: reg 0x10: [io  0x8000-0x8007]
[    0.661525] pci 0001:0a:00.0: reg 0x14: [io  0x8040-0x8043]
[    0.661553] pci 0001:0a:00.0: reg 0x18: [io  0x8100-0x8107]
[    0.661581] pci 0001:0a:00.0: reg 0x1c: [io  0x8140-0x8143]
[    0.661608] pci 0001:0a:00.0: reg 0x20: [io  0x800000-0x80001f]
[    0.661637] pci 0001:0a:00.0: reg 0x24: [mem 0x3fe881010000-0x3fe8810107ff]
[    0.661666] pci 0001:0a:00.0: reg 0x30: [mem 0x3fe8d0000000-0x3fe8d000ffff pref]
[    0.661818] pci 0001:0a:00.0: PME# supported from D3hot
[    0.662259] pci 0001:02:0a.0: PCI bridge to [bus 0a]
[    0.662347] pci 0001:02:0a.0:   bridge window [mem 0x3fe881000000-0x3fe8817fffff]
[    0.662599] pci 0001:0b:00.0: [1a03:1150] type 01 class 0x060400
[    0.662900] pci 0001:0b:00.0: supports D1 D2
[    0.662905] pci 0001:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.663143] pci 0001:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.663288] pci 0001:02:0b.0: PCI bridge to [bus 0b-0c]
[    0.663373] pci 0001:02:0b.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.663609] pci 0001:0c:00.0: [1a03:2000] type 00 class 0x030000
[    0.663665] pci 0001:0c:00.0: reg 0x10: [mem 0x3fe882000000-0x3fe882ffffff]
[    0.663696] pci 0001:0c:00.0: reg 0x14: [mem 0x3fe881800000-0x3fe88181ffff]
[    0.663725] pci 0001:0c:00.0: reg 0x18: [io  0x0000-0x007f]
[    0.664142] pci 0001:0c:00.0: supports D1 D2
[    0.664148] pci 0001:0c:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.664340] pci 0001:0b:00.0: PCI bridge to [bus 0c]
[    0.664431] pci 0001:0b:00.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.664659] pci 0001:02:0c.0: PCI bridge to [bus 0d-11]
[    0.664883] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to 11
[    0.665031] PCI host bridge to bus 0000:00
[    0.665086] pci_bus 0000:00: root bus resource [mem 0x3fe900000000-0x3fe97ffeffff] (bus address [0x80000000-0xfffeffff])
[    0.665211] pci_bus 0000:00: root bus resource [mem 0x3c2000000000-0x3c2fdfffffff 64bit pref]
[    0.665320] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.665387] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to ff
[    0.665428] pci 0000:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.665798] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.666214] pci 0000:01:00.0: [14e4:1657] type 00 class 0x020000
[    0.666273] pci 0000:01:00.0: reg 0x10: [mem 0x3c2000000000-0x3c200000ffff 64bit pref]
[    0.666314] pci 0000:01:00.0: reg 0x18: [mem 0x3c2000010000-0x3c200001ffff 64bit pref]
[    0.666356] pci 0000:01:00.0: reg 0x20: [mem 0x3c2000020000-0x3c200002ffff 64bit pref]
[    0.666384] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.666618] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.666919] pci 0000:01:00.1: [14e4:1657] type 00 class 0x020000
[    0.666979] pci 0000:01:00.1: reg 0x10: [mem 0x3c2000030000-0x3c200003ffff 64bit pref]
[    0.667020] pci 0000:01:00.1: reg 0x18: [mem 0x3c2000040000-0x3c200004ffff 64bit pref]
[    0.667061] pci 0000:01:00.1: reg 0x20: [mem 0x3c2000050000-0x3c200005ffff 64bit pref]
[    0.667091] pci 0000:01:00.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.667325] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    0.667594] pci 0000:01:00.2: [14e4:1657] type 00 class 0x020000
[    0.667655] pci 0000:01:00.2: reg 0x10: [mem 0x3c2000060000-0x3c200006ffff 64bit pref]
[    0.667697] pci 0000:01:00.2: reg 0x18: [mem 0x3c2000070000-0x3c200007ffff 64bit pref]
[    0.667738] pci 0000:01:00.2: reg 0x20: [mem 0x3c2000080000-0x3c200008ffff 64bit pref]
[    0.667766] pci 0000:01:00.2: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.668000] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.668270] pci 0000:01:00.3: [14e4:1657] type 00 class 0x020000
[    0.668331] pci 0000:01:00.3: reg 0x10: [mem 0x3c2000090000-0x3c200009ffff 64bit pref]
[    0.668373] pci 0000:01:00.3: reg 0x18: [mem 0x3c20000a0000-0x3c20000affff 64bit pref]
[    0.668414] pci 0000:01:00.3: reg 0x20: [mem 0x3c20000b0000-0x3c20000bffff 64bit pref]
[    0.668442] pci 0000:01:00.3: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.668889] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    0.678774] pci 0000:00:00.0: PCI bridge to [bus 01]
[    0.678862] pci 0000:00:00.0:   bridge window [mem 0x3fe900000000-0x3fe9007fffff]
[    0.678880] pci 0000:00:00.0:   bridge window [mem 0x3c2000000000-0x3c200fffffff 64bit pref]
[    0.679131] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 01
[    0.679188] pci 0004:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.679820] pci 0004:00:00.0: PCI bridge to [bus 01]
[    0.680087] pci_bus 0004:00: resource 4 [mem 0x3fe000000000-0x3fe07ffeffff]
[    0.680093] pci_bus 0004:00: resource 5 [mem 0x3b0000000000-0x3b0fdfffffff 64bit pref]
[    0.680121] pci 0003:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.680700] pci 0003:00:00.0: PCI bridge to [bus 01]
[    0.680794] pci_bus 0003:00: resource 4 [mem 0x3fe080000000-0x3fe0fffeffff]
[    0.680801] pci_bus 0003:00: resource 5 [mem 0x3b1000000000-0x3b1fdfffffff 64bit pref]
[    0.680828] pci 0002:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.681408] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.681500] pci_bus 0002:00: resource 4 [mem 0x3fe800000000-0x3fe87ffeffff]
[    0.681506] pci_bus 0002:00: resource 5 [mem 0x3c0000000000-0x3c0fdfffffff 64bit pref]
[    0.681537] pci 0001:02:01.0: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.681699] pci 0001:02:01.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.681708] pci 0001:01:00.0: bridge window [io  0x1000-0x2fff] to [bus 02-11] add_size 1000
[    0.681738] pci 0001:01:00.0: res[13]=[io  0x1000-0x2fff] res_to_dev_res add_size 1000 min_align 1000
[    0.681746] pci 0001:00:00.0: bridge window [io  0x1000-0x2fff] to [bus 01-11] add_size 1000
[    0.681762] pci 0001:00:00.0: res[13]=[io  0x1000-0x2fff] res_to_dev_res add_size 1000 min_align 1000
[    0.681769] pci 0001:00:00.0: res[13]=[io  0x1000-0x3fff] res_to_dev_res add_size 1000 min_align 1000
[    0.681780] pci 0001:00:00.0: BAR 15: assigned [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.681890] pci 0001:00:00.0: BAR 14: assigned [mem 0x3fe880000000-0x3fe8837fffff]
[    0.681987] pci 0001:00:00.0: BAR 13: no space for [io  size 0x3000]
[    0.682067] pci 0001:00:00.0: BAR 13: failed to assign [io  size 0x3000]
[    0.682151] pci 0001:00:00.0: BAR 13: no space for [io  size 0x2000]
[    0.682231] pci 0001:00:00.0: BAR 13: failed to assign [io  size 0x2000]
[    0.682321] pci 0001:01:00.0: res[13]=[io  0x1000-0x2fff] res_to_dev_res add_size 1000 min_align 1000
[    0.682328] pci 0001:01:00.0: res[13]=[io  0x1000-0x3fff] res_to_dev_res add_size 1000 min_align 1000
[    0.682336] pci 0001:01:00.0: BAR 15: assigned [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.682446] pci 0001:01:00.0: BAR 14: assigned [mem 0x3fe880000000-0x3fe882ffffff]
[    0.682542] pci 0001:01:00.0: BAR 0: assigned [mem 0x3fe883000000-0x3fe88303ffff]
[    0.682648] pci 0001:01:00.1: BAR 0: assigned [mem 0x3fe883040000-0x3fe883041fff]
[    0.682759] pci 0001:01:00.2: BAR 0: assigned [mem 0x3fe883042000-0x3fe883043fff]
[    0.682863] pci 0001:01:00.3: BAR 0: assigned [mem 0x3fe883044000-0x3fe883045fff]
[    0.682967] pci 0001:01:00.4: BAR 0: assigned [mem 0x3fe883046000-0x3fe883047fff]
[    0.683069] pci 0001:01:00.0: BAR 13: no space for [io  size 0x3000]
[    0.683149] pci 0001:01:00.0: BAR 13: failed to assign [io  size 0x3000]
[    0.683233] pci 0001:01:00.0: BAR 13: no space for [io  size 0x2000]
[    0.683314] pci 0001:01:00.0: BAR 13: failed to assign [io  size 0x2000]
[    0.683403] pci 0001:02:01.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.683410] pci 0001:02:01.0: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.683418] pci 0001:02:01.0: BAR 15: assigned [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.683528] pci 0001:02:01.0: BAR 14: assigned [mem 0x3fe880000000-0x3fe8807fffff]
[    0.683626] pci 0001:02:09.0: BAR 14: assigned [mem 0x3fe880800000-0x3fe880ffffff]
[    0.706481] pci 0001:02:0a.0: BAR 14: assigned [mem 0x3fe881000000-0x3fe8817fffff]
[    0.707481] pci 0001:02:0b.0: BAR 14: assigned [mem 0x3fe881800000-0x3fe882ffffff]
[    0.709156] pci 0001:02:01.0: BAR 13: no space for [io  size 0x1000]
[    0.710721] pci 0001:02:01.0: BAR 13: failed to assign [io  size 0x1000]
[    0.711665] pci 0001:02:0a.0: BAR 13: no space for [io  size 0x1000]
[    0.712575] pci 0001:02:0a.0: BAR 13: failed to assign [io  size 0x1000]
[    0.714338] pci 0001:02:0b.0: BAR 13: no space for [io  size 0x1000]
[    0.715307] pci 0001:02:0b.0: BAR 13: failed to assign [io  size 0x1000]
[    0.716169] pci 0001:02:0a.0: BAR 13: no space for [io  size 0x1000]
[    0.717075] pci 0001:02:0a.0: BAR 13: failed to assign [io  size 0x1000]
[    0.717954] pci 0001:02:0b.0: BAR 13: no space for [io  size 0x1000]
[    0.718860] pci 0001:02:0b.0: BAR 13: failed to assign [io  size 0x1000]
[    0.719776] pci 0001:02:01.0: BAR 13: no space for [io  size 0x1000]
[    0.749597] pci 0001:02:01.0: BAR 13: failed to assign [io  size 0x1000]
[    0.752308] pci 0001:03:00.0: BAR 0: assigned [mem 0x3c1000000000-0x3c10007fffff 64bit pref]
[    0.753280] pci 0001:03:00.0: BAR 2: assigned [mem 0x3c1000800000-0x3c1000ffffff 64bit pref]
[    0.754260] pci 0001:03:00.1: BAR 0: assigned [mem 0x3c1001000000-0x3c10017fffff 64bit pref]
[    0.756057] pci 0001:03:00.1: BAR 2: assigned [mem 0x3c1001800000-0x3c1001ffffff 64bit pref]
[    0.756975] pci 0001:03:00.2: BAR 0: assigned [mem 0x3c1002000000-0x3c10027fffff 64bit pref]
[    0.758672] pci 0001:03:00.2: BAR 2: assigned [mem 0x3c1002800000-0x3c1002ffffff 64bit pref]
[    0.759604] pci 0001:03:00.3: BAR 0: assigned [mem 0x3c1003000000-0x3c10037fffff 64bit pref]
[    0.761499] pci 0001:03:00.3: BAR 2: assigned [mem 0x3c1003800000-0x3c1003ffffff 64bit pref]
[    0.762464] pci 0001:03:00.0: BAR 6: assigned [mem 0x3fe880000000-0x3fe88003ffff pref]
[    0.764213] pci 0001:03:00.1: BAR 6: assigned [mem 0x3fe880040000-0x3fe88007ffff pref]
[    0.765099] pci 0001:03:00.2: BAR 6: assigned [mem 0x3fe880080000-0x3fe8800bffff pref]
[    0.766834] pci 0001:03:00.3: BAR 6: assigned [mem 0x3fe8800c0000-0x3fe8800fffff pref]
[    0.767780] pci 0001:03:00.0: BAR 4: assigned [mem 0x3c1004000000-0x3c100400ffff 64bit pref]
[    0.768746] pci 0001:03:00.1: BAR 4: assigned [mem 0x3c1004010000-0x3c100401ffff 64bit pref]
[    0.773881] pci 0001:03:00.2: BAR 4: assigned [mem 0x3c1004020000-0x3c100402ffff 64bit pref]
[    0.774810] pci 0001:03:00.3: BAR 4: assigned [mem 0x3c1004030000-0x3c100403ffff 64bit pref]
[    0.776785] pci 0001:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.778176] pci 0001:03     : [PE# 00] Secondary bus 3 associated with PE#0
[    0.779114] pci 0001:03     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
[    0.809674] IOMMU table initialized, virtual merging enabled
[    0.809758] pci 0001:03     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
[    0.809856] pci 0001:03     : [PE# 00] Enabling 64-bit DMA bypass
[    0.809946] iommu: Adding device 0001:03:00.0 to group 0
[    0.810018] iommu: Adding device 0001:03:00.1 to group 0
[    0.810088] iommu: Adding device 0001:03:00.2 to group 0
[    0.810159] iommu: Adding device 0001:03:00.3 to group 0
[    0.810231] pci 0001:02:01.0: PCI bridge to [bus 03]
[    0.810306] pci 0001:02:01.0:   bridge window [mem 0x3fe880000000-0x3fe8807fffff]
[    0.810408] pci 0001:02:01.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.810529] pci 0001:02:08.0: PCI bridge to [bus 04-08]
[    0.810626] pci 0001:09:00.0: BAR 0: assigned [mem 0x3fe880800000-0x3fe88080ffff 64bit]
[    0.810746] pci 0001:09:00.0: BAR 2: assigned [mem 0x3fe880810000-0x3fe880811fff 64bit]
[    0.810868] pci 0001:09     : [PE# fd] Secondary bus 9 associated with PE#fd
[    0.811465] pci 0001:09     : [PE# fd] Setting up 32-bit TCE table at 0..80000000
[    0.838154] pci 0001:09     : [PE# fd] Setting up window#0 0..7fffffff pg=1000
[    0.838251] pci 0001:09     : [PE# fd] Enabling 64-bit DMA bypass
[    0.838345] iommu: Adding device 0001:09:00.0 to group 1
[    0.838411] pci 0001:02:09.0: PCI bridge to [bus 09]
[    0.838486] pci 0001:02:09.0:   bridge window [mem 0x3fe880800000-0x3fe880ffffff]
[    0.838604] pci 0001:0a:00.0: BAR 6: assigned [mem 0x3fe881000000-0x3fe88100ffff pref]
[    0.838701] pci 0001:0a:00.0: BAR 5: assigned [mem 0x3fe881010000-0x3fe8810107ff]
[    0.838804] pci 0001:0a:00.0: BAR 4: no space for [io  size 0x0020]
[    0.838886] pci 0001:0a:00.0: BAR 4: failed to assign [io  size 0x0020]
[    0.838967] pci 0001:0a:00.0: BAR 0: no space for [io  size 0x0008]
[    0.839047] pci 0001:0a:00.0: BAR 0: failed to assign [io  size 0x0008]
[    0.839128] pci 0001:0a:00.0: BAR 2: no space for [io  size 0x0008]
[    0.841406] pci 0001:0a:00.0: BAR 2: failed to assign [io  size 0x0008]
[    0.843182] pci 0001:0a:00.0: BAR 1: no space for [io  size 0x0004]
[    0.844088] pci 0001:0a:00.0: BAR 1: failed to assign [io  size 0x0004]
[    0.845033] pci 0001:0a:00.0: BAR 3: no space for [io  size 0x0004]
[    0.845911] pci 0001:0a:00.0: BAR 3: failed to assign [io  size 0x0004]
[    0.846789] pci 0001:0a     : [PE# fc] Secondary bus 10 associated with PE#fc
[    0.848195] pci 0001:0a     : [PE# fc] Setting up 32-bit TCE table at 0..80000000
[    0.878393] pci 0001:0a     : [PE# fc] Setting up window#0 0..7fffffff pg=1000
[    0.878489] pci 0001:0a     : [PE# fc] Enabling 64-bit DMA bypass
[    0.878576] iommu: Adding device 0001:0a:00.0 to group 2
[    0.878643] pci 0001:02:0a.0: PCI bridge to [bus 0a]
[    0.878719] pci 0001:02:0a.0:   bridge window [mem 0x3fe881000000-0x3fe8817fffff]
[    0.878836] pci 0001:0b:00.0: BAR 14: assigned [mem 0x3fe881800000-0x3fe882ffffff]
[    0.878931] pci 0001:0b:00.0: BAR 13: no space for [io  size 0x1000]
[    0.879011] pci 0001:0b:00.0: BAR 13: failed to assign [io  size 0x1000]
[    0.879097] pci 0001:0c:00.0: BAR 0: assigned [mem 0x3fe882000000-0x3fe882ffffff]
[    0.879200] pci 0001:0c:00.0: BAR 1: assigned [mem 0x3fe881800000-0x3fe88181ffff]
[    0.891489] pci 0001:0c:00.0: BAR 2: no space for [io  size 0x0080]
[    0.892443] pci 0001:0c:00.0: BAR 2: failed to assign [io  size 0x0080]
[    0.894265] pci 0001:0c     : [PE# fb] Secondary bus 12..12 associated with PE#fb
[    0.895707] pci 0001:0c     : [PE# fb] Setting up 32-bit TCE table at 0..80000000
[    0.927536] pci 0001:0c     : [PE# fb] Setting up window#0 0..7fffffff pg=1000
[    0.927634] pci 0001:0c     : [PE# fb] Enabling 64-bit DMA bypass
[    0.927721] iommu: Adding device 0001:0c:00.0 to group 3
[    0.927795] pci 0001:0b:00.0: PCI bridge to [bus 0c]
[    0.927870] pci 0001:0b:00.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.927986] pci 0001:0b     : [PE# fa] Secondary bus 11 associated with PE#fa
[    0.928564] pci 0001:02:0b.0: PCI bridge to [bus 0b-0c]
[    0.928641] pci 0001:02:0b.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.928755] pci 0001:02:0c.0: PCI bridge to [bus 0d-11]
[    0.928853] pci 0001:02     : [PE# f9] Secondary bus 2 associated with PE#f9
[    0.929435] pci 0001:01:00.0: PCI bridge to [bus 02-11]
[    0.929510] pci 0001:01:00.0:   bridge window [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.929612] pci 0001:01:00.0:   bridge window [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.929740] pci 0001:01     : [PE# f8] Secondary bus 1 associated with PE#f8
[    0.930338] pci 0001:01     : [PE# f8] Setting up 32-bit TCE table at 0..80000000
[    0.957685] pci 0001:01     : [PE# f8] Setting up window#0 0..7fffffff pg=1000
[    0.957782] pci 0001:01     : [PE# f8] Enabling 64-bit DMA bypass
[    0.957871] iommu: Adding device 0001:01:00.0 to group 4
[    0.957943] iommu: Adding device 0001:01:00.1 to group 4
[    0.958015] iommu: Adding device 0001:01:00.2 to group 4
[    0.958088] iommu: Adding device 0001:01:00.3 to group 4
[    0.958161] iommu: Adding device 0001:01:00.4 to group 4
[    0.958227] pci 0001:00:00.0: PCI bridge to [bus 01-11]
[    0.958302] pci 0001:00:00.0:   bridge window [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.995317] pci 0001:00:00.0:   bridge window [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.996267] pci_bus 0001:00: Some PCI device resources are unassigned, try booting with pci=realloc
[    0.998014] pci_bus 0001:00: resource 4 [mem 0x3fe880000000-0x3fe8fffeffff]
[    0.998020] pci_bus 0001:00: resource 5 [mem 0x3c1000000000-0x3c1fdfffffff 64bit pref]
[    0.998027] pci_bus 0001:01: resource 1 [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.998033] pci_bus 0001:01: resource 2 [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.998040] pci_bus 0001:02: resource 1 [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.998046] pci_bus 0001:02: resource 2 [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.998053] pci_bus 0001:03: resource 1 [mem 0x3fe880000000-0x3fe8807fffff]
[    0.998059] pci_bus 0001:03: resource 2 [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.998067] pci_bus 0001:09: resource 1 [mem 0x3fe880800000-0x3fe880ffffff]
[    0.998074] pci_bus 0001:0a: resource 1 [mem 0x3fe881000000-0x3fe8817fffff]
[    0.998080] pci_bus 0001:0b: resource 1 [mem 0x3fe881800000-0x3fe882ffffff]
[    0.998087] pci_bus 0001:0c: resource 1 [mem 0x3fe881800000-0x3fe882ffffff]
[    0.998144] pci 0000:00:00.0: BAR 15: assigned [mem 0x3c2000000000-0x3c200fffffff 64bit pref]
[    0.998953] pci 0000:00:00.0: BAR 14: assigned [mem 0x3fe900000000-0x3fe9007fffff]
[    0.999904] pci 0000:01:00.0: BAR 6: assigned [mem 0x3fe900000000-0x3fe90007ffff pref]
[    1.016670] pci 0000:01:00.1: BAR 6: assigned [mem 0x3fe900080000-0x3fe9000fffff pref]
[    1.017641] pci 0000:01:00.2: BAR 6: assigned [mem 0x3fe900100000-0x3fe90017ffff pref]
[    1.018628] pci 0000:01:00.3: BAR 6: assigned [mem 0x3fe900180000-0x3fe9001fffff pref]
[    1.032362] pci 0000:01:00.0: BAR 0: assigned [mem 0x3c2000000000-0x3c200000ffff 64bit pref]
[    1.033399] pci 0000:01:00.0: BAR 2: assigned [mem 0x3c2000010000-0x3c200001ffff 64bit pref]
[    1.035200] pci 0000:01:00.0: BAR 4: assigned [mem 0x3c2000020000-0x3c200002ffff 64bit pref]
[    1.036136] pci 0000:01:00.1: BAR 0: assigned [mem 0x3c2000030000-0x3c200003ffff 64bit pref]
[    1.037909] pci 0000:01:00.1: BAR 2: assigned [mem 0x3c2000040000-0x3c200004ffff 64bit pref]
[    1.039048] pci 0000:01:00.1: BAR 4: assigned [mem 0x3c2000050000-0x3c200005ffff 64bit pref]
[    1.046261] pci 0000:01:00.2: BAR 0: assigned [mem 0x3c2000060000-0x3c200006ffff 64bit pref]
[    1.047173] pci 0000:01:00.2: BAR 2: assigned [mem 0x3c2000070000-0x3c200007ffff 64bit pref]
[    1.049548] pci 0000:01:00.2: BAR 4: assigned [mem 0x3c2000080000-0x3c200008ffff 64bit pref]
[    1.055985] pci 0000:01:00.3: BAR 0: assigned [mem 0x3c2000090000-0x3c200009ffff 64bit pref]
[    1.061697] pci 0000:01:00.3: BAR 2: assigned [mem 0x3c20000a0000-0x3c20000affff 64bit pref]
[    1.062633] pci 0000:01:00.3: BAR 4: assigned [mem 0x3c20000b0000-0x3c20000bffff 64bit pref]
[    1.064471] pci 0000:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    1.065842] pci 0000:01     : [PE# 00] Secondary bus 1 associated with PE#0
[    1.066718] pci 0000:01     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
[    1.094735] pci 0000:01     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
[    1.094833] pci 0000:01     : [PE# 00] Enabling 64-bit DMA bypass
[    1.094921] iommu: Adding device 0000:01:00.0 to group 5
[    1.111394] iommu: Adding device 0000:01:00.1 to group 5
[    1.112338] iommu: Adding device 0000:01:00.2 to group 5
[    1.113294] iommu: Adding device 0000:01:00.3 to group 5
[    1.113359] pci 0000:00:00.0: PCI bridge to [bus 01]
[    1.114363] pci 0000:00:00.0:   bridge window [mem 0x3fe900000000-0x3fe97fefffff]
[    1.116109] pci 0000:00:00.0:   bridge window [mem 0x3c2000000000-0x3c2fdff0ffff 64bit pref]
[    1.117044] pci_bus 0000:00: resource 4 [mem 0x3fe900000000-0x3fe97ffeffff]
[    1.117050] pci_bus 0000:00: resource 5 [mem 0x3c2000000000-0x3c2fdfffffff 64bit pref]
[    1.117057] pci_bus 0000:01: resource 1 [mem 0x3fe900000000-0x3fe97fefffff]
[    1.117063] pci_bus 0000:01: resource 2 [mem 0x3c2000000000-0x3c2fdff0ffff 64bit pref]
[    1.119938] EEH: PCI Enhanced I/O Error Handling Enabled
[    1.120409] PCI: Probing PCI hardware done
[    1.124750] powernv-rng: Registering arch random hook.
[    1.140673] HugeTLB registered 1 MB page size, pre-allocated 0 pages
[    1.140735] HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    1.140785] HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    1.143981] pci 0001:0c:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
[    1.144049] pci 0001:0c:00.0: vgaarb: bridge control possible
[    1.144099] vgaarb: loaded
[    1.144371] SCSI subsystem initialized
[    1.144630] libata version 3.00 loaded.
[    1.144664] usbcore: registered new interface driver usbfs
[    1.144714] usbcore: registered new interface driver hub
[    1.145011] usbcore: registered new device driver usb
[    1.145072] pps_core: LinuxPPS API ver. 1 registered
[    1.145111] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti-k2GhghHVRtY@public.gmane.org>
[    1.155366] PTP clock support registered
[    1.156780] NetLabel: Initializing
[    1.156812] NetLabel:  domain hash size = 128
[    1.157198] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    1.158083] NetLabel:  unlabeled traffic allowed by default
[    1.159519] clocksource: Switched to clocksource timebase
[    1.168367] VFS: Disk quotas dquot_6.6.0
[    1.168466] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    1.168795] AppArmor: AppArmor Filesystem Enabled
[    1.170477] NET: Registered protocol family 2
[    1.170966] TCP established hash table entries: 524288 (order: 6, 4194304 bytes)
[    1.172116] TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
[    1.172394] TCP: Hash tables configured (established 524288 bind 65536)
[    1.172522] UDP hash table entries: 32768 (order: 4, 1048576 bytes)
[    1.173044] UDP-Lite hash table entries: 32768 (order: 4, 1048576 bytes)
[    1.174874] NET: Registered protocol family 1
[    1.175199] PCI: CLS 0 bytes, default 128
[    1.175375] Trying to unpack rootfs image as initramfs...
[    1.732201] Freeing initrd memory: 38400K
[    1.732691] random: crng init done
[    1.753296] futex hash table entries: 32768 (order: 6, 4194304 bytes)
[    1.754004] audit: initializing netlink subsys (disabled)
[    1.754106] audit: type=2000 audit(1486142278.588:1): initialized
[    1.754264] Initialise system trusted keyrings
[    1.754692] workingset: timestamp_bits=38 max_order=20 bucket_order=0
[    1.756354] zbud: loaded
[    1.757117] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.757314] fuse init (API version 7.26)
[    1.758112] Key type asymmetric registered
[    1.758144] Asymmetric key parser 'x509' registered
[    1.758193] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    1.758441] io scheduler noop registered
[    1.758473] io scheduler deadline registered (default)
[    1.758520] io scheduler cfq registered
[    1.761265] hvc0: raw protocol on /ibm,opal/consoles/serial@0 (boot console)
[    1.761328] hvc0: No interrupts property, using OPAL event
[    1.761591] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.762818] Linux agpgart interface v0.103
[    1.768751] brd: module loaded
[    1.774468] loop: module loaded
[    1.774891] libphy: Fixed MDIO Bus: probed
[    1.774922] tun: Universal TUN/TAP device driver, 1.6
[    1.774961] tun: (C) 1999-2004 Max Krasnyansky <maxk-zC7DfRvBq/JWk0Htik3J/w@public.gmane.org>
[    1.775062] tg3.c:v3.137 (May 11, 2014)
[    1.823201] tg3 0000:01:00.0: Using 64-bit DMA iommu bypass
[    1.823576] tg3 0000:01:00.0 eth0: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:dc
[    1.823811] tg3 0000:01:00.0 eth0: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.823891] tg3 0000:01:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.823952] tg3 0000:01:00.0 eth0: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.858281] tg3 0000:01:00.1: Using 64-bit DMA iommu bypass
[    1.858615] tg3 0000:01:00.1 eth1: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:dd
[    1.858842] tg3 0000:01:00.1 eth1: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.858921] tg3 0000:01:00.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.858982] tg3 0000:01:00.1 eth1: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.892224] tg3 0000:01:00.2: Using 64-bit DMA iommu bypass
[    1.892562] tg3 0000:01:00.2 eth2: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:de
[    1.892801] tg3 0000:01:00.2 eth2: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.892880] tg3 0000:01:00.2 eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.892940] tg3 0000:01:00.2 eth2: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.928224] tg3 0000:01:00.3: Using 64-bit DMA iommu bypass
[    1.928572] tg3 0000:01:00.3 eth3: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:df
[    1.928668] tg3 0000:01:00.3 eth3: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.928747] tg3 0000:01:00.3 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.928807] tg3 0000:01:00.3 eth3: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.928914] PPP generic driver version 2.4.2
[    1.929004] VFIO - User Level meta-driver version: 0.3
[    1.931367] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.931427] ehci-pci: EHCI PCI platform driver
[    1.931486] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.931542] ohci-pci: OHCI PCI platform driver
[    1.931597] uhci_hcd: USB Universal Host Controller Interface driver
[    1.931712] xhci_hcd 0001:09:00.0: xHCI Host Controller
[    1.931761] xhci_hcd 0001:09:00.0: new USB bus registered, assigned bus number 1
[    1.931912] xhci_hcd 0001:09:00.0: Using 64-bit DMA iommu bypass
[    1.932020] xhci_hcd 0001:09:00.0: hcc params 0x0270f06d hci version 0x96 quirks 0x00000000
[    1.932313] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.932365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.932425] usb usb1: Product: xHCI Host Controller
[    1.932465] usb usb1: Manufacturer: Linux 4.10.0-rc6-gpiccoli-cleech+ xhci-hcd
[    1.932526] usb usb1: SerialNumber: 0001:09:00.0
[    1.932663] hub 1-0:1.0: USB hub found
[    1.932702] hub 1-0:1.0: 4 ports detected
[    1.932854] xhci_hcd 0001:09:00.0: xHCI Host Controller
[    1.932896] xhci_hcd 0001:09:00.0: new USB bus registered, assigned bus number 2
[    1.932973] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    1.933053] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.933104] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.933164] usb usb2: Product: xHCI Host Controller
[    1.933205] usb usb2: Manufacturer: Linux 4.10.0-rc6-gpiccoli-cleech+ xhci-hcd
[    1.933265] usb usb2: SerialNumber: 0001:09:00.0
[    1.933388] hub 2-0:1.0: USB hub found
[    1.933427] hub 2-0:1.0: 4 ports detected
[    1.933780] mousedev: PS/2 mouse device common for all mice
[    1.955471] rtc-opal opal-rtc: rtc core: registered rtc-opal as rtc0
[    1.955527] i2c /dev entries driver
[    1.956547] device-mapper: uevent: version 1.0.3
[    1.956655] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[    1.956865] powernv-cpufreq: cpufreq pstate min -54 nominal -16 max 0
[    1.960495] powernv_idle_driver registered
[    1.961896] ledtrig-cpu: registered to indicate activity on CPUs
[    1.962487] NET: Registered protocol family 10
[    1.963577] Segment Routing with IPv6
[    1.963635] NET: Registered protocol family 17
[    1.963696] Key type dns_resolver registered
[    1.963950] registered taskstats version 1
[    1.963983] Loading compiled-in X.509 certificates
[    1.966429] Loaded X.509 cert 'Build time autogenerated kernel key: 411ec76c048a1d66c98e183c1c880bd495b62112'
[    1.966595] zswap: loaded using pool lzo/zbud
[    1.968417] Key type trusted registered
[    1.971799] Key type encrypted registered
[    1.971830] AppArmor: AppArmor sha1 policy hashing enabled
[    1.971870] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
[    1.971933] evm: HMAC attrs: 0x1
[    1.991505] rtc-opal opal-rtc: setting system clock to 2017-02-03 17:17:59 UTC (1486142279)
[    1.992778] Freeing unused kernel memory: 4416K
[    1.992821] This architecture does not have kernel memory protection.
[    2.055700] tg3 0000:01:00.1 enp1s0f1: renamed from eth1
[    2.067333] ahci 0001:0a:00.0: version 3.0
[    2.067495] ahci 0001:0a:00.0: Using 64-bit DMA iommu bypass
[    2.072863] [drm] Initialized
[    2.077653] ahci 0001:0a:00.0: AHCI 0001.0000 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    2.077723] ahci 0001:0a:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    2.078481] scsi host0: ahci
[    2.078684] scsi host1: ahci
[    2.078847] scsi host2: ahci
[    2.078993] scsi host3: ahci
[    2.079089] ata1: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010100 irq 392
[    2.079159] ata2: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010180 irq 392
[    2.079227] ata3: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010200 irq 392
[    2.079296] ata4: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010280 irq 392
[    2.087980] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.712.30-0 (2014/02/10)
[    2.088175] bnx2x 0001:03:00.0: msix capability found
[    2.093473] [drm] platform has no IO space, trying MMIO
[    2.093517] [drm] AST 2400 detected
[    2.093555] [drm] Analog VGA only
[    2.093592] [drm] dram 1632000000 7 16 00c00000
[    2.093673] [TTM] Zone  kernel: Available graphics memory: 33417120 kiB
[    2.093720] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    2.093766] [TTM] Initializing pool allocator
[    2.093806] [TTM] Initializing DMA pool allocator
[    2.103681] tg3 0000:01:00.3 enp1s0f3: renamed from eth3
[    2.111732] bnx2x 0001:03:00.0: Using 64-bit DMA iommu bypass
[    2.111872] bnx2x 0001:03:00.0: part number 0-0-0-0
[    2.209076] Console: switching to colour frame buffer device 128x48
[    2.259446] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    2.283422] ast 0001:0c:00.0: fb0: astdrmfb frame buffer device
[    2.287550] tg3 0000:01:00.2 enp1s0f2: renamed from eth2
[    2.303442] [drm] Initialized ast 0.1.0 20120228 for 0001:0c:00.0 on minor 0
[    2.315539] tg3 0000:01:00.0 enp1s0f0: renamed from eth0
[    2.348834] bnx2x 0001:03:00.1: msix capability found
[    2.367509] bnx2x 0001:03:00.1: Using 64-bit DMA iommu bypass
[    2.367726] bnx2x 0001:03:00.1: part number 0-0-0-0
[    2.393578] ata3: SATA link down (SStatus 0 SControl 300)
[    2.393663] ata2: SATA link down (SStatus 0 SControl 300)
[    2.393721] ata4: SATA link down (SStatus 0 SControl 300)
[    2.432768] bnx2x 0001:03:00.2: msix capability found
[    2.445371] usb 1-3: New USB device found, idVendor=046b, idProduct=ff01
[    2.445421] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.445476] usb 1-3: Product: Virtual Hub
[    2.445506] usb 1-3: Manufacturer: American Megatrends Inc.
[    2.445544] usb 1-3: SerialNumber: serial
[    2.451508] bnx2x 0001:03:00.2: Using 64-bit DMA iommu bypass
[    2.451658] bnx2x 0001:03:00.2: part number 0-0-0-0
[    2.477882] hub 1-3:1.0: USB hub found
[    2.478243] hub 1-3:1.0: 5 ports detected
[    2.516795] bnx2x 0001:03:00.3: msix capability found
[    2.535508] bnx2x 0001:03:00.3: Using 64-bit DMA iommu bypass
[    2.535722] bnx2x 0001:03:00.3: part number 0-0-0-0
[    2.555449] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.556589] ata1.00: ATA-10: ST1000NX0313         00NA562 00NA565LEN, BE30, max UDMA/133
[    2.556652] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.557353] ata1.00: configured for UDMA/133
[    2.557741] scsi 0:0:0:0: Direct-Access     ATA      ST1000NX0313     BE30 PQ: 0 ANSI: 5
[    2.587592] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
[    2.587653] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.587847] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.588064] sd 0:0:0:0: [sda] Write Protect is off
[    2.588102] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.588113] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.601785] bnx2x 0001:03:00.3 enP1p3s0f3: renamed from eth3
[    2.619633] bnx2x 0001:03:00.2 enP1p3s0f2: renamed from eth2
[    2.632520]  sda: sda1 sda2 sda3
[    2.636133] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    2.691627] bnx2x 0001:03:00.1 enP1p3s0f1: renamed from eth1
[    2.735575] bnx2x 0001:03:00.0 enP1p3s0f0: renamed from eth0
[    2.795443] usb 1-3.1: new high-speed USB device number 3 using xhci_hcd
[    2.919014] usb 1-3.1: New USB device found, idVendor=046b, idProduct=ff20
[    2.919211] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.919270] usb 1-3.1: Product: Virtual Cdrom Device
[    2.919308] usb 1-3.1: Manufacturer: American Megatrends Inc.
[    2.919354] usb 1-3.1: SerialNumber: AAAABBBBCCCC1
[    2.923256] usb-storage 1-3.1:1.0: USB Mass Storage device detected
[    2.923456] scsi host4: usb-storage 1-3.1:1.0
[    2.923568] usbcore: registered new interface driver usb-storage
[    2.924785] usbcore: registered new interface driver uas
[    3.019443] usb 1-3.2: new high-speed USB device number 4 using xhci_hcd
[    3.143025] usb 1-3.2: New USB device found, idVendor=046b, idProduct=ff40
[    3.143238] usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.143299] usb 1-3.2: Product: Virtual Floppy Device
[    3.143337] usb 1-3.2: Manufacturer: American Megatrends Inc.
[    3.143383] usb 1-3.2: SerialNumber: AAAABBBBCCCC2
[    3.144551] usb-storage 1-3.2:1.0: USB Mass Storage device detected
[    3.144821] usb-storage 1-3.2:1.0: Quirks match for vid 046b pid ff40: 200
[    3.144887] scsi host5: usb-storage 1-3.2:1.0
[    3.247447] usb 1-3.3: new high-speed USB device number 5 using xhci_hcd
[    3.270082] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    3.371034] usb 1-3.3: New USB device found, idVendor=046b, idProduct=ff31
[    3.371236] usb 1-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.371302] usb 1-3.3: Product: Virtual HardDisk Device
[    3.371340] usb 1-3.3: Manufacturer: American Megatrends Inc.
[    3.371386] usb 1-3.3: SerialNumber: AAAABBBBCCCC3
[    3.372549] usb-storage 1-3.3:1.0: USB Mass Storage device detected
[    3.372796] scsi host6: usb-storage 1-3.3:1.0
[    3.471444] usb 1-3.4: new low-speed USB device number 6 using xhci_hcd
[    3.614544] usb 1-3.4: New USB device found, idVendor=046b, idProduct=ff10
[    3.614734] usb 1-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.614790] usb 1-3.4: Product: Virtual Keyboard and Mouse
[    3.614828] usb 1-3.4: Manufacturer: American Megatrends Inc.
[    3.907905] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
[    3.908493] systemd[1]: Detected architecture ppc64-le.
[    3.937071] scsi 4:0:0:0: CD-ROM            AMI      Virtual CDROM0   1.00 PQ: 0 ANSI: 0 CCS
[    3.938966] systemd[1]: Set hostname to <fs28>.
[    3.940690] scsi 4:0:0:1: CD-ROM            AMI      Virtual CDROM1   1.00 PQ: 0 ANSI: 0 CCS
[    3.941819] scsi 4:0:0:2: CD-ROM            AMI      Virtual CDROM2   1.00 PQ: 0 ANSI: 0 CCS
[    3.942854] scsi 4:0:0:3: CD-ROM            AMI      Virtual CDROM3   1.00 PQ: 0 ANSI: 0 CCS
[    3.947567] sr 4:0:0:0: [sr0] scsi-1 drive
[    3.947634] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.947782] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.947845] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.954188] sr 4:0:0:1: [sr1] scsi-1 drive
[    3.954337] sr 4:0:0:1: Attached scsi CD-ROM sr1
[    3.954420] sr 4:0:0:1: Attached scsi generic sg2 type 5
[    3.959312] sr 4:0:0:2: [sr2] scsi-1 drive
[    3.959461] sr 4:0:0:2: Attached scsi CD-ROM sr2
[    3.959533] sr 4:0:0:2: Attached scsi generic sg3 type 5
[    3.964938] sr 4:0:0:3: [sr3] scsi-1 drive
[    3.965072] sr 4:0:0:3: Attached scsi CD-ROM sr3
[    3.965127] sr 4:0:0:3: Attached scsi generic sg4 type 5
[    4.161079] scsi 5:0:0:0: Direct-Access     AMI      Virtual Floppy0  1.00 PQ: 0 ANSI: 0 CCS
[    4.163449] scsi 5:0:0:1: Direct-Access     AMI      Virtual Floppy1  1.00 PQ: 0 ANSI: 0 CCS
[    4.165948] scsi 5:0:0:2: Direct-Access     AMI      Virtual Floppy2  1.00 PQ: 0 ANSI: 0 CCS
[    4.168448] scsi 5:0:0:3: Direct-Access     AMI      Virtual Floppy3  1.00 PQ: 0 ANSI: 0 CCS
[    4.169122] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    4.169423] sd 5:0:0:1: Attached scsi generic sg6 type 0
[    4.169588] sd 5:0:0:2: Attached scsi generic sg7 type 0
[    4.169757] sd 5:0:0:3: Attached scsi generic sg8 type 0
[    4.175823] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[    4.182447] sd 5:0:0:1: [sdc] Attached SCSI removable disk
[    4.183698] sd 5:0:0:2: [sdd] Attached SCSI removable disk
[    4.184948] sd 5:0:0:3: [sde] Attached SCSI removable disk
[    4.385084] scsi 6:0:0:0: Direct-Access     AMI      Virtual HDisk0   1.00 PQ: 0 ANSI: 0 CCS
[    4.387584] scsi 6:0:0:1: Direct-Access     AMI      Virtual HDisk1   1.00 PQ: 0 ANSI: 0 CCS
[    4.391984] scsi 6:0:0:2: Direct-Access     AMI      Virtual HDisk2   1.00 PQ: 0 ANSI: 0 CCS
[    4.393208] scsi 6:0:0:3: Direct-Access     AMI      Virtual HDisk3   1.00 PQ: 0 ANSI: 0 CCS
[    4.394333] scsi 6:0:0:4: Direct-Access     AMI      Virtual HDisk4   1.00 PQ: 0 ANSI: 0 CCS
[    4.394961] sd 6:0:0:0: Attached scsi generic sg9 type 0
[    4.395145] sd 6:0:0:1: Attached scsi generic sg10 type 0
[    4.395443] sd 6:0:0:2: Attached scsi generic sg11 type 0
[    4.395613] sd 6:0:0:3: Attached scsi generic sg12 type 0
[    4.395808] sd 6:0:0:4: Attached scsi generic sg13 type 0
[    4.402959] sd 6:0:0:0: [sdf] Attached SCSI removable disk
[    4.404208] sd 6:0:0:1: [sdg] Attached SCSI removable disk
[    4.405458] sd 6:0:0:2: [sdh] Attached SCSI removable disk
[    4.412958] sd 6:0:0:3: [sdi] Attached SCSI removable disk
[    4.414207] sd 6:0:0:4: [sdj] Attached SCSI removable disk
[    4.419294] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    4.419556] systemd[1]: Listening on multipathd control socket.
[    4.419766] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    4.419987] systemd[1]: Listening on fsck to fsckd communication Socket.
[    4.420174] systemd[1]: Reached target Encrypted Volumes.
[    4.420344] systemd[1]: Listening on Syslog Socket.
[    4.420513] systemd[1]: Listening on Journal Socket (/dev/log).
[    5.018101] lp: driver loaded but no devices found
[    5.107766] ppdev: user-space parallel port driver
[    5.262372] Loading iSCSI transport class v2.0-870.
[    5.355566] iscsi: registered transport (tcp)
[    5.552764] iscsi: registered transport (iser)
[    5.976593] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    6.187476] systemd-journald[1323]: Received request to flush runtime journal from PID 1
[    6.327088] powernv_rng: Registered powernv hwrng.
[    6.481172] crypto_register_alg 'aes' = 0
[    6.483610] crypto_register_alg 'cbc(aes)' = 0
[    6.486705] crypto_register_alg 'ctr(aes)' = 0
[    6.490450] crypto_register_alg 'xts(aes)' = 0
[    6.491859] ipmi message handler version 39.2
[    6.606256] at24 0-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.606643] at24 0-0052: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.607015] at24 0-0053: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.607386] at24 0-0054: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.607771] at24 0-0055: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.607868] at24 1-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.607961] at24 1-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608055] at24 2-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608147] at24 2-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608242] at24 3-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608335] at24 3-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608436] at24 4-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608534] at24 4-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.608703] at24 5-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.618900] ipmi device interface
[    6.682279] at24 6-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    6.682757] at24 6-0052: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.683185] at24 6-0053: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.683559] at24 6-0054: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.683931] at24 6-0055: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    6.822810] ipmi-powernv ibm,opal:ipmi: Unable to map irq from device tree
[    6.824470] ipmi-powernv ibm,opal:ipmi: Found new BMC (man_id: 0x000000, prod_id: 0x0000, dev_id: 0x00)
[    7.592756] hidraw: raw HID events driver (C) Jiri Kosina
[    7.620903] usbcore: registered new interface driver usbhid
[    7.620906] usbhid: USB HID core driver
[    7.675335] audit: type=1400 audit(1486142285.176:2): apparmor="STATUS" operation="profile_load" name="/usr/lib/snapd/snap-confine" pid=1998 comm="apparmor_parser"
[    7.675346] audit: type=1400 audit(1486142285.176:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/snapd/snap-confine//mount-namespace-capture-helper" pid=1998 comm="apparmor_parser"
[    7.757372] audit: type=1400 audit(1486142285.260:4): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ippusbxd" pid=2002 comm="apparmor_parser"
[    7.769850] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0001:00/0001:00:00.0/0001:01:00.0/0001:02:09.0/0001:09:00.0/usb1/1-3/1-3.4/1-3.4:1.0/0003:046B:FF10.0001/input/input0
[    7.769933] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0001:09:00.0-3.4/input0
[    7.770046] input: American Megatrends Inc. Virtual Keyboard and Mouse as /devices/pci0001:00/0001:00:00.0/0001:01:00.0/0001:02:09.0/0001:09:00.0/usb1/1-3/1-3.4/1-3.4:1.1/0003:046B:FF10.0002/input/input1
[    7.770133] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0001:09:00.0-3.4/input1
[    7.776196] audit: type=1400 audit(1486142285.280:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/libvirt/virt-aa-helper" pid=1997 comm="apparmor_parser"
[    7.778249] audit: type=1400 audit(1486142285.280:6): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=1995 comm="apparmor_parser"
[    7.778252] audit: type=1400 audit(1486142285.280:7): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1995 comm="apparmor_parser"
[    7.778255] audit: type=1400 audit(1486142285.280:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=1995 comm="apparmor_parser"
[    7.778257] audit: type=1400 audit(1486142285.280:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=1995 comm="apparmor_parser"
[    7.787111] audit: type=1400 audit(1486142285.288:10): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cups-browsed" pid=2000 comm="apparmor_parser"
[    7.788053] audit: type=1400 audit(1486142285.296:11): apparmor="STATUS" operation="profile_load" name="/usr/sbin/libvirtd" pid=2003 comm="apparmor_parser"
[    8.216149] IPv6: ADDRCONF(NETDEV_UP): enp1s0f0: link is not ready
[    8.504063] Adding 39519168k swap on /dev/sda3.  Priority:-1 extents:1 across:39519168k FS
[    9.387938] cgroup: new mount options do not match the existing superblock, will be ignored
[   11.127062] tg3 0000:01:00.0 enp1s0f0: Link is up at 1000 Mbps, full duplex
[   11.127064] tg3 0000:01:00.0 enp1s0f0: Flow control is off for TX and off for RX
[   11.127066] tg3 0000:01:00.0 enp1s0f0: EEE is disabled
[   11.127078] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f0: link becomes ready
[   11.735221] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f3: link is not ready
[   12.316140] bnx2x 0001:03:00.3 enP1p3s0f3: using MSI-X  IRQs: sp 423  fp[0] 425 ... fp[7] 432
[   12.577680] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f3: link is not ready
[   12.581682] IPv6: ADDRCONF(NETDEV_UP): enp1s0f1: link is not ready
[   12.650159] IPv6: ADDRCONF(NETDEV_UP): enp1s0f1: link is not ready
[   12.653460] IPv6: ADDRCONF(NETDEV_UP): enp1s0f2: link is not ready
[   12.724084] IPv6: ADDRCONF(NETDEV_UP): enp1s0f2: link is not ready
[   12.727165] IPv6: ADDRCONF(NETDEV_UP): enp1s0f3: link is not ready
[   12.797732] IPv6: ADDRCONF(NETDEV_UP): enp1s0f3: link is not ready
[   12.800915] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f0: link is not ready
[   13.324153] bnx2x 0001:03:00.0 enP1p3s0f0: using MSI-X  IRQs: sp 393  fp[0] 395 ... fp[7] 402
[   13.523456] bnx2x 0001:03:00.0 enP1p3s0f0: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & transmit
[   13.529418] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f1: link is not ready
[   13.684153] bnx2x 0001:03:00.1 enP1p3s0f1: using MSI-X  IRQs: sp 403  fp[0] 405 ... fp[7] 412
[   13.883452] bnx2x 0001:03:00.1 enP1p3s0f1: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & transmit
[   13.891081] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f2: link is not ready
[   14.048191] bnx2x 0001:03:00.2 enP1p3s0f2: using MSI-X  IRQs: sp 413  fp[0] 415 ... fp[7] 422
[   14.309680] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f2: link is not ready
[   16.297799] tg3 0000:01:00.1 enp1s0f1: Link is up at 1000 Mbps, full duplex
[   16.297801] tg3 0000:01:00.1 enp1s0f1: Flow control is off for TX and off for RX
[   16.297802] tg3 0000:01:00.1 enp1s0f1: EEE is disabled
[   16.297898] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f1: link becomes ready
[   24.064151] ip_tables: (C) 2000-2006 Netfilter Core Team
[   24.207596] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   24.555287] Ebtables v2.0 registered
[   25.447954] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   25.523479] virbr0: port 1(virbr0-nic) entered blocking state
[   25.523480] virbr0: port 1(virbr0-nic) entered disabled state
[   25.523676] device virbr0-nic entered promiscuous mode
[   25.888414] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   26.279016] virbr0: port 1(virbr0-nic) entered blocking state
[   26.279018] virbr0: port 1(virbr0-nic) entered listening state
[   26.720279] bnx2x 0001:03:00.0 enP1p3s0f0: using MSI-X  IRQs: sp 393  fp[0] 395 ... fp[7] 402
[   26.799661] bnx2x 0001:03:00.0 enP1p3s0f0: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & transmit
[   27.300230] bnx2x 0001:03:00.1 enP1p3s0f1: using MSI-X  IRQs: sp 403  fp[0] 405 ... fp[7] 412
[   27.379662] bnx2x 0001:03:00.1 enP1p3s0f1: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & transmit
[   27.876102] bnx2x 0001:03:00.2 enP1p3s0f2: using MSI-X  IRQs: sp 413  fp[0] 415 ... fp[7] 422
[   28.287444] virbr0: port 1(virbr0-nic) entered learning state
[   28.576124] bnx2x 0001:03:00.3 enP1p3s0f3: using MSI-X  IRQs: sp 423  fp[0] 425 ... fp[7] 432
[   29.205553] virbr0: port 1(virbr0-nic) entered disabled state
[   29.214153] device virbr0-nic left promiscuous mode
[   29.214199] virbr0: port 1(virbr0-nic) entered disabled state
[ 1331.291012] scsi host7: iSCSI Initiator over TCP/IP
[ 1331.563100] scsi 7:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1331.615585] sd 7:0:0:0: Attached scsi generic sg14 type 0
[ 1331.617746] scsi 7:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1331.618763] sd 7:0:0:0: [sdk] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1331.618767] sd 7:0:0:0: [sdk] 4096-byte physical blocks
[ 1331.619749] sd 7:0:0:0: [sdk] Write Protect is off
[ 1331.619752] sd 7:0:0:0: [sdk] Mode Sense: a7 00 00 08
[ 1331.620733] sd 7:0:0:0: [sdk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1331.626455] sd 7:0:0:0: [sdk] Attached SCSI disk
[ 1331.671422] sd 7:0:0:1: Attached scsi generic sg15 type 0
[ 1331.672024] sd 7:0:0:1: [sdl] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1331.672028] sd 7:0:0:1: [sdl] 4096-byte physical blocks
[ 1331.672029] scsi 7:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1331.672187] sd 7:0:0:1: [sdl] Write Protect is off
[ 1331.672191] sd 7:0:0:1: [sdl] Mode Sense: a7 00 00 08
[ 1331.672343] sd 7:0:0:1: [sdl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1331.674919] sd 7:0:0:1: [sdl] Attached SCSI disk
[ 1331.754914] device-mapper: multipath queue-length: version 0.2.0 loaded
[ 1331.755104] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1331.758970] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1331.759620] sd 7:0:0:2: Attached scsi generic sg16 type 0
[ 1331.760252] sd 7:0:0:2: [sdm] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1331.760257] sd 7:0:0:2: [sdm] 4096-byte physical blocks
[ 1331.760430] sd 7:0:0:2: [sdm] Write Protect is off
[ 1331.760436] sd 7:0:0:2: [sdm] Mode Sense: a7 00 00 08
[ 1331.760664] scsi 7:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1331.760733] sd 7:0:0:2: [sdm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1331.763413] sd 7:0:0:2: [sdm] Attached SCSI disk
[ 1331.836000] sd 7:0:0:3: Attached scsi generic sg17 type 0
[ 1331.836391] sd 7:0:0:3: [sdn] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1331.836395] sd 7:0:0:3: [sdn] 4096-byte physical blocks
[ 1331.836562] sd 7:0:0:3: [sdn] Write Protect is off
[ 1331.836565] sd 7:0:0:3: [sdn] Mode Sense: a7 00 00 08
[ 1331.836762] sd 7:0:0:3: [sdn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1331.837426] scsi 7:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1331.840106] sd 7:0:0:3: [sdn] Attached SCSI disk
[ 1331.840906] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1331.898148] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1331.911701] sd 7:0:0:4: Attached scsi generic sg18 type 0
[ 1331.912856] sd 7:0:0:4: [sdo] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1331.912860] sd 7:0:0:4: [sdo] 4096-byte physical blocks
[ 1331.913064] scsi 7:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1331.913067] sd 7:0:0:4: [sdo] Write Protect is off
[ 1331.913071] sd 7:0:0:4: [sdo] Mode Sense: a7 00 00 08
[ 1331.913537] sd 7:0:0:4: [sdo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1331.919000] sd 7:0:0:4: [sdo] Attached SCSI disk
[ 1332.003639] sd 7:0:0:5: Attached scsi generic sg19 type 0
[ 1332.004118] sd 7:0:0:5: [sdp] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.004122] sd 7:0:0:5: [sdp] 4096-byte physical blocks
[ 1332.004284] sd 7:0:0:5: [sdp] Write Protect is off
[ 1332.004287] sd 7:0:0:5: [sdp] Mode Sense: a7 00 00 08
[ 1332.004389] scsi 7:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.004453] sd 7:0:0:5: [sdp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.007073] sd 7:0:0:5: [sdp] Attached SCSI disk
[ 1332.010284] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1332.063724] sd 7:0:0:6: Attached scsi generic sg20 type 0
[ 1332.064111] sd 7:0:0:6: [sdq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.064115] sd 7:0:0:6: [sdq] 4096-byte physical blocks
[ 1332.064251] sd 7:0:0:6: [sdq] Write Protect is off
[ 1332.064255] sd 7:0:0:6: [sdq] Mode Sense: a7 00 00 08
[ 1332.064461] sd 7:0:0:6: [sdq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.064463] scsi 7:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.067852] sd 7:0:0:6: [sdq] Attached SCSI disk
[ 1332.105482] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1332.138205] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1332.143682] sd 7:0:0:7: Attached scsi generic sg21 type 0
[ 1332.144020] sd 7:0:0:7: [sdr] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.144024] sd 7:0:0:7: [sdr] 4096-byte physical blocks
[ 1332.144169] sd 7:0:0:7: [sdr] Write Protect is off
[ 1332.144174] sd 7:0:0:7: [sdr] Mode Sense: a7 00 00 08
[ 1332.144382] sd 7:0:0:7: [sdr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.144392] scsi 7:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.146786] sd 7:0:0:7: [sdr] Attached SCSI disk
[ 1332.206373] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1332.227829] sd 7:0:0:8: Attached scsi generic sg22 type 0
[ 1332.228286] sd 7:0:0:8: [sds] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.228292] sd 7:0:0:8: [sds] 4096-byte physical blocks
[ 1332.228452] sd 7:0:0:8: [sds] Write Protect is off
[ 1332.228456] sd 7:0:0:8: [sds] Mode Sense: a7 00 00 08
[ 1332.228570] scsi 7:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.228628] sd 7:0:0:8: [sds] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.231155] sd 7:0:0:8: [sds] Attached SCSI disk
[ 1332.291834] sd 7:0:0:9: Attached scsi generic sg23 type 0
[ 1332.292496] scsi 7:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.293375] sd 7:0:0:9: [sdt] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.293377] sd 7:0:0:9: [sdt] 4096-byte physical blocks
[ 1332.293641] sd 7:0:0:9: [sdt] Write Protect is off
[ 1332.293643] sd 7:0:0:9: [sdt] Mode Sense: a7 00 00 08
[ 1332.293781] sd 7:0:0:9: [sdt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.296505] sd 7:0:0:9: [sdt] Attached SCSI disk
[ 1332.322305] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1332.367786] sd 7:0:0:10: Attached scsi generic sg24 type 0
[ 1332.368250] sd 7:0:0:10: [sdu] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.368255] sd 7:0:0:10: [sdu] 4096-byte physical blocks
[ 1332.368453] sd 7:0:0:10: [sdu] Write Protect is off
[ 1332.368457] sd 7:0:0:10: [sdu] Mode Sense: a7 00 00 08
[ 1332.368587] scsi 7:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.368687] sd 7:0:0:10: [sdu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.371788] sd 7:0:0:10: [sdu] Attached SCSI disk
[ 1332.380150] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1332.443698] sd 7:0:0:11: Attached scsi generic sg25 type 0
[ 1332.444094] sd 7:0:0:11: [sdv] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.444099] sd 7:0:0:11: [sdv] 4096-byte physical blocks
[ 1332.444248] sd 7:0:0:11: [sdv] Write Protect is off
[ 1332.444253] sd 7:0:0:11: [sdv] Mode Sense: a7 00 00 08
[ 1332.444425] sd 7:0:0:11: [sdv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.444474] scsi 7:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.447291] sd 7:0:0:11: [sdv] Attached SCSI disk
[ 1332.503701] sd 7:0:0:12: Attached scsi generic sg26 type 0
[ 1332.504160] sd 7:0:0:12: [sdw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.504165] sd 7:0:0:12: [sdw] 4096-byte physical blocks
[ 1332.504326] sd 7:0:0:12: [sdw] Write Protect is off
[ 1332.504329] sd 7:0:0:12: [sdw] Mode Sense: a7 00 00 08
[ 1332.504440] scsi 7:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.504491] sd 7:0:0:12: [sdw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.506907] sd 7:0:0:12: [sdw] Attached SCSI disk
[ 1332.575761] sd 7:0:0:13: Attached scsi generic sg27 type 0
[ 1332.576183] sd 7:0:0:13: [sdx] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.576189] sd 7:0:0:13: [sdx] 4096-byte physical blocks
[ 1332.576362] sd 7:0:0:13: [sdx] Write Protect is off
[ 1332.576366] sd 7:0:0:13: [sdx] Mode Sense: a7 00 00 08
[ 1332.576523] scsi 7:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.576567] sd 7:0:0:13: [sdx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.579394] sd 7:0:0:13: [sdx] Attached SCSI disk
[ 1332.643661] sd 7:0:0:14: Attached scsi generic sg28 type 0
[ 1332.644036] sd 7:0:0:14: [sdy] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.644039] sd 7:0:0:14: [sdy] 4096-byte physical blocks
[ 1332.644184] sd 7:0:0:14: [sdy] Write Protect is off
[ 1332.644187] sd 7:0:0:14: [sdy] Mode Sense: a7 00 00 08
[ 1332.644331] sd 7:0:0:14: [sdy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.644386] scsi 7:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.646829] sd 7:0:0:14: [sdy] Attached SCSI disk
[ 1332.715635] sd 7:0:0:15: Attached scsi generic sg29 type 0
[ 1332.716102] sd 7:0:0:15: [sdz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.716105] sd 7:0:0:15: [sdz] 4096-byte physical blocks
[ 1332.716268] sd 7:0:0:15: [sdz] Write Protect is off
[ 1332.716271] sd 7:0:0:15: [sdz] Mode Sense: a7 00 00 08
[ 1332.716413] scsi 7:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.716436] sd 7:0:0:15: [sdz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.719124] sd 7:0:0:15: [sdz] Attached SCSI disk
[ 1332.783679] sd 7:0:0:16: Attached scsi generic sg30 type 0
[ 1332.784079] sd 7:0:0:16: [sdaa] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.784082] sd 7:0:0:16: [sdaa] 4096-byte physical blocks
[ 1332.784225] sd 7:0:0:16: [sdaa] Write Protect is off
[ 1332.784227] sd 7:0:0:16: [sdaa] Mode Sense: a7 00 00 08
[ 1332.784421] scsi 7:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.784455] sd 7:0:0:16: [sdaa] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.787085] sd 7:0:0:16: [sdaa] Attached SCSI disk
[ 1332.863662] sd 7:0:0:17: Attached scsi generic sg31 type 0
[ 1332.864060] sd 7:0:0:17: [sdab] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.864064] sd 7:0:0:17: [sdab] 4096-byte physical blocks
[ 1332.864214] sd 7:0:0:17: [sdab] Write Protect is off
[ 1332.864217] sd 7:0:0:17: [sdab] Mode Sense: a7 00 00 08
[ 1332.864361] sd 7:0:0:17: [sdab] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.864413] scsi 7:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.866643] sd 7:0:0:17: [sdab] Attached SCSI disk
[ 1332.939698] sd 7:0:0:18: Attached scsi generic sg32 type 0
[ 1332.940083] sd 7:0:0:18: [sdac] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1332.940088] sd 7:0:0:18: [sdac] 4096-byte physical blocks
[ 1332.940220] sd 7:0:0:18: [sdac] Write Protect is off
[ 1332.940223] sd 7:0:0:18: [sdac] Mode Sense: a7 00 00 08
[ 1332.940383] sd 7:0:0:18: [sdac] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1332.940460] scsi 7:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1332.944850] sd 7:0:0:18: [sdac] Attached SCSI disk
[ 1333.019669] sd 7:0:0:19: Attached scsi generic sg33 type 0
[ 1333.020126] sd 7:0:0:19: [sdad] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.020130] sd 7:0:0:19: [sdad] 4096-byte physical blocks
[ 1333.020302] sd 7:0:0:19: [sdad] Write Protect is off
[ 1333.020306] sd 7:0:0:19: [sdad] Mode Sense: a7 00 00 08
[ 1333.020426] scsi 7:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.020492] sd 7:0:0:19: [sdad] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.023015] sd 7:0:0:19: [sdad] Attached SCSI disk
[ 1333.083672] sd 7:0:0:20: Attached scsi generic sg34 type 0
[ 1333.084110] sd 7:0:0:20: [sdae] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.084114] sd 7:0:0:20: [sdae] 4096-byte physical blocks
[ 1333.084273] sd 7:0:0:20: [sdae] Write Protect is off
[ 1333.084277] sd 7:0:0:20: [sdae] Mode Sense: a7 00 00 08
[ 1333.084405] scsi 7:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.084513] sd 7:0:0:20: [sdae] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.090090] sd 7:0:0:20: [sdae] Attached SCSI disk
[ 1333.167783] sd 7:0:0:21: Attached scsi generic sg35 type 0
[ 1333.168857] scsi 7:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.169003] sd 7:0:0:21: [sdaf] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.169008] sd 7:0:0:21: [sdaf] 4096-byte physical blocks
[ 1333.169231] sd 7:0:0:21: [sdaf] Write Protect is off
[ 1333.169233] sd 7:0:0:21: [sdaf] Mode Sense: a7 00 00 08
[ 1333.169379] sd 7:0:0:21: [sdaf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.173238] sd 7:0:0:21: [sdaf] Attached SCSI disk
[ 1333.267733] sd 7:0:0:22: Attached scsi generic sg36 type 0
[ 1333.268149] sd 7:0:0:22: [sdag] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.268153] sd 7:0:0:22: [sdag] 4096-byte physical blocks
[ 1333.268325] sd 7:0:0:22: [sdag] Write Protect is off
[ 1333.268329] sd 7:0:0:22: [sdag] Mode Sense: a7 00 00 08
[ 1333.268416] scsi 7:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.268549] sd 7:0:0:22: [sdag] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.271179] sd 7:0:0:22: [sdag] Attached SCSI disk
[ 1333.331701] sd 7:0:0:23: Attached scsi generic sg37 type 0
[ 1333.332006] sd 7:0:0:23: [sdah] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.332009] sd 7:0:0:23: [sdah] 4096-byte physical blocks
[ 1333.332177] sd 7:0:0:23: [sdah] Write Protect is off
[ 1333.332183] sd 7:0:0:23: [sdah] Mode Sense: a7 00 00 08
[ 1333.332357] sd 7:0:0:23: [sdah] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.335528] sd 7:0:0:23: [sdah] Attached SCSI disk
[ 1333.589571] scsi host8: iSCSI Initiator over TCP/IP
[ 1333.862255] scsi 8:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.907649] sd 8:0:0:0: Attached scsi generic sg38 type 0
[ 1333.909891] scsi 8:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.910851] sd 8:0:0:0: [sdai] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.910855] sd 8:0:0:0: [sdai] 4096-byte physical blocks
[ 1333.911824] sd 8:0:0:0: [sdai] Write Protect is off
[ 1333.911827] sd 8:0:0:0: [sdai] Mode Sense: a7 00 00 08
[ 1333.912816] sd 8:0:0:0: [sdai] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.918900] sd 8:0:0:0: [sdai] Attached SCSI disk
[ 1333.971619] sd 8:0:0:1: Attached scsi generic sg39 type 0
[ 1333.972106] sd 8:0:0:1: [sdaj] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1333.972109] sd 8:0:0:1: [sdaj] 4096-byte physical blocks
[ 1333.972260] sd 8:0:0:1: [sdaj] Write Protect is off
[ 1333.972262] sd 8:0:0:1: [sdaj] Mode Sense: a7 00 00 08
[ 1333.972272] scsi 8:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1333.972417] sd 8:0:0:1: [sdaj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1333.975070] sd 8:0:0:1: [sdaj] Attached SCSI disk
[ 1334.043734] sd 8:0:0:2: Attached scsi generic sg40 type 0
[ 1334.045575] sd 8:0:0:2: [sdak] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.045578] scsi 8:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.045580] sd 8:0:0:2: [sdak] 4096-byte physical blocks
[ 1334.045746] sd 8:0:0:2: [sdak] Write Protect is off
[ 1334.045748] sd 8:0:0:2: [sdak] Mode Sense: a7 00 00 08
[ 1334.045929] sd 8:0:0:2: [sdak] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.049051] sd 8:0:0:2: [sdak] Attached SCSI disk
[ 1334.115793] sd 8:0:0:3: Attached scsi generic sg41 type 0
[ 1334.116993] scsi 8:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.117132] sd 8:0:0:3: [sdal] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.117138] sd 8:0:0:3: [sdal] 4096-byte physical blocks
[ 1334.117318] sd 8:0:0:3: [sdal] Write Protect is off
[ 1334.117323] sd 8:0:0:3: [sdal] Mode Sense: a7 00 00 08
[ 1334.117504] sd 8:0:0:3: [sdal] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.121488] sd 8:0:0:3: [sdal] Attached SCSI disk
[ 1334.191682] sd 8:0:0:4: Attached scsi generic sg42 type 0
[ 1334.192180] sd 8:0:0:4: [sdam] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.192182] sd 8:0:0:4: [sdam] 4096-byte physical blocks
[ 1334.192321] sd 8:0:0:4: [sdam] Write Protect is off
[ 1334.192323] sd 8:0:0:4: [sdam] Mode Sense: a7 00 00 08
[ 1334.192534] scsi 8:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.192611] sd 8:0:0:4: [sdam] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.195581] sd 8:0:0:4: [sdam] Attached SCSI disk
[ 1334.267739] sd 8:0:0:5: Attached scsi generic sg43 type 0
[ 1334.268262] sd 8:0:0:5: [sdan] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.268269] sd 8:0:0:5: [sdan] 4096-byte physical blocks
[ 1334.268438] sd 8:0:0:5: [sdan] Write Protect is off
[ 1334.268442] sd 8:0:0:5: [sdan] Mode Sense: a7 00 00 08
[ 1334.268617] sd 8:0:0:5: [sdan] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.268667] scsi 8:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.272023] sd 8:0:0:5: [sdan] Attached SCSI disk
[ 1334.327753] sd 8:0:0:6: Attached scsi generic sg44 type 0
[ 1334.328335] sd 8:0:0:6: [sdao] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.328340] sd 8:0:0:6: [sdao] 4096-byte physical blocks
[ 1334.328497] sd 8:0:0:6: [sdao] Write Protect is off
[ 1334.328500] sd 8:0:0:6: [sdao] Mode Sense: a7 00 00 08
[ 1334.328670] sd 8:0:0:6: [sdao] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.332070] scsi 8:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.332828] sd 8:0:0:6: [sdao] Attached SCSI disk
[ 1334.411803] sd 8:0:0:7: Attached scsi generic sg45 type 0
[ 1334.412291] sd 8:0:0:7: [sdap] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.412295] sd 8:0:0:7: [sdap] 4096-byte physical blocks
[ 1334.412497] sd 8:0:0:7: [sdap] Write Protect is off
[ 1334.412504] sd 8:0:0:7: [sdap] Mode Sense: a7 00 00 08
[ 1334.412797] sd 8:0:0:7: [sdap] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.413160] scsi 8:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.417861] sd 8:0:0:7: [sdap] Attached SCSI disk
[ 1334.495781] sd 8:0:0:8: Attached scsi generic sg46 type 0
[ 1334.496235] sd 8:0:0:8: [sdaq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.496241] sd 8:0:0:8: [sdaq] 4096-byte physical blocks
[ 1334.496433] sd 8:0:0:8: [sdaq] Write Protect is off
[ 1334.496440] sd 8:0:0:8: [sdaq] Mode Sense: a7 00 00 08
[ 1334.496687] sd 8:0:0:8: [sdaq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.497219] scsi 8:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.500727] sd 8:0:0:8: [sdaq] Attached SCSI disk
[ 1334.579871] sd 8:0:0:9: Attached scsi generic sg47 type 0
[ 1334.580290] sd 8:0:0:9: [sdar] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.580294] sd 8:0:0:9: [sdar] 4096-byte physical blocks
[ 1334.580440] sd 8:0:0:9: [sdar] Write Protect is off
[ 1334.580444] sd 8:0:0:9: [sdar] Mode Sense: a7 00 00 08
[ 1334.580552] scsi 8:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.580605] sd 8:0:0:9: [sdar] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.583768] sd 8:0:0:9: [sdar] Attached SCSI disk
[ 1334.655692] sd 8:0:0:10: Attached scsi generic sg48 type 0
[ 1334.656144] sd 8:0:0:10: [sdas] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.656146] sd 8:0:0:10: [sdas] 4096-byte physical blocks
[ 1334.656300] sd 8:0:0:10: [sdas] Write Protect is off
[ 1334.656303] sd 8:0:0:10: [sdas] Mode Sense: a7 00 00 08
[ 1334.656306] scsi 8:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.656453] sd 8:0:0:10: [sdas] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.658876] sd 8:0:0:10: [sdas] Attached SCSI disk
[ 1334.727894] sd 8:0:0:11: Attached scsi generic sg49 type 0
[ 1334.728178] sd 8:0:0:11: [sdat] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.728188] sd 8:0:0:11: [sdat] 4096-byte physical blocks
[ 1334.728360] sd 8:0:0:11: [sdat] Write Protect is off
[ 1334.728366] sd 8:0:0:11: [sdat] Mode Sense: a7 00 00 08
[ 1334.728591] sd 8:0:0:11: [sdat] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.729244] scsi 8:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.732632] sd 8:0:0:11: [sdat] Attached SCSI disk
[ 1334.803923] sd 8:0:0:12: Attached scsi generic sg50 type 0
[ 1334.804540] sd 8:0:0:12: [sdau] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.804544] sd 8:0:0:12: [sdau] 4096-byte physical blocks
[ 1334.804692] sd 8:0:0:12: [sdau] Write Protect is off
[ 1334.804696] sd 8:0:0:12: [sdau] Mode Sense: a7 00 00 08
[ 1334.805122] sd 8:0:0:12: [sdau] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.805394] scsi 8:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.807657] sd 8:0:0:12: [sdau] Attached SCSI disk
[ 1334.847739] sd 8:0:0:13: Attached scsi generic sg51 type 0
[ 1334.848039] sd 8:0:0:13: [sdav] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.848043] sd 8:0:0:13: [sdav] 4096-byte physical blocks
[ 1334.848188] sd 8:0:0:13: [sdav] Write Protect is off
[ 1334.848192] sd 8:0:0:13: [sdav] Mode Sense: a7 00 00 08
[ 1334.848407] sd 8:0:0:13: [sdav] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.848685] scsi 8:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.851025] sd 8:0:0:13: [sdav] Attached SCSI disk
[ 1334.931802] sd 8:0:0:14: Attached scsi generic sg52 type 0
[ 1334.932442] sd 8:0:0:14: [sdaw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1334.932449] sd 8:0:0:14: [sdaw] 4096-byte physical blocks
[ 1334.932638] sd 8:0:0:14: [sdaw] Write Protect is off
[ 1334.932645] sd 8:0:0:14: [sdaw] Mode Sense: a7 00 00 08
[ 1334.932912] sd 8:0:0:14: [sdaw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1334.933242] scsi 8:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1334.937382] sd 8:0:0:14: [sdaw] Attached SCSI disk
[ 1335.019795] sd 8:0:0:15: Attached scsi generic sg53 type 0
[ 1335.020420] sd 8:0:0:15: [sdax] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.020423] sd 8:0:0:15: [sdax] 4096-byte physical blocks
[ 1335.020603] scsi 8:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.020609] sd 8:0:0:15: [sdax] Write Protect is off
[ 1335.020614] sd 8:0:0:15: [sdax] Mode Sense: a7 00 00 08
[ 1335.021116] sd 8:0:0:15: [sdax] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.024035] sd 8:0:0:15: [sdax] Attached SCSI disk
[ 1335.091714] sd 8:0:0:16: Attached scsi generic sg54 type 0
[ 1335.092180] sd 8:0:0:16: [sday] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.092183] sd 8:0:0:16: [sday] 4096-byte physical blocks
[ 1335.092316] sd 8:0:0:16: [sday] Write Protect is off
[ 1335.092318] sd 8:0:0:16: [sday] Mode Sense: a7 00 00 08
[ 1335.092628] sd 8:0:0:16: [sday] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.092652] scsi 8:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.095543] sd 8:0:0:16: [sday] Attached SCSI disk
[ 1335.167747] sd 8:0:0:17: Attached scsi generic sg55 type 0
[ 1335.168188] sd 8:0:0:17: [sdaz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.168192] sd 8:0:0:17: [sdaz] 4096-byte physical blocks
[ 1335.168331] sd 8:0:0:17: [sdaz] Write Protect is off
[ 1335.168334] sd 8:0:0:17: [sdaz] Mode Sense: a7 00 00 08
[ 1335.168536] sd 8:0:0:17: [sdaz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.168676] scsi 8:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.171271] sd 8:0:0:17: [sdaz] Attached SCSI disk
[ 1335.251752] sd 8:0:0:18: Attached scsi generic sg56 type 0
[ 1335.252341] sd 8:0:0:18: [sdba] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.252344] sd 8:0:0:18: [sdba] 4096-byte physical blocks
[ 1335.252473] sd 8:0:0:18: [sdba] Write Protect is off
[ 1335.252475] sd 8:0:0:18: [sdba] Mode Sense: a7 00 00 08
[ 1335.252624] scsi 8:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.252668] sd 8:0:0:18: [sdba] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.256226] sd 8:0:0:18: [sdba] Attached SCSI disk
[ 1335.315860] sd 8:0:0:19: Attached scsi generic sg57 type 0
[ 1335.316250] sd 8:0:0:19: [sdbb] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.316254] sd 8:0:0:19: [sdbb] 4096-byte physical blocks
[ 1335.316410] sd 8:0:0:19: [sdbb] Write Protect is off
[ 1335.316414] sd 8:0:0:19: [sdbb] Mode Sense: a7 00 00 08
[ 1335.316634] sd 8:0:0:19: [sdbb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.317035] scsi 8:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.319861] sd 8:0:0:19: [sdbb] Attached SCSI disk
[ 1335.387842] sd 8:0:0:20: Attached scsi generic sg58 type 0
[ 1335.388700] sd 8:0:0:20: [sdbc] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.388705] sd 8:0:0:20: [sdbc] 4096-byte physical blocks
[ 1335.388888] sd 8:0:0:20: [sdbc] Write Protect is off
[ 1335.388894] sd 8:0:0:20: [sdbc] Mode Sense: a7 00 00 08
[ 1335.388901] scsi 8:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.389105] sd 8:0:0:20: [sdbc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.393191] sd 8:0:0:20: [sdbc] Attached SCSI disk
[ 1335.451897] sd 8:0:0:21: Attached scsi generic sg59 type 0
[ 1335.452271] sd 8:0:0:21: [sdbd] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.452276] sd 8:0:0:21: [sdbd] 4096-byte physical blocks
[ 1335.452432] sd 8:0:0:21: [sdbd] Write Protect is off
[ 1335.452437] sd 8:0:0:21: [sdbd] Mode Sense: a7 00 00 08
[ 1335.452620] sd 8:0:0:21: [sdbd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.452963] scsi 8:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.455532] sd 8:0:0:21: [sdbd] Attached SCSI disk
[ 1335.543752] sd 8:0:0:22: Attached scsi generic sg60 type 0
[ 1335.544099] sd 8:0:0:22: [sdbe] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.544102] sd 8:0:0:22: [sdbe] 4096-byte physical blocks
[ 1335.544280] sd 8:0:0:22: [sdbe] Write Protect is off
[ 1335.544283] sd 8:0:0:22: [sdbe] Mode Sense: a7 00 00 08
[ 1335.544451] sd 8:0:0:22: [sdbe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.544532] scsi 8:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1335.547129] sd 8:0:0:22: [sdbe] Attached SCSI disk
[ 1335.607755] sd 8:0:0:23: Attached scsi generic sg61 type 0
[ 1335.608102] sd 8:0:0:23: [sdbf] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1335.608106] sd 8:0:0:23: [sdbf] 4096-byte physical blocks
[ 1335.608239] sd 8:0:0:23: [sdbf] Write Protect is off
[ 1335.608242] sd 8:0:0:23: [sdbf] Mode Sense: a7 00 00 08
[ 1335.608392] sd 8:0:0:23: [sdbf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1335.611650] sd 8:0:0:23: [sdbf] Attached SCSI disk
[ 1335.868439] scsi host9: iSCSI Initiator over TCP/IP
[ 1336.141579] scsi 9:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.191784] sd 9:0:0:0: Attached scsi generic sg62 type 0
[ 1336.193899] scsi 9:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.194900] sd 9:0:0:0: [sdbg] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.194904] sd 9:0:0:0: [sdbg] 4096-byte physical blocks
[ 1336.195875] sd 9:0:0:0: [sdbg] Write Protect is off
[ 1336.195878] sd 9:0:0:0: [sdbg] Mode Sense: a7 00 00 08
[ 1336.196880] sd 9:0:0:0: [sdbg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.202437] sd 9:0:0:0: [sdbg] Attached SCSI disk
[ 1336.251714] sd 9:0:0:1: Attached scsi generic sg63 type 0
[ 1336.252113] sd 9:0:0:1: [sdbh] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.252118] sd 9:0:0:1: [sdbh] 4096-byte physical blocks
[ 1336.252279] sd 9:0:0:1: [sdbh] Write Protect is off
[ 1336.252283] sd 9:0:0:1: [sdbh] Mode Sense: a7 00 00 08
[ 1336.252501] sd 9:0:0:1: [sdbh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.252550] scsi 9:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.255396] sd 9:0:0:1: [sdbh] Attached SCSI disk
[ 1336.315855] sd 9:0:0:2: Attached scsi generic sg64 type 0
[ 1336.316463] scsi 9:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.316701] sd 9:0:0:2: [sdbi] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.316704] sd 9:0:0:2: [sdbi] 4096-byte physical blocks
[ 1336.316848] sd 9:0:0:2: [sdbi] Write Protect is off
[ 1336.316853] sd 9:0:0:2: [sdbi] Mode Sense: a7 00 00 08
[ 1336.316973] sd 9:0:0:2: [sdbi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.319882] sd 9:0:0:2: [sdbi] Attached SCSI disk
[ 1336.375731] sd 9:0:0:3: Attached scsi generic sg65 type 0
[ 1336.376214] sd 9:0:0:3: [sdbj] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.376217] sd 9:0:0:3: [sdbj] 4096-byte physical blocks
[ 1336.376371] sd 9:0:0:3: [sdbj] Write Protect is off
[ 1336.376373] sd 9:0:0:3: [sdbj] Mode Sense: a7 00 00 08
[ 1336.376450] scsi 9:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.376565] sd 9:0:0:3: [sdbj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.379079] sd 9:0:0:3: [sdbj] Attached SCSI disk
[ 1336.451730] sd 9:0:0:4: Attached scsi generic sg66 type 0
[ 1336.452152] sd 9:0:0:4: [sdbk] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.452155] sd 9:0:0:4: [sdbk] 4096-byte physical blocks
[ 1336.452298] sd 9:0:0:4: [sdbk] Write Protect is off
[ 1336.452301] sd 9:0:0:4: [sdbk] Mode Sense: a7 00 00 08
[ 1336.452371] scsi 9:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.452489] sd 9:0:0:4: [sdbk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.454732] sd 9:0:0:4: [sdbk] Attached SCSI disk
[ 1336.531749] sd 9:0:0:5: Attached scsi generic sg67 type 0
[ 1336.532129] sd 9:0:0:5: [sdbl] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.532132] sd 9:0:0:5: [sdbl] 4096-byte physical blocks
[ 1336.532255] sd 9:0:0:5: [sdbl] Write Protect is off
[ 1336.532258] sd 9:0:0:5: [sdbl] Mode Sense: a7 00 00 08
[ 1336.532415] sd 9:0:0:5: [sdbl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.532686] scsi 9:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.535326] sd 9:0:0:5: [sdbl] Attached SCSI disk
[ 1336.591751] sd 9:0:0:6: Attached scsi generic sg68 type 0
[ 1336.592124] sd 9:0:0:6: [sdbm] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.592126] sd 9:0:0:6: [sdbm] 4096-byte physical blocks
[ 1336.592282] sd 9:0:0:6: [sdbm] Write Protect is off
[ 1336.592284] sd 9:0:0:6: [sdbm] Mode Sense: a7 00 00 08
[ 1336.592396] scsi 9:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.592430] sd 9:0:0:6: [sdbm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.595000] sd 9:0:0:6: [sdbm] Attached SCSI disk
[ 1336.647844] sd 9:0:0:7: Attached scsi generic sg69 type 0
[ 1336.648229] sd 9:0:0:7: [sdbn] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.648233] sd 9:0:0:7: [sdbn] 4096-byte physical blocks
[ 1336.648370] sd 9:0:0:7: [sdbn] Write Protect is off
[ 1336.648373] sd 9:0:0:7: [sdbn] Mode Sense: a7 00 00 08
[ 1336.648534] sd 9:0:0:7: [sdbn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.648692] scsi 9:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.651789] sd 9:0:0:7: [sdbn] Attached SCSI disk
[ 1336.731725] sd 9:0:0:8: Attached scsi generic sg70 type 0
[ 1336.732128] sd 9:0:0:8: [sdbo] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.732130] sd 9:0:0:8: [sdbo] 4096-byte physical blocks
[ 1336.732272] sd 9:0:0:8: [sdbo] Write Protect is off
[ 1336.732275] sd 9:0:0:8: [sdbo] Mode Sense: a7 00 00 08
[ 1336.732356] scsi 9:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.732471] sd 9:0:0:8: [sdbo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.734756] sd 9:0:0:8: [sdbo] Attached SCSI disk
[ 1336.791735] sd 9:0:0:9: Attached scsi generic sg71 type 0
[ 1336.792263] sd 9:0:0:9: [sdbp] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.792266] sd 9:0:0:9: [sdbp] 4096-byte physical blocks
[ 1336.792459] sd 9:0:0:9: [sdbp] Write Protect is off
[ 1336.792463] sd 9:0:0:9: [sdbp] Mode Sense: a7 00 00 08
[ 1336.792597] scsi 9:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.792672] sd 9:0:0:9: [sdbp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.795881] sd 9:0:0:9: [sdbp] Attached SCSI disk
[ 1336.824276] ql_add_path: 86 callbacks suppressed
[ 1336.824278] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.824281] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.824302] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.858465] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.858468] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.858487] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.871747] sd 9:0:0:10: Attached scsi generic sg72 type 0
[ 1336.872151] sd 9:0:0:10: [sdbq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.872154] sd 9:0:0:10: [sdbq] 4096-byte physical blocks
[ 1336.872286] sd 9:0:0:10: [sdbq] Write Protect is off
[ 1336.872288] sd 9:0:0:10: [sdbq] Mode Sense: a7 00 00 08
[ 1336.872415] scsi 9:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.872440] sd 9:0:0:10: [sdbq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.875008] sd 9:0:0:10: [sdbq] Attached SCSI disk
[ 1336.939778] sd 9:0:0:11: Attached scsi generic sg73 type 0
[ 1336.940226] sd 9:0:0:11: [sdbr] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1336.940230] sd 9:0:0:11: [sdbr] 4096-byte physical blocks
[ 1336.940403] sd 9:0:0:11: [sdbr] Write Protect is off
[ 1336.940406] sd 9:0:0:11: [sdbr] Mode Sense: a7 00 00 08
[ 1336.940595] sd 9:0:0:11: [sdbr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1336.940877] scsi 9:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1336.944012] sd 9:0:0:11: [sdbr] Attached SCSI disk
[ 1336.944256] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.944261] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.944287] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1336.998231] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[ 1337.011726] sd 9:0:0:12: Attached scsi generic sg74 type 0
[ 1337.012240] sd 9:0:0:12: [sdbs] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.012243] sd 9:0:0:12: [sdbs] 4096-byte physical blocks
[ 1337.012394] sd 9:0:0:12: [sdbs] Write Protect is off
[ 1337.012396] sd 9:0:0:12: [sdbs] Mode Sense: a7 00 00 08
[ 1337.012464] scsi 9:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.012591] sd 9:0:0:12: [sdbs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.015338] sd 9:0:0:12: [sdbs] Attached SCSI disk
[ 1337.075718] sd 9:0:0:13: Attached scsi generic sg75 type 0
[ 1337.076113] sd 9:0:0:13: [sdbt] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.076117] sd 9:0:0:13: [sdbt] 4096-byte physical blocks
[ 1337.076270] sd 9:0:0:13: [sdbt] Write Protect is off
[ 1337.076273] sd 9:0:0:13: [sdbt] Mode Sense: a7 00 00 08
[ 1337.076408] sd 9:0:0:13: [sdbt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.076584] scsi 9:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.078900] sd 9:0:0:13: [sdbt] Attached SCSI disk
[ 1337.147810] sd 9:0:0:14: Attached scsi generic sg76 type 0
[ 1337.148284] sd 9:0:0:14: [sdbu] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.148292] sd 9:0:0:14: [sdbu] 4096-byte physical blocks
[ 1337.148496] sd 9:0:0:14: [sdbu] Write Protect is off
[ 1337.148501] sd 9:0:0:14: [sdbu] Mode Sense: a7 00 00 08
[ 1337.148690] sd 9:0:0:14: [sdbu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.149011] scsi 9:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.152395] sd 9:0:0:14: [sdbu] Attached SCSI disk
[ 1337.215722] sd 9:0:0:15: Attached scsi generic sg77 type 0
[ 1337.216139] sd 9:0:0:15: [sdbv] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.216143] sd 9:0:0:15: [sdbv] 4096-byte physical blocks
[ 1337.216314] sd 9:0:0:15: [sdbv] Write Protect is off
[ 1337.216317] sd 9:0:0:15: [sdbv] Mode Sense: a7 00 00 08
[ 1337.216680] sd 9:0:0:15: [sdbv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.216717] scsi 9:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.219581] sd 9:0:0:15: [sdbv] Attached SCSI disk
[ 1337.279801] sd 9:0:0:16: Attached scsi generic sg78 type 0
[ 1337.280274] sd 9:0:0:16: [sdbw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.280278] sd 9:0:0:16: [sdbw] 4096-byte physical blocks
[ 1337.280455] sd 9:0:0:16: [sdbw] Write Protect is off
[ 1337.280458] sd 9:0:0:16: [sdbw] Mode Sense: a7 00 00 08
[ 1337.280630] sd 9:0:0:16: [sdbw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.280927] scsi 9:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.284225] sd 9:0:0:16: [sdbw] Attached SCSI disk
[ 1337.347816] sd 9:0:0:17: Attached scsi generic sg79 type 0
[ 1337.348336] sd 9:0:0:17: [sdbx] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.348342] sd 9:0:0:17: [sdbx] 4096-byte physical blocks
[ 1337.348567] sd 9:0:0:17: [sdbx] Write Protect is off
[ 1337.348571] sd 9:0:0:17: [sdbx] Mode Sense: a7 00 00 08
[ 1337.348778] sd 9:0:0:17: [sdbx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.349150] scsi 9:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.352488] sd 9:0:0:17: [sdbx] Attached SCSI disk
[ 1337.427777] sd 9:0:0:18: Attached scsi generic sg80 type 0
[ 1337.428270] sd 9:0:0:18: [sdby] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.428275] sd 9:0:0:18: [sdby] 4096-byte physical blocks
[ 1337.428545] sd 9:0:0:18: [sdby] Write Protect is off
[ 1337.428548] sd 9:0:0:18: [sdby] Mode Sense: a7 00 00 08
[ 1337.428795] sd 9:0:0:18: [sdby] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.429047] scsi 9:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.432695] sd 9:0:0:18: [sdby] Attached SCSI disk
[ 1337.507807] sd 9:0:0:19: Attached scsi generic sg81 type 0
[ 1337.508209] sd 9:0:0:19: [sdbz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.508213] sd 9:0:0:19: [sdbz] 4096-byte physical blocks
[ 1337.508354] sd 9:0:0:19: [sdbz] Write Protect is off
[ 1337.508357] sd 9:0:0:19: [sdbz] Mode Sense: a7 00 00 08
[ 1337.508507] sd 9:0:0:19: [sdbz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.508729] scsi 9:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.511005] sd 9:0:0:19: [sdbz] Attached SCSI disk
[ 1337.575795] sd 9:0:0:20: Attached scsi generic sg82 type 0
[ 1337.576158] sd 9:0:0:20: [sdca] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.576161] sd 9:0:0:20: [sdca] 4096-byte physical blocks
[ 1337.576293] sd 9:0:0:20: [sdca] Write Protect is off
[ 1337.576297] sd 9:0:0:20: [sdca] Mode Sense: a7 00 00 08
[ 1337.576432] sd 9:0:0:20: [sdca] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.576657] scsi 9:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.579038] sd 9:0:0:20: [sdca] Attached SCSI disk
[ 1337.651767] sd 9:0:0:21: Attached scsi generic sg83 type 0
[ 1337.652137] sd 9:0:0:21: [sdcb] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.652139] sd 9:0:0:21: [sdcb] 4096-byte physical blocks
[ 1337.652268] sd 9:0:0:21: [sdcb] Write Protect is off
[ 1337.652270] sd 9:0:0:21: [sdcb] Mode Sense: a7 00 00 08
[ 1337.652400] sd 9:0:0:21: [sdcb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.652447] scsi 9:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.655028] sd 9:0:0:21: [sdcb] Attached SCSI disk
[ 1337.739741] sd 9:0:0:22: Attached scsi generic sg84 type 0
[ 1337.740160] sd 9:0:0:22: [sdcc] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.740166] sd 9:0:0:22: [sdcc] 4096-byte physical blocks
[ 1337.740297] sd 9:0:0:22: [sdcc] Write Protect is off
[ 1337.740300] sd 9:0:0:22: [sdcc] Mode Sense: a7 00 00 08
[ 1337.740449] sd 9:0:0:22: [sdcc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.740476] scsi 9:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1337.742927] sd 9:0:0:22: [sdcc] Attached SCSI disk
[ 1337.795816] sd 9:0:0:23: Attached scsi generic sg85 type 0
[ 1337.796133] sd 9:0:0:23: [sdcd] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1337.796136] sd 9:0:0:23: [sdcd] 4096-byte physical blocks
[ 1337.796271] sd 9:0:0:23: [sdcd] Write Protect is off
[ 1337.796274] sd 9:0:0:23: [sdcd] Mode Sense: a7 00 00 08
[ 1337.796410] sd 9:0:0:23: [sdcd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1337.799555] sd 9:0:0:23: [sdcd] Attached SCSI disk
[ 1338.056832] scsi host10: iSCSI Initiator over TCP/IP
[ 1338.328142] scsi 10:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.371822] sd 10:0:0:0: Attached scsi generic sg86 type 0
[ 1338.373952] scsi 10:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.374944] sd 10:0:0:0: [sdce] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.374947] sd 10:0:0:0: [sdce] 4096-byte physical blocks
[ 1338.375919] sd 10:0:0:0: [sdce] Write Protect is off
[ 1338.375922] sd 10:0:0:0: [sdce] Mode Sense: a7 00 00 08
[ 1338.376927] sd 10:0:0:0: [sdce] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.382378] sd 10:0:0:0: [sdce] Attached SCSI disk
[ 1338.439761] sd 10:0:0:1: Attached scsi generic sg87 type 0
[ 1338.440318] sd 10:0:0:1: [sdcf] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.440323] sd 10:0:0:1: [sdcf] 4096-byte physical blocks
[ 1338.440502] sd 10:0:0:1: [sdcf] Write Protect is off
[ 1338.440508] sd 10:0:0:1: [sdcf] Mode Sense: a7 00 00 08
[ 1338.440511] scsi 10:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.440718] sd 10:0:0:1: [sdcf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.444236] sd 10:0:0:1: [sdcf] Attached SCSI disk
[ 1338.511819] sd 10:0:0:2: Attached scsi generic sg88 type 0
[ 1338.512195] sd 10:0:0:2: [sdcg] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.512198] sd 10:0:0:2: [sdcg] 4096-byte physical blocks
[ 1338.512335] sd 10:0:0:2: [sdcg] Write Protect is off
[ 1338.512338] sd 10:0:0:2: [sdcg] Mode Sense: a7 00 00 08
[ 1338.512460] scsi 10:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.512498] sd 10:0:0:2: [sdcg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.514986] sd 10:0:0:2: [sdcg] Attached SCSI disk
[ 1338.587980] sd 10:0:0:3: Attached scsi generic sg89 type 0
[ 1338.588641] scsi 10:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.588797] sd 10:0:0:3: [sdch] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.588799] sd 10:0:0:3: [sdch] 4096-byte physical blocks
[ 1338.588954] sd 10:0:0:3: [sdch] Write Protect is off
[ 1338.588957] sd 10:0:0:3: [sdch] Mode Sense: a7 00 00 08
[ 1338.589098] sd 10:0:0:3: [sdch] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.591851] sd 10:0:0:3: [sdch] Attached SCSI disk
[ 1338.667796] sd 10:0:0:4: Attached scsi generic sg90 type 0
[ 1338.668172] sd 10:0:0:4: [sdci] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.668175] sd 10:0:0:4: [sdci] 4096-byte physical blocks
[ 1338.668307] sd 10:0:0:4: [sdci] Write Protect is off
[ 1338.668309] sd 10:0:0:4: [sdci] Mode Sense: a7 00 00 08
[ 1338.668465] sd 10:0:0:4: [sdci] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.668503] scsi 10:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.670726] sd 10:0:0:4: [sdci] Attached SCSI disk
[ 1338.735723] sd 10:0:0:5: Attached scsi generic sg91 type 0
[ 1338.736276] scsi 10:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.736303] sd 10:0:0:5: [sdcj] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.736305] sd 10:0:0:5: [sdcj] 4096-byte physical blocks
[ 1338.736474] sd 10:0:0:5: [sdcj] Write Protect is off
[ 1338.736477] sd 10:0:0:5: [sdcj] Mode Sense: a7 00 00 08
[ 1338.736633] sd 10:0:0:5: [sdcj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.739786] sd 10:0:0:5: [sdcj] Attached SCSI disk
[ 1338.803850] sd 10:0:0:6: Attached scsi generic sg92 type 0
[ 1338.804326] sd 10:0:0:6: [sdck] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.804332] sd 10:0:0:6: [sdck] 4096-byte physical blocks
[ 1338.804489] sd 10:0:0:6: [sdck] Write Protect is off
[ 1338.804492] sd 10:0:0:6: [sdck] Mode Sense: a7 00 00 08
[ 1338.804662] sd 10:0:0:6: [sdck] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.804669] scsi 10:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.808135] sd 10:0:0:6: [sdck] Attached SCSI disk
[ 1338.855756] sd 10:0:0:7: Attached scsi generic sg93 type 0
[ 1338.856195] sd 10:0:0:7: [sdcl] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.856199] sd 10:0:0:7: [sdcl] 4096-byte physical blocks
[ 1338.856356] sd 10:0:0:7: [sdcl] Write Protect is off
[ 1338.856362] sd 10:0:0:7: [sdcl] Mode Sense: a7 00 00 08
[ 1338.856523] scsi 10:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.856579] sd 10:0:0:7: [sdcl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.859721] sd 10:0:0:7: [sdcl] Attached SCSI disk
[ 1338.932238] sd 10:0:0:8: Attached scsi generic sg94 type 0
[ 1338.932494] sd 10:0:0:8: [sdcm] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.932497] sd 10:0:0:8: [sdcm] 4096-byte physical blocks
[ 1338.933042] sd 10:0:0:8: [sdcm] Write Protect is off
[ 1338.933045] sd 10:0:0:8: [sdcm] Mode Sense: a7 00 00 08
[ 1338.933152] scsi 10:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.933224] sd 10:0:0:8: [sdcm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.936111] sd 10:0:0:8: [sdcm] Attached SCSI disk
[ 1338.995898] sd 10:0:0:9: Attached scsi generic sg95 type 0
[ 1338.996241] sd 10:0:0:9: [sdcn] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1338.996245] sd 10:0:0:9: [sdcn] 4096-byte physical blocks
[ 1338.996374] sd 10:0:0:9: [sdcn] Write Protect is off
[ 1338.996377] sd 10:0:0:9: [sdcn] Mode Sense: a7 00 00 08
[ 1338.996549] sd 10:0:0:9: [sdcn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1338.996709] scsi 10:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1338.999372] sd 10:0:0:9: [sdcn] Attached SCSI disk
[ 1339.067852] sd 10:0:0:10: Attached scsi generic sg96 type 0
[ 1339.068375] sd 10:0:0:10: [sdco] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.068384] sd 10:0:0:10: [sdco] 4096-byte physical blocks
[ 1339.068555] sd 10:0:0:10: [sdco] Write Protect is off
[ 1339.068558] sd 10:0:0:10: [sdco] Mode Sense: a7 00 00 08
[ 1339.068674] scsi 10:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.068764] sd 10:0:0:10: [sdco] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.072475] sd 10:0:0:10: [sdco] Attached SCSI disk
[ 1339.167805] sd 10:0:0:11: Attached scsi generic sg97 type 0
[ 1339.168452] scsi 10:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.168454] sd 10:0:0:11: [sdcp] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.168457] sd 10:0:0:11: [sdcp] 4096-byte physical blocks
[ 1339.168608] sd 10:0:0:11: [sdcp] Write Protect is off
[ 1339.168611] sd 10:0:0:11: [sdcp] Mode Sense: a7 00 00 08
[ 1339.168775] sd 10:0:0:11: [sdcp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.172000] sd 10:0:0:11: [sdcp] Attached SCSI disk
[ 1339.231866] sd 10:0:0:12: Attached scsi generic sg98 type 0
[ 1339.232351] sd 10:0:0:12: [sdcq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.232354] sd 10:0:0:12: [sdcq] 4096-byte physical blocks
[ 1339.232528] sd 10:0:0:12: [sdcq] Write Protect is off
[ 1339.232532] sd 10:0:0:12: [sdcq] Mode Sense: a7 00 00 08
[ 1339.232618] scsi 10:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.232729] sd 10:0:0:12: [sdcq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.235362] sd 10:0:0:12: [sdcq] Attached SCSI disk
[ 1339.295888] sd 10:0:0:13: Attached scsi generic sg99 type 0
[ 1339.296451] sd 10:0:0:13: [sdcr] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.296458] sd 10:0:0:13: [sdcr] 4096-byte physical blocks
[ 1339.296627] sd 10:0:0:13: [sdcr] Write Protect is off
[ 1339.296630] sd 10:0:0:13: [sdcr] Mode Sense: a7 00 00 08
[ 1339.296750] scsi 10:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.296825] sd 10:0:0:13: [sdcr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.300106] sd 10:0:0:13: [sdcr] Attached SCSI disk
[ 1339.363844] sd 10:0:0:14: Attached scsi generic sg100 type 0
[ 1339.364241] sd 10:0:0:14: [sdcs] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.364245] sd 10:0:0:14: [sdcs] 4096-byte physical blocks
[ 1339.364425] sd 10:0:0:14: [sdcs] Write Protect is off
[ 1339.364427] sd 10:0:0:14: [sdcs] Mode Sense: a7 00 00 08
[ 1339.364539] scsi 10:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.364572] sd 10:0:0:14: [sdcs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.366939] sd 10:0:0:14: [sdcs] Attached SCSI disk
[ 1339.455897] sd 10:0:0:15: Attached scsi generic sg101 type 0
[ 1339.456918] scsi 10:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.457010] sd 10:0:0:15: [sdct] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.457014] sd 10:0:0:15: [sdct] 4096-byte physical blocks
[ 1339.457180] sd 10:0:0:15: [sdct] Write Protect is off
[ 1339.457184] sd 10:0:0:15: [sdct] Mode Sense: a7 00 00 08
[ 1339.457343] sd 10:0:0:15: [sdct] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.461044] sd 10:0:0:15: [sdct] Attached SCSI disk
[ 1339.523941] sd 10:0:0:16: Attached scsi generic sg102 type 0
[ 1339.524268] sd 10:0:0:16: [sdcu] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.524276] sd 10:0:0:16: [sdcu] 4096-byte physical blocks
[ 1339.524432] sd 10:0:0:16: [sdcu] Write Protect is off
[ 1339.524436] sd 10:0:0:16: [sdcu] Mode Sense: a7 00 00 08
[ 1339.524675] sd 10:0:0:16: [sdcu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.524902] scsi 10:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.527389] sd 10:0:0:16: [sdcu] Attached SCSI disk
[ 1339.591871] sd 10:0:0:17: Attached scsi generic sg103 type 0
[ 1339.592433] sd 10:0:0:17: [sdcv] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.592437] sd 10:0:0:17: [sdcv] 4096-byte physical blocks
[ 1339.592599] sd 10:0:0:17: [sdcv] Write Protect is off
[ 1339.592602] sd 10:0:0:17: [sdcv] Mode Sense: a7 00 00 08
[ 1339.592684] scsi 10:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.592803] sd 10:0:0:17: [sdcv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.595511] sd 10:0:0:17: [sdcv] Attached SCSI disk
[ 1339.659910] sd 10:0:0:18: Attached scsi generic sg104 type 0
[ 1339.660393] sd 10:0:0:18: [sdcw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.660398] sd 10:0:0:18: [sdcw] 4096-byte physical blocks
[ 1339.660549] sd 10:0:0:18: [sdcw] Write Protect is off
[ 1339.660554] sd 10:0:0:18: [sdcw] Mode Sense: a7 00 00 08
[ 1339.660661] scsi 10:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.660749] sd 10:0:0:18: [sdcw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.663706] sd 10:0:0:18: [sdcw] Attached SCSI disk
[ 1339.727943] sd 10:0:0:19: Attached scsi generic sg105 type 0
[ 1339.729295] sd 10:0:0:19: [sdcx] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.729298] sd 10:0:0:19: [sdcx] 4096-byte physical blocks
[ 1339.729443] sd 10:0:0:19: [sdcx] Write Protect is off
[ 1339.729445] sd 10:0:0:19: [sdcx] Mode Sense: a7 00 00 08
[ 1339.729451] scsi 10:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.729611] sd 10:0:0:19: [sdcx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.732653] sd 10:0:0:19: [sdcx] Attached SCSI disk
[ 1339.796032] sd 10:0:0:20: Attached scsi generic sg106 type 0
[ 1339.796443] sd 10:0:0:20: [sdcy] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.796446] sd 10:0:0:20: [sdcy] 4096-byte physical blocks
[ 1339.796594] sd 10:0:0:20: [sdcy] Write Protect is off
[ 1339.796596] sd 10:0:0:20: [sdcy] Mode Sense: a7 00 00 08
[ 1339.796766] sd 10:0:0:20: [sdcy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.796801] scsi 10:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.799428] sd 10:0:0:20: [sdcy] Attached SCSI disk
[ 1339.871823] sd 10:0:0:21: Attached scsi generic sg107 type 0
[ 1339.872209] sd 10:0:0:21: [sdcz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.872213] sd 10:0:0:21: [sdcz] 4096-byte physical blocks
[ 1339.872363] sd 10:0:0:21: [sdcz] Write Protect is off
[ 1339.872365] sd 10:0:0:21: [sdcz] Mode Sense: a7 00 00 08
[ 1339.872477] scsi 10:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.872511] sd 10:0:0:21: [sdcz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.874798] sd 10:0:0:21: [sdcz] Attached SCSI disk
[ 1339.943886] sd 10:0:0:22: Attached scsi generic sg108 type 0
[ 1339.944480] sd 10:0:0:22: [sdda] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1339.944483] sd 10:0:0:22: [sdda] 4096-byte physical blocks
[ 1339.944519] scsi 10:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[ 1339.944633] sd 10:0:0:22: [sdda] Write Protect is off
[ 1339.944636] sd 10:0:0:22: [sdda] Mode Sense: a7 00 00 08
[ 1339.944981] sd 10:0:0:22: [sdda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1339.947350] sd 10:0:0:22: [sdda] Attached SCSI disk
[ 1340.003899] sd 10:0:0:23: Attached scsi generic sg109 type 0
[ 1340.004235] sd 10:0:0:23: [sddb] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[ 1340.004239] sd 10:0:0:23: [sddb] 4096-byte physical blocks
[ 1340.004377] sd 10:0:0:23: [sddb] Write Protect is off
[ 1340.004380] sd 10:0:0:23: [sddb] Mode Sense: a7 00 00 08
[ 1340.004513] sd 10:0:0:23: [sddb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 1340.007235] sd 10:0:0:23: [sddb] Attached SCSI disk
[ 1374.685923] iscsi_complete_task while task on list
[ 1374.686027] ------------[ cut here ]------------
[ 1374.686060] WARNING: CPU: 31 PID: 2574 at drivers/scsi/libiscsi.c:565 iscsi_complete_task+0x1d8/0x1e0 [libiscsi]
[ 1374.686064] Modules linked in: dm_queue_length xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables joydev input_leds mac_hid hid_generic usbhid hid kvm_hv kvm ofpart ipmi_powernv ipmi_devintf cmdlinepart at24 nvmem_core uio_pdrv_genirq powernv_flash mtd ipmi_msghandler vmx_crypto uio powernv_rng opal_prd ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi parport_pc ppdev lp parport dm_multipath autofs4 uas usb_storage ast i2c_algo_bit ttm bnx2x drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops d
 rm ahci libahci
[ 1374.686234]  mdio libcrc32c
[ 1374.686246] CPU: 31 PID: 2574 Comm: kworker/u256:1 Not tainted 4.10.0-rc6-gpiccoli-cleech+ #7
[ 1374.686257] Workqueue: iscsi_q_9 iscsi_xmitworker [libiscsi]
[ 1374.686263] task: c000000f19990800 task.stack: c000000f04d28000
[ 1374.686266] NIP: d00000000e2d0f58 LR: d00000000e2d0f54 CTR: c0000000005e9260
[ 1374.686270] REGS: c000000f04d2af40 TRAP: 0700   Not tainted  (4.10.0-rc6-gpiccoli-cleech+)
[ 1374.686272] MSR: 900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>
[ 1374.686293]   CR: 28842222  XER: 00000000
[ 1374.686295] CFAR: c000000000b93c30 SOFTE: 1 
               GPR00: d00000000e2d0f54 c000000f04d2b1c0 d00000000e2e2c10 0000000000000026 
               GPR04: 0000000000000001 0000000000000000 c000000001666000 00000000000006b2 
               GPR08: c000000001666000 0000000000000000 0000000000000000 d00000000e2d84b8 
               GPR12: 0000000000002200 c00000000fb91700 00000000d2a0744b 0000000000007c70 
               GPR16: 0000000000000004 c000000ea5da01d8 c000000000000000 0000000000000000 
               GPR20: 0000000000000000 c000000f0c714598 c000000f0c08bc00 d00000000e2db380 
               GPR24: 0000000000000000 0000000000000000 c000000efc9fc458 0000000000000000 
               GPR28: c000000f0c714418 c000000f0c08bc80 c000000f0c714368 c000000f0c08bc00 
[ 1374.686374] NIP [d00000000e2d0f58] iscsi_complete_task+0x1d8/0x1e0 [libiscsi]
[ 1374.686383] LR [d00000000e2d0f54] iscsi_complete_task+0x1d4/0x1e0 [libiscsi]
[ 1374.686385] Call Trace:
[ 1374.686398] [c000000f04d2b1c0] [d00000000e2d0f54] iscsi_complete_task+0x1d4/0x1e0 [libiscsi] (unreliable)
[ 1374.686411] [c000000f04d2b240] [d00000000e2d6ec8] __iscsi_complete_pdu+0x3f8/0xa90 [libiscsi]
[ 1374.686423] [c000000f04d2b320] [d00000000e2d75b4] iscsi_complete_pdu+0x54/0xc0 [libiscsi]
[ 1374.686434] [c000000f04d2b370] [d00000000e3320e0] iscsi_tcp_hdr_recv_done+0x390/0x12c8 [libiscsi_tcp]
[ 1374.686443] [c000000f04d2b450] [d00000000e331968] iscsi_tcp_recv_skb+0xd8/0x4c0 [libiscsi_tcp]
[ 1374.686454] [c000000f04d2b540] [d00000000e391738] iscsi_sw_tcp_recv+0x98/0x170 [iscsi_tcp]
[ 1374.686466] [c000000f04d2b5e0] [c000000000a7ac44] tcp_read_sock+0xd4/0x290
[ 1374.686476] [c000000f04d2b650] [d00000000e3915c0] iscsi_sw_tcp_data_ready+0x70/0x150 [iscsi_tcp]
[ 1374.686484] [c000000f04d2b6f0] [c000000000a8c7f8] tcp_rcv_established+0x5a8/0x850
[ 1374.686492] [c000000f04d2b760] [c000000000a9a024] tcp_v4_do_rcv+0x1a4/0x2e0
[ 1374.686502] [c000000f04d2b7a0] [c0000000009df6c4] __release_sock+0xd4/0x170
[ 1374.686510] [c000000f04d2b800] [c0000000009e05fc] release_sock+0x4c/0xe0
[ 1374.686518] [c000000f04d2b830] [c000000000a7fa08] tcp_sendmsg+0x438/0xd50
[ 1374.686527] [c000000f04d2b910] [c000000000abaef8] inet_sendmsg+0x78/0x130
[ 1374.686535] [c000000f04d2b950] [c0000000009da83c] sock_sendmsg+0x6c/0xa0
[ 1374.686544] [c000000f04d2b980] [d00000000e390690] iscsi_sw_tcp_xmit_segment+0x90/0x1f0 [iscsi_tcp]
[ 1374.686555] [c000000f04d2ba60] [d00000000e39087c] iscsi_sw_tcp_pdu_xmit+0x8c/0x250 [iscsi_tcp]
[ 1374.686570] [c000000f04d2baf0] [d00000000e330cc8] iscsi_tcp_task_xmit+0x188/0x420 [libiscsi_tcp]
[ 1374.686587] [c000000f04d2bba0] [d00000000e2d0cc0] iscsi_xmit_task+0x80/0x140 [libiscsi]
[ 1374.686608] [c000000f04d2bbe0] [d00000000e2d6070] iscsi_xmitworker+0x2a0/0x440 [libiscsi]
[ 1374.686627] [c000000f04d2bc90] [c0000000000f6490] process_one_work+0x1e0/0x590
[ 1374.686649] [c000000f04d2bd20] [c0000000000f68e8] worker_thread+0xa8/0x660
[ 1374.686668] [c000000f04d2bdc0] [c0000000000ffd24] kthread+0x154/0x1a0
[ 1374.686683] [c000000f04d2be30] [c00000000000b4e8] ret_from_kernel_thread+0x5c/0x74
[ 1374.686697] Instruction dump:
[ 1374.686704] 992a0000 0fe00000 4bfffebc 60000000 60000000 60420000 3d220000 e8698060 
[ 1374.686739] 39200001 992a0001 48007569 e8410018 <0fe00000> 4bfffec8 3c4c0001 38421cb0 
[ 1374.686757] ---[ end trace 3ace3c9c59f4a183 ]---

--------------C6172F10CCBA83E84B9E7370
Content-Type: text/plain; charset=UTF-8;
 name="repro.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="repro.out"

6e:mon>
6e:mon> e
cpu 0x6e: Vector: 300 (Data Access) at [c000000e8224b820]
    pc: d00000000e4a68a8: iscsi_eh_cmd_timed_out+0x2a8/0x3a0 [libiscsi]
    lr: d00000000e4a6660: iscsi_eh_cmd_timed_out+0x60/0x3a0 [libiscsi]
    sp: c000000e8224baa0
   msr: 900000000280b033
   dar: b0
 dsisr: 40000000
  current = 0xc000000ef99c2c00
  paca    = 0xc00000000fbbde00   softe: 0        irq_happened: 0x09
    pid   = 3068, comm = kworker/110:1H
Linux version 4.10.0-rc6-gpiccoli+ (root@fs28) (gcc version 5.4.0 20160609 (Ubuntu/IBM 5.4.0-6ubuntu1~16.04.4) ) #4 SM
P Thu Feb 2 11:19:11 CST 2017
6e:mon> t
[c000000e8224bb30] c0000000007ce1d8 scsi_times_out+0x88/0x330
[c000000e8224bbb0] c00000000059e8c8 blk_rq_timed_out+0x48/0xf0
[c000000e8224bc20] c00000000059eb64 blk_timeout_work+0x1f4/0x250
[c000000e8224bc90] c0000000000f7130 process_one_work+0x1e0/0x590
[c000000e8224bd20] c0000000000f7588 worker_thread+0xa8/0x660
[c000000e8224bdc0] c0000000001009c4 kthread+0x154/0x1a0
[c000000e8224be30] c00000000000b4e8 ret_from_kernel_thread+0x5c/0x74
6e:mon> r
R00 = d00000000e4a6660   R16 = 0000000000000000
R01 = c000000e8224baa0   R17 = 0000000000000000
R02 = d00000000e4b2aa0   R18 = 0000000000000000
R03 = c000000ee9841b68   R19 = 0000000000000001
R04 = c000000e56accc00   R20 = 0000000000000000
R05 = 0000000000000000   R21 = 0000000000000000
R06 = c000000ee9841410   R22 = c0000000013c5559
R07 = 00000001001db33f   R23 = 0000000000000000
R08 = 00000001001db33f   R24 = 0000000000000000
R09 = 00000001001db33f   R25 = c0000000014f3b00
R10 = c000000e7cd15c00   R26 = c000000eb8c00750
R11 = c000000ee98417f8   R27 = c0000000014f3b00
R12 = c000000000b8c360   R28 = 0000000000000001
R13 = c00000000fbbde00   R29 = d00000000e4ab200
R14 = c000000000100878   R30 = c000000e7cd15800
R15 = c000000f13d40040   R31 = c000000ee9840c58
pc  = d00000000e4a68a8 iscsi_eh_cmd_timed_out+0x2a8/0x3a0 [libiscsi]
cfar= c000000000005bf0 masked_interrupt+0x5c/0x64
lr  = d00000000e4a6660 iscsi_eh_cmd_timed_out+0x60/0x3a0 [libiscsi]
msr = 900000000280b033   cr  = 22002482
ctr = c000000000b8c360   xer = 0000000000000000   trap =  300
dar = 00000000000000b0   dsisr = 40000000
6e:mon> dp
paca for cpu 0x6e @ c00000000fbbde00:
 possible             = yes
 present              = yes
 online               = yes
 lock_token           = 0x8000                  (0xa)
 paca_index           = 0x6e                    (0x8)
 kernel_toc           = 0xc0000000014c6200      (0x10)
 kernelbase           = 0xc000000000000000      (0x18)
 kernel_msr           = 0xb000000000001033      (0x20)
 emergency_sp         = 0xc00000003fc90000      (0x28)
 mc_emergency_sp      = 0xc00000003fc8c000      (0x260)
 in_mce               = 0x0                     (0x268)
 hmi_event_available  = 0x0                     (0x26a)
 data_offset          = 0xf29b70000             (0x30)
 hw_cpu_id            = 0x66                    (0x38)
 cpu_start            = 0x1                     (0x3a)
 kexec_state          = 0x0                     (0x3b)
 slb_shadow[0]:       = 0xc000000008000000 0x40016e7779000500
 slb_shadow[1]:       = 0xd000000008000001 0x400142add1000510
 vmalloc_sllp         = 0x510                   (0x1b8)
 slb_cache_ptr        = 0x4                     (0x1ba)
 slb_cache[0]:        = 0x000000000003f000
 slb_cache[1]:        = 0x0000000000000001
 slb_cache[2]:        = 0x0000000000001000
 slb_cache[3]:        = 0x0000000000000000
 slb_cache[4]:        = 0x0000000000000c00
 slb_cache[5]:        = 0x0000000000000c81
 slb_cache[6]:        = 0x0000000000000000
 slb_cache[7]:        = 0x0000000000000000
 dscr_default         = 0x0                     (0x58)
 __current            = 0xc000000ef99c2c00      (0x210)
 kstack               = 0xc000000e8224be30      (0x218)
 stab_rr              = 0x3                     (0x220)
 saved_r1             = 0xc000000f1f9e7ac0      (0x228)
 trap_save            = 0x0                     (0x238)
 soft_enabled         = 0x0                     (0x23a)
 irq_happened         = 0x9                     (0x23b)
 io_sync              = 0x0                     (0x23c)
 irq_work_pending     = 0x0                     (0x23d)
 nap_state_lost       = 0x0                     (0x23e)
 sprg_vdso            = 0x6e                    (0x240)
 tm_scratch           = 0x900000000280b033      (0x248)
 core_idle_state_ptr  = 0xc000000f261b8ac0      (0x250)
 thread_idle_state    = 0x0                     (0x258)
 thread_mask          = 0x40                    (0x259)
 subcore_sibling_mask = 0xff                    (0x25a)
 accounting.user_time = 0x0                     (0x270)
 accounting.system_time = 0x0                   (0x278)
 accounting.user_time_scaled = 0x0                      (0x280)
 accounting.starttime = 0x0                     (0x288)
 accounting.starttime_user = 0x0                (0x290)
 accounting.startspurr = 0x0                    (0x298)
 accounting.utime_sspurr = 0x0                  (0x2a0)
 stolen_time          = 0x0                     (0x2a8)
6e:mon> dl
[    0.000000] opal: OPAL detected !
[    0.000000] Allocated 4718592 bytes for 2048 pacas at c00000000fb80000
[    0.000000] Page sizes from device-tree:
[    0.000000] base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
[    0.000000] base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
[    0.000000] base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
[    0.000000] base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
[    0.000000] base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
[    0.000000] base_shift=20: shift=20, sllp=0x0130, avpnm=0x00000000, tlbiel=0, penc=2
[    0.000000] base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
[    0.000000] base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
[    0.000000] Page orders: linear mapping = 24, virtual = 16, io = 16, vmemmap = 24
[    0.000000] Using 1TB segments
[    0.000000] Initializing hash mmu with SLB
[    0.000000] Found initrd at 0xc0000000030f0000:0xc0000000056943ce
[    0.000000] OPAL: Power8 LPC bus found, chip ID 0
[    0.000000] Using PowerNV machine description
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] CPU maps initialized for 8 threads per core
[    0.000000]  (thread shift is 3)
[    0.000000] Freed 4390912 bytes for unused pacas
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size    = 0x0
[    0.000000] phys_mem_size     = 0x1000000000
[    0.000000] dcache_bsize      = 0x80
[    0.000000] icache_bsize      = 0x80
[    0.000000] cpu_features      = 0x27fc7aed18500249
[    0.000000]   possible        = 0x7fffffff18500649
[    0.000000]   always          = 0x0000000018100040
[    0.000000] cpu_user_features = 0xdc0065c2 0xef000000
[    0.000000] mmu_features      = 0x7c004001
[    0.000000] firmware_features = 0x0000000110000000
[    0.000000] htab_address      = 0xc000000ff8000000
[    0.000000] htab_hash_mask    = 0x7ffff
[    0.000000] -----------------------------------------------------
[    0.000000] cma: Reserved 3280 MiB at 0x0000000f2b000000
[    0.000000] numa: Initmem setup node 0 [mem 0x00000000-0xfffffffff]
[    0.000000] numa:   NODE_DATA [mem 0xfff376300-0xfff37ffff]
[    0.000000] numa: Initmem setup node 8
[    0.000000] numa:   NODE_DATA [mem 0xfff35c600-0xfff3662ff]
[    0.000000] numa:     NODE_DATA(8) on node 0
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe40000000)
[    0.000000] PCI host bridge /pciex@3fffe40000000  ranges:
[    0.000000]  MEM 0x00003fe000000000..0x00003fe07ffeffff -> 0x0000000080000000
[    0.000000]  MEM 0x00003b0000000000..0x00003b0fffffffff -> 0x00003b0000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x800)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe40100000)
[    0.000000] PCI host bridge /pciex@3fffe40100000  ranges:
[    0.000000]  MEM 0x00003fe080000000..0x00003fe0fffeffff -> 0x0000000080000000
[    0.000000]  MEM 0x00003b1000000000..0x00003b1fffffffff -> 0x00003b1000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x1000)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe41000000)
[    0.000000] PCI host bridge /pciex@3fffe41000000  ranges:
[    0.000000]  MEM 0x00003fe800000000..0x00003fe87ffeffff -> 0x0000000080000000
[    0.000000]  MEM 0x00003c0000000000..0x00003c0fffffffff -> 0x00003c0000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x10800)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe41100000)
[    0.000000] PCI host bridge /pciex@3fffe41100000  ranges:
[    0.000000]  MEM 0x00003fe880000000..0x00003fe8fffeffff -> 0x0000000080000000
[    0.000000]  MEM 0x00003c1000000000..0x00003c1fffffffff -> 0x00003c1000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x11000)
[    0.000000] Initializing IODA2 PHB (/pciex@3fffe41200000)
[    0.000000] PCI host bridge /pciex@3fffe41200000 (primary) ranges:
[    0.000000]  MEM 0x00003fe900000000..0x00003fe97ffeffff -> 0x0000000080000000
[    0.000000]  MEM 0x00003c2000000000..0x00003c2fffffffff -> 0x00003c2000000000 (M64 #0..15)
[    0.000000]  Using M64 #15 as default window
[    0.000000]   256 (255) PE's M32: 0x80000000 [segment=0x800000]
[    0.000000]                  M64: 0x1000000000 [segment=0x10000000]
[    0.000000]   Allocated bitmap for 2040 MSIs (base IRQ 0x11800)
[    0.000000] OPAL nvram setup, 589824 bytes
[    0.000000] Top of RAM: 0x1000000000, Total RAM: 0x1000000000
[    0.000000] Memory hole size: 0MB
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000] On node 0 totalpages: 1048576
[    0.000000]   DMA zone: 1024 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 1048576 pages, LIFO batch:1
[    0.000000] Could not find start_pfn for node 8
[    0.000000] Initmem setup node 8 [mem 0x0000000000000000-0x0000000000000000]
[    0.000000] On node 8 totalpages: 0
[    0.000000] percpu: Embedded 3 pages/cpu @c000000f29000000 s149016 r0 d47592 u262144
[    0.000000] pcpu-alloc: s149016 r0 d47592 u262144 alloc=1*1048576
[    0.000000] pcpu-alloc: [0] 000 001 002 003 [0] 004 005 006 007
[    0.000000] pcpu-alloc: [0] 008 009 010 011 [0] 012 013 014 015
[    0.000000] pcpu-alloc: [0] 016 017 018 019 [0] 020 021 022 023
[    0.000000] pcpu-alloc: [0] 024 025 026 027 [0] 028 029 030 031
[    0.000000] pcpu-alloc: [0] 032 033 034 035 [0] 036 037 038 039
[    0.000000] pcpu-alloc: [0] 040 041 042 043 [0] 044 045 046 047
[    0.000000] pcpu-alloc: [0] 048 049 050 051 [0] 052 053 054 055
[    0.000000] pcpu-alloc: [0] 056 057 058 059 [0] 060 061 062 063
[    0.000000] pcpu-alloc: [0] 064 065 066 067 [0] 068 069 070 071
[    0.000000] pcpu-alloc: [0] 072 073 074 075 [0] 076 077 078 079
[    0.000000] pcpu-alloc: [0] 080 081 082 083 [0] 084 085 086 087
[    0.000000] pcpu-alloc: [0] 088 089 090 091 [0] 092 093 094 095
[    0.000000] pcpu-alloc: [0] 096 097 098 099 [0] 100 101 102 103
[    0.000000] pcpu-alloc: [0] 104 105 106 107 [0] 108 109 110 111
[    0.000000] pcpu-alloc: [0] 112 113 114 115 [0] 116 117 118 119
[    0.000000] pcpu-alloc: [0] 120 121 122 123 [0] 124 125 126 127
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1047552
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: root=UUID=3c17131a-9724-4e4f-b094-b4b5ed53e767 ro xmon=on
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 520192 bytes
[    0.000000] log_buf_len min size: 131072 bytes
[    0.000000] log_buf_len: 1048576 bytes
[    0.000000] early log buf free: 122768(93%)
[    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=128, Nodes=9
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000]  RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=128.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=128
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000000] ICS OPAL backend registered
[    0.000000] time_init: decrementer frequency = 512.000000 MHz
[    0.000000] time_init: processor frequency   = 3325.000000 MHz
[    0.000003] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
[    0.001646] clocksource: timebase mult[1f40000] shift[24] registered
[    0.002697] clockevent: decrementer mult[83126e98] shift[32] cpu[56]
[    0.002914] Console: colour dummy device 80x25
[    0.003787] console [hvc0] enabled
[    0.004446] bootconsole [udbg0] disabled
[    0.005370] pid_max: default: 131072 minimum: 1024
[    0.005617] Security Framework initialized
[    0.005810] Yama: becoming mindful.
[    0.005868] AppArmor: AppArmor initialized
[    0.006603] Dentry cache hash table entries: 8388608 (order: 10, 67108864 bytes)
[    0.043902] Inode-cache hash table entries: 4194304 (order: 9, 33554432 bytes)
[    0.062792] Mount-cache hash table entries: 131072 (order: 4, 1048576 bytes)
[    0.063093] Mountpoint-cache hash table entries: 131072 (order: 4, 1048576 bytes)
[    0.065078] ftrace: allocating 30009 entries in 11 pages
[    0.081939] EEH: PowerNV platform initialized
[    0.082176] POWER8 performance monitor hardware support registered
[    0.084229] smp: Bringing up secondary CPUs ...
[    0.210945] random: fast init done
[    0.310820] smp: Brought up 2 nodes, 128 CPUs
[    0.311085] numa: Node 0 CPUs: 64-127
[    0.311142] numa: Node 8 CPUs: 0-63
[    0.326076] devtmpfs: initialized
[    0.438859] evm: security.selinux
[    0.439098] evm: security.SMACK64
[    0.439146] evm: security.SMACK64EXEC
[    0.439193] evm: security.SMACK64TRANSMUTE
[    0.439242] evm: security.SMACK64MMAP
[    0.439289] evm: security.ima
[    0.439337] evm: security.capability
[    0.440677] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.445864] NET: Registered protocol family 16
[    0.470159] cpuidle: using governor ladder
[    0.494185] cpuidle: using governor menu
[    0.494573] pstore: using zlib compression
[    0.494778] pstore: Registered nvram as persistent store backend
[    0.632958] PCI: Probing PCI hardware
[    0.633324] PCI host bridge to bus 0004:00
[    0.633454] pci_bus 0004:00: root bus resource [mem 0x3fe000000000-0x3fe07ffeffff] (bus address [0x80000000-0xfffef
fff])
[    0.633579] pci_bus 0004:00: root bus resource [mem 0x3b0000000000-0x3b0fdfffffff 64bit pref]
[    0.633689] pci_bus 0004:00: root bus resource [bus 00-ff]
[    0.633758] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to ff
[    0.633816] pci 0004:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.634031] pci 0004:00:00.0: PME# supported from D0 D3hot D3cold
[    0.634428] pci 0004:00:00.0: PCI bridge to [bus 01]
[    0.634567] pci_bus 0004:00: busn_res: [bus 00-ff] end is updated to 01
[    0.634696] PCI host bridge to bus 0003:00
[    0.634752] pci_bus 0003:00: root bus resource [mem 0x3fe080000000-0x3fe0fffeffff] (bus address [0x80000000-0xfffef
fff])
[    0.634876] pci_bus 0003:00: root bus resource [mem 0x3b1000000000-0x3b1fdfffffff 64bit pref]
[    0.634985] pci_bus 0003:00: root bus resource [bus 00-ff]
[    0.635052] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to ff
[    0.635096] pci 0003:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.635292] pci 0003:00:00.0: PME# supported from D0 D3hot D3cold
[    0.635661] pci 0003:00:00.0: PCI bridge to [bus 01]
[    0.635786] pci_bus 0003:00: busn_res: [bus 00-ff] end is updated to 01
[    0.635953] PCI host bridge to bus 0002:00
[    0.636008] pci_bus 0002:00: root bus resource [mem 0x3fe800000000-0x3fe87ffeffff] (bus address [0x80000000-0xfffef
fff])
[    0.636134] pci_bus 0002:00: root bus resource [mem 0x3c0000000000-0x3c0fdfffffff 64bit pref]
[    0.636243] pci_bus 0002:00: root bus resource [bus 00-ff]
[    0.636310] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to ff
[    0.636352] pci 0002:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.636539] pci 0002:00:00.0: PME# supported from D0 D3hot D3cold
[    0.636901] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.637026] pci_bus 0002:00: busn_res: [bus 00-ff] end is updated to 01
[    0.637147] PCI host bridge to bus 0001:00
[    0.637202] pci_bus 0001:00: root bus resource [mem 0x3fe880000000-0x3fe8fffeffff] (bus address [0x80000000-0xfffef
fff])
[    0.637326] pci_bus 0001:00: root bus resource [mem 0x3c1000000000-0x3c1fdfffffff 64bit pref]
[    0.637435] pci_bus 0001:00: root bus resource [bus 00-ff]
[    0.637501] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to ff
[    0.637542] pci 0001:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.637728] pci 0001:00:00.0: PME# supported from D0 D3hot D3cold
[    0.638129] pci 0001:01:00.0: [10b5:8725] type 01 class 0x060400
[    0.638174] pci 0001:01:00.0: reg 0x10: [mem 0x3fe883000000-0x3fe88303ffff]
[    0.638465] pci 0001:01:00.0: PME# supported from D0 D3hot D3cold
[    0.638791] pci 0001:01:00.1: [10b5:87d0] type 00 class 0x088000
[    0.638830] pci 0001:01:00.1: reg 0x10: [mem 0x3fe883040000-0x3fe883041fff]
[    0.639302] pci 0001:01:00.2: [10b5:87d0] type 00 class 0x088000
[    0.639342] pci 0001:01:00.2: reg 0x10: [mem 0x3fe883042000-0x3fe883043fff]
[    0.639813] pci 0001:01:00.3: [10b5:87d0] type 00 class 0x088000
[    0.639853] pci 0001:01:00.3: reg 0x10: [mem 0x3fe883044000-0x3fe883045fff]
[    0.640327] pci 0001:01:00.4: [10b5:87d0] type 00 class 0x088000
[    0.640367] pci 0001:01:00.4: reg 0x10: [mem 0x3fe883046000-0x3fe883047fff]
[    0.640903] pci 0001:00:00.0: PCI bridge to [bus 01-11]
[    0.640989] pci 0001:00:00.0:   bridge window [mem 0x3fe880000000-0x3fe8837fffff]
[    0.641007] pci 0001:00:00.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.641670] pci 0001:02:01.0: [10b5:8725] type 01 class 0x060400
[    0.642001] pci 0001:02:01.0: PME# supported from D0 D3hot D3cold
[    0.642457] pci 0001:02:08.0: [10b5:8725] type 01 class 0x060400
[    0.642798] pci 0001:02:08.0: PME# supported from D0 D3hot D3cold
[    0.643265] pci 0001:02:09.0: [10b5:8725] type 01 class 0x060400
[    0.643595] pci 0001:02:09.0: PME# supported from D0 D3hot D3cold
[    0.644067] pci 0001:02:0a.0: [10b5:8725] type 01 class 0x060400
[    0.644400] pci 0001:02:0a.0: PME# supported from D0 D3hot D3cold
[    0.644704] pci 0001:02:0b.0: [10b5:8725] type 01 class 0x060400
[    0.645232] pci 0001:02:0b.0: PME# supported from D0 D3hot D3cold
[    0.645539] pci 0001:02:0c.0: [10b5:8725] type 01 class 0x060400
[    0.646108] pci 0001:02:0c.0: PME# supported from D0 D3hot D3cold
[    0.646389] pci 0001:01:00.0: PCI bridge to [bus 02-11]
[    0.646475] pci 0001:01:00.0:   bridge window [mem 0x3fe880000000-0x3fe882ffffff]
[    0.646495] pci 0001:01:00.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.650715] pci 0001:03:00.0: [14e4:168a] type 00 class 0x020000
[    0.650776] pci 0001:03:00.0: reg 0x10: [mem 0x3c1000000000-0x3c10007fffff 64bit pref]
[    0.650818] pci 0001:03:00.0: reg 0x18: [mem 0x3c1000800000-0x3c1000ffffff 64bit pref]
[    0.650860] pci 0001:03:00.0: reg 0x20: [mem 0x3c1004000000-0x3c100400ffff 64bit pref]
[    0.650888] pci 0001:03:00.0: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.651142] pci 0001:03:00.0: PME# supported from D0 D3hot D3cold
[    0.651479] pci 0001:03:00.1: [14e4:168a] type 00 class 0x020000
[    0.651540] pci 0001:03:00.1: reg 0x10: [mem 0x3c1001000000-0x3c10017fffff 64bit pref]
[    0.651582] pci 0001:03:00.1: reg 0x18: [mem 0x3c1001800000-0x3c1001ffffff 64bit pref]
[    0.651624] pci 0001:03:00.1: reg 0x20: [mem 0x3c1004010000-0x3c100401ffff 64bit pref]
[    0.651652] pci 0001:03:00.1: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.652082] pci 0001:03:00.1: PME# supported from D0 D3hot D3cold
[    0.652391] pci 0001:03:00.2: [14e4:168a] type 00 class 0x020000
[    0.652452] pci 0001:03:00.2: reg 0x10: [mem 0x3c1002000000-0x3c10027fffff 64bit pref]
[    0.652495] pci 0001:03:00.2: reg 0x18: [mem 0x3c1002800000-0x3c1002ffffff 64bit pref]
[    0.652537] pci 0001:03:00.2: reg 0x20: [mem 0x3c1004020000-0x3c100402ffff 64bit pref]
[    0.652566] pci 0001:03:00.2: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.652999] pci 0001:03:00.2: PME# supported from D0 D3hot D3cold
[    0.653306] pci 0001:03:00.3: [14e4:168a] type 00 class 0x020000
[    0.653368] pci 0001:03:00.3: reg 0x10: [mem 0x3c1003000000-0x3c10037fffff 64bit pref]
[    0.653410] pci 0001:03:00.3: reg 0x18: [mem 0x3c1003800000-0x3c1003ffffff 64bit pref]
[    0.653453] pci 0001:03:00.3: reg 0x20: [mem 0x3c1004030000-0x3c100403ffff 64bit pref]
[    0.653482] pci 0001:03:00.3: reg 0x30: [mem 0x00000000-0x0003ffff pref]
[    0.653933] pci 0001:03:00.3: PME# supported from D0 D3hot D3cold
[    0.654321] pci 0001:02:01.0: PCI bridge to [bus 03]
[    0.654407] pci 0001:02:01.0:   bridge window [mem 0x3fe880000000-0x3fe8807fffff]
[    0.654426] pci 0001:02:01.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.655003] pci 0001:02:08.0: PCI bridge to [bus 04-08]
[    0.655305] pci 0001:09:00.0: [104c:8241] type 00 class 0x0c0330
[    0.655367] pci 0001:09:00.0: reg 0x10: [mem 0x3fe880800000-0x3fe88080ffff 64bit]
[    0.655409] pci 0001:09:00.0: reg 0x18: [mem 0x3fe880810000-0x3fe880811fff 64bit]
[    0.655831] pci 0001:09:00.0: supports D1 D2
[    0.655836] pci 0001:09:00.0: PME# supported from D0 D1 D2 D3hot
[    0.656134] pci 0001:02:09.0: PCI bridge to [bus 09]
[    0.656220] pci 0001:02:09.0:   bridge window [mem 0x3fe880800000-0x3fe880ffffff]
[    0.656659] pci 0001:0a:00.0: [1b4b:9235] type 00 class 0x010601
[    0.656706] pci 0001:0a:00.0: reg 0x10: [io  0x8000-0x8007]
[    0.656734] pci 0001:0a:00.0: reg 0x14: [io  0x8040-0x8043]
[    0.656762] pci 0001:0a:00.0: reg 0x18: [io  0x8100-0x8107]
[    0.656790] pci 0001:0a:00.0: reg 0x1c: [io  0x8140-0x8143]
[    0.656817] pci 0001:0a:00.0: reg 0x20: [io  0x800000-0x80001f]
[    0.656846] pci 0001:0a:00.0: reg 0x24: [mem 0x3fe881010000-0x3fe8810107ff]
[    0.656874] pci 0001:0a:00.0: reg 0x30: [mem 0x3fe8d0000000-0x3fe8d000ffff pref]
[    0.657025] pci 0001:0a:00.0: PME# supported from D3hot
[    0.657302] pci 0001:02:0a.0: PCI bridge to [bus 0a]
[    0.657550] pci 0001:02:0a.0:   bridge window [mem 0x3fe881000000-0x3fe8817fffff]
[    0.657804] pci 0001:0b:00.0: [1a03:1150] type 01 class 0x060400
[    0.658101] pci 0001:0b:00.0: supports D1 D2
[    0.658106] pci 0001:0b:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.658524] pci 0001:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.658674] pci 0001:02:0b.0: PCI bridge to [bus 0b-0c]
[    0.658761] pci 0001:02:0b.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.658997] pci 0001:0c:00.0: [1a03:2000] type 00 class 0x030000
[    0.659054] pci 0001:0c:00.0: reg 0x10: [mem 0x3fe882000000-0x3fe882ffffff]
[    0.659084] pci 0001:0c:00.0: reg 0x14: [mem 0x3fe881800000-0x3fe88181ffff]
[    0.659113] pci 0001:0c:00.0: reg 0x18: [io  0x0000-0x007f]
[    0.659501] pci 0001:0c:00.0: supports D1 D2
[    0.659506] pci 0001:0c:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.659697] pci 0001:0b:00.0: PCI bridge to [bus 0c]
[    0.659788] pci 0001:0b:00.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.660178] pci 0001:02:0c.0: PCI bridge to [bus 0d-11]
[    0.660399] pci_bus 0001:00: busn_res: [bus 00-ff] end is updated to 11
[    0.660549] PCI host bridge to bus 0000:00
[    0.660605] pci_bus 0000:00: root bus resource [mem 0x3fe900000000-0x3fe97ffeffff] (bus address [0x80000000-0xfffef
fff])
[    0.660728] pci_bus 0000:00: root bus resource [mem 0x3c2000000000-0x3c2fdfffffff 64bit pref]
[    0.660838] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.660905] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to ff
[    0.660947] pci 0000:00:00.0: [1014:03dc] type 01 class 0x060400
[    0.661132] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.661545] pci 0000:01:00.0: [14e4:1657] type 00 class 0x020000
[    0.661605] pci 0000:01:00.0: reg 0x10: [mem 0x3c2000000000-0x3c200000ffff 64bit pref]
[    0.661647] pci 0000:01:00.0: reg 0x18: [mem 0x3c2000010000-0x3c200001ffff 64bit pref]
[    0.661688] pci 0000:01:00.0: reg 0x20: [mem 0x3c2000020000-0x3c200002ffff 64bit pref]
[    0.661715] pci 0000:01:00.0: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.661947] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.662242] pci 0000:01:00.1: [14e4:1657] type 00 class 0x020000
[    0.662302] pci 0000:01:00.1: reg 0x10: [mem 0x3c2000030000-0x3c200003ffff 64bit pref]
[    0.662344] pci 0000:01:00.1: reg 0x18: [mem 0x3c2000040000-0x3c200004ffff 64bit pref]
[    0.662384] pci 0000:01:00.1: reg 0x20: [mem 0x3c2000050000-0x3c200005ffff 64bit pref]
[    0.662412] pci 0000:01:00.1: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.662645] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    0.662922] pci 0000:01:00.2: [14e4:1657] type 00 class 0x020000
[    0.662981] pci 0000:01:00.2: reg 0x10: [mem 0x3c2000060000-0x3c200006ffff 64bit pref]
[    0.663022] pci 0000:01:00.2: reg 0x18: [mem 0x3c2000070000-0x3c200007ffff 64bit pref]
[    0.663063] pci 0000:01:00.2: reg 0x20: [mem 0x3c2000080000-0x3c200008ffff 64bit pref]
[    0.663091] pci 0000:01:00.2: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.663324] pci 0000:01:00.2: PME# supported from D0 D3hot D3cold
[    0.663596] pci 0000:01:00.3: [14e4:1657] type 00 class 0x020000
[    0.663657] pci 0000:01:00.3: reg 0x10: [mem 0x3c2000090000-0x3c200009ffff 64bit pref]
[    0.663698] pci 0000:01:00.3: reg 0x18: [mem 0x3c20000a0000-0x3c20000affff 64bit pref]
[    0.663739] pci 0000:01:00.3: reg 0x20: [mem 0x3c20000b0000-0x3c20000bffff 64bit pref]
[    0.663767] pci 0000:01:00.3: reg 0x30: [mem 0x00000000-0x0007ffff pref]
[    0.664003] pci 0000:01:00.3: PME# supported from D0 D3hot D3cold
[    0.674741] pci 0000:00:00.0: PCI bridge to [bus 01]
[    0.674988] pci 0000:00:00.0:   bridge window [mem 0x3fe900000000-0x3fe9007fffff]
[    0.675006] pci 0000:00:00.0:   bridge window [mem 0x3c2000000000-0x3c200fffffff 64bit pref]
[    0.675262] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 01
[    0.675319] pci 0004:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.676062] pci 0004:00:00.0: PCI bridge to [bus 01]
[    0.676157] pci_bus 0004:00: resource 4 [mem 0x3fe000000000-0x3fe07ffeffff]
[    0.676164] pci_bus 0004:00: resource 5 [mem 0x3b0000000000-0x3b0fdfffffff 64bit pref]
[    0.676193] pci 0003:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.676959] pci 0003:00:00.0: PCI bridge to [bus 01]
[    0.677055] pci_bus 0003:00: resource 4 [mem 0x3fe080000000-0x3fe0fffeffff]
[    0.677062] pci_bus 0003:00: resource 5 [mem 0x3b1000000000-0x3b1fdfffffff 64bit pref]
[    0.677088] pci 0002:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.677834] pci 0002:00:00.0: PCI bridge to [bus 01]
[    0.677927] pci_bus 0002:00: resource 4 [mem 0x3fe800000000-0x3fe87ffeffff]
[    0.677934] pci_bus 0002:00: resource 5 [mem 0x3c0000000000-0x3c0fdfffffff 64bit pref]
[    0.677965] pci 0001:02:01.0: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.678126] pci 0001:02:01.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.678135] pci 0001:01:00.0: bridge window [io  0x1000-0x2fff] to [bus 02-11] add_size 1000
[    0.678166] pci 0001:01:00.0: res[13]=[io  0x1000-0x2fff] res_to_dev_res add_size 1000 min_align 1000
[    0.678174] pci 0001:00:00.0: bridge window [io  0x1000-0x2fff] to [bus 01-11] add_size 1000
[    0.678189] pci 0001:00:00.0: res[13]=[io  0x1000-0x2fff] res_to_dev_res add_size 1000 min_align 1000
[    0.678196] pci 0001:00:00.0: res[13]=[io  0x1000-0x3fff] res_to_dev_res add_size 1000 min_align 1000
[    0.678208] pci 0001:00:00.0: BAR 15: assigned [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.678320] pci 0001:00:00.0: BAR 14: assigned [mem 0x3fe880000000-0x3fe8837fffff]
[    0.678577] pci 0001:00:00.0: BAR 13: no space for [io  size 0x3000]
[    0.678658] pci 0001:00:00.0: BAR 13: failed to assign [io  size 0x3000]
[    0.678747] pci 0001:00:00.0: BAR 13: no space for [io  size 0x2000]
[    0.678827] pci 0001:00:00.0: BAR 13: failed to assign [io  size 0x2000]
[    0.678918] pci 0001:01:00.0: res[13]=[io  0x1000-0x2fff] res_to_dev_res add_size 1000 min_align 1000
[    0.678924] pci 0001:01:00.0: res[13]=[io  0x1000-0x3fff] res_to_dev_res add_size 1000 min_align 1000
[    0.678932] pci 0001:01:00.0: BAR 15: assigned [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.679044] pci 0001:01:00.0: BAR 14: assigned [mem 0x3fe880000000-0x3fe882ffffff]
[    0.679139] pci 0001:01:00.0: BAR 0: assigned [mem 0x3fe883000000-0x3fe88303ffff]
[    0.679242] pci 0001:01:00.1: BAR 0: assigned [mem 0x3fe883040000-0x3fe883041fff]
[    0.679506] pci 0001:01:00.2: BAR 0: assigned [mem 0x3fe883042000-0x3fe883043fff]
[    0.679609] pci 0001:01:00.3: BAR 0: assigned [mem 0x3fe883044000-0x3fe883045fff]
[    0.679711] pci 0001:01:00.4: BAR 0: assigned [mem 0x3fe883046000-0x3fe883047fff]
[    0.679813] pci 0001:01:00.0: BAR 13: no space for [io  size 0x3000]
[    0.679893] pci 0001:01:00.0: BAR 13: failed to assign [io  size 0x3000]
[    0.679977] pci 0001:01:00.0: BAR 13: no space for [io  size 0x2000]
[    0.680056] pci 0001:01:00.0: BAR 13: failed to assign [io  size 0x2000]
[    0.680145] pci 0001:02:01.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.680152] pci 0001:02:01.0: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.680159] pci 0001:02:01.0: BAR 15: assigned [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.680468] pci 0001:02:01.0: BAR 14: assigned [mem 0x3fe880000000-0x3fe8807fffff]
[    0.680566] pci 0001:02:09.0: BAR 14: assigned [mem 0x3fe880800000-0x3fe880ffffff]
[    0.680662] pci 0001:02:0a.0: BAR 14: assigned [mem 0x3fe881000000-0x3fe8817fffff]
[    0.680759] pci 0001:02:0b.0: BAR 14: assigned [mem 0x3fe881800000-0x3fe882ffffff]
[    0.680853] pci 0001:02:01.0: BAR 13: no space for [io  size 0x1000]
[    0.680934] pci 0001:02:01.0: BAR 13: failed to assign [io  size 0x1000]
[    0.681015] pci 0001:02:0a.0: BAR 13: no space for [io  size 0x1000]
[    0.681094] pci 0001:02:0a.0: BAR 13: failed to assign [io  size 0x1000]
[    0.681175] pci 0001:02:0b.0: BAR 13: no space for [io  size 0x1000]
[    0.681254] pci 0001:02:0b.0: BAR 13: failed to assign [io  size 0x1000]
[    0.681337] pci 0001:02:0a.0: BAR 13: no space for [io  size 0x1000]
[    0.681417] pci 0001:02:0a.0: BAR 13: failed to assign [io  size 0x1000]
[    0.681497] pci 0001:02:0b.0: BAR 13: no space for [io  size 0x1000]
[    0.681576] pci 0001:02:0b.0: BAR 13: failed to assign [io  size 0x1000]
[    0.681657] pci 0001:02:01.0: BAR 13: no space for [io  size 0x1000]
[    0.681736] pci 0001:02:01.0: BAR 13: failed to assign [io  size 0x1000]
[    0.681829] pci 0001:03:00.0: BAR 0: assigned [mem 0x3c1000000000-0x3c10007fffff 64bit pref]
[    0.681964] pci 0001:03:00.0: BAR 2: assigned [mem 0x3c1000800000-0x3c1000ffffff 64bit pref]
[    0.682097] pci 0001:03:00.1: BAR 0: assigned [mem 0x3c1001000000-0x3c10017fffff 64bit pref]
[    0.682231] pci 0001:03:00.1: BAR 2: assigned [mem 0x3c1001800000-0x3c1001ffffff 64bit pref]
[    0.682365] pci 0001:03:00.2: BAR 0: assigned [mem 0x3c1002000000-0x3c10027fffff 64bit pref]
[    0.682498] pci 0001:03:00.2: BAR 2: assigned [mem 0x3c1002800000-0x3c1002ffffff 64bit pref]
[    0.691811] pci 0001:03:00.3: BAR 0: assigned [mem 0x3c1003000000-0x3c10037fffff 64bit pref]
[    0.693625] pci 0001:03:00.3: BAR 2: assigned [mem 0x3c1003800000-0x3c1003ffffff 64bit pref]
[    0.694502] pci 0001:03:00.0: BAR 6: assigned [mem 0x3fe880000000-0x3fe88003ffff pref]
[    0.696232] pci 0001:03:00.1: BAR 6: assigned [mem 0x3fe880040000-0x3fe88007ffff pref]
[    0.697166] pci 0001:03:00.2: BAR 6: assigned [mem 0x3fe880080000-0x3fe8800bffff pref]
[    0.698072] pci 0001:03:00.3: BAR 6: assigned [mem 0x3fe8800c0000-0x3fe8800fffff pref]
[    0.699844] pci 0001:03:00.0: BAR 4: assigned [mem 0x3c1004000000-0x3c100400ffff 64bit pref]
[    0.701227] pci 0001:03:00.1: BAR 4: assigned [mem 0x3c1004010000-0x3c100401ffff 64bit pref]
[    0.703000] pci 0001:03:00.2: BAR 4: assigned [mem 0x3c1004020000-0x3c100402ffff 64bit pref]
[    0.703921] pci 0001:03:00.3: BAR 4: assigned [mem 0x3c1004030000-0x3c100403ffff 64bit pref]
[    0.705708] pci 0001:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.707158] pci 0001:03     : [PE# 00] Secondary bus 3 associated with PE#0
[    0.708008] pci 0001:03     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
[    0.734257] IOMMU table initialized, virtual merging enabled
[    0.734339] pci 0001:03     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
[    0.734438] pci 0001:03     : [PE# 00] Enabling 64-bit DMA bypass
[    0.734530] iommu: Adding device 0001:03:00.0 to group 0
[    0.734832] iommu: Adding device 0001:03:00.1 to group 0
[    0.735747] iommu: Adding device 0001:03:00.2 to group 0
[    0.736780] iommu: Adding device 0001:03:00.3 to group 0
[    0.736845] pci 0001:02:01.0: PCI bridge to [bus 03]
[    0.737752] pci 0001:02:01.0:   bridge window [mem 0x3fe880000000-0x3fe8807fffff]
[    0.738790] pci 0001:02:01.0:   bridge window [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.740514] pci 0001:02:08.0: PCI bridge to [bus 04-08]
[    0.747449] pci 0001:09:00.0: BAR 0: assigned [mem 0x3fe880800000-0x3fe88080ffff 64bit]
[    0.748393] pci 0001:09:00.0: BAR 2: assigned [mem 0x3fe880810000-0x3fe880811fff 64bit]
[    0.750176] pci 0001:09     : [PE# fd] Secondary bus 9 associated with PE#fd
[    0.751764] pci 0001:09     : [PE# fd] Setting up 32-bit TCE table at 0..80000000
[    0.780941] pci 0001:09     : [PE# fd] Setting up window#0 0..7fffffff pg=1000
[    0.781040] pci 0001:09     : [PE# fd] Enabling 64-bit DMA bypass
[    0.781129] iommu: Adding device 0001:09:00.0 to group 1
[    0.781195] pci 0001:02:09.0: PCI bridge to [bus 09]
[    0.781270] pci 0001:02:09.0:   bridge window [mem 0x3fe880800000-0x3fe880ffffff]
[    0.781387] pci 0001:0a:00.0: BAR 6: assigned [mem 0x3fe881000000-0x3fe88100ffff pref]
[    0.781483] pci 0001:0a:00.0: BAR 5: assigned [mem 0x3fe881010000-0x3fe8810107ff]
[    0.781585] pci 0001:0a:00.0: BAR 4: no space for [io  size 0x0020]
[    0.781666] pci 0001:0a:00.0: BAR 4: failed to assign [io  size 0x0020]
[    0.781746] pci 0001:0a:00.0: BAR 0: no space for [io  size 0x0008]
[    0.781827] pci 0001:0a:00.0: BAR 0: failed to assign [io  size 0x0008]
[    0.781909] pci 0001:0a:00.0: BAR 2: no space for [io  size 0x0008]
[    0.781989] pci 0001:0a:00.0: BAR 2: failed to assign [io  size 0x0008]
[    0.782069] pci 0001:0a:00.0: BAR 1: no space for [io  size 0x0004]
[    0.782150] pci 0001:0a:00.0: BAR 1: failed to assign [io  size 0x0004]
[    0.782230] pci 0001:0a:00.0: BAR 3: no space for [io  size 0x0004]
[    0.782311] pci 0001:0a:00.0: BAR 3: failed to assign [io  size 0x0004]
[    0.782396] pci 0001:0a     : [PE# fc] Secondary bus 10 associated with PE#fc
[    0.798614] pci 0001:0a     : [PE# fc] Setting up 32-bit TCE table at 0..80000000
[    0.828134] pci 0001:0a     : [PE# fc] Setting up window#0 0..7fffffff pg=1000
[    0.828233] pci 0001:0a     : [PE# fc] Enabling 64-bit DMA bypass
[    0.828321] iommu: Adding device 0001:0a:00.0 to group 2
[    0.828387] pci 0001:02:0a.0: PCI bridge to [bus 0a]
[    0.828463] pci 0001:02:0a.0:   bridge window [mem 0x3fe881000000-0x3fe8817fffff]
[    0.828580] pci 0001:0b:00.0: BAR 14: assigned [mem 0x3fe881800000-0x3fe882ffffff]
[    0.828675] pci 0001:0b:00.0: BAR 13: no space for [io  size 0x1000]
[    0.828755] pci 0001:0b:00.0: BAR 13: failed to assign [io  size 0x1000]
[    0.828842] pci 0001:0c:00.0: BAR 0: assigned [mem 0x3fe882000000-0x3fe882ffffff]
[    0.828947] pci 0001:0c:00.0: BAR 1: assigned [mem 0x3fe881800000-0x3fe88181ffff]
[    0.845372] pci 0001:0c:00.0: BAR 2: no space for [io  size 0x0080]
[    0.846324] pci 0001:0c:00.0: BAR 2: failed to assign [io  size 0x0080]
[    0.847303] pci 0001:0c     : [PE# fb] Secondary bus 12..12 associated with PE#fb
[    0.848800] pci 0001:0c     : [PE# fb] Setting up 32-bit TCE table at 0..80000000
[    0.880843] pci 0001:0c     : [PE# fb] Setting up window#0 0..7fffffff pg=1000
[    0.880941] pci 0001:0c     : [PE# fb] Enabling 64-bit DMA bypass
[    0.881028] iommu: Adding device 0001:0c:00.0 to group 3
[    0.881094] pci 0001:0b:00.0: PCI bridge to [bus 0c]
[    0.881170] pci 0001:0b:00.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.881286] pci 0001:0b     : [PE# fa] Secondary bus 11 associated with PE#fa
[    0.881863] pci 0001:02:0b.0: PCI bridge to [bus 0b-0c]
[    0.881939] pci 0001:02:0b.0:   bridge window [mem 0x3fe881800000-0x3fe882ffffff]
[    0.882051] pci 0001:02:0c.0: PCI bridge to [bus 0d-11]
[    0.882157] pci 0001:02     : [PE# f9] Secondary bus 2 associated with PE#f9
[    0.882739] pci 0001:01:00.0: PCI bridge to [bus 02-11]
[    0.882816] pci 0001:01:00.0:   bridge window [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.882918] pci 0001:01:00.0:   bridge window [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.883045] pci 0001:01     : [PE# f8] Secondary bus 1 associated with PE#f8
[    0.883645] pci 0001:01     : [PE# f8] Setting up 32-bit TCE table at 0..80000000
[    0.913876] pci 0001:01     : [PE# f8] Setting up window#0 0..7fffffff pg=1000
[    0.913974] pci 0001:01     : [PE# f8] Enabling 64-bit DMA bypass
[    0.914062] iommu: Adding device 0001:01:00.0 to group 4
[    0.914134] iommu: Adding device 0001:01:00.1 to group 4
[    0.914206] iommu: Adding device 0001:01:00.2 to group 4
[    0.914284] iommu: Adding device 0001:01:00.3 to group 4
[    0.914356] iommu: Adding device 0001:01:00.4 to group 4
[    0.914421] pci 0001:00:00.0: PCI bridge to [bus 01-11]
[    0.914498] pci 0001:00:00.0:   bridge window [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.914599] pci 0001:00:00.0:   bridge window [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.914720] pci_bus 0001:00: Some PCI device resources are unassigned, try booting with pci=realloc
[    0.914833] pci_bus 0001:00: resource 4 [mem 0x3fe880000000-0x3fe8fffeffff]
[    0.914840] pci_bus 0001:00: resource 5 [mem 0x3c1000000000-0x3c1fdfffffff 64bit pref]
[    0.914846] pci_bus 0001:01: resource 1 [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.914852] pci_bus 0001:01: resource 2 [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.914859] pci_bus 0001:02: resource 1 [mem 0x3fe880000000-0x3fe8ffefffff]
[    0.914865] pci_bus 0001:02: resource 2 [mem 0x3c1000000000-0x3c1fdff0ffff 64bit pref]
[    0.914871] pci_bus 0001:03: resource 1 [mem 0x3fe880000000-0x3fe8807fffff]
[    0.914878] pci_bus 0001:03: resource 2 [mem 0x3c1000000000-0x3c100fffffff 64bit pref]
[    0.914886] pci_bus 0001:09: resource 1 [mem 0x3fe880800000-0x3fe880ffffff]
[    0.914893] pci_bus 0001:0a: resource 1 [mem 0x3fe881000000-0x3fe8817fffff]
[    0.914899] pci_bus 0001:0b: resource 1 [mem 0x3fe881800000-0x3fe882ffffff]
[    0.914906] pci_bus 0001:0c: resource 1 [mem 0x3fe881800000-0x3fe882ffffff]
[    0.914963] pci 0000:00:00.0: BAR 15: assigned [mem 0x3c2000000000-0x3c200fffffff 64bit pref]
[    0.915074] pci 0000:00:00.0: BAR 14: assigned [mem 0x3fe900000000-0x3fe9007fffff]
[    0.915181] pci 0000:01:00.0: BAR 6: assigned [mem 0x3fe900000000-0x3fe90007ffff pref]
[    0.915278] pci 0000:01:00.1: BAR 6: assigned [mem 0x3fe900080000-0x3fe9000fffff pref]
[    0.915373] pci 0000:01:00.2: BAR 6: assigned [mem 0x3fe900100000-0x3fe90017ffff pref]
[    0.915469] pci 0000:01:00.3: BAR 6: assigned [mem 0x3fe900180000-0x3fe9001fffff pref]
[    0.939923] pci 0000:01:00.0: BAR 0: assigned [mem 0x3c2000000000-0x3c200000ffff 64bit pref]
[    0.941321] pci 0000:01:00.0: BAR 2: assigned [mem 0x3c2000010000-0x3c200001ffff 64bit pref]
[    0.943132] pci 0000:01:00.0: BAR 4: assigned [mem 0x3c2000020000-0x3c200002ffff 64bit pref]
[    0.944070] pci 0000:01:00.1: BAR 0: assigned [mem 0x3c2000030000-0x3c200003ffff 64bit pref]
[    0.945852] pci 0000:01:00.1: BAR 2: assigned [mem 0x3c2000040000-0x3c200004ffff 64bit pref]
[    0.946784] pci 0000:01:00.1: BAR 4: assigned [mem 0x3c2000050000-0x3c200005ffff 64bit pref]
[    0.947695] pci 0000:01:00.2: BAR 0: assigned [mem 0x3c2000060000-0x3c200006ffff 64bit pref]
[    0.949443] pci 0000:01:00.2: BAR 2: assigned [mem 0x3c2000070000-0x3c200007ffff 64bit pref]
[    0.950352] pci 0000:01:00.2: BAR 4: assigned [mem 0x3c2000080000-0x3c200008ffff 64bit pref]
[    0.952841] pci 0000:01:00.3: BAR 0: assigned [mem 0x3c2000090000-0x3c200009ffff 64bit pref]
[    0.953780] pci 0000:01:00.3: BAR 2: assigned [mem 0x3c20000a0000-0x3c20000affff 64bit pref]
[    0.955584] pci 0000:01:00.3: BAR 4: assigned [mem 0x3c20000b0000-0x3c20000bffff 64bit pref]
[    0.956476] pci 0000:00     : [PE# fe] Secondary bus 0 associated with PE#fe
[    0.957901] pci 0000:01     : [PE# 00] Secondary bus 1 associated with PE#0
[    0.959626] pci 0000:01     : [PE# 00] Setting up 32-bit TCE table at 0..80000000
[    0.992467] pci 0000:01     : [PE# 00] Setting up window#0 0..7fffffff pg=1000
[    0.992566] pci 0000:01     : [PE# 00] Enabling 64-bit DMA bypass
[    0.992654] iommu: Adding device 0000:01:00.0 to group 5
[    0.992727] iommu: Adding device 0000:01:00.1 to group 5
[    0.992799] iommu: Adding device 0000:01:00.2 to group 5
[    0.992871] iommu: Adding device 0000:01:00.3 to group 5
[    0.992936] pci 0000:00:00.0: PCI bridge to [bus 01]
[    0.993012] pci 0000:00:00.0:   bridge window [mem 0x3fe900000000-0x3fe97fefffff]
[    0.993114] pci 0000:00:00.0:   bridge window [mem 0x3c2000000000-0x3c2fdff0ffff 64bit pref]
[    0.993236] pci_bus 0000:00: resource 4 [mem 0x3fe900000000-0x3fe97ffeffff]
[    0.993243] pci_bus 0000:00: resource 5 [mem 0x3c2000000000-0x3c2fdfffffff 64bit pref]
[    0.993249] pci_bus 0000:01: resource 1 [mem 0x3fe900000000-0x3fe97fefffff]
[    0.993255] pci_bus 0000:01: resource 2 [mem 0x3c2000000000-0x3c2fdff0ffff 64bit pref]
[    0.995603] EEH: PCI Enhanced I/O Error Handling Enabled
[    0.996067] PCI: Probing PCI hardware done
[    1.000480] powernv-rng: Registering arch random hook.
[    1.019119] HugeTLB registered 1 MB page size, pre-allocated 0 pages
[    1.019315] HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    1.019365] HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    1.022462] pci 0001:0c:00.0: vgaarb: VGA device added: decodes=io+mem,owns=none,locks=none
[    1.022666] pci 0001:0c:00.0: vgaarb: bridge control possible
[    1.022716] vgaarb: loaded
[    1.022987] SCSI subsystem initialized
[    1.023234] libata version 3.00 loaded.
[    1.023267] usbcore: registered new interface driver usbfs
[    1.023316] usbcore: registered new interface driver hub
[    1.023609] usbcore: registered new device driver usb
[    1.023670] pps_core: LinuxPPS API ver. 1 registered
[    1.023711] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti-k2GhghHVRtY@public.gmane.org>
[    1.023782] PTP clock support registered
[    1.024325] NetLabel: Initializing
[    1.024438] NetLabel:  domain hash size = 128
[    1.024477] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    1.024545] NetLabel:  unlabeled traffic allowed by default
[    1.025277] clocksource: Switched to clocksource timebase
[    1.035526] VFS: Disk quotas dquot_6.6.0
[    1.035622] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    1.035815] AppArmor: AppArmor Filesystem Enabled
[    1.037527] NET: Registered protocol family 2
[    1.037999] TCP established hash table entries: 524288 (order: 6, 4194304 bytes)
[    1.038989] TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
[    1.039259] TCP: Hash tables configured (established 524288 bind 65536)
[    1.039406] UDP hash table entries: 32768 (order: 4, 1048576 bytes)
[    1.039812] UDP-Lite hash table entries: 32768 (order: 4, 1048576 bytes)
[    1.041535] NET: Registered protocol family 1
[    1.041862] PCI: CLS 0 bytes, default 128
[    1.042051] Trying to unpack rootfs image as initramfs...
[    1.601004] Freeing initrd memory: 38528K
[    1.601506] random: crng init done
[    1.626965] futex hash table entries: 32768 (order: 6, 4194304 bytes)
[    1.627673] audit: initializing netlink subsys (disabled)
[    1.627887] audit: type=2000 audit(1486124903.544:1): initialized
[    1.628032] Initialise system trusted keyrings
[    1.628489] workingset: timestamp_bits=38 max_order=20 bucket_order=0
[    1.630177] zbud: loaded
[    1.631033] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.631235] fuse init (API version 7.26)
[    1.632046] Key type asymmetric registered
[    1.632078] Asymmetric key parser 'x509' registered
[    1.632129] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 246)
[    1.632384] io scheduler noop registered
[    1.632415] io scheduler deadline registered (default)
[    1.632462] io scheduler cfq registered
[    1.635257] hvc0: raw protocol on /ibm,opal/consoles/serial@0 (boot console)
[    1.635321] hvc0: No interrupts property, using OPAL event
[    1.635589] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.636814] Linux agpgart interface v0.103
[    1.642792] brd: module loaded
[    1.648409] loop: module loaded
[    1.648756] libphy: Fixed MDIO Bus: probed
[    1.648787] tun: Universal TUN/TAP device driver, 1.6
[    1.648828] tun: (C) 1999-2004 Max Krasnyansky <maxk-zC7DfRvBq/JWk0Htik3J/w@public.gmane.org>
[    1.648927] tg3.c:v3.137 (May 11, 2014)
[    1.684898] tg3 0000:01:00.0: Using 64-bit DMA iommu bypass
[    1.685133] tg3 0000:01:00.0 eth0: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:dc
[    1.685217] tg3 0000:01:00.0 eth0: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.685297] tg3 0000:01:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.685357] tg3 0000:01:00.0 eth0: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.723985] tg3 0000:01:00.1: Using 64-bit DMA iommu bypass
[    1.724183] tg3 0000:01:00.1 eth1: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:dd
[    1.724264] tg3 0000:01:00.1 eth1: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.724344] tg3 0000:01:00.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.724404] tg3 0000:01:00.1 eth1: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.757926] tg3 0000:01:00.2: Using 64-bit DMA iommu bypass
[    1.758265] tg3 0000:01:00.2 eth2: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:de
[    1.758515] tg3 0000:01:00.2 eth2: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.758594] tg3 0000:01:00.2 eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.758654] tg3 0000:01:00.2 eth2: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.793927] tg3 0000:01:00.3: Using 64-bit DMA iommu bypass
[    1.794269] tg3 0000:01:00.3 eth3: Tigon3 [partno(00E1681) rev 5719001] (PCI Express) MAC address 6c:ae:8b:01:24:df
[    1.794377] tg3 0000:01:00.3 eth3: attached PHY is 5719C (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[1])
[    1.794456] tg3 0000:01:00.3 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.794516] tg3 0000:01:00.3 eth3: dma_rwctrl[00000000] dma_mask[64-bit]
[    1.794624] PPP generic driver version 2.4.2
[    1.794716] VFIO - User Level meta-driver version: 0.3
[    1.795342] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.795401] ehci-pci: EHCI PCI platform driver
[    1.795451] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.795502] ohci-pci: OHCI PCI platform driver
[    1.795552] uhci_hcd: USB Universal Host Controller Interface driver
[    1.795651] xhci_hcd 0001:09:00.0: xHCI Host Controller
[    1.795696] xhci_hcd 0001:09:00.0: new USB bus registered, assigned bus number 1
[    1.795838] xhci_hcd 0001:09:00.0: Using 64-bit DMA iommu bypass
[    1.795947] xhci_hcd 0001:09:00.0: hcc params 0x0270f06d hci version 0x96 quirks 0x00000000
[    1.796237] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.796288] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.796348] usb usb1: Product: xHCI Host Controller
[    1.796389] usb usb1: Manufacturer: Linux 4.10.0-rc6-gpiccoli+ xhci-hcd
[    1.796440] usb usb1: SerialNumber: 0001:09:00.0
[    1.796575] hub 1-0:1.0: USB hub found
[    1.796614] hub 1-0:1.0: 4 ports detected
[    1.796772] xhci_hcd 0001:09:00.0: xHCI Host Controller
[    1.796815] xhci_hcd 0001:09:00.0: new USB bus registered, assigned bus number 2
[    1.796892] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
[    1.796971] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.797022] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.797082] usb usb2: Product: xHCI Host Controller
[    1.797123] usb usb2: Manufacturer: Linux 4.10.0-rc6-gpiccoli+ xhci-hcd
[    1.797176] usb usb2: SerialNumber: 0001:09:00.0
[    1.797298] hub 2-0:1.0: USB hub found
[    1.797336] hub 2-0:1.0: 4 ports detected
[    1.797718] mousedev: PS/2 mouse device common for all mice
[    1.817175] rtc-opal opal-rtc: rtc core: registered rtc-opal as rtc0
[    1.817369] i2c /dev entries driver
[    1.818378] device-mapper: uevent: version 1.0.3
[    1.818480] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[    1.818556] powernv-cpufreq: cpufreq pstate min -54 nominal -16 max 0
[    1.822178] powernv_idle_driver registered
[    1.823569] ledtrig-cpu: registered to indicate activity on CPUs
[    1.824165] NET: Registered protocol family 10
[    1.825262] Segment Routing with IPv6
[    1.825321] NET: Registered protocol family 17
[    1.825385] Key type dns_resolver registered
[    1.825628] registered taskstats version 1
[    1.825660] Loading compiled-in X.509 certificates
[    1.828090] Loaded X.509 cert 'Build time autogenerated kernel key: 411ec76c048a1d66c98e183c1c880bd495b62112'
[    1.828282] zswap: loaded using pool lzo/zbud
[    1.830091] Key type trusted registered
[    1.833518] Key type encrypted registered
[    1.833551] AppArmor: AppArmor sha1 policy hashing enabled
[    1.833592] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
[    1.833654] evm: HMAC attrs: 0x1
[    1.853225] rtc-opal opal-rtc: setting system clock to 2017-02-03 12:28:24 UTC (1486124904)
[    1.853845] Freeing unused kernel memory: 4480K
[    1.853891] This architecture does not have kernel memory protection.
[    1.916862] tg3 0000:01:00.0 enp1s0f0: renamed from eth0
[    1.926475] ahci 0001:0a:00.0: version 3.0
[    1.926583] ahci 0001:0a:00.0: Using 64-bit DMA iommu bypass
[    1.935664] [drm] Initialized
[    1.936865] ahci 0001:0a:00.0: AHCI 0001.0000 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    1.936994] bnx2x: QLogic 5771x/578xx 10/20-Gigabit Ethernet Driver bnx2x 1.712.30-0 (2014/02/10)
[    1.937076] bnx2x 0001:03:00.0: msix capability found
[    1.937326] ahci 0001:0a:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs
[    1.937812] scsi host0: ahci
[    1.937957] scsi host1: ahci
[    1.938065] scsi host2: ahci
[    1.938179] scsi host3: ahci
[    1.938310] ata1: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010100 irq 392
[    1.938367] ata2: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010180 irq 392
[    1.938425] ata3: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010200 irq 392
[    1.938482] ata4: SATA max UDMA/133 abar m2048@0x3fe881010000 port 0x3fe881010280 irq 392
[    1.950764] [drm] platform has no IO space, trying MMIO
[    1.950895] [drm] AST 2400 detected
[    1.951003] [drm] Analog VGA only
[    1.951041] [drm] dram 1632000000 7 16 00c00000
[    1.951117] [TTM] Zone  kernel: Available graphics memory: 33417120 kiB
[    1.951166] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.951212] [TTM] Initializing pool allocator
[    1.951252] [TTM] Initializing DMA pool allocator
[    1.959659] bnx2x 0001:03:00.0: Using 64-bit DMA iommu bypass
[    1.961044] bnx2x 0001:03:00.0: part number 0-0-0-0
[    2.075475] Console: switching to colour frame buffer device 128x48
[    2.082651] tg3 0000:01:00.1 enp1s0f1: renamed from eth1
[    2.083110] bnx2x 0001:03:00.1: msix capability found
[    2.102144] bnx2x 0001:03:00.1: Using 64-bit DMA iommu bypass
[    2.102402] bnx2x 0001:03:00.1: part number 0-0-0-0
[    2.121146] usb 1-3: new high-speed USB device number 2 using xhci_hcd
[    2.154259] ast 0001:0c:00.0: fb0: astdrmfb frame buffer device
[    2.185147] [drm] Initialized ast 0.1.0 20120228 for 0001:0c:00.0 on minor 0
[    2.185252] tg3 0000:01:00.2 enp1s0f2: renamed from eth2
[    2.205240] tg3 0000:01:00.3 enp1s0f3: renamed from eth3
[    2.242577] bnx2x 0001:03:00.2: msix capability found
[    2.251287] ata3: SATA link down (SStatus 0 SControl 300)
[    2.251351] ata4: SATA link down (SStatus 0 SControl 300)
[    2.251411] ata2: SATA link down (SStatus 0 SControl 300)
[    2.261217] bnx2x 0001:03:00.2: Using 64-bit DMA iommu bypass
[    2.261302] bnx2x 0001:03:00.2: part number 0-0-0-0
[    2.304540] usb 1-3: New USB device found, idVendor=046b, idProduct=ff01
[    2.304623] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.304778] usb 1-3: Product: Virtual Hub
[    2.304807] usb 1-3: Manufacturer: American Megatrends Inc.
[    2.304844] usb 1-3: SerialNumber: serial
[    2.309798] hub 1-3:1.0: USB hub found
[    2.310161] hub 1-3:1.0: 5 ports detected
[    2.326297] bnx2x 0001:03:00.3: msix capability found
[    2.349213] bnx2x 0001:03:00.3: Using 64-bit DMA iommu bypass
[    2.349437] bnx2x 0001:03:00.3: part number 0-0-0-0
[    2.413156] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.414274] ata1.00: ATA-10: ST1000NX0313         00NA562 00NA565LEN, BE30, max UDMA/133
[    2.414468] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.415301] ata1.00: configured for UDMA/133
[    2.415707] bnx2x 0001:03:00.0 enP1p3s0f0: renamed from eth0
[    2.415758] scsi 0:0:0:0: Direct-Access     ATA      ST1000NX0313     BE30 PQ: 0 ANSI: 5
[    2.433459] bnx2x 0001:03:00.3 enP1p3s0f3: renamed from eth3
[    2.509371] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.509438] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
[    2.509441] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.509466] sd 0:0:0:0: [sda] Write Protect is off
[    2.509468] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.509501] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.529314] bnx2x 0001:03:00.2 enP1p3s0f2: renamed from eth2
[    2.553894]  sda: sda1 sda2 sda3
[    2.554356] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    2.585283] bnx2x 0001:03:00.1 enP1p3s0f1: renamed from eth1
[    2.621152] usb 1-3.1: new high-speed USB device number 3 using xhci_hcd
[    2.744682] usb 1-3.1: New USB device found, idVendor=046b, idProduct=ff20
[    2.744866] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.744922] usb 1-3.1: Product: Virtual Cdrom Device
[    2.745111] usb 1-3.1: Manufacturer: American Megatrends Inc.
[    2.745161] usb 1-3.1: SerialNumber: AAAABBBBCCCC1
[    2.748967] usb-storage 1-3.1:1.0: USB Mass Storage device detected
[    2.749122] scsi host4: usb-storage 1-3.1:1.0
[    2.749251] usbcore: registered new interface driver usb-storage
[    2.750425] usbcore: registered new interface driver uas
[    2.849145] usb 1-3.2: new high-speed USB device number 4 using xhci_hcd
[    2.972737] usb 1-3.2: New USB device found, idVendor=046b, idProduct=ff40
[    2.972739] usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.972739] usb 1-3.2: Product: Virtual Floppy Device
[    2.972740] usb 1-3.2: Manufacturer: American Megatrends Inc.
[    2.972741] usb 1-3.2: SerialNumber: AAAABBBBCCCC2
[    2.973715] usb-storage 1-3.2:1.0: USB Mass Storage device detected
[    2.973767] usb-storage 1-3.2:1.0: Quirks match for vid 046b pid ff40: 200
[    2.973787] scsi host5: usb-storage 1-3.2:1.0
[    3.077157] usb 1-3.3: new high-speed USB device number 5 using xhci_hcd
[    3.200702] usb 1-3.3: New USB device found, idVendor=046b, idProduct=ff31
[    3.200901] usb 1-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.200966] usb 1-3.3: Product: Virtual HardDisk Device
[    3.201128] usb 1-3.3: Manufacturer: American Megatrends Inc.
[    3.201176] usb 1-3.3: SerialNumber: AAAABBBBCCCC3
[    3.202329] usb-storage 1-3.3:1.0: USB Mass Storage device detected
[    3.202460] scsi host6: usb-storage 1-3.3:1.0
[    3.301144] usb 1-3.4: new low-speed USB device number 6 using xhci_hcd
[    3.444213] usb 1-3.4: New USB device found, idVendor=046b, idProduct=ff10
[    3.444397] usb 1-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.444453] usb 1-3.4: Product: Virtual Keyboard and Mouse
[    3.444614] usb 1-3.4: Manufacturer: American Megatrends Inc.
[    3.471363] hidraw: raw HID events driver (C) Jiri Kosina
[    3.484651] usbcore: registered new interface driver usbhid
[    3.484828] usbhid: USB HID core driver
[    3.758870] scsi 4:0:0:0: CD-ROM            AMI      Virtual CDROM0   1.00 PQ: 0 ANSI: 0 CCS
[    3.760859] scsi 4:0:0:1: CD-ROM            AMI      Virtual CDROM1   1.00 PQ: 0 ANSI: 0 CCS
[    3.762110] scsi 4:0:0:2: CD-ROM            AMI      Virtual CDROM2   1.00 PQ: 0 ANSI: 0 CCS
[    3.763235] scsi 4:0:0:3: CD-ROM            AMI      Virtual CDROM3   1.00 PQ: 0 ANSI: 0 CCS
[    3.767358] sr 4:0:0:0: [sr0] scsi-1 drive
[    3.767449] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.767685] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    3.767767] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    3.783608] sr 4:0:0:1: [sr1] scsi-1 drive
[    3.783745] sr 4:0:0:1: Attached scsi CD-ROM sr1
[    3.783815] sr 4:0:0:1: Attached scsi generic sg2 type 5
[    3.792607] sr 4:0:0:2: [sr2] scsi-1 drive
[    3.792745] sr 4:0:0:2: Attached scsi CD-ROM sr2
[    3.792818] sr 4:0:0:2: Attached scsi generic sg3 type 5
[    3.802362] sr 4:0:0:3: [sr3] scsi-1 drive
[    3.802494] sr 4:0:0:3: Attached scsi CD-ROM sr3
[    3.802553] sr 4:0:0:3: Attached scsi generic sg4 type 5
[    3.982077] scsi 5:0:0:0: Direct-Access     AMI      Virtual Floppy0  1.00 PQ: 0 ANSI: 0 CCS
[    3.984470] scsi 5:0:0:1: Direct-Access     AMI      Virtual Floppy1  1.00 PQ: 0 ANSI: 0 CCS
[    3.988641] scsi 5:0:0:2: Direct-Access     AMI      Virtual Floppy2  1.00 PQ: 0 ANSI: 0 CCS
[    3.992308] scsi 5:0:0:3: Direct-Access     AMI      Virtual Floppy3  1.00 PQ: 0 ANSI: 0 CCS
[    3.993242] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    3.993716] sd 5:0:0:1: Attached scsi generic sg6 type 0
[    3.994004] sd 5:0:0:2: Attached scsi generic sg7 type 0
[    3.994406] sd 5:0:0:3: Attached scsi generic sg8 type 0
[    3.996805] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[    3.998310] sd 5:0:0:2: [sdd] Attached SCSI removable disk
[    3.998950] sd 5:0:0:3: [sde] Attached SCSI removable disk
[    4.025618] sd 5:0:0:1: [sdc] Attached SCSI removable disk
[    4.206759] scsi 6:0:0:0: Direct-Access     AMI      Virtual HDisk0   1.00 PQ: 0 ANSI: 0 CCS
[    4.211005] scsi 6:0:0:1: Direct-Access     AMI      Virtual HDisk1   1.00 PQ: 0 ANSI: 0 CCS
[    4.213256] scsi 6:0:0:2: Direct-Access     AMI      Virtual HDisk2   1.00 PQ: 0 ANSI: 0 CCS
[    4.215380] scsi 6:0:0:3: Direct-Access     AMI      Virtual HDisk3   1.00 PQ: 0 ANSI: 0 CCS
[    4.217390] scsi 6:0:0:4: Direct-Access     AMI      Virtual HDisk4   1.00 PQ: 0 ANSI: 0 CCS
[    4.218176] sd 6:0:0:0: Attached scsi generic sg9 type 0
[    4.218569] sd 6:0:0:1: Attached scsi generic sg10 type 0
[    4.218870] sd 6:0:0:2: Attached scsi generic sg11 type 0
[    4.219162] sd 6:0:0:3: Attached scsi generic sg12 type 0
[    4.219470] sd 6:0:0:4: Attached scsi generic sg13 type 0
[    4.228877] sd 6:0:0:0: [sdf] Attached SCSI removable disk
[    4.230128] sd 6:0:0:1: [sdg] Attached SCSI removable disk
[    4.231380] sd 6:0:0:2: [sdh] Attached SCSI removable disk
[    4.234379] sd 6:0:0:3: [sdi] Attached SCSI removable disk
[    4.290630] sd 6:0:0:4: [sdj] Attached SCSI removable disk
[    4.890935] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    5.545854] systemd[1]: Detected architecture ppc64-le.
[    5.576259] systemd[1]: Set hostname to <fs28>.
[    6.281460] systemd[1]: Listening on fsck to fsckd communication Socket.
[    6.282046] systemd[1]: Created slice User and Session Slice.
[    6.282251] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    6.282595] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    6.282991] systemd[1]: Listening on Journal Socket.
[    6.283158] systemd[1]: Listening on multipathd control socket.
[    6.283351] systemd[1]: Listening on Syslog Socket.
[    6.816047] lp: driver loaded but no devices found
[    6.822982] ppdev: user-space parallel port driver
[    6.923229] Loading iSCSI transport class v2.0-870.
[    6.993651] iscsi: registered transport (tcp)
[    7.148556] iscsi: registered transport (iser)
[    7.747100] EXT4-fs (sda2): re-mounted. Opts: errors=remount-ro
[    7.798555] systemd-journald[1463]: Received request to flush runtime journal from PID 1
[    8.236057] powernv_rng: Registered powernv hwrng.
[    8.244081] crypto_register_alg 'aes' = 0
[    8.245138] crypto_register_alg 'cbc(aes)' = 0
[    8.247830] crypto_register_alg 'ctr(aes)' = 0
[    8.247969] crypto_register_alg 'xts(aes)' = 0
[    8.251140] ipmi message handler version 39.2
[    8.291904] ipmi device interface
[    8.663329] ipmi-powernv ibm,opal:ipmi: Unable to map irq from device tree
[    8.677232] ipmi-powernv ibm,opal:ipmi: Found new BMC (man_id: 0x000000, prod_id: 0x0000, dev_id: 0x00)
[    8.937620] at24 0-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.938011] at24 0-0052: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    8.938386] at24 0-0053: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    8.938763] at24 0-0054: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    8.939137] at24 0-0055: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    8.939235] at24 1-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939331] at24 1-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939429] at24 2-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939523] at24 2-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939623] at24 3-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939722] at24 3-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939825] at24 4-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.939922] at24 4-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    8.940091] at24 5-0050: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    9.506728] at24 6-0051: 16384 byte 24c128 EEPROM, writable, 1 bytes/write
[    9.507220] at24 6-0052: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    9.507620] at24 6-0053: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    9.508018] at24 6-0054: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    9.508442] at24 6-0055: 256 byte 24c02 EEPROM, writable, 1 bytes/write
[    9.885878] IPv6: ADDRCONF(NETDEV_UP): enp1s0f0: link is not ready
[   10.757669] Adding 39519168k swap on /dev/sda3.  Priority:-1 extents:1 across:39519168k FS
[   11.026367] cgroup: new mount options do not match the existing superblock, will be ignored
[   12.810498] tg3 0000:01:00.0 enp1s0f0: Link is up at 1000 Mbps, full duplex
[   12.810500] tg3 0000:01:00.0 enp1s0f0: Flow control is off for TX and off for RX
[   12.810501] tg3 0000:01:00.0 enp1s0f0: EEE is disabled
[   12.810517] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f0: link becomes ready
[   13.846964] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f0: link is not ready
[   14.485908] bnx2x 0001:03:00.0 enP1p3s0f0: using MSI-X  IRQs: sp 393  fp[0] 395 ... fp[7] 402
[   14.685160] bnx2x 0001:03:00.0 enP1p3s0f0: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & tra
nsmit
[   14.691315] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f1: link is not ready
[   15.217834] bnx2x 0001:03:00.1 enP1p3s0f1: using MSI-X  IRQs: sp 403  fp[0] 405 ... fp[7] 412
[   15.421154] bnx2x 0001:03:00.1 enP1p3s0f1: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & tra
nsmit
[   15.428415] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f2: link is not ready
[   15.585904] bnx2x 0001:03:00.2 enP1p3s0f2: using MSI-X  IRQs: sp 413  fp[0] 415 ... fp[7] 422
[   15.851377] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f2: link is not ready
[   15.856945] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f3: link is not ready
[   16.013844] bnx2x 0001:03:00.3 enP1p3s0f3: using MSI-X  IRQs: sp 423  fp[0] 425 ... fp[7] 432
[   16.275373] IPv6: ADDRCONF(NETDEV_UP): enP1p3s0f3: link is not ready
[   16.278903] IPv6: ADDRCONF(NETDEV_UP): enp1s0f1: link is not ready
[   16.347287] IPv6: ADDRCONF(NETDEV_UP): enp1s0f1: link is not ready
[   16.350359] IPv6: ADDRCONF(NETDEV_UP): enp1s0f2: link is not ready
[   16.420989] IPv6: ADDRCONF(NETDEV_UP): enp1s0f2: link is not ready
[   16.424026] IPv6: ADDRCONF(NETDEV_UP): enp1s0f3: link is not ready
[   16.494597] IPv6: ADDRCONF(NETDEV_UP): enp1s0f3: link is not ready
[   19.994548] tg3 0000:01:00.1 enp1s0f1: Link is up at 1000 Mbps, full duplex
[   19.994557] tg3 0000:01:00.1 enp1s0f1: Flow control is off for TX and off for RX
[   19.994559] tg3 0000:01:00.1 enp1s0f1: EEE is disabled
[   19.994588] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0f1: link becomes ready
[   26.950451] ip_tables: (C) 2000-2006 Netfilter Core Team
[   27.084957] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   27.201998] Ebtables v2.0 registered
[   27.961178] virbr0: port 1(virbr0-nic) entered blocking state
[   27.961181] virbr0: port 1(virbr0-nic) entered disabled state
[   27.961395] device virbr0-nic entered promiscuous mode
[   28.602987] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   28.859279] virbr0: port 1(virbr0-nic) entered blocking state
[   28.859284] virbr0: port 1(virbr0-nic) entered listening state
[   29.302037] bnx2x 0001:03:00.0 enP1p3s0f0: using MSI-X  IRQs: sp 393  fp[0] 395 ... fp[7] 402
[   29.381448] bnx2x 0001:03:00.0 enP1p3s0f0: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & tra
nsmit
[   29.881930] bnx2x 0001:03:00.1 enP1p3s0f1: using MSI-X  IRQs: sp 403  fp[0] 405 ... fp[7] 412
[   29.961365] bnx2x 0001:03:00.1 enP1p3s0f1: NIC Link is Up, 10000 Mbps full duplex, Flow control: ON - receive & tra
nsmit
[   30.457817] bnx2x 0001:03:00.2 enP1p3s0f2: using MSI-X  IRQs: sp 413  fp[0] 415 ... fp[7] 422
[   31.021161] virbr0: port 1(virbr0-nic) entered learning state
[   31.165826] bnx2x 0001:03:00.3 enP1p3s0f3: using MSI-X  IRQs: sp 423  fp[0] 425 ... fp[7] 432
[   31.566926] virbr0: port 1(virbr0-nic) entered disabled state
[   31.573215] device virbr0-nic left promiscuous mode
[   31.573264] virbr0: port 1(virbr0-nic) entered disabled state
[  299.005566] scsi host7: iSCSI Initiator over TCP/IP
[  299.276964] scsi 7:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.328216] sd 7:0:0:0: Attached scsi generic sg14 type 0
[  299.331331] scsi 7:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.331396] sd 7:0:0:0: [sdk] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.331397] sd 7:0:0:0: [sdk] 4096-byte physical blocks
[  299.332374] sd 7:0:0:0: [sdk] Write Protect is off
[  299.332376] sd 7:0:0:0: [sdk] Mode Sense: a7 00 00 08
[  299.333443] sd 7:0:0:0: [sdk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.338428] sd 7:0:0:0: [sdk] Attached SCSI disk
[  299.388294] sd 7:0:0:1: Attached scsi generic sg15 type 0
[  299.388647] sd 7:0:0:1: [sdl] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.388649] sd 7:0:0:1: [sdl] 4096-byte physical blocks
[  299.388768] sd 7:0:0:1: [sdl] Write Protect is off
[  299.388770] sd 7:0:0:1: [sdl] Mode Sense: a7 00 00 08
[  299.388903] sd 7:0:0:1: [sdl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.388960] scsi 7:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.390936] sd 7:0:0:1: [sdl] Attached SCSI disk
[  299.452157] sd 7:0:0:2: Attached scsi generic sg16 type 0
[  299.452530] sd 7:0:0:2: [sdm] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.452532] sd 7:0:0:2: [sdm] 4096-byte physical blocks
[  299.452649] sd 7:0:0:2: [sdm] Write Protect is off
[  299.452651] sd 7:0:0:2: [sdm] Mode Sense: a7 00 00 08
[  299.452776] sd 7:0:0:2: [sdm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.452844] scsi 7:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.454812] sd 7:0:0:2: [sdm] Attached SCSI disk
[  299.460546] device-mapper: multipath queue-length: version 0.2.0 loaded
[  299.460721] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.470863] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.538764] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.540191] sd 7:0:0:3: Attached scsi generic sg17 type 0
[  299.540712] scsi 7:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.540752] sd 7:0:0:3: [sdn] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.540757] sd 7:0:0:3: [sdn] 4096-byte physical blocks
[  299.540887] sd 7:0:0:3: [sdn] Write Protect is off
[  299.540890] sd 7:0:0:3: [sdn] Mode Sense: a7 00 00 08
[  299.541044] sd 7:0:0:3: [sdn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.543239] sd 7:0:0:3: [sdn] Attached SCSI disk
[  299.608244] sd 7:0:0:4: Attached scsi generic sg18 type 0
[  299.608736] sd 7:0:0:4: [sdo] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.608739] sd 7:0:0:4: [sdo] 4096-byte physical blocks
[  299.608873] sd 7:0:0:4: [sdo] Write Protect is off
[  299.608874] sd 7:0:0:4: [sdo] Mode Sense: a7 00 00 08
[  299.609000] scsi 7:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.609064] sd 7:0:0:4: [sdo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.611529] sd 7:0:0:4: [sdo] Attached SCSI disk
[  299.637197] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.690892] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.704474] sd 7:0:0:5: Attached scsi generic sg19 type 0
[  299.704712] sd 7:0:0:5: [sdp] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.704720] sd 7:0:0:5: [sdp] 4096-byte physical blocks
[  299.704855] sd 7:0:0:5: [sdp] Write Protect is off
[  299.704857] sd 7:0:0:5: [sdp] Mode Sense: a7 00 00 08
[  299.704981] sd 7:0:0:5: [sdp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.705155] scsi 7:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.707070] sd 7:0:0:5: [sdp] Attached SCSI disk
[  299.795929] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.820384] sd 7:0:0:6: Attached scsi generic sg20 type 0
[  299.820889] sd 7:0:0:6: [sdq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.820891] sd 7:0:0:6: [sdq] 4096-byte physical blocks
[  299.821044] sd 7:0:0:6: [sdq] Write Protect is off
[  299.821046] sd 7:0:0:6: [sdq] Mode Sense: a7 00 00 08
[  299.821272] sd 7:0:0:6: [sdq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.821314] scsi 7:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.824213] sd 7:0:0:6: [sdq] Attached SCSI disk
[  299.880420] sd 7:0:0:7: Attached scsi generic sg21 type 0
[  299.881393] scsi 7:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.881503] sd 7:0:0:7: [sdr] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.881506] sd 7:0:0:7: [sdr] 4096-byte physical blocks
[  299.881637] sd 7:0:0:7: [sdr] Write Protect is off
[  299.881639] sd 7:0:0:7: [sdr] Mode Sense: a7 00 00 08
[  299.881937] sd 7:0:0:7: [sdr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.884364] sd 7:0:0:7: [sdr] Attached SCSI disk
[  299.900286] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  299.948457] sd 7:0:0:8: Attached scsi generic sg22 type 0
[  299.948865] sd 7:0:0:8: [sds] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  299.948868] sd 7:0:0:8: [sds] 4096-byte physical blocks
[  299.949015] sd 7:0:0:8: [sds] Write Protect is off
[  299.949017] sd 7:0:0:8: [sds] Mode Sense: a7 00 00 08
[  299.949158] scsi 7:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  299.949191] sd 7:0:0:8: [sds] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  299.951372] sd 7:0:0:8: [sds] Attached SCSI disk
[  299.987701] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  300.024479] sd 7:0:0:9: Attached scsi generic sg23 type 0
[  300.024795] sd 7:0:0:9: [sdt] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.024799] sd 7:0:0:9: [sdt] 4096-byte physical blocks
[  300.024975] sd 7:0:0:9: [sdt] Write Protect is off
[  300.024983] sd 7:0:0:9: [sdt] Mode Sense: a7 00 00 08
[  300.025158] sd 7:0:0:9: [sdt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.025694] scsi 7:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.028426] sd 7:0:0:9: [sdt] Attached SCSI disk
[  300.029045] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  300.104445] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  300.112485] sd 7:0:0:10: Attached scsi generic sg24 type 0
[  300.113329] scsi 7:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.113831] sd 7:0:0:10: [sdu] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.113838] sd 7:0:0:10: [sdu] 4096-byte physical blocks
[  300.114001] sd 7:0:0:10: [sdu] Write Protect is off
[  300.114005] sd 7:0:0:10: [sdu] Mode Sense: a7 00 00 08
[  300.114644] sd 7:0:0:10: [sdu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.119115] sd 7:0:0:10: [sdu] Attached SCSI disk
[  300.192596] sd 7:0:0:11: Attached scsi generic sg25 type 0
[  300.192893] sd 7:0:0:11: [sdv] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.192902] sd 7:0:0:11: [sdv] 4096-byte physical blocks
[  300.193065] sd 7:0:0:11: [sdv] Write Protect is off
[  300.193069] sd 7:0:0:11: [sdv] Mode Sense: a7 00 00 08
[  300.193241] sd 7:0:0:11: [sdv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.193342] scsi 7:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.196234] sd 7:0:0:11: [sdv] Attached SCSI disk
[  300.284405] sd 7:0:0:12: Attached scsi generic sg26 type 0
[  300.285212] scsi 7:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.285756] sd 7:0:0:12: [sdw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.285758] sd 7:0:0:12: [sdw] 4096-byte physical blocks
[  300.285886] sd 7:0:0:12: [sdw] Write Protect is off
[  300.285888] sd 7:0:0:12: [sdw] Mode Sense: a7 00 00 08
[  300.286141] sd 7:0:0:12: [sdw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.288576] sd 7:0:0:12: [sdw] Attached SCSI disk
[  300.356572] sd 7:0:0:13: Attached scsi generic sg27 type 0
[  300.356954] sd 7:0:0:13: [sdx] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.356957] sd 7:0:0:13: [sdx] 4096-byte physical blocks
[  300.357103] sd 7:0:0:13: [sdx] Write Protect is off
[  300.357106] sd 7:0:0:13: [sdx] Mode Sense: a7 00 00 08
[  300.357255] sd 7:0:0:13: [sdx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.357291] scsi 7:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.360025] sd 7:0:0:13: [sdx] Attached SCSI disk
[  300.456635] sd 7:0:0:14: Attached scsi generic sg28 type 0
[  300.457131] sd 7:0:0:14: [sdy] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.457136] sd 7:0:0:14: [sdy] 4096-byte physical blocks
[  300.457323] sd 7:0:0:14: [sdy] Write Protect is off
[  300.457327] sd 7:0:0:14: [sdy] Mode Sense: a7 00 00 08
[  300.457416] scsi 7:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.457613] sd 7:0:0:14: [sdy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.460644] sd 7:0:0:14: [sdy] Attached SCSI disk
[  300.548564] sd 7:0:0:15: Attached scsi generic sg29 type 0
[  300.549031] sd 7:0:0:15: [sdz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.549035] sd 7:0:0:15: [sdz] 4096-byte physical blocks
[  300.549206] sd 7:0:0:15: [sdz] Write Protect is off
[  300.549210] sd 7:0:0:15: [sdz] Mode Sense: a7 00 00 08
[  300.549378] sd 7:0:0:15: [sdz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.549432] scsi 7:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.552840] sd 7:0:0:15: [sdz] Attached SCSI disk
[  300.608614] sd 7:0:0:16: Attached scsi generic sg30 type 0
[  300.609297] sd 7:0:0:16: [sdaa] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.609327] sd 7:0:0:16: [sdaa] 4096-byte physical blocks
[  300.609334] scsi 7:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.609487] sd 7:0:0:16: [sdaa] Write Protect is off
[  300.609491] sd 7:0:0:16: [sdaa] Mode Sense: a7 00 00 08
[  300.609737] sd 7:0:0:16: [sdaa] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.612937] sd 7:0:0:16: [sdaa] Attached SCSI disk
[  300.684723] sd 7:0:0:17: Attached scsi generic sg31 type 0
[  300.685084] sd 7:0:0:17: [sdab] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.685094] sd 7:0:0:17: [sdab] 4096-byte physical blocks
[  300.685253] sd 7:0:0:17: [sdab] Write Protect is off
[  300.685256] sd 7:0:0:17: [sdab] Mode Sense: a7 00 00 08
[  300.685434] sd 7:0:0:17: [sdab] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.685706] scsi 7:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.689665] sd 7:0:0:17: [sdab] Attached SCSI disk
[  300.776506] sd 7:0:0:18: Attached scsi generic sg32 type 0
[  300.776921] sd 7:0:0:18: [sdac] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.776924] sd 7:0:0:18: [sdac] 4096-byte physical blocks
[  300.777059] sd 7:0:0:18: [sdac] Write Protect is off
[  300.777062] sd 7:0:0:18: [sdac] Mode Sense: a7 00 00 08
[  300.777218] scsi 7:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.777222] sd 7:0:0:18: [sdac] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.779904] sd 7:0:0:18: [sdac] Attached SCSI disk
[  300.856559] sd 7:0:0:19: Attached scsi generic sg33 type 0
[  300.856963] sd 7:0:0:19: [sdad] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.856965] sd 7:0:0:19: [sdad] 4096-byte physical blocks
[  300.857092] sd 7:0:0:19: [sdad] Write Protect is off
[  300.857094] sd 7:0:0:19: [sdad] Mode Sense: a7 00 00 08
[  300.857221] sd 7:0:0:19: [sdad] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.857318] scsi 7:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.859363] sd 7:0:0:19: [sdad] Attached SCSI disk
[  300.924493] sd 7:0:0:20: Attached scsi generic sg34 type 0
[  300.924730] sd 7:0:0:20: [sdae] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.924732] sd 7:0:0:20: [sdae] 4096-byte physical blocks
[  300.924874] sd 7:0:0:20: [sdae] Write Protect is off
[  300.924879] sd 7:0:0:20: [sdae] Mode Sense: a7 00 00 08
[  300.925013] sd 7:0:0:20: [sdae] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.925607] scsi 7:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.927197] sd 7:0:0:20: [sdae] Attached SCSI disk
[  300.996529] sd 7:0:0:21: Attached scsi generic sg35 type 0
[  300.996793] sd 7:0:0:21: [sdaf] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  300.996795] sd 7:0:0:21: [sdaf] 4096-byte physical blocks
[  300.996969] sd 7:0:0:21: [sdaf] Write Protect is off
[  300.996971] sd 7:0:0:21: [sdaf] Mode Sense: a7 00 00 08
[  300.997110] sd 7:0:0:21: [sdaf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  300.997405] scsi 7:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  300.999828] sd 7:0:0:21: [sdaf] Attached SCSI disk
[  301.092609] sd 7:0:0:22: Attached scsi generic sg36 type 0
[  301.092956] sd 7:0:0:22: [sdag] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  301.092959] sd 7:0:0:22: [sdag] 4096-byte physical blocks
[  301.093104] sd 7:0:0:22: [sdag] Write Protect is off
[  301.093110] sd 7:0:0:22: [sdag] Mode Sense: a7 00 00 08
[  301.093238] sd 7:0:0:22: [sdag] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  301.093346] scsi 7:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  301.095523] sd 7:0:0:22: [sdag] Attached SCSI disk
[  301.188419] sd 7:0:0:23: Attached scsi generic sg37 type 0
[  301.188788] sd 7:0:0:23: [sdah] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  301.188790] sd 7:0:0:23: [sdah] 4096-byte physical blocks
[  301.188913] sd 7:0:0:23: [sdah] Write Protect is off
[  301.188916] sd 7:0:0:23: [sdah] Mode Sense: a7 00 00 08
[  301.189042] sd 7:0:0:23: [sdah] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  301.192426] sd 7:0:0:23: [sdah] Attached SCSI disk
[  301.445281] scsi host8: iSCSI Initiator over TCP/IP
[  301.712625] scsi 8:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  301.776659] sd 8:0:0:0: Attached scsi generic sg38 type 0
[  301.779714] scsi 8:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  301.779793] sd 8:0:0:0: [sdai] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  301.779796] sd 8:0:0:0: [sdai] 4096-byte physical blocks
[  301.780789] sd 8:0:0:0: [sdai] Write Protect is off
[  301.780794] sd 8:0:0:0: [sdai] Mode Sense: a7 00 00 08
[  301.781846] sd 8:0:0:0: [sdai] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  301.787977] sd 8:0:0:0: [sdai] Attached SCSI disk
[  301.860633] sd 8:0:0:1: Attached scsi generic sg39 type 0
[  301.861029] sd 8:0:0:1: [sdaj] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  301.861033] sd 8:0:0:1: [sdaj] 4096-byte physical blocks
[  301.861210] sd 8:0:0:1: [sdaj] Write Protect is off
[  301.861213] sd 8:0:0:1: [sdaj] Mode Sense: a7 00 00 08
[  301.861384] sd 8:0:0:1: [sdaj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  301.861568] scsi 8:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  301.864785] sd 8:0:0:1: [sdaj] Attached SCSI disk
[  301.948646] sd 8:0:0:2: Attached scsi generic sg40 type 0
[  301.949015] sd 8:0:0:2: [sdak] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  301.949026] sd 8:0:0:2: [sdak] 4096-byte physical blocks
[  301.949168] sd 8:0:0:2: [sdak] Write Protect is off
[  301.949172] sd 8:0:0:2: [sdak] Mode Sense: a7 00 00 08
[  301.949350] sd 8:0:0:2: [sdak] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  301.949705] scsi 8:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  301.952660] sd 8:0:0:2: [sdak] Attached SCSI disk
[  302.020629] sd 8:0:0:3: Attached scsi generic sg41 type 0
[  302.021090] sd 8:0:0:3: [sdal] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.021095] sd 8:0:0:3: [sdal] 4096-byte physical blocks
[  302.021251] sd 8:0:0:3: [sdal] Write Protect is off
[  302.021254] sd 8:0:0:3: [sdal] Mode Sense: a7 00 00 08
[  302.021413] sd 8:0:0:3: [sdal] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.021418] scsi 8:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.024446] sd 8:0:0:3: [sdal] Attached SCSI disk
[  302.100718] sd 8:0:0:4: Attached scsi generic sg42 type 0
[  302.101274] sd 8:0:0:4: [sdam] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.101277] sd 8:0:0:4: [sdam] 4096-byte physical blocks
[  302.101418] sd 8:0:0:4: [sdam] Write Protect is off
[  302.101421] sd 8:0:0:4: [sdam] Mode Sense: a7 00 00 08
[  302.101425] scsi 8:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.101562] sd 8:0:0:4: [sdam] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.105407] sd 8:0:0:4: [sdam] Attached SCSI disk
[  302.192690] sd 8:0:0:5: Attached scsi generic sg43 type 0
[  302.192961] sd 8:0:0:5: [sdan] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.192969] sd 8:0:0:5: [sdan] 4096-byte physical blocks
[  302.193121] sd 8:0:0:5: [sdan] Write Protect is off
[  302.193123] sd 8:0:0:5: [sdan] Mode Sense: a7 00 00 08
[  302.193243] sd 8:0:0:5: [sdan] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.193473] scsi 8:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.195648] sd 8:0:0:5: [sdan] Attached SCSI disk
[  302.244615] sd 8:0:0:6: Attached scsi generic sg44 type 0
[  302.244994] sd 8:0:0:6: [sdao] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.244998] sd 8:0:0:6: [sdao] 4096-byte physical blocks
[  302.245153] sd 8:0:0:6: [sdao] Write Protect is off
[  302.245156] sd 8:0:0:6: [sdao] Mode Sense: a7 00 00 08
[  302.245313] sd 8:0:0:6: [sdao] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.245521] scsi 8:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.248346] sd 8:0:0:6: [sdao] Attached SCSI disk
[  302.312712] sd 8:0:0:7: Attached scsi generic sg45 type 0
[  302.313361] sd 8:0:0:7: [sdap] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.313375] sd 8:0:0:7: [sdap] 4096-byte physical blocks
[  302.313560] sd 8:0:0:7: [sdap] Write Protect is off
[  302.313564] sd 8:0:0:7: [sdap] Mode Sense: a7 00 00 08
[  302.313712] scsi 8:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.313796] sd 8:0:0:7: [sdap] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.317882] sd 8:0:0:7: [sdap] Attached SCSI disk
[  302.416789] sd 8:0:0:8: Attached scsi generic sg46 type 0
[  302.417221] sd 8:0:0:8: [sdaq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.417225] sd 8:0:0:8: [sdaq] 4096-byte physical blocks
[  302.417382] sd 8:0:0:8: [sdaq] Write Protect is off
[  302.417385] sd 8:0:0:8: [sdaq] Mode Sense: a7 00 00 08
[  302.417527] scsi 8:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.417569] sd 8:0:0:8: [sdaq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.420071] sd 8:0:0:8: [sdaq] Attached SCSI disk
[  302.488780] sd 8:0:0:9: Attached scsi generic sg47 type 0
[  302.488947] sd 8:0:0:9: [sdar] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.488951] sd 8:0:0:9: [sdar] 4096-byte physical blocks
[  302.489100] sd 8:0:0:9: [sdar] Write Protect is off
[  302.489104] sd 8:0:0:9: [sdar] Mode Sense: a7 00 00 08
[  302.489245] sd 8:0:0:9: [sdar] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.489552] scsi 8:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.492089] sd 8:0:0:9: [sdar] Attached SCSI disk
[  302.564758] sd 8:0:0:10: Attached scsi generic sg48 type 0
[  302.565155] sd 8:0:0:10: [sdas] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.565158] sd 8:0:0:10: [sdas] 4096-byte physical blocks
[  302.565293] sd 8:0:0:10: [sdas] Write Protect is off
[  302.565295] sd 8:0:0:10: [sdas] Mode Sense: a7 00 00 08
[  302.565434] sd 8:0:0:10: [sdas] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.565695] scsi 8:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.568098] sd 8:0:0:10: [sdas] Attached SCSI disk
[  302.628750] sd 8:0:0:11: Attached scsi generic sg49 type 0
[  302.629253] sd 8:0:0:11: [sdat] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.629267] sd 8:0:0:11: [sdat] 4096-byte physical blocks
[  302.629422] sd 8:0:0:11: [sdat] Write Protect is off
[  302.629426] sd 8:0:0:11: [sdat] Mode Sense: a7 00 00 08
[  302.629580] scsi 8:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.629621] sd 8:0:0:11: [sdat] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.632543] sd 8:0:0:11: [sdat] Attached SCSI disk
[  302.708889] sd 8:0:0:12: Attached scsi generic sg50 type 0
[  302.709255] sd 8:0:0:12: [sdau] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.709259] sd 8:0:0:12: [sdau] 4096-byte physical blocks
[  302.709415] sd 8:0:0:12: [sdau] Write Protect is off
[  302.709418] sd 8:0:0:12: [sdau] Mode Sense: a7 00 00 08
[  302.709812] sd 8:0:0:12: [sdau] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.709820] scsi 8:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.713245] sd 8:0:0:12: [sdau] Attached SCSI disk
[  302.788707] sd 8:0:0:13: Attached scsi generic sg51 type 0
[  302.789221] sd 8:0:0:13: [sdav] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.789225] sd 8:0:0:13: [sdav] 4096-byte physical blocks
[  302.789360] sd 8:0:0:13: [sdav] Write Protect is off
[  302.789362] sd 8:0:0:13: [sdav] Mode Sense: a7 00 00 08
[  302.789623] scsi 8:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.789668] sd 8:0:0:13: [sdav] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.793519] sd 8:0:0:13: [sdav] Attached SCSI disk
[  302.872603] sd 8:0:0:14: Attached scsi generic sg52 type 0
[  302.873044] sd 8:0:0:14: [sdaw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.873048] sd 8:0:0:14: [sdaw] 4096-byte physical blocks
[  302.873197] sd 8:0:0:14: [sdaw] Write Protect is off
[  302.873201] sd 8:0:0:14: [sdaw] Mode Sense: a7 00 00 08
[  302.873302] scsi 8:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.873399] sd 8:0:0:14: [sdaw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.876034] sd 8:0:0:14: [sdaw] Attached SCSI disk
[  302.940778] sd 8:0:0:15: Attached scsi generic sg53 type 0
[  302.941137] sd 8:0:0:15: [sdax] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  302.941140] sd 8:0:0:15: [sdax] 4096-byte physical blocks
[  302.941322] sd 8:0:0:15: [sdax] Write Protect is off
[  302.941325] sd 8:0:0:15: [sdax] Mode Sense: a7 00 00 08
[  302.941501] sd 8:0:0:15: [sdax] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  302.941593] scsi 8:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  302.944496] sd 8:0:0:15: [sdax] Attached SCSI disk
[  303.028662] sd 8:0:0:16: Attached scsi generic sg54 type 0
[  303.029380] scsi 8:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.029514] sd 8:0:0:16: [sday] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.029516] sd 8:0:0:16: [sday] 4096-byte physical blocks
[  303.029677] sd 8:0:0:16: [sday] Write Protect is off
[  303.029680] sd 8:0:0:16: [sday] Mode Sense: a7 00 00 08
[  303.029816] sd 8:0:0:16: [sday] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.033271] sd 8:0:0:16: [sday] Attached SCSI disk
[  303.120870] sd 8:0:0:17: Attached scsi generic sg55 type 0
[  303.121338] sd 8:0:0:17: [sdaz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.121342] sd 8:0:0:17: [sdaz] 4096-byte physical blocks
[  303.121488] sd 8:0:0:17: [sdaz] Write Protect is off
[  303.121491] sd 8:0:0:17: [sdaz] Mode Sense: a7 00 00 08
[  303.121641] scsi 8:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.121682] sd 8:0:0:17: [sdaz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.124626] sd 8:0:0:17: [sdaz] Attached SCSI disk
[  303.204718] sd 8:0:0:18: Attached scsi generic sg56 type 0
[  303.205211] sd 8:0:0:18: [sdba] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.205215] sd 8:0:0:18: [sdba] 4096-byte physical blocks
[  303.205369] sd 8:0:0:18: [sdba] Write Protect is off
[  303.205373] sd 8:0:0:18: [sdba] Mode Sense: a7 00 00 08
[  303.205494] scsi 8:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.205538] sd 8:0:0:18: [sdba] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.208439] sd 8:0:0:18: [sdba] Attached SCSI disk
[  303.264815] sd 8:0:0:19: Attached scsi generic sg57 type 0
[  303.265257] sd 8:0:0:19: [sdbb] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.265261] sd 8:0:0:19: [sdbb] 4096-byte physical blocks
[  303.265404] sd 8:0:0:19: [sdbb] Write Protect is off
[  303.265406] sd 8:0:0:19: [sdbb] Mode Sense: a7 00 00 08
[  303.265571] scsi 8:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.265602] sd 8:0:0:19: [sdbb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.268635] sd 8:0:0:19: [sdbb] Attached SCSI disk
[  303.336759] sd 8:0:0:20: Attached scsi generic sg58 type 0
[  303.337486] sd 8:0:0:20: [sdbc] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.337489] sd 8:0:0:20: [sdbc] 4096-byte physical blocks
[  303.337566] scsi 8:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.337693] sd 8:0:0:20: [sdbc] Write Protect is off
[  303.337696] sd 8:0:0:20: [sdbc] Mode Sense: a7 00 00 08
[  303.337909] sd 8:0:0:20: [sdbc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.340996] sd 8:0:0:20: [sdbc] Attached SCSI disk
[  303.428714] sd 8:0:0:21: Attached scsi generic sg59 type 0
[  303.429211] sd 8:0:0:21: [sdbd] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.429215] sd 8:0:0:21: [sdbd] 4096-byte physical blocks
[  303.429359] sd 8:0:0:21: [sdbd] Write Protect is off
[  303.429362] sd 8:0:0:21: [sdbd] Mode Sense: a7 00 00 08
[  303.429485] scsi 8:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.429523] sd 8:0:0:21: [sdbd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.432143] sd 8:0:0:21: [sdbd] Attached SCSI disk
[  303.492751] sd 8:0:0:22: Attached scsi generic sg60 type 0
[  303.493214] sd 8:0:0:22: [sdbe] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.493216] sd 8:0:0:22: [sdbe] 4096-byte physical blocks
[  303.493353] sd 8:0:0:22: [sdbe] Write Protect is off
[  303.493355] sd 8:0:0:22: [sdbe] Mode Sense: a7 00 00 08
[  303.493488] scsi 8:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  303.493526] sd 8:0:0:22: [sdbe] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.496309] sd 8:0:0:22: [sdbe] Attached SCSI disk
[  303.560762] sd 8:0:0:23: Attached scsi generic sg61 type 0
[  303.561347] sd 8:0:0:23: [sdbf] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  303.561353] sd 8:0:0:23: [sdbf] 4096-byte physical blocks
[  303.561527] sd 8:0:0:23: [sdbf] Write Protect is off
[  303.561532] sd 8:0:0:23: [sdbf] Mode Sense: a7 00 00 08
[  303.561749] sd 8:0:0:23: [sdbf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  303.566332] sd 8:0:0:23: [sdbf] Attached SCSI disk
[  303.821882] scsi host9: iSCSI Initiator over TCP/IP
[  304.094362] scsi 9:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.148841] sd 9:0:0:0: Attached scsi generic sg62 type 0
[  304.151868] scsi 9:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.151926] sd 9:0:0:0: [sdbg] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.151929] sd 9:0:0:0: [sdbg] 4096-byte physical blocks
[  304.152900] sd 9:0:0:0: [sdbg] Write Protect is off
[  304.152902] sd 9:0:0:0: [sdbg] Mode Sense: a7 00 00 08
[  304.153960] sd 9:0:0:0: [sdbg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.158699] sd 9:0:0:0: [sdbg] Attached SCSI disk
[  304.208737] sd 9:0:0:1: Attached scsi generic sg63 type 0
[  304.209266] sd 9:0:0:1: [sdbh] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.209272] sd 9:0:0:1: [sdbh] 4096-byte physical blocks
[  304.209428] sd 9:0:0:1: [sdbh] Write Protect is off
[  304.209432] sd 9:0:0:1: [sdbh] Mode Sense: a7 00 00 08
[  304.209454] scsi 9:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.209587] sd 9:0:0:1: [sdbh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.212701] sd 9:0:0:1: [sdbh] Attached SCSI disk
[  304.284809] sd 9:0:0:2: Attached scsi generic sg64 type 0
[  304.285331] sd 9:0:0:2: [sdbi] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.285334] sd 9:0:0:2: [sdbi] 4096-byte physical blocks
[  304.285482] sd 9:0:0:2: [sdbi] Write Protect is off
[  304.285487] sd 9:0:0:2: [sdbi] Mode Sense: a7 00 00 08
[  304.285684] sd 9:0:0:2: [sdbi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.286774] scsi 9:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.289266] sd 9:0:0:2: [sdbi] Attached SCSI disk
[  304.372791] sd 9:0:0:3: Attached scsi generic sg65 type 0
[  304.373317] sd 9:0:0:3: [sdbj] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.373320] sd 9:0:0:3: [sdbj] 4096-byte physical blocks
[  304.373462] sd 9:0:0:3: [sdbj] Write Protect is off
[  304.373464] scsi 9:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.373465] sd 9:0:0:3: [sdbj] Mode Sense: a7 00 00 08
[  304.373620] sd 9:0:0:3: [sdbj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.376288] sd 9:0:0:3: [sdbj] Attached SCSI disk
[  304.476819] sd 9:0:0:4: Attached scsi generic sg66 type 0
[  304.477217] sd 9:0:0:4: [sdbk] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.477221] sd 9:0:0:4: [sdbk] 4096-byte physical blocks
[  304.477355] sd 9:0:0:4: [sdbk] Write Protect is off
[  304.477357] sd 9:0:0:4: [sdbk] Mode Sense: a7 00 00 08
[  304.477462] scsi 9:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.477497] sd 9:0:0:4: [sdbk] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.480055] sd 9:0:0:4: [sdbk] Attached SCSI disk
[  304.540848] sd 9:0:0:5: Attached scsi generic sg67 type 0
[  304.541303] sd 9:0:0:5: [sdbl] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.541308] sd 9:0:0:5: [sdbl] 4096-byte physical blocks
[  304.541462] sd 9:0:0:5: [sdbl] Write Protect is off
[  304.541465] sd 9:0:0:5: [sdbl] Mode Sense: a7 00 00 08
[  304.541680] sd 9:0:0:5: [sdbl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.541725] scsi 9:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.544757] ql_add_path: 74 callbacks suppressed
[  304.544759] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.544762] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.544786] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.544832] sd 9:0:0:5: [sdbl] Attached SCSI disk
[  304.612879] sd 9:0:0:6: Attached scsi generic sg68 type 0
[  304.613248] sd 9:0:0:6: [sdbm] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.613252] sd 9:0:0:6: [sdbm] 4096-byte physical blocks
[  304.613384] sd 9:0:0:6: [sdbm] Write Protect is off
[  304.613387] sd 9:0:0:6: [sdbm] Mode Sense: a7 00 00 08
[  304.613521] sd 9:0:0:6: [sdbm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.613588] scsi 9:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.616226] sd 9:0:0:6: [sdbm] Attached SCSI disk
[  304.623087] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.623091] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.623108] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.676890] sd 9:0:0:7: Attached scsi generic sg69 type 0
[  304.677351] sd 9:0:0:7: [sdbn] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.677354] sd 9:0:0:7: [sdbn] 4096-byte physical blocks
[  304.677506] sd 9:0:0:7: [sdbn] Write Protect is off
[  304.677509] sd 9:0:0:7: [sdbn] Mode Sense: a7 00 00 08
[  304.677623] scsi 9:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.677680] sd 9:0:0:7: [sdbn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.680569] sd 9:0:0:7: [sdbn] Attached SCSI disk
[  304.695891] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.695895] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.695914] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.736944] sd 9:0:0:8: Attached scsi generic sg70 type 0
[  304.737375] sd 9:0:0:8: [sdbo] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.737379] sd 9:0:0:8: [sdbo] 4096-byte physical blocks
[  304.737530] sd 9:0:0:8: [sdbo] Write Protect is off
[  304.737534] sd 9:0:0:8: [sdbo] Mode Sense: a7 00 00 08
[  304.737747] sd 9:0:0:8: [sdbo] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.737808] scsi 9:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.741664] sd 9:0:0:8: [sdbo] Attached SCSI disk
[  304.741766] device-mapper: multipath queue-length: repeat_count > 1 is deprecated, using 1 instead
[  304.812874] sd 9:0:0:9: Attached scsi generic sg71 type 0
[  304.813513] sd 9:0:0:9: [sdbp] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.813518] sd 9:0:0:9: [sdbp] 4096-byte physical blocks
[  304.813713] sd 9:0:0:9: [sdbp] Write Protect is off
[  304.813717] sd 9:0:0:9: [sdbp] Mode Sense: a7 00 00 08
[  304.813902] scsi 9:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.814045] sd 9:0:0:9: [sdbp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.817647] sd 9:0:0:9: [sdbp] Attached SCSI disk
[  304.896864] sd 9:0:0:10: Attached scsi generic sg72 type 0
[  304.897288] sd 9:0:0:10: [sdbq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.897293] sd 9:0:0:10: [sdbq] 4096-byte physical blocks
[  304.897446] sd 9:0:0:10: [sdbq] Write Protect is off
[  304.897450] sd 9:0:0:10: [sdbq] Mode Sense: a7 00 00 08
[  304.897601] sd 9:0:0:10: [sdbq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.897673] scsi 9:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.900101] sd 9:0:0:10: [sdbq] Attached SCSI disk
[  304.984866] sd 9:0:0:11: Attached scsi generic sg73 type 0
[  304.985375] sd 9:0:0:11: [sdbr] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  304.985377] sd 9:0:0:11: [sdbr] 4096-byte physical blocks
[  304.985521] scsi 9:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  304.985621] sd 9:0:0:11: [sdbr] Write Protect is off
[  304.985623] sd 9:0:0:11: [sdbr] Mode Sense: a7 00 00 08
[  304.985808] sd 9:0:0:11: [sdbr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  304.988457] sd 9:0:0:11: [sdbr] Attached SCSI disk
[  305.064844] sd 9:0:0:12: Attached scsi generic sg74 type 0
[  305.065290] sd 9:0:0:12: [sdbs] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.065293] sd 9:0:0:12: [sdbs] 4096-byte physical blocks
[  305.065428] sd 9:0:0:12: [sdbs] Write Protect is off
[  305.065430] sd 9:0:0:12: [sdbs] Mode Sense: a7 00 00 08
[  305.065544] scsi 9:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.065581] sd 9:0:0:12: [sdbs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.068215] sd 9:0:0:12: [sdbs] Attached SCSI disk
[  305.148963] sd 9:0:0:13: Attached scsi generic sg75 type 0
[  305.149329] sd 9:0:0:13: [sdbt] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.149333] sd 9:0:0:13: [sdbt] 4096-byte physical blocks
[  305.149471] sd 9:0:0:13: [sdbt] Write Protect is off
[  305.149474] sd 9:0:0:13: [sdbt] Mode Sense: a7 00 00 08
[  305.149620] sd 9:0:0:13: [sdbt] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.149662] scsi 9:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.152089] sd 9:0:0:13: [sdbt] Attached SCSI disk
[  305.248905] sd 9:0:0:14: Attached scsi generic sg76 type 0
[  305.249414] sd 9:0:0:14: [sdbu] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.249417] sd 9:0:0:14: [sdbu] 4096-byte physical blocks
[  305.249542] sd 9:0:0:14: [sdbu] Write Protect is off
[  305.249544] sd 9:0:0:14: [sdbu] Mode Sense: a7 00 00 08
[  305.249654] scsi 9:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.249686] sd 9:0:0:14: [sdbu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.252311] sd 9:0:0:14: [sdbu] Attached SCSI disk
[  305.336885] sd 9:0:0:15: Attached scsi generic sg77 type 0
[  305.337587] sd 9:0:0:15: [sdbv] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.337590] sd 9:0:0:15: [sdbv] 4096-byte physical blocks
[  305.337639] scsi 9:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.337737] sd 9:0:0:15: [sdbv] Write Protect is off
[  305.337740] sd 9:0:0:15: [sdbv] Mode Sense: a7 00 00 08
[  305.337910] sd 9:0:0:15: [sdbv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.341675] sd 9:0:0:15: [sdbv] Attached SCSI disk
[  305.424898] sd 9:0:0:16: Attached scsi generic sg78 type 0
[  305.425560] sd 9:0:0:16: [sdbw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.425563] sd 9:0:0:16: [sdbw] 4096-byte physical blocks
[  305.425696] sd 9:0:0:16: [sdbw] Write Protect is off
[  305.425698] sd 9:0:0:16: [sdbw] Mode Sense: a7 00 00 08
[  305.425705] scsi 9:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.425863] sd 9:0:0:16: [sdbw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.429172] sd 9:0:0:16: [sdbw] Attached SCSI disk
[  305.489007] sd 9:0:0:17: Attached scsi generic sg79 type 0
[  305.489458] sd 9:0:0:17: [sdbx] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.489463] sd 9:0:0:17: [sdbx] 4096-byte physical blocks
[  305.489640] sd 9:0:0:17: [sdbx] Write Protect is off
[  305.489646] sd 9:0:0:17: [sdbx] Mode Sense: a7 00 00 08
[  305.489890] sd 9:0:0:17: [sdbx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.489951] scsi 9:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.493634] sd 9:0:0:17: [sdbx] Attached SCSI disk
[  305.588988] sd 9:0:0:18: Attached scsi generic sg80 type 0
[  305.589431] sd 9:0:0:18: [sdby] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.589436] sd 9:0:0:18: [sdby] 4096-byte physical blocks
[  305.589597] sd 9:0:0:18: [sdby] Write Protect is off
[  305.589600] sd 9:0:0:18: [sdby] Mode Sense: a7 00 00 08
[  305.589749] scsi 9:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.589789] sd 9:0:0:18: [sdby] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.592855] sd 9:0:0:18: [sdby] Attached SCSI disk
[  305.648970] sd 9:0:0:19: Attached scsi generic sg81 type 0
[  305.649407] sd 9:0:0:19: [sdbz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.649414] sd 9:0:0:19: [sdbz] 4096-byte physical blocks
[  305.649613] sd 9:0:0:19: [sdbz] Write Protect is off
[  305.649619] sd 9:0:0:19: [sdbz] Mode Sense: a7 00 00 08
[  305.649798] sd 9:0:0:19: [sdbz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.650081] scsi 9:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.653127] sd 9:0:0:19: [sdbz] Attached SCSI disk
[  305.713004] sd 9:0:0:20: Attached scsi generic sg82 type 0
[  305.713513] sd 9:0:0:20: [sdca] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.713517] sd 9:0:0:20: [sdca] 4096-byte physical blocks
[  305.713670] sd 9:0:0:20: [sdca] Write Protect is off
[  305.713673] sd 9:0:0:20: [sdca] Mode Sense: a7 00 00 08
[  305.713788] scsi 9:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.713852] sd 9:0:0:20: [sdca] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.716708] sd 9:0:0:20: [sdca] Attached SCSI disk
[  305.812954] sd 9:0:0:21: Attached scsi generic sg83 type 0
[  305.813793] sd 9:0:0:21: [sdcb] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.813795] sd 9:0:0:21: [sdcb] 4096-byte physical blocks
[  305.813849] scsi 9:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.813967] sd 9:0:0:21: [sdcb] Write Protect is off
[  305.813971] sd 9:0:0:21: [sdcb] Mode Sense: a7 00 00 08
[  305.814153] sd 9:0:0:21: [sdcb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.817280] sd 9:0:0:21: [sdcb] Attached SCSI disk
[  305.880942] sd 9:0:0:22: Attached scsi generic sg84 type 0
[  305.881360] sd 9:0:0:22: [sdcc] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.881364] sd 9:0:0:22: [sdcc] 4096-byte physical blocks
[  305.881529] sd 9:0:0:22: [sdcc] Write Protect is off
[  305.881532] sd 9:0:0:22: [sdcc] Mode Sense: a7 00 00 08
[  305.881691] sd 9:0:0:22: [sdcc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.881747] scsi 9:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  305.884584] sd 9:0:0:22: [sdcc] Attached SCSI disk
[  305.953075] sd 9:0:0:23: Attached scsi generic sg85 type 0
[  305.953434] sd 9:0:0:23: [sdcd] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  305.953443] sd 9:0:0:23: [sdcd] 4096-byte physical blocks
[  305.953592] sd 9:0:0:23: [sdcd] Write Protect is off
[  305.953596] sd 9:0:0:23: [sdcd] Mode Sense: a7 00 00 08
[  305.953764] sd 9:0:0:23: [sdcd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  305.957265] sd 9:0:0:23: [sdcd] Attached SCSI disk
[  306.215856] scsi host10: iSCSI Initiator over TCP/IP
[  306.489131] scsi 10:0:0:0: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.549040] sd 10:0:0:0: Attached scsi generic sg86 type 0
[  306.552065] scsi 10:0:0:1: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.552160] sd 10:0:0:0: [sdce] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  306.552163] sd 10:0:0:0: [sdce] 4096-byte physical blocks
[  306.553121] sd 10:0:0:0: [sdce] Write Protect is off
[  306.553124] sd 10:0:0:0: [sdce] Mode Sense: a7 00 00 08
[  306.554176] sd 10:0:0:0: [sdce] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  306.559463] sd 10:0:0:0: [sdce] Attached SCSI disk
[  306.633120] sd 10:0:0:1: Attached scsi generic sg87 type 0
[  306.633506] sd 10:0:0:1: [sdcf] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  306.633509] sd 10:0:0:1: [sdcf] 4096-byte physical blocks
[  306.633645] sd 10:0:0:1: [sdcf] Write Protect is off
[  306.633648] sd 10:0:0:1: [sdcf] Mode Sense: a7 00 00 08
[  306.633786] sd 10:0:0:1: [sdcf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  306.634100] scsi 10:0:0:2: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.637119] sd 10:0:0:1: [sdcf] Attached SCSI disk
[  306.709138] sd 10:0:0:2: Attached scsi generic sg88 type 0
[  306.709550] sd 10:0:0:2: [sdcg] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  306.709556] sd 10:0:0:2: [sdcg] 4096-byte physical blocks
[  306.709725] sd 10:0:0:2: [sdcg] Write Protect is off
[  306.709730] sd 10:0:0:2: [sdcg] Mode Sense: a7 00 00 08
[  306.709923] scsi 10:0:0:3: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.710040] sd 10:0:0:2: [sdcg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  306.713597] sd 10:0:0:2: [sdcg] Attached SCSI disk
[  306.797076] sd 10:0:0:3: Attached scsi generic sg89 type 0
[  306.797827] scsi 10:0:0:4: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.797829] sd 10:0:0:3: [sdch] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  306.797833] sd 10:0:0:3: [sdch] 4096-byte physical blocks
[  306.798083] sd 10:0:0:3: [sdch] Write Protect is off
[  306.798087] sd 10:0:0:3: [sdch] Mode Sense: a7 00 00 08
[  306.798250] sd 10:0:0:3: [sdch] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  306.801508] sd 10:0:0:3: [sdch] Attached SCSI disk
[  306.900993] sd 10:0:0:4: Attached scsi generic sg90 type 0
[  306.901467] sd 10:0:0:4: [sdci] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  306.901469] sd 10:0:0:4: [sdci] 4096-byte physical blocks
[  306.901613] sd 10:0:0:4: [sdci] Write Protect is off
[  306.901616] sd 10:0:0:4: [sdci] Mode Sense: a7 00 00 08
[  306.901684] scsi 10:0:0:5: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.901803] sd 10:0:0:4: [sdci] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  306.904241] sd 10:0:0:4: [sdci] Attached SCSI disk
[  306.973101] sd 10:0:0:5: Attached scsi generic sg91 type 0
[  306.973426] sd 10:0:0:5: [sdcj] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  306.973435] sd 10:0:0:5: [sdcj] 4096-byte physical blocks
[  306.973591] sd 10:0:0:5: [sdcj] Write Protect is off
[  306.973595] sd 10:0:0:5: [sdcj] Mode Sense: a7 00 00 08
[  306.973761] sd 10:0:0:5: [sdcj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  306.974007] scsi 10:0:0:6: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  306.976460] sd 10:0:0:5: [sdcj] Attached SCSI disk
[  307.037083] sd 10:0:0:6: Attached scsi generic sg92 type 0
[  307.037560] sd 10:0:0:6: [sdck] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.037566] sd 10:0:0:6: [sdck] 4096-byte physical blocks
[  307.037729] sd 10:0:0:6: [sdck] Write Protect is off
[  307.037732] sd 10:0:0:6: [sdck] Mode Sense: a7 00 00 08
[  307.037888] scsi 10:0:0:7: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.037933] sd 10:0:0:6: [sdck] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.041428] sd 10:0:0:6: [sdck] Attached SCSI disk
[  307.153037] sd 10:0:0:7: Attached scsi generic sg93 type 0
[  307.153553] sd 10:0:0:7: [sdcl] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.153556] sd 10:0:0:7: [sdcl] 4096-byte physical blocks
[  307.153701] sd 10:0:0:7: [sdcl] Write Protect is off
[  307.153704] sd 10:0:0:7: [sdcl] Mode Sense: a7 00 00 08
[  307.153771] scsi 10:0:0:8: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.153890] sd 10:0:0:7: [sdcl] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.156409] sd 10:0:0:7: [sdcl] Attached SCSI disk
[  307.233076] sd 10:0:0:8: Attached scsi generic sg94 type 0
[  307.233609] sd 10:0:0:8: [sdcm] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.233612] sd 10:0:0:8: [sdcm] 4096-byte physical blocks
[  307.233763] sd 10:0:0:8: [sdcm] Write Protect is off
[  307.233767] sd 10:0:0:8: [sdcm] Mode Sense: a7 00 00 08
[  307.233846] scsi 10:0:0:9: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.233963] sd 10:0:0:8: [sdcm] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.236714] sd 10:0:0:8: [sdcm] Attached SCSI disk
[  307.313190] sd 10:0:0:9: Attached scsi generic sg95 type 0
[  307.313658] sd 10:0:0:9: [sdcn] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.313660] sd 10:0:0:9: [sdcn] 4096-byte physical blocks
[  307.313822] sd 10:0:0:9: [sdcn] Write Protect is off
[  307.313825] sd 10:0:0:9: [sdcn] Mode Sense: a7 00 00 08
[  307.313914] scsi 10:0:0:10: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.314037] sd 10:0:0:9: [sdcn] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.317360] sd 10:0:0:9: [sdcn] Attached SCSI disk
[  307.393097] sd 10:0:0:10: Attached scsi generic sg96 type 0
[  307.393639] sd 10:0:0:10: [sdco] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.393644] sd 10:0:0:10: [sdco] 4096-byte physical blocks
[  307.393794] sd 10:0:0:10: [sdco] Write Protect is off
[  307.393796] sd 10:0:0:10: [sdco] Mode Sense: a7 00 00 08
[  307.393923] scsi 10:0:0:11: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.393961] sd 10:0:0:10: [sdco] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.396978] sd 10:0:0:10: [sdco] Attached SCSI disk
[  307.489139] sd 10:0:0:11: Attached scsi generic sg97 type 0
[  307.489531] sd 10:0:0:11: [sdcp] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.489535] sd 10:0:0:11: [sdcp] 4096-byte physical blocks
[  307.489684] sd 10:0:0:11: [sdcp] Write Protect is off
[  307.489688] sd 10:0:0:11: [sdcp] Mode Sense: a7 00 00 08
[  307.489852] sd 10:0:0:11: [sdcp] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.489900] scsi 10:0:0:12: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.492465] sd 10:0:0:11: [sdcp] Attached SCSI disk
[  307.549087] sd 10:0:0:12: Attached scsi generic sg98 type 0
[  307.549580] sd 10:0:0:12: [sdcq] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.549585] sd 10:0:0:12: [sdcq] 4096-byte physical blocks
[  307.549803] sd 10:0:0:12: [sdcq] Write Protect is off
[  307.549806] sd 10:0:0:12: [sdcq] Mode Sense: a7 00 00 08
[  307.549987] sd 10:0:0:12: [sdcq] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.549992] scsi 10:0:0:13: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.553123] sd 10:0:0:12: [sdcq] Attached SCSI disk
[  307.617168] sd 10:0:0:13: Attached scsi generic sg99 type 0
[  307.617639] sd 10:0:0:13: [sdcr] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.617645] sd 10:0:0:13: [sdcr] 4096-byte physical blocks
[  307.617791] sd 10:0:0:13: [sdcr] Write Protect is off
[  307.617795] sd 10:0:0:13: [sdcr] Mode Sense: a7 00 00 08
[  307.617936] scsi 10:0:0:14: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.617986] sd 10:0:0:13: [sdcr] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.621304] sd 10:0:0:13: [sdcr] Attached SCSI disk
[  307.709124] sd 10:0:0:14: Attached scsi generic sg100 type 0
[  307.709841] scsi 10:0:0:15: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.709886] sd 10:0:0:14: [sdcs] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.709888] sd 10:0:0:14: [sdcs] 4096-byte physical blocks
[  307.710018] sd 10:0:0:14: [sdcs] Write Protect is off
[  307.710020] sd 10:0:0:14: [sdcs] Mode Sense: a7 00 00 08
[  307.710141] sd 10:0:0:14: [sdcs] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.713056] sd 10:0:0:14: [sdcs] Attached SCSI disk
[  307.785198] sd 10:0:0:15: Attached scsi generic sg101 type 0
[  307.785659] sd 10:0:0:15: [sdct] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.785662] sd 10:0:0:15: [sdct] 4096-byte physical blocks
[  307.785806] sd 10:0:0:15: [sdct] Write Protect is off
[  307.785809] sd 10:0:0:15: [sdct] Mode Sense: a7 00 00 08
[  307.785985] sd 10:0:0:15: [sdct] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.786033] scsi 10:0:0:16: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.788697] sd 10:0:0:15: [sdct] Attached SCSI disk
[  307.849170] sd 10:0:0:16: Attached scsi generic sg102 type 0
[  307.849683] sd 10:0:0:16: [sdcu] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.849689] sd 10:0:0:16: [sdcu] 4096-byte physical blocks
[  307.849843] sd 10:0:0:16: [sdcu] Write Protect is off
[  307.849846] sd 10:0:0:16: [sdcu] Mode Sense: a7 00 00 08
[  307.850011] sd 10:0:0:16: [sdcu] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.850054] scsi 10:0:0:17: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.853005] sd 10:0:0:16: [sdcu] Attached SCSI disk
[  307.925103] sd 10:0:0:17: Attached scsi generic sg103 type 0
[  307.925526] sd 10:0:0:17: [sdcv] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.925530] sd 10:0:0:17: [sdcv] 4096-byte physical blocks
[  307.925672] sd 10:0:0:17: [sdcv] Write Protect is off
[  307.925675] sd 10:0:0:17: [sdcv] Mode Sense: a7 00 00 08
[  307.925830] sd 10:0:0:17: [sdcv] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  307.925872] scsi 10:0:0:18: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.928464] sd 10:0:0:17: [sdcv] Attached SCSI disk
[  307.997188] sd 10:0:0:18: Attached scsi generic sg104 type 0
[  307.997696] sd 10:0:0:18: [sdcw] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  307.997699] sd 10:0:0:18: [sdcw] 4096-byte physical blocks
[  307.997853] sd 10:0:0:18: [sdcw] Write Protect is off
[  307.997857] sd 10:0:0:18: [sdcw] Mode Sense: a7 00 00 08
[  307.997984] scsi 10:0:0:19: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  307.998017] sd 10:0:0:18: [sdcw] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  308.001080] sd 10:0:0:18: [sdcw] Attached SCSI disk
[  308.057190] sd 10:0:0:19: Attached scsi generic sg105 type 0
[  308.057674] sd 10:0:0:19: [sdcx] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  308.057677] sd 10:0:0:19: [sdcx] 4096-byte physical blocks
[  308.057818] sd 10:0:0:19: [sdcx] Write Protect is off
[  308.057821] sd 10:0:0:19: [sdcx] Mode Sense: a7 00 00 08
[  308.057970] scsi 10:0:0:20: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  308.058029] sd 10:0:0:19: [sdcx] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  308.060751] sd 10:0:0:19: [sdcx] Attached SCSI disk
[  308.137102] sd 10:0:0:20: Attached scsi generic sg106 type 0
[  308.137815] scsi 10:0:0:21: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  308.137853] sd 10:0:0:20: [sdcy] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  308.137860] sd 10:0:0:20: [sdcy] 4096-byte physical blocks
[  308.138000] sd 10:0:0:20: [sdcy] Write Protect is off
[  308.138002] sd 10:0:0:20: [sdcy] Mode Sense: a7 00 00 08
[  308.138120] sd 10:0:0:20: [sdcy] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  308.141611] sd 10:0:0:20: [sdcy] Attached SCSI disk
[  308.217161] sd 10:0:0:21: Attached scsi generic sg107 type 0
[  308.217713] sd 10:0:0:21: [sdcz] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  308.217716] sd 10:0:0:21: [sdcz] 4096-byte physical blocks
[  308.217859] sd 10:0:0:21: [sdcz] Write Protect is off
[  308.217882] sd 10:0:0:21: [sdcz] Mode Sense: a7 00 00 08
[  308.218005] scsi 10:0:0:22: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  308.218045] sd 10:0:0:21: [sdcz] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  308.221186] sd 10:0:0:21: [sdcz] Attached SCSI disk
[  308.309418] sd 10:0:0:22: Attached scsi generic sg108 type 0
[  308.310061] sd 10:0:0:22: [sdda] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  308.310084] sd 10:0:0:22: [sdda] 4096-byte physical blocks
[  308.310231] sd 10:0:0:22: [sdda] Write Protect is off
[  308.310256] sd 10:0:0:22: [sdda] Mode Sense: a7 00 00 08
[  308.310399] scsi 10:0:0:23: Direct-Access     IBM      FlashSystem-9840 1217 PQ: 0 ANSI: 5
[  308.310700] sd 10:0:0:22: [sdda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  308.314382] sd 10:0:0:22: [sdda] Attached SCSI disk
[  308.429250] sd 10:0:0:23: Attached scsi generic sg109 type 0
[  308.429612] sd 10:0:0:23: [sddb] 629145600 512-byte logical blocks: (322 GB/300 GiB)
[  308.429617] sd 10:0:0:23: [sddb] 4096-byte physical blocks
[  308.429773] sd 10:0:0:23: [sddb] Write Protect is off
[  308.429778] sd 10:0:0:23: [sddb] Mode Sense: a7 00 00 08
[  308.429939] sd 10:0:0:23: [sddb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  308.432895] sd 10:0:0:23: [sddb] Attached SCSI disk
[ 5163.623477] SGI XFS with ACLs, security attributes, realtime, no debug enabled
[ 5163.644005] JFS: nTxBlock = 8192, nTxLock = 65536
[ 5163.665598] ntfs: driver 2.1.32 [Flags: R/O MODULE].
[ 5163.710949] QNX4 filesystem 0.2.3 registered.
[ 5163.794930] raid6: altivecx1 gen()  7316 MB/s
[ 5163.862924] raid6: altivecx2 gen() 12510 MB/s
[ 5163.930923] raid6: altivecx4 gen() 17013 MB/s
[ 5163.998918] raid6: altivecx8 gen()  8735 MB/s
[ 5164.066929] raid6: int64x1  gen()  2839 MB/s
[ 5164.134937] raid6: int64x1  xor()  1001 MB/s
[ 5164.202915] raid6: int64x2  gen()  3187 MB/s
[ 5164.270917] raid6: int64x2  xor()  1033 MB/s
[ 5164.338902] raid6: int64x4  gen()  3794 MB/s
[ 5164.406904] raid6: int64x4  xor()  1112 MB/s
[ 5164.474913] raid6: int64x8  gen()  1575 MB/s
[ 5164.542926] raid6: int64x8  xor()   790 MB/s
[ 5164.542928] raid6: using algorithm altivecx4 gen() 17013 MB/s
[ 5164.542929] raid6: using intx1 recovery algorithm
[ 5164.557674] xor: measuring software checksum speed
[ 5164.594893]    8regs     :  9968.000 MB/sec
[ 5164.634891]    8regs_prefetch:  9072.000 MB/sec
[ 5164.674887]    32regs    : 19056.000 MB/sec
[ 5164.714886]    32regs_prefetch: 17280.000 MB/sec
[ 5164.754886]    altivec   : 25984.000 MB/sec
[ 5164.754887] xor: using function: altivec (25984.000 MB/sec)
[ 5164.816115] Btrfs loaded, crc32c=crc32c-generic
[ 5164.991676] EXT4-fs (sda1): VFS: Can't find ext4 filesystem
[ 5164.993216] EXT4-fs (sda1): VFS: Can't find ext4 filesystem
[ 5164.995127] EXT4-fs (sda1): VFS: Can't find ext4 filesystem
[ 5164.996655] squashfs: SQUASHFS error: Can't find a SQUASHFS superblock on sda1
[ 5164.998399] FAT-fs (sda1): bogus number of reserved sectors
[ 5164.998450] FAT-fs (sda1): Can't find a valid FAT filesystem
[ 5165.006580] XFS (sda1): Invalid superblock magic number
[ 5165.010806] FAT-fs (sda1): bogus number of reserved sectors
[ 5165.010862] FAT-fs (sda1): Can't find a valid FAT filesystem
[ 5165.015104] VFS: Can't find a Minix filesystem V1 | V2 | V3 on device sda1.
[ 5165.031156] hfsplus: unable to find HFS+ superblock
[ 5165.032459] qnx4: no qnx4 filesystem (no root dir).
[ 5165.034106] ufs: You didn't specify the type of your ufs filesystem
[ 5165.034106]
[ 5165.034729] ufs: ufs_fill_super(): bad magic number
[ 5165.037415] hfs: can't find a HFS filesystem on dev sda1
[ 8085.784538] Unable to handle kernel paging request for data at address 0x000000b0
[ 8085.784810] Faulting instruction address: 0xd00000000e4a68a8
[ 8712.183900] Dumping ftrace buffer:
[ 8712.184136]    (ftrace buffer empty)
[ 8760.511444] Unable to handle kernel paging request for data at address 0x000000b0
[ 8760.511800]  connection4:0: detected conn error (1022)
[ 8760.512039] Faulting instruction address: 0xd00000000e4a68a8

--------------C6172F10CCBA83E84B9E7370--
