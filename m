From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] target: Add max_write_same_len device attribute
Date: Fri, 16 Nov 2012 14:05:05 +0100
Message-ID: <50A63A01.3080404@redhat.com>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>  <1352405238-23267-3-git-send-email-nab@linux-iscsi.org>  <20121115105312.GC28956@infradead.org> <1353007392.4447.22.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353007392.4447.22.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Il 15/11/2012 20:23, Nicholas A. Bellinger ha scritto:
>>> > > 
>>> > > This patch adds a new max_write_same_len device attribute for use with
>>> > > WRITE_SAME w/ UNMAP=0 backend emulation.
>>> > > 
>>> > > Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
>>> > > set the default MAXIMUM WRITE SAME LENGTH value of zero.
>> > 
>> > why do we need an exposed attribute for this?
>> > 
> This is useful for userspace to reduce the allowed maximum from the
> default 0xFFFF set by IBLOCK.  Allowing huge WRITE_SAMEs can very much
> effect performance (esp. with spinning media), so being able to reduce
> the max we accept via a userspace tunable is helpful.

Unfortunately this doesn't really help.  Linux will submit the smaller
WRITE SAMEs in parallel, and this could easily bring the target to its
knees.

(This was reported to me with a Linux virtual machine sending WRITE SAME
commands to a Nexenta iSCSI target running OpenSolaris.  QEMU can be
easily replaced with LIO, with the same effect).

Paolo
