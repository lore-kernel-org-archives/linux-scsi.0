From: Bruce Coulter <bcoulter@visidon.com>
Subject: iscsi_ttx kernel issues on 3.10.0-327.28.3.el7.x86_64
Date: Fri, 16 Sep 2016 02:08:39 +0000 (UTC)
Message-ID: <alpine.LRH.2.20.1609160156430.8921@pluto.express.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

linux-scsi, target-devel,

We're noticing consistent kernel lock-up issues with RH 3.10 kernels, esp. 
while dm targets are under concurrent load from iscsi and local disk 
access.  Issue is reproducible with load on disks over time.  Sample call 
trace below; what additional information can I help to provide on this?

   [1084022.512107] Call Trace:
   [1084022.512108]  [<ffffffff8163da5b>] _raw_spin_unlock_bh+0x1b/0x40
   [1084022.512112]  [<ffffffffa07f1e7b>]
     iscsit_free_r2ts_from_list+0x7b/0x90 [iscsi_target_mod]
   [1084022.512115]  [<ffffffffa07f2c48>] __iscsit_free_cmd+0x1f8/0x250
     [iscsi_target_mod]
   [1084022.512118]  [<ffffffffa07f2d08>] iscsit_free_cmd+0x68/0x150
     [iscsi_target_mod]
   [1084022.512121]  [<ffffffffa07fa273>]
     iscsit_close_connection+0x413/0x820 [iscsi_target_mod]
   [1084022.512123]  [<ffffffffa07e8183>]
     iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
   [1084022.512126]  [<ffffffffa07f8aa8>]
     iscsi_target_tx_thread+0x1d8/0x200 [iscsi_target_mod]
   [1084022.512127]  [<ffffffff810a6ae0>] ? wake_up_atomic_t+0x30/0x30

Thanks,


--
Visidon, LLC - http://www.visidon.com/ - support@visidon.com
Expert cloud, open source software, and Linux consulting services
