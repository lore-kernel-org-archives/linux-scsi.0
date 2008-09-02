From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 01/14] block: separate failfast into multiple bits.
Date: Tue, 2 Sep 2008 10:31:14 -0700
Message-ID: <20080902173114.GA27138@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com> <1220371543-15099-2-git-send-email-andmike@linux.vnet.ibm.com> <da824cf30809020935k6a05df54yf0a2eda1ecc9e65e@mail.gmail.com> <48BD70E6.5020702@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36045 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYIBWHc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 18:07:32 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82M7JjN015952
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 18:07:31 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82HVHR2163090
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 13:31:18 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82HVGkM005591
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 13:31:17 -0400
Content-Disposition: inline
In-Reply-To: <48BD70E6.5020702@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Grant Grundler <grundler@google.com>, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>

Mike Christie <michaelc@cs.wisc.edu> wrote:
> Grant Grundler wrote:
>> On Tue, Sep 2, 2008 at 9:05 AM, Mike Anderson
>> <andmike@linux.vnet.ibm.com> wrote:
>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>
>>> Multipath is best at handling transport errors. If it gets a device
>>> error then there is not much the multipath layer can do. It will just
>>> access the same device but from a different path.
>>>
>>> This patch breaks up failfast into device, transport and driver errors.
>>
>> Is there any document that describes what those errors are for each
>> class of transport?
>
>
>
> Not yet. For SCSI I was still trying to classify the host byte errors,  
> because drivers are using them differently. I had sent patches in the  
> thread here
> http://marc.info/?l=linux-scsi&m=121918956332584&w=2
>  that just start syncing up the transport errors for SCSI by adding some 
> new transport host byte errors and converting drivers and transport  
> classes to them.
>

I can work on a patch to the scsi_mid_low_api.txt document that describes
the mapping / policy of these changes (i.e., DID_* / sense to
SCSI_MLQUEUE_DIS_* mapping to blk_failfast_* mapping ). 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
