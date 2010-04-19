From: Leif Sawyer <ak.hepcat+scsi@gmail.com>
Subject: high volume of disk-writes causes disk to 'disappear'
Date: Mon, 19 Apr 2010 10:38:17 -0800
Message-ID: <y2wd4bc8f581004191138ldab84bect8670755200e2c413@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37300 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0DSSiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2010 14:38:18 -0400
Received: by gyg13 with SMTP id 13so2733577gyg.19
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2010 11:38:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

All -

Just joined the list so I could better track this particular issue
that's I've been experiencing.

This issue is repeatable using kernels from 2.6.27 - 2.6.33, whether
vanilla or distro.

Summary:
        high volume of disk-writes causes disk to 'disappear'

Setup:
        I have a dual-Xeon CPU 2.40GHz with embedded Adaptec AIC-7902
U320 controller, 2GiB ram, and 2 1000baseT and 1 100baseT interfaces.

This system is built as a remote network sniffer, and streams all
captured data using tshark with rotating capture-files.  The files are
automatically rotated at 512MiB.

       The system has two seagate drives installed:
            system: ST336706LC -  36Gb
            data:  ST3146855LC - 146Gb

root is formatted on the system drive as ext3.  swap is also on the
system drive.
data is (full-disk) formatted as ext2, mounted  noexec,nodev,noatime

       A web-based interface starts/stops the sniffer, which writes
data from either/both GiB interfaces (depending on link status)  to
the data disk.

Symptom:

       After a variable length of time, the system will start logging
errors, and become unresponsive.

----

<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115076.989521]
sd 3:0:1:0: [sdb] Attempting to queue an ABORT message:CDB: 0x0 0x0
0x0 0x0 0x0 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115076.993289]
sd 3:0:1:0: [sdb] Attempting to queue an ABORT message:CDB: 0x2a 0x0
0x2 0xc0 0xdd 0x8f 0x0 0x4 0x0 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115076.993308]
sd 3:0:1:0: [sdb] Command not found
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115086.060044]
INFO: task kjournald:1007 blocked for more than 120 seconds.
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115086.760828]
INFO: task rsyslogd:26910 blocked for more than 120 seconds.
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115086.842049]
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115086.936773]
rsyslogd      D 00000000     0 26910      1 0x00000000
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115086.936957]
INFO: task cron:9106 blocked for more than 120 seconds.
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115087.013001]
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115187.040452]
sd 3:0:0:0: [sda] Command not found
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115197.040033]
sd 3:0:0:0: [sda] Attempting to queue an ABORT message:CDB: 0x0 0x0
0x0 0x0 0x0 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115197.041579]
sd 3:0:0:0: [sda] Attempting to queue an ABORT message:CDB: 0x2a 0x0
0x1 0xca 0xc0 0x4f 0x0 0x0 0x8 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115197.041624]
sd 3:0:0:0: [sda] Command not found
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115207.040034]
sd 3:0:0:0: [sda] Attempting to queue an ABORT message:CDB: 0x0 0x0
0x0 0x0 0x0 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115207.041854]
sd 3:0:0:0: [sda] Attempting to queue a TARGET RESET message:CDB: 0x2a
0x0 0x1 0xca 0xc0 0x97 0x0 0x0 0x8 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115212.040034]
sd 3:0:1:0: [sdb] Attempting to queue a TARGET RESET message:CDB: 0x2a
0x0 0x2 0xc0 0xa3 0x5f 0x0 0x4 0x0 0x0
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.264287]
sd 3:0:1:0: Device offlined - not ready after error recovery
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.264308]
sd 3:0:1:0: [sdb] Unhandled error code
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.264312]
sd 3:0:1:0: [sdb] Result: hostbyte=DID_REQUEUE driverbyte=DRIVER_OK
<kern.info<6>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.264319]
sd 3:0:1:0: [sdb] CDB: Write(10): 2a 00 02 c0 a7 5f 00 04 00 00
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.264340]
end_request: I/O error, dev sdb, sector 46180191
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.334682] sd
3:0:1:0: rejecting I/O to offline device
<kern.err<3>>Apr  8 19:28:41 websniff-6036a5 kernel:[115227.337071] sd
3:0:1:0: rejecting I/O to offline device

-----

At this point, via console, I have attempted to use
scsiadd/partprobe/sdparm to "re-discover" the lost disk,
        scsiadd -s > ${logfile} 2>&1
        partprobe -s >> ${logfile} 2>&1
        sdparm -al /dev/sdb >> ${logfile} 2>&1

scsiadd finds the device, but the kernel doesn't seem to register it:

        Attached devices:
        Host: scsi3 Channel: 00 Id: 00 Lun: 00
          Vendor: SEAGATE  Model: ST336706LC       Rev: 0108
          Type:   Direct-Access                    ANSI  SCSI revision: 03
        Host: scsi3 Channel: 00 Id: 01 Lun: 00
          Vendor: SEAGATE  Model: ST3146855LC      Rev: 0003
          Type:   Direct-Access                    ANSI  SCSI revision: 03
        Host: scsi3 Channel: 00 Id: 06 Lun: 00
          Vendor: ESG-TSD  Model: SCA HSBP M23     Rev: 1.05
          Type:   Processor                        ANSI  SCSI revision: 02
        /dev/sda: msdos partitions 1 2
        open error: /dev/sdb [read only]: No such device or address


At this point, I have to reboot in order to see the disk.

I have more logging data, but no kernel-debug data at this time.

I would appreciate any help or pointers.

Thanks,
   Leif

-- 
"It's pronounced Layf...you know, like Leif Garrett? Don't you watch
 'I Love the 70's'? What kind of retro lover are you, anyway?"
