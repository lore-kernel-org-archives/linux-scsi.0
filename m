From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH qla2xxx] Race in handling rport deletion in Qlogic driver
 during recovery causes panic
Date: Thu, 4 Dec 2014 15:18:40 -0500
Message-ID: <alpine.OSX.2.00.1412041517580.1608@administrators-macbook-pro.local>
References: <66112100.3203938.1416924145624.JavaMail.zimbra@redhat.com> <827904999.3215615.1416925002571.JavaMail.zimbra@redhat.com> <20141204084437.GA12187@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:11325 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751878AbaLDUTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 15:19:13 -0500
In-Reply-To: <20141204084437.GA12187@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org, Chad Dupuis <cdupuis@redhat.com>



On Thu, 4 Dec 2014, Christoph Hellwig wrote:

> On Tue, Nov 25, 2014 at 09:16:42AM -0500, Laurence Oberman wrote:
>> When we have an rport disconnect we race during rport deletion and re-connection resulting in a panic.
>> When we do this, we call fc_remote_port_del() just before we do the calls to re-establish the session with
>> the FC transport with fc_remote_port_add() and then fc_remote_port_rolechg().
>>
>> If we remove the call to fc_remote_port_del() before re-establishing the connection this prevents the race.
>> This patch has resolved this for multiple customers via test kernels.
>>
>> Suggested by Chad Dupuis, implemented and tested by Laurence Oberman.
>
> Chad, can you review this one?  Or do you plan to send it to me with the
> next qla2xxx update?  Note that the 3.19 merge window is about to end.

This looks good. Thanks.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
