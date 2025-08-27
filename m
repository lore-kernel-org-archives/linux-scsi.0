Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84B38DEC
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756272875; cv=none; b=GPGfcIN5E/4uRmnrock15etsK4dZEE1rtf9Gv+hx0GNkdg+qTt74X5rAOXKs6OUc6M+KdPHy5CdKPhm/t+pO2mKL3uRnCUCuxmJ/i0GRdH9BF3pDVZoCrODgmxV6nNtr0x46eVK1JqeJA/nPJZ25c0qrXrDgb//pB3WmUYznJAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756272875; c=relaxed/simple;
	bh=SSXZ5LORUOEcksN1IUCiMoJVWQ03MCD5zf9ODzR4QIo=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uxyH+UsqKt//vSlrBjRYzVdgzbYiko/tcXvmlr1Tiv2ryiE8QIuQNHBVuF/nTON4+J3Ma5xJnHVgsQUP4VLX6eDUbmc4XZ/0QAH7ooqHT8Ye4PyAPvplEzLGgeDu0p4eWRRx1amd2Ad1pWq26pvR7C8p6X35u8TwqNIGi213GBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+fNaKLK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+fNaKLK"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56D3FC116C6
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756272875;
	bh=SSXZ5LORUOEcksN1IUCiMoJVWQ03MCD5zf9ODzR4QIo=;
	h=From:To:Subject:Date:From;
	b=b+fNaKLKWWtX7BdxzZAHvV7aj28P6k90vFFmQ62Tk6kcldCPMf7CUzSkaZtg5vhPx
	 NLG7Smq0SWPG5kSp8NIvobUmLbglNNx0qNL/uIdSdUH0rF73hHCRAXvfXNyaktjGy9
	 OPlz922b/+yh+YBPsx1pI9MoEPFaBefsNhLYgcAb/3dcN3qcPMnLwUrEoFy8Awowdi
	 uqAAZkq5tyB9JVCCv5sgTpPBlOvhidu6AAFWqokGpiwI8w+XQuXil84iXyUQAbV2O/
	 2oSw5ow6C8cOW7HlmPIDLvFTLKBwrlQklpIC76g+8XrV70fFc+/goCk8sl5n5WcSZD
	 iV7KEaHVQgVMA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 4605EC53BBF; Wed, 27 Aug 2025 05:34:35 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 220504] New: [BUG] aacraid: DMA mapping leak in
 aac_send_raw_srb() causes eventual -ENOMEM failure
Date: Wed, 27 Aug 2025 05:34:34 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: shobu@ume2001.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-220504-11613@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D220504

            Bug ID: 220504
           Summary: [BUG] aacraid: DMA mapping leak in aac_send_raw_srb()
                    causes eventual -ENOMEM failure
           Product: SCSI Drivers
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: AACRAID
          Assignee: scsi_drivers-aacraid@kernel-bugs.osdl.org
          Reporter: shobu@ume2001.com
        Regression: No

Created attachment 308556
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D308556&action=3Dedit
Please refer to the details in the "Attachments" section of the main text

# Summary

On systems using the aacraid driver, repeated execution of FSACTL_SEND_RAW_=
SRB
ioctls, such as from smartctl -d aacraid,..., triggers a DMA mapping leak in
the aac_send_raw_srb() function. Over time, this exhausts DMA resources,
leading to allocation failures (-ENOMEM, reported as -12) and eventual syst=
em
instability or crash.

## Description

The aac_send_raw_srb() function in drivers/scsi/aacraid/commctrl.c is
responsible for handling raw SRB commands from userspace. When processing a
command with a scatter/gather (SG) list, the function iterates through the
list, allocates kernel memory for each entry (kmalloc), and maps it for DMA
using dma_map_single.

However, the corresponding dma_unmap_single call is missing from all code
paths, including both the success and error-handling (cleanup) paths.
Consequently, every SG entry processed through this ioctl leaks its DMA
mapping.

This continuous resource leak eventually prevents new DMA mappings from bei=
ng
created, causing I/O operations to fail with -ENOMEM. This is observed in
kernel logs as aac_read:

```
aac_read: aac_fib_send failed with status: -12
```

Eventually, the system becomes unstable or crashes.

## Affected Versions

Observed on AlmaLinux 9 kernels (5.14.x) through kernel-ml 6.14.9 from ELRe=
po.
Based on code inspection, the issue likely persists in the latest upstream
aacraid driver.

