From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: Optimize scsi_cmnd initialization and bug fix
Date: Tue, 29 Nov 2005 08:37:33 +0100
Message-ID: <1133249853.2804.9.camel@laptopd505.fenrus.org>
References: <200511290122.jAT1MKg02003@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30600 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751334AbVK2Hhh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 02:37:37 -0500
In-Reply-To: <200511290122.jAT1MKg02003@unix-os.sc.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


> 
> 30 out of 38 member variables are initialized to non-zero value, about 4
> are initialized by the LLDD.  Another 4 got written in the I/O return
> path, though these 4 are sprinkled in the structure.  Even though memset
> doesn't write-allocate, there are enough code which will bring the cache
> line into the cpu anyway.  

but.. it's ALREADY in cache after the memset.... That's the entire point
of that. You put zeros in the cache without needing to get the
overwritten-in-a-few-cycles data from ram, but make sure the data is in
cache so that the next uses of it are really cheap. Eg the only cache
traffic is writing the data back to ram eventually, which is
asynchronous. By avoiding the write allocate altogether you avoid 1)
having to wait for the ram and 2) the memory bandwidth needed for it.
Both are important, and both are avoided by a memset..

> Since this is arch independent code, I'm also
> trying to optimize not just x86-64, but other arch like ia64 which doesn't
> have the same memset cache behavior.

sounds like an unoptimized cpu to me; alpha and others I'm sure will
avoid this as well.. I'd be highly surprised if ppc64 didn't as well. 

> Our experiments with I/O intensive db workload showed that removing memset
> call has a net performance gain for db workload.

which architectures?


