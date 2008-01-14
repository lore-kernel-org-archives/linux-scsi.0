From: Jan Sembera <jsembera@suse.cz>
Subject: aic94xx: failing on high load
Date: Mon, 14 Jan 2008 15:49:16 +0100
Message-ID: <20080114144916.GD23867@alaris.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40384 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768AbYANOtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 09:49:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, vojtech@suse.cz

Hi,

	we have array of 16 SAS disks connected to Adaptec controllers
(we have ASC-58300 and on-board AIC-9410W, but this bug occurs on both
of them). Controller initializes drives successfully and they seem to w=
ork
normally, but when we perform some I/O intensive task (such as create m=
d
raid5 just over few disks and then reshape it onto all disks), everythi=
ng
seems to work for a while and then it starts emitting log messages that=
 are
included later in this mail, kicks out some (or all) disk devices, some=
times
it detects them back, sometimes it doesn't. It ocassionally even leads =
to
complete lockup of the machine in question. I apologize in advance if
I overlooked something obvious, but I was unable to find any reference =
to
this elsewhere and I was recommended to send it to linux-scsi.

	As logs are quite big, I only include part of it, you can find
full logs on following URLs:

http://init.suse.cz/sas-error-s1 (Adaptec AIC-9410W SAS)
http://init.suse.cz/sas-error-s2 (Adaptec ASC-58300 SAS)

