Return-Path: <SRS0=D4W/=WL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328D1C31E40
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 05:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D548B208C2
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Aug 2019 05:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfHOFwd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Aug 2019 01:52:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:42700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbfHOFwc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Aug 2019 01:52:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 22:52:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,388,1559545200"; 
   d="gz'50?scan'50,208,50";a="201114636"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 14 Aug 2019 22:52:26 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hy8gU-000HZn-3h; Thu, 15 Aug 2019 13:52:26 +0800
Date:   Thu, 15 Aug 2019 13:51:51 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Mark Balantzyan <mbalant3@gmail.com>
Cc:     kbuild-all@01.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Balantzyan <mbalant3@gmail.com>
Subject: Re: [PATCH] lsilogic mpt fusion: mptctl: Fixed race condition around
 mptctl_id variable using mutexes
Message-ID: <201908151359.SaIiRive%lkp@intel.com>
References: <20190814204828.13449-1-mbalant3@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eln7unvd53m35ci2"
Content-Disposition: inline
In-Reply-To: <20190814204828.13449-1-mbalant3@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--eln7unvd53m35ci2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mark,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[cannot apply to v5.3-rc4 next-20190814]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Mark-Balantzyan/lsilogic-mpt-fusion-mptctl-Fixed-race-condition-around-mptctl_id-variable-using-mutexes/20190815-115822
config: x86_64-lkp (attached as .config)
compiler: gcc-7 (Debian 7.4.0-10) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/message/fusion/mptctl.c: In function 'mptctl_do_fw_download':
>> drivers/message/fusion/mptctl.c:820:3: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
      if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
      ^~
   drivers/message/fusion/mptctl.c:822:4: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
       return -EAGAIN;
       ^~~~~~
   drivers/message/fusion/mptctl.c: In function 'mptctl_do_mpt_command':
   drivers/message/fusion/mptctl.c:1898:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
            if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL)
            ^~
   drivers/message/fusion/mptctl.c:1900:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
                    return -EAGAIN;
                    ^~~~~~

vim +/if +820 drivers/message/fusion/mptctl.c

