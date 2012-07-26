From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 10:17:26 +0000
Message-ID: <50111936.8090508@acm.org>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>   <1342454751-8950-2-git-send-email-pbonzini@redhat.com>  <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com> <1343294472.3115.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:40380 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GZKRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2012 06:17:33 -0400
In-Reply-To: <1343294472.3115.22.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 07/26/12 09:21, James Bottomley wrote:
> On Thu, 2012-07-26 at 11:04 +0200, Paolo Bonzini wrote:
>> Il 26/07/2012 10:52, James Bottomley ha scritto:
>>>>> +static unsigned int virtscsi_get_lun(u8 *lun_bytes)
>>>>> +{
>>>>> +	unsigned int lun = (lun_bytes[2] << 8) | lun_bytes[3];
>>>>> +	return lun & 16383;
>>>>> +}
>>>>> +
>>> Why are you rolling your own incomplete version of scsilun_to_int here?
>>
>> Because scsilun_to_int does not do the AND, so it would have exactly the
>> same bug I'm fixing.
> 
> It's not a bug ... it's the encoding.  All the other devices use this
> too.  Ideally we should have switched to 64 bit lun numbers for the
> encoding to be exact, but nothing so far has gone over 32 bits.  If we
> don't encode the Address method as part of the lun number, we don't get
> the reverse transform right and the addressing often fails.
> 
> That does mean that arrays that use address method=1 in REPORT LUNS have
> their lun numbers start at 16384.

Has it already been considered to modify scsilun_to_int() such that LUN
numbers start at zero even for addressing method 1 ? This is what e.g.
the function scst_unpack_lun() already does. See also
http://scst.svn.sourceforge.net/viewvc/scst/trunk/scst/src/scst_lib.c?revision=HEAD&view=markup.

Bart.
