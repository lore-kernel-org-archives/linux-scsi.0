From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] sg driver for large page_size, lk 2.6.18
Date: Fri, 22 Sep 2006 16:23:00 -0500
Message-ID: <45145434.4080007@us.ibm.com>
References: <4511BEC1.8030809@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:53477 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932177AbWIVVXO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 17:23:14 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8MLN5PD021048
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 17:23:05 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8MLN5Vb375114
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 15:23:05 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8MLN5h5007567
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 15:23:05 -0600
In-Reply-To: <4511BEC1.8030809@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, david.falkinder@hp.com

Douglas Gilbert wrote:
> This sg driver patch addresses the problem with larger
> page sizes reported by Brian King in this post:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=115867718623631&w=2

This fixes the oops I was seeing on PPC64 with 64k pages
enabled.

Brian


> Some other related matters are also addressed. Some of these
> prevent oopses when the SG_SCATTER_SZ or scatter_elem_sz are
> set to inappropriate values.
> 
> The scatter_elem_sz has been tested up to 4 MB which should
> make the largest data transfer with one SCSI command, 32 MB
> less one block, achievable with a relatively small number
> of elements in the scatter gather list.
> 
> For consideration in lk 2.6.19 . The patch is against lk 2.6.18 .
> 
>   ChangeLog:
>     - add scatter_elem_sz boot time parameter and sysfs module
>       parameter that is initialized to SG_SCATTER_SZ
>     - the driver will then adjust scatter_elem_sz to be the
>       max(given(scatter_elem_sz), PAGE_SIZE)
>       It will also round it up, if necessary, to be a power
>       of two
>     - clean up sg.h header, correct bad urls and some statements
>       that are no longer valid
>     - make the def_reserved_size sysfs module attribute writable
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>
> 
> Doug Gilbert
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
