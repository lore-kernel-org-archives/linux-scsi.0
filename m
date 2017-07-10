From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/4] scsi_dh_alua: fix stuck I/O after
 unavailable/standby states
Date: Mon, 10 Jul 2017 19:53:55 -0300
Message-ID: <aa41e2b9-119d-710a-c3d5-43b748f41a88@linux.vnet.ibm.com>
References: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499726857-7875-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: hare@suse.de, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/10/2017 07:47 PM, Mauricio Faria de Oliveira wrote:
> This patchset addresses that problem, and adds a few improvements
> to the logging of PG state changes.

Here are some kernel log snippets with the patchset, if that helps.

The 2 port groups temporarily gone into unavailable state, and
recovered to active states later on, when I/O has been restored.

The devices, port groups, and relative port IDs:
2 LUNs, 2 targets per LUN, 2 hosts (8 paths total).

[  294.482107] scsi 4:0:0:0: alua: device 
naa.60050764008100dac000000000000104 port group 1 rel port 881
[  294.642063] scsi 4:0:0:1: alua: device 
naa.60050764008100dac000000000000105 port group 0 rel port 881
[  294.812140] scsi 4:0:1:0: alua: device 
naa.60050764008100dac000000000000104 port group 0 rel port 81
[  295.002027] scsi 4:0:1:1: alua: device 
naa.60050764008100dac000000000000105 port group 1 rel port 81
[  296.952092] scsi 5:0:0:0: alua: device 
naa.60050764008100dac000000000000104 port group 1 rel port 881
[  297.162043] scsi 5:0:0:1: alua: device 
naa.60050764008100dac000000000000105 port group 0 rel port 881
[  297.312130] scsi 5:0:1:0: alua: device 
naa.60050764008100dac000000000000104 port group 0 rel port 81
[  297.512006] scsi 5:0:1:1: alua: device 
naa.60050764008100dac000000000000105 port group 1 rel port 81

First, mpatha goes down:

mpatha (360050764008100dac000000000000104) dm-6 IBM     ,2145
size=40G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
|-+- policy='round-robin 0' prio=0 status=active
| |- 4:0:1:0 sde 8:64  active undef unknown
| `- 5:0:1:0 sdi 8:128 active undef unknown
`-+- policy='round-robin 0' prio=0 status=enabled
   |- 4:0:0:0 sdc 8:32  active undef unknown
   `- 5:0:0:0 sdg 8:96  active undef unknown

[258929.940734] device-mapper: multipath: Failing path 8:64.
[258929.940751] device-mapper: multipath: Failing path 8:128.

[258929.940777] sd 4:0:0:0: alua: alua_activate(): port group 01, fn: 
pg_init_done [dm_multipath]()
[258929.940784] sd 5:0:0:0: alua: alua_activate(): port group 01, fn: 
pg_init_done [dm_multipath]()

[258929.941575] sd 5:0:1:0: alua: alua_check_sense(): Sense Key: 0x2, 
ASC: 0x4, ASCQ: 0xc
[258929.941578] sd 5:0:1:0: [sdi] tag#1 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[258929.941874] sd 5:0:1:0: [sdi] tag#1 Sense Key : Not Ready [current]
[258929.941928] sd 5:0:1:0: [sdi] tag#1 Add. Sense: Logical unit not 
accessible, target port in unavailable state

[258929.942096] sd 4:0:1:0: alua: alua_check_sense(): Sense Key: 0x2, 
ASC: 0x4, ASCQ: 0xc
[258929.942104] sd 4:0:1:0: [sde] tag#2 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[258929.942300] sd 4:0:1:0: [sde] tag#2 Sense Key : Not Ready [current]
[258929.942354] sd 4:0:1:0: [sde] tag#2 Add. Sense: Logical unit not 
accessible, target port in unavailable state

[258929.956347] sd 4:0:1:0: alua: port group 00 state U non-preferred 
supports tolusna
[258929.956389] sd 4:0:1:0: alua: port group 01 state U non-preferred

[258930.036355] sd 5:0:0:0: alua: alua_check_sense(): Sense Key: 0x2, 
ASC: 0x4, ASCQ: 0xc
[258930.036360] sd 5:0:0:0: alua: alua_rtpg_queue(): port group 01
[258930.036365] device-mapper: multipath: Failing path 8:96.

[258930.036444] sd 4:0:0:0: alua: alua_check_sense(): Sense Key: 0x2, 
ASC: 0x4, ASCQ: 0xc
[258930.036506] device-mapper: multipath: Failing path 8:32.

Then, mpathb goes down:

mpathb (360050764008100dac000000000000105) dm-7 IBM     ,2145
size=40G features='1 queue_if_no_path' hwhandler='1 alua' wp=rw
|-+- policy='round-robin 0' prio=0 status=active
| |- 4:0:0:1 sdd 8:48  active undef unknown
| `- 5:0:0:1 sdh 8:112 active undef unknown
`-+- policy='round-robin 0' prio=0 status=enabled
   |- 4:0:1:1 sdf 8:80  active undef unknown
   `- 5:0:1:1 sdj 8:144 active undef unknown


