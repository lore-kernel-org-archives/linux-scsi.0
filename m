From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 11:04:32 +0200
Message-ID: <50110820.4040403@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>  <1342454751-8950-2-git-send-email-pbonzini@redhat.com> <1343292731.3115.17.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2GZJEe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2012 05:04:34 -0400
In-Reply-To: <1343292731.3115.17.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 26/07/2012 10:52, James Bottomley ha scritto:
>> > +static unsigned int virtscsi_get_lun(u8 *lun_bytes)
>> > +{
>> > +	unsigned int lun = (lun_bytes[2] << 8) | lun_bytes[3];
>> > +	return lun & 16383;
>> > +}
>> > +
> Why are you rolling your own incomplete version of scsilun_to_int here?

Because scsilun_to_int does not do the AND, so it would have exactly the
same bug I'm fixing.

Paolo
