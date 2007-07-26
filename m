From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Thu, 26 Jul 2007 10:32:45 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B3A65@NAMAIL4.ad.lsil.com>
References: <20070726190913A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37068 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933978AbXGZQdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 12:33:32 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070726190913A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Thursday, July 26, 2007 4:09 AM, FUJITA Tomonori wrote: 
> The SMP response's function result wasn't set correctly? bsg's
> smp_rep_manufacturer didn't check the result so it showed garbase, I
> guess.
> 
> BTW, I took the code to check the result from Doug's smp_utils and put
> bsg's smp_rep_manufacturer:
> 
> http://www.kernel.org/pub/linux/kernel/people/tomo/smp/
> 
> or
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git

Thanks.    with Doug Gilberts help, I have solved the git dilema thru
firewall.  I need a socks proxy, which I found from
http://tsocks.sourceforge.net/


> 
> That's the reason why I said before, sense buffer is not used for smp
> and using sense buffer would be the easiest way to push up the mpt
> unique response to userspace.

do you suggest the scsi llds would would need to translate there own
codes (in my case iocstatus/loginfo/sasstatus) into common sense
sk/asc/ascq ?


> 
> Here's an updated patch.
> 

 The patch looks good.  It can be applied upstream.  I tested on x86_64,
not big endian (I could try out on a ppc64 when I have time).  Here is
the output from your latest tool with various expanders I have in my
lab.

# ./smp_rep_manufacturer /sys/class/bsg/sas_host2
  SAS-1.1 format: 0
  vendor identification: LSI
  product identification: Virtual SMP Port
  product revision level:

# ./smp_rep_manufacturer /sys/class/bsg/expander-3:0
  SAS-1.1 format: 1
  vendor identification: LSILOGIC
  product identification: x36-00.00.06.00
  product revision level: 0000
  component vendor identification: LSI
  component id: 531

# ./smp_rep_manufacturer /sys/class/bsg/expander-3:1
  SAS-1.1 format: 1
  vendor identification: XYRATEX
  product identification: SAS-01
  product revision level: 03A
  component vendor identification: LSI
  component id: 517

# ./smp_rep_manufacturer /sys/class/bsg/expander-3:2
  SAS-1.1 format: 1
  vendor identification: HP
  product identification: MSA 50-10D25G1
  product revision level:
  component vendor identification: LSI
  component id: 512
  component revision level: 1

# ./smp_rep_manufacturer /sys/class/bsg/expander-3:3
  SAS-1.1 format: 0
  vendor identification: LSILOGIC
  product identification: SASx12 A.0
  product revision level:
