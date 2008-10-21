From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: Problems with new block device size reporting
Date: Tue, 21 Oct 2008 16:20:27 -0400
Message-ID: <49EC1EBE-B970-4FEA-B899-9BD07A0006F2@oracle.com>
References: <3F0757B4-6310-4EB7-9E2B-C51101BCC41A@oracle.com> <1224540525.3586.26.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:28405 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYJUUUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2008 16:20:48 -0400
In-Reply-To: <1224540525.3586.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>

On Oct 20, 2008, at Oct 20, 2008, 6:08 PM, James Bottomley wrote:
> On Mon, 2008-10-20 at 17:58 -0400, Chuck Lever wrote:
>> [ Cc'ing myself because I'm not subscribed to linux-scsi ]
>>
>> Hi James-
>>
>> I found two problems in 2.6.27:
>>
>> 1.  If CONFIG_LBD is not set on 32-bit platforms, the computation
>> added in sd_read_capacity() by commit 7404ad3b computes sz
>> incorrectly.  On my system (a Fedora 9 VMware guest with an 8GB  
>> disk),
>> sz is computed as zero.
>>
>> 2.  The new string helper string_get_size() added by commit 3c9f3681
>> goes into an infinite loop if it is passed a "size" of zero.  the  
>> "for
>> (j=0;" loop never terminates because 0*10 is always less than 1000.
>
> Actually, both reported with patches:
>
> http://marc.info/?l=linux-scsi&m=122400928411030
> http://marc.info/?l=linux-scsi&m=122400928511033

Confirmed fix.

-- 
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
