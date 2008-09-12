From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 0/5] mpt fusion error handler patches
Date: Fri, 12 Sep 2008 20:57:40 +0200
Message-ID: <200809122057.41565.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:34463 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbYILS5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 14:57:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>

Hello,

I'm going to submit several error handler patches for the MPT fusion 
driver. The purpose of these patches is mainly to fix errors happening 
on the second port of dual port 53C1030 based HBAs.
As I complained some time ago on this list, a device failure on one of the 
ports of LSI22320R HBAs, will also cause device failures of innocent devices 
on the other port of this HBA. In order to debug this Eric Moore sent me a 
fusion-tip version of this driver, which we have been using ever since. However, 
this version has issues with SAS HBAs and probably also won't work for recent kernel 
versions. So I spent quite some amount of time to figure out why fusion-tip 
version (4.x) of the driver doesn't have the issue.

Below I will provide the some examples of these issues. Errors on one of the attached 
scsi devices have been simulated using lsiutil by doing target of one of the attached 
devices on one of the port (5 0 4 0).

Unpatched 2.6.26 + a few scsi diagnostics and error handler patches:

[  224.819697] sd 5:0:4:0: last recovery: 4294911483, now: 4294948403
[  224.826142] sd 5:0:4:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[  224.831676] sd 5:0:4:0: [sdc] CDB: Write(16): 8a 00 00 00 00 01 0c 27 2e 98 00 00 04 00 00 00
[  224.842803] sd 5:0:4:0: Activating scsi error recovery (1)
[  224.857824] sd 5:0:4:0: trying to abort command
[  224.865697] mptscsih: ioc1: attempting task abort! (sc=ffff8100f8f10000)
[  224.870572] sd 5:0:4:0: [sdc] CDB: Write(16): 8a 00 00 00 00 01 0c 27 2e 98 00 00 04 00 00 00
[  227.047968] mptbase: ioc1: Initiating recovery
[  229.481849] sd 5:0:4:0: mptscsih: ioc1: completing cmds: fw_channel 0, fw_id 4, sc=ffff8100f8fbb180, mf = ffff8100
[...]
[  364.322013] mptscsih: ioc1: bus reset: SUCCESS (sc=ffff8100f8f11b80)
[  371.924342] sd 4:0:2:0: scmd retry 6/6
[  371.928364] sd 4:0:2:0: last recovery: 0, now: 4294985148
[  371.932924] sd 4:0:2:0: [sda] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
[  371.932924] sd 4:0:2:0: [sda] CDB: Write(16): 8a 00 00 00 00 01 31 8b 4a 4e 00 00 00 39 00 00
[  371.932924] sd 4:0:2:0: Activating scsi error recovery (1)
[  371.960382] sd 4:0:2:0: Sending BDR 0xffff81007eaf2538
[  371.984936] sd 4:0:2:0: trying device reset
[  371.989426] mptscsih: ioc0: attempting target reset! (sc=ffff81007eb7c780)

As you can see, suddenly also target 4 0 2 0 fails, which is ioc0. In the end:

[  398.596119] sd 4:0:2:0: [sda] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
[  398.605291] end_request: I/O error, dev sda, sector 5126179406
[  398.612360] end_request: I/O error, dev sda, sector 5126179406
[  398.617818]  target4:0:2: Beginning Domain Validation

So the innocent device sda (which is really another device) failed.

Now the same with patches applied, but with the soft reset-handler deactivated:

[  912.861708] sd 5:0:4:0: last recovery: 4295082734, now: 4295120387
[  912.868130] sd 5:0:4:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_

