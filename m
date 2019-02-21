From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 1/2] scsi: replace GFP_ATOMIC with GFP_KERNEL for
 allocations in scsi_scan.c
Date: Thu, 21 Feb 2019 10:45:19 -0800
Message-ID: <1550774719.31902.137.camel@acm.org>
References: <20190220184847.24640-1-bblock@linux.ibm.com>
         <c5bd5a82d1250471822cbf5891ea1866166cd9e6.1550740533.git.bblock@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c5bd5a82d1250471822cbf5891ea1866166cd9e6.1550740533.git.bblock@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Benjamin Block <bblock@linux.ibm.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-02-21 at 10:18 +-0100, Benjamin Block wrote:
+AD4 Looking at the code of scsi+AF8-alloc+AF8-sdev(), and all the calling contexts,
+AD4 there seems to be no reason to use GFP+AF8-ATMOIC here. All the different
+AD4 call-contexts use a mutex at some point, and nothing in between that
+AD4 requires no sleeping, as far as I could see. Additionally, the code that
+AD4 later allocates the block queue for the device (scsi+AF8-mq+AF8-alloc+AF8-queue())
+AD4 already uses GFP+AF8-KERNEL.
+AD4 
+AD4 
+AD4 +AFs ... +AF0
+AD4
+AD4 So replace all these, and give them a bit of a better chance to succeed,
+AD4 with more chances of reclaim.

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
