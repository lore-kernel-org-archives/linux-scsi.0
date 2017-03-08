From: Christoph Hellwig <hch@infradead.org>
Subject: Re: out of range LBA using sg_raw
Date: Wed, 8 Mar 2017 07:11:13 -0800
Message-ID: <20170308151113.GB27450@infradead.org>
References: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf343e80707394b8945cd7643f7beecd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Kashyap,

for SG_IO passthrough requests we can't validate command validity
for commands as the block layer treats them as opaque.  The SCSI
device implementation needs to handle incorrect parameter to be
robust.

For your fast path bypass the megaraid driver assumes part of the
SCSI device implementation, so it will have to check for validity.