[258930.162558] sd 4:0:0:1: alua: alua_check_sense(): Sense Key: 0x2, 
ASC: 0x4, ASCQ: 0xc
[258930.162568] sd 4:0:0:1: alua: alua_rtpg_queue(): port group 00

[258930.162572] sd 4:0:0:1: [sdd] tag#9 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[258930.162731] sd 4:0:0:1: [sdd] tag#9 Sense Key : Not Ready [current]
[258930.162762] sd 4:0:0:1: [sdd] tag#9 Add. Sense: Logical unit not 
accessible, target port in unavailable state
[258930.162860] device-mapper: multipath: Failing path 8:48.

[258930.162979] sd 5:0:0:1: [sdh] tag#1 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[258930.162980] sd 5:0:0:1: [sdh] tag#1 Sense Key : Not Ready [current]
[258930.162982] sd 5:0:0:1: [sdh] tag#1 Add. Sense: Logical unit not 
accessible, target port in unavailable state
[258930.162992] device-mapper: multipath: Failing path 8:112.

[258930.163025] sd 4:0:1:1: alua: alua_activate(): port group 01, fn: 
pg_init_done [dm_multipath]()
[258930.163029] sd 4:0:1:1: alua: alua_rtpg_queue(): port group 01
[258930.163048] sd 5:0:1:1: alua: alua_activate(): port group 01, fn: 
pg_init_done [dm_multipath]()

[258930.176323] sd 4:0:0:1: alua: port group 00 state U non-preferred 
supports tolusna
[258930.176325] sd 4:0:1:1: alua: port group 01 state U non-preferred 
supports tolusna

[258930.186390] device-mapper: multipath: Failing path 8:144.
[258930.186417] device-mapper: multipath: Failing path 8:80.


Later, mpathb comes back up.

[259299.514519] device-mapper: multipath: Reinstating path 8:48.
[259299.514776] sd 4:0:0:1: alua: alua_activate(): port group 00, fn: 
pg_init_done [dm_multipath]()
[259299.514781] sd 4:0:0:1: alua: alua_rtpg_queue(): port group 00

[259299.536115] sd 4:0:0:1: alua: port group 01 state N non-preferred
[259299.536243] sd 4:0:0:1: alua: port group 00 state A non-preferred 
supports tolusna

[259300.516079] device-mapper: multipath: Reinstating path 8:112.
[259300.516225] sd 5:0:0:1: alua: alua_activate(): port group 00, fn: 
pg_init_done [dm_multipath]()
[259300.516228] sd 5:0:0:1: alua: alua_rtpg_queue(): port group 00
[259300.536119] sd 5:0:0:1: alua: port group 01 state N non-preferred
[259300.536245] sd 5:0:0:1: alua: port group 00 state A non-preferred 
supports tolusna

[259301.516823] device-mapper: multipath: Reinstating path 8:80.
[259301.517727] device-mapper: multipath: Reinstating path 8:144.

And, mpatha comes back up:

[262860.847102] device-mapper: multipath: Reinstating path 8:32.
[262860.847357] sd 4:0:0:0: alua: alua_activate(): port group 01, fn: 
pg_init_done [dm_multipath]()
[262860.847363] sd 4:0:0:0: alua: alua_rtpg_queue(): port group 01

[262860.847717] device-mapper: multipath: Reinstating path 8:96.
[262860.864217] sd 4:0:0:0: alua: port group 00 state A non-preferred
[262860.864335] sd 4:0:0:0: alua: port group 01 state N non-preferred 
supports tolusna

[262860.864563] sd 5:0:0:0: alua: alua_activate(): port group 01, fn: 
pg_init_done [dm_multipath]()
[262860.884215] sd 4:0:0:0: alua: port group 00 state A non-preferred
[262860.884328] sd 4:0:0:0: alua: port group 01 state N non-preferred 
supports tolusna

[262861.848315] device-mapper: multipath: Reinstating path 8:64.
[262861.849003] device-mapper: multipath: Reinstating path 8:128.
[262862.270417] sd 4:0:1:0: alua: alua_activate(): port group 00, fn: 
pg_init_done [dm_multipath]()
[262862.270419] sd 4:0:1:0: alua: alua_rtpg_queue(): port group 00
[262862.270422] sd 5:0:1:0: alua: alua_activate(): port group 00, fn: 
pg_init_done [dm_multipath]()
[262862.284250] sd 4:0:1:0: alua: port group 00 state A non-preferred 
supports tolusna
[262862.284401] sd 4:0:1:0: alua: port group 01 state N non-preferred

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
