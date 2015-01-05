From: "Kenneth R. Crudup" <kenny@panix.com>
Subject: Re: Issues with commit 34b48db6 ("block: remove artifical max_hw_sectors cap")
Date: Mon, 05 Jan 2015 12:19:52 -0800
Message-ID: <9196E79D-9938-4704-AB14-523297F9019F@panix.com>
References: <Pine.LNX.4.44L0.1501051452440.1101-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1501051452440.1101-100000@iolanthe.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

I will later tonight. For now, I'm using 3.18.x (for another reason), which doesn't have this commit.

My Linus-latest tree has a "fix" that imposed a hard limit of 32767, which worked for me then.

On January 5, 2015 12:07:56 PM PST, Alan Stern <stern@rowland.harvard.edu> wrote:
>On Mon, 5 Jan 2015, Christoph Hellwig wrote:
>
>> On Tue, Dec 30, 2014 at 08:36:34AM -0800, Kenneth R. Crudup wrote:
>> > OP here. FWIW, this is what I get when running that command on the
>SCSI
>> > generic device that corresponds to the USB-3 (non-UAS) disk[1] that
>had the
>> > issue:
>> 
>> So it looks like this one actually provides sane values, but we don't
>> we never even look at EVPD pages for usb devices due to the wrong
>SCSI
>> level?
>
>According to James Bottomley, it doesn't matter much what the EVPD
>pages say.  The limitation is imposed by the USB _bridge_, whereas the
>EVPD data indicates what the _drive_ is capable of.  So we can't rely
>on that data anyway.  (Although if the EVPD data indicates a limit 
>smaller than the bridge can handle, then we'd need to pay attention to 
>it.)
>
>The patch I posted sets a general limit of 32 MB for USB drives that 
>don't have a quirk flag for a smaller limit.
>
>Kenneth, have you tried that patch?  Does it fix your problem?
>
>Alan Stern

-- 
Sent from my 2014 Galaxy Note 10.1
