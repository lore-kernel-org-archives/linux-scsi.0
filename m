From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: avoid a double-fetch and a redundant copy
Date: Wed, 26 Dec 2018 05:11:55 +0800
Message-ID: <201812260515.ZT3AtaMb%fengguang.wu@intel.com>
References: <20181225201554.69395-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181225201554.69395-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, kjlu@umn.edu, pakki001@umn.edu, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kangjie,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on scsi/for-next]
[also build test ERROR on v4.20 next-20181224]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kangjie-Lu/scsi-avoid-a-double-fetch-and-a-redundant-copy/20181226-042018
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: i386-randconfig-x079-201851 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/uaccess.h:14:0,
                    from include/linux/poll.h:12,
                    from drivers//scsi/sg.c:42:
   drivers//scsi/sg.c: In function 'sg_read':
>> drivers//scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:138:41: note: in definition of macro '__inttype'
    __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
                                            ^
>> drivers//scsi/sg.c:449:14: note: in expansion of macro 'get_user'
        retval = get_user(req_pack_id,
                 ^~~~~~~~
>> arch/x86/include/asm/uaccess.h:138:12: error: first argument to '__builtin_choose_expr' not a constant
    __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
               ^
>> arch/x86/include/asm/uaccess.h:174:11: note: in expansion of macro '__inttype'
     register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);  \
              ^~~~~~~~~
>> drivers//scsi/sg.c:449:14: note: in expansion of macro 'get_user'
        retval = get_user(req_pack_id,
                 ^~~~~~~~
>> drivers//scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:180:15: note: in definition of macro 'get_user'
           : "0" (ptr), "i" (sizeof(*(ptr))));  \
                  ^~~
>> drivers//scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:180:35: note: in definition of macro 'get_user'
           : "0" (ptr), "i" (sizeof(*(ptr))));  \
                                      ^~~
>> drivers//scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:181:30: note: in definition of macro 'get_user'
     (x) = (__force __typeof__(*(ptr))) __val_gu;   \
                                 ^~~
--
   In file included from include/linux/uaccess.h:14:0,
                    from include/linux/poll.h:12,
                    from drivers/scsi/sg.c:42:
   drivers/scsi/sg.c: In function 'sg_read':
   drivers/scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:138:41: note: in definition of macro '__inttype'
    __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
                                            ^
   drivers/scsi/sg.c:449:14: note: in expansion of macro 'get_user'
        retval = get_user(req_pack_id,
                 ^~~~~~~~
>> arch/x86/include/asm/uaccess.h:138:12: error: first argument to '__builtin_choose_expr' not a constant
    __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
               ^
>> arch/x86/include/asm/uaccess.h:174:11: note: in expansion of macro '__inttype'
     register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);  \
              ^~~~~~~~~
   drivers/scsi/sg.c:449:14: note: in expansion of macro 'get_user'
        retval = get_user(req_pack_id,
                 ^~~~~~~~
   drivers/scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:180:15: note: in definition of macro 'get_user'
           : "0" (ptr), "i" (sizeof(*(ptr))));  \
                  ^~~
   drivers/scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:180:35: note: in definition of macro 'get_user'
           : "0" (ptr), "i" (sizeof(*(ptr))));  \
                                      ^~~
   drivers/scsi/sg.c:450:27: error: request for member 'pack_id' in something not a structure or union
          &((sg_io_hdr_t *)buf->pack_id));
                              ^
   arch/x86/include/asm/uaccess.h:181:30: note: in definition of macro 'get_user'
     (x) = (__force __typeof__(*(ptr))) __val_gu;   \
                                 ^~~

