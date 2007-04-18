From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iSCSI fun in 2.6.21-rc6
Date: Wed, 18 Apr 2007 12:57:53 -0500
Message-ID: <46265C21.1070402@cs.wisc.edu>
References: <200704181622.16171.olaf.kirch@oracle.com> <46263B7D.5090200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49413 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992969AbXDRR6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2007 13:58:07 -0400
In-Reply-To: <46263B7D.5090200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Olaf Kirch wrote:
>> Hi,
>>
>> I tried to use the iSCSI initiator with iscsitarget on 2.6.21-rc6 today,
>> with rather mixed results.
>>
>> I could log in okay, and a device would appear. Trying to mount
>> that device would hang though:
>>
>> kernel: iscsi: ctask enq [read cid 0 sc df57e500 cdb 0x28 itt 0x1c len 4096 cmdsn 29 win 33]
>> kernel: iscsi: cmdrsp [op 0x25 cid 0 itt 0x1c len 0]
>> ...
>> kernel: iscsi: ctask enq [read cid 0 sc df57e500 cdb 0x28 itt 0x2b len 4096 cmdsn 44 win 33]
>> kernel: iscsi: cmdrsp [op 0x25 cid 0 itt 0x2b len 0]
>> kernel: kjournald starting.  Commit interval 5 seconds
>> kernel: iscsi: ctask enq [write cid 0 sc df57e500 cdb 0x2a itt 0x2c len 4096 cmdsn 45 win 33]
>>
>> Nothing in the logs. tcpdump shows lots of data being transmitted, and tracing
>> iscsitarget shows a storm of data_out commands being received.
>>
> 
> Could you send the trace? It is weird that we would get a storm of data
> out commands for a IO that was only 4096 bytes (assuming part of the log
> did not get cut off and the above line is the last one).

Oh yeah, does reverting the endien patches
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commitdiff;h=b4377356450e2358f5f92d34f130d6cb6574bf76
make any difference?
