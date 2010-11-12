From: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: transport_generic_handle_data - BUG:
 scheduling	while atomic
Date: Thu, 11 Nov 2010 17:18:03 -0800
Message-ID: <4CDC95CB.50702@cisco.com>
References: <FE279AF0CA06284B8C26150408F3EB120787382F@CBSSEXM02P.crossbeamsys.com>	
	<4CDC494A.5030207@cisco.com>	
	<13830B75AD5A2F42848F92269B11996F0107633CE4@orsmsx509.amr.corp.intel.com>
	<1289523519.2867.181.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1289523519.2867.181.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-iscsi-target-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jansen,
	Frank" <fjansen-qtErNyoUTJvkRXVmnFA4bA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 11/11/10 4:58 PM, Nicholas A. Bellinger wrote:
> On Thu, 2010-11-11 at 14:57 -0800, Patil, Kiran wrote:
>> Yes, transport_generic_handle_data which is called from ft_recv_write_data can do msleep_interruptible only if transport is active.
>>
>> FYI, this msleep was not introduced by my patch, it has been there.
>>
>> Agree with Joe's both suggestion (fcoe_rcv - always let it go to processing thread and TCM should not block per CPU receive thread). Will let Nick comment on that.
>>
> 
> Hey guys,
> 
> So the split for interrupt context setup of individual se_cmd
> descriptors for TCM_Loop (and other WIP HW FC target mode drivers) is to
> use the optional target_core_fabric_ops->new_cmd_map() for the pieces of
> se_cmd setup logic that are currently not done in interrupt context.
> For TCM_Loop this is currently:
> 
> *) transport_generic_allocate_tasks() (access of lun, PR and ALUA 
>         specifics locks currently using spin_lock() + spin_unlock()
> *) transport_generic_map_mem_to_cmd() using GFP_KERNEL allocations
> 
> However for this specific transport_generic_handle_data() case:
> 
>         /*
>          * Make sure that the transport has been disabled by
>          * transport_write_pending() before readding this struct se_cmd to the
>          * processing queue.  If it has not yet been reset to zero by the
>          * processing thread in transport_add_cmd_to_queue(), let other
>          * processes run.  If a signal was received, then we assume the
>          * connection is being failed/shutdown, so we return a failure.
>          */
>         while (atomic_read(&T_TASK(cmd)->t_transport_active)) {
>                 msleep_interruptible(10);
>                 if (signal_pending(current))
>                         return -1;
>         }
> 
> is specific for existing drivers/target/lio-target iSCSI code, which need this for
> traditional kernel sockets recv side iSCSI WRITE case.
> 
> Since we have already have FCP write data ready for submission to

(We have some, usually not all of the data)

> backend devices at this point, I think we want something in the
> transport_generic_new_cmd() -> transport_generic_write_pending() code
> that does the immediate SCSI write submission and skips the
> TFO->write_pending() callback / extra fabric API exchange/response..  

If I understand, the write_pending() callback is when we send the transfer ready
to the initiator, and we don't have the data yet.

> Here is how TCM_loop is currently doing that with SCSI WRITE data mapped
> from incoming ->queuecommand() cmd->table.sgl memory:
> 
> int tcm_loop_write_pending(struct se_cmd *se_cmd)
> {
>         /*
>          * Since Linux/SCSI has already sent down a struct scsi_cmnd
>          * sc->sc_data_direction of DMA_TO_DEVICE with struct scatterlist array
>          * memory, and memory has already been mapped to struct se_cmd->t_mem_list
>          * format with transport_generic_map_mem_to_cmd().
>          *
>          * We now tell TCM to add this WRITE CDB directly into the TCM storage
>          * object execution queue.
>          */
>         transport_generic_process_write(se_cmd);
>         return 0;
> }
> 
> This will skip the transport_check_aborted_status() in
> transport_generic_handle_data(), and immediately add the
> T_TASK(cmd)->t_task_list for se_task execution down to
> se_subsystem_api->do_task() and out to backend subsystem code.
> 
> So just to reiterate the point with current v4.0 code, we currently
> cannot safely call transport_generic_allocate_tasks() or
> transport_generic_map_mem_to_cmd() from interrupt context, so you want
> to do these calls using TFO->new_cmd_map() callback in the backend
> kernel thread process context..  

The workaround I gave calls them from thread context, but we don't
want that thread to block (at least not for very long) either.  It is
holding up more incoming requests and data for unrelated I/O.

> So I think this means you want to call transport_generic_process_write()
> to immediate queue the WRITE from TFO->write_pending(), but not very
> certain after looking at ft_write_pending().
> 
> Joe, any thoughts here..?

I find this all confusing, mainly because I'm not taking time to figure
it all out, and there seem to be so many related issues.  So, I'm not
sure I've researched it enough to make any of these comments.

Eventually, we want to accumulate all the write data frames and then
give you an s/g list for them which you pass to the back end driver.
For FCP, however, the sequence is:
	
receive command - verify LUN, etc.  TCM calls tcm_fc to send transfer-ready.
When all the data frames have been received, tcm_fc makes the S/G list and give
them to TCM.  When the back end is done, tcm_fc sends status and free the frames.

