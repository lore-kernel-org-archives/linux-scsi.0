From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: How to set DPOFUA=0 ?
Date: Tue, 29 Dec 2015 12:30:28 +0100
Message-ID: <n5tqsl$5eg$2@ger.gmane.org>
References: <n5kqb4$k8n$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38974 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbbL2LfH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 06:35:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1aDsYR-0000OA-Nj
	for linux-scsi@vger.kernel.org; Tue, 29 Dec 2015 12:35:03 +0100
Received: from ip4d14b373.dynamic.kabel-deutschland.de ([77.20.179.115])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 29 Dec 2015 12:35:03 +0100
Received: from for-gmane by ip4d14b373.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Tue, 29 Dec 2015 12:35:03 +0100
In-Reply-To: <n5kqb4$k8n$1@ger.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Solved:

By installing a the latest kernel and headers from Debian backports solved the 
problem:

apt-get -t jessie-backports install linux-image-amd64 linux-headers-amd64

Info about backports configuration:
http://backports.debian.org/Instructions/

# uname -a
Linux panther 4.2.0-0.bpo.1-amd64 #1 SMP Debian 4.2.6-3~bpo8+2 (2015-12-14) 
x86_64 GNU/Linux

After this nigtmare-ish experience I would suggest the debian maintainers
to trash the default jessie kernel 3.16 and replace it with the above
4.2 kernel; otherwise unexperienced users will wonder why their new SSD etc.
isn't working in debian/ubuntu & co., as happened to me... :-(



