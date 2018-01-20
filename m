From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 4/6] mpt3sas: Introduce Base function for cloning.
Date: Sun, 21 Jan 2018 01:57:14 +0800
Message-ID: <201801210158.dDNewOts%fengguang.wu@intel.com>
References: <1516365462-14708-5-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51556 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755008AbeATR5c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 20 Jan 2018 12:57:32 -0500
Content-Disposition: inline
In-Reply-To: <1516365462-14708-5-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, chaitra.basappa@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Suganath,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.15-rc8 next-20180119]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Suganath-Prabu-S/mpt3sas-Add-PCI-device-ID-for-Andromeda/20180121-002454
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: i386-randconfig-i1-201802 (attached as .config)
compiler: gcc-7 (Debian 7.2.0-12) 7.2.1 20171025
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_base_get_chain_phys':
   drivers/scsi/mpt3sas/mpt3sas_base.c:188:21: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     base_chain_phys  = (void *)ioc->chip_phys + MPI_FRAME_START_OFFSET +
                        ^
   drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_clone_sg_entries':
   drivers/scsi/mpt3sas/mpt3sas_base.c:315:10: error: implicit declaration of function 'mpt3sas_scsih_scsi_lookup_get'; did you mean 'mpt3sas_scsih_issue_locked_tm'? [-Werror=implicit-function-declaration]
      scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             mpt3sas_scsih_issue_locked_tm
   drivers/scsi/mpt3sas/mpt3sas_base.c:315:8: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
           ^