[  912.873757] sd 5:0:4:0: [sdc] CDB: Write(10): 2a 00 73 11 33 08 00 04 00 00
[  912.873757] sd 5:0:4:0: Activating scsi error recovery (2)
[  912.889492] sd 5:0:4:0: trying to abort command
[  912.894118] mptscsih: ioc1: attempting task abort! (sc=ffff8100e361d180)
[  912.900951] sd 5:0:4:0: [sdc] CDB: Write(10): 2a 00 73 11 33 08 00 04 00 00
[  913.025771] mptscsih: ioc1: task abort: FAILED (sc=ffff8100e361d180)
[  913.032269] sd 5:0:4:0: Sending BDR 0xffff8100f99e1428
[  913.040264] sd 5:0:4:0: trying device reset
[  913.044597] mptscsih: ioc1: attempting target reset! (sc=ffff8100e361d180)
[  913.049955] sd 5:0:4:0: [sdc] CDB: Write(10): 2a 00 73 11 33 08 00 04 00 00
[  913.177284] mptscsih: ioc1: target reset: FAILED (sc=ffff8100e361d180)
[  913.181946] Sending BRST chan: 0
[  913.185945] sd 5:0:4:0: trying bus reset
[  913.189974] mptscsih: ioc1: attempting bus reset! (sc=ffff8100e361d180)
[  913.197310] sd 5:0:4:0: [sdc] CDB: Write(10): 2a 00 73 11 33 08 00 04 00 00
[  913.325079] mptscsih: ioc1: bus reset: FAILED (sc=ffff8100e361d180)
[  913.329668] sd 5:0:4:0: trying host reset
[  913.333864] mptscsih: ioc1: attempting host reset! (sc=ffff8100e361d180)
[  913.341832] mptscsih: ioc1: Skipping hard reset in order to prevent failures on ioc

[  913.349821] mptscsih: ioc1: host reset: FAILED (sc=ffff8100e361d180)
[  913.356704] sd 5:0:4:0: Device offlined - not ready after error recovery
[  913.363199] sd 5:0:4:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT,SUGGEST_OK

=> The device was not recovered, but at least 4 0 2 0 didn't fail :)

Now with all patches applied:

[  214.903699] sd 5:0:4:0: last recovery: 0, now: 4294945953
[  214.910652] sd 5:0:4:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
[  214.918652] sd 5:0:4:0: [sdc] CDB: Write(16): 8a 00 00 00 00 01 31 8b 9c e7 00 00 00 39 00 00
[  214.918652] sd 5:0:4:0: Activating scsi error recovery (1)
[  214.934655] sd 5:0:4:0: trying to abort command
[  214.939581] mptscsih: ioc1: attempting task abort! (sc=ffff8100f9be0c80)
[  214.947581] sd 5:0:4:0: [sdc] CDB: Write(16): 8a 00 00 00 00 01 31 8b 9c e7 00 00 00 39 00 00
[  215.077430] mptscsih: ioc1: task abort: FAILED (sc=ffff8100f9be0c80)
[  215.083645] sd 5:0:4:0: Sending BDR 0xffff81007eb51428
[  215.090298] sd 5:0:4:0: trying device reset
[  215.094810] mptscsih: ioc1: attempting target reset! (sc=ffff8100f9be0c80)
[  215.101917] sd 5:0:4:0: [sdc] CDB: Write(16): 8a 00 00 00 00 01 31 8b 9c e7 00 00 00 39 00 00
[  215.229659] mptscsih: ioc1: target reset: FAILED (sc=ffff8100f9be0c80)
[  215.236367] Sending BRST chan: 0
[  215.240173] sd 5:0:4:0: trying bus reset
[  215.244313] mptscsih: ioc1: attempting bus reset! (sc=ffff8100f9be0c80)
[  215.251731] sd 5:0:4:0: [sdc] CDB: Write(16): 8a 00 00 00 00 01 31 8b 9c e7 00 00 00 39 00 00
[  215.382449] mptscsih: ioc1: bus reset: FAILED (sc=ffff8100f9be0c80)
[  215.388946] sd 5:0:4:0: trying host reset
[  215.393162] mptscsih: ioc1: attempting host reset! (sc=ffff8100f9be0c80)
[  215.400489] sd 5:0:4:0: mptscsih: ioc1: completing cmds: fw_channel 0, fw_id 4, sc=ffff8100f9be0c80, mf = ffff8105
[  217.317914] mptbase: ioc1: SoftResetHandler: completed (1 seconds): SUCCESS
[  217.324924] mptscsih: ioc1: host reset: SUCCESS (sc=ffff8100f9be0c80)
[  227.546452]  target5:0:4: Beginning Domain Validation
[  227.578775]  target5:0:4: Ending Domain Validation
[  227.584099]  target5:0:4: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS PCOMP (6.25 ns, offset 127)
[  227.596959]  target5:0:5: Beginning Domain Validation
[  227.651196]  target5:0:5: Ending Domain Validation
[  227.656977]  target5:0:5: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS PCOMP (6.25 ns, offset 127)


-- 
Bernd Schubert
Q-Leap Networks GmbH
