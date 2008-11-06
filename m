From: Ric Wheeler <rwheeler@redhat.com>
Subject: thin provisioned LUN support
Date: Thu, 06 Nov 2008 09:43:23 -0500
Message-ID: <4913028B.6010405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org


After talking to some vendors, one issue that came up is that the arrays 
all have a different size that is used internally to track the SCSI 
equivalent of TRIM commands (POKE/unmap).

What they would like is for us to coalesce these commands into aligned 
multiples of these chunks. If not, the target device will most likely 
ignore the bits at the beginning and end (and all small requests).

I have been thinking about whether or not we can (and should) do 
anything more than our current best effort to send down large chunks 
(note that the "chunk" size can range from reasonable sizes like 8KB or 
so up to close to 1MB!).

One suggestion is that a modified defrag sweep could be used 
periodically to update the device (a proposal I am not keen on).

Thoughts?

Ric