>> drivers/scsi/mpt3sas/mpt3sas_base.c:378:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
       sgel->Address = (dma_addr_t)dst_addr_phys;
                       ^
   drivers/scsi/mpt3sas/mpt3sas_base.c:389:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
          (dma_addr_t)buff_ptr_phys;
          ^
   drivers/scsi/mpt3sas/mpt3sas_base.c:395:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
             (dma_addr_t)buff_ptr_phys;
             ^
   At top level:
   drivers/scsi/mpt3sas/mpt3sas_base.c:278:13: warning: '_clone_sg_entries' defined but not used [-Wunused-function]
    static void _clone_sg_entries(struct MPT3SAS_ADAPTER *ioc,
                ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +378 drivers/scsi/mpt3sas/mpt3sas_base.c

   265	
   266	/**
   267	 * _clone_sg_entries -	MPI EP's scsiio and config requests
   268	 *			are handled here. Base function for
   269	 *			double buffering, before submitting
   270	 *			the requests.
   271	 *
   272	 * @ioc: per adapter object.
   273	 * @mpi_request: mf request pointer.
   274	 * @smid: system request message index.
   275	 *
   276	 * @Returns: Nothing.
   277	 */
   278	static void _clone_sg_entries(struct MPT3SAS_ADAPTER *ioc,
   279			void *mpi_request, u16 smid)
   280	{
   281		Mpi2SGESimple32_t *sgel, *sgel_next;
   282		u32  sgl_flags, sge_chain_count = 0;
   283		bool is_write = 0;
   284		u16 i = 0;
   285		void  *buffer_iomem, *buffer_iomem_phys;
   286		void *buff_ptr, *buff_ptr_phys;
   287		void *dst_chain_addr[MCPU_MAX_CHAINS_PER_IO];
   288		void *src_chain_addr[MCPU_MAX_CHAINS_PER_IO], *dst_addr_phys;
   289		MPI2RequestHeader_t *request_hdr;
   290		struct scsi_cmnd *scmd;
   291		struct scatterlist *sg_scmd = NULL;
   292		int is_scsiio_req = 0;
   293	
   294		request_hdr = (MPI2RequestHeader_t *) mpi_request;
   295	
   296		if (request_hdr->Function == MPI2_FUNCTION_SCSI_IO_REQUEST) {
   297			Mpi25SCSIIORequest_t *scsiio_request =
   298				(Mpi25SCSIIORequest_t *)mpi_request;
   299			sgel = (Mpi2SGESimple32_t *) &scsiio_request->SGL;
   300			is_scsiio_req = 1;
   301		} else if (request_hdr->Function == MPI2_FUNCTION_CONFIG) {
   302			Mpi2ConfigRequest_t  *config_req =
   303				(Mpi2ConfigRequest_t *)mpi_request;
   304			sgel = (Mpi2SGESimple32_t *) &config_req->PageBufferSGE;
   305		} else
   306			return;
   307	
   308		/* From smid we can get scsi_cmd, once we have sg_scmd,
   309		 * we just need to get sg_virt and sg_next to get virual
   310		 * address associated with sgel->Address.
   311		 */
   312	
   313		if (is_scsiio_req) {
   314			/* Get scsi_cmd using smid */
 > 315			scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
   316			if (scmd == NULL) {
   317				pr_err(MPT3SAS_FMT "scmd is NULL\n", ioc->name);
   318				return;
   319			}
   320	
   321			/* Get sg_scmd from scmd provided */
   322			sg_scmd = scsi_sglist(scmd);
   323		}
   324	
   325		/*
   326		 * 0 - 255	System register
   327		 * 256 - 4352	MPI Frame. (This is based on maxCredit 32)
   328		 * 4352 - 4864	Reply_free pool (512 byte is reserved
   329		 *		considering maxCredit 32. Reply need extra
   330		 *		room, for mCPU case kept four times of
   331		 *		maxCredit).
   332		 * 4864 - 17152	SGE chain element. (32cmd * 3 chain of
   333		 *		128 byte size = 12288)
   334		 * 17152 - x	Host buffer mapped with smid.
   335		 *		(Each smid can have 64K Max IO.)
   336		 * BAR0+Last 1K MSIX Addr and Data
   337		 * Total size in use 2113664 bytes of 4MB BAR0
   338		 */
   339	
   340		buffer_iomem = _base_get_buffer_bar0(ioc, smid);
   341		buffer_iomem_phys = _base_get_buffer_phys_bar0(ioc, smid);
   342	
   343		buff_ptr = buffer_iomem;
   344		buff_ptr_phys = buffer_iomem_phys;
   345	
   346		if (sgel->FlagsLength &
   347				(MPI2_SGE_FLAGS_HOST_TO_IOC << MPI2_SGE_FLAGS_SHIFT))
   348			is_write = 1;
   349	
   350		for (i = 0; i < MPT_MIN_PHYS_SEGMENTS + ioc->facts.MaxChainDepth; i++) {
   351	
   352			sgl_flags = (sgel->FlagsLength >> MPI2_SGE_FLAGS_SHIFT);
   353	
   354			switch (sgl_flags & MPI2_SGE_FLAGS_ELEMENT_MASK) {
   355			case MPI2_SGE_FLAGS_CHAIN_ELEMENT:
   356				/*
   357				 * Helper function which on passing
   358				 * chain_buffer_dma returns chain_buffer. Get
   359				 * the virtual address for sgel->Address
   360				 */
   361				sgel_next =
   362					_base_get_chain_buffer_dma_to_chain_buffer(ioc,
   363							sgel->Address);
   364				if (sgel_next == NULL)
   365					return;
   366				/*
   367				 * This is coping 128 byte chain
   368				 * frame (not a host buffer)
   369				 */
   370				dst_chain_addr[sge_chain_count] =
   371					_base_get_chain(ioc,
   372						smid, sge_chain_count);
   373				src_chain_addr[sge_chain_count] =
   374							(void *) sgel_next;
   375				dst_addr_phys =
   376					_base_get_chain_phys(ioc,
   377							smid, sge_chain_count);
 > 378				sgel->Address = (dma_addr_t)dst_addr_phys;
   379				sgel = sgel_next;
   380				sge_chain_count++;
   381				break;
   382			case MPI2_SGE_FLAGS_SIMPLE_ELEMENT:
   383				if (is_write) {
   384					if (is_scsiio_req) {
   385						_base_clone_to_sys_mem(buff_ptr,
   386						    sg_virt(sg_scmd),
   387						    (sgel->FlagsLength & 0x00ffffff));
   388						sgel->Address =
   389							(dma_addr_t)buff_ptr_phys;
   390					} else {
   391						_base_clone_to_sys_mem(buff_ptr,
   392						    ioc->config_vaddr,
   393						    (sgel->FlagsLength & 0x00ffffff));
   394						sgel->Address =
   395						    (dma_addr_t)buff_ptr_phys;
   396					}
   397				}
   398				buff_ptr += (sgel->FlagsLength & 0x00ffffff);
   399				buff_ptr_phys += (sgel->FlagsLength & 0x00ffffff);
   400				if ((sgel->FlagsLength &
   401				    (MPI2_SGE_FLAGS_END_OF_BUFFER
   402						<< MPI2_SGE_FLAGS_SHIFT)))
   403					goto eob_clone_chain;
   404				else {
   405					/*
   406					 * Every single element in MPT will have
   407					 * associated sg_next. Better to sanity that
   408					 * sg_next is not NULL, but it will be a bug
   409					 * if it is null.
   410					 */
   411					if (is_scsiio_req) {
   412						sg_scmd = sg_next(sg_scmd);
   413						if (sg_scmd)
   414							sgel++;
   415						else
   416							goto eob_clone_chain;
   417					}
   418				}
   419				break;
   420			}
   421		}
   422	
   423	eob_clone_chain:
   424		for (i = 0; i < sge_chain_count; i++) {
   425			if (is_scsiio_req)
   426				_base_clone_to_sys_mem(dst_chain_addr[i],
   427					src_chain_addr[i], ioc->request_sz);
   428		}
   429	}
   430	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--nFreZHaLTZJo0R7j
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
6nsEgNAs+VDBmncu18dLd4s3/z8Q1dM2vL4BAA==

--nFreZHaLTZJo0R7j--
