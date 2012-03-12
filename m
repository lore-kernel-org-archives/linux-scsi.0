From: "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/10] fcoe: avoid getting into
 dev_queue_xmit with bottom halves disabled
Date: Mon, 12 Mar 2012 22:51:40 +0000
Message-ID: <4F5E7DFB.8030508@intel.com>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
 <20120309224942.6515.83069.stgit@localhost6.localdomain6>
 <4F5A9754.6080009@broadcom.com> <4F5A9C53.5040200@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4F5A9C53.5040200-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Content-ID: <AC5A384B0E63E8498E728C60E878F7E9-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.open-fcoe.org/mailman/options/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.open-fcoe.org/mailman/listinfo/devel>,
 <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 03/09/2012 04:12 PM, Love, Robert W wrote:
> On 03/09/2012 03:50 PM, Bhanu Prakash Gollapudi wrote:
>> On 3/9/2012 2:49 PM, Robert Love wrote:
>>> From: Neil Horman<nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
>>>
>>> Recieved this warning recently:
>>>
>>> WARNING: at kernel/softirq.c:143 local_bh_enable+0x7d/0xb0() (Not
>>> tainted)
>>> Hardware name: C6100
>>> Modules linked in: autofs4 bnx2fc cnic uio fcoe libfcoe libfc
>>> scsi_transport_fc
>>> scsi_tgt 8021q garp stp llc sunrpc cpufreq_ondemand acpi_cpufreq
>>> freq_table
>>> mperf ipv6 ixgbe mdio igb dcdbas microcode i2c_i801 i2c_core sg iTCO_wdt
>>> iTCO_vendor_support ioatdma dca i7core_edac edac_core shpchp ext4
>>> mbcache jbd2
>>> sd_mod crc_t10dif ahci dm_mirror dm_region_hash dm_log dm_mod [last
>>> unloaded:
>>> scsi_wait_scan]
>>> Pid: 4926, comm: fc_rport_eq Not tainted 2.6.32 #2
>>> Call Trace:
>>>    [<ffffffff81069c67>] ? warn_slowpath_common+0x87/0xc0
>>>    [<ffffffff81069cba>] ? warn_slowpath_null+0x1a/0x20
>>>    [<ffffffff8107216d>] ? local_bh_enable+0x7d/0xb0
>>>    [<ffffffff81433567>] ? dev_queue_xmit+0x177/0x6c0
>>>    [<ffffffffa0293a34>] ? vlan_dev_hwaccel_hard_start_xmit+0x84/0xb0
>>> [8021q]
>>>    [<ffffffff8142f46c>] ? dev_hard_start_xmit+0x2bc/0x3f0
>>>    [<ffffffff8143392e>] ? dev_queue_xmit+0x53e/0x6c0
>>>    [<ffffffff8142348e>] ? __skb_clone+0x2e/0x120
>>>    [<ffffffffa02ea83d>] ? fcoe_clean_pending_queue+0xcd/0x100 [libfcoe]
>>>    [<ffffffff810559ca>] ? find_busiest_group+0x9aa/0xb20
>>>    [<ffffffffa02f7624>] ? fcoe_port_send+0x24/0x50 [fcoe]
>>>    [<ffffffffa02f9568>] ? fcoe_xmit+0x228/0x3e0 [fcoe]
>>>    [<ffffffffa02c1896>] ? fc_seq_send+0xb6/0x160 [libfc]
>>>    [<ffffffffa02c1a76>] ? fc_exch_abort_locked+0x136/0x1c0 [libfc]
>>>    [<ffffffffa02c1ca7>] ? fc_exch_mgr_reset+0x147/0x2a0 [libfc]
>>>    [<ffffffff814f2c7e>] ? _spin_unlock_irq+0xe/0x20
>>>    [<ffffffffa02c91d3>] ? fc_rport_work+0x123/0x5f0 [libfc]
>>>    [<ffffffffa02c90b0>] ? fc_rport_work+0x0/0x5f0 [libfc]
>>>    [<ffffffff8108b559>] ? worker_thread+0x179/0x2a0
>>>    [<ffffffff81090ea0>] ? autoremove_wake_function+0x0/0x40
>>>    [<ffffffff8108b3e0>] ? worker_thread+0x0/0x2a0
>>>    [<ffffffff81090b56>] ? kthread+0x96/0xa0
>>>    [<ffffffff8100c10a>] ? child_rip+0xa/0x20
>>>    [<ffffffff81090ac0>] ? kthread+0x0/0xa0
>>>    [<ffffffff8100c100>] ? child_rip+0x0/0x20
>>>
>>> fc_exch_abort_locked attempts to send an abort frame, but it does so
>>> with a
>>> spinlock held and irqs/bh's disabled.  Because of this dev_queue_xmit
>>> issues a
>>> warning. This patch allows the fc_exch_abort_locked to drop and
>>> re-acquire the
>>> lock so that the warning is suppressed.
>>>
>>> Note this isn't a great fix, given that we need to free and
>>> re-acquire the
>>> ex_lock during the fc_exch_abort_locked operation, but any other
>>> solution is
>>> going to be a fairly major undertaking I think.  This should work
>>> until a proper
>>> fix can be found.
>>>
>>> Signed-off-by: Neil Horman<nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
>>> Signed-off-by: Robert Love<robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Robert,  This patch is not required based on what we discussed in this
>> thread..
>> http://lists.open-fcoe.org/pipermail/devel/2012-February/011946.html
>>
>> Neil provided "fcoe: Ensure fcoe_recv_frame is always called in
>> process context" instead of the two patches he submitted initially.
>> http://lists.open-fcoe.org/pipermail/devel/2012-February/011962.html
>>
> Thanks for pointing this out Bhanu, I overlooked the last comment in the
> discussion of this patch.
>
> James, I believe the correct patch is 02/10 in this series, so I think
> you should be able to drop this patch and we'll be back on track. If
> you'd like me to resend the series without this patch please let me
> know. I'll check to make sure 02/10 through 10/10 apply without 01/10
> and resend if I have to make changes.
FYI, patches 02/10 through 10/10 all applied for me without patch 01/10. 
You should be able to drop this patch and the rest of the series should 
be fine.

Thanks, //Rob
