From: Brian Minton <brian.j.minton@usps.gov>,
	Brian Minton <bminton@efn.org>
Subject: oops while trying to burn multiple CDs simultaneously using ide scsi emulation
Date: Wed, 28 Jul 2004 11:23:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040728152305.GA21481@irp-bminton.eng.usps.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from maileast16.srvs.usps.gov ([56.0.103.16]:24301 "EHLO
	maileast16.srvs.usps.gov") by vger.kernel.org with ESMTP
	id S267223AbUG1PXO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2004 11:23:14 -0400
Received: from rlghncsu1e0.usps.gov (ral-e1000.13 [56.88.106.13])
	by maileast16.srvs.usps.gov (Postfix) with SMTP id 00DA11ADBB1
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jul 2004 15:23:06 +0000 (UTC)
Received: from bminton by irp-bminton.eng.usps.gov with local (Exim 4.34)
	id 1BpqGn-0005ad-Kp
	for linux-scsi@vger.kernel.org; Wed, 28 Jul 2004 11:23:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am not subscribed, so please reply off list.

Stock Debian 2.6.7-1-686-smp kernel.
Single processor Pentium 4

/proc/cpuinfo 
processor   : 0
vendor_id   : GenuineIntel
cpu family  : 15
model       : 0
model name  : Intel(R) Pentium(R) 4 CPU 1600MHz
stepping    : 10
cpu MHz     : 1603.775
cache size  : 256 KB
physical id : 0
siblings    : 1
fdiv_bug    : no
hlt_bug     : no
f00f_bug    : no
coma_bug    : no
fpu     : yes
fpu_exception   : yes
cpuid level : 2
wp      : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
bogomips    : 3170.30

I was attempting to burn multiple CDs like so (using bash):
mkisofs -iso-level 3 .|tee >(cdrecord dev=1,0,0 -v -eject -) |cdrecord
dev=0,0,0 -v -eject -

One of the burns succeeded, the other got to about 90%


Here are the modules I have loaded:
lsmod
Module                  Size  Used by
sr_mod                 18212  1 
sg                     40000  0 
ide_scsi               18020  0 
scsi_mod              127492  3 sr_mod,sg,ide_scsi
nls_cp437               5920  0 
isofs                  36124  0 
cdrom                  40768  1 sr_mod
tsdev                   7552  0 
mousedev               10704  2 
psmouse                20616  0 
parport_pc             35840  1 
lp                     11524  0 
parport                43272  2 parport_pc,lp
autofs                 18304  2 
binfmt_misc            11240  1 
ds                     18820  0 
yenta_socket           21664  0 
pcmcia_core            68804  2 ds,yenta_socket
ipv6                  272160  29 
nfs                   199484  1 
lockd                  64936  2 nfs
sunrpc                159364  4 nfs,lockd
ipt_ttl                 2144  0 
ipt_tos                 1856  0 
ipt_tcpmss              2528  0 
ipt_recent             11820  0 
ipt_pkttype             1920  0 
ipt_physdev             2416  0 
ipt_owner               4704  0 
ipt_multiport           2272  0 
ipt_mark                1920  0 
ipt_mac                 2208  0 
ipt_limit               2848  0 
ipt_length              1920  0 
ipt_iprange             2048  0 
ipt_esp                 2208  0 
ipt_ecn                 2464  0 
ipt_dscp                1920  0 
ipt_ah                  2208  0 
ipt_ULOG                8104  0 
ipt_TOS                 2752  0 
ipt_TCPMSS              4640  0 
ipt_REJECT              7136  0 
ipt_MARK                2336  0 
ipt_LOG                 6880  0 
ipt_ECN                 3680  0 
ipt_DSCP                2784  0 
ipt_CLASSIFY            2400  0 
ip_queue               11960  0 
iptable_mangle          3104  0 
iptable_filter          3104  0 
ip_tables              19328  28
ipt_ttl,ipt_tos,ipt_tcpmss,ipt_recent,ipt_pkttype,ipt_physdev,ipt_owner,ipt_multiport,ipt_mark,ipt_mac,ipt_limit,ipt_length,ipt_iprange,ipt_esp,ipt_ecn,ipt_dscp,ipt_ah,ipt_ULOG,ipt_TOS,ipt_TCPMSS,ipt_REJECT,ipt_MARK,ipt_LOG,ipt_ECN,ipt_DSCP,ipt_CLASSIFY,iptable_mangle,iptable_filter
cls_fw                  6464  0 
sch_cbq                19488  0 
sch_gred                7616  0 
sch_red                 5472  0 
sch_sfq                 6208  0 
af_packet              23912  4 
snd_ens1371            26340  0 
snd_rawmidi            25984  1 snd_ens1371
snd_seq_device          8456  1 snd_rawmidi
snd_pcm               102944  1 snd_ens1371
snd_page_alloc         12008  1 snd_pcm
snd_timer              27300  1 snd_pcm
snd_ac97_codec         70884  1 snd_ens1371
snd                    59108  6
snd_ens1371,snd_rawmidi,snd_seq_device,snd_pcm,snd_timer,snd_ac97_codec
es1371                 40832  0 
soundcore              10880  2 snd,es1371
gameport                5120  2 snd_ens1371,es1371
ac97_codec             19212  1 es1371
8139too                27488  0 
8139cp                 22080  0 
mii                     5344  2 8139too,8139cp
crc32                   4544  2 8139too,8139cp
uhci_hcd               33776  0 
jedec_probe            14976  0 
gen_probe               4032  1 jedec_probe
mtdcore                 7876  0 
chipreg                 3872  1 jedec_probe
shpchp                103372  0 
pciehp                100428  0 
pci_hotplug            35708  2 shpchp,pciehp
intel_agp              20060  1 
agpgart                34892  1 intel_agp
evdev                   9792  0 
dm_mod                 46016  0 
capability              4744  0 
commoncap               7520  1 capability
usbkbd                  7648  0 
usbcore               117440  4 uhci_hcd,usbkbd
ext3                  129672  2 
jbd                    70232  1 ext3
mbcache                10340  1 ext3
ide_disk               19616  4 
piix                   13824  1 
ide_core              145200  3 ide_scsi,ide_disk,piix
unix                   31056  290 
font                    8544  0 
vesafb                  6880  0 
cfbcopyarea             4064  1 vesafb
cfbimgblt               3264  1 vesafb
cfbfillrect             4000  1 vesafb

And here is the output of ksymoops.  BTW, why is there no /proc/ksyms?
 Is that something that can be changed at runtime, or do I need to
configure the kernel with that option?

ksymoops 2.4.9 on i686 2.6.7-1-686-smp.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.7-1-686-smp/ (default)
     -m /boot/System.map-2.6.7-1-686-smp (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol
resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to
find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Jul 28 10:28:51 irp-bminton vmunix: Unable to handle kernel paging
request at virtual address 0000ff00
Jul 28 10:28:51 irp-bminton kernel: eax: cf97e280   ebx: 00000000  
ecx: cf97e280   edx: 0000ff00
Jul 28 10:28:51 irp-bminton kernel: esi: cce4a080   edi: c1755e70  
ebp: 00000000   esp: c1755de8
Jul 28 10:28:51 irp-bminton kernel: ds: 007b   es: 007b   ss: 0068
Jul 28 10:28:51 irp-bminton kernel: Stack: c1755df4 cce4a080 cce4a080
c0226a33 cce4a080 c542bb80 00000000 c0226af7
Jul 28 10:28:51 irp-bminton kernel:        cce4a080 cce4a080 c1755e70
00000080 d0831fb2 cce4a080 cf97e200 00000080
Jul 28 10:28:51 irp-bminton kernel:        c1754000 c1755e38 cce4a080
c4f6bb50 c4f6bc54 00000001 00000000 ffffffa1
Jul 28 10:28:51 irp-bminton kernel: Call Trace:
Warning (Oops_read): Code line not seen, dumping what data is
available


>>eax; cf97e280 <__crc_blk_queue_end_tag+1d5ca/296591>
>>ecx; cf97e280 <__crc_blk_queue_end_tag+1d5ca/296591>
>>esi; cce4a080 <__crc_xfrm_ealg_get_byname+1617a/494b27>
>>edi; c1755e70 <__crc_memcpy_tokerneliovec+4f7de8/6cf409>
>>esp; c1755de8 <__crc_memcpy_tokerneliovec+4f7d60/6cf409>

Jul 28 10:28:51 irp-bminton kernel: Code: 8b 02 f6 c4 08 75 18 8b 42
04 40 74 4b f0 83 42 04 ff 0f 98
Using defaults from ksymoops -t elf32-i386 -a i386


Code;  00000000 Before first symbol
00000000 <_EIP>:
Code;  00000000 Before first symbol
   0:   8b 02                     mov    (%edx),%eax
Code;  00000002 Before first symbol
   2:   f6 c4 08                  test   $0x8,%ah
Code;  00000005 Before first symbol
   5:   75 18                     jne    1f <_EIP+0x1f>
Code;  00000007 Before first symbol
   7:   8b 42 04                  mov    0x4(%edx),%eax
Code;  0000000a Before first symbol
   a:   40                        inc    %eax
Code;  0000000b Before first symbol
   b:   74 4b                     je     58 <_EIP+0x58>
Code;  0000000d Before first symbol
   d:   f0 83 42 04 ff            lock addl $0xffffffff,0x4(%edx)
Code;  00000012 Before first symbol
  12:   0f 98 00                  sets   (%eax)


2 warnings and 1 error issued.  Results may not be reliable.


thanks,
Brian Minton
