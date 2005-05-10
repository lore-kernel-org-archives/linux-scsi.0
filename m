From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: request for comments on sg_request changes (again)
Date: Wed, 11 May 2005 00:51:16 +0200
Message-ID: <42813AE4.6050601@shadowconnect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0003.shadowconnect.net ([213.239.201.226]:271 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261822AbVEJWph (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2005 18:45:37 -0400
Received: from p549bbaa5.dip.t-dialin.net ([84.155.186.165] helo=[192.168.1.52])
	by mail.shadowconnect.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.43)
	id 1DVdT9-0007kx-RU
	for linux-scsi@vger.kernel.org; Wed, 11 May 2005 00:44:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

for some time i asked for comments on moving sg_request into a own header 
file into include/scsi/sg_request.h. Now this time i also have a real 
implementation :-)

OK, this is a part of the queuecommand function, which uses the 
sg_request to change some flags for the request:


#ifdef CONFIG_I2O_EXT_ADAPTEC
	if (c->adaptec) {
		u32 adpt_flags = 0;

		if (SCpnt->sc_request && SCpnt->sc_request->upper_private_data) {
			i2o_sg_io_hdr_t __user *usr_ptr =
			    ((Sg_request *) (SCpnt->sc_request->
					     upper_private_data))->header.
			    usr_ptr;

			if (usr_ptr)
				get_user(adpt_flags, &usr_ptr->flags);
		}

		switch (i2o_dev->lct_data.class_id) {
		case I2O_CLASS_EXECUTIVE:
		case I2O_CLASS_RANDOM_BLOCK_STORAGE:
			/* interpret flag has to be set for executive */
			adpt_flags ^= I2O_DPT_SG_FLAG_INTERPRET;
			break;

		default:
			break;
		}

		/*
		 * for Adaptec controllers we use the PRIVATE command, because
		 * the normal SCSI EXEC doesn't support all SCSI commands on
		 * all controllers (for example READ CAPACITY).
		 */
		if (sgl_offset == SGL_OFFSET_10)
			sgl_offset = SGL_OFFSET_12;
		cmd = I2O_CMD_PRIVATE << 24;
		writel(I2O_VENDOR_DPT << 16 | I2O_CMD_SCSI_EXEC, mptr++);
		writel(adpt_flags | tid, mptr++);
	}
#endif


and here is the sg_request.h header:



static Scsi_Request *dummy_cmdp;

typedef struct sg_scatter_hold {
	unsigned short k_use_sg;
	unsigned short sglist_len;
	unsigned bufflen;
	unsigned b_malloc_len;
	void *buffer;
	char dio_in_use;
	unsigned char cmd_opcode;
} Sg_scatter_hold;

typedef struct sg_request {
	Scsi_Request *my_cmdp;
	struct sg_request *nextrp;
	struct sg_fd *parentfp;
	Sg_scatter_hold data;
	sg_io_hdr_t header;
	unsigned char sense_b[sizeof (dummy_cmdp->sr_sense_buffer)];
	char res_used;
	char orphan;
	char sg_io_owned;
	volatile char done;
} Sg_request;


So please if you have anything against it, or know a better solution how 
a program could get some information to the LLD (at least 2 bits so far), 
please let me know...


Thank you very much in advance.


Best regards,



Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
