From: Sagar Borikar <sagar.borikar@gmail.com>
Subject: LSI controller resetting with fault_state 0x2622
Date: Fri, 8 Feb 2013 23:30:19 -0800
Message-ID: <CAFwMWxtk4Kmo5ztBdoLCOowsaPgzvO2JfU6jiADM4kBR8zRM5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

I am using LSI 9207 controller on mips board and ported the standard
driver came with the controller on linux-mips 2.6.23 kernel. I know
its bit old but that's what I have available on the board that I am
using.

After loading the driver, I can see the end device properly.


# lsmod
Module                  Size  Used by    Not tainted
mpt2sas 246000 0 - Live 0xc01a9000
# /config/lsscsi -t
[0:0:0:0]    disk    sas:0x5000c5001db47d9d          /dev/sda

But when I am creating the ext3 fs on the disk, It throws following error:
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done
Writing inode tables: [16844.399000] mpt2sas0: fault_state(0x2622)!
[16844.400000] mpt2sas0: sending diag reset !!
[16845.590000] mpt2sas0: diag reset: SUCCESS
[16845.687000] mpt2sas0: LSISAS2308: FWVersion(13.00.57.00),
ChipRevision(0x05), BiosVersion(07.25.00.00)
[16845.688000] mpt2sas0: Protocol=(Initiator,Target),
Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set
Full,NCQ)
[16845.720000] mpt2sas0: sending port enable !!
[16853.398000] mpt2sas0: port enable: SUCCESS

While checking the meaning of fault_state 0x2622, I happen to find a
link which states that there was an issue with the controller firmware
as following:

SCS Engineering Release Notice
Phase14 Pre-Alpha Release Version 13.250.01.00 - SAS2FW_Phase14 (SCGCQ00276613)

Total Defects Resolved (6)
(SCGCQ00268527)
HEADLINE:
DESC OF CHANGE:
TO REPRODUCE:
ISSUE DESC:
Defect 1/6
Fault 0x2622 will occur if Request Equalization bit is set during PCIe Training
Masked the unnecessary interrupts.
Using a PCIe protocol exerciser, set the Request Equalization bit in
the PCIe Training Sets. No known
systems currently set this bit.
Devices supporting Gen3 PCIe speeds can have interrupts occur when
PCIe training sets the Request
Equalization bit. The interrupt should be masked since firmware
intervention is not required. Firmware
faults on the unexpected interrupt with the belief that it is an error.

Not sure whether the problem is as described above.

Thanks
Sagar
