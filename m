From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Mon, 24 Feb 2014 11:10:16 +0200
Message-ID: <20140224091016.GD8981@redhat.com>
References: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1393219950-18613-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 24, 2014 at 05:32:24AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hi MST, MKP, Paolo & Co,
> 
> The following is an initial RFC series for allowing vhost/scsi to
> accept T10 protection information (PI) as seperate SGLs along side
> existing data payload SGLs from within virtio-scsi guest memory.
> 
> In it's current form, both ends are using virtio_scsi_cmd_req->prio
> for signaling the total protection SGLs vs. data payload SGLs to be
> expected.  This is due to the current inability of virtio / vhost
> to signal a seperate SGL count specific for T10 PI metadata.
> 
> AFAICT up until this point the ->prio field has been unused, but
> I'm certainly open to better ways of signaling (to vhost) that some
> number of metadata iovs are to be expected..  Any thoughts..?
> 
> Also included is a new VIRTIO_SCSI_F_T10_PI feature bit to signal
> DIF/DIX fabric support.  Note this is currently hardcoded to 1 for
> testing purposes as v3.14-rc2 code is having problems correctly
> proposing + acknowleding feature bits so that virtio_has_feature()
> works as expected.  Still tracking this seperate bug down..
> 
> That said, here's a quick look of the WIP code in action on
> v3.14-rc2 host/guest.
> 
> Comments..?
> 
> --nab

We'll also need to add the new feature in the
virtio spec.