U.Mutlu wrote on 12/26/2015 02:25 AM:
> Hi,
> I have got 2 different submodels of the SSD Samsung 850 Evo 500 GB.
> The first one has DPOFUA=0, the second one has DPOFUA=1 (see below).
> That with DPOFUA=0 works fine, but the other with DPOFUA=1 doesn't work
> after mounting; it reports errors and switches to read-only mount.
>
> It seems Linux has a problem with DPOFUA=1, so then IMO best would be to
> disable that feature of the device. So, how & where can DPOFUA be set to value
> 0 ?
>
> Thx
>
>
> ############################################################################
> # uname -a
> Linux panther 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u1 (2015-12-14)
> x86_64 GNU/Linux
>
> ############################################################################
> Dec 26 00:45:38 panther vmunix: [ 2337.193164] usb 4-1: new SuperSpeed USB
> device number 2 using xhci_hcd
> Dec 26 00:45:38 panther vmunix: [ 2337.212852] usb 4-1: New USB device found,
> idVendor=357d, idProduct=7788
> Dec 26 00:45:38 panther vmunix: [ 2337.212861] usb 4-1: New USB device
> strings: Mfr=1, Product=2, SerialNumber=3
> Dec 26 00:45:38 panther vmunix: [ 2337.212866] usb 4-1: Product: USB to
> ATA/ATAPI Bridge
> Dec 26 00:45:38 panther vmunix: [ 2337.212870] usb 4-1: Manufacturer: JMicron
> Dec 26 00:45:38 panther vmunix: [ 2337.212874] usb 4-1: SerialNumber:
> 321AE8171482926
> Dec 26 00:45:38 panther vmunix: [ 2337.245338] usb-storage 4-1:1.0: USB Mass
> Storage device detected
> Dec 26 00:45:38 panther vmunix: [ 2337.245591] scsi2 : usb-storage 4-1:1.0
> Dec 26 00:45:38 panther vmunix: [ 2337.245770] usbcore: registered new
> interface driver usb-storage
> Dec 26 00:45:39 panther vmunix: [ 2338.244729] scsi 2:0:0:0: Direct-Access
> Samsung SSD 850 EVO 500G 0114 PQ: 0 ANSI: 6
> Dec 26 00:45:39 panther vmunix: [ 2338.245308] sd 2:0:0:0: Attached scsi
> generic sg2 type 0
> Dec 26 00:45:39 panther vmunix: [ 2338.247115] sd 2:0:0:0: [sdb] Spinning up
> disk...
> Dec 26 00:45:49 panther vmunix: [ 2339.251034] .........
> Dec 26 00:45:52 panther vmunix: [ 2348.278894] ....ready
> Dec 26 00:45:52 panther vmunix: [ 2351.288429] sd 2:0:0:0: [sdb] 976773168
> 512-byte logical blocks: (500 GB/465 GiB)
> Dec 26 00:45:52 panther vmunix: [ 2351.288953] sd 2:0:0:0: [sdb] Write Protect
> is off
> Dec 26 00:45:52 panther vmunix: [ 2351.288959] sd 2:0:0:0: [sdb] Mode Sense:
> 47 00 10 08
> Dec 26 00:45:52 panther vmunix: [ 2351.289447] sd 2:0:0:0: [sdb] Write cache:
> enabled, read cache: enabled, supports DPO and FUA
> Dec 26 00:45:52 panther vmunix: [ 2351.293763] sdb: sdb1 sdb2 sdb3
> Dec 26 00:45:52 panther vmunix: [ 2351.295862] sd 2:0:0:0: [sdb] Attached SCSI
> disk
> Dec 26 00:47:02 panther vmunix: [ 2421.091552] EXT4-fs (sdb1): mounted
> filesystem with ordered data mode. Opts: (null)
> Dec 26 00:47:09 panther vmunix: [ 2428.394003] sd 2:0:0:0: [sdb] Invalid
> command failure
> Dec 26 00:47:09 panther vmunix: [ 2428.394013] sd 2:0:0:0: [sdb]
> Dec 26 00:47:09 panther vmunix: [ 2428.394017] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> Dec 26 00:47:09 panther vmunix: [ 2428.394021] sd 2:0:0:0: [sdb]
> Dec 26 00:47:09 panther vmunix: [ 2428.394024] Sense Key : Illegal Request
> [current]
> Dec 26 00:47:09 panther vmunix: [ 2428.394030] sd 2:0:0:0: [sdb]
> Dec 26 00:47:09 panther vmunix: [ 2428.394034] Add. Sense: Invalid field in cdb
> Dec 26 00:47:09 panther vmunix: [ 2428.394038] sd 2:0:0:0: [sdb] CDB:
> Dec 26 00:47:09 panther vmunix: [ 2428.394040] Write(10): 2a 08 02 04 08 20 00
> 00 08 00
> Dec 26 00:47:09 panther vmunix: [ 2428.394054] end_request: critical target
> error, dev sdb, sector 33818656
> Dec 26 00:47:09 panther vmunix: [ 2428.394059] end_request: critical target
> error, dev sdb, sector 33818656
> Dec 26 00:47:09 panther vmunix: [ 2428.394120] Aborting journal on device sdb1-8.
> Dec 26 00:47:09 panther vmunix: [ 2428.471535] EXT4-fs error (device sdb1):
> ext4_journal_check_start:56: Detected aborted journal
> Dec 26 00:47:09 panther vmunix: [ 2428.471547] EXT4-fs (sdb1): Remounting
> filesystem read-only
>
>
> ############################################################################
> # sdparm -a --long /dev/sda
>      /dev/sda: ATA       Samsung SSD 850   1B6Q
>      Direct access device specific parameters: WP=0  DPOFUA=0
> Read write error recovery [rw] mode page:
>    AWRE        1  [cha: n, def:  1]  Automatic write reallocation enabled
>    ARRE        0  [cha: n, def:  0]  Automatic read reallocation enabled
>    TB          0  [cha: n, def:  0]  Transfer block
>    RC          0  [cha: n, def:  0]  Read continuous
>    EER         0  [cha: n, def:  0]  Enable early recovery
>    PER         0  [cha: n, def:  0]  Post error
>    DTE         0  [cha: n, def:  0]  Data terminate on error
>    DCR         0  [cha: n, def:  0]  Disable correction
>    RRC         0  [cha: n, def:  0]  Read retry count
>    COR_S       0  [cha: n, def:  0]  Correction span (obsolete)
>    HOC         0  [cha: n, def:  0]  Head offset count (obsolete)
>    DSOC        0  [cha: n, def:  0]  Data strobe offset count (obsolete)
>    LBPERE      0  [cha: n, def:  0]  Logical block provisioning error
> reporting enabled
>    WRC         0  [cha: n, def:  0]  Write retry count
>    RTL         0  [cha: n, def:  0]  Recovery time limit (ms)
> Caching (SBC) [ca] mode page:
>    IC          0  [cha: n, def:  0]  Initiator control
>    ABPF        0  [cha: n, def:  0]  Abort pre-fetch
>    CAP         0  [cha: n, def:  0]  Caching analysis permitted
>    DISC        0  [cha: n, def:  0]  Discontinuity
>    SIZE        0  [cha: n, def:  0]  Size enable
>    WCE         1  [cha: y, def:  1]  Write cache enable
>    MF          0  [cha: n, def:  0]  Multiplication factor
>    RCD         0  [cha: n, def:  0]  Read cache disable
>    DRRP        0  [cha: n, def:  0]  Demand read retention priority
>    WRP         0  [cha: n, def:  0]  Write retention priority
>    DPTL        0  [cha: n, def:  0]  Disable pre-fetch transfer length
>    MIPF        0  [cha: n, def:  0]  Minimum pre-fetch
>    MAPF        0  [cha: n, def:  0]  Maximum pre-fetch
>    MAPFC       0  [cha: n, def:  0]  Maximum pre-fetch ceiling
>    FSW         0  [cha: n, def:  0]  Force sequential write
>    LBCSS       0  [cha: n, def:  0]  Logical block cache segment size
>    DRA         0  [cha: n, def:  0]  Disable read ahead
>    SYNC_PROG   0  [cha: n, def:  0]  Synchronous cache progress indication
>    NV_DIS      0  [cha: n, def:  0]  Non-volatile cache disable
>    NCS         0  [cha: n, def:  0]  Number of cache segments
>    CSS         0  [cha: n, def:  0]  Cache segment size
> Control [co] mode page:
>    TST         0  [cha: n, def:  0]  Task set type
>    TMF_ONLY    0  [cha: n, def:  0]  Task management functions only
>    DPICZ       0  [cha: n, def:  0]  Disable protection information check if
> protect field zero
>    D_SENSE     0  [cha: n, def:  0]  Descriptor format sense data
>    GLTSD       1  [cha: n, def:  1]  Global logging target save disable
>    RLEC        0  [cha: n, def:  0]  Report log exception condition
>    QAM         0  [cha: n, def:  0]  Queue algorithm modifier
>    NUAR        0  [cha: n, def:  0]  No unit attention on release
>    QERR        0  [cha: n, def:  0]  Queue error management
>    RAC         0  [cha: n, def:  0]  Report a check
>    UA_INTLCK   0  [cha: n, def:  0]  Unit attention interlocks control
>    SWP         0  [cha: n, def:  0]  Software write protect
>    ATO         0  [cha: n, def:  0]  Application tag owner
>    TAS         0  [cha: n, def:  0]  Task aborted status
>    ATMPE       0  [cha: n, def:  0]  Application tag mode page enabled
>    RWWP        0  [cha: n, def:  0]  Reject write without protection
>    AUTOLOAD    0  [cha: n, def:  0]  Autoload mode
>    BTP        -1  [cha: n, def: -1]  Busy timeout period (100us)
>    ESTCT      30  [cha: n, def: 30]  Extended self test completion time (sec)
>
>
> ############################################################################
> # sdparm -a --long /dev/sdb
>      /dev/sdb: Samsung   SSD 850 EVO 500G  0114
>      Direct access device specific parameters: WP=0  DPOFUA=1
> Caching (SBC) [ca] mode page:
>    IC          0  [cha: n, def:  0, sav:  0]  Initiator control
>    ABPF        0  [cha: n, def:  0, sav:  0]  Abort pre-fetch
>    CAP         0  [cha: n, def:  0, sav:  0]  Caching analysis permitted
>    DISC        1  [cha: n, def:  1, sav:  1]  Discontinuity
>    SIZE        0  [cha: n, def:  0, sav:  0]  Size enable
>    WCE         1  [cha: n, def:  1, sav:  1]  Write cache enable
>    MF          0  [cha: n, def:  0, sav:  0]  Multiplication factor
>    RCD         0  [cha: n, def:  0, sav:  0]  Read cache disable
>    DRRP        0  [cha: n, def:  0, sav:  0]  Demand read retention priority
>    WRP         0  [cha: n, def:  0, sav:  0]  Write retention priority
>    DPTL       -1  [cha: n, def: -1, sav: -1]  Disable pre-fetch transfer length
>    MIPF        0  [cha: n, def:  0, sav:  0]  Minimum pre-fetch
>    MAPF       -1  [cha: n, def: -1, sav: -1]  Maximum pre-fetch
>    MAPFC      -1  [cha: n, def: -1, sav: -1]  Maximum pre-fetch ceiling
>    FSW         0  [cha: n, def:  0, sav:  0]  Force sequential write
>    LBCSS       0  [cha: n, def:  0, sav:  0]  Logical block cache segment size
>    DRA         0  [cha: n, def:  0, sav:  0]  Disable read ahead
>    SYNC_PROG   0  [cha: n, def:  0, sav:  0]  Synchronous cache progress
> indication
>    NV_DIS      0  [cha: n, def:  0, sav:  0]  Non-volatile cache disable
>    NCS       255  [cha: n, def:255, sav:255]  Number of cache segments
>    CSS         0  [cha: n, def:  0, sav:  0]  Cache segment size
> Power condition [po] mode page:
>    PM_BG       0  [cha: n, def:  0, sav:  0]  Power management, background
> functions, precedence
>    STANDBY_Y   0  [cha: n, def:  0, sav:  0]  Standby_y timer enable
>    IDLE_C      0  [cha: n, def:  0, sav:  0]  Idle_c timer enable
>    IDLE_B      0  [cha: n, def:  0, sav:  0]  Idle_b timer enable
>    IDLE        0  [cha: n, def:  0, sav:  0]  Idle_a timer enable
>    STANDBY     0  [cha: y, def:  1, sav:  0]  Standby_z timer enable
>    ICT         0  [cha: n, def:  0, sav:  0]  Idle_a condition timer (100 ms)
>    SCT         0  [cha: y, def:18000, sav:  0]  Standby_z condition timer (100
> ms)
>    IBCT        0  [cha: n, def:  0, sav:  0]  Idle_b condition timer (100 ms)
>    ICCT        0  [cha: n, def:  0, sav:  0]  Idle_c condition timer (100 ms)
>    SYCT        0  [cha: n, def:  0, sav:  0]  Standby_y condition timer (100 ms)
>    CCF_IDLE    0  [cha: n, def:  0, sav:  0]  check condition on transition
> from idle
>    CCF_STAND   0  [cha: n, def:  0, sav:  0]  check condition on transition
> from standby
>    CCF_STOPP   0  [cha: n, def:  0, sav:  0]  check condition on transition
> from stopped
>
> ############################################################################
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


