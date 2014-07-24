From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Thu, 24 Jul 2014 16:36:12 +0100
Message-ID: <20140724153612.GA23648@sucs.org>
References: <20140724122223.GA31798@sucs.org>
 <yq1iommkgkv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <yq1iommkgkv.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 24, 2014 at 09:54:24AM -0400, Martin K. Petersen wrote:
> >>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:
> 
> Sitsofe> Fix incorrectly named variable.  Some block devices (such as
> Sitsofe> Hyper-V passthrough SSDs) support logical block provisioning
> Sitsofe> (e.g. via UNMAP) but don't set lbpme thus disabling discard. 
> 
> The fix for an SSD that is known to support LBP but which does not claim
> support for it is to use:
> 
>     echo unmap > /sys/class/scsi_disk/foo/provisioning_mode
> 
> I'm very much against short-circuiting the LBP logic in a passthrough
> driver because then we might end up in the exact situation we were
> trying to avoid with this patch series. Namely sending down commands
> unsupported by the target device.
> 
> This kind of thing really needs to be a sysadmin decision and can be
> handled with a udev rule.

The problem is that the SSD _does_ claim to support it. Here are the
results of booting Linux directly on the host hardware and looking at
the device directly with a 3.10.35 kernel:

root@sysresccd /root % uname -a
Linux sysresccd 3.10.35-std420-amd64 #2 SMP Wed Apr 2 18:31:51 UTC 2014 x86_64 Intel(R) Core(TM) i7-3930K CPU @ 3.20GHz GenuineIntel GNU/Linux
root@sysresccd /root % sg_vpd -p lbpv /dev/sdb
root@sysresccd /root % sg_inq /dev/sdb   
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=0
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: ATA     
 Product identification: ADATA SSD S510 1
 Product revision level: 5.2.
 Unit serial number: 03205115500300002076
root@sysresccd /root % sg_readcap -l /dev/sdb
Read Capacity results:
   Protection: prot_en=0, p_type=0, p_i_exponent=0
   Logical block provisioning: lbpme=1, lbprz=0
   Last logical block address=234441647 (0xdf94baf), Number of logical blocks=234441648
   Logical block length=512 bytes
   Logical blocks per physical block exponent=0
   Lowest aligned logical block address=0
Hence:
   Device size: 120034123776 bytes, 114473.5 MiB, 120.03 GB
Logical block provisioning VPD page (SBC):
  Unmap command supported (LBPU): 0
  Write same (16) with unmap bit supported (LBWS): 1
  Write same (10) with unmap bit supported (LBWS10): 0
  Logical block provisioning read zeros (LBPRZ): 0
  Anchored LBAs supported (ANC_SUP): 0
  Threshold exponent: 0
  Descriptor present (DP): 0
  Provisioning type: 0
root@sysresccd /root % sg_vpd -p bl /dev/sdb
Block limits VPD page (SBC):
  Write same no zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 0 blocks
  Optimal transfer length: 0 blocks
  Maximum prefetch length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 1
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x3fffc0 blocks
root@sysresccd /root % grep . /sys/block/sdb/device/scsi_disk/1:0:0:0/*                
/sys/block/sdb/device/scsi_disk/1:0:0:0/allow_restart:1
/sys/block/sdb/device/scsi_disk/1:0:0:0/app_tag_own:0
/sys/block/sdb/device/scsi_disk/1:0:0:0/cache_type:write back
grep: /sys/block/sdb/device/scsi_disk/1:0:0:0/device: Is a directory
/sys/block/sdb/device/scsi_disk/1:0:0:0/FUA:0
/sys/block/sdb/device/scsi_disk/1:0:0:0/manage_start_stop:1
/sys/block/sdb/device/scsi_disk/1:0:0:0/max_medium_access_timeouts:2
/sys/block/sdb/device/scsi_disk/1:0:0:0/max_write_same_blocks:0
grep: /sys/block/sdb/device/scsi_disk/1:0:0:0/power: Is a directory
/sys/block/sdb/device/scsi_disk/1:0:0:0/protection_mode:none
/sys/block/sdb/device/scsi_disk/1:0:0:0/protection_type:0
/sys/block/sdb/device/scsi_disk/1:0:0:0/provisioning_mode:writesame_16
grep: /sys/block/sdb/device/scsi_disk/1:0:0:0/subsystem: Is a directory
/sys/block/sdb/device/scsi_disk/1:0:0:0/thin_provisioning:1

So we can see it is really a SATA device that announces discard
correctly and supports discard through WRITE_SAME(16). It is the act of
passing it through Hyper-V that turned it into a SCSI device that supports
UNMAP (but not WRITE_SAME(16)), doesn't announce its SCSI conformance number
and doesn't correctly announce which features it supports. Surely in
this case it's reasonable to quirk our way around the problem?

-- 
Sitsofe | http://sucs.org/~sits/
