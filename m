Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB04C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC6BE61380
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237310AbhGNBYS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237198AbhGNBYS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 21:24:18 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64630C0613DD
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 18:21:27 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a6so868322ljq.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 18:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NRnxrOCgHG4wcC+kxAa3PYFsa1gETBXfv7Mz8LLaKFk=;
        b=hU+skSCwfNManDdL4EwLzayhRdhco92+/0uQYK5kGKUAQYZmRPJoyr+zPMnQbQL5jh
         4eGItvWantJRBPsIGRULKSSGm3yEp8OsD10rnXC60SRwUpCuqDgurkEINStuvSnmN5Tm
         5KiDGhACTqMvPk9PiCSRKPK3RYR7e1it0mU8CFADFvN2JPHgKnmRYRH7sXP38Aip4Cz1
         C3pzcb3jG4kOrfvy7OwVrPVKwR62rD+RyuZZJHe4D35ZAMzjGZHWK4tkM2LQ/WLnvlYU
         fjo1mklcijJc1+/wCFxVsZRBtkQK8sibInZnom0k/UN01TjA47J1bkL4Vfn3gaNTXnuT
         ywQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NRnxrOCgHG4wcC+kxAa3PYFsa1gETBXfv7Mz8LLaKFk=;
        b=jLxWK55PXvKkSfIpdhYj2uzlmJaXnYfI4OkANdv2klHHssp01V8aXXmrl2DhefuA6A
         EciqimA9e3c2RhBjMCJkMBMInR08UQHitnSAQVi5xilTUIic/JHHsNXzAwP+txYfrk4Z
         XYQen+zuKgSb98x4/O7kLlNGWDQ8B7mCGEPz7G2QB12A5YeaNyx+eDcvZBCL7l43Gv/t
         5JeN/xm7AA5e5CTwDBi0JVfHa7qrnd7ycN+lObZGLNh9JTCp1r1zzIFZgb8OD/YGW8d/
         Nc+35AJj4inCi4YqZ0RJSuRCXEqdXs+En1bnYZAGa9JUAanhFharZLgYttF//E+gQqyR
         oOaw==
X-Gm-Message-State: AOAM530ShESD1Mo/7E6DJjaL1BP4MS7pawCjbI/L25miUuXr12VxA8hZ
        G2yxKLstuvMrToQwyNz7AgiDIsubUbFILJyEXlFL2oSzYELhvA==
X-Google-Smtp-Source: ABdhPJzAYRlDq9/mV2UWB7nDZHYYz69K3K1aMmSIja9Ohj/C20Z8502aM/ztxfyT3rOsRzTZjO7FWH0neq496I+RM2A=
X-Received: by 2002:a2e:6e09:: with SMTP id j9mr6642621ljc.319.1626225685442;
 Tue, 13 Jul 2021 18:21:25 -0700 (PDT)
MIME-Version: 1.0
From:   Bryce Evans <bryceevans@gmail.com>
Date:   Tue, 13 Jul 2021 18:21:13 -0700
Message-ID: <CAMRENR2g+nCaxfFGcgaMLm0TxQ+aTZA4E_UZarhRMoPAB3Uxhg@mail.gmail.com>
Subject: PROBLEM: sas_address sysfs attribute empty on E208i-p SR Gen10
To:     don.brace@microsemi.com
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The sas_address device attribute in sas_device sysfs in is 0x0, and
missing (empty or null?) in scsi_disk sysfs on LTS kernel 5.10.x, and
Stable 5.13.1

Specifically  /sys/class/scsi_disk/X:X/device/sas_address and
/sys/class/sas_device/end_device-X:X/sas_address are null and 0x0
respectively

Using this device in hba mode (pass through) - Serial Attached SCSI
controller: Adaptec Smart Storage PQI 12G SAS/PCIe 3 (rev 01)
Subsystem: Hewlett-Packard Company Smart Array E208i-p SR Gen10

This appears to have regressed some time after 4.19 (expected results
from 4.19 below)

It seems that systemd udev depends on this attribute from sysfs to
populate /dev/disk/by-path, and when it is unavailable the sas_address
shows as 0x0, which breaks population of this directory, potentially
breaking userspace tools that rely on this

