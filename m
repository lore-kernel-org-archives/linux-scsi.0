From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: kernel addresses
Date: 28 Oct 2002 23:26:14 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1035847574.3550.109.camel@irongate.swansea.linux.org.uk>
References: <20021028230140.79410.qmail@web80305.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021028230140.79410.qmail@web80305.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

kmalloc memory comes out of the pool requested  GFP_DMA selects the ISA
space, GFP_HIGH allows all 36bits (if I remember rightly). vmalloc comes
from the whole of memory space.

the highmem I/O stuff is a 2.4 patch some people use so that DMA aware
drivers that support the full 32bit DMA range can avoid bounce buffers. 

This comes from a 2.4 transition thing. Older drivers assume memory they
access is always mapped (eg when doing PIO) so the scsi code makes sure
this is true. The bounce patch lets drivers that don't do PIO avoid
this.

2.5 does the job properly instead as part of the block rewrite

