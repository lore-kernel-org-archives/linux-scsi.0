From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: lpfc driver loading is rebooting the box: 2.6.33 and above.
Date: Fri, 12 Mar 2010 00:41:25 -0800
Message-ID: <1268383285.7818.58.camel@keith-laptop>
References: <1268256548.7818.20.camel@keith-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53281 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0CLIl0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2010 03:41:26 -0500
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id o2C8bBXb001931
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 01:37:11 -0700
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2C8fPEH122330
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 01:41:25 -0700
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2C8hp6W011968
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 01:43:52 -0700
In-Reply-To: <1268256548.7818.20.camel@keith-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: rlary@us.ibm.com, James Smart <james.smart@Emulex.Com>

On Wed, 2010-03-10 at 13:29 -0800, Keith Mannthey wrote:
> I moved forwarded and a server started rebooting while loading the
> kernel current kernels. 
> 
> I isolated it to the lpfc driver. 
> 
> Upsteam kernels tried so far:
> 
> 3.6.34-rc1
> 3.4.33-git15 
Update on the issue. It gets weird. 

2.6.33 stock worked ok. 

A different .config file was working just fine on an identical setup so
I started peeling away at .config changes. 


I really have no idea about this option change and it will have to be
punted to those more in the know. 

the diff between a good and a bad kernel is....

@@ -130,7 +130,7 @@
 CONFIG_RD_BZIP2=y
 # CONFIG_RD_LZMA is not set
 # CONFIG_RD_LZO is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
 CONFIG_EMBEDDED=y

This is some gcc optimization flag change. In the working config I have
CONFIG_CC_OPTIMIZE_FOR_SIZE=y.  If I don't optimize I get the badness. 


 gcc -v
Using built-in specs.
Target: x86_64-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
--mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.3
--enable-ssp --disable-libssp --with-bugurl=http://bugs.opensuse.org/
--with-pkgversion='SUSE Linux' --disable-libgcj --disable-libmudflap
--with-slibdir=/lib64 --with-system-zlib --enable-__cxa_atexit
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch
--enable-version-specific-runtime-libs --program-suffix=-4.3
--enable-linux-futex --without-system-libunwind --with-cpu=generic
--build=x86_64-suse-linux
Thread model: posix
gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux)


Thanks,
  Keith Mannthey 
  LTC LTC-FS 

