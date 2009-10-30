From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] sd: WRITE SAME(16) / UNMAP support
Date: Fri, 30 Oct 2009 12:02:41 -0400
Message-ID: <4AEB0E21.4060401@redhat.com>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>	<1256873409-12668-3-git-send-email-martin.petersen@oracle.com>	<4AEA6B76.2010303@interlog.com> <yq1pr85scs4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbZJ3P7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2009 11:59:38 -0400
In-Reply-To: <yq1pr85scs4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dgilbert@interlog.com, hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On 10/30/2009 12:53 AM, Martin K. Petersen wrote:
>>>>>> "Doug" == Douglas Gilbert<dgilbert@interlog.com>  writes:
>>>>>>              
> Doug>  And if both are supported by the logical unit, the patch prefers
> Doug>  UNMAP?
>
> Yes.
>
> SBC states that if the device reports MAXIMUM UNMAP LBA COUNT>  1 and
> MAXIMUM UNMAP DESCRIPTOR COUNT>  1 then the device supports UNMAP.  And
> in that case that's what I'll issue.  In all other cases I'll send out
> WRITE SAME(16).  I believe that approach is what's currently considered
> best practice.
>    

This sounds like the correct thing to do.

We should at the same time try to unify the file system mount options so 
we roll out the testing in a careful way.

Specifically, I would suggest that we default to "not" issuing discards 
by default and that we try to use the same mount option for any file 
system that supports barrier discards. My worry is that we will fry 
SSD's (like the reported issues with the Intel SSD's and Windows 7) or 
have horrific performance on arrays that are not tuned for fine grained 
discards :-)

Ric

