From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: mpt2sas + raid10 goes boom
Date: Mon, 8 Apr 2013 17:53:51 +1000
Message-ID: <20130408075351.GA16422@onthe.net.au>
References: <20130408071834.GA15457@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130408071834.GA15457@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Upon reflection, given this smells like a controller issue, this
may be better addressed to linux-scsi@vger.kernel.org...

On Mon, Apr 08, 2013 at 05:18:34PM +1000, Chris Dunlop wrote:
> G'day,
> 
> On a LSI 9211-8i controller with IT firmware, when I use mdadm
> to create a 4-disk raid10 and mount it, the controller reports
> errors on all 4 disks, then the disks go read-only (kern.log
> below).
> 
> A raid6 using the same sets of disks works without any problems.
> 
> Has anyone had any success or similar failures with similar
> hardware, and/or have any idea what might be going on?
> 
> The command sequence used is:
> 
> mdadm --create /dev/md4 --raid-devices=4 --level=raid10 --layout=o2 --bitmap=internal /dev/sd{f,j,k,m}
> mkfs.ext4 /dev/md4
> mount -onoatime /dev/md4 /mnt
> 
> (Note: the mkfs and mount are done immediately after the mdadm
> returns, i.e. the raid has only just started syncing.)
> 
> This happens with linux-3.7.3, and 3.7.10, and LSI firmware
> versions 14 and 15, and with 4 x WD20EFRX (the original config),
> and 2 x ST2000DL003 + 2 x WD20EADS disks (a test config).
> 
> Cheers,
> 
> Chris
> 
> ----------------------------------------------------------------------
> kern.log
> ----------------------------------------------------------------------
> Apr  8 15:08:13 b4 kernel: [  409.230164] md/raid10:md4: not clean -- starting background reconstruction
> Apr  8 15:08:13 b4 kernel: [  409.230227] md/raid10:md4: active with 4 out of 4 devices
> Apr  8 15:08:13 b4 kernel: [  409.230442] created bitmap (30 pages) for device md4
> Apr  8 15:08:13 b4 kernel: [  409.233333] md4: bitmap initialized from disk: read 2 pages, set 59613 of 59613 bits
> Apr  8 15:08:14 b4 kernel: [  409.303719] md4: detected capacity change from 0 to 4000525058048
> Apr  8 15:08:14 b4 kernel: [  409.326603]  md4: unknown partition table
> Apr  8 15:08:20 b4 kernel: [  415.821209] md: resync of RAID array md4
> Apr  8 15:08:20 b4 kernel: [  415.821271] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Apr  8 15:08:20 b4 kernel: [  415.821333] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
> Apr  8 15:08:20 b4 kernel: [  415.821415] md: using 128k window, over a total of 3906762752k.
> Apr  8 15:08:33 b4 kernel: [  428.762213] EXT4-fs (md4): mounted filesystem with ordered data mode. Opts: (null)
> Apr  8 15:08:41 b4 kernel: [  436.345890] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.345977] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346062] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346138] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346215] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346291] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346367] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346443] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346519] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:41 b4 kernel: [  436.346595] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:42 b4 kernel: [  437.594032] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:42 b4 kernel: [  437.594119] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:42 b4 kernel: [  437.594202] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:42 b4 kernel: [  437.594278] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:42 b4 kernel: [  437.594355] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:42 b4 kernel: [  437.594431] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:43 b4 kernel: [  438.842232] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:43 b4 kernel: [  438.842319] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:43 b4 kernel: [  438.842402] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:43 b4 kernel: [  438.842479] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:43 b4 kernel: [  438.842555] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:43 b4 kernel: [  438.842631] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:44 b4 kernel: [  440.090321] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:44 b4 kernel: [  440.090408] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:44 b4 kernel: [  440.090491] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:44 b4 kernel: [  440.090567] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:44 b4 kernel: [  440.090644] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:44 b4 kernel: [  440.090720] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:46 b4 kernel: [  441.338473] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:46 b4 kernel: [  441.338560] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:46 b4 kernel: [  441.338644] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:46 b4 kernel: [  441.338721] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:46 b4 kernel: [  441.338797] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:46 b4 kernel: [  441.338873] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.586623] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.586707] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.586717] sd 0:0:5:0: [sdf] Unhandled error code
> Apr  8 15:08:47 b4 kernel: [  442.586719] sd 0:0:5:0: [sdf]  
> Apr  8 15:08:47 b4 kernel: [  442.586720] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:47 b4 kernel: [  442.586722] sd 0:0:5:0: [sdf] CDB: 
> Apr  8 15:08:47 b4 kernel: [  442.586728] Write(10): 2a 00 00 04 1c 00 00 04 00 00
> Apr  8 15:08:47 b4 kernel: [  442.586730] end_request: I/O error, dev sdf, sector 269312
> Apr  8 15:08:47 b4 kernel: [  442.587114] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.587192] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.587268] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.587344] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.587355] sd 0:0:9:0: [sdj] Unhandled error code
> Apr  8 15:08:47 b4 kernel: [  442.587356] sd 0:0:9:0: [sdj]  
> Apr  8 15:08:47 b4 kernel: [  442.587357] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:47 b4 kernel: [  442.587359] sd 0:0:9:0: [sdj] CDB: 
> Apr  8 15:08:47 b4 kernel: [  442.587364] Write(10): 2a 00 00 04 1c 00 00 04 00 00
> Apr  8 15:08:47 b4 kernel: [  442.587366] end_request: I/O error, dev sdj, sector 269312
> Apr  8 15:08:47 b4 kernel: [  442.588919] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.588996] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.589006] sd 0:0:10:0: [sdk] Unhandled error code
> Apr  8 15:08:47 b4 kernel: [  442.589008] sd 0:0:10:0: [sdk]  
> Apr  8 15:08:47 b4 kernel: [  442.589009] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:47 b4 kernel: [  442.589011] sd 0:0:10:0: [sdk] CDB: 
> Apr  8 15:08:47 b4 kernel: [  442.589016] Write(10): 2a 00 00 04 1d 10 00 02 f0 00
> Apr  8 15:08:47 b4 kernel: [  442.589018] end_request: I/O error, dev sdk, sector 269584
> Apr  8 15:08:47 b4 kernel: [  442.589396] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.589468] sd 0:0:10:0: [sdk] Unhandled error code
> Apr  8 15:08:47 b4 kernel: [  442.589471] sd 0:0:10:0: [sdk]  
> Apr  8 15:08:47 b4 kernel: [  442.589473] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:47 b4 kernel: [  442.589475] sd 0:0:10:0: [sdk] CDB: 
> Apr  8 15:08:47 b4 kernel: [  442.589480] Write(10): 2a 00 00 04 18 00 00 04 00 00
> Apr  8 15:08:47 b4 kernel: [  442.589482] end_request: I/O error, dev sdk, sector 268288
> Apr  8 15:08:47 b4 kernel: [  442.589560] md/raid10:md4: Disk failure on sdk1, disabling device.
> Apr  8 15:08:47 b4 kernel: [  442.589565] md/raid10:md4: Disk failure on sdj1, disabling device.
> Apr  8 15:08:47 b4 kernel: [  442.589565] md/raid10:md4: Operation continuing on 2 devices.
> Apr  8 15:08:47 b4 kernel: [  442.589959] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.590036] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.590046] sd 0:0:12:0: [sdm] Unhandled error code
> Apr  8 15:08:47 b4 kernel: [  442.590048] sd 0:0:12:0: [sdm]  
> Apr  8 15:08:47 b4 kernel: [  442.590049] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:47 b4 kernel: [  442.590050] sd 0:0:12:0: [sdm] CDB: 
> Apr  8 15:08:47 b4 kernel: [  442.590055] Write(10): 2a 00 00 04 19 10 00 02 f0 00
> Apr  8 15:08:47 b4 kernel: [  442.590057] end_request: I/O error, dev sdm, sector 268560
> Apr  8 15:08:47 b4 kernel: [  442.590437] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.590513] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:47 b4 kernel: [  442.590552] sd 0:0:12:0: [sdm] Unhandled error code
> Apr  8 15:08:47 b4 kernel: [  442.590554] sd 0:0:12:0: [sdm]  
> Apr  8 15:08:47 b4 kernel: [  442.590555] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:47 b4 kernel: [  442.590556] sd 0:0:12:0: [sdm] CDB: 
> Apr  8 15:08:47 b4 kernel: [  442.590561] Write(10): 2a 00 00 04 1c 00 00 04 00 00
> Apr  8 15:08:47 b4 kernel: [  442.590562] end_request: I/O error, dev sdm, sector 269312
> Apr  8 15:08:47 b4 kernel: [  442.590913] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:48 b4 kernel: [  443.834819] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:48 b4 kernel: [  443.834907] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:48 b4 kernel: [  443.834989] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:48 b4 kernel: [  443.835065] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:48 b4 kernel: [  443.835141] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:49 b4 kernel: [  445.082918] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:49 b4 kernel: [  445.083006] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:49 b4 kernel: [  445.083089] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:49 b4 kernel: [  445.083165] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:49 b4 kernel: [  445.083241] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:51 b4 kernel: [  446.331061] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:51 b4 kernel: [  446.331149] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:51 b4 kernel: [  446.331232] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:51 b4 kernel: [  446.331309] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:52 b4 kernel: [  447.579212] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:52 b4 kernel: [  447.579281] sd 0:0:5:0: [sdf] Unhandled error code
> Apr  8 15:08:52 b4 kernel: [  447.579282] sd 0:0:5:0: [sdf]  
> Apr  8 15:08:52 b4 kernel: [  447.579284] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:52 b4 kernel: [  447.579285] sd 0:0:5:0: [sdf] CDB: 
> Apr  8 15:08:52 b4 kernel: [  447.579290] Write(10): 2a 00 00 04 18 00 00 04 00 00
> Apr  8 15:08:52 b4 kernel: [  447.579292] end_request: I/O error, dev sdf, sector 268288
> Apr  8 15:08:52 b4 kernel: [  447.579628] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:52 b4 kernel: [  447.579700] sd 0:0:9:0: [sdj] Unhandled error code
> Apr  8 15:08:52 b4 kernel: [  447.579702] sd 0:0:9:0: [sdj]  
> Apr  8 15:08:52 b4 kernel: [  447.579705] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:52 b4 kernel: [  447.579707] sd 0:0:9:0: [sdj] CDB: 
> Apr  8 15:08:52 b4 kernel: [  447.579712] Write(10): 2a 00 00 04 18 00 00 04 00 00
> Apr  8 15:08:52 b4 kernel: [  447.579714] end_request: I/O error, dev sdj, sector 268288
> Apr  8 15:08:52 b4 kernel: [  447.580031] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:52 b4 kernel: [  447.580103] sd 0:0:10:0: [sdk] Unhandled error code
> Apr  8 15:08:52 b4 kernel: [  447.580105] sd 0:0:10:0: [sdk]  
> Apr  8 15:08:52 b4 kernel: [  447.580108] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:52 b4 kernel: [  447.580110] sd 0:0:10:0: [sdk] CDB: 
> Apr  8 15:08:52 b4 kernel: [  447.580115] Write(10): 2a 00 00 04 24 00 00 01 08 00
> Apr  8 15:08:52 b4 kernel: [  447.580116] end_request: I/O error, dev sdk, sector 271360
> Apr  8 15:08:52 b4 kernel: [  447.580434] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
> Apr  8 15:08:52 b4 kernel: [  447.580505] sd 0:0:12:0: [sdm] Unhandled error code
> Apr  8 15:08:52 b4 kernel: [  447.580507] sd 0:0:12:0: [sdm]  
> Apr  8 15:08:52 b4 kernel: [  447.580508] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Apr  8 15:08:52 b4 kernel: [  447.580511] sd 0:0:12:0: [sdm] CDB: 
> Apr  8 15:08:52 b4 kernel: [  447.580516] Write(10): 2a 00 00 04 20 00 00 01 08 00
> Apr  8 15:08:52 b4 kernel: [  447.580518] end_request: I/O error, dev sdm, sector 270336
> Apr  8 15:08:53 b4 kernel: [  448.614727] md/raid10:md4: Disk failure on sdm1, disabling device.
> Apr  8 15:08:53 b4 kernel: [  448.614727] md/raid10:md4: Operation continuing on 1 devices.
> Apr  8 15:08:53 b4 kernel: [  448.656989] md/raid10:md4: Disk failure on sdf1, disabling device.
> Apr  8 15:08:53 b4 kernel: [  448.656989] md/raid10:md4: Operation continuing on 0 devices.
> Apr  8 15:08:53 b4 kernel: [  448.657142] md4: WRITE SAME failed. Manually zeroing.
> Apr  8 15:08:53 b4 kernel: [  448.657178] Buffer I/O error on device md4, logical block 488144896
> Apr  8 15:08:53 b4 kernel: [  448.657179] lost page write due to I/O error on md4
> Apr  8 15:08:53 b4 kernel: [  448.657182] JBD2: Error -5 detected when updating journal superblock for md4-8.
> Apr  8 15:08:53 b4 kernel: [  448.657708] Aborting journal on device md4-8.
> Apr  8 15:08:53 b4 kernel: [  448.657794] Buffer I/O error on device md4, logical block 488144896
> Apr  8 15:08:53 b4 kernel: [  448.657875] lost page write due to I/O error on md4
> Apr  8 15:08:53 b4 kernel: [  448.657952] JBD2: Error -5 detected when updating journal superblock for md4-8.
> Apr  8 15:08:54 b4 kernel: [  449.663626] md: md4: resync done.
> Apr  8 15:08:54 b4 kernel: [  449.666948] md: checkpointing resync of md4.
> Apr  8 15:08:54 b4 kernel: [  449.667275] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.667279]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.667282]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.667284]  disk 1, wo:1, o:0, dev:sdk1
> Apr  8 15:08:54 b4 kernel: [  449.667286]  disk 2, wo:1, o:0, dev:sdj1
> Apr  8 15:08:54 b4 kernel: [  449.667288]  disk 3, wo:1, o:0, dev:sdf1
> Apr  8 15:08:54 b4 kernel: [  449.713524] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.713528]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.713531]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.713533]  disk 1, wo:1, o:0, dev:sdk1
> Apr  8 15:08:54 b4 kernel: [  449.713535]  disk 2, wo:1, o:0, dev:sdj1
> Apr  8 15:08:54 b4 kernel: [  449.713541] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.713543]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.713545]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.713547]  disk 1, wo:1, o:0, dev:sdk1
> Apr  8 15:08:54 b4 kernel: [  449.713549]  disk 2, wo:1, o:0, dev:sdj1
> Apr  8 15:08:54 b4 kernel: [  449.803374] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.803378]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.803381]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.803383]  disk 1, wo:1, o:0, dev:sdk1
> Apr  8 15:08:54 b4 kernel: [  449.803387] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.803389]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.803391]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.803393]  disk 1, wo:1, o:0, dev:sdk1
> Apr  8 15:08:54 b4 kernel: [  449.893250] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.893254]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.893257]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.893261] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.893263]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.893265]  disk 0, wo:1, o:0, dev:sdm1
> Apr  8 15:08:54 b4 kernel: [  449.983101] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.983105]  --- wd:0 rd:4
> Apr  8 15:08:54 b4 kernel: [  449.983325] md: resync of RAID array md4
> Apr  8 15:08:54 b4 kernel: [  449.983404] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Apr  8 15:08:54 b4 kernel: [  449.983490] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
> Apr  8 15:08:54 b4 kernel: [  449.983607] md: using 128k window, over a total of 3906762752k.
> Apr  8 15:08:54 b4 kernel: [  449.983817] md: md4: resync done.
> Apr  8 15:08:54 b4 kernel: [  449.987338] RAID10 conf printout:
> Apr  8 15:08:54 b4 kernel: [  449.987342]  --- wd:0 rd:4
> Apr  8 15:09:05 b4 kernel: [  460.616633] Buffer I/O error on device md4, logical block 0
> Apr  8 15:09:05 b4 kernel: [  460.616697] lost page write due to I/O error on md4
> Apr  8 15:09:05 b4 kernel: [  460.616760] EXT4-fs error (device md4): ext4_put_super:858: Couldn't clean up the journal
> Apr  8 15:09:05 b4 kernel: [  460.616901] EXT4-fs (md4): Remounting filesystem read-only
> Apr  8 15:09:05 b4 kernel: [  460.616957] EXT4-fs (md4): previous I/O error to superblock detected
> Apr  8 15:09:05 b4 kernel: [  460.617017] Buffer I/O error on device md4, logical block 0
> Apr  8 15:09:05 b4 kernel: [  460.617074] lost page write due to I/O error on md4
> ----------------------------------------------------------------------
