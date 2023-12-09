Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8561804D
	for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2023 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtNv18QT"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1132C433A9
	for <linux-scsi@vger.kernel.org>; Sat,  9 Dec 2023 21:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702156382;
	bh=aGVFh4jOTf6N0DTFx18IO2Qu9irKFVZChyipNs6XttA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OtNv18QTtAgexUQHqqEYpSYJlOmQGXFzeaIP8Gn+vkjuHrse00N+EciiY8MwZiEhT
	 85axrbQry+6N+PLqYHjFyLcbt1p1tA9Id3Rus40Cb5WSqfBtrmcijcfmBncSgUYxpV
	 opJ0NHAPCWIFYANQgKpmyFv1MP2HxQbLEhBgXXh4eyA2wqXOWytgCPXJrEi8adyq7x
	 flqHWDg2LJDOfApYZNQR+HIz/lW2bKuB8Jr4DXjGeoF8+riynhcjV2yvDfL+Ofnc5g
	 KfXBT8hTZxn2JL8NBRTSvgwMslGJObr2CviCE3f0oguRf5oTNkPwRkcZApgeJx1SGi
	 v/QvdNtArweWQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id E1FC7C4332E; Sat,  9 Dec 2023 21:13:01 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 09 Dec 2023 21:13:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: encore2097@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-217599-11613-2NEupFUyi0@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

encore2097@hotmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |encore2097@hotmail.com

--- Comment #46 from encore2097@hotmail.com ---
Hello,

I'm also experiencing this issue on a single core system using the controll=
er
as an HBA with a 10 disk ZFS pool:

Card: Adaptec ASR-71605
CPU: AMD Ryzen 5950X
OS: debian bookworm
kernel: Linux stratus 6.1.0-13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.55-1
(2023-09-29) x86_64 GNU/Linux

Syslog:
kernel: aacraid: Outstanding commands on (0,1,4,0):
kernel: aacraid: Host adapter abort request.
kernel: aacraid: Outstanding commands on (0,1,4,0):
kernel: aacraid: Host adapter abort request.
kernel: aacraid: Outstanding commands on (0,1,11,0):
kernel: aacraid: Host adapter abort request.
kernel: aacraid: Outstanding commands on (0,1,4,0):
kernel: aacraid: Host adapter abort request.
kernel: aacraid: Outstanding commands on (0,1,4,0):
kernel: aacraid: Host bus reset request. SCSI hang ?
kernel: aacraid 0000:0c:00.0: outstanding cmd: midlevel-0
kernel: aacraid 0000:0c:00.0: outstanding cmd: lowlevel-0
kernel: aacraid 0000:0c:00.0: outstanding cmd: error handler-0
kernel: aacraid 0000:0c:00.0: outstanding cmd: firmware-28
kernel: aacraid 0000:0c:00.0: outstanding cmd: kernel-0
kernel: aacraid 0000:0c:00.0: Controller reset type is 3
kernel: aacraid 0000:0c:00.0: Issuing IOP reset
kernel: aacraid 0000:0c:00.0: IOP reset succeeded
kernel: aacraid: Comm Interface type2 enabled
kernel: aacraid 0000:0c:00.0: Scheduling bus rescan


Controller config:

./arcconf getconfig 1
Controllers found: 1
----------------------------------------------------------------------
Controller information
----------------------------------------------------------------------
   Controller Status                        : Optimal
   Controller Mode                          : HBA
   Channel description                      : SAS/SATA
   Controller Model                         : Adaptec ASR71605
   Controller Serial Number                 : ##########
   Temperature                              : 46 C/ 114 F (Normal)
   Installed memory                         : 1024 MB
   Copyback                                 : Disabled
   Background consistency check             : Disabled
   Automatic Failover                       : Enabled
   Global task priority                     : High
   Performance Mode                         : Default/Dynamic
   Host bus type                            : PCIe
   Host bus speed                           : 8000 MHz
   Host bus link width                      : 8 bit(s)/link(s)
   Stayawake period                         : Disabled
   Spinup limit internal drives             : 0
   Spinup limit external drives             : 0
   Defunct disk drive count                 : 0
   Logical devices/Failed/Degraded          : 0/0/0
   NCQ status                               : Enabled
   Statistics data collection mode          : Disabled
   --------------------------------------------------------
   Controller Version Information
   --------------------------------------------------------
   BIOS                                     : 7.5-0 (32118)
   Firmware                                 : 7.5-0 (32118)
   Driver                                   : 1.2-1 (50983)
   Boot Flash                               : 7.5-0 (32118)

   --------------------------------------------------------
   Controller Cache Backup Unit Information
   --------------------------------------------------------

    Overall Backup Unit Status              : Not Ready

         Backup Unit Type                   : AFM-700/700LP
         Non-Volatile Storage Status        : Ready
         Supercap Status                    : Fatal

