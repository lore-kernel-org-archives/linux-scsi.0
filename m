From: Arjan van de Ven <arjan@fenrus.demon.nl>
Subject: Re: About sg_tablesize in 2.6 kernel
Date: Sun, 01 Oct 2006 20:43:37 +0200
Message-ID: <1159728217.2891.401.camel@laptopd505.fenrus.org>
References: <451FA502.1070207@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:18366 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S932177AbWJASnq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 14:43:46 -0400
In-Reply-To: <451FA502.1070207@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org


[note: you forgot to put in a link to your sourcecode, which greatly
reduces our ability to give you good answers; please fix this]
> 
> 1. In 2.6 kernel, even if I set the sg_tablesize to SG_NONE, the 
> mid-layer is still queuing commands with use_sg=1. There is no way to 
> disable this SG at all?

in 2.6 everything is now going via the ONE sg codepath yes. The dual
code path stuff was just incredibly fragile and a bad idea.



> address=page_address(sg[i].page) + sg[i].offset;
> 
> Is this the right way? I am assuming that sg[i].page will be mapped in 
> to kernel address space as this address is created by SCSI mid-layer. Is 
> that right? Or do I have to use kmap? I tried replacing page_address 
> with kmap/kunmap. But as soon as call kunmap to unmap, the kernal 
> panics! Any thoughts?

kmap doesn't take struct page as argument.

 but.... if you show us the real code we can give you better
suggestions.

> 
> 3. Do I have to disable bottom halves before calling scsi_done()? It 
> seems that the kernel panics when I call scsi_done if I use spin_lock 
> instead of spin_lock_bh(). This is one of my spin_locks created for 
> protecting a data structure.

you don't need any locks before calling the done method.

