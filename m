From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi_ram: a RAM-based SCSI driver
Date: Fri, 07 Dec 2012 23:24:34 +0100
Message-ID: <50C26CA2.8080903@redhat.com>
References: <1354725918-14713-1-git-send-email-kirill.shutemov@linux.intel.com> <50C06EC3.20002@redhat.com> <20121207112014.GA4466@otc-wbsnb-06>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121207112014.GA4466@otc-wbsnb-06>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Stephen Cameron <stephenmcameron@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <willy@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 07/12/2012 12:20, Kirill A. Shutemov ha scritto:
>> > Is this that much faster than scsi-debug?  The discarding options surely
>> > can be added there.
> scsi_ram is about 9% faster (without fake_rw/throw_away_*) on my machine:

There are two main differences in the data path:

- scsi_debug uses locking.  Shouldn't be the culprit because otherwise
read and write would have different speed, but it's easy to add it to
scsi_ram and check.

- scsi_debug uses scsi_sg_copy_to_buffer, i.e. sg_miter_start/next/stop
in kernel/scatterlist.c.  Again, it should be easy to port the scsi_ram
code to scsi_debug or vice versa and verify if this is the culprit.

Having a completely different driver seems useless to me...

Paolo
