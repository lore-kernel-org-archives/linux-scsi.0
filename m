From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
Date: Thu, 26 Jul 2012 13:21:12 +0400
Message-ID: <1343294472.3115.22.camel@dabdike>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
	  <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
	 <1343292731.3115.17.camel@dabdike> <50110820.4040403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50110820.4040403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-07-26 at 11:04 +0200, Paolo Bonzini wrote:
> Il 26/07/2012 10:52, James Bottomley ha scritto:
> >> > +static unsigned int virtscsi_get_lun(u8 *lun_bytes)
> >> > +{
> >> > +	unsigned int lun = (lun_bytes[2] << 8) | lun_bytes[3];
> >> > +	return lun & 16383;
> >> > +}
> >> > +
> > Why are you rolling your own incomplete version of scsilun_to_int here?
> 
> Because scsilun_to_int does not do the AND, so it would have exactly the
> same bug I'm fixing.

It's not a bug ... it's the encoding.  All the other devices use this
too.  Ideally we should have switched to 64 bit lun numbers for the
encoding to be exact, but nothing so far has gone over 32 bits.  If we
don't encode the Address method as part of the lun number, we don't get
the reverse transform right and the addressing often fails.

That does mean that arrays that use address method=1 in REPORT LUNS have
their lun numbers start at 16384.

James