**Note:** AlmaLinux 9.x and `kernel-ml` packages use the upstream `aacraid`
code without distribution-specific modifications.

## Steps to Reproduce

1. Use a system with an Adaptec RAID controller (e.g., ASR81605ZQ or ASR716=
05).
2. Run the following accelerated test repeatedly for 1=E2=80=932 days:

   ```
   while true; do
       smartctl -d aacraid,N1,N2,N3 /dev/sdX
   done
   ```

   (Replace N1,N2,N3 and device names as appropriate.)

3. Monitor with the attached bpftrace script (aac_leak_monitor_pre1.bt) to
observe allocation/free imbalance during aac_send_raw_srb() execution.

## Observed Behavior

- During smartctl stress, alloc - free difference grows monotonically.
- Eventually, kernel logs show:

  ```
  aac_read: aac_fib_send failed with status: -12
  ```

  followed by system hang or reboot.

- Other tools (e.g., arcconf / MaxView) may cause temporary diffs, but they
return to zero.

## Sample Logs

```
kernel: aacraid: Host adapter abort request.
kernel: aacraid: Host bus reset request. SCSI hang?
kernel: aacraid 0000:12:00.0: outstanding cmd: midlevel-0
kernel: aacraid 0000:12:00.0: outstanding cmd: firmware-1
kernel: aacraid 0000:12:00.0: Issuing IOP reset
kernel: aacraid 0000:12:00.0: IOP reset succeeded
kernel: aac_read: aac_fib_send failed with status: -12.
(repeated hundreds of times before crash)
```

## bpftrace Output (excerpt)

```
Time Alloc: 1024 Free: 1010 Diff: 14
Bytes: 65536 Live: 14
...
Time Alloc: 2048 Free: 2010 Diff: 38
Bytes: 131072 Live: 38
```

The Diff value increases steadily during smartctl stress and never returns =
to
zero, confirming a leak in the aac_send_raw_srb() scope.

## Workaround

Enable expose_physicals in aacraid so that smartctl does not require -d. In
this mode, the leak does not occur.

## Additional Notes

Attached is a bpftrace script used to confirm the leak.
Also attached is an experimental patch (AI-assisted, not for direct use) th=
at
attempts to fix the leak by ensuring all DMA mappings are unmapped in clean=
up
paths. This patch is provided for reference only to highlight the suspected
problematic areas in aac_send_raw_srb().
The final resolution should be determined by maintainers.
This patch was generated with the assistance of AI tools and adapted by a
non-expert user. Applying AI-generated patches without a deep understanding=
 of
the subsystem and established development practices is not recommended. The
final resolution should be determined by the maintainers.

