From: Jonas Stoehr <jonass@dev.jsje.de>
Subject: PROBLEM: MegaRAID SCSI fails to initialize due to double-freeing IRQ
 58
Date: Thu, 15 Feb 2018 11:37:36 +0100
Message-ID: <74acc15a-7bc6-8478-f46a-1e073d6bdc43@dev.jsje.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trinity.jsje.de ([136.243.152.71]:34982 "EHLO mail.jsje.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030219AbeBOKms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Feb 2018 05:42:48 -0500
Received: from [10.1.0.4] (p3EE07528.dip0.t-ipconnect.de [62.224.117.40])
        by mail.jsje.de (Postfix) with ESMTPSA id 0C6B7A60BFD
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 11:37:36 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1.] The initlialization of the megaraid_sas module fails with the 
message "Trying to free already-free IRQ 58".

[2.] With the latest kernel used by CoreOS stable (4.14.16), the 
megaraid_sas module does not properly initialize. Disks connected to the 
controller (well, virtual ones at least) are not visible to the system. 
The controller is also completely inaccessible from storcli (read: it 
says there's 0 controllers in the system).

[3.] Keywords: megaraid_sas sas raid megacli storcli

[4.] Linux version 4.14.16-coreos (jenkins@jenkins-worker-1) (gcc 
version 4.9.4 (Gentoo Hardened 4.9.4 p1.0, pie-0.6.4)) #1 SMP Thu Feb 1 
20:38:35 UTC 2018

[5.] OOPs output: ?

[6.] The problem triggers during boot, so there is not really a way for 
me to reproduce it other than rebooting.

[7.] Environment
[7.1.] ver_linux output
Linux docker-srv.home.local 4.14.16-coreos #1 SMP Thu Feb 1 20:38:35 UTC 
2018 x86_64 AMD Ryzen 7 1700 Eight-Core Processor AuthenticAMD GNU/Linux

Util-linux              2.30.2
Mount                   2.30.2
Module-init-tools       21
E2fsprogs               1.43.3
Xfsprogs                4.9.0
Quota-tools             4.03
Nfs-utils               1.3.2
Linux C Library         2.23
Dynamic linker (ldd)    2.23
Linux C++ Library       6.0.20
Procps                  3.3.9
Net-tools               1.60
Sh-utils                8.25
Udev                    235
Modules Loaded          acpi_cpufreq aes_x86_64 aesni_intel ahci 
br_netfilter bridge button crc32c_generic crc32c_intel cryptd 
crypto_simd dax dm_log dm_mirror dm_mod dm_region_hash edac_core 
edac_mce_amd evdev glue_helper i2c_core i2c_piix4 ipt_MASQUERADE 
iptable_filter iptable_nat irqbypass kvm libahci libata libcrc32c llc 
loop megaraid_sas mii nf_conntrack nf_conntrack_ipv4 
nf_conntrack_netlink nf_defrag_ipv4 nf_nat nf_nat_ipv4 
nf_nat_masquerade_ipv4 nfnetlink overlay r8169 sch_fq_codel scsi_mod 
squashfs stp usb_common usbcore veth xfrm_algo xfrm_user xhci_hcd 
xhci_pci xt_addrtype xt_conntrack

[7.2.] Processor information (from /proc/cpuinfo):
[Basically it's a Ryzen 1700. The infamous Ryzen bug is unlikely the 
cause, as it worked with a buggy processor using an older kernel version 
(though I don't know which one) before and this one is a replacement 
shipped after I filed an RMA due to other stability issues]
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 3002.701
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 3017.718
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2550.346
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 1
cpu cores       : 8
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2555.928
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 1
cpu cores       : 8
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 4
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2764.669
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 2
cpu cores       : 8
apicid          : 4
initial apicid  : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 5
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2782.758
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 2
cpu cores       : 8
apicid          : 5
initial apicid  : 5
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 6
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2567.791
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 3
cpu cores       : 8
apicid          : 6
initial apicid  : 6
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 7
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2792.540
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 3
cpu cores       : 8
apicid          : 7
initial apicid  : 7
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 8
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2549.968
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 4
cpu cores       : 8
apicid          : 8
initial apicid  : 8
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 9
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2550.815
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 4
cpu cores       : 8
apicid          : 9
initial apicid  : 9
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 10
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2546.525
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 5
cpu cores       : 8
apicid          : 10
initial apicid  : 10
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 11
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2556.506
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 5
cpu cores       : 8
apicid          : 11
initial apicid  : 11
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 12
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2552.053
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 6
cpu cores       : 8
apicid          : 12
initial apicid  : 12
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 13
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 2554.295
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 6
cpu cores       : 8
apicid          : 13
initial apicid  : 13
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 14
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 3035.011
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 7
cpu cores       : 8
apicid          : 14
initial apicid  : 14
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

processor       : 15
vendor_id       : AuthenticAMD
cpu family      : 23
model           : 1
model name      : AMD Ryzen 7 1700 Eight-Core Processor
stepping        : 1
microcode       : 0x800111c
cpu MHz         : 3190.566
cache size      : 512 KB
physical id     : 0
siblings        : 16
core id         : 7
cpu cores       : 8
apicid          : 15
initial apicid  : 15
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid 
extd_apicid aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 
sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit wdt 
tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb 
hw_pstate sme retpoline retpoline_amd vmmcall fsgsbase bmi1 avx2 smep 
bmi2 rdseed adx smap clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves 
clzero irperf xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale 
vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
bugs            : sysret_ss_attrs null_seg spectre_v1 spectre_v2
bogomips        : 5988.27
TLB size        : 2560 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate eff_freq_ro [13] [14]

[7.3.] Module information (from /proc/modules):
veth 16384 0 - Live 0x0000000000000000
ipt_MASQUERADE 16384 1 - Live 0x0000000000000000
nf_nat_masquerade_ipv4 16384 1 ipt_MASQUERADE, Live 0x0000000000000000
nf_conntrack_netlink 40960 0 - Live 0x0000000000000000
nfnetlink 16384 2 nf_conntrack_netlink, Live 0x0000000000000000
xfrm_user 45056 1 - Live 0x0000000000000000
xfrm_algo 16384 1 xfrm_user, Live 0x0000000000000000
iptable_nat 16384 1 - Live 0x0000000000000000
nf_conntrack_ipv4 16384 3 - Live 0x0000000000000000
nf_defrag_ipv4 16384 1 nf_conntrack_ipv4, Live 0x0000000000000000
nf_nat_ipv4 16384 1 iptable_nat, Live 0x0000000000000000
xt_addrtype 16384 2 - Live 0x0000000000000000
iptable_filter 16384 1 - Live 0x0000000000000000
xt_conntrack 16384 1 - Live 0x0000000000000000
nf_nat 32768 2 nf_nat_masquerade_ipv4,nf_nat_ipv4, Live 0x0000000000000000
nf_conntrack 131072 7 
ipt_MASQUERADE,nf_nat_masquerade_ipv4,nf_conntrack_netlink,nf_conntrack_ipv4,nf_nat_ipv4,xt_conntrack,nf_nat, 
Live 0x0000000000000000
libcrc32c 16384 2 nf_nat,nf_conntrack, Live 0x0000000000000000
crc32c_generic 16384 0 - Live 0x0000000000000000
br_netfilter 24576 0 - Live 0x0000000000000000
bridge 151552 1 br_netfilter, Live 0x0000000000000000
stp 16384 1 bridge, Live 0x0000000000000000
llc 16384 2 bridge,stp, Live 0x0000000000000000
overlay 77824 1 - Live 0x0000000000000000
edac_mce_amd 28672 0 - Live 0x0000000000000000
edac_core 49152 0 - Live 0x0000000000000000
evdev 28672 2 - Live 0x0000000000000000
i2c_piix4 24576 0 - Live 0x0000000000000000
kvm 593920 0 - Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
i2c_core 61440 1 i2c_piix4, Live 0x0000000000000000
button 16384 0 - Live 0x0000000000000000
acpi_cpufreq 24576 0 - Live 0x0000000000000000
sch_fq_codel 20480 1 - Live 0x0000000000000000
squashfs 57344 1 - Live 0x0000000000000000
loop 32768 2 - Live 0x0000000000000000
crc32c_intel 20480 1 - Live 0x0000000000000000
ahci 40960 0 - Live 0x0000000000000000
xhci_pci 16384 0 - Live 0x0000000000000000
libahci 36864 1 ahci, Live 0x0000000000000000
xhci_hcd 212992 1 xhci_pci, Live 0x0000000000000000
aesni_intel 163840 0 - Live 0x0000000000000000
libata 237568 2 ahci,libahci, Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
megaraid_sas 151552 0 - Live 0x0000000000000000
crypto_simd 16384 1 aesni_intel, Live 0x0000000000000000
cryptd 24576 2 aesni_intel,crypto_simd, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
usbcore 241664 2 xhci_pci,xhci_hcd, Live 0x0000000000000000
r8169 81920 0 - Live 0x0000000000000000
scsi_mod 221184 2 libata,megaraid_sas, Live 0x0000000000000000
mii 16384 1 r8169, Live 0x0000000000000000
usb_common 16384 1 usbcore, Live 0x0000000000000000
dm_mirror 28672 0 - Live 0x0000000000000000
dm_region_hash 16384 1 dm_mirror, Live 0x0000000000000000
dm_log 20480 2 dm_mirror,dm_region_hash, Live 0x0000000000000000
dm_mod 126976 2 dm_mirror,dm_log, Live 0x0000000000000000
dax 24576 1 dm_mod, Live 0x0000000000000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-0000 : PCI Bus 0000:00
   0000-0000 : dma1
   0000-0000 : pic1
   0000-0000 : timer0
   0000-0000 : timer1
   0000-0000 : keyboard
   0000-0000 : PNP0800:00
   0000-0000 : keyboard
   0000-0000 : rtc0
   0000-0000 : dma page reg
   0000-0000 : pic2
   0000-0000 : dma2
   0000-0000 : fpu
   0000-0000 : pnp 00:03
   0000-0000 : pnp 00:03
   0000-0000 : pnp 00:03
0000-0000 : PCI Bus 0000:00
   0000-0000 : vga+
0000-0000 : PCI Bus 0000:00
   0000-0000 : serial
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
     0000-0000 : ACPI PM1a_EVT_BLK
     0000-0000 : ACPI PM1a_CNT_BLK
     0000-0000 : ACPI PM_TMR
     0000-0000 : ACPI CPU throttle
     0000-0000 : ACPI GPE0_BLK
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
     0000-0000 : piix4_smbus
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
   0000-0000 : pnp 00:05
     0000-0000 : smba_idx
   0000-0000 : pnp 00:05
0000-0000 : PCI conf1
0000-0000 : PCI Bus 0000:00
   0000-0000 : PCI Bus 0000:03
     0000-0000 : PCI Bus 0000:1d
       0000-0000 : PCI Bus 0000:23
         0000-0000 : PCI Bus 0000:24
           0000-0000 : PCI Bus 0000:26
           0000-0000 : 0000:26:00.0
           0000-0000 : r8169
           0000-0000 : PCI Bus 0000:25
           0000-0000 : 0000:25:00.0
           0000-0000 : r8169
       0000-0000 : PCI Bus 0000:29
         0000-0000 : 0000:29:00.0
       0000-0000 : PCI Bus 0000:28
         0000-0000 : 0000:28:00.0
           0000-0000 : r8169
   0000-0000 : PCI Bus 0000:2a
     0000-0000 : 0000:2a:00.0

00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : PCI Bus 0000:00
00000000-00000000 : PCI Bus 0000:00
   00000000-00000000 : Video ROM
   00000000-00000000 : Adapter ROM
   00000000-00000000 : Adapter ROM
00000000-00000000 : Reserved
   00000000-00000000 : System ROM
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : ACPI Tables
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : ACPI Tables
00000000-00000000 : System RAM
00000000-00000000 : ACPI Non-volatile Storage
00000000-00000000 : Reserved
00000000-00000000 : System RAM
00000000-00000000 : Reserved
00000000-00000000 : PCI Bus 0000:00
   00000000-00000000 : PCI Bus 0000:03
     00000000-00000000 : PCI Bus 0000:1d
       00000000-00000000 : PCI Bus 0000:29
         00000000-00000000 : 0000:29:00.0
         00000000-00000000 : 0000:29:00.0
       00000000-00000000 : PCI Bus 0000:23
         00000000-00000000 : PCI Bus 0000:24
           00000000-00000000 : PCI Bus 0000:26
           00000000-00000000 : 0000:26:00.0
           00000000-00000000 : r8169
           00000000-00000000 : PCI Bus 0000:25
           00000000-00000000 : 0000:25:00.0
           00000000-00000000 : r8169
   00000000-00000000 : PCI Bus 0000:03
     00000000-00000000 : PCI Bus 0000:1d
       00000000-00000000 : PCI Bus 0000:29
         00000000-00000000 : 0000:29:00.0
         00000000-00000000 : 0000:29:00.1
       00000000-00000000 : PCI Bus 0000:23
         00000000-00000000 : PCI Bus 0000:24
           00000000-00000000 : PCI Bus 0000:26
           00000000-00000000 : 0000:26:00.0
           00000000-00000000 : r8169
           00000000-00000000 : PCI Bus 0000:25
           00000000-00000000 : 0000:25:00.0
           00000000-00000000 : r8169
       00000000-00000000 : PCI Bus 0000:28
         00000000-00000000 : 0000:28:00.0
           00000000-00000000 : r8169
         00000000-00000000 : 0000:28:00.0
           00000000-00000000 : r8169
       00000000-00000000 : PCI Bus 0000:22
         00000000-00000000 : 0000:22:00.0
           00000000-00000000 : xhci-hcd
     00000000-00000000 : 0000:03:00.1
     00000000-00000000 : 0000:03:00.1
       00000000-00000000 : ahci
     00000000-00000000 : 0000:03:00.0
       00000000-00000000 : xhci-hcd
   00000000-00000000 : PCI Bus 0000:2b
     00000000-00000000 : 0000:2b:00.3
       00000000-00000000 : xhci-hcd
     00000000-00000000 : 0000:2b:00.2
     00000000-00000000 : 0000:2b:00.2
   00000000-00000000 : PCI Bus 0000:2c
     00000000-00000000 : 0000:2c:00.3
     00000000-00000000 : 0000:2c:00.2
       00000000-00000000 : ahci
   00000000-00000000 : PCI Bus 0000:2a
     00000000-00000000 : 0000:2a:00.0
     00000000-00000000 : 0000:2a:00.0
     00000000-00000000 : 0000:2a:00.0
00000000-00000000 : PCI MMCONFIG 0000 [bus 00-3f]
   00000000-00000000 : Reserved
     00000000-00000000 : pnp 00:00
00000000-00000000 : Reserved
00000000-00000000 : Reserved
00000000-00000000 : Reserved
   00000000-00000000 : pnp 00:01
   00000000-00000000 : IOAPIC 0
   00000000-00000000 : IOAPIC 1
00000000-00000000 : Reserved
   00000000-00000000 : pnp 00:05
00000000-00000000 : Reserved
   00000000-00000000 : AMDIF030:00
00000000-00000000 : Reserved
   00000000-00000000 : HPET 0
     00000000-00000000 : PNP0103:00
00000000-00000000 : Reserved
00000000-00000000 : Reserved
   00000000-00000000 : AMDI0030:00
00000000-00000000 : pnp 00:05
00000000-00000000 : Reserved
00000000-00000000 : Reserved
00000000-00000000 : Reserved
   00000000-00000000 : Local APIC
     00000000-00000000 : pnp 00:05
00000000-00000000 : Reserved
   00000000-00000000 : pnp 00:05
00000000-00000000 : System RAM
   00000000-00000000 : Kernel code
   00000000-00000000 : Kernel data
   00000000-00000000 : Kernel bss
00000000-00000000 : RAM buffer

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1450
         Subsystem: ASUSTeK Computer Inc. Device 8747
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Device 1451
         Subsystem: Advanced Micro Devices, Inc. [AMD] Device 1451
         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 255
         Capabilities: [40] Secure device <?>
         Capabilities: [64] MSI: Enable- Count=1/4 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [74] HyperTransport: MSI Mapping Enable+ Fixed+

00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1452
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.3 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 1453 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=03, subordinate=29, sec-latency=0
         I/O behind bridge: 0000b000-0000efff
         Memory behind bridge: f6000000-f76fffff
         Prefetchable memory behind bridge: 
00000000e8000000-00000000f22fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #1, Speed 8GT/s, Width x4, ASPM L1, Exit 
Latency L0s <512ns, L1 <64us
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState+
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible+
                 RootCap: CRSVisible+
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, 
LTR-, OBFF Not Supported ARIFwd+
                 DevCtl2: Completion Timeout: 65ms to 210ms, 
TimeoutDis-, LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Device 8747
         Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [270 v1] #19
         Capabilities: [370 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- 
ASPM_L1.1+ L1_PM_Substates+
         Capabilities: [3c4 v1] #23
         Kernel driver in use: pcieport

00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1452
         DeviceName:  Onboard IGD
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:03.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1452
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:03.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 1453 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=2a, subordinate=2a, sec-latency=0
         I/O behind bridge: 0000f000-0000ffff
         Memory behind bridge: f7c00000-f7cfffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 512 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L1, Exit 
Latency L0s <512ns, L1 <64us
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState+
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible+
                 RootCap: CRSVisible+
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, 
LTR-, OBFF Not Supported ARIFwd+
                 DevCtl2: Completion Timeout: 65ms to 210ms, 
TimeoutDis-, LTR-, OBFF Disabled ARIFwd+
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] Subsystem: ASUSTeK Computer Inc. Device 8747
         Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [270 v1] #19
         Capabilities: [370 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2- PCI-PM_L1.1+ ASPM_L1.2- 
ASPM_L1.1+ L1_PM_Substates+
         Capabilities: [3c4 v1] #23
         Kernel driver in use: pcieport

00:04.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1452
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:07.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1452
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:07.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 1454 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 26
         Bus: primary=00, secondary=2b, subordinate=2b, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: f7800000-f7afffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible+
                 RootCap: CRSVisible+
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] Subsystem: Advanced Micro Devices, Inc. 
[AMD] Device 1454
         Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [270 v1] #19
         Kernel driver in use: pcieport

00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1452
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 1454 
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 27
         Bus: primary=00, secondary=2c, subordinate=2c, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: f7b00000-f7bfffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible+
                 RootCap: CRSVisible+
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] Subsystem: Advanced Micro Devices, Inc. 
[AMD] Device 1454
         Capabilities: [c8] HyperTransport: MSI Mapping Enable+ Fixed+
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [270 v1] #19
         Kernel driver in use: pcieport

00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller 
(rev 59)
         Subsystem: ASUSTeK Computer Inc. FCH SMBus Controller
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Kernel driver in use: piix4_smbus
         Kernel modules: i2c_piix4

00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge 
(rev 51)
         Subsystem: ASUSTeK Computer Inc. FCH LPC Bridge
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0

00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1460
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1461
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1462
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1463
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1464
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1465
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1466
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1467
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-

03:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] Device 43bb 
(rev 02) (prog-if 30 [XHCI])
         Subsystem: ASMedia Technology Inc. Device 1142
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 59
         Region 0: Memory at f76a0000 (64-bit, non-prefetchable) [size=32K]
         Capabilities: [50] MSI: Enable+ Count=1/8 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4054
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <2us
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Capabilities: [200 v1] #19
         Capabilities: [300 v1] Latency Tolerance Reporting
                 Max snoop latency: 0ns
                 Max no snoop latency: 0ns
         Capabilities: [400 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=0us 
PortTPowerOnTime=10us
         Kernel driver in use: xhci_hcd
         Kernel modules: xhci_pci

03:00.1 SATA controller: Advanced Micro Devices, Inc. [AMD] Device 43b7 
(rev 02) (prog-if 01 [AHCI 1.0])
         Subsystem: ASMedia Technology Inc. Device 1062
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 60
         Region 5: Memory at f7680000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at f7600000 [disabled] [size=512K]
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4064
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <2us
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 16384 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Kernel driver in use: ahci
         Kernel modules: ahci

03:00.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43b2 (rev 
02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin C routed to IRQ 28
         Bus: primary=03, secondary=1d, subordinate=29, sec-latency=0
         I/O behind bridge: 0000b000-0000efff
         Memory behind bridge: f6000000-f75fffff
         Prefetchable memory behind bridge: 
00000000e8000000-00000000f22fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40a1
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Upstream Port, MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ 
SlotPowerLimit 0.000W
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x4, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x4, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 0201
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Kernel driver in use: pcieport

1d:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43b4 (rev 
02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 29
         Bus: primary=1d, secondary=22, subordinate=22, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: f7500000-f75fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40b1
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 5GT/s, Width x2, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #1, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState+
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 3306
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Capabilities: [200 v1] #19
         Capabilities: [400 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=0us 
PortTPowerOnTime=10us
         Kernel driver in use: pcieport

1d:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43b4 (rev 
02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 30
         Bus: primary=1d, secondary=23, subordinate=26, sec-latency=0
         I/O behind bridge: 0000b000-0000cfff
         Memory behind bridge: f7200000-f73fffff
         Prefetchable memory behind bridge: 
00000000f2100000-00000000f22fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40c1
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #1, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState+
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 3306
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Capabilities: [200 v1] #19
         Capabilities: [400 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=0us 
PortTPowerOnTime=10us
         Kernel driver in use: pcieport

1d:05.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43b4 (rev 
02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 32
         Bus: primary=1d, secondary=27, subordinate=27, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40e1
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D3 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s unlimited, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #1, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 3306
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Capabilities: [200 v1] #19
         Capabilities: [400 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=0us 
PortTPowerOnTime=10us
         Kernel driver in use: pcieport

1d:06.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43b4 (rev 
02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 33
         Bus: primary=1d, secondary=28, subordinate=28, sec-latency=0
         I/O behind bridge: 0000e000-0000efff
         Memory behind bridge: f7400000-f74fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4022
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn+ PwrCtrl+ MRL- AttnInd+ PwrInd+ 
HotPlug+ Surprise-
                         Slot #1, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Off, PwrInd Off, Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState+
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 3306
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Capabilities: [200 v1] #19
         Capabilities: [400 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=0us 
PortTPowerOnTime=10us
         Kernel driver in use: pcieport

1d:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43b4 (rev 
02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 35
         Bus: primary=1d, secondary=29, subordinate=29, sec-latency=0
         I/O behind bridge: 0000d000-0000dfff
         Memory behind bridge: f6000000-f70fffff
         Prefetchable memory behind bridge: 
00000000e8000000-00000000f1ffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4052
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #7, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #1, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet+ LinkState+
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 3306
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap- ChkEn-
         Capabilities: [200 v1] #19
         Capabilities: [400 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=0us 
PortTPowerOnTime=10us
         Kernel driver in use: pcieport

22:00.0 USB controller: ASMedia Technology Inc. Device 1343 (prog-if 30 
[XHCI])
         Subsystem: ASUSTeK Computer Inc. Device 86f2
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 63
         Region 0: Memory at f7500000 (64-bit, non-prefetchable) [size=32K]
         Capabilities: [50] MSI: Enable+ Count=1/8 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4094
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <2us
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #1, Speed 5GT/s, Width x2, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x2, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR+, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [200 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap- CGenEn- 
ChkCap- ChkEn-
         Capabilities: [280 v1] #19
         Capabilities: [300 v1] Latency Tolerance Reporting
                 Max snoop latency: 0ns
                 Max no snoop latency: 0ns
         Kernel driver in use: xhci_hcd
         Kernel modules: xhci_pci

23:00.0 PCI bridge: ASMedia Technology Inc. Device 1182 (prog-if 00 
[Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 36
         Bus: primary=23, secondary=24, subordinate=26, sec-latency=0
         I/O behind bridge: 0000b000-0000cfff
         Memory behind bridge: f7200000-f73fffff
         Prefetchable memory behind bridge: 
00000000f2100000-00000000f22fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4062
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Upstream Port, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ 
SlotPowerLimit 26.000W
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 118f
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [200 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 1f, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Capabilities: [300 v1] Vendor Specific Information: ID=0000 
Rev=0 Len=c00 <?>
         Kernel driver in use: pcieport

24:03.0 PCI bridge: ASMedia Technology Inc. Device 1182 (prog-if 00 
[Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 37
         Bus: primary=24, secondary=25, subordinate=25, sec-latency=0
         I/O behind bridge: 0000c000-0000cfff
         Memory behind bridge: f7300000-f73fffff
         Prefetchable memory behind bridge: 
00000000f2200000-00000000f22fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4072
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #3, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState+
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 118f
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [200 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 1f, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Kernel driver in use: pcieport

24:07.0 PCI bridge: ASMedia Technology Inc. Device 1182 (prog-if 00 
[Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 38
         Bus: primary=24, secondary=26, subordinate=26, sec-latency=0
         I/O behind bridge: 0000b000-0000bfff
         Memory behind bridge: f7200000-f72fffff
         Prefetchable memory behind bridge: 
00000000f2100000-00000000f21fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4082
         Capabilities: [78] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [80] Express (v2) Downstream Port (Slot+), MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0
                         ExtTag+ RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #7, Speed 5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <2us, L1 unlimited
                         ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp+
                 LnkCtl: ASPM Disabled; Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug- Surprise-
                         Slot #7, PowerLimit 26.000W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState+
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported ARIFwd-
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled ARIFwd-
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-, Selectable De-emphasis: -6dB
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [c0] Subsystem: ASMedia Technology Inc. Device 118f
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [200 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 1f, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Kernel driver in use: pcieport

25:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 
PCI Express Gigabit Ethernet Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 39
         Region 0: I/O ports at c000 [size=256]
         Region 2: Memory at f7300000 (64-bit, non-prefetchable) [size=4K]
         Region 4: Memory at f2200000 (64-bit, prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4092
         Capabilities: [70] Express (v2) Endpoint, MSI 01
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s unlimited, L1 <64us
                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, 
LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                 Vector table: BAR=4 offset=00000000
                 PBA: BAR=4 offset=00000800
         Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
                 Not readable
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Capabilities: [140 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
         Kernel driver in use: r8169
         Kernel modules: r8169

26:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 07)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 
PCI Express Gigabit Ethernet Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 40
         Region 0: I/O ports at b000 [size=256]
         Region 2: Memory at f7200000 (64-bit, non-prefetchable) [size=4K]
         Region 4: Memory at f2100000 (64-bit, prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40a2
         Capabilities: [70] Express (v2) Endpoint, MSI 01
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s unlimited, L1 <64us
                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, 
LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                 Vector table: BAR=4 offset=00000000
                 PBA: BAR=4 offset=00000800
         Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
                 Not readable
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Capabilities: [140 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
         Kernel driver in use: r8169
         Kernel modules: r8169

28:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
         Subsystem: ASUSTeK Computer Inc. RTL8111/8168/8411 PCI Express 
Gigabit Ethernet Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 42
         Region 0: I/O ports at e000 [size=256]
         Region 2: Memory at f7404000 (64-bit, non-prefetchable) [size=4K]
         Region 4: Memory at f7400000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40c2
         Capabilities: [70] Express (v2) Endpoint, MSI 01
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 <64us
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s unlimited, L1 <64us
                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, 
LTR+, OBFF Via message/WAKE#
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
                 Vector table: BAR=4 offset=00000000
                 PBA: BAR=4 offset=00000800
         Capabilities: [100 v2] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap+ CGenEn- 
ChkCap+ ChkEn-
         Capabilities: [140 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [160 v1] Device Serial Number 01-00-00-00-68-4c-e0-00
         Capabilities: [170 v1] Latency Tolerance Reporting
                 Max snoop latency: 0ns
                 Max no snoop latency: 0ns
         Capabilities: [178 v1] L1 PM Substates
                 L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ 
ASPM_L1.1+ L1_PM_Substates+
                           PortCommonModeRestoreTime=150us 
PortTPowerOnTime=150us
         Kernel driver in use: r8169
         Kernel modules: r8169

29:00.0 VGA compatible controller: NVIDIA Corporation Device 128b (rev 
a1) (prog-if 00 [VGA controller])
         Subsystem: ZOTAC International (MCO) Ltd. Device 5360
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 5
         Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at e8000000 (64-bit, prefetchable) [size=128M]
         Region 3: Memory at f0000000 (64-bit, prefetchable) [size=32M]
         Region 5: I/O ports at d000 [size=128]
         Expansion ROM at 000c0000 [disabled] [size=128K]
         Capabilities: [60] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [78] Express (v2) Legacy Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 <64us
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #7, Speed 5GT/s, Width x8, ASPM not 
supported, Exit Latency L0s <512ns, L1 <4us
                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range AB, TimeoutDis+, 
LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [128 v1] Power Budgeting <?>
         Capabilities: [600 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=024 <?>

29:00.1 Audio device: NVIDIA Corporation GK208 HDMI/DP Audio Controller 
(rev a1)
         Subsystem: ZOTAC International (MCO) Ltd. GK208 HDMI/DP Audio 
Controller
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 11
         Region 0: Memory at f7080000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [60] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [78] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
unlimited, L1 <64us
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #7, Speed 5GT/s, Width x8, ASPM not 
supported, Exit Latency L0s <512ns, L1 <4us
                         ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range AB, TimeoutDis+, 
LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkSta2: Current De-emphasis Level: -6dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-

2a:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 
[Thunderbolt] (rev 05)
         Subsystem: IBM ServeRAID M5110 SAS/SATA Controller
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin A routed to IRQ 41
         Region 0: I/O ports at f000 [size=256]
         Region 1: Memory at f7c60000 (64-bit, non-prefetchable) [size=16K]
         Region 3: Memory at f7c00000 (64-bit, non-prefetchable) [size=256K]
         Expansion ROM at f7c40000 [disabled] [size=128K]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [68] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 4096 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+ 
FLReset-
                         MaxPayload 512 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L0s, Exit 
Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Range BC, TimeoutDis+, 
LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [d0] Vital Product Data
pcilib: sysfs_read_vpd: read failed: Input/output error
                 Not readable
         Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] MSI-X: Enable- Count=16 Masked-
                 Vector table: BAR=1 offset=00002000
                 PBA: BAR=1 offset=00003000
         Capabilities: [100 v2] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 00, GenCap- CGenEn- 
ChkCap- ChkEn-
         Capabilities: [1e0 v1] #19
         Capabilities: [1c0 v1] Power Budgeting <?>
         Capabilities: [190 v1] #16
         Capabilities: [148 v1] Alternative Routing-ID Interpretation (ARI)
                 ARICap: MFVC- ACS-, Next Function: 0
                 ARICtl: MFVC- ACS-, Function Group: 0
         Kernel modules: megaraid_sas

2b:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, 
Inc. [AMD] Device 145a
         Subsystem: Advanced Micro Devices, Inc. [AMD] Device 145a
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [270 v1] #19

2b:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Device 
1456
         Subsystem: Advanced Micro Devices, Inc. [AMD] Device 1456
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 11
         Region 2: Memory at f7900000 (32-bit, non-prefetchable) [size=1M]
         Region 5: Memory at f7a00000 (32-bit, non-prefetchable) [size=8K]
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/2 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [c0] MSI-X: Enable- Count=2 Masked-
                 Vector table: BAR=5 offset=00000000
                 PBA: BAR=5 offset=00001000
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>

2b:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Device 145c 
(prog-if 30 [XHCI])
         Subsystem: ASUSTeK Computer Inc. Device 8747
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin C routed to IRQ 65
         Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=1M]
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable+ Count=1/8 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 40b4
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Kernel driver in use: xhci_hcd
         Kernel modules: xhci_pci

2c:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, 
Inc. [AMD] Device 1455
         Subsystem: Advanced Micro Devices, Inc. [AMD] Device 1455
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- 
SpeedDis-
                          Transmit Margin: Normal Operating Range, 
EnterModifiedCompliance- ComplianceSOS-
                          Compliance De-emphasis: -6dB
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete+, EqualizationPhase1+
                          EqualizationPhase2+, EqualizationPhase3+, 
LinkEqualizationRequest-
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Capabilities: [270 v1] #19

2c:00.2 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA 
Controller [AHCI mode] (rev 51) (prog-if 01 [AHCI 1.0])
         Subsystem: ASUSTeK Computer Inc. FCH SATA Controller [AHCI mode]
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 62
         Region 5: Memory at f7b08000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable+ Count=1/16 Maskable- 64bit+
                 Address: 00000000fee00000  Data: 4084
         Capabilities: [d0] SATA HBA v1.0 InCfgSpace
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>
         Kernel driver in use: ahci
         Kernel modules: ahci

2c:00.3 Audio device: Advanced Micro Devices, Inc. [AMD] Device 1457
         Subsystem: ASUSTeK Computer Inc. Device 86c7
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin C routed to IRQ 5
         Region 0: Memory at f7b00000 (32-bit, non-prefetchable) [size=32K]
         Capabilities: [48] Vendor Specific Information: Len=08 <?>
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [64] Express (v2) Endpoint, MSI 00
                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s 
<4us, L1 unlimited
                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 256 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 8GT/s, Width x16, ASPM L0s L1, 
Exit Latency L0s <64ns, L1 <1us
                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 8GT/s, Width x16, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 DevCap2: Completion Timeout: Not Supported, 
TimeoutDis-, LTR-, OBFF Not Supported
                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, 
LTR-, OBFF Disabled
                 LnkSta2: Current De-emphasis Level: -3.5dB, 
EqualizationComplete-, EqualizationPhase1-
                          EqualizationPhase2-, EqualizationPhase3-, 
LinkEqualizationRequest-
         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                 Address: 0000000000000000  Data: 0000
         Capabilities: [100 v1] Vendor Specific Information: ID=0001 
Rev=1 Len=010 <?>

[7.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:

(probably because there's no disks connected to the motherboard's SATA 
bus and the LSI controller's are not enumerated)

[7.7.] Other information that might be relevant to the problem (please 
look in /proc and include all information that you think to be relevant):
excerpt from dmesg:
|[ 25.781991] Trying to free already-free IRQ 58
[ 25.781992] ------------[ cut here ]------------
[ 25.781992] WARNING: CPU: 13 PID: 366 at 
../source/kernel/irq/manage.c:1531 __free_irq+0x2b1/0x2f0
[ 25.781993] Modules linked in: ahci xhci_pci libahci xhci_hcd 
aesni_intel libata aes_x86_64 megaraid_sas(+) crypto_simd cryptd 
glue_helper usbcore r8169 scsi_mod mii usb_common dm_mirror 
dm_region_hash dm_log dm_mod dax
[ 25.781996] CPU: 13 PID: 366 Comm: systemd-udevd Tainted: G W 
4.14.16-coreos #1
[ 25.781996] Hardware name: System manufacturer System Product 
Name/PRIME B350M-A, BIOS 0604 04/06/2017
[ 25.781997] task: ffffa078a9e51e40 task.stack: ffffc05bc20e4000
[ 25.781997] RIP: 0010:__free_irq+0x2b1/0x2f0
[ 25.781998] RSP: 0018:ffffc05bc20e7a18 EFLAGS: 00010086
[ 25.781998] RAX: 0000000000000022 RBX: 000000000000003a RCX: 
0000000000000001
[ 25.781999] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 
0000000000000096
[ 25.781999] RBP: ffffa07a0b32e400 R08: 0000000000000000 R09: 
0000000000000022
[ 25.782000] R10: ffffc05bc20e7950 R11: 0000000000000000 R12: 
000000000000003a
[ 25.782000] R13: ffffa07a0b32e608 R14: ffffa07a0b32e514 R15: 
ffffa079f28ee4d8
[ 25.782001] FS: 00007f73c7ee6900(0000) GS:ffffa07a0e940000(0000) 
knlGS:0000000000000000
[ 25.782002] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 25.782003] CR2: 00007f73c6e95940 CR3: 00000003f2d90000 CR4: 
00000000003406e0
[ 25.782003] Call Trace:
[ 25.782005] free_irq+0x33/0x60
[ 25.782007] megasas_sriov_heartbeat_handler+0x9a5/0x1090 [megaraid_sas]
[ 25.782009] megasas_setup_jbod_map+0x13cc/0x2330 [megaraid_sas]
[ 25.782010] local_pci_probe+0x3f/0xa0
[ 25.782011] ? pci_assign_irq+0x27/0x120
[ 25.782012] pci_device_probe+0x14b/0x1b0
[ 25.782014] driver_probe_device+0x29f/0x460
[ 25.782015] __driver_attach+0xd6/0xe0
[ 25.782016] ? driver_probe_device+0x460/0x460
[ 25.782017] bus_for_each_dev+0x67/0xb0
[ 25.782018] bus_add_driver+0x40/0x260
[ 25.782019] driver_register+0x57/0xd0
[ 25.782020] init_module+0xc4/0x1000 [megaraid_sas]
[ 25.782021] ? 0xffffffffc0307000
[ 25.782022] do_one_initcall+0x4e/0x1a0
[ 25.782023] ? kmem_cache_alloc_trace+0xa5/0x1b0
[ 25.782024] ? do_init_module+0x22/0x1fb
[ 25.782025] do_init_module+0x5a/0x1fb
[ 25.782026] load_module+0x247e/0x2930
[ 25.782028] ? SYSC_finit_module+0x94/0xe0
[ 25.782029] SYSC_finit_module+0x94/0xe0
[ 25.782030] do_syscall_64+0x59/0x1c0
[ 25.782031] entry_SYSCALL64_slow_path+0x25/0x25
[ 25.782032] RIP: 0033:0x7f73c6f4a5e9
[ 25.782032] RSP: 002b:00007ffe53982368 EFLAGS: 00000246 ORIG_RAX: 
0000000000000139
[ 25.782033] RAX: ffffffffffffffda RBX: 0000556bd9c5b4e0 RCX: 
00007f73c6f4a5e9
[ 25.782033] RDX: 0000000000000000 RSI: 00007f73c768cd24 RDI: 
000000000000000e
[ 25.782033] RBP: 00007f73c768cd24 R08: 0000000000000000 R09: 
0000556bd9c5b460
[ 25.782034] R10: 000000000000000e R11: 0000000000000246 R12: 
0000000000000000
[ 25.782034] R13: 0000556bd9c62f80 R14: 0000000000020000 R15: 
000000000aba9500
[ 25.782035] Code: 00 48 89 c3 e9 18 fe ff ff 4c 89 f7 ff d2 48 8b 85 b0 
00 00 00 e9 4e ff ff ff 44 89 e6 48 c7 c7 68 0a df 96 31 c0 e8 fc dc ff 
ff <0f> ff 48 8b 34 24 4c 89 f7 e8 d1 58 53 00 48 8b 85 b0 00 00 00
[ 25.782048] ---[ end trace c3ff49e5354fc7e0 ]---
[ 25.782106] megaraid_sas 0000:2a:00.0: Failed from megasas_init_fw 5523|


I was told to report this to the "upstream maintainers" (I hope I got 
the right list here) here from 
https://github.com/coreos/bugs/issues/2360. Further conversation can be 
found there, though I doubt there is information there that is not 
included here.

Also please notice I have never reported a bug to a mailing list before, 
let alone the kernel's mailing lists, so please let me know, if I did 
something wrong or when further information is needed.

Thanks in advance for reading through that wall of text.

Sincerely
Jonas
