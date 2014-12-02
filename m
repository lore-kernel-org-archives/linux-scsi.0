From: Alex Thorlton <athorlton@sgi.com>
Subject: [BUG] kzalloc overflow in lpfc driver on 6k core system
Date: Tue, 2 Dec 2014 15:58:10 -0600
Message-ID: <20141202215810.GT4720@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alex Thorlton <athorlton@sgi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey guys,

We've recently upgraded our big machine up to 6144 cores, and we're
shaking out a number of bugs related to booting at that large core
count.  Last night I tripped a warning from the lpfc driver that appears
to be related to a kzalloc that uses the number of cores as part of it's
size calculation.  Here's the backtrace from the warning:

--------------------------------------------------------------------                                                                                                                                                                                                         
2199382.828437 (    0.005216)| lpfc 0003:02:00.0: enabling device (0140 -> 0142)                                                                                                                                                                                             
2199382.999272 (    0.170835)| ------------[ cut here ]------------                                                                                                                                                                                                          
2199382.999337 (    0.000065)| WARNING: CPU: 84 PID: 404 at mm/slab_common.c:653 kmalloc_slab+0x2f/0x89()                                                                                                                                                                    
2199383.004534 (    0.005197)| Modules linked in: lpfc(+) usbcore(+) mptctl scsi_transport_fc sg lpc_ich i2c_i801 usb_common tpm_tis mfd_core tpm acpi_cpufreq button scsi_dh_alua scsi_dh_rdacusbcore: registered new device driver usb                                     
2199383.020568 (    0.016034)|                                                                                                                                                                                                                                               
2199383.020581 (    0.000013)|  scsi_dh_hp_sw scsi_dh_emc scsi_dh gru thermal sata_nv processor piix fan thermal_sysehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                                                                               
2199383.035288 (    0.014707)|                                                                                                                                                                                                                                               
2199383.035306 (    0.000018)|  hwmon ata_piix                                                                                                                                                                                                                               
2199383.035336 (    0.000030)| CPU: 84 PID: 404 Comm: kworker/84:0 Not tainted 3.18.0-rc2-gat-00106-ga7ca10f-dirty #178                                                                                                                                                      
2199383.047077 (    0.011741)| ehci-pci: EHCI PCI platform driver                                                                                                                                                                                                            
2199383.047134 (    0.000057)| Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013                                                                                                                                                                
2199383.056245 (    0.009111)| Workqueue: events work_for_cpu_fn                                                                                                                                                                                                             
2199383.066174 (    0.009929)|  000000000000028d ffff88eef827bbe8 ffffffff815a542f 000000000000028d                                                                                                                                                                          
2199383.069545 (    0.003371)|  ffffffff810ea142 ffff88eef827bc28 ffffffff8104365c ffff88eefe4006c8                                                                                                                                                                          
2199383.076214 (    0.006669)|  0000000000000000 00000000000080d0 0000000000000000 0000000000000004                                                                                                                                                                          
2199383.079213 (    0.002999)| Call Trace:                                                                                                                                                                                                                                   
2199383.084084 (    0.004871)|  [<ffffffff815a542f>] dump_stack+0x49/0x62                                                                                                                                                                                                    
2199383.087283 (    0.003199)|  [<ffffffff810ea142>] ? kmalloc_slab+0x2f/0x89                                                                                                                                                                                                
2199383.091415 (    0.004132)|  [<ffffffff8104365c>] warn_slowpath_common+0x77/0x92                                                                                                                                                                                          
2199383.095197 (    0.003782)|  [<ffffffff8104368c>] warn_slowpath_null+0x15/0x17                                                                                                                                                                                            
2199383.103336 (    0.008139)|  [<ffffffff810ea142>] kmalloc_slab+0x2f/0x89                                                                                                                                                                                                  
2199383.107082 (    0.003746)|  [<ffffffff8110fd9e>] __kmalloc+0x13/0x16a                                                                                                                                                                                                    
2199383.112531 (    0.005449)|  [<ffffffffa01a8ed9>] lpfc_pci_probe_one_s4+0x105b/0x1644 [lpfc]                                                                                                                                                                              
2199383.115316 (    0.002785)|  [<ffffffff81302b92>] ? pci_bus_read_config_dword+0x75/0x87                                                                                                                                                                                   
2199383.123431 (    0.008115)|  [<ffffffffa01a951f>] lpfc_pci_probe_one+0x5d/0xcb5 [lpfc]                                                                                                                                                                                    
2199383.127364 (    0.003933)|  [<ffffffff81497119>] ? dbs_check_cpu+0x168/0x177                                                                                                                                                                                             
2199383.136438 (    0.009074)|  [<ffffffff81496fa5>] ? gov_queue_work+0xb4/0xc0                                                                                                                                                                                              
2199383.140407 (    0.003969)|  [<ffffffff8130b2a1>] local_pci_probe+0x1e/0x52                                                                                                                                                                                               
2199383.143105 (    0.002698)|  [<ffffffff81052c47>] work_for_cpu_fn+0x13/0x1b                                                                                                                                                                                               
2199383.147315 (    0.004210)|  [<ffffffff81054965>] process_one_work+0x222/0x35e                                                                                                                                                                                            
2199383.151379 (    0.004064)|  [<ffffffff81054e76>] worker_thread+0x3d5/0x46e                                                                                                                                                                                               
2199383.159402 (    0.008023)|  [<ffffffff81054aa1>] ? process_one_work+0x35e/0x35e                                                                                                                                                                                          
2199383.163097 (    0.003695)|  [<ffffffff810599c6>] kthread+0xc8/0xd2                                                                                                                                                                                                       
2199383.167476 (    0.004379)|  [<ffffffff810598fe>] ? kthread_freezable_should_stop+0x5b/0x5b                                                                                                                                                                               
2199383.176434 (    0.008958)|  [<ffffffff815a8cac>] ret_from_fork+0x7c/0xb0                                                                                                                                                                                                 
2199383.180086 (    0.003652)|  [<ffffffff810598fe>] ? kthread_freezable_should_stop+0x5b/0x5b                                                                                                                                                                               
2199383.192333 (    0.012247)| ehci-pci 0000:00:1a.0: EHCI Host Controller                                                                                                                                                                                                   
--------------------------------------------------------------------

For a little bit more information on exactly what's going wrong, we're
tripping the warning from lpfc_pci_probe_one_s4 (as you can see from the
trace).  That function calls down to lpfc_sli4_driver_resource_setup,
which contains the failing kzalloc here:

phba->sli4_hba.cpu_map = kzalloc((sizeof(struct lpfc_vector_map_info) *
                                 phba->sli4_hba.num_present_cpu),
                                 GFP_KERNEL);

As mentioned, it looks like we're multiplying the number available cpus
by that struct size to get an allocation size, which ends up being
greater than KMALLOC_MAX_SIZE.

Does anyone have any ideas on what could be done to break that
allocation up into smaller pieces, or to make it in a different way so
that we avoid this warning?

Any help is greatly appreciated.  Thanks!

- Alex 
