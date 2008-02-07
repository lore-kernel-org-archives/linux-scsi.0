From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Thu, 7 Feb 2008 14:13:20 +0100
Message-ID: <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <47A751C5.60600@vlnb.net>
	 <1202149322.3096.66.camel@localhost.localdomain>
	 <47A75B8A.3020503@vlnb.net>
	 <1202151293.3096.80.camel@localhost.localdomain>
	 <47A8B210.8040202@vlnb.net>
	 <1202238802.3133.71.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.238]:59204 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628AbYBGNNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 08:13:22 -0500
Received: by wx-out-0506.google.com with SMTP id h31so3651431wxd.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Feb 2008 05:13:21 -0800 (PST)
In-Reply-To: <1202238802.3133.71.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@la>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

Since the focus of this thread shifted somewhat in the last few
messages, I'll try to summarize what has been discussed so far:
- There was a number of participants who joined this discussion
spontaneously. This suggests that there is considerable interest in
networked storage and iSCSI.
- It has been motivated why iSCSI makes sense as a storage protocol
(compared to ATA over Ethernet and Fibre Channel over Ethernet).
- The direct I/O performance results for block transfer sizes below 64
KB are a meaningful benchmark for storage target implementations.
- It has been discussed whether an iSCSI target should be implemented
in user space or in kernel space. It is clear now that an
implementation in the kernel can be made faster than a user space
implementation (http://kerneltrap.org/mailarchive/linux-kernel/2008/2/4/714804).
Regarding existing implementations, measurements have a.o. shown that
SCST is faster than STGT (30% with the following setup: iSCSI via
IPoIB and direct I/O block transfers with a size of 512 bytes).
- It has been discussed which iSCSI target implementation should be in
the mainstream Linux kernel. There is no agreement on this subject
yet. The short-term options are as follows:
1) Do not integrate any new iSCSI target implementation in the
mainstream Linux kernel.
2) Add one of the existing in-kernel iSCSI target implementations to
the kernel, e.g. SCST or PyX/LIO.
3) Create a new in-kernel iSCSI target implementation that combines
the advantages of the existing iSCSI kernel target implementations
(iETD, STGT, SCST and PyX/LIO).

As an iSCSI user, I prefer option (3). The big question is whether the
various storage target authors agree with this ?

Bart Van Assche.
