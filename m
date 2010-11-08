From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 09:39:52 -0500
Message-ID: <20101108143952.GB22121@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org


Some comments on the configfs to backend API:

 - the various get_*_info methods look like they really should use
   the seq_file API.  That gives you safety against overflows,
   and simplifies the code.
 - why are show_configfs_dev_params and get_dev_info separate
   methods if they always end up calling the same code?
 - the set_configfs_dev_params method implementation contains some
   rather nast parsing code.  They look like they really should use
   the parser.h helpers we use for mount option parsing.
