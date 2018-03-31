From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 11/15] mpt3sas: Report Firmware Package Version from HBA
 Driver.
Date: Sat, 31 Mar 2018 16:44:15 +0800
Message-ID: <201803311603.a1U62YPT%fengguang.wu@intel.com>
References: <1522402644-3016-12-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522402644-3016-12-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Hi Chaitra,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20180329]
[cannot apply to scsi/for-next v4.16-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Chaitra-P-B/mpt3sas-Enhancements-and-Defect-fixes/20180331-123801
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/mpt3sas/mpt3sas_base.c:3878:32: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] ImageSize @@    got unsigned long [unsrestricted __le32 [usertype] ImageSize @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3878:32:    expected restricted __le32 [usertype] ImageSize
   drivers/scsi/mpt3sas/mpt3sas_base.c:3878:32:    got unsigned long [unsigned] [assigned] [usertype] data_length
>> drivers/scsi/mpt3sas/mpt3sas_base.c:3903:63: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 [usertype] Word @@    got unsignrestricted __le32 [usertype] Word @@
   drivers/scsi/mpt3sas/mpt3sas_base.c:3903:63:    expected restricted __le32 [usertype] Word
   drivers/scsi/mpt3sas/mpt3sas_base.c:3903:63:    got unsigned int [unsigned] [usertype] <noident>
   drivers/scsi/mpt3sas/mpt3sas_base.c:3906:41: sparse: restricted __le32 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_base.c:3906:41: sparse: restricted __le32 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_base.c:3906:41: sparse: restricted __le32 degrades to integer
   drivers/scsi/mpt3sas/mpt3sas_base.c:3906:41: sparse: restricted __le32 degrades to integer

vim +3878 drivers/scsi/mpt3sas/mpt3sas_base.c

  3826	
  3827	/**
  3828	 * _base_display_fwpkg_version - sends FWUpload request to pull FWPkg
  3829	 *				version from FW Image Header.
  3830	 * @ioc: per adapter object
  3831	 *
  3832	 * Returns 0 for success, non-zero for failure.
  3833	 */
  3834		static int
  3835	_base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
  3836	{
  3837		Mpi2FWImageHeader_t *FWImgHdr;
  3838		Mpi25FWUploadRequest_t *mpi_request;
  3839		Mpi2FWUploadReply_t mpi_reply;
  3840		int r = 0;
  3841		void *fwpkg_data = NULL;
  3842		dma_addr_t fwpkg_data_dma;
  3843		u16 smid, ioc_status;
  3844		size_t data_length;
  3845	
  3846		dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
  3847					__func__));
  3848	
  3849		if (ioc->base_cmds.status & MPT3_CMD_PENDING) {
  3850			pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
  3851					ioc->name, __func__);
  3852			return -EAGAIN;
  3853		}
  3854	
  3855		data_length = sizeof(Mpi2FWImageHeader_t);
  3856		fwpkg_data = pci_alloc_consistent(ioc->pdev, data_length,
  3857				&fwpkg_data_dma);
  3858		if (!fwpkg_data) {
  3859			pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
  3860					ioc->name, __FILE__, __LINE__, __func__);
  3861			return -ENOMEM;
  3862		}
  3863	
  3864		smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
  3865		if (!smid) {
  3866			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
  3867					ioc->name, __func__);
  3868			r = -EAGAIN;
  3869			goto out;
  3870		}
  3871	
  3872		ioc->base_cmds.status = MPT3_CMD_PENDING;
  3873		mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
  3874		ioc->base_cmds.smid = smid;
  3875		memset(mpi_request, 0, sizeof(Mpi25FWUploadRequest_t));
  3876		mpi_request->Function = MPI2_FUNCTION_FW_UPLOAD;
  3877		mpi_request->ImageType = MPI2_FW_UPLOAD_ITYPE_FW_FLASH;
> 3878		mpi_request->ImageSize = data_length;
  3879		ioc->build_sg(ioc, &mpi_request->SGL, 0, 0, fwpkg_data_dma,
  3880				data_length);
  3881		init_completion(&ioc->base_cmds.done);
  3882		mpt3sas_base_put_smid_default(ioc, smid);
  3883		/* Wait for 15 seconds */
  3884		wait_for_completion_timeout(&ioc->base_cmds.done,
  3885				FW_IMG_HDR_READ_TIMEOUT*HZ);
  3886		pr_info(MPT3SAS_FMT "%s: complete\n",
  3887				ioc->name, __func__);
  3888		if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
  3889			pr_err(MPT3SAS_FMT "%s: timeout\n",
  3890					ioc->name, __func__);
  3891			_debug_dump_mf(mpi_request,
  3892					sizeof(Mpi25FWUploadRequest_t)/4);
  3893			r = -ETIME;
  3894		} else {
  3895			memset(&mpi_reply, 0, sizeof(Mpi2FWUploadReply_t));
  3896			if (ioc->base_cmds.status & MPT3_CMD_REPLY_VALID) {
  3897				memcpy(&mpi_reply, ioc->base_cmds.reply,
  3898						sizeof(Mpi2FWUploadReply_t));
  3899				ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
  3900							MPI2_IOCSTATUS_MASK;
  3901				if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
  3902					FWImgHdr = (Mpi2FWImageHeader_t *)fwpkg_data;
> 3903					FWImgHdr->PackageVersion.Word =
  3904					    le32_to_cpu(FWImgHdr->PackageVersion.Word);
  3905					if (FWImgHdr->PackageVersion.Word) {
  3906						pr_info(MPT3SAS_FMT "FW Package Version"
  3907						"(%02d.%02d.%02d.%02d)\n",
  3908						ioc->name,
  3909						((FWImgHdr->PackageVersion.Word)
  3910								& 0xFF000000) >> 24,
  3911						((FWImgHdr->PackageVersion.Word)
  3912								& 0x00FF0000) >> 16,
  3913						((FWImgHdr->PackageVersion.Word)
  3914								& 0x0000FF00) >> 8,
  3915						(FWImgHdr->PackageVersion.Word)
  3916								& 0x000000FF);
  3917					}
  3918				} else {
  3919					_debug_dump_mf(&mpi_reply,
  3920							sizeof(Mpi2FWUploadReply_t)/4);
  3921				}
  3922			}
  3923		}
  3924		ioc->base_cmds.status = MPT3_CMD_NOT_USED;
  3925	out:
  3926		if (fwpkg_data)
  3927			pci_free_consistent(ioc->pdev, data_length, fwpkg_data,
  3928					fwpkg_data_dma);
  3929		return r;
  3930	}
  3931	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
