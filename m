From: Naveen karthick <naveenkc@gmail.com>
Subject: Fwd: how to map virtual addresses for multipage SG list
Date: Mon, 16 May 2005 13:46:11 +0530
Message-ID: <918ebc9405051601165469a611@mail.gmail.com>
References: <1116223080.396680.208400@g44g2000cwa.googlegroups.com>
	 <20050516060026.3ED465FA34@attila.bofh.it>
	 <918ebc94050516010338a4d16f@mail.gmail.com>
Reply-To: Naveen karthick <naveenkc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.198]:11764 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261445AbVEPIQO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 04:16:14 -0400
Received: by rproxy.gmail.com with SMTP id b11so827790rne
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2005 01:16:11 -0700 (PDT)
In-Reply-To: <918ebc94050516010338a4d16f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi list,

I'm writing a SCSI LLD in which i have a requirement to
copy the SCSI mid-layer supplied request_buffer(as a SG list) in the
Scsi_Cmnd structure to a local buffer in the LLD. Hence i need the
virtual address of the mapped SGs but attempt to mapping results in a
panic.

Configuration:
i386 SMP machine with 1GB RAM under kernel 2.6.11.8 or 2.6.9.x(RHEL4)

I get a kernel panic under the below mentioned condition:
1) parse thro' the mid layer supplied SG list elements
2) do a kmap_atomic() (the code is in interrupt context) on the page
and get a virtual addr(vaddr)
3) memcpy the returned vaddr into local buffer upto the length of the
SG element received in the scatterlist
4) kunmap_atomic the virtual addr

This works fine as long as the SG element page size is <4K and is in
lowmem area. If the SG element page is in highmem(PG_Highmem is set in
page->flags) and the SG length is >4k (say 8k) then the memcpy panics
at the address vaddr+4K. Apparently kmap_atomic mapped only the first
4K of the 8K page properly and hence the start of the panic happened
at the start of next 4K.

My questions here are:
1) how to find the address of the next 'page' structure if the SG
element specifies a length of 8k since PAGE_SIZE is 4k on i386
2) is there an alternative to map page to virtual address safely under
interrupt context

Please correct me if I'm missing something here. 

Any help is thankfully appreciated.

thanks,
naveen

PS: I'm not subscribed to this list, please CC me on replies.
