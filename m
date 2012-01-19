From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Thu, 19 Jan 2012 12:50:33 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B9159135E1@nsmail.netscout.com>
References: <4EF2026F.2090506@redhat.com> <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com> <4F1706AD.3080405@redhat.com> <CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:60270 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932129Ab2ASRug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jan 2012 12:50:36 -0500
Content-class: urn:content-classes:message
In-Reply-To: <CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Roland Dreier
> Sent: January 18, 2012 1:46 PM
> To: Ric Wheeler
> Cc: linux-fsdevel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's
> missing?
> 
> > Why would you crash is you have device mapper multipath configured
to
> handle
> > path fail over? We have tons of enterprise customers that use
that...
> 
> cf http://www.spinics.net/lists/linux-scsi/msg56254.html
> 
> Basically hot unplug of an sdX can oops on any recent kernel, no
> matter what dm stuff you have on top.


Depends on the use-case. In the particular (SAN)use-case that I'm
talking about, 
you shouldn't unplug live sdX which is still mapped on the target(array)
side.
I've attempted to fix it somewhere and it works. If you need more info
about eh and initiator fixes, email me offline.

When would this case arise? :
a) you unknowingly unmap *hot* LUNs from target(array) while managing
the array.

End result - reset storm on front-end. You just need a smarter way to
isolate/localize this
front-end storm.


Chetan Loke