> <virtio-scsi + LIO FILEIO LUN in DIF TYPE1 mode>
> 
> [    3.324348] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
> [    3.324407] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
> [    3.324475] virtio-pci 0000:00:04.0: irq 42 for MSI/MSI-X
> [    3.324529] virtio-pci 0000:00:04.0: irq 43 for MSI/MSI-X
> [    3.325421] scsi0 : Virtio SCSI HBA
> [    3.486951] scsi 0:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
> [    3.515702] sd 0:0:1:0: [sda] Enabling DIF Type 1 protection
> [    3.515713] sd 0:0:1:0: [sda] 4194304 512-byte logical blocks: (2.14 GB/2.00 GiB)
> [    3.608441] sd 0:0:1:0: [sda] Write Protect is off
> [    3.632304] sd 0:0:1:0: [sda] Mode Sense: 43 00 00 08
> [    3.662132] sd 0:0:1:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [    3.938072]  sda: unknown partition table
> [    3.970423] sd 0:0:1:0: [sda] Enabling DIX T10-DIF-TYPE1-CRC protection
> [    3.970425] sd 0:0:1:0: [sda] DIF application tag size 2
> 
> <initiator side TYPE1 GENERATE for WRITE + READ -> TYPE1 VERIFY>
> 
> [  113.273961] virtio_scsi_add_cmd: CDB: 0x00 EDTL: 0 sg_count: 0 out_num: 1 in_num: 1
> [  113.277687] virtqueue_add_sgs: total_out: 1 total_in: 1
> [  114.438563] Entering sd_dif_type1_generate >>>>>>>>>>>>>>>
> [  114.438571] TYPE1 Generate: sector: 0 sdt->guard_tag: 0x21b2 sdt->app_tag: 0x0000 sdt->ref_tag: 0
> [  114.438578] TYPE1 Generate: sector: 1 sdt->guard_tag: 0xe534 sdt->app_tag: 0x0000 sdt->ref_tag: 1
> [  114.438582] TYPE1 Generate: sector: 2 sdt->guard_tag: 0x4f0b sdt->app_tag: 0x0000 sdt->ref_tag: 2
> [  114.438586] TYPE1 Generate: sector: 3 sdt->guard_tag: 0xe8cc sdt->app_tag: 0x0000 sdt->ref_tag: 3
> [  114.438590] TYPE1 Generate: sector: 4 sdt->guard_tag: 0xab21 sdt->app_tag: 0x0000 sdt->ref_tag: 4
> [  114.438594] TYPE1 Generate: sector: 5 sdt->guard_tag: 0x6c36 sdt->app_tag: 0x0000 sdt->ref_tag: 5
> [  114.438598] TYPE1 Generate: sector: 6 sdt->guard_tag: 0x5f28 sdt->app_tag: 0x0000 sdt->ref_tag: 6
> [  114.438602] TYPE1 Generate: sector: 7 sdt->guard_tag: 0xecd3 sdt->app_tag: 0x0000 sdt->ref_tag: 7
> [  114.438610] Entering sd_dif_type1_generate >>>>>>>>>>>>>>>
> [  114.438614] TYPE1 Generate: sector: 8 sdt->guard_tag: 0x01b4 sdt->app_tag: 0x0000 sdt->ref_tag: 8
> [  114.438618] TYPE1 Generate: sector: 9 sdt->guard_tag: 0x4362 sdt->app_tag: 0x0000 sdt->ref_tag: 9
> [  114.438622] TYPE1 Generate: sector: 10 sdt->guard_tag: 0x21fa sdt->app_tag: 0x0000 sdt->ref_tag: 10
> [  114.438626] TYPE1 Generate: sector: 11 sdt->guard_tag: 0xdb56 sdt->app_tag: 0x0000 sdt->ref_tag: 11
> [  114.438630] TYPE1 Generate: sector: 12 sdt->guard_tag: 0xb680 sdt->app_tag: 0x0000 sdt->ref_tag: 12
> [  114.438634] TYPE1 Generate: sector: 13 sdt->guard_tag: 0xd00f sdt->app_tag: 0x0000 sdt->ref_tag: 13
> [  114.438638] TYPE1 Generate: sector: 14 sdt->guard_tag: 0xfc4d sdt->app_tag: 0x0000 sdt->ref_tag: 14
> [  114.438643] TYPE1 Generate: sector: 15 sdt->guard_tag: 0x0447 sdt->app_tag: 0x0000 sdt->ref_tag: 15
> [  114.438655] Attaching prot_sg list for WRITE, prot_sg_count: 2
> [  114.440029] virtio_scsi_add_cmd: CDB: 0x2a EDTL: 8192 sg_count: 2 out_num: 3 in_num: 1
> [  114.440029] virtqueue_add_sgs: total_out: 5 total_in: 1
> [  132.407792] Attaching prot_sg list for READ, prot_sg_count: 1
> [  132.408039] virtio_scsi_add_cmd: CDB: 0x28 EDTL: 8192 sg_count: 2 out_num: 1 in_num: 3
> [  132.408039] virtqueue_add_sgs: total_out: 1 total_in: 4
> [  132.417454] TYPE1 Verify sector: 0 sdt->guard_tag: 0x21b2 sdt->app_tag: 0x0000 sdt->ref_tag: 0
> [  132.417459] TYPE1 Verify sector: 1 sdt->guard_tag: 0xe534 sdt->app_tag: 0x0000 sdt->ref_tag: 1
> [  132.417463] TYPE1 Verify sector: 2 sdt->guard_tag: 0x4f0b sdt->app_tag: 0x0000 sdt->ref_tag: 2
> [  132.417468] TYPE1 Verify sector: 3 sdt->guard_tag: 0xe8cc sdt->app_tag: 0x0000 sdt->ref_tag: 3
> [  132.417472] TYPE1 Verify sector: 4 sdt->guard_tag: 0xab21 sdt->app_tag: 0x0000 sdt->ref_tag: 4
> [  132.417476] TYPE1 Verify sector: 5 sdt->guard_tag: 0x6c36 sdt->app_tag: 0x0000 sdt->ref_tag: 5
> [  132.417480] TYPE1 Verify sector: 6 sdt->guard_tag: 0x5f28 sdt->app_tag: 0x0000 sdt->ref_tag: 6
> [  132.417484] TYPE1 Verify sector: 7 sdt->guard_tag: 0xecd3 sdt->app_tag: 0x0000 sdt->ref_tag: 7
> [  132.417488] TYPE1 Verify sector: 8 sdt->guard_tag: 0x01b4 sdt->app_tag: 0x0000 sdt->ref_tag: 8
> [  132.417492] TYPE1 Verify sector: 9 sdt->guard_tag: 0x4362 sdt->app_tag: 0x0000 sdt->ref_tag: 9
> [  132.417496] TYPE1 Verify sector: 10 sdt->guard_tag: 0x21fa sdt->app_tag: 0x0000 sdt->ref_tag: 10
> [  132.417500] TYPE1 Verify sector: 11 sdt->guard_tag: 0xdb56 sdt->app_tag: 0x0000 sdt->ref_tag: 11
> [  132.417504] TYPE1 Verify sector: 12 sdt->guard_tag: 0xb680 sdt->app_tag: 0x0000 sdt->ref_tag: 12
> [  132.417508] TYPE1 Verify sector: 13 sdt->guard_tag: 0xd00f sdt->app_tag: 0x0000 sdt->ref_tag: 13
> [  132.417512] TYPE1 Verify sector: 14 sdt->guard_tag: 0xfc4d sdt->app_tag: 0x0000 sdt->ref_tag: 14
> [  132.417516] TYPE1 Verify sector: 15 sdt->guard_tag: 0x0447 sdt->app_tag: 0x0000 sdt->ref_tag: 15
> [  132.417540] Attaching prot_sg list for READ, prot_sg_count: 1
> [  132.420328] virtio_scsi_add_cmd: CDB: 0x28 EDTL: 8192 sg_count: 2 out_num: 1 in_num: 3
> [  132.421044] virtqueue_add_sgs: total_out: 1 total_in: 4
> [  132.429092] virtio_scsi_add_cmd: CDB: 0x00 EDTL: 0 sg_count: 0 out_num: 1 in_num: 1
> [  132.432759] virtqueue_add_sgs: total_out: 1 total_in: 1
> 
> <vhost-scsi host side processing of data + protection SGLs>
> 
> [18603.378919] vhost_get_vq_desc: head: 2, out: 1 in: 1
> [18603.378922] Calling __copy_from_user: vq->iov[0].iov_base: 00007feb89318c10, len: 51
> [18603.378925] Allocated tv_cmd: ffff88080349fb60 exp_data_len: 0, data_direction: 3
> [18603.378927] vhost_scsi got command opcode: 0x0, lun: 0
> [18603.378933] vhost_get_vq_desc: head: 128, out: 1 in: 1
> [18603.378953] vhost_scsi_complete_cmd_work tv_cmd ffff88080349fb60 resid 0 status 0x0
> [18604.546673] vhost_get_vq_desc: head: 2, out: 5 in: 1
> [18604.546678] Calling __copy_from_user: vq->iov[0].iov_base: 00007feb87e35d90, len: 51
> [18604.546684] Allocated tv_cmd: ffff88080349fb60 exp_data_len: 8192, data_direction: 1
> [18604.546688] vhost_scsi got command opcode: 0x2a, lun: 0
> [18604.546691] vhost_scsi_map_iov_to_sgl sg ffff880859460000 sgl_count 2
> [18604.546695] Mapping iovec ffff880810408908 for 2 pages
> [18604.546699] vhost_scsi_map_iov_to_prot prot_sg ffff880855f54000 prot_sgl_count 2
> [18604.546708] vhost_get_vq_desc: head: 128, out: 5 in: 1
> [18604.546773] DIF WRITE sector: 0 guard_tag: 0x21b2 app_tag: 0x0000 ref_tag: 0
> [18604.546779] DIF WRITE sector: 1 guard_tag: 0xe534 app_tag: 0x0000 ref_tag: 1
> [18604.546784] DIF WRITE sector: 2 guard_tag: 0x4f0b app_tag: 0x0000 ref_tag: 2
> [18604.546788] DIF WRITE sector: 3 guard_tag: 0xe8cc app_tag: 0x0000 ref_tag: 3
> [18604.546793] DIF WRITE sector: 4 guard_tag: 0xab21 app_tag: 0x0000 ref_tag: 4
> [18604.546797] DIF WRITE sector: 5 guard_tag: 0x6c36 app_tag: 0x0000 ref_tag: 5
> [18604.546802] DIF WRITE sector: 6 guard_tag: 0x5f28 app_tag: 0x0000 ref_tag: 6
> [18604.546807] DIF WRITE sector: 7 guard_tag: 0xecd3 app_tag: 0x0000 ref_tag: 7
> [18604.546811] DIF WRITE sector: 8 guard_tag: 0x01b4 app_tag: 0x0000 ref_tag: 8
> [18604.546816] DIF WRITE sector: 9 guard_tag: 0x4362 app_tag: 0x0000 ref_tag: 9
> [18604.546820] DIF WRITE sector: 10 guard_tag: 0x21fa app_tag: 0x0000 ref_tag: 10
> [18604.546825] DIF WRITE sector: 11 guard_tag: 0xdb56 app_tag: 0x0000 ref_tag: 11
> [18604.546829] DIF WRITE sector: 12 guard_tag: 0xb680 app_tag: 0x0000 ref_tag: 12
> [18604.546833] DIF WRITE sector: 13 guard_tag: 0xd00f app_tag: 0x0000 ref_tag: 13
> [18604.546838] DIF WRITE sector: 14 guard_tag: 0xfc4d app_tag: 0x0000 ref_tag: 14
> [18604.546842] DIF WRITE sector: 15 guard_tag: 0x0447 app_tag: 0x0000 ref_tag: 15
> [18604.605089] vhost_scsi_complete_cmd_work tv_cmd ffff88080349fb60 resid 0 status 0x0
> [18622.529730] vhost_get_vq_desc: head: 2, out: 1 in: 4
> [18622.529734] Calling __copy_from_user: vq->iov[0].iov_base: 00007feb8923d790, len: 51
> [18622.529739] Allocated tv_cmd: ffff88080349fb60 exp_data_len: 8192, data_direction: 2
> [18622.529741] vhost_scsi got command opcode: 0x28, lun: 0
> [18622.529744] vhost_scsi_map_iov_to_sgl sg ffff880859460000 sgl_count 2
> [18622.529746] Mapping iovec ffff880810408918 for 2 pages
> [18622.529749] vhost_scsi_map_iov_to_prot prot_sg ffff880855f54000 prot_sgl_count 1
> [18622.529756] vhost_get_vq_desc: head: 128, out: 1 in: 4
> [18622.529918] DIF READ sector: 0 guard_tag: 0x21b2 app_tag: 0x0000 ref_tag: 0
> [18622.529924] DIF READ sector: 1 guard_tag: 0xe534 app_tag: 0x0000 ref_tag: 1
> [18622.529929] DIF READ sector: 2 guard_tag: 0x4f0b app_tag: 0x0000 ref_tag: 2
> [18622.529933] DIF READ sector: 3 guard_tag: 0xe8cc app_tag: 0x0000 ref_tag: 3
> [18622.529938] DIF READ sector: 4 guard_tag: 0xab21 app_tag: 0x0000 ref_tag: 4
> [18622.529942] DIF READ sector: 5 guard_tag: 0x6c36 app_tag: 0x0000 ref_tag: 5
> [18622.529947] DIF READ sector: 6 guard_tag: 0x5f28 app_tag: 0x0000 ref_tag: 6
> [18622.529951] DIF READ sector: 7 guard_tag: 0xecd3 app_tag: 0x0000 ref_tag: 7
> [18622.529956] DIF READ sector: 8 guard_tag: 0x01b4 app_tag: 0x0000 ref_tag: 8
> [18622.529960] DIF READ sector: 9 guard_tag: 0x4362 app_tag: 0x0000 ref_tag: 9
> [18622.529965] DIF READ sector: 10 guard_tag: 0x21fa app_tag: 0x0000 ref_tag: 10
> [18622.529970] DIF READ sector: 11 guard_tag: 0xdb56 app_tag: 0x0000 ref_tag: 11
> [18622.529974] DIF READ sector: 12 guard_tag: 0xb680 app_tag: 0x0000 ref_tag: 12
> [18622.529978] DIF READ sector: 13 guard_tag: 0xd00f app_tag: 0x0000 ref_tag: 13
> [18622.529983] DIF READ sector: 14 guard_tag: 0xfc4d app_tag: 0x0000 ref_tag: 14
> [18622.529987] DIF READ sector: 15 guard_tag: 0x0447 app_tag: 0x0000 ref_tag: 15
> [18622.530025] vhost_scsi_complete_cmd_work tv_cmd ffff88080349fb60 resid 0 status 0x0
> [18622.541483] vhost_get_vq_desc: head: 2, out: 1 in: 4
> [18622.541486] Calling __copy_from_user: vq->iov[0].iov_base: 00007feb8923d310, len: 51
> [18622.541490] Allocated tv_cmd: ffff88080349fb60 exp_data_len: 8192, data_direction: 2
> [18622.541492] vhost_scsi got command opcode: 0x28, lun: 0
> [18622.541494] vhost_scsi_map_iov_to_sgl sg ffff880859460000 sgl_count 2
> [18622.541497] Mapping iovec ffff880810408918 for 2 pages
> [18622.541500] vhost_scsi_map_iov_to_prot prot_sg ffff880855f54000 prot_sgl_count 1
> [18622.541506] vhost_get_vq_desc: head: 128, out: 1 in: 4
> [18622.541584] DIF READ sector: 16 guard_tag: 0xffff app_tag: 0xffff ref_tag: 16
> [18622.541587] DIF READ sector: 17 guard_tag: 0xffff app_tag: 0xffff ref_tag: 17
> [18622.541589] DIF READ sector: 18 guard_tag: 0xffff app_tag: 0xffff ref_tag: 18
> [18622.541591] DIF READ sector: 19 guard_tag: 0xffff app_tag: 0xffff ref_tag: 19
> [18622.541594] DIF READ sector: 20 guard_tag: 0xffff app_tag: 0xffff ref_tag: 20
> [18622.541596] DIF READ sector: 21 guard_tag: 0xffff app_tag: 0xffff ref_tag: 21
> [18622.541598] DIF READ sector: 22 guard_tag: 0xffff app_tag: 0xffff ref_tag: 22
> [18622.541600] DIF READ sector: 23 guard_tag: 0xffff app_tag: 0xffff ref_tag: 23
> [18622.541603] DIF READ sector: 24 guard_tag: 0xffff app_tag: 0xffff ref_tag: 24
> [18622.541605] DIF READ sector: 25 guard_tag: 0xffff app_tag: 0xffff ref_tag: 25
> [18622.541607] DIF READ sector: 26 guard_tag: 0xffff app_tag: 0xffff ref_tag: 26
> [18622.541612] DIF READ sector: 27 guard_tag: 0xffff app_tag: 0xffff ref_tag: 27
> [18622.541617] DIF READ sector: 28 guard_tag: 0xffff app_tag: 0xffff ref_tag: 28
> [18622.541621] DIF READ sector: 29 guard_tag: 0xffff app_tag: 0xffff ref_tag: 29
> [18622.541625] DIF READ sector: 30 guard_tag: 0xffff app_tag: 0xffff ref_tag: 30
> [18622.541630] DIF READ sector: 31 guard_tag: 0xffff app_tag: 0xffff ref_tag: 31
> [18622.541665] vhost_scsi_complete_cmd_work tv_cmd ffff88080349fb60 resid 0 status 0x0
> [18622.548226] vhost_get_vq_desc: head: 2, out: 1 in: 1
> [18622.548228] Calling __copy_from_user: vq->iov[0].iov_base: 00007feb8923d0d0, len: 51
> [18622.548232] Allocated tv_cmd: ffff88080349fb60 exp_data_len: 0, data_direction: 3
> [18622.548234] vhost_scsi got command opcode: 0x0, lun: 0
> [18622.548240] vhost_get_vq_desc: head: 128, out: 1 in: 1
> [18622.548261] vhost_scsi_complete_cmd_work tv_cmd ffff88080349fb60 resid 0 status 0x0
> 
> --
> 
> Nicholas Bellinger (6):
>   vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
>   vhost/scsi: Add preallocation of protection SGLs
>   vhost/scsi: Add T10 PI IOV -> SGL memory mapping logic
>   vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
>   vhost/scsi: Add new VIRTIO_SCSI_F_T10_PI feature bit
>   virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
> 
>  drivers/scsi/virtio_scsi.c  |   33 +++++++--
>  drivers/vhost/scsi.c        |  170 ++++++++++++++++++++++++++++++-------------
>  include/linux/virtio_scsi.h |    1 +
>  3 files changed, 147 insertions(+), 57 deletions(-)
> 
> -- 
> 1.7.10.4
