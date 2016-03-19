From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] uas: Limit qdepth at the scsi-host level
Date: Sat, 19 Mar 2016 10:06:16 -0700
Message-ID: <1458407176.2288.5.camel@HansenPartnership.com>
References: <1458377952-12567-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1458377952-12567-1-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gerd Hoffmann <kraxel@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-03-19 at 09:59 +0100, Hans de Goede wrote:
> Commit 64d513ac31bd ("scsi: use host wide tags by default") causes
> the scsi-core to queue more cmnds then we can handle on devices with
> multiple LUNs, limit the qdepth at the scsi-host level instead of
> per slave to fix this.

Help me understand this bug a bit more.  Are you saying that the commit
you identify is causing the block layer to queue more commands than
you've set the per-lun limit to?  In which case we have a serious
problem for more than just UAS.  Or are you saying that UAS always had
a global command limit, but it just didn't get set correctly; however,
it mostly worked until the above commit exposed the problem?


James
