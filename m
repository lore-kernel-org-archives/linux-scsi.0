From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Optimize scsi_cmnd initialization and bug fix
Date: Thu, 24 Nov 2005 09:05:46 +0100
Message-ID: <1132819546.2832.28.camel@laptopd505.fenrus.org>
References: <200511232250.jANMo0g20086@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9614 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161053AbVKXIFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Nov 2005 03:05:51 -0500
In-Reply-To: <200511232250.jANMo0g20086@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Wed, 2005-11-23 at 14:50 -0800, Chen, Kenneth W wrote:
> struct scsi_cmnd is a fairly large data structure and is used
> to construct scsi command.  On x86-64 arch, it is 448 bytes.  
> 
> In scsi_get_command(), it is a bit too paranoid in zeroing the
> data structure.  Since most of the member variables will be
> initialized in various stage of I/O submission, i.e., in
> scsi_prep_fn, scsi_init_io, sd_init_command, scsi_init_cmd_errh,
> etc.  So instead of blindly zeroing the whole structure, initialize
> to some other value later on.  All it needs in scsi_get_command
> is to zero out a few member variables that aren't initialized in
> the I/O path.


actually I question this optimisation. memset uses the rep stosl code
sequence, which mean that the cpu can avoid write-allocate on the
cachelines in question, and just plain zero them in cache. If you
initialize the parts one by one, the cpu will need to do write-allocate
on the cachelines, and thus has double the memory bandwidth needed than
the existing case.

(not sure if all cpus are smart enough to avoid write allocate for rep
stosl, but most of the newer ones are)

