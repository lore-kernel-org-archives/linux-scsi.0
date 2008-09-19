From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Fri, 19 Sep 2008 21:50:18 +0400
Message-ID: <48D3E65A.4080108@vlnb.net>
References: <48ADC53B.6090501@vlnb.net> <48ADFAB7.5010201@cs.wisc.edu>	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>	 <48B59556.7050108@vlnb.net>	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org>	 <48B6E5C8.2000306@vlnb.net>	 <1219964919.13470.505.camel@haakon2.linux-iscsi.org>	 <48B823C4.7010803@vlnb.net> <e2e108260808311142lda0063bh819718a510ade505@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:55920 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbYISRuc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 13:50:32 -0400
In-Reply-To: <e2e108260808311142lda0063bh819718a510ade505@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, Jerome Martin <tramjoe.merin@gmail.com>

Bart Van Assche wrote:
> On Fri, Aug 29, 2008 at 6:28 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> It has a big problem with atomicity of changes. Configuration of each iSCSI
>> target should be atomic and on the target driver's start configuration of
>> *all* targets as a whole should be atomic as well. How are you going to
>> solve this issue?
> 
> One way to solve this (I'm not saying it's the best way to solve this)
> is to implement a transaction interface through configfs. A configfs
> interface for transactions could e.g. be implemented as follows:
> 1. Provide one integer variable representing the sequence number of
> the ongoing transaction. This variable is incremented before its value
> is returned to userspace.
> 2. Provide as many variables as needed to allow entry of all the data
> involved in the transaction.
> 3. Provide one variable for requesting a commit. A commit is requested
> by writing a number to this variable. If and only if the value written
> equals the current value of counter (1), a commit is performed.
> Whether or not this action triggered a commit must be reported to
> userspace, e.g. through errno.
> 
> User space processes must use this interface as follows:
> (a) Read counter (1).
> (b) Write all relevant data to (2).
> (c) Write the value read in step (a) to variable (3).
> (d) If step (c) reported that the transaction failed, go back to step (a).
> 
> This is an optimistic locking scheme that can be used by several
> processes simultaneously and that survives processes that are killed
> while performing a transaction.

Unfortunately, this seems to be a lot more complicated, than I would 
want to have...

> Bart.
> 