vim +/pack_id +450 drivers//scsi/sg.c

   412	
   413	static ssize_t
   414	sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
   415	{
   416		Sg_device *sdp;
   417		Sg_fd *sfp;
   418		Sg_request *srp;
   419		int req_pack_id = -1;
   420		sg_io_hdr_t *hp;
   421		struct sg_header *old_hdr = NULL;
   422		int retval = 0;
   423	
   424		/*
   425		 * This could cause a response to be stranded. Close the associated
   426		 * file descriptor to free up any resources being held.
   427		 */
   428		retval = sg_check_file_access(filp, __func__);
   429		if (retval)
   430			return retval;
   431	
   432		if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
   433			return -ENXIO;
   434		SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
   435					      "sg_read: count=%d\n", (int) count));
   436	
   437		if (!access_ok(VERIFY_WRITE, buf, count))
   438			return -EFAULT;
   439		if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
   440			old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
   441			if (!old_hdr)
   442				return -ENOMEM;
   443			if (__copy_from_user(old_hdr, buf, SZ_SG_HEADER)) {
   444				retval = -EFAULT;
   445				goto free_old_hdr;
   446			}
   447			if (old_hdr->reply_len < 0) {
   448				if (count >= SZ_SG_IO_HDR) {
 > 449					retval = get_user(req_pack_id,
 > 450							&((sg_io_hdr_t *)buf->pack_id));
   451					if (retval) {
   452						retval = -EFAULT;
   453						goto free_old_hdr;
   454					}
   455				}
   456			} else
   457				req_pack_id = old_hdr->pack_id;
   458		}
   459		srp = sg_get_rq_mark(sfp, req_pack_id);
   460		if (!srp) {		/* now wait on packet to arrive */
   461			if (atomic_read(&sdp->detaching)) {
   462				retval = -ENODEV;
   463				goto free_old_hdr;
   464			}
   465			if (filp->f_flags & O_NONBLOCK) {
   466				retval = -EAGAIN;
   467				goto free_old_hdr;
   468			}
   469			retval = wait_event_interruptible(sfp->read_wait,
   470				(atomic_read(&sdp->detaching) ||
   471				(srp = sg_get_rq_mark(sfp, req_pack_id))));
   472			if (atomic_read(&sdp->detaching)) {
   473				retval = -ENODEV;
   474				goto free_old_hdr;
   475			}
   476			if (retval) {
   477				/* -ERESTARTSYS as signal hit process */
   478				goto free_old_hdr;
   479			}
   480		}
   481		if (srp->header.interface_id != '\0') {
   482			retval = sg_new_read(sfp, buf, count, srp);
   483			goto free_old_hdr;
   484		}
   485	
   486		hp = &srp->header;
   487		if (old_hdr == NULL) {
   488			old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
   489			if (! old_hdr) {
   490				retval = -ENOMEM;
   491				goto free_old_hdr;
   492			}
   493		}
   494		memset(old_hdr, 0, SZ_SG_HEADER);
   495		old_hdr->reply_len = (int) hp->timeout;
   496		old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
   497		old_hdr->pack_id = hp->pack_id;
   498		old_hdr->twelve_byte =
   499		    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
   500		old_hdr->target_status = hp->masked_status;
   501		old_hdr->host_status = hp->host_status;
   502		old_hdr->driver_status = hp->driver_status;
   503		if ((CHECK_CONDITION & hp->masked_status) ||
   504		    (DRIVER_SENSE & hp->driver_status))
   505			memcpy(old_hdr->sense_buffer, srp->sense_b,
   506			       sizeof (old_hdr->sense_buffer));
   507		switch (hp->host_status) {
   508		/* This setup of 'result' is for backward compatibility and is best
   509		   ignored by the user who should use target, host + driver status */
   510		case DID_OK:
   511		case DID_PASSTHROUGH:
   512		case DID_SOFT_ERROR:
   513			old_hdr->result = 0;
   514			break;
   515		case DID_NO_CONNECT:
   516		case DID_BUS_BUSY:
   517		case DID_TIME_OUT:
   518			old_hdr->result = EBUSY;
   519			break;
   520		case DID_BAD_TARGET:
   521		case DID_ABORT:
   522		case DID_PARITY:
   523		case DID_RESET:
   524		case DID_BAD_INTR:
   525			old_hdr->result = EIO;
   526			break;
   527		case DID_ERROR:
   528			old_hdr->result = (srp->sense_b[0] == 0 && 
   529					  hp->masked_status == GOOD) ? 0 : EIO;
   530			break;
   531		default:
   532			old_hdr->result = EIO;
   533			break;
   534		}
   535	
   536		/* Now copy the result back to the user buffer.  */
   537		if (count >= SZ_SG_HEADER) {
   538			if (__copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
   539				retval = -EFAULT;
   540				goto free_old_hdr;
   541			}
   542			buf += SZ_SG_HEADER;
   543			if (count > old_hdr->reply_len)
   544				count = old_hdr->reply_len;
   545			if (count > SZ_SG_HEADER) {
   546				if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
   547					retval = -EFAULT;
   548					goto free_old_hdr;
   549				}
   550			}
   551		} else
   552			count = (old_hdr->result == 0) ? 0 : -EIO;
   553		sg_finish_rem_req(srp);
   554		sg_remove_request(sfp, srp);
   555		retval = count;
   556	free_old_hdr:
   557		kfree(old_hdr);
   558		return retval;
   559	}
   560	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--17pEHd4RhPHOinZp
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--17pEHd4RhPHOinZp--