----------------------------------------------------------------------
Logical device information
----------------------------------------------------------------------
   No logical devices configured

----------------------------------------------------------------------
Physical Device information
----------------------------------------------------------------------
      Device #0
         Device is a Hard drive
         State                              : Raw (Pass Through)
         Block Size                         : 4K
         Supported                          : Yes
         Transfer Speed                     : SATA 6.0 Gb/s
         Reported Channel,Device(T:L)       : 0,0(0:0)
         Reported Location                  : Connector 0, Device 0
         Vendor                             : ATA
         Model                              : WDC WD140EDFZ-11
         Firmware                           : 81.00A81
         Serial number                      : #####
         World-wide name                    : #####
         Reserved Size                      : 0 KB
         Used Size                          : 0 MB
         Unused Size                        : 13351936 MB
         Total Size                         : 13351936 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
         S.M.A.R.T. warnings                : 0
         Power State                        : Full rpm
         Supported Power States             : Full rpm,Powered off,Reduced =
rpm
         SSD                                : No
         NCQ status                         : Enabled
      Device #1
         Device is a Hard drive
         State                              : Raw (Pass Through)
         Block Size                         : 4K
         Supported                          : Yes
         Transfer Speed                     : SATA 6.0 Gb/s
         Reported Channel,Device(T:L)       : 0,1(1:0)
         Reported Location                  : Connector 0, Device 1
         Vendor                             : ATA
         Model                              : WDC WD140EDFZ-11
         Firmware                           : 81.00A81
         Serial number                      : #####
         World-wide name                    : #####
         Reserved Size                      : 0 KB
         Used Size                          : 0 MB
         Unused Size                        : 13351936 MB
         Total Size                         : 13351936 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
         S.M.A.R.T. warnings                : 0
         Power State                        : Full rpm
         Supported Power States             : Full rpm,Powered off,Reduced =
rpm
         SSD                                : No
         NCQ status                         : Enabled
      Device #2
         Device is a Hard drive
         State                              : Raw (Pass Through)
         Block Size                         : 4K
         Supported                          : Yes
         Transfer Speed                     : SATA 6.0 Gb/s
         Reported Channel,Device(T:L)       : 0,4(4:0)
         Reported Location                  : Connector 1, Device 0
         Vendor                             : ATA
         Model                              : WDC WD140EDFZ-11
         Firmware                           : 81.00A81
         Serial number                      : #####
         World-wide name                    : #####
         Reserved Size                      : 0 KB
         Used Size                          : 0 MB
         Unused Size                        : 13351936 MB
         Total Size                         : 13351936 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
         S.M.A.R.T. warnings                : 0
         Power State                        : Full rpm
         Supported Power States             : Full rpm,Powered off,Reduced =
rpm
         SSD                                : No
         NCQ status                         : Enabled

... snip for brevity ...

      Device #9
         Device is a Hard drive
         State                              : Raw (Pass Through)
         Block Size                         : 4K
         Supported                          : Yes
         Transfer Speed                     : SATA 6.0 Gb/s
         Reported Channel,Device(T:L)       : 0,11(11:0)
         Reported Location                  : Connector 2, Device 3
         Vendor                             : ATA
         Model                              : WDC WD140EDFZ-11
         Firmware                           : 81.00A81
         Serial number                      : #####
         World-wide name                    : #####
         Reserved Size                      : 0 KB
         Used Size                          : 0 MB
         Unused Size                        : 13351936 MB
         Total Size                         : 13351936 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
         S.M.A.R.T. warnings                : 0
         Power State                        : Full rpm
         Supported Power States             : Full rpm,Powered off,Reduced =
