From: Doug Ledford <dledford@redhat.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 6 Jan 2003 17:10:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106221023.GB29126@redhat.com>
References: <UTC200301061918.h06JIjB21034.aeb@smtp.cwi.nl> <20030106112259.B13916@one-eyed-alien.net> <3E19EBC4.6000601@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E19EBC4.6000601@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Mon, Jan 06, 2003 at 03:49:08PM -0500, Luben Tuikov wrote:
> Matthew Dharm wrote:
> >
> >Perhaps the "best" fix here is to simply make scsi_scan.c only send 36 byte
> >inquiry requests if the bus is 'emulated'.  That would solve a world of
> >problems....
> 
> When scsi_scan.c does it's own scanning for SCSI Core, maybe it's best to
> ignore 36 < INQUIRY_DATA_LEN < 57, since this is just vendor specific
> data and SCSI Core is not interested in it.

Yes please, this is the right thing to do.  We don't care about extra data
until you get up to 57 and above (to check for DT flag and therefore find
devices that report SCSI-2 as the scsi level but which are still capable
of PPR negotiation messages and therefore Ultra160 and possibly above
speeds), so the case of returning 37 bytes available after a 36 byte
request is totally non-interesting to the scsi core.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
