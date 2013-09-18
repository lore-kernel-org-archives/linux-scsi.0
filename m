From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v3 3/6] uas: make work list per-device
Date: Wed, 18 Sep 2013 09:33:04 +0200
Message-ID: <1379489584.12907.11.camel@nilsson.home.kraxel.org>
References: <1379071635-30701-1-git-send-email-kraxel@redhat.com>
	 <1379071635-30701-4-git-send-email-kraxel@redhat.com>
	 <20130917203012.GA1752@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130917203012.GA1752@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-usb@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "open list:USB ATTACHED SCSI" <linux-scsi@vger.kernel.org>, "open list:USB MASS STORAGE..." <usb-storage@lists.one-eyed-alien.net>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Di, 2013-09-17 at 13:30 -0700, Christoph Hellwig wrote:
> On Fri, Sep 13, 2013 at 01:27:12PM +0200, Gerd Hoffmann wrote:
> > Simplifies locking, we'll protect the list with the device spin lock.
> > Also plugs races which can happen when two devices operate on the
> > global list.
> > 
> > While being at it rename the list head from "list" to "work", preparing
> > for the addition of a second list.
> 
> Why do you even the list?

The list was already there when I took over maintainance ...

> What would a ordered per-device workqueue not
> provide?

Had no reason to look into replacing the list with something else so
far.  Why do you suggest using a workqueue instead?

Note that the list is not used in a typical request workflow.  Only in
case queuing an usb urb failed the request is linked into the list and
the worker will try to submit the usb urb again.

cheers,
  Gerd