rpm
         SSD                                : No
         NCQ status                         : Enabled



Command completed successfully.


zfs errors:
zed: eid=3D8 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-3 size=3D4096 offset=
=3D4762294419456
priority=3D3 err=3D0 flags=3D0x180880 delay=3D163243ms bookmark=3D643:0:0:7=
5777
zed: eid=3D10 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-3 size=3D8192
offset=3D4766619205632 priority=3D1 err=3D0 flags=3D0x180880 delay=3D115074=
ms
bookmark=3D515:456914:0:0
zed: eid=3D9 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-3 size=3D4096 offset=
=3D2135816388608
priority=3D3 err=3D0 flags=3D0x180880 delay=3D163242ms bookmark=3D643:0:1:74
zed: eid=3D11 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-3 size=3D16384
offset=3D13953519005696 priority=3D1 err=3D0 flags=3D0x180880 delay=3D11507=
4ms
bookmark=3D515:0:-2:1
zed: eid=3D12 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-0 size=3D4096
offset=3D12405183983616 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
0ms
bookmark=3D515:780332:0:8
zed: eid=3D13 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-0 size=3D4096
offset=3D12405183991808 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
0ms
bookmark=3D515:780332:0:12
zed: eid=3D14 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-0 size=3D4096
offset=3D12405183995904 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
0ms
bookmark=3D515:780332:0:13
zed: eid=3D16 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-8 size=3D4096
offset=3D12405183959040 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
0ms
bookmark=3D515:780332:0:1
zed: eid=3D15 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-0 size=3D4096
offset=3D12405184004096 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
0ms
bookmark=3D515:780332:0:16
zed: eid=3D17 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-8 size=3D4096
offset=3D12405183963136 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
0ms
bookmark=3D515:780332:0:0
zed: eid=3D18 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-6 size=3D4096
offset=3D12405183979520 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
2ms
bookmark=3D515:780332:0:7
zed: eid=3D19 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-6 size=3D4096
offset=3D12405183983616 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
2ms
bookmark=3D515:780332:0:9
zed: eid=3D20 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-6 size=3D4096
offset=3D12405183995904 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
2ms
bookmark=3D515:780332:0:14
zed: eid=3D21 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-6 size=3D4096
offset=3D12405183991808 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
2ms
bookmark=3D515:780332:0:11
zed: eid=3D22 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-5 size=3D4096
offset=3D12405183983616 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
2ms
bookmark=3D515:780332:0:9
zed: eid=3D23 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-5 size=3D4096
offset=3D12405183979520 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
3ms
bookmark=3D515:780332:0:7
zed: eid=3D24 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-5 size=3D4096
offset=3D12405183991808 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
2ms
bookmark=3D515:780332:0:11
zed: eid=3D25 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-2 size=3D4096
offset=3D12405184008192 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
4ms
bookmark=3D515:780332:0:18
zed: eid=3D26 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-2 size=3D4096
offset=3D12405184020480 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
4ms
bookmark=3D515:780332:0:20
zed: eid=3D27 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-7 size=3D4096
offset=3D12405183971328 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:4
zed: eid=3D28 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-7 size=3D4096
offset=3D12405183975424 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:6
zed: eid=3D29 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-7 size=3D4096
offset=3D12405183987712 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:12
zed: eid=3D30 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-7 size=3D4096
offset=3D12405183983616 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:9
zed: eid=3D31 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-7 size=3D4096
offset=3D12405183995904 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:14
zed: eid=3D32 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-7 size=3D4096
offset=3D12405184000000 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:16
zed: eid=3D33 class=3Ddelay pool=3D'tank' vdev=3Dhdd-14-1 size=3D4096
offset=3D12405183975424 priority=3D0 err=3D0 flags=3D0x180880 delay=3D17238=
6ms
bookmark=3D515:780332:0:5

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
