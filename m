From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] USB: uas: Fix slave queue_depth not being set
Date: Tue, 24 May 2016 02:53:47 +0800
Message-ID: <CAGnHSEktpsyr7SCroHF6vnXNBWt8DibNhedWwePV2OQfgLznDw@mail.gmail.com>
References: <1464004158-3062-1-git-send-email-hdegoede@redhat.com>
	<1464025007.2331.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1464025007.2331.17.camel@HansenPartnership.com>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 24 May 2016 at 01:36, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Are you sure about this?  For spinning rust, experiments imply that the
> optimal queue depth per device is somewhere between 2 and 4.  Obviously
> that's not true for SSDs, so it depends on your use case.

Are we supposed to care about the storage behind though? If it
matters, it would still be the UAS bridge's responsibility to adjust
the number of streams accordingly (even though I don't really think
any of them will be ideal enough to actually do that anyway).

> Plus, for
> ATA NCQ devices (which I believe most UAS is bridged to) you have a
> maximum NCQ depth of 31.

So far I haven't seen any UAS/SATA bridge reports a qdepth higher than
32 (and therefore, queue_depth is at most set to 30).
