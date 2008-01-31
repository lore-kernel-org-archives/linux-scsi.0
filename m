From: Halim Issa <yallaone@gmail.com>
Subject: Re: sd incorrectly reports write cache disabled on cache-capable drives/controllers
Date: Thu, 31 Jan 2008 11:41:53 +0100
Message-ID: <200801311141.53367.yallaone@gmail.com>
References: <200801252159.20858.yallaone@gmail.com> <200801252228.22659.yallaone@gmail.com> <1201296801.3119.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:32665 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760349AbYAaKl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 05:41:59 -0500
Received: by fk-out-0910.google.com with SMTP id z23so524162fkz.5
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jan 2008 02:41:57 -0800 (PST)
In-Reply-To: <1201296801.3119.63.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

Hi,

On Friday 25 January 2008 22:33:21 James Bottomley wrote:
> I don't think it would be correct to assume that there actually is a
> problem.  Most RAID controllers habitually lie about having a cache in
> their INQUIRY strings because they don't want to deal with the kernel
> sending SYNCHRONIZE_CACHE commands down.

I just tested this with two various Linux-distributions to verify that that 
the problem is in the inquiry and is not performance related. Unfortunately 
it turns out there's a rather huge performance difference.

When testing this with CentOS, I not only got the "correct" report from the 
kernel that write cache enabled (and no warnings about things being 
disabled), and also saw a three times increase in write performance when 
testing with dd.

The tests, which are far from scientific, I used the following command:
Read test: dd if=/dev/sda of=/dev/zero bs=64k count=10000
Write test: dd if=/dev/zero of/tmp/outfile bs=64k count=10000

CentOS results:
dd READ test 1st run: 64.9MB/s
dd READ test consecutive runs: 2.2 GB/s
dd WRITE test 1st run: 304 MB/s
dd WRITE test consecute runs: 329 MB/s

Other distributions, identical kernel config & initrd setup:
dd READ test 1st run: 65,2MB/s
dd READ test consecutive runs: 3.1 GB/s
dd WRITE test 1st run: 129 MB/s
dd WRITE test consecute runs: 98 MB/s

So to conclude, what I would like to figure out is what LSI Logic / RedHat is 
doing to get such a dramatic increase in Write performance and if that is in 
any way associated with their system reporting that the write cache is 
actually enabled.

Furthermore, I'm highly puzzled to see that the non-RedHat kernels are 
actually faster than RedHat on cached read access. I've tried this over long 
periods with various loads and uptimes on the systems, and the test results 
are quite persistent.

Note that on both setups, the mptfusion drivers are loaded as modules from an 
initrd. No special parameters are passed to these drivers in either setup. I 
have mirrored the kernel .config between the two, and have also gone through 
the patches to the 2.6.18 kernel in RedHat that are relevant to mptfusion 
without finding anything that matches.

I have also tried with the very latest drivers from LSI Logic, just recently 
released, on both systems, and the performance data remain the same.

I'm sorry to open this issue again as I hoped and believed that it was 
resolved as per the description above, but since it turns out to be a very 
real performance difference associated with it, it might be of interest to 
others as well to get to the bottom of it?

The full dmesg, kernel config and other information is available at
http://www.hiawata.com/linux/
(system is still not in production and is therefor available for wild 
experimentation)

Thanks again for your patient and insightful responses