^1da177e4c3f41 Linus Torvalds  2005-04-16   771  
^1da177e4c3f41 Linus Torvalds  2005-04-16   772  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
^1da177e4c3f41 Linus Torvalds  2005-04-16   773  /*
^1da177e4c3f41 Linus Torvalds  2005-04-16   774   * FW Download engine.
^1da177e4c3f41 Linus Torvalds  2005-04-16   775   * Outputs:	None.
^1da177e4c3f41 Linus Torvalds  2005-04-16   776   * Return:	0 if successful
^1da177e4c3f41 Linus Torvalds  2005-04-16   777   *		-EFAULT if data unavailable
^1da177e4c3f41 Linus Torvalds  2005-04-16   778   *		-ENXIO  if no such device
^1da177e4c3f41 Linus Torvalds  2005-04-16   779   *		-EAGAIN if resource problem
^1da177e4c3f41 Linus Torvalds  2005-04-16   780   *		-ENOMEM if no memory for SGE
^1da177e4c3f41 Linus Torvalds  2005-04-16   781   *		-EMLINK if too many chain buffers required
^1da177e4c3f41 Linus Torvalds  2005-04-16   782   *		-EBADRQC if adapter does not support FW download
^1da177e4c3f41 Linus Torvalds  2005-04-16   783   *		-EBUSY if adapter is busy
^1da177e4c3f41 Linus Torvalds  2005-04-16   784   *		-ENOMSG if FW upload returned bad status
^1da177e4c3f41 Linus Torvalds  2005-04-16   785   */
^1da177e4c3f41 Linus Torvalds  2005-04-16   786  static int
^1da177e4c3f41 Linus Torvalds  2005-04-16   787  mptctl_do_fw_download(int ioc, char __user *ufwbuf, size_t fwlen)
^1da177e4c3f41 Linus Torvalds  2005-04-16   788  {
^1da177e4c3f41 Linus Torvalds  2005-04-16   789  	FWDownload_t		*dlmsg;
^1da177e4c3f41 Linus Torvalds  2005-04-16   790  	MPT_FRAME_HDR		*mf;
^1da177e4c3f41 Linus Torvalds  2005-04-16   791  	MPT_ADAPTER		*iocp;
^1da177e4c3f41 Linus Torvalds  2005-04-16   792  	FWDownloadTCSGE_t	*ptsge;
^1da177e4c3f41 Linus Torvalds  2005-04-16   793  	MptSge_t		*sgl, *sgIn;
^1da177e4c3f41 Linus Torvalds  2005-04-16   794  	char			*sgOut;
^1da177e4c3f41 Linus Torvalds  2005-04-16   795  	struct buflist		*buflist;
^1da177e4c3f41 Linus Torvalds  2005-04-16   796  	struct buflist		*bl;
^1da177e4c3f41 Linus Torvalds  2005-04-16   797  	dma_addr_t		 sgl_dma;
^1da177e4c3f41 Linus Torvalds  2005-04-16   798  	int			 ret;
^1da177e4c3f41 Linus Torvalds  2005-04-16   799  	int			 numfrags = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   800  	int			 maxfrags;
^1da177e4c3f41 Linus Torvalds  2005-04-16   801  	int			 n = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   802  	u32			 sgdir;
^1da177e4c3f41 Linus Torvalds  2005-04-16   803  	u32			 nib;
^1da177e4c3f41 Linus Torvalds  2005-04-16   804  	int			 fw_bytes_copied = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   805  	int			 i;
^1da177e4c3f41 Linus Torvalds  2005-04-16   806  	int			 sge_offset = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   807  	u16			 iocstat;
^1da177e4c3f41 Linus Torvalds  2005-04-16   808  	pFWDownloadReply_t	 ReplyMsg = NULL;
ea2a788de4ce5e Kashyap, Desai  2009-05-29   809  	unsigned long		 timeleft;
^1da177e4c3f41 Linus Torvalds  2005-04-16   810  
946cbf040adb9d Moore, Eric     2006-02-02   811  	if (mpt_verify_adapter(ioc, &iocp) < 0) {
29dd3609f2fc70 Eric Moore      2007-09-14   812  		printk(KERN_DEBUG MYNAM "ioctl_fwdl - ioc%d not found!\n",
29dd3609f2fc70 Eric Moore      2007-09-14   813  				 ioc);
^1da177e4c3f41 Linus Torvalds  2005-04-16   814  		return -ENODEV; /* (-6) No such device or address */
946cbf040adb9d Moore, Eric     2006-02-02   815  	} else {
^1da177e4c3f41 Linus Torvalds  2005-04-16   816  
^1da177e4c3f41 Linus Torvalds  2005-04-16   817  		/*  Valid device. Get a message frame and construct the FW download message.
^1da177e4c3f41 Linus Torvalds  2005-04-16   818  	 	*/
b07cb166c26273 Mark Balantzyan 2019-08-14   819  		mutex_lock(&mpctl_mutex);
^1da177e4c3f41 Linus Torvalds  2005-04-16  @820  		if ((mf = mpt_get_msg_frame(mptctl_id, iocp)) == NULL)
b07cb166c26273 Mark Balantzyan 2019-08-14   821  			mutex_unlock(&mpctl_mutex);
^1da177e4c3f41 Linus Torvalds  2005-04-16   822  			return -EAGAIN;
946cbf040adb9d Moore, Eric     2006-02-02   823  	}
b07cb166c26273 Mark Balantzyan 2019-08-14   824  	mutex_lock(&mpctl_mutex);
09120a8cd38dbd Prakash, Sathya 2007-07-24   825  	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT
09120a8cd38dbd Prakash, Sathya 2007-07-24   826  	    "mptctl_do_fwdl called. mptctl_id = %xh.\n", iocp->name, mptctl_id));
b07cb166c26273 Mark Balantzyan 2019-08-14   827  	mutex_unlock(&mpctl_mutex);
09120a8cd38dbd Prakash, Sathya 2007-07-24   828  	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.bufp  = %p\n",
09120a8cd38dbd Prakash, Sathya 2007-07-24   829  	    iocp->name, ufwbuf));
09120a8cd38dbd Prakash, Sathya 2007-07-24   830  	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.fwlen = %d\n",
09120a8cd38dbd Prakash, Sathya 2007-07-24   831  	    iocp->name, (int)fwlen));
09120a8cd38dbd Prakash, Sathya 2007-07-24   832  	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: kfwdl.ioc   = %04xh\n",
09120a8cd38dbd Prakash, Sathya 2007-07-24   833  	    iocp->name, ioc));
09120a8cd38dbd Prakash, Sathya 2007-07-24   834  
^1da177e4c3f41 Linus Torvalds  2005-04-16   835  	dlmsg = (FWDownload_t*) mf;
^1da177e4c3f41 Linus Torvalds  2005-04-16   836  	ptsge = (FWDownloadTCSGE_t *) &dlmsg->SGL;
^1da177e4c3f41 Linus Torvalds  2005-04-16   837  	sgOut = (char *) (ptsge + 1);
^1da177e4c3f41 Linus Torvalds  2005-04-16   838  
^1da177e4c3f41 Linus Torvalds  2005-04-16   839  	/*
^1da177e4c3f41 Linus Torvalds  2005-04-16   840  	 * Construct f/w download request
^1da177e4c3f41 Linus Torvalds  2005-04-16   841  	 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   842  	dlmsg->ImageType = MPI_FW_DOWNLOAD_ITYPE_FW;
^1da177e4c3f41 Linus Torvalds  2005-04-16   843  	dlmsg->Reserved = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   844  	dlmsg->ChainOffset = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   845  	dlmsg->Function = MPI_FUNCTION_FW_DOWNLOAD;
^1da177e4c3f41 Linus Torvalds  2005-04-16   846  	dlmsg->Reserved1[0] = dlmsg->Reserved1[1] = dlmsg->Reserved1[2] = 0;
946cbf040adb9d Moore, Eric     2006-02-02   847  	if (iocp->facts.MsgVersion >= MPI_VERSION_01_05)
946cbf040adb9d Moore, Eric     2006-02-02   848  		dlmsg->MsgFlags = MPI_FW_DOWNLOAD_MSGFLGS_LAST_SEGMENT;
946cbf040adb9d Moore, Eric     2006-02-02   849  	else
^1da177e4c3f41 Linus Torvalds  2005-04-16   850  		dlmsg->MsgFlags = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   851  
946cbf040adb9d Moore, Eric     2006-02-02   852  
^1da177e4c3f41 Linus Torvalds  2005-04-16   853  	/* Set up the Transaction SGE.
^1da177e4c3f41 Linus Torvalds  2005-04-16   854  	 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   855  	ptsge->Reserved = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   856  	ptsge->ContextSize = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   857  	ptsge->DetailsLength = 12;
^1da177e4c3f41 Linus Torvalds  2005-04-16   858  	ptsge->Flags = MPI_SGE_FLAGS_TRANSACTION_ELEMENT;
^1da177e4c3f41 Linus Torvalds  2005-04-16   859  	ptsge->Reserved_0100_Checksum = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   860  	ptsge->ImageOffset = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   861  	ptsge->ImageSize = cpu_to_le32(fwlen);
^1da177e4c3f41 Linus Torvalds  2005-04-16   862  
^1da177e4c3f41 Linus Torvalds  2005-04-16   863  	/* Add the SGL
^1da177e4c3f41 Linus Torvalds  2005-04-16   864  	 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   865  
^1da177e4c3f41 Linus Torvalds  2005-04-16   866  	/*
^1da177e4c3f41 Linus Torvalds  2005-04-16   867  	 * Need to kmalloc area(s) for holding firmware image bytes.
^1da177e4c3f41 Linus Torvalds  2005-04-16   868  	 * But we need to do it piece meal, using a proper
^1da177e4c3f41 Linus Torvalds  2005-04-16   869  	 * scatter gather list (with 128kB MAX hunks).
^1da177e4c3f41 Linus Torvalds  2005-04-16   870  	 *
^1da177e4c3f41 Linus Torvalds  2005-04-16   871  	 * A practical limit here might be # of sg hunks that fit into
^1da177e4c3f41 Linus Torvalds  2005-04-16   872  	 * a single IOC request frame; 12 or 8 (see below), so:
^1da177e4c3f41 Linus Torvalds  2005-04-16   873  	 * For FC9xx: 12 x 128kB == 1.5 mB (max)
^1da177e4c3f41 Linus Torvalds  2005-04-16   874  	 * For C1030:  8 x 128kB == 1   mB (max)
^1da177e4c3f41 Linus Torvalds  2005-04-16   875  	 * We could support chaining, but things get ugly(ier:)
^1da177e4c3f41 Linus Torvalds  2005-04-16   876  	 *
^1da177e4c3f41 Linus Torvalds  2005-04-16   877  	 * Set the sge_offset to the start of the sgl (bytes).
^1da177e4c3f41 Linus Torvalds  2005-04-16   878  	 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   879  	sgdir = 0x04000000;		/* IOC will READ from sys mem */
^1da177e4c3f41 Linus Torvalds  2005-04-16   880  	sge_offset = sizeof(MPIHeader_t) + sizeof(FWDownloadTCSGE_t);
^1da177e4c3f41 Linus Torvalds  2005-04-16   881  	if ((sgl = kbuf_alloc_2_sgl(fwlen, sgdir, sge_offset,
^1da177e4c3f41 Linus Torvalds  2005-04-16   882  				    &numfrags, &buflist, &sgl_dma, iocp)) == NULL)
^1da177e4c3f41 Linus Torvalds  2005-04-16   883  		return -ENOMEM;
^1da177e4c3f41 Linus Torvalds  2005-04-16   884  
^1da177e4c3f41 Linus Torvalds  2005-04-16   885  	/*
^1da177e4c3f41 Linus Torvalds  2005-04-16   886  	 * We should only need SGL with 2 simple_32bit entries (up to 256 kB)
^1da177e4c3f41 Linus Torvalds  2005-04-16   887  	 * for FC9xx f/w image, but calculate max number of sge hunks
^1da177e4c3f41 Linus Torvalds  2005-04-16   888  	 * we can fit into a request frame, and limit ourselves to that.
^1da177e4c3f41 Linus Torvalds  2005-04-16   889  	 * (currently no chain support)
^1da177e4c3f41 Linus Torvalds  2005-04-16   890  	 * maxfrags = (Request Size - FWdownload Size ) / Size of 32 bit SGE
^1da177e4c3f41 Linus Torvalds  2005-04-16   891  	 *	Request		maxfrags
^1da177e4c3f41 Linus Torvalds  2005-04-16   892  	 *	128		12
^1da177e4c3f41 Linus Torvalds  2005-04-16   893  	 *	96		8
^1da177e4c3f41 Linus Torvalds  2005-04-16   894  	 *	64		4
^1da177e4c3f41 Linus Torvalds  2005-04-16   895  	 */
14d0f0b063f536 Kashyap, Desai  2009-05-29   896  	maxfrags = (iocp->req_sz - sizeof(MPIHeader_t) -
14d0f0b063f536 Kashyap, Desai  2009-05-29   897  			sizeof(FWDownloadTCSGE_t))
14d0f0b063f536 Kashyap, Desai  2009-05-29   898  			/ iocp->SGE_size;
^1da177e4c3f41 Linus Torvalds  2005-04-16   899  	if (numfrags > maxfrags) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   900  		ret = -EMLINK;
^1da177e4c3f41 Linus Torvalds  2005-04-16   901  		goto fwdl_out;
^1da177e4c3f41 Linus Torvalds  2005-04-16   902  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   903  
09120a8cd38dbd Prakash, Sathya 2007-07-24   904  	dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "DbG: sgl buffer = %p, sgfrags = %d\n",
09120a8cd38dbd Prakash, Sathya 2007-07-24   905  	    iocp->name, sgl, numfrags));
^1da177e4c3f41 Linus Torvalds  2005-04-16   906  
^1da177e4c3f41 Linus Torvalds  2005-04-16   907  	/*
^1da177e4c3f41 Linus Torvalds  2005-04-16   908  	 * Parse SG list, copying sgl itself,
^1da177e4c3f41 Linus Torvalds  2005-04-16   909  	 * plus f/w image hunks from user space as we go...
^1da177e4c3f41 Linus Torvalds  2005-04-16   910  	 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   911  	ret = -EFAULT;
^1da177e4c3f41 Linus Torvalds  2005-04-16   912  	sgIn = sgl;
^1da177e4c3f41 Linus Torvalds  2005-04-16   913  	bl = buflist;
^1da177e4c3f41 Linus Torvalds  2005-04-16   914  	for (i=0; i < numfrags; i++) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   915  
^1da177e4c3f41 Linus Torvalds  2005-04-16   916  		/* Get the SGE type: 0 - TCSGE, 3 - Chain, 1 - Simple SGE
^1da177e4c3f41 Linus Torvalds  2005-04-16   917  		 * Skip everything but Simple. If simple, copy from
^1da177e4c3f41 Linus Torvalds  2005-04-16   918  		 *	user space into kernel space.
^1da177e4c3f41 Linus Torvalds  2005-04-16   919  		 * Note: we should not have anything but Simple as
^1da177e4c3f41 Linus Torvalds  2005-04-16   920  		 *	Chain SGE are illegal.
^1da177e4c3f41 Linus Torvalds  2005-04-16   921  		 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   922  		nib = (sgIn->FlagsLength & 0x30000000) >> 28;
^1da177e4c3f41 Linus Torvalds  2005-04-16   923  		if (nib == 0 || nib == 3) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   924  			;
^1da177e4c3f41 Linus Torvalds  2005-04-16   925  		} else if (sgIn->Address) {
14d0f0b063f536 Kashyap, Desai  2009-05-29   926  			iocp->add_sge(sgOut, sgIn->FlagsLength, sgIn->Address);
^1da177e4c3f41 Linus Torvalds  2005-04-16   927  			n++;
^1da177e4c3f41 Linus Torvalds  2005-04-16   928  			if (copy_from_user(bl->kptr, ufwbuf+fw_bytes_copied, bl->len)) {
29dd3609f2fc70 Eric Moore      2007-09-14   929  				printk(MYIOC_s_ERR_FMT "%s@%d::_ioctl_fwdl - "
^1da177e4c3f41 Linus Torvalds  2005-04-16   930  					"Unable to copy f/w buffer hunk#%d @ %p\n",
29dd3609f2fc70 Eric Moore      2007-09-14   931  					iocp->name, __FILE__, __LINE__, n, ufwbuf);
^1da177e4c3f41 Linus Torvalds  2005-04-16   932  				goto fwdl_out;
^1da177e4c3f41 Linus Torvalds  2005-04-16   933  			}
^1da177e4c3f41 Linus Torvalds  2005-04-16   934  			fw_bytes_copied += bl->len;
^1da177e4c3f41 Linus Torvalds  2005-04-16   935  		}
^1da177e4c3f41 Linus Torvalds  2005-04-16   936  		sgIn++;
^1da177e4c3f41 Linus Torvalds  2005-04-16   937  		bl++;
14d0f0b063f536 Kashyap, Desai  2009-05-29   938  		sgOut += iocp->SGE_size;
^1da177e4c3f41 Linus Torvalds  2005-04-16   939  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   940  
09120a8cd38dbd Prakash, Sathya 2007-07-24   941  	DBG_DUMP_FW_DOWNLOAD(iocp, (u32 *)mf, numfrags);
^1da177e4c3f41 Linus Torvalds  2005-04-16   942  
^1da177e4c3f41 Linus Torvalds  2005-04-16   943  	/*
^1da177e4c3f41 Linus Torvalds  2005-04-16   944  	 * Finally, perform firmware download.
^1da177e4c3f41 Linus Torvalds  2005-04-16   945  	 */
946cbf040adb9d Moore, Eric     2006-02-02   946  	ReplyMsg = NULL;
ea2a788de4ce5e Kashyap, Desai  2009-05-29   947  	SET_MGMT_MSG_CONTEXT(iocp->ioctl_cmds.msg_context, dlmsg->MsgContext);
ea2a788de4ce5e Kashyap, Desai  2009-05-29   948  	INITIALIZE_MGMT_STATUS(iocp->ioctl_cmds.status)
b07cb166c26273 Mark Balantzyan 2019-08-14   949  	mutex_lock(&mpctl_mutex);
^1da177e4c3f41 Linus Torvalds  2005-04-16   950  	mpt_put_msg_frame(mptctl_id, iocp, mf);
b07cb166c26273 Mark Balantzyan 2019-08-14   951  	mutex_lock(&mpctl_mutex);
^1da177e4c3f41 Linus Torvalds  2005-04-16   952  
^1da177e4c3f41 Linus Torvalds  2005-04-16   953  	/* Now wait for the command to complete */
ea2a788de4ce5e Kashyap, Desai  2009-05-29   954  retry_wait:
ea2a788de4ce5e Kashyap, Desai  2009-05-29   955  	timeleft = wait_for_completion_timeout(&iocp->ioctl_cmds.done, HZ*60);
ea2a788de4ce5e Kashyap, Desai  2009-05-29   956  	if (!(iocp->ioctl_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
ea2a788de4ce5e Kashyap, Desai  2009-05-29   957  		ret = -ETIME;
ea2a788de4ce5e Kashyap, Desai  2009-05-29   958  		printk(MYIOC_s_WARN_FMT "%s: failed\n", iocp->name, __func__);
ea2a788de4ce5e Kashyap, Desai  2009-05-29   959  		if (iocp->ioctl_cmds.status & MPT_MGMT_STATUS_DID_IOCRESET) {
ea2a788de4ce5e Kashyap, Desai  2009-05-29   960  			mpt_free_msg_frame(iocp, mf);
ea2a788de4ce5e Kashyap, Desai  2009-05-29   961  			goto fwdl_out;
ea2a788de4ce5e Kashyap, Desai  2009-05-29   962  		}
97009a29e8c999 Kei Tokunaga    2010-06-22   963  		if (!timeleft) {
97009a29e8c999 Kei Tokunaga    2010-06-22   964  			printk(MYIOC_s_WARN_FMT
97009a29e8c999 Kei Tokunaga    2010-06-22   965  			       "FW download timeout, doorbell=0x%08x\n",
97009a29e8c999 Kei Tokunaga    2010-06-22   966  			       iocp->name, mpt_GetIocState(iocp, 0));
ea2a788de4ce5e Kashyap, Desai  2009-05-29   967  			mptctl_timeout_expired(iocp, mf);
97009a29e8c999 Kei Tokunaga    2010-06-22   968  		} else
ea2a788de4ce5e Kashyap, Desai  2009-05-29   969  			goto retry_wait;
ea2a788de4ce5e Kashyap, Desai  2009-05-29   970  		goto fwdl_out;
ea2a788de4ce5e Kashyap, Desai  2009-05-29   971  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   972  
ea2a788de4ce5e Kashyap, Desai  2009-05-29   973  	if (!(iocp->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID)) {
ea2a788de4ce5e Kashyap, Desai  2009-05-29   974  		printk(MYIOC_s_WARN_FMT "%s: failed\n", iocp->name, __func__);
ea2a788de4ce5e Kashyap, Desai  2009-05-29   975  		mpt_free_msg_frame(iocp, mf);
^1da177e4c3f41 Linus Torvalds  2005-04-16   976  		ret = -ENODATA;
^1da177e4c3f41 Linus Torvalds  2005-04-16   977  		goto fwdl_out;
^1da177e4c3f41 Linus Torvalds  2005-04-16   978  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   979  
^1da177e4c3f41 Linus Torvalds  2005-04-16   980  	if (sgl)
^1da177e4c3f41 Linus Torvalds  2005-04-16   981  		kfree_sgl(sgl, sgl_dma, buflist, iocp);
^1da177e4c3f41 Linus Torvalds  2005-04-16   982  
ea2a788de4ce5e Kashyap, Desai  2009-05-29   983  	ReplyMsg = (pFWDownloadReply_t)iocp->ioctl_cmds.reply;
^1da177e4c3f41 Linus Torvalds  2005-04-16   984  	iocstat = le16_to_cpu(ReplyMsg->IOCStatus) & MPI_IOCSTATUS_MASK;
^1da177e4c3f41 Linus Torvalds  2005-04-16   985  	if (iocstat == MPI_IOCSTATUS_SUCCESS) {
25985edcedea63 Lucas De Marchi 2011-03-30   986  		printk(MYIOC_s_INFO_FMT "F/W update successful!\n", iocp->name);
^1da177e4c3f41 Linus Torvalds  2005-04-16   987  		return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   988  	} else if (iocstat == MPI_IOCSTATUS_INVALID_FUNCTION) {
29dd3609f2fc70 Eric Moore      2007-09-14   989  		printk(MYIOC_s_WARN_FMT "Hmmm...  F/W download not supported!?!\n",
29dd3609f2fc70 Eric Moore      2007-09-14   990  			iocp->name);
29dd3609f2fc70 Eric Moore      2007-09-14   991  		printk(MYIOC_s_WARN_FMT "(time to go bang on somebodies door)\n",
^1da177e4c3f41 Linus Torvalds  2005-04-16   992  			iocp->name);
^1da177e4c3f41 Linus Torvalds  2005-04-16   993  		return -EBADRQC;
^1da177e4c3f41 Linus Torvalds  2005-04-16   994  	} else if (iocstat == MPI_IOCSTATUS_BUSY) {
29dd3609f2fc70 Eric Moore      2007-09-14   995  		printk(MYIOC_s_WARN_FMT "IOC_BUSY!\n", iocp->name);
29dd3609f2fc70 Eric Moore      2007-09-14   996  		printk(MYIOC_s_WARN_FMT "(try again later?)\n", iocp->name);
^1da177e4c3f41 Linus Torvalds  2005-04-16   997  		return -EBUSY;
^1da177e4c3f41 Linus Torvalds  2005-04-16   998  	} else {
29dd3609f2fc70 Eric Moore      2007-09-14   999  		printk(MYIOC_s_WARN_FMT "ioctl_fwdl() returned [bad] status = %04xh\n",
^1da177e4c3f41 Linus Torvalds  2005-04-16  1000  			iocp->name, iocstat);
29dd3609f2fc70 Eric Moore      2007-09-14  1001  		printk(MYIOC_s_WARN_FMT "(bad VooDoo)\n", iocp->name);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1002  		return -ENOMSG;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1003  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16  1004  	return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1005  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1006  fwdl_out:
ea2a788de4ce5e Kashyap, Desai  2009-05-29  1007  
ea2a788de4ce5e Kashyap, Desai  2009-05-29  1008  	CLEAR_MGMT_STATUS(iocp->ioctl_cmds.status);
ea2a788de4ce5e Kashyap, Desai  2009-05-29  1009  	SET_MGMT_MSG_CONTEXT(iocp->ioctl_cmds.msg_context, 0);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1010          kfree_sgl(sgl, sgl_dma, buflist, iocp);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1011  	return ret;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1012  }
^1da177e4c3f41 Linus Torvalds  2005-04-16  1013  

:::::: The code at line 820 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--eln7unvd53m35ci2
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/8EBAA==

--eln7unvd53m35ci2--
