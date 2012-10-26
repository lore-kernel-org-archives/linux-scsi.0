From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: tcm_fc+ libfcoe regression on v3.7-rc2
Date: Fri, 26 Oct 2012 16:33:20 -0700
Message-ID: <1351294400.13631.22.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: openfcoe-devel <devel@open-fcoe.org>, "Rustad, Mark D" <mark.d.rustad@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Vasu Dev <vasu.dev@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi MDR, Robert & Co,

During the process of updating target-pending.git/master to v3.7-rc2
this afternoon, I noticed the following warnings below when using
tcm_fc.

The Poison overwritten appears during each I/O, but the LUN SCAN + I/O
are seem to be still working as expected..

AFAICT there has not been anything effecting tcm_fc that has gone in
recently, so it looks like some type of libfcoe or libfc regression.

Any ideas where to start looking to track this down..?

Thanks,

--nab

[ 3930.920161] =============================================================================
[ 3930.929274] BUG libfc_em (Tainted: G    B       ): Poison overwritten
[ 3930.936447] -----------------------------------------------------------------------------
[ 3930.936447] 
[ 3930.947203] INFO: 0xffff8806e04f0004-0xffff8806e04f0004. First byte 0x6a instead of 0x6b
[ 3930.956219] INFO: Allocated in mempool_alloc_slab+0x10/0x12 age=9 cpu=3 pid=25401
[ 3930.964556] INFO: Freed in mempool_free_slab+0x12/0x14 age=11 cpu=3 pid=18291
[ 3930.972506] INFO: Slab 0xffffea001b813c00 objects=42 used=42 fp=0x          (null) flags=0x8000000000004080
[ 3930.983360] INFO: Object 0xffff8806e04f0000 @offset=0 fp=0xffff8806e04f3d80
[ 3930.983360] 
[ 3930.992762] Object ffff8806e04f0000: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkjkkkkkkkkkkk
[ 3931.003132] Object ffff8806e04f0010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.013500] Object ffff8806e04f0020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.023868] Object ffff8806e04f0030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.034235] Object ffff8806e04f0040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.044605] Object ffff8806e04f0050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.054973] Object ffff8806e04f0060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.065341] Object ffff8806e04f0070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.075709] Object ffff8806e04f0080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.086080] Object ffff8806e04f0090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.096448] Object ffff8806e04f00a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.106816] Object ffff8806e04f00b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.117184] Object ffff8806e04f00c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.127552] Object ffff8806e04f00d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.137921] Object ffff8806e04f00e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ 3931.148290] Object ffff8806e04f00f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[ 3931.158659] Redzone ffff8806e04f0100: bb bb bb bb bb bb bb bb                          ........
[ 3931.168351] Padding ffff8806e04f0140: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[ 3931.178816] Padding ffff8806e04f0150: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[ 3931.189282] Padding ffff8806e04f0160: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[ 3931.199747] Padding ffff8806e04f0170: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[ 3931.210213] Pid: 25402, comm: fcoethread/4 Tainted: G    B        3.7.0-rc2+ #51
[ 3931.218452] Call Trace:
[ 3931.221175]  [<ffffffff810b08cc>] print_trailer+0x126/0x12f
[ 3931.227381]  [<ffffffff810b0dfe>] check_bytes_and_report+0xb2/0xeb
[ 3931.234267]  [<ffffffff81088dbb>] ? mempool_alloc_slab+0xf/0x12
[ 3931.240860]  [<ffffffff810b0eec>] check_object+0xb5/0x1df
[ 3931.246873]  [<ffffffff81088dbc>] ? mempool_alloc_slab+0x10/0x12
[ 3931.253565]  [<ffffffff810b1a69>] alloc_debug_processing+0xa4/0x138
[ 3931.260547]  [<ffffffff810b3150>] T.1679+0x28d/0x2d9
[ 3931.266075]  [<ffffffff81088dbc>] ? mempool_alloc_slab+0x10/0x12
[ 3931.272767]  [<ffffffff81088dbc>] ? mempool_alloc_slab+0x10/0x12
[ 3931.279458]  [<ffffffff810b330c>] kmem_cache_alloc+0x4d/0xa0
[ 3931.285763]  [<ffffffff81088dbc>] mempool_alloc_slab+0x10/0x12
[ 3931.292258]  [<ffffffff81088ee6>] mempool_alloc+0x5a/0x139
[ 3931.298369]  [<ffffffff810b0f72>] ? check_object+0x13b/0x1df
[ 3931.304674]  [<ffffffffa03d673a>] fc_exch_em_alloc+0x25/0x1f6 [libfc]
[ 3931.311850]  [<ffffffffa03d6c62>] fc_seq_lookup_recip+0x17c/0x347 [libfc]
[ 3931.319413]  [<ffffffffa03d6eac>] fc_seq_assign+0x7f/0x9c [libfc]
[ 3931.326202]  [<ffffffffa067829e>] ft_recv_req+0x76/0x14c [tcm_fc]
[ 3931.332991]  [<ffffffffa0679f1c>] ft_recv+0x129/0x132 [tcm_fc]
[ 3931.339490]  [<ffffffffa03db815>] fc_lport_recv_req+0x68/0xc5 [libfc]
[ 3931.346667]  [<ffffffffa03d8ecd>] fc_exch_recv+0xaed/0xbb0 [libfc]
[ 3931.353552]  [<ffffffffa06b9cc4>] ? fcoe_percpu_thread_create+0x7b/0x7b [fcoe]
[ 3931.361600]  [<ffffffffa06ba05c>] fcoe_percpu_receive_thread+0x398/0x46f [fcoe]
[ 3931.369744]  [<ffffffffa06b9cc4>] ? fcoe_percpu_thread_create+0x7b/0x7b [fcoe]
[ 3931.377790]  [<ffffffff81043f56>] kthread+0xb0/0xb8
[ 3931.383224]  [<ffffffff81043ea6>] ? kthread_freezable_should_stop+0x60/0x60
[ 3931.390979]  [<ffffffff81362c7c>] ret_from_fork+0x7c/0xb0
[ 3931.396993]  [<ffffffff81043ea6>] ? kthread_freezable_should_stop+0x60/0x60
[ 3931.404749] FIX libfc_em: Restoring 0xffff8806e04f0004-0xffff8806e04f0004=0x6b
[ 3931.404749] 
[ 3931.414441] FIX libfc_em: Marking all objects used
