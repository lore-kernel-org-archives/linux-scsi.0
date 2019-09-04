Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622D9C3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 16:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DD52053B
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 16:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731942AbfIDQTQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731972AbfIDP60 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:26 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204769] SCSI devices missing for disks attached to controller
Date:   Wed, 04 Sep 2019 15:58:25 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: loberman@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-204769-11613-YYoO4Gb6do@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204769-11613@https.bugzilla.kernel.org/>
References: <bug-204769-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204769

--- Comment #1 from loberman@redhat.com ---
On Wed, 2019-09-04 at 15:18 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=204769
> 
>             Bug ID: 204769
>            Summary: SCSI devices missing for disks attached to
> controller
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 5.12.11
>           Hardware: Intel
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: AACRAID
>           Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
>           Reporter: linux@lanrules.de
>         Regression: No
> 
> We use an Adaptec ASR8405 RAID controller with LSI backplane. The
> RAID
> controller is configured to expose attached disks to the system
> ("Expose RAW").
> 
> Up to Linux 5.1.12, devices would show as expected. lsscsi -v
> reports:
> > [0:0:0:0]    disk    ASR8405  storage          V1.0  /dev/sda
> >   dir: /sys/bus/scsi/devices/0:0:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:0:
> > 0/0:0:0:0]
> > [0:1:4:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:4:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 4/0:1:4:0]
> > [0:1:5:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:5:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 5/0:1:5:0]
> > [0:1:6:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:6:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 6/0:1:6:0]
> > [0:1:7:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:7:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 7/0:1:7:0]
> > [0:1:8:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:8:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 8/0:1:8:0]
> > [0:1:9:0]    disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:9:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 9/0:1:9:0]
> > [0:1:10:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:10:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 10/0:1:10:0]
> > [0:1:11:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:11:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 11/0:1:11:0]
> > [0:1:12:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:12:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 12/0:1:12:0]
> > [0:1:13:0]   disk    ATA      HGST HUH721212AL T3D0  -
> >   dir: /sys/bus/scsi/devices/0:1:13:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:1:
> > 13/0:1:13:0]
> > [0:3:0:0]    enclosu LSI      SAS3x36          0601  -
> >   dir: /sys/bus/scsi/devices/0:3:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:3:
> > 0/0:3:0:0]
> > [N:0:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme0n1
> >   dir: /sys/class/nvme/nvme0/nvme0n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.3/0000:13:00.0/nvme/nvme0/nvme0
> > n1]
> > [N:1:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme1n1
> >   dir: /sys/class/nvme/nvme1/nvme1n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.4/0000:14:00.0/nvme/nvme1/nvme1
> > n1]
> 
> On Linux 5.12.11, the devices are missing. lsscsi -v reports:
> > [0:0:0:0]    disk    ASR8405  storage          V1.0  /dev/sda
> >   dir: /sys/bus/scsi/devices/0:0:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:0:
> > 0/0:0:0:0]
> > [0:3:0:0]    enclosu LSI      SAS3x36          0601  -
> >   dir: /sys/bus/scsi/devices/0:3:0:0 
> >  
> > [/sys/devices/pci0000:60/0000:60:03.1/0000:61:00.0/host0/target0:3:
> > 0/0:3:0:0]
> > [N:1:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme1n1
> >   dir: /sys/class/nvme/nvme0/nvme1n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.3/0000:13:00.0/nvme/nvme0/nvme1
> > n1]
> > [N:0:4:1]    dsk/nvm Samsung SSD 970 PRO
> > 1TB__1                 /dev/nvme0n1
> >   dir: /sys/class/nvme/nvme1/nvme0n1 
> >  
> > [/sys/devices/pci0000:10/0000:10:01.4/0000:14:00.0/nvme/nvme1/nvme0
> > n1]
> 
> Output in dmesg is basically the same, except that the following
> lines are
> missing with the newer kernel:
> 
> > [   17.016661] scsi 0:1:4:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.018313] scsi 0:1:5:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.020129] scsi 0:1:6:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.022530] scsi 0:1:7:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.024291] scsi 0:1:8:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.026041] scsi 0:1:9:0: Direct-Access     ATA      HGST
> > HUH721212AL T3D0
> > PQ: 1 ANSI: 6
> > [   17.027725] scsi 0:1:10:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> > [   17.029395] scsi 0:1:11:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> > [   17.031145] scsi 0:1:12:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> > [   17.032672] scsi 0:1:13:0: Direct-Access     ATA      HGST
> > HUH721212AL
> > T3D0 PQ: 1 ANSI: 6
> 
> The only change on the system to obtain the different behavior is
> upgrade/downgrade of the kernel via kexec.

So the driver is loading as /dev/sda is being seen above.
Seems likely to be the enclosure then that is not being probed
[0:0:0:0]    disk    ASR8405  storage          V1.0  /dev/sda 
The enclosure looks like its on another port correct ?
0:1:x:x

I am looking at what may have changed in the latest commits
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