==================================================================
udevadm uses 0x0 for the address variable of ID_PATH, causing unique
disks to have the same identifier used for ID_PATH, which breaks
population of /dev/disk/by-path

[bryce@myhost ~]$ udevadm info /dev/sdy | grep "ID_PATH=""
E: ID_PATH=pci-0000:5c:00.0-sas-0x0000000000000000-lun-0

[bryce@myhost ~]$ udevadm info /dev/sdx | grep "ID_PATH=""
E: ID_PATH=pci-0000:5c:00.0-sas-0x0000000000000000-lun-0

you can see the above 2 disks, should have a unique ID_PATH, and do not.


==================================================================
In kernel sysfs, we see empty sas_address attribute for each disk
attached to the hba in the scsi_disk sysfs

[bryce@myhost ~]$ cat /sys/class/scsi_disk/*/device/sas_address
cat: /sys/class/scsi_disk/0:0:0:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/0:0:1:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:0:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:10:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:1:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:11:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:12:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:13:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:14:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:15:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:16:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:17:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:18:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:19:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:20:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:2:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:21:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:22:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:23:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:3:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:4:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:5:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:6:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:7:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:8:0/device/sas_address: No such device
cat: /sys/class/scsi_disk/1:0:9:0/device/sas_address: No such device
==================================================================

See the following end device to pci device  mapping
[bryce@myhost ~]$ ls -al /sys/class/sas_device/
total 0
drwxr-xr-x  2 root root 0 Jul 13 16:06 .
drwxr-xr-x 77 root root 0 Jul 13 16:06 ..
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-0:1 ->
../../devices/pci0000:36/0000:36:02.0/0000:38:00.0/host0/scsi_host/host0/port-0:1/end_device-0:1/sas_device/end_device-0:1
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-0:2 ->
../../devices/pci0000:36/0000:36:02.0/0000:38:00.0/host0/scsi_host/host0/port-0:2/end_device-0:2/sas_device/end_device-0:2
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-0:3 ->
../../devices/pci0000:36/0000:36:02.0/0000:38:00.0/host0/scsi_host/host0/port-0:3/end_device-0:3/sas_device/end_device-0:3
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:1 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:1/end_device-1:1/sas_device/end_device-1:1
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:10 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:10/end_device-1:10/sas_device/end_device-1:10
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:11 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:11/end_device-1:11/sas_device/end_device-1:11
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:12 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:12/end_device-1:12/sas_device/end_device-1:12
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:13 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:13/end_device-1:13/sas_device/end_device-1:13
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:14 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:14/end_device-1:14/sas_device/end_device-1:14
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:15 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:15/end_device-1:15/sas_device/end_device-1:15
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:16 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:16/end_device-1:16/sas_device/end_device-1:16
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:17 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:17/end_device-1:17/sas_device/end_device-1:17
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:18 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:18/end_device-1:18/sas_device/end_device-1:18
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:19 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:19/end_device-1:19/sas_device/end_device-1:19
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:2 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:2/end_device-1:2/sas_device/end_device-1:2
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:20 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:20/end_device-1:20/sas_device/end_device-1:20
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:21 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:21/end_device-1:21/sas_device/end_device-1:21
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:22 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:22/end_device-1:22/sas_device/end_device-1:22
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:23 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:23/end_device-1:23/sas_device/end_device-1:23
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:24 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:24/end_device-1:24/sas_device/end_device-1:24
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:25 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:25/end_device-1:25/sas_device/end_device-1:25
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:26 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:26/end_device-1:26/sas_device/end_device-1:26
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:27 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:27/end_device-1:27/sas_device/end_device-1:27
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:3 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:3/end_device-1:3/sas_device/end_device-1:3
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:4 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:4/end_device-1:4/sas_device/end_device-1:4
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:5 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:5/end_device-1:5/sas_device/end_device-1:5
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:6 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:6/end_device-1:6/sas_device/end_device-1:6
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:7 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:7/end_device-1:7/sas_device/end_device-1:7
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:8 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:8/end_device-1:8/sas_device/end_device-1:8
lrwxrwxrwx  1 root root 0 Jul 13 16:06 end_device-1:9 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/scsi_host/host1/port-1:9/end_device-1:9/sas_device/end_device-1:9
==================================================================

and 0x0 in sysfs for sas_device/end_device sas_addresses (this is what
breaks udev)

[bryce@myhost ~]$ for d in $(ls
/sys/class/sas_device/end_device*/sas_address); do echo $d; cat
$d;done
/sys/class/sas_device/end_device-0:1/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-0:2/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-0:3/sas_address
0x51402ec0130545a8
/sys/class/sas_device/end_device-1:10/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:11/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:12/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:13/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:14/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:15/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:16/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:17/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:18/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:19/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:1/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:20/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:21/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:22/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:23/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:24/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:25/sas_address
0x50014380436ed4bc
/sys/class/sas_device/end_device-1:26/sas_address
0x50014380436ec7fc
/sys/class/sas_device/end_device-1:27/sas_address
0x51402ec013612638
/sys/class/sas_device/end_device-1:2/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:3/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:4/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:5/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:6/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:7/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:8/sas_address
0x0000000000000000
/sys/class/sas_device/end_device-1:9/sas_address
0x0000000000000000

