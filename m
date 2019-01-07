From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: sd: Make protection lookup tables static
Date: Mon, 07 Jan 2019 08:57:23 -0800
Message-ID: <1546880243.83374.12.camel@acm.org>
References: <1546872111-5627-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546872111-5627-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-01-07 at 22:41 +-0800, John Garry wrote:
+AD4 Currently the protection lookup tables in sd+AF8-prot+AF8-flag+AF8-mask() and
+AD4 sd+AF8-prot+AF8-op() are declared non-static. As such, they will be rebuilt for
+AD4 each respective function call.
+AD4 
+AD4 Optimise by making them static.
+AD4 
+AD4 This saves +AH4-100B object code for sd.c:
+AD4 
+AD4 Before:
+AD4    text	   data	    bss	    dec	    hex	filename
+AD4   25403	   1024	     16	  26443	   674b	drivers/scsi/sd.o
+AD4 
+AD4 After:
+AD4   text	   data	    bss	    dec	    hex	filename
+AD4   25299	   1024	     16	  26339	   66e3	drivers/scsi/sd.o

Since the sd+AF8-prot+AF8-op() function only has a single caller, please move it from sd.h
into sd.c.

Thanks,

Bart.