=3D=3D CUT =3D=3D
=2E..
sas: command 0xffff810260004b00, task 0xffff810266a55780, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810291fda540, task 0xffff81030d7b57c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81025368b780, task 0xffff8102e58fccc0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81029eb536c0, task 0xffff81025d755300, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8102fd8a6b00, task 0xffff8102c245c6c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810132015300, task 0xffff81025d755a00, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8100134a29c0, task 0xffff8102c6c6f400, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810140d9b100, task 0xffff8101ac3b0b80, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81020c4f50c0, task 0xffff81001e99a080, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8101f4451680, task 0xffff81012f8dbd40, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810050910140, task 0xffff81026361f4c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810266a57600, task 0xffff81014e0c92c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810140d9b2c0, task 0xffff81015b2162c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81025368b940, task 0xffff81030ce5da00, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8102fc3d1a80, task 0xffff8101d41947c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81020c4f5600, task 0xffff810299e789c0, timed out: EH=
_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xffff810266a55780
sas: sas_scsi_find_task: aborting task 0xffff810266a55780
aic94xx: tmf timed out
aic94xx: tmf came back
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_timedout: here
aic94xx: came back from clear nexus
aic94xx: task not done, clearing nexus
aic94xx: asd_clear_nexus_index: PRE
aic94xx: asd_clear_nexus_index: POST
aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
aic94xx: came back from clear nexus
aic94xx: task 0xffff810266a55780 aborted, res: 0x5
sas: sas_scsi_find_task: querying task 0xffff810266a55780
aic94xx: tmf tasklet complete
sas: sas_scsi_find_task: task 0xffff810266a55780 not at LU
sas: task 0xffff810266a55780 is not at LU: I_T recover
sas: I_T nexus reset for dev 5000c5000647e471
sas: clearing nexus for port:0
aic94xx: asd_clear_nexus_port: PRE
aic94xx: asd_clear_nexus_port: POST
aic94xx: asd_clear_nexus_port: clear nexus posted, waiting...
aic94xx: task 0xffff8101ac3b0b80 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81001e99a080 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81012f8dbd40 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81026361f4c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81014e0c92c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81015b2162c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81030ce5da00 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff8101d41947c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff810299e789c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x23
aic94xx: task 0xffff8102e58fccc0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81025d755300 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff81030d7b57c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: BUG:sequencer:dl:no ascb?!
aic94xx: task 0xffff81025d755a00 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff8102c245c6c0 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: task 0xffff8102c6c6f400 done with opcode 0x23 resp 0x0 stat 0x=
8d but aborted by upper layer!
sas: clear nexus ha
aic94xx: asd_clear_nexus_ha: PRE
aic94xx: asd_clear_nexus_ha: POST
aic94xx: asd_clear_nexus_ha: clear nexus posted, waiting...
aic94xx: asd_clear_nexus_tasklet_complete: here
aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
sas: clear nexus ha succeeded
aic94xx: tmf timed out
aic94xx: escb_tasklet_complete: phy3: PRIMITIVE_RECVD
aic94xx: phy3: BROADCAST change received:256
aic94xx: escb_tasklet_complete: phy2: PRIMITIVE_RECVD
aic94xx: phy2: BROADCAST change received:256
aic94xx: escb_tasklet_complete: phy0: PRIMITIVE_RECVD
aic94xx: phy0: BROADCAST change received:256
sas: broadcast received: 9
sas: broadcast received: 9
sas: broadcast received: 9
sas: REVALIDATING DOMAIN on port 0, pid:2343
sas: ex 500304800001c47f phy18 originated BROADCAST(CHANGE)
sd 3:0:10:0: [sdn] Synchronizing SCSI cache
aic94xx: escb_tasklet_complete: phy3: PRIMITIVE_RECVD
aic94xx: phy3: BROADCAST change received:256
aic94xx: escb_tasklet_complete: phy2: PRIMITIVE_RECVD
aic94xx: phy2: BROADCAST change received:256
aic94xx: escb_tasklet_complete: phy0: PRIMITIVE_RECVD
aic94xx: phy0: BROADCAST change received:256
aic94xx: tmf timed out
=2E..
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sd 3:0:10:0: scsi: Device offlined - not ready after error recovery
sas: --- Exit sas_scsi_recover_host
sas: command 0xffff8101f4451840, task 0xffff81026361fbc0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81020c4f5600, task 0xffff810299e78480, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8102fc3d1a80, task 0xffff810299e782c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81025368b940, task 0xffff81014e0c9800, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810140d9b2c0, task 0xffff81014e0c9d40, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810266a57600, task 0xffff81014e0c99c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810050910140, task 0xffff81014e0c9100, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8101f4451680, task 0xffff81014e0c9b80, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81020c4f50c0, task 0xffff81014e0c9480, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810140d9b100, task 0xffff81014e0c9640, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8100134a29c0, task 0xffff8102e58fc780, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810132015300, task 0xffff8102e58fc080, timed out: EH=
_NOT_HANDLED
sas: command 0xffff8102fd8a6b00, task 0xffff8102e58fc940, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810291fda540, task 0xffff8102e58fc5c0, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81029eb536c0, task 0xffff8102e58fc240, timed out: EH=
_NOT_HANDLED
sas: command 0xffff81025368b780, task 0xffff8101ac3b0d40, timed out: EH=
_NOT_HANDLED
sas: command 0xffff810260004b00, task 0xffff8101ac3b09c0, timed out: EH=
_NOT_HANDLED
sas: Enter sas_scsi_recover_host
sas: trying to find task 0xffff81026361fbc0
sas: sas_scsi_find_task: aborting task 0xffff81026361fbc0
aic94xx: task 0xffff81026361fbc0 done with opcode 0x1e resp 0x0 stat 0x=
8d but aborted by upper layer!
aic94xx: tmf tasklet complete
aic94xx: tmf came back
aic94xx: asd_abort_task: task 0xffff81026361fbc0 done
aic94xx: task 0xffff81026361fbc0 aborted, res: 0x0
sas: sas_scsi_find_task: task 0xffff81026361fbc0 is done
sas: sas_eh_handle_sas_errors: task 0xffff81026361fbc0 is done
=2E..
=3D=3D CUT =3D=3D

	If you need any further information or testing, I will be glad
to provide it. I tried several different kernel versions (even some
2.6.24-rc6 git) without any effect.

Thanks for your reply

--
Jan Sembera
Linux Administrator
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                        e-mail: jsembera@suse.cz
Lihovarsk=E1 1060/12                          tel: +420 284 028 981
190 00 Praha 9                              fax: +420 284 028 951
Czech Republic                              http://www.suse.cz/

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