_Some logs also contained the message `"Host bus reset request. SCSI hang?"=
`,
which initially led me to suspect a relation to the issue reported on
linux-scsi (see: https://marc.info/?l=3Dlinux-scsi&m=3D168781894020549&w=3D=
2). I also
tested with the recent patch associated with that report, but it appears
unrelated to this problem. For the background and progression of my
investigation until reaching this conclusion, please refer to the following
report: "0001514: kmod-aacraid Issue Resurfaces with ASR71605 on AlmaLinux =
9.5"
(https://elrepo.org/bugs/view.php?id=3D1514)._

## Attachments

- aacraid-smartctl-test - script for accelerated test
- aac_leak_monitor_pre1.bt =E2=80=93 bpftrace script for leak detection
- aacraid-fix-aac_send_raw_srb-memleak.patch =E2=80=93 experimental patch (=
reference
only)

## Test Environments

### **Test Environments A**

```
System:
  Host: serverA Kernel: 6.14.9-1.el9.elrepo.x86_64 arch: x86_64 bits: 64
  Console: pty pts/0 Distro: AlmaLinux 9.6 (Sage Margay)
Machine:
  Type: Unknown Mobo: ASRockRack model: X470D4U serial: M80-D8000100878 UEF=
I:
American Megatrends
    LLC. v: L4.29A date: 03/11/2024
Memory:
  System RAM: total: 32 GiB available: 30.21 GiB used: 18.28 GiB (60.5%)
  Array-1: capacity: 128 GiB slots: 4 modules: 2 EC: Multi-bit ECC
  Device-1: Channel-A DIMM 0 type: no module installed
  Device-2: Channel-A DIMM 1 type: DDR4 size: 16 GiB speed: 3200 MT/s
  Device-3: Channel-B DIMM 0 type: no module installed
  Device-4: Channel-B DIMM 1 type: DDR4 size: 16 GiB speed: 3200 MT/s
CPU:
  Info: 6-core model: AMD Ryzen 5 PRO 4650G with Radeon Graphics
```

```
# arcconf getconfig 1 AD | grep 'Model'
   Controller Model                           : Adaptec ASR81605ZQ
```

```
# arcconf getversion 1
Controllers found: 1
Controller #1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firmware                               : 7.18-0 (33556)
Staged Firmware                        : 7.18-0 (33556)
BIOS                                   : 7.18-0 (33556)
Driver                                 : 1.2-1 (50983)
Boot Flash                             : 7.18-0 (33556)
CPLD (Load version/ Flash version)     : 12/ 12
SEEPROM (Load version/ Flash version)  : 1/ 1
FCT Custom Init String Version         : 0x0
```

---

### **Test Environments B**

```
System:
  Host: serverB Kernel: 6.14.9-1.el9.elrepo.x86_64 arch: x86_64 bits: 64
  Console: pty pts/4 Distro: AlmaLinux 9.6 (Sage Margay)
Machine:
  Type: Unknown Mobo: ASRockRack model: X470D4U serial: M80-D6013900227
    UEFI-[Legacy]: American Megatrends v: P3.50 date: 11/02/2020
Memory:
  System RAM: total: 48 GiB available: 46.73 GiB used: 16.34 GiB (35.0%)
  Array-1: capacity: 128 GiB slots: 4 modules: 4 EC: Multi-bit ECC
  Device-1: Channel-A DIMM 0 type: DDR4 size: 16 GiB speed: spec: 3200 MT/s
actual: 2933 MT/s
  Device-2: Channel-A DIMM 1 type: DDR4 size: 8 GiB speed: spec: 3200 MT/s
actual: 2933 MT/s
  Device-3: Channel-B DIMM 0 type: DDR4 size: 16 GiB speed: spec: 3200 MT/s
actual: 2933 MT/s
  Device-4: Channel-B DIMM 1 type: DDR4 size: 8 GiB speed: spec: 3200 MT/s
actual: 2933 MT/s
CPU:
  Info: 6-core model: AMD Ryzen 5 2600
```

```
# arcconf getconfig 1 AD | grep 'Model'
   Controller Model                           : Adaptec ASR71605
```

```
# arcconf getversion 1
Controllers found: 1
Controller #1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firmware                               : 7.5-0 (32118)
Staged Firmware                        : 7.5-0 (32118)
BIOS                                   : 7.5-0 (32118)
Driver                                 : 1.2-1 (50983)
Boot Flash                             : 7.5-0 (32118)
CPLD (Load version/ Flash version)     : 8/ 10
SEEPROM (Load version/ Flash version)  : 1/ 1
```

---

### **Test Environments C**

```
System:
  Host: serverC Kernel: 6.14.9-1.el9.elrepo.x86_64 arch: x86_64 bits: 64
  Console: pty pts/0 Distro: AlmaLinux 9.6 (Sage Margay)
Machine:
  Type: Desktop Mobo: ASUSTeK model: ROG STRIX B350-F GAMING v: Rev X.0x
serial: 171012711504156
    UEFI: American Megatrends v: 6232 date: 09/29/2024
Memory:
  System RAM: total: 16 GiB available: 15.28 GiB used: 1.28 GiB (8.3%)
  Array-1: capacity: 128 GiB slots: 4 modules: 2 EC: None
  Device-1: DIMM_A1 type: no module installed
  Device-2: DIMM_A2 type: DDR4 size: 8 GiB speed: 2666 MT/s
  Device-3: DIMM_B1 type: no module installed
  Device-4: DIMM_B2 type: DDR4 size: 8 GiB speed: 2666 MT/s
CPU:
  Info: 6-core model: AMD Ryzen 5 1600
```

```
# arcconf getconfig 1 AD | grep 'Model'
   Controller Model                           : Adaptec ASR71605
```

```
# arcconf getversion 1
Controllers found: 1
Controller #1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Firmware                               : 7.5-0 (32118)
Staged Firmware                        : 7.5-0 (32118)
BIOS                                   : 7.5-0 (32118)
Driver                                 : 1.2-1 (50983)
Boot Flash                             : 7.5-0 (32118)
CPLD (Load version/ Flash version)     : 7/ 10
SEEPROM (Load version/ Flash version)  : 0/ 1
```

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
