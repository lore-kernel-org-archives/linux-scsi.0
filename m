From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Wed, 18 Jan 2012 10:46:12 -0800
Message-ID: <CAL1RGDXDaeNG_YVC38f4nxvBA+btbypcW=1KyEzm90UQOw3HiQ@mail.gmail.com>
References: <4EF2026F.2090506@redhat.com> <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
 <4F1706AD.3080405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F1706AD.3080405@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Why would you crash is you have device mapper multipath configured to handle
> path fail over? We have tons of enterprise customers that use that...

cf http://www.spinics.net/lists/linux-scsi/msg56254.html

Basically hot unplug of an sdX can oops on any recent kernel, no
matter what dm stuff you have on top.

> On the broader topic of error handling and so on, I do agree that is always
> an area of concern (how many times to retry, how long time outs need to be,
> when to panic/reboot or propagate up an error code)

Yes, especially the scsi eh stuff escalating to a host reset when
a single drive has gone bad -- even if the HBA is happily doing IO
to other drives, we'll kill access to the whole SAS fabric.

- R.