In the mean time, the current interface is probably fine, but means we need
to do a copy, unless the LLD uses direct data placement.

	Joe

> Best,
> 
> --nab
> 
>> Thanks,
>> -- Kiran P.
>>
>> -----Original Message-----
>> From: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org [mailto:devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org] On Behalf Of Joe Eykholt
>> Sent: Thursday, November 11, 2010 11:52 AM
>> To: Jansen, Frank
>> Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
>> Subject: Re: [Open-FCoE] transport_generic_handle_data - BUG: scheduling while atomic
>>
>>
>>
>> On 11/11/10 11:41 AM, Jansen, Frank wrote:
>>> Greetings!
>>>
>>> I'm running 2.6.36 with Kiran Patil's patches from 10/28/10.
>>>
>>> I have 4 logical volumes configured over fcoe:
>>>
>>> [root@dut ~]# tcm_node --listhbas
>>> \------> iblock_0
>>>        HBA Index: 1 plugin: iblock version: v4.0.0-rc5
>>>        \-------> r0_lun3
>>>        Status: ACTIVATED  Execute/Left/Max Queue Depth: 0/32/32
>>> SectorSize: 512  MaxSectors: 1024
>>>        iBlock device: dm-4  UDEV PATH: /dev/vg_R0_p1/lv_R0_p1_l3
>>>        Major: 253 Minor: 4  CLAIMED: IBLOCK
>>>        udev_path: /dev/vg_R0_p1/lv_R0_p1_l3
>>>        \-------> r0_lun2
>>>        Status: ACTIVATED  Execute/Left/Max Queue Depth: 0/32/32
>>> SectorSize: 512  MaxSectors: 1024
>>>        iBlock device: dm-3  UDEV PATH: /dev/vg_R0_p1/lv_R0_p1_l2
>>>        Major: 253 Minor: 3  CLAIMED: IBLOCK
>>>        udev_path: /dev/vg_R0_p1/lv_R0_p1_l2
>>>        \-------> r0_lun1
>>>        Status: ACTIVATED  Execute/Left/Max Queue Depth: 0/32/32
>>> SectorSize: 512  MaxSectors: 1024
>>>        iBlock device: dm-2  UDEV PATH: /dev/vg_R0_p1/lv_R0_p1_l1
>>>        Major: 253 Minor: 2  CLAIMED: IBLOCK
>>>        udev_path: /dev/vg_R0_p1/lv_R0_p1_l1
>>>        \-------> r0_lun0
>>>        Status: ACTIVATED  Execute/Left/Max Queue Depth: 0/32/32
>>> SectorSize: 512  MaxSectors: 1024
>>>        iBlock device: dm-1  UDEV PATH: /dev/vg_R0_p1/lv_R0_p1_l0
>>>        Major: 253 Minor: 1  CLAIMED: IBLOCK
>>>        udev_path: /dev/vg_R0_p1/lv_R0_p1_l0
>>>
>>> When any significant I/O load is put on any of the devices, I receive
>>> a flood of the following messages:
>>>
>>>> Nov 11 13:46:09 dut kernel: BUG: scheduling while atomic:
>>>> LIO_iblock/4439/0x00000101
>>>> Nov 11 13:46:09 dut kernel: Modules linked in: fcoe libfcoe
>>>> target_core_stgt target_core_pscsi target_core_file target_core_iblock
>>>> ipt_MASQUERADE iptable_nat nf_nat bridge stp llc autofs4 tcm_fc libfc
>>>> scsi_transport_fc scsi_tgt target_core_mod configfs sunrpc ipv6
>>>> dm_mirror dm_region_hash dm_log kvm_intel kvm uinput ixgbe ioatdma
>>>> iTCO_wdt ses enclosure i2c_i801 i2c_core iTCO_vendor_support mdio sg
>>>> igb dca pcspkr evbug evdev ext4 mbcache jbd2 sd_mod crc_t10dif
>>>> pata_acpi ata_generic mpt2sas scsi_transport_sas ata_piix raid_class
>>>> dm_mod [last unloaded: speedstep_lib]
>>>> Nov 11 13:46:09 dut kernel: Pid: 4439, comm: LIO_iblock Not tainted
>>>> 2.6.36+ #1
>>>> Nov 11 13:46:09 dut kernel: Call Trace:
>>>> Nov 11 13:46:09 dut kernel: <IRQ>  [<ffffffff8104fb96>]
>>>> __schedule_bug+0x66/0x70
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff8149779c>] schedule+0xa2c/0xa60
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81497d73>]
>>>> schedule_timeout+0x173/0x2e0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81071200>] ?
>>>> process_timeout+0x0/0x10
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81497f3e>]
>>>> schedule_timeout_interruptible+0x1e/0x20
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81072b39>]
>>>> msleep_interruptible+0x39/0x50
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa033ebfa>]
>>>> transport_generic_handle_data+0x2a/0x80 [target_core_mod]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa03c33ee>]
>>>> ft_recv_write_data+0x1fe/0x2b0 [tcm_fc]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa03c13cb>] ft_recv_seq+0x8b/0xc0
>>>> [tcm_fc]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa03a0e1f>]
>>>> fc_exch_recv+0x61f/0xe20 [libfc]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813c1123>] ?
>>>> skb_copy_bits+0x63/0x2c0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813c15ea>] ?
>>>> __pskb_pull_tail+0x26a/0x360
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa015b86d>]
>>>> fcoe_recv_frame+0x18d/0x340 [fcoe]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813c13df>] ?
>>>> __pskb_pull_tail+0x5f/0x360
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813c0404>] ?
>>>> __netdev_alloc_skb+0x24/0x50
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa015e52a>] fcoe_rcv+0x2aa/0x44c
>>>> [fcoe]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff8113c897>] ?
>>>> __kmalloc_node_track_caller+0x67/0xe0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813c0404>] ?
>>>> __netdev_alloc_skb+0x24/0x50
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813cd39a>]
>>>> __netif_receive_skb+0x41a/0x5d0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81012699>] ? read_tsc+0x9/0x20
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813ceab8>]
>>>> netif_receive_skb+0x58/0x80
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813cec20>]
>>>> napi_skb_finish+0x50/0x70
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813cf1a5>]
>>>> napi_gro_receive+0xc5/0xd0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa0207a1f>]
>>>> ixgbe_clean_rx_irq+0x31f/0x840 [ixgbe]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa02083a6>]
>>>> ixgbe_clean_rxtx_many+0x136/0x240 [ixgbe]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813cf382>]
>>>> net_rx_action+0x102/0x250
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81068af2>]
>>>> __do_softirq+0xb2/0x240
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff8100c07c>] call_softirq+0x1c/0x30
>>>> Nov 11 13:46:09 dut kernel: <EOI>  [<ffffffff8100db25>] ?
>>>> do_softirq+0x65/0xa0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81068664>]
>>>> local_bh_enable+0x94/0xa0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff813cdfd3>]
>>>> dev_queue_xmit+0x143/0x3b0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa015d96e>] fcoe_xmit+0x30e/0x520
>>>> [fcoe]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa03a2a13>] ?
>>>> _fc_frame_alloc+0x33/0x90 [libfc]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa039f904>] fc_seq_send+0xb4/0x140
>>>> [libfc]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa03c1722>]
>>>> ft_write_pending+0x112/0x160 [tcm_fc]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa0347800>]
>>>> transport_generic_new_cmd+0x280/0x2b0 [target_core_mod]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa03479d4>]
>>>> transport_processing_thread+0x1a4/0x7c0 [target_core_mod]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff810835d0>] ?
>>>> autoremove_wake_function+0x0/0x40
>>>> Nov 11 13:46:09 dut kernel: [<ffffffffa0347830>] ?
>>>> transport_processing_thread+0x0/0x7c0 [target_core_mod]
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81082f36>] kthread+0x96/0xa0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff8100bf84>]
>>>> kernel_thread_helper+0x4/0x10
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff81082ea0>] ? kthread+0x0/0xa0
>>>> Nov 11 13:46:09 dut kernel: [<ffffffff8100bf80>] ?
>>>> kernel_thread_helper+0x0/0x10
>>>
>>> I started noticing these issues first when I ran I/O with larger
>>> filesizes (appr. 25GB), but I'm thinking that might be a red herring.
>>> I'll rebuild the kernel and tools to make sure nothing is out of sorts
>>> and will report on any additional findings.
>>>
>>> Thanks,
>>>
>>> Frank
>>
>> FCP data frames are coming in at the interrupt level, and TCM expects
>> to be called in a thread or non-interrupt context, since
>> transport_generic_handle_data() may sleep.
>>
>> A quick workaround would be to change the fast path in fcoe_rcv() so that
>> data always goes through the per-cpu receive threads.   That avoids part of the
>> problem, but isn't anything like the right fix.  It doesn't seem good to
>> let TCM block FCoE's per-cpu receive thread either.
>>
>> Here's a quick change if you want to just work around the problem.
>> I haven't tested it:
>>
>> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
>> index feddb53..8f854cd 100644
>> --- a/drivers/scsi/fcoe/fcoe.c
>> +++ b/drivers/scsi/fcoe/fcoe.c
>> @@ -1285,6 +1285,7 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
>>  	 * BLOCK softirq context.
>>  	 */
>>  	if (fh->fh_type == FC_TYPE_FCP &&
>> +	    0 &&
>>  	    cpu == smp_processor_id() &&
>>  	    skb_queue_empty(&fps->fcoe_rx_list)) {
>>  		spin_unlock_bh(&fps->fcoe_rx_list.lock);
>>
>> ---
>>
>> 	Cheers,
>> 	Joe
>>
>>
>>
>>
>> _______________________________________________
>> devel mailing list
>> devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
>> _______________________________________________
>> devel mailing list
>> devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
>> http://www.open-fcoe.org/mailman/listinfo/devel
> 
