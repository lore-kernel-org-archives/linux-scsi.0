From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Thu, 31 Jul 2008 01:18:52 -0600
Message-ID: <20080731071851.GA30534@parisc-linux.org>
References: <6cf6b73e0807271302o77700222r321102ef7be0333b@mail.gmail.com> <20080728111915N.fujita.tomonori@lab.ntt.co.jp> <6cf6b73e0807301259s309f6332wef74d2ac5bafe691@mail.gmail.com> <20080731135521N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56897 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYGaHSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 03:18:53 -0400
Content-Disposition: inline
In-Reply-To: <20080731135521N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adel.gadllah@gmail.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Thu, Jul 31, 2008 at 01:55:31PM +0900, FUJITA Tomonori wrote:
> Someone might think that it would be better if we can change the
> filter without specifying all the accepted commands. For example, we
> could do like:
> 
> clover:/sys/block/cciss!c0d0/cmd_filter# cat read_table
> 03 08 12 1a 1b 1c
> 
> clover:/sys/block/cciss!c0d0/cmd_filter# echo 02 > read_table_on
> 02 03 08 12 1a 1b 1c
> 
> But I don't have strong opinions about it.

We need to be able to delete as well as add.

We could have a scheme in which:

echo -- "-03" >read_table
cat read_table
08 12 1a 1b 1c

echo -- "+02 +07 +08" >read_table
cat read_table
02 07 08 12 1a 1b 1c

The + could be implicit.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
