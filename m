From: Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH] target: Use WARNON_NON_RT(!irqs_disabled())
Date: Wed, 21 Mar 2018 12:38:54 -0300
Message-ID: <20180321153854.GB24312@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, linux-rt-users <linux-rt-users@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, linux-scsi@vger.kernel.org, Daniel Bristot de Oliveira <daniel@bristot.me>, Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= <lclaudio@redhat.com>, Clark Williams <williams@redhat.com>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

	We got a report where this WARN_ON got triggered:

[ 7552.799997] ------------[ cut here ]------------
[ 7552.800016] WARNING: CPU: 7 PID: 1090 at drivers/target/target_core_transport.c:3009 __transport_check_aborted_status+0x153/0x190 [target_core_mod]
[ 7552.800037] Modules linked in: target_core_user uio target_core_pscsi target_core_file target_core_iblock ib_srpt ib_srp scsi_transport_srp scsi_tgt xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge stp llc ib_isert iscsi_target_mod target_core_mod ib_ucm rpcrdma mlx5_ib sunrpc rdma_ucm ib_uverbs ib_iser rdma_cm iw_cm libiscsi ib_umad ib_ipoib scsi_transport_iscsi ib_cm sb_edac intel_powerclamp coretemp intel_rapl iosf_mbi crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd iTCO_wdt iTCO_vendor_support hfi1 ipmi_ssif sg rdmavt ib_core hpilo hpwdt
  pcspkr ipmi_si
[ 7552.800055]  ipmi_devintf ipmi_msghandler wmi acpi_power_meter ioatdma dca shpchp pcc_cpufreq lpc_ich ip_tables xfs libcrc32c mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_common crc32c_intel serio_raw ata_generic pata_acpi mlx5_core ata_piix tg3 drm devlink libata i2c_core ptp hpsa scsi_transport_sas pps_core dm_mirror dm_region_hash dm_log dm_mod [last unloaded: ib_srpt]
[ 7552.800058] CPU: 7 PID: 1090 Comm: kworker/7:1H Not tainted 3.10.0-768.rt56.699.el7.x86_64 #1
[ 7552.800058] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 11/14/2013
[ 7552.800066] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[ 7552.800067] Call Trace:
[ 7552.800075]  [<ffffffffb76cd055>] dump_stack+0x19/0x1b
[ 7552.800078]  [<ffffffffb70807bb>] __warn+0xfb/0x120
[ 7552.800080]  [<ffffffffb70808fd>] warn_slowpath_null+0x1d/0x20
[ 7552.800085]  [<ffffffffc0ab3983>] __transport_check_aborted_status+0x153/0x190 [target_core_mod]
[ 7552.800091]  [<ffffffffc0ab5c04>] target_execute_cmd+0x34/0x2e0 [target_core_mod]
[ 7552.800096]  [<ffffffffc0ab5fc2>] transport_generic_new_cmd+0x112/0x240 [target_core_mod]
[ 7552.800100]  [<ffffffffc0ab6132>] transport_handle_cdb_direct+0x42/0x90 [target_core_mod]
[ 7552.800105]  [<ffffffffc0ab62cd>] target_submit_cmd_map_sgls+0x14d/0x210 [target_core_mod]
[ 7552.800107]  [<ffffffffc09c15b4>] srpt_handle_new_iu+0x254/0x660 [ib_srpt]
[ 7552.800109]  [<ffffffffc09c1bc8>] srpt_recv_done+0x38/0x60 [ib_srpt]
[ 7552.800113]  [<ffffffffc07a5fb5>] __ib_process_cq+0x65/0xe0 [ib_core]
[ 7552.800118]  [<ffffffffc07a60a0>] ib_cq_poll_work+0x20/0x60 [ib_core]
[ 7552.800120]  [<ffffffffb70a4336>] process_one_work+0x176/0x4a0
[ 7552.800121]  [<ffffffffb70a50ec>] worker_thread+0x16c/0x3f0
[ 7552.800123]  [<ffffffffb70a4f80>] ? manage_workers.isra.36+0x2b0/0x2b0
[ 7552.800125]  [<ffffffffb70ac62f>] kthread+0xcf/0xe0
[ 7552.800139]  [<ffffffffb70ac560>] ? kthread_worker_fn+0x170/0x170
[ 7552.800151]  [<ffffffffb76dd1d8>] ret_from_fork+0x58/0x90
[ 7552.800153]  [<ffffffffb70ac560>] ? kthread_worker_fn+0x170/0x170
[ 7552.800154] ---[ end trace 0000000000000002 ]---
[ 7554.164964] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.231254] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.294860] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.360810] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.421867] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.485931] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.546909] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.607820] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.671883] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[ 7554.730826] srpt/0xf4521403000e4aa0f4521403000e4ad0: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.

static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
        __releases(&cmd->t_state_lock)
        __acquires(&cmd->t_state_lock)
{
        int ret;

        assert_spin_locked(&cmd->t_state_lock);
        WARN_ON_ONCE_NONRT(!irqs_disabled());
<SNIP>

And it is called just from these two places:

int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
{
        int ret;

        spin_lock_irq(&cmd->t_state_lock);
        ret = __transport_check_aborted_status(cmd, send_status);
        spin_unlock_irq(&cmd->t_state_lock);

        return ret;
}
EXPORT_SYMBOL(transport_check_aborted_status);

And:

void target_execute_cmd(struct se_cmd *cmd)
{
        /*
         * Determine if frontend context caller is requesting the stopping of
         * this command for frontend exceptions.
         *
         * If the received CDB has aleady been aborted stop processing it here.
         */
        spin_lock_irq(&cmd->t_state_lock);
        if (__transport_check_aborted_status(cmd, 1)) {
                spin_unlock_irq(&cmd->t_state_lock);
                return;
        }
<SNIP>

Since cmd->t_state_lock becomes a sleeping spin lock on RT, that thing
triggers, turn it into a NONRT WARN_ON, a kernel built with this patch
passes the test case that lead to a BZ being filled for the kernel-rt
package:

https://bugzilla.redhat.com/show_bug.cgi?id=1512875

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

---

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4558f2e1fe1b..318453e7adfd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3204,7 +3204,7 @@ static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 	int ret;
 
 	assert_spin_locked(&cmd->t_state_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	WARN_ON_ONCE_NONRT(!irqs_disabled());
 
 	if (!(cmd->transport_state & CMD_T_ABORTED))
 		return 0;