==================================================================
lspci -vvv output

38:00.0 Serial Attached SCSI controller: Adaptec Smart Storage PQI 12G
SAS/PCIe 3 (rev 01)
Subsystem: Hewlett-Packard Company Smart Array E208i-a SR Gen10
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 30
NUMA node: 0
Region 0: Memory at e2800000 (64-bit, non-prefetchable) [size=32K]
Region 4: I/O ports at 6000 [size=256]
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [b0] MSI-X: Enable+ Count=64 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [c0] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <1us
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0.000W
DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
MaxPayload 256 bytes, MaxReadReq 4096 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L1, Exit Latency L0s <1us, L1 <1us
ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-, OBFF Via message
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+,
EqualizationPhase1+
EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
Capabilities: [100 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [300 v1] #19
Kernel driver in use: smartpqi

5c:00.0 Serial Attached SCSI controller: Adaptec Smart Storage PQI 12G
SAS/PCIe 3 (rev 01)
Subsystem: Hewlett-Packard Company Smart Array E208i-p SR Gen10
Physical Slot: 1
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 32
NUMA node: 1
Region 0: Memory at e6c00000 (64-bit, non-prefetchable) [size=32K]
Region 4: I/O ports at 8000 [size=256]
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [b0] MSI-X: Enable+ Count=64 Masked-
Vector table: BAR=0 offset=00002000
PBA: BAR=0 offset=00003000
Capabilities: [c0] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <1us
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0.000W
DevCtl: Report errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
MaxPayload 256 bytes, MaxReadReq 4096 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 8GT/s, Width x8, ASPM L1, Exit Latency L0s <1us, L1 <1us
ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 8GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR-, OBFF Via message
DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete+,
EqualizationPhase1+
EqualizationPhase2+, EqualizationPhase3+, LinkEqualizationRequest-
Capabilities: [100 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr+ BadTLP+ BadDLLP+ Rollover+ Timeout+ NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [300 v1] #19
Kernel driver in use: smartpqi

==================================================================
linux version
Linux version 5.13.1-1.el7.x86_64 (bryce@myhost2) (gcc (GCC) 9.3.1
20200408 (Red Hat 9.3.1-2), GNU ld version 2.32-16.el7) #1 SMP Tue Jul
13 15:46:58 UTC 2021

==================================================================
.config
I Think the only relevant thing in .config are the following, I can
paste the entire .config if you think necessary

CONFIG_SCSI_SMARTPQI=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
==================================================================
[bryce@myhost ~]$ sudo cat /proc/scsi/scsi

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: MK000480GWSSC    Rev: HPG0
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: MK000480GWSSC    Rev: HPG0
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: HPE      Model: Smart Adapter    Rev: 3.53
  Type:   Enclosure                        ANSI  SCSI revision: 05
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: HPE      Model: E208i-a SR Gen10 Rev: 3.53
  Type:   RAID                             ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 03 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 04 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 05 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 07 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 08 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 09 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 10 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 11 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 12 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 13 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 14 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 15 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 16 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 17 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 18 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 19 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 20 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 21 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 22 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 23 Lun: 00
  Vendor: ATA      Model: MB012000GWDFE    Rev: HPG2
  Type:   Direct-Access                    ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 24 Lun: 00
  Vendor: HPE      Model: Apollo 4200 LFF  Rev: 1.78
  Type:   Enclosure                        ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 25 Lun: 00
  Vendor: HPE      Model: Apollo 4200 LFF  Rev: 1.78
  Type:   Enclosure                        ANSI  SCSI revision: 06
Host: scsi1 Channel: 00 Id: 26 Lun: 00
  Vendor: HPE      Model: Smart Adapter    Rev: 3.53
  Type:   Enclosure                        ANSI  SCSI revision: 05
Host: scsi1 Channel: 02 Id: 00 Lun: 00
  Vendor: HPE      Model: E208i-p SR Gen10 Rev: 3.53
  Type:   RAID                             ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic- Model: SD/MMC CRW       Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 06

==================================================================
 modules (shouldn't matter, using kernel driver)

  [bryce@myhost ~]$ cat /proc/modules
binfmt_misc 24576 1 - Live 0x0000000000000000
fuse 143360 5 - Live 0x0000000000000000
scsi_transport_iscsi 139264 1 - Live 0x0000000000000000
bonding 196608 0 - Live 0x0000000000000000
tls 110592 1 bonding, Live 0x0000000000000000
xt_TCPMSS 16384 4 - Live 0x0000000000000000
xt_multiport 20480 4 - Live 0x0000000000000000
ip6table_mangle 16384 1 - Live 0x0000000000000000
ip6t_REJECT 16384 2 - Live 0x0000000000000000
nf_reject_ipv6 20480 1 ip6t_REJECT, Live 0x0000000000000000
ip6table_filter 16384 1 - Live 0x0000000000000000
ip6table_raw 16384 1 - Live 0x0000000000000000
ip6_tables 28672 3 ip6table_mangle,ip6table_filter,ip6table_raw, Live
0x0000000000000000
ipt_REJECT 16384 2 - Live 0x0000000000000000
nf_reject_ipv4 16384 1 ipt_REJECT, Live 0x0000000000000000
xt_conntrack 16384 2 - Live 0x0000000000000000
iptable_filter 16384 1 - Live 0x0000000000000000
xt_CT 16384 42 - Live 0x0000000000000000
nf_conntrack 163840 2 xt_conntrack,xt_CT, Live 0x0000000000000000
nf_defrag_ipv6 24576 1 nf_conntrack, Live 0x0000000000000000
nf_defrag_ipv4 16384 1 nf_conntrack, Live 0x0000000000000000
iptable_raw 16384 1 - Live 0x0000000000000000
intel_powerclamp 20480 0 - Live 0x0000000000000000
coretemp 20480 0 - Live 0x0000000000000000
kvm_intel 339968 0 - Live 0x0000000000000000
kvm 1007616 1 kvm_intel, Live 0x0000000000000000
irqbypass 16384 1 kvm, Live 0x0000000000000000
crct10dif_pclmul 16384 1 - Live 0x0000000000000000
mgag200 36864 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
mlx5_ib 389120 0 - Live 0x0000000000000000
ib_uverbs 167936 1 mlx5_ib, Live 0x0000000000000000
drm_kms_helper 278528 1 mgag200, Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
drm 663552 2 mgag200,drm_kms_helper, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
aesni_intel 380928 0 - Live 0x0000000000000000
crypto_simd 16384 1 aesni_intel, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
acpi_ipmi 20480 0 - Live 0x0000000000000000
ib_core 413696 2 mlx5_ib,ib_uverbs, Live 0x0000000000000000
pcspkr 16384 0 - Live 0x0000000000000000
cryptd 24576 2 ghash_clmulni_intel,crypto_simd, Live 0x0000000000000000
mei_me 45056 0 - Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
ipmi_si 77824 2 - Live 0x0000000000000000
i2c_algo_bit 16384 1 mgag200, Live 0x0000000000000000
ses 20480 0 - Live 0x0000000000000000
lpc_ich 28672 0 - Live 0x0000000000000000
ipmi_devintf 20480 2 - Live 0x0000000000000000
ioatdma 65536 0 - Live 0x0000000000000000
enclosure 16384 1 ses, Live 0x0000000000000000
mfd_core 20480 1 lpc_ich, Live 0x0000000000000000
hpilo 24576 4 - Live 0x0000000000000000
i2c_core 102400 4 mgag200,drm_kms_helper,drm,i2c_algo_bit, Live
0x0000000000000000
hpwdt 20480 0 - Live 0x0000000000000000
mei 151552 1 mei_me, Live 0x0000000000000000
dca 16384 1 ioatdma, Live 0x0000000000000000
wmi 32768 0 - Live 0x0000000000000000
ipmi_msghandler 118784 3 acpi_ipmi,ipmi_si,ipmi_devintf, Live 0x0000000000000000
acpi_power_meter 20480 0 - Live 0x0000000000000000
brd 16384 1 - Live 0x0000000000000000
ip_tables 28672 2 iptable_filter,iptable_raw, Live 0x0000000000000000
crc32c_intel 24576 2 - Live 0x0000000000000000
mlx5_core 1298432 1 mlx5_ib, Live 0x0000000000000000
mlxfw 36864 1 mlx5_core, Live 0x0000000000000000
psample 20480 1 mlx5_core, Live 0x0000000000000000
uas 32768 0 - Live 0x0000000000000000
usb_storage 81920 1 uas, Live 0x0000000000000000
dummy 16384 0 - Live 0x0000000000000000

==================================================================
********** 4.19 kernel expected results ****************
********** Everything below here is working as expected, with kernel
version 4.19 **********

[bryce@myhost ~]$ uname -r
4.19.132-1.el7.x86_64

[bryce@myhost ~]$ sudo udevadm info /dev/sdy | grep "ID_PATH="
E: ID_PATH=pci-0000:5c:00.0-sas-0x50014380436ed48a-lun-0
[bryce@myhost ~]$ sudo udevadm info /dev/sdx | grep "ID_PATH="
E: ID_PATH=pci-0000:5c:00.0-sas-0x50014380436ed489-lun-0

note the ID_PATH var for udev is unique, and matches what sysfs shows
in /sys/class/scsi_disk/X:X/device/sas_address

==================================================================
[bryce@myhost ~]$ cat /sys/class/scsi_disk/*/device/sas_address
0x31402ec0130545a0
0x31402ec0130545a2
0x50014380436ec7c0
0x50014380436ec7ca
0x50014380436ec7c1
0x50014380436ec7cb
0x50014380436ed480
0x50014380436ed481
0x50014380436ed482
0x50014380436ed483
0x50014380436ed484
0x50014380436ed485
0x50014380436ed486
0x50014380436ed487
0x50014380436ed488
0x50014380436ec7c2
0x50014380436ed489
0x50014380436ed48a
0x50014380436ed48b
0x50014380436ec7c3
0x50014380436ec7c4
0x50014380436ec7c5
0x50014380436ec7c6
0x50014380436ec7c7
0x50014380436ec7c8
0x50014380436ec7c9


==================================================================
[bryce@myhost ~]$  ls -al /sys/class/sas_device/
total 0
drwxr-xr-x  2 root root 0 Jul 13 20:40 .
drwxr-xr-x 73 root root 0 Jul 13 20:35 ..
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-0:1 ->
../../devices/pci0000:36/0000:36:02.0/0000:38:00.0/host0/port-0:1/end_device-0:1/sas_device/end_device-0:1
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-0:2 ->
../../devices/pci0000:36/0000:36:02.0/0000:38:00.0/host0/port-0:2/end_device-0:2/sas_device/end_device-0:2
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-0:3 ->
../../devices/pci0000:36/0000:36:02.0/0000:38:00.0/host0/port-0:3/end_device-0:3/sas_device/end_device-0:3
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:1 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:1/end_device-1:1/sas_device/end_device-1:1
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:10 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:10/end_device-1:10/sas_device/end_device-1:10
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:11 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:11/end_device-1:11/sas_device/end_device-1:11
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:12 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:12/end_device-1:12/sas_device/end_device-1:12
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:13 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:13/end_device-1:13/sas_device/end_device-1:13
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:14 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:14/end_device-1:14/sas_device/end_device-1:14
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:15 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:15/end_device-1:15/sas_device/end_device-1:15
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:16 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:16/end_device-1:16/sas_device/end_device-1:16
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:17 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:17/end_device-1:17/sas_device/end_device-1:17
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:18 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:18/end_device-1:18/sas_device/end_device-1:18
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:19 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:19/end_device-1:19/sas_device/end_device-1:19
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:2 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:2/end_device-1:2/sas_device/end_device-1:2
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:20 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:20/end_device-1:20/sas_device/end_device-1:20
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:21 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:21/end_device-1:21/sas_device/end_device-1:21
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:22 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:22/end_device-1:22/sas_device/end_device-1:22
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:23 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:23/end_device-1:23/sas_device/end_device-1:23
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:24 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:24/end_device-1:24/sas_device/end_device-1:24
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:25 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:25/end_device-1:25/sas_device/end_device-1:25
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:26 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:26/end_device-1:26/sas_device/end_device-1:26
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:27 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:27/end_device-1:27/sas_device/end_device-1:27
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:3 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:3/end_device-1:3/sas_device/end_device-1:3
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:4 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:4/end_device-1:4/sas_device/end_device-1:4
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:5 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:5/end_device-1:5/sas_device/end_device-1:5
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:6 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:6/end_device-1:6/sas_device/end_device-1:6
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:7 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:7/end_device-1:7/sas_device/end_device-1:7
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:8 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:8/end_device-1:8/sas_device/end_device-1:8
lrwxrwxrwx  1 root root 0 Jul 13 20:35 end_device-1:9 ->
../../devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host1/port-1:9/end_device-1:9/sas_device/end_device-1:9
==================================================================
[bryce@myhost ~]$ for d in $(ls
/sys/class/sas_device/end_device*/sas_address); do echo $d; cat
$d;done
/sys/class/sas_device/end_device-0:1/sas_address
0x31402ec0130545a0
/sys/class/sas_device/end_device-0:2/sas_address
0x31402ec0130545a2
/sys/class/sas_device/end_device-0:3/sas_address
0x51402ec0130545a8
/sys/class/sas_device/end_device-1:10/sas_address
0x50014380436ec7c9
/sys/class/sas_device/end_device-1:11/sas_address
0x50014380436ec7ca
/sys/class/sas_device/end_device-1:12/sas_address
0x50014380436ec7cb
/sys/class/sas_device/end_device-1:13/sas_address
0x50014380436ed480
/sys/class/sas_device/end_device-1:14/sas_address
0x50014380436ed481
/sys/class/sas_device/end_device-1:15/sas_address
0x50014380436ed482
/sys/class/sas_device/end_device-1:16/sas_address
0x50014380436ed483
/sys/class/sas_device/end_device-1:17/sas_address
0x50014380436ed484
/sys/class/sas_device/end_device-1:18/sas_address
0x50014380436ed485
/sys/class/sas_device/end_device-1:19/sas_address
0x50014380436ed486
/sys/class/sas_device/end_device-1:1/sas_address
0x50014380436ec7c0
/sys/class/sas_device/end_device-1:20/sas_address
0x50014380436ed487
/sys/class/sas_device/end_device-1:21/sas_address
0x50014380436ed488
/sys/class/sas_device/end_device-1:22/sas_address
0x50014380436ed489
/sys/class/sas_device/end_device-1:23/sas_address
0x50014380436ed48a
/sys/class/sas_device/end_device-1:24/sas_address
0x50014380436ed48b
/sys/class/sas_device/end_device-1:25/sas_address
0x50014380436ed4bc
/sys/class/sas_device/end_device-1:26/sas_address
0x50014380436ec7fc
/sys/class/sas_device/end_device-1:27/sas_address
0x51402ec013612638
/sys/class/sas_device/end_device-1:2/sas_address
0x50014380436ec7c1
/sys/class/sas_device/end_device-1:3/sas_address
0x50014380436ec7c2
/sys/class/sas_device/end_device-1:4/sas_address
0x50014380436ec7c3
/sys/class/sas_device/end_device-1:5/sas_address
0x50014380436ec7c4
/sys/class/sas_device/end_device-1:6/sas_address
0x50014380436ec7c5
/sys/class/sas_device/end_device-1:7/sas_address
0x50014380436ec7c6
/sys/class/sas_device/end_device-1:8/sas_address
0x50014380436ec7c7
/sys/class/sas_device/end_device-1:9/sas_address
0x50014380436ec7c8
